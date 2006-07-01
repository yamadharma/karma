# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/superadduser/superadduser-1.0-r2.ebuild,v 1.6 2003/02/10 21:58:20 latexer Exp $

inherit perl-module

DESCRIPTION="Interactive adduser script"
SRC_URI="http://savannah.nongnu.org/download/usertools/stable.pkg/${PV}/${PN}.tar.gz"
HOMEPAGE="http://savannah.nongnu.org/download/usertools"
S=${WORKDIR}/${PN}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha "

RDEPEND="sys-apps/shadow"

