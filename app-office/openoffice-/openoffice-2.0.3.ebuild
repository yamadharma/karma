# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit check-reqs db-use debug eutils fdo-mime flag-o-matic java-pkg-2 kde-functions mono multilib

IUSE="access agg binfilter boost bsh cairo cups debug eds firefox gnome hsqldb
icu java jpeg kde ldap mono nas nosound odbc odk pam portaudio seamonkey sndfile
vba webdav wpd xalan xml xmlsec xt"

LANGS="af ar be_BY bg bn bs ca cs cy da de el en_GB en_US en_ZA es et fa fi fr
gu_IN he hi_IN hr hu it ja km ko lt mk nb nl nn nr ns pa_IN pl pt pt_BR ru rw
sh_YU sk sl sr_CS st sv sw_TZ th tn tr ts vi xh zh_CN zh_TW zu"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

MY_PV="${PV}.0"
PATCHLEVEL="OOC680"
SRC="OOO_2_0_3"
S="${WORKDIR}/ooo-build-${MY_PV}"

DISTRO="GentooUnstable"
CONFFILE="${S}/distro-configs/${DISTRO}.conf.in"

DESCRIPTION="OpenOffice.org, unstable 2.0 development sources."
HOMEPAGE="http://go-oo.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~ppc64 ~sparc"
RESTRICT="binchecks strip"

