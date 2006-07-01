# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-tex/eurosym/eurosym-1.2.ebuild,v 1.5 2003/09/20 03:43:52 obz Exp $

inherit latex-package

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

src_unpack ()
{
    unpack ${A}
    sed -i -e "s:/usr/local/lib/bibtex:/usr/share/texmf/bibtex:g" unix.mak
}

src_compile ()
{
    make -f unix.mak linux-gcc
}
src_install() 
{
    newbin bibtex bibtex8

    insinto ${TEXMF}/bibtex/csf
    doins *.csf

    dodoc 00readme.txt COPYING HISTORY csfile.txt file_id.diz
}

