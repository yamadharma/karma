# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils alternatives toolchain-funcs gnustep

DESCRIPTION="A Cocoa port of Emacs for MacOS X and GNUstep"
HOMEPAGE="http://emacs-on-aqua.sourceforge.net"
SRC_URI="mirror://sourceforge/emacs-on-aqua/emacs-20.7_ns-${PV}.tar.bz2"


S=${WORKDIR}/emacs-20.7_ns-${PV}

LICENSE="GPL-2"
SLOT="20"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 ~sh sparc x86"
IUSE="leim"

RDEPEND="${GS_DEPEND}
	sys-libs/ncurses
	sys-libs/gdbm
	virtual/x11
		>=media-libs/giflib-4.1.0.1b
		>=media-libs/jpeg-6b-r2
		>=media-libs/tiff-3.5.5-r3
		>=media-libs/libpng-1.2.1
	nls? ( sys-devel/gettext )
	!nosendmail? ( virtual/mta )"

DEPEND="${RDEPEND}
	${GS_RDEPEND}
	>=sys-devel/autoconf-2.58"


PROVIDE="virtual/emacs virtual/editor"
SANDBOX_DISABLED="1"

src_unpack () 
{
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/emacs-21.3-xorg.patch
	epatch ${FILESDIR}/emacs-21.3-amd64.patch
	epatch ${FILESDIR}/emacs-21.3-hppa.patch
	epatch ${FILESDIR}/emacs-21.2-sh.patch

	# This will need to be updated for X-Compilation
	sed -i -e "s:/usr/lib/\([^ ]*\).o:/usr/$(get_libdir)/\1.o:g" \
	       ${S}/src/s/gnu-linux.h

	sed -i -e "s/-lungif/-lgif/g" configure* src/Makefile.in || die
##    
	sed -i -e "s:-I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers:-I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers -I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers/\$LIBRARY_COMBO -I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers/\$LIBRARY_COMBO/\$GNUSTEP_HOST_CPU/\$GNUSTEP_HOST_OS:" \
		${S}/GNUstep/compile

}

src_compile () 
{
    	egnustep_env

	# -fstack-protector gets internal compiler error at xterm.c (bug 33265)
	filter-flags -fstack-protector

	# emacs doesn't handle LDFLAGS properly (bug #77430 and bug #65002)
	unset LDFLAGS

	# gcc 3.4 with -O3 or stronger flag spoils emacs
	if [ "$(gcc-major-version)" -ge 3 -a "$(gcc-minor-version)" -ge 4 ] ; then
		replace-flags -O[3-9] -O2
	fi

	# -march is known to cause signal 6 on some environment
	filter-flags "-march=*"

	export WANT_AUTOCONF=2.1
	autoconf

	export CONFIG_SYSTEM_LIBS=-L$GNUSTEP_SYSTEM_ROOT/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO

        cd ${S}/GNUstep
	./compile || die "Compile error"
}

src_install () 
{
	egnustep_env
	
	einfo "Fixing info documentation..."
	cd ${S}/GNUstep/build/Emacs.app/Resources/info
	rm dir
	for i in *
	    do
	    mv ${i} ${i##*/}.info
	    gzip -9 ${i##*/}.info
	done
	cd ${S}

	einfo "Add read permission..."
	chmod -R a+r ${S}/GNUstep/build/Emacs.app
	
	dodir ${GNUSTEP_SYSTEM_ROOT}/Applications
	mv ${S}/GNUstep/build/Emacs.app ${D}/${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app
	
	cd ${D}/${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app
	ln -s Emacs Emacs-${SLOT/./_}
	cd ${S}
	
	einfo "Fixing permissions..."
	find ${D} -perm 664 |xargs chmod 644
	find ${D} -type d |xargs chmod 755

	dodoc BUGS ChangeLog README*
	newdoc ${S}/GNUstep/ChangeLog ChangeLog.GNUstep
	
	dodir /etc/env.d
	echo -e "INFOPATH=${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app/Resources/info" > ${D}/etc/env.d/60emacs.app-${SLOT}
}

update-alternatives () 
{
	egnustep_env
	
	local REGEXP="Emacs-*.app"
	local TARGET="Emacs.app"
	
	cd ${GNUSTEP_SYSTEM_ROOT}/Applications
	local ALT="$(echo $REGEXP | sort -r)"
	if [ -n "$ALT" ]
	    then
    	    for i in $ALT
		do 
		ln -sf $i $TARGET
    	    done
	else
	    rm $TARGET	    
	fi	    
}

#pkg_postinst () 
#{
#	update-alternatives
#}

#pkg_postrm () 
#{
#	update-alternatives
#}
