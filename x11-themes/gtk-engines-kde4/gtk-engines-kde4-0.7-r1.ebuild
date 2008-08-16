# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils qt4 cmake-utils

DESCRIPTION="GTK+2 Qt4 Theme Engine"
MY_PN="gtk-kde4"
HOMEPAGE="http://kde-apps.org/content/show.php/${MY_PN}?content=74689"
SRC_URI="http://kde-apps.org/CONTENT/content-files/74689-${MY_PN}v${PV}.tar.gz"

LICENSE="GPL-2"
# no keywords for now
# Sweet Zombie Jesus, at least leave the variable empty. --Diskmaster
KEYWORDS="amd64 x86"
# KEYWORDS=""
IUSE="themes"
RDEPEND="${RDEPEND}
	>=x11-libs/qt-4.3:4
	>=kde-base/kdelibs-4.0
	>=x11-libs/gtk+-2.2
	themes? ( x11-themes/gtk-kde4-theme )"
DEPEND="${RDEPEND}"

SLOT="0"

S=${WORKDIR}/${MY_PN}

src_compile() {
	epatch "${FILESDIR}"/move_theme.patch
	cmake . || die "cmake failed" # becouse it can't handle current dir other then "${S}"
	emake || die "emake failed"
}
