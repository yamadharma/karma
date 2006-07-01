# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-wm/WindowMaker/WindowMaker-0.80.2.ebuild,v 1.3 2002/11/18 06:49:54 blizzy Exp $

inherit patch

IUSE="${IUSE} gif nls png kde oss jpeg gnome xinerama netwm vdesktop"

# branch update
MY_PV="${PV/0.90.0_pre/}"
MY_PN="WindowMaker"
MY_P="${MY_PN}-CVS-${MY_PV}"
EXTRA_P="${MY_PN}-extra-0.1"

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="ftp://ftp.windowmaker.org/pub/source/snapshots/${MY_P}.tar.gz
	 ftp://ftp.windowmaker.org/pub/source/release/${EXTRA_P}.tar.gz"
HOMEPAGE="http://www.windowmaker.org/"


MY_PV_WORKAROUND="20040723"
MY_P_WORKAROUND="${MY_PN}-CVS-${MY_PV_WORKAROUND}"


S=${WORKDIR}/${MY_P_WORKAROUND}

DEPEND="virtual/x11
	media-libs/hermes
	>=media-libs/tiff-3.5.5
	gif? ( >=media-libs/giflib-4.1.0-r3 
		>=media-libs/libungif-4.1.0 )
	png? ( >=media-libs/libpng-1.2.1 
		sys-libs/zlib )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	gnustep-base/gnustep-env"

RDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.39 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~sparc64 ~alpha"

patch_OPTIONS="cleancvs autogen"

if [ -z "${GENTOO_GNUSTEP_ROOT}" ]
    then
    GENTOO_GNUSTEP_ROOT=/usr/GNUstep
fi

GNUSTEP_ROOT=${GENTOO_GNUSTEP_ROOT}
GNUSTEP_SYSTEM_ROOT=${GNUSTEP_ROOT}/System

APPS_DIR=${GNUSTEP_SYSTEM_ROOT}/Applications

src_unpack () 
{
    patch_src_unpack
    
# {{{ Wprefs.app location

    cd ${S}/WindowMaker
    for i in plmenu*
      do
      sed -i -e "s:/usr/local/GNUstep/Apps/WPrefs.app/WPrefs:${APPS_DIR}/WPrefs.app/WPrefs:g" ${i}
    done

# }}}
    
}

src_compile () 
{
    local myconf

    WITH_MODELOCK=yes

    # disabling asm code since its broke when using 
    # optimalization for i686 with ggc3
    if `echo ${CFLAGS} | grep i686` 
	then
    	perl -pi -e 's/test \$x86 = 1/false/' configure.ac
    fi

	use gnome \
		&& myconf="${myconf} --enable-gnome" \
		|| myconf="${myconf} --disable-gnome"
	
	use kde \
		&& myconf="${myconf} --enable-kde" \
		&& export KDEDIR=/usr/kde/2 \
		|| myconf="${myconf} --disable-kde"
	
	if [ "$WITH_MODELOCK" ] ; then
		myconf="${myconf} --enable-modelock"
	else
		myconf="${myconf} --disable-modelock"
	fi
	
	use nls \
		&& export LINGUAS="`ls po/*.po | sed 's:po/\(.*\)\.po$:\1:'`" \
		|| myconf="${myconf} --disable-nls --disable-locale"

	use gif \
		|| myconf="${myconf} --disable-gif"

	use jpeg \
		|| myconf="${myconf} --disable-jpeg"
	
	use png \
		|| myconf="${myconf} --disable-png"
		

	use esd || use alsa || use oss \
		&& myconf="${myconf} --enable-sound" \
		|| myconf="${myconf} --disable-sound"
		
	myconf="${myconf} `use_enable xinerama`"
	myconf="${myconf} `use_enable netwm`"
	myconf="${myconf} `use_enable vdesktop virtual-desktop`"
	
	econf \
		--sysconfdir=/etc/X11 \
		--with-x \
		--enable-superfluous \
		--enable-usermenu \
		--with-appspath=${APPS_DIR} \
		--with-pixmapdir=/usr/share/pixmaps \
		--enable-bounce \
		${myconf} || die
	
	cd ${S}/po
	cp Makefile Makefile.orig
	sed 's:zh_TW.*::' \
		Makefile.orig > Makefile

	cd ${S}/WPrefs.app/po
	cp Makefile Makefile.orig
	sed 's:zh_TW.*::' \
		Makefile.orig > Makefile
	
	cd ${S}
	#0.80.1-r2 did not work with make -j4 (drobbins, 15 Jul 2002)
	#with future Portage, this should become "emake -j1"
	emake -j1 || die
  
  	# WindowMaker Extra
	cd ../WindowMaker-extra-0.1
	econf || die
		    
	make || die
}

src_install () 
{
    make install \
	DESTDIR=${D} \
	|| die

# {{{ FIXME xpm not installed

    cd ${S}/WPrefs.app/xpm
    cp *.xpm ${D}${APPS_DIR}/WPrefs.app/xpm
    cd ${S}

# }}}

    cp -f WindowMaker/plmenu ${D}/etc/X11/WindowMaker/WMRootMenu

    dodoc AUTHORS BUGFORM BUGS ChangeLog COPYING* INSTALL* FAQ* \
          MIRRORS README* NEWS TODO Sample* 

    # WindowMaker Extra
    cd ../WindowMaker-extra-0.1
    einstall || die
	
    newdoc README README.extra

    exeinto /etc/X11/Sessions/
    doexe ${FILESDIR}/wmaker
}

# Local Variables:
# mode: sh
# End:


