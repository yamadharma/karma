# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module latex-package

DESCRIPTION="Perl script for automatically building LaTeX documents."
HOMEPAGE="http://www.arakhne.org/spip.php?rubrique35"
SRC_URI="http://download.tuxfamily.org/arakhne/pool/${PN}/${PN}_${PV}-0arakhne0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	dev-perl/Config-Simple"

src_install() {
	perl ./Makefile.PL --nobinlink "--prefix=${D}/usr" install
	
	dosym /usr/lib/autolatex/autolatex.pl /usr/bin/autolatex
	dosym /usr/lib/autolatex/autolatex-gtk.pl /usr/bin/autolatex-gtk	
}