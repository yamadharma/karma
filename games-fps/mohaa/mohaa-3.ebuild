# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/mohaa/mohaa-3.ebuild,v 1.1 2005/12/27 13:26:43 egore Exp $

inherit games

DESCRIPTION="Medal of Honor for Linux"
HOMEPAGE="http://icculus.org/betas/mohaa/"
SRC_URI="http://icculus.org/betas/${PN}/${PN}-lnxclient-beta${PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_install() {

	dodoc README || die "dodoc failed"
	rm README || die "removing docs failed"

	dodir "${GAMES_DATADIR}/${PN}" || die "dodir failed"
	cp * "${D}${GAMES_DATADIR}/${PN}" || die "cp failed"
	echo "#!/bin/sh
cd ${GAMES_DATADIR}/${PN}
./mohaa_lnx" > mohaa
	dogamesbin mohaa || die "dogamesbin failed"
	prepgamesdirs
}

pkg_postinst() {
	einfo "You need the data files from Medal of Honor in ${GAMES_DATADIR}/${PN}/main."
	einfo "For example you can symlink them to the directory with the following command"
	einfo ""
	einfo "ln -s /mnt/windows/Games/MOHAA/\* ${GAMES_DATADIR}/${PN}"
	einfo ""
	einfo "This will also use the configfile from your windows installation, but"
	einfo "you will have to allow writing for the file."
}
