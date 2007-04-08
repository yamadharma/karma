# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of this eclass:
# ----------------------
# zxy, samlt
# big contributor: dleverton

# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/index.php?page=paludis_scripts

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


HOMEPAGE="http://drzile.dyndns.org/index.php?page=paludis_scripts"

SRC_URI="mirror://zxy/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

IUSE="${IUSE} paludis_hooks_eselect"

DEPEND="app-shells/bash
	>=sys-apps/paludis-0.14.2
	paludis_hooks_eselect? ( app-admin/eselect-paludis-hooks )"

RDEPEND="${DEPEND}"

export eselect_enable_it="true"

dohook() {
	local hookfile="${1}" 
	local hookname="${hookfile##*/}" 
	local hooksdir="/usr/share/paludis/hooks" 
	local es="common/${hookname} "
	local esdfn="${PN##*paludis-hooks-}"
	local esf="${WORKDIR}/${esdfn}"

	shift 

	dodir "${hooksdir}/common" || die "dodir failed"
	exeinto "${hooksdir}/common" || die "exeinto failed" 
	doexe "${hookfile}" || die "doins failed" 
	if use paludis_hooks_eselect ; then
		export eselect_enable_it="true"
		if [ -e ${hooksdir}/eselect/${esdfn} ] ; then
			if [ ! -e ${hooksdir}/eselect/.db/${esdfn} ] ; then
				export eselect_enable_it="false"
				einfo "setting to false"
			fi
		fi

		for hooktype in "$@"; do 
			es="${es} ${hooktype}"
		done 

		echo "# eselect definition file for ${P}" >> ${esf}
		echo "${es}" >> ${esf}

		insinto "${hooksdir}/eselect" || die "insinto failed"
		doins "${esf}" || die "doins failed"
	else
		for hooktype in "$@"; do 
			dodir "${hooksdir}/${hooktype}" || die "dodir failed" 
			dosym "${hooksdir}/common/${hookname}" "${hooksdir}/${hooktype}" || die "dosym failed" 
			es="${es} ${hooktype}"
		done 
	fi
	
}

puthookconfig() {
	insinto "/etc/paludis/hooks/config" || die "insinto failed"
	doins ${1} || die "doins failed"
}

install_hook_using_eselect() {
	local eselect_hook_name="${PN##*paludis-hooks-}"
	if use paludis_hooks_eselect ; then
		if [ "${eselect_enable_it}" == "true" ] ; then
			einfo "Using eselect to enable the hook: ${eselect_hook_name}"
			eselect paludis-hook enable ${eselect_hook_name}
		else
			ewarn "The hook ${eselect_hook_name} was disabled or nonexistent before the installation."			
			ewarn "So I won't enable it now."
			eselect paludis-hook disable ${eselect_hook_name}

		fi
	fi
}

pkg_postinst() {
	install_hook_using_eselect
}
