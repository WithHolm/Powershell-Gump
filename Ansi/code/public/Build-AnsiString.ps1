function Build-Ansi {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory,
            Position = 0
        )]
        [scriptblock]$definition,
        [switch]$IgnoreAnsiCheck
    )
    
    begin {
        $script:_ansiReturn = @{
            Color = @()
            console = @()
        }
    }
    
    process {
        if ($Definition) {
            $defintionString = $Definition.ToString()
            $NewScriptblockString = @(
                "`$script:_ansiBuild = `$true"
                "`$verbosePreference = '$verbosePreference'"
                "`$debugPreference = '$debugPreference'"
                $defintionString
            ) -join [System.Environment]::NewLine

            $NewScriptblock = [scriptblock]::Create($NewScriptblockString)

            try {
                $NewScriptblock.Invoke()
            }
            catch {
                throw $_.Exception.InnerException.ErrorRecord
            }
        }
    }
    
    end {
        
    }
}