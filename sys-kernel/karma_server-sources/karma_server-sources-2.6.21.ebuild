# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

EXTRAVERSION="-karma-server${EXTRAREVISION}"
S=${WORKDIR}/linux-${KV}

DESCRIPTION="KLK Sources with Xen."

KARMA_PATCH="karma-server-${PV}${EXTRAREVISION}.tar.bz2"
KARMA_PATCH_URI="mirror://gentoo/${KARMA_PATCH}"

xen_hv_version=3.1.0-rc7
xen_hv_cset=7041b52471c3
XEN_SRC="xen-${xen_hv_version}-${xen_hv_cset}.tar.bz2"
XEN_SRC_URI="mirror://gentoo/${XEN_SRC}"

UNIPATCH_LIST="${DISTDIR}/${KARMA_PATCH}"
UNIPATCH_STRICTORDER="yes"

SRC_URI="${KERNEL_URI} ${KARMA_PATCH_URI}"

KEYWORDS="x86 amd64"

# Local Variables:
# mode: sh
# End:
