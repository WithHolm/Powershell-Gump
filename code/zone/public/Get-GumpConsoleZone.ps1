function Get-GumpConsoleZone {
    [CmdletBinding()]
    [Outputtype('GumpConsoleZone')]
    param(
        [parameter(Mandatory)]
        [string]$Name,

        [switch]$ThrowIfNull
    )
    if ($ThrowIfNull -and !$Global:Zones.Contains($name)) {
        throw "Could not find zone with name '$name'"
    }
    return $Global:Zones.$name
}