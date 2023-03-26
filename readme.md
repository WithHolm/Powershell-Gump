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