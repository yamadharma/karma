if [ "$EUID" != "0" -a -f ~/.smb/smbnetfs.conf -a \
     -z "$(grep -w "smbnetfs.*user_id=$MY_ID" /proc/mounts)" ] ; then
	[ ! -d ~/net ] && mkdir -p ~/net
	/usr/bin/smbnetfs ~/net > /dev/null 2>&1
fi
