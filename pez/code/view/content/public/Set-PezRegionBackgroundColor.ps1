using namespace System.Drawing
function Set-PezRegionBackgroundColor {
    [CmdletBinding(
        DefaultParameterSetName = 'KnownColor'
    )]
    param (
        [parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [hashtable]$Region,

        [parameter(
            ParameterSetName = 'KnownColor'
        )]
        [KnownColor]$KnownColor,

        [parameter(
            ParameterSetName = 'Conosle'
        )]
        [switch]$Console,

        [parameter(
            ParameterSetName = 'Color'
        )]
        [Color]$Color
    )
    
    begin {
        $Registry = Get-PezRegistry -Name View
    }
    
    process {
        $Name = $Region.Name
        $Registry.$name.Color.ContentHasAnsi = $false
        if($KnownColor){
            $Color = [color]::FromName($KnownColor.ToString())
        }
        if($Console)
        {
            $Color = [color]::FromName([Console]::BackgroundColor.ToString())
        }
        # switch ($PSCmdlet.ParameterSetName) {
        #     'KnownColor' {
        #     }
        #     'Console' {
        #         $Color = [color]::FromName([Console]::BackgroundColor.ToString())
        #     }
        # }

        $Registry.$name.Color.Background = $color
    }
    end {}
}