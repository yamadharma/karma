# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep gnuconfig subversion

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/apps/gworkspace/trunk"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org-gnustep/apps"

S=${WORKDIR}/${PN}

DESCRIPTION="A workspace manager for GNUstep."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
#SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="~ppc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE} pdfkit"
DEPEND="${GS_DEPEND}
	pdfkit? ( gnustep-libs/pdfkit )
	!gnustep-apps/desktop
	!gnustep-apps/recycler"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"

src_unpack ()
{
        subversion_src_unpack
    
	cd ${S}
    
        # Non-flattened patch
        epatch ${FILESDIR}/configure.ac-7.patch 
    
	gnuconfig_update ${S}/Inspector    
	cd ${S}/Inspector    
	autoconf
}

src_compile() {
	egnustep_env

	econf || die "configure failed"

	egnustep_make
}

