
class ChoiceReturn {
    [int]$Index
    [string]$Choice
    [string[]]$Items
    [bool]$completed
    [bool]$canceled
    ChoiceReturn($items, [int]$index, [bool]$completed, [bool]$canceled) {
        $this.items = $items
        $this.Index = $index
        $this.Choice = $this.items[$this.Index]
        $this.completed = $completed
        $this.canceled = $canceled
    }
}

function Invoke-GumpChoice {
    [CmdletBinding()]
    [OutputType([ChoiceReturn])]
    param (
        [parameter(
            ValueFromPipeline
        )]
        $InputItem,
        $Select,
        [string]$Message,
        [switch]$EnableFilter,
        [GumpColor]$ChoiceColor = [GumpColor]::DarkSalmon,

        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 1)]
        [char]$SelectChar = ">",
        
        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxChoices = 1,
        [switch]$DisableHelp
    )
    
    begin {
        # $Tui = [GumpTui]::new()
        $reset = (Get-GumpAnsiSequence)

        #color of selector and line currently active
        $SelectionColor = Get-GumpAnsiSequence -ForegroundColor $ChoiceColor
        $FilterColor = Get-GumpAnsiSequence -ForeGroundColor BurlyWood

        #items to list
        # $items = @{}
        $items = [Collections.Generic.List[hashtable]]::new()
    }
    
    process {
        Foreach ($it in $InputItem) {
            $content = $it.tostring()
            if ($Select) {
                $content = ($it | Select-Object -ExpandProperty $Select).ToString()
            }
            $items.Add(
                @{
                    id      = $items.Count
                    content = $content
                }
            )
        }
    }
    
    end {
        try {
            #region init
            #remove console cursor
            Set-GumpConsoleModes -Modes DisableCursor

            #figure out the space requred for the tui
            New-GumpConsoleZone -Name 'ViewTop' -Height 2 -Init
            if ($EnableFilter) {
                New-GumpConsoleZone -Name 'Filter' -Height 1
            }
            New-GumpConsoleZone -Name 'view' -Height $items.count -Resizable -MinHeight 5
            New-GumpConsoleZone -Name 'help' -Height 1 
            New-GumpConsoleZone -Name 'verbose' -Height 1 -StreamType verbose
            Initialize-GumpConsoleZones

            $view = Get-GumpConsoleZone -Name 'View' -ThrowIfNull

            #set items that can be viewed
            $AllItemsIndex = @(0..($items.count - 1))
            $CurrentViewIndex = @(0 .. $($view.Height - 1))
            
            #set options for multiselect
            $multiSelect = $MaxChoices -ne 1
            $MultiselectStates = @("[ ]", "[X]")
            $MultiSelectCounter = $MaxChoices

            if (!$DisableHelp) {
                $HelpOptions = "Enter", "Esc", "Up/Down"
                if ($multiSelect) {
                    $HelpOptions += "Space"
                }
                
                Write-GumpTip -help $HelpOptions -Zone 'help'
            }

            #while choice is being made
            # $LimitedView = $view.Height -lt $items.Count

            #choices that are made by user, as index
            $Choices = @()

            #choice completed
            $Complete = $false
            
            #choice canceled
            $Canceled = $false

            # #next active item in index (user has pressed down/up)
            $NextActiveItemIndex = 0
            $ActiveItemIndex = 0
            $shiftIndex = 0
            $FilterText = ""
            $showItems = $items
            #init empty array to get what was shown last frame. decides if i should update this line again or not. saves rendering
            # $LastViewArray = [string[]]::new($CurrentViewIndex.Count)

            #endregion
            do {
                $HelpMessage = $Message
                if ($multiSelect) {
                    $HelpMessage += " ($MultiSelectCounter selections left)"
                }
                Set-GumpConsoleZone -Name 'viewTop' -Content @($HelpMessage, "----------")

                if ($EnableFilter) {
                    Set-GumpConsoleZone -Name 'Filter' -Content $($FilterColor + "filter ('*' for wildcard): $FilterText")
                    # $Flt = $FilterText
                }

                $showItems = $Items.Where{ $_.content -like "$FilterText*" }

                $LimitedView = $CurrentViewIndex.count -ne $showItems.Count
                $AllItemsIndex = [int[]]@($showItems.id)

                #figure if if i need to shift my viewed items, incase there are more items avalible then i can show (limited view)
                #current view index is just a list of indexes from all items index currently being shown
                #currentviewindex[0] = 10 = allitemsindex[10]
                $shiftParam = @{
                    AllIndexArray   = $AllItemsIndex
                    ViewIndexArray  = $CurrentViewIndex
                    ActiveItemIndex = $ActiveItemIndex
                    ShiftIndex      = $shiftIndex
                }
                $CurrentViewIndex = Invoke-GumpShift @shiftParam

                <#
                line -> currentviewindex -> showitems -> content
                #>
                #render all lines.. current view items index..
                $IShift = 0
                for ($i = 0; $i -lt $view.Height; $i++) {
                    $itemIndex = $CurrentViewIndex[$i + $IShift]
                    
                    $isAtTop = $AllItemsIndex.IndexOf($AllItemsIndex[$itemIndex]) -eq 0
                    $isAtbottom = $AllItemsIndex.IndexOf($AllItemsIndex[$itemIndex]) -eq $AllItemsIndex.IndexOf($AllItemsIndex[-1])

                    if ($LimitedView)
                    {
                        if($i -eq 0 -and $AllItemsIndex.IndexOf($AllItemsIndex[$itemIndex]) -eq 0){
                            $itemsAboveCount = $AllItemsIndex.IndexOf($AllItemsIndex[$itemIndex])
                            $content = "   ...$itemsAboveCount..."
                            #get count of how many items there are in between the first item of currentviewindex and the first item of allitemsindex
                            $count = $CurrentViewIndex[0] - $AllItemsIndex[0]
                            Set-GumpConsoleZone -Name 'view' -Content "...$count..." -StartIndex $i
                            $IShift = -1
                            continue
                        }
                    }

                    $Line = $($showItems.where{$_.id -eq $itemIndex}).content
                    
                }

                for ($i = 0; $i -lt $CurrentViewIndex.Count; $i++) {
                    $itemIndex = $CurrentViewIndex[$i]
                    $Line = $($showItems.where{$_.id -eq $i}).content

                    #either write line wouthout selector and color or write one with
                    $prepend = $reset + "  "
                    if ($itemIndex -eq $NextActiveItemIndex) {
                        $prepend = $SelectionColor + "$SelectChar " 
                    }

                    if ($multiSelect) {
                        $prepend += $MultiselectStates[([int]$Choices.Contains($itemIndex))]
                        $prepend += " " 
                    }
                    $OutputLine = $prepend + $line

                    Set-GumpConsoleZone -Name 'view' -Content $OutputLine -StartIndex $i
                }

                if ($LimitedView) {
                    $prepend = "   "
                    # if ($multiSelect) { $prepend += "   " }
                    #set top dots if min index is not viewed
                    if ($CurrentViewIndex[0] -ne 0) {
                        Set-GumpConsoleZone -name 'view' -Content "$prepend...$($CurrentViewIndex[0] - 1)..." -StartIndex 0
                        # write-GumpConsole -y $ViewTop -Text "$prepend..."
                    }
                    
                    #set bottom dots if max index is not viewed
                    if ($CurrentViewIndex[-1] -ne $AllItemsIndex[-1]) {
                        Set-GumpConsoleZone -name 'view' -Content "$prepend...$($AllItemsIndex[-1] - $CurrentViewIndex[-1])..." -StartIndex ($CurrentViewIndex.count - 1)
                        # write-GumpConsole -y $ViewBottom -Text "$prepend..."
                    }
                }
                
                $ActiveItemIndex = $NextActiveItemIndex
                Update-GumpConsole

                $shiftIndex = 0
                Set-GumpConsoleZone -Name 'verbose' -Content "cur:$ActiveItemIndex v_index:$($CurrentViewIndex[0])..$($CurrentViewIndex[-1]) shift:$shiftIndex; filter:$FilterText; items:$($showItems.count)"
                Update-GumpConsole

                $KeyPress = [Console]::ReadKey("NoEcho,IncludeKeyDown")
                Set-GumpConsoleZone -Name 'verbose' -Content "key:$($KeyPress.key)/$($keypress.KeyChar)  cur:$ActiveItemIndex v_index:$($CurrentViewIndex[0])..$($CurrentViewIndex[-1]) shift:$shiftIndex; filter:$FilterText"
                Update-GumpConsole

                switch ($KeyPress) {
                    { Confirm-GumpConsoleKey -Keypress $_ -Keys a-z, '*' } {
                        if (!$EnableFilter) {
                            break
                        }

                        $FilterText = "$FilterText$($keypress.KeyChar)"
                        $disableEnter = $true
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys backspace) {
                        if (!$EnableFilter) {
                            break
                        }

                        if ($FilterText.length -gt 0) {
                            $FilterText = $FilterText.Substring(0, $FilterText.length - 1 )
                        }
                        $disableEnter = $true
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys escape) { 
                        $Canceled = $true 
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys spacebar) {
                        if (!$multiSelect) { break }

                        if ($Choices.Contains($ActiveItemIndex)) {
                            $Choices = $Choices -ne $ActiveItemIndex
                            $MultiSelectCounter++
                        }
                        elseif ($MultiSelectCounter -eq 0) { 
                            break 
                        }
                        else {
                            $Choices += $ActiveItemIndex
                            $MultiSelectCounter--
                        }
                        break
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys enter) {
                        if ($disableEnter) {
                            $disableEnter = $false
                            break
                        }
                        if (!$multiSelect) {
                            $Choices += $ActiveItemIndex
                        }
                        $Complete = $true 
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys upArrow) {
                        $shiftIndex = -1
                        #returns the largest of two numbers. makes sure the index is never under 0
                        $NextActiveItemIndex = [math]::Max(0, ($ActiveItemIndex - 1))
                    }
                    (Confirm-GumpConsoleKey -Keypress $_ -Keys downArrow) {
                        $shiftIndex = 1
                        #returns the smallest of two numbers. makes sure the index is never above max of item index
                        $NextActiveItemIndex = [math]::Min(($Items.count - 1), ($ActiveItemIndex + 1))
                    }
                }
            }while ($complete -eq $false -and $canceled -eq $false)

            #update selected items 
            $Choices = $Choices | Select-Object -Unique | Sort-Object
        }
        catch {
            $err = $_
        }
        finally {
            Set-GumpConsoleModes -Modes EnableCursor

            # go to top of menu, and clear everything below that on screen
            write-GumpConsole -y $Top -Text "`e[0J"

            if ($err) {
                throw $err
            }
    
            $Choices | % {
                Write-Output ([ChoiceReturn]::new($Items, $_, $Complete, $Canceled))
            }
        }
    }
}

# get-process|Invoke-GumpChoice -Message "Select a process" -select name -EnableFilter -verbose