# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

MY_PV=${PV/./_}

DESCRIPTION="Post-processing scanned and photocopied book pages"
HOMEPAGE="http://unpaper.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
DEPEND=""

S="${WORKDIR}"

src_compile() {
	cd src
	DATE=`date +"%F %T"`
	$(tc-getCC) ${CFLAGS} -lm -D TIMESTAMP=\""${DATE}\"" -o unpaper unpaper.c
}

src_install() {
	exeinto /usr/bin
	doexe src/unpaper || die
	
	sed -i "s:doc/img:img:g" unpaper.html || die
	sed -i "s:doc/index.html:index.html:g" unpaper.html || die
	sed -i "s:../unpaper.html:unpaper.html:" doc/index.html || die
	sed -i "s:doc/index.html:index.html:g" doc/index.html || die
	dohtml unpaper.html
	dohtml -r doc/
	dodoc readme.txt
}
