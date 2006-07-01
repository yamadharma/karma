# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils alternatives toolchain-funcs gnustep cvs

ECVS_AUTH="pserver"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/emacs"
ECVS_MODULE="emacs"
ECVS_BRANCH="emacs-unicode-2"
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-emacs/23.0.0"


MY_PV=${PV/_/}

DESCRIPTION="A Cocoa port of Emacs for MacOS X and GNUstep"
HOMEPAGE="http://emacs-app.sourceforge.net"
SRC_URI="mirror://sourceforge/emacs-app/emacs-23.0.0_NS-${MY_PV}_patch_add.tgz
	mirror://sourceforge/emacs-app/emacs-23.0.0_NS-${MY_PV}.patch"


# S=${WORKDIR}/${ECVS_MODULE}
S=${WORKDIR}/emacs-23.0.0_NS-${MY_PV}

LICENSE="GPL-2"
SLOT="23"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 ~sh sparc ~x86"
IUSE="gif jpeg nls png spell tiff"

RDEPEND="${GS_DEPEND}
	>=sys-libs/ncurses-5.3
	spell? ( || ( app-text/aspell app-text/ispell ) )
	sys-libs/gdbm
	virtual/x11
	gif? ( >=media-libs/giflib-4.1.0.1b )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.7 )
	png? ( >=media-libs/libpng-1.2.5 )
	nls? ( >=sys-devel/gettext-0.11.5 )
	!nosendmail? ( virtual/mta )"

DEPEND="${RDEPEND}
	${GS_RDEPEND}
	>=sys-devel/autoconf-2.58"

PROVIDE="virtual/emacs virtual/editor"
SANDBOX_DISABLED="1"

src_unpack () 
{
	cvs_src_unpack

	cd ${WORKDIR}
	mv emacs emacs-23.0.0_NS-${MY_PV}

	cd ${WORKDIR}
	unpack ${A}

	# no flag is allowed
	ALLOWED_FLAGS=" "
	strip-flags
	unset LDFLAGS

	cd ${S}
	epatch ${DISTDIR}/emacs-23.0.0_NS-${MY_PV}.patch
	
	epatch ${FILESDIR}/emacs-subdirs-el-gentoo.diff
	use ppc-macos && epatch ${FILESDIR}/emacs-cvs-21.3.50-nofink.diff

	sed -i -e "s/-lungif/-lgif/g" configure* src/Makefile* || die
###
	# Bootstraping for cvs
#	sed -i -e "s:\$MAKE install:\$MAKE bootstrap install:g" ${S}/nextstep/compile
	sed -i -e "s:^\$MAKE$:\$MAKE bootstrap:g" ${S}/nextstep/compile	
	# Non-flattened headers
#	sed -i -e "s:-I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers:-I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers -I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers/\$LIBRARY_COMBO -I\${GNUSTEP_SYSTEM_ROOT}/Library/Headers/\$LIBRARY_COMBO/\$GNUSTEP_HOST_CPU/\$GNUSTEP_HOST_OS:" \
#		${S}/nextstep/compile

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
	
	#
	append-flags "-I$GNUSTEP_SYSTEM_ROOT/Library/Headers -I$GNUSTEP_SYSTEM_ROOT/Library/Headers/$LIBRARY_COMBO -I$GNUSTEP_SYSTEM_ROOT/Library/Headers/$LIBRARY_COMBO/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS"
	append-ldflags "-L$GNUSTEP_SYSTEM_ROOT/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO"
	
	export WANT_AUTOCONF=2.5
	autoconf

	export CONFIG_SYSTEM_LIBS=-L$GNUSTEP_SYSTEM_ROOT/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO

        cd ${S}/nextstep
	./compile || die "Compile error"
}

src_install () 
{
	egnustep_env
	
	einfo "Fixing info documentation..."
	cd ${S}/nextstep/build/Emacs.app/Resources/info
	rm dir
	for i in *
	    do
	    mv ${i} ${i##*/}.info
	    gzip -9 ${i##*/}.info
	done
	cd ${S}

	einfo "Add read permission..."
	chmod -R a+r ${S}/nextstep/build/Emacs.app
	
	dodir ${GNUSTEP_SYSTEM_ROOT}/Applications
	mv ${S}/nextstep/build/Emacs.app ${D}/${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app

	##
	cd ${D}/${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app
	ln -s Emacs Emacs-${SLOT/./_}
	cd ${S}
	
	##
	cd ${D}/${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app/Resources
	rm -rf var
	dosym /var ${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app/Resources/var
	
	dodir /usr/share/emacs
	mv site-lisp ${D}/usr/share/emacs
	dosym /usr/share/emacs/site-lisp ${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app/Resources/site-lisp
	
	cd ${S}
	
	einfo "Fixing permissions..."
	find ${D} -perm 664 |xargs chmod 644
	find ${D} -type d |xargs chmod 755

	dodoc BUGS ChangeLog README*
	
	docinto nextstep
	dodoc ${S}/nextstep/*.txt
	docinto nextstep/devdoc
	dodoc ${S}/nextstep/devdoc/*
	cd ${S}/nextstep
	dodoc ChangeLog INSTALL.txt KNOWN-ISSUES.txt README.txt USAGE.txt
	
	dodir /etc/env.d
	echo -e "INFOPATH=${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-${SLOT/./_}.app/Resources/info" > ${D}/etc/env.d/60emacs.app-${SLOT}
}

#update-alternatives () 
#{
#	egnustep_env
#	alternatives_auto_makesym "${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs.app" "${GNUSTEP_SYSTEM_ROOT}/Applications/Emacs-*.app"
#}

#pkg_postinst () 
#{
#	update-alternatives
#}

#pkg_postrm () 
#{
#	update-alternatives
#}

