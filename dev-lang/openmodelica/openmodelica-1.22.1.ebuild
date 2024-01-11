# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit autotools flag-o-matic multilib qmake-utils desktop
#inherit cmake flag-o-matic multilib qmake-utils desktop

OMOptimPV=1.11.0-dev.beta4
OMSensPV=WorkPackage-2-Final

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenModelica/OpenModelica.git"
	KEYWORDS=""
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenModelica/OpenModelica.git"
	EGIT_COMMIT="v${PV}"
	REFS="refs/tags/v${PV}"
	TAG="${PV}"
#	SRC_URI="https://github.com/OpenModelica/OpenModelica/archive/v${PV}.tar.gz -> ${P}.tar.gz
#		https://github.com/OpenModelica/OMOptim/archive/v${OMOptimPV}.tar.gz -> OMOptim-${OMOptimPV}.tar.gz
#		https://github.com/OpenModelica/OMSens/archive/v${OMSensPV}.tar.gz -> OMSens-${OMSensPV}.tar.gz
#		"
#	S=${WORKDIR}/OpenModelica-${PV}
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="A Modelica modeling, compilation and simulation environment."
HOMEPAGE="https://openmodelica.org/"

LICENSE="OMPL"
SLOT="0"
IUSE="+editor doc threads clang"

# Don't compile with lapack-3.8
DEPEND="sys-apps/sed
	sys-apps/coreutils
	sys-apps/findutils
	app-arch/tar
	dev-libs/libffi
	sys-apps/hwloc
	sci-libs/hdf5
	sci-mathematics/lpsolve
	|| ( dev-games/openscenegraph dev-games/openscenegraph-openmw )
	threads? ( dev-libs/boost )
	|| ( sci-libs/openblas ( sci-libs/lapack-reference sci-libs/blas-reference ) )
	dev-qt/qtwebengine:5
"
#	dev-qt/qtwebkit

RDEPEND="=dev-java/antlr-2*
	sys-libs/readline
	dev-libs/libf2c
	|| ( sci-libs/metis sci-libs/parmetis )
	editor? ( || ( net-misc/omniORB net-misc/mico )
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		>=virtual/jre-1.5 )"

RESTRICT="network-sandbox nostrip"

PATCHES=(
	"${FILESDIR}/openmodelica-1.19.0-fmil-zlib.patch"
#	"${FILESDIR}/FCFlags.patch"
#	"${FILESDIR}/antlr4.patch"
#	"${FILESDIR}/openmodelica-1.17.0-emoth-release.patch"
#	"${FILESDIR}/openmodelica-1.17.0-cmake-3.20.patch"
)

#S="${WORKDIR}/${PN}"

pkg_setup() {
#	export RMLHOME="${ROOT}usr"
#	export ANTLRHOME="${ROOT}usr"
#	export CLASSPATH="${ROOT}usr/share/antlr/lib/antlr.jar"

	# This package is very sensitive to parallelisation of the build process. Do not
	# do it and you will be safe.
	MAKEOPTS="${MAKEOPTS} -j1"
}

src_unpack() {
	git-r3_fetch ${EGIT_REPO_URI} ${REFS} ${TAG}
	git-r3_checkout ${EGIT_REPO_URI} "${WORKDIR}/${P}" ${TAG}
}

src_prepare() {
	default

	# FIXME! Dirty patch
#	sed -i -e "s:assert(tmp);:/* assert(tmp); */:g" OMCompiler/Compiler/runtime/settingsimpl.c

	export QMAKE=qmake5; \
	eautoreconf

	cd libraries
	make
}

