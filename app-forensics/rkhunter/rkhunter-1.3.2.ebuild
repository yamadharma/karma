# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official rkhunter ebuild

inherit eutils

DESCRIPTION="Rootkit Hunter scans for known and unknown rootkits, backdoors, and sniffers."
HOMEPAGE="http://rkhunter.sf.net/"
SRC_URI="mirror://sourceforge/rkhunter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~mips ~ppc ~sparc x86"
IUSE=""

RDEPEND="virtual/mta
	app-shells/bash
	dev-lang/perl
	sys-process/lsof"

S="${WORKDIR}/${P}/files"

src_install() {
	insinto /usr/lib/rkhunter/db
	doins *.dat || die "failed to install dat files"
	insinto /usr/lib/rkhunter/db/i18n
	doins i18n/* || die "failed to install dat files"

	exeinto /usr/lib/rkhunter/scripts
	doexe *.pl check_update.sh || die "failed to install scripts"

	dobin rkhunter || die "failed to install rkhunter script"
	insinto /etc
	doins rkhunter.conf || die "failed to install rkhunter.conf"
	dosed 's:ROOTDIR=\"\":ROOTDIR=\"\"\nINSTALLDIR=/usr:' /etc/rkhunter.conf || die "sed rkhunter failed"
	dosed 's:#TMPDIR:TMPDIR:' /etc/rkhunter.conf || die "sed rkhunter failed"
	dosed 's:#SCRIPTDIR=/usr/local/lib/rkhunter/scripts:SCRIPTDIR=/usr/lib/rkhunter/scripts:' /etc/rkhunter.conf || die "sed rkhunter failed"
	dodir /var/lib/rkhunter/tmp
	doman rkhunter.8 || die "doman failed"
	dodoc CHANGELOG LICENSE README WISHLIST || die "dodoc failed"

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/rkhunter.cron rkhunter || \
		die "failed to install cron script"
}

pkg_postinst() {
	echo
	elog "A cron script has been installed to /etc/cron.daily/rkhunter."
	elog "To enable it, edit /etc/cron.daily/rkhunter and follow the"
	elog "directions."
	echo
}
