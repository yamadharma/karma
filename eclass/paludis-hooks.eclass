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

IUSE="${IUSE} paludis_hooks_eselect"

DEPEND="app-shells/bash
	>=sys-apps/paludis-0.14.2
	paludis_hooks_eselect? ( app-admin/eselect-paludis-hooks )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

dohook() {
	local hookfile="${1}" 
	local hookname="${hookfile##*/}" 
	local hooksdir="/usr/share/paludis/hooks" 
	local es="common/${hookname} "
	local esf="${WORKDIR}/${PN##*paludis-hooks-}"
	local esdbf="${PN##*paludis-hooks-}"
	shift 

	insinto "${hooksdir}/common" || die "insinto failed" 
	doins "${hookfile}" || die "doins failed" 

	for hooktype in "$@"; do 
		dodir "${hooksdir}/${hooktype}" || die "dodir failed" 
		dosym "${hooksdir}/common/${hookname}" "${hooksdir}/${hooktype}" || die "dosym failed" 
		es="${es} ${hooktype}"
	done 

	if use paludis_hooks_eselect ; then
		echo "# eselect definition file for ${P}" >> ${esf}
		echo "${es}" >> ${esf}

		insinto "${hooksdir}/eselect" || die "insinto failed"
		doins "${esf}" || die "doins failed"

		touch ${WORKDIR}/.dbf
		dodir /usr/share/paludis/hooks/eselect/.db/ || die
		insinto /usr/share/paludis/hooks/eselect/.db/ || die
		newins ${WORKDIR}/.dbf ${esdbf} || die
	fi
}

puthookconfig() {
	insinto "/etc/paludis/hooks/config" || die "insinto failed"
	doins ${1} || die "doins failed"
}
