# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Line breaking library"
HOMEPAGE="http://vimgadgets.cvs.sourceforge.net/vimgadgets/common/tools/linebreak/"
SRC_URI="mirror://debian/pool/main/libl/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}_fPIC.patch
}

src_compile() {
	emake release || die "emake failed"
}

src_install() {
	dolib.a ReleaseDir/liblinebreak.a
	insinto /usr/include
	doins linebreak.h

	dodoc ChangeLog
}
