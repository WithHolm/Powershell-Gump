using namespace System
using namespace System.Drawing
using namespace System.Collections.Generic

$Global:Zones = [ordered]@{}
$global:Gump_debug = $false

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

Enum GumpStreamType{
    host
    verbose
    debug
    warning
    error
}

class GumpConsoleZone {
    [string]$Name
    [int]$index = $Global:Zones.count
    [int]$MaxHeight
    [int]$Height
    [int]$MinHeight
    [bool]$Resizable
    [GumpStreamType]$StreamType
    [int[]]$y = [int[]]::new(2)
    [List[string]]$Content = [List[string]]::new()
    [List[string]]$Active = [List[String]]::new()
}

Enum GumpColor {
    Transparent
    AliceBlue
    AntiqueWhite
    Aquamarine
    Azure
    Beige
    Bisque
    Black
    BlanchedAlmond
    Blue
    BlueViolet
    Brown
    BurlyWood
    CadetBlue
    Chartreuse
    Chocolate
    Coral
    CornflowerBlue
    Cornsilk
    Crimson
    Cyan
    DarkBlue
    DarkCyan
    DarkGoldenrod
    DarkGray
    DarkGreen
    DarkKhaki
    DarkOliveGreen
    DarkOrange
    DarkOrchid
    DarkRed
    DarkSalmon
    DarkSeaGreen
    DarkSlateBlue
    DarkSlateGray
    DarkTurquoise
    DarkViolet
    DeepPink
    DeepSkyBlue
    DimGray
    DodgerBlue
    Firebrick
    FloralWhite
    ForestGreen
    Gainsboro
    GhostWhite
    Gold
    Goldenrod
    Gray
    Green
    GreenYellow
    Honeydew
    HotPink
    IndianRed
    Indigo
    Ivory
    Khaki
    LavenderBlush
    LawnGreen
    LemonChiffon
    LightBlue
    LightCoral
    LightCyan
    LightGoldenrodYellow
    LightGreen
    LightGray
    LightPink
    LightSalmon
    LightSeaGreen
    LightSkyBlue
    LightSlateGray
    LightSteelBlue
    LightYellow
    Lime
    LimeGreen
    Linen
    Maroon
    MediumAquamarine
    MediumBlue
    MediumOrchid
    MediumPurple
    MediumSeaGreen
    MediumSlateBlue
    MediumSpringGreen
    MediumTurquoise
    MediumVioletRed
    MidnightBlue
    MintCream
    MistyRose
    Moccasin
    NavajoWhite
    Navy
    OldLace
    Olive
    Orange
    OrangeRed
    Orchid
    PaleGoldenrod
    PaleGreen
    PaleTurquoise
    PaleVioletRed
    PapayaWhip
    PeachPuff
    Peru
    Pink
    Plum
    PowderBlue
    Purple
    RebeccaPurple
    Red
    RosyBrown
    RoyalBlue
    SaddleBrown
    Salmon
    SandyBrown
    SeaGreen
    SeaShell
    SkyBlue
    SlateBlue
    SlateGray
    Snow
    SpringGreen
    SteelBlue
    Tan
    Teal
    Thistle
    Tomato
    Turquoise
    Violet
    Wheat
    White
    WhiteSmoke
    Yellow
    YellowGreen
}

function Test-GumpAnsi {
    param()
    # Powershell ISE don't support ANSI, and this test will print ugly chars there
    if ($host.PrivateData.ToString() -eq 'Microsoft.PowerShell.Host.ISE.ISEOptions') {
        return $false;
    }

    # To test is console supports ANSI, we will print an ANSI code
    # and check if cursor postion has changed. If it has, ANSI is not
    # supported
    $oldPos = $host.UI.RawUI.CursorPosition.X

    Write-Host -NoNewline "$([char](27))[0m" -ForegroundColor ($host.UI.RawUI.BackgroundColor);

    $pos = $host.UI.RawUI.CursorPosition.X

    if ($pos -eq $oldPos) {
        return $true;
    }
    else {
        # If ANSI is not supported, let's clean up ugly ANSI escapes
        Write-Host -NoNewLine ("`b" * 4)
        return $false
    }
}
# $Script:HasAnsi = Test-GumpAnsi

