# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cuneiform/cuneiform-0.8.0.ebuild,v 1.1 2009/09/04 10:17:06 pva Exp $

EAPI="2"
inherit cmake-utils flag-o-matic

if [[ ${PV} == 9999 ]]
then
	inherit bzr
	EBZR_REPO_URI="lp:cuneiform-linux"
else
	inherit versionator

	PV_MAJ=$(get_version_component_range 1-2)
	MY_P=${PN}-linux-${PV}

	SRC_URI="http://launchpad.net/${PN}-linux/${PV_MAJ}/${PV_MAJ}/+download/${MY_P}.tar.bz2"

	S=${WORKDIR}/${MY_P}
fi


DESCRIPTION="An enterprise quality OCR engine developed in USSR/Russia in the 90's."
HOMEPAGE="https://launchpad.net/cuneiform-linux"


LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug +imagemagick"

RDEPEND="imagemagick? ( media-gfx/imagemagick )"
DEPEND=">=dev-util/cmake-2.6.2
	${RDEPEND}"

DOCS="readme.txt"

src_prepare(){
	# respect LDFLAGS
	sed -i 's:\(set[(]CMAKE_SHARED_LINKER_FLAGS "[^"]*\):\1 $ENV{LDFLAGS}:' \
		"${S}/cuneiform_src/CMakeLists.txt" || die "failed to sed for LDFLAGS"
	# Fix automagic dependencies / linking
	if ! use imagemagick; then
		sed -i "s:find_package(ImageMagick COMPONENTS Magick++):#DONOTFIND:" \
			"${S}/cuneiform_src/CMakeLists.txt" \
		|| die "Sed for ImageMagick automagic dependency failed."
	fi

	filter-flags -O1 -O2 -O3
}
