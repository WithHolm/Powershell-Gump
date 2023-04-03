function write-GumpConsole {
    [CmdletBinding()]
    param (
        [int]$y,
        [string]$Text,
        [GumpStreamType]$Type = [GumpStreamType]::host
    )
    
    [console]::SetCursorPosition(0, $y)
    #add message to erase rest of line
    $text += "`e[0K"
    switch ($Type.tostring()) {
        'host' { Write-host $Text }
        'verbose' { Write-Verbose $Text }
        'debug' { Write-Debug $Text }
        'warning' { Write-Warning $Text }
        'error' { Write-error -Message $Text }
        Default {}
    }
}