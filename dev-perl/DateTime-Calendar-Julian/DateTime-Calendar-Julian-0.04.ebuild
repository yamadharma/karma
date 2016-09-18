# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PIJLL
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Convert between DateTime and RFC2822/822 formats"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/DateTime-0.180.0
"
DEPEND="${RDEPEND}
"

SRC_TEST=do
