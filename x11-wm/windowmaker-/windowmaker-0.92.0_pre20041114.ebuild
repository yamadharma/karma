# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils gnustep gnuconfig

# branch update
#MY_PV="${PV/0.92.0_pre/}"
MY_PV=0.91.0
MY_PN="WindowMaker"
#MY_P="${MY_PN}-CVS-${MY_PV}"
MY_P="${MY_PN}-${MY_PV}"
EXTRA_P="${MY_PN}-extra-0.1"


S=${WORKDIR}/${MY_P}

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="ftp://ftp.windowmaker.org/pub/source/release/${MY_P}.tar.gz
	 ftp://ftp.windowmaker.org/pub/source/release/${EXTRA_P}.tar.gz"
HOMEPAGE="http://www.windowmaker.org/"

IUSE="gif gnustep jpeg nls png tiff modelock vdesktop xinerama"
DEPEND="virtual/x11
	gif? ( || ( >=media-libs/libungif-4.1.0
			>=media-libs/giflib-4.1.0-r3))
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.6.1-r2 )"
RDEPEND="nls? ( >=sys-devel/gettext-0.10.39 )
	gnustep? ( gnustep-base/gnustep-env )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~sparc ~x86"

PATCHDIR="${FILESDIR}/patch/version/${PV}"

if use gnustep 
    then
    egnustep_install_domain "System"
fi

src_unpack () 
{
    unpack ${A}

    cd ${S}
    
    EPATCH_FORCE="yes"
    EPATCH_SUFFIX="patch.bz2"
    epatch ${PATCHDIR}
    
#    sed -i -e "s:/*#define XDND*/:#define XDND:" src/wconfig.h.in

# {{{ 

    cd ${S}/WindowMaker/Defaults
    sed -i -e "s:/floppy:/media/floppy:g" WMGLOBAL

# }}}

    gnuconfig_update ${S}
}

