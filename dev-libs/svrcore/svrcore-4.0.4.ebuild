# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib autotools

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/directory/svrcore/releases/${PV}/src/${P}.tar.bz2"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ipv6 debug"

DEPEND=">=dev-libs/nss-3.11
	>=dev-libs/nspr-4.6"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cd "${S}"
	eautoreconf
}

src_compile() {
	if use amd64 ; then
		myconf="${myconf} --enable-64bit"
	else
		myconf=""
	fi

	econf $(use_enable debug) ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"

	# cope with libraries being in /usr/lib/svrcore
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/svrcore" > "${D}"/etc/env.d/08svrcore
}
