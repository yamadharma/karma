# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic

MY_P="${P/bibtool/BibTool}"
S="${WORKDIR}/BibTool"

DESCRIPTION="BibTool is a powerful command-line tool to manipulate BibTeX databases."
HOMEPAGE="http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
SRC_URI="http://mirror.ctan.org/biblio/bibtex/utils/bibtool/${MY_P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc"

DEPEND="dev-libs/kpathsea
	virtual/libc
		doc? ( app-text/texlive )"
RDEPEND="$DEPEND"

src_unpack()
{
	unpack ${A}
	cd ${S}
	sed -i -e 's,^INSTALL_DIR.*\./mkdirchain,INSTALL_DIR = install -d,g' \
		-e 's,^BIBTOOL_DEFAULT.*$,BIBTOOL_DEFAULT = \\"\.:/usr/share/bibtool\\",g' \
		-e 's,^LIBDIR.*$,LIBDIR = @libdir@/bibtool,g' \
		-e 's,^NON_ANSI_DEFS.*,NON_ANSI_DEFS = @DEFS@ -DSTDC_HEADERS,g' \
		AutoConf/makefile.in || die
}

src_compile()
{
	append-flags -fno-strict-aliasing
	econf --with-system-kpathsea --prefix=${D}/usr --libdir=${D}/usr/share || die "econf failed"
	sed -i -e 's#@kpathsea_lib_static@##' makefile
	emake CFLAGS="${CFLAGS}" || die "emake failed"
	if use doc ; then
		ln -s makefile Makefile
		emake doc
	fi
}

src_install()
{
	emake DESTDIR="${D}" install || die "emake install failed"

	doman doc/bibtool.1 || die

	if use doc ; then
		dodoc doc/{bibtool.pdf,c_lib.pdf,ref_card.pdf} || die
	fi
}
