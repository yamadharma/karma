# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 eutils cmake

S=${WORKDIR}/devil-${PV}/DevIL/

DESCRIPTION="DevIL image library"
HOMEPAGE="http://openil.sourceforge.net/"
EGIT_REPO_URI="https://github.com/DentonW/DevIL.git"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="allegro cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 gif glut jpeg mng nvtt openexr opengl png sdl static-libs tiff X xpm"

RDEPEND="
	allegro? ( media-libs/allegro:0 )
	gif? ( media-libs/giflib:= )
	glut? ( media-libs/freeglut )
	jpeg? ( virtual/jpeg:0 )
	mng? ( media-libs/libmng:= )
	nvtt? ( media-gfx/nvidia-texture-tools )
	openexr? ( media-libs/openexr:= )
	opengl? ( virtual/opengl
			virtual/glu )
	png? ( media-libs/libpng:0= )
	sdl? ( media-libs/libsdl )
	tiff? ( media-libs/tiff:0 )
	X? ( x11-libs/libXext
		 x11-libs/libX11
		 x11-libs/libXrender )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_static="$(usex static-libs)"
		--disable-lcms
		--enable-ILU
		--enable-ILUT
		-DENABLE_sse="$(usex cpu_flags_x86_sse)"
		-DENABLE_sse2="$(usex cpu_flags_x86_sse2)"
		-DENABLE_sse3="$(usex cpu_flags_x86_sse3)"
		-DENABLE_exr="$(usex openexr)"
		-DENABLE_gif="$(usex gif)"
		-DENABLE_jpeg="$(usex jpeg)"
		--enable-jp2
		-DENABLE_mng="$(usex mng)"
		-DENABLE_png="$(usex png)"
		-DENABLE_tiff="$(usex tiff)"
		-DENABLE_xpm="$(usex xpm)"
		-DENABLE_allegro="$(usex allegro)"
		--disable-directx8
		--disable-directx9
		-DENABLE_opengl="$(usex opengl)"
		-DENABLE_sdl="$(usex sdl)"
		-DENABLE_x11="$(usex X)"
		-DENABLE_shm="$(usex X)"
		-DENABLE_render="$(usex X)"
		-DENABLE_glut="$(usex glut)"
		-DWITH_x="$(usex X)"
		-DWITH_nvtt="$(usex nvtt)"
	)
	cmake_src_configure
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
