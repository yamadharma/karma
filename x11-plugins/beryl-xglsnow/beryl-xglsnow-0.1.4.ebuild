# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib

DESCRIPTION="Beryl Window Decorator Snow Plugin"
HOMEPAGE="http://beryl-project.org"
SRC_URI="http://cornergraf.net/fundanemt/files/xglsnow-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="x11-plugins/beryl-plugins"

S="${WORKDIR}/xglsnow-${PV}"

src_compile() {
	filter-ldflags -znow -z,now
	filter-ldflags -Wl,-znow -Wl,-z,now

	epatch "${FILESDIR}"/${PN}-makefile.patch

	emake -j1 || die "make failed"
}

src_install() {
	dodir /usr/share/beryl
	dodir /usr/$(get_libdir)/beryl
	make PREFIX="${D}/usr" LIBDIR="$(get_libdir)" install || die "make install failed"
}

pkg_postinst() {
	einfo "Please report all bugs to http://bugs.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo XEffects team"
}
