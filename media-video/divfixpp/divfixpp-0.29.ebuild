# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets

MY_P="DivFix++_v${PV}"

DESCRIPTION="Repair broken AVI file streams by rebuilding index part of file."
HOMEPAGE="http://divfixpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=x11-libs/wxGTK-2.8
	sys-devel/gettext"

RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	export WX_GTK_VER="2.8"
	need-wxwidgets unicode
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/makefile.patch
}

src_compile() {
	emake WXCONFIG=${WX_CONFIG} || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc docs/Change.log docs/ReadMe.txt
}
