# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzrtools/bzrtools-1.5.0.ebuild,v 1.1 2008/05/22 16:46:49 hawking Exp $

NEED_PYTHON=2.4

inherit distutils versionator

DESCRIPTION="Qt frontend for Bazaar"
HOMEPAGE="https://launchpad.net/qbzr"
SRC_URI="http://launchpad.net/qbzr/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-util/bzr-1.3
        >=dev-python/PyQt4-4.1"

DOCS="AUTHORS.txt COPYING.txt NEWS.txt README.txt TODO.txt"

S="${WORKDIR}/${PN}"

PYTHON_MODNAME=bzrlib
