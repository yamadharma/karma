# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: kde4svn.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Eclass for writing KDE "live" ebuilds.
# @DESCRIPTION:
# This eclass provides all functions to handle live KDE ebuilds,
# monolithic, split and extragear ebuilds.
#
# The eclass checks out to ${DISTDIR}/svn-src/KDE, and recreates the structure
# of upstream's SVN repository locally.

# @ECLASS-VARIABLE: NEED_KDE
# @DESCRIPTION:
# Defaults to "svn", also see: kde4-base.eclass.
if [[ -z ${NEED_KDE} ]]; then
	NEED_KDE="svn"
fi

# @ECLASS-VARIABLE: NEED_KDE_PRE
# @DESCRIPTION:
# This variable tells the eclass to set NEED_KDE and SLOT based on the PV of the
# ebuild.
#
# Acceptable values for the PV when using this are:
#   - ${PV}_pre4    - Compile against the kde-4 SLOT
#   - ${PV}_pre9999 - Compile against the kde-svn SLOT
if [[ -n ${NEED_KDE_PRE} ]]; then
	case ${PV##*_pre} in
		4) SLOT="kde-4"; NEED_KDE=":${SLOT}";;
		9999) SLOT="kde-svn"; NEED_KDE="svn";;
		*) die "Unknown package version." ;;
	esac
fi

# @ECLASS-VARIABLE: KMNAME
# @DESCRIPTION:
# Name of the parent-module (eg kdebase, kdepim, "extragear/base").
# You _must_ set it _before_ inheriting this eclass, (unlike the other parameters),
# since it's used to set $ESVN_REPO_URI.

# @ECLASS-VARIABLE: KMMODULE
# @DESCRIPTION:
# Specify exactly one subdirectory of $KMNAME here. Defaults to $PN.
# You shouldn't set this for monolithic ebuilds.

# Split SVN ebuilds
if [[ -n ${KMNAME} ]]; then
	case ${CATEGORY} in
		kde-base|app-office)
			inherit kde4overlay-meta ;;
	esac
fi

ESVN_MIRROR="svn://anonsvn.kde.org/home/kde"

# Split ebuild, or extragear stuff
if [[ -n ${KMNAME} ]]; then
	ESVN_PROJECT="KDE/${KMNAME}"
	if [[ -z ${KMNOMODULE} && -z ${KMMODULE} ]]; then
		KMMODULE="${PN}/"
	fi
	# Split kde-base/ ebuilds: (they reside in trunk/KDE)
	case ${KMNAME} in
		kdebase-*)
			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/KDE/kdebase"
			ESVN_PROJECT="KDE/kdebase"
		;;
		kdereview)
			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
		;;
		kde*)
			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/KDE/${KMNAME}"
		;;
		extragear*|playground*)
			case ${PN} in
				*-plasma)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
					ESVN_PROJECT="KDE/${KMNAME}/${KMMODULE}"
				;;
				*)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}"
				;;
			esac
		;;
		koffice)
			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}"
		;;
		*)
			# Extragear material
			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
		;;
	esac
else
# kdelibs, kdepimlibs
	ESVN_REPO_URI="${ESVN_MIRROR}/trunk/KDE/${PN}"
	ESVN_PROJECT="KDE/${PN}"
fi


inherit subversion kde4overlay-base

if [[ -n ${KMNAME} ]]; then
	inherit kde4overlay-meta
fi

EXPORT_FUNCTIONS pkg_setup src_unpack

# @FUNCTION: kde4svn_pkg_setup
# @DESCRIPTION:
# This function calls kde4-base_pkg_setup, then issues a warning about the
# experimental nature of live ebuilds.
kde4svn_pkg_setup() {
	kde4overlay-base_pkg_setup

	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		echo
		ewarn "WARNING! This is an experimental ebuild of the ${KMNAME:-${PN}} KDE4 SVN tree."
		ewarn "Use at your own risk. Do _NOT_ file bugs at bugs.gentoo.org because"
		ewarn "of this ebuild!"
		echo
	fi
}

# @FUNCTION: kde4svn_src_unpack
# @DESCRIPTION:
# Unpack SVN sources and apply patches.
kde4svn_src_unpack() {
	local cleandir
	cleandir="${ESVN_STORE_DIR}/KDE/KDE"
	if [[ -d ${cleandir} ]]; then
		eerror "'${cleandir}' should never have been created. Either move it to"
		eerror "${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/} or remove"
		eerror "completely."
		die "'${cleandir}' is in the way."
	fi

	subversion_src_unpack
	kde4overlay-base_apply_patches
}
