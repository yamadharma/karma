# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

MY_P=Addresses-${PV}

S=${WORKDIR}/${MY_P}

DESCRIPTION="Address Book Framework and Application for GNUstep"
HOMEPAGE="http://giesler.biz/bjoern/English/Software.html#Addresses"
SRC_URI="http://giesler.biz/bjoern/Downloads/Addresses/${MY_P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86"

DEPEND="${DEPEND}
	gnustep-apps/gworkspace"

# FIXME: check headers path
# S_ADD="Goodies"

mydoc="AUTHORS INSTALL NEWS README THANKS TODO"

src_unpack ()
{
    patch_src_unpack
    
    # LDFLAGS fix
    cd ${S}
#    if [ -z "$GNUSTEP_FLATTENED" ] 
#	then
#	sed -i -e "s:framework/Versions/A:framework/Versions/A/${GNUSTEP_HOST_CPU}/${GNUSTEP_HOST_OS}/${LIBRARY_COMBO}:g" AddressManager/GNUmakefile
#    fi

    sed -i -e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" AddressManager/GNUmakefile
    
    # Headers fix
    sed -i -e "s:\$(GNUSTEP_INSTALLATION_DIR)/Library/Headers/Addresses:./Addresses:g" Frameworks/Addresses/GNUmakefile
    sed -i -e "s:Library/Headers:Library/Headers/\$(LIBRARY_COMBO):g" Frameworks/Addresses/GNUmakefile
}

# Local Variables:
# mode: sh
# End:
