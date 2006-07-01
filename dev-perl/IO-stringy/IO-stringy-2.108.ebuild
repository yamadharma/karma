# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/dev-perl/IO-String/IO-String-1.01-r1.ebuild,v 1.6 2002/08/14 04:32:32 murphy Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="I/O on in-core objects like strings and arrays"
SRC_URI="mirror://cpan/modules/by-module/IO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/IO/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64"

mydocs="README"