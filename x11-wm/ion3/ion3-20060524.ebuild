# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Kirill A. Korinskiy <catap@catap.ru>
# $Header: $

inherit eutils confutils

MY_PV=${PV/_p/-}
MY_PN=ion-3ds-${MY_PV}
DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.iki.fi/tuomov/ion/"
SRC_URI="http://modeemi.cs.tut.fi/~tuomov/ion/dl/${MY_PN}.tar.gz
http://iki.fi/tuomov/dl/${MY_PN}.tar.gz
http://catap.ru/gentoo/distfiles/mod_ionflux-3-${MY_PV}.tbz2
http://catap.ru/gentoo/distfiles/mod_xrandr-3-${MY_PV}.tbz2
http://catap.ru/gentoo/distfiles/ion-scripts-3-${MY_PV}.tbz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="ionflux ionxrandr iontruetype ionscripts xinerama"
DEPEND="
	|| (
		(
			x11-libs/libICE
			x11-libs/libXext
			iontruetype? ( x11-libs/libXft )
			xinerama? ( x11-libs/libXinerama )
		)
		virtual/x11
	)
	app-misc/run-mailcap
	>=dev-lang/lua-5.1"

S=${WORKDIR}/${MY_PN}

SCRIPTS_DIRS="keybindings misc scripts statusbar statusd styles"

src_unpack() {
	unpack ${MY_PN}.tar.gz

	if use ionflux; then
		unpack mod_ionflux-3-${MY_PV}.tbz2
	fi

	if use ionxrandr; then
		unpack mod_xrandr-3-${MY_PV}.tbz2
	fi

	if use ionscripts; then
		unpack ion-scripts-3-${MY_PV}.tbz2
	fi

	use iontruetype && epatch ${FILESDIR}/${P}-truetype.patch
}

src_compile() {

	autoreconf -i

	local myconf=""

	if has_version '>=x11-base/xfree-4.3.0'; then
		myconf="${myconf} --disable-xfree86-textprop-bug-workaround"
	fi

	use hppa && myconf="${myconf} --disable-shared"

	econf \
		--sysconfdir=/etc/X11 \
		`use_enable iontruetype xft` \
		`use_enable xinerama` \
		${myconf} || die



	make \
		DOCDIR=/usr/share/doc/${PF} || die

	if use ionflux; then
		cd ${WORKDIR}/mod_ionflux-3
		sed -i "s|../ion-3|../${MY_PN}|" system.mk
		make || die
	fi

	if use ionxrandr; then
		cd ${WORKDIR}/mod_xrandr-3
		sed -i "s|../ion-3|../${MY_PN}|" Makefile
		make || die
	fi

}

src_install() {

	make \
		prefix=${D}/usr \
		ETCDIR=${D}/etc/X11/ion3 \
		SHAREDIR=${D}/usr/share/ion3 \
		MANDIR=${D}/usr/share/man \
		DOCDIR=${D}/usr/share/doc/${PF} \
		LOCALEDIR=${D}/usr/share/locale \
		LIBDIR=${D}/usr/lib \
		MODULEDIR=${D}/usr/lib/ion3/mod \
		LCDIR=${D}/usr/lib/ion3/lc \
		VARDIR=${D}/var/cache/ion3 \
		install || die

	prepalldocs

	echo -e "#!/bin/sh\n/usr/bin/ion3" > ${T}/ion3
	echo -e "#!/bin/sh\n/usr/bin/pwm3" > ${T}/pwm3
	exeinto /etc/X11/Sessions
	doexe ${T}/ion3 ${T}/pwm3

	insinto /usr/share/xsessions
	doins ${FILESDIR}/ion3.desktop ${FILESDIR}/pwm3.desktop

	

	if use ionflux; then
		cd ${WORKDIR}/mod_ionflux-3

		make \
			prefix=${D}/usr \
			ETCDIR=${D}/etc/X11/ion3 \
			SHAREDIR=${D}/usr/share/ion3 \
			MANDIR=${D}/usr/share/man \
			DOCDIR=${D}/usr/share/doc/${PF} \
			LOCALEDIR=${D}/usr/share/locale \
			LIBDIR=${D}/usr/lib \
			MODULEDIR=${D}/usr/lib/ion3/mod \
			LCDIR=${D}/usr/lib/ion3/lc \
			VARDIR=${D}/var/cache/ion3 \
			install || die
	fi

	if use ionxrandr; then
		cd ${WORKDIR}/mod_xrandr-3

		make \
			prefix=${D}/usr \
			ETCDIR=${D}/etc/X11/ion3 \
			SHAREDIR=${D}/usr/share/ion3 \
			MANDIR=${D}/usr/share/man \
			DOCDIR=${D}/usr/share/doc/${PF} \
			LOCALEDIR=${D}/usr/share/locale \
			LIBDIR=${D}/usr/lib \
			MODULEDIR=${D}/usr/lib/ion3/mod \
			LCDIR=${D}/usr/lib/ion3/lc \
			VARDIR=${D}/var/cache/ion3 \
			install || die
	fi
	
#	if use ionscripts; then
#		cd ${WORKDIR}/ion-scripts-3
#		insinto /usr/share/ion3
#		find $SCRIPTS_DIRS -type f |\
#        while read FILE ; do
#			doins $PWD/$FILE
#        done
#	fi

	if use ionscripts 
	    then
	    cd ${WORKDIR}/ion-scripts-3
	    dodir /usr/share/ion3
	    cp -R * ${D}/usr/share/ion3
	fi
	
}
