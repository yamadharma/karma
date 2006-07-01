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
UNIPATCH_LIST="${FILESDIR}/misc/${PV}${EXTRAREVISION}/karma.tar.bz2"
#PATCH_LIST="${FILESDIR}/misc/${PV}${EXTRAREVISION}/karma.tar.bz2"
UNIPATCH_STRICTORDER=1

DEPEND="${DEPEND}
	sys-kernel/config-kernel"

	
KEYWORDS="x86 ~amd64 ~ia64 -*"
SLOT="${KV}"

K_EXTRAEINFO=""


pkg_postinst () 
{
    kernel-2_pkg_postinst
    
    mkdir -p /var/tmp/kernel-output

    unset ARCH
    /usr/bin/config-kernel --make-koutput=/usr/src/linux-${KV}
}

# Local Variables:
# mode: sh
# End:
