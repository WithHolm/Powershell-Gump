function New-PezLogContext {
    [CmdletBinding()]
    param (
        [string]$context,
        [string]$subContext,
        [string]$command
    )
    begin {
        if(!$global:pezLog)
        {
            throw "pezLog is not initialized"
        }


        # if (!$global:logContext) {
        #     # $lc = [LogContext]::new("process")
        #     # $lc.context = "process"
        #     $global:logContext = [LogContext]::new("process")
        # }
        if ($context) {
            $global:pezLog.context = $context
        }
        if ($subContext) {
            $global:pezLog.subContext = $subContext
        }
        if($command)
        {
            $frame = (Get-PSCallStack)[1]
            if($global:pezLog.commandMap.ContainsKey($frame.Command)) {
                $global:pezLog.commandMap[$frame.Command] = $command
                return
            }
            $global:pezLog.commandMap.Add($frame.Command,$command)
        }
    }
    process {
        
    }
    end {
        # $global:logContext = $null
    }
}