# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils cmake-utils

DESCRIPTION="ParadisEO is a white-box object-oriented framework dedicated to the flexible design of metaheuristics"
HOMEPAGE="http://paradiseo.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/27238/paradiseo-1.3-beta2.tar.gz"

LICENSE="CeCill"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="dev-util/cmake"
RDEPEND=""

S=${WORKDIR}/${PN}-${PV/_/-}

src_compile() {
	echo -e "1\n3\ny\n" | ./installParadiseo.sh
}