src_configure_() {
	local mycmakeargs=(
		-DOM_OMEDIT_ENABLE_QTWEBENGINE=ON
#		-DFMILIB_BUILD_STATIC_LIB=ON
#		-DFMILIB_BUILD_SHARED_LIB=OFF
		-DOM_OMC_USE_CORBA=ON
		-DOM_OMC_USE_LAPACK=ON
		-DOM_ENABLE_GUI_CLIENTS=ON
		-DOM_ENABLE_ENCRYPTION=OFF
		-DOM_OMC_ENABLE_CPP_RUNTIME=ON
		-DOM_OMC_ENABLE_FORTRAN=ON
		-DOM_OMC_ENABLE_IPOPT=ON
		-DOM_OMEDIT_INSTALL_RUNTIME_DLLS=ON
		-DOM_OMEDIT_ENABLE_TESTS=OFF
		-DOM_OMSHELL_ENABLE_TERMINAL=ON
	)

#		-DENABLE_IMAGE_PNG=$(usex png)
#		-DENABLE_XINERAMA=$(usex xinerama)
#		-DENABLE_XFT=$(usex truetype)
#		-DENABLE_IMAGE_XPM=$(usex xpm)
#		-DENABLE_PANGO=$(usex pango)


	# CMAKE_BUILD_TYPE=$(usex debug Debug)

	cmake_src_configure
}

src_configure() {
	strip-flags

	append-ldflags -Wno-dev
	append-ldflags $(no-as-needed)
	append-cppflags -I/usr/lib64/libffi/include
	append-cflags -ffloat-store
	filter-flags -march=native
	append-cflags -DOM_OMEDIT_ENABLE_QTWEBENGINE:BOOL=ON
	append-cflags -DOM_OMEDIT_ENABLE_QTWEBENGINE

	## https://github.com/OpenModelica/OpenModelica/issues/7619
	## https://github.com/graphstream/gs-netstream/issues/8
	append-cxxflags -std=c++17

#	export FFLAGS=""
#	export FCFLAGS=""
	
	# Only omniORB for me
#	local myconf=(
#		--with-openmodelicahome="${S}"/build
#		--with-omc="${S}"/build/bin/omc
#		$(use_with editor omniORB)
#		)

	local myconf=( --without-omc )
	myconf+=( $(use_with editor omniORB) )

	use clang && myconf+=( CC=clang CXX=clang++ GNUCXX=g++ )

#		--disable-modelica3d
#		--with-ombuilddir="${S}"/build
#		--with-openmodelicahome="${S}"/build
#		--disable-modelica3d
#		--with-omlibrary=all
#		$(use_with metis METIS)
	myconf+=( --with-omlibrary=all )
	myconf+=( $(use_with threads cppruntime) )
	# myconf+=( --without-cppruntime )

	# for me only reference lapack work
	# myconf+=( --with-lapack="`pkg-config --libs lapack` `pkg-config --libs blas`" )
	myconf+=( --with-lapack=auto )
	
#	myconf+=( --with-omlibrary=no --libdir=/usr/lib )
	myconf+=( --with-omc=no --libdir=/usr/lib )

#	LDFLAGS="-L${S}/build/lib/x86_64-linux-gnu/omc" \
#	    OPENMODELICAHOME="${S}"/build \
#	    econf "${myconf[@]}"
	# LDFLAGS="" econf "${myconf[@]}"
	export QMAKE=qmake5; \
	./configure "${myconf[@]}"

	#LDFLAGS="-L${S}/build/lib/x86_64-linux-gnu/omc" \
	#    OPENMODELICAHOME=/usr \
	#    econf "${myconf[@]}"


	# Correct the documentation installation directory: the package does not
	# give a 'make doc' alternative, so we simply install it into a folder that
	# will be discarded if documentation is not desired.
#	if use doc ; then
#		sed -i -r "s|^(INSTALL_DOCDIR.*)/omc/doc|\1/doc/${P}|" "${S}/Makefile"
#		sed -i -r "s|^(INSTALL_DOCDIR.*)/omc/testmodels|\1/doc/${P}/testmodels|" "${S}/Makefile"
#	else
#		sed -i -r "s|^(INSTALL_DOCDIR).*/omc/doc|\1 = ${T}/rubbish|" "${S}/Makefile"
#		sed -i -r "s|^(INSTALL_DOCDIR).*/omc/testmodels|\1 = ${T}/rubbish|" "${S}/Makefile"
#	fi

#	emake || die "Build of the OpenModelica Compiler failed."

#	if use corba ; then
#		cd "${S}/OMShell"
#		qmake OMShell.pro || die "QMake could not be run on OMShell.pro."
#		emake || die "Build of the OpenModelica GUI Shell failed."
#	else
#		ewarn "You deactivated CORBA support for OpenModelica. This means also"
#		ewarn "that the Qt-based GUI will not be built."
#	fi
}

