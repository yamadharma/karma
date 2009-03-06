# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils rpm

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://young.sp2mi.univ-poitiers.fr/~marc/LiE"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/linux/SRPMS/lie-${PV}-1.src.rpm"
#SRC_URI="http://young.sp2mi.univ-poitiers.fr/~marc/LiE/conLiE.tar.gz "

LICENSE="LGPL"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
DEPEND=""
RDEPEND=""

src_prepare() {
	epatch ${FILESDIR}/${P}-make.patch
	epatch ${FILESDIR}/parrallelmake-${P}.patch
}


src_install() {
	einstall DESTDIR=${D} || die
	use doc && dodoc ${S}/manual/*
	dodoc README
}
