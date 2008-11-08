# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Fedora Directory Server (base)"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/svrcore-4.0.3
	>=dev-libs/mozldap-6.0.2
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/adminutil-1.1.4-no_icu_pc.patch
}

src_compile() {
	econf $(use_enable debug) \
	    ${myconf} \
	    --with-fhs \
	    || die "econf failed"
	emake || die "emake failed"

#             --with-nspr=yes \
#             --with-nss=yes \
#             --with-ldapsdk=yes \
#             --with-db=yes \
#             --with-svrcore=yes \
#             --with-icu=yes \

}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"
}
