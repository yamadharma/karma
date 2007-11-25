# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Frameworks/BookmarkKit

DESCRIPTION="System wide bookmarks support framework"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=BookmarkKit"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND="gnustep-libs/collectionkit"
RDEPEND="${DEPEND}"
