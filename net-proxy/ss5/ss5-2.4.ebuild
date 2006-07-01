# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-misc/dante/dante-1.1.14-r1.ebuild,v 1.1 2003/12/08 22:00:43 agriffis Exp $

inherit patch extrafiles

IUSE="${IUSE} pam ldap"

DESCRIPTION="SS5 is a socks server that implements the SOCKS v4 and v5 protocol"
HOMEPAGE="http://digilander.libero.it/matteo.ricchetti"
SRC_URI="http://digilander.libero.it/matteo.ricchetti/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~hppa"


DEPEND="virtual/glibc
	pam? sys-libs/pam
	ldap? ( net-nds/openldap )"

src_compile () 
{
    rm -r Makefile
    if [ `use pam` -a `use ldap` ]
	then
	ln -sf ./Linux/Makefile_openldap_pam_slb.lx Makefile
    else
        if [ `use pam` ]
	    then
	    ln -sf ./Linux/Makefile_pam.lx Makefile
        else
    	    if [ `use ldap` ]
		then
		ln -s ./Linux/Makefile_openldap.lx Makefile
	    fi
	fi    
    fi
    
    emake || die "compile problem"
}

src_install () 
{
    cd ${S}/man
    rm -f *.bz2
    gzip -d *.gz
    
    cd ${S}
    make dst_dir=${D} install || die
    
    rm -rf ${D}/etc/rc.d
    rm -rf ${D}/usr/share/doc
    rm -rf ${D}/usr/share/man

    extrafiles_install
    
    cd ${S}/man
    doman *
    
    # install documentation
    cd ${S}
    dodoc ChangeLog README*
    docinto conf
        cd ${S}/conf
        dodoc *
    docinto ldap
        cd ${S}/ldap
        dodoc *
    docinto pam
        cd ${S}/pam
        dodoc *
}
