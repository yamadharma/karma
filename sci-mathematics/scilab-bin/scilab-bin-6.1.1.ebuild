# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit eutils bash-completion-r1 xdg


DESCRIPTION="Scilab scientific software"
HOMEPAGE="http://www.scilab.org"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

MY_PN=${PN/-bin/}
MY_PV=${PV/_beta/-beta-}
MY_P=${MY_PN}-${MY_PV}

SRC_URI="https://www.scilab.org/download/${MY_PV}/${MY_P}.bin.linux-x86_64.tar.gz"

IUSE="bash-completion"

DEPEND=""
RDEPEND="
	sys-libs/ncurses-compat
	virtual/jre:1.8
"

QA_PREBUILT=( "opt/${MY_PN}/*" )

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	local SCILAB_HOME="/opt/${MY_PN}"
	# fix the .pc file to reflect the dirs where we are installing stuff
	sed -i -e "/^prefix=/c prefix=${SCILAB_HOME}" lib/pkgconfig/scilab.pc || die

	# move appdata to metainfo
	mv share/appdata share/metainfo || die
}

src_install() {
	local SCILAB_HOME="/opt/${MY_PN}"
	dodir "${SCILAB_HOME}"
	dodir /usr/bin

	# make convenience symlinks in PATH
#	for file in bin/*; do
#		dosym "../${MY_PN}/${file}" "/usr/bin/${file}"
#	done

	# copy all the things
	cp -r "${S}/"*  "${ED}/${SCILAB_HOME}" || die


#        local dest="${D}/opt/scilab"
#        mkdir -p "${dest}"
#        cp -R "${WORKDIR}/scilab"*/. "${dest}" || die
#	dodir /usr/share
#	cp -R "${S}/share/"* ${D}/usr/share  || die
##        dosym /opt/scilab/bin/scilab /usr/bin/scilab || die
#	cd ${dest}/bin
#	for i in *
#	do
#            dosym /opt/scilab/bin/"$i" /usr/bin/"$i"
#	done
#	cd ${S}
#	fowners root /opt/scilab
#        fperms 755 /opt/scilab

	for i in bin/*
	do
            dosym /opt/scilab/"$i" /usr/"$i"
	done


	# Hack, use script for call scilab
	rm ${D}/usr/bin/scilab
	dobin ${FILESDIR}/scilab

	use bash-completion && newbashcomp "${FILESDIR}"/bash_completion "${PN}"
	use bash-completion && newbashcomp "${FILESDIR}"/bash_completion "${PN//-bin}"

#	echo "SEARCH_DIRS_MASK=${EPREFIX}/usr/$(get_libdir)/scilab" \
#		> 50-"${PN}"
#	insinto /etc/revdep-rebuild && doins "50-${PN}"

	# move out dekstop, icons etc
	dodir /usr/share
	mv "${ED}/${SCILAB_HOME}/share/"{metainfo,applications,icons,locale,mime} "${ED}/usr/share/" || die
	dodir /usr/lib64/pkgconfig
	mv "${ED}/${SCILAB_HOME}/lib/pkgconfig/scilab.pc" "${ED}/usr/lib64/pkgconfig/" || die

}

pkg_postinst() {
	xdg_pkg_postinst
}


pkg_postrm() {
	xdg_pkg_postrm
}

