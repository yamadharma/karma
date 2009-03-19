# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/festival-ru/festival-ru-0.4,v 1 2008/01/30 06:59:52 williamh Exp $

inherit eutils

DESCRIPTION="Russian language for Festival Text to Speech engine"
HOMEPAGE="https://developer.berlios.de/projects/festlang/"
SRC_URI="http://prdownload.berlios.de/festlang/msu_ru_nsh_clunits-${PV}.tar.gz"
LICENSE="FESTIVAL BSD as-is"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

DEPEND=">=app-accessibility/festival-1.96_beta"
RDEPEND="${DEPEND}"

S=${WORKDIR}/msu_ru_nsh_clunits

src_unpack() {
	unpack ${A}
}

src_install() {

	# Install the main libraries
	insinto /usr/share/festival/voices/russian/msu_ru_nsh_clunits
	doins -r *

	# Install the docs
	dodoc "${S}"/{COPYING,NOTES,README}
	
}
