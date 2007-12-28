# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/scons/scons-0.97.ebuild,v 1.8 2007/09/26 18:38:56 ranger Exp $

NEED_PYTHON="1.5.2"

inherit python distutils multilib

DESCRIPTION="Extensible Python-based build utility"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.scons.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DOCS="RELEASE.txt CHANGES.txt LICENSE.txt"

src_install () {
	distutils_src_install
	# Another attempt on Bug 107013
	rm -f "${D}"/usr/$(get_libdir)/${P}/SCons/*.py[co]
	rm -f "${D}"/usr/$(get_libdir)/${P}/SCons/*/*.py[co]
	# move man pages from /usr/man to /usr/share/man
	dodir /usr/share
	mv ${D}/usr/man ${D}/usr/share
}

pkg_postinst() {
	einfo "Cleaning up stale orphaned py[co] files..."
	# Another attempt on Bug 107013
	rm -f ${ROOT}/usr/$(get_libdir)/${P}/SCons/*.py[co]
	rm -f ${ROOT}/usr/$(get_libdir)/${P}/SCons/*/*.py[co]
	# clean up stale junk left there by old faulty ebuilds
	# see Bug 118022 and Bug 132448
	[[ -d "${ROOT}/usr/$(get_libdir)/scons" ]] && rm -rf "${ROOT}/usr/$(get_libdir)/scons"
	einfo "Done."

	python_mod_optimize ${ROOT}/usr/$(get_libdir)/${P}
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}/usr/$(get_libdir)/${P}
}
