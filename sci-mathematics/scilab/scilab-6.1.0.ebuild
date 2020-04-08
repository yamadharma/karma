# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1 fdo-mime


DESCRIPTION="Scilab scientific software"
HOMEPAGE="http://www.scilab.org"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

MY_PN=${PN/-bin/}
MY_PV=${PV/_beta/-beta-}
MY_P=${MY_PN}-${MY_PV}

SRC_URI="http://www.scilab.org/download/${MY_PV}/${MY_PN}-${MY_PV}.bin.linux-x86_64.tar.gz"

IUSE="bash-completion"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {

        local dest="${D}/opt/scilab"
        mkdir -p "${dest}"
        cp -R "${WORKDIR}/scilab"*/. "${dest}" || die
	dodir /usr/share
	cp -R "${S}/share/"* ${D}/usr/share  || die	
#        dosym /opt/scilab/bin/scilab /usr/bin/scilab || die
	cd ${dest}/bin
	for i in *
	do
            dosym /opt/scilab/bin/"$i" /usr/bin/"$i"
	done
	cd ${S}
	fowners root /opt/scilab
        fperms 755 /opt/scilab

	use bash-completion && newbashcomp "${FILESDIR}"/"${PN}".bash_completion "${PN}"

#	echo "SEARCH_DIRS_MASK=${EPREFIX}/usr/$(get_libdir)/scilab" \
#		> 50-"${PN}"
#	insinto /etc/revdep-rebuild && doins "50-${PN}"

}

pkg_postinst() {
	fdo-mime_mime_database_update
}


pkg_postrm() {
	fdo-mime_mime_database_update
}

