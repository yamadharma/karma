# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

DESCRIPTION="OgreKit is a regular expression library written in Objective-C in Cocoa."
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	>=dev-libs/oniguruma-5.7.0"
RDEPEND="${GS_RDEPEND}"

S1=${S}/Frameworks/OgreKit
