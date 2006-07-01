# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE=""

DESCRIPTION="Submount is a new attempt to solve the removable media problem for Linux."
HOMEPAGE="http://submount.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
#	mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"

DEPEND="virtual/linux-sources"

SLOT="${KV}"

LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"

# KV_full=`uname -r`
check_KV
KV_full=${KV}

case "${KV_full}" in
    2.4*)
	SRC_URI="mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"
	S=${WORKDIR}/${PN}-2.4-${PV}
	EXTRA_V=-2.4
	;;
    *)
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	S=${WORKDIR}/${P}
	EXTRA_V=""
	;;
esac

src_compile () 
{
    cd subfs${EXTRA_V}-${PV}
    
    make || die
    cd ${S}
    ./submountd${EXTRA_V}-${PV}/configure
    make || die
}

src_install () 
{
    make install DESTDIR=${D}
    
    cd subfs${EXTRA_V}-${PV}
    
    insinto /lib/modules/${KV_full}/fs/subfs
    doins subfs.o
    
    cd ${S}
    ./rename-docs ${PV}	
    dodoc README COPYING INSTALL.subfs INSTALL.submountd README.subfs README.submountd 
}

pkg_postinstall ()
{
    if [ "${ROOT}" = / ]
	then
	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
    fi
}

# Local Variables:
# mode: sh
# End:
