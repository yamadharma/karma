# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.22-r1.ebuild,v 1.8 2010/08/18 04:02:21 jer Exp $

EAPI="2"
inherit eutils multilib


DESCRIPTION="minidjvu is a DjVu encoder for black-and-white images"
HOMEPAGE="http://minidjvu.sourceforge.net"
SRC_URI="mirror://sourceforge/minidjvu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="debug doc jpeg nls tiff xml"

DEPEND="virtual/jpeg
	media-libs/tiff"
RDEPEND="${RDEPEND}"

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install-app install-lib install-po || die

	# Dirty hack
	dodir /usr/$(get_libdir)
	mv ${D}/usr/lib* ${D}/usr/$(get_libdir)/

	doman doc/minidjvu.1
	doman -i18n=ru doc/ru/minidjvu.1

	dodoc README NEWS INSTALL

	use doc && cp -r doc/ "${D}"/usr/share/doc/${PF}
}

