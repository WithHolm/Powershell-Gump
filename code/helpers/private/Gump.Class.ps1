using namespace System
using namespace System.Drawing
using namespace System.Collections.Generic

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
    [bool]$Resized
    [GumpStreamType]$StreamType
    [int[]]$y = [int[]]::new(2)
    [List[string]]$Content = [List[string]]::new()
    [List[string]]$Active = [List[String]]::new()
}