# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/User/${PN/v/V}

DESCRIPTION="An Application for displaying and navigating in PDF documents."
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Applications"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/popplerkit
	gnustep-libs/iconkit"
RDEPEND="${DEPEND}"
