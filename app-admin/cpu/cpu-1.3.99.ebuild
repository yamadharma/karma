# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/superadduser/superadduser-1.0-r2.ebuild,v 1.6 2003/02/10 21:58:20 latexer Exp $

IUSE="ldap"

DESCRIPTION="Interactive adduser script"
SRC_URI="mirror://sourceforge/cpu/${P}.tar.gz"
HOMEPAGE="http://cpu.sf.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha "

RDEPEND="sys-apps/shadow
	sys-libs/cracklib
	ldap? net-nds/openldap"

DEPEND="${RDEPEND}"

src_compile()
{
  local myconf
  
  myconf="${myconf} `use_with ldap`"
	

  econf \
    --with-libcrack \
    --with-passwd \
    ${myconf}
    
  emake
}

src_install() 
{
  emake DESTDIR=${D} install
  dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
  cd ${S}/docs
  dodoc config_file_usage cpu.cfg mini_man rfc*
}
