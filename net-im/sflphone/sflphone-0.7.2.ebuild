# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3

DESCRIPTION="SFLphone aims to become your desktop's VoIP companion."
HOMEPAGE="http://www.sflphone.org/"
SRC_URI="http://www.sflphone.org/releases/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE="qt3 speex zeroconf mdnsresponder-compat"

DEPEND=">=net-libs/libosip-2.2.2
	>=net-libs/libeXosip-1.9.0
	>=dev-cpp/commoncpp2-1.3.21
	>=net-libs/ccrtp-1.3.5
	>=media-libs/portaudio-19_pre
	>=media-libs/libsamplerate-0.1.1
	qt3? ( $(qt_min_version 3.3) )
	speex? ( media-libs/speex )
	zeroconf? ( mdnsresponder-compat? ( net-dns/avahi )
		    !mdnsresponder-compat? ( net-misc/mDNSResponder ) 
		    )"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix compile error on genstef's box..doesn't seem to break anything
	sed -i -e "s/Qt::Key_Mode_switch/0x0100117e/" src/gui/qt/SFLPhoneWindow.cpp
	
	# Fix portaudio
#	sed -i -e "s:libportaudio,:libportaudio-2,:g" "${S}"/configure.ac
#	autoconf
}
src_compile () {
	econf \
		$(use_enable qt3 sflphoneqt) \
		$(use_enable speex) \
		$(use_enable zeroconf) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README
}
