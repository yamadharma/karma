# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

DESCRIPTION="Patched version of transset for extra functionality"
HOMEPAGE="http://forchheimer.se/transset-df/"
SRC_URI="http://forchheimer.se/transset-df/transset-df-5.tar.gz"

SLOT="0"
# *****************
# Double check license - no specific mention of one
LICENSE="BSD"
# ******************
KEYWORDS="x86 ~ppc amd64"

DEPEND=">=x11-base/xorg-x11-6.7.99.902"

S=${WORKDIR}/transset-df-5

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/transset-df-makefile.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin transset-df
	dodoc README
	dodoc ChangeLog
}
