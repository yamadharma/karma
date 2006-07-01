# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

MY_P=libhtmlobject-perl-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A HTML development and delivery Perl Module"
HOMEPAGE="http://htmlobject.sourceforge.net"
SRC_URI="mirror://sourceforge/htmlobject/${MY_P}.tar.gz"

DEPEND="dev-perl/DateManip"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 sparc x86"
IUSE=""

mydoc="LICENSE TODO"
