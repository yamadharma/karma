# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE=""

DESCRIPTION="Submount is a new attempt to solve the removable media problem for Linux."
HOMEPAGE="http://submount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"

DEPEND="virtual/linux-sources"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"

case "${KV}" in
    2.4*)
	S=${WORKDIR}/${PN}-2.4-${PV}
	EXTRA_V=-2.4
	;;
    *)
	S=${WORKDIR}/${P}
	EXTRA_V=""
	;;
esac


src_unpack () 
{
    case "${KV}" in
	2.4*)
	    unpack ${PN}-2.4-${PV}.tar.gz
	    EXTRA_V=-2.4
	    ;;
	*)
	    unpack ${P}.tar.gz
	    ;;
    esac
}

src_compile () 
{
    cd ${S}
    case "${KV}" in
	2.4*)
	    cd subfs${EXTRA_V}
	    ;;
	*)
	    cd subfs-${PV}
	    ;;
    esac
    
    make || die
    cd ${S}
    ./submountd${EXTRA_V}-${PV}/configure
    make || die
}

src_install () 
{
    make install DESTDIR=${D}
    
    case "${KV}" in
	2.4*)
	    cd subfs${EXTRA_V}
	    ;;
	*)
	    cd subfs-${PV}
	    ;;
    esac
    
    insinto /lib/modules/${KV}/kernel/fs/subfs
    doins subfs.o
    
    cd ${S}
    ./rename-docs ${PV}	
    dodoc README COPYING INSTALL.subfs INSTALL.submountd README.subfs README.submountd 
}

pkg_postinstall ()
{
    depmod -a
}

# Local Variables:
# mode: sh
# End:
