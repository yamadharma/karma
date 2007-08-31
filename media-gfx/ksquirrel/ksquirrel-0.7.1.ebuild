# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

MY_P="${PN}-${PV/_pre/-pre}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="An image viewer for KDE implementing OpenGL"
HOMEPAGE="http://ksquirrel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="kdeenablefinal kipi"

DEPEND="=media-libs/ksquirrel-libs-${PV}
	kipi? ( media-libs/libkipi )"
RDEPEND="${DEPEND}"

need-kde 3.3

src_install() {
	kde_src_install
	dodoc fmt_filters_README
}
