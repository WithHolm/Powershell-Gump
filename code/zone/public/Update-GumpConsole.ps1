function Update-GumpConsole {
    [CmdletBinding()]
    param ()
    
    foreach ($Name in $Global:Zones.Keys) {
        $Zone = Get-GumpConsoleZone -Name $Name
    
        for ($i = 0; $i -lt $zone.Content.Count; $i++) {
            $Content = $zone.Content[$i]

            if (![string]::Equals($Content, $zone.Active[$i])) {
                write-GumpConsole -y ($zone.y[0] + $i) -Text $Content -Type $zone.StreamType
                $zone.Active[$i] = $Content
            }
        }
    }
}