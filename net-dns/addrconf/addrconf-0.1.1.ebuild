# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Iv4/IPv6 DNS and DHCP config generator"
HOMEPAGE="http://www.net.t-labs.tu-berlin.de/~gregor/tools/"
SRC_URI="http://www.net.t-labs.tu-berlin.de/~gregor/tools/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ipv6"

DEPEND=""
RDEPEND="dev-lang/perl
	ipv6? ( net-misc/ipv6calc )"


src_install() {
	dobin addrconf.pl
	dodoc LICENSE README
	cp -R examples ${D}/usr/share/doc/${PF}
}