# class GumpConsoleSpaceZone {
#     [int]$Height
#     [int]$Top
#     [int]$bottom
#     GumpConsoleSpaceZone([int]$Height) {
#         $this.Height = $Height
#     }
#     #sets top and bottom from the avalible y position. returns the next avalible line
#     #if you only need 1 line and you get y=0, return y=1
#     [int]SetScope([int]$Y) {
#         if ($this.heigh -eq 0) {
#             return $y
#         }
#         $this.Top = $y
#         $this.bottom = $y + $this.Height
#         return ($this.bottom + 1)
#     }
# }


#borrowed from ecsousa/PSColors. really nice check
#fixed 


function Get-GumpAnsiSequence {
    [CmdletBinding()]
    param (
        [GumpColor]$ForegroundColor,
        [GumpColor]$BackGroundColor,
        [ValidateSet(
            'Bold',
            'Underline',
            'Italic',
            'strikethrough',
            "Blink"
        )]
        [string[]]$Mode
    )
    
    begin {
        #i dont really reset
    }
    
    process {
        $typeMap = @{
            Foreground = 38
            Background = 48
        }

        if (!$ForegroundColor -and !$BackGroundColor -and !$Mode) {
            return "`e[0m"
        }

        # $Color = ""
        $modes = @()
        if ($ForegroundColor) {
            $color = [color]::FromName($ForegroundColor.ToString())
            $modes += "38;2;{0};{1};{2}" -f $Color.R, $Color.G, $Color.B
        }

        if ($BackGroundColor) {
            $color = [color]::FromName($BackGroundColor.ToString())
            $modes += "48;2;{0};{1};{2}" -f $Color.R, $Color.G, $Color.B
        }

        switch ($Mode) {
            'Bold' {
                $modes += '1'
            }
            'Underline' {
                $modes += '4'
            }
            'Italic' {
                $modes += '3'
            }
            'strikethrough' {
                $modes += '9'
            }
            'Blink' {
                $modes += '5'
            }
        }
        # $modes = $modes|?{$_}
        return "`e[$($modes -join ";")`m"
    }
    
    end {
    }
}

function Write-GumpTip {
    [CmdletBinding()]
    param (
        [ValidateSet(
            'Up/Down',
            'Esc',
            'Enter',
            'Space'
        )]
        [string[]]$Help,
        [int]$Y = [Console]::GetCursorPosition().Item2,
        [string]$Zone
    )
    
    begin {
        # if ($Zone) {
        #     $Y = (Get-GumpConsoleZone -Name $zone -ThrowIfNull).y[0]
        # }
        $color = @{
            Reset     = Get-GumpAnsiSequence
            UpDown    = Get-GumpAnsiSequence -ForeGroundColor DarkTurquoise
            LeftRight = (Get-GumpAnsiSequence -ForeGroundColor BlueViolet)
            Esc       = Get-GumpAnsiSequence -ForeGroundColor Tomato
            Enter     = Get-GumpAnsiSequence -ForeGroundColor MediumSpringGreen
            Space     = Get-GumpAnsiSequence -ForeGroundColor Coral
        }
    }
    
    process {
        $msg = @()
        switch ($help) {
            'Left/Right' { 
                $msg += "{0}Left/Right:Select " -f $color.UpDown, $color.Reset
            }
            'Up/Down' { 
                $msg += "{0}Up/Down:Select " -f $color.UpDown, $color.Reset
            }
            'Esc' { 
                $msg += "{0}Esc:Cancel " -f $color.Esc, $color.Reset
            }
            'Enter' { 
                $msg += "{0}Enter:Accept " -f $color.Enter, $color.Reset
            }
            'Space' { 
                $msg += "{0}Space:Choose " -f $color.Space, $color.Reset
            }
            Default {}
        }
        $msg += $color.Reset
        if ($Zone) {
            Set-GumpConsoleZone -Name $Zone -Content $($msg -join " ")
        }
        else {
            write-GumpConsole  -y $y -Text $($msg -join " ") -Type Host
        }
    }
    
    end {
        
    }
}

function write-GumpConsole {
    [CmdletBinding()]
    param (
        [int]$y,
        [string]$Text,
        [GumpStreamType]$Type = [GumpStreamType]::host
    )
    
    [console]::SetCursorPosition(0, $y)
    #add message to erase rest of line
    $text += "`e[0K"
    switch ($Type.tostring()) {
        'host' { Write-host $Text }
        'verbose' { Write-Verbose $Text }
        'debug' { Write-Debug $Text }
        'warning' { Write-Warning $Text }
        'error' { Write-error -Message $Text }
        Default {}
    }
}

