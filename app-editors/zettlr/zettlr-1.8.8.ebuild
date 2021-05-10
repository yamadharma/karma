# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils rpm

MY_PN="Zettlr"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Markdown Editor for the 21st century (binary version)"
HOMEPAGE="https://www.zettlr.com/"
SRC_URI="https://github.com/Zettlr/Zettlr/releases/download/v${PV}/${MY_P}-x86_64.rpm"

RESTRICT="mirror strip bindist"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* amd64"

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	x11-libs/libXtst
	"

RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-atk
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	app-crypt/libsecret[crypt]"

S="${WORKDIR}"

# DOCS=( resources/app/LICENSE.rtf )

QA_PRESTRIPPED="*"
QA_PREBUILT="opt/${MY_PN}/${PN}"

src_install(){
	mkdir -p "${ED%/}"
	cp -r . "${ED%/}/"
	rm -rf "${ED%/}/usr/lib"
	dodir /usr/bin
	dosym /opt/${MY_PN}/${PN} /usr/bin/${PN}
	pax-mark m "${ED%/}"/opt/${MY_PN}/${PN}
}

