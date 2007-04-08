# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Hook management wih eselect - for Paludis."

SRC_URI=""

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

DEPEND="sys-apps/paludis
	app-admin/eselect"

RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/share/eselect/modules/ || die
	insinto /usr/share/eselect/modules/ || die
	newins ${FILESDIR}/eselect-${PV}/paludis-hook.eselect paludis-hook.eselect || die

	touch ${WORKDIR}/.keep
	dodir /usr/share/paludis/hooks/eselect/.db/ || die
	insinto /usr/share/paludis/hooks/eselect/.db/ || die
	newins ${WORKDIR}/.keep .keep || die

	for i in `ls ${FILESDIR}/definitions/` ; do
		insinto /usr/share/paludis/hooks/eselect/ || die
		newins ${FILESDIR}/definitions/${i} ${i} || die
	done
}
