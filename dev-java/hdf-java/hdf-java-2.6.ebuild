# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2
DESCRIPTION="Java interface to the hdf5 library"
HOMEPAGE="http://www.hdfgroup.org/hdf-java-html/index.html"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/hdf-java/src/${P}-src.tar"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE="szip"

COMMON_DEPEND=">=sci-libs/hdf5-1.8[szip=]
               >=media-libs/jpeg-7
			   >=dev-libs/libzip-0.9"
RDEPEND="${COMMON_DEPEND}
		 >=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
		${RDEPEND}"

S="${WORKDIR}/${PN}"

RESTRICT=userpriv

src_prepare() {
	cd "${S}/native/hdf5lib" || die
	sed -i s"|case JH5F_SCOPE_DOWN|//case JH5F_SCOPE_DOWN|" h5Constants.c || die
}

src_configure() {
	local myconf=""
	use szip && myconf="--with-libsz=/usr/include,/usr/$(get_libdir)"

	econf \
		--with-libz="/usr/include,/usr/$(get_libdir)" \
		--with-libjpeg="/usr/include,/usr/$(get_libdir)" \
		--with-hdf5="/usr/include,/usr/$(get_libdir)" \
		--with-jdk="$(java-config -O)/include,$(java-config -o)/jre/lib" \
		$myconf
}

src_compile() {
	emake || die
}

src_install() {
	java-pkg_dojar "lib/jhdf5.jar"
	java-pkg_doso "lib/linux/libjhdf5.so"
}
