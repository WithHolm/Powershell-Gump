
<#
.SYNOPSIS
Sets Pad for a string

.DESCRIPTION
Long description

.PARAMETER String
Parameter description

.PARAMETER Length
Parameter description

.PARAMETER Pad
Parameter description

.PARAMETER PadType
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-StringPad {
    [CmdletBinding()]
    param (
        [string]$String,

        [parameter(
            ParameterSetName = 'length'
        )]
        [int]$Length,

        [parameter(
            ParameterSetName = 'pad'
        )]
        [int]$Pad,
        
        [ValidateSet('left', 'right', 'middle')]
        [string]$PadType = 'middle',
        [ValidateLength(1,1)]
        [string]$PadChar = " "
    )
    
    begin {}
    
    process {
        if ($PSCmdlet.ParameterSetName -eq 'pad') {
            $Length = $pad + $String.Length
        }

        switch ($PadType) {
            'left' {
                $String = $String.PadLeft($Length + $String.Length, $PadChar)
            }
            'right' {
                $String = $String.PadRight($Length + $String.Length, $PadChar)
            }
            'middle' {
                $LengthDiff = $Length - $String.Length
                $LeftPad = [math]::Round($LengthDiff / 2, [System.MidpointRounding]::AwayFromZero)
                $String = $String.padleft($LeftPad + $String.Length,$PadChar).PadRight($Length,$PadChar)
            }
        }

        return $string
    }
    
    end {
        
    }
}