# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit font gnome2-utils eutils unpacker

DESCRIPTION="Joplin is a free, open source note taking and to-do application, which can handle a large number of notes organised into notebooks. The notes are searchable, can be copied, tagged and modified either from the applications directly or from your own text editor."
HOMEPAGE="https://joplinapp.org/"

KEYWORDS="amd64"

SRC_URI="amd64? ( https://github.com/laurent22/joplin/releases/download/v${PV}/Joplin-${PV}.AppImage )"

SLOT="0"
RESTRICT="strip mirror"
LICENSE="AGPL-3"
IUSE=""


NATIVE_DEPEND="
"
RDEPEND="
    ${NATIVE_DEPEND}
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	default

	dodir /opt/joplin
	dodir /usr/share/applications
	dodir /usr/share/pixmaps
	dodir /usr/bin

	cp -r ${FILESDIR}/*.desktop ${D}/usr/share/applications/
	cp -r ${FILESDIR}/*.png ${D}/usr/share/pixmaps/

	cp -rL ${DISTDIR}/Joplin-${PV}.AppImage ${D}/opt/joplin/Joplin.AppImage
	chmod 0755 ${D}/opt/joplin/*.AppImage

	echo -e "#!/bin/bash\n/opt/joplin/Joplin.AppImage" > ${D}/usr/bin/joplin-bin

	chmod 0755 ${D}/usr/bin/joplin-bin
}
