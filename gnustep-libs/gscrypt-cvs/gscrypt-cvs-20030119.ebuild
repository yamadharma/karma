# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2


inherit gnustep-app cvs

IUSE=""

ECVS_SERVER="subversions.gnu.org:/cvsroot/gnustep"
ECVS_MODULE="gscrypt"
ECVS_USER="anoncvs"
ECVS_CVS_OPTIONS="-dP"
ECVS_ANON="yes"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="GNUstep GSCrypt Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86"

	
