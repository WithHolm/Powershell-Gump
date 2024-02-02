function Add-PezRegion {
    [CmdletBinding(
        DefaultParameterSetName = "__AllParameterSets"
    )]
    param (
        [parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Name,
        [string]$Parent = $script:_pezParent,
        [ValidateSet('cell', 'percent')]
        [string]$Measurement = 'cell',
        [parameter(
            Mandatory,
            Position = 1
        )]
        [string]$Size,
        #Can only be set once per scope
        [parameter(
            ParameterSetName = 'Down'
        )]
        [switch]$Down,
        [parameter(
            ParameterSetName = 'Across'
        )]
        [switch]$Across,

        [bool]$Visible = $true,
        # [ValidateSet('down', 'across', 'auto')]
        # [string]$Direction = 'auto',
        [parameter(
            Position = 2
        )]
        [scriptblock]$Definition
    )
    
    begin {  
        Write-Verbose "[$name] starting"

        #throw if not initialized
        Test-IsPezInitialized

        #root is always first item
        $RootName = (Get-PezRoot).Name
        if ($name -eq $RootName) {
            throw "'$RootName' is a reserved name"
        
        }

        if (!$Global:PezView.ContainsKey($parent)) {
            throw "Parent '$parent' does not exist"
        }
    
        if ($Global:PezView.ContainsKey($name)) {
            throw "View '$name' already exists"
        }
    }
    
    process {

        $ParentObj = Get-PezViewItem -Name $Parent

        #if precent, convert to cells

        $Siblings = $ParentObj|Get-PezViewChildren
        # Write-verbose "[$name] $($Global:PezView.count)"
        Write-Verbose "[$name] parent: '$parent', siblings: $($Siblings.name -join ",")"

        #Get Direction from switch
        $Direction = switch ($true) {
            ($Down -eq $true) { 'down' }
            ($Across -eq $true) { 'across' }
            default { 'auto' }
        }
        #vaildate or get from siblings
        $Direction = $Direction|Get-PezViewDirection -Parent $Parent -Name $Name
        
        $RegionLocation = [Point]$ParentObj.Location
        $RegionSize = [Size]$ParentObj.Size

        #convert size% to size and measurement
        if($Size -like '*%'){
            $Measurement = 'Percent'
        }
        $_Size = [int]($Size -replace '%')
        $size = "$_Size"

        #figure out size
        $AvailableCells = switch ($Direction) {
            'down' { $ParentObj.Size.Height }
            'across' { $ParentObj.Size.Width }
        }
        
        Write-Verbose "[$name] direction: $Direction, Available cells from parent: $AvailableCells, asking for $Measurement`:$Size"

        #if there are siblings,
        if ($Siblings.count -gt 0) {
            # Write-Verbose "[$name] Siblings: $($Siblings.name -join ",")"

            #check if other children have the same direction, throw if not
            $OtherDirectionSiblings = $Siblings | Where-Object { $_.direction -ne $Direction } 
            if ($null -ne $OtherDirectionSiblings) {
                throw "siblings_needs_same_direction : View '$name' is asking for direction '$Direction' but sibling-views ($($OtherDirectionSiblings.name -join ",")) already have direction '$($OtherDirectionSiblings[0].direction)'"
            }

            #set start from the x or y of the sibling with the highest id (last to be calculated)
            $LatestSibling = $Siblings | Select-Object -Last 1
            Write-Verbose "[$name] Latest sibling: $($LatestSibling.path)"
            #set start of this view to the end of the latest sibling
            # $RegionLocationVal = $Direction -eq 'across'? 'x': 'y'
            switch ($Direction) {
                'down' { $RegionLocation.y = $LatestSibling.Location.Y + $LatestSibling.size.Height }
                'across' { $RegionLocation.x = $LatestSibling.Location.X + $LatestSibling.size.Width }
            }

            #subtract their size from the available cells
            $s = @($Siblings)
            switch ($Direction) {
                'down' { 
                    for ($y = 0; $y -lt $s.Count; $y++) {
                        Write-Verbose "[$name] Sibling: $($s[$y].path), height: $($s[$y].Canvas.Height)"
                        $AvailableCells -= $s[$y].Canvas.Height
                    }
                }
                'across' { 
                    # $s = @($Siblings)
                    for ($y = 0; $y -lt $s.Count; $y++) {
                        Write-Verbose "[$name] Sibling: $($s[$y].path), width: $($s[$y].Canvas.Width)"
                        $AvailableCells -= $s[$y].Canvas.Width
                    }
                }
            }
            Write-Verbose "[$name] Available cells after siblings: $AvailableCells"
        }
        # Write-Verbose "AvailableCells: $AvailableCells"

        #
        # if($Size -like '%'){
        #     $Measurement = 'Percent'
        # }
        # $_Size = [int]($Size -replace '%')
        # $size = "$_Size"
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
                    'down' { $RegionSize.Height = $_size }
                    'across' { $RegionSize.Width = $_size }
                }
                # $item.size[$DirectionToCheck] = $_size   #$Direction -eq 'x'? @($Size, $ParentObj.size[1]) : @($ParentObj.size[0], $Size)
            }
            'Percent' {
                #i dont really care if you ask for 60% 2 times.. if you do, you get 60% first time then 40% second time
                $parentsize = switch ($Direction) {
                    'down' { $ParentObj.size.Height }
                    'across' { $ParentObj.size.Width }
                }
                $SizeInCells = [math]::Round($parentsize * ($_size / 100), 0)
                $UsingSize = [math]::Min($SizeInCells, $AvailableCells)
                switch ($Direction) {
                    'down' { $RegionSize.Height = $UsingSize }
                    'across' { $RegionSize.Width = $UsingSize }
                }
            }
        }
        Add-PezViewItem -Name $name -Parent $Parent -Direction $Direction -Location $RegionLocation -Size $RegionSize -InitSize $Size -Visible $Visible  #-Direction $Direction -Visible $true -Measurement $Measurement -Definition $Definition        
        $CurrentPezParent = $script:_pezParent
        Invoke-PezViewDefinition -Name $name -Definition $Definition
        $script:_pezParent = $CurrentPezParent
    }
    
    end {
        
    }
}