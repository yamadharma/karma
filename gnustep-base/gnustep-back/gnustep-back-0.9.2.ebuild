# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-back/gnustep-back-0.8.7.ebuild,v 1.1 2003/07/13 21:01:17 raker Exp $

inherit gnustep-base

DESCRIPTION="GNUstep GUI backend"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"

DEPEND=">=gnustep-base/gnustep-gui-${PV}*
    	>=media-libs/tiff-3.5.7
    	>=media-libs/jpeg-6b-r2
	>=media-libs/freetype-2*
	virtual/x11
	>=x11-wm/windowmaker-0.80.1
	media-libs/libart_lgpl"

RDEPEND="${DEPEND}
	${RDEPEND}
	media-fonts/freefont"

S=${WORKDIR}/${P}


# For a different graphics library... choose one
#
# myconf="--enable-graphics=xdps --with-name=xdps"
#
# -OR-
#
# make sure you have libart_lgpl installed and...
#
# myconf="--enable-graphics=art --with-name=art"

myconf="--enable-graphics=art"

myconf="${myconf} \
    	--with-jpeg-library=/usr/lib \
       	--with-jpeg-include=/usr/include \
       	--with-tiff-library=/usr/lib \
       	--with-tiff-include=/usr/include \
	--with-x \
	--enable-server=x11"


# Local Variables:
# mode: sh
# End:

