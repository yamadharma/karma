# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit check-reqs db-use eutils fdo-mime flag-o-matic java-pkg-opt-2 kde-functions mono multilib versionator

IUSE="access binfilter branding cups dbus debug eds firefox gcj gnome gstreamer
kde ldap mono nas sound odbc odk pam seamonkey webdav xt"

LANGS="af ar be_BY bg bn bs ca cs cy da de el en_GB en_US en_ZA es et fa fi fr
gu_IN he hi_IN hr hu it ja km ko lt lv mk nb nl nn nr ns pa_IN pl pt pt_BR ru rw
sh_YU sk sl sr_CS st sv sw_TZ th tn tr ts vi xh zh_CN zh_TW zu"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

#PATCHLEVEL="SRC680"
#SRC="src680-m$(get_version_component_range 2)"
PATCHLEVEL="OOE680"
SRC="ooe680-m6"
S="${WORKDIR}/ooo-build"

DESCRIPTION="OpenOffice.org, unstable 2.x development sources."
HOMEPAGE="http://go-oo.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc ~x86"
RESTRICT="binchecks strip"

SRC_URI="http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-core.tar.bz2
	http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-lang.tar.bz2
	binfilter? ( http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-binfilter.tar.bz2 )
	odk? ( http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-sdk_oo.tar.bz2
		http://tools.openoffice.org/unowinreg_prebuild/680/unowinreg.dll )
	http://go-oo.org/packages/${PATCHLEVEL}/ooo-build-${SRC}.tar.gz
	mono? ( http://go-oo.org/packages/${PATCHLEVEL}/cli_types.dll
		http://go-oo.org/packages/${PATCHLEVEL}/cli_types_bridgetest.dll )
	http://go-oo.org/packages/SRC680/extras-2.tar.bz2
	http://go-oo.org/packages/SRC680/biblio.tar.bz2
	http://go-oo.org/packages/SRC680/hunspell_UNO_1.1.tar.gz
	http://go-oo.org/packages/xt/xt-20051206-src-only.zip
	http://go-oo.org/packages/SRC680/lp_solve_5.5.tar.gz"

NSS_DEP=">=dev-libs/nspr-4.6.2
	>=dev-libs/nss-3.11-r1"

COMMON_DEPEND="!app-office/openoffice-bin
	virtual/libc
	access? ( >=app-office/mdbtools-0.6_pre1 )
	cups? ( net-print/cups )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	gnome? ( >=x11-libs/cairo-1.2.0
		>=x11-libs/gtk+-2.10
		>=gnome-base/gnome-vfs-2.12
		>=gnome-base/gconf-2.12 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	firefox? ( >=www-client/mozilla-firefox-1.0.7
		${NSS_DEP} )
	!firefox? ( seamonkey? ( www-client/seamonkey
		${NSS_DEP} ) )
	gstreamer? ( >=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	java? ( >=dev-java/bsh-2.0_beta4
		>=dev-db/hsqldb-1.8.0.4
		>=dev-java/xalan-2.7
		>=dev-java/xerces-2.7
		=dev-java/xml-commons-external-1.3* )
	kde? ( >=kde-base/kdelibs-3.2 )
	ldap? ( net-nds/openldap )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )
	mono? ( >=dev-lang/mono-1.1.6 )
	nas? ( >=media-libs/nas-1.6 )
	sound? ( =media-libs/portaudio-18*
		>=media-libs/libsndfile-1.0.9 )
	webdav? ( >=net-misc/neon-0.24.7 )
	>=app-admin/eselect-oodict-20060706
	>=app-text/hunspell-1.1.4-r1
	>=app-text/libwpd-0.8.6
	>=dev-lang/python-2.3.4
	  dev-libs/expat
	>=dev-libs/icu-3.6
	>=dev-libs/libxml2-2.0
	  dev-libs/libxslt
	>=dev-libs/xmlsec-1.2.9-r1
	>=dev-libs/STLport-4.6.2-r2
	>=media-libs/fontconfig-2.2.0
	>=media-libs/freetype-2.1.10-r2
	  media-libs/jpeg
	  media-libs/libpng
	>=net-misc/curl-7.9.8
	>=sys-libs/db-4.3
	  sys-libs/zlib
	  x11-libs/libXaw
	  x11-libs/libXinerama
	>=x11-libs/startup-notification-0.5"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.4 )"

DEPEND="${COMMON_DEPEND}
	!dev-util/dmake
	java? ( =virtual/jdk-1.4*
		dev-java/ant-core
		xt? ( dev-java/xt ) )
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
	if ! built_with_use dev-libs/xmlsec mozilla; then
		eerror "xmlsec built without nss support!"
		eerror "emerge it with USE=\"mozilla\""
		die "bad luck"
	fi

	if is-flagq -ffast-math ; then
		eerror "You are using -ffast-math, which is known to cause problems."
		eerror "Please remove it from your CFLAGS, using this globally causes"
		eerror "all sorts of problems."
		eerror "After that you will also have to - at least - rebuild python"
		eerror "otherwise the openoffice build will break."
		die "bad luck"
	fi

	# need this much memory (does *not* check swap)
	CHECKREQS_MEMORY="512"
	# need this much temporary build space
	use debug && CHECKREQS_DISK_BUILD="8192" \
		|| CHECKREQS_DISK_BUILD="5112"
	# install will need this much space in /usr
	use debug && CHECKREQS_DISK_USR="1024" \
		|| CHECKREQS_DISK_USR="512"
	# go!
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
		ewarn "of the OpenOffice.org functionality (i.e. help) being disabled."
		ewarn "If something you need does not work for you, rebuild with"
		ewarn "java in your USE-flags."
		ewarn
	fi
}

src_unpack() {
	unpack ooo-build-${SRC}.tar.gz

	cd ${S}
	epatch ${FILESDIR}/config.diff
	epatch ${FILESDIR}/build-java-target-update.diff

	# sys-libs/db version used
	local db_ver="$(db_findver '>=sys-libs/db-4.3')"

	# Gentoo
	cp ${S}/distro-configs/Gentoo.conf.in ${S}/distro-configs/GentooUnstable.conf.in
	local CONFFILE="${S}/distro-configs/GentooUnstable.conf.in"
	use branding && echo "--with-intro-bitmaps=\\\"${S}/src/openintro_gentoo.bmp\\\"" >> ${CONFFILE}

	# GentooExperimental Defaults
	echo "--with-stlport=/usr" >> ${CONFFILE}
	echo "--with-system-db" >> ${CONFFILE}
	echo "--with-system-jpeg" >> ${CONFFILE}
	echo "--with-system-libwpd" >> ${CONFFILE}
	echo "--with-system-xmlsec" >> ${CONFFILE}
	echo "--enable-vba" >> ${CONFFILE}

	# Internal
	echo "`use_enable binfilter`" >> ${CONFFILE}
	echo "`use_enable dbus`" >> ${CONFFILE}
	echo "`use_enable debug crashdump`" >> ${CONFFILE}

	# System
	echo "`use_enable cups`" >> ${CONFFILE}
	echo "`use_enable eds evolution2`" >> ${CONFFILE}
	echo "`use_enable ldap`" >> ${CONFFILE}
	echo "`use_with ldap openldap`" >> ${CONFFILE}
	echo "`use_enable mono`" >> ${CONFFILE}
	echo "`use_with odbc system-odbc-headers`" >> ${CONFFILE}
	echo "`use_enable webdav neon`" >> ${CONFFILE}
	echo "`use_with webdav system-neon`" >> ${CONFFILE}

	# Browser
	if use firefox || use seamonkey ; then
		echo "--enable-mozilla" >> ${CONFFILE}
		echo "--with-system-mozilla" >> ${CONFFILE}
		echo "`use_with firefox`" >> ${CONFFILE}
	else
		echo "--disable-mozilla" >> ${CONFFILE}
	fi

	# Gnome
	echo "`use_enable gnome gnome-vfs`" >> ${CONFFILE}
	echo "`use_enable gnome lockdown`" >> ${CONFFILE}
	echo "`use_enable gnome atkbridge`" >> ${CONFFILE}
	echo "`use_enable gstreamer`" >> ${CONFFILE}

	# Java
	echo "`use_with java`" >> ${CONFFILE}
	if use java ; then
		echo "--with-ant-home=${ANT_HOME}" >> ${CONFFILE}
		echo "--with-jdk-home=$(java-config --jdk-home 2>/dev/null)" >> ${CONFFILE}
		echo "--with-java-target-version=1.4" >> ${CONFFILE}
		echo "--with-system-beanshell" >> ${CONFFILE}
		echo "--with-system-hsqldb" >> ${CONFFILE}
		echo "--with-system-xalan" >> ${CONFFILE}
		echo "--with-system-xerces" >> ${CONFFILE}
		echo "--with-system-xml-apis" >> ${CONFFILE}
		echo "--with-beanshell-jar=/usr/share/bsh/lib/bsh.jar" >> ${CONFFILE}
		echo "--with-db-jar=/usr/share/db-${db_ver}/lib/db.jar" >> ${CONFFILE}
		echo "--with-hsqldb-jar=/usr/share/hsqldb/lib/hsqldb.jar" >> ${CONFFILE}
		echo "--with-serializer-jar=/usr/share/xalan/lib/serializer.jar" >> ${CONFFILE}
		echo "--with-xalan-jar=/usr/share/xalan/lib/xalan.jar" >> ${CONFFILE}
		echo "--with-xerces-jar=/usr/share/xerces-2/lib/xercesImpl.jar" >> ${CONFFILE}
		echo "--with-xml-apis-jar=/usr/share/xml-commons-external-1.3/lib/xml-apis.jar" >> ${CONFFILE}
		echo "`use_with xt system-xt`" >> ${CONFFILE}
		use xt && echo "--with-xt-jar=/usr/share/xt/lib/xt.jar" >> ${CONFFILE}
	fi

	# Sound
	echo "`use_enable sound pasf`" >> ${CONFFILE}
	echo "`use_with sound system-portaudio`" >> ${CONFFILE}
	echo "`use_with sound system-sndfile`" >> ${CONFFILE}
	echo "`use_with nas`" >> ${CONFFILE}
	echo "`use_with nas system-nas`" >> ${CONFFILE}
}

src_compile() {
	unset LIBC
	addpredict "/bin"
	addpredict "/root/.gconfd"
	addpredict "/root/.gnome"

	# Should the build use multiprocessing? Not enabled by default, as it tends to break 
	[ "${WANT_MP}" == "true" ] && export JOBS="`echo "${MAKEOPTS}" | sed -e "s/ //" | sed -e "s/.*-j\([0-9]\+\).*/\1/"`"

	# gcj upstream says to use LD_LIBRARY_PATH for run-time ...
	use java && [[ "$(java-config -f)" =~ "gcj-jdk" ]] && export LD_LIBRARY_PATH="$(java-config --jdk-home)/lib:${LD_LIBRARY_PATH}"

	# Compile problems with these ...
	filter-flags "-funroll-loops"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	replace-flags "-O3" "-O2"

	# Now for our optimization flags ...
	export ARCH_FLAGS="${CXXFLAGS}"
	use debug || export LINKFLAGSOPTIMIZE="${LDFLAGS}"

	cd ${S}
	./autogen.sh \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man \
		--with-distro="GentooUnstable" \
		--with-intro-bitmaps="${S}/src/openintro_gentoo.bmp" \
		--with-arch="${ARCH}" \
		--with-srcdir="${DISTDIR}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-num-cpus="${JOBS}" \
		--with-binsuffix="2" \
		--with-installed-ooo-dirname="openoffice" \
		--with-tag="${SRC}" \
		--disable-post-install-scripts \
		--enable-hunspell \
		--with-system-hunspell \
		`use_enable !debug strip` \
		`use_enable odk` \
		`use_enable pam` \
		`use_enable kde` \
		`use_enable gnome gtk` \
		`use_enable gnome quickstart` \
		`use_enable gnome cairo` \
		`use_with gnome system-cairo` \
		`use_enable access` \
		`use_with access system-mdbtools` \
		`use_enable mono` \
		|| die "Configuration failed!"

	einfo "Building OpenOffice.org..."
	use kde && set-kdedir 3
	make || die "Build failed"
}

src_install() {
	einfo "Preparing Installation"
	make DESTDIR=${D} install || die "Installation failed!"

	# Install corrected Symbol Font
	insinto /usr/share/fonts/TTF/
	doins fonts/*.ttf

	# Fix the permissions for security reasons
	chown -R root:root ${D}

	# record java libraries
	use java && java-pkg_regjar ${D}/usr/$(get_libdir)/openoffice/program/classes/*.jar
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	eselect oodict update --libdir $(get_libdir)

	[ -x /sbin/chpax ] && [ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	# Add available & useful jars to openoffice classpath
	/usr/lib/openoffice/program/java-set-classpath \
		$(java-config --classpath=jdbc-mysql 2>/dev/null) >/dev/null

	einfo " To start OpenOffice.org, run:"
	einfo
	einfo " $ ooffice2"
	einfo
	einfo " Also, for individual components, you can use any of:"
	einfo
	einfo " oobase2, oocalc2, oodraw2, oofromtemplate2,"
	einfo " ooimpress2, oomath2, ooweb2 or oowriter2"
	einfo
	einfo " Spell checking is now provided through our own myspell-ebuilds,"
	einfo " if you want to use it, please install the correct myspell package"
	einfo " according to your language needs."
}
