# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/dev-apps/${PN/projectc/ProjectC}"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="An IDE for GNUstep."
HOMEPAGE="http://www.gnustep.org/experience/ProjectCenter.html"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}
	>=sys-devel/gdb-6.0"

src_unpack ()
{
    cvs_src_unpack

    cd ${S}
    # LDFLAGS fix for Non-flattened
    cd ${S}
    sed -i -e "s:framework/Versions/Current:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" GNUmakefile.preamble
}

# Local Variables:
# mode: sh
# End:
