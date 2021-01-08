# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit eutils gnome2-utils distutils-r1 scons-utils

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem and offers to remove it"
HOMEPAGE="https://github.com/sahib/rmlint"

if [[ ${PV} = 9999* ]]; then
inherit git-r3
EGIT_REPO_URI="https://github.com/sahib/${PN}.git"
EGIT_BRANCH="develop"
KEYWORDS=""
else
SRC_URI="https://github.com/sahib/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="X doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="X? ( x11-libs/gtksourceview:3.0
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		gnome-base/librsvg:2
		x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
		dev-util/scons[${PYTHON_USEDEP}]
		sys-devel/gettext
		virtual/pkgconfig"

src_compile(){
	escons CC="$(tc-getCC)"
}

src_install(){
	escons install LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr
    rm -f ${ED}/usr/share/glib-2.0/schemas/gschemas.compiled
    if ! use X; then
    	rm -rf "${D}"/usr/share/{glib-2.0,icons,applications}
    	rm -rf "${D}"/usr/lib
	fi
	if ! use doc; then
		rm -rf "${D}"/usr/share/man
	fi
}

pkg_postinst() {
	use X && gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	use X && gnome2_schemas_update
	xdg_icon_cache_update
}
