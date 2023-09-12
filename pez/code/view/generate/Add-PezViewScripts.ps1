#export:core
using namespace System.Collections.Generic
function Add-PezViewScripts {
    [CmdletBinding()]
    param (
        [string]$Name
    )
    
    begin {
        
    }
    
    process {
        $Global:PezView[$name] | Add-Member -MemberType ScriptProperty -Name Visible -Value {
            [CmdletBinding()]
            [OutputType([boolean])]
            param()
            $children = $Global:PezView.GetEnumerator().where{ $_.value.parent -eq $this.name }
            if (!$children) {
                return $true
            }
            $ChildrenDirection = $children.value.direction| Select-Object -First 1

            $return = switch ($ChildrenDirection) {
                'down' {
                    $this.canvas.Height -gt 0
                }
                'across' {
                    $this.canvas.Width -gt 0
                }
            }
            return $return
        }

        $Global:PezView[$name] | Add-Member ScriptMethod -Name RemoveFromCanvas -Value {
            [CmdletBinding()]
            param(
                [System.Drawing.Rectangle]$rect,
                [string]$direction
            )
            
            $NewCanvas = [System.Drawing.Rectangle]$this.canvas
            switch($direction){
                'across'{
                    Write-Verbose "shifting $($this.name) across by $($rect.Width)"
                    #shifting start of canvas to the right, and reducing width
                    $NewCanvas.Width -= $rect.Width
                    $NewCanvas.x += $rect.Width 
                }
                'down'{
                    Write-Verbose "shifting $($this.name) down by $($rect.Height)"
                    #shifting start of canvas down, and reducing height
                    $NewCanvas.Height -= $rect.Height
                    $NewCanvas.y += $rect.Height
                }
            }

            $this.canvas = $NewCanvas
        }
    }
    
    end {
        
    }
}

function Verb-Noun {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}