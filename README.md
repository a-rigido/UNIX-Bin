# UNIX "Recycle Bin"

The remove.sh and restore.sh scripts allow a Unix users to emulated a function recycling bin in the Unix environment.

Traditionally the rm command is used to delete files but once the file is removed it can not be restored. In a more tradional operating system this problem is fixed by having a bin in which the removed files are collected before permanent deletion. 

Therefore, with the use of these scripts in your environment, you will be able to have the major functions of the remove command without worry of accidental deletion.


## Features:
### remove.sh
* Multi-file Removal
    * The user can remove as many files as they want to with a single command.
* Interactive Mode:
    * Using the -i option, the user will be asked for confirmation prior to removal.
* Verbose Mode:
    * Using the -v option, the user will be received confirmation of the files removal.
* Recursive Mode:
    * Using the -r option, the user will be able to recursively delete all the files in a folder and then remove the folder itself.
* Combination Modes:
    * The user may opt to combine any of the options in any order to satisfy their removal needs.

### restore.sh
* Full Restoration Ability
    * The user will be able to return their file to its original state before removal.
    * The user will be able to use recursive restoration if necessary to rebuild deleted directories.

### Implementation
To implement this scripts into your system, simply add the scripts to and give them a desired alias so that you can call them with ease.

#### Final Remarks

Feel free to use any code written here as you see fit. Thanks for stopping by.


<p align="center">
Copyright (c) 2020 Alex Rigido
</p>
