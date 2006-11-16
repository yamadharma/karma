# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ion3/ion3-20060326.ebuild,v 1.1 2006/04/06 08:30:05 twp Exp $

inherit eutils

MY_PV=${PV/_p/-}
MY_PN=ion-3ds-${MY_PV}

SCRIPTS_PV=20061027
SCRIPTS_PN=ion3-scripts

IONFLUX_PV=20061022
IONFLUX_PN=ion3-mod-ionflux

DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.iki.fi/tuomov/ion/"
SRC_URI="http://iki.fi/tuomov/dl/${MY_PN}.tar.gz
	mirror://debian/pool/main/i/${SCRIPTS_PN}/${SCRIPTS_PN}_${SCRIPTS_PV}.orig.tar.gz
	mirror://debian/pool/main/i/${IONFLUX_PN}/${IONFLUX_PN}_${IONFLUX_PV}.orig.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="iontruetype xinerama"
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

src_unpack() {
	unpack ${A}
	
	cd ${S}
	epatch ${FILESDIR}/${PV}/*.patch
#	use iontruetype && epatch ${FILESDIR}/ion3-20060326-truetype.patch

	autoreconf -i -v ${S}/build/ac/
	
	# FIX for ionflux
	cd ${WORKDIR}
	ln -s ${MY_PN} ion-3
}

src_compile() {
	local myconf=""
	
#	epatch ${FILESDIR}/ion3-20061020-configure.patch

	if has_version '>=x11-base/xfree-4.3.0'; then
		myconf="${myconf} --disable-xfree86-textprop-bug-workaround"
	fi

	use hppa && myconf="${myconf} --disable-shared"

	${S}/build/ac/configure \
		${myconf} \
#		`use_enable iontruetype xft` \
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
		
	cd ${WORKDIR}/${IONFLUX_PN}-${IONFLUX_PV}

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
	dodir /usr/share/ion3
	cp -R * ${D}/usr/share/ion3
	
	cd ${WORKDIR}/${IONFLUX_PN}-${IONFLUX_PV}
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
}
