# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep cvs

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.gna.org:/cvs/gsimageapps"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"
ECVS_MODULE="gsimageapps/Applications/SlideShow"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/gna.org-gsimageapps"

S=${WORKDIR}/${ECVS_MODULE}


#MY_PN=SlideShow
#S=${WORKDIR}/${MY_PN}

DESCRIPTION="SlideShow Viewer"


HOMEPAGE="http://gna.org/projects/gsimageapps"
#SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-libs/slideshowkit"
RDEPEND="${GS_RDEPEND}"
	
mydoc="Documentation/*"	

src_unpack ()
{
    cvs_src_unpack
    cd ${S}
    
    sed -i -e "s:-lSlideShowKit:-lSlideShow:g" GNUmakefile

}

src_install ()
{
    egnustep_env
    egnustep_install

    dodoc ${mydoc}
}


# Local Variables:
# mode: sh
# End:

