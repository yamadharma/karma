# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

S=${WORKDIR}/ProjectCenter-${PV}

DESCRIPTION="GNUstep project developer"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/ProjectCenter-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="ANNOUNCE AUTHORS ChangeLog INSTALL README README.contributions TODO"

src_unpack ()
{
    patch_src_unpack

    # LDFLAGS fix
    cd ${S}
    sed -i -e "s:framework/Versions/Current:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" GNUmakefile.preamble
}

# Local Variables:
# mode: sh
# End:
