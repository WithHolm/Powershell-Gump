function Build-DocsColors {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $template = Get-Content -Path "$PSScriptRoot\color.md" -Raw
    }
    
    process {
        $rows = @()
        [enum]::GetNames([System.Drawing.KnownColor])|%{
            $Color = [System.Drawing.Color]::FromName($_)
            Write-Verbose ($Color|ConvertTo-Json -Compress)
            #figure out if the color is dark or light
            $luma = (0.2126 * $Color.R) + (0.7152 * $Color.G) + (0.0722 * $Color.B)
            if ($luma -gt 128) {
                $fg = 'black'
            }else{
                $fg = 'white'
            }
            $Name = $_
            $Foreground = '<span style="color:rgb({0},{1},{2});">{3}</span>' -f $Color.R, $Color.G, $Color.B, "Foreground"
            $Background = '<span style="background-color:rgb({0},{1},{2});color:{3};">{4}</span>' -f $Color.R, $Color.G, $Color.B, $fg, "Background"
            $Ansi = "``ESC[48;2;{0};{1};{2}m``" -f $Color.R, $Color.G, $Color.B
            if($color.IsSystemColor){
                $rows += $([ordered]@{
                    Name = "$name (system color)"
                })
            }else{
                $rows += $([ordered]@{
                    Name = $name
                    Foreground = $Foreground
                    Background = $Background
                    Ansi = $Ansi
                })
            }

        }
        $Headers = $rows.keys|select -Unique

        #generate the markdown table
        $TableContents = @()
        $TableContents += $Headers -join ' | '
        $TableContents += "---|" * $Headers.count
        $TableContents += $rows|%{$_.values -join ' | '}
        $markdown = $TableContents -join "`n"

        #replace the template with the markdown
        $Out = $template -replace '{{colormap}}', $markdown
        
        return $Out
    }
    
    end {
        
    }
}

# Build-DocsColors