#!/bin/sh

# Test for an interactive shell
if [[ $- != *i* ]]; then
	return
fi
	
GNUSTEP_SYSTEM_TOOLS=/usr/GNUstep/System/Tools

if [ -x ${GNUSTEP_SYSTEM_TOOLS}/make_services ]; then
    ${GNUSTEP_SYSTEM_TOOLS}/make_services
fi

if [ -x ${GNUSTEP_SYSTEM_TOOLS}/gdnc ]; then
    ${GNUSTEP_SYSTEM_TOOLS}/gdnc
fi
