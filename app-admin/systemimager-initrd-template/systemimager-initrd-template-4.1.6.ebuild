# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

IUSE="${IUSE} doc"

MY_P="systemimager-${PV}"
S=${WORKDIR}/${MY_P}

source ${FILESDIR}/add-${PV}
case $ARCH in
    x86) 
    LINUX_VERSION=${LINUX_VERSION_x86}
    ;;
    amd64)
    LINUX_VERSION=${LINUX_VERSION_amd64}
    ;;
esac


DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2
	http://download.systemimager.org/pub/busybox/busybox-${BUSYBOX_VERSION}.tar.bz2
	http://download.systemimager.org/pub/dhcp/dhcp-${DHCLIENT_VERSION}.tar.gz


	http://download.systemimager.org/pub/module-init-tools/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/rsync/rsync-${RSYNC_VERSION}.tar.gz
	http://download.systemimager.org/pub/uclibc/uClibc-${UCLIBC_VERSION}.tar.bz2
	http://download.systemimager.org/pub/udpcast/udpcast-${UDPCAST_VERSION}.tar.gz

	http://download.systemimager.org/pub/coreutils/coreutils-${COREUTILS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/cx-freeze/cx_Freeze-${CX_FREEZE_VERSION}-source.tgz

	http://download.systemimager.org/pub/hotplug/hotplug_${HOTPLUG_VERSION}.orig.tar.gz
	http://download.systemimager.org/pub/hotplug/hotplug_${HOTPLUG_VERSION}-${HOTPLUG_DIFF_VERSION}.diff.gz

	http://download.systemimager.org/pub/lsb/lsb_${LSB_VERSION}-${LSB_DIFF_VERSION}.tar.gz

	http://download.systemimager.org/pub/sysvinit/sysvinit_${SYSVINIT_VERSION}.orig.tar.gz
	http://download.systemimager.org/pub/sysvinit/sysvinit_${SYSVINIT_VERSION}-${SYSVINIT_DIFF_VERSION}.diff.gz

	http://download.systemimager.org/pub/udev/udev_${UDEV_VERSION}.orig.tar.gz
	http://download.systemimager.org/pub/udev/udev_${UDEV_VERSION}-${UDEV_DIFF_VERSION}.diff.gz

	http://download.systemimager.org/pub/util-linux/util-linux-${UTIL_LINUX_VERSION}.tar.bz2

	http://download.systemimager.org/pub/linux/linux-${LINUX_VERSION}.tar.bz2"


SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

src_unpack () 
{
	unpack ${MY_P}.tar.bz2
	mkdir -p ${S}/initrd_source/src
	mkdir -p ${S}/src
	
	cp ${DISTDIR}/busybox-${BUSYBOX_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/dhcp-${DHCLIENT_VERSION}.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/rsync-${RSYNC_VERSION}.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/uClibc-${UCLIBC_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/udpcast-${UDPCAST_VERSION}.tar.gz ${S}/initrd_source/src

	cp ${DISTDIR}/coreutils-${COREUTILS_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/cx_Freeze-${CX_FREEZE_VERSION}-source.tgz ${S}/initrd_source/src

	cp ${DISTDIR}/hotplug_${HOTPLUG_VERSION}.orig.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/hotplug_${HOTPLUG_VERSION}-${HOTPLUG_DIFF_VERSION}.diff.gz ${S}/initrd_source/src

	cp ${DISTDIR}/lsb_${LSB_VERSION}-${LSB_DIFF_VERSION}.tar.gz ${S}/initrd_source/src

	cp ${DISTDIR}/sysvinit_${SYSVINIT_VERSION}.orig.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/sysvinit_${SYSVINIT_VERSION}-${SYSVINIT_DIFF_VERSION}.diff.gz ${S}/initrd_source/src
	
	cp ${DISTDIR}/udev_${UDEV_VERSION}.orig.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/udev_${UDEV_VERSION}-${UDEV_DIFF_VERSION}.diff.gz ${S}/initrd_source/src

	cp ${DISTDIR}/util-linux-${UTIL_LINUX_VERSION}.tar.bz2 ${S}/src

	cp ${DISTDIR}/linux-${LINUX_VERSION}.tar.bz2 ${S}/src
	
	# Some dirty hacks
#	sed -i -e "s:${OLD_COREUTILS_VERSION}:${COREUTILS_VERSION}:g" ${S}/initrd_source/make.d/coreutils.rul
#	sed -i -e "s:${OLD_UDEV_VERSION}:${UDEV_VERSION}:g" ${S}/initrd_source/make.d/udev.rul
}

src_compile () 
{
	unset CFLAGS
	unset CXXFLAGS
	unset LDFLAGS
	
	filter-flags -march
	filter-flags -O
	
        econf || die "Config error"    
	emake build_dir
#	emake manpages
}

src_install () 
{
        make install DESTDIR=${D} install_initrd_template install_dev_tarball 
    
#	newinitd ${FILESDIR}/systemimager-server-flamethrowerd.initd systemimager-server-flamethrowerd
#	newinitd ${FILESDIR}/systemimager-server-netbootmond.initd systemimager-server-netbootmond
#	newinitd ${FILESDIR}/systemimager-server-rsyncd.initd systemimager-server-rsyncd
#	newinitd ${FILESDIR}/systemimager-server-monitord.initd  systemimager-server-monitord
#	
#	keepdir -r /var
#	    
#	dodoc README* RELEASE* CHANGE.LOG COPYING CREDITS DEVELOPER_GUIDELINES ERRATA
}

