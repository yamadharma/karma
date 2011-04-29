# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion autotools
	ESVN_REPO_URI=https://openmodelica.org/svn/MetaModelica/trunk
	ESVN_PROJECT=mmc
	ESVN_USER=anonymous
	ESVN_PASSWORD=none
else
	inherit autotools
# 	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="Relational Meta-Language (RML) and Tools"
HOMEPAGE="http://www.ida.liu.se/~pelab/rml"

LICENSE="OSMC-PL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	|| ( dev-lang/smlnj dev-lang/mlton )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_configure() {
	SMLNJ_HOME=/usr \
	./configure --prefix=/usr \
	|| die
}