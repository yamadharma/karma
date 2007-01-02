# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ion3/ion3-20060326.ebuild,v 1.3 2006/12/27 01:02:04 mabi Exp $

inherit eutils

MY_PV=${PV/_p/-}
MY_PN=ion-3ds-${MY_PV}
DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.iki.fi/tuomov/ion/"
SRC_URI="http://iki.fi/tuomov/dl/${MY_PN}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xinerama ionunicode"

DEPEND="
	|| (
		(
			x11-libs/libICE
			x11-libs/libSM
			x11-libs/libXext
			xinerama? ( x11-libs/libXinerama )
		)
		virtual/x11
	)
    >=dev-lang/lua-5.1
	app-misc/run-mailcap"
S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
    # Does the truetype patch still work?
    # Don't know, and don't care.
}

src_compile() {
    # Many rewrites to fix a broken configure. Still much cleaner than patch files.
    # No problem using GNU Sed 4.x for -i switch since Portage depends on it anyways.

    (
        cd build/ac/ || exit 1

        autoreconf -i --force

	    local myconf=""
        
        # xfree less than 4.3 isn't even in use anymore, so of course we want this!
	    myconf="${myconf} --disable-xfree86-textprop-bug-workaround"

        # help out this arch as it can't handle certain shared library linkage
	    use hppa && myconf="${myconf} --disable-shared"

        # unicode support
        use ionunicode && myconf="${myconf} --enable-Xutf8"

        # configure bug, only specify xinerama to not have it
        use xinerama || myconf="${myconf} --disable-xinerama"

        # for the first instance of DEFINES, add XINERAMA
        use xinerama && \
            (
            sed -i 's!\(DEFINES *+=\)!\1 -DCF_XINERAMA !' system-ac.mk.in
            sed -i 's!\(LIBS="$LIBS.*\)"!\1 $XINERAMA_LIBS"!' configure.ac
            )

        # configure
	    econf \
		    --sysconfdir=/etc/X11 \
            --with-lua-prefix=/usr \
		    ${myconf} \
            || exit 1
    ) || die "emake failed"

    # Rewrite hard-coded share/doc/ion3 documents directory to have ion version
    sed -i 's!share/doc/ion3!share/doc/'"${PF}"'!g' system*.{mk,in} build/ac/system*.{mk,in}

    # Rewrite hard-coded /usr/local prefix to /usr
    sed -i 's!=/usr/local!=/usr!g' system*.{mk,in} build/ac/configure

    # Rewrite install directories to be prefixed by DESTDIR for sake of portage's sandbox
    sed -i 's!\($(INSTALL\w*)\|rm -f\|ln -s\)\(.*\)\($(\w\+DIR)\)!\1\2$(DESTDIR)\3!g' Makefile */Makefile */*/Makefile build/rules.mk

    # Hey guys! Implicit rules apply to include statements also. Be more careful!
    # Fix an implicit rule that will kill the installation by rewriting a .mk
    # should configure be given just the right set of options.
    sed -i 's!%: %.in!ion-completeman: %: %.in!g' utils/Makefile

    # Now compile, and pray!
	make \
		DOCDIR=/usr/share/doc/${PF} || die
}

src_install() {
	emake \
        DESTDIR=${D} \
		install || die "Install failed"

	prepalldocs

    # Use exec in this scripts to save on processes.
	echo -e "#!/bin/sh\nexec /usr/bin/ion3" > ${T}/ion3
	echo -e "#!/bin/sh\nexec /usr/bin/pwm3" > ${T}/pwm3
	exeinto /etc/X11/Sessions
	doexe ${T}/ion3 ${T}/pwm3

	insinto /usr/share/xsessions
	doins ${FILESDIR}/ion3.desktop ${FILESDIR}/pwm3.desktop
}
