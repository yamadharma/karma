# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for translating text and web pages between natural languages."
HOMEPAGE="http://www.nongnu.org/libtranslate"
SRC_URI="http://savannah.nongnu.org/download/libtranslate/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86 amd64"
LICENSE="BSD"
IUSE=""


DEPEND=">=dev-libs/glib-2.4.0
		>=net-libs/libsoup-2.2.0
		>=dev-libs/libxml2-2.0
		app-text/talkfilters
		dev-perl/XML-Parser"


src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/libtranslate-ds-timed.patch.bz2
	epatch "${FILESDIR}"/libtranslate-ds-memory.patch
	
	epatch "${FILESDIR}"/libtranslate-0.99-charsetparse.diff
	epatch "${FILESDIR}"/libtranslate-0.99-condfix.diff
	epatch "${FILESDIR}"/libtranslate-ds-empty.patch 
	epatch "${FILESDIR}"/libtranslate-ds-promt.patch 
	epatch "${FILESDIR}"/libtranslate-ds-fixcharset.patch
}

src_install() {
# Installing new services.xml without broken items
	cp -f ${FILESDIR}/services.xml data/
	
	make install DESTDIR="${D}"

	cd ${S}
	dodoc AUTHORS COPYING INSTALL NEWS README TODO
}
