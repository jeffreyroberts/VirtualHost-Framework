#!/bin/bash
. /web/_scripts/header

if [ "$#" -lt 1 ] 
then
	echo "Wheres my var"
	exit 1
fi

if [ ! -f $1 ]
then
	echo "File $1 does not exist"
	exit 1
fi

if [ -f /web/_conf/webhead.conf ]
then
	read -p "webhead.conf exists, overwrite? (y/n)"
	if [ "$REPLY" != "y" ] 
	then
		echo "Answered No, Exiting"
		exit 1
	fi

	echo "Answered Yes, Overwriting"
	rm -rf /web/_conf/webhead.conf
fi

ln -s $1 /web/_conf/webhead.conf
echo "Symlink Created."
ls -al /web/_conf/webhead.conf
