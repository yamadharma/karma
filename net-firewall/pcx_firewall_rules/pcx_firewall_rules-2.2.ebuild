# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

#inherit perl-module

DESCRIPTION="Rules for PCX-Firewall"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
DEPEND=">=dev-lang/perl-5.6*
	>=net-misc/pcx_firewall-2.16
	>=dev-libs/libxml2-2.4.11
	>=dev-perl/XML-SAX-0.10
	>=dev-perl/XML-LibXML-1.40
	net-firewall/iptables"
RDEPEND="dev-lang/perl"
S=${WORKDIR}/${P}

src_unpack ()
{
  unpack ${A}
  cd ${S}
  tar -xzf ${PN}_perl-${PV}.tar.gz
}

#mydoc="convert.pl convert2.pl docs/VeryTight.html"

src_install () {
#	dodir ${D}/usr
#	./install -p ${D} -r
#	rm -rf ${D}/usr/etc/rc.d
#  doman 
#  perl-module_src_install 
  cd ${S}/${PN}_perl-${PV}
  perl Makefile.PL PREFIX=${D}/usr/lib/perl5
  make \
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
  mv -f ${D}/usr/lib/perl5/lib/* ${D}/usr/lib/perl5
  rm -rf ${D}/usr/lib/perl5/lib

  # now put the support files in their locations.
  cd ${S}
  mkdir -p ${D}/usr/lib/pcx_firewall/PCXFireWall
  cp -ap usr/lib/pcx_firewall/PCXFireWall/* ${D}/usr/lib/pcx_firewall/PCXFireWall
  
#  rm -rf ${D}/usr/share/doc
  dodoc README Changes convert.pl convert2.pl docs/VeryTight.html
}

#pkg_postinst() {
#}
