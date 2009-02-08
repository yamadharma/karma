# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils versionator

PV_MAJ=$(get_version_component_range 1-2)

DESCRIPTION="An enterprise quality OCR engine developed in USSR/Russia in the 90's."
HOMEPAGE="https://launchpad.net/cuneiform-linux"
SRC_URI="http://launchpad.net/${PN}-linux/${PV_MAJ}/${PV_MAJ}/+download/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="mirror"

IUSE="imagemagick debug"

RDEPEND="imagemagick? ( media-gfx/imagemagick )"
DEPEND=">=dev-util/cmake-2.4.7
	${RDEPEND}"

DOCS="readme.txt"

S="${S}.0"

src_prepare() {
	if ! use imagemagick; then
		sed -e '/pkg_check_modules(MAGICK ImageMagick++)/s/^/#DONOTFIND /' \
			-i "${S}/cuneiform_src/Kern/CMakeLists.txt" \
		|| die "Sed for ImageMagick automagic dependency failed."
	fi
	# sys-devel/binutils-2.19 fixups
# 	epatch ${FILESDIR}/visibility.patch
}
