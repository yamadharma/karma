# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-kernel/wolk-sources/wolk-sources-4.9.ebuild,v 1.2 2003/09/29 18:33:04 mholzer Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"

inherit kernel

if [ "${PR}" = "r0" ]
    then
    EXTRAREVISION=""
else
    EXTRAREVISION="-${PR}"
fi

# EXTRAVERSION=-wolk${PV}s${EXTRAREVISION}

OKV=2.4.20
WOLK_MAJOR=${PV%.*}
WOLK_MINOR=${PV#*.}
WOLK_MINOR=${WOLK_MINOR%_*}

WOLK_PRE=${PV#*_}
if [ "${WOLK_PRE}" == "${PV}" ]
    then
    WOLK_PRE=""
else
    WOLK_PRE="-${WOLK_PRE}"
fi



EXTRAVERSION=-wolk${WOLK_MAJOR}.${WOLK_MINOR}s${WOLK_PRE}${EXTRAREVISION}
BASE_VERSION=9
BASE=-wolk${WOLK_MAJOR}.${BASE_VERSION}s
KV=${OKV}${EXTRAVERSION}
S=${WORKDIR}/linux-${KV}
DESCRIPTION="Working Overloaded Linux Kernel"
SRC_URI="mirror://sourceforge/wolk/linux-${OKV}-wolk${WOLK_MAJOR}.${BASE_VERSION}-fullkernel.tar.bz2"
# WOLK_PATCHLIST="linux-${OKV}${BASE}.patch.bz2"
WOLK_PATCHLIST=""

# cheat and build it in a constant fashion

# for i in `seq ${BASE_VERSION}+1 ${WOLK_MINOR}`
#   do
#   old="$((${i}-1))"
#   new="${i}"
#   WOLK_PATCHLIST="${WOLK_PATCHLIST} linux-${OKV}-wolk${WOLK_MAJOR}.${old}s-to-${WOLK_MAJOR}.${new}s.patch.bz2"
# done

# for i in ${WOLK_PATCHLIST}
#   do
#   SRC_URI="${SRC_URI} mirror://sourceforge/wolk/${i}"
# done;

#WOLK_PATCHLIST="${WOLK_PATCHLIST} 4.10s-pre7-update.patch.bz2"
#SRC_URI="${SRC_URI} http://wolk.sourceforge.net/tmp/4.10s-pre7-update.patch.bz2"

KEYWORDS="x86"
SLOT="${KV}"
HOMEPAGE="http://wolk.sourceforge.net http://www.kernel.org"

src_unpack () 
{
    unpack linux-${OKV}-wolk${WOLK_MAJOR}.${BASE_VERSION}-fullkernel.tar.bz2
    mv linux-${OKV}-wolk${WOLK_MAJOR}.${BASE_VERSION}-fullkernel linux-${KV} || die
    cd ${WORKDIR}/linux-${KV}
    
    echo "patchlist" ${WOLK_PATCHLIST}
    for i in ${WOLK_PATCHLIST}
      do
      epatch ${DISTDIR}/${i}
#      bzcat ${DISTDIR}/${i} | patch -p1 || die
    done
}

src_install () 
{
    dodir /usr/src
    echo ">>> Copying sources..."
    dodoc ${FILESDIR}/patches.txt
    mv ${WORKDIR}/linux* ${D}/usr/src
}

pkg_postinst () 
{
    local KERNELPATH="/usr/src/linux-${OKV}-wolk${WOLK_MAJOR}.${WOLK_MINOR}s"
    einfo
    einfo   "If you use one of the NVIDIA modules below, you will need to use the"
    einfo   "supplied rmap patch in ${KERNELPATH}/userspace-patches"
    einfo   "against your nvidia kernel driver source"
    einfo   "cd NVIDIA_kernel-1.0-XXXX "
    einfo	"patch -p1 <${KERNELPATH}/userspace-patches/"
    einfo   "NVIDIA_kernel-1.0-XXXX-2.4-rmap15b.patch"
    einfo   "There are NVIDIA_kernel-1.0-3123 and 1.0-4191 patches supplied."
    einfo
}


# Local Variables:
# mode: sh
# End:
