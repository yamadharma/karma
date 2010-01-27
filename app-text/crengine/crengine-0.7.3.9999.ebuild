# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cvs

DESCRIPTION="CoolReader Engine"
HOMEPAGE="http://crengine.sourceforge.net/"
# SRC_URI=""

ECVS_SERVER="crengine.cvs.sourceforge.net:/cvsroot/crengine"
ECVS_MODULE="${PN}"
ECVS_USER="anonymous"

S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 arm"

IUSE="doc"
DEPEND="
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
#	epatch ${FILESDIR}/loses_precision.patch
	NOCONFIGURE=1 ./autogen.sh
}

src_install() {
	einstall || die

	insinto /usr/include/${PN}
	doins include/*.h

	use doc && dodoc docs/*
}

