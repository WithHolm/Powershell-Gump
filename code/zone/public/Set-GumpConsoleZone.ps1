<#
.SYNOPSIS


.DESCRIPTION
Long description

.PARAMETER Name
Parameter description

.PARAMETER Content
Parameter description

.PARAMETER StartIndex
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-GumpConsoleZone {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string[]]$Content,
        [int]$StartIndex = 0,
        [switch]$Clean
    )
    
    begin {
        $Zone = Get-GumpConsoleZone -Name $Name -ThrowIfNull
    }
    process {
        if ($Clean) {
            $Zone.Content = [List[string]]::new($zone.Content.Count)
            return 
        }

        0..($content.Count - 1) | % {
            $zoneContentIndex = $_ + $StartIndex
            $zone.Content[$zoneContentIndex] = $Content[$_]
        }
    }
}