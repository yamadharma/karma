# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/aide/aide-0.9.ebuild,v 1.12 2003/08/11 20:14:42 mholzer Exp $

inherit eutils extrafiles

IUSE="doc static"

MY_PN=${PN}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}


DESCRIPTION="Open Source File Integrity Checker and IDS (local use monitoring agent)"
HOMEPAGE="http://la-samhna.de/samhain/"
SRC_URI="http://la-samhna.de/archive/${MY_PN}_signed-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

RESTRICT=nostrip

DEPEND="virtual/glibc"

RDEPEND="${DEPEND}"

src_unpack () 
{
	unpack ${A}
	cd ${S}
	tar xzvf ${P}.tar.gz
}

src_compile () 
{
	local myconf=""
	
	myconf="${myconf} `use_enable static`"

	./configure \
	    --prefix=USR \
	    --sysconfdir=/etc/samhain \
	    --enable-suidcheck \
	    --with-log-file=/var/log/samhain/samhain.log \
	    --enable-login-watch \
	    --enable-mail \
	    --with-trusted=0 \
	    ${myconf} \
	    || die

	
	make || die
}

src_install () 
{
	make install DESTDIR=${D} || die

	dodoc COPYING
	dodoc example*.pl
	
	extrafiles_install
		
	cd ${S}/docs
	dohtml *.html
	dodoc README* BUGS Changelog TODO  

	if ( use doc )
	then
	    cd ${S}/docs
	    dodoc MANUAL*
	fi
}

pkg_postinst ()
{
	einfo "Samhain is installed but is NOT running yet, and the database of"
	einfo "file signatures is NOT initialized yet. Read the documentation,"
	einfo "review configuration files, and then (i) initialize it"
	einfo "(/usr/sbin/samhain -t init)"
	einfo "and (ii) start it manually"
	einfo "(/etc/init.d/samhain start)."
}

