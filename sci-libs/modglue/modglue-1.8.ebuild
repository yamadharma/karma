# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="C++ library for handling of multiple co-processes"
HOMEPAGE="http://www.aei.mpg.de/~peekas/cadabra"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
DEPEND="( >=dev-libs/libsigc++-2.0 )"
RDEPEND="${DEPEND}"


src_install() {
	einstall DESTDIR=${D} DEVDESTDIR=${D} || die
	use doc && dohtml ${S}/doc/*
	dodoc AUTHORS COPYING ChangeLog INSTALL
}
