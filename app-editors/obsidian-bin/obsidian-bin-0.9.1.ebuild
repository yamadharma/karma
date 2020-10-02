# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils

MY_PN="${PN/-bin}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files (binary version)"
HOMEPAGE="https://obsidian.md/"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/${MY_P}.tar.gz"

RESTRICT="mirror strip bindist"

LICENSE="EULA"
SLOT="0"
KEYWORDS="-* amd64"

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	x11-libs/libXtst
	!app-editors/vscode"

RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-atk
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	app-crypt/libsecret[crypt]"

S="${WORKDIR}/${MY_P}"

# DOCS=( resources/app/LICENSE.rtf )

QA_PRESTRIPPED="*"
QA_PREBUILT="opt/${MY_PN}/${MY_PN}"

src_install() {
	mkdir -p "${ED%/}/opt/${MY_PN}"
	cp -r . "${ED%/}/opt/${MY_PN}/"
	dodir /usr/bin
	dosym /opt/${MY_PN}/${MY_PN} /usr/bin/${MY_PN}

	pax-mark m "${ED%/}"/opt/${MY_PN}/${MY_PN}
}

