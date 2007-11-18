# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic multilib

DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"
# FIXME: any better way?
# WINEVER=20071012
WINEVER=20071109
# WINENUMVERSION=${WINENUMVERSION:-1.0}
WINENUMVERSION=${PV}
SRC_URI="ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft-$WINENUMVERSION/sources/tarball/wine-$WINEVER.tar.bz2
	 ftp://updates.etersoft.ru/pub/Etersoft/WINE@Etersoft-$WINENUMVERSION/sources/tarball/wine-etersoft-public-$WINEVER.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="alsa arts cups dbus esd hal jack jpeg lcms ldap nas ncurses opengl oss scanner xml X"
RESTRICT="test" #72375

RDEPEND=">=media-libs/freetype-2.0.0
	media-fonts/corefonts
	ncurses? ( >=sys-libs/ncurses-5.2 )
	jack? ( media-sound/jack-audio-connection-kit )
	dbus? ( sys-apps/dbus )
	hal? ( sys-apps/hal )
	X? (
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage

	)
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
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
	amd64? (
		>=app-emulation/emul-linux-x86-xlibs-2.1
		>=app-emulation/emul-linux-x86-soundlibs-2.1
		>=sys-kernel/linux-headers-2.6
	)
	!app-emulation/wine"

DEPEND="${RDEPEND}
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	sys-devel/bison
	sys-devel/flex"

# this will not build as 64bit code
#export ABI=x86

src_unpack() {
	unpack wine-$WINEVER.tar.bz2
	unpack wine-etersoft-public-$WINEVER.tar.bz2
	cd "${WORKDIR}"/wine-$WINEVER/ || die
	patch -p0 <etersoft/wine-etersoft.patch
	#epatch etersoft/wine-etersoft.patch
	#epatch "${FILESDIR}"/wineprefixcreate.in.patch

	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in
	epatch "${FILESDIR}"/wine-gentoo-no-ssp.patch #66002
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785

	#Do not pack private part now
	#cp ${DISTDIR}/wine-etersoft-1.0.local.tgz ${WORKDIR}
	#cd "${WORKDIR}"
	#mkdir "${WORKDIR}"/private
	#tar -xzf wine-etersoft-1.0.local.tgz -C "${WORKDIR}"/private
	autoconf
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

src_compile() {
	export LDCONFIG=/bin/true
	use arts    || export ac_cv_path_ARTSCCONFIG=""
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
	#use x86 && config_cache truetype freetype:FT_Init_FreeType

	strip-flags

	use amd64 && multilib_toolchain_setup x86

	#	$(use_enable amd64 win64)
	cd "${WORKDIR}"/wine-$WINEVER/
	econf \
		CC=$(tc-getCC) \
		--sysconfdir=/etc/wine \
		$(use_with opengl) \
		$(use_with X x) \
		$(use_with ncurses curses) \
		$(use_enable debug trace) \
		$(use_enable debug) \
		|| die "configure failed"

	emake -j1 depend || die "depend"
	emake all || die "all"
}

src_install() {
	cd "${WORKDIR}"/wine-$WINEVER/
	make DESTDIR="${D}" install || die

	make -C etersoft install prefix=${D}/usr initdir=${D}/etc/init.d sysconfdir=${D}/etc
	
	rm -f ${D}/etc/init.d/*
	newinitd ${FILESDIR}/wine.init wine
}

pkg_postinst() {
	elog "~/.wine/config is now deprecated.  For configuration either use"
	elog "winecfg or regedit HKCU\\Software\\Wine"
}
