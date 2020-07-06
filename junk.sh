###############################################################################
# Author: Luke McEvoy
# Name: junk.sh
# A simple bash script to provide the basic functionality of a recycle bin.
# In addition to moving files into the recycle bin directory, the script must 
# be able to list and purge the files that have been placed into the recycle bin.
# This script acts as a substitute for the rm command, giving the user a chance
# to recover files deleted accidentally.
###############################################################################
#!/bin/bash

###############################################################################
# 				QUESTIONS/CONCERNS
# 	DONE) Do I add exit 0 to every getopts option, right way to do it
# 	DONE) How to catch when there are two working flags entered
# 	3) How to catch case when a file is passed in
#		(a) how to see if the file exists in that directory or not
#		(b) how to move that file --> cd /junk?
# 	4) How to make the help message global string
# 		(a) how important is the format of error
# 	5) Test script?
#		(b) just following the run scenario with no files created?
#	6) How are we to purge files when -p is ran?
#		(a) do we just move them to junk or do we clear junk?
###############################################################################

###############################################################################
#			OFFICE HOURS NOTES Feb 4th
# 	1) readonly at the header for the .junk folder ~/.junk
# 	2) $# is the number of arguments
#	3) $@ is the list of arguments
#	4) if the arg count is > 1 then output 'too many'
#	5) if makes it through the options and the count is still 1, then
#	file handling begins
#	6) see if the file exists, if not, throw a warning with basename
#		a) look at the slides in regards to checking whether file exists
#
#	7) file and then flag will never be a case
###############################################################################

###############################################################################
#			OFFICE HOURS NOTES Feb 5th
#	1) For Part C: for loop through #@ (list of arguments) and append them to
#		to an array. Then index through this array and mv them to junk
#	2) TA said might not need to print Warning message if the file exists
#		because that is automatic to bash but I think I will need to use the
#		tee command to make the appropriate output
###############################################################################


###############################################################################
# 				TO DO
# 	1) How to specify between flags and texts
#		(a) if arguments have made it to the ? then it has to be non flag
#		(b) have to check if the input is a file or directory that exists
#		(c) 
#	2) When file that exists is passed in, move it to junked
# 	DONE [I THINK]) -p Purging of files
###############################################################################

###############################################################################
#				REFERENCE CODE
# PASSED=$1
# if [[ -d $PASSED ]]; then
#     echo "$PASSED is a directory"
# elif [[ -f $PASSED ]]; then
#     echo "$PASSED is a file"
# else
#     echo "$PASSED is not valid"
#     exit 1
# fi
###############################################################################


###############################################################################
#				ARRAY OF FILE NAMES
# Put all the hidden folders into an array, see if the junk folder exists
# if it doesn't, make it in the home directory

#declare -a filenames

# Instead of appending parameter filenames into array, use grep to extract the
# hidden file names of the current directory.

# If the hidden directory ./junk does not exists, then create it

# 	Command -->		egrep "^\..*/$" 

# shift "$((OPTIND-1))"
# index=0
# for f in $@; do
# 	filenames[$index]="$f"
# 	(( ++index ))
# done

# Make a for loop that checks if the ./junk is there
# if[]

#echo ${filenames[*]} 
###############################################################################

readonly destination="/home/cs392/.junk"

# NO ENTRY CASE
# If no parameters are passed, then echo the usage message
if [ -z "$1" ]; then
	cat << ENDOFTEXT 
Usage: junk.sh [-hlp] [list of files]
   -h: Display help.
   -l: List junked files
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
fi

# getopts while loop for flags
while getopts ":hlp" option; do
	case "$option" in
		# Should display help here instead of echo
		h) 
		if [ $# -gt 1 ]; then
			cat << ENDOFTEXT
Error: Too many options enabled.
ENDOFTEXT
		fi

		cat << ENDOFTEXT
Usage: junk.sh [-hlp] [list of files]
   -h: Display help.
   -l: List junked files
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
			exit 1
			;;

		# Should list junked files
		# Start of with an ls and then work to improve
		l) 
		if [ $# -gt 1 ]; then
			cat << ENDOFTEXT
Error: Too many options enabled.
Usage: junk.sh [-hlp] [list of files]
   -h: Display help.
   -l: List junked files
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
			exit 1;
		fi
			ls -lAF $destination
			exit 0
			;;

		# Purge all files
		p)
		if [ $# -gt 1 ]; then
			cat << ENDOFTEXT
Error: Too many options enabled.
Usage: junk.sh [-hlp] [list of files]
   -h: Display help.
   -l: List junked files
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
			exit 1;
		fi
			rm -rf $destination
			cd ~
			mkdir .junk
			cd $destination
			exit 0
			;;

		# TASK
		# Check to see if the file passed exists!
		?) cat << ENDOFTEXT
Error: Unknown option '$@'.
Usage: junk.sh [-hlp] [list of files]
   -h: Display help.
   -l: List junked files
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
          exit 1
			;;
	esac
done

# Check for the presence of ~/.junk directory. Hidden folder placed in home directory of the user
# if the directory is not found, the script creates it
if [ ! -d "$destination" ]; then 		# if directory doesn't exist
	# echo "Did not find .junk"
	cd ~
	mkdir .junk
	cd $destination
	# echo "Should have created .junk at this point"
fi

# if [ -d "$destination" ]; then
# 	echo "Did find .junk"
# fi

# For loop cycles through the filenames and inputs them into an array
declare -a filenames

shift "$((OPTIND-1))"
index=0
for f in $@; do
	filenames[$index]="$f"
	(( ++index ))
done

# Checking if the files exist within the current directory (/shared/assignment1)
# test cases will be: test.txt, foo.txt, py.txt

for i in "${filenames[@]}"; do

	if [[ -d $i ]]; then
    	#mv $i ~/.junk
    	mv $i $destination
	elif [[ -f $i ]]; then
    	#mv $i ~/.junk
    	mv $i $destination
	else
    	cat << ENDOFTEXT
Warning: '$i' not found.
ENDOFTEXT
    	exit 1
	fi

done

exit 0
