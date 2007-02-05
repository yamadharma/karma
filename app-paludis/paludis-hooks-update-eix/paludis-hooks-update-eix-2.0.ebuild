# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author(s) of hook: update-eix
# --------------------------------------
# original author: pioto
# contributors: bo.andresen, truc

# Author of this ebuild:
# ----------------------
# zxy, truc
# contributor: dleverton

# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/index.php?page=paludis_scripts

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


inherit eutils paludis-hooks

DESCRIPTION="Hook update-eix makes eix work with Paludis."

DEPEND="${DEPEND}
	app-portage/eix"

RDEPEND="${DEPEND}"

src_install() {
	dohook update-eix-${PV}/update-eix.bash sync_all_pre sync_all_post
}

pkg_postinst() {
	einfo
	einfo "--------------------------------------"
	einfo "The Paludis hook installed: update-eix"
	einfo "--------------------------------------"
	einfo
}
