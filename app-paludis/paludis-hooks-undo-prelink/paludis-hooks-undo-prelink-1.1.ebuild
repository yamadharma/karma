# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: undo-prelink
# --------------------------------------
# dleverton

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

DESCRIPTION="Hook undo-prelink prevents Paludis from leaving prelinked binaries lying around (because it thinks they've been modified) when you uninstall the package."

DEPEND="${DEPEND}
	sys-devel/prelink"

RDEPEND="${DEPEND}"


src_install() {
	dohook undo-prelink-${PV}/undo-prelink.bash ebuild_merge_pre ebuild_unmerge_pre
}

pkg_postinst() {
	
	einfo
	einfo "----------------------------------------"
	einfo "The Paludis hook installed: undo-prelink"
	einfo "----------------------------------------"
	einfo
}
