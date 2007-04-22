#!/bin/csh

if ( -e /etc/GNUstep/GNUstep.conf ) then
    eval `sed -e '/^[^#=][^#=]*=.*$/\\!d' -e 's/^\([^#=][^#=]*\)=\(.*\)$/setenv \1 \2;/' /etc/GNUstep/GNUstep.conf`
else
    GNUSTEP_MAKEFILES=/usr/GNUstep/System/Library/Makefiles
endif

source $GNUSTEP_MAKEFILES/GNUstep.csh

if ( -z "$GNUSTEP_IS_FLATTENED" = "no" ) then
    set TDIR=${GNUSTEP_SYSTEM_TOOLS}/${GNUSTEP_HOST_CPU}/${GNUSTEP_HOST_OS}/${LIBRARY_COMBO}
else
    set TDIR=${GNUSTEP_SYSTEM_TOOLS}
endif

if ( -x $TDIR/make_services ) then
    $TDIR/make_services
endif

unset TDIR