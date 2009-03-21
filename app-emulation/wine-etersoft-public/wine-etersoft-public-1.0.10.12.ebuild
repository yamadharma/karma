# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils flag-o-matic multilib versionator rpm


GV="0.9.1"
DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"

MY_PV=$(replace_version_separator 3 '-alt')

SRC_URI="ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft/$(get_version_component_range 1-3)/sources/wine-etersoft-${MY_PV}.src.rpm"
#	gecko? ( mirror://sourceforge/wine/wine_gecko-${GV}.cab )"
#	ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft/${PV}/sources/tarball/wine-etersoft-public-${WINEVER}.tar.bz2
#	ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft/${PV}/sources/tarball/wine-etersoft-common-${PV}.tar.bz2

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="alsa cups dbus esd gecko gnutls hal jack jpeg lcms ldap nas ncurses opengl oss png samba scanner ssl win64 X xcomposite xinerama xml"

S="${WORKDIR}"/wine-etersoft-$(get_version_component_range 1-3)

RDEPEND=">=media-libs/freetype-2.0.0
	!app-emulation/wine
	media-fonts/corefonts
	ncurses? ( >=sys-libs/ncurses-5.2 )
	jack? ( media-sound/jack-audio-connection-kit )
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
	alsa? ( media-libs/alsa-lib[midi] )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	cups? ( net-print/cups )
	opengl? ( virtual/opengl )
	jpeg? ( media-libs/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( media-libs/lcms )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	>=media-gfx/fontforge-20060703
	scanner? ( media-gfx/sane-backends )
	ssl? ( dev-libs/openssl )
	png? ( media-libs/libpng )
	win64? ( >=sys-devel/gcc-4.4_alpha )
	amd64? (
		X? (
			>=app-emulation/emul-linux-x86-xlibs-2.1
			>=app-emulation/emul-linux-x86-soundlibs-2.1
		)
		app-emulation/emul-linux-x86-baselibs
		>=sys-kernel/linux-headers-2.6
	)"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	enewgroup wineadmin
}

src_prepare() {
	epatch "${FILESDIR}"/wine-1.1.15-winegcc.patch #260726
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

config_cache() {
	local h ans="no"
	use $1 && ans="yes"
	shift
	for h in "$@" ; do
		[[ ${h} == *.h ]] \
			&& h=header_${h} \
			|| h=lib_${h}
		export ac_cv_${h//[:\/.]/_}=${ans}
	done
}

src_configure() {
	export LDCONFIG=/bin/true

	use esd     || export ac_cv_path_ESDCONFIG=""
	use scanner || export ac_cv_path_sane_devel="no"
	config_cache jack jack/jack.h
	config_cache cups cups/cups.h
	config_cache alsa alsa/asoundlib.h sys/asoundlib.h asound:snd_pcm_open
	config_cache nas audio/audiolib.h audio/soundlib.h
	config_cache xml libxml/parser.h libxslt/pattern.h libxslt/transform.h
	config_cache ldap ldap.h lber.h
	config_cache dbus dbus/dbus.h
	config_cache hal hal/libhal.h
	config_cache jpeg jpeglib.h
	config_cache oss sys/soundcard.h machine/soundcard.h soundcard.h
	config_cache lcms lcms.h

	use amd64 && ! use win64 && multilib_toolchain_setup x86

	# XXX: should check out these flags too:
	#	audioio capi fontconfig freetype gphoto
	econf \
		--sysconfdir=/etc/wine \
		$(use_with alsa) \
		$(use_with cups) \
		$(use_with esd) \
		$(use_with gnutls) \
		$(use_with jack) \
		$(use_with jpeg) \
		$(use_with lcms cms) \
		$(use_with nas) \
		$(use_with ncurses curses) \
		$(use_with opengl) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with ssl openssl) \
		$(use_enable win64) \
		$(use_with X x) \
		$(use_with xcomposite) \
		$(use_with xinerama) \
		$(use_with xml) \
		$(use_with xml xslt) \
		|| die "configure failed"

#		$(use_with ldap) \
#		$(! use dbus && echo --without-hal || use_with hal) \
#		$(use_with scanner sane) \

	emake -j1 depend || die "depend"
}

src_compile() {
	emake all || die "all"
}

src_install() {
	make DESTDIR="${D}" initdir=/etc/init.d sysconfdir=/etc install || die
	dodoc ANNOUNCE AUTHORS ChangeLog README

#	if use gecko ; then
#		insinto /usr/share/wine/gecko
#		doins "${DISTDIR}"/wine_gecko-${GV}.cab || die
#	fi

	cp "${FILESDIR}"/*.fon ${D}/usr/share/wine/fonts/
	cp "${FILESDIR}"/*.ttf ${D}/usr/share/wine/fonts/

	rm -f ${D}/etc/init.d/*
	newinitd ${FILESDIR}/wine.initd wine

	keepdir /var/lib/wine
	fperms g+w /var/lib/wine
	fowners root:wineadmin /var/lib/wine
}

