# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-ext

DESCRIPTION="A Visual Editor for XML"
HOMEPAGE="http://vex.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-plugins.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

S=${WORKDIR}

DEPEND=">=virtual/jdk-1.4
	>=dev-util/eclipse-sdk-3
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4
	>=dev-util/eclipse-sdk-3"

pkg_setup () 
{
	eclipse-ext_require-slot 3 || die "No suitable Eclipse found!"
}

src_compile () 
{

	einfo "Nothing to compile"

}

src_install() {
	eclipse-ext_create-ext-layout source
	eclipse-ext_install-plugins ${S}/plugins/*
	eclipse-ext_install-features ${S}/features/*
}
