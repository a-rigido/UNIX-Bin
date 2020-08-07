#!/bin/bash

# Author: Alex Rigido
# Remove Script (1/2 of the Recycle Bin Project)

################################ ~~~  FUNCTIONS  ~~~ ################################

# Start by creating the recycle bin and associated files
function mkBin(){
	if [ ! -d $HOME/deleted ]; then
		mkdir $HOME/deleted
        touch $HOME/.restore.info
	fi
}

# check if user gave a command line argument, if not give an error.
function ensureArgs(){
	if [ $# -eq 0 ]; then
	        echo "remove: missing operand"
	        exit 1;
	fi
}

function recurRm() {
    for i in "$1"/*
    do
            if [ -d $i ]; then
                if [ "$(ls -A $i)" ]; then
                    recurRm $i
          fi
            else
		main $i
            fi
   done

   # remove the empty directory
   rmdir $1 2>/dev/null
}

# process file based on user input and if its a directory send it
# to the previous function for processing
function recFile() {
    for i in $*
    do
        file=$i
        if [ -d $file ] ; then
            isDir $i
        else
            optFunc
        fi
    done
}

# remove the file based on the users inputted options
function optFunc() {

    if [ $noOpt = true ] ; then
        rmFile

    elif [ $intMode = true ] ; then
	if [ $file != "!err" ] ; then
	    read -p "remove $i? (y/n) " sel
            getSelection
        fi
    else
	rmFile
    fi
}

# main loop to process files
function main() {
    for i in $*
    do
        file=$i

        # check if CL arg exists
        if [ ! -e $file ] ; then
            echo "remove: cannot remove '$file': No such file or directory"
            file="!err"
            ec=1
	fi

        # check is CL arg is a directory (Error when -r not selected)
        if [ -d $file ] ; then
            echo "remove: cannot remove '$file': Is a directory"
            file="!err"
            ec=1
	fi

        # ensure the user can't deleted the remove script or its variants
        if [ $(basename $file) = "remove" ] || [ $(basename $file)  = "Remove" ] || [ $(basename $file)  = "removal" ]; then
	                echo "Attempting to delete $file – operation aborted"
                    file="!err"
		    ec=1
        fi

        # process files according to selected options
        optFunc
    done
}

# This function gives the removal functionality to the script
# If there are no errors the file will be moved to the "recycling bin"
function rmFile() {
    # If no errors mv the file to the relevant dir and add to restore info.
    if [ $file != "!err" ] ; then
        fileInode=$(ls -i $file | cut -d " " -f1)
        baseName=$(basename $file)
        binName=$baseName\_$fileInode
        path=$(readlink -fn $file)
        echo $binName:$path >> $HOME/.restore.info
        mv $file $HOME/deleted/$binName
	if [ $verMode = true ]
		then
			echo "removed '$file'"
	fi
    fi
}

# get the users confirmation to remove file
function getSelection() {
    case $sel in
        ["Yy"]) rmFile;;
    esac
}

################################ ~~~  MAIN  ~~~ ################################

# check if bin is present
mkBin

# check if user provided args
ensureArgs $*

# define exit code
ec=0

# define the default options
noOpt=true
intMode=false
verMode=false
recMode=false

# get the users selected options
while getopts ivr opt
do
    case $opt in
        i)  intMode=true
            noOpt=false;;

        v)  verMode=true
            noOpt=false;;

        r)  recMode=true
            noOpt=false;;

        # error for invalid selection
        *)
           exit 1;;
    esac
done
shift $(($OPTIND - 1))

# check whether selection is a directory or file and process accordingly
if [ $recMode = true ] ; then
    for i in $*
    do
	# check if CL arg exists
        if [ ! -e $i ] ; then
            echo "remove: cannot remove '$i': No such file or directory"
            file="!err"
	    ec=1
        else
            if [ -d $i ] ; then
                recurRm $i
	    else
		main $i
            fi
        fi
    done
else
	main $*
fi

exit $ec