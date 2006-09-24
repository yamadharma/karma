# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep flag-o-matic

MY_P=${PN}-${PV##*pre}

S=${WORKDIR}/${MY_P/pdfk/PDFK}

DESCRIPTION="A framework for rendering of PDF content in GNUstep applications"
HOMEPAGE="http://home.gna.org/gsimageapps/"
SRC_URI="http://www.gnustep.it/enrico/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=${IUSE}
DEPEND="${GS_DEPEND}
	!gnustep-libs/imagekits"
RDEPEND="${GS_RDEPEND}
	!gnustep-libs/imagekits"

egnustep_install_domain "System"

src_unpack () {
	unpack ${A}
	
	# FIX for amd64
	sed -i -e "s:CFLAGS = @CFLAGS@ @DEFS@ -I.. -I\$(srcdir):CFLAGS = @CFLAGS@ @DEFS@ -I.. -I\$(srcdir) -fPIC:" ${S}/xpdf/xpdf-3.01/goo/Makefile.in
}

src_compile () {
	egnustep_env

	append-flags -fPIC
	
	econf || die
	egnustep_make || die
}

