# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-tex/latex-beamer/latex-beamer-2.20.ebuild,v 1.2 2004/05/06 14:57:00 ciaranm Exp $

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector."
HOMEPAGE="http://latex-beamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex-beamer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64 ~sparc"

IUSE=""

RDEPEND="virtual/tetex
	>=dev-tex/pgf-0.61
	>=dev-tex/xcolor-1.10"
S="${WORKDIR}/beamer"

src_compile () 
{
    return
}

src_install () 
{

	dodir /usr/share/texmf/tex/latex/beamer
	cp -a base themes art multimedia ${D}/usr/share/texmf/tex/latex/beamer
	
	insinto /usr/share/texmf/tex/latex/beamer/emulation
	doins emulation/*.sty
	

	for dir in examples emulation/examples 
	do
		insinto /usr/share/doc/${PF}/$dir
		doins $dir/*
	done
	if has_version 'app-office/lyx' ; then
		cp -a lyx ${D}/usr/share/doc/${PF}
	fi

	dodoc AUTHORS ChangeLog FILES TODO README
	insinto /usr/share/doc/${PF}
	doins doc/*
}

# Local Variables: ***
# mode: shell-script ***
# tab-width: 4 ***
# indent-tabs-mode: t ***
# End: ***
