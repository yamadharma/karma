# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdegraphics
inherit kde4overlay-meta

DESCRIPTION="KDE image viewer"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook +semantic-desktop"
RESTRICT="test"

DEPEND="media-gfx/exiv2
	media-libs/jpeg
	semantic-desktop? ( kde-base/nepomuk:${SLOT} )"
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with semantic-desktop Nepomuk)"

	kde4overlay-meta_src_compile
}
