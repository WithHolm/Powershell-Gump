using namespace System.Drawing

function Start-PezViewColors {
    [CmdletBinding()]
    param (
        [switch]$Continous,
        [switch]$Smooth
    )
    try{
        Set-AlternativeBuffer enabled
        Set-ConsoleModes DisableCursor
        $Pez = Get-PezViewItem -AllVisible
        $script:UsedColors = [System.Collections.Generic.HashSet[string]]::new()
        $global:Animate = @{}
        do {
            Foreach ($Item in $Pez) {
                if ($Smooth) {
                    if (!$Animate.ContainsKey($Item.name)) {
                        # do {
                        # }while (! $script:UsedColors.Add($colorEnum))
                        $colorEnum = [enum]::getnames([System.Drawing.KnownColor]) | Get-Random
        
                        $Animate.Add($Item.name, @(
                            [color]::FromName($colorEnum.ToString()),
                            [color]::FromName($colorEnum.ToString())
                        ))
                        # $Animate[$Item.name] += [color]::FromName($colorEnum.ToString())
                    }
                    elseif ($Animate[$Item.name].count -eq 1) {
                        $colorEnum = [enum]::getnames([System.Drawing.KnownColor]) | Get-Random
                        $NewColor = [color]::FromName($colorEnum.ToString())
                        $OldColor = $Animate[$Item.name] | Select-Object -first 1
                        $Animate[$Item.name] = Get-ColorTransition -Start $OldColor -End $NewColor -Steps 30
                    }
    
                    $Color = $Animate[$Item.name] | Select-Object -first 1
                    $Animate[$Item.name] = $Animate[$Item.name] | Select-Object -skip 1
                }
                else {
                    do {
                        $colorEnum = [enum]::getnames([System.Drawing.KnownColor]) | Get-Random
                    }while (! $script:UsedColors.Add($colorEnum))
                    $Color = [color]::FromName($colorEnum.ToString())
                }
    
    
                $item | Set-PezRegionColor -Backgroundcolor $Color -DynamicForeground
    
                $HeightMid = [math]::floor($Item.Size.Height / 2)
                $Content = $item.Content

                Set-PezRegionContent -Name $item.Name -YAlignment middle -Content $item.name -XAlignment middle

                $item | Write-PezRegion | Out-Null
            }
            if ($Continous) {
                Start-Sleep -Milliseconds 1
            }
        }while ($Continous)
        
        
    }
    finally{
        if(!$Continous){
            [console]::SetCursorPosition(0,[console]::WindowHeight -1)
            pause
        }
        Set-ConsoleModes EnableCursor
        Set-AlternativeBuffer disabled
    }
}