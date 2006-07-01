# Copyright 1999-2004 Gentoo Foundation
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
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-backbone"

S=${WORKDIR}/${ECVS_MODULE}/Applications/${PN/texte/TextE}

DESCRIPTION="A text editor with font, color, and style capabilities for GNUstep"
HOMEPAGE="http://www.nongnu.org/backbone/"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

