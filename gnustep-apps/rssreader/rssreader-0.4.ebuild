# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep 

S=${WORKDIR}/RSSReader

DESCRIPTION="A workspace manager for GNUstep."
HOMEPAGE="http://www.unix-ag.uni-kl.de/~guenther/rssreader.html"

SRC_URI="http://www.unix-ag.uni-kl.de/~guenther/RSSReader-${PV}-complete.tar"

KEYWORDS="~ppc x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"

DEPEND="${GS_DEPEND}
	gnustep-libs/rsskit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/rsskit"

egnustep_install_domain "System"

src_unpack ()
{
	unpack ${A}
	cd ${WORKDIR}
	tar xzf RSSReader-${PV}.tar.gz
}

src_compile () 
{
	egnustep_env

	egnustep_make
}

src_install () 
{
	egnustep_env

	egnustep_install
	
	dodoc AUTHORS COPYRIGHT ChangeLog INSTALL TODO PORTING-TO-OSX
}

