# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${PN/a/A}

DESCRIPTION="Addresses is a Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://giesler.biz/bjoern/en/sw_addr.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${P/a/A}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
