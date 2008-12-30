# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Sound (.wav) files from Real People Sound to pronounce English words"
HOMEPAGE="http://sourceforge.net/projects/stardict/"
SRC_URI="mirror://sourceforge/stardict/WyabdcRealPeopleTTS.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="!<app-dicts/stardict-3.0.1-r2"
RDEPEND=""

src_install() {
	dodir /usr/share
	mv "${WORKDIR}/WyabdcRealPeopleTTS" "${D}/usr/share"
}

