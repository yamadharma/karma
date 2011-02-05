# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECLASS="openoffice-ext"
INHERITED="$INHERITED $ECLASS"

inherit eutils multilib

# list of extentions
# OOO_EXTENSIONS="" 

openoffice-ext_pkg_setup() {
if ( has_version "app-office/openoffice" || has_version "app-office/openoffice-bin" )
then
	OOO_ROOT_DIR="/usr/$(get_libdir)/openoffice"
elif ( has_version "app-office/libreoffice" || has_version "app-office/libreoffice-bin" )
then
	OOO_ROOT_DIR="/usr/$(get_libdir)/libreoffice"
fi
OOO_PROGRAM_DIR="${OOO_ROOT_DIR}/program"
UNOPKG="${OOO_PROGRAM_DIR}/unopkg"
OOO_EXT_DIR="${OOO_ROOT_DIR}/share/extension/install"
}

DEPEND="virtual/ooo"
RDEPEND="virtual/ooo"

add_extension() {
	ebegin "Adding extension $1"
	INSTDIR=$(mktemp -d --tmpdir=${T})
	${UNOPKG} add --shared $1 \
	"-env:UserInstallation=file:///${INSTDIR}" \
	"-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
	if [ -n ${INSTDIR} ]; then rm -rf ${INSTDIR}; fi
	eend
}

flush_unopkg_cache() {
	${UNOPKG} list --shared > /dev/null 2>&1
}

remove_extension() {
	if ${UNOPKG} list --shared $1 >/dev/null; then
		ebegin "Removing extension $1"
		INSTDIR=$(mktemp -d --tmpdir=${T})
		${UNOPKG} remove --shared $1 \
		"-env:UserInstallation=file://${INSTDIR}" \
		"-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
		if [ -n ${INSTDIR} ]; then rm -rf ${INSTDIR}; fi
    		eend
		flush_unopkg_cache
	fi
}

openoffice-ext_src_install() {
	cd "${S}" || die
	insinto ${OOO_EXT_DIR}
	for i in ${OOO_EXTENSIONS}
	do
		doins ${i} || die "doins failed."
	done
}

openoffice-ext_pkg_postinst() {
	for i in ${OOO_EXTENSIONS}
	do
		add_extension ${OOO_EXT_DIR}/${i}
	done

}

openoffice-ext_pkg_prerm() {
	for i in ${OOO_EXTENSIONS}
	do
		remove_extension ${i}
	done
}

EXPORT_FUNCTIONS src_install pkg_postinst pkg_prerm pkg_setup
