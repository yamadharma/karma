# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: check-security-updates
# --------------------------------------
#

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

DESCRIPTION="Hook check-security-updates shows GLSA info after syncing with Paludis."

src_install() {
	dohook check-security-updates-${PV}/check-security-updates.bash sync_all_post
}

pkg_postinst() {
	einfo
	einfo "--------------------------------------------------"
	einfo "The Paludis hook installed: check-security-updates"
	einfo "--------------------------------------------------"
	einfo

	ewarn "---------------------------------------------------------------------------"
	ewarn "You have chosen to install a hook: check-security-updates"
	ewarn
	ewarn "If you used a hook from paludis wiki before please remove it. "
	ewarn "This hook is the same. It has just been renamed, to a more descriptive name"
	ewarn "Sorry for the inconvenience."
	ewarn
	ewarn "Shell command: # rm  /usr/share/paludis/hooks/sync_all_post/check-security.bash"
	ewarn
	ewarn "No action is needed for upgrades "
	ewarn "---------------------------------------------------------------------------"

}
