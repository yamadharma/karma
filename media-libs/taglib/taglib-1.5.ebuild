# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.5.ebuild,v 1.5 2008/07/06 12:58:15 maekke Exp $

inherit autotools libtool eutils base

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="debug test"

RDEPEND=""
DEPEND="dev-util/pkgconfig
	test? ( dev-util/cppunit )
	sys-libs/zlib 
	rcc? ( app-i18n/librcc )"


PATCHES=( "${FILESDIR}/${P}-gcc43-tests.patch" "${FILESDIR}/taglib-1.5-ds-rusxmms.patch" )

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc43-tests.patch" || die
	
	use rcc && (
	    epatch ${FILESDIR}/taglib-1.5-ds-rusxmms.patch || die
	    aclocal
	    automake
	    autoconf
	)
}


src_compile() {
	econf $(use_enable debug) || die "econf failed."
	emake || die "emake failed."
	emake -C examples || die "emake -C examples failed."	
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	emake -C examples DESTDIR=${D} install || die "emake -C examples install failed."	
	dodoc AUTHORS doc/* || die "dodoc failed."
}

