# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop unpacker xdg-utils

IUSE="system-ffmpeg system-mesa"

DESCRIPTION="Microsoft Teams Linux Client (Insiders Build)"
HOMEPAGE="https://teams.microsoft.com/"
SRC_URI="https://packages.microsoft.com/repos/ms-teams/pool/main/t/${PN}/${PN}_${PV}_amd64.deb"
LICENSE="GitHub"
SLOT="0"
KEYWORDS="~amd64"

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
	media-libs/alsa-lib
	media-libs/fontconfig
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
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
DEPEND=""
PDEPEND=""
RESTRICT="primaryuri mirror strip"

S="${WORKDIR}"

src_install() {
	local dest=/usr

	# Remove keytar3, it needs libgnome-keyring. keytar4 uses libsecret and is used instead
	rm -rf "${WORKDIR}/usr/share/teams-insiders/resources/app.asar.unpacked/node_modules/keytar3" || die

	insinto ${dest}/share
	doins -r "${S}"${dest}/share/applications
	doins -r "${S}"${dest}/share/pixmaps
	doins -r "${S}"${dest}/share/${PN}

	exeinto ${dest}/bin
	doexe "${S}"${dest}/bin/${PN}

	exeinto ${dest}/share/${PN}
	doexe "${S}"${dest}/share/${PN}/${PN}

	# Use system ffmpeg, if wanted. Might crash MS Teams!
	if use system-ffmpeg; then
		rm -f "${D}"/${dest}/share/${PN}/libffmpeg.so
		dosym "${dest}/$(get_libdir)/chromium/libffmpeg.so" "${dest}/share/${PN}/libffmpeg.so"
	else
		# Otherwise keep the executable bit on the bundled lib
		doexe "${S}"${dest}/share/${PN}/libffmpeg.so
	fi

	# Use system mesa, if wanted. Might Crash MS Teams!
	if use system-mesa; then
		rm -f "${D}"/${dest}/share/${PN}/libEGL.so
		rm -f "${D}"/${dest}/share/${PN}/libGLESv2.so
	else
		# Otherwise keep original executable flag
		doexe "${S}"/${dest}/share/${PN}/libEGL.so
		doexe "${S}"/${dest}/share/${PN}/libGLESv2.so
	fi

	# Keep swiftshader, used in GPU-/Head-less systems
	exeinto ${dest}/share/${PN}/swiftshader
	doexe "${S}"/${dest}/share/${PN}/swiftshader/libEGL.so
	doexe "${S}"/${dest}/share/${PN}/swiftshader/libGLESv2.so

	sed -i '/OnlyShowIn=/d' "${S}"${dest}/share/applications/${PN}.desktop
	domenu "${S}"${dest}/share/applications/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
