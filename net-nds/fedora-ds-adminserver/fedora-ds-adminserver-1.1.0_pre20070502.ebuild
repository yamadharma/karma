# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_AUTH="pserver"
ECVS_SERVER="cvs.fedora.redhat.com:/cvs/dirsec"
ECVS_MODULE="adminserver"
#ECVS_BRANCH=""
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"
ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/fedora-ds"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Fedora DS LDAP adminutils"
HOMEPAGE="http://directory.fedora.redhat.com/"
#SRC_URI="http://directory.fedora.redhat.com/sources/fedora-setuputil-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lib/mozldap
	dev-libs/nspr
	dev-libs/nss
	dev-libs/svrcore
	dev-libs/icu
	dev-libs/cyrus-sasl
	dev-libs/openssl"

RDEPEND="${DEPEND}"

#S="${WORKDIR}/fedora-setuputil-${PV}"

src_compile() {
	
	make \
		BUILD_DEBUG=optimize \
		LDAPSDK_INCDIR="/usr/include/mozldap" \
		NSPR_INCDIR="/usr/include" \
		ICU_BUILD_DIR="/usr" \
		SECURITY_INCDIR="/usr/include" \
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
