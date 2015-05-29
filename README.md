# Cdifold.vim
vim plugin that find and create folds for nonsignificant C code diff. 

like the following diffs, they are nosignificant C code diff.
 
 418 -        if(i != 0 && i % 6 == 0) {
 419 +        if (i != 0 && i % 6 == 0) {
 420              printf("\n");

or

 418 -        if(i != 0 && i % 6 == 0) {
 419 +        if (i != 0 && i % 6 == 0)
 420 +        {
 421              printf("\n");
 
:Cdifold   find and create folds for the nosignificant C code diff.
