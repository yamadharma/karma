# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit octave-forge

DESCRIPTION="Symbolic toolbox based on GiNaC and CLN."
LICENSE="GPL-2"
HOMEPAGE="http://octave.sourceforge.net/symbolic/index.html"
SRC_URI="mirror://sourceforge/octave/${OCT_PKG}.tar.gz"
SLOT="0"

IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="sci-mathematics/ginac"
