# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit gnustep subversion

IUSE=""

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/${PN}/trunk"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org-gnustep/libs"

S=${WORKDIR}/${PN}

IUSE=""

DESCRIPTION="GNUstep GSLdap Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86"

newdepend	"net-nds/openldap"

src_unpack ()
{
    subversion_src_unpack
    
    cd ${S}
    # Headers location fix
    sed -i -e "s:base/GSCategories.h:GNUstepBase/GSCategories.h:g" GSLDAPCom.h
}