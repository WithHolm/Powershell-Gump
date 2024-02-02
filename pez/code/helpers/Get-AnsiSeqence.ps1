using namespace System.Drawing
function Get-AnsiSequence {
    [CmdletBinding(
        DefaultParameterSetName = '__AllParameterSets'
    )]
    [OutputType([string])]
    param (
        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$Foreground,
        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$Background,
        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$ForegroundColor,
        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$BackGroundColor,

        [string]$FromHex,
        [ValidateSet(
            'Bold',
            'Underline',
            'Italic',
            'strikethrough',
            "Blink"
        )]
        [string[]]$Mode,
        [switch]$Reset
    )
    
    begin {

    }
    
    process {
        #return reset code
        if ($reset) {
            return "`e[0m"
        }

        $modes = @()
        if ($Foreground) {
            $ForegroundColor = [color]::FromName($Foreground.ToString())
        }
        if ($ForegroundColor) {
            $modes += "38;2;{0};{1};{2}" -f $ForegroundColor.R, $ForegroundColor.G, $ForegroundColor.B
        }
        
        if ($BackGround) {
            $BackGroundColor = [color]::FromName($Background.ToString())
        }
        if ($BackGroundColor) {
            $modes += "48;2;{0};{1};{2}" -f $BackGroundColor.R, $BackGroundColor.G, $BackGroundColor.B
        }

        switch ($Mode) {
            'Bold' {
                $modes += '1'
            }
            'Underline' {
                $modes += '4'
            }
            'Italic' {
                $modes += '3'
            }
            'strikethrough' {
                $modes += '9'
            }
            'Blink' {
                $modes += '5'
            }
        }
        # $modes = $modes|?{$_}
        # Write-debug "Modes $($modes.gettype()): $(($modes|%{"'$_'"}) -join ", ")"
        if(!$modes){
            return
        }
        return "`e[$($modes -join ";")m"
    }
    
    end {
    }
}