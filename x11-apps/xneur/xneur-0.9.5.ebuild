# Copyright 2007 Gleb "Sectoid" Golubitsky
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xeyes/xeyes-1.0.1.ebuild,v 1.4 2006/09/18 11:54:09 dberkholz Exp $

#inherit x-modular

DESCRIPTION="Replacement for Punto Switcher"
HOMEPAGE="http://www.xneur.ru"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="pcre aspell openal gstreamer"
DEPEND="x11-base/xorg-x11
	media-libs/imlib2
	x11-libs/xosd
	pcre? ( dev-libs/libpcre )
	aspell? ( app-text/aspell )
	openal? ( media-libs/openal )
	gstreamer? ( media-libs/gstreamer )"

RESTRICT="mirror"

S=${WORKDIR}/${P}
SLOT="0"

src_compile() {

	if ! use pcre; then 
	    myconf="${myconf} --without-pcre"
	fi

	if ! use aspell; then
	    myconf="${myconf} --without-aspell"
	fi

	if ! use gstreamer && ! use openal ; then
	    myconf="${myconf} --without-sound"
	else
	    if ! use gstreamer; then
		myconf="${myconf} --without-gstreamer"
	    fi
	    if ! use openal; then
		myconf="${myconf} --without-openal"
	    fi
	fi

        econf ${myconf} || die
        emake || die
}

src_install() {
        emake DESTDIR=${D} install || die "install failed"
}
