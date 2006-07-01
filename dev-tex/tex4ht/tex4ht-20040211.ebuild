# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-tex/xmltex/xmltex-0.14-r1.ebuild,v 1.2 2004/02/29 14:44:15 aliz Exp $

inherit latex-package patch

IUSE=""

DESCRIPTION="A non validating namespace aware XML parser implemented in TeX"
HOMEPAGE="http://www.cis.ohio-state.edu/~gurari/TeX4ht"
# Taken from: http://www.cis.ohio-state.edu/~gurari/TeX4ht/tex4ht-all.zip
#SRC_URI="${FILESDIR}/distro/${PV}/tex4ht-all.zip"
SRC_URI=""

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/tetex
	app-arch/unzip"

RDEPEND="${RDEPEND}
	virtual/tetex	
	media-gfx/imagemagick"

S=${WORKDIR}

src_unpack ()
{
    cd ${S}
    
    unzip ${FILESDIR}/distro/${PV}/tex4ht-all.zip
    unzip tex4ht.zip
    
    patch_apply_addsrc    
}

src_compile () 
{
    cd ${S}
    cd temp
    gcc ${CFLAGS} -DKPATHSEA -I/usr/include -L/usr/lib -o tex4ht tex4ht.c -DHAVE_DIRENT_H -lkpathsea
    gcc ${CFLAGS} -DKPATHSEA -I/usr/include -L/usr/lib -o t4ht t4ht.c -DHAVE_DIRENT_H -lkpathsea
    
    rm -rf ${S}/texmf/tex4ht/base/win32
}

src_install () 
{
    cd ${S}/temp
    dobin tex4ht t4ht	

    cd ${S}/bin/unix
    dobin *

    dodir ${TEXMF}
    cp -R ${S}/texmf/* ${D}/${TEXMF}
}

