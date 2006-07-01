# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-make/gnustep-make-1.7.1.ebuild,v 1.2 2003/07/14 02:48:55 raker Exp $

inherit doc-tex patch

DESCRIPTION="GNUstep makefile package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

IUSE="doc"

DEPEND=""

RDEPEND=""

patch_OPTIONS="cleancvs"

if [ -z "${GNUSTEP_ROOT}" ]
    then
    GNUSTEP_ROOT=/opt/GNUstep
fi

GNUSTEP_SYSTEM_ROOT=${GNUSTEP_ROOT}/System
GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT}
INSTALL_ROOT_DIR=${D}


src_compile () 
{
    local myconf
    
    myconf="${myconf} --disable-flattened"
    
    ./configure \
	--prefix=${GNUSTEP_ROOT} \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info \
	--enable-multi-platform \
	--host=${CHOST} \
	${myconf} \
	|| die "./configure failed"
	
    make || die
}

src_install () 
{
    make \
	GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_ROOT}/System \
	GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_ROOT}/Local \
	GNUSTEP_NETWORK_ROOT=${D}${GNUSTEP_ROOT}/Network \
	install || die "install failed"
	
	dodir /etc/env.d
	echo "GNUSTEP_ROOT=${GNUSTEP_ROOT}" > ${D}/etc/env.d/01gnustep_root
	
	dodir /etc/profile.d
	
	echo -e "#!/bin/sh\n. ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh" > ${D}/etc/profile.d/gnustep.sh
	echo -e "#!/bin/csh\nsource ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.csh" > ${D}/etc/profile.d/gnustep.csh
	
	#{{{ doc install
	
	if ( use doc )
	then 
	    cd ${S}/Documentation
	    make
	    make GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT} install
	fi
	
	#}}}
	
}

pkg_postinst ()
{
    env-update &> /dev/null
    source /etc/profile
}

# Local Variables:
# mode: sh
# End:

