# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

inherit toolchain-funcs eutils

DESCRIPTION="small and fast paludis helper tools written in C"
HOMEPAGE="http://www.gentoo.org/"

SRC_URI="mirror://truc/${PN}/${P}.tar.bz2 mirror://truc/${PN}/${PV}-overlay-and-optional-paludis-support.tar.bz2"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="purge"
RESTRICT="primaryuri test"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/overlay-support.patch
	epatch ${WORKDIR}/portage2paludis.patch
	if use purge; then
		epatch ${WORKDIR}/purge_metadata.patch
		sed 's:/usr/bin/q --metacache:/usr/bin/q --purge:' -i ${WORKDIR}/q-reinitialize.bash
	fi
}

src_install() {
	dobin q || die "dobin failed"
	doman man/*.[0-9]
	for applet in $(<applet-list) ; do
		dosym q /usr/bin/${applet}
	done

	exeinto "/usr/bin"
	doexe ${WORKDIR}/palsearch
	dodir /usr/share/paludis/hooks/sync_all_post/ || die
	insinto /usr/share/paludis/hooks/sync_all_post
	doins ${WORKDIR}/q-reinitialize.bash
}

pkg_postinst() {

	einfo "${ROOT}/usr/share/paludis/hooks/sync_all_post/q-reinitialize.bash been installed for convenience"
	einfo "Normally this should only take a few seconds to run but file systems such as ext3 can take a lot longer."
	einfo "If ever you find this to be an inconvenience simply delete ${ROOT}/usr/share/paludis/hooks/sync_all_post/q-reinitialize.bash"
}
