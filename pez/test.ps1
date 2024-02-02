[CmdletBinding()]
param()

Get-ChildItem "$PSScriptRoot/code/*.ps1" -Recurse | ForEach-Object{ . $_.FullName }
# "dette","er ","en","test"
# New-PezLog -LogPath "$psscriptroot\tetting.log"
# 1..15| Out-Select -MaxChoices 3 -ShowItemCount 5 -Title 'test'
New-PezView -Definition {
    Add-PezRegion -name 'top' -Size 95% -Definition {
        Add-PezRegion  -name 'left' -Size 80% -Across -Definition{
            Add-PezRegion -name "Title" -Size 3 -Down
        #     1..10| % {
        #         $i = $_ 
        #         Add-PezRegion -name "item$i" -Size 1 -Down -definition {
        #             Add-PezRegion -name "space $i" -size 1 -Across
        #             Add-PezRegion -name "select $i" -Size 3 
        #             Add-PezRegion -name "show $i" -Size 100%
        #         }
        #     }
            Add-PezRegion -name 'help' -size 3
            Add-PezRegion -name 'leftTop' -Size 50% -Down
            
        }
        Add-PezRegion -name 'right' -Size 60%
    }
    Add-PezRegion -name 'bottom' -Size 80%
    # Add-PezRegion -Name 'pause' -Size 1%
}
Start-PezViewColors -Continous -Smooth
# Pause