# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of hook: ask
# --------------------
# zxy, truc

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

DESCRIPTION="Hook ask provides -a, --ask functionality for Paludis."

KEYWORDS="amd64 x86"

DEPEND="app-paludis/paludis-wrapper
	${DEPEND}"

RDEPEND="${DEPEND}"

src_install() {
	dohook paludis-ask-${PV}/paludis-ask.bash uninstall_all_pre install_all_pre

	dodir /etc/paludis/hooks/config || die
	insinto /etc/paludis/hooks/config || die
	newins paludis-ask-${PV}/paludis-ask.conf paludis-ask.conf || die
}

pkg_postinst() {
	einfo
	einfo "-------------------------------"
	einfo "The Paludis hook installed: ask"
	einfo "-------------------------------"
	einfo
	ewarn "-----------------------------------------------------------------"
	ewarn "You have chosen to install a hook: ask"
	ewarn "To start using this hook, create an alias in the shell"
	ewarn
	ewarn "Shell command: # alias paludis=\"sh /usr/local/bin/_paludis_wrapper.bash\""
	ewarn
	ewarn "To make it permanent put it in a .bashrc file in your /root folder"
	ewarn "-----------------------------------------------------------------"
}

