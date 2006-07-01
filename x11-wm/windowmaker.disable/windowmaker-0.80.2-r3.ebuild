# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-wm/WindowMaker/WindowMaker-0.80.2.ebuild,v 1.3 2002/11/18 06:49:54 blizzy Exp $

IUSE="gif nls png kde oss jpeg gnome"

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
	jpeg? ( >=media-libs/jpeg-6b-r2 )"

RDEPEND="nls? ( >=sys-devel/gettext-0.10.39 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64 alpha"

src_unpack() 
{
    unpack ${A}
    cd ${S}
    epatch ${FILESDIR}/${PN}-0.80.2-r1-gentoo.patch	
##
    cd ${S}/WindowMaker/Defaults
    sed 's:Mod1:Mod4:g' WindowMaker.in > WindowMaker.in.tmp
    mv -f WindowMaker.in.tmp WindowMaker.in
    sed 's:/floppy:/mnt/floppy:g' WMGLOBAL > WMGLOBAL.tmp
    mv -f WMGLOBAL.tmp WMGLOBAL
}

src_compile() 
{
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

	econf \
		--sysconfdir=/etc/X11 \
		--with-x \
		--enable-newstyle \
		--enable-superfluous \
		--enable-usermenu \
		--with-appspath=/usr/share/GNUstep \
		--with-pixmapdir=/usr/share/pixmaps \
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
    einstall \
	sysconfdir=${D}/etc/X11 \
	wprefsdir=${D}/usr/lib/GNUstep/Apps/WPrefs.app \
	wpdatadir=${D}/usr/lib/GNUstep/Apps/WPrefs.app \
	wpexecbindir=${D}/usr/lib/GNUstep/Apps/WPrefs.app || die

    cp -f WindowMaker/plmenu ${D}/etc/X11/WindowMaker/WMRootMenu

    dodoc AUTHORS BUGFORUM BUGS ChangeLog COPYING* INSTALL* FAQ* \
          MIRRORS README* NEWS TODO

    # WindowMaker Extra
    cd ../WindowMaker-extra-0.1
    einstall || die
	
    newdoc README README.extra

    echo "#!/bin/bash" > wmaker
    echo "/usr/bin/wmaker" >> wmaker

    exeinto /etc/X11/Sessions/
    doexe wmaker
}


pkg_postinst() 
{
    einfo "/usr/share/GNUstep/ has moved to /usr/lib/GNUstep/"
    einfo "this means the WPrefs app has moved. If you have"
    einfo "entries for this in your menus, please correct them"
}
