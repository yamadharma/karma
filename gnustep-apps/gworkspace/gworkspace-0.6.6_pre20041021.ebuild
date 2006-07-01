# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/usr-apps/${PN}"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="A workspace manager for GNUstep."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE} imagekits samba"
DEPEND="${GS_DEPEND}
	=dev-db/sqlite-3*
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
    cvs_src_unpack
    
    cd ${S}
    
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


