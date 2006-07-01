# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-back/gnustep-back-0.8.0.ebuild,v 1.4 2003/02/28 16:54:59 liquidx Exp $

DESCRIPTION="GNUstep GUI backend"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc -sparc "
DEPEND=">=dev-util/gnustep-gui-0.8.0
        >=media-libs/tiff-3.5.7
        >=media-libs/jpeg-6b-r2
	x11-base/xfree"
S=${WORKDIR}/${P}

src_compile() {

	. /usr/GNUstep/System/Makefiles/GNUstep.sh

        ./configure --prefix=/usr/GNUstep \
                --with-jpeg-library=/usr/lib \
                --with-jpeg-include=/usr/include \
                --with-tiff-library=/usr/lib \
                --with-tiff-include=/usr/include \
		--with-x \
                || die "configure failed"

        make || die

}

src_install () {

	. /usr/GNUstep/System/Makefiles/GNUstep.sh

        make \
                GNUSTEP_INSTALLATION_DIR=${D}/usr/GNUstep/System \
                INSTALL_ROOT_DIR=${D} \
                install || die "install failed"

}
