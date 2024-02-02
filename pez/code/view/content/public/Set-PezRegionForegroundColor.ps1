using namespace System.Drawing
using namespace System
function Set-PezRegionForegroundColor {
    [CmdletBinding(
        DefaultParameterSetName = 'KnownColor'
    )]
    param (
        [parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [hashtable]$Region,

        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$KnownColor,

        [parameter(
            ParameterSetName = 'Conosle'
        )]
        [switch]$ConsoleColor,

        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$Color,

        [parameter(
            ParameterSetName = 'Inverse'
        )]
        [switch]$Inverse
    )
    
    begin {
        
    }
    
    process {
        $UsingRegion = get-pezViewItem -Name $Region.Name
        $UsingRegion.Color.ForegroundInverse = $false
        $UsingRegion.Color.ContentHasAnsi = $false
        if($Inverse)
        {
            $UsingRegion.Color.ForegroundInverse = $true
            $Light = [console]::ForegroundColor.ToString()
            $Dark = [console]::BackgroundColor.ToString()
            if ($UsingRegion.Color.Background.GetBrightness() -gt 0.5) {
                $UsingRegion.Color.Foreground = $Dark
            }
            else {
                $UsingRegion.Color.Foreground = $Light
            }
        }


        if ($KnownColor) {
            $UsingRegion.Color.Foreground = [color]::FromName($KnownColor.ToString())
        }

        if ($ConsoleColor) {
            $UsingRegion.Color.Foreground = [color]::FromName([Console]::ForegroundColor.ToString())
        }

        if ($Color) {
            $UsingRegion.Color.Foreground = $Color
        }
    }
    end {}
}