# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="Lightweight network manager for LXDE"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="dev-libs/glib:2
	net-misc/dhcpcd"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	dev-util/intltool
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:docbook-to-man \$< > \$@:docbook2man \$<:' man/Makefile.am || die "sed failed"
	sed -i 's:LXNM:lxnm:' man/lxnm.sgml || die "sed failed"
	./autogen.sh
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
}
