#export:core
using namespace System.Collections.Generic
using namespace System.Drawing
function New-PezView {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory
        )]
        [string]$Name,
        [string]$Parent = $script:_pezParent,
        [bool]$Visible = $true,
        [ValidateSet('cell', 'percent')]
        [string]$Measurement = 'cell',
        [string]$Size,
        #Can only be set once per scope
        [ValidateSet('down', 'across', 'auto')]
        [string]$Direction = 'auto',
        [scriptblock]$Definition,
        [switch]$Root
    )
    
    begin {
        Write-Verbose "[$name] starting"
        $Measurement = $Size -like "*%" ? 'percent' : $Measurement
        [int]$_size = $Size -like "*%" ? [int]$Size.TrimEnd('%') : [int]$Size

        $dirsplit = [System.IO.Path]::DirectorySeparatorChar
        if ($name -eq 'root') {
            throw "'root' is a reserved name"
        }
        
        if ($Global:PezView -eq $null -or $Root) {
            Write-Verbose "[$name] initializing root" 
            # $init = $true
            $parent = "root"
            $Global:PezView = [Dictionary[string, ordered]]::new()
            $rootItem = [ordered]@{
                Name = $parent
                #name of the view
                Path      = $parent
                Parent    = ""
                #id of the view
                Id        = 0
                #is the view visible
                Visible   = $false
                #should the view be rendered. set to true if new content is added (when rendered, this is set to false)
                Rendered  = $false
                #direction of the view. x = horizontal, y = vertical
                Direction = 'down'
                #start coords of the view. x = width, y = height
                Location  = [Point]::new(0, 0)
                #size of the view. x = width, y = height
                Size      = [Size]::new(
                    ([Console]::WindowWidth - 2), 
                    ([Console]::WindowHeight - 1)
                )
                Canvas = [System.Drawing.Rectangle]::new(0, 0, ([Console]::WindowWidth - 2), ([Console]::WindowHeight - 1))
            }

            # $rootItem = $rootItem | Add-PezViewScripts
            $Global:PezView.Add($parent, $rootItem )
            Add-PezViewScripts -Name $parent
        }
        
    }
    
    process {
        if (!$Global:PezView.ContainsKey($parent)) {
            throw "Parent '$parent' does not exist"
        }

        if ($Global:PezView.ContainsKey($name)) {
            throw "View '$name' already exists"
        }

        $parentInfo = $Global:PezView[$parent]

        $Siblings = $Global:PezView.Values | Where-Object { $_.Parent -eq $Parent }

        Write-Verbose "[$name] parent: '$parent', siblings: $($Siblings.name -join ",")"
        if($Direction -eq 'auto'){
            #check direction of siblings
            #else get from parent
            if($Siblings.count -gt 0){
                $siblingName = $Siblings.Name|Select-Object -first 1
                $_direction = $Global:PezView.$siblingName.Direction
                Write-Verbose "[$name] grabbing direction '$_direction' from sibling '$siblingName'"
                $Direction = $_direction
            }else{
                $_direction = $parentInfo.Direction
                Write-Verbose "[$name] grabbing direction '$($_direction)' from parent '$($parentInfo.Name)'"
                $Direction = $_direction
            }
            if($Direction -eq 'auto'){
                throw "View $name failed to grab direction from parent or siblings"
            }
        }

        #check if other children have the same direction, throw if not
        if ($null -ne $Siblings) {
            $OtherDirectionSiblings = $Siblings | Where-Object { $_.direction -ne $Direction } 
            if ($null -ne $OtherDirectionSiblings) {
                throw "View '$name' is asking for direction '$Direction' but siblings $($OtherDirectionSiblings.name -join ",") has defined direction '$($OtherDirectionSiblings[0].direction)'"
            }
        }

        $item = [ordered]@{
            Name      = $name
            Path      = (@($parentInfo.path, $Name) | Where-Object { $_ }) -join $dirsplit
            Parent    = $parent
            Id        = $Global:PezView.Count
            Rendered  = $false
            Direction = $Direction
            #static
            Location  = [Point]$parentInfo.Location
            #static
            Size      = [Size]$parentInfo.Size
            
            #dynamically found out. figure out self when initiated. when childrens get added, update parents canvas
            Canvas    = [System.Drawing.Rectangle]::new($parentInfo.Location, $parentInfo.Size)
            Content   = @()
        }
        
        #figure out size
        $AvailableCells = switch ($Direction) {
            'down' { $parentInfo.Size.Height }
            'across' { $parentInfo.Size.Width }
        }
        
        Write-Verbose "[$name] direction: $Direction, Available cells from parent: $AvailableCells"

        #if there are siblings,
        if ($Siblings.count -gt 0) {
            Write-Verbose "[$name] Siblings: $($Siblings.name -join ",")"

            #check if other children have the same direction, throw if not
            $OtherDirectionSiblings = $Siblings | Where-Object { $_.direction -ne $Direction } 
            if ($null -ne $OtherDirectionSiblings) {
                throw "siblings_needs_same_direction : View '$name' is asking for direction '$Direction' but sibling-views ($($OtherDirectionSiblings.name -join ",")) already have direction '$($OtherDirectionSiblings[0].direction)'"
            }

            #set start from the x or y of the sibling with the highest id (last to be calculated)
            $LatestSibling = $Siblings | Select-Object -Last 1
            Write-Verbose "[$name] Latest sibling: $($LatestSibling.path)"
            #set start of this view to the end of the latest sibling
            # $LocationVal = $Direction -eq 'across'? 'x': 'y'
            switch ($Direction) {
                'down' { $item.Location.y = $LatestSibling.Location.Y + $LatestSibling.size.Height }
                'across' { $item.Location.x = $LatestSibling.Location.X + $LatestSibling.size.Width }
            }

            #subtract their size from the available cells
            $AvailableCells -= switch ($Direction) {
                'down' { $Siblings.size | Measure-Object -Property Height -Sum | Select-Object -ExpandProperty Sum }
                'across' { $Siblings.size | Measure-Object -Property Width -Sum | Select-Object -ExpandProperty Sum }
            }
            Write-Verbose "[$name] Available cells after siblings: $AvailableCells"
        }
        # Write-Verbose "AvailableCells: $AvailableCells"

        # if measurement is cell, then height and width are in cells
        switch ($Measurement) {
            'Cell' {
                #only check the direction that is being set
                if ($AvailableCells -lt $_size) {
                    $msg = @(
                        "View '$name' is asking for too many cells ($_size). parent '$parent' ",
                        ($Siblings.count -lt 0 ? "and $($Siblings.count) siblings " : ""),
                        "can maximum give it $AvailableCells cells."
                    ) -join ''
                    throw $msg
                }
                switch ($Direction) {
                    'down' { $item.size.Height = $_size }
                    'across' { $item.size.Width = $_size }
                }
                # $item.size[$DirectionToCheck] = $_size   #$Direction -eq 'x'? @($Size, $parentInfo.size[1]) : @($parentInfo.size[0], $Size)
            }
            'Percent' {
                #i dont really care if you ask for 60% 2 times.. if you do, you get 60% first time then 40% second time
                $parentsize = switch ($Direction) {
                    'down' { $parentInfo.size.Height }
                    'across' { $parentInfo.size.Width }
                }
                $SizeInCells = [math]::Round($parentsize * ($_size / 100), 0)
                $UsingSize = [math]::Min($SizeInCells, $AvailableCells)
                switch ($Direction) {
                    'down' { $item.size.Height = $UsingSize }
                    'across' { $item.size.Width = $UsingSize }
                }
            }
        }
        $item.canvas = [System.Drawing.Rectangle]::new($item.Location, $item.Size)

        # Write-Verbose "is parent '$parent' null? $($Global:PezView[$parent].canvas -eq $null)"
        # Write-Verbose "is item canvas null?: $($item.canvas -eq $null)"
        #remove the size of this view from the canvas of the parent
        $Global:PezView[$parent].RemoveFromCanvas($item.Canvas,$item.direction)
        
        $Global:PezView[$name] = $item
        Add-PezViewScripts -Name $name
        
        if ($Definition) {
            $defintionString = $Definition.ToString()
            $NewScriptblockString = @(
                "`$script:_pezParent = '$($name)'"
                "`$verbosePreference = '$verbosePreference'"
                "`$debugPreference = '$debugPreference'"
                $defintionString
            ) -join [System.Environment]::NewLine

            $NewScriptblock = [scriptblock]::Create($NewScriptblockString)

            try {
                $NewScriptblock.Invoke()
            }
            catch {
                throw $_.Exception.InnerException.ErrorRecord
            }
        }
        $script:_pezParent = $parent
    }
    
    end {
        
    }
}

# New-PezView -Name 'test' -Root -Size 100 -Direction across -Definition {
#     New-PezView -name 'other' -Size 40%
#     New-PezView -name 'other2' -Size 40%
#     New-PezView -name 'other3' -Size 30%
# } -Verbose
# $Global:PezView.Values | % { "---"; $_ }
# $Global:PezView