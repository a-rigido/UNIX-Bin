#!/bin/bash

# Author: Alex Rigido
# Restore Script (2/2 of the Recycle Bin Project)

################################ ~~~  FUNCTIONS  ~~~ ################################

# check if user gave a command line argument, if not give an error.
function ensureArgs(){
	if [ $# -eq 0 ]; then
	        echo "restore: missing operand"
	        exit 1;
	fi
}

# check if the user gave a valid file input
function validateArg(){
if [ ! -e $HOME/deleted/$1 ]; then
	echo "restore: cannot restore '$1': No such file or directory"
	exit 1;
fi
}

# This function gives the restoration functionality to the script
# If there are no errors the file will be restore
function main(){
    # define variables
	path=$(grep $1 $HOME/.restore.info | cut -d":" -f2)
	dirPath=$(dirname $path)

	if [ -e $path ]
    # check for duplications
    then
		read -p "File already exists. Do you want to overwrite? (y/n) " sel

	        if [ $sel = "y" ] || [ $sel = "Y" ]
		then
			rm $path
			mv $HOME/deleted/$1 $path
			cat $HOME/.restore.info | grep -v $1 > $HOME/.temp.info
    		mv $HOME/.temp.info $HOME/.restore.info
		fi
	else

	# recreate dirs if not present
		idx=2
		fullPathDir="/"
		until [ $fullPathDir = $dirPath ]
		do
			fullPathDir=$(echo $path | cut -d"/" -f-$idx)
			if [ ! -d $fullPathDir ]
			then
				mkdir $fullPathDir
			fi

			((idx++))
		done

		# move files back into their directory
		cat $HOME/.restore.info | grep -v $1 > $HOME/.temp.info
    	mv $HOME/.temp.info $HOME/.restore.info
    	filename=$(echo $1 | cut -d"_" -f1)
		mv $HOME/deleted/$1 $fullPathDir/$filename

	fi

}

################################ ~~~  MAIN  ~~~ ################################

# check user provided args
ensureArgs $*
validateArg $*

# execute main
main $1