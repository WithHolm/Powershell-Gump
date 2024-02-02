function get-pezViewItem {
    [CmdletBinding()]
    [OutputType('PezViewItem')]
    param (
        [parameter(
            Mandatory,
            Position = 0,
            parametersetname = 'name',
            ValueFromPipeline
        )]
        [string]$Name,

        [parameter(
            parametersetname = 'all'
        )]
        [switch]$All,

        [parameter(
            parametersetname = 'all'
        )]
        [switch]$AllVisible
    )
    
    begin {

    }
    
    process {
        $PezView = Get-PezRegistry -Name 'View'
        if($PSCmdlet.ParameterSetName -eq 'name'){
            $ActualName = $PezView.keys|Where-Object {$_ -eq $Name}
            if($ActualName){
                $Name = $ActualName
            }
            else{
                throw "PezView does not contain a view with name '$Name'"
            }
            return $PezView[$Name]    
        }
        elseif($PSCmdlet.ParameterSetName -eq 'all'){
            if($AllVisible){
                
               <#
               https://www.red-gate.com/simple-talk/development/dotnet-development/high-performance-powershell-linq/
              [Linq.Enumerable]::Where(
                        $dates,
                        [Func[DateTime,bool]] { param($d); return $d.Year -gt 2016 }
                    ) 
               #>
                return $PezView.Values|Where-Object {$_.Visible}
            }
            else{
                return $PezView.Values
            }
        }
    }
    
    end {
        
    }
}

# $k = Get-PezView -Name 'root'
# $k

# calculate the points of a cicrle to show as dots in terminal


# function Get-CircleCoordinatesv2 {
#     [CmdletBinding()]
#     param (
#         [int]$Radius = 10,
#         [int]$X = 0,
#         [int]$Y = 0,
#         [double]$AspectRatio = 2
#     )
#     begin {
#         $points = @()
#         $pi = [math]::PI
#         $step = 2 * $pi / 360
#     }
#     process {
#         $Set = [System.Collections.Generic.HashSet[array]]::new()
#         for ($i = 0; $i -lt 2 * $pi; $i += $step) {
#             [void]$Set.Add(@(
#                     [math]::Round($X + ($Radius * [math]::cos($i) * 2.5)),
#                     [math]::Round($Y + ($Radius * [math]::sin($i)))
#                 ))
#             # [void]$Set.Add(@{
#             #     x = [math]::Round($X + ($Radius * [math]::cos($i) * $AspectRatio))
#             #     y = [math]::Round($Y + ($Radius * [math]::sin($i)))
#             # })
#         }
#     }
#     end {
#         return $Set
#     }
# }



# $v2 = Get-CircleCoordinatesv2 -Radius 5 -X 15 -Y 5

# do{
#     $k = 0,0
#     $v2 | ForEach-Object {
#         [console]::SetCursorPosition($_[0], $_[1])
#         [console]::Write(" ")
#         Start-Sleep -Milliseconds 4

#         [console]::SetCursorPosition($_[0], $_[1])
#         [console]::Write("█")

#         Start-Sleep -Milliseconds 4
#     }
# }while($true)