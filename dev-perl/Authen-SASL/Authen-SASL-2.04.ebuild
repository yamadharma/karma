# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit perl-module

S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="Interface to SASL library"
SRC_URI="http://www.cpan.org/modules/by-module/Authen/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Authen/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~arm amd64"
