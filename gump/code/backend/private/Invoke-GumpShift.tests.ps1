#make pester tests for Invoke-GumpShift
Describe "Invoke-GumpShift" {
    Context "shift down" {
        It "shifts down when the active item is not on the halfway point" {
            $allitems = 0..10
            $viewItems = 1..5
            $activeitem = 2
            $shift = 1
            $viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
            $viewItems | Should -Be (1..5)
        }
        It "shifts down when the active item is on the halfway point" {
            $allitems = 0..10
            $viewItems = 1..5
            $activeitem = 3
            $shift = 1
            $viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
            $viewItems | Should -Be (2..6)
        }
    }
    Context "shift up" {
        It "does not shift up when the active item is not on the halfway point" {
            $allitems = 0..10
            $viewItems = 2..6
            $activeitem = 2
            $shift = -1
            $viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
            $viewItems | Should -Be (2..6)
        }
        It "shifts up when the active item is on the halfway point" {
            $allitems = 0..10
            $viewItems = 2..6
            $activeitem = 4
            $shift = -1
            $viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
            $viewItems | Should -Be (1..5)
        }
        It "does not shift up when already at the top" {
            $allitems = 0..10
            $viewItems = 0..4
            $activeitem = 3
            $shift = -1
            $viewItems = Invoke-GumpShift -AllIndexArray $allitems -ViewIndexArray $viewItems -ActiveItemIndex $activeitem -ShiftIndex $shift
            $viewItems | Should -Be (0..4)
        }
    }

}