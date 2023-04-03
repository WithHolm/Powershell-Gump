<#
.SYNOPSIS
Used to confirm if a keypress is what you expect it to be

.DESCRIPTION
Used to confirm if a keypress is what you expect it to be. 
For example, if you want to confirm that the keypress is a letter, then you can use this function to confirm that.

.PARAMETER Keys
Keys to compare with the keypress

.PARAMETER Keypress
The Keypress to Confirm

.EXAMPLE
#Confirm that the keypress is a letter
$keypress = Read-Host
if (Confirm-GumpConsoleKey -Keys 'a-z' -Keypress $keypress) {
    Write-Host "You pressed a letter"
}
.EXAMPLE
$keypress = Read-Host
switch ($KeyPress) {
    { Confirm-GumpConsoleKey -Keypress $_ -Keys a-z, '*' } {
        Write-Host "You pressed a letter or *"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'backspace' } {
        Write-Host "You pressed backspace"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'upArrow' } {
        Write-Host "You pressed up arrow"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'downArrow' } {
        Write-Host "You pressed down arrow"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'enter' } {
        Write-Host "You pressed enter"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'escape' } {
        Write-Host "You pressed escape"
    }
    { Confirm-GumpConsoleKey -Keypress $_ -Keys 'spacebar' } {
        Write-Host "You pressed spacebar"
    }
}

.NOTES
General notes
#>
function Confirm-GumpConsoleKey {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [ValidateSet(
            'a-z',
            'æ-å',
            '*',
            'backspace',
            'upArrow',
            'downArrow',
            'enter',
            'escape',
            'spacebar'
        )]
        [string[]]$Keys,
        [ConsoleKeyInfo]$Keypress
    )

    $test = $false
    switch ($Keys) {
        { $test -eq $true } {
            break
        }
        'a-z' {
            $test = ($Keypress.Key -in ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' | ForEach-Object { [ConsoleKey]$_ }))
            break
        }
        '*' {
            $test = ($Keypress.KeyChar -eq '*')
            break
        }
        'æ-å' {
            $test = ($Keypress.keychar -in ('æ', 'ø', 'å' | ForEach-Object { [ConsoleKey]$_ }))
            break
        }
        default {
            $test = ($Keypress.key -eq [ConsoleKey]$_)
            break
        }
    }
    if (!$test) {
        return $false
    }
    return $keypress
    
}