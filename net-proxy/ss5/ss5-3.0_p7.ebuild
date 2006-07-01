# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-misc/dante/dante-1.1.14-r1.ebuild,v 1.1 2003/12/08 22:00:43 agriffis Exp $

inherit eutils

IUSE="${IUSE} pam ldap"

REV=mr${PV/*_p}
MY_P=${PN}-${PV/_p*}${REV}

S=${WORKDIR}/${PN}-${PV/_p*}

DESCRIPTION="SS5 is a socks server that implements the SOCKS v4 and v5 protocol"
HOMEPAGE="http://digilander.libero.it/matteo.ricchetti"
SRC_URI="http://digilander.libero.it/matteo.ricchetti/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~hppa"


DEPEND="virtual/glibc
	dev-libs/openssl
	sys-libs/gdbm
	pam? sys-libs/pam
	ldap? ( net-nds/openldap )"

src_unpack () 
{
    unpack ${A}

    cd ${S}
    
    rm -r Makefile
    ln -sf ./build/linux/Makefile Makefile

    ln -s src core
    
    sed -i -e "s:/etc/opt:/etc:g" src/SS5Utils.c
    sed -i -e "s:/etc/opt:/etc:g" src/SS5Main.c
    sed -i -e "s:/etc/opt:/etc:g" modules/mod_authen/basic/SS5Basic.c
    sed -i -e "s:/etc/opt:/etc:g" modules/mod_author/SS5Mod_authorization.c
}

src_compile () 
{
    emake || die "compile problem"
}

src_install () 
{
    cd ${S}
    make dst_dir=${D} install || die
    
    rm -rf ${D}/etc/rc.d
    rm -rf ${D}/usr/share/doc
    rm -rf ${D}/usr/share/man

    newconfd ${FILESDIR}/ss5.confd ss5
    newinitd ${FILESDIR}/ss5.initd ss5
    
    cd ${S}/man/linux
    doman *
    
    # install documentation
    cd ${S}
    dodoc ChangeLog
    
    cp -R ${S}/doc/* ${D}/usr/share/doc/${PF}
}
