# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/net-mail/amavis/amavis-0.2.1-r2.ebuild,v 1.7 2002/08/14 12:05:25 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ripMIME has been written with one sole purpose in mind, 
to extract the attached files out of a MIME encoded email package"
SRC_URI="http://www.pldaniels.com/ripmime/${P}.tar.gz"
HOMEPAGE="http://www.pldaniels.com/ripmime"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

RDEPEND=${DEPEND}

src_compile() 
{
  make || die
}

src_install() 
{  
  dodir /usr/bin
  make LOCATION=${D}/usr install
}