src_compile_() {
	emake -j1
	emake -j1 omlibrary
}

src_install() {
	default
	# sed -i -r "s#^((lib|data)dir\s*=)\s*/usr(.*)#\1 \${prefix}\3#" Makefile

	emake DESTDIR="${D}" install
	einstalldocs

	dodir /usr
	cp -R ${S}/build/* ${D}/usr
	
	#dobin "${S}/OMShell/OMShell"
	# Yes, it looks stupid to put data files in /bin, but that's where
	# OpenModelica expects them to be.
	#dobin "${S}/OMNotebook/OMNotebookQT4/commands.xml"
	#dobin "${S}/OMNotebook/OMNotebookQT4/modelicacolors.xml"
	#dobin "${S}/OMNotebook/OMNotebookQT4/stylesheet.xml"

	#dodoc "${S}/build/bin/ptplot\ copyright.txt"
	#dodoc "${S}/OSMC-License.txt"

	# Untar the Modelica standard library and set permissions
	#LIBRARYDIR="${D}/usr/share/${PN}"
	#mkdir ${LIBRARYDIR}
	#cd ${LIBRARYDIR}
	#tar xzf "${S}/Compiler/VC7/Setup/zips/ModelicaLib.tar.gz"
	#for DIR in $( find ${LIBRARYDIR} -type d )
	#do
	#	chmod 755 ${DIR}
	#done
	#for FILE in $( find ${LIBRARYDIR} -type f )
	#do
	#	chmod 644 ${FILE}
	#done

	# Build environment variables
	# echo "OPENMODELICAHOME=${ROOT}usr" > "${T}/99OpenModelica"
	# echo "OPENMODELICALIBRARY=${ROOT}usr/$(get_libdir)/omlibrary" >> "${T}/99OpenModelica"
	# echo "LDPATH=${ROOT}/usr/lib/x86_64-linux-gnu/omc" >> "${T}/99OpenModelica"
	# doenvd "${T}/99OpenModelica"
	
	# Do some spring cleaining: some files must be removed.
	#cd "${D}/usr"
	# Note that lib/ could be lib64/ or lib32/.
	#rm -f lib*/libQt*.a lib*/libf2c*
	# This has been dodoc'ed above.
	#rm -f bin/ptplot\ copyright.txt
	# Remove files that are not useful in UNIX.
	#rm -f bin/Compile.* bin/doPlot.* bin/omc_*
	# Remove one header that belongs to another package.
	#rm -f include/f2c.h

	# Adjust some permissions
	#chmod 755 "${D}/usr/bin/Compile"
	#chmod 755 "${D}/usr/bin/doPlot"
	# ... And fix some line endings
	#sed -i -e "s|\r$||g" "${D}/usr/bin/Compile"
	#sed -i -e "s|\r$||g" "${D}/usr/bin/doPlot"

	rm ${D}/usr/bin/*.so

	mv ${D}/usr/share/doc/omc/* ${D}/usr/share/doc/${P}
	
	doicon ${WORKDIR}/${P}/OMEdit/OMEditLIB/Resources/icons/omedit.ico
	make_desktop_entry OMEdit OMEdit omedit 
	#OMNotebook OMPlot OMShell OMShell-terminal OMSimulator 
	
	# FIXME! Dirty hack
	rm -r ${D}/var/tmp
}

pkg_postinst_() {
	if use corba ; then
		ewarn "Remember to run 'source /etc/profile' as a user before starting the"
		ewarn "graphical interface OMShell, otherwise it will not be able to"
		ewarn "find the compiler and the Modelica standard library."
		ewarn
		ewarn "Note that OMShell generates a number of garbage files (C++ files,"
		ewarn "result listings, executables) in the folder it is run from. You"
		ewarn "should run OMShell from a sandbox folder."
	fi
}

