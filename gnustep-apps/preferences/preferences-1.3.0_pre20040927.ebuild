# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/preferences/preferences-1.3.0_pre20040927.ebuild,v 1.1 2004/09/28 17:52:56 fafhrd Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/backbone"
ECVS_USER="anoncvs"
ECVS_AUTH="no"
ECVS_MODULE="System"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-backbone"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}/Applications/${PN/p/P}

DESCRIPTION="Preferences is the GNUstep program with which you define your own personal user experience."
HOMEPAGE="http://www.nongnu.org/backbone/apps.html"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	=gnustep-libs/prefsmodule-1.1.1${PV/*_/_}"
RDEPEND="${GS_RDEPEND}"

src_unpack() {
	cvs_src_unpack
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/Preferences-nocreate-extra-dirs.patch
}

