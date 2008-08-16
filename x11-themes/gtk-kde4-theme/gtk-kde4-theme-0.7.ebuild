# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Qt4 theme for gtk-engines-kde4"
MY_PN="qt4"
HOMEPAGE="http://kde-apps.org/content/show.php/${PN/-theme//}?content=74689"
SRC_URI="http://betta.h.com.ua/no-site/qt4.tar.gz"

LICENSE="GPL-2"
# no keywords for now
KEYWORDS="amd64 x86"

RDEPEND="${RDEPEND}
	x11-themes/gtk-engines-kde4
	"
DEPEND="${RDEPEND}"

SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_PN}

src_install() {
	into usr/share/themes/
	dodir ${MY_PN}
}
