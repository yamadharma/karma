# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=RYBSKEJ
inherit perl-module

DESCRIPTION="drop-in replacement for Perl threads using fork()"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

COMMON="dev-lang/perl"
RDEPEND="${COMMON}
	dev-perl/List-MoreUtils
	dev-perl/Sys-SigAction
	dev-perl/Devel-Symdump
	dev-perl/Acme-Damn"
DEPEND="${COMMON}"
