# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Rules for PCX-Firewall"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
DEPEND=">=dev-lang/perl-5.6*
	>=net-firewall/pcx_firewall-2.17
	>=dev-libs/libxml2-2.4.11
	>=dev-perl/XML-SAX-0.10
	>=dev-perl/XML-LibXML-1.40
	net-firewall/iptables"
RDEPEND="dev-lang/perl"
S=${WORKDIR}/${P}

src_install () 
{
#	dodir /usr
#	./install -p ${D}
#	rm -rf ${D}/usr/etc/rc.d
  cd ${S}
  tar xvzf ${PN}_perl-${PV}.tar.gz
  cd ${PN}_perl-${PV}
  perl Makefile.PL \
    PREFIX=${D}/usr
  make
  
#  make \
#    PREFIX=${D}/usr \
#    SITEPREFIX=${D}/usr \
#    INSTALLMAN1DIR=${D}/usr/share/man/man1 \
#    INSTALLMAN2DIR=${D}/usr/share/man/man2 \
#    INSTALLMAN3DIR=${D}/usr/share/man/man3 \
#    INSTALLMAN4DIR=${D}/usr/share/man/man4 \
#    INSTALLMAN5DIR=${D}/usr/share/man/man5 \
#    INSTALLMAN6DIR=${D}/usr/share/man/man6 \
#    INSTALLMAN7DIR=${D}/usr/share/man/man7 \
#    INSTALLMAN8DIR=${D}/usr/share/man/man8 \
#  all pure_install doc_install \
#  || die
  
  make install

  cd ${S}
  dodir /usr/lib/pcx_firewall
  cp -aRp usr/* ${D}/usr
  
  cd ${S}
  dodoc docs/*
  dodoc README Changes convert.pl convert2.pl

}

#pkg_postinst() {
#}
