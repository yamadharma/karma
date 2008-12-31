# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://commanderstalin.sourceforge.net/"
SRC_URI="mirror://sourceforge/commanderstalin/cstalin-${PV}-linux.tar.gz"

KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S=${WORKDIR}/cstalin-${PV}-linux

RDEPEND="dev-lang/lua
	virtual/opengl
	amd64? ( app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-soundlibs
		>=app-emulation/emul-linux-x86-xlibs-7.0
		)
	!games-strategy/cstalin"

DEPEND=""

dir=${GAMES_PREFIX_OPT}/cstalin

src_install() {
	dodir ${dir}
	cp -R * ${D}/${dir}
	games_make_wrapper cstalin ./cstalin "${dir}" "${dir}"

	prepgamesdirs
	make_desktop_entry cstalin "Commander Stalin" cstalin

	dodoc CHANGELOG COPYRIGHT.txt LICENSE.txt README.txt
	cd ${D}/${dir}
	rm CHANGELOG COPYRIGHT.txt LICENSE.txt README.txt
}
