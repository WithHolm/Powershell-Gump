function Set-AlternativeBuffer{
    [CmdletBinding()]
    param (
        [ValidateSet(
            'enabled',
            'disabled'
        )]
        $state = 'enabled'
    )
    
    switch ($state) {
        'enabled' {
            [console]::Write("`e[?1049h")
        }
        'disabled' {
            [console]::Write("`e[?1049l")
        }
    }
    # [console]::Write("`e[?1049l")Set-AlternativeBuffer
}