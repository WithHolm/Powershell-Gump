function Test-IsPezInitialized {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        $pezview = Get-PezRegistry -Name 'View'
        if ($null -eq $pezview -or $pezview.Count -eq 0) {
            throw "Pez is not initialized, or does not haven any items. please run New-PezView"
        }
    }
    
    end {
        
    }
}