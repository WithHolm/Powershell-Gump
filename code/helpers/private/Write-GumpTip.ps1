function Write-GumpTip {
    [CmdletBinding()]
    param (
        [ValidateSet(
            'Up/Down',
            'Esc',
            'Enter',
            'Space'
        )]
        [string[]]$Help,
        [int]$Y = [Console]::GetCursorPosition().Item2,
        [string]$Zone
    )
    
    begin {
        $color = @{
            Reset     = Get-GumpAnsiSequence
            UpDown    = Get-GumpAnsiSequence -ForeGroundColor DarkTurquoise
            LeftRight = Get-GumpAnsiSequence -ForeGroundColor BlueViolet
            Esc       = Get-GumpAnsiSequence -ForeGroundColor Tomato
            Enter     = Get-GumpAnsiSequence -ForeGroundColor MediumSpringGreen
            Space     = Get-GumpAnsiSequence -ForeGroundColor Coral
        }
    }
    
    process {
        $msg = @()
        switch ($help) {
            'Left/Right' { 
                $msg += "{0}Left/Right:Select " -f $color.UpDown, $color.Reset
            }
            'Up/Down' { 
                $msg += "{0}Up/Down:Select " -f $color.UpDown, $color.Reset
            }
            'Esc' { 
                $msg += "{0}Esc:Cancel " -f $color.Esc, $color.Reset
            }
            'Enter' { 
                $msg += "{0}Enter:Accept " -f $color.Enter, $color.Reset
            }
            'Space' { 
                $msg += "{0}Space:Choose " -f $color.Space, $color.Reset
            }
            Default {}
        }
        $msg += $color.Reset
        if ($Zone) {
            Set-GumpConsoleZone -Name $Zone -Content $($msg -join " ")
        }
        else {
            write-GumpConsole  -y $y -Text $($msg -join " ") -Type Host
        }
    }
    
    end {
        
    }
}