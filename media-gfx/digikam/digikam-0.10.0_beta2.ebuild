# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_KDE="4.1"

SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.bz2"
inherit kde4overlay-base

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"

LICENSE="GPL-2"
SLOT="4.1"
RDEPEND="${DEPEND}"
IUSE="addressbook marble"

S="${WORKDIR}/${P/_/-}"

KEYWORDS="amd64 x86"
DEPEND="
	dev-db/sqlite:3
	kde-base/libkdcraw:${SLOT}
	kde-base/libkexiv2:${SLOT}
	kde-base/libkipi:${SLOT}
	>=media-libs/jasper-1.7.0
	media-libs/jpeg
	>=media-libs/lcms-1.14.0
	>=media-libs/libgphoto2-2.4.0
	>=media-libs/libpng-1.2.7
	>=media-libs/tiff-3.8.2
	addressbook? ( kde-base/kdepimlibs:${SLOT} )
	marble? ( kde-base/marble )
	"

# No ebuild?
# liblensfun      >= 0.1.0                        http://lensfun.berlios.de
# Optional to support LensCorrection editor plugin.
#WITH_Freetype                    ON

RDEPEND="${DEPEND}"

# Install to KDEDIR to slot it.
PREFIX="${KDEDIR}"
# Search for the dependencies in KDEDIR.
PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${KDEDIR}/$(get_libdir)/pkgconfig"
