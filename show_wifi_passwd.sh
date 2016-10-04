#!/bin/sh

##################################################################################
#
#  Copyright (C) 2016 Craig Miller
#
#  See the file "LICENSE" for information on usage and redistribution
#  of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#  Distributed under GPLv2 License
#
##################################################################################


#
# Script to decode Wifi Passwords on a Chromebook
# based on Redit Post - https://www.reddit.com/r/chromeos/comments/3gbaw0/chromebook_stored_wifi_password_access/
#
# Craig Miller 25 September 2016
#

#
# Define interfaces
#

# Define files
PASSWD_FILE="/tmp/shill.profile"


# script version
VERSION=0.91


usage () {
	# show help
	echo "Decodes Wifi Passwords on a Chromebook"
	echo " "
	echo " First, from diag shell, Copy wifi password file & change permissons"
	echo "	sudo find  /home/root/ -name shill.profile -exec cp {} /tmp/ \\;"
	echo "	sudo chmod 644 /tmp/shill.profile"
	echo " " 
	echo " Usage:"
	echo "	$0 -f <password file>"
	echo "	-h         this help"
	echo "  "
	echo " By Craig Miller - Version: $VERSION"
	exit 1
}


# check that the WAN interface has been passed in
if [ $# -eq 0 ]; then
	usage
	exit 1
fi


# default options values
DEBUG=0
numopts=0
# get args from CLI
while getopts "?hdf:" options; do
  case $options in
    f ) PASSWD_FILE=$OPTARG
    	numopts=$((numopts+2));;
    d ) DEBUG=1
		numopts=$((numopts+1));;
    h ) usage;;
    \? ) usage	# show usage with flag and no value
         exit 1;;
    * ) usage		# show usage with unknown flag
    	 exit 1;;
  esac
done

# remove the options as cli arguments
shift $((numopts))

# check that there are no arguments left to process
if [ $# -ne 0 ]; then
	usage
	exit 1
fi

echo "=== Show the decoded wifi password file"

if [ $DEBUG -eq 1 ]; then
	egrep 'Name=|=rot' "$PASSWD_FILE" | sed -r 's;.*rot47:([^ ]+).*;\1;' | grep -v 'rot47'
fi

DATA=$(egrep 'Name=|=rot' "$PASSWD_FILE"  | sed -r 's;.*rot47:([^ ]+).*;\1;' | grep -v 'rot47' | sed 's; ;^;g')
for item in $DATA
do
	field=$(echo "$item" | grep 'Name=')
	if [ ! -z "$field" ]; then
		echo "$item" | tr '^' ' '
	else
		# do rot47 conversion, and colorize
		echo "$item" | tr '!-~' 'P-~!-O' | grep --color '.*'
	fi
done


echo "=== Pau!"



