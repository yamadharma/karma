# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Displays a sphere being turned inside out via the Thurston eversion"
HOMEPAGE="http://www.dgp.toronto.edu/~mjmcguff/eversion/"
MY_PN="${PN/-e/E}"
MY_P="${MY_PN}-${PV}"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="
	|| (
		(
			x11-libs/libX11
			x11-proto/xproto
		)
		virtual/x11
	)
	virtual/opengl"

src_unpack() {
	unpack ${A}
	pushd ${S}
	ln -s Makefile.linux Makefile
	cp ${FILESDIR}/vroot.h .
	popd
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/lib/misc/xscreensaver
	exeinto /usr/lib/misc/xscreensaver
	doexe ${MY_PN}
}
