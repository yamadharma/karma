# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit elisp eutils latex-package

DESCRIPTION="Extended support for writing, formatting and using (La)TeX, Texinfo and BibTeX files"
HOMEPAGE="http://www.gnu.org/software/auctex/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="preview-latex"

DEPEND="virtual/latex-base"

src_compile() {
	emake lispdir=${SITELISP}/${PN} || die "emake failed"
	cd doc; emake reftex.pdf || die "creation of reftex.pdf failed"
}

src_install() {
	emake prefix=${D}/usr lispdir=${D}${SITELISP}/${PN} install || die "emake install failed"
	dodoc CHANGES COPYING ChangeLog INSTALL README RELEASE doc/reftex.pdf
}

