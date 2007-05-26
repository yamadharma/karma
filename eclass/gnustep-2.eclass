# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="eclass for GNUstep Apps, Frameworks, and Bundles build"

# IUSE variables across all GNUstep packages
# "debug"	- enable code for debugging; also nostrip
# "doc" - build and install documentation, if available
IUSE="debug doc"
if use debug; then
	RESTRICT="nostrip"
fi

# Dependencies
# Most .app should be set up this way:
#   + DEPEND="${GS_DEPEND} other/depend ..."
#   + RDEPEND="${GS_RDEPEND} other/rdepend ..."

# packages needed to build (resp view) docs
DOC_DEPEND="doc? ( virtual/tetex
	=dev-tex/latex2html-2002*
	>=app-text/texi2html-1.64 )"
DOC_RDEPEND="doc? ( virtual/man
	>=sys-apps/texinfo-4.6 )"
# packages needed to utilize .debug apps
DEBUG_DEPEND="debug? ( >=sys-devel/gdb-6.0 )"
# packages needed to build any gnustep package
GNUSTEP_CORE_DEPEND="virtual/libc
	${DOC_DEPEND}"

GS_DEPEND=">=gnustep-base/gnustep-env-0.2"
GS_RDEPEND="${GS_DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}"

# Where to install GNUstep
GNUSTEP_PREFIX="/usr/GNUstep"

# Ebuild function overrides
gnustep-2_pkg_setup() {
	if test_version_info 3.3
	then
		strip-unsupported-flags
	elif test_version_info 3.4
	then
		# strict-aliasing is known to break obj-c stuff in gcc-3.4*
		filter-flags -fstrict-aliasing
	fi

	# known to break ObjC (bug 86089)
	filter-flags -fomit-frame-pointer
}

gnustep-2_src_compile() {
	egnustep_env
	if [ -x ./configure ]; then
		econf || die
	fi
	egnustep_make || die
}

gnustep-2_src_install() {
	egnustep_env
	egnustep_install || die
	if use doc ; then
		egnustep_env
		egnustep_doc || die
	fi
	# Copies "convenience scripts"
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		dodir $(egnustep_tools_dir)/Gentoo
		exeinto $(egnustep_tools_dir)/Gentoo
		doexe ${FILESDIR}/config-${PN}.sh
	fi
}

gnustep-2_pkg_postinst() {
	# Informs user about existence of "convenience script"	
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		einfo "Make sure to set happy defaults for this package by executing:"
		einfo "  $(egnustep_tools_dir)/Gentoo/config-${PN}.sh"
		einfo "as the user you will run the package as."
	fi
}

# Prints/sets the GNUstep install domain (System/Local)
egnustep_install_domain() {
	if [ -z "$1" ]; then
		echo ${__GS_INSTALL_DOMAIN}
		return 0
	fi

	if [ "$1" == "System" ]; then
		__GS_INSTALL_DOMAIN="SYSTEM"
	elif [ "$1" == "Local" ]; then
		__GS_INSTALL_DOMAIN="LOCAL"
	else
		die "An invalid parameter has been passed to ${FUNCNAME}"
	fi
}

# Prints the GNUstep domain Tools directory
egnustep_tools_dir() {
	if [ "$__GS_INSTALL_DOMAIN" == "SYSTEM" ]; then
		echo "${GNUSTEP_SYSTEM_TOOLS}"
	elif [ "$__GS_INSTALL_DOMAIN" == "LOCAL" ]; then
		echo "${GNUSTEP_LOCAL_TOOLS}"
	fi
}

# Clean/reset an ebuild to the installed GNUstep environment
egnustep_env() {
	# Get additional variables
	GNUSTEP_SH_EXPORT_ALL_VARIABLES="true"

	if [ -f ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep.sh ] ; then
		. ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep-reset.sh
		. ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep.sh

		# Needed to run installed GNUstep apps in sandbox
		addpredict "/root/GNUstep"

		# Set up common env vars for make operations
		__GS_MAKE_EVAL=" \
			HOME=\"\${T}\" \
			GNUSTEP_USER_DIR=\"\${T}\" \
			GNUSTEP_USER_DEFAULTS_DIR=\"\${T}\"/Defaults \
			DESTDIR=\"\${D}\" \
			GNUSTEP_INSTALLATION_DOMAIN=\"$(egnustep_install_domain)\" \
			TAR_OPTIONS=\"\${TAR_OPTIONS} --no-same-owner\" \
			messages=yes -j1"

		if ! use debug ; then
			__GS_MAKE_EVAL="${__GS_MAKE_EVAL} debug=no"
		fi

		case ${CHOST} in
			*-linux-gnu|*-solaris*)
				append-ldflags \
					-Wl,-rpath="${GNUSTEP_SYSTEM_LIBRARIES}" \
					-L"${GNUSTEP_SYSTEM_LIBRARIES}"
			;;
			*)
				append-ldflags \
					-L"${GNUSTEP_SYSTEM_LIBRARIES}"
			;;
		esac
	else
		die "gnustep-make not installed!"
	fi
}

# Make utilizing GNUstep Makefiles
egnustep_make() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		eval emake ${__GS_MAKE_EVAL} all || die "package make failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Make-install utilizing GNUstep Makefiles
egnustep_install() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		eval emake ${__GS_MAKE_EVAL} install || die "package install failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Make and install docs using GNUstep Makefiles
egnustep_doc() {
	cd ${S}/Documentation
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		eval emake ${__GS_MAKE_EVAL} all || die "doc make failed"
		eval emake ${__GS_MAKE_EVAL} install || die "doc install failed"
	fi
	cd ..
	return 0
}

EXPORT_FUNCTIONS pkg_setup src_compile src_install pkg_postinst
