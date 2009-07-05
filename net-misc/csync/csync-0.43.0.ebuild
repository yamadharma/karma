# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="File transfer program to keep remote files into sync"
HOMEPAGE="http://www.csync.org/"
SRC_URI="http://www.csync.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="samba"

DEPEND=">=dev-libs/check-0.9.5
	>=dev-libs/log4c-1.2
	>=dev-db/sqlite-3.4
	samba? ( net-fs/samba )"

RDEPEND=">=dev-libs/log4c-1.2
	>=dev-db/sqlite-3.4
	samba? ( net-fs/samba )"
