# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://gigi.svn.sourceforge.net/svnroot/gigi/trunk/GG"

inherit multilib eutils subversion

MY_PN=GG
MY_P=${MY_PN}-${PV}

DESCRIPTION="GiGi is a small, efficient, and feature-rich C++ GUI for SDL and OpenGL. 
It is uses frame-based rendering and has fully customizable graphics, making it ideal 
for use in low- or high-frame rate applications and games."

HOMEPAGE="http://gigi.sourceforge.net/"
# SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE="ogre ois sdl"

CDEPEND="media-libs/devil
		media-libs/freetype
		dev-libs/boost
		media-libs/sdl-net
		ogre? ( dev-games/ogre )
		ois? ( dev-games/ois )
		sdl? ( media-libs/libsdl )"

DEPEND="${CDEPEND} dev-util/scons"

RDEPEND="${CDEPEND}"

# S=${WORKDIR}/${MY_P}

bool_use() {
	if use $1; then echo 1; else echo 0; fi
}

vscons() {
	echo $*
	scons "$@"
}

src_unpack() {
#	unpack ${A}
	subversion_src_unpack
	
	cd ${S}
	
	epatch ${FILESDIR}/gigi-sconspatch.patch
	sed "s|'ln -s ' + lib_dir + '/'|'ln -s '|g" -i SConstruct
}

src_compile() {
	scons configure
	vscons libdir=/usr/$(get_libdir)/ build_sdl_driver=$(bool_use sdl) \
		build_ogre_driver=$(bool_use ogre) \
		build_ogre_ois_plugin=$(bool_use ois) \
		|| die
}

src_install() {
	scons prefix="${D}"/usr/ \
	    libdir="${D}"/usr/$(get_libdir)/ \
	    pkgconfigdir="${D}"/usr/$(get_libdir)/pkgconfig \
	    install || die

	#is this really necessary?
	for dir in GiGi GiGiNet GiGiSDL; do
		sed "s_${D}_/_g" -i ${D}/usr/$(get_libdir)/pkgconfig/${dir}.pc
	done
}
