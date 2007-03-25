# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: collision-protect
# ----------------------------------
# dlverton

# Author of this ebuild:
# ----------------------
# zxy, truc, dleverton

# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/index.php?page=paludis_scripts

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


inherit eutils paludis-hooks

DESCRIPTION="Hook collision-protect provides collision protect functionality for Paludis."

KEYWORDS="amd64 x86"

RDEPEND=">=sys-apps/paludis-0.20.0"

src_install() {
	dohook collision-protect-${PV}/collision-protect.bash merger_check_pre
}

pkg_postinst() {
	einfo
	einfo "---------------------------------------------"
	einfo "The Paludis hook installed: collision-protect"
	einfo "---------------------------------------------"
	einfo
}
