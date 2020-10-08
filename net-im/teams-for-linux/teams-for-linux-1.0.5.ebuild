# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

IUSE="system-ffmpeg system-mesa"

DESCRIPTION="Unofficial Microsoft Teams client for Linux using Electron"
HOMEPAGE="https://github.com/IsmaelMartinez/teams-for-linux"
SRC_URI="https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${PV}/${PN}_${PV}_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="bindist mirror splitdebug test"

QA_PREBUILT="*"

BDEPEND="
	system-ffmpeg? ( <media-video/ffmpeg-4.3[chromium] )
	system-mesa? ( <media-libs/mesa-20.2[egl,gles2] )
"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	gnome-base/libgnome-keyring
	media-libs/alsa-lib
	media-libs/fontconfig
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
	${BDEPEND}
"

S="${WORKDIR}"

src_install() {
	local dest=/opt

	cp -R ${S}/* "${D}"

	# Use system ffmpeg, if wanted. Might crash MS Teams!
	if use system-ffmpeg; then
		rm -f "${D}"/${dest}/${PN}/libffmpeg.so
		dosym "${dest}/$(get_libdir)/chromium/libffmpeg.so" "${dest}/share/${PN}/libffmpeg.so"
#	else
#		# Otherwise keep the executable bit on the bundled lib
#		doexe "${S}"${dest}/${PN}/libffmpeg.so
	fi

	# Use system mesa, if wanted. Might Crash MS Teams!
	if use system-mesa; then
		rm -f "${D}"/${dest}/${PN}/libEGL.so
		rm -f "${D}"/${dest}/${PN}/libGLESv2.so
#	else
#		# Otherwise keep original executable flag
#		doexe "${S}"/${dest}/${PN}/libEGL.so
#		doexe "${S}"/${dest}/${PN}/libGLESv2.so
	fi

	dodir /opt/bin
	dosym /opt/${PN}/${PN} /opt/bin/${PN}

#	sed -i '/OnlyShowIn=/d' "${S}"/usr/share/applications/${PN}.desktop || die
	domenu usr/share/applications/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
