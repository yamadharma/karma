# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Id3 library for C/C++"
HOMEPAGE="http://id3lib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc rcc"

RDEPEND="sys-libs/zlib
	 rcc? ( app-i18n/librcc )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-zlib.patch
	epatch ${FILESDIR}/${P}-test_io.patch
	epatch "${FILESDIR}"/${P}-autoconf259.patch
	epatch "${FILESDIR}"/${P}-doxyinput.patch
	epatch "${FILESDIR}"/${P}-unicode16.patch
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch

	# Security fix for bug 189610.
	epatch "${FILESDIR}"/${P}-security.patch

	use rcc && ( epatch ${FILESDIR}/id3lib-ds-rcc.patch || die )

	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	econf || die "econf failed."
	emake || die "emake failed."

	if use doc; then
		cd doc/
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dosym /usr/$(get_libdir)/libid3-3.8.so.3 /usr/$(get_libdir)/libid3-3.8.so.0.0.0
	dosym /usr/$(get_libdir)/libid3-3.8.so.0.0.0 /usr/$(get_libdir)/libid3-3.8.so.0

	dodoc AUTHORS ChangeLog HISTORY INSTALL README THANKS TODO

	# some example programs to be placed in docs dir.
	if use doc; then
		dohtml -r doc
		cp -a examples ${D}/usr/share/doc/${PF}/examples
		cd ${D}/usr/share/doc/${PF}/examples
		make distclean
	fi
}
