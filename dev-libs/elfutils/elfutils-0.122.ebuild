# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.122.ebuild,v 1.3 2006/08/05 21:10:27 vapier Exp $

inherit eutils autotools

PVER="1.0"
DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="http://people.redhat.com/drepper/"
SRC_URI="ftp://sources.redhat.com/pub/systemtap/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PVER}.tar.bz2"

LICENSE="OpenSoftware"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

# This pkg does not actually seem to compile currently in a uClibc
# environment (xrealloc errs), but we need to ensure that glibc never
# gets pulled in as a dep since this package does not respect virtual/libc
DEPEND="elibc_glibc? ( >=sys-libs/glibc-2.3.2 )
	sys-devel/gettext
	sys-devel/autoconf
	>=sys-devel/binutils-2.15.90.0.1
	>=sys-devel/gcc-3.3.3
	!dev-libs/libelf"
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${WORKDIR}"/patch/*.patch
	epatch "${FILESDIR}"/${PN}-0.118-libelf-link.patch
	epatch "${FILESDIR}"/${PN}-0.118-PaX-support.patch
	epatch "${FILESDIR}"/${PN}-0.118-no-nested-functions.patch #116968
	# this will make more files +x than need be, but who cares really
	chmod a+rx config/*

	AT_M4DIR="${S}/m4" eautoreconf

	find . -name Makefile.in -print0 | xargs -0 sed -i -e 's:-W\(error\|extra\)::g'
}

src_compile() {
	econf \
		--program-prefix="eu-" \
		--enable-shared \
		|| die "./configure failed"
	emake || die
}

src_test() {
	env LD_LIBRARY_PATH="${S}/libelf:${S}/libebl:${S}/libdw:${S}/libasm" \
		make check || die "test failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO
}
