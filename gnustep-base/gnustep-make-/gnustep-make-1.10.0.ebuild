# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/gnustep-make-1.10.0.ebuild,v 1.1 2004/09/24 01:03:52 fafhrd Exp $

inherit gnustep

DESCRIPTION="The makefile package is a simple, powerful and extensible way to write makefiles for a GNUstep-based project."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

IUSE="${IUSE} doc noflattened"
DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75
	${DOC_DEPEND}"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

if [ -z "${GENTOO_GNUSTEP_ROOT}" ]
    then
    GENTOO_GNUSTEP_ROOT=/usr/GNUstep
fi

GNUSTEP_ROOT=${GENTOO_GNUSTEP_ROOT}

pkg_setup() {
	gnustep_pkg_setup

	# okay, I couldn't figure out how to check if a dependency was
	#  compiled with a specific use flag, so we do it ./configure
	#  check-for-lib style ...
	gcc ${FILESDIR}/helloworld.m -o $TMP/helloworld -lobjc || die \
		"gcc must be compiled with Objective-C support! See the objc USE flag."
}

src_unpack() {
	unpack ${A}
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/make-user-defaults.patch-${PV}
}

src_compile() {
	cd ${S}

	myconf="--prefix=${GNUSTEP_ROOT}"
	myconf="$myconf --with-network-root=${GNUSTEP_ROOT}/Network"
	
	myconf="$myconf --with-tar=/bin/tar"
		if ( use noflattened )    
    	    then
	    myconf="${myconf} --disable-flattened"
	fi
	
	econf $myconf || die "configure failed"
	
	egnustep_make
}

src_install() {
	. ${S}/GNUstep.sh

	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		if [ `use debug` ]; then
			emake -j1 INSTALL_ROOT=${D} \
				GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_SYSTEM_ROOT} \
				GNUSTEP_NETWORK_ROOT=${D}${GNUSTEP_NETWORK_ROOT} \
				GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_LOCAL_ROOT} \
				debug=yes install || die "install has failed"
		else
			emake -j1 INSTALL_ROOT=${D} \
				GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_SYSTEM_ROOT} \
				GNUSTEP_NETWORK_ROOT=${D}${GNUSTEP_NETWORK_ROOT} \
				GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_LOCAL_ROOT} \
				install || die "install has failed"
		fi
	else
		die "no Makefile found"
	fi

	. ${D}usr/GNUstep/System/Library/Makefiles/GNUstep.sh

	if [ `use doc` ]; then
		cd Documentation
		make INSTALL_ROOT=${D} \
			GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_SYSTEM_ROOT} \
			GNUSTEP_MAKEFILES=${D}usr/GNUstep/System/Library/Makefiles \
			GNUSTEP_USER_ROOT=${TMP}/GNUstep \
			GNUSTEP_DEFAULTS_ROOT=${TMP}/GNUstep \
			all || die "doc build failed"
		make INSTALL_ROOT=${D} \
			GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_SYSTEM_ROOT} \
			GNUSTEP_MAKEFILES=${D}usr/GNUstep/System/Library/Makefiles \
			GNUSTEP_USER_ROOT=${TMP}/GNUstep \
			GNUSTEP_DEFAULTS_ROOT=${TMP}/GNUstep \
			install || die "doc install failed"
		cd ..
	fi

    dodir /etc/profile.d
    
    echo -e "#!/bin/sh\n. ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh\nmake_services" > ${D}/etc/profile.d/gnustep.sh
    echo -e "#!/bin/csh\nsource ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.csh\nmake_services" > ${D}/etc/profile.d/gnustep.csh
}

