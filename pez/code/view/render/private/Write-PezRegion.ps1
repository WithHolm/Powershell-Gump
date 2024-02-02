function Write-PezRegion {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory,
            ParameterSetName = 'Name'
        )]
        [string]$Name,

        [parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'PezViewItem'
        )]
        [hashtable]$Region,
        [parameter(                       
            ParameterSetName = 'All'
        )]
        [switch]$All
    )
    
    begin {
        New-PezLogContext -command 'Write-PezRegion'
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $Region = Get-PezViewItem -Name $Name
        }
    }
    
    process {
        if ($All) {
            get-pezViewItem -AllVisible | Write-PezRegion
        }
        else {
            $reset = Get-AnsiSequence -Reset
            # $Region.OutContent = $Region.Content
            if ($Region.Rendered -eq $false) {
                [console]::SetCursorPosition($Region.Canvas.y, $Region.Canvas.y)
                for ($i = 0; $i -lt $Region.Content.Count; $i++) {
                    $x = $Region.Canvas.x
                    #force x to be 0 or bigger
                    $x = [math]::Max($x, 0)
                    #force x to be less than the console width
                    $x = [math]::Min($x, $Host.UI.RawUI.WindowSize.Width - 1)

                    $y = $Region.Canvas.y + $i
                    #force y to be 0 or bigger
                    $y = [math]::Max($y, 0)
                    #force y to be less than the console height
                    $y = [math]::Min($y, $Host.UI.RawUI.WindowSize.Height - 1)

                    $global:param = @{}

                    if ($Region.Color.ForegroundInverse) {
                        $Light = [console]::ForegroundColor.ToString()
                        $Dark = [console]::BackgroundColor.ToString()
                        if ($Region.Color.Background.GetBrightness() -gt 0.5) {
                            $Region.Color.Foreground = $Dark
                        }
                        else {
                            $Region.Color.Foreground = $Light
                        }
                    }

                    if ($Region.Color.Foreground.Name -ne [console]::ForegroundColor.tostring()) {
                        $param['ForegroundColor'] = $Region.Color.Foreground
                    }

                    if ($Region.Color.Background -ne [console]::BackgroundColor.tostring()) {
                        $param['BackgroundColor'] = $Region.Color.Background
                    }
                    # Write-Verbose "$ansi"
                    try {
                        $Ansi = Get-AnsiSequence @param 

                        $out = ($reset + $Ansi + $Region.Content[$i] + $reset)
                        if ($Region.OutContent[$i] -ne $out) {
                            $Region.OutContent[$i] = $out
                            $setPos = "`e[$y;$($x + 1)`H"
                            # [console]::SetCursorPosition($x, $y)
                            # $setPos = ""
                            $EraseCursor = "`e[?25l"
                            Write-PezLog -message "Writing '$($Region.Name)' to console, column:$($x + 1), line:$y`: $($Region.Content[$i])"
                            [console]::Write($setPos + $EraseCursor + $out)
                            # Start-Sleep -Seconds 1
                        }
                    }
                    catch {
                        throw "'$($region.Name)' line: $i : Failed to write to console (column:$($x + 1), line:$y): $_"
                        
                    }
                }
                $region.Rendered = $true
            }
        }
    }
    
    end {
        
    }
}
