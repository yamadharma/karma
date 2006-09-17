# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="ezbzr is a set of plugins for bzr that provide convenience functions."
HOMEPAGE="http://www.natemccallum.com/software/ezbzr"
SRC_URI="http://www.natemccallum.com/projects/ezbzr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
