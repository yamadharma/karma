# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/superadduser/superadduser-1.0-r2.ebuild,v 1.6 2003/02/10 21:58:20 latexer Exp $


DESCRIPTION="System tools to manipulate users and groups stored in LDAP directory"
SRC_URI="http://samba.idealx.org/dist/${P}.tgz"
HOMEPAGE="http://samba.idealx.org"
S=${WORKDIR}/${P}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha "

#RDEPEND="sys-apps/shadow"

src_compile()
{
  cd ${S}
  tar xzvf mkntpwd.tar.gz
  cd ${S}/mkntpwd
  make
  
  cd ${S}  
  sed "s:/usr/local/sbin/mkntpwd:/usr/sbin/mkntpwd:g" smbldap_conf.pm > smbldap_conf.pm.tmp
  mv -f smbldap_conf.pm.tmp smbldap_conf.pm
}

src_install()
{
  cd ${S}
  exeinto /usr/sbin
  doexe *.pl
  doexe mkntpwd/mkntpwd
  
  cd ${S}
  eval `perl '-V:installsitearch'`
  dodir $installsitearch
  cp smbldap_tools.pm ${D}/$installsitearch
  
  cd ${S}  
  dodir /usr/lib/perl5/site_perl
  dodir /etc
  cp smbldap_conf.pm ${D}/etc
#  dosym /etc/smbldap_conf.pm /usr/lib/perl5/site_perl/smbldap_conf.pm
  
  cd ${S}
  dodoc CONTRIBUTORS COPYING ChangeLog FILES INFRA INSTALL README TODO
}

src_postinstall()
{
  ##(512 = 0x200 = Domain Admins)
  cd /etc      
  chmod 753 /etc/smbldap_conf.pm
  chgrp 512 smbldap_conf.pm
  cd /usr/sbin
  chmod 750 smbldap-useradd.pl
  chgrp 512 smbldap-useradd.pl 
}