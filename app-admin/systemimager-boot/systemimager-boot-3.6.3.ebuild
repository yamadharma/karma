# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

IUSE="${IUSE}"

MY_P="systemimager-${PV}"
S=${WORKDIR}/${MY_P}

MKLIBS_VERSION=0.1.20

BC_VERSION=1.06
CTCS_VERSION=1.3.0pre4
DISCOVER_DATA_VERSION=1.2005.11.25
DISCOVER_VERSION=1.7.15ubuntu1
#DISCOVER_PATCH_VERSION=2
DOSFSTOOLS_VERSION=2.8
E2FSPROGS_VERSION=1.38
GZIP_VERSION=1.3.5
HFSUTILS_VERSION=3.2.6
JFSUTILS_VERSION=1.1.7
DEVMAPPER_VERSION=1.01.02
LVM_VERSION=2.2.00.32
OPENSSH_VERSION=3.9p1
OPENSSL_VERSION=0.9.7e
PARTED_VERSION=1.6.25.1
PDISK_VERSION=20000516
RPM_VERSION=4.2
RPM_SRPM_VERSION=${RPM_VERSION}-1
RAIDTOOLS_VERSION=1.00.3
REISERFSPROGS_VERSION=3.6.19
TAR_VERSION=1.13.25
UTIL_LINUX_VERSION=2.12r
XFSPROGS_VERSION=2.7.3
ZLIB_VERSION=1.2.3

MODULE_INIT_TOOLS_VERSION="3.2.1"

case $ARCH in
    x86) 
    LINUX_VERSION=2.6.12.2
    ;;
    amd64)
    LINUX_VERSION=2.6.12.2
    ;;
esac    

DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2
	mirror://debian/pool/main/m/mklibs/mklibs_${MKLIBS_VERSION}.tar.gz
	http://download.systemimager.org/pub/bc/bc-${BC_VERSION}.tar.gz
	mirror://sourceforge/va-ctcs/ctcs-${CTCS_VERSION}.tar.gz
	http://download.systemimager.org/pub/discover/discover1-data_${DISCOVER_DATA_VERSION}.tar.gz
	http://download.systemimager.org/pub/dosfstools/dosfstools-${DOSFSTOOLS_VERSION}.src.tar.gz
	http://download.systemimager.org/pub/e2fsprogs/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz
	http://download.systemimager.org/pub/gzip/gzip-${GZIP_VERSION}.tar.gz
	http://download.systemimager.org/pub/hfsutils/hfsutils-${HFSUTILS_VERSION}.tar.gz
	http://download.systemimager.org/pub/jfsutils/jfsutils-${JFSUTILS_VERSION}.tar.gz
	http://download.systemimager.org/pub/device-mapper/device-mapper.${DEVMAPPER_VERSION}.tgz
	http://download.systemimager.org/pub/lvm/LVM${LVM_VERSION}.tgz
	http://download.systemimager.org/pub/openssh/openssh-${OPENSSH_VERSION}.tar.gz
	http://download.systemimager.org/pub/openssl/openssl-${OPENSSL_VERSION}.tar.gz
	http://download.systemimager.org/pub/parted/parted-${PARTED_VERSION}.tar.gz
	http://download.systemimager.org/pub/pdisk/pdisk.${PDISK_VERSION}.src.tar
	http://download.systemimager.org/pub/rpm/rpm-${RPM_VERSION}.tar.gz
	http://download.systemimager.org/pub/rpm/rpm-${RPM_SRPM_VERSION}.src.rpm
	http://download.systemimager.org/pub/raidtools/raidtools-${RAIDTOOLS_VERSION}.tar.gz
	http://download.systemimager.org/pub/reiserfsprogs/reiserfsprogs-${REISERFSPROGS_VERSION}.tar.gz
	http://download.systemimager.org/pub/tar/tar_${TAR_VERSION}.orig.tar.gz
	http://download.systemimager.org/pub/util-linux/util-linux-${UTIL_LINUX_VERSION}.tar.bz2
	http://download.systemimager.org/pub/xfsprogs/xfsprogs-${XFSPROGS_VERSION}.src.tar.gz
	ftp://oss.sgi.com/projects/xfs/download/cmd_tars/xfsprogs-${XFSPROGS_VERSION}.src.tar.gz
	http://download.systemimager.org/pub/zlib/zlib-${ZLIB_VERSION}.tar.gz
	http://download.systemimager.org/pub/module-init-tools/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/linux/linux-${LINUX_VERSION}.tar.bz2"

#	http://download.systemimager.org/pub/discover/discover_${DISCOVER_VERSION}-${DISCOVER_PATCH_VERSION}.tar.gz

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"

#SANDBOX_DISABLED="1"
FEATURES="${FEATURES} -ccache -distcc"


MAKEOPTS="${MAKEOPTS} -j1"

boot_flavor=standard

src_unpack ()
{
        unpack ${MY_P}.tar.bz2
        unpack mklibs_${MKLIBS_VERSION}.tar.gz

	mkdir -p ${S}/initrd_source/src
	mkdir -p ${S}/src
	
	cp ${DISTDIR}/bc-${BC_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/ctcs-${CTCS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/discover1-data_${DISCOVER_DATA_VERSION}.tar.gz ${S}/src
#	cp ${DISTDIR}/discover_${DISCOVER_VERSION}-${DISCOVER_PATCH_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/dosfstools-${DOSFSTOOLS_VERSION}.src.tar.gz ${S}/src
	cp ${DISTDIR}/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/gzip-${GZIP_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/hfsutils-${HFSUTILS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/jfsutils-${JFSUTILS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/device-mapper.${DEVMAPPER_VERSION}.tgz ${S}/src
	cp ${DISTDIR}/LVM${LVM_VERSION}.tgz ${S}/src
	cp ${DISTDIR}/openssh-${OPENSSH_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/openssl-${OPENSSL_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/parted-${PARTED_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/pdisk.${PDISK_VERSION}.src.tar ${S}/src
	cp ${DISTDIR}/rpm-${RPM_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/rpm-${RPM_SRPM_VERSION}.src.rpm ${S}/src
	cp ${DISTDIR}/raidtools-${RAIDTOOLS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/reiserfsprogs-${REISERFSPROGS_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/tar_${TAR_VERSION}.orig.tar.gz ${S}/src
	cp ${DISTDIR}/util-linux-${UTIL_LINUX_VERSION}.tar.bz2 ${S}/src
	cp ${DISTDIR}/xfsprogs-${XFSPROGS_VERSION}.src.tar.gz ${S}/src
	cp ${DISTDIR}/zlib-${ZLIB_VERSION}.tar.gz ${S}/src
	cp ${DISTDIR}/linux-${LINUX_VERSION}.tar.bz2 ${S}/src
	
	cp ${DISTDIR}/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2 ${S}/initrd_source/src
	
	sed -ie "s:mklibs -L:mklibs -L $(gcc-config -L) -L:" ${S}/Makefile
	
}

src_compile () 
{
#	unset CFLAGS
	
	filter-flags -fstack-protector
	filter-flags -fPIC

	replace-flags -O[2-9] -O1
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

# MKLIBS compile
	cd ${WORKDIR}/mklibs-${MKLIBS_VERSION}
	econf || die "mklibs configuration error"
	emake || die "mklibs compilation error"
	
	cd ${S}/initrd_source
	ln -sf ${WORKDIR}/mklibs-${MKLIBS_VERSION}/src/mklibs-copy.py mklibs

#    emake kernel || die "Kernel compiling error"
#    make kernel || die "Kernel compiling error"
#    make -f ${S}/initrd_source/initrd.rul INITRD_DIR=${S}/initrd_source || die "Initrd.img compiling error"
#    make boel_binaries_tarball || die "BOEL tarball compiling error"
#    make -i binaries || die "Compiling error"

#    make binaries || die "Compiling error"    

	cd ${S}
#	export CC=/usr/bin/gcc
#	export CXX=/usr/bin/g++ 
	econf || die "Config error"    
#	./configure || die "Config error"    
#	make kernel || die "Compiling error"    	
#	make
	emake ${MAKEOPTS} \
	    kernel \
    	    initrd \
	    boel_binaries_tarball \
	    || die "Compiling error"    
}

src_install () 
{
#	einstall DESTDIR=${D} install_binaries || die "Installing error"
	einstall DESTDIR=${D} \
	    install_kernel \
	    install_initrd \
	    install_boel_binaries_tarball \
	    || die "Installing error"
}

