#!/bin/sh

# Test for an interactive shell
case $- in
	*i*)
	;;
	*)
		return
	;;
esac

if [ -e /etc/GNUstep/GNUstep.conf ]
    then
    . /etc/GNUstep/GNUstep.conf
else
    GNUSTEP_SYSTEM_ROOT="/usr/GNUstep/System"
fi

. $GNUSTEP_SYSTEM_ROOT/Library/Makefiles/GNUstep.sh
	
GNUSTEP_SYSTEM_TOOLS=/usr/GNUstep/System/Tools

if [ -x ${GNUSTEP_SYSTEM_TOOLS}/make_services ]; then
    ${GNUSTEP_SYSTEM_TOOLS}/make_services
fi

if [ -x ${GNUSTEP_SYSTEM_TOOLS}/gdnc ]; then
    ${GNUSTEP_SYSTEM_TOOLS}/gdnc
fi
