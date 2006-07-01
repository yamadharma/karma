# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-kernel/gentoo-test-sources/gentoo-test-sources-2.6.2-r1.ebuild,v 1.1 2004/02/07 21:15:45 iggy Exp $

ETYPE="sources"

inherit kernel-2
detect_version
detect_arch

if [ "${PR}" = "r0" ]
    then
    EXTRAREVISION=""
else
    EXTRAREVISION="-${PR}"
fi

#RESTRICT="nomirror"
EXTRAVERSION="-karma${EXTRAREVISION}"
#KV="2.6.3-karma"
S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Gentoo Kernel."
SRC_URI="${KERNEL_URI}"
#UNIPATCH_LIST="${FILESDIR}/misc/${PV}${EXTRAREVISION}/karma.tar.bz2"
PATCH_LIST="${FILESDIR}/misc/${PV}${EXTRAREVISION}/karma.tar.bz2"

DEPEND="${DEPEND}
	sys-kernel/config-kernel"

	
KEYWORDS="x86 ~amd64 ~ia64 -*"
SLOT="${KV}"

K_EXTRAEINFO=""

src_unpack () 
{
	[ -z "${OKV}" ] && OKV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"

	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2
	if [ "${OKV}" != "${KV}" ]
	then
		mv linux-${OKV} linux-${KV} || die "Unable to move source tree to ${KV}."
	fi

	mkdir ${WORKDIR}/patches
	cd ${WORKDIR}/patches
	tar xjvf ${PATCH_LIST}
	
	cd ${S}
	for i in ${WORKDIR}/patches/*.patch
	    do
	    epatch ${i}
	done
	
	universal_unpack
	[ -z "${K_NOSETEXTRAVERSION}" ] && unpack_set_extraversion
	
	# Fix
	cd ${S}/arch
	ln -sf i386 x86
}

pkg_postinst () 
{
    kernel-2_pkg_postinst
    
    keepdir /var/tmp/kernel-output

    /usr/bin/config-kernel --make-koutput=/usr/src/${KV}
}

# Local Variables:
# mode: sh
# End:
