# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=7

inherit desktop xdg-utils

DESCRIPTION="Research management tool for desktop and web"
HOMEPAGE="https://www.mendeley.com/"
SRC_URI="https://static.mendeley.com/bin/desktop/${P}-x86_64.AppImage"

LICENSE="Mendeley-terms"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	${PYTHON_DEPS}"

S=${WORKDIR}/squashfs-root

RESTRICT="mirror strip bindist"

src_unpack() {
	cp "${DISTDIR}"/${P}-x86_64.AppImage . || die "cp failed"
	chmod +x ${P}-x86_64.AppImage || die "chmod failed"
	./${P}-x86_64.AppImage --appimage-extract || die "AppImage extract failed"
}

src_install() {
	# install menu
	domenu ${PN}.desktop

	# fix permissions
	find ${S} -type d -exec chmod 755 '{}' \;

	# install application icons
	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor

	# install files
	dodir /opt/${PN}
	cp -R ${S}/* ${D}/opt/${PN}

	# symlink launch script
	dosym /opt/${PN}/${PN} /opt/bin/${PN}
}
