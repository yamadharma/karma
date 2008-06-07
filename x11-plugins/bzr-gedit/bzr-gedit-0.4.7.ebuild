# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils

EAPI=1

SERIES=$(get_version_component_range 1-2)
MY_PV=${SERIES}$(get_version_component_range 3)
MY_P=${PN}.${MY_PV}

DESCRIPTION="gedit plugin: Bazaar integration"
HOMEPAGE="https://launchpad.net/bzr-gedit/"
SRC_URI="http://edge.launchpad.net/${PN}/${SERIES}/${MY_PV}/+download/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+bzr-gtk"

DEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8
	>=dev-util/bzr-1.0_rc1"

RDEPEND="${DEPEND}
	>=app-editors/gedit-2.13
	bzr-gtk? ( >=dev-util/bzr-gtk-0.93 )"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	if ! built_with_use app-editors/gedit python; then
		die "gedit needs to be built with python support for this plugin to work."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:expanduser(.*):'${D}/usr/lib/gedit-2/plugins/':" setup.py
}

src_install() {
	dodir /usr/lib/gedit-2/plugins
	python setup.py install || die "install failed"
	dodoc README ROADMAP
}
