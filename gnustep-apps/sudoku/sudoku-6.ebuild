# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

MY_PN="${PN/s/S}"
S="${WORKDIR}/${MY_PN}${PV}"

DESCRIPTION="Sudoku generator for GNUstep"
HOMEPAGE="http://www.gnustep.it/marko/Sudoku"
SRC_URI="http://www.gnustep.it/marko/${MY_PN}/${MY_PN}${PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"
