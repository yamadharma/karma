# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION=""
HOMEPAGE="http://www.geogebra.org/cms/en"
SRC_URI="https://geogebra.googlecode.com/files/GeoGebra-Unixlike-Installer-${PV}.tar.gz"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jdk-1.6.0-r1
	${DEPEND}"

RESTRICT=mirror

src_unpack() {
	unpack ${A}
}

src_prepare() {
	sed -i -e "s:/usr:\${D}/usr:g" install.sh
}

src_install() {
	dodir /usr/bin
	dodir /usr/share
	dodir /usr/share/applications
	dodir /usr/share/geogebra
	dodir /usr/share/mime/packages
	./install.sh
}
