function Test-IsViewVisible {
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [parameter(
            Mandatory,
            ParameterSetName = "Name"
        )]
        [string]$Name,

        [parameter(
            Mandatory,
            ParameterSetName = "Region"
        )]
        [hashtable]$Region
    )
    begin {
        if ($PSCmdlet.ParameterSetName -eq "Name") {
            $Region = $Global:PezView[$Name]
        }
    }
    process {
        return ($region.canvas.width -eq 0 -or $region.canvas.height -eq 0)
    }
    end {
    }
    # $children = $Global:PezView.GetEnumerator().where{ $_.value.parent -eq $Name }
    # if (!$children) {
    #     return $true
    # }
    # $ChildrenDirection = $children.value.direction | Select-Object -First 1

    # $return = switch ($ChildrenDirection) {
    #     'down' {
    #         $this.canvas.Height -gt 0
    #     }
    #     'across' {
    #         $this.canvas.Width -gt 0
    #     }
    # }

    # return $return
}