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

RDEPEND="dev-perl/perl-ldap"

src_compile ()
{
    cd ${S}
    tar xzvf mkntpwd.tar.gz
    cd ${S}/mkntpwd
    make
    
    cd ${S}  
    sed -i -e "s:/usr/local/sbin/mkntpwd:/usr/sbin/mkntpwd:g" smbldap.conf
}

src_install ()
{
    cd ${S}
    exeinto /usr/sbin
    doexe smbldap-*
    doexe mkntpwd/mkntpwd
    
    cd ${S}
    eval `perl '-V:installsitearch'`
    dodir $installsitearch
    cp smbldap_tools.pm ${D}/${installsitearch}
  
    cd ${S}  
    insinto /etc/smbldap-tools
    doins smbldap*.conf
    fperms 644 /etc/smbldap-tools/smbldap.conf
    fperms 600 /etc/smbldap-tools/smbldap_bind.conf
#    dosym /etc/samba/smbldap_conf.pm ${installsitearch}/smbldap_conf.pm
    
    cd ${S}
    dodoc CONTRIBUTORS COPYING ChangeLog FILES INFRA INSTALL README TODO smb.conf configure.pl
    
    cd ${S}
    for i in smbldap-*
	do
	pod2man $i > $i.1
    done	
    doman *.1
}

#src_postinstall ()
#{
## to allow a domain admin to add user using "add user script" in smb.conf :
## (512 = 0x200 = Domain Admins)
## In smb.conf : domain admin group = " @"Domain Admins" "
#    
#    cd /etc      
#    chmod 753 /etc/samba/smbldap_conf.pm
#    chgrp 512 /etc/samba/smbldap_conf.pm
#    
#    cd /usr/sbin
#    chmod 750 smbldap-useradd.pl
#    chgrp 512 smbldap-useradd.pl 
#}

# Local Variables:
# mode: sh
# End:

