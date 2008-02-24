# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

ECJ_VER="3.4"

inherit gcc-java-2

DESCRIPTION="The GNU Compiler for the Java(tm) Programming Language"
HOMEPAGE="http://gcc.gnu.org/java/"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="4.3"

RDEPEND="virtual/libc
	virtual/libiconv
	=dev-java/eclipse-ecj-${ECJ_VER}*
	>=sys-libs/zlib-1.1.4
	>=dev-libs/gmp-4.2.1
	>=dev-libs/mpfr-2.2.0_p10
	!nogtk? ( >=x11-libs/gtk+-2.8
		>=x11-libs/cairo-1.0.2
		x11-libs/pango
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXtst
		x11-proto/xproto
		x11-proto/xextproto )
	gconf? ( >=gnome-base/gconf-2.14 )
	>=media-libs/libart_lgpl-2.1
	>=sys-libs/ncurses-5.2-r2
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	>=sys-devel/bison-1.875
	>=sys-devel/binutils-2.16.1"

pkg_setup() {
	gcj_pkg_setup
}

src_unpack() {
	gcj_src_unpack
}

src_compile() {
	gcj_src_compile
}

pkg_preinst() {
	:;
}

src_install() {
	gcj_src_install

	# copy scripts
	exeinto /usr/bin
	doexe ${FILESDIR}/gcj-config
	doexe ${FILESDIR}/rebuild-classmap-db
}

pkg_postinst() {
	ewarn "This gcj ebuild is provided for your convenience, and the use"
	ewarn "of this JDK replacement is not supported by the Gentoo Developers."
	ewarn
	ewarn "You are on your own using this! If you have any interesting news"
	ewarn "let us know: http://forums.gentoo.org/viewtopic-t-379693.html"

	gcj-config ${P}
}

pkg_prerm() {
	:;
}

pkg_postrm() {
	:;
}
