# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Scilab scientific software"
HOMEPAGE="http://www.scilab.org"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

MY_PN=${PN/-bin/}
MY_PV=${PV/_beta/-beta-}
MY_P=${MY_PN}-${MY_PV}

SRC_URI="http://www.scilab.org/download/${MY_PV}/${MY_PN}-${MY_PV}.bin.linux-x86_64.tar.gz"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {

        local dest="${D}/opt/scilab"
        mkdir -p "${dest}"
        cp -R "${WORKDIR}/scilab"*/. "${dest}" || die
        dosym /opt/scilab/bin/scilab /usr/bin/scilab || die
        fowners root /opt/scilab
        fperms 755 /opt/scilab

}

#pkg_postrm() {
#
#        rm -rf "/opt/${MY_PN}"
#        rm "/usr/bin/${MY_PN}"
#
#}
