# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit cmake desktop xdg fortran-2

DESCRIPTION="Open-source Modelica-based modeling and simulation environment"
HOMEPAGE="https://openmodelica.org/"
SRC_URI="
	https://github.com/OpenModelica/OpenModelica/archive/1fcd964f50824f82fd36d536804b0d80234131c9.tar.gz
		-> ${P}.tar.gz
	https://github.com/OpenModelica/OMCompiler-3rdParty/archive/520663f5fb67950a118fb48c16a4ac456f01037d.tar.gz
		-> OMCompiler-3rdParty_${P}.tar.gz
	https://github.com/OpenModelica/OMBootstrapping/archive/91938f0acbdc6e9ba91114376e3640ca6147b579.tar.gz
		-> OMBootstrapping_${P}.tar.gz
	https://github.com/OpenModelica/OMSens/archive/093ad1134cf572ea73a9c7f834614e53ba5ea878.tar.gz
		-> OMSens_${P}.tar.gz
	https://github.com/OpenModelica/OMSens_Qt/archive/bab329ae897ce28621dc45a34cc9cc7dad1aa002.tar.gz
		-> OMSens_Qt_${P}.tar.gz
	https://github.com/OpenModelica/OMSimulator/archive/46fa40fcf72dad3513e029bfb34aebf8a4d99e10.tar.gz
		-> OMSimulator_${P}.tar.gz
	https://github.com/OpenModelica/OMSimulator-3rdParty/archive/7cfc997bbe0d2afcf519b8412a5612cbe098043d.tar.gz
		-> OMSimulator-3rdParty_${P}.tar.gz
	https://github.com/OpenModelica/OMOptim/archive/35dfa9621e6d4f2a36247dab58de4fbf956b7090.tar.gz
		-> OMOptim_${P}.tar.gz
	https://github.com/OpenModelica/OpenModelica-common/archive/6e6d4fd78c74da79ef079ee412d5325eb3b60166.tar.gz
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
	>=dev-libs/icu-74.1
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

# PATCHES=(
# 	"${FILESDIR}"/"${P}"-raw_strings.patch
# )

src_unpack() {
	default

	mv "${WORKDIR}/OpenModelica-1fcd964f50824f82fd36d536804b0d80234131c9" "${S}" || die
	rmdir "${S}/OMCompiler/3rdParty" || die
	mv "${WORKDIR}/OMCompiler-3rdParty-520663f5fb67950a118fb48c16a4ac456f01037d" "${S}/OMCompiler/3rdParty" || die
	rmdir "${S}/OMSens" || die

	# OMOptim depends on a working CORBA interface (which fails to compile) supplied by OmniORB.
	# For compilation trials remember setting -DOM_OMC_USE_CORBA=ON.
	#rmdir "${S}/OMOptim" || die
	#mv "${WORKDIR}/OMOptim-f1036f43db18c5015da259771004cfb80e08a110" "${S}/OMOptim" || die
	#rmdir "${S}/OMOptim/common" || die
	#cp -a "${WORKDIR}/OpenModelica-common-08a01802db5ba5edb540383c46718b89ff229ef2" "${S}/OMOptim/common" || die

	mv "${WORKDIR}/OMSens-093ad1134cf572ea73a9c7f834614e53ba5ea878" "${S}/OMSens" || die
	rmdir "${S}/OMSens_Qt" || die
	mv "${WORKDIR}/OMSens_Qt-bab329ae897ce28621dc45a34cc9cc7dad1aa002" "${S}/OMSens_Qt" || die
	rmdir "${S}/OMSens_Qt/common" || die
	mv "${WORKDIR}/OpenModelica-common-6e6d4fd78c74da79ef079ee412d5325eb3b60166" "${S}/OMSens_Qt/common" || die
	rmdir "${S}/OMSimulator" || die
	mv "${WORKDIR}/OMSimulator-46fa40fcf72dad3513e029bfb34aebf8a4d99e10" "${S}/OMSimulator" || die
	rmdir "${S}/OMSimulator/3rdParty" || die
	mv "${WORKDIR}/OMSimulator-3rdParty-7cfc997bbe0d2afcf519b8412a5612cbe098043d" "${S}/OMSimulator/3rdParty" || die
	mv "OMBootstrapping-91938f0acbdc6e9ba91114376e3640ca6147b579" "${S}/OMCompiler/Compiler/boot/bomc" || die
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
