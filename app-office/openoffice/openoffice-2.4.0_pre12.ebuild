# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"

inherit autotools check-reqs db-use eutils fdo-mime flag-o-matic java-pkg-opt-2 kde-functions mono multilib

IUSE="access binfilter branding cups dbus debug eds firefox gnome gstreamer gtk
helpless jemalloc kde ldap mono odbc odk opengl openxml pam seamonkey webdav
xulrunner"

LANGS="af ar as_IN be_BY bg bn br bs ca cs cy da de dz el en_GB en_US en_ZA eo
es et fa fi fr ga gl gu_IN he hi_IN hr hu it ja km ko ku lt lv mk ml_IN mr_IN nb
ne nl nn nr ns or_IN pa_IN pl pt pt_BR ru rw sh_YU sk sl sr_CS ss st sv sw_TZ
ta_IN te_IN tg th ti_ER tn tr ts uk ur_IN ve vi xh zh_CN zh_TW zu"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

MILE="${PV/*_pre/m}"
PATCHLEVEL="OOH680"
SRC="ooh680-${MILE}"
S="${WORKDIR}/ooo-build"

DESCRIPTION="OpenOffice.org, unstable 2.x development sources."
HOMEPAGE="http://go-oo.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
RESTRICT="binchecks mirror splitdebug"

