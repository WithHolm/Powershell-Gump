<#
.SYNOPSIS
Gets a zone from the global gump zone list

.DESCRIPTION
Gets a zone from the global gump zone list. 

.PARAMETER Name
Name of zone

.PARAMETER ThrowIfNull
if enabled, if the zone is not found, throw an error

.PARAMETER All
if enabled, return all zones
#>
function Get-GumpConsoleZone {
    [CmdletBinding()]
    [Outputtype('GumpConsoleZone')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName = 'One'
        )]
        [string]$Name,
        [parameter(
            ParameterSetName = 'One'
        )]
        [switch]$ThrowIfNull,
        [parameter(
            ParameterSetName = 'Many'
        )]
        [switch]$All
    )

    #many
    if($PSCmdlet.ParameterSetName -eq 'Many') {
        return $Global:GumpZones.Values
    }

    #one
    if ($ThrowIfNull -and !$Global:GumpZones.Contains($name)) {
        throw "Could not find zone with name '$name'"
    }
    return $Global:GumpZones.$name
}