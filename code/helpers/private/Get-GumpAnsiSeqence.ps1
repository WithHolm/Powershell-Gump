using namespace System.Drawing
function Get-GumpAnsiSequence {
    [CmdletBinding()]
    param (
        [GumpColor]$ForegroundColor,
        [GumpColor]$BackGroundColor,
        [ValidateSet(
            'Bold',
            'Underline',
            'Italic',
            'strikethrough',
            "Blink"
        )]
        [string[]]$Mode
    )
    
    begin {
        if(!$global:SupportsAnsi){
            return ""
        }
    }
    
    process {

        #return reset code
        if (!$ForegroundColor -and !$BackGroundColor -and !$Mode) {
            return "`e[0m"
        }

        $modes = @()
        if ($ForegroundColor) {
            $color = [color]::FromName($ForegroundColor.ToString())
            $modes += "38;2;{0};{1};{2}" -f $Color.R, $Color.G, $Color.B
        }

        if ($BackGroundColor) {
            $color = [color]::FromName($BackGroundColor.ToString())
            $modes += "48;2;{0};{1};{2}" -f $Color.R, $Color.G, $Color.B
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
        return "`e[$($modes -join ";")`m"
    }
    
    end {
    }
}