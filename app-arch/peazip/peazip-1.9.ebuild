# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions

DESCRIPTION="OS-portable archiver with many formats support"
HOMEPAGE="http://peazip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/peazip_portable-${PV}.bin.LINUX.GTK2.i586-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 -*" # binary distribution, won't work on other arches

IUSE="kde"

DEPEND=""
RDEPEND="x86? (
		>=x11-libs/libX11-1.1.1
		>=x11-libs/libXext-1.0.3
		>=x11-libs/libXrender-0.9.1
		>=x11-libs/libXinerama-1.0.2
		>=x11-libs/libXi-1.1.0
		>=x11-libs/libXrandr-1.2.1
		>=x11-libs/libXcursor-1.1.8
		>=x11-libs/libXfixes-4.0.3
		>=x11-libs/libXau-1.0.3
		>=x11-libs/libXdmcp-1.0.2
		>=x11-libs/gtk+-2.10.9
		>=dev-libs/glib-2.12.9
		>=x11-libs/pango-1.14.10
		>=media-libs/freetype-2.3.3
		>=media-libs/fontconfig-2.4.2
		>=dev-libs/expat-1.95.8
		=media-libs/libpng-1.2*
	)
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-10.2
		>=app-emulation/emul-linux-x86-xlibs-10.0
		>=app-emulation/emul-linux-x86-gtklibs-10.0
	)"

if use kde; then
	need-kde 3
fi

S="${WORKDIR}/peazip_portable-${PV}.bin.LINUX.GTK2.i586-1"

src_compile() {
	true # no compilation required, it's binary package
}

src_install() {
	exeinto /opt/${PN}
	doexe ${PN}
	dosym ../../opt/${PN}/${PN} /usr/bin/${PN}
	domenu FreeDesktop_integration/${PN}.desktop
	if use kde; then
		insinto "${KDEDIR}/share/apps/konqueror/servicemenus"
		doins FreeDesktop_integration/${PN}{add,extfolder,exthere,open}.desktop
	fi
	dodir /opt/${PN}/res
	cp -R "${S}/res" "${D}/opt/${PN}" || die "install failed"
}
