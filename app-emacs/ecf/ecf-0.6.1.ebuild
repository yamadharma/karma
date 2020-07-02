# Copyright 1999-2020 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit elisp-common

DESCRIPTION="Emacs Configuration Framework"
HOMEPAGE="https://github.com/yamadharma/ecf"
SRC_URI="https://github.com/yamadharma/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="${IUSE}"

DEPEND="virtual/emacs"

src_install() {
	default

	make install DESTDIR=${D}

	SITELISPROOT=/usr/share/site-lisp

	dodir ${SITELISP}
	dosym ${SITELISPROOT}/rc.d/site-start.el ${SITELISP}/site-start.el
	dosym ${SITELISPROOT}/rc.d/default.el ${SITELISP}/default.el

	dodir /etc/emacs
	dosym ${SITELISPROOT}/rc.d/site-start.el /etc/emacs/site-start.el

	cd ${S}
	dodoc doc/*

	find ${D}/${SITELISPROOT} -type d -printf "%p/.keep\n" | tr "\n" "\0" | xargs -0 -n100 touch
}

# Local Variables:
# mode: sh
# End:
