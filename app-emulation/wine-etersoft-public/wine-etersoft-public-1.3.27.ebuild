# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-1.1.25.ebuild,v 1.2 2009/08/01 06:58:00 ssuominen Exp $

EAPI="2"

AUTOTOOLS_AUTO_DEPEND="no"
inherit eutils flag-o-matic multilib autotools
# rpm

GV="1.3"
DESCRIPTION="MS Windows compatibility layer (WINE@Etersoft public edition)"
HOMEPAGE="http://etersoft.ru/wine"
SRC_URI="ftp://updates.etersoft.ru/pub/Etersoft/Wine-public/${PV/_/-}/sources/wine-${PV}-alt1.src.rpm
	gecko? (
		mirror://sourceforge/wine/wine_gecko-${GV}-x86.msi
		win64? ( mirror://sourceforge/wine/wine_gecko-${GV}-x86_64.msi )
	)"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86 ~x86-fbsd"
IUSE="alsa capi cups custom-cflags dbus fontconfig gecko gnutls gphoto2 gsm gstreamer hardened jpeg lcms ldap mp3 ncurses nls openal opencl opengl oss +perl png samba scanner ssl test +threads +truetype v4l +win32 +win64 X xcomposite xinerama xml"
RESTRICT="test" #72375

S=${WORKDIR}/wine-${PV}

MLIB_DEPS="amd64? (
	truetype? ( >=app-emulation/emul-linux-x86-xlibs-2.1 )
	X? (
		>=app-emulation/emul-linux-x86-xlibs-2.1
		>=app-emulation/emul-linux-x86-soundlibs-2.1
	)
	mp3? ( app-emulation/emul-linux-x86-soundlibs )
	openal? ( app-emulation/emul-linux-x86-sdl )
	opengl? ( app-emulation/emul-linux-x86-opengl )
	scanner? ( app-emulation/emul-linux-x86-medialibs )
	v4l? ( app-emulation/emul-linux-x86-medialibs )
	app-emulation/emul-linux-x86-baselibs
	>=sys-kernel/linux-headers-2.6
	)"
RDEPEND="truetype? ( >=media-libs/freetype-2.0.0 media-fonts/corefonts )
	perl? ( dev-lang/perl dev-perl/XML-Simple )
	capi? ( net-dialup/capi4k-utils )
	ncurses? ( >=sys-libs/ncurses-5.2 )
	fontconfig? ( media-libs/fontconfig )
	gphoto2? ( media-libs/libgphoto2 )
	openal? ( media-libs/openal )
	dbus? ( sys-apps/dbus )
	gnutls? ( net-libs/gnutls )
	gstreamer? ( media-libs/gstreamer media-libs/gst-plugins-base )
	X? (
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage
	)
	xinerama? ( x11-libs/libXinerama )
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	opencl? ( x11-drivers/nvidia-drivers >=dev-util/nvidia-cuda-toolkit-3.1 )
	opengl? ( virtual/opengl )
	gsm? ( media-sound/gsm )
	jpeg? ( virtual/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( =media-libs/lcms-1* )
	mp3? ( >=media-sound/mpg123-1.5.0 )
	nls? ( sys-devel/gettext )
	samba? ( >=net-fs/samba-3.0.25 )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	scanner? ( media-gfx/sane-backends )
	ssl? ( dev-libs/openssl )
	png? ( media-libs/libpng )
	v4l? ( media-libs/libv4l )
	!win64? ( ${MLIB_DEPS} )
	win32? ( ${MLIB_DEPS} )
	xcomposite? ( x11-libs/libXcomposite )"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	xinerama? ( x11-proto/xineramaproto )
	!hardened? ( sys-devel/prelink )
	virtual/yacc
	sys-devel/flex"

#src_unpack() {
#	rpm_src_unpack
#	tar xf wine-${PV}.tar
#}

src_unpack() {
	addwrite /var/lib/rpm
	alien -t ${DISTDIR}/wine-${PV}-alt1.src.rpm
	tar xf wine-${PV}.tgz
	tar xf wine-${PV}.tar
	rm wine-${PV}.tgz wine-${PV}.tar
}

src_prepare() {
	epatch "${FILESDIR}"/wine-1.1.15-winegcc.patch #260726
	epatch_user #282735
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

do_configure() {
	local builddir="${WORKDIR}/wine$1"
	mkdir -p "${builddir}"
	pushd "${builddir}" >/dev/null

	ECONF_SOURCE=${S} \
	econf \
		--sysconfdir=/etc/wine \
		$(use_with alsa) \
		$(use_with capi) \
		$(use_with lcms cms) \
		$(use_with cups) \
		$(use_with ncurses curses) \
		$(use_with fontconfig) \
		$(use_with gnutls) \
		$(use_with gphoto2 gphoto) \
		$(use_with gsm) \
		$(use_with gstreamer) \
		--without-hal \
		$(use_with jpeg) \
		$(use_with ldap) \
		$(use_with mp3 mpg123) \
		$(use_with nls gettextpo) \
		$(use_with openal) \
		$(use_with opencl) \
		$(use_with opengl) \
		$(use_with ssl openssl) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with threads pthread) \
		$(use_with scanner sane) \
		$(use_enable test tests) \
		$(use_with truetype freetype) \
		$(use_with v4l) \
		$(use_with X x) \
		$(use_with xcomposite) \
		$(use_with xinerama) \
		$(use_with xml) \
		$(use_with xml xslt) \
		$2

	emake -j1 depend || die "depend"

	popd >/dev/null
}
src_configure() {
	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags

	if use win64 ; then
		do_configure 64 --enable-win64
		use win32 && ABI=x86 do_configure 32 --with-wine64=../wine64
	else
		ABI=x86 do_configure 32 --disable-win64
	fi
}

src_compile() {
	local b
	for b in 64 32 ; do
		local builddir="${WORKDIR}/wine${b}"
		[[ -d ${builddir} ]] || continue
		emake -C "${builddir}" all || die
	done
}

src_install() {
	local b

	cd ${S}/tools
	for b in 64 32 ; do
		[[ -d "${WORKDIR}/wine${b}" ]] || continue
		cp udev*.rules wine.desktop "${WORKDIR}/wine${b}/tools"
	done
	cd ${S}

	for b in 64 32 ; do
		local builddir="${WORKDIR}/wine${b}"
		[[ -d ${builddir} ]] || continue
		emake -C "${builddir}" install DESTDIR="${D}" || die
	done
	dodoc ANNOUNCE AUTHORS README
	if use gecko ; then
		insinto /usr/share/wine/gecko
		doins "${DISTDIR}"/wine_gecko-${GV}-x86.msi || die
		use win64 && { doins "${DISTDIR}"/wine_gecko-${GV}-x86_64.msi || die ; }
	fi
	if ! use perl ; then
		rm "${D}"/usr/bin/{wine{dump,maker},function_grep.pl} "${D}"/usr/share/man/man1/wine{dump,maker}.1 || die
	fi

	rm -f ${D}/etc/init.d/*
	newinitd ${FILESDIR}/wine.initd wine

	keepdir /var/lib/wine
	fperms g+w /var/lib/wine
	fowners root:wineadmin /var/lib/wine
}

pkg_postinst() {
	paxctl -psmr "${ROOT}"/usr/bin/wine{,-preloader} 2>/dev/null #255055
}

