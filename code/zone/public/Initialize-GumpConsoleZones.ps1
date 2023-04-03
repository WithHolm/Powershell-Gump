#init console from global:zones
function Initialize-GumpConsoleZones {
    [CmdletBinding()]
    param (
        [Switch]$Clear
    )
    if ($Global:Zones.count -eq 0) {
        Throw "No zones added. please add zones before Initializing"
    }

    #find zone that is reziable
    $resizeKey = $Global:Zones.Keys.Where{ $Global:Zones.$_.Resizable }
    if (@($resizeKey).count -gt 1) {
        throw "There is more than one rezizable zone. can only handle 1 at the moment."
    }

    #max allowed space for the console 
    $ConsoleHeight = [console]::WindowHeight - 1

    #the height of all zones combined
    $AskingHeight = ($Global:Zones.Values | Measure-Object -sum MaxHeight).Sum

    #get either asked for height or whatever is avalible in console
    $UsingHeight = [math]::Min($AskingHeight, $ConsoleHeight)

    #Height left over 
    $StaticHeight = ($Global:Zones.values | Where-Object { $_.resizable -eq $false } | Measure-Object -Sum height).sum

    #if dynamic height is set
    if ($resizeKey) {
        $zone = Get-GumpConsoleZone -Name $resizeKey
        $NewHeight = ($UsingHeight - $StaticHeight)

        #if the console is too small to fit the minimum value of the dynamic zone
        if ($NewHeight -lt $zone.MinHeight) {
            $Throw_TooSmall = $true
            $Throw_TooSmall_size = $($zone.MinHeight - $zone.Height)
        }
        else {
            $zone.Height = $NewHeight
            $zone.Resized = $true
        }
    }
    #if only static height is set and the console is too small
    elseif ($StaticHeight -gt $UsingHeight) {
        $Throw_TooSmall = $true
        $Throw_TooSmall_size = $StaticHeight - $UsingHeight
    }

    if ($Throw_TooSmall) {
        Throw "Your console is too small to fit the view i want to show you. please resize you your console and try again (missing $Throw_TooSmall_size console lines)"
    }

    if ($Clear) {
        Clear-Host
    }

    <#
    do the actual thing
    write host with empty all the lines you want, 
    get the lowest Y on the console (IE highest number (top is 0, bottom is not 0)), 
    go up through the zones (starting at highest index), divide up adding the Y range to each zone, until you get the y under where you started the script from
    1 zone1 - 2 lines
    2 zone1
    3 zone2 - 3 lines
    4 zone2
    5 zone2 <- Starte here, and go up adding 3,5 to zone.y 
    #>
    1..$UsingHeight | % {
        if ($global:Gump_debug) {
            Write-host "kk > $_"
        }
        else {
            Write-host ""
        }
    }

    $zone_keys_desc = $Global:Zones.keys[($Global:Zones.count - 1)..0]

    $currentY = [Console]::GetCursorPosition().Item2
    foreach ($ZoneName in $zone_keys_desc ) {
        #since the zone map is ordered i know that index 0 is the first item i added to zones 
        $zone = Get-GumpConsoleZone -Name $ZoneName
        $zone.Active.Clear()
        if ($zone.Height -eq 0) {
            continue
        }

        1..($zone.Height) | % {
            $y = $currentY - $_
            if ($global:Gump_debug) {
                write-GumpConsole -y $y -Text "$y - $_ $ZoneName $($zone.Height)"
            }
            $content = $zone.Content[$_ - 1]
            if($content)
            {
                write-GumpConsole -y $y -Text $content -Type $zone.StreamType
                $zone.Active.Add($content)
            }
            else{
                $zone.Content.Add("")
                $zone.Active.Add("")
            }
            # $zone.Active.Add("")
        }
        #set top of zone
        $zone.y[0] = $y

        #set bottom of zone
        $zone.y[1] = $currentY - 1


        # $zone.Content = 

        if ($global:Gump_debug) {
            write-GumpConsole -y $y -Text "$y - $($zone.Height) $ZoneName $($zone.Height) -> $($zone.y -join ",")"
        }

        $currentY = $y
    }
    #go to bottom
    [console]::SetCursorPosition(0, ($Global:Zones[$zone_keys_desc[0]].y[1] + 1 ))
}