# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openoffice-ext

MY_P=OOoFBTools-${PV}

DESCRIPTION="The cross platform OpenOffice.org extension OOo FBTools used to convert to and processing eBooks in FictionBook2 format"
LICENSE="GPL-2"
HOMEPAGE="http://extensions.services.openoffice.org/project/ooofbtools
	https://code.google.com/p/ooofbtools/"
SRC_URI="http://ooofbtools.googlecode.com/files/${MY_P}.zip"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

RDEPEND="${RDEPEND}
	sys-apps/coreutils"

S="${WORKDIR}/${MY_P}"

OOO_EXTENSIONS=OOoFBTools.oxt

