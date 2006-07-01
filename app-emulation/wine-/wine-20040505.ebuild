# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emulation/wine/wine-20040408.ebuild,v 1.2 2004/05/03 20:46:53 vapier Exp $

inherit eutils base patch extrafiles

DESCRIPTION="free implementation of Windows(tm) on Unix - CVS snapshot"
HOMEPAGE="http://www.winehq.com/"
SRC_URI="mirror://sourceforge/${PN}/Wine-${PV}.tar.gz"
#	 mirror://gentoo/${P}-fake_windows.tar.bz2
#	 mirror://gentoo/${PF}-misc.tar.bz2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="nas arts cups opengl alsa tcltk nptl debug"

DEPEND="sys-devel/gcc
	sys-devel/flex
	>=sys-libs/ncurses-5.2
	>=media-libs/freetype-2.0.0
	X? ( virtual/x11 )
	tcltk? ( dev-lang/tcl dev-lang/tk )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	nas? ( media-libs/nas )
	cups? ( net-print/cups )
	opengl? ( virtual/opengl )"


WINE_C=/var/lib/wine

#pkg_setup () 
#{
#    if ( use opengl )
#	then	
#	if [ -e /etc/env.d/09opengl ]
#	then
#		# Set up X11 implementation
#		X11_IMPLEM_P="$(portageq best_version "${ROOT}" virtual/x11)"
#		X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
#		X11_IMPLEM="${X11_IMPLEM##*\/}"
#		einfo "X11 implementation is ${X11_IMPLEM}."
#
#		VOID=$(cat /etc/env.d/09opengl | grep ${X11_IMPLEM})
#
#		USING_X11=$?
#		if [ ${USING_X11} -eq 1 ]
#		then
#			GL_IMPLEM=$(cat /etc/env.d/09opengl | cut -f5 -d/)
#			opengl-update ${X11_IMPLEM}
#		fi
#	else
#		die "Could not find /etc/env.d/09opengl. Please run opengl-update."
#	fi
#    fi	
#}


src_compile () 
{
	# there's no configure flag for cups, arts, alsa and nas, it's supposed to be autodetected

	unset CFLAGS CXXFLAGS

#	ac_cv_header_jack_jack_h=no \
#	ac_cv_lib_soname_jack= \
	./configure \
		--prefix=/usr/lib/wine \
		--sysconfdir=/etc/wine \
		--host=${CHOST} \
		--enable-curses \
		`use_enable opengl` \
		`use_with nptl` \
		`use_enable debug trace` \
		`use_enable debug` \
		|| die "configure failed"

	cd ${S}/programs/winetest
	sed -i 's:wine.pm:include/wine.pm:' Makefile

	# No parallel make
	cd ${S}
	make depend || die
	make all || die

	cd programs && emake || die
}

src_install () 
{
	local WINEMAKEOPTS="prefix=${D}/usr/lib/wine"

	### Install wine to ${D}
	make ${WINEMAKEOPTS} install || die
	cd ${S}/programs
	make ${WINEMAKEOPTS} install || die

	# Needed for later installation
	dodir /usr/bin

	### Creation of /usr/lib/wine/.data
	# Setting up fake_windows
	dodir /usr/lib/wine/.data
	cd ${D}/usr/lib/wine/.data
	tar jxvf ${DISTDIR}/${P}-fake_windows.tar.bz2
	chown root:root fake_windows/ -R

	# Unpacking the miscellaneous files
	tar jxvf ${FILESDIR}/misc/misc.tar.bz2
	chown root:root config

	# moving the wrappers to bin/
	insinto /usr/bin
	dobin regedit-wine wine winedbg
	rm regedit-wine wine winedbg

	# copying the winedefault.reg into .data
	insinto /usr/lib/wine/.data
	doins ${WORKDIR}/${P}/winedefault.reg

#	# Set up this dynamic data
#	cd ${S}
#	insinto /usr/lib/wine/.data/fake_windows/Windows
#	doins documentation/samples/system.ini
#	doins documentation/samples/generic.ppd
#	## Setup of .data complete

	### Misc tasks
	# Take care of the documentation
	cd ${S}
	dodoc ANNOUNCE AUTHORS BUGS ChangeLog DEVELOPERS-HINTS LICENSE README

	# Manpage setup
	cp ${D}/usr/lib/${PN}/man/man1/wine.1 ${D}/usr/lib/${PN}/man/man1/${PN}.1
	doman ${D}/usr/lib/${PN}/man/man1/${PN}.1
	rm ${D}/usr/lib/${PN}/man/man1/${PN}.1
	doman ${D}/usr/lib/${PN}/man/man5/wine.conf.5
	rm ${D}/usr/lib/${PN}/man/man5/wine.conf.5

	# Remove the executable flag from those libraries.
	cd ${D}/usr/lib/wine/lib/wine
	chmod a-x *.so

	# {{{ Documentation installation
	
	docinto documentation/samples
	dodoc ${S}/documentation/samples/*
	
	dohtml -r ${S}/documentation/samples/*
	
	# }}}
	
	insinto /etc/wine
	doins ${S}/tools/wine.inf
	
	dobin ${S}/tools/fnt2bdf
	
	keepdir ${WINE_C}
	tar xjvf ${FILESDIR}/misc/fake_windows.tar.bz2 -C ${D}/${WINE_C}
	chown -R root:root ${D}/${WINE_C}

	# {{{ Set up this dynamic data
	
	cd ${S}
	insinto ${WINE_C}/Windows
	doins ${S}/documentation/samples/system.ini
	doins ${S}/dlls/wineps/generic.ppd
	## Setup of .data complete
	
	# }}}

	
	extrafiles_install
}

pkg_postinst () 
{
#    if ( use opengl )
#	then
#	if [ ${USING_X11} -eq 1 ]
#	then
#		opengl-update ${GL_IMPLEM}
#	fi
#    fi

	einfo "Use /usr/bin/wine to start wine. This is a wrapper-script"
	einfo "which will take care of everything else."
	einfo ""
	einfo "Use /usr/bin/regedit-wine to import registry files into the"
	einfo "wine registry."
}

# Local Variables:
# mode: sh
# End:
