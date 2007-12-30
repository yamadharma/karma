# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Flexible Indexing System"

MY_PV=${PV/_beta2/-beta2}
HOMEPAGE="http://www.xindy.org/"
SRC_URI="http://dev.atmarama.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
DEPEND="virtual/tetex"

S=${WORKDIR}/${PN}-${MY_PV}


src_compile() {
	econf \
	`use_enable doc docs` \
	|| die "Configure failed"
	emake -j1 || die "Make failed"
}


src_install() {
	make install \
	DESTDIR=${D} || die "Install failed"
}

