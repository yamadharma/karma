# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/farsight/farsight-0.1.10.ebuild,v 1.1 2006/10/30 17:37:10 peper Exp $

DESCRIPTION="FarSight is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.sourceforge.net/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"
#EDARCS_REPO_URI="http://projects.collabora.co.uk/darcs/farsight/farsight"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="sofia-sip gnet jingle"
# msn yahoo
SLOT="0"

RDEPEND="=media-libs/gstreamer-0.10*
	=media-plugins/gst-plugins-farsight-0.10*
	>=dev-libs/glib-2.6
	dev-libs/libxml2
	gnet? ( >=net-libs/gnet-2.0.7 )
	sofia-sip? ( >=net-libs/sofia-sip-1.11.6 )
	jingle? ( >=net-libs/libjingle-0.3 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --disable-debug \
		--disable-gtk-doc \
		--disable-sequence-diagrams \
		--enable-rtp \
		$(use_enable sofia-sip) \
		$(use_enable gnet) \
		$(use_enable jingle jingle-p2p) || die "econf failed"
	# Not yet ported to the new version
	# $(use_enable msn msnwebcam) \
	# $(use_enable msn msnavconf) \
	# $(use_enable yahoo yahoowebcam) \
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
}
