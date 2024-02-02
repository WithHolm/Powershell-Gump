#export:core
using namespace System.Collections.Generic
using namespace System.Drawing
function New-PezView {
    [CmdletBinding()]
    param (
        [scriptblock]$Definition
    )
    
    begin {
        $name = 'root'
        Write-Verbose "starting new pez view"

        $Global:PezView = [Dictionary[string, ordered]]::new()
    }
    
    process {      
        $size = [Size]::new(
            ([Console]::WindowWidth - 1), 
            ([Console]::WindowHeight - 1)
        )
        $location = [Point]::new(0, 0)

        Add-PezViewItem -Name $name -Parent '' -Location $location -Size $size -Direction 'down' -Visible $false
        
        Invoke-PezViewDefinition -Name $name -Definition $Definition
    }
    end {}
}

# New-PezView -Name 'test' -Root -Size 100 -Direction across -Definition {
#     New-PezView -name 'other' -Size 40%
#     New-PezView -name 'other2' -Size 40%
#     New-PezView -name 'other3' -Size 30%
# } -Verbose
# $Global:PezView.Values | % { "---"; $_ }
# $Global:PezView