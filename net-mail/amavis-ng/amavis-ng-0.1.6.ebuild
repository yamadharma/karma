# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/net-mail/amavis/amavis-0.2.1-r2.ebuild,v 1.7 2002/08/14 12:05:25 murphy Exp $

inherit perl-module

S=${WORKDIR}/${PN}-${PV}.orig
DESCRIPTION="Virus Scanner"
SRC_URI="mirror://sourceforge/amavis/${PN}_${PV}.orig.tar.gz"
#SRC_URI="http://www.amavis.org/dist/${P}.tar.gz"
HOMEPAGE="http://www.amavis.org"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 sparc sparc64"

#DEPEND="net-mail/maildrop
#	>=net-mail/tnef-0.13
#	>=net-mail/vlnx-407e
#	net-mail/qmail"

DEPEND="dev-perl/File-MMagic
	dev-perl/Compress-Zlib
	dev-perl/Archive-Tar
	dev-perl/Archive-Zip
	dev-perl/Config-IniFiles
	dev-perl/Convert-TNEF
	>=dev-perl/MIME-tools-5.411
	app-arch/unrar
	app-arch/zoo
	app-arch/arc
	app-arch/lha"

RDEPEND=${DEPEND}

src_unpack() 
{
  local myconf
  local mylibs
  unpack ${A}
  cd ${S}
  sed -e "s:.*amavis-milter.*$::g" Makefile.PL > Makefile.PL.tmp
  mv -f Makefile.PL.tmp Makefile.PL
}

src_install() 
{

  perl-module_src_install

  cd ${S}
  insinto /etc/amavis
  doins etc/amavis.conf
  
  dodoc doc/*
  docinto exim ; dodoc doc/exim/*
  docinto sendmail ; dodoc doc/sendmail/*        
}
