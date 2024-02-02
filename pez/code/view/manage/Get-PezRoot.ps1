function Get-PezRoot {
    [CmdletBinding()]
    [OutputType('PezViewItem')]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        (Get-PezViewItem -All)|select -first 1
    }
    
    end {
        
    }
}