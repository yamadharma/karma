# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

MY_P=Addresses-${PV}

S=${WORKDIR}/${MY_P}

DESCRIPTION="Address Book Framework and Application for GNUstep"
HOMEPAGE="http://giesler.biz/bjoern/en/sw_addr.html"
SRC_URI="http://giesler.biz/bjoern/downloads/${MY_P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86"

DEPEND="${DEPEND}
	gnustep-apps/gworkspace"

S_ADD="Goodies"

mydoc="AUTHORS INSTALL NEWS README THANKS TODO"

src_unpack ()
{
    patch_src_unpack

    # LDFLAGS fix
    cd ${S}
    sed -i -e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" AddressManager/GNUmakefile
    
    # Headers destdir fix
    sed -i -e "s:\$(GNUSTEP_INSTALLATION_DIR)/Library/Headers/Addresses:./Addresses:g" Frameworks/Addresses/GNUmakefile
    sed -i -e "s:Library/Headers:Library/Headers/\$(LIBRARY_COMBO):g" Frameworks/Addresses/GNUmakefile
    
    # OBJCFLAGS and LDFLAGS fix
    cd ${S}/Goodies
    
    sed -i -e "s:\(.*\)OBJCFLAGS\(.*\):\1OBJCFLAGS\2 -I../../Frameworks:" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR) -L../../Frameworks/AddressView/AddressView.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):" VCFViewer/GNUmakefile
    
    sed -i -e "/TOOL_NAME/a\adgnumailconverter_OBJCFLAGS += -I../../Frameworks" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):" adgnumailconverter/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" adserver/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" adtool/GNUmakefile
}

# Local Variables:
# mode: sh
# End:
