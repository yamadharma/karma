# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

DESCRIPTION="GNOME interface for libtranslate"
HOMEPAGE="http://www.nongnu.org/libtranslate/gnome-translate"
SRC_URI="http://savannah.nongnu.org/download/libtranslate/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86 amd64"
LICENSE="GPL-2"
IUSE=""
G2CONF=""


DEPEND=">=x11-libs/gtk+-2.4.0
	 >=dev-libs/libtranslate-0.99
	 >=gnome-base/eel-2.6.0
	 app-text/aspell"
	 
DOCS="AUTHORS COPYING INSTALL NEWS README TODO"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}"/gnome-translate-ds-eel.patch || die
}
