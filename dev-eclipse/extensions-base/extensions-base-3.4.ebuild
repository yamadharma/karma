# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils

DESCRIPTION="Base package for Eclipse extensions"
HOMEPAGE="http://www.eclipse.org"
SRC_URI=""
SLOT="${PV}"
LICENSE="as-is"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-util/eclipse-sdk:${SLOT}"
RDEPEND="${DEPEND}"

src_install() {
	local EXT_DIR="/usr/$(get_libdir)/eclipse-extensions-${SLOT}"
	local SDK_DIR="/usr/$(get_libdir)/eclipse-${SLOT}"

	dodir "${EXT_DIR}" || die
	touch "${D}${EXT_DIR}/.eclipseextension" || die
	ln -s . "${D}${EXT_DIR}/eclipse" || die

	dodir "${SDK_DIR}/links" || die
	echo "path=${EXT_DIR}/eclipse" > "${D}${SDK_DIR}/links/eclipse-extensions-${SLOT}.link" || die
}
