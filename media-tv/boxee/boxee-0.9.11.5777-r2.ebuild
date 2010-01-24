# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools eutils flag-o-matic

FLASHLIB="flashlib-shared-5765"

SRC_URI="http://dl.boxee.tv/${P}-src.tar.bz2
		http://dl.boxee.tv/${FLASHLIB}.tar.gz
		http://0xc0dedbad.com/files/${PN}/${PN}-binary-overlay-r1.tbz2"
DESCRIPTION="Boxee is a fork of XBMC with a focus on social media"
HOMEPAGE="http://www.boxee.tv/"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug joystick opengl profile"
RESTRICT="mirror bindist strict"

RDEPEND="opengl? ( virtual/opengl )
	app-arch/bzip2
	app-arch/unrar
	app-arch/unzip
	amd64? ( app-emulation/emul-linux-x86-xlibs
			app-emulation/emul-linux-x86-gtklibs
			app-emulation/emul-linux-x86-nspr
			app-emulation/emul-linux-x86-libcurl )
	app-i18n/enca
	>=dev-lang/python-2.4
	dev-libs/boost
	dev-libs/fribidi
	dev-libs/libpcre
	dev-libs/lzo
	dev-libs/tre
	>=dev-python/pysqlite-2
	media-libs/alsa-lib
	media-libs/faac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glew
	media-libs/jasper
	media-libs/libmad
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsdl[alsa,X]
	media-libs/sdl-gfx
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-sound
	net-libs/xulrunner-bin
	net-misc/curl
	sys-apps/dbus
	sys-apps/hal
	sys-apps/pmount
	virtual/mysql
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	x11-proto/xineramaproto
	dev-util/cmake
	app-misc/screen
	x86? ( dev-lang/nasm
			virtual/krb5 )"

RESTRICT="strip"

S=${WORKDIR}/${P}-src

