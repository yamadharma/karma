# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

IUSE=""

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/${PN}/trunk"
ESVN_STORE_DIR="${DISTDIR}/svn-src/svn.gna.org-gnustep/libs"

S=${WORKDIR}/${PN}

DESCRIPTION="StepTalk is the official GNUstep scripting framework."
HOMEPAGE="http://www.gnustep.org/experience/StepTalk.html"

KEYWORDS="x86 ~ppc"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="${IUSE} doc"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"

src_install() {
	cd ${S}
	egnustep_env
	egnustep_install || die

	if use doc ; then
		egnustep_env
		cd Documentation
		mkdir -p ${TMP}/tmpdocs
		mv *.* ${TMP}/tmpdocs
		mv Reference ${TMP}/tmpdocs
		mkdir -p ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
		mv ${TMP}/tmpdocs/* ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
		cd ..
	fi
	egnustep_package_config
}

