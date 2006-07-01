# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/vmoconv/vmoconv-1.0.ebuild,v 1.2 2005/10/10 19:26:16 mrness Exp $

DESCRIPTION="A tool that converts Siemens phones VMO and VMI audio files to gsm and wav."
HOMEPAGE="http://triq.net/obex/"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die
	# ugly workaround, otherwise make tries to build binaries before
	# necessary .la file is built
	cd src && make libgsm.la || die "make libgsm failed"
	cd ..
	emake || die "make failed"
}

src_install() {
	dobin src/vmo2gsm src/gsm2vmo src/vmo2wav
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
