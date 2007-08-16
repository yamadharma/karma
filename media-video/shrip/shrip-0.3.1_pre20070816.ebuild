# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified for SVN by Sebastian Schuberth <sschuberth_AT_gmail_DOT_com>
# $Header: $

inherit subversion

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="https://ogmrip.svn.sourceforge.net/svnroot/ogmrip/trunk/shrip/"
ESVN_PROJECT="shrip"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

DESCRIPTION="Command line tool for ripping DVDs and encoding to AVI/OGM/MKV/MP4"
HOMEPAGE="http://ogmrip.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug"
KEYWORDS="amd64 x86"

DEPEND=">=dev-libs/glib-2.6
       >=dev-util/intltool-0.29
       >=dev-util/pkgconfig-0.12.0
       >=media-video/ogmrip-0.10.3"

src_compile() {
	myconf="$(use_enable debug maintainer-mode)"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog README TODO

	insinto /etc
	doins shrip.conf
}

