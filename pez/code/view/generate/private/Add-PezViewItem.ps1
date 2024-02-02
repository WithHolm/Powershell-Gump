using namespace System.Collections.Generic
using namespace System.Drawing
function Add-PezViewItem {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$Name,
        
        # [parameter(Mandatory)]
        [string]$Parent,

        [bool]$Visible = $true,

        [ValidateSet('down', 'across')]
        [string]$Direction = 'down',

        [ValidateNotNullOrEmpty()]
        [point]$Location,

        [ValidateNotNullOrEmpty()]
        [Size]$Size,

        [int]$InitSize,

        [validateset('cell', 'percent')]
        [string]$Measurement = 'cell'
    )
    
    if ($null -eq $Global:PezView) {
        throw "Pez is not initialized, please set up and run New-PezView"
    }

    $SizeProperty = $Direction -eq 'down' ? 'Height' : 'Width'

    #only really hit by root
    if ($Global:PezView.count -eq 0 -and $name -eq 'root') {
        $ParentPath = ""
        $InitSize = $size.$SizeProperty
    }
    elseif ([string]::IsNullOrEmpty($Parent)) {
        throw "Parent is not defined for '$name'. please define this"
    }
    elseif ($Global:PezView.ContainsKey($parent) -eq $false) {
        throw "Parent '$parent' does not exist"
    }
    else {
        #if its a normal item..
        $ParentItem = $Global:PezView[$Parent]
        $ParentPath = $ParentItem.Path
        if(!$InitSize)
        {
            $InitSize = $size.$SizeProperty
            if($Measurement -eq 'percent'){
                $InitSize = [int]($ParentItem.size.$SizeProperty * ($size.$SizeProperty / 100))
            }
        }
    }
    $item = [ordered]@{
        Name        = $Name
        #name of the view
        Path        = @($ParentPath,$name) -join "/"
        Parent      = $Parent
        #id of the view
        Id          = $Global:PezView.Count
        #is the view visible
        Visible     = $Visible
        #should the view be rendered. set to true if new content is added (when rendered, this is set to false)
        Rendered    = $false
        Color = @{
            #look up color info from shared color scheme
            Theme = ""
            ForegroundInverse = $false
            ContentHasAnsi = $false
            Foreground = [color]::FromName([console]::ForegroundColor)
            Background = [color]::FromName([console]::BackgroundColor)
        }
        Content     = [string[]]::new($Size.Height)
        OutContent     = [string[]]::new($Size.Height)
        #measurement type. cell = number of cells, percent = percentage of parent
        Measurement = $Measurement
        InitSize    = $InitSize
        #direction of the view. x = horizontal, y = vertical
        Direction   = $Direction
        #start coords of the view. x = width, y = height
        Location    = $Location
        #size of the view. x = width, y = height
        Size        = $Size
        #canvas of the view. this is resized as child items are added.
        #its the actual size of the area (childitems remove from this canvas)
        Canvas      = [System.Drawing.Rectangle]::new($Location, $Size)
    }

    if($item.id -eq 0){
        $typeName= "PezViewItem"
        $item.Keys | ForEach-Object {
            $val = $item[$_]
            $init = switch($val.GetType())
            {
                ([string]){
                    ""
                }
                ([int]){
                    0
                }
                ([size]){
                    [size]::Empty
                }
                ([point]){
                    [point]::Empty
                }
                ([System.Drawing.Rectangle]){
                    [System.Drawing.Rectangle]::Empty
                }
                ([bool]){
                    $false
                }
            }
            Update-TypeData -MemberType NoteProperty -MemberName $_ -TypeName $typeName -Force -Value $init
        }
    }

    #remove current canvas from parents canvas
    if($parent)
    {
        Resize-PezViewCanvas -Name $Parent -Subtract $item.Canvas -SubtractDirection $Direction 
    }

    $Global:PezView.Add($name, $item)
}