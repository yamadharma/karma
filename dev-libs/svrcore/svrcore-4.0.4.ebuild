# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Secure PIN handling using NSS crypto"
HOMEPAGE="http://www.mozilla.org/projects/security/pki"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/svrcore/releases/4.0.4/src/${P}.tar.bz2"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/nspr
	dev-libs/nss"

RDEPEND="${DEPEND}"

#src_compile() {
#}

src_install () {
	einstall || die
	dodoc INSTALL* NEWS README TODO ChangeLog
}
