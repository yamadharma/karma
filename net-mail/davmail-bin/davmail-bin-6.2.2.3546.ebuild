# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit java-pkg-2 desktop systemd

#https://sourceforge.net/projects/davmail/files/davmail/
MY_PN="davmail"

DESCRIPTION="POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway"
HOMEPAGE="http://davmail.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${MY_PN}/${MY_PN}/$(ver_cut 1-3)/${MY_PN}-$(ver_cut 1-3)-$(ver_cut 4).zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="server"

DEPEND="|| ( >=virtual/jre-1.6:*
	>=virtual/jdk-1.6:*
	)
	!net-mail/davmail"
RDEPEND="${DEPEND}
	server? ( acct-user/davmail
		acct-group/davmail
	)"
S="${WORKDIR}"

java-pkg-2_src_compile() {
	einfo ""
}

src_install() {
	# libraries
	java-pkg_dojar lib/*.jar
	java-pkg_dojar ${MY_PN}.jar
	# create wrapper script for the client
	java-pkg_dolauncher ${MY_PN} --main ${MY_PN}.DavGateway --java_args ""

	if use server ; then
		# log file
		touch ${MY_PN}.log
		insinto /var/log
		doins ${MY_PN}.log
		fowners ${MY_PN} /var/log/${MY_PN}.log

		# config files
		insinto /etc
		doins "${FILESDIR}"/${MY_PN}.properties
		newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
		newconfd "${FILESDIR}"/${MY_PN}.conf ${MY_PN}
		systemd_dounit "${FILESDIR}"/davmail.service
	else
		# icon
		doicon "${FILESDIR}"/${MY_PN}.png
		# desktop entry
		make_desktop_entry ${MY_PN} "DavMail" /usr/share/pixmaps/${MY_PN}.png "Network"
	fi
}

pkg_postinst() {
	if use server ; then
		elog
		elog "You have chosen to run ${MY_PN} as a system service. You will need to"
		elog "modify /etc/${MY_PN}.properties to serve your needs."
		elog
		elog "You may find it easier to run the ${MY_PN}, configure it via the GUI"
		elog "and copy the resulting ~/.${MY_PN}.properties to /etc. Make sure you"
		elog "set ${MY_PN}.server=true and ${MY_PN}.allowRemote=true."
		elog
	fi
}
