# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

S="${WORKDIR}"
MY_PV="${PV/_pre/M}"
DMF="S-${MY_PV}-200711012000"

DESCRIPTION="GTK based SWT Library"
HOMEPAGE="http://www.eclipse.org/swt/"
SRC_URI="x86? ( http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${PN}-${MY_PV}-gtk-linux-x86.zip )
		amd64? ( http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${PN}-${MY_PV}-gtk-linux-x86_64.zip )
		ppc? ( http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${PN}-${MY_PV}-gtk-linux-ppc.zip )"

SLOT="3.4"
LICENSE="CPL-1.0 LGPL-2.1 MPL-1.1"
KEYWORDS="amd64 ~ppc x86"
IUSE="cairo firefox gnome opengl seamonkey xulrunner"

COMMON_DEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.8
	>=dev-libs/atk-1.10.2
	cairo? ( >=x11-libs/cairo-1.0.2 )
	gnome? (
		=gnome-base/libgnome-2*
		=gnome-base/gnome-vfs-2*
		=gnome-base/libgnomeui-2*
	)
	!seamonkey? (
		firefox? ( >=www-client/mozilla-firefox-2 >=dev-libs/nspr-4.6.2 )
	) seamonkey? ( >=www-client/seamonkey-1.0.2 >=dev-libs/nspr-4.6.2 )
	xulrunner? ( >=net-libs/xulrunner-1.8.0.1 >=dev-libs/nspr-4.6.2 )
	opengl? (
		virtual/opengl
		virtual/glu
	)"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.4
	dev-java/ant-core
	app-arch/unzip
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	x11-proto/xextproto"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.4"

src_unpack() {
	unzip -jq ${DISTDIR}/${A} "*src.zip" || die "unable to extract distfile"
	unpack ./src.zip

	# replace build.xml to skip eclipse tasks
	cp ${FILESDIR}/build.xml ${S}/build.xml || die "Failed to update build.xml"
	mkdir ${S}/src && mv ${S}/org ${S}/src || die "Failed to restructure SWT sources"

	epatch ${FILESDIR}/swt-3.2-callback-pointer-dereferencing.patch

	sed -r -e "s/(CFLAGS = -O -Wall)/\1 ${CFLAGS} /" -i make_linux.mak \
		|| die "Failed to tweak make_linux.mak"
	sed -r -e "s/(MOZILLACFLAGS = )-O/\1${CXXFLAGS} /" -i make_linux.mak \
		|| die "Failed to tweak make_linux.mak"

	# arch: ppc, x86, x86_64, ...
	# version: 3.2.1.v3235
	local eclipsearch=${ARCH}
	use amd64 && eclipsearch=x86_64
	local myver="${PV/_*}.v$(sed -e "s:[A-z. ]::g" ${S}/version.txt)"
	sed -r -e "s:ARCH:${eclipsearch}:g" \
		-e "s:PV:${myver}:g" \
		< ${FILESDIR}/MANIFEST.MF \
		> ${S}/MANIFEST.MF \
		|| die "manifest failed"
}

src_compile() {
	local jvmarch="${ARCH}"
	use x86 && jvmarch="i386"
	
	# set awt library path
	AWT_LIB_PATH="$(java-config --jdk-home)/jre/lib/${jvmarch}"
	echo ${AWT_LIB_PATH}
	[[ $(java-pkg_get-vm-vendor) == "ibm" ]] \
		&& AWT_LIB_PATH="$(java-config --jdk-home)/jre/bin"
	[[ ! -f ${AWT_LIB_PATH}/libjawt.so ]] \
		&& die "Could not find libjawt.so native library"
	export AWT_LIB_PATH

	# fix pointer size
	[[ ${ARCH} == "amd64" ]] && export SWT_PTR_CFLAGS=-DSWT_PTR_SIZE_64

	# set targets
	local target="awt swt atk"
	use gnome && target="${target} gnome"
	( use seamonkey || use firefox ) && target="${target} mozilla"
	use xulrunner && target="${target} xulrunner"
	use cairo && target="${target} cairo"
	use opengl && target="${target} glx"

	declare mozilla
	use firefox && mozilla=firefox
	use seamonkey && mozilla=seamonkey
	if [ -n "${mozilla}" ] ; then
		export MOZILLA_INCLUDES="$(pkg-config ${mozilla}-gtkmozembed --cflags)"
		export MOZILLA_LIBS="$(pkg-config ${mozilla}-gtkmozembed --libs)"
	fi

	if use xulrunner; then
		export XULRUNNER_INCLUDES="$(pkg-config xulrunner-gtkmozembed --cflags)"
		export XULRUNNER_LIBS="$(pkg-config xulrunner-gtkmozembed --libs)"
	fi

	for lib in ${target} ; do
		einfo "building ${lib} library"
		emake -f make_linux.mak NO_STRIP=y make_${lib} || die "failed to build ${lib} library"
	done

	einfo "building jni library"
	eant compile

	# copy missing files
	cp ${FILESDIR}/fragment.properties ${S}/build/fragment.properties
	cp ${S}/version.txt ${S}/build/version.txt
	cp ${S}/src/org/eclipse/swt/internal/SWTMessages.properties ${S}/build/org/eclipse/swt/internal/

	einfo "jarring jni library"
	eant jar
}

src_install() {
	java-pkg_dojar swt.jar

	java-pkg_sointo /usr/$(get_libdir)
	java-pkg_doso *.so

	local eclipse_dir=/usr/$(get_libdir)/eclipse-${SLOT}/plugins
	local swt_pkg=$(sed -n -r -e "s/^Bundle-SymbolicName: (.*);.*/\1/p" "${S}/MANIFEST.MF")
	local swt_ver=$(sed -n -r -e "s/^Bundle-Version: (.*)\r$/\1/p" "${S}/MANIFEST.MF")

	dodir ${eclipse_dir}

	local eclipse_link=${eclipse_dir}/${swt_pkg}_${swt_ver}.jar
	local swt_lib=/usr/share/swt-${SLOT}/lib/swt.jar

	dosym ${swt_lib} ${eclipse_link}

	dohtml about.html
}
