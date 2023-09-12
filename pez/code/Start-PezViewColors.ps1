using namespace System.Drawing

function Start-PezViewColors {
    [CmdletBinding()]
    param ()
    $script:PezViewColors = @()
    Foreach($It in $Global:PezView.GetEnumerator()){
        $key = $it.key
        $item = $it.value
        if($item.visible -eq $false){
            continue
        }
        do{
            $colorEnum = [enum]::getnames([System.Drawing.KnownColor])|Get-Random
        }while($colorEnum -in $script:PezViewColors)
        $script:PezViewColors += $colorEnum
        $color = [color]::FromName($colorEnum.ToString())
        $mode = "`e[38;2;{0};{1};{2}m" -f $Color.R, $Color.G, $Color.B

        $item.content = [string[]]::new($item.canvas.height)
        for ($i = 0; $i -lt $item.canvas.height; $i++) {
            $item.content[$i] = $mode + ("█"*$item.canvas.width)
        }

        #render..
        for ($i = 0; $i -lt $item.content.Count; $i++) {
            [console]::SetCursorPosition($item.canvas.x, $item.canvas.y + $i)
            [console]::Write($item.content[$i])
        }
    }
    [console]::SetCursorPosition($Global:PezView.pause.canvas.x, $Global:PezView.pause.canvas.y)
    Write-host "`e[0m"
    pause
    # for ($i = 0; $i -lt $Global:PezView.root.Size.Height; $i++) {
    #     [console]::SetCursorPosition($i,0)
    #     Write-host "`e[0m"
    # }
    # cls
}



# while($true){
#     Start-PezViewColors
#     Start-Sleep -Milliseconds 100
# }