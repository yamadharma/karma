# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzr/bzr-0.6.2.ebuild,v 1.1 2006/01/07 01:20:43 arj Exp $

EAPI="3"

inherit distutils

PYTHON_MODNAME="vcpx"
DESCRIPTION="Tool to migrate changesets between RCS repositories"
HOMEPAGE="http://darcs.net/DarcsWiki/Tailor"
SRC_URI="http://darcs.arstecnica.it/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
DEPEND="dev-lang/python"