#init console from global:zones
function Initialize-GumpConsoleZones {
    [CmdletBinding()]
    param (
        [Switch]$Clear
    )
    if ($Global:Zones.count -eq 0) {
        Throw "No zones added. please add zones before Initializing"
    }

    #find zone that is reziable
    $resizeKey = $Global:Zones.Keys.Where{ $Global:Zones.$_.Resizable }
    if (@($resizeKey).count -gt 1) {
        throw "There is more than one rezizable zone. can only handle 1 at the moment."
    }

    #max allowed space for the console 
    $ConsoleHeight = [console]::WindowHeight - 1

    #the height of all zones combined
    $AskingHeight = ($Global:Zones.Values | Measure-Object -sum MaxHeight).Sum

    #get either asked for height or whatever is avalible in console
    $UsingHeight = [math]::Min($AskingHeight, $ConsoleHeight)

    #Height left over 
    $StaticHeight = ($Global:Zones.values | Where-Object { $_.resizable -eq $false } | Measure-Object -Sum height).sum

    #if dynamic height is set
    if ($resizeKey) {
        $zone = Get-GumpConsoleZone -Name $resizeKey
        $NewHeight = ($UsingHeight - $StaticHeight)

        #if the console is too small to fit the minimum value of the dynamic zone
        if ($NewHeight -lt $zone.MinHeight) {
            $Throw_TooSmall = $true
            $Throw_TooSmall_size = $($zone.MinHeight - $zone.Height)
        }
        else {
            $zone.Height = $NewHeight
        }
    }
    #if only static height is set and the console is too small
    elseif ($StaticHeight -gt $UsingHeight) {
        $Throw_TooSmall = $true
        $Throw_TooSmall_size = $StaticHeight - $UsingHeight
    }

    if ($Throw_TooSmall) {
        Throw "Your console is too small to fit the view i want to show you. please resize you your console and try again (missing $Throw_TooSmall_size console lines)"
    }

    if ($Clear) {
        Clear-Host
    }

    <#
    do the actual thing
    write host with empty all the lines you want, 
    get the lowest Y on the console (IE highest number (top is 0, bottom is not 0)), 
    go up through the zones (starting at highest index), divide up adding the Y range to each zone, until you get the y under where you started the script from
    1 zone1 - 2 lines
    2 zone1
    3 zone2 - 3 lines
    4 zone2
    5 zone2 <- Starte here, and go up adding 3,5 to zone.y 
    #>
    # [console]::SetCursorPosition(0,([Console]::GetCursorPosition().Item2 - 1 ))
    1..$UsingHeight | % {
        if ($global:Gump_debug) {
            Write-host "kk > $_"
        }
        else {
            Write-host ""
        }
    }
    # $Global:Zones.keys[($Global:Zones.count-1)..0]

    $zone_keys_desc = $Global:Zones.keys[($Global:Zones.count - 1)..0]

    $currentY = [Console]::GetCursorPosition().Item2
    foreach ($ZoneName in $zone_keys_desc ) {
        #since the zone map is ordered i know that index 0 is the first item i added to zones 
        $zone = Get-GumpConsoleZone -Name $ZoneName
        if ($zone.Height -eq 0) {
            continue
        }
        1..($zone.Height) | % {
            $y = $currentY - $_
            if ($global:Gump_debug) {
                write-GumpConsole -y $y -Text "$y - $_ $ZoneName $($zone.Height)"
            }
            $zone.Content.Add("")
            $zone.Active.Add("")
        }
        #set top of zone
        $zone.y[0] = $y

        #set bottom of zone
        $zone.y[1] = $currentY - 1


        # $zone.Content = 

        if ($global:Gump_debug) {
            write-GumpConsole -y $y -Text "$y - $($zone.Height) $ZoneName $($zone.Height) -> $($zone.y -join ",")"
        }

        $currentY = $y
    }
    #go to bottom
    [console]::SetCursorPosition(0, ($Global:Zones[$zone_keys_desc[0]].y[1] + 1 ))
}

