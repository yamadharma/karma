# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-fs/udev/udev-023-r1.ebuild,v 1.1 2004/03/25 00:51:24 gregkh Exp $

# Note: Cannot use external libsysfs with klibc ..
USE_KLIBC="no"

inherit kmod eutils

IUSE="${IUSE} selinux evms2"

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev-FAQ"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~hppa ~amd64 ~mips"

DEPEND="virtual/glibc
	sys-apps/hotplug-base
	>=sys-fs/sysfsutils-0.4.0
	selinux? >=sys-libs/libselinux-1.8
	evms2?	>=sys-libs/device-mapper-1.00.07"

RDEPEND="${DEPEND}
	>=sys-apps/baselayout-1.8.6.12-r3"
# We need some changes for devfs type layout

PROVIDE="virtual/dev-manager"

#if use evms2
#    then
#    USE_KLIBC="yes"
#fi


pkg_setup () 
{
    [ "${USE_KLIBC}" = "yes" ] && check_KV
    return 0
}

src_unpack () 
{
    unpack ${A}
    
    cd ${S}

    # patches go here...
    # epatch ${FILESDIR}/${P}-udev_add_c-gcc295-compat.patch

    # No need to clutter the logs ...
    sed -ie '/^DEBUG/ c\DEBUG = false' Makefile
    # Do not use optimization flags from the package
    sed -ie 's|$(OPTIMIZATION)||g' Makefile

    # Make sure there is no sudden changes to udev.rules.gentoo
    # (more for my own needs than anything else ...)
    if [ "`md5sum < "${S}/etc/udev/udev.rules.gentoo"`" != \
	"1b240acdcf4cbfacf9b749b55271e26b  -" ]
	then
	echo
	eerror "udev.rules.gentoo has been updated, please validate!"
	die "udev.rules.gentoo has been updated, please validate!"
    fi

    # Setup things for klibc
    if [ "${USE_KLIBC}" = "yes" -o `use evms2` ]
	then
	ln -snf ${ROOT}/usr/src/linux ${S}/klibc/linux
	if is_koutput
	    then
	    sed -i -e "s:-I\$(KERNEL_DIR)/include:-I\$(KERNEL_DIR)/include -I${KV_OUTPUT}/include -I${KV_OUTPUT}/include2:" ${S}/klibc/MCONFIG
	    sed -i -e "s:-I\$(LINUX_INCLUDE_DIR)/include:-I\$(LINUX_INCLUDE_DIR)/include -I${KV_OUTPUT}/include -I${KV_OUTPUT}/include2:" ${S}/Makefile
	fi
    fi
}

src_compile () 
{
    local myconf=
    local extras="extras/scsi_id extras/chassis_id"
    
    
    myconf="KERNEL_DIR=${KERNEL_DIR}"

	# DBUS support?
	# disabled for now as it's currently broken.
#	if which pkg-config &>/dev/null && pkg-config dbus-1 &>/dev/null
#	then
#		myconf="USE_DBUS=true"
#	fi

    if use selinux
	then
	extras="${extras} extras/selinux"
    fi    
    

    # Device-mapper support
#    if [ `use evms2` ]
#	then
#	extras="${extras} extras/multipath-tools"
#    fi

    if [ "${USE_KLIBC}" = "yes" -o `use evms2` ]
	then
	cd ${S}/klibc
	make KERNEL_DIR=${KERNEL_DIR} || die
    fi
	
    cd ${S}
    # Do not work with emake
    make EXTRAS="${extras}" \
	udevdir="/dev/" \
	${myconf} || die
		
	if use evms2
	    then
		cd ${S}/extras/multipath-tools
		make ${myconf} || die
	fi

}

src_install () 
{
#    make install DESTDIR=${D}
    
    dobin udevinfo udevtest
    into /
    dosbin udev udevd udevsend udevstart
    dosbin extras/scsi_id/scsi_id
    dosbin extras/chassis_id/chassis_id

    if use selinux
	then
	into /
	dosbin extras/selinux/udev_selinux
    fi    
    
    # Device-mapper support
    if use evms2
	then
	into /
	dosbin extras/multipath-tools/{multipath/multipath,multipathd/multipathd,devmap_name/devmap_name}
	exeinto /etc/hotplug.d/scsi/
	doexe extras/multipath-tools/multipath/multipath.hotplug
	
	doman extras/multipath-tools/{multipath/multipath.8,devmap_name/devmap_name.8}
    fi

    exeinto /etc/udev/scripts
    doexe extras/ide-devfs.sh
    doexe extras/scsi-devfs.sh


    dodir /etc/conf.d
    dodir /etc/dev.d
    cp -R ${S}/etc/conf.d/* ${D}/etc/conf.d
    cp -R ${S}/etc/dev.d/* ${D}/etc/dev.d


    insinto /etc/udev
    newins ${FILESDIR}/udev.conf.post_024 udev.conf
#	newins etc/udev/udev.rules udev.rules.example
    # For devfs style layout
    insinto /etc/udev/rules.d/
    newins etc/udev/udev.rules.gentoo 50-udev.rules
    # Our own custom udev.permissions
    insinto /etc/udev/permissions.d/
    newins etc/udev/udev.permissions.gentoo 50-udev.permissions
#	doins ${FILESDIR}/udev.permissions
#	doins etc/udev/udev.permissions
    insinto /etc
    doins extras/scsi_id/scsi_id.config

	# DBUS support?
#	if which pkg-config &>/dev/null && pkg-config dbus-1 &>/dev/null
#	then
#		insinto /etc/dbus-1/system.d
#		doins etc/dbus-1/system.d/udev_sysbus_policy.conf
#	fi

    dodir /etc/hotplug.d/default
    dosym ../../../sbin/udevsend /etc/hotplug.d/default/udev.hotplug

    # set up the /etc/dev.d directory tree
    dodir /etc/dev.d/default
    dodir /etc/dev.d/net
    exeinto /etc/dev.d/net
    doexe etc/dev.d/net/hotplug.dev


    doman *.8
    doman extras/scsi_id/scsi_id.8
    
    dodoc COPYING ChangeLog FAQ HOWTO-udev_for_dev README TODO
    dodoc docs/{overview,udev-OLS2003.pdf,udev_vs_devfs,RFC-dev.d}

    docinto extras/scsi_id
    cd ${S}/extras/scsi_id
    dodoc README TODO ChangeLog release-notes

    docinto extras/chassis_id
    cd ${S}/extras/chassis_id
    dodoc README
}

pkg_preinst () 
{
    if [ -f "${ROOT}/etc/udev/udev.config" -a \
	! -f "${ROOT}/etc/udev/udev.rules" ]
	then
	mv -f ${ROOT}/etc/udev/udev.config ${ROOT}/etc/udev/udev.rules
    fi
}

pkg_postinst () 
{
    if [ "${ROOT}" = "/" -a -n "`pidof udevd`" ]
	then
	killall -15 udevd &>/dev/null
	sleep 1
	killall -9 udevd &>/dev/null
    fi
}

# Local Variables:
# mode: sh
# End:
