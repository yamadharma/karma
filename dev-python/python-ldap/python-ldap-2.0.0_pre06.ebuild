# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-python/python-ldap/python-ldap-2.0.0_pre05-r1.ebuild,v 1.6 2002/12/15 10:44:19 bjb Exp $

VERSION="2.0.0pre05"
S=${WORKDIR}/${PN}-${VERSION}
DESCRIPTION="Various LDAP-related Python modules"
SRC_URI="mirror://sourceforge/python-ldap/python-ldap-${VERSION}.tar.gz"
HOMEPAGE="http://python-ldap.sourceforge.net/"

DEPEND="virtual/python
	>=net-nds/openldap-2.0.11"
SLOT="0"
LICENSE="public-domain" # NOTE: win32 section is under questionable license
KEYWORDS="x86 sparc alpha"

inherit distutils

src_compile() {
	mv setup.cfg setup.cfg.orig
	sed -e "s|/usr/local/openldap2/lib|/usr/lib|" \
	    -e "s|/usr/local/openldap2/include|/usr/include /usr/include/sasl|" \
		-e "s|libs = ldap lber|libs = ldap lber resolv sasl|" \
		setup.cfg.orig > setup.cfg || die

	distutils_src_compile 
}
