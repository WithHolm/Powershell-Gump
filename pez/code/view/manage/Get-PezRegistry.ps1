using namespace System.Collections.Generic
function Get-PezRegistry {
    [CmdletBinding()]
    [OutputType([Dictionary[string, ordered]])]
    param (
        [ValidateSet('View')]
        [string]$Name
    )
    
    begin {
        
    }
    
    process {
        switch($Name){
            'View' {
                return $Global:PezView
            }
        }
    }
    
    end {
        
    }
}