# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Bib2x - The Tool For Manipulating and Converting BibTeX-Libraries"
HOMEPAGE="http://www.xandi.eu/bib2x/"
SRC_URI="http://www.xandi.eu/bib2x/files/dist/${PN}_${PV/.0/}_src.tgz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install(){
	emake DESTDIR="${D}" install || die "emake install failed"
}
