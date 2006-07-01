#!/bin/csh

set MY_ID=`id -u`
set MY_MOUNT=`grep -E "smbnetfs.*user_id=$MY_ID" /proc/mounts`


if ( -z "$MY_MOUNT" && -f ~/.smb/smbnetfs.conf ) then
    if ( ! -d ~/net/smb ) then
	mkdir -p ~/net/smb
    endif    
    /usr/bin/smbnetfs ~/net/smb
endif    

unset MY_MOUNT
unset MY_ID


