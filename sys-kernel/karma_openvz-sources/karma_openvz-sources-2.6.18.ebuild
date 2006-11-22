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

EXTRAVERSION="-karma_openvz${EXTRAREVISION}"
S=${WORKDIR}/linux-${KV}

DESCRIPTION="KLK Sources with OpenVZ support."
SRC_URI="${KERNEL_URI}"
UNIPATCH_LIST="${FILESDIR}/misc/${PV}${EXTRAREVISION}/karma-openvz.tar.bz2"
UNIPATCH_STRICTORDER="yes"

#DEPEND="${DEPEND}"
	
KEYWORDS="x86 amd64"

# Local Variables:
# mode: sh
# End:
