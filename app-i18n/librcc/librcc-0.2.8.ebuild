# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils

DESCRIPTION="LibRCC is Russian Encoding Conversion Library"
SRC_URI="http://dside.dyndns.org/files/rusxmms/librcc-${PV}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
DEPEND="app-i18n/librcd
	app-i18n/libguess 
	dev-libs/libxml2 
	sys-libs/db 
	app-i18n/enca 
	app-text/aspell 
	app-dicts/libtranslate"


src_unpack() {
    unpack ${P}.tar.bz2
#    cd "${S}"
#    epatch "${FILESDIR}"/rcc-debug.patch || die

# We are doing this because of ugly automake-wrapper which forces usage of 
# automake version refered in Makefile.in's. And librcc-0.2.8 is prepared with 
# 1.9 while 1.10 is standard now.
    cd ${P}
    rm -f `find . -name Makefile.in`
    rm -f configure
    rm -f aclocal.m4
}

src_compile() {
    ./autogen.sh || die
    econf || die
    make || die
    make -C examples || die
}

src_install() {
    into /usr
    mkdir -p ${D}/usr/lib
    mkdir -p ${D}/usr/include
    mkdir -p ${D}/usr/lib/rcc/engines
    mkdir -p ${D}/etc
    make install DESTDIR=${D} INSTALLTOP=${D}/usr || die
    rm -f ${D}/usr/lib/rcc/engines/*.a
    rm -f ${D}/usr/lib/rcc/engines/*.la
    install -m 644 examples/rcc.xml ${D}/etc
    
    make -C examples install DESTDIR=${D} INSTALLTOP=${D}/usr || die
    rm -f ${D}/usr/bin/example*
}
