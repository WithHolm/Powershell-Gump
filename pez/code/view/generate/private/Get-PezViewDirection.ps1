function Get-PezViewDirection {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateSet('down', 'across', 'auto')]
        [string]$Direction,
        
        [parameter(
            Mandatory
        )]
        [string]$Parent,

        [parameter(
            Mandatory
        )]
        [String]$Name
    )
    
    begin {
        
    }
    
    process {
        $ParentItem = Get-PezViewItem -Name $Parent
        $Siblings = $ParentItem | Get-PezViewChildren

        if ($Direction -eq 'auto') {
            #check direction of siblings
            #else get from parent
            if ($Siblings) {
                $FirstSibling = $Siblings | Sort-Object Id | Select-Object -first 1
                $_direction = $FirstSibling.Direction
                Write-Verbose "[$name] grabbing direction '$($_direction)' from sibling '$($FirstSibling.Name)'"
                $Direction = $_direction
            }
            else {
                $_direction = $ParentItem.Direction
                Write-Verbose "[$name] grabbing direction '$($_direction)' from parent '$($ParentItem.Name)'"
                $Direction = $_direction
            }
            if ($Direction -eq 'auto') {
                throw "View $name failed to grab direction from parent or siblings"
            }
        }
        elseif ($Siblings) {
            #check if other children have the same direction, throw if not
            $OtherDirectionSiblings = $Siblings | Where-Object { $_.Direction -ne $Direction } 
            if ($null -ne $OtherDirectionSiblings) {
                throw "View '$name' is asking for direction '$Direction' but siblings $($OtherDirectionSiblings.name -join ",") has defined direction '$($OtherDirectionSiblings[0].direction)'"
            }
        }
        return $Direction
    }
    
    end {
        
    }
}