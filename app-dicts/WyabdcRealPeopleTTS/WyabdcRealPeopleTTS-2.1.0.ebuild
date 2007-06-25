# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Real People Sound"
HOMEPAGE="http://sourceforge.net/projects/stardict/"
SRC_URI="mirror://sourceforge/stardict/${PN}.tar.bz2"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=""
RESTRICT="primaryuri"

src_install() {
	dodir /usr/share/WyabdcRealPeopleTTS
	cd ${WORKDIR}/WyabdcRealPeopleTTS
	for SUBDIR in *
	do
		if [ -d $SUBDIR ]
		then
				dodir /usr/share/WyabdcRealPeopleTTS/$SUBDIR
				insinto /usr/share/WyabdcRealPeopleTTS/$SUBDIR
				doins $SUBDIR/*.wav
		fi
	done
}

