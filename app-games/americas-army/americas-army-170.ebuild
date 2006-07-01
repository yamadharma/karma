# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-games/americas-army/americas-army-170.ebuild,v 1.2 2003/06/21 18:56:44 vapier Exp $

inherit games

DESCRIPTION="military simulations by the U.S. Army to provide civilians with insights on Soldiering"
HOMEPAGE="http://www.americasarmy.com/"
SRC_URI="ftp://ftp.stenstad.net/mirrors/icculus.org/armyops-lnx-${PV}.sh.bin
	http://guinness.devrandom.net/%7Eprimus/armyops-lnx-${PV}.sh.bin"

LICENSE=""
SLOT="0"
KEYWORDS="x86"
RESTRICT="nostrip"

DEPEND="virtual/opengl"

S=${WORKDIR}

pkg_setup() {
	ewarn "The installed game takes about 850MB of space!"
	games_pkg_setup
}

src_unpack() {
	tail +266 ${DISTDIR}/${A} | tar xf - || die
	tar -zxf setupstuff.tar.gz || die
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir}

	tar -jxvf armyops${PV}System.tar.bz2 -C ${D}/${dir}/ || die
	tar -jxvf armyops${PV}data.tar.bz2 -C ${D}/${dir}/ || die

	dodoc README.linux
	insinto ${dir} ; doins ArmyOps.xpm
	exeinto ${dir} ; doexe bin/armyops

	sed -e "s:GENTOO_DIR:${dir}:" ${FILESDIR}/playamericas-army > playamericas-army
	dogamesbin playamericas-army
	dosym ${dir}/armyops ${GAMES_BINDIR}/armyops

	prepgamesdirs
}

pkg_postinst() {
	einfo "To play the game run:"
	einfo " playamericas-army"
	echo
	einfo "To run a dedicated server read:"
	einfo " /usr/share/doc/${PF}/README.linux.gz"

	games_pkg_postinst
}
