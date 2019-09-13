# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils multilib-minimal autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/periscop/${PN}.git"
	inherit git-r3
else
	KEYWORDS="amd64"
	SRC_URI="https://github.com/periscop/${PN}/archive/${P}.tar.gz"
fi

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/"

RESTRICT="mirror"
LICENSE="LGPL-2.1"
SLOT="0/4"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-6.0.0[${MULTILIB_USEDEP}]
	>=dev-libs/isl-0.19:0=[${MULTILIB_USEDEP}]
	!dev-libs/cloog-ppl"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( README )

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		./get_submodules.sh
		./autogen.sh
#		eautoreconf -i
	else
		./autogen.sh
#		eautoreconf -i
		# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
		# sed to avoid eautoreconf
		sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die
	fi

	# Make sure we always use the system isl.
	rm -rf isl
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-gmp=system \
		--with-isl=system \
		--with-osl=no \
		$(use_enable static-libs static)
}

# The default src_test() fails, so we'll just run these directly
multilib_src_test () {
	echo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	emake -j1 check
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
