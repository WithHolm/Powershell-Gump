#borrowed from ecsousa/PSColors. really nice check
function Test-GumpAnsi {
    param()
    # Powershell ISE don't support ANSI, and this test will print ugly chars there
    if ($host.PrivateData.ToString() -eq 'Microsoft.PowerShell.Host.ISE.ISEOptions') {
        return $false;
    }

    # To test is console supports ANSI, we will print an ANSI code
    # and check if cursor postion has changed. If it has, ANSI is not
    # supported
    $oldPos = $host.UI.RawUI.CursorPosition.X

    Write-Host -NoNewline "$([char](27))[0m" -ForegroundColor ($host.UI.RawUI.BackgroundColor);

    $pos = $host.UI.RawUI.CursorPosition.X

    if ($pos -eq $oldPos) {
        return $true;
    }
    else {
        # If ANSI is not supported, let's clean up ugly ANSI escapes
        Write-Host -NoNewLine ("`b" * 4)
        return $false
    }
}