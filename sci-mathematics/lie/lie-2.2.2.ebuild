# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://young.sp2mi.univ-poitiers.fr/~marc/LiE"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/linux/dapper/${P/-/_}.orig.tar.gz"

LICENSE="LGPL"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${P}.orig

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-make.patch
}


src_install() {
	einstall DESTDIR=${D} || die
	use doc && dodoc ${S}/manual/*
	dodoc README
}
