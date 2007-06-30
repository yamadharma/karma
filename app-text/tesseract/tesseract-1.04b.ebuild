# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="A commercial quality OCR engine developed at HP in the 80's and early 90's."
HOMEPAGE="http://sourceforge.net/projects/tesseract-ocr/"
SRC_URI="http://tesseract-ocr.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/tesseract-1.04/

	epatch "${FILESDIR}"/tesseract-1.04b.xterm-path.patch
	epatch "${FILESDIR}"/tesseract-1.04b-globals.patch
	sed -i -e "s/datadir = \${prefix}\/share\/tessdata/datadir = \${prefix}\/$(get_libdir)\/${PN}/" ${WORKDIR}/tesseract-1.04/tessdata/Makefile
}

src_compile() {
	cd ${WORKDIR}/tesseract-1.04/
	econf --datadir=/usr/$(get_libdir)/${PN} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/tesseract-1.04/
	local dest="/usr/$(get_libdir)/${PN}"

	dodir "${dest}"

	exeinto "${dest}"
	doexe ccmain/tesseract

	dodir "${dest}/tessdata/configs"
	dodir "${dest}/tessdata/tessconfigs"

	insinto "${dest}/tessdata"
	doins tessdata/*

	insinto "${dest}/tessdata/configs"
	doins tessdata/configs/*

	insinto "${dest}/tessdata/tessconfigs"
	doins tessdata/tessconfigs/*

	dodoc README AUTHORS phototest.tif

	echo -e "#!/bin/sh\n${dest}/${PN} \"\${@}\"" > ${PN}.sh
	newbin ${PN}.sh ${PN}
}
