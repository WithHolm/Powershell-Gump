using namespace System.Management.Automation
enum GumpLogLevel{
    None
    Debug
    Verbose
    Info
    Warning
    Error
}

class GumpLogInfo{
    [string]$initiatorName
    [string]$initiatorId
    [string]$processId
    [string]$path
    [string]$timeZone
    [GumpLogLevel]$LogLevel

    GumpLogInfo([InvocationInfo]$CallerInfo, [GumpLogLevel]$DefaultLogLevel = [GumpLogLevel]::Info){
        $LogPathPrefix = join-path $env:TEMP 'gump'

        $this.processId = [System.Diagnostics.Process]::GetCurrentProcess().Id
        $this.path = join-path $LogPathPrefix "$($this.processId).gumplog"
        if($this.Exists()){
            $this.GetLog()
        }
        $this.RegisterLog()
    }

    [bool]Exists()
    {
        return Test-Path $this.Path
    }

    RegisterLog(){
        New-Item -ItemType File -Path $this.path -Force | Out-Null
    }

    GetLog(){

    }
}