#
# /etc/profile.d/xprint.sh
#
#
# Obtain list of Xprint servers
#

if [ -f "/usr/sbin/xprint" ]
    then
    XPSERVERLIST="`/bin/sh /usr/sbin/xprint get_xpserverlist`"
    export XPSERVERLIST
fi

# Local Variables:
# mode: sh
# End:
