function Write-GumpLog {
    [CmdletBinding()]
    param (
        $msg,
        [string]$tag,
        [ValidateSet(
            'Info',
            'Warn',
            'Debug',
            'Verbose',
            'Error',
            'Output',
            "None"
        )]
        [string]$Level = 'Info'
    )
    
    begin {
        
    }
    
    process {

        if(!$LogRefrence){
            throw "LogRefrence is required"
        }

        $Missing = @()
        @("Tag","Id","Path","timeType","defaultLogLevel")|%{
            if(!$LogRefrence.ContainsKey($_)){
                $Missing += $_
            }
        }
        if($Missing)
        {
            throw "missing the following keys from LogRefrence: ($Missing -join ', ')"
        }

        $LogPath = $LogRefrence.Path
        If(!(Test-Path $LogPath)){
            throw "Log file not found at $LogPath. is the log initialized?"
        }
        $Timestamp = Get-Date
        if($LogRefrence.timeType -eq 'utc')
        {
            $Timestamp = $Timestamp.ToUniversalTime()
        }
        $dateParam = @{
            AsUtc = $LogRefrence.timestampFormat -eq 'utc'
        }
        $Log = @{
            Msg = $msg
            Caller = ((Get-PSCallStack)|select -First 1 -Skip 1).Command
            Level = $Level
            Timestamp = (Get-Date @dateParam).ToString($LogRefrence.timestampFormat)
        }
        
    }
    
    end {
        
    }
}

# function test{
#     Write-GumpLog -msg "test"
# }

# test