function New-GumpLog {
    [CmdletBinding()]
    param (
        [ValidateSet(
            'local',
            'utc'
            )]
        [string]$TimeZone = 'utc',
        [GumpLogLevel]$defaultLogLevel = 'Info'
    )
    
    begin {
    <#
        IDEA:
        Client side
        - Generate a item in index file with the following info:
            - initiator name
            - initiator id
            - process id
            - path
            - time type
            - default log level
        - start a log stream to the path
        - every someone calls log

    #>

        $LogPathPrefix = join-path $env:TEMP 'gump'
    }
    process {
        $Source = ((get-pscallstack)|Select-Object -Last 2|Select-Object -First 1).InvocationInfo
        $GumpLogInfo = [GumpLogInfo]::new($Source, $defaultLogLevel)

        $log = @{
            InitiatorName = $Source.MyCommand.name
            InitiatorId = $Source.GetHashCode()
            pid = $pid
            Path = join-path $LogPathPrefix "$pid.gumplog"  
            timeType = $TimeType
            defaultLogLevel = $defaultLogLevel
        }
        
        if(Test-Path $log.path) {
            return $log
        }

        New-Item -ItemType File -Path $log.path -Force | Out-Null
        $log|Write-GumpLog -msg "started log"
    }
    
    end {
        return $log
    }
}