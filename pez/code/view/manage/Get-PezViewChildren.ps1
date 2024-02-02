#export:core
function Get-PezViewChildren {
    [CmdletBinding()]
    [OutputType('PezViewItem')]
    param (
        [parameter(
            Mandatory,
            ParameterSetName = 'Name'
        )]
        [string]$Name,
        [parameter(
            ValueFromPipeline,
            ParameterSetName = 'PezViewItem'
        )]
        [hashtable]$PezViewItem,
        [switch]$Recurse
    )

    begin{
        if ($null -eq $Global:PezView -or $Global:PezView.Count -eq 0) {
            throw "Pez is not initialized, or does not haven any items. please run New-PezView"
        }
    }
    process{
        # Write-verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        if ($PSCmdlet.ParameterSetName -eq 'PezViewItem') {
            if(! $PezViewItem.ContainsKey('Name')){
                throw "PezView Item needs to have the property 'Name' $($pezViewItem | ConvertTo-Json -Compress)"
            }
            $name = $PezViewItem.Name
        }elseif(! $Global:PezView.ContainsKey($Name)){
            
            throw "PezView Item with name $Name does not exist"
        }
        # Write-Verbose "Name: $Name"

        $out = $Global:PezView.Values|Where-Object{ $_.Parent -eq $name }

        Write-Output $out
        if(!$Recurse)
        {
            return 
        }
        
        # Write-Verbose "count out $($out.count)"
        $out | Where-Object {$_}|ForEach-Object {
            $_ | Get-PezViewChildren -Recurse
        }

    }
    

}

# $pez.root | Get-PezViewChildren -Recurse -Verbose #|%{"..";$_}