src_unpack() {
	local pic
	my_arch=i486
	use amd64 && my_arch=x86_64
	my_prefix=/opt/${PN}

	unpack ${A}
	cd "${S}"
	skiplist="${FILESDIR}/${PV}-fribidi_0.19.patch"
	for patch in ${FILESDIR}/${PV}-*.patch ; do
		for skip in $skiplist ; do
			if [[ $skip == $patch ]] ; then
				continue 2
			fi
		done
		epatch "${patch}" || die "Patch failed"
	done
	has_version '>=dev-libs/fribidi-0.19' && epatch "${FILESDIR}/${PV}-fribidi_0.19.patch"
	cd "${WORKDIR}/binaries"
	for file in `find . -type f` ; do
		mv "${file}" "${S}/${file}" || die "Unable to mv file ${file}"
	done
	rm -rf "${WORKDIR}/binaries"

	# Create flashlib Makefile
	use amd64 && pic="-fPIC"
	cd "${WORKDIR}/flashlib-shared"
	epatch "${FILESDIR}/flashlib-Makefile.patch" || die "Patch failed"
	sed -e "s#@ARCH@#${my_arch}#g" -i Makefile || die "sed failed."
	sed -e "s#@PIC@#${pic}#g" -i Makefile || die "sed failed."

	cd "${S}"
	# Prevent Mac OSX files being installed #
	rm -rf system/python/lib-osx/
	rm system/players/dvdplayer/*-osx*

	for dir in \
		. \
		xbmc/lib/libBoxee/tinyxpath \
		xbmc/cores/dvdplayer/Codecs/libmad
	do
		cd "${S}"/"${dir}"
		eautoreconf
	done
	cd "${S}"

	sed -e 's#\((cd tinyxpath; autoconf; aclocal; automake;\)\( ./configure -C)\)#\1 LDFLAGS=""\2#g' -i xbmc/lib/libBoxee/Makefile || die "sed failed."

}

src_prepare() {
	use profile && filter-flags "-fomit-frame-pointer"
}

src_configure() {
	econf \
		--disable-ccache \
		--prefix=${my_prefix} \
		$(use_enable debug) \
		$(use_enable profile profiling) \
		$(use_enable joystick) \
		$(use_enable opengl gl) \
		|| die "Configure failed!"
}

src_compile() {
	cd "${WORKDIR}/flashlib-shared"
	make || die "Make flashlib failed!"
	cp "${WORKDIR}/flashlib-shared/FlashLib-x86_64-linux.so" "${S}/system/players/flashplayer"

	cd "${S}"
	emake -j1 || die "Make boxee failed!"
}

src_install() {
	cd "${S}"

	insinto ${my_prefix}/language
	doins -r language/*

	insinto ${my_prefix}/media
	doins	media/defaultrss.png \
			media/downloadrss.png \
			media/weather.rar
	doins -r media/boxee_screen_saver

	insinto ${my_prefix}/media/Fonts
	doins media/Fonts/boxee*

	insinto ${my_prefix}/screensavers
	doins screensavers/*.xbs

	insinto ${my_prefix}
	#doins -r plugins
	rm -f scripts/Lyrics/resources/skins/Boxee/720p
	rm -f scripts/Lyrics/resources/skins/Default/720p
	doins -r scripts
	dosym PAL ${my_prefix}/scripts/Lyrics/resources/skins/Boxee/720p
	dosym PAL ${my_prefix}/scripts/Lyrics/resources/skins/Default/720p

	insinto ${my_prefix}/skin
	doins -r skin/Boxee*

	exeinto ${my_prefix}/system
	doexe system/*-${my_arch}-linux.so
	insinto ${my_prefix}/system
	doins -r system/scrapers
	doins system/rtorrent.rc.linux

	for player in system/players/* ; do
		exeinto ${my_prefix}/system/players/$(basename ${player})
		doexe ${player}/*-${my_arch}-linux.so
	done

	# FIXME: flashplayer is closed and builds don't exist for x86_64!
	exeinto ${my_prefix}/system/players/flashplayer
	doexe	system/players/flashplayer/*linux* \
			system/players/flashplayer/bxoverride.so
	insinto ${my_prefix}/system/players/flashplayer
	doins -r system/players/flashplayer/boxeejs
	dodir xulrunner
	dosym /opt/xulrunner ${my_prefix}/system/players/flashplayer/xulrunner/bin
	exeinto /opt/xulrunner/plugins
	doexe system/players/flashplayer/xulrunner-i486-linux/bin/plugins/libflashplayer.so
	
	exeinto ${my_prefix}/system/python
	doexe system/python/*-${my_arch}-linux.so

	rm -rf xbmc/lib/libPython/Python/Lib/test
	exeinto ${my_prefix}/system/python/lib
	doexe xbmc/lib/libPython/Python/build/lib.linux-${HOSTTYPE}-2.4/*.so

	insinto ${my_prefix}/system/python/lib
	for base in "${S}/system/python/lib" "${S}/xbmc/lib/libPython/Python/Lib" ; do
		for del in $(find ${base} -name plat-\*) ; do
			if [[ "`basename ${del}`" != "plat-linux2" ]] ; then 
				rm -rf ${del}
			fi
		done
		for suffix in pyo py ; do
			for file in $(find ${base} -iname \*.${suffix}) ; do
				dir=$(dirname ${file} | sed -e "s#^${base}/*##g")
				if [[ "${dir}" != "${last_dir}" ]] ; then
					last_dir="${dir}"
					insinto "${my_prefix}/system/python/lib/${dir}"
				fi
				doins ${file}
			done
		done
	done

	# FIXME: Don't exist for x86_64!
	if use amd64 ; then
		ewarn "cdrip libraries do not exist for x86_64!"
	else
		exeinto ${my_prefix}/system/cdrip
		doexe system/cdrip/*-${my_arch}-linux.so
	fi

	insinto ${my_prefix}/UserData
	cp -f UserData/sources.xml.in.diff.linux UserData/sources.xml
	cp -f UserData/advancedsettings.xml.in UserData/advancedsettings.xml
	doins UserData/*.xml
	dosym UserData ${my_prefix}/userdata

	insinto ${my_prefix}/system
	doins system/*.xml
	doins system/asound.conf
	doins -r system/scrapers

	insinto ${my_prefix}/visualisations
	doins	visualisations/Goom.vis \
			visualisations/Waveform.vis \
			visualisations/opengl_spectrum.vis \
			visualisations/projectM.vis
	doins -r	visualisations/projectM \
				visualisations/projectM.presets
	
	exeinto ${my_prefix}/bin
	doexe bin-linux/boxee-rtorrent

	mv run-boxee-desktop.in run-boxee-desktop
	exeinto ${my_prefix}
	doexe Boxee
	doexe run-boxee-desktop
	doexe give_me_my_mouse_back
	doexe xbmc-xrandr

	dodir /opt/bin
	dosym ${my_prefix}/run-boxee-desktop /opt/bin/boxee

	insinto /usr/share/applications
	doins tools/Linux/boxee.desktop
	insinto /usr/share/pixmaps
	doins tools/Linux/boxee.png

	dodir /etc/env.d
	echo "CONFIG_PROTECT=\"${my_prefix}/UserData\"" > "${D}/etc/env.d/95boxee"
}
