# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 eutils

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}-src-x11.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${P}-src"

DEPEND="${RDEPEND}
	>=x11-libs/qt-core-4.5
	>=x11-libs/qt-gui-4.5
	>=x11-libs/qt-webkit-4.5"
RDEPEND="dev-libs/libzip
	media-libs/libvorbis
	>=app-text/hunspell-1.2"


src_prepare() {
	epatch ${FILESDIR}/gcc-4.4-fix.patch
}

src_compile() {
	PREFIX=/usr eqmake4 ${PN}.pro
	emake || die "emake failed"
	lrelease ${PN}.pro || die "failed to compile locale"
}

src_install() {
	emake -j1 INSTALL_ROOT="${D}" install || die 'make install failed'	
	# install icon
	newicon icons/programicon.png ${PN}.png
	# create desktop entry
	make_desktop_entry ${PN} GoldenDict ${PN}.png "Qt;Utility;Dictionary;"
	# install locale
	insinto /usr/share/apps/${PN}/locale
	doins locale/*.qm
}

