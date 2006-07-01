# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Perl module to read TNEF files"
SRC_URI="mirror://cpan/modules/by-module/Convert/${P}.tar.gz"
HOMEPAGE=

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="${DEPEND}
	dev-perl/MIME-tools"

mydoc="README"
