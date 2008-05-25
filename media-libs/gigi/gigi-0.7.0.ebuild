# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib eutils

MY_PN=GG
MY_P=${MY_PN}-${PV}

DESCRIPTION="GiGi is a small, efficient, and feature-rich C++ GUI for SDL and OpenGL. 
It is uses frame-based rendering and has fully customizable graphics, making it ideal 
for use in low- or high-frame rate applications and games."

HOMEPAGE="http://gigi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

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

S=${WORKDIR}/${MY_P}

bool_use() {
	if use $1; then echo 1; else echo 0; fi
}

vscons() {
	echo $*
	scons "$@"
}

src_unpack() {
	unpack ${A}
	
	cd ${S}
	
#	epatch ${FILESDIR}/gigi-sconspatch.patch
	sed "s|'ln -s ' + lib_dir + '/'|'ln -s '|g" -i SConstruct
}

src_compile() {
	export LIBPATH=/usr/$(get_libdir)/
	vscons libdir=/usr/$(get_libdir)/ build_sdl_driver=$(bool_use sdl) \
		build_ogre_driver=$(bool_use ogre) \
		build_ogre_ois_plugin=$(bool_use ois) \
		|| die
}

# dies ^^ here with:
# KeyError: 'LIBPATH':
#   File "/var/tmp/portage/games-strategy/gigi-0.7.0/work/GG-0.7.0/SConstruct", line 636:
#     CreateGiGiPCFile(['GiGi.pc'], ['GiGi.pc.in'], env)
#   File "/var/tmp/portage/games-strategy/gigi-0.7.0/work/GG-0.7.0/build_support.py", line 91:
#     for path in env['LIBPATH']:
#   File "//usr/lib64/scons-0.97/SCons/Environment.py", line 309:
#     return self._dict[key]


src_install() {
	scons prefix="${D}"/usr/ pkgconfigdir="${D}"/usr/lib/pkgconfig install || die

	#is this really necessary?
	for dir in GiGi GiGiNet GiGiSDL; do
		sed "s_${D}_/_g" -i ${D}/usr/lib/pkgconfig/${dir}.pc
	done
}
