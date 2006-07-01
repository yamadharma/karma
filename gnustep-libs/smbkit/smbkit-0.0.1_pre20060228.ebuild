# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2


inherit gnustep subversion

IUSE=""

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/smbkit/trunk"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org-gnustep/libs"

S=${WORKDIR}/${PN}

DESCRIPTION="GNUstep SMBKit Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86"

newdepend	"net-fs/samba"
