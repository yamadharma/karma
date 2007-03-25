# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils paludis-hooks

DESCRIPTION="Wrapper script for paludis, that adds new command line options."

KEYWORDS="amd64 x86"

IUSE="paludis_hooks_ask paludis_hooks_nice"

src_install() {
	for p in ${IUSE};do
		if use ${p}; then
			p=`echo ${p} | sed 's:paludis_hooks_\(.*\):PALUDIS_WRAPPER_\U\1:'`
			# enabling this option in the wrapper script
			sed s:^${p}=\"no\"$:${p}=\"yes\": -i ${P}/_paludis_wrapper.bash
		fi
	done

	puthookconfig ${P}/paludis-wrapper.conf 

	insinto /usr/local/bin/ || die
	doins ${P}/_paludis_wrapper.bash || die
}

pkg_postinst() {
	ewarn "-----------------------------------------------------------------"
	ewarn "To start using the wrapper, create an alias in the shell"
	ewarn
	ewarn "Shell command: # alias paludis=\"sh /usr/local/bin/_paludis_wrapper.bash\""
	ewarn
	ewarn "To make it permanent put it in a .bashrc file in your /root folder"
	ewarn "-----------------------------------------------------------------"
}

pkg_postrm() {
	ewarn 
	ewarn "If you want to permanently remove ${PN} from your system"
	ewarn "you should manually remove the alias for paludis from /root/.bashrc"
	ewarn "followed by running: unalias paludis"
	ewarn
}
