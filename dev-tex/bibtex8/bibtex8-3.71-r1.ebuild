# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package patch

S=${WORKDIR}

MY_P=bt${PV/./}

DESCRIPTION="LaTeX package and fonts used to set the euro (currency) symbol."
SRC_URI="ftp://ftp.tex.ac.uk/tex-archive/biblio/bibtex/8-bit/${MY_P}src.zip
	ftp://ftp.tex.ac.uk/tex-archive/biblio/bibtex/8-bit/${MY_P}csf.zip"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/bibtex8bit.html"
LICENSE="GNU"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc"

#src_unpack ()
#{
#    unpack ${A}
#}

src_compile ()
{
    make || die
}

src_install() 
{
    dobin bibtex8

    insinto ${TEXMF}/bibtex/csf
    doins *.csf

    dodoc 00readme.txt COPYING HISTORY csfile.txt file_id.diz
}

