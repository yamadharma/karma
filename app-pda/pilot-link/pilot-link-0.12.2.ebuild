# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.9"
inherit perl-module eutils autotools toolchain-funcs

DESCRIPTION="suite of tools for moving data between a Palm device and a desktop"
HOMEPAGE="http://www.pilot-link.org/"
SRC_URI="http://pilot-link.org/source/${P}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~sparc x86"
IUSE="threads usb png bluetooth readline perl java tcl python"

RDEPEND="virtual/libc
	sys-libs/ncurses
	usb? ( dev-libs/libusb )
	png? ( media-libs/libpng )
	bluetooth? ( net-wireless/bluez-libs )
	readline? ( sys-libs/readline )
	perl? ( dev-lang/perl )
	java? ( virtual/jre )
	tcl? ( dev-lang/tcl dev-lang/tk )
	python? ( dev-lang/python )
	"
DEPEND="${RDEPEND}
	java? ( virtual/jdk )
	"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-build.patch"
	eautoconf
	eautomake
}

src_compile() {
	econf \
		--includedir=/usr/include/libpisock \
		--enable-conduits \
		$(use_enable threads) $(use_enable usb libusb) \
		$(use_with png libpng $(libpng-config --prefix)) \
		$(use_with bluetooth bluez) \
		$(use_with readline) $(use_with perl) $(use_with java) \
		$(use_with tcl tcl /usr/$(get_libdir)) \
		$(use_with python) \
		|| die "econf failed"
	emake || die "emake failed"

	if use perl ; then
		cd "${S}/bindings/Perl"
		perl-module_src_prep
		perl-module_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog README doc/README* doc/TODO NEWS AUTHORS

	if use perl ; then
		cd "${S}/bindings/Perl"
		perl-module_src_install
	fi
}