src_compile () 
{
	local myconf
	local gs_user_postfix
	
	# image format types
	# xpm is provided by X itself
	myconf="--enable-xpm $(use_enable png) $(use_enable jpeg) $(use_enable gif) $(use_enable tiff)"

	# non required X capabilities
	myconf="${myconf} $(use_enable modelock) $(use_enable vdesktop) $(use_enable xinerama)"

	# integrate with GNUstep environment, or not
	if use gnustep ; then
		egnustep_env
		myconf="${myconf} --with-gnustepdir=$(egnustep_system_root)/ --with-appspath=$(egnustep_system_root)/Applications"
	else
		# no change from wm-0.80* ebuilds, as to not pollute things more
		myconf="${myconf} --with-gnustepdir=/usr/lib/GNUstep --with-appspath=/usr/lib/GNUstep/Applications"
	fi

	use nls \
		&& export LINGUAS="`ls po/*.po | sed 's:po/\(.*\)\.po$:\1:'`" \
		|| myconf="${myconf} --disable-nls --disable-locale"

	# default settings with $myconf appended
	econf \
		--sysconfdir=/etc/X11 \
		--with-x \
		--enable-usermenu \
		--with-pixmapdir=/usr/share/pixmaps \
		${myconf} || die

	# don't know if zh_TW is still non-functional, but leaving it out still
	#  for now
	cd ${S}/po
	cp Makefile Makefile.orig
	sed 's:zh_TW.*::' \
		Makefile.orig > Makefile

	cd ${S}/WPrefs.app/po
	cp Makefile Makefile.orig
	sed 's:zh_TW.*::' \
		Makefile.orig > Makefile

	cd ${S}
	for file in ${S}/WindowMaker/*menu*; do
		if [ -r $file ]; then
			if use gnustep ; then
				sed -e "s/\/usr\/local\/GNUstep/`cat ${TMP}/sed.gs_prefix`System/g;
					s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
			else
				sed -e 's/\/usr\/local\/GNUstep/\/usr\/lib\/GNUstep/g;' < $file > $file.tmp
			fi
			mv $file.tmp $file;

			sed -e 's/\/usr\/local\/share\/WindowMaker/\/usr\/share\/WindowMaker/g;' < $file > $file.tmp;
			mv $file.tmp $file;
		fi;
	done;

	cd ${S}
	emake -j1 || die "windowmaker: make has failed"

	cd ${S}
	for file in ${S}/WindowMaker/Defaults/W*; do
		if [ -r $file ]; then
			if use gnustep; then
				sed -e "s/\$HOME\/GNUstep\//\$HOME`cat ${TMP}/sed.gs_user_root_suffix`/g;
						s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
				mv $file.tmp $file;

				sed -e "s/~\/GNUstep\//~`cat ${TMP}/sed.gs_user_root_suffix`/g;
						s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
				mv $file.tmp $file;
			fi
		fi
	done;

	# WindowMaker Extra Package (themes and icons)
	cd ../${EXTRA_P}
	econf || die "windowmaker-extra: configure has failed"
	emake || die "windowmaker-extra: make has failed"
}

src_install () 
{
	emake install DESTDIR=${D} || die "windowmaker: install has failed."

# {{{ FIX: xpm not installed
	
	cd ${S}/WPrefs.app/xpm
	if use gnustep  
	    then
	    egnustep_env
    	    cp *.xpm ${D}$(egnustep_system_root)/Applications/WPrefs.app/xpm
	else	    
	    cp *.xpm ${D}/usr/lib/GNUstep/Applications/Applications/WPrefs.app/xpm
	fi	    
	cd ${S}

# }}}

        dobin contrib/dockit
	doman contrib/dockit.1

	dodoc AUTHORS BUGFORM BUGS ChangeLog COPYING* INSTALL* FAQ* \
	      MIRRORS README* NEWS TODO

	# WindowMaker Extra
	cd ../${EXTRA_P}
	emake install DESTDIR=${D} || die "windowmaker-extra: install failed"

	newdoc README README.extra

	# create wmaker session shell script
	echo "#!/bin/bash" > wmaker
	echo "/usr/bin/wmaker" >> wmaker
	exeinto /etc/X11/Sessions/
	doexe wmaker
}

pkg_postinst () 
{
	einfo "If you are using 'startx' from the command line, and require"
	einfo "  .xinitrc, you may need to execute 'wmaker.inst', which will"
	einfo "  setup default configurations for you."
	einfo ""

	if use gnustep ; then
		einfo "WPrefs.app is installed in you GNUstep System Applications directory."
		einfo ""
		ewarn "*** IMPORTANT ***"
		ewarn "If you changed the GNUstep user root, via a use flag like 'layout-osx-like' in gnustep-make"
		ewarn "  you will have to repair the personal WindowMaker config files you have.  For example,"
		ewarn "  if you changed the default user root as above, \$HOME/GNUstep to ~/, these commands"
		ewarn "  will help you:"
		ewarn "cd ; cp -a ./GNUstep/.AppInfo . ; cp -a ./GNUstep/Defaults/W* ./Defaults/ ;"
		ewarn "  cp -a ./GNUstep/Library/Icons ./GNUstep/Library/WindowMaker ./Library/"
		ewarn "The above commands are specifically to help repair your WindowMaker install;"
		ewarn "  a less elegant, but reasonable method is to simply run wmaker.inst again,"
		ewarn "  **after sourcing GNUstep.sh**, as this env script sets the GNUSTEP_USER_ROOT variable."
		ewarn "Generally, other config files in your old ~/GNUstep directory, can simply be"
		ewarn "  moved to the new GNUSTEP_USER_ROOT."
		ewarn "^^^ IMPORTANT ^^^"
		ewarn ""
	else
		einfo "Even though you are not using the GNUstep environment, wmaker.inst will"
		einfo "  create a 'GNUstep' directory in your home -- it uses this dirctory"
		einfo "  to store your WindowMaker configuration files."
		einfo "WPrefs.app can be launched at /usr/lib/GNUstep/Applications/WPrefs.app/WPrefs"
		einfo "  or by simply **clicking on it in the WindowMaker default dock.**"
		einfo ""
	fi

	if use vdesktop ; then
		ewarn "Note that enabling support for NETWM virtual desktops will make"
		ewarn "  menus that should be autoscrolling seem to not scroll, as they"
		ewarn "  are not off the screen, but rather in another virtual desktop."
		ewarn ""
	fi

	ewarn "This package provides libwraster.so.3.  Packages depending on"
	ewarn "  libwraster.so.2 will have to be rebuilt, i.e. 'revdep-rebuild'"

	ebeep 4
	epause 4
}


