# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

ESVN_PROJECT=etoile

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/etoile/trunk/Etoile"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/etoile"

S1=${S}/Frameworks/PopplerKit

DESCRIPTION="PopplerKit is a GNUstep/Cocoa framework for accessing and rendering PDF content."
HOMEPAGE="http://home.gna.org/gsimageapps/"
#SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	>=app-text/poppler-0.4.5"
RDEPEND="${GS_RDEPEND}
	>=app-text/poppler-0.4.5"

egnustep_install_domain "System"

src_compile ()
{
	egnustep_env

	cd ${S1}

#	if ( ! has_version =x11-libs/cairo-1.2.* )
#	    then
#	    # Dirty hack. Don't work with cairo-1.2.x
#	    ./config.sh
#	    sed -i -e "s:HAVE_CAIRO=.*:HAVE_CAIRO=NO:" config.make
#	fi
	
	egnustep_make || die
}

src_install() {
	cd ${S1}
	gnustep_src_install
}
