# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-www/apache/apache-2.0.44.ebuild,v 1.5 2003/02/23 19:39:22 woodchip Exp $

IUSE=""

inherit perl-module extrafiles

DESCRIPTION="Caudium Web Server"
HOMEPAGE="http://software.eprints.org/"
SRC_URI="http://software.eprints.org/files/eprints2/${P}.tar.gz"

S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha hppa"

DEPEND="dev-perl/URI
	dev-perl/Unicode-String
	dev-perl/XML-Parser
	dev-perl/XML-GDOME
	dev-perl/Digest-MD5
	dev-perl/Data-Dumper
	dev-perl/Data-ShowTable
	dev-perl/DBD-mysql"
	
RDEPEND="${DEPEND}"

pkg_preinst () 
{
    enewgroup eprints 1010
    enewuser eprints 1010 /dev/null /opt/eprints2 eprints
}

	
src_compile() 
{
    local myconf
    myconf="${myconf} --enable-gdome"
    
    
    cd ${S}
    
    econf \
	${myconf}
    
#    emake || die "Compile error"
  
}

src_install () 
{
    ./install.pl prefix=${D}/opt/eprints2    
#    make install_alt prefix=/usr DESTDIR=${D} 
    
#    mv ${D}/usr/share/doc/caudium ${D}/usr/share/doc/${P}
    
    extrafiles_install
}    


# Local Variables:
# mode: sh
# End:


