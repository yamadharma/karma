# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-gui/gnustep-gui-0.8.7.ebuild,v 1.1 2003/07/13 20:59:40 raker Exp $

inherit gnustep-base

IUSE="${IUSE} spell"

DESCRIPTION="GNUstep AppKit implementation"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"

DEPEND=">=gnustep-base/gnustep-base-1.7.1
	>=media-libs/tiff-3.5.7
	>=media-libs/jpeg-6b-r2
	>=media-libs/audiofile-0.2.3
	spell? app-text/aspell" 
	
PDEPEND="=gnustep-base/gnustep-back-${PV}*"

S=${WORKDIR}/${P}

patch_OPTIONS="autoconf cleancvs"

myconf="--with-jpeg-library=/usr/lib \
	--with-jpeg-include=/usr/include \
	--with-tiff-library=/usr/lib \
	--with-tiff-include=/usr/include"

src_unpack ()
{
    gnustep-base_src_unpack

    # Header fix
    cd ${S}
    sed -ie "s:^ADDITIONAL_INCLUDE_DIRS\(.*\):ADDITIONAL_INCLUDE_DIRS\1 -I../Source/\$(GNUSTEP_TARGET_DIR):" Tools/GNUmakefile.preamble

    # FIXME: compilation bug workaround
    sed -ie "$ a\OPTFLAG = ${CFLAGS/O?/O1}" gui.make.in
}


# Local Variables:
# mode: sh
# End:
