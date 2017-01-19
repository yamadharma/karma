# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils eutils flag-o-matic

DESCRIPTION="C++ library for handling of multiple co-processes"
HOMEPAGE="http://cadabra.science/"
# SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"

if [[ ${PV} = *.9999* ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/kpeeters/cadabra.git"
        KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
        EGIT_REPO_URI="https://github.com/kpeeters/cadabra.git"
        EGIT_COMMIT="${PV}"
        KEYWORDS="~amd64 ~x86"
fi


RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1

#PATCHES=(
	# consolidated (src/)Makefile.in patch
#	"${FILESDIR}"/${PN}-1.19-Makefiles.patch
#	)

#src_compile() {
#	append-flags -D_GLIBCXX_USE_CXX11_ABI=0
#	emake
#}

src_install() {
	use doc && HTML_DOCS=( "${S}"/doc/. )
	autotools-utils_src_install DEVDESTDIR="${D}"
}

pkg_postinst() {
	elog "This version of the modglue ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=194393"
}
