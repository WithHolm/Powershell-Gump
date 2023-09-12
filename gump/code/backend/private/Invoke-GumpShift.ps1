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
#shifting down, and nothing is happening, because the active item is not on the halfway point (3)
$allitems = 0..10
$viewItems = 1..5
$activeitem = 2
$shift = 1
$viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
# $viewItems = 1,2,3,4,5

.EXAMPLE
#shifting down, and returning 1..6 because the active item is on the halfway point (3)
$allitems = 0..10
$viewItems = 1..5
$activeitem = 3
$shift = 1
$viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
# $viewItems = 2,3,4,5,6

.EXAMPLE
#shifting up and nothin is happening because im already at the top
$allitems = 0..10
$viewItems = 0..4
$activeitem = 3
$shift = -1
$viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
# $viewItems = 0,1,2,3,4

.NOTES
General notes
#This function is designed to shift the view of items in a list. It is not designed to actually move the items. 
#It is used in the Gump shell, in the "gump list" command. It is used to shift the view of items in a list, 
#so that the user can view different items in the list. For example, if a list contains 10 items, and the user
#wants to view items 5 through 9, then the user can do that. If the user wants to view items 7 through 11, 
#then this function is used to shift the view to that. This is so the user can view different items in the list,
#without having to scroll up or down.
#>

function Invoke-GumpShift {
    param(
        [parameter(Mandatory)]
        [array]$AllIndexArray,

        [parameter(Mandatory)]
        [array]$ViewIndexArray,

        [int]$ActiveItemIndex,

        [parameter(Mandatory)]
        [int]$ShiftIndex
    )

    #if im supposed to shift the view, so a new item appears at bottom or top (depending on direction),
    #i want to make sure the current view does NOT include the 'min' index of all items (almost always 0..),
    #I also want to make sure the last item of current view is NOT the 'max' index of all items (ie if i got delivered 5 items, the last index would be 4)

    #we want to avoid out of bounds items:
    # index with || view = 0|1234|5 -> viewing item 0,1,2,3,4. 0 and 5 is not in view
    # going up =   | 012|345 -> getting index below min (-1)
    # going down =  012|345 | -> getting index above max (0)
    #if the shift index is 0, we're doing nothing
    if ($ShiftIndex -eq 0) {
        return $ViewIndexArray
    }

    #if the shift index is -1, we're shifting up
    if ($ShiftIndex -lt 0) {
        #if 0 index of current view is not the same as 0 index of all item.. 
        #in essence that i can actually shift up
        if ($ViewIndexArray[0] -eq $AllIndexArray[0]) {
            return $ViewIndexArray
        }
    }

    #if the shift index is 1, we're shifting down
    if ($ShiftIndex -lt 0) {
        #if -1 index of current view is not the same as -1 index of all item.. 
        #in essence that i can actually shift down
        if ($ViewIndexArray[-1] -eq $AllIndexArray[-1]) {
            return $ViewIndexArray
        }
    }
   
    if ($ActiveItemIndex) {
        #if selected item is on the halfway point between view top and bottom
        #0..10 = 5,5=~5
        $MidpointIndex = [math]::Round(($ViewIndexArray | Measure-Object -Average).Average, [MidpointRounding]::ToZero)
        if ($ActiveItemIndex -ne $midpointIndex) {
            return $ViewIndexArray
        }
    }

    #return shifted view
    return $AllIndexArray[($ViewIndexArray[0] + $shiftIndex)..($ViewIndexArray[-1] + $shiftIndex)]
}