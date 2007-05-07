# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

IUSE=""

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/steptalk/trunk/Examples/Shell"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org-gnustep/libs/steptalk/trunk"
ESVN_PROJECT=Examples

S=${WORKDIR}/${PN}

DESCRIPTION="An interactive shell for StepTalk."
HOMEPAGE="http://www.gnustep.org/experience/StepTalk.html"

KEYWORDS="~x86 ~ppc"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	=gnustep-libs/steptalk-${PV}*"
RDEPEND="${GS_RDEPEND}
	=gnustep-libs/steptalk-${PV}*"

egnustep_install_domain "System"

