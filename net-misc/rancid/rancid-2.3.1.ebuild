# Copyright 2003 Martin Hierling <mad@cc.fh-lippe.de>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rancid/rancid-2.3.1.ebuild,v 1.3 2006/02/21 08:48:28 mad Exp $

IUSE=""

DESCRIPTION="Really Awesome New Cisco confIg Differ"
HOMEPAGE="http://www.shrubbery.net/rancid/"
SRC_URI="ftp://ftp.shrubbery.net/pub/rancid/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
RESTRICT="nomirror"

DEPEND=">=dev-tcltk/expect-5.40"

src_unpack() {
	unpack ${A}
	cd ${S}
	econf --prefix=/usr --sysconfdir=/etc/rancid --localstatedir=/var/lib/rancid
}

src_compile() {
	emake || die "compile problem"
}

src_install() {
	# dirty, someone should patch the makefile
	for i in $(find bin/ -perm 755 -regex 'bin/[-a-z0-9]+'); do
		dobin $i
	done
	doman man/*{1,5}

	# dirty, someone should patch the makefile
	for i in $(find share/ -regex 'share/[^M].*'); do
		dodoc $i
	done

	dodoc CHANGES COPYING FAQ README README.lg UPGRADING cloginrc.sample

	keepdir /etc/rancid
	insinto /etc/rancid
	doins etc/*.sample

	keepdir /var/lib/rancid
}

