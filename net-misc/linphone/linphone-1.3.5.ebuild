# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/linphone/linphone-1.1.0.ebuild,v 1.1 2005/08/29 02:46:33 stkn Exp $

inherit eutils autotools

MY_DPV="${PV%.*}.x"

DESCRIPTION="Linphone is a SIP phone with a GNOME interface."
HOMEPAGE="http://www.linphone.org/?lang=us"
SRC_URI="http://simon.morlat.free.fr/download/${MY_DPV}/source/${P}.tar.gz
	ilbc? ( http://simon.morlat.free.fr/download/${MY_DPV}/source/plugins/${PN}-plugin-ilbc-1.2.0.tar.gz )"
SLOT=1
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"

IUSE="alsa gnome ilbc ipv6 truespeech xv"

RDEPEND="dev-libs/glib
	dev-perl/XML-Parser
	>=net-libs/libosip-2.2.0
	>=media-libs/speex-1.1.12
	x86? ( xv? ( dev-lang/nasm ) )
	gnome? ( >=gnome-base/gnome-panel-2
		 >=gnome-base/libgnome-2
		 >=gnome-base/libgnomeui-2
		 >=x11-libs/gtk+-2 )
	alsa? ( media-libs/alsa-lib )
	ilbc? ( dev-libs/ilbc-rfc3951 )"

DEPEND="${RDEPEND}"

S_ILBC="${WORKDIR}/${PN}-plugin-ilbc-1.2.0"

src_unpack() {
	unpack ${A}

	cd ${S}
	# fix #99083
	epatch ${FILESDIR}/${PN}-1.0.1-ipv6-include.diff

	# gcc4 fix for ortp
	epatch ${FILESDIR}/${PN}-1.3.5-ortp-gcc4.diff

	# _never_ever_ add the default search locations for libs and includes in the middle
	# of your cflags / ldflags (or generally), things will break horribly if you do!
	#epatch ${FILESDIR}/${PN}-1.3.5-osip.m4.diff

	# create m4 in oRTP subdir to make eautoreconf happy (blaah)
	mkdir ${S}/oRTP/m4 

	AT_M4DIR="m4" eautoreconf

	# - Problem:
	#   include statement from osip patch... libtool sucks for stuff like linphone
	#   (= packages that bundle parts of their dependencies, oRTP in linphone's case)
	#   libtool does a relink of liblinphone during make install which will use -L/usr/lib
	#   in the middle and completely b0rk if you have oRTP already installed there (read: net-libs/oRTP)
	# - Workaround:
	#   Add a filter that removes system's default search paths from the final link command
	#
	#   /me needs a beer now
	epatch ${FILESDIR}/${PN}-1.3.5-ltmain.sh.diff

	if use ilbc; then
		cd ${S_ILBC}
		# add -fPIC and custom cflags to ilbc makefile
		epatch ${FILESDIR}/ilbc-1.2.0-makefile.diff
	fi
}

src_compile() {
	local withgnome myconf=""

	if use gnome; then
		einfo "Building with GNOME interface."
		withgnome="yes"
	else
		withgnome="no"
	fi

	use x86 && use truespeech && \
		myconf="--enable-truespeech"

	econf \
		--enable-glib \
		--with-speex=/usr \
		--libexecdir=/usr/sbin \
		--libdir=/usr/$(get_libdir)/linphone \
		--enable-gnome_ui=${withgnome} \
		`use_enable ipv6` \
		`use_enable alsa` \
		${myconf} || die "Unable to configure"

	emake || die "Unable to make"

	if use ilbc; then
		emake LINPHONE_SOURCE=${S} \
		PLUGINS_INSTALL_PATH=/usr/$(get_libdir)/linphone/plugins/mediastreamer \
		-C ${S_ILBC} || die
	fi
}

src_install () {
	make DESTDIR=${D} install || die "Failed to install"

	if use ilbc; then
		make LINPHONE_SOURCE=${S} \
		PLUGINS_INSTALL_PATH=/usr/$(get_libdir)/linphone/plugins/mediastreamer \
		DESTDIR=${D} -C ${S_ILBC} install || die
	fi

	dodoc ABOUT-NLS AUTHORS BUGS ChangeLog COPYING INSTALL NEWS README
	dodoc README.arm TODO

	# don't install ortp includes, docs and pkgconfig files
	# to avoid conflicts with net-libs/ortp
	rm -rf ${D}/usr/include/ortp
	rm -rf ${D}/usr/share/gtk-doc/html/ortp
	rm -rf ${D}/usr/$(get_libdir)/linphone/pkgconfig
}
