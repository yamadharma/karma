# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2


inherit gnustep cvs

IUSE=""

#ECVS_SERVER="subversions.gnu.org:/cvsroot/gnustep"
#ECVS_MODULE="SMBKit"
#ECVS_USER="anoncvs"
#ECVS_CVS_OPTIONS="-dP"
#ECVS_ANON="yes"

ECVS_AUTH="ext"
ECVS_SERVER="cvs.gnustep.org:/cvsroot/gnustep"
ECVS_MODULE="gnustep/dev-libs/SMBKit"
ECVS_USER="anoncvs"
ECVS_CVS_OPTIONS="-dP"


S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="GNUstep SMBKit Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86"

newdepend	"net-fs/samba"
