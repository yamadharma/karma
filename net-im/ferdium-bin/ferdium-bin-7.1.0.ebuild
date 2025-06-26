# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_PN="${PN/-bin/}"

inherit desktop xdg-utils

DESCRIPTION="Combine your favorite messaging services into one application"
HOMEPAGE="https://ferdium.org/"

SRC_URI="
	amd64? ( https://github.com/${_PN}/${_PN}-app/releases/download/v${PV}/${_PN^}-linux-${PV}-amd64.deb )
"
S=${WORKDIR}
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
IUSE="wayland"

RDEPEND="
	wayland? ( dev-libs/wayland )
"

QA_PREBUILT="*"

src_prepare() {
	bsdtar -x -f data.tar.xz
	rm data.tar.xz control.tar.gz debian-binary
	if use wayland; then
		sed -E -i -e "s|Exec=/opt/${_PN^}/${_PN}|Exec=/usr/bin/${PN} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-webrtc-pipewire-capturer|" "usr/share/applications/${_PN}.desktop"
	else
		sed -E -i -e "s|Exec=/opt/${_PN^}/${_PN}|Exec=/usr/bin/${PN}|" "usr/share/applications/${_PN}.desktop"
	fi

	# Activate icon
	sed -E -i -e "s|Icon=${_PN}|Icon=${PN}|" "usr/share/applications/${_PN}.desktop"

	default
}

src_install() {
	declare FERDIUM_HOME=/opt/${_PN^}

	dodir ${FERDIUM_HOME%/*}

	insinto ${FERDIUM_HOME}
	doins -r opt/${_PN^}/*

	exeinto ${FERDIUM_HOME}
	exeopts -m0755
	doexe "opt/${_PN^}/${_PN}"

	# keep executable portable library
	doexe opt/${_PN^}/{chrome-sandbox,chrome_crashpad_handler,lib*}

	dosym "${FERDIUM_HOME}/${_PN}" "/usr/bin/${PN}"

	newmenu usr/share/applications/${_PN}.desktop ${PN}.desktop

	for _size in 16 24 32 48 64 96 128 256 512; do
		newicon -s ${_size} "usr/share/icons/hicolor/${_size}x${_size}/apps/${_PN}.png" "${PN}.png"
	done

	# desktop eclass does not support installing 1024x1024 icons
	insinto /usr/share/icons/hicolor/1024x1024/apps
	newins "usr/share/icons/hicolor/1024x1024/apps/${_PN}.png" "${PN}.png"

	# Installing 128x128 icon in /usr/share/pixmaps for legacy DEs
	newicon "usr/share/icons/hicolor/128x128/apps/${_PN}.png" "${PN}.png"

	insinto /usr/share/licenses/${PN}
	for _license in 'LICENSE.electron.txt' 'LICENSES.chromium.html'; do
		doins opt/${_PN^}/$_license
	done
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
