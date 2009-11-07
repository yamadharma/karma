# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EHG_REPO_URI="https://artscan.googlecode.com/hg"

inherit distutils mercurial

DESCRIPTION="Cross-platform Python/PyQt4 scripted scanning and image processing"
HOMEPAGE="http://code.google.com/p/artscan"
# SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/Babel
	dev-python/PyQt4
	media-gfx/imagemagick
	dev-python/pythonmagick
	"

DEPEND="$RDEPEND"

S=${WORKDIR}/hg/trunk/python


