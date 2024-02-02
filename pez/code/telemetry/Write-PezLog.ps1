function Write-PezLog {
    [CmdletBinding()]
    param (
        $message,
        [ValidateSet("info", "warning", "error", "success", "verbose","dev")]
        [string]$level = "info"
    )
    
    begin {
        $colors = @{
            info    = "Cyan"
            warning = "DarkYellow"
            error   = "Red"
            success = "Green"
            verbose = "yellow"
            dev     = 'DarkMagenta'
        }

        $levelshort = @{
            info    = "Inf"
            warning = "Wrn"
            error   = "Err"
            success = "Suc"
            verbose = "Ver"
            dev     = 'dev'
        }
    }
    process {
        $msg = $message -join ""
        # $msg = "$msg"

        $Context = @($Global:pezLog.context)
        if ($Global:pezLog.subContext) {
            $Context += "$($Global:pezLog.subContext)"
        }

        if($Global:pezLog.commandMap.Count -gt 0)
        {
            :commandsearch foreach($cmd in Get-PSCallStack)
            {
                if($Global:pezLog.commandMap.ContainsKey($cmd.Command))
                {
                    $Context += "$($Global:pezLog.commandMap[$cmd.Command])"
                    break :commandsearch
                }
            }
        }
        $msg = "[$($levelshort[$level])] $(($Context|?{$_}) -join ":") - $msg"

        if($Global:pezLog.LogPath)
        {
            $msg | Out-File -FilePath $Global:pezLog.LogPath -Append
        }
        # $ContextString = ""
        # if ($Global:logContext) {
        #     $ContextString = $Global:logContext.ToString()
        # }


        # # if verbose is set to silent and $alwayswrite isnt activated , don't write verbose messages
        # if (!$AlwaysWrite -and $level -eq "verbose" -and $VerbosePreference -eq "SilentlyContinue") {
        #     return
        # }
        # if (($Level -eq 'dev' -and $global:boltDev -ne $true) -or $global:pester_enabled) {
        #     return
        # }

        # Write-Host "[$($levelshort[$level])]$ContextString - $msg" -ForegroundColor $colors[$level]
    }
    end {}
}