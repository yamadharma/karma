# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/Private/MenuServer

DESCRIPTION="Menubar's background for Etoile."

HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/etoilesystem"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/etoilesystem"
