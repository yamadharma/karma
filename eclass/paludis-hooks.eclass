# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of this eclass:
# ----------------------
# zxy 
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

DEPEND="app-shells/bash
	>=sys-apps/paludis-0.14.2"

RDEPEND="${DEPEND}"

dohook() { 
	local hookfile="${1}" 
	local hookname="${hookfile##*/}" 
	local hooksdir="/usr/share/paludis/hooks" 
	shift 

	if [[ $# -gt 1 ]]; then 
	   insinto "${hooksdir}/common" || die "insinto failed" 
	   doins "${hookfile}" || die "doins failed" 
	   for hooktype in "$@"; do 
		  dodir "${hooksdir}/${hooktype}" || die "dodir failed" 
		  dosym "${hooksdir}/common/${hookname}" "${hooksdir}/${hooktype}" || die "dosym failed" 
	   done 

	else 
	   insinto "${hooksdir}/${1}" || die "insinto failed" 
	   doins "${hookfile}" || die "doins failed" 
	fi 
}
