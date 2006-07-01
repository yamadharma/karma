# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

IUSE=""

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gsimageapps/trunk/Frameworks/PopplerKit"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org/gsimageapps"
ESVN_PROJECT=Frameworks

MY_PN=PopplerKit
MY_PV=${PV/0.0.0.}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="PopplerKit is a GNUstep/Cocoa framework for accessing and rendering PDF content."
HOMEPAGE="http://home.gna.org/gsimageapps/"
#SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86 ~amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	>=app-text/poppler-0.3.3"
RDEPEND="${GS_RDEPEND}
	>=app-text/poppler-0.3.3"

egnustep_install_domain "System"
