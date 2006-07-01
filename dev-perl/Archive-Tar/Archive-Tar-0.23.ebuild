# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Compress-Zlib/Compress-Zlib-1.16-r1.ebuild,v 1.6 2002/08/14 04:32:30 murphy Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Perl module for creation and manipulation of tar files"
SRC_URI="http://www.cpan.org/modules/by-module/Archive/${P}.tgz"
HOMEPAGE=

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="${DEPEND}
	dev-perl/Compress-Zlib"

mydoc="TODO README"
