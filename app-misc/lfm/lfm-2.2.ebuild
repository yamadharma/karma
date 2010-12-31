# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="lfm - Last File Manager"
HOMEPAGE="http://www.terra.es/personal7/inigoserna/lfm"
SRC_URI="http://www.terra.es/personal7/inigoserna/lfm/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

RDEPEND="dev-lang/python
	sys-libs/ncurses"
DEPEND="${RDEPEND}"
