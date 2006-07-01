# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib toolchain-funcs cvs

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/tvision"
ECVS_USER="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/sourceforge.net/${PN}"

IUSE="doc"

S="${WORKDIR}/${PN}"

DESCRIPTION="Turbo Vision is a Borland-like TUI "
HOMEPAGE="http://tvision.sf.net"
#SRC_URI="mirror://gentoo/${P}.tar.bz2
#	http://dev.gentoo.org/~azarah/rhide/${P}.tar.bz2"

# AUX_PV=-1
# SRC_URI="mirror://sourceforge/${PN}/rh${P/-/_}${AUX_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="2.1"
KEYWORDS="x86"

DEPEND="virtual/glibc
	>=dev-lang/perl-5
	sys-libs/ncurses
	sys-libs/gpm
	app-text/recode"

src_compile () 
{
	local myconf
	myconf="${myconf} --fhs"
	myconf="${myconf} --with-pthread"
	
	CC=$(tc-getCC) CXX=$(tc-getCXX) \
        ./configure \
		--prefix=/usr \
		--x-include="${ROOT}/usr/include" \
		--x-lib="${ROOT}/usr/$(get_libdir)" \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install () 
{

	einstall || die "make install failed"
	
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

