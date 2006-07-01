# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-wm/WindowMaker/WindowMaker-0.80.2.ebuild,v 1.3 2002/11/18 06:49:54 blizzy Exp $

inherit patch extrafiles

IUSE="${IUSE} gif nls png kde oss jpeg gnome xinerama"

MY_P=${P/windowm/WindowM}
S=${WORKDIR}/${MY_P}

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="ftp://ftp.windowmaker.org/pub/source/release/${MY_P}.tar.gz
	 ftp://ftp.windowmaker.org/pub/source/release/WindowMaker-extra-0.1.tar.gz"
HOMEPAGE="http://www.windowmaker.org/"

DEPEND="virtual/x11
	media-libs/hermes
	>=media-libs/tiff-3.5.5
	gif? ( >=media-libs/giflib-4.1.0-r3 
		>=media-libs/libungif-4.1.0 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	gnustep-base/gnustep-make"

RDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.39 )
	media-fonts/urw"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~sparc64 ~alpha"

pkg_setup ()
{
    addwrite /root/GNUstep/Defaults/.GNUstepDefaults.lck
    addpredict /root/GNUstep	
}

src_unpack() 
{
    patch_src_unpack

    aclocal
    autoheader
    autoconf
    libtoolize --force --automake --copy
    automake -a --gnu --include-deps
    
# {{{ Mod4 as Command

#    cd ${S}/WindowMaker/Defaults
#    sed -i -e "s:Mod1:Mod4:g" WindowMaker.in 
#    sed -i -e "s:/floppy:/media/floppy:g" WMGLOBAL

# }}}
# {{{ Wprefs.app location

    cd ${S}/WindowMaker
    for i in plmenu*
      do
      sed -i -e "s:/usr/local/GNUstep/Apps/WPrefs.app/WPrefs:${APPS_DIR}/WPrefs.app/WPrefs:g" ${i}
    done

# }}}
    
}

src_compile() 
{
    if [ -f ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh ] 
	then
	source ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh
    else
	die "gnustep-make not installed!"
    fi

    APPS_DIR=${GNUSTEP_SYSTEM_ROOT}/Applications


    WITH_MODELOCK=yes
    local myconf

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
	
	econf \
		--sysconfdir=/etc/X11 \
		--with-x \
		--enable-newstyle \
		--enable-superfluous \
		--enable-usermenu \
		--with-appspath=${APPS_DIR} \
		--with-pixmapdir=/usr/share/pixmaps \
		--enable-virtual-desktop \
		--enable-netwm \
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
	make || die
  
  	# WindowMaker Extra
	cd ../WindowMaker-extra-0.1
	econf || die
		    
	make || die
}

src_install() 
{
    if [ -f ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh ] 
	then
	source ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh
    else
	die "gnustep-make not installed!"
    fi

    APPS_DIR=${GNUSTEP_SYSTEM_ROOT}/Applications

#    einstall \
#	sysconfdir=${D}/etc/X11 \
#	wprefsdir=${D}${APPS_DIR}/WPrefs.app \
#	wpdatadir=${D}${APPS_DIR}/WPrefs.app \
#	wpexecbindir=${D}${APPS_DIR}/WPrefs.app || die

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


pkg_postinst() 
{
    einfo "/usr/share/GNUstep/ has moved ${GNUSTEP_ROOT}"
    einfo "this means the WPrefs app has moved. If you have"
    einfo "entries for this in your menus, please correct them"
}


# Local Variables:
# mode: sh
# End:

