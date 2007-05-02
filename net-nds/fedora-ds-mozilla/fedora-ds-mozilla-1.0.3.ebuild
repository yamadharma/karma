# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit perl-module

DESCRIPTION="Fedora DS LDAP Mozilla security components"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedora.redhat.com/sources/mozilla-components-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/mozilla"

src_compile() {
	einfo "Building Mozilla components..."

	local myconf="--with-nss --with-sasl --with-svrcore --enable-clu --enable-optimize"
	local myopts="BUILD_OPT=1"

        # enable/disable appropiate 64 bit switches
        [[ "${PROFILE_ARCH}" == "amd64" ]] && myconf="${myconf} --enable-64bit"
	[[ "${PROFILE_ARCH}" == "amd64" ]] && myopts="${myopts} USE_64=1"

	# Build NSS (this will also build NSPR and DBM)
	cd ${S}/security/nss
	make ${myopts} nss_build_all || die "make nss failed"

	# Build SVRCORE
	cd ${S}/security/svrcore
	make ${myopts} || die "make svrcore failed"

	# Build LDAPSDK
	cd ${S}/directory/c-sdk
	econf ${myconf} || die "configure c-sdk failed"
	make ${myopts} HAVE_SRVCORE=1 || die "make c-sdk failed"

	# Build PerLDAP
	cd ${S}/directory/perldap
	LDAPSDKDIR=${S}/directory/c-sdk \
	LDAPSDKSSL=yes NSPRDIR=$(echo ../../dist/*.OBJ) \
		perl Makefile.PL || die "creating perldap Makefile failed"

	make || die "make perldap failed"
	# LD_RUN_PATH=/opt/fedora-ds/shared/lib
}

src_install() {
	# PERL MODULE IS NOT INSTALLED!!!

	# this is where the binaries are after the compile process
	local DIST="${S}/dist"

	### create directories
	# these directories are created to store Fedora DS-specific binaries
	#dodir "/usr/fedora-ds"
#	dodir "/usr/fedora-ds/bin"
	# standard conf
	dodir "/etc/fedora-ds"
	# libs
	dodir /usr/lib/fedora-ds
	# headers
	dodir /usr/include/fedora-ds

	### install
	# binaries (what are these .so files doing here?)
#	dobin ${DIST}/bin/*[^.so]
#	insinto "/usr/fedora-ds/bin"
	exeinto "/usr/bin/fedora-ds"	
	doexe ${DIST}/bin/*[^.so]
	doexe ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/bin/*

	# conf files
	insinto "/etc/fedora-ds"
	doins ${DIST}/etc/*

	# libs
	insinto /usr/lib
	doins ${DIST}/lib/*

	insinto /usr/lib/fedora-ds
	doins ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/lib/*

	# headers
	insinto /usr/include/fedora-ds/private/nss
	doins ${DIST}/private/nss/*

	insinto /usr/include/fedora-ds
	doins -r ${DIST}/public/*
	doins -r ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/include/*

	#cd ${DIST}/public/
	#for dir in *; do
	#	dodir /usr/include/${PN}/public/${dir}
	#	insinto /usr/include/${PN}/public/${dir}
	#	doins ${DIST}/public/${dir}/*
	#done

#	insinto /usr/include/${PN}


#	insinto /usr/include/${PN}/private
#	doins ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/include/private/*

#	dodir /usr/include/${PN}/md
#	insinto /usr/include/${PN}/md
#	doins ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/include/md/*

#	dodir /usr/include/${PN}/obsolete
#	insinto /usr/include/${PN}/obsolete
#	doins ${DIST}/Linux2.6_x86_glibc_PTH_OPT.OBJ/include/obsolete/*
}