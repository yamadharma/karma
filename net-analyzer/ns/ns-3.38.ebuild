# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

PYTHON_COMPAT=( python3_{7..11} )

inherit python-single-r1

NSC_PV=0.5.3

DESCRIPTION="Network Simulator"
HOMEPAGE="http://www.nsnam.org"
SRC_URI="https://www.nsnam.org/release/ns-allinone-${PV}.tar.bz2"
#	http://research.wand.net.nz/software/nsc/nsc-${NSC_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~x86 ~amd64"
IUSE="doc +examples +tests mpi static"

RDEPEND="dev-lang/python
	dev-libs/boost
	x11-libs/gtk+:3
	dev-python/pygraphviz
	sci-libs/gsl
"
DEPEND="${RDEPEND}
	static? ( dev-db/sqlite[static-libs] )
	!static? ( dev-db/sqlite )
	dev-python/pygccxml
	dev-python/cxxfilt
	|| ( sci-physics/root dev-python/cppyy )
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/ns-allinone-${PV}

#src_prepare() {
#	sed -i -e "s|^NSC_RELEASE_URL =.*|NSC_RELEASE_URL = \"file://${DISTDIR}\"|" src/internet-stack/wscript
#}

src_configure() {
	python_get_sitedir
	#./build.py

	## NetAnim
	NETANIM_DIR=$(echo netanim-*)
	cd ${NETANIM_DIR}
	qmake5 NetAnim.pro
	cd ..
	
	## pybindgen
	#PYBINGEN_DIR=$(echo pybindgen-*)
	#cd ${PYBINGEN_DIR}
	#./waf configure --prefix=/usr
	#cd ..
	
	## ns
	local myconf
	use mpi && myconf="${myconf} --enable-mpi"

	myconf="${myconf} --enable-monolib --enable-python-bindings"
	myconf="${myconf} --cxx-standard 17"
	
	myconf="${myconf} -- -DNS3_BINDINGS_INSTALL_DIR=${PYTHON_SITEDIR}"


	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}

	./ns3 configure \
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

	## pybindgen
	#PYBINGEN_DIR=$(echo pybindgen-*)
	#cd ${PYBINGEN_DIR}
	#./waf build
	#cd ..

	# ns
	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}
	
	./ns3 build || die
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

	## pybindgen
	#PYBINGEN_DIR=$(echo pybindgen-*)
	#cd ${PYBINGEN_DIR}
	#./waf install --prefix=/usr --destdir=${D}
	#cd ..

	## ns
	NS_DIR=$(echo ns-*)
	cd ${NS_DIR}

	export DESTDIR="${D}"; ./ns3 install
	dobin ns3
	
	dodoc README.md
#	cp waf ${D}/usr/share/doc/${PF}
	if ( use examples )
	then
	    cp -R examples ${D}/usr/share/doc/${PF}
	    cp -R samples ${D}/usr/share/doc/${PF}
	fi

	cd ..

	mv ${D}/usr/lib/* ${D}/usr/lib64
}

