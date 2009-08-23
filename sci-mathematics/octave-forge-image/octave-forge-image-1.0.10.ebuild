# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit octave-forge

DESCRIPTION="Provides functions for reading, writing, and processing images."
LICENSE="GPL-2"
HOMEPAGE="http://octave.sourceforge.net/image/index.html"
SRC_URI="mirror://sourceforge/octave/${OCT_PKG}.tar.gz"
SLOT="0"

IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="media-gfx/imagemagick"
