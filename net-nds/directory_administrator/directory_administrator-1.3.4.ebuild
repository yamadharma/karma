# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

S=${WORKDIR}/${P}
DESCRIPTION="User/group/access control management tool for LDAP directories"
SRC_URI="http://diradmin.open-it.org/${P}.tar.gz"
HOMEPAGE="http://diradmin.open-it.org"
IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	gnome-base/gnome-libs
	>=net-nds/openldap-2"

src_compile() {
	local myconf="--with-gnome"

    econf $myconf || die "./configure failed"
	
    emake || die "Compilation failed"
}

src_install() {
    einstall || die "Installation failed"
	
    dodoc ABOUT-NLS AUTHORS ChangeLog COPYING NEWS README* TODO
    
    cd ${S}
    cd doc
    dodoc *

    docinto pam.d
    dodoc pam.d/* 

    docinto misc_docs
    dodoc misc_docs/*
    
}