#add zones to console
function New-GumpConsoleZone {
    [CmdletBinding()]
    param(
        [string]$Name,
        [int]$Height,
        [int]$MinHeight = 0,
        [switch]$Resizable,
        [GumpStreamType]$StreamType = 'host',
        [switch]$Init
    )
    if ($Init) {
        $Global:Zones = [ordered]@{}
    }
    $Key = $Name
    # if ($Resizable) {
    #     $key = "_$name"
    # }
    $Global:Zones.$key = [GumpConsoleZone]@{
        Name       = $key
        index      = $Global:Zones.count
        MaxHeight  = $Height
        Height     = $Height
        MinHeight  = $MinHeight
        Resizable  = $Resizable
        StreamType = $StreamType
        y          = ([int[]]::new(2))
        Content    = ([List[string]]::new())
        Active     = ([List[String]]::new())
    }
    
    if ($Resizable) {
        $Global:Zones.$key.Height = 0
    }
}

function Get-GumpConsoleZone {
    [CmdletBinding()]
    [Outputtype('GumpConsoleZone')]
    param(
        [parameter(Mandatory)]
        [string]$Name,

        [switch]$ThrowIfNull
    )
    if ($ThrowIfNull -and !$Global:Zones.Contains($name)) {
        throw "Could not find zone with name '$name'"
    }
    return $Global:Zones.$name
}

function Update-GumpConsole {
    [CmdletBinding()]
    param ()
    
    foreach ($Name in $Global:Zones.Keys) {
        $Zone = Get-GumpConsoleZone -Name $Name
    
        for ($i = 0; $i -lt $zone.Content.Count; $i++) {
            $Content = $zone.Content[$i]

            if (![string]::Equals($Content, $zone.Active[$i])) {
                write-GumpConsole -y ($zone.y[0] + $i) -Text $Content -Type $zone.StreamType
                $zone.Active[$i] = $Content
            }
        }
    }
}

function Set-GumpConsoleZone {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string[]]$Content,
        [int]$StartIndex = 0
    )
    
    begin {
        $Zone = Get-GumpConsoleZone -Name $Name -ThrowIfNull
    }
    process {
        0..($content.Count - 1) | % {
            $zoneContentIndex = $_ + $StartIndex
            $zone.Content[$zoneContentIndex] = $Content[$_]
        }
    }
}


<#
.SYNOPSIS
Takes a portion of a int array and figures out if its going to shift that array up or down

.DESCRIPTION
Takes a portion of a int array and figures out if its going to shift that array up or down depending on active item index and if one can actually shift up and down
going up =   |0123|45 -> 0|1234|5
going down =  0|1234|5 -> |0123|45

.PARAMETER AllIndexArray
int array of all items

.PARAMETER ViewIndexArray
int array of all items currently in view

.PARAMETER ActiveItemIndex
index of the active item

.PARAMETER ShiftIndex
-1 for up, +1 for down, 0 for nothing

.EXAMPLE
#shifting down, and nothing is happening
$allitems = 0..10
$viewItems = 1..5
$activeitem = 2
$shift = 1
Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift



.NOTES
General notes
#>
function Invoke-GumpShift {
    param(
        [int[]]$AllIndexArray,
        [int[]]$ViewIndexArray,
        [int]$ActiveItemIndex,
        [ValidateRange(-1, 1)]
        [int]$ShiftIndex
    )

    #if im supposed to shift the view, so a new item appears at bottom or top (depending on direction),
    #i want to make sure the current view does NOT include the 'min' index of all items (almost always 0..),
    #I also want to make sure the last item of current view is NOT the 'max' index of all items (ie if i got delivered 5 items, the last index would be 4)

    #we want to avoid out of bounds items:
    # index with || view = 0|1234|5 -> viewing item 0,1,2,3,4. 0 and 5 is not in view
    # going up =   | 012|345 -> getting index below min (-1)
    # going down =  012|345 | -> getting index above max (0)
    switch ($ShiftIndex) {
        #doing nothing
        0 { return $ViewIndexArray }
        #shifting up
        -1 {
            #if 0 index of current view is not the same as 0 index of all item.. 
            #in essence that i can actually shift up
            if ($CurrentViewIndex[0] -eq $AllItemsIndex[0]) {
                return $ViewIndexArray
            }
        }
        #shifting down
        1 {
            #if -1 index of current view is not the same as -1 index of all item.. 
            #in essence that i can actually shift down
            if ($CurrentViewIndex[-1] -eq $AllItemsIndex[-1]) {
                return $ViewIndexArray
            }
        }
    }
   
    #if selected item is on the halfway point between view top and bottom
    #0..10 = 5,5=~5
    $MidpointIndex = [math]::Round(($ViewIndexArray | Measure-Object -Average).Average, [MidpointRounding]::ToZero)
    if ($ActiveItemIndex -ne $midpointIndex) {
        return $ViewIndexArray
    }

    #return shifted view
    return $AllItemsIndex[($CurrentViewIndex[0] + $shiftIndex)..($CurrentViewIndex[-1] + $shiftIndex)]
}

