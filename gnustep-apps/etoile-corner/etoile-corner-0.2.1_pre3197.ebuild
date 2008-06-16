# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/Private/Corner

DESCRIPTION="Runs a StepTalk script when the mouse moves into the corner of the
screen"
HOMEPAGE="http://www.etoile-project.org"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/steptalk"
RDEPEND="${DEPEND}"
