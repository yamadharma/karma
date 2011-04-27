# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion autotools
	ESVN_REPO_URI=https://openmodelica.org/svn/OpenModelica/trunk/
# ESVN_PROJECT=
	ESVN_USER=anonymous
	ESVN_PASSWORD=none
else
	inherit autotools
# 	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="OPENMODELICA is an open-source Modelica-based modeling and simulation environment intended for industrial and academic usage"
HOMEPAGE="http://www.openmodelica.org"

LICENSE="OSMC-PL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

