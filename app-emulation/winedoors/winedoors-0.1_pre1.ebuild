# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit versionator

DESCRIPTION="Wine Doors"
HOMEPAGE="http://www.wine-doors.org"
MY_PV="$(delete_version_separator _ ${PV})"
SRC_URI="http://www.wine-doors.org/releases/wine-doors-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-python/pygtk
		dev-python/pycairo
		app-emulation/wine
		app-arch/cabextract
		app-arch/tar
		dev-python/gnome-python-desktop"
src_compile() {
return
}

src_install(){
python ${WORKDIR}/wine-doors-${MY_PV}/setup.py -S --prefix=${D} install
return
}


