# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Nyxt (formerly Next) browser - Be productive."
HOMEPAGE="https://github.com/atlas-engineer/nyxt"
SRC_URI="https://github.com/atlas-engineer/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# TODO: Necessary to download dependencies. Otherwise, create dev-lisp packages.
RESTRICT="network-sandbox"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	dev-db/sqlite
	dev-lisp/sbcl
	sys-libs/libfixposix
	x11-misc/xclip
"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

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
	elog "if page not render "
	elog "\"export WEBKIT_DISABLE_COMPOSITING_MODE=1\""
	elog " and try again"
}
