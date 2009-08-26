# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Chromium Web Browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://build.chromium.org/buildbot/archives/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-* x86 amd64"
IUSE=""

RDEPEND="
	>=dev-libs/nss-3.12.2
	>=gnome-base/gconf-2.24.0
	>=media-libs/alsa-lib-1.0.19
	>=x11-libs/gtk+-2.14.7"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23
	>=dev-util/scons-1.2.0"

src_compile() {
	tools/gyp/gyp_chromium build/all.gyp --depth=. || die "gyp failed"
	scons --site-dir="${S}/site_scons" -C build \
		--mode=Release chrome || die "scons failed"
}

src_install() {
	# Chromium does not have "install" target in the build system.

	dodir /opt/chromium

	exeinto /opt/chromium
	doexe sconsbuild/Release/chrome
	doexe sconsbuild/Release/xdg-settings
	doexe "${FILESDIR}/chromium-launcher.sh"

	insinto /opt/chromium
	doins sconsbuild/Release/chrome.pak
	doins sconsbuild/Release/product_logo_48.png

	doins -r sconsbuild/Release/locales
	doins -r sconsbuild/Release/resources
	doins -r sconsbuild/Release/themes

	# Chromium compiles patched versions of these media libraries.
	dodir /opt/chromium/lib
	insinto /opt/chromium/lib
	doins sconsbuild/Release/libavcodec.so.52
	doins sconsbuild/Release/libavformat.so.52
	doins sconsbuild/Release/libavutil.so.50

	make_desktop_entry "/opt/chromium/chromium-launcher.sh" "Chromium" \
		"/opt/chromium/product_logo_48.png" || die "make_desktop_entry failed"
}
