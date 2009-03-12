# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/User/${PN/t/T}

DESCRIPTION="Etoile project simple word processor"

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Applications"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND="gnustep-libs/ogrekit"
RDEPEND="${DEPEND}"
