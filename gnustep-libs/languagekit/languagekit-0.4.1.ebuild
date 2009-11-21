# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Languages/LanguageKit"

DESCRIPTION="a compiler kit built on top of LLVM for creating dynamic language implementations using an Objective-C runtime for the object model"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	>=gnustep-libs/etoile-foundation-${PV}
	sys-devel/llvm-2.5"
RDEPEND="${DEPEND}"
