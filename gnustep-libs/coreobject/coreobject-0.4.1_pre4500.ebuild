# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2 etoile-svn

# S="${WORKDIR}/Etoile-${PV}/Frameworks/CoreObject"
S1="${S}/Frameworks/CoreObject"

DESCRIPTION="A framework for describing and organizing model objects"
HOMEPAGE="http://www.etoile-project.org"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/postgresql-base
	gnustep-libs/etoile-serialize"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s/-Werror/& -fgnu89-inline/" etoile.make || die "sed failed"
}
