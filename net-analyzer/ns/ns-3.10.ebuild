# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

NSC_PV=0.5.2

DESCRIPTION="Network Simulator"
HOMEPAGE="http://www.nsnam.org"
SRC_URI="http://www.nsnam.org/releases/ns-allinone-${PV}.tar.bz2
	http://research.wand.net.nz/software/nsc/nsc-${NSC_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

RDEPEND="dev-lang/python
	dev-python/pygccxml"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i -e "s|^NSC_RELEASE_URL =.*|NSC_RELEASE_URL = \"file://${DISTDIR}\"|" src/internet-stack/wscript
}

src_configure() {
	local myconf
	myconf="${myconf} --enable-nsc"
	
	./waf configure \
	    --prefix=/usr \
	    ${myconf} || die
}

src_compile() {
	./waf build
	if ( use examples )
	then
	    ./waf check
	    ./waf --doxygen
	fi	    
}

src_install() {
	DESTDIR=${D} ./waf install
	
	dodoc AUTHORS CHANGES.html LICENSE README RELEASE_NOTES VERSION
	cp waf ${D}/usr/share/doc/${PF}
	if ( use examples )
	then
	    cp -R examples ${D}/usr/share/doc/${PF}
	    cp -R samples ${D}/usr/share/doc/${PF}
	fi	    
}

