using namespace System
using namespace System.Drawing
using namespace System.Collections.Generic

$Global:GumpZones = [ordered]@{}
$global:Gump_debug = $false
$global:gump_supportsAnsi = $false




























<#function Confirm-GumpConsoleKey {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [ValidateSet(
            'a-z',
            'æ-å',
            '*',
            'backspace',
            'upArrow',
            'downArrow',
            'enter',
            'escape',
            'spacebar'
        )]
        [string[]]$Keys,
        [ConsoleKeyInfo]$Keypress
    )

    $test = $false
    switch ($Keys) {
        { $test -eq $true } {
            break
        }
        'a-z' {
            $test = ($Keypress.Key -in ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' | ForEach-Object { [ConsoleKey]$_ }))
            break
        }
        '*' {
            $test = ($Keypress.KeyChar -eq '*')
            break
        }
        'æ-å' {
            $test = ($Keypress.keychar -in ('æ', 'ø', 'å' | ForEach-Object { [ConsoleKey]$_ }))
            break
        }
        default {
            $test = ($Keypress.key -eq [ConsoleKey]$_)
            break
        }
    }
    if (!$test) {
        return $false
    }
    return $keypress
    
}
#>


<# function Get-GumpChoice {
#     [CmdletBinding()]
#     [OutputType([ChoiceReturn])]
#     param (
#         [parameter(
#             ValueFromPipeline
#         )]
#         $InputItem,
#         $Select,
#         [string]$Message,
#         [switch]$EnableFilter,
#         [GumpColor]$ChoiceColor = [GumpColor]::DarkSalmon,
#         [ValidateNotNullOrEmpty()]
#         [ValidateLength(1, 1)]
#         [char]$SelectChar = ">",
#         [int]$MaxChoices = 1,
#         [switch]$DisableHelp
#     )
#     begin {
#         # $Tui = [GumpTui]::new()
#         $reset = (Get-GumpAnsiSequence)

#         #color of selector and line currently active
#         $SelectionColor = Get-GumpAnsiSequence -ForegroundColor $ChoiceColor
#         $SearchColor = Get-GumpAnsiSequence -ForeGroundColor BurlyWood

#         #items to list
#         # $items = @{}
#         $items = [Collections.Generic.List[hashtable]]::new()
#     }
#     process {
#         Foreach ($it in $InputItem) {
#             # $items.$($items.Count) = ($it | Select-Object -ExpandProperty $select).ToString()
#             $items.Add(
#                 @{
#                     id      = $items.Count
#                     content = ($it | Select-Object -ExpandProperty $select).ToString()
#                 }
#             )
#         }
#     }
    
#     end {
#         try {
#             #region init
#             #remove console cursor
#             Set-GumpConsoleModes -Modes DisableCursor

#             #figure out the space requred for the tui
#             New-GumpConsoleZone -Name 'ViewTop' -Height 2 -Init
#             if ($EnableFilter) {
#                 New-GumpConsoleZone -Name 'Filter' -Height 1
#             }
#             New-GumpConsoleZone -Name 'view' -Height $items.count -Resizable -MinHeight 5
#             New-GumpConsoleZone -Name 'help' -Height 1 
#             New-GumpConsoleZone -Name 'verbose' -Height 1 -StreamType verbose
#             Initialize-GumpConsoleZones

#             $view = Get-GumpConsoleZone -Name 'View' -ThrowIfNull
            
#             $ViewTop = $view.y[0]
#             $ViewBottom = $view.y[1]

#             #set items that can be viewed
#             $AllItemsIndex = @(0..($items.count - 1))
#             $CurrentViewIndex = @(0 .. $($ViewBottom - $viewTop))
            
#             #set options for multiselect
#             $multiSelect = $MaxChoices -ne 1
#             $MultiselectStates = @("[ ]", "[X]")
#             $MultiSelectCounter = $MaxChoices

#             if (!$DisableHelp) {
#                 $HelpOptions = "Enter", "Esc", "Up/Down"
#                 if ($multiSelect) {
#                     $HelpOptions += "Space"
#                 }
                
#                 Write-GumpTip -help $HelpOptions -Zone 'help'
#             }

#             #while choice is being made
#             $LimitedView = $view.Height -lt $items.Count

#             #choices that are made by user, as index
#             $Choices = @()

#             #choice completed
#             $Complete = $false
            
#             #choice canceled
#             $Canceled = $false

#             # #next active item in index (user has pressed down/up)
#             $NextActiveItemIndex = 0
#             $ActiveItemIndex = 0
#             $shiftIndex = 0
#             $FilterText = ""
#             $showItems = $items
#             #init empty array to get what was shown last frame. decides if i should update this line again or not. saves rendering
#             # $LastViewArray = [string[]]::new($CurrentViewIndex.Count)

#             #endregion
#             do {
#                 $HelpMessage = $Message
#                 if ($multiSelect) {
#                     $HelpMessage += " ($MultiSelectCounter selections left)"
#                 }
#                 Set-GumpConsoleZone -Name 'viewTop' -Content @($HelpMessage, "----------")

#                 if ($EnableFilter) {
#                     Set-GumpConsoleZone -Name 'Filter' -Content "filter ('*' for wildcard): $FilterText"
#                     $Flt = $FilterText
#                 }
                
#                 if ($FilterText -eq '') {
#                     $Flt = "*"
#                 }

#                 $showItems = $Items.Where{ $_ -like $Flt }


#                 $LimitedView = $CurrentViewIndex.count -ne $showItems.Count
#                 $AllItemsIndex = @(0..($showItems.count - 1))

