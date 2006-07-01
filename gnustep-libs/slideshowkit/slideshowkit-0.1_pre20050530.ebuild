# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep cvs

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.gna.org:/cvs/gsimageapps"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"
ECVS_MODULE="gsimageapps/Frameworks/SlideShowKit"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/gna.org-gsimageapps"

S=${WORKDIR}/${ECVS_MODULE}

# MY_PN=SlideShowKit
# MY_PV=${PV/*_pre}

# S=${WORKDIR}/${MY_PN}

DESCRIPTION="Small kit to include slideshow in your application"

HOMEPAGE="http://gna.org/projects/gsimageapps"
# SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

