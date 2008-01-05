# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Flexible Indexing System"

MY_PV=${PV/_beta2/-beta2}
CLISP_PV=2.43

HOMEPAGE="http://www.xindy.org/"
SRC_URI="http://dev.atmarama.org/${PN}-${MY_PV}.tar.gz
	mirror://sourceforge/clisp/clisp-${CLISP_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
DEPEND="virtual/tetex"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	local clisp
	
	unpack ${A}
	
	# Dirty hack. clisp-2.33.2 don't compile for me.
	cd ${S}/rte
	clisp=`ls -d clisp* | tail -n 1`
	rm -rf ${clisp} 
	mv -f ${WORKDIR}/clisp-${CLISP_PV} ${clisp}	
}

src_compile() {
	LDFLAGS="" \
	econf \
	    `use_enable doc docs` \
	    || die "Configure failed"
	make -j1 || die "Make failed"
}


src_install() {
	make install \
	    DESTDIR=${D} || die "Install failed"
}

