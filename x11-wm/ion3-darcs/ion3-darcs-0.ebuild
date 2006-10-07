# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit darcs eutils confutils

DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.modeemi.fi/tuomov/ion/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="ionflux ionxrandr iontruetype ionscripts xinerama doc"

EDARCS_REPOSITORY="http://iki.fi/tuomov/repos/ion-3"
EDARCS_GET_CMD="get --partial --verbose"

DEPEND="|| (
		(
			x11-libs/libICE
			x11-libs/libXext
			iontruetype? ( x11-libs/libXft )
			xinerama? ( x11-libs/libXinerama )
		)
		virtual/x11
	)
	app-misc/run-mailcap
	>=dev-lang/lua-5.0.2
	!x11-wm/ion3"

# this functions checks wether the repository should be updated or downloaded
# from scratch
# $1 is reposititory $2 is directory from which to call darcs pull
download-darcs-repo() {
	EDARCS_REPOSITORY="$1" EDARCS_LOCALREPO="$2" darcs_fetch
}

src_unpack() {
	download-darcs-repo http://iki.fi/tuomov/repos/ion-3 ion-3 || die "ion-3 repo download failure"
	download-darcs-repo http://iki.fi/tuomov/repos/libtu-3 ion-3/libtu || die "libtu repo download failure"
	download-darcs-repo http://iki.fi/tuomov/repos/libextl-3 ion-3/libextl || die "libextl repo download failure"
	
	use ionflux && download-darcs-repo http://iki.fi/tuomov/repos/mod_ionflux-3 ion-3/mod_ionflux || die "mod_ionflux repo download failure"
	use ionxrandr && download-darcs-repo http://iki.fi/tuomov/repos/mod_xrandr-3 ion-3/mod_xrandr || die "mod_xrandr repo download failure"
	use ionscripts && download-darcs-repo http://iki.fi/tuomov/repos/ion-scripts-3 ion-3/ion-scripts || die "ion-scripts repo download failure"
	
	use doc && download-darcs-repo http://iki.fi/tuomov/repos/ion-doc-3 ion-3/ion-doc || die "ion-doc repo download failure"
	
	darcs_src_unpack
	cd ${S}
	# predist.sh is required, but should not call darcs anymore (we want control about internet access)
	sed -i "s|^  *do_darcs_export.*$||" predist.sh
	/bin/bash predist.sh -snapshot
}

src_compile() {
	
	cd ${S}/build/ac
	    
	autoreconf -i

	local myconf=""

	if has_version '>=x11-base/xfree-4.3.0'; then
		myconf="${myconf} --disable-xfree86-textprop-bug-workaround"
	fi

	use hppa && myconf="${myconf} --disable-shared"

	econf \
		--sysconfdir=/etc/X11 \
		`use_enable xinerama` \
		${myconf} || die

	cd ${S}
	
	make \
		DOCDIR=/usr/share/doc/${PF} || die
		
#	if use ionflux 
#	    then
#	    cd ${S}/mod_ionflux
#	    sed -i "s|../ion-3|../${MY_PN}|" system.mk
#	    make || die
#	fi

#	if use ionxrandr 
#	    then
#	    cd ${S}/mod_xrandr
#	    sed -i "s|../ion-3|../${MY_PN}|" Makefile
#	    make || die
#	fi

#	if use doc
#	    then
#	    cd ${S}/ion-doc
#	    sed -i -e "s|^TOPDIR=.*|TOPDIR=..|" \
#		-e "s|^include \$(TOPDIR)/system-inc.mk|include \$(TOPDIR)/build/system-inc.mk|" \
#		-e "s|mod_ionws|mod_tiling|g" \
#		Makefile
#	    make all || die
#	fi
		

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

#	if use ionflux; then
#		cd ${S}/mod_ionflux

#		make \
#			prefix=${D}/usr \
#			ETCDIR=${D}/etc/X11/ion3 \
#			SHAREDIR=${D}/usr/share/ion3 \
#			MANDIR=${D}/usr/share/man \
#			DOCDIR=${D}/usr/share/doc/${PF} \
#			LOCALEDIR=${D}/usr/share/locale \
#			LIBDIR=${D}/usr/lib \
#			MODULEDIR=${D}/usr/lib/ion3/mod \
#			LCDIR=${D}/usr/lib/ion3/lc \
#			VARDIR=${D}/var/cache/ion3 \
#			install || die
#	fi

#	if use ionxrandr; then
#		cd ${S}/mod_xrandr

#		make \
#			prefix=${D}/usr \
#			ETCDIR=${D}/etc/X11/ion3 \
#			SHAREDIR=${D}/usr/share/ion3 \
#			MANDIR=${D}/usr/share/man \
#			DOCDIR=${D}/usr/share/doc/${PF} \
#			LOCALEDIR=${D}/usr/share/locale \
#			LIBDIR=${D}/usr/lib \
#			MODULEDIR=${D}/usr/lib/ion3/mod \
#			LCDIR=${D}/usr/lib/ion3/lc \
#			VARDIR=${D}/var/cache/ion3 \
#			install || die
#	fi
	
	if use ionscripts 
	    then
	    cd ${S}/ion-scripts
	    dodir /usr/share/ion3
	    rm -rf _darcs
	    cp -R * ${D}/usr/share/ion3
	fi

}

