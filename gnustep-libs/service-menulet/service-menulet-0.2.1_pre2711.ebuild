# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Bundles/ServiceMenulet

DESCRIPTION="menulet to use services provided by GNUstep applications"
HOMEPAGE="http://www.etoile-project.org"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86"
SLOT="0"

RDEPEND="gnustep-apps/azbackground"
