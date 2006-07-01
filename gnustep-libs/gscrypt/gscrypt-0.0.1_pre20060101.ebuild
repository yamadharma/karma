# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="gnustep/dev-libs/${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"

inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

IUSE=""

DESCRIPTION="GNUstep GSCrypt Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86"

	
