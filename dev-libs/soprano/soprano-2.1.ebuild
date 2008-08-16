# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils eutils flag-o-matic

DESCRIPTION="Soprano is a library which provides a nice QT interface to RDF storage solutions."
HOMEPAGE="http://sourceforge.net/projects/soprano"
SRC_URI="mirror://sourceforge/soprano/soprano-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+clucene debug doc elibc_FreeBSD"

COMMON_DEPEND="
	>=dev-libs/rasqal-0.9.15
	>=dev-libs/redland-1.0.6
	>=media-libs/raptor-1.4.16
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	clucene? ( >=dev-cpp/clucene-0.9.19 )"
DEPEND="${COMMON_DEPEND}
doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}"

#pkg_setup() {
#	echo
#	ewarn "WARNING! This is an experimental ebuild of ${PN} SVN tree. Use at your own risk."
#	ewarn "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
#
#}

src_compile() {
	# Fix automagic dependencies / linking
	if ! use clucene; then
		sed -e '/find_package(CLucene)/s/^/#DONOTFIND /' \
			-i "${S}/CMakeLists.txt" || die "Sed for CLucene automagic dependency failed."
	fi

	if ! use doc; then
		sed -e '/find_package(Doxygen)/s/^/#DONOTFIND /' \
			-i "${S}/CMakeLists.txt" || die "Sed to disable api-docs failed."
	fi

	if ! use java; then
		sed -e '/find_package(JNI)/s/^/#DONOTFIND /' \
		-i "${S}/CMakeLists.txt" || die "Sed for Java JNI automagic dependency failed."
	fi

	sed -e '/add_subdirectory(test)/s/^/#DONOTCOMPILE /' \
		-e '/enable_testing/s/^/#DONOTENABLE /' \
		-i "${S}"/CMakeLists.txt || die "Disabling of ${PN} tests failed."
	einfo "Disabled building of ${PN} tests."

	# Fix for missing pthread.h linking
	# NOTE: temporarely fix until a better cmake files patch will be provided.
	use elibc_FreeBSD && append-ldflags "-lpthread"

	cmake-utils_src_compile
}

src_test() {
	sed -e 's/#NOTESTS//' \
		-i "${S}"/CMakeLists.txt || die "Enabling tests failed."
	cmake-utils_src_compile
	ctest --extra-verbose || die "Tests failed."
}
