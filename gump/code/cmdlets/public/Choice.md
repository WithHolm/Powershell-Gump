# Invoke-GumpChoice (techincal)

this is partly technical docs and partly thoughts on the inner workings.

one of the biggest issues i had was showing a list of filtered items. if i came in with originally 10 items, and then filtered, i would only get 


### showItems and items
items is the complete list of items avalible to the user, showitems is the filtered list

id|content
---|---
0|line 1
1|line 2
2|etc
3|
4|
5|
5|
6|
7|
8|
9|
10|

for our example showitems would just be id 0..3

knowin this iv also created `AllItemsIndex`. this index is a `int[]` of id's in showitems