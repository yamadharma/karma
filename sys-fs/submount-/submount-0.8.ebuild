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

if kernel-mod_is_2_4_kernel
    then
    SRC_URI="mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz"
    S=${WORKDIR}/${PN}-2.4-${PV}
    EXTRA_V=-2.4
else
    SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
    S=${WORKDIR}/${P}
    EXTRA_V=""
    RESTRICT=nouserpriv
fi

check_module_safe ()
{
    if kernel-mod_is_2_4_kernel
	then
	return 1
    else
	if [ "`has sandbox ${FEATURES}`" -o "`has usersandbox ${FEATURES}`" ]
	    then
	    eerror "Due to a problem with kbuild in 2.5/2.6 kernels, external modules"
	    eerror "require that sandbox and usersandbox be disabled."
	    eerror "The only place in your live filesystem that will be affected is"
	    eerror "in /usr/src/linux (nothing destructive)."
	    eerror "Please see bug #32737 on bugs.gentoo.org for info, until then"
	    eerror "you can install the ${PN} modules by doing "
	    eerror ""
	    eerror "# FEATURES='-sandbox -usersandbox' emerge ${PN}"
	    die "'sandbox' or 'usersandbox' enabled for 2.5/2.6 kernel module build"
	fi
    fi
}


src_compile () 
{
    check_module_safe
    
    cd ${S}/subfs${EXTRA_V}-${PV}
    make MODVERDIR=${T} || die
    
    cd ${S}/submountd${EXTRA_V}-${PV}
    econf \
	--sbindir=/sbin \
	|| die "Confugure error"
	
    make || die "Make error"
}

src_install () 
{
    cd ${S}/submountd${EXTRA_V}-${PV}
    make install DESTDIR=${D}
    
    cd ${S}/subfs${EXTRA_V}-${PV}
    
    insinto /lib/modules/${KV}/fs/subfs

    if kernel-mod_is_2_4_kernel
	then
	doins subfs.o
    else
	doins subfs.ko
    fi

    
    cd ${S}    
    ./rename-docs ${PV}	
    dodoc README* COPYING INSTALL*
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
