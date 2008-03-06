# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils

EXT_VER="d7"

DESCRIPTION="LibGuess is Encoding Detection Library for Japanese, Chinese, Korean and Thai Languages"
SRC_URI="http://www.honeyplanet.jp/${P}-${EXT_VER}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

S=${WORKDIR}/${P}-${EXT_VER}

src_unpack() {
    unpack ${P}-${EXT_VER}.tar.gz || die
    epatch "${FILESDIR}"/libguess-ds-cn.patch || die
}

src_compile() {
    make || die
}

src_install() {
    into /usr
    mkdir -p ${D}/usr/lib
    mkdir -p ${D}/usr/include
    make install PREFIX=${D}/usr
}
