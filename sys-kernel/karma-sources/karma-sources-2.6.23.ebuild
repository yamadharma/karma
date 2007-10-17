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

EXTRAVERSION="-karma${EXTRAREVISION}"
S=${WORKDIR}/linux-${KV}

DESCRIPTION="KLK Sources."

KARMA_PATCH="karma-ws-${PV}${EXTRAREVISION}.tar.bz2"
KARMA_PATCH_URI="mirror://gentoo/${KARMA_PATCH}"

UNIPATCH_LIST="${DISTDIR}/${KARMA_PATCH}"
UNIPATCH_STRICTORDER="yes"

SRC_URI="${KERNEL_URI} ${KARMA_PATCH_URI}"
	
KEYWORDS="~x86 ~amd64"

# Local Variables:
# mode: sh
# End:
