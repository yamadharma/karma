# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit autotools python-any-r1 toolchain-funcs flag-o-matic

DESCRIPTION="A tool to create DjVu files from PDF files"
HOMEPAGE="http://jwilk.net/software/pdf2djvu"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jwilk/pdf2djvu.git"
	KEYWORDS="amd64 x86"
else
	SRC_URI="https://github.com/jwilk/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+graphicsmagick nls openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-text/djvu-3.5.21:=
	>=app-text/poppler-0.16.7:=
	dev-libs/libxml2:=
	dev-libs/libxslt:=
	graphicsmagick? ( media-gfx/graphicsmagick:= )
"
DEPEND="${RDEPEND}
	dev-cpp/pstreams
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
	)
"

REQUIRED_USE="test? ( graphicsmagick )"

DOCS=(
	doc/{changelog,credits,djvudigital,README}
)

#PATCHES=(
#	${FILESDIR}/pdf2djvu-0.9.18.2-poppler-fix.patch
#	${FILESDIR}/pdf2djvu-0.9.18.2-tests-python-3.patch
#	)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# use C++17 for Poppler
	append-cxxflags -std=gnu++17
	default
	eautoreconf
}

src_configure() {
	local openmp=--disable-openmp
	use openmp && tc-has-openmp && openmp=--enable-openmp

	econf \
		${openmp} \
		$(use_enable nls) \
		$(use_with graphicsmagick)
}
