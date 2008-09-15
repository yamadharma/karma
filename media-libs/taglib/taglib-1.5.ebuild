# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.5.ebuild,v 1.1 2008/03/20 21:57:15 ingmar Exp $

inherit autotools libtool eutils

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="debug rcc"

RDEPEND=""
DEPEND="dev-util/pkgconfig
	rcc? ( app-i18n/librcc )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	use rcc && (
	    epatch ${FILESDIR}/taglib-1.5-ds-rusxmms.patch || die
	    aclocal
	    automake
	    autoconf
#	    causes make install problems
#	    eautoreconf || die
	)

#	elibtoolize
}

src_compile() {
	econf $(use_enable debug) || die "econf failed."
	emake || die "emake failed."
#SDS
	emake -C examples || die "emake -C examples failed."
#EDS
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
#SDS
	emake -C examples DESTDIR=${D} install || die "emake -C examples install failed."
#EDS
	dodoc AUTHORS doc/* || die "dodoc failed."
}
