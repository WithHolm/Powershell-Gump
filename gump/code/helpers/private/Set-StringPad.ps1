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
        [string]$PadType = 'middle'
    )
    
    begin {}
    
    process {
        if ($PSCmdlet.ParameterSetName -eq 'pad') {
            $Length = $pad + $String.Length
        }

        switch ($PadType) {
            'left' {
                $String = $String.PadLeft($Length + $String.Length)
            }
            'right' {
                $String = $String.PadRight($Length + $String.Length)
            }
            'middle' {
                $LengthDiff = $Length - $String.Length
                $LeftPad = [math]::Round($LengthDiff / 2, [System.MidpointRounding]::AwayFromZero)
                $String = $String.padleft($LeftPad + $String.Length).PadRight($Length)
            }
        }

        return $string
    }
    
    end {
        
    }
}