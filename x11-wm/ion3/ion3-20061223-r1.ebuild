# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils darcs

MY_PV=${PV/_p/-}
MY_PN=ion-3ds-${MY_PV}

SCRIPTS_PV=20061214
SCRIPTS_PN=ion3-scripts

IONFLUX_PV=20061022
IONFLUX_PN=ion3-mod-ionflux

IONXRANDR_PV=20061021
IONXRANDR_PN=ion3-mod-xrandr


DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.iki.fi/tuomov/ion/"
SRC_URI="http://iki.fi/tuomov/dl/${MY_PN}.tar.gz
	mirror://debian/pool/main/i/${SCRIPTS_PN}/${SCRIPTS_PN}_${SCRIPTS_PV}.orig.tar.gz
	mirror://debian/pool/main/i/${IONFLUX_PN}/${IONFLUX_PN}_${IONFLUX_PV}.orig.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="xinerama ionunicode"
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
	>=dev-lang/lua-5.1.1"
S=${WORKDIR}/${MY_PN}

SCRIPTS_DIRS="keybindings scripts statusbar statusd styles"

src_unpack() {
	unpack ${A}

	tar xjf ${FILESDIR}/${IONXRANDR_PN}-${IONXRANDR_PV}.tar.bz2
	
	cd ${S}
	epatch ${FILESDIR}/${PV}/*.patch

#	autoreconf -i -v ${S}/build/ac/

        cd build/ac/ || exit 1
        autoreconf -i --force

        # for the first instance of DEFINES, add XINERAMA
        use xinerama && \
            (
            sed -i 's!\(DEFINES *+=\)!\1 -DCF_XINERAMA !' system-ac.mk.in
            sed -i 's!\(LIBS="$LIBS.*\)"!\1 $XINERAMA_LIBS"!' configure.ac
            )

	
	# FIX for modules
	cd ${WORKDIR}
	ln -s ${MY_PN} ion-3
}

src_compile() {
	local myconf=""

#	myconf="${myconf} `use_enable iontruetype xft`" 

        # xfree 
	if has_version '>=x11-base/xfree-4.3.0'; then
		myconf="${myconf} --disable-xfree86-textprop-bug-workaround"
	fi

        # help out this arch as it can't handle certain shared library linkage
        use hppa && myconf="${myconf} --disable-shared"

        # unicode support
        use ionunicode && myconf="${myconf} --enable-Xutf8"

        # configure bug, only specify xinerama to not have it
        use xinerama || myconf="${myconf} --disable-xinerama"


	${S}/build/ac/configure \
		${myconf} \
		`use_enable xinerama` \
		--sysconfdir=/etc/X11 \
		--prefix=/usr \
		--datadir=/usr \
		--bindir=/usr \
		--sbindir=/usr \
		--libexecdir=/usr \
		--datarootdir=/usr \
		--with-lua-prefix=/usr \
		--with-lua-includes=/usr/include \
		--with-lua-libraries=/usr/lib \
		--libdir=/usr \
		--includedir=/usr 

	make \
		DOCDIR=/usr/share/doc/${PF} || die

	for i in "${IONFLUX_PN}-${IONFLUX_PV}" "${IONXRANDR_PN}-${IONXRANDR_PV}"
	do
	cd ${WORKDIR}/${i}

	emake \
		prefix=/usr \
		ETCDIR=/etc/X11/ion3 \
		SHAREDIR=/usr/share/ion3 \
		MANDIR=/usr/share/man \
		DOCDIR=/usr/share/doc/${PF} \
		LOCALEDIR=/usr/share/locale \
		LIBDIR=/usr/lib \
		MODULEDIR=/usr/lib/ion3/mod \
		LCDIR=/usr/lib/ion3/lc \
		VARDIR=/var/cache/ion3 
	done
}

src_install() {

	emake \
		PREFIX=${D}/usr \
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
	
	cd ${WORKDIR}/${SCRIPTS_PN}-${SCRIPTS_PV}
	insinto /usr/share/ion3
	find $SCRIPTS_DIRS -type f |\
    	    while read FILE 
    	    do
		doins $PWD/$FILE
    	    done

#	dodir /usr/share/ion3
#	cp -R * ${D}/usr/share/ion3

	for i in "${IONFLUX_PN}-${IONFLUX_PV}" "${IONXRANDR_PN}-${IONXRANDR_PV}"
	do
	cd ${WORKDIR}/${i}

	make \
		PREFIX=${D}/usr \
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

	done

	echo '--dopath("mod_ionflux")' >> ${D}/etc/X11/ion3/cfg_modules.lua	
	echo 'dopath("mod_xrandr")' >> ${D}/etc/X11/ion3/cfg_modules.lua
}
