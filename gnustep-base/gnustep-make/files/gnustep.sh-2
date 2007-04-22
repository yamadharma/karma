#!/bin/sh

if [ -e /etc/GNUstep/GNUstep.conf ]
    then
    . /etc/GNUstep/GNUstep.conf
else
    GNUSTEP_MAKEFILES=/usr/GNUstep/System/Library/Makefiles
fi

. $GNUSTEP_MAKEFILES/GNUstep.sh

if [ "$GNUSTEP_IS_FLATTENED" = "no" ] 
then
    TDIR=${GNUSTEP_SYSTEM_TOOLS}/${GNUSTEP_HOST_CPU}/${GNUSTEP_HOST_OS}/${LIBRARY_COMBO}
else
    TDIR=${GNUSTEP_SYSTEM_TOOLS}
fi

if [ -x $TDIR/make_services ]
    then
    $TDIR/make_services
fi

