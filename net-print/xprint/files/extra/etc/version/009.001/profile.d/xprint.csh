#
# /etc/profile.d/xprint.csh
#
#
# Obtain list of Xprint servers
#

if ( -f /usr/sbin/xprint ) 
    then
    setenv XPSERVERLIST "`/bin/sh /usr/sbin/xprint get_xpserverlist`"
endif

# Local Variables:
# mode: csh
# End:
