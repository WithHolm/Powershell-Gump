function Use-AnsiConsoleControl {
    [CmdletBinding()]
    param (
        [ValidateSet(
            "enable",
            "disable"
        )]
        [string]$Cursor,
        [ValidateSet(
            "restore",
            "save"
        )]
        [string]$Screen,
        [ValidateSet(
            "enable",
            "disable"
        )]
        $AlternativeBuffer
    )
    
    begin {
        $return = @()
    }
    
    process {
        switch($Cursor)
        {
            "enable"{
                $return += "[?25h"
            }
            "disable"{
                $return += "[?25l"
            }
            default{
                #do nothing
            }
        }

        switch($Screen)
        {
            "restore"{
                $return += "[?1049l"
            }
            "save"{
                $return += "[?1049h"
            }
            default{
                #do nothing
            }
        }

        switch($AlternativeBuffer)
        {
            "enable"{
                $return += "[?47h"
            }
            "disable"{
                $return += "[?47l"
            }
            default{
                #do nothing
            }
        }

        if($script:_ansiBuild){
            $script:_ansiReturn.console += $return
            return
        }

        return (($return|%{"`e$_"}) -join "") 

        
        
    }
    
    end {
        
    }
}