# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="discleaner implements differents policies to clean /usr/portage/distdir"
HOMEPAGE="http://www.leak.com.ar/~juam/code/distcleaner/"
SRC_URI="http://www.leak.com.ar/~juam/code/distcleaner/releases/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=app-portage/gentoolkit-0.2.0_pre8"

src_install () 
{
     dobin ${WORKDIR}/${PN}/${PN} || die
     dodoc  ${WORKDIR}/${PN}/AUTHORS  ${WORKDIR}/${PN}/doc/README ${WORKDIR}/${PN}/TODO
}
