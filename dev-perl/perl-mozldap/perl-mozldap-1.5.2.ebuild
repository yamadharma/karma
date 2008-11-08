# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION=" Mozilla PerLDAP"
HOMEPAGE="http://www.mozilla.org/directory/perldap.html"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-libs/nspr-4.0.1
	>=dev-libs/nss-3.11.6
	>=dev-libs/mozldap-6.0.1
	dev-lang/perl"

src_compile() {
	LDAPPKGNAME=mozldap perl Makefile.PL.rpm DESTDIR="${D}" INSTALLDIRS=vendor
	perl-module_src_test
}
