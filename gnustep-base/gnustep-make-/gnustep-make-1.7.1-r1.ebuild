# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-make/gnustep-make-1.7.1.ebuild,v 1.2 2003/07/14 02:48:55 raker Exp $

inherit doc-tex

DESCRIPTION="GNUstep makefile package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

IUSE="doc"

#DEPEND="virtual/glibc
#	>=sys-devel/gcc-3.2
#	>=dev-libs/ffcall-1.8d
#	>=dev-libs/gmp-4.1
#	>=dev-util/guile-1.6
#	>=dev-libs/openssl-0.9.6j
#	>=media-libs/tiff-3.5.7-r1
#	>=dev-libs/libxml2-2.4.24
#	>=media-libs/audiofile-0.2.3
#	X? ( >=x11-wm/windowmaker-0.80.1 )"

DEPEND=""

if [ -z "${GNUSTEP_ROOT}" ]
    then
    GNUSTEP_ROOT=/opt/GNUstep
fi
GNUSTEP_SYSTEM_ROOT=${GNUSTEP_ROOT}/System
GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT}
INSTALL_ROOT_DIR=${D}


src_compile () 
{
    ./configure \
	--prefix=${GNUSTEP_ROOT} \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info \
	--enable-multi-platform \
	--host=${CHOST} || die "./configure failed"
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
	echo "GNUSTEP_ROOT=${GNUSTEP_ROOT}" > ${D}/etc/env.d/10gnustep
	
	dodir /etc/profile.d
	
	echo -e "#!/bin/sh\n. ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh" > ${D}/etc/profile.d/gnustep.sh
	echo -e "#!/bin/csh\nsource ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.csh" > ${D}/etc/profile.d/gnustep.csh
	
	chmod +x ${D}/etc/profile.d/gnustep.sh ${D}/etc/profile.d/gnustep.csh
	
	dodoc ANNOUNCE COPYING ChangeLog ChangeLog.1 FAQ GNUstep-HOWTO INSTALL NEWS README Documentation/DESIGN Documentation/README*

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

