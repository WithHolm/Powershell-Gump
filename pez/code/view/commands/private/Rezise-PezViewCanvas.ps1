function Resize-PezViewCanvas {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory
        )]
        [string]$Name,

        [parameter(
            Mandatory,
            ParameterSetName = 'SubtractByRect'
        )]
        [System.Drawing.Rectangle]$Subtract,

        [parameter(
            Mandatory,
            ParameterSetName = 'SubtractByRect'
        )]
        [string]$SubtractDirection,

        [parameter(
            ParameterSetName = 'Reset'
        )]
        [switch]$Reset
    )
    $Item = $Global:PezView[$name]

    if($PSCmdlet.ParameterSetName -eq 'Reset'){
        Write-Verbose "resetting canvas for $($item.name)"
        $Item.canvas = [System.Drawing.Rectangle]::new($item.location, $item.size)
        return
    }
    elseif($PSCmdlet.ParameterSetName -eq 'SubtractByRect'){
        switch ($direction) {
            'across' {
                Write-Verbose "shifting $($Item.name) across by $($Subtract.Width)"
                #shifting start of canvas to the right, and reducing width
                $Item.canvas.Width -= $Subtract.Width
                $Item.canvas.x += $Subtract.Width 
            }
            'down' {
                Write-Verbose "shifting $($Item.name) down by $($Subtract.Height)"
                #shifting start of canvas down, and reducing height
                $Item.canvas.Height -= $Subtract.Height
                $Item.canvas.y += $Subtract.Height
            }
        }
    }

    if($item.Visible -and ($Item.canvas.Height -eq 0 -or $Item.canvas.Width -eq 0)){
        Write-Verbose "hiding $($item.name). canvas is $($item.Canvas.Width)x$($Item.Canvas.Height)"
        $item.Visible = $false
    }
}