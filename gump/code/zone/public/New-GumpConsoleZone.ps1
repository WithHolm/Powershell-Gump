using namespace System.Collections.Generic

#add zones to console


function New-GumpConsoleZone {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$Name,
        [parameter(Mandatory)]
        [int]$Height,
        [int]$MinHeight = 0,
        [switch]$Resizable,
        [GumpStreamType]$StreamType = 'host',
        [switch]$Init
    )
    if ($Init) {
        $Global:GumpZones = [ordered]@{}
    }

    if ($Global:GumpZones.Contains($Name)) {
        throw "Zone with name '$Name' already exists"
    }

    if($Resizable -and $MinHeight -eq 0) {
        throw "Cannot create a resizable zone with a minimum height of 0"
    }

    $Global:GumpZones.$Name = [GumpConsoleZone]@{
        Name       = $Name
        index      = $Global:GumpZones.count
        MaxHeight  = $Height
        Height     = $Height
        MinHeight  = $MinHeight
        Resizable  = $Resizable
        Resized    = $false
        StreamType = $StreamType
        y          = ([int[]]::new(2))
        Content    = ([List[string]]::new())
        Active     = ([List[String]]::new())
    }
    
    if ($Resizable) {
        $Global:GumpZones.$Name.Height = 0
    }
}