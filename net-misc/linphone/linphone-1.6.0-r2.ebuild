# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/linphone/linphone-1.3.5.ebuild,v 1.9 2006/07/01 11:08:57 pylon Exp $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"

inherit eutils autotools

MY_DPV="${PV%.*}.x"

DESCRIPTION="Linphone is a SIP phone with a GNOME interface."
HOMEPAGE="http://www.linphone.org"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${MY_DPV}/sources/${P}.tar.gz
	gtk? ( http://dev.gentoo.org/~drizzt/trash/linphone-1.6.0-gtk.patch.bz2 )"
SLOT=1
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="alsa console gnome gtk ilbc ipv6 novideo portaudio xv"

RDEPEND="dev-libs/glib
	dev-perl/XML-Parser
	net-dns/bind-tools
	>=net-libs/libosip-2.2.0
	>=media-libs/speex-1.1.12
	x86? ( xv? ( dev-lang/nasm ) )
	gnome? ( >=gnome-base/gnome-panel-2
		  >=gnome-base/libgnome-2
		  >=gnome-base/libgnomeui-2
		  >=x11-libs/gtk+-2 )
	gtk? ( >=x11-libs/gtk+-2
		gnome-base/libglade )
	alsa? ( media-libs/alsa-lib )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	!novideo? ( >=media-libs/libsdl-1.2.9
		media-video/ffmpeg
		media-libs/libtheora )
	portaudio? ( >=media-libs/portaudio-19_pre )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.5.1-pkgconfig.patch
	epatch "${FILESDIR}"/${P}-call.patch
	epatch "${WORKDIR}"/${P}-gtk.patch

	./autogen.sh
}

src_compile() {
	local withconsole withgnome withgtk myconf

	use console && withconsole="yes" || withconsole="no"
	use gnome && withgnome="yes" || withgnome="no"
	use gtk && withgtk="yes" || withgtk="no"
	use x86 && myconf="--enable-truespeech"

	econf \
		--libdir=/usr/$(get_libdir)/linphone \
		--enable-console_ui=${withconsole} \
		--enable-gnome_ui=${withgnome} \
		--enable-gtk_ui=${withgtk} \
		$(use_with ilbc) \
		$(use_enable ipv6) \
		$(use_enable alsa) \
		$(use_enable !novideo video) \
		$(use_enable portaudio) \
		${myconf} || die "Unable to configure"

	emake || die "Unable to make"
}

src_install () {
	emake DESTDIR=${D} install || die "Failed to install"

	dodoc ABOUT-NLS AUTHORS BUGS ChangeLog COPYING INSTALL NEWS README
	dodoc README.arm TODO

	# don't install ortp includes, docs and pkgconfig files
	# to avoid conflicts with net-libs/ortp
	rm -rf ${D}/usr/include/ortp
	rm -rf ${D}/usr/share/gtk-doc/html/ortp
	rm -rf ${D}/usr/$(get_libdir)/linphone/pkgconfig
	rm -rf ${D}/ortp
}