#                 #figure if if i need to shift my viewed items, incase there are more items avalible then i can show (limited view)
#                 $shiftParam = @{
#                     AllIndexArray   = $AllItemsIndex
#                     ViewIndexArray  = $CurrentViewIndex
#                     ActiveItemIndex = $ActiveItemIndex
#                     ShiftIndex      = $shiftIndex
#                 }
#                 $CurrentViewIndex = Invoke-GumpShift @shiftParam

#                 #render all lines.. current view items index..
#                 for ($i = 0; $i -lt $CurrentViewIndex.Count; $i++) {
#                     $itemIndex = $CurrentViewIndex[$i]
#                     $Line = $($items[$itemIndex])

#                     #either write line wouthout selector and color or write one with
#                     $prepend = $reset + "  "
#                     if ($itemIndex -eq $NextActiveItemIndex) {
#                         $prepend = $SelectionColor + "$SelectChar " 
#                     }

#                     if ($multiSelect) {
#                         $prepend += $MultiselectStates[([int]$Choices.Contains($itemIndex))]
#                         $prepend += " " 
#                     }
#                     $OutputLine = $prepend + $line

#                     Set-GumpConsoleZone -Name 'view' -Content $OutputLine -StartIndex $i
#                 }

#                 if ($LimitedView) {
#                     $prepend = "   "
#                     # if ($multiSelect) { $prepend += "   " }
#                     #set top dots if min index is not viewed
#                     if ($CurrentViewIndex[0] -ne 0) {
#                         Set-GumpConsoleZone -name 'view' -Content "$prepend...$($CurrentViewIndex[0] - 1)..." -StartIndex 0
#                         # write-GumpConsole -y $ViewTop -Text "$prepend..."
#                     }
                    
#                     #set bottom dots if max index is not viewed
#                     if ($CurrentViewIndex[-1] -ne $AllItemsIndex[-1]) {
#                         Set-GumpConsoleZone -name 'view' -Content "$prepend...$($AllItemsIndex[-1] - $CurrentViewIndex[-1])..." -StartIndex ($CurrentViewIndex.count - 1)
#                         # write-GumpConsole -y $ViewBottom -Text "$prepend..."
#                     }
#                 }
                
#                 $ActiveItemIndex = $NextActiveItemIndex
#                 Update-GumpConsole

#                 $shiftIndex = 0
#                 $KeyPress = [Console]::ReadKey("NoEcho,IncludeKeyDown")
#                 Set-GumpConsoleZone -Name 'verbose' -Content "key:$($KeyPress.key)/$($keypress.KeyChar)  cur:$ActiveItemIndex v_index:$($CurrentViewIndex[0])..$($CurrentViewIndex[-1]) shift:$shiftIndex; filter:$FilterText"
#                 Update-GumpConsole

#                 switch ($KeyPress) {
#                     { Confirm-GumpConsoleKey -Keypress $_ -Keys a-z, '*' } {
#                         if (!$EnableFilter) {
#                             break
#                         }

#                         $FilterText = "$FilterText$($keypress.KeyChar)"
#                         $disableEnter = $true
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys backspace) {
#                         if (!$EnableFilter) {
#                             break
#                         }

#                         if ($FilterText.length -gt 0) {
#                             $FilterText = $FilterText.Substring(0, $FilterText.length - 1 )
#                         }
#                         $disableEnter = $true
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys escape) { 
#                         $Canceled = $true 
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys spacebar) {
#                         if (!$multiSelect) { break }

#                         if ($Choices.Contains($ActiveItemIndex)) {
#                             $Choices = $Choices -ne $ActiveItemIndex
#                             $MultiSelectCounter++
#                         }
#                         elseif ($MultiSelectCounter -eq 0) { 
#                             break 
#                         }
#                         else {
#                             $Choices += $ActiveItemIndex
#                             $MultiSelectCounter--
#                         }
#                         break
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys enter) {
#                         if ($disableEnter) {
#                             $disableEnter = $false
#                             break
#                         }
#                         if (!$multiSelect) {
#                             $Choices += $ActiveItemIndex
#                         }
#                         $Complete = $true 
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys upArrow) {
#                         $shiftIndex = -1
#                         #returns the largest of two numbers. makes sure the index is never under 0
#                         $NextActiveItemIndex = [math]::Max(0, ($ActiveItemIndex - 1))
#                     }
#                     (Confirm-GumpConsoleKey -Keypress $_ -Keys downArrow) {
#                         $shiftIndex = 1
#                         #returns the smallest of two numbers. makes sure the index is never above max of item index
#                         $NextActiveItemIndex = [math]::Min(($Items.count - 1), ($ActiveItemIndex + 1))
#                     }
#                 }
#             }while ($complete -eq $false -and $canceled -eq $false)

#             #update selected items 
#             $Choices = $Choices | Select-Object -Unique | Sort-Object
#         }
#         catch {
#             $err = $_
#         }
#         finally {
#             Set-GumpConsoleModes -Modes EnableCursor

#             # go to top of menu, and clear everything below that on screen
#             write-GumpConsole -y $Top -Text "`e[0J"

#             if ($err) {
#                 throw $err
#             }
    
#             $Choices | % {
#                 Write-Output ([ChoiceReturn]::new($Items, $_, $Complete, $Canceled))
#             }
#         }
#     }
# }
#>


# if (!$global:services) {
#     $global:services = get-service -ea SilentlyContinue 
# }
# $global:services | Get-GumpChoice -select Name -MaxChoices 3 -message 'select correct service' -verbose -EnableFilter


# $allitems = 0..10
# $viewItems = 1..5
# $activeitem = 3
# $shift = 1
# Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift