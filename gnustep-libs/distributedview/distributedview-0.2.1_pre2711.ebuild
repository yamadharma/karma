# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Frameworks/DistributedView

DESCRIPTION="Etoile project extensions framework, provides a flexible icon view"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=DistributedView"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND="gnustep-libs/etoile-ui"
RDEPEND="${DEPEND}"
