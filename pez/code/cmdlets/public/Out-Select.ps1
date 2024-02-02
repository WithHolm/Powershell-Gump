using namespace System
using namespace Collections.Generic
function Out-Select {
    [CmdletBinding()]
    param (
        [parameter(
            ValueFromPipeline
        )]
        $InputItem,
        [string]$Title,
        [string]$Select,

        [System.Drawing.KnownColor]$SelectionColor = [System.Drawing.KnownColor]::DarkSalmon,

        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 1)]
        [string]$SelectChar = "▶",

        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxChoices = 1,

        [int]$ShowItemCount = 0
    )
    
    begin {
        New-PezLogContext -context 'Out-Select'
        #tuple to hold it
        $items = [List[hashtable]]::new()
        
    }
    
    process {
        Foreach ($it in $InputItem) {
            $content = $it.tostring()
            if ($Select) {
                $content = ($it | Select-Object -ExpandProperty $Select).ToString()
            }
            $items.Add(
                @{
                    index    = $items.Count
                    content  = $content
                    selected = $false
                }
            )
        }
    }
    
    end {
        Write-PezLog "Got $($items.Count) items"
        try {

            ## MAKE VIEW
            $MultiselectStates = @("[ ]", "[X]")
            $LongestItem = $items.content.length | Sort-Object | select -first 1
            # $LongestItem
            $Minlength = [math]::max($LongestItem, 25)
            #setup the view
            $ItemCount = [math]::Min($items.Count, $ShowItemCount)
            $ViewSpanLength  = $ItemCount
            if ($ShowItemCount -eq 0) {
                $ItemCount = $items.Count
            }
            Write-PezLog "Generating view with $ItemCount rows ($($items.Count) items, limit for console $ShowItemCount)))"
            New-PezView  -Definition {
                Add-PezRegion 'top' 90% -Visible $false {
                    Add-PezRegion 'left' $($Minlength + 5) -Visible $false -Across {
                        Add-PezRegion "title" 3 -Down
                        # Write-warning ($(get-pezViewItem -All).name -join ", ")
                        $MaxSize = (get-pezViewItem -Name left).Canvas.Height - 5
                        $ViewSpanLength = [math]::Min($ItemCount, $MaxSize)
                        Write-PezLog "Viewspanlength: $ViewSpanLength"
                        #generate all rows that are shown. if there are more items than rows, then we can only show a subset of the items
                        for ($i = 0; $i -lt $ViewSpanLength; $i++) {
                            Add-PezRegion "row$i" 1 {
                                Add-PezRegion "row$i-space" 1 -Across
                                Add-PezRegion "row$i-select" 2
                                if ($MaxChoices -gt 1) {
                                    Add-PezRegion "row$i-selected" 3
                                }
                                Add-PezRegion "row$i-name" 100%
                            }
                        }
                        
                        Add-PezRegion 'line' 1                    
                        Add-PezRegion 'help1' 1 {
                            Add-PezRegion 'help-updown' 50% -Across
                            Add-PezRegion 'help-esc' 50%
                        }                 
                        Add-PezRegion 'help2' 1 {
                            if ($MaxChoices -gt 1) {
                                Add-PezRegion 'help-space' 50% -Across
                            }
                            Add-PezRegion 'help-enter' 100% -Across
                        }                 
                    }
                    Add-PezRegion 'right' 60%
                }
                Add-PezRegion 'debug' 5%                   
                Add-PezRegion 'bottom' 80%
            } #-Verbose
    

            Write-PezLog "Viewspanlength: $ViewSpanLength"
            Set-AlternativeBuffer enabled
            Set-ConsoleModes DisableCursor
            Set-ConsoleModes SetConsoleEncoding-utf8
    
            ## MAINLOOP
            ## Fill the view
            

            $PAllignMid = @{
                YAlignment = "middle"
                XAlignment = "middle"
            }
            $LineItem = get-pezViewItem -Name line
            $LineItem | Set-PezRegionContent -Content ('-' * $LineItem.Canvas.Width) @PAllignMid

            if (!$Title) {
                $Title = "Select an item"
            }
            $TitleView = get-pezViewItem -Name title
            $TitleView | Set-PezRegionBackgroundColor -KnownColor AliceBlue
            $TitleView | Set-PezRegionForegroundColor -Inverse
            $TitleView | Set-PezRegionContent -Content $Title @PAllignMid
    
    
            # for ($i = 0; $i -lt $items.Count; $i++) {
            #     $item = $items[$i]
            #     $ItemView = get-pezViewItem -Name "show$i"
            #     $ItemView | Set-PezRegionContent -Content $Item.content
            #     $ItemView | Set-PezRegionForegroundColor -ConsoleColor

            #     if ($MaxChoices -gt 1) {
            #         # $ItemSelect = get-pezViewItem -Name "selected$i"
            #         get-pezViewItem -Name "selected$i" | Set-PezRegionContent -Content $MultiselectStates[0] -XAlignment middle
            #     }
            # }
    
            #Help Message
            $color = @{
                UpDown = [System.Drawing.KnownColor]::DarkTurquoise
                Esc    = [System.Drawing.KnownColor]::Tomato
                Enter  = [System.Drawing.KnownColor]::MediumSpringGreen
                Space  = [System.Drawing.KnownColor]::coral
            }
            $helpmessages = @{
                UpDown = "Up/Down:Select"
                Esc    = "Esc:Cancel"
                Enter  = "Enter:Accept"
            }
            $helpmessages.GetEnumerator() | % {
                $help = get-pezViewItem -Name "help-$($_.key)"
                $help | Set-PezRegionContent -Content $_.value @PAllignMid
                $help | Set-PezRegionForegroundColor -KnownColor $color.$($_.key)
            }
    
            if ($MaxChoices -gt 1) {
                get-pezViewItem -Name "help-space" | Set-PezRegionContent -Content "Space:Choose" @PAllignMid
                get-pezViewItem -Name "help-space" | Set-PezRegionForegroundColor -KnownColor $color.Space
            }
            



            $Complete = $false
            $Active = 0
            $NewActive = 0

            $EnableViewSpan = $items.Count -gt $ViewSpanLength

            #what is half of the view?
            $ViewSpanHalfwayPoint = [math]::Round($ViewSpanLength / 2, 0)

            $return = @{}
            while (!$Complete) {

                #if no viewspan is needed, then we can just show the whole list
                if (!$EnableViewSpan) {
                    $VisibleListRangeStart = 0
                }
                # viewing the start of the list while the selector is over the halfway point
                elseif ($Active -lt $ViewSpanHalfwayPoint) {
                    $VisibleListRangeStart = 0
                }
                #on the bottom of the list while the selector is over the halfway point
                elseif ($active -gt ($items.Count - $ViewSpanHalfwayPoint)) {
                    $VisibleListRangeStart = $items.count - $ViewSpanLength
                }
                #if its at the halway point we need to revolve the list around it
                else {
                    $VisibleListRangeStart = $Active - $ViewSpanHalfwayPoint
                }
                
                # $ActiveIndexInView
                $ViewListIndex = 0
                $ViewListLength = $ViewSpanLength
                $DotsAtTop = $VisibleListRangeStart -gt 0
                $DotsAtBottom = ($VisibleListRangeStart + $ViewSpanLength) -lt $items.Count

                if ($DotsAtTop) {
                    "row0-selected", "row0-name", "row0-selected" | get-pezViewItem | Set-PezRegionContent -Content "..."
                    $viewListIndex = 1
                }

                if ($DotsAtBottom) {
                    $BottomRow = "row$($ViewSpanLength - 1)"
                    Write-PezLog "BottomRow: $BottomRow; viewspanlength: $ViewSpanLength; ViewListIndex: $ViewListIndex"
                    "$BottomRow-selected", "$BottomRow-name", "$BottomRow-selected" | get-pezViewItem | Set-PezRegionContent -Content "..."
                    $ViewSpanLength--
                }

                $viewList = $items.GetRange($VisibleListRangeStart, $ViewSpanLength)
                # $viewListIndex = 0
                for ($i = $ViewListIndex; $i -lt $ViewListLength; $i++) {
                    $NameColumn = "row$i-name" | get-pezViewItem
                    $NameColumn | Set-PezRegionContent -Content $view[$viewListIndex]

                    $SelectColumn = "row$i-select"| get-pezViewItem

                    if($MaxChoices -gt 1)
                    {
                        #set state from item.selected
                        $state = switch($view[$viewList].selected)
                        {
                            $true {$MultiselectStates[1]}
                            $false {$MultiselectStates[0]}
                        }

                        $SelectedColumn = "row$i-selected" | get-pezViewItem
                        $SelectedColumn | Set-PezRegionContent -Content $state -XAlignment middle
                    }
                    if($view[$viewListIndex].index -eq $Active)
                    {
                        $SelectColumn | Set-PezRegionContent -Content $SelectChar -XAlignment middle
                        $SelectColumn | Set-PezRegionForegroundColor -KnownColor $SelectionColor
                        $NameColumn | Set-PezRegionForegroundColor -KnownColor $SelectionColor
                        if($MaxChoices -gt 1)
                        {
                            $SelectedColumn | Set-PezRegionForegroundColor -KnownColor $SelectionColor
                        }
                    }
                    else
                    {
                        $SelectColumn | Set-PezRegionContent -Content " " -XAlignment middle
                        $SelectColumn | Set-PezRegionForegroundColor -ConsoleColor
                        $NameColumn | Set-PezRegionForegroundColor -ConsoleColor
                        $SelectedColumn | Set-PezRegionForegroundColor -ConsoleColor
                    }
                    $viewListIndex++
                }
                $Active = $NewActive
                
                Set-PezRegionContent -Name 'debug' -Content @(
                    "Active: $Active, NewActive: $NewActive, Complete: $Complete"
                    "Active region show: $($NewRegions[0].name), bg: $($global:PezView.($NewRegions[0].name).Color.background), select: $($NewRegions[1].name), bg $($global:PezView.($NewRegions[0].name).Color.background)"
                )
                write-PezRegion -all
                $KeyPress = [Console]::ReadKey("NoEcho,IncludeKeyDown")
                #region Keypress
                switch ($KeyPress) {
                    (Test-Keypress -Keypress $_ -Keys escape) {
                        $Complete = $true
                    }
                    #going down on list. stop on 
                    (Test-Keypress -Keypress $_ -Keys downArrow) {
                        $NewActive = [math]::min($Active + 1, $items.Count - 1)
                    }
                    (Test-Keypress -Keypress $_ -Keys upArrow) {
                        $NewActive = [math]::max(($Active - 1), 0)
                    }
                    (Test-Keypress -Keypress $_ -Keys enter) {
                        $Complete = $true
                        if ($MaxChoices -eq 1) {
                            $return.$active = $items[$Active]
                        }
                    }
                    #only when multiple choices are allowed
                    (Test-Keypress -Keypress $_ -Keys spacebar) {
                        if ($MaxChoices -gt 1) {
                            $ItemSelect = get-pezViewItem -Name "selected$Active"
                            # $ItemSelect | Set-PezRegionForegroundColor -ConsoleColor
                            if ($return.$active) {
                                $return.Remove($active)     
                                $ItemSelect | Set-PezRegionContent -Content $MultiselectStates[0] -XAlignment middle #@PAllignMid 
                            }
                            else {
                                $ItemSelect | Set-PezRegionContent -Content $MultiselectStates[1] -XAlignment middle #@PAllignMid 
                                $return.$active = $items[$Active]
                            }
                        }
                    }
                }
                #endregion Keypress
            }
        }
        finally {
            Set-AlternativeBuffer disabled
            Set-ConsoleModes EnableCursor
            Set-ConsoleModes RevertConsoleEncoding
        }
        return $return.Values
    }
}