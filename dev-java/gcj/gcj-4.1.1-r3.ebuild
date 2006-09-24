# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

PATCH_VER="1.6"
UCLIBC_VER="1.0"
GENTOO_PATCH_EXCLUDE="54_all_300-libstdc++-pic.patch"

inherit gcc-java-2

DESCRIPTION="The GNU Compiler for the Java(tm) Programming Language"
HOMEPAGE="http://gcc.gnu.org/java/"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~ppc x86"
SLOT="4.1"

RDEPEND="virtual/libc
	>=sys-libs/zlib-1.1.4
	!nogtk? ( >=x11-libs/gtk+-2.8
		cairo? ( >=x11-libs/cairo-1.0.2 ) )
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

	echo ${PV/_/-} > "${S}"/gcc/BASE-VER
	echo "" > "${S}"/gcc/DATESTAMP

	cd ${S}/libjava/classpath/
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
		EPATCH_MULTI_MSG="fixes/ports from gnu-classpath ..." \
		epatch ${FILESDIR}/classpath/

	einfo "tweak ports for GCJ ..."
	epatch ${FILESDIR}/fix-java.beans.Encoder.patch

	cd ${S}
	epatch ${FILESDIR}/libjava-include.XMLEncoder.patch
	# OOo2 issues / gcc PR13212
	epatch ${FILESDIR}/gcc41-java-gc-thread-attach-2.patch
}

src_compile() {
	gcj_src_compile
}

pkg_preinst() {
	:
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
	ewarn ""
	ewarn "You are on your own using this! If you have any interesting news"
	ewarn "let us know: http://forums.gentoo.org/viewtopic-t-379693.html"
}

pkg_postinst() {
	:
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
