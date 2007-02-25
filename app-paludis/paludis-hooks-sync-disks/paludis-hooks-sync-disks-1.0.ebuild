# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of hook: ask
# --------------------
# zxy

# Author of this ebuild:
# ----------------------
# zxy, dleverton


# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/index.php?page=paludis_scripts

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


inherit eutils paludis-hooks

DESCRIPTION="Hook sync-disks makes a kernel sync call (writes any data buffered in memory out to disk)."

KEYWORDS="amd64 x86"

DEPEND="${DEPEND}
	sys-apps/coreutils"

RDEPEND="${DEPEND}"

src_install() {

  	dohook sync-disks-${PV}/sync-disks.bash uninstall_all_post uninstall_post install_all_post install_post sync_all_post sync_post
}
