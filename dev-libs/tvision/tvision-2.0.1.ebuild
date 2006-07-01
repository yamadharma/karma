# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"


S="${WORKDIR}/${PN}"
DESCRIPTION="Turbo Vision is a Borland-like TUI "
HOMEPAGE="http://tvision.sf.net"
SRC_URI="mirror://sourceforge/${PN}/rh${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
	>=dev-lang/perl-5
	sys-libs/ncurses
	sys-libs/gpm
	app-text/recode"

src_compile() 
{
	local myconf
	myconf="${myconf} --fhs"
	
	cd ${S}
        ./configure \
		--prefix=/usr \
		${myconf} || die "configure failed"

	make || die "make failed"
}

src_install() 
{

	make prefix=${D}/usr install || die "make install failed"
	
	cd ${S}
	dodoc doc/* 
	dodoc THANKS TODO borland.txt change*.log readme.txt

	dodir /usr/share/doc/${P}
	if use doc
	then
	  cp -R ${S}/examples ${D}/usr/share/doc/${P}
	  cp -R ${S}/extra ${D}/usr/share/doc/${P}
	fi

}

