using namespace System.Drawing
function Set-PezRegionColor {
    [CmdletBinding(
        DefaultParameterSetName = 'StaticForeground'
    )]
    param (
        [parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [hashtable]$Region,

        [parameter(
            ParameterSetName = 'StaticForeground'
        )]
        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$Foreground,
        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$Background,

        [parameter(
            ParameterSetName = 'StaticForeground'
        )]
        [parameter(
            ParameterSetName = 'Conosle'
        )]
        [switch]$ConsoleForeground,
        [parameter(
            ParameterSetName = 'Conosle'
        )]
        [switch]$ConsoleBackground,

        [parameter(
            ParameterSetName = 'StaticForeground'
        )]
        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$ForegroundColor,
        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$BackgroundColor,

        [parameter(
            ParameterSetName = 'DynamicForeground'
        )]
        [parameter(
            ParameterSetName = 'Color'
        )]
        [parameter(
            ParameterSetName = 'Conosle'
        )]
        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [switch]$DynamicForeground
    )
    
    begin {
        # throw "Cmdlet is no longer supported."
    }
    
    process {
        if ($Background) {
            $Region.Color.Background = [color]::FromName($Background.ToString())
        }
        elseif ($BackgroundColor) {
            $Region.Color.Background = $BackgroundColor
        }
        elseif ($ConsoleBackground) {
            $region.Color.Background = $null
        }

        if ($PSCmdlet.ParameterSetName -eq 'DynamicForeground' -and $DynamicForeground) {

            # $Region.Color.Background.GetBrightness()
            $Light = [console]::ForegroundColor.ToString()
            $Dark = [console]::BackgroundColor.ToString()
            if ($Region.Color.Background.GetBrightness() -gt 0.5) {
                $Region.Color.Foreground = $Dark
            }
            else {
                $Region.Color.Foreground = $Light
            }
        }
        if ($Foreground) {
            $Region.Color.Foreground = [color]::FromName($Foreground.ToString())
        }
        elseif ($ForegroundColor) {
            $Region.Color.Foreground = $ForegroundColor
        }

    }
    
    end {
        
    }
}