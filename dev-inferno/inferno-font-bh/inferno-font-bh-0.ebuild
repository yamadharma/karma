# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

DESCRIPTION="Bigelow & Holmes Lucida fonts for OS Inferno"
HOMEPAGE="http://www.vitanuova.com/inferno/index.html"
SRC_URI="
	http://www.vitanuova.com/dist/4e/20071003/inferno.tgz
	http://www.vitanuova.com/dist/4e/20071003/Linux.tgz
	"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~x86"
IUSE="hardened"

RDEPEND=""

DEPEND="${RDEPEND}
	dev-inferno/inferno
	hardened? ( sys-apps/chpax )
	"

MY_S="${WORKDIR}"

src_compile() {
	cd "${MY_S}"
	# emu in distrib is too old for modern linux, let's use svn version instead
	cp /usr/inferno/Linux/386/bin/emu Linux/386/bin/emu
	mkdir image
	sh install/Linux-386.sh "${MY_S}"/image/
	[ -f "${MY_S}"/image/fonts/LICENCE ] || die "please re-run emerge"
}

src_install() {
	insinto /usr/inferno/fonts
	doins -r "${MY_S}"/image/fonts/{lucida,lucidasans,lucm,pelm,LICENCE}
}