#OOSRC="mirror://openoffice/stable/${PV/_*}/OOo_${PV/_*}_src"
#OOSRC="mirror://openoffice/developer/${PATCHLEVEL}_${MILE}/OOo_${PATCHLEVEL}_${MILE}_src"
GOSRC="http://download.go-oo.org"
SRC_URI="${GOSRC}/${PATCHLEVEL}/${SRC}-core.tar.bz2
	${GOSRC}/${PATCHLEVEL}/${SRC}-lang.tar.bz2
	binfilter? ( ${GOSRC}/${PATCHLEVEL}/${SRC}-binfilter.tar.bz2 )
	mono? ( ${GOSRC}/${PATCHLEVEL}/cli_types.dll
		${GOSRC}/${PATCHLEVEL}/cli_types_bridgetest.dll )
	odk? ( ${GOSRC}/${PATCHLEVEL}/${SRC}-sdk_oo.tar.bz2
		http://tools.openoffice.org/unowinreg_prebuild/680/unowinreg.dll )
	${GOSRC}/${PATCHLEVEL}/ooo-build-2.4.0.3.2.tar.gz
	${GOSRC}/SRC680/libwps-0.1.2.tar.gz
	${GOSRC}/SRC680/libwpg-0.1.2.tar.gz
	${GOSRC}/SRC680/writerfilter.2008-02-29.tar.bz2
	${GOSRC}/SRC680/lp_solve_5.5.0.10_source.tar.gz
	${GOSRC}/SRC680/oox.2008-02-29.tar.bz2
	${GOSRC}/SRC680/extras-2.tar.bz2
	${GOSRC}/SRC680/biblio.tar.bz2
	http://geki.ath.cx/hacks/ooo30-chart2-images.tar.bz2"

#	${GOSRC}/${PATCHLEVEL}/ooo-build-${SRC}.tar.gz

NSS_DEP=">=dev-libs/nspr-4.6.2
	>=dev-libs/nss-3.11-r1"

CDEPEND="!app-office/openoffice-bin
	access? ( >=app-office/mdbtools-0.6_pre20051109 )
	cups? ( net-print/cups )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	gtk? ( >=x11-libs/cairo-1.4.10
		>=x11-libs/gtk+-2.10 )
	gnome? ( >=x11-libs/cairo-1.4.10
		>=x11-libs/gtk+-2.10
		>=gnome-base/gnome-vfs-2.12
		>=gnome-base/gconf-2.12 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	!xulrunner? (
		!seamonkey? (
			firefox? ( www-client/mozilla-firefox ${NSS_DEP} )
		) seamonkey? ( www-client/seamonkey ${NSS_DEP} )
	) xulrunner? ( net-libs/xulrunner ${NSS_DEP} )
	gstreamer? ( >=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	java? ( >=dev-java/bsh-2.0_beta4
		>=dev-db/hsqldb-1.8.0.4
		>=dev-java/xalan-2.7
		>=dev-java/xalan-serializer-2.7
		>=dev-java/xerces-2.7
		dev-java/rhino:1.5
		dev-java/xml-commons-external:1.3 )
	kde? ( =kde-base/kdelibs-3* )
	ldap? ( net-nds/openldap )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )
	mono? ( >=dev-lang/mono-1.2.3.1 )
	opengl? ( virtual/opengl
		virtual/glu )
	webdav? ( >=net-misc/neon-0.26
			  >=dev-libs/openssl-0.9.8g )
	>=app-admin/eselect-oodict-20060706
	>=app-text/hunspell-1.1.4-r1
	>=app-text/libwpd-0.8.14
	>=dev-lang/python-2.3.4
	  dev-libs/expat
	>=dev-libs/glib-2.12
	>=dev-libs/icu-3.8.1
	>=dev-libs/libxml2-2.0
	  dev-libs/libxslt
	>=dev-libs/xmlsec-1.2.11
	>=dev-util/gperf-3.0.0
	>=media-libs/fontconfig-2.3
	>=media-libs/freetype-2.1.10-r2
	  media-libs/jpeg
	  media-libs/libpng
	>=media-libs/libsvg-0.1.4
	>=media-libs/vigra-1.4
	>=net-misc/curl-7.9.8
	>=sys-libs/db-4.3
	  sys-libs/zlib
	  x11-libs/libXaw
	  x11-libs/libXinerama
	>=x11-libs/startup-notification-0.5"

RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.4 )"

DEPEND="${CDEPEND}
	!dev-util/dmake
	java? ( >=virtual/jdk-1.4
		dev-java/ant-core )
	odbc? ( dev-db/unixODBC )
	pam? ( sys-libs/pam )
	  app-arch/unzip
	  app-arch/zip
	>=dev-lang/perl-5.0
	>=dev-libs/boost-1.33.1
	  dev-perl/Archive-Zip
	  dev-util/intltool
	  dev-util/pkgconfig
	  sys-apps/coreutils
	  sys-apps/grep
	  sys-apps/sed
	>=sys-apps/findutils-4.1.20-r1
	  sys-devel/bison
	  sys-devel/flex
	  x11-libs/libXrender
	  x11-proto/printproto
	  x11-proto/xextproto
	  x11-proto/xineramaproto
	  x11-proto/xproto"

PROVIDE="virtual/ooo"

pkg_setup() {
	if use xulrunner; then
		if pkg-config --exists xulrunner-xpcom; then
			xul="xulrunner"
		elif pkg-config --exists libxul; then
			xul="libxul"
		else
			die "USE flag [xulrunner] set but not found!"
		fi
	fi

	if ! built_with_use dev-libs/xmlsec mozilla; then
		eerror "xmlsec built without nss support!"
		eerror "emerge it with USE=\"mozilla\""
		die "bad luck"
	fi

	if is-flagq -ffast-math; then
		eerror "You are using -ffast-math, which is known to cause problems."
		eerror "Please remove it from your CFLAGS, using this globally causes"
		eerror "all sorts of problems."
		eerror "After that you will also have to - at least - rebuild python"
		eerror "otherwise the openoffice build will break."
		die "bad luck"
	fi

	if use jemalloc; then
		local je="/usr/$(get_libdir)/libjemalloc.so"
		[ -e ${je} ] || die "USE flag [jemalloc] set but library not found! (${je})"
	fi

	CHECKREQS_MEMORY="512"
	use debug && CHECKREQS_DISK_BUILD="12000" \
		|| CHECKREQS_DISK_BUILD="6000"
	use debug && CHECKREQS_DISK_USR="1024" \
		|| CHECKREQS_DISK_USR="512"
	check_reqs

	echo
	ewarn "This openoffice version uses an experimental patchset."
	ewarn "Things could just break."
	ewarn

	strip-linguas ${LANGS}

	if [ -z "${LINGUAS}" ]; then
		export LINGUAS_OOO="en-US"
		ewarn "To get a localized build, set the according LINGUAS variable(s)."
		ewarn
	else
		export LINGUAS_OOO="${LINGUAS//_/-}"
	fi

	java-pkg-opt-2_pkg_setup

	if ! use java; then
		ewarn "You are building with java-support disabled, this results in some"
		ewarn "of the OpenOffice.org functionality being disabled."
		ewarn "If something you need does not work for you, rebuild with"
		ewarn "java in your USE-flags."
		ewarn
	fi
}

src_unpack() {
	unpack ooo-build-${SRC}.tar.gz

	cd ${S}
	epatch ${FILESDIR}/config.diff
	epatch ${FILESDIR}/fix-automake.diff
	epatch ${FILESDIR}/unpack_only-required.diff
	epatch ${FILESDIR}/unpack_ooo30-chart2-images.diff
	epatch ${FILESDIR}/env_log.diff
	epatch ${FILESDIR}/build-java-target-update.diff

	# ooo30 chart2 features, etc.
	cp ${FILESDIR}/cws-chart*.diff patches/src680
	cp ${FILESDIR}/system-*.diff patches/src680
	cp ${FILESDIR}/jemalloc.diff patches/src680

	# gentoo
	local CONFFILE="${S}/distro-configs/GentooUnstable.conf.in"
	cp ${S}/distro-configs/Gentoo.conf.in ${CONFFILE}
	echo "--with-build-version=\\\"geki built ${PV} (unsupported)\\\"" >> ${CONFFILE}
	use branding && echo "--with-intro-bitmaps=\\\"${S}/src/openintro_gentoo.bmp\\\"" >> ${CONFFILE}

	# gentooexperimental defaults
	use jemalloc && echo "--with-alloc=jemalloc" >> ${CONFFILE}
	echo "--without-afms" >> ${CONFFILE}
	echo "--without-agfa-monotype-fonts" >> ${CONFFILE}
	echo "--without-ppds" >> ${CONFFILE}
	echo "--with-vba-package-format=extn" >> ${CONFFILE}
	echo "--enable-sdext" >> ${CONFFILE}
	echo "--disable-reportdesign" >> ${CONFFILE}

	# internal
	echo "`use_enable binfilter`" >> ${CONFFILE}
	echo "`use_enable dbus`" >> ${CONFFILE}
	echo "`use_enable debug crashdump`" >> ${CONFFILE}
	echo "`use_enable helpless separate-helpcontent`" >> ${CONFFILE}

	# system
	echo "`use_enable cups`" >> ${CONFFILE}
	echo "`use_enable eds evolution2`" >> ${CONFFILE}
	echo "`use_enable ldap`" >> ${CONFFILE}
	echo "`use_with ldap openldap`" >> ${CONFFILE}
	echo "`use_enable mono`" >> ${CONFFILE}
	echo "`use_with odbc system-odbc-headers`" >> ${CONFFILE}
	echo "`use_enable opengl`" >> ${CONFFILE}
	echo "`use_enable webdav neon`" >> ${CONFFILE}
	echo "`use_with webdav system-neon`" >> ${CONFFILE}
	echo "`use_with webdav system-openssl`" >> ${CONFFILE}

	# browser
	if use firefox || use seamonkey || use xulrunner ; then
		echo "--enable-mozilla" >> ${CONFFILE}
		declare mozilla
		use firefox && mozilla="firefox"
		use seamonkey && mozilla="seamonkey"
		use xulrunner && mozilla="${xul}"
		echo "--with-system-mozilla=${mozilla}" >> ${CONFFILE}
	else
		echo "--disable-mozilla" >> ${CONFFILE}
		echo "--without-system-mozilla" >> ${CONFFILE}
	fi

	# gnome
	if use gtk || use gnome ; then
		echo "--enable-lockdown" >> ${CONFFILE}
		echo "--enable-atkbridge" >> ${CONFFILE}
	fi
	echo "`use_enable gnome gnome-vfs`" >> ${CONFFILE}
	echo "`use_enable gstreamer`" >> ${CONFFILE}

	# java
	if use java ; then
		echo "--with-ant-home=${ANT_HOME}" >> ${CONFFILE}
		echo "--with-jdk-home=$(java-config --jdk-home 2>/dev/null)" >> ${CONFFILE}
		echo "--with-java-target-version=1.4" >> ${CONFFILE}
		echo "--with-system-beanshell" >> ${CONFFILE}
		echo "--with-system-hsqldb" >> ${CONFFILE}
		echo "--with-system-xalan" >> ${CONFFILE}
		echo "--with-system-xerces" >> ${CONFFILE}
		echo "--with-system-rhino" >> ${CONFFILE}
		echo "--with-system-xml-apis" >> ${CONFFILE}
		echo "--with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)" >> ${CONFFILE}
		echo "--with-hsqldb-jar=$(java-pkg_getjar hsqldb hsqldb.jar)" >> ${CONFFILE}
		echo "--with-serializer-jar=$(java-pkg_getjar xalan-serializer serializer.jar)" >> ${CONFFILE}
		echo "--with-xalan-jar=$(java-pkg_getjar xalan xalan.jar)" >> ${CONFFILE}
		echo "--with-xerces-jar=$(java-pkg_getjar xerces-2 xercesImpl.jar)" >> ${CONFFILE}
		echo "--with-rhino-jar=$(java-pkg_getjar rhino-1.5 js.jar)" >> ${CONFFILE}
		echo "--with-xml-apis-jar=$(java-pkg_getjar xml-commons-external-1.3 xml-apis.jar)" >> ${CONFFILE}
	fi

	# to be removed!
	echo "--disable-pasf" >> ${CONFFILE}

	eautoreconf
}

src_compile() {
	filter-flags "-funroll-loops"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	replace-flags "-O3" "-O2"
#	append-flags "-w"
	use opengl && append-flags -DGL_GLEXT_PROTOTYPES

	use debug && append-flags -g \
		|| export LINKFLAGSOPTIMIZE="${LDFLAGS}"
	export ARCH_FLAGS="${CXXFLAGS}"
	local JOBS="`grep ^processor /proc/cpuinfo | wc -l`"

	local myconf="--disable-gtk --disable-cairo --without-system-cairo"
	( use gtk || use gnome ) &&	myconf="--enable-gtk --enable-cairo --with-system-cairo"

	cd ${S}
	./configure \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man \
		--with-distro="GentooUnstable" \
		--with-arch="${ARCH}" \
		--with-srcdir="${DISTDIR}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-num-cpus="${JOBS}" \
		--with-binsuffix=no \
		--with-installed-ooo-dirname=openoffice \
		--with-tag="${SRC}" \
		--disable-post-install-scripts \
		--enable-hunspell \
		--with-system-hunspell \
		--with-system-libsvg \
		--with-system-libwpd \
		${myconf} \
		`use_enable kde` \
		`use_enable !debug strip` \
		`use_with java` \
		`use_enable access` \
		`use_with access system-mdbtools` \
		`use_enable openxml` \
		`use_enable mono` \
		`use_enable pam` \
		`use_enable odk` \
		|| die "configure failed"

	use kde && set-kdedir 3
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"

	# copy presentation minimizer
	cp ${S}/build/${SRC}/solver/*/*/bin/minimizer/sun-presentation-minimizer.oxt \
		${D}/usr/$(get_libdir)/openoffice/program/addin/ \
		|| die "presentation minimizer not found!"

	chown -R root:root ${D}

	use java && java-pkg_regjar ${D}/usr/$(get_libdir)/${PN}/program/classes/*.jar
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	eselect oodict update --libdir $(get_libdir)

	[ -x /sbin/chpax ] && [ -e /usr/$(get_libdir)/${PN}/program/soffice.bin ] \
		&& chpax -zm /usr/$(get_libdir)/${PN}/program/soffice.bin

	/usr/$(get_libdir)/${PN}/program/java-set-classpath \
		$(java-config --classpath=jdbc-mysql 2>/dev/null) >/dev/null

	# javaldx got issues...
	cp ${S}/build/${SRC}/solver/*/*/lib/sunjavapluginrc \
		${D}/usr/$(get_libdir)/openoffice/program/ \
		|| die "java plugin config not found!"

	elog " To start OpenOffice.org, run:"
	elog
	elog " $ ooffice"
	elog
	elog "__________________________________________________________________"
	elog " Also, for individual components, you can use any of:"
	elog
	elog " oobase, oocalc, oodraw, oofromtemplate,"
	elog " ooimpress, oomath, ooweb or oowriter"
	elog
	elog "__________________________________________________________________"
	elog " Spell checking is now provided through our own myspell-ebuilds,"
	elog " if you want to use it, please install the correct myspell package"
	elog " according to your language needs."
	elog
	elog "__________________________________________________________________"
	elog " Some parts have to be enabled via Extension Manager now:"
	elog " - VBA"
	elog " - presentation minimizer"
	elog " - more may come"
}
