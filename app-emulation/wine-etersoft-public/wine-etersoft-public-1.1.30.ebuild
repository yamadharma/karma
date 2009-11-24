# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-1.1.25.ebuild,v 1.2 2009/08/01 06:58:00 ssuominen Exp $

EAPI="2"

inherit multilib eutils rpm

GV="1.0.0-x86"
DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"
SRC_URI="ftp://updates.etersoft.ru/pub/Etersoft/Wine-public/${PV}/sources/wine-${PV}-alt1.src.rpm
	gecko? ( mirror://sourceforge/wine/wine_gecko-${GV}.cab )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="alsa capi +cups dbus esd fontconfig gecko gnutls gphoto2 gsm hal jack jpeg lcms ldap mp3 nas ncurses openal opengl oss png samba scanner ssl test +threads win64 X xcomposite xinerama xml"
RESTRICT="test" #72375

S=${WORKDIR}/wine-${PV}

RDEPEND=">=media-libs/freetype-2.0.0
	media-fonts/corefonts
	dev-lang/perl
	dev-perl/XML-Simple
	capi? ( net-dialup/capi4k-utils )
	ncurses? ( >=sys-libs/ncurses-5.2 )
	fontconfig? ( media-libs/fontconfig )
	gphoto2? ( media-libs/libgphoto2 )
 	jack? ( media-sound/jack-audio-connection-kit )
	openal? ( media-libs/openal )
	dbus? ( sys-apps/dbus )
	gnutls? ( net-libs/gnutls )
	hal? ( sys-apps/hal )
	X? (
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage
	)
	alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	cups? ( net-print/cups )
	opengl? ( virtual/opengl )
	gsm? ( media-sound/gsm )
	jpeg? ( media-libs/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( media-libs/lcms )
	mp3? ( media-sound/mpg123 )
	samba? ( >=net-fs/samba-3.0.25 )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	scanner? ( media-gfx/sane-backends )
	ssl? ( dev-libs/openssl )
	png? ( media-libs/libpng )
	win64? ( >=sys-devel/gcc-4.4.0 )
	!win64? ( amd64? (
		X? (
			>=app-emulation/emul-linux-x86-xlibs-2.1
			>=app-emulation/emul-linux-x86-soundlibs-2.1
		)
		app-emulation/emul-linux-x86-baselibs
		>=sys-kernel/linux-headers-2.6
	) )"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	sys-devel/bison
	sys-devel/flex"

src_unpack() {
	rpm_src_unpack
	tar xf wine-${PV}.tar
}

src_prepare() {
	epatch "${FILESDIR}"/wine-1.1.15-winegcc.patch #260726
	epatch_user #282735
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

src_configure() {
	export LDCONFIG=/bin/true

	use amd64 && ! use win64 && multilib_toolchain_setup x86

	# XXX: should check out these flags too:
	#	audioio capi fontconfig freetype gphoto
	econf \
		--sysconfdir=/etc/wine \
		$(use_with alsa) \
		$(use_with capi) \
		$(use_with lcms cms) \
		$(use_with cups) \
		$(use_with ncurses curses) \
		$(use_with esd) \
		$(use_with fontconfig) \
		$(use_with gnutls) \
		$(use_with gphoto2 gphoto) \
		$(use_with gsm) \
		$(! use dbus && echo --without-hal || use_with hal) \
		$(use_with jack) \
		$(use_with jpeg) \
		$(use_with ldap) \
		$(use_with mp3 mpg123) \
		$(use_with nas) \
		$(use_with ncurses curses) \
		$(use_with openal) \
		$(use_with ncurses curses) \
		$(use_with opengl) \
		$(use_with ssl openssl) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with threads pthread) \
		$(use_with scanner sane) \
		$(use_enable test tests) \
		$(use_enable win64) \
		$(use_with X x) \
		$(use_with xcomposite) \
		$(use_with xinerama) \
		$(use_with xml) \
		$(use_with xml xslt) \
		|| die "configure failed"

	emake -j1 depend || die "depend"
}

src_compile() {
	emake all || die "all"
}

src_install() {
	make DESTDIR="${D}" initdir=/etc/init.d sysconfdir=/etc install || die
	dodoc ANNOUNCE AUTHORS README

	if use gecko ; then
		insinto /usr/share/wine/gecko
		doins "${DISTDIR}"/wine_gecko-${GV}.cab || die
	fi

#	cp "${FILESDIR}"/*.fon ${D}/usr/share/wine/fonts/
#	cp "${FILESDIR}"/*.ttf ${D}/usr/share/wine/fonts/

	rm -f ${D}/etc/init.d/*
	newinitd ${FILESDIR}/wine.initd wine

	keepdir /var/lib/wine
	fperms g+w /var/lib/wine
	fowners root:wineadmin /var/lib/wine
}
