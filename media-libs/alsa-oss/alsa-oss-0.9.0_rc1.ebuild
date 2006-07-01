# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-libs/alsa-oss/alsa-oss-0.9.0_rc1.ebuild,v 1.12 2003/02/13 12:40:44 vapier Exp $

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Advanced Linux Sound Architecture OSS compatibility layer"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="ftp://ftp.alsa-project.org/pub/oss-lib/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc  ppc"

DEPEND="virtual/glibc 
	>=media-libs/alsa-lib-0.9.0_rc1"

src_compile() {				  
	econf || die "./configure failed"
	emake || die "Parallel Make Failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc COPYING
}
