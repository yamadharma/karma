# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="a gssapi interface wrapper"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/libgssapi/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.7-gssapi_mech.patch
}

src_compile() {
	econf --libdir=/usr/$(get_libdir)/gssapi || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	mv ${D}/usr/$(get_libdir)/gssapi/pkgconfig ${D}/usr/$(get_libdir)/
	dodoc AUTHORS ChangeLog NEWS README
	insinto /etc
	doins doc/gssapi_mech.conf || die
}
