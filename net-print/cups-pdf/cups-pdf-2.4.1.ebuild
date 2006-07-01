# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups-pdf/cups-pdf-2.4.1.ebuild,v 1.1 2006/06/19 19:53:55 genstef Exp $

inherit toolchain-funcs multilib

DESCRIPTION="Provides a virtual printer for CUPS to produce PDF files."
HOMEPAGE="http://cip.physik.uni-wuerzburg.de/~vrbehr/cups-pdf/"
SRC_URI="http://cip.physik.uni-wuerzburg.de/~vrbehr/cups-pdf/src/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="net-print/cups
	virtual/ghostscript"

src_compile() {
	cd src
	$(tc-getCC) ${CFLAGS} -o cups-pdf cups-pdf.c || die "Compilation failed."
}

src_install () {
	exeinto $(cups-config --serverbin)/backend
	has_version '>=net-print/cups-1.2*' && exeopts -m0700
	doexe src/cups-pdf

	insinto /usr/share/cups/model
	doins extra/PostscriptColor_rev3b.ppd.gz
	doins extra/PostscriptColor_rev4.ppd.gz
	dosym PostscriptColor_rev3b.ppd.gz /usr/share/cups/model/PostscriptColor.ppd.gz

	insinto /etc/cups
	doins extra/cups-pdf.conf

	dodoc ChangeLog README
	newdoc contrib/Contents contrib_Contents
}

pkg_postinst () {
	einfo "Please view both the README and contrib_Contents files"
	einfo "as you may want to adjust some settings and/or use"
	einfo "contributed software. In the latter case you may need"
	einfo "to extract some files from the ${P} distfile."
}
