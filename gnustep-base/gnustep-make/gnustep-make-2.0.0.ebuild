# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep 

DESCRIPTION="The makefile package is a simple, powerful and extensible way to write makefiles for a GNUstep-based project."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="ppc x86 amd64 sparc ~alpha"
SLOT="0"
LICENSE="GPL-2"

# Need add in make.conf
# USE_EXPAND="${USE_EXPAND} GNUSTEP_LAYOUT"
# GNUSTEP_LAYOUT=gnustep (or other)

# GNUSTEP_LAYOUT is one of 
# fhs fhs-system gnustep gnustep-with-network mac next
IUSE_GNUSTEP_LAYOUT="
	gnustep_layout_fhs 
	gnustep_layout_fhs-system 
	gnustep_layout_gnustep 
	gnustep_layout_gnustep-with-network 
	gnustep_layout_mac 
	gnustep_layout_next"

IUSE="${IUSE_GNUSTEP_LAYOUT}"

IUSE="${IUSE} doc non-flattened"
IUSE="${IUSE} layout-osx-like layout-from-conf-file"
IUSE="${IUSE} verbose"





DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

pkg_setup() {
	gnustep_pkg_setup

	if [ "$(objc_available)" == "no" ]; then
		objc_not_available_info
		die "ObjC support not available"
	fi
}

src_compile() {
	. ${S}/GNUstep-reset.sh

	local myconf
	local mylayout 
	local layout 
	
	for layout in ${IUSE_GNUSTEP_LAYOUT} 
	do
		if ( use ${layout} )
		then
			mylayout=${layout#gnustep_layout_}
		fi
	done
	
	if [ -z "${mylayout}" ]
	then
		mylayout=gnustep
	fi
	
	if ( use layout-osx-like )
	then
		mylayout=mac
	fi
	
	use non-flattened && myconf="$myconf --disable-flattened --enable-multi-platform"
	myconf="$myconf --with-tar=/bin/tar"
	myconf="$myconf --enable-native-objc-exceptions"
	myconf="$myconf --with-layout=${mylayout}"
	use layout-from-conf-file && myconf="$myconf --enable-importing-config-file"
	
	./configure $myconf || die "configure failed"

	make

	if use doc 
	then	
		cd Documentation
		make || die "doc make has failed"
		cd ${S}
	fi
	
}

src_install () {
	local make_eval=""
	
	make_eval="${make_eval} -j1"

	make_eval="${make_eval} GNUSTEP_INSTALLATION_DOMAIN=SYSTEM"

	if use debug  
	    then
	    make_eval="${make_eval} debug=yes"
	fi
	if use verbose  
	    then
	    make_eval="${make_eval} verbose=yes"
	fi

	make install DESTIR=${D} special_prefix=${D} ${make_eval} || die "install has failed"
	
	if use doc 
	then
    		# Makefiles massively changed 
		unset GNUSTEP_MAKEFILES

		export GNUSTEP_MAKEFILES=${S}/Documentation/tmp-installation/System/Library/Makefiles
    		cd Documentation
		emake ${make_eval} DESTIR=${D} special_prefix=${D} install || die "doc install has failed"
		
		source ${S}/GNUstep.conf
		dodir ${GNUSTEP_SYSTEM_DOC}
		mv ${S}/Documentation/tmp-installation/System/Library/Documentation/* ${D}/${GNUSTEP_SYSTEM_DOC}
		cd ${S}
	fi

#	dodir /etc/conf.d
#	echo "GNUSTEP_SYSTEM_ROOT=$(egnustep_system_root)" > ${D}/etc/conf.d/gnustep.env
#	echo "GNUSTEP_LOCAL_ROOT=$(egnustep_local_root)" >> ${D}/etc/conf.d/gnustep.env
#	echo "GNUSTEP_NETWORK_ROOT=$(egnustep_network_root)" >> ${D}/etc/conf.d/gnustep.env
#	echo "GNUSTEP_USER_ROOT='$(egnustep_user_root)'" >> ${D}/etc/conf.d/gnustep.env

	insinto /etc/GNUstep
	doins ${S}/GNUstep.conf
	
	exeinto /etc/profile.d
	newexe ${FILESDIR}/gnustep.sh-2	gnustep.sh
	newexe ${FILESDIR}/gnustep.csh-2 gnustep.csh
	
	cd ${S}
	dodoc ChangeLog*
	cd ${S}/Documentation
	dodoc ANNOUNCE GNUstep-HOWTO INSTALL NEWS README* DESIGN FAQ RELEASENOTES
}
