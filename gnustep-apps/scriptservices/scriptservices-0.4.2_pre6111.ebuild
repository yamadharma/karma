# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1="${S}/Services/Private/ScriptServices"

DESCRIPTION="Gateway between GNUstep system services and Unix scripts"
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="gnustep-libs/smalltalkkit"
RDEPEND="${DEPEND}"
