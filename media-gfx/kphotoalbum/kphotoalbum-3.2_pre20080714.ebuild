# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
NEED_KDE="svn"

inherit kde4svn

PREFIX="${KDEDIR}"

DESCRIPTION="KDE Photo Album is a tool for indexing, searching, and viewing images."
HOMEPAGE="http://www.kphotoalbum.org/"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/extragear/graphics/kphotoalbum/@830392"
#${PV/3.2_pre/}

LICENSE="GPL-2"
SLOT="kde-svn"
RDEPEND="${DEPEND}"
IUSE="exif raw"

KEYWORDS=""
DEPEND="
	dev-db/sqlite:3
	raw? ( kde-base/libkdcraw:${SLOT} )
	exif? ( kde-base/libkexiv2:${SLOT} )
	kde-base/libkipi:${SLOT}
	>=media-libs/jasper-1.7.0
	media-libs/jpeg
	>=media-libs/lcms-1.14.0
	>=media-libs/libgphoto2-2.4.0
	>=media-libs/libpng-1.2.7
	>=media-libs/tiff-3.8.2
	"

RDEPEND="${DEPEND}"

src_unpack() {
	kde4svn_src_unpack
	epatch "${FILESDIR}/actualize.patch"
}
