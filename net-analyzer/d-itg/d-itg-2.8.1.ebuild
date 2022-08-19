# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptraf-ng/iptraf-ng-1.1.4-r1.ebuild,v 1.9 2014/05/03 20:46:58 zlogene Exp $

EAPI=7
inherit eutils toolchain-funcs

MY_PN=D-ITG
MY_REV=1023

DESCRIPTION="D-ITG, Distributed Internet Traffic Generator"
HOMEPAGE="http://traffic.comics.unina.it/software/ITG/"
SRC_URI="https://traffic.comics.unina.it/software/ITG/codice/${MY_PN}-${PV}-r${MY_REV}-src.zip
	doc? ( http://traffic.comics.unina.it/software/ITG/manual/${MY_PN}-${PV}-manual.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="doc"

RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
S=${WORKDIR}/${MY_PN}-${PV}-r${MY_REV}

src_prepare() { :; }

# configure does not do very much we do not already control
src_configure() { :; }

src_compile() {
    cd ${S}/src
    emake
}

src_install() {
    dolib.so bin/*.so
    dobin bin/ITG*
    dobin src/ITGPlot/ITGplot

    doheader src/libITG/ITGapi.h

    exeinto usr/libexec/${PN}
    doexe tools/*

    dodoc CHANGELOG INSTALL README

    use doc && dodoc ${DISTDIR}/${MY_PN}-${PV}-manual.pdf
}
