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

src_install() {
	dohook paludis-ask-${PV}/paludis-ask.bash uninstall_all_pre install_all_pre

	dodir /usr/local/bin/ || die
	insinto /usr/local/bin/ || die
	doins paludis-ask-${PV}/_paludis_wrapper.bash || die

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

pkg_postrm() {
	ewarn "----------------------------------------------------------------------"
	ewarn "Read below ONLY if you have chosen to uninstall a hook: ask"
	ewarn "No need for this if you are reinstalling or installing a newer version"
	ewarn
	ewarn "If you have created an alias for paludis, you have to remove it."
	ewarn
	ewarn "Shell command: # unalias paludis"
	ewarn
	ewarn "And remove (or comment) the alias line in /root/.bashrc "
	ewarn "if you have put an alias command there!!!"
	ewarn "----------------------------------------------------------------------"
}
