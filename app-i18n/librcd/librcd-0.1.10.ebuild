# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils

DESCRIPTION="LibRCD is Russian Encoding Detection Library"
SRC_URI="http://dside.dyndns.org/files/rusxmms/librcd-${PV}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

src_unpack() {
    unpack ${P}.tar.bz2
}

src_compile() {
    ./autogen.sh
    econf
    make
}

src_install() {
    into /usr
    mkdir -p ${D}/usr/lib
    mkdir -p ${D}/usr/include
    make install DESTDIR=${D} INSTALLTOP=${D}/usr
}
