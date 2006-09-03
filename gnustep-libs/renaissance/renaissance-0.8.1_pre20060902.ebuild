# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

IUSE=""

ESVN_PROJECT=renaissance

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/${ESVN_PROJECT}/trunk"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/svn.gna.org/gnustep/libs"

S=${WORKDIR}/${ESVN_PROJECT}

DESCRIPTION="GNUstep Renaissance allows you to describe your user interfaces in simple and intuitive XML files."
HOMEPAGE="http://www.gnustep.it/Renaissance/index.html"

KEYWORDS="x86 amd64"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="${IUSE} doc"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

src_install() {
	cd ${S}
	egnustep_env
	egnustep_install || die
	if [ `use doc` ]; then
		egnustep_env
		cd Documentation
		egnustep_make
		egnustep_install
		mkdir -p ${TMP}/tmpdocs
		mv ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Documentation/* ${TMP}/tmpdocs
		mkdir -p ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Documentation/Developer/Renaissance
		mv ${TMP}/tmpdocs/* ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Documentation/Developer/Renaissance
		cd ..
	fi
	egnustep_package_config
}

