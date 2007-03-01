# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of script:
# --------------------
# zxy, truc

# Author of this ebuild:
# ----------------------
# zxy, truc


# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/index.php?page=paludis_scripts

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


inherit eutils paludis-hooks

DESCRIPTION="Wrapper script for paludis, that adds new command line options."

KEYWORDS="amd64 x86"

IUSE="paludis_hooks_ask paludis_hooks_nice"

src_install() {

	if use paludis_hooks_ask ; then
		sed 's:^PALUDIS_WRAPPER_ASK="no"$:PALUDIS_WRAPPER_ASK="yes":' -i ${WORKDIR}/paludis-wrapper-${PV}/_paludis_wrapper.bash 
	fi

	if use paludis_hooks_nice ; then
		sed 's:^PALUDIS_WRAPPER_NICE="no"$:PALUDIS_WRAPPER_NICE="yes":' -i ${WORKDIR}/paludis-wrapper-${PV}/_paludis_wrapper.bash 
		dodir /etc/paludis/hooks/config || die
		insinto /etc/paludis/hooks/config || die
		newins paludis-nice.conf paludis-nice.conf || die
	fi

	dodir /usr/local/bin/ || die
	insinto /usr/local/bin/ || die
	doins _paludis_wrapper.bash || die
}

pkg_postinst() {
	einfo
	einfo "--------------------------------------"
	einfo "The Paludis wrapper has been installed"
	einfo "--------------------------------------"
	einfo
	ewarn "-----------------------------------------------------------------"
	ewarn "To start using the wrapper, create an alias in the shell"
	ewarn
	ewarn "Shell command: # alias paludis=\"sh /usr/local/bin/_paludis_wrapper.bash\""
	ewarn
	ewarn "To make it permanent put it in a .bashrc file in your /root folder"
	ewarn "-----------------------------------------------------------------"
}

pkg_postrm() {
	ewarn "----------------------------------------------------------------------"
	ewarn "Read below ONLY if you have chosen to uninstall a wrapper"
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
