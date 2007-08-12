# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/DictionaryReader"

DESCRIPTION="Dictionary application that queries Dict servers"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=DictionaryReader"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/etoile-ui"
RDEPEND="${DEPEND}"

src_compile() {
	egnustep_env
	egnustep_make etoile=yes || die "compilation failed"
}
