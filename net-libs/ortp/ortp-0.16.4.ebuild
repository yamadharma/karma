# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.16.3.ebuild,v 1.4 2011/01/01 20:36:18 hwoarang Exp $

EAPI="3"

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://download.savannah.nongnu.org/releases-noredirect/linphone/${PN}/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE="debug doc examples ipv6# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.16.3.ebuild,v 1.4 2011/01/01 20:36:18 hwoarang Exp $

EAPI="3"

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://download.savannah.nongnu.org/releases-noredirect/linphone/${PN}/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE="debug doc examples ipv6 minimal srtp ssl"

RDEPEND="srtp? ( net-libs/libsrtp )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	# to be sure doc is not builded nor installed w/ -doc and doxygen installed
	if ! use doc; then
		sed -i -e 's/test $DOXYGEN != //' configure \
			|| die "patching configure failed"
	fi

	# to authorize -srtp even with libsrtp installed
	if ! use srtp; then
		sed -i -e 's/$have_srtp_headers$have_srtp_lib//' configure \
			|| die "patching configure failed"
	fi

	# to authorize -ssl even with openssl installed
	if ! use ssl; then
		sed -i -e 's/SSL_LIBS=".*"/SSL_LIBS=""/' \
			-e 's/openssl\/.*.h/poll.h/' configure \
			|| die "patching configure failed"
	fi

	# do not build examples programs, see bug 226247
	sed -i -e 's/SUBDIRS = . tests/SUBDIRS = ./' src/Makefile.in \
		|| die "patching src/Makefile.in failed"

	# ${P} is added after ${docdir}
	if use doc; then
		sed -i -e 's/$(docdir)\/$(PACKAGE)-$(VERSION)/$(docdir)/' Makefile.in \
			|| die "patching Makefile.in failed"
	fi
}

src_configure() {
	# force docdir to standard Gentoo doc directory
	# memcheck is for HP-UX only
	# mode64bit adds +DA2.0W +DS2.0 CFLAGS wich are needed for HP-UX
	# st