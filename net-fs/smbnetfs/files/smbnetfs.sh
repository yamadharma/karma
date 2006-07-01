#!/bin/sh

MY_ID=`id -u`
MY_MOUNT=`grep -E "smbnetfs.*user_id=$MY_ID" /proc/mounts`

if [ -z "$MY_MOUNT" -a -f ~/.smb/smbnetfs.conf ]
    then
    if [ ! -d ~/net/smb ]
	then
	mkdir -p ~/net/smb
    fi    
    /usr/bin/smbnetfs ~/net/smb > /dev/null 2>&1
fi    