# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"

inherit eutils

DESCRIPTION="Port of 7-Zip archiver for Unix."
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~amd64"

DEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs )"

S=${WORKDIR}/${PN}_${PV}

src_compile () 
{
    if [ `use amd64` ] 
	then
	use multilib || die "You need to add 'multilib' to your USE-flags and re-emerge GCC!"
	sed -i -e "s:^CXX=\(.*\):CXX=\1 -m32:" \
	    -e "s:^CC=\(.*\):CC=\1 -m32:" makefile.glb
    fi
    
    make || die "compilation error"	
}

src_install () 
{
    dobin bin/7za
    
    dodir /usr/lib/7z
    cp -R bin/Codecs bin/Formats ${D}/usr/lib/7z
    cp bin/7z ${D}/usr/lib/7z
    dobin ${FILESDIR}/7z
    
    dodoc ChangeLog README TODO
    
    use doc && cp -R html ${D}/usr/share/doc/${P}
}

# Local Variables:
# mode: sh
# End:
