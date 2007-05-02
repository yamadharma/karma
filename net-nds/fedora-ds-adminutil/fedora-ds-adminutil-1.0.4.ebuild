# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Fedora DS LDAP adminutils"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedora.redhat.com/sources/fedora-adminutil-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="net-nds/fedora-ds-mozilla
	>=dev-libs/icu-3.4"

RDEPEND="${DEPEND}"

S="${WORKDIR}/fedora-adminutil-${PV}"

src_compile() {
	einfo "Building adminutil..."
	
	make \
		BUILD_DEBUG=optimize \
		LDAPSDK_INCDIR="/usr/include/fedora-ds/ldap/" \
		NSPR_INCDIR="/usr/include/fedora-ds" \
		ICU_BUILD_DIR="/usr" \
		SECURITY_INCDIR="/usr/include/fedora-ds/nss/" \
		|| die "make adminutil failed"
		#SECURITY_INCDIR="/usr/include/nss/" \
}

src_install() {
	local DIST="${S}/built/adminutil/Linux2.6_x86_glibc_PTH_OPT.OBJ"

	# make directories
#	dodir /usr/include/fedora-ds
#	dodir /usr/lib/fedora-ds/adminutil-properties

	# headers
	insinto /usr/include/fedora-ds
	doins -r ${DIST}/include/adminutil-1.0/*

	# libs
	insinto /usr/lib/fedora-ds
	doins ${DIST}/lib/*

	insinto /usr/lib/fedora-ds/adminutil-properties
	doins ${DIST}/lib/adminutil-properties/*
}