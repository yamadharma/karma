# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Eselect news module with multi-language support."

SRC_URI=""

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

DEPEND="app-admin/eselect"

RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/share/eselect/modules/ || die
	insinto /usr/share/eselect/modules/ || die
	newins ${FILESDIR}/news.eselect-${PV} news.eselect || die
}
