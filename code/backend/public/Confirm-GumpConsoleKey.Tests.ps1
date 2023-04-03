#Generate tests for confirm-gumpconsolekey
Describe 'Confirm-GumpConsoleKey' {
    #generalise tests
    It 'Confirms that the keypress is <name>' -TestCases @(
        @{
            key = 'a'
            name = 'a-z'
        }
        # @{
        #     key = 'æ'
        #     name = 'æ'
        # }
        # @{
        #     key = '*'
        #     name = '*'
        # }
        @{
            key = [ConsoleKey]::Backspace
            name = 'backspace'
        }
        @{
            key = [ConsoleKey]::UpArrow
            name = 'upArrow'
        }
        @{
            key = [ConsoleKey]::DownArrow
            name = 'downArrow'
        }
        @{
            key = [ConsoleKey]::Enter
            name = 'enter'
        }
        @{
            key = [ConsoleKey]::Escape
            name = 'escape'
        }
        @{
            key = [ConsoleKey]::Spacebar
            name = 'spacebar'
        }
     ) {
        param(
            [ConsoleKey]$key,
            [string]$name
        )
        $keypress = [ConsoleKeyInfo]::new($key, $key, $false, $false, $false)
        Confirm-GumpConsoleKey -Keys $name -Keypress $keypress | Should -Be $true
    }
}