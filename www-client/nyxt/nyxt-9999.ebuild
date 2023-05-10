# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Nyxt browser: the Internet on your terms"
HOMEPAGE="https://nyxt.atlas.engineer/"
EGIT_REPO_URI="https://github.com/atlas-engineer/nyxt.git"

# TODO: Necessary to download dependencies. Otherwise, create dev-lisp packages.
RESTRICT="network-sandbox"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/enchant:2
	net-libs/glib-networking
	dev-libs/gobject-introspection
	gnome-base/gsettings-desktop-schemas
	net-libs/webkit-gtk[introspection,spell]
	dev-db/sqlite
	sys-libs/libfixposix
	x11-misc/xclip
"
BDEPEND="${DEPEND}"
RDEPEND="
	>=dev-lisp/sbcl-2.0.0
	${DEPEND}"

src_compile(){
	emake all
}

src_install(){
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		install
}

pkg_postinst(){
	elog "If pages do not render, "
	elog "\"export WEBKIT_DISABLE_COMPOSITING_MODE=1\""
	elog " and try again"
}