function Set-GumpConsoleModes {
    param(
        [ValidateSet(
            'EnableCursor',
            'DisableCursor'
        )]
        [string[]]$Modes
    )

    switch ($Modes) {
        'EnableCursor' {
            [Console]::CursorVisible = $true
        }
        'DisableCursor' {
            [Console]::CursorVisible = $false
        }
    }
}

function Confirm-GumpConsoleKey {
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

function Get-GumpChoice {
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

        [int]$MaxChoices = 1,
        [switch]$DisableHelp
    )
    
    begin {
        # $Tui = [GumpTui]::new()
        $reset = (Get-GumpAnsiSequence)

        #color of selector and line currently active
        $SelectionColor = Get-GumpAnsiSequence -ForegroundColor $ChoiceColor
        $SearchColor = Get-GumpAnsiSequence -ForeGroundColor BurlyWood

        #items to list
        # $items = @{}
        $items = [Collections.Generic.List[hashtable]]::new()
    }
    
    process {
        Foreach ($it in $InputItem) {
            # $items.$($items.Count) = ($it | Select-Object -ExpandProperty $select).ToString()
            $items.Add(
                @{
                    id      = $items.Count
                    content = ($it | Select-Object -ExpandProperty $select).ToString()
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
            
            $ViewTop = $view.y[0]
            $ViewBottom = $view.y[1]

            #set items that can be viewed
            $AllItemsIndex = @(0..($items.count - 1))
            $CurrentViewIndex = @(0 .. $($ViewBottom - $viewTop))
            
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
            $LimitedView = $view.Height -lt $items.Count

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
                    Set-GumpConsoleZone -Name 'Filter' -Content "filter ('*' for wildcard): $FilterText"
                    $Flt = $FilterText
                }
                
                if ($FilterText -eq '') {
                    $Flt = "*"
                }

                $showItems = $Items.Where{ $_ -like $Flt }


                $LimitedView = $CurrentViewIndex.count -ne $showItems.Count
                $AllItemsIndex = @(0..($showItems.count - 1))

                #figure if if i need to shift my viewed items, incase there are more items avalible then i can show (limited view)
                $shiftParam = @{
                    AllIndexArray   = $AllItemsIndex
                    ViewIndexArray  = $CurrentViewIndex
                    ActiveItemIndex = $ActiveItemIndex
                    ShiftIndex      = $shiftIndex
                }
                $CurrentViewIndex = Invoke-GumpShift @shiftParam

                #render all lines.. current view items index..
                for ($i = 0; $i -lt $CurrentViewIndex.Count; $i++) {
                    $itemIndex = $CurrentViewIndex[$i]
                    $Line = $($items[$itemIndex])

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

function Get-GumpColors {
    $Stats = [enum]::GetNames([GumpColor]) | Measure-Object -Property length -AllStats

    $Screenwidth = [Console]::WindowWidth

    # $a.PadLeft(15, [char]4)
    foreach ($type in 'ForegroundColor', 'BackgroundColor') {
        $write = @()
        [enum]::GetNames([GumpColor]) | ForEach-Object {
            $param = @{
                $type = $_
            }
            $color = Get-GumpAnsiSequence @param

            #get difference between current color length and max color length
            $LengthDiff = $Stats.Maximum - $_.Length

            #get how many characters i can pad left 
            $LeftPad = [math]::Round($LengthDiff / 2, [System.MidpointRounding]::AwayFromZero)

            $msg = $_

            #pad left with length of str + pad i can add, 
            #then pad right to make sure that it fills
            $msg.padleft($LeftPad + $msg.Length).PadRight($Stats.Maximum)

            #color + msg with paddig + reset
            $write += ($color + $msg + (Get-GumpAnsiSequence))
        }




        #reset
        

        

        Write-Host $($write -join "")
    }

    # $Background = Get-GumpAnsiSequence -BackGroundColor $_
}
if (!$global:services) {
    $global:services = get-service -ea SilentlyContinue 
}
$global:services | Get-GumpChoice -select Name -MaxChoices 3 -message 'select correct service' -verbose -EnableFilter