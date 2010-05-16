# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2 subversion

ESVN_PROJECT=libobjc2

ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/libobjc2/trunk@${PV/*_pre}"


DESCRIPTION="GNUstep Objective-C Runtime"
HOMEPAGE="http://www.gnustep.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
