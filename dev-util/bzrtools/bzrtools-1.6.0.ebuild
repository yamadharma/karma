# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzrtools/bzrtools-0.13.0.ebuild,v 1.2 2007/01/18 16:09:03 fmccor Exp $

inherit distutils versionator

DESCRIPTION="bzrtools is a useful collection of utilities for bzr."
HOMEPAGE="http://bazaar-vcs.org/BzrTools"
SRC_URI="https://launchpad.net/${PN}/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-util/bzr-$(get_version_component_range 1-2)_beta1"

DOCS="CREDITS NEWS NEWS.Shelf README README.Shelf TODO TODO.Shelf"

S="${WORKDIR}/${PN}"

src_test() {
	python_version
	einfo "Running testsuite..."
	# put a linked copy of the bzr core into the build directory to properly
	# test the "built" version of bzrtools
	find /usr/lib/python${PYVER}/site-packages/bzrlib/ \
		-mindepth 1 -maxdepth 1 \
		\( \( -type d -and -not -name "plugins" \) -or -name "*.py" \) \
		-exec ln -s '{}' "${S}"/build/lib/bzrlib/ \;
	touch "${S}"/build/lib/bzrlib/plugins/__init__.py
	"${S}"/test.py "${S}"/build/lib || die "Testsuite failed."
	# remove the "shadow" copy so it doesn't get installed
	rm "${S}"/build/lib/bzrlib/plugins/__init__.py
	find "${S}"/build/lib/bzrlib/ -mindepth 1 -maxdepth 1 -type l -exec rm '{}' \;
}
