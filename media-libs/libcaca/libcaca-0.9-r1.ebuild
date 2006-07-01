# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcaca/libcaca-0.9-r1.ebuild,v 1.7 2005/01/07 02:38:01 chriswhite Exp $

inherit eutils

DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://sam.zoy.org/projects/libcaca"
SRC_URI="http://sam.zoy.org/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="ncurses slang doc imlib X"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.3 )
	slang? ( >=sys-libs/slang-1.4.2 )
	doc? ( app-doc/doxygen )
	imlib? ( media-libs/imlib2 )
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	# Let libtool build the libraries, see BUG #57359
	epatch ${FILESDIR}/${P}-libtool.patch
	cd "${S}"
	libtoolize --force || die "libtoolize"
	aclocal || die "aclocal"
	automake --add-missing || die "automake"
	autoconf || die "autoconf"
}

src_compile() {
	# temp font fix #44128
	export VARTEXFONTS="${T}/fonts"

	local myconf=""

	if use X ; then
		if [ -e /usr/lib/libX11.so ] || [ -e /usr/lib/libX11.a ]
		then
			myconf="${myconf} --enable-x11 --with-x --x-libraries=/usr/$(get_libdir)"
		else
			myconf="${myconf} --enable-x11 --with-x --x-libraries=/usr/X11R6/$(get_libdir)"
		fi
	else
		myconf="${myconf} --disable-x11"
	fi

	econf \
	    --disable-doc \
	    $(use_enable ncurses) \
	    $(use_enable slang) \
	    $(use_enable imlib imlib2) \
		${myconf} \
	    || die

# $(use_enable doc) \

	emake || die
	unset VARTEXFONTS
}

src_install() {
	mv doc/man/man3caca doc/man/man3
	make install DESTDIR="${D}" || die
	dodoc AUTHORS BUGS ChangeLog NEWS NOTES README TODO
}
