function Set-PezRegionContent {
    [CmdletBinding()]
    param (
        [parameter(
            ParameterSetName = 'Name',
            Mandatory
        )]
        [string]$Name,
        [parameter(
            ParameterSetName = 'PezViewItem',
            Mandatory,
            ValueFromPipeline
        )]
        [hashtable]$View,

        [string[]]$Content,

        [ValidateSet(
            'left',
            'middle',
            'right',
            'none'
        )]
        [string]$XAlignment = 'none',
        [ValidateSet(
            'top',
            'middle',
            'bottom',
            'none'
        )]
        [string]$YAlignment = 'none'
    )
    
    begin {
        $reg = Get-PezRegistry -Name View
        
    }
    
    process {
        if ($View) {
            $Name = $View.Name
        }

        $UsingView = $reg.$Name


        # if ($content.Count -gt $View.Canvas.Height) {
        #     throw "Incoming content is too high for $($view.Name). expected a size of $($view.Content.count), but got $($content.Count)."
        # }
        
        # #empty line
        $Line = ' ' * $UsingView.Canvas.Width
        # Write-Host $UsingView.Canvas.Height
        if ($YAlignment -ne 'none' -and $content.Count -lt $UsingView.Canvas.Height) {
            $HeighDiff = $UsingView.Canvas.Height - $content.Count
            # Write-Host $HeighDiff 
            #TODO: Make these array instertions better and faster... i mean.. @()?.. good enooghh for now tho 
            switch ($YAlignment) {
                'top' {
                    #nothing really needed.. im already starting from the top
                }
                'middle' {
                    $top = [math]::floor($HeighDiff / 2)
                    $NewContent = @()
                    1..$top | % {
                        $NewContent += $Line
                    }
                    $Content.ForEach{
                        $NewContent += $_
                    }
                    $Content = $NewContent
                }
                'bottom' {
                    $BottomCount = ($View.Canvas.Height) - $content.Count
                    $NewContent = @()
                    1..$BottomCount | % {
                        $NewContent += $Line
                    }
                    $content.foreach{
                        $NewContent += $_
                    }
                    $content = $NewContent
                }
            }
        }
        
        #Fix so content box is filled
        if ($Content.count -lt $UsingView.Canvas.Height) {
            $Add = $UsingView.Canvas.Height - $content.Count
            1..$Add | % {
                $content += $Line
            }
        }
        elseif ($Content.count -gt $UsingView.Canvas.Height) {
            $first = [math]::max(1, $View.Canvas.Height)
            $content = $content|Select-Object -First $first
        }
        
        $ansiRegex = "\u001B\[[0-9;]*m"
        # "(?'ansi'\u001B\[[0-9;]*m)(?'content'.*)"

        for ($i = 0; $i -lt $content.Count; $i++) {
            $Content[$i] = $Content[$i] -replace $ansiRegex
            
            $ContentWithoutAnsi = $content[$i] -replace "\u001B\[[0-9;]*m"
            if($ContentWithoutAnsi.length -lt $UsingView.Canvas.Width){
                $content[$i] = $content[$i] + (' ' * ($UsingView.Canvas.Width - $content[$i].length))
            }
            elseif ($ContentWithoutAnsi.length -gt $UsingView.Canvas.Width) {
                $content[$i] = $content[$i].substring(0, $UsingView.Canvas.Width)
            }

            if($XAlignment -ne 'none'){
                $padtype = switch($XAlignment){
                    'left' { 'right' }
                    'right' { 'left' }
                    'middle' { 'middle' }
                }
                $content[$i] = Set-StringPad -String $ContentWithoutAnsi -length $UsingView.Canvas.width -PadType $padtype
                # $content[$i]
            }
        }

        $UsingView.Content = $Content
    }
    
    end {
        
    }
}

<#
@{
    content = string[]
    theme = @{
        foreground = [consolecolor]
        background = [consolecolor]
    }

}
#>