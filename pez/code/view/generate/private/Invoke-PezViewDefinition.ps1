function Invoke-PezViewDefinition {
    [CmdletBinding()]
    param (
        [string]$Name,
        [scriptblock]$Definition
    )
    
    begin {
        
    }
    
    process {
        if ($Definition) {
            $defintionString = $Definition.ToString()
            $NewScriptblockString = @(
                "`$script:_pezParent = '$($name)'"
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