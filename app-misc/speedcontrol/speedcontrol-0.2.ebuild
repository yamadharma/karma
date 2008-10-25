# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

DESCRIPTION="Limits the speed of your DVD drive for noise reduction. Very useful for NEC drives."
HOMEPAGE="http://harmsma.eu/files/${P}.tar.gz"
SRC_URI="http://harmsma.eu/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="mirror"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}"

src_compile() {
        emake speedcontrol || die "emake failed"
}

src_install() {
        dosbin speedcontrol || die "dosbin failed"
        doman speedcontrol.1 || die "doman failed"
        dodoc speedcontrol.1 speedcontrol.c || die "dodoc failed"
}
