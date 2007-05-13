# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/User/Vindaloo

DESCRIPTION="An Application for displaying and navigating in PDF documents."

HOMEPAGE="http://gna.org/projects/gsimageapps"
#SRC_URI="http://download.gna.org/gsimageapps/${PN/v/V}/${P/v/V}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/popplerkit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/popplerkit"

