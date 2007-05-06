# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit gnustep subversion

ESVN_PROJECT=gsldap

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/${ESVN_PROJECT}/trunk"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/gnustep/libs"

S=${WORKDIR}/${ESVN_PROJECT}

IUSE=""

DESCRIPTION="GNUstep GSLdap Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="${GS_DEPEND}
	net-nds/openldap"
RDEPEND="${GS_RDEPEND}
	net-nds/openldap"

src_unpack ()
{
    subversion_src_unpack
    
    cd ${S}
    # Headers location fix
    sed -i -e "s:base/GSCategories.h:GNUstepBase/GSCategories.h:g" GSLDAPCom.h
}