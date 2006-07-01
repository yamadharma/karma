# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-sound/xmms/xmms-1.2.7-r24.ebuild,v 1.1 2003/07/28 02:22:19 raker Exp $

IUSE="xml nls esd gnome opengl mmx oggvorbis 3dnow mikmod directfb ipv6 cjk"

inherit libtool flag-o-matic eutils patch
filter-flags -fforce-addr -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

RUSXMMS_PV=csa13

DESCRIPTION="X MultiMedia System"
SRC_URI="http://www.xmms.org/files/1.2.x/${P}.tar.gz
	 mmx? ( http://members.jcom.home.ne.jp/jacobi/linux/etc/${P}-mmx.patch.gz )
	 mirror://sourceforge/rusxmms/${P}-recode-${RUSXMMS_PV}.tar.bz2"
HOMEPAGE="http://www.xmms.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND="app-arch/unzip
	=x11-libs/gtk+-1.2*
	mikmod? ( >=media-libs/libmikmod-3.1.6 )
	esd? ( >=media-sound/esound-0.2.22 )
	xml? ( >=dev-libs/libxml-1.8.15 )
	gnome? ( <gnome-base/gnome-panel-1.5.0 )
	opengl? ( virtual/opengl )
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
RDEPEND="${DEPEND}
	directfb? ( dev-libs/DirectFB )
	nls? ( dev-util/intltool )"

src_unpack () 
{
    patch_src_unpack


	# Patch for mpg123 to convert Japanese character code of MP3 tag info
	# the Japanese patch and the Russian one overlap, so its one or the other
#	if use cjk; 
#	then
#	    echo "cjk"
#	else
#		# add russian recoding
#		epatch ${WORKDIR}/xmms-ds-recode.patch
#	fi

	if [ ! -f ${S}/config.rpath ] ; 
	then
		touch ${S}/config.rpath
		chmod +x ${S}/config.rpath
	fi

	# We run automake and autoconf here else we get a lot of warning/errors.
	# I have tested this with gcc-2.95.3 and gcc-3.1.
	elibtoolize

	if use nls; 
	then
		if has_version '>=sys-devel/gettext-0.12'; then
			epatch ${FILESDIR}/${PN}-gettext-fix.patch
		fi
	fi

	echo ">>> Reconfiguring..."
	for x in ${S} ${S}/libxmms
	do
		cd ${x}
		aclocal
		export WANT_AUTOCONF_2_5=1
		automake --gnu --add-missing --include-deps Makefile || die
		autoconf || die
	done
}

src_compile() {
	local myconf=""

	use 3dnow || use mmx \
		&& myconf="${myconf} --enable-simd" \
		|| myconf="${myconf} --disable-simd"

	use xml \
		|| myconf="${myconf} --disable-cdindex"

	econf \
		--with-dev-dsp=/dev/sound/dsp \
		--with-dev-mixer=/dev/sound/mixer \
		`use_with gnome` \
		`use_enable oggvorbis vorbis` \
		`use_enable oggvorbis oggtest` \
		`use_enable oggvorbis vorbistest` \
		`use_with oggvorbis ogg` \
		`use_enable esd` \
		`use_enable esd esdtest` \
		`use_enable mikmod` \
		`use_enable mikmod mikmodtest` \
		`use_with mikmod libmikmod` \
		`use_enable opengl` \
		`use_enable nls` \
		`use_enable ipv6` \
		${myconf} || die

	### emake seems to break some compiles, please keep @ make
	make || die
}

src_install() {
	make prefix=${D}/usr \
		datadir=${D}/usr/share \
		incdir=${D}/usr/include \
		infodir=${D}/usr/share/info \
		localstatedir=${D}/var/lib \
		mandir=${D}/usr/share/man \
		sysconfdir=${D}/etc \
		sysdir=${D}/usr/share/applets/Multimedia \
		GNOME_SYSCONFDIR=${D}/etc install || die "FOO"

	dodoc AUTHORS ChangeLog COPYING FAQ NEWS README TODO 
	
	keepdir /usr/share/xmms/Skins
	insinto /usr/share/pixmaps/
	donewins gnomexmms/gnomexmms.xpm xmms.xpm
	doins xmms/xmms_logo.xpm
	insinto /usr/share/pixmaps/mini
	doins xmms/xmms_mini.xpm

	insinto /etc/X11/wmconfig
	donewins xmms/xmms.wmconfig xmms

	if [ `use gnome` ] ; then
		insinto /usr/share/gnome/apps/Multimedia
		doins xmms/xmms.desktop
		dosed "s:xmms_mini.xpm:mini/xmms_mini.xpm:" \
			/usr/share/gnome/apps/Multimedia/xmms.desktop
	else
		rm ${D}/usr/share/man/man1/gnomexmms*
	fi

	# causes segfaults for ppc users #10309 and after talking
	# to xmms dev's, they've punted this from the src tree anyways ...
	rm -rf ${D}/usr/lib/xmms/Input/libidcin.so
}

pkg_postrm() {
	if [ -x ${ROOT}/usr/bin/xmms ] && [ ! -d ${ROOT}/usr/share/xmms/Skins ]
	then
		mkdir -p ${ROOT}/usr/share/xmms/Skins
	fi
}
