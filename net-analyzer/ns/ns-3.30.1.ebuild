# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit eutils python-single-r1

NSC_PV=0.5.3

DESCRIPTION="Network Simulator"
HOMEPAGE="http://www.nsnam.org"
SRC_URI="https://www.nsnam.org/release/ns-allinone-${PV}.tar.bz2
	http://research.wand.net.nz/software/nsc/nsc-${NSC_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples tests mpi"

RDEPEND="dev-lang/python
	dev-libs/boost
	x11-libs/gtk+:3
	dev-python/pygraphviz
	sci-libs/gsl
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/ns-allinone-${PV}

#src_prepare() {
#	sed -i -e "s|^NSC_RELEASE_URL =.*|NSC_RELEASE_URL = \"file://${DISTDIR}\"|" src/internet-stack/wscript
#}

src_configure() {
	# NetAnim
	NETANIM_DIR=$(echo netanim-*)
	cd ${NETANIM_DIR}
	qmake NetAnim.pro
	cd ..

	# ns
	local myconf
	use mpi && myconf="${myconf} --enable-mpi"

	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}
	
	./waf configure \
	    --prefix=/usr \
	    $(use_enable examples) \
	    $(use_enable tests) \
	    ${myconf} || die
	cd ..	 

}

src_compile() {
	# NetAnim
	NETANIM_DIR=$(echo netanim-*)
	cd ${NETANIM_DIR}
	emake
	cd ..

	# ns
	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}
	
	./waf build || die
	cd ..	 

#	./waf build
#	if ( use examples )
#	then
#	    ./waf check
#	    ./waf --doxygen
#	fi	    
}


src_install() {
	# NetAnim
	NETANIM_DIR=$(echo netanim-*)
	cd ${NETANIM_DIR}
	
	dobin NetAnim	

	cd ..

	# ns
	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}

	./waf install --prefix=/usr --destdir=${D}
	
	dodoc AUTHORS CHANGES.html LICENSE README.md RELEASE_NOTES VERSION
	cp waf ${D}/usr/share/doc/${PF}
	if ( use examples )
	then
	    cp -R examples ${D}/usr/share/doc/${PF}
	    cp -R samples ${D}/usr/share/doc/${PF}
	fi

	cd ..

	mv ${D}/usr/lib/* ${D}/usr/lib64
}

