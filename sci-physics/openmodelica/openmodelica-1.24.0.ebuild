# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit cmake desktop xdg fortran-2

DESCRIPTION="Open-source Modelica-based modeling and simulation environment"
HOMEPAGE="https://openmodelica.org/"
SRC_URI="
	https://github.com/OpenModelica/OpenModelica/archive/904c4c783a5fa6eb9e99e4a98bdb0cca1d619303.tar.gz
		-> ${P}.tar.gz
	https://github.com/OpenModelica/OMCompiler-3rdParty/archive/82e892ece107787e9ff17780bf5ac8c3f6bc39ba.tar.gz
		-> OMCompiler-3rdParty_${P}.tar.gz
	https://github.com/OpenModelica/OMBootstrapping/archive/c289e97c41d00939a4a69fe504961b47283a6d8e.tar.gz
		-> OMBootstrapping_${P}.tar.gz
	https://github.com/OpenModelica/OMSens/archive/0d804d597bc385686856d453cc830fad4923fa3e.tar.gz
		-> OMSens_${P}.tar.gz
	https://github.com/OpenModelica/OMSens_Qt/archive/92090770426271b4193e78b04f13e6a3abcd6f1a.tar.gz
		-> OMSens_Qt_${P}.tar.gz
	https://github.com/OpenModelica/OMSimulator/archive/ce342b60b3675185b7daf8197f4b7fd3227f694f.tar.gz
		-> OMSimulator_${P}.tar.gz
	https://github.com/OpenModelica/OMSimulator-3rdParty/archive/5c10de1648d1134a577d9284b58580a72383d89f.tar.gz
		-> OMSimulator-3rdParty_${P}.tar.gz
	https://github.com/OpenModelica/OMOptim/archive/f1036f43db18c5015da259771004cfb80e08a110.tar.gz
		-> OMOptim_${P}.tar.gz
	https://github.com/OpenModelica/OpenModelica-common/archive/08a01802db5ba5edb540383c46718b89ff229ef2.tar.gz
		-> OpenModelica-common_${P}.tar.gz

"

LICENSE="OSMC-PL GPL-3 AGPL-3 BSD EPL-1.0 public-domain BSD-with-attribution LGPL-2.1+ LGPL-2 Apache-2.0 Boost-1.0 Modelica-1.1 Modelica-2 MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-text/asciidoc-10.2.0
	>=app-text/doxygen-1.9.8
	>=dev-libs/boost-1.85.0
	>=dev-games/openscenegraph-3.6.5-r114
	dev-lang/python:3.12
	>=dev-libs/expat-2.5.0
	dev-libs/icu:0
	>=dev-libs/libxml2-2.12.7
	>=dev-python/kiwisolver-1.3.2
	>=dev-python/matplotlib-3.3
	>=dev-python/numpy-1.26.4
	>=dev-python/pandas-1.1.3
	>=dev-python/pillow-9.0.1
	>=dev-python/pytest-8.2.2
	>=dev-python/six-1.16.0-r1
	>=dev-python/sphinx-7.3.7-r2
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtpositioning:5[qml]
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtwebchannel:5[qml]
	>=net-misc/curl-8.7.1-r4
	>=net-misc/omniORB-4.3.0
	>=sci-libs/hdf5-1.14.3-r1
	>=sys-apps/hwloc-2.9.2
	>=sys-devel/flex-2.6.4-r6
	>=sys-libs/ncurses-6.4_p20240414
	>=sys-libs/readline-8.2_p10
	>=virtual/blas-3.8
	>=virtual/jdk-17
	>=virtual/lapack-3.10
	>=virtual/libiconv-0-r2
	>=virtual/libintl-0-r2
	>=virtual/opencl-3-r3
	>=virtual/opengl-7.0-r2
	>=virtual/pkgconfig-3
"

BDEPEND="
	dev-util/ccache
	>=media-gfx/imagemagick-7.1.1.25-r1[png]
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/"${P}"-raw_strings.patch
)

src_unpack() {
	default

	mv "${WORKDIR}/OpenModelica-904c4c783a5fa6eb9e99e4a98bdb0cca1d619303" "${S}" || die
	rmdir "${S}/OMCompiler/3rdParty" || die
	mv "${WORKDIR}/OMCompiler-3rdParty-82e892ece107787e9ff17780bf5ac8c3f6bc39ba" "${S}/OMCompiler/3rdParty" || die
	rmdir "${S}/OMSens" || die

	# OMOptim depends on a working CORBA interface (which fails to compile) supplied by OmniORB.
	# For compilation trials remember setting -DOM_OMC_USE_CORBA=ON.
	#rmdir "${S}/OMOptim" || die
	#mv "${WORKDIR}/OMOptim-f1036f43db18c5015da259771004cfb80e08a110" "${S}/OMOptim" || die
	#rmdir "${S}/OMOptim/common" || die
	#cp -a "${WORKDIR}/OpenModelica-common-08a01802db5ba5edb540383c46718b89ff229ef2" "${S}/OMOptim/common" || die

	mv "${WORKDIR}/OMSens-0d804d597bc385686856d453cc830fad4923fa3e" "${S}/OMSens" || die
	rmdir "${S}/OMSens_Qt" || die
	mv "${WORKDIR}/OMSens_Qt-92090770426271b4193e78b04f13e6a3abcd6f1a" "${S}/OMSens_Qt" || die
	rmdir "${S}/OMSens_Qt/common" || die
	mv "${WORKDIR}/OpenModelica-common-08a01802db5ba5edb540383c46718b89ff229ef2" "${S}/OMSens_Qt/common" || die
	rmdir "${S}/OMSimulator" || die
	mv "${WORKDIR}/OMSimulator-ce342b60b3675185b7daf8197f4b7fd3227f694f" "${S}/OMSimulator" || die
	rmdir "${S}/OMSimulator/3rdParty" || die
	mv "${WORKDIR}/OMSimulator-3rdParty-5c10de1648d1134a577d9284b58580a72383d89f" "${S}/OMSimulator/3rdParty" || die
	mv "OMBootstrapping-c289e97c41d00939a4a69fe504961b47283a6d8e" "${S}/OMCompiler/Compiler/boot/bomc" || die
	touch "${S}/OMCompiler/Compiler/boot/bomc/sources.tar.gz" || die

	# Solve https://bugs.gentoo.org/937038
	rm -fr "${S}/OMCompiler/3rdParty/FMIL/ThirdParty/Minizip/minizip" || die
	cp -a "${S}/OMSimulator/3rdParty/fmi4c/3rdparty/minizip" \
		"${S}/OMCompiler/3rdParty/FMIL/ThirdParty/Minizip/minizip" || die
}

