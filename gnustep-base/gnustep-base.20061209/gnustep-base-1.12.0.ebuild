# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-base/gnustep-base-1.10.3.ebuild,v 1.2 2005/05/05 17:54:58 swegener Exp $

inherit gnustep

DESCRIPTION="The GNUstep Base Library is a library of general-purpose, non-graphical Objective C objects."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~ppc x86 amd64 ~sparc ~alpha"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

IUSE="${IUSE} doc gcc-libffi"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-1.10.0
	|| (
		gcc-libffi? ( >=sys-devel/gcc-3.3.5 )
		>=dev-libs/libffi-3.3.5
	)
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1
	>=dev-libs/openssl-0.9.7
	>=sys-libs/zlib-1.2
	sys-apps/sed
	${DOC_DEPEND}"
	
RDEPEND="${DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

pkg_setup () 
{
	if use gcc-libffi; then
		export OBJC_INCLUDE_PATH="OBJC_INCLUDE_PATH:$(gcc-config -L | sed 's/:.*//')/include/libffi"
		if [ "$(ffi_available)" == "no" ]; then
			ffi_not_available_info
			die "libffi is not available"
		fi
	fi
}

src_unpack () 
{
	egnustep_env
	unpack ${A}
	
	cd ${S}
	
	# FIX non-flattened
	sed -ie "s:../Source/config.h:config.h:" Tools/gdomap.c

	if [ -z $GNUSTEP_FLATTENED ] 
	    then
	    sed -i -e 's:$GNUSTEP_MAKEFILES/config.make:$GNUSTEP_MAKEFILES/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/config.make:' configure.ac
	    autoconf
	fi
}

src_compile () 
{
	egnustep_env
	# why libffi over ffcall?
	# - libffi is known to work with 32 and 64 bit platforms
	# - libffi does not use trampolines
	local myconf
	myconf="--enable-libffi --disable-ffcall"
	if use gcc-libffi; then
		myconf="${myconf} --with-ffi-library=$(gcc-config -L) --with-ffi-include=$(gcc-config -L | sed 's/:.*//')/include/libffi"
	else
		myconf="${myconf} --with-ffi-library=/usr/lib/libffi --with-ffi-include=/usr/include/libffi"
	fi

	myconf="$myconf --with-xml-prefix=/usr"
	myconf="$myconf --with-gmp-include=/usr/include --with-gmp-library=/usr/lib"
    
        myconf="$myconf --with-default-config=/etc/GNUstep/GNUstep.conf"

	econf $myconf || die "configure failed"

	egnustep_make || die
}

src_install () 
{
	egnustep_env
	egnustep_install || die

	local base_temp_lib_path
	if [ ! -z $GNUSTEP_FLATTENED ]; then
		base_temp_lib_path="$(egnustep_install_domain)/Library/Libraries"
	else
		base_temp_lib_path="$(egnustep_install_domain)/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO"
	fi

	if use doc ; then
		local make_eval="INSTALL_ROOT=\${D} \
			GNUSTEP_SYSTEM_ROOT=\${D}\$(egnustep_system_root) \
			GNUSTEP_NETWORK_ROOT=\$(egnustep_network_root) \
			GNUSTEP_LOCAL_ROOT=\$(egnustep_local_root) \
			GNUSTEP_MAKEFILES=\$(egnustep_system_root)/Library/Makefiles \
			GNUSTEP_USER_ROOT=\${TMP} \
			GNUSTEP_DEFAULTS_ROOT=\${TMP}/\${__GS_USER_ROOT_POSTFIX} \
			LD_LIBRARY_PATH=\"\${D}\${base_temp_lib_path}:\${LD_LIBRARY_PATH}\" \
			GNUSTEP_INSTALLATION_DIR=\${D}\$(egnustep_install_domain) \
			-j1"
		if use debug ; then
			make_eval="${make_eval} debug=yes"
		fi
		if use verbose ; then
			make_eval="${make_eval} verbose=yes"
		fi

		cd ${S}/Documentation
		eval emake ${make_eval} AUTOGSDOC="${S}/Tools/obj/autogsdoc" all || die "doc make has failed"
		eval emake ${make_eval} install || die "doc install has failed"
		cd ..
	fi
	
	newinitd ${FILESDIR}/gnustep.initd gnustep
	
	egnustep_package_config
}

pkg_postinst () 
{
	egnustep_env

	ewarn "The shared library version has changed in this release."
	ewarn "You will need to recompile all Applications/Tools/etc in order to use this library."
	ewarn "Run:"
	ewarn "export SEARCH_DIRS=\"$GNUSTEP_PATHLIST\"; revdep-rebuild --library libgnustep-base.so.1.1[01]"
	ewarn "or add SEARCH_DIRS=\"$GNUSTEP_PATHLIST\" to /etc/make.conf and run"
	ewarn "revdep-rebuild --library libgnustep-base.so.1.1[01]"
}
