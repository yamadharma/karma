# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools cvs

DESCRIPTION="CoolReader"
HOMEPAGE="http://crengine.sourceforge.net/"
# SRC_URI=""

ECVS_SERVER="crengine.cvs.sourceforge.net:/cvsroot/crengine"
ECVS_MODULE="cr3"
ECVS_USER="anonymous"

S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 arm"

IUSE=""
DEPEND="
	app-text/crengine
	sys-libs/zlib
	media-libs/libpng
	media-libs/jpeg
	media-libs/freetype
	media-fonts/corefonts
	app-arch/unzip
	x11-libs/wxGTK
	"
RDEPEND="${DEPEND}"

src_prepare() {
		sed -i -e "s:^AC_OUTPUT\(.*\)crengine/Makefile crengine/src/Makefile\(.*\)$:AC_OUTPUT\1\2:g" \
			-e "s:-I\.\./crengine/include:-I/usr/include/crengine:g" configure.in
		sed -i -e "s:^SUBDIRS\(.*\)crengine\(.*\)$:SUBDIRS\1\2:g" Makefile.am
		eautomake
}

src_configure() {
		econf \
		--enable-unicode \
		--enable-debug=no \
		|| die
}

src_install() {
		einstall || die
}
