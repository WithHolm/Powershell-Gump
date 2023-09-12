using namespace System
using namespace System.Drawing
using namespace System.Collections.Generic

$Global:GumpZones = [ordered]@{}
$global:Gump_debug = $false
$global:gump_supportsAnsi = $false

Enum GumpStreamType{
    host
    verbose
    debug
    warning
    error
}



class GumpConsoleZone {
    [string]$Name
    [int]$index = $Global:GumpZones.count
    [int]$MaxHeight
    [int]$Height
    [int]$MinHeight
    [bool]$Resizable
    [GumpStreamType]$StreamType
    [int[]]$y = [int[]]::new(2)
    [List[string]]$Content = [List[string]]::new()
    [List[string]]$Active = [List[String]]::new()
}



Get-ChildItem "$PSScriptRoot\code\*.ps1" -Recurse|?{$_.BaseName -notlike '*.tests'} | ForEach-Object {
    . $_.FullName
}


$global:gump_supportsAnsi = Test-GumpAnsi