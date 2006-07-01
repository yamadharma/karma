# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

S=${WORKDIR}/${PN}
DESCRIPTION="Utility for opening arj archives."
HOMEPAGE="http://arj.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL"
KEYWORDS="~x86 ~ppc ~sparc "

DEPEND=""

RESTRICT=nostrip

src_compile() 
{
    cd ${S}
    cd gnu
    autoconf
    econf || die
    cd ../
    make prepare || die
    make package || die
}

src_install() 
{
    cd ${S}/linux-gnu/en/rs/u
    dobin bin/*
    dodoc doc/arj/*
    
    cd ${S}
    dodoc ChangeLog
}
