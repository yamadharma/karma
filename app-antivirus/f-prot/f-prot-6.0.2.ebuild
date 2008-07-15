# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

S=${WORKDIR}/${PN}

DESCRIPTION="Frisk Software's f-prot virus scanner"
HOMEPAGE="http://www.f-prot.com/"
SRC_URI="http://files.f-prot.com/files/unix-trial/fp-Linux-i686-ws.tar.gz"
DEPEND=""
# unzip and perl are needed for the check-updates.pl script
RDEPEND=">=app-arch/unzip-5.42-r1
	dev-lang/perl
	dev-perl/libwww-perl
	amd64? ( >=app-emulation/emul-linux-x86-baselibs-1.0 )"
PROVIDE="virtual/antivirus"

SLOT="0"
LICENSE="F-PROT"
KEYWORDS="amd64 -ppc -sparc x86"

src_install() {
	cd ${S}

	dodir /var/tmp/f-prot
	keepdir /var/tmp/f-prot

	insinto /opt/f-prot
	insopts -m 755
	doins fpscan fpupdate

	newins f-prot.conf.default f-prot.conf
	dodir /etc
	dosym /opt/f-prot/f-prot.conf /etc/f-prot.conf

	insopts -m 644
	doins *.def license.key product.data.default f-prot.conf.default
	dosym /opt/f-prot/product.data.default /opt/f-prot/product.data

	doman doc/man/*
	dodoc doc/LICENSE* doc/CHANGES README
	dohtml doc/html/*
}

pkg_postinst() {
	elog
	elog "Remember to run /opt/f-prot/fpupdate regularly to keep virus"
	elog "database up to date. Recommended method is to use cron. See manpages for"
	elog "cron(8) and crontab(5) for more info."
	elog "An example crontab entry, causing fpupdate to run every night at 4AM:"
	elog
	elog "0 4 * * * /opt/f-prot/fpupdate -q"
	elog
	elog "For more examples, see /usr/share/doc/${PF}/html/auto_updt.html"
	elog
}