SRC_URI="http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-core.tar.bz2
	http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-system.tar.bz2
	http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-lang.tar.bz2
	binfilter? ( http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-binfilter.tar.bz2 )
	odk? ( http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-sdk_oo.tar.bz2 )
	http://go-oo.org/packages/${PATCHLEVEL}/ooo-build-${MY_PV}.tar.gz
	!wpd? ( http://go-oo.org/packages/libwpd/libwpd-0.8.3.tar.gz )
	mono? ( http://go-oo.org/packages/SRC680/cli_types.dll
			http://go-oo.org/packages/SRC680/cli_types_bridgetest.dll )
	http://go-oo.org/packages/SRC680/biblio.tar.bz2
	http://go-oo.org/packages/SRC680/extras-2.tar.bz2
	http://go-oo.org/packages/SRC680/hunspell_UNO_1.1.tar.gz
	http://go-oo.org/packages/SRC680/lp_solve_5.5.tar.gz
	http://go-oo.org/packages/xt/xt-20051206-src-only.zip"

NSS_DEP=">=dev-libs/nspr-4.6.2
	>=dev-libs/nss-3.11-r1"

RDEPEND="!app-office/openoffice-bin
	|| ( ( x11-libs/libXaw x11-libs/libXinerama ) virtual/x11 )
	virtual/libc
	dev-libs/expat
	dev-libs/libxslt
	>=dev-libs/STLport-4.6.2-r2
	>=sys-libs/db-4.3
	sys-libs/zlib
	>=dev-lang/python-2.3.4
	>=media-libs/freetype-2.1.10-r2
	>=media-libs/fontconfig-2.2.0
	media-libs/libpng
	>=x11-libs/startup-notification-0.5
	>=net-misc/curl-7.9.8
	>=app-text/hunspell-1.1.4-r1
	cups? ( net-print/cups )
	gnome? ( >=x11-libs/gtk+-2.4
		>=sys-apps/dbus-0.60
		>=gnome-base/gnome-vfs-2.6
		>=gnome-base/gconf-2.0 )
	cairo? ( >=x11-libs/cairo-1.0.2
		>=x11-libs/gtk+-2.8 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	kde? ( >=kde-base/kdelibs-3.2 )
	java? ( >=virtual/jre-1.4
		>=dev-java/java-config-2 )
	firefox? ( >=www-client/mozilla-firefox-1.0.7
		${NSS_DEP} )
	!firefox? ( seamonkey? ( www-client/seamonkey
		${NSS_DEP} ) )
	ldap? ( net-nds/openldap )
	mono? ( >=dev-lang/mono-1.1.6 )
	xml? ( >=dev-libs/libxml2-2.0 )
	access? ( >=app-office/mdbtools-0.6_pre20051109 )
	agg? ( >=x11-libs/agg-2.3 )
	boost? ( >=dev-libs/boost-1.30.2 )
	bsh? ( >=dev-java/bsh-2.0_beta4 )
	hsqldb? ( >=dev-db/hsqldb-1.8.0.4 )
	icu? ( >=dev-libs/icu-3.4 )
	jpeg? ( media-libs/jpeg )
	nas? ( >=media-libs/nas-1.6 )
	!nosound? ( portaudio? ( =media-libs/portaudio-18* )
				sndfile? ( >=media-libs/libsndfile-1.0.9 ) )
	webdav? ( >=net-misc/neon-0.24.7 )
	wpd? ( >=app-text/libwpd-0.8.3 )
	xalan? ( =dev-java/xml-commons-external-1.3*
		>=dev-java/xerces-2.7
		>=dev-java/xalan-2.7 )
	xmlsec? ( >=dev-libs/xmlsec-1.2.9-r1 )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )
	amd64? ( >=dev-libs/boost-1.33.1
		java? ( !gcj? ( >=dev-db/hsqldb-1.8.0.4 ) ) )"

DEPEND="${RDEPEND}
	!dev-util/dmake
	|| ( ( x11-libs/libXrender x11-proto/printproto x11-proto/xextproto
		   x11-proto/xproto x11-proto/xineramaproto ) virtual/x11 )
	>=sys-devel/gcc-3.2.1
	amd64? ( >=sys-devel/gcc-4 )
	>=app-shells/tcsh-6.14-r3
	dev-util/pkgconfig
	>=dev-lang/perl-5.0
	sys-devel/flex
	sys-devel/bison
	dev-util/intltool
	app-arch/zip
	app-arch/unzip
	dev-perl/Archive-Zip
	>=sys-apps/findutils-4.1.20-r1
	>=app-admin/eselect-oodict-20060706
	pam? ( sys-libs/pam )
	java? ( !amd64? ( >=virtual/jdk-1.4 )
		amd64? ( !gcj? ( >=virtual/jdk-1.6.0.0_beta65 )
			gcj? ( >=dev-java/gcj-jdk-4.1 ) )
		dev-java/ant-core )
	!java? ( dev-libs/libxslt
		>=dev-libs/libxml2-2.0 )
	odbc? ( dev-db/unixODBC )
	xt? ( dev-java/xt )"

PROVIDE="virtual/ooo"

pkg_setup() {
	if use gnome && ! built_with_use sys-apps/dbus gtk; then
		eerror "dbus built without gtk support!"
		eerror "emerge it with USE=\"gtk\""
		die "bad luck"
	fi

	if use xmlsec && ! built_with_use dev-libs/xmlsec mozilla; then
		eerror "xmlsec built without nss support!"
		eerror "emerge it with USE=\"mozilla\""
		die "bad luck"
	fi

	if is-flagq -ffast-math ; then
		eerror "Using broken cflag in global scope!"
		eerror
		eerror "	-ffast-math"
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

	use java && java-pkg-2_pkg_setup

	if ! use java; then
		ewarn "You are building with java-support disabled, this results in some"
		ewarn "of the OpenOffice.org functionality (i.e. help) being disabled."
		ewarn "If something you need does not work for you, rebuild with"
		ewarn "java in your USE-flags. Also the xml use-flag is disabled with"
		ewarn "-java to prevent build breakage."
		ewarn
	elif use sparc; then
		ewarn "Java support on sparc is very flaky, we don't recommend"
		ewarn "building openoffice this way."
		echo
		ewarn "One may try the gcj-overlay from"
		ewarn
		ewarn "	http://forums.gentoo.org/viewtopic-t-379693.html"
		ewarn
		ebeep 5
		epause 10
	fi

	if use jpeg; then
		ewarn "You lose functionality using sytem's jpeg library! (ycck support)"
		ewarn "If you miss any functionality from JPEG support in OOo"
		ewarn "switch back to OOo's implemented JPEG!"
		ewarn
	fi
}

src_unpack() {
	unpack ooo-build-${MY_PV}.tar.gz

	cd ${S}
	epatch ${FILESDIR}/config.diff
	epatch ${FILESDIR}/gentoo.diff

	local db_ver="$(db_findver '>=sys-libs/db-4.3')"

	# Defaults
	echo "--with-vendor=\\\"Gentoo Foundation\\\"" > ${CONFFILE}
	echo "--with-intro-bitmaps=\\\"${S}/src/openintro_gentoo.bmp\\\"" >> ${CONFFILE}
	echo "--disable-fontooo" >> ${CONFFILE}
	echo "--disable-qadevooo" >> ${CONFFILE}
	echo "--enable-fontconfig" >> ${CONFFILE}
	echo "--enable-libsn" >> ${CONFFILE}
	echo "--with-system-db" >> ${CONFFILE}
	echo "--with-system-expat" >> ${CONFFILE}
	echo "--with-system-stdlibs" >> ${CONFFILE}
	echo "--with-x" >> ${CONFFILE}
	echo "--with-system-xrender-headers" >> ${CONFFILE}
	echo "--with-dynamic-xinerama" >> ${CONFFILE}
	echo "--with-stlport=/usr" >> ${CONFFILE}
	echo "--with-system-curl" >> ${CONFFILE}
	echo "--with-system-libxslt" >> ${CONFFILE}
	echo "--without-myspell-dicts" >> ${CONFFILE}

	# Internal
	echo "`use_enable binfilter`" >> ${CONFFILE}
	echo "`use_enable debug crashdump`" >> ${CONFFILE}
	echo "`use_enable odk`" >> ${CONFFILE}
	echo "`use_enable vba`" >> ${CONFFILE}

	# System
	echo "`use_with agg system-agg`" >> ${CONFFILE}
	echo "`use_with boost system-boost`" >> ${CONFFILE}
	echo "`use_enable cups`" >> ${CONFFILE}
	echo "`use_enable eds evolution2`" >> ${CONFFILE}
	echo "`use_with icu system-icu`" >> ${CONFFILE}
	echo "`use_with jpeg system-jpeg`" >> ${CONFFILE}
	echo "`use_enable ldap`" >> ${CONFFILE}
	echo "`use_with ldap openldap`" >> ${CONFFILE}
	echo "`use_enable mono`" >> ${CONFFILE}
	echo "`use_with odbc system-odbc-headers`" >> ${CONFFILE}
	echo "`use_enable webdav neon`" >> ${CONFFILE}
	echo "`use_with webdav system-neon`" >> ${CONFFILE}
	echo "`use_with wpd system-libwpd`" >> ${CONFFILE}
	echo "`use_with xml system-libxml`" >> ${CONFFILE}
	echo "`use_with xmlsec system-xmlsec`" >> ${CONFFILE}

	# Browser
	if use firefox || use seamonkey ; then
		echo "--enable-mozilla" >> ${CONFFILE}
		echo "--with-system-mozilla" >> ${CONFFILE}
	else
		echo "--disable-mozilla" >> ${CONFFILE}
	fi
	echo "`use_with firefox`" >> ${CONFFILE}

	# Gnome
	echo "`use_enable gnome atkbridge`" >> ${CONFFILE}
	echo "`use_enable gnome gnome-vfs`" >> ${CONFFILE}
	echo "`use_enable gnome lockdown`" >> ${CONFFILE}

	# Java
	use java && echo "--with-db-jar=/usr/lib/db-${db_ver}.jar" >> ${CONFFILE}
	echo "`use_with bsh system-beanshell`" >> ${CONFFILE}
	use bsh && echo "--with-beanshell-jar=/usr/share/bsh/lib/bsh.jar" >> ${CONFFILE}
	echo "`use_with hsqldb system-hsqldb`" >> ${CONFFILE}
	use hsqldb && echo "--with-hsqldb-jar=/usr/share/hsqldb/lib/hsqldb.jar" >> ${CONFFILE}
	echo "`use_with java ant-home ${ANT_HOME}`" >> ${CONFFILE}
	echo "`use_with java jdk-home $(java-config --jdk-home 2>/dev/null)`" >> ${CONFFILE}
	echo "`use_with java`" >> ${CONFFILE}
	echo "`use_with xalan system-xalan`" >> ${CONFFILE}
	echo "`use_with xalan system-xerces`" >> ${CONFFILE}
	echo "`use_with xalan system-xml-apis`" >> ${CONFFILE}
	if use xalan; then
		echo "--with-xalan-jar=/usr/share/xalan/lib/xalan.jar" >> ${CONFFILE}
		echo "--with-serializer-jar=/usr/share/xalan/lib/serializer.jar" >> ${CONFFILE}
		echo "--with-xerces-jar=/usr/share/xerces-2/lib/xercesImpl.jar" >> ${CONFFILE}
		echo "--with-xml-apis-jar=/usr/share/xml-commons-external-1.3/lib/xml-apis.jar" >> ${CONFFILE}
	fi
	echo "`use_with xt system-xt`" >> ${CONFFILE}
	use xt && echo "--with-xt-jar=/usr/share/xt/lib/xt.jar" >> ${CONFFILE}

	# Sound
	echo "`use_with nas`" >> ${CONFFILE}
	echo "`use_with nas system-nas`" >> ${CONFFILE}
	echo "`use_enable !nosound pasf`" >> ${CONFFILE}
	echo "`use_with portaudio system-portaudio`" >> ${CONFFILE}
	echo "`use_with sndfile system-sndfile`" >> ${CONFFILE}

	# AMD64
	if use amd64 ; then
		echo "--with-system-boost" >> ${CONFFILE}
		if use java && ! use gcj ; then
			echo "--with-system-hsqldb" >> ${CONFFILE}
			echo "--with-hsqldb-jar=/usr/share/hsqldb/lib/hsqldb.jar" >> ${CONFFILE}
		fi
	fi

	# test binfilter fixes
	cp ${FILESDIR}/binfilter-stl.diff patches/src680
}

src_compile() {
	unset LIBC
	addpredict "/bin"
	addpredict "/root/.gconfd"
	addpredict "/root/.gnome"

	# Enable compiler cache?
	local COMPILER_CACHE=""
	[[ -x "$(which ccache 2>/dev/null)" ]] && COMPILER_CACHE="ccache"

	# Should the build use multiprocessing? Not enabled by default, as it tends to break 
	[ "${WANT_MP}" == "true" ] && export JOBS="`echo "${MAKEOPTS}" | sed -e "s/ //" | sed -e "s/.*-j\([0-9]\+\).*/\1/"`"

	# Compile problems with these ...
	filter-flags "-funroll-loops"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	replace-flags "-O3" "-O2"

	# Now for our optimization flags ...
	export ARCH_FLAGS="${CXXFLAGS}"
	export LINKFLAGSOPTIMIZE="${LDFLAGS}"

	cd ${S}
	autoconf
	./configure \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man \
		--with-distro="${DISTRO}" \
		--with-intro-bitmaps="${S}/src/openintro_gentoo.bmp" \
		--with-arch="${ARCH}" \
		--with-srcdir="${DISTDIR}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-gcc-speedup="${COMPILER_CACHE}" \
		--with-num-cpus="${JOBS}" \
		--with-binsuffix="2" \
		--with-installed-ooo-dirname="openoffice" \
		--with-tag="${SRC}" \
		--disable-post-install-scripts \
		--enable-hunspell \
		--with-system-hunspell \
		`use_enable !debug strip` \
		`use_enable kde` \
		`use_enable gnome gtk` \
		`use_enable gnome quickstart` \
		`use_enable cairo` \
		`use_with cairo system-cairo` \
		`use_enable access` \
		`use_with access system-mdbtools` \
		`use_enable mono` \
		`use_enable pam` \
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

	# create native libraries
	use gcj && java-pkg_cachejar
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	# TODO tweak startup scripts
	# create gcj db
	if use gcj && [ -x /usr/bin/rebuild-classmap-db ] ; then
		rm -f /usr/$(get_libdir)/openoffice/classmap.gcjdb
		rebuild-classmap-db /usr/$(get_libdir)/openoffice/classmap.gcjdb /usr/$(get_libdir)/openoffice
	fi

	eselect oodict update --libdir $(get_libdir)

	[ -x /sbin/chpax ] && [ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	einfo " To start OpenOffice.org, run:"
	einfo
	einfo " $ ooffice2"
	einfo
	einfo " Also, for individual components, you can use any of:"
	einfo
	einfo " oobase2, oocalc2, oodraw2, oofromtemplate2,"
	einfo " ooimpress2, oomath2, ooweb2 or oowriter2"
}
