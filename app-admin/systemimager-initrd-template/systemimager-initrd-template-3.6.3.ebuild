# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="${IUSE} doc"

MY_P="systemimager-${PV}"
S=${WORKDIR}/${MY_P}

BUSYBOX_VERSION="1.01"
DEVFSD_VERSION="1.3.25"
DHCLIENT_VERSION="2.0pl5"
MODUTILS_VERSION="2.4.26"
MODULE_INIT_TOOLS_VERSION="3.2.1"
RSYNC_VERSION="2.6.6"
UCLIBC_VERSION="0.9.28"
UDPCAST_VERSION="20050217"

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
	http://download.systemimager.org/pub/busybox/busybox-${BUSYBOX_VERSION}.tar.bz2
	http://download.systemimager.org/pub/devfsd/devfsd-v${DEVFSD_VERSION}.tar.bz2
	http://download.systemimager.org/pub/dhcp/dhcp-${DHCLIENT_VERSION}.tar.gz
	http://www.kernel.org/pub/linux/utils/kernel/modutils/v2.4/modutils-${MODUTILS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/modutils/modutils-${MODUTILS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/module-init-tools/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2
	http://download.systemimager.org/pub/rsync/rsync-${RSYNC_VERSION}.tar.gz
	http://download.systemimager.org/pub/uclibc/uClibc-${UCLIBC_VERSION}.tar.bz2
	http://download.systemimager.org/pub/udpcast/udpcast-${UDPCAST_VERSION}.tar.gz
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
	cp ${DISTDIR}/devfsd-v${DEVFSD_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/dhcp-${DHCLIENT_VERSION}.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/modutils-${MODUTILS_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/module-init-tools-${MODULE_INIT_TOOLS_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/rsync-${RSYNC_VERSION}.tar.gz ${S}/initrd_source/src
	cp ${DISTDIR}/uClibc-${UCLIBC_VERSION}.tar.bz2 ${S}/initrd_source/src
	cp ${DISTDIR}/udpcast-${UDPCAST_VERSION}.tar.gz ${S}/initrd_source/src

	cp ${DISTDIR}/linux-${LINUX_VERSION}.tar.bz2 ${S}/src
}

src_compile () 
{
        econf || die "Config error"    
	emake build_dir
#	emake manpages
}

src_install () 
{
        einstall DESTDIR=${D} install_initrd_template
    
#	newinitd ${FILESDIR}/systemimager-server-flamethrowerd.initd systemimager-server-flamethrowerd
#	newinitd ${FILESDIR}/systemimager-server-netbootmond.initd systemimager-server-netbootmond
#	newinitd ${FILESDIR}/systemimager-server-rsyncd.initd systemimager-server-rsyncd
#	newinitd ${FILESDIR}/systemimager-server-monitord.initd  systemimager-server-monitord
#	
#	keepdir -r /var
#	    
#	dodoc README* RELEASE* CHANGE.LOG COPYING CREDITS DEVELOPER_GUIDELINES ERRATA
}

