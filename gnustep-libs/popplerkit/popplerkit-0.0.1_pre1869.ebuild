# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Frameworks/PopplerKit

DESCRIPTION="PopplerKit is a GNUstep/Cocoa framework for accessing and rendering PDF content."
HOMEPAGE="http://home.gna.org/gsimageapps/"
#SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	>=app-text/poppler-0.4.5"
RDEPEND="${GS_RDEPEND}
	>=app-text/poppler-0.4.5"
