# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: kde4svn-meta.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Eclass for writing KDE "live" split ebuilds.
# @DESCRIPTION:
# This eclass provides a src_unpack function to handle split, live KDE ebuilds.
# All other phases come from the eclasses it inherits.

ESVN_UP_FREQ=${ESVN_UP_FREQ:-1}

inherit subversion kde4svn

EXPORT_FUNCTIONS src_unpack

kde4svn-meta_src_extract() {
	local rsync_options subdir kmnamedir targetdir

	# Export working copy to ${S}
	einfo "Exporting parts of working copy to ${S}"
	kde4overlay-meta_create_extractlists

	case ${KMNAME} in
		kdebase) kmnamedir="" ;;
		kdebase-*) kmnamedir="${KMNAME#kdebase-}/" ;;
	esac

	rsync_options="--group --links --owner --perms --quiet --exclude=.svn/"

	# Copy ${KMNAME} non-recursively (toplevel files)
	rsync ${rsync_options} "${ESVN_WC_PATH}"/${kmnamedir}* "${S}" \
		|| die "${ESVN}: can't export toplevel files to '${S}'."

	# Copy cmake directory
	if [[ -d "${ESVN_WC_PATH}/${kmnamedir}cmake" ]]; then
		rsync --recursive ${rsync_options} "${ESVN_WC_PATH}/${kmnamedir}cmake" "${S}" \
			|| die "${ESVN}: can't export cmake files to '${S}'."
	fi

	# Copy all subdirectories
	for subdir in $(__list_needed_subdirectories); do
		targetdir=""
		if [[ ${subdir} == doc/* && ! -e "${ESVN_WC_PATH}/${kmnamedir}${subdir}" ]]; then
			continue
		fi

		[[ ${subdir%/} == */* ]] && targetdir=${subdir%/} && targetdir=${targetdir%/*} && mkdir -p "${S}/${targetdir}"

		rsync --recursive ${rsync_options} "${ESVN_WC_PATH}/${kmnamedir}${subdir%/}" "${S}/${targetdir}" \
			|| die "${ESVN}: can't export subdirectory '${subdir}' to '${S}/${targetdir}'."
	done
	[[ "${KMNAME}" == kdebase* ]] && kdebase_toplevel_cmakelist

	if [[ ${KMNAME} == kdebase-runtime && ${PN} != kdebase-data ]]; then
		sed -i -e '/^install(PROGRAMS[[:space:]]*[^[:space:]]*\/kde4[[:space:]]/s/^/#DONOTINSTALL /' \
			"${S}"/CMakeLists.txt || die "Sed to exclude bin/kde4 failed"
	fi
}

kde4svn-meta_src_unpack() {
	S="${WORKDIR}/${PN}"
	# Ensure the target directory exists
	mkdir -p "${S}"
	# Update working copy
	ESVN_RESTRICT="export" subversion_src_unpack

	# this sets variables used by the src_extract and change_cmakelists
	subversion_wc_info

	# Fetch SVN sources and export (parts of) our SVN working copy to ${S}
	kde4svn-meta_src_extract

	# Make sure PATCHES as well as ESVN_PATCHES get applied
	kde4overlay-base_apply_patches
	subversion_bootstrap

	# CMakeLists.txt magic
	kde4overlay-meta_change_cmakelists
}

# We need to copy 4 /macro_optional_find_package/ statements from the
# kdebase/CMakeLists.txt to our new toplevel CMakeLists.txt for kdebase* split ebuilds.
kdebase_toplevel_cmakelist() {
	insert=$(sed -e '/macro_optional_find_package/!d' < "${ESVN_WC_PATH}"/CMakeLists.txt)

	at=$(sed -n '/^include[[:space:]]*(/=' < "${S}"/CMakeLists.txt | sed -n '$p')
	for line in ${insert}; do
		sed "${at}a${line}" -i "${S}"/CMakeLists.txt
	done
}
