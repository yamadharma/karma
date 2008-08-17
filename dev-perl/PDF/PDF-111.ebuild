# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="The PDF library is a proposed library for access the information contained inside a PDF file"
SRC_URI="mirror://cpan/authors/id/A/AN/ANTRO/${P}.tgz"
HOMEPAGE="http://search.cpan.org/~antro/"

S=${WORKDIR}/${PN}

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"

mydoc=examples/*
