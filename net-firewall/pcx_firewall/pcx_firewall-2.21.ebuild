# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Command line util for managing firewall rules"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
DEPEND=">=dev-lang/perl-5.6.1
	net-firewall/iptables"
	
RDEPEND="dev-lang/perl"
S=${WORKDIR}/${P}

src_install () 
{
#	dodir /usr
#	rm -rf ${D}/etc/rc.d
  cd ${S}
  tar xvzf pcx_firewall_perl-${PV}.tar.gz
  cd pcx_firewall_perl-${PV}
  perl Makefile.PL PREFIX=${D}/usr
  make
  make \
    PREFIX=${D}/usr \
    INSTALLMAN1DIR=${D}/usr/share/man/man1 \
    INSTALLMAN2DIR=${D}/usr/share/man/man2 \
    INSTALLMAN3DIR=${D}/usr/share/man/man3 \
    INSTALLMAN4DIR=${D}/usr/share/man/man4 \
    INSTALLMAN5DIR=${D}/usr/share/man/man5 \
    INSTALLMAN6DIR=${D}/usr/share/man/man6 \
    INSTALLMAN7DIR=${D}/usr/share/man/man7 \
    INSTALLMAN8DIR=${D}/usr/share/man/man8 \
  install \
  || die

  cd ${S}
  dodir /usr/lib/pcx_firewall
  cp -aRp usr/lib/pcx_firewall/* ${D}/usr/lib/pcx_firewall
  
  cd ${S}
  dodoc docs/*
  dodoc README
  docinto man; dodoc docs/man/*


  exeinto /etc/init.d ; newexe ${FILESDIR}/rc.d/2.17/pcx_firewall.rc pcx_firewall
#	insinto /etc/conf.d ; newins ${FILESDIR}/rc.d/pcx_firewall.confd pcx_firewall
}

#pkg_postinst() {
#}
