# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_P=${PN}-${PV##*pre}

S=${WORKDIR}/${MY_P/pdfk/PDFK}

DESCRIPTION="PDFKit is a framework that supports rendering of PDF content in GNUstep applications"
HOMEPAGE="http://home.gna.org/gsimageapps/"
SRC_URI="http://www.gnustep.it/enrico/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	!gnustep-libs/imagekits"
RDEPEND="${GS_RDEPEND}
	!gnustep-libs/imagekits"

egnustep_install_domain "System"

src_compile ()
{
	egnustep_env
	
	econf || die
	egnustep_make || die
}