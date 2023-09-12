#Generate Pwsh cmdlet documentation
<#
.SYNOPSIS
Set different console modes like cursor visibility

.DESCRIPTION
Set different console modes like cursor visibility

.PARAMETER Modes
Modes to set

.EXAMPLE
Set-GumpConsoleModes -Modes EnableCursor
#>
function Set-ConsoleModes {
    param(
        [ValidateSet(
            'EnableCursor',
            'DisableCursor'
        )]
        [string[]]$Modes
    )

    switch ($Modes) {
        'EnableCursor' {
            [Console]::CursorVisible = $true
        }
        'DisableCursor' {
            [Console]::CursorVisible = $false
        }
    }
}