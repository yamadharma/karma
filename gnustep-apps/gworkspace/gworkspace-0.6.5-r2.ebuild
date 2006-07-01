# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep 

S=${WORKDIR}/GWorkspace-${PV}

DESCRIPTION="A workspace manager for GNUstep."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/${PN}/${P}.tar.gz"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE} imagekits samba"
DEPEND="${GS_DEPEND}
	gnustep-libs/pdfkit"
RDEPEND="${GS_RDEPEND}"

if [ `use samba` ]
    then
    S_ADD="GWNet"
    newdepend	"gnustep-libs/smbkit"
fi

S_ADD="${S_ADD} ClipBook GWRemote"

src_unpack ()
{
    unpack ${A}
    
    cd ${S}
    
    epatch ${FILESDIR}/000_gworkspace--cvs-20040630.patch.bz2
    # Non-flattened patch
    epatch ${FILESDIR}/configure.ac.patch 
    
    # Removable madia locations
    epatch ${FILESDIR}/rem_media_path.patch
    
    autoconf
}

src_compile() {
	egnustep_env

	econf || die "configure failed"

	egnustep_make

	for i in ${S_ADD}
	  do
	  cd ${S}/${i}
	  egnustep_make
	done
}

src_install ()
{
	egnustep_env
	
	egnustep_install

	for i in ${S_ADD}
	  do
	  cd ${S}/${i}
	  egnustep_install
	done
}


