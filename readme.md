# Tui


# Zones
To make figuring out the avalible space i need as easy as possible, i decided to use something i call zones:
a zone is just a space within the height of a console window, on the y axis (a write-host line essentially)
if you wanted to make a app that provided a list of items and let te user pick from one of them you would need the following:
- mabye some title/status? 1 line
- space to show your items (5-10 lines depending on how many elements you have)
- space to show some help. 1 line
- space for andy debug or verbose info. 1 line

this would be a total of 8 lines divided like this:
``` text
0 -> status
1 -> view start
2 -> 
3 -> 
4 -> 
5 -> view end
6 -> help
7 -> verbose
```

add a new zone to GumpTui by defining `.addzone($name,$height)`. 
when done, call `New-GumpTuiSpace` using the gumptui object as a input


## Colors

supports all default colors provided by `System.Drawing.Color`, currently these are:

Background                                                                     | Foreground                                              | Name                    | Ansi                  
------------------------------------------------------------------------------ | ------------------------------------------------------- | ----------------------- | ----------------------
<span style="background-color:rgb(180,180,180);color:black;">Background</span> | <span style="color:rgb(180,180,180);">Foreground</span> | ActiveBorder            | \033[48;2;180;180;180m
<span style="background-color:rgb(153,180,209);color:black;">Background</span> | <span style="color:rgb(153,180,209);">Foreground</span> | ActiveCaption           | \033[48;2;153;180;209m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | ActiveCaptionText       | \033[48;2;0;0;0m      
<span style="background-color:rgb(171,171,171);color:black;">Background</span> | <span style="color:rgb(171,171,171);">Foreground</span> | AppWorkspace            | \033[48;2;171;171;171m
<span style="background-color:rgb(240,240,240);color:black;">Background</span> | <span style="color:rgb(240,240,240);">Foreground</span> | Control                 | \033[48;2;240;240;240m
<span style="background-color:rgb(160,160,160);color:black;">Background</span> | <span style="color:rgb(160,160,160);">Foreground</span> | ControlDark             | \033[48;2;160;160;160m
<span style="background-color:rgb(105,105,105);color:white;">Background</span> | <span style="color:rgb(105,105,105);">Foreground</span> | ControlDarkDark         | \033[48;2;105;105;105m
<span style="background-color:rgb(227,227,227);color:black;">Background</span> | <span style="color:rgb(227,227,227);">Foreground</span> | ControlLight            | \033[48;2;227;227;227m
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | ControlLightLight       | \033[48;2;255;255;255m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | ControlText             | \033[48;2;0;0;0m      
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | Desktop                 | \033[48;2;0;0;0m      
<span style="background-color:rgb(109,109,109);color:white;">Background</span> | <span style="color:rgb(109,109,109);">Foreground</span> | GrayText                | \033[48;2;109;109;109m
<span style="background-color:rgb(0,120,215);color:white;">Background</span>   | <span style="color:rgb(0,120,215);">Foreground</span>   | Highlight               | \033[48;2;0;120;215m  
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | HighlightText           | \033[48;2;255;255;255m
<span style="background-color:rgb(0,102,204);color:white;">Background</span>   | <span style="color:rgb(0,102,204);">Foreground</span>   | HotTrack                | \033[48;2;0;102;204m  
<span style="background-color:rgb(244,247,252);color:black;">Background</span> | <span style="color:rgb(244,247,252);">Foreground</span> | InactiveBorder          | \033[48;2;244;247;252m
<span style="background-color:rgb(191,205,219);color:black;">Background</span> | <span style="color:rgb(191,205,219);">Foreground</span> | InactiveCaption         | \033[48;2;191;205;219m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | InactiveCaptionText     | \033[48;2;0;0;0m      
<span style="background-color:rgb(255,255,225);color:black;">Background</span> | <span style="color:rgb(255,255,225);">Foreground</span> | Info                    | \033[48;2;255;255;225m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | InfoText                | \033[48;2;0;0;0m      
<span style="background-color:rgb(240,240,240);color:black;">Background</span> | <span style="color:rgb(240,240,240);">Foreground</span> | Menu                    | \033[48;2;240;240;240m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | MenuText                | \033[48;2;0;0;0m      
<span style="background-color:rgb(200,200,200);color:black;">Background</span> | <span style="color:rgb(200,200,200);">Foreground</span> | ScrollBar               | \033[48;2;200;200;200m
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | Window                  | \033[48;2;255;255;255m
<span style="background-color:rgb(100,100,100);color:white;">Background</span> | <span style="color:rgb(100,100,100);">Foreground</span> | WindowFrame             | \033[48;2;100;100;100m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | WindowText              | \033[48;2;0;0;0m      
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | Transparent             | \033[48;2;255;255;255m
<span style="background-color:rgb(240,248,255);color:black;">Background</span> | <span style="color:rgb(240,248,255);">Foreground</span> | AliceBlue               | \033[48;2;240;248;255m
<span style="background-color:rgb(250,235,215);color:black;">Background</span> | <span style="color:rgb(250,235,215);">Foreground</span> | AntiqueWhite            | \033[48;2;250;235;215m
<span style="background-color:rgb(0,255,255);color:black;">Background</span>   | <span style="color:rgb(0,255,255);">Foreground</span>   | Aqua                    | \033[48;2;0;255;255m  
<span style="background-color:rgb(127,255,212);color:black;">Background</span> | <span style="color:rgb(127,255,212);">Foreground</span> | Aquamarine              | \033[48;2;127;255;212m
<span style="background-color:rgb(240,255,255);color:black;">Background</span> | <span style="color:rgb(240,255,255);">Foreground</span> | Azure                   | \033[48;2;240;255;255m
<span style="background-color:rgb(245,245,220);color:black;">Background</span> | <span style="color:rgb(245,245,220);">Foreground</span> | Beige                   | \033[48;2;245;245;220m
<span style="background-color:rgb(255,228,196);color:black;">Background</span> | <span style="color:rgb(255,228,196);">Foreground</span> | Bisque                  | \033[48;2;255;228;196m
<span style="background-color:rgb(0,0,0);color:white;">Background</span>       | <span style="color:rgb(0,0,0);">Foreground</span>       | Black                   | \033[48;2;0;0;0m      
<span style="background-color:rgb(255,235,205);color:black;">Background</span> | <span style="color:rgb(255,235,205);">Foreground</span> | BlanchedAlmond          | \033[48;2;255;235;205m
<span style="background-color:rgb(0,0,255);color:white;">Background</span>     | <span style="color:rgb(0,0,255);">Foreground</span>     | Blue                    | \033[48;2;0;0;255m    
<span style="background-color:rgb(138,43,226);color:white;">Background</span>  | <span style="color:rgb(138,43,226);">Foreground</span>  | BlueViolet              | \033[48;2;138;43;226m 
<span style="background-color:rgb(165,42,42);color:white;">Background</span>   | <span style="color:rgb(165,42,42);">Foreground</span>   | Brown                   | \033[48;2;165;42;42m  
<span style="background-color:rgb(222,184,135);color:black;">Background</span> | <span style="color:rgb(222,184,135);">Foreground</span> | BurlyWood               | \033[48;2;222;184;135m
<span style="background-color:rgb(95,158,160);color:black;">Background</span>  | <span style="color:rgb(95,158,160);">Foreground</span>  | CadetBlue               | \033[48;2;95;158;160m 
<span style="background-color:rgb(127,255,0);color:black;">Background</span>   | <span style="color:rgb(127,255,0);">Foreground</span>   | Chartreuse              | \033[48;2;127;255;0m  
<span style="background-color:rgb(210,105,30);color:white;">Background</span>  | <span style="color:rgb(210,105,30);">Foreground</span>  | Chocolate               | \033[48;2;210;105;30m 
<span style="background-color:rgb(255,127,80);color:black;">Background</span>  | <span style="color:rgb(255,127,80);">Foreground</span>  | Coral                   | \033[48;2;255;127;80m 
<span style="background-color:rgb(100,149,237);color:black;">Background</span> | <span style="color:rgb(100,149,237);">Foreground</span> | CornflowerBlue          | \033[48;2;100;149;237m
<span style="background-color:rgb(255,248,220);color:black;">Background</span> | <span style="color:rgb(255,248,220);">Foreground</span> | Cornsilk                | \033[48;2;255;248;220m
<span style="background-color:rgb(220,20,60);color:white;">Background</span>   | <span style="color:rgb(220,20,60);">Foreground</span>   | Crimson                 | \033[48;2;220;20;60m  
<span style="background-color:rgb(0,255,255);color:black;">Background</span>   | <span style="color:rgb(0,255,255);">Foreground</span>   | Cyan                    | \033[48;2;0;255;255m  
<span style="background-color:rgb(0,0,139);color:white;">Background</span>     | <span style="color:rgb(0,0,139);">Foreground</span>     | DarkBlue                | \033[48;2;0;0;139m    
<span style="background-color:rgb(0,139,139);color:white;">Background</span>   | <span style="color:rgb(0,139,139);">Foreground</span>   | DarkCyan                | \033[48;2;0;139;139m  
<span style="background-color:rgb(184,134,11);color:black;">Background</span>  | <span style="color:rgb(184,134,11);">Foreground</span>  | DarkGoldenrod           | \033[48;2;184;134;11m 
<span style="background-color:rgb(169,169,169);color:black;">Background</span> | <span style="color:rgb(169,169,169);">Foreground</span> | DarkGray                | \033[48;2;169;169;169m
<span style="background-color:rgb(0,100,0);color:white;">Background</span>     | <span style="color:rgb(0,100,0);">Foreground</span>     | DarkGreen               | \033[48;2;0;100;0m    
<span style="background-color:rgb(189,183,107);color:black;">Background</span> | <span style="color:rgb(189,183,107);">Foreground</span> | DarkKhaki               | \033[48;2;189;183;107m
<span style="background-color:rgb(139,0,139);color:white;">Background</span>   | <span style="color:rgb(139,0,139);">Foreground</span>   | DarkMagenta             | \033[48;2;139;0;139m  
<span style="background-color:rgb(85,107,47);color:white;">Background</span>   | <span style="color:rgb(85,107,47);">Foreground</span>   | DarkOliveGreen          | \033[48;2;85;107;47m  
<span style="background-color:rgb(255,140,0);color:black;">Background</span>   | <span style="color:rgb(255,140,0);">Foreground</span>   | DarkOrange              | \033[48;2;255;140;0m  
<span style="background-color:rgb(153,50,204);color:white;">Background</span>  | <span style="color:rgb(153,50,204);">Foreground</span>  | DarkOrchid              | \033[48;2;153;50;204m 
<span style="background-color:rgb(139,0,0);color:white;">Background</span>     | <span style="color:rgb(139,0,0);">Foreground</span>     | DarkRed                 | \033[48;2;139;0;0m    
<span style="background-color:rgb(233,150,122);color:black;">Background</span> | <span style="color:rgb(233,150,122);">Foreground</span> | DarkSalmon              | \033[48;2;233;150;122m
<span style="background-color:rgb(143,188,143);color:black;">Background</span> | <span style="color:rgb(143,188,143);">Foreground</span> | DarkSeaGreen            | \033[48;2;143;188;143m
<span style="background-color:rgb(72,61,139);color:white;">Background</span>   | <span style="color:rgb(72,61,139);">Foreground</span>   | DarkSlateBlue           | \033[48;2;72;61;139m  
<span style="background-color:rgb(47,79,79);color:white;">Background</span>    | <span style="color:rgb(47,79,79);">Foreground</span>    | DarkSlateGray           | \033[48;2;47;79;79m   
<span style="background-color:rgb(0,206,209);color:black;">Background</span>   | <span style="color:rgb(0,206,209);">Foreground</span>   | DarkTurquoise           | \033[48;2;0;206;209m  
<span style="background-color:rgb(148,0,211);color:white;">Background</span>   | <span style="color:rgb(148,0,211);">Foreground</span>   | DarkViolet              | \033[48;2;148;0;211m  
<span style="background-color:rgb(255,20,147);color:white;">Background</span>  | <span style="color:rgb(255,20,147);">Foreground</span>  | DeepPink                | \033[48;2;255;20;147m 
<span style="background-color:rgb(0,191,255);color:black;">Background</span>   | <span style="color:rgb(0,191,255);">Foreground</span>   | DeepSkyBlue             | \033[48;2;0;191;255m  
<span style="background-color:rgb(105,105,105);color:white;">Background</span> | <span style="color:rgb(105,105,105);">Foreground</span> | DimGray                 | \033[48;2;105;105;105m
<span style="background-color:rgb(30,144,255);color:white;">Background</span>  | <span style="color:rgb(30,144,255);">Foreground</span>  | DodgerBlue              | \033[48;2;30;144;255m 
<span style="background-color:rgb(178,34,34);color:white;">Background</span>   | <span style="color:rgb(178,34,34);">Foreground</span>   | Firebrick               | \033[48;2;178;34;34m  
<span style="background-color:rgb(255,250,240);color:black;">Background</span> | <span style="color:rgb(255,250,240);">Foreground</span> | FloralWhite             | \033[48;2;255;250;240m
<span style="background-color:rgb(34,139,34);color:white;">Background</span>   | <span style="color:rgb(34,139,34);">Foreground</span>   | ForestGreen             | \033[48;2;34;139;34m  
<span style="background-color:rgb(255,0,255);color:white;">Background</span>   | <span style="color:rgb(255,0,255);">Foreground</span>   | Fuchsia                 | \033[48;2;255;0;255m  
<span style="background-color:rgb(220,220,220);color:black;">Background</span> | <span style="color:rgb(220,220,220);">Foreground</span> | Gainsboro               | \033[48;2;220;220;220m
<span style="background-color:rgb(248,248,255);color:black;">Background</span> | <span style="color:rgb(248,248,255);">Foreground</span> | GhostWhite              | \033[48;2;248;248;255m
<span style="background-color:rgb(255,215,0);color:black;">Background</span>   | <span style="color:rgb(255,215,0);">Foreground</span>   | Gold                    | \033[48;2;255;215;0m  
<span style="background-color:rgb(218,165,32);color:black;">Background</span>  | <span style="color:rgb(218,165,32);">Foreground</span>  | Goldenrod               | \033[48;2;218;165;32m 
<span style="background-color:rgb(128,128,128);color:white;">Background</span> | <span style="color:rgb(128,128,128);">Foreground</span> | Gray                    | \033[48;2;128;128;128m
<span style="background-color:rgb(0,128,0);color:white;">Background</span>     | <span style="color:rgb(0,128,0);">Foreground</span>     | Green                   | \033[48;2;0;128;0m    
<span style="background-color:rgb(173,255,47);color:black;">Background</span>  | <span style="color:rgb(173,255,47);">Foreground</span>  | GreenYellow             | \033[48;2;173;255;47m 
<span style="background-color:rgb(240,255,240);color:black;">Background</span> | <span style="color:rgb(240,255,240);">Foreground</span> | Honeydew                | \033[48;2;240;255;240m
<span style="background-color:rgb(255,105,180);color:black;">Background</span> | <span style="color:rgb(255,105,180);">Foreground</span> | HotPink                 | \033[48;2;255;105;180m
<span style="background-color:rgb(205,92,92);color:white;">Background</span>   | <span style="color:rgb(205,92,92);">Foreground</span>   | IndianRed               | \033[48;2;205;92;92m  
<span style="background-color:rgb(75,0,130);color:white;">Background</span>    | <span style="color:rgb(75,0,130);">Foreground</span>    | Indigo                  | \033[48;2;75;0;130m   
<span style="background-color:rgb(255,255,240);color:black;">Background</span> | <span style="color:rgb(255,255,240);">Foreground</span> | Ivory                   | \033[48;2;255;255;240m
<span style="background-color:rgb(240,230,140);color:black;">Background</span> | <span style="color:rgb(240,230,140);">Foreground</span> | Khaki                   | \033[48;2;240;230;140m
<span style="background-color:rgb(230,230,250);color:black;">Background</span> | <span style="color:rgb(230,230,250);">Foreground</span> | Lavender                | \033[48;2;230;230;250m
<span style="background-color:rgb(255,240,245);color:black;">Background</span> | <span style="color:rgb(255,240,245);">Foreground</span> | LavenderBlush           | \033[48;2;255;240;245m
<span style="background-color:rgb(124,252,0);color:black;">Background</span>   | <span style="color:rgb(124,252,0);">Foreground</span>   | LawnGreen               | \033[48;2;124;252;0m  
<span style="background-color:rgb(255,250,205);color:black;">Background</span> | <span style="color:rgb(255,250,205);">Foreground</span> | LemonChiffon            | \033[48;2;255;250;205m
<span style="background-color:rgb(173,216,230);color:black;">Background</span> | <span style="color:rgb(173,216,230);">Foreground</span> | LightBlue               | \033[48;2;173;216;230m
<span style="background-color:rgb(240,128,128);color:black;">Background</span> | <span style="color:rgb(240,128,128);">Foreground</span> | LightCoral              | \033[48;2;240;128;128m
<span style="background-color:rgb(224,255,255);color:black;">Background</span> | <span style="color:rgb(224,255,255);">Foreground</span> | LightCyan               | \033[48;2;224;255;255m
<span style="background-color:rgb(250,250,210);color:black;">Background</span> | <span style="color:rgb(250,250,210);">Foreground</span> | LightGoldenrodYellow    | \033[48;2;250;250;210m
<span style="background-color:rgb(211,211,211);color:black;">Background</span> | <span style="color:rgb(211,211,211);">Foreground</span> | LightGray               | \033[48;2;211;211;211m
<span style="background-color:rgb(144,238,144);color:black;">Background</span> | <span style="color:rgb(144,238,144);">Foreground</span> | LightGreen              | \033[48;2;144;238;144m
<span style="background-color:rgb(255,182,193);color:black;">Background</span> | <span style="color:rgb(255,182,193);">Foreground</span> | LightPink               | \033[48;2;255;182;193m
<span style="background-color:rgb(255,160,122);color:black;">Background</span> | <span style="color:rgb(255,160,122);">Foreground</span> | LightSalmon             | \033[48;2;255;160;122m
<span style="background-color:rgb(32,178,170);color:black;">Background</span>  | <span style="color:rgb(32,178,170);">Foreground</span>  | LightSeaGreen           | \033[48;2;32;178;170m 
<span style="background-color:rgb(135,206,250);color:black;">Background</span> | <span style="color:rgb(135,206,250);">Foreground</span> | LightSkyBlue            | \033[48;2;135;206;250m
<span style="background-color:rgb(119,136,153);color:black;">Background</span> | <span style="color:rgb(119,136,153);">Foreground</span> | LightSlateGray          | \033[48;2;119;136;153m
<span style="background-color:rgb(176,196,222);color:black;">Background</span> | <span style="color:rgb(176,196,222);">Foreground</span> | LightSteelBlue          | \033[48;2;176;196;222m
<span style="background-color:rgb(255,255,224);color:black;">Background</span> | <span style="color:rgb(255,255,224);">Foreground</span> | LightYellow             | \033[48;2;255;255;224m
<span style="background-color:rgb(0,255,0);color:black;">Background</span>     | <span style="color:rgb(0,255,0);">Foreground</span>     | Lime                    | \033[48;2;0;255;0m    
<span style="background-color:rgb(50,205,50);color:black;">Background</span>   | <span style="color:rgb(50,205,50);">Foreground</span>   | LimeGreen               | \033[48;2;50;205;50m  
<span style="background-color:rgb(250,240,230);color:black;">Background</span> | <span style="color:rgb(250,240,230);">Foreground</span> | Linen                   | \033[48;2;250;240;230m
<span style="background-color:rgb(255,0,255);color:white;">Background</span>   | <span style="color:rgb(255,0,255);">Foreground</span>   | Magenta                 | \033[48;2;255;0;255m  
<span style="background-color:rgb(128,0,0);color:white;">Background</span>     | <span style="color:rgb(128,0,0);">Foreground</span>     | Maroon                  | \033[48;2;128;0;0m    
<span style="background-color:rgb(102,205,170);color:black;">Background</span> | <span style="color:rgb(102,205,170);">Foreground</span> | MediumAquamarine        | \033[48;2;102;205;170m
<span style="background-color:rgb(0,0,205);color:white;">Background</span>     | <span style="color:rgb(0,0,205);">Foreground</span>     | MediumBlue              | \033[48;2;0;0;205m    
<span style="background-color:rgb(186,85,211);color:white;">Background</span>  | <span style="color:rgb(186,85,211);">Foreground</span>  | MediumOrchid            | \033[48;2;186;85;211m 
<span style="background-color:rgb(147,112,219);color:white;">Background</span> | <span style="color:rgb(147,112,219);">Foreground</span> | MediumPurple            | \033[48;2;147;112;219m
<span style="background-color:rgb(60,179,113);color:black;">Background</span>  | <span style="color:rgb(60,179,113);">Foreground</span>  | MediumSeaGreen          | \033[48;2;60;179;113m 
<span style="background-color:rgb(123,104,238);color:white;">Background</span> | <span style="color:rgb(123,104,238);">Foreground</span> | MediumSlateBlue         | \033[48;2;123;104;238m
<span style="background-color:rgb(0,250,154);color:black;">Background</span>   | <span style="color:rgb(0,250,154);">Foreground</span>   | MediumSpringGreen       | \033[48;2;0;250;154m  
<span style="background-color:rgb(72,209,204);color:black;">Background</span>  | <span style="color:rgb(72,209,204);">Foreground</span>  | MediumTurquoise         | \033[48;2;72;209;204m 
<span style="background-color:rgb(199,21,133);color:white;">Background</span>  | <span style="color:rgb(199,21,133);">Foreground</span>  | MediumVioletRed         | \033[48;2;199;21;133m 
<span style="background-color:rgb(25,25,112);color:white;">Background</span>   | <span style="color:rgb(25,25,112);">Foreground</span>   | MidnightBlue            | \033[48;2;25;25;112m  
<span style="background-color:rgb(245,255,250);color:black;">Background</span> | <span style="color:rgb(245,255,250);">Foreground</span> | MintCream               | \033[48;2;245;255;250m
<span style="background-color:rgb(255,228,225);color:black;">Background</span> | <span style="color:rgb(255,228,225);">Foreground</span> | MistyRose               | \033[48;2;255;228;225m
<span style="background-color:rgb(255,228,181);color:black;">Background</span> | <span style="color:rgb(255,228,181);">Foreground</span> | Moccasin                | \033[48;2;255;228;181m
<span style="background-color:rgb(255,222,173);color:black;">Background</span> | <span style="color:rgb(255,222,173);">Foreground</span> | NavajoWhite             | \033[48;2;255;222;173m
<span style="background-color:rgb(0,0,128);color:white;">Background</span>     | <span style="color:rgb(0,0,128);">Foreground</span>     | Navy                    | \033[48;2;0;0;128m    
<span style="background-color:rgb(253,245,230);color:black;">Background</span> | <span style="color:rgb(253,245,230);">Foreground</span> | OldLace                 | \033[48;2;253;245;230m
<span style="background-color:rgb(128,128,0);color:white;">Background</span>   | <span style="color:rgb(128,128,0);">Foreground</span>   | Olive                   | \033[48;2;128;128;0m  
<span style="background-color:rgb(107,142,35);color:white;">Background</span>  | <span style="color:rgb(107,142,35);">Foreground</span>  | OliveDrab               | \033[48;2;107;142;35m 
<span style="background-color:rgb(255,165,0);color:black;">Background</span>   | <span style="color:rgb(255,165,0);">Foreground</span>   | Orange                  | \033[48;2;255;165;0m  
<span style="background-color:rgb(255,69,0);color:white;">Background</span>    | <span style="color:rgb(255,69,0);">Foreground</span>    | OrangeRed               | \033[48;2;255;69;0m   
<span style="background-color:rgb(218,112,214);color:black;">Background</span> | <span style="color:rgb(218,112,214);">Foreground</span> | Orchid                  | \033[48;2;218;112;214m
<span style="background-color:rgb(238,232,170);color:black;">Background</span> | <span style="color:rgb(238,232,170);">Foreground</span> | PaleGoldenrod           | \033[48;2;238;232;170m
<span style="background-color:rgb(152,251,152);color:black;">Background</span> | <span style="color:rgb(152,251,152);">Foreground</span> | PaleGreen               | \033[48;2;152;251;152m
<span style="background-color:rgb(175,238,238);color:black;">Background</span> | <span style="color:rgb(175,238,238);">Foreground</span> | PaleTurquoise           | \033[48;2;175;238;238m
<span style="background-color:rgb(219,112,147);color:black;">Background</span> | <span style="color:rgb(219,112,147);">Foreground</span> | PaleVioletRed           | \033[48;2;219;112;147m
<span style="background-color:rgb(255,239,213);color:black;">Background</span> | <span style="color:rgb(255,239,213);">Foreground</span> | PapayaWhip              | \033[48;2;255;239;213m
<span style="background-color:rgb(255,218,185);color:black;">Background</span> | <span style="color:rgb(255,218,185);">Foreground</span> | PeachPuff               | \033[48;2;255;218;185m
<span style="background-color:rgb(205,133,63);color:black;">Background</span>  | <span style="color:rgb(205,133,63);">Foreground</span>  | Peru                    | \033[48;2;205;133;63m 
<span style="background-color:rgb(255,192,203);color:black;">Background</span> | <span style="color:rgb(255,192,203);">Foreground</span> | Pink                    | \033[48;2;255;192;203m
<span style="background-color:rgb(221,160,221);color:black;">Background</span> | <span style="color:rgb(221,160,221);">Foreground</span> | Plum                    | \033[48;2;221;160;221m
<span style="background-color:rgb(176,224,230);color:black;">Background</span> | <span style="color:rgb(176,224,230);">Foreground</span> | PowderBlue              | \033[48;2;176;224;230m
<span style="background-color:rgb(128,0,128);color:white;">Background</span>   | <span style="color:rgb(128,0,128);">Foreground</span>   | Purple                  | \033[48;2;128;0;128m  
<span style="background-color:rgb(255,0,0);color:white;">Background</span>     | <span style="color:rgb(255,0,0);">Foreground</span>     | Red                     | \033[48;2;255;0;0m    
<span style="background-color:rgb(188,143,143);color:black;">Background</span> | <span style="color:rgb(188,143,143);">Foreground</span> | RosyBrown               | \033[48;2;188;143;143m
<span style="background-color:rgb(65,105,225);color:white;">Background</span>  | <span style="color:rgb(65,105,225);">Foreground</span>  | RoyalBlue               | \033[48;2;65;105;225m 
<span style="background-color:rgb(139,69,19);color:white;">Background</span>   | <span style="color:rgb(139,69,19);">Foreground</span>   | SaddleBrown             | \033[48;2;139;69;19m  
<span style="background-color:rgb(250,128,114);color:black;">Background</span> | <span style="color:rgb(250,128,114);">Foreground</span> | Salmon                  | \033[48;2;250;128;114m
<span style="background-color:rgb(244,164,96);color:black;">Background</span>  | <span style="color:rgb(244,164,96);">Foreground</span>  | SandyBrown              | \033[48;2;244;164;96m 
<span style="background-color:rgb(46,139,87);color:white;">Background</span>   | <span style="color:rgb(46,139,87);">Foreground</span>   | SeaGreen                | \033[48;2;46;139;87m  
<span style="background-color:rgb(255,245,238);color:black;">Background</span> | <span style="color:rgb(255,245,238);">Foreground</span> | SeaShell                | \033[48;2;255;245;238m
<span style="background-color:rgb(160,82,45);color:white;">Background</span>   | <span style="color:rgb(160,82,45);">Foreground</span>   | Sienna                  | \033[48;2;160;82;45m  
<span style="background-color:rgb(192,192,192);color:black;">Background</span> | <span style="color:rgb(192,192,192);">Foreground</span> | Silver                  | \033[48;2;192;192;192m
<span style="background-color:rgb(135,206,235);color:black;">Background</span> | <span style="color:rgb(135,206,235);">Foreground</span> | SkyBlue                 | \033[48;2;135;206;235m
<span style="background-color:rgb(106,90,205);color:white;">Background</span>  | <span style="color:rgb(106,90,205);">Foreground</span>  | SlateBlue               | \033[48;2;106;90;205m 
<span style="background-color:rgb(112,128,144);color:white;">Background</span> | <span style="color:rgb(112,128,144);">Foreground</span> | SlateGray               | \033[48;2;112;128;144m
<span style="background-color:rgb(255,250,250);color:black;">Background</span> | <span style="color:rgb(255,250,250);">Foreground</span> | Snow                    | \033[48;2;255;250;250m
<span style="background-color:rgb(0,255,127);color:black;">Background</span>   | <span style="color:rgb(0,255,127);">Foreground</span>   | SpringGreen             | \033[48;2;0;255;127m  
<span style="background-color:rgb(70,130,180);color:white;">Background</span>  | <span style="color:rgb(70,130,180);">Foreground</span>  | SteelBlue               | \033[48;2;70;130;180m 
<span style="background-color:rgb(210,180,140);color:black;">Background</span> | <span style="color:rgb(210,180,140);">Foreground</span> | Tan                     | \033[48;2;210;180;140m
<span style="background-color:rgb(0,128,128);color:white;">Background</span>   | <span style="color:rgb(0,128,128);">Foreground</span>   | Teal                    | \033[48;2;0;128;128m  
<span style="background-color:rgb(216,191,216);color:black;">Background</span> | <span style="color:rgb(216,191,216);">Foreground</span> | Thistle                 | \033[48;2;216;191;216m
<span style="background-color:rgb(255,99,71);color:black;">Background</span>   | <span style="color:rgb(255,99,71);">Foreground</span>   | Tomato                  | \033[48;2;255;99;71m  
<span style="background-color:rgb(64,224,208);color:black;">Background</span>  | <span style="color:rgb(64,224,208);">Foreground</span>  | Turquoise               | \033[48;2;64;224;208m 
<span style="background-color:rgb(238,130,238);color:black;">Background</span> | <span style="color:rgb(238,130,238);">Foreground</span> | Violet                  | \033[48;2;238;130;238m
<span style="background-color:rgb(245,222,179);color:black;">Background</span> | <span style="color:rgb(245,222,179);">Foreground</span> | Wheat                   | \033[48;2;245;222;179m
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | White                   | \033[48;2;255;255;255m
<span style="background-color:rgb(245,245,245);color:black;">Background</span> | <span style="color:rgb(245,245,245);">Foreground</span> | WhiteSmoke              | \033[48;2;245;245;245m
<span style="background-color:rgb(255,255,0);color:black;">Background</span>   | <span style="color:rgb(255,255,0);">Foreground</span>   | Yellow                  | \033[48;2;255;255;0m  
<span style="background-color:rgb(154,205,50);color:black;">Background</span>  | <span style="color:rgb(154,205,50);">Foreground</span>  | YellowGreen             | \033[48;2;154;205;50m 
<span style="background-color:rgb(240,240,240);color:black;">Background</span> | <span style="color:rgb(240,240,240);">Foreground</span> | ButtonFace              | \033[48;2;240;240;240m
<span style="background-color:rgb(255,255,255);color:black;">Background</span> | <span style="color:rgb(255,255,255);">Foreground</span> | ButtonHighlight         | \033[48;2;255;255;255m
<span style="background-color:rgb(160,160,160);color:black;">Background</span> | <span style="color:rgb(160,160,160);">Foreground</span> | ButtonShadow            | \033[48;2;160;160;160m
<span style="background-color:rgb(185,209,234);color:black;">Background</span> | <span style="color:rgb(185,209,234);">Foreground</span> | GradientActiveCaption   | \033[48;2;185;209;234m
<span style="background-color:rgb(215,228,242);color:black;">Background</span> | <span style="color:rgb(215,228,242);">Foreground</span> | GradientInactiveCaption | \033[48;2;215;228;242m
<span style="background-color:rgb(240,240,240);color:black;">Background</span> | <span style="color:rgb(240,240,240);">Foreground</span> | MenuBar                 | \033[48;2;240;240;240m
<span style="background-color:rgb(51,153,255);color:black;">Background</span>  | <span style="color:rgb(51,153,255);">Foreground</span>  | MenuHighlight           | \033[48;2;51;153;255m 
<span style="background-color:rgb(102,51,153);color:white;">Background</span>  | <span style="color:rgb(102,51,153);">Foreground</span>  | RebeccaPurple           | \033[48;2;102;51;153m 


