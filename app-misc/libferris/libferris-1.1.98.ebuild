# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions libtool autotools perl-module toolchain-funcs

need-kde 3

DESCRIPTION=""
HOMEPAGE="http://witme.sourceforge.net/libferris.web/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kde stlport exif epeg qt gtk xapian curl gphoto2 jpeg
png ldap imagemagick hevea gs bogofilter gpgme gtk xine obby beagle perl X"

RDEPEND="dev-libs/xerces-c
	dev-libs/xalan-c
	dev-libs/redland
	>=dev-libs/fampp2-3.5.0
	exif? ( media-libs/libexif )
	epeg? ( media-libs/epeg )
	sys-apps/file
	>=dev-libs/ferrisloki-2.2.0
	dev-libs/libferrisstreams
	dev-libs/libsigc++
	>=dev-libs/libpqxx-2.4.3
	xapian? ( >=dev-libs/xapian-0.8.3 )
	dev-libs/boost
	curl? ( net-misc/curl )
	media-libs/imlib2
	dev-db/stldb4
	gphoto2? ( media-gfx/gphoto2 )
	media-libs/libextractor
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	jpeg2k? ( media-libs/jasper )
	ldap? ( net-nds/openldap )
	imagemagick? ( media-gfx/imagemagick )
	app-text/wv
	hevea? ( dev-tex/hevea )
	gs? ( app-text/ghostscript-esp )
	bogofilter? ( mail-filter/bogofilter )
	dev-util/pccts
	gnome? ( gnome-base/bonobo )
	kde? ( >=kde-base/kdelibs-3 )
	gpgme? ( >=app-crypt/gpgme-0.4.3 )
	>=dev-libs/glib-2.2.0
	gtk? ( >=x11-libs/gtk+-2.2.0 )
	xine? ( >=media-libs/xine-lib-1.1.1 )
	obby? ( net-libs/obby )
	beagle? ( app-misc/beagle )
	perl? ( dev-lang/swig )
	X? ( virtual/x11 )"
DEPEND="${RDEPEND}"

disable_component() {
	sed -r -i "s@^$1/Makefile\$@@g" ${S}/configure.ac
	if [ x`echo $1 | egrep '^.+?/.+$'` == x ]; then
		parent_dir='.'
	else
		parent_dir=`echo $1 | sed -r 's@^(.+?)/.+?$@\1@g'`
	fi
	component_name=`echo $1 | sed -r 's@^.+?/(.+?)$@\1@g'`

	#echo "arg=$1 parent_dir=${parent_dir} component_name=${component_name}"

	cat "${parent_dir}/Makefile.in" | perl -p -e 's/\\\n/ /' > ${parent_dir}/Makefile.in.tmp
	mv ${parent_dir}/Makefile.in.tmp ${parent_dir}/Makefile.in
	sed -r -i "s@(DIST_SUBDIRS = .*?)${component_name}(.*?)@\1\2@g"	${parent_dir}/Makefile.in
	sed -r -i "s@(SUBDIRS = .*?)${component_name}(.*?)@\1\2@g"	${parent_dir}/Makefile.in
	sed -r -i "s@(SUBDIRS = .*?)\\$\\(${component_name}DIR\)(.*?)@\1\2@gi"	${parent_dir}/Makefile.in
	sed -r -i "s@(XALANTESTS = .*?)${component_name}(.*?)@\1\2@g" ${parent_dir}/Makefile.in
}

src_unpack() {
	if [ $(gcc-major-version) -lt 4 ]; then
		ewarn "You need GCC of version 4 or higher to build libferris"
		die "Need GCC of version 4"
	fi
	if built_with_use dev-db/postgresql pg-hier; then
		ewarn "libferris is uncompatible with PostgreSQL hierarchical \
		extensions."
		ewarn "Emerge PostgreSQL without pg-hier flag and then emerge libferris"
		die "PostgreSQL is merged with pg-hier flag"
	fi

	unpack ${A}
	cd "${S}"

	#epatch "${FILESDIR}/${PN}-1.1.98-missed-leak-pointer.patch"
	epatch "${FILESDIR}/${PN}-1.1.98-broken-hidden-visibility.patch"
	if [ $ARCH = "amd64" ]; then
		epatch "${FILESDIR}/${PN}-1.1.98-amd64.patch"
	fi
	epatch "${FILESDIR}/${PN}-1.1.98-gentoo.patch"
	epatch "${FILESDIR}/${PN}-1.1.98-gentoo2.patch"

	#FIX IT!
	disable_component "perl"
	disable_component "apps/xml/CGITransform"
	disable_component "plugins/context/external"
	disable_component "noarch"
	disable_component "plugins/fulltextindexers/clucene"
	disable_component "plugins/context/sqlplus"

	for i in 'apps/xml/Makefile.in media/icons/Makefile.in media/xslt/Makefile.in'; do
		sed -i 's@(prefix)/ferris@(prefix)/share/ferris@g' ${S}/$i
	done

	#find . -iname "*.in" -exec sed -i 's/$(LIBTOOL) --mode=install/$(LIBTOOL) -mode=install -inst-prefix=${DESTDIR}/g' "{}" \;

	#elibtoolize
	eaclocal -I macros
	eautoconf
}

src_compile() {
	local myconf

	#if ( ! use stlport ); then
	#	myconf="${myconf} --disable-stlport"
	#fi

	myconf=`use-disable stlport` `use-with qt` `use-with X` `use-with ldap`
	`use-with mysql` `use-with exif` `use-with curl` `use-with gphoto2`

	if ( use kde ); then
		myconf="${myconf} --with-kde-mime \
		--with-kde-includedir=${KDEDIR}/include \
		--with-kde-libdir=${KDEDIR}/lib"
	else
		myconf="${myconf} --disable-kde-detection"
	fi

	#if ( use qt ); then
	#	myconf="${myconf} --with-qt"
	#fi	

	if ( use perl ); then
		myconf="${myconf} --with-swig-perl"
	fi

	if ( use gnome ); then
		myconf="${myconf} --with-gnome-vfs-mime"
	else
		myconf="${myconf} --without-bonobo"
	fi

	#if ( use X ); then
	#	myconf="${myconf} --with-X"
	#fi

	#if ( ! use ldap ); then
	#	myconf="${myconf} --without-ldap"
	#fi

	econf ${myconf} || die "econf failed"	
	emake || die

	if ( use perl ); then
		cd ${S}/perl
		perl-module_src_prep
		perl-module_src_compile
		cd ${S}
	fi

	#if use emacs; then
	#	einfo "compiling emacs support"
	#	elisp-compile ${S}/noarch/libferris-emacs.el || die "emacs modules failed"
	#fi
}

src_install() {
	make install DESTDIR=${D}

	if use perl; then
		cd ${S}/perl
		perl-module_src_install
		cd ${S}
	fi

	#if use emacs; then
	#	insinto /usr/share/emacs/site-lisp/ferris
	#	doins noarch/libferris-emacs.el*
	#	elisp-site-file-install ${FILESDIR}/99ferris-gentoo.el
	#fi
}
