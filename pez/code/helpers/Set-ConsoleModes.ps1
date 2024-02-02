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
            'DisableCursor',
            'SetConsoleEncoding-utf8',
            'RevertConsoleEncoding'
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
        'SetConsoleEncoding-utf8' {
            $global:_ConsoleOutputEncoding = [Console]::OutputEncoding
            [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        }
        'RevertConsoleEncoding' {
            [Console]::OutputEncoding = $global:_ConsoleOutputEncoding
        }
    }
}