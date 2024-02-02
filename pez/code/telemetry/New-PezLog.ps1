using namespace System.Collections.Generic
$Global:pezLog = @{
    OutputToRegion = ""
    LogPath = ""
    Context = ""
    SubContext = ""
    commandMap = [Dictionary[string, string]]::new()
}

function New-PezLog {
    [CmdletBinding()]
    param (
        [string]$OutputToRegion,
        [string]$LogPath
    )
    if($LogPath)
    {
        $Global:pezLog.LogPath = $logpath
        if(test-path $LogPath)
        {
            Remove-Item $LogPath
        }
        New-Item -Path $LogPath -ItemType File -Force|Out-Null
    }
}