src_configure() {
	# [2024-10-24] Only OMEdit adapted to Qt6 (not, for example, optimization plugins)
	local mycmakeargs=(
		-DOM_OMEDIT_ENABLE_QTWEBENGINE=ON
		-DBUILD_SHARED_LIBS=OFF
		-DOM_ENABLE_ENCRYPTION=OFF
		-DOM_USE_CCACHE=ON
		-DOM_ENABLE_GUI_CLIENTS=ON
		-DOM_OMC_ENABLE_FORTRAN=ON
		-DOM_OMC_ENABLE_IPOPT=ON
		-DOM_OMC_ENABLE_CPP_RUNTIME=ON
		-DOM_OMC_USE_CORBA=OFF
		-DOM_OMC_USE_LAPACK=ON
		-DOM_OMEDIT_INSTALL_RUNTIME_DLLS=ON
		-DOM_OMEDIT_ENABLE_TESTS=OFF
		-DOM_OMEDIT_ENABLE_QTWEBENGINE=ON
		-DOM_OMEDIT_ENABLE_LIBXML2=ON
		-DOM_QT_MAJOR_VERSION=5
	)
	cmake_src_configure
}

src_compile() {
	# [2024-07-15]
	# OMSens is disabled in "${S}/CMakeLists.txt" (## omc_add_subdirectory(OMSens)) due to lack of a
	# working "${S}/OMSens/CMakeLists.txt". So, we compile it manually.
	pushd OMSens/fortran_interface > /dev/null || die
	${FC} -fPIC -c Rutf.for Rut.for Curvif.for || die
	# BUG: Undefined symbol curvif_ in
	# ${S}/OMSens/fortran_interface/curvif_simplified.cpython-312-x86_64-linux-gnu.so
	# See with nm -D or objdump -tT
	# ${S}/OMSens/fortran_interface/curvif_simplified.cpython-312-x86_64-linux-gnu.so
	# This bug causes "Vectorial Parameter Based Sensitivity Analysis" in OMSens to fail.
	f2py --verbose -c -I. Curvif.o Rutf.o Rut.o -m curvif_simplified curvif_simplified.pyf Curvif_simplified.f90 || die
	popd > /dev/null || die

	cmake_src_compile
}

src_install() {
	cmake_src_install

	# [2024-07-15]
	# OMSens is disabled in "${S}/CMakeLists.txt" (## omc_add_subdirectory(OMSens)) due to lack of a
	# working "${S}/OMSens/CMakeLists.txt". So, we install it manually.
	cp -a "${WORKDIR}"/"${P}"/OMSens "${ED}"/usr/share/ || die
	rm -fr "${ED}"/usr/share/OMSens/{old,.git,.gitignore,CMakeLists.txt,.jenkins,Jenkinsfile,Makefile.omdev.mingw,Makefile.unix} || die
	rm -fr "${ED}"/usr/share/OMSens/{README.md,setup.py,testing} || die

	newicon -s scalable OMShell/OMShell/OMShellGUI/Resources/omshell-large.svg omshell.svg
	newicon -s scalable OMNotebook/OMNotebook/OMNotebookGUI/Resources/OMNotebook_icon.svg OMNotebook.svg
	magick convert OMEdit/OMEditLIB/Resources/icons/omedit.ico[0] -thumbnail 256x256 -flatten \
		OMEdit/OMEditLIB/Resources/icons/omedit_icon.png || die
	newicon -s 256 OMEdit/OMEditLIB/Resources/icons/omedit_icon.png omedit.png

	make_desktop_entry "OMEdit %F" OMedit omedit "Physics;" "MimeType=text/x-modelica;"
	make_desktop_entry OMShell OMShell omshell "Physics;"
	make_desktop_entry "OMNotebook %f" OMNotebook OMNotebook "Physics;"

	# Fix libraries
	if [[ $(get_libdir) != "lib" ]]; then
		mv "${ED}"/usr/lib/omc/* "${ED}"/usr/$(get_libdir)/omc/ || die
		rmdir "${ED}"/usr/lib/omc/ || die
		dosym -r /usr/$(get_libdir)/omc /usr/lib/omc
	fi
	dosym -r /usr/include/omc/ParModelica /usr/include/ParModelica

	# Documentation housekeeping & QA
	mv "${ED}"/usr/share/doc/omc "${ED}"/usr/share/doc/"${PF}" || die
	rm -fr "${ED}"/usr/doc  "${ED}"/usr/share/{zmq,cmake} || die

	ewarn "Upstream has deprecated OMTLMSimulator and, therefore, it has not been installed. Use OMSimulator/SSP instead."
}
