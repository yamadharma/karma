# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep cvs

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/backbone"
ECVS_USER="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="System"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/savannah.gnu.org-backbone"

S=${WORKDIR}/${ECVS_MODULE}/Frameworks/${PN/prefsm/PrefsM}

DESCRIPTION="Preferences is the GNUstep program with which you define your own personal user experience."
HOMEPAGE="http://www.nongnu.org/backbone/apps.html"

LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"

