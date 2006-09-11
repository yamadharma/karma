# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV="${PV/./}"
MY_PV="${MY_PV/_p/p}"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="XMLmind FO Converter (Personal Edition)"
SRC_URI="http://www.xmlmind.net/foconverter/_download/java/${PN}-${MY_PV}.tgz"
HOMEPAGE="http://www.xmlmind.com/foconverter/index.html"
IUSE="doc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc amd64"

RESTRICT="nostrip nomirror"
RDEPEND=">=virtual/jre-1.4.1"
DEPEND=""
INSTALLDIR=/opt/${PN}

src_install () 
{
	dodir ${INSTALLDIR}
	cp -pPR ${S}/* ${D}/${INSTALLDIR}

	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > ${D}/etc/env.d/10xfc

	if ( use doc )
	    then
	    dodir /usr/share/doc/${PF}
	    mv ${S}/docs/* ${D}/usr/share/doc/${PF}
	    rm -rf ${S}/docs
	    mv ${S}/samples ${D}/usr/share/doc/${PF}
	else
	    rm -rf ${S}/docs
	    rm -rf ${S}/samples
	fi
}

