function Invoke-GumpColorMap {
    [CmdletBinding()]
    param(
        $Style
    )
    $AllColors = [enum]::GetNames([GumpColor]) 
    $Stats = $AllColors | Measure-Object -Property length -AllStats
    $Screenwidth = [Console]::WindowWidth
    $RowCellCount = [math]::Round($Screenwidth / $Stats.Maximum, [System.MidpointRounding]::ToZero)

    $AllColorMatrix = [ordered]@{}
    $index = 0
    do {
        $upper = $index + ($RowCellCount - 1)
        $Colors = $AllColors[$index..$upper]
        $AllColorMatrix.$($AllColorMatrix.count) = $Colors
        $index = $upper + 1
    }while ($Colors.Count -eq $RowCellCount) 
    # $AllColorMatrix.values | % { $_.count }
    $reset = Get-GumpAnsiSequence

    New-GumpConsoleZone -name 'header' -Height 1 -Init
    New-GumpConsoleZone -name 'verbose' -Height 1
    $AllColorMatrix.Keys | ForEach-Object {
        $key = $_
        New-GumpConsoleZone -Name "$key-fc" -Height 1
        New-GumpConsoleZone -Name "$key-bc" -Height 1
    }

    Initialize-GumpConsoleZones -Clear

    $AllColorMatrix.Keys | ForEach-Object {
        $key = $_
        $fc_content = ($AllColorMatrix.$key | ForEach-Object {
                $col = $_
                $Ansi = Get-GumpAnsiSequence -ForegroundColor $col
                $str = Set-StringPad -String "$col" -Length $Stats.Maximum -PadType 'middle'
                $Ansi + $str
            }
        ) -join ''

        $bc_content = ($AllColorMatrix.$key  | ForEach-Object {
                $col = $_
                $Ansi = Get-GumpAnsiSequence -BackGroundColor $col
                $color = [System.Drawing.Color]::FromName($col.ToString())
                $content = "48;2;{0};{1};{2}" -f $Color.R, $Color.G, $Color.B
                $str = Set-StringPad -String "$content" -Length $Stats.Maximum -PadType 'middle'
                $Ansi + $str
            }
        ) -join ''
        Set-GumpConsoleZone -Name "$key-fc" -content "$fc_content$reset"
        Set-GumpConsoleZone -Name "$key-bc" -content "$bc_content$reset"
    }
    Update-GumpConsole
}

# Invoke-GumpColorMap