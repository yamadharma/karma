# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE="ldap doc"

S=${WORKDIR}/${P}
DESCRIPTION="amd automounter and utilities"
HOMEPAGE="http://www.am-utils.org"
SRC_URI="ftp://ftp.am-utils.org/pub/am-utils/${P}.tar.gz"

DEPEND="virtual/glibc
	ldap? ( >=net-nds/openldap-1.2 )"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

src_compile () 
{
	local myconf

	myconf="${myconf} `use_with ldap`"

	myconf="${myconf} --sysconfdir=/etc/amd"

	cd ${S}
	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install () 
{
    make DESTDIR=${D} install || die
    
    dodoc README* AUTHORS BUGS COPYING ChangeLog INSTALL LSM.am-utils MIRRORS ldap-id.txt tasks 
    
    if ( use doc ) then
	cd ${S}/doc
	dodoc *.ps	
    fi
    
    cp ${FILESDIR}/amd.conf ${D}/etc/amd
    cp ${FILESDIR}/amd.net ${D}/etc/amd

    exeinto /etc/init.d ; newexe ${FILESDIR}/amd.rc amd
}
