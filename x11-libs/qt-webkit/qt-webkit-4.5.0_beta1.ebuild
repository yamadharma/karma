# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4-build flag-o-matic toolchain-funcs

DESCRIPTION="The Webkit module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~x11-libs/qt-gui-${PV}
	|| ( media-sound/phonon ~x11-libs/qt-phonon-${PV} )
	!x11-libs/qt:${SLOT}"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/3rdparty/webkit/WebCore tools/designer/src/plugins/qwebview"
QT4_EXTRACT_DIRECTORIES="
include/
src/
tools/
"
QCONFIG_ADD="webkit"
QCONFIG_DEFINE="QT_WEBKIT"

# see bug 236781
QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
	~x11-libs/qt-core-${PV} ssl"

src_unpack() {
	[[ $(tc-arch) == "ppc64" ]] && append-flags -mminimal-toc #241900

	qt4-build_src_unpack
	epatch "${FILESDIR}"/ExecutableAllocator_h.patch
}

src_configure() {
	myconf="${myconf} -webkit"
}
