# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Fedora DS LDAP setuputil"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedora.redhat.com/sources/fedora-setuputil-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lib/mozldap"

RDEPEND="${DEPEND}"

S="${WORKDIR}/fedora-setuputil-${PV}"

src_compile() {
	einfo "Building setuputil..."

	# you may need to do this....
	#ln -s /lib/libtermcap.so.2 /lib/libtermcap.so

#emake -j1 PROJECT_LIBDEPS="" REQUIRED_LIBDEPS="" LOCAL_LIBDEPS="" OPTIMISE_CXXFLAGS="${CXXFLAGS}" OPTIMISE_CCFLAGS="${CFLAGS}" CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die

	#
	# Fedora-setuputil
	#
	einfo "Building setuputil..."

	make \
		BUILD_DEBUG=optimize \
		LDAPSDK_INCDIR="/usr/include/mozldap" \
		LDAP_LIBPATH="/usr/lib" \
		NSPR_INCDIR="/usr/include" \
		ICU_BUILD_DIR="/usr" \
		SECURITY_INCDIR="/usr/include" \
		|| die "make setuputil failed"

}

src_install() {
	local DIST="${S}/built/package/Linux2.6_x86_glibc_PTH_OPT.OBJ"

	# create directories
#	dodir /usr/fedora-ds/bin
	dodir /usr/include/fedora-ds
	dodir /usr/lib/fedora-ds

	# docs (these docs are bogus)
	#dodoc ${DIST}/*txt
	rm -f ${DIST}/*txt
	dodoc ${S}/LICENSE

	# binaries
	exeinto /usr/bin/fedora-ds
	doexe ${DIST}/bin/*

	# headers
	insinto /usr/include/fedora-ds
	doins -r ${DIST}/include/*

	# libs
	insinto /usr/lib/fedora-ds
	doins ${DIST}/lib/*
}