# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

inherit kernel-mod

IUSE=""

DESCRIPTION="Submount is a new attempt to solve the removable media problem for Linux."
HOMEPAGE="http://submount.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
#	mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"

DEPEND="virtual/linux-sources"

SLOT="${KV}"

LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"

check_KV
KV_full=${KV}

case "${KV_full}" in
    2.4*)
	SRC_URI="mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"
	S=${WORKDIR}/${PN}-2.4-${PV}
	EXTRA_V=-2.4
	;;
    2.6*)
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	S=${WORKDIR}/${P}
	EXTRA_V=""
	addpredict /usr/src/linux
#	addwrite /usr/src/linux/scripts/elfconfig.h
#	addpredict /usr/src/linux
#	addpredict /usr/src/linux/.tmp_versions
#	addwrite /usr/src/linux/.tmp_versions/subfs.mod
#	export MODVERDIR=${T}
	RESTRICT=nouserpriv
	;;
    *)
	die "Unknown kernel version"
	;;	
esac

src_compile () 
{
    cd subfs${EXTRA_V}-${PV}
#    mkdir ${T}/scripts
#    cp -R /usr/src/linux/scripts/* ${T}/scripts
#    ln -s /usr/src/linux/arch ${T}/arch
    
    make MODVERDIR=${T} || die
    #KBUILD_SRC=${T} 
    
    cd ${S}/submountd${EXTRA_V}-${PV}
    econf
    make || die
}

src_install () 
{
    cd ${S}/submountd${EXTRA_V}-${PV}
    make install DESTDIR=${D}
    
    cd ${S}/subfs${EXTRA_V}-${PV}
    
    insinto /lib/modules/${KV_full}/fs/subfs

    case "${KV_full}" in
	2.4*)
	    doins subfs.o
	    ;;
	2.6*)
            doins subfs.ko
	    ;;
	*)
	    die "Unknown kernel version"
	    ;;	
    esac
    
    cd ${S}
    case "${KV_full}" in
	2.4*)
	    ./rename-docs ${PV}	
	    dodoc README COPYING INSTALL.subfs INSTALL.submountd README.subfs README.submountd 
	    ;;
	2.6*)
            dodoc README COPYING 
	    docinto subfs
	    cd ${S}/subfs${EXTRA_V}-${PV}
	    dodoc INSTALL README 

	    docinto submountd
	    cd ${S}/submountd${EXTRA_V}-${PV}
	    dodoc INSTALL README 
	    ;;
	*)
	    die "Unknown kernel version"
	    ;;	
    esac
}

pkg_postinst ()
{
    if [ "${ROOT}" = / ]
	then
	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
    fi
}

# Local Variables:
# mode: sh
# End:
