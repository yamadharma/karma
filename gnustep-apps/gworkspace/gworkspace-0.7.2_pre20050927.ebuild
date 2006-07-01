# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/usr-apps/${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"

inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

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
        cvs_src_unpack
    
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

