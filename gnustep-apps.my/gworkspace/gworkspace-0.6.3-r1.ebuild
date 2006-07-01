# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

IUSE="${IUSE} samba"

S=${WORKDIR}/GWorkspace-${PV}

DESCRIPTION="GWorkspace is the official GNUstep workspace manager"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

newdepend	"gnustep-libs/imagekits"

if [ `use samba` ]
    then
    S_ADD="GWNet"
    newdepend	"gnustep-libs/smbkit-cvs"
fi

S_ADD="${S_ADD} ClipBook GWRemote"

patch_OPTIONS="autoconf"


src_unpack ()
{
    gnustep-app-gui_src_unpack

    # LDFLAGS fix
    cd ${S}
    sed -i -e "s:\(.*\)ADDITIONAL_LDFLAGS\(.*\):\1ADDITIONAL_LDFLAGS\2 -L../FSNode/FSNode.framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" Finder/GNUmakefile.preamble
    sed -i -e "s:\(.*\)ADDITIONAL_LDFLAGS\(.*\):\1ADDITIONAL_LDFLAGS\2 -L../FSNode/FSNode.framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" Desktop/GNUmakefile.preamble
}


# Local Variables:
# mode: sh
# End:
