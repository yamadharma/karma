# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gworkspace/gworkspace-0.7.1.ebuild,v 1.1 2005/04/15 04:35:57 fafhrd Exp $

inherit gnustep gnuconfig

S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="A workspace manager for GNUstep."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="~ppc x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE} pdfkit"
#	>=dev-db/sqlite-3.2.8
DEPEND="${GS_DEPEND}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	pdfkit? ( gnustep-libs/pdfkit )
	!gnustep-apps/desktop
	!gnustep-apps/recycler"
RDEPEND="${GS_RDEPEND}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	pdfkit? ( gnustep-libs/pdfkit )
	!gnustep-apps/desktop
	!gnustep-apps/recycler"

egnustep_install_domain "System"

src_unpack ()
{
        unpack ${A}
    
	cd ${S}
    
        # Non-flattened patch
        epatch ${FILESDIR}/configure.ac-7.patch 
	
	gnuconfig_update ${S}/Inspector    
	cd ${S}/Inspector    
	autoconf
	
	# FIX compile mdextractor
	echo "ADDITIONAL_LDFLAGS += -L../../../DBKit/obj" >> ${S}/Tools/gmds/mdextractor/GNUmakefile.preamble
}


src_compile () 
{
	egnustep_env

	econf || die "configure failed"
	egnustep_make
	
	cd ${S}/Tools/gmds
	econf || die "configure failed"
	egnustep_make
	
	cd ${S}/Preferences/Indexing
	egnustep_make
}

src_install () 
{
	egnustep_env

	egnustep_install

	cd ${S}/Tools/gmds
	egnustep_install
	
	cd ${S}/Preferences/Indexing
	egnustep_install
}

