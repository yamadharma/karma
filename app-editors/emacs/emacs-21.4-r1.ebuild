# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-21.4-r1.ebuild,v 1.3 2005/04/12 21:28:03 eradicator Exp $

inherit flag-o-matic eutils alternatives toolchain-funcs

DESCRIPTION="An incredibly powerful, extensible text editor"
HOMEPAGE="http://www.gnu.org/software/emacs"
SRC_URI="mirror://gnu/emacs/${P}.tar.gz
	leim? ( mirror://gnu/emacs/leim-21.3.tar.gz )"

LICENSE="GPL-2"
SLOT="21"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE="X Xaw3d gnome leim lesstif motif nls nosendmail"

RDEPEND="sys-libs/ncurses
	sys-libs/gdbm
	X? ( virtual/x11
		>=media-libs/giflib-4.1.0.1b
		>=media-libs/jpeg-6b-r2
		>=media-libs/tiff-3.5.5-r3
		>=media-libs/libpng-1.2.1
		!arm? (
		Xaw3d? ( x11-libs/Xaw3d )
		motif? (
			lesstif? ( x11-libs/lesstif )
			!lesstif? ( >=x11-libs/openmotif-2.1.30 ) )
		gnome? ( gnome-base/gnome-desktop )
		)
	)
	nls? ( sys-devel/gettext )
	!nosendmail? ( virtual/mta )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58"

PROVIDE="virtual/emacs virtual/editor"
SANDBOX_DISABLED="1"

DFILE=emacs-${SLOT}.desktop

src_unpack() {
	# Emacs 21.4 uses leim from 21.3
	ln -s emacs-21.4 emacs-21.3

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/emacs-21.3-xorg.patch
	epatch ${FILESDIR}/emacs-21.3-amd64.patch
	epatch ${FILESDIR}/emacs-21.3-hppa.patch
	use ppc64 && epatch ${FILESDIR}/emacs-21.3-ppc64.patch

	epatch ${FILESDIR}/emacs-subdirs-el-gentoo.diff

	# This will need to be updated for X-Compilation
	sed -i -e "s:/usr/lib/\([^ ]*\).o:/usr/$(get_libdir)/\1.o:g" \
	       ${S}/src/s/gnu-linux.h

	sed -i -e "s/-lungif/-lgif/g" configure* src/Makefile.in || die
}

src_compile() {

	# -fstack-protector gets internal compiler error at xterm.c (bug 33265)
	filter-flags -fstack-protector

	# emacs doesn't handle LDFLAGS properly (bug #77430 and bug #65002)
	unset LDFLAGS

	# gcc 3.4 with -O3 or stronger flag spoils emacs
	if [ "$(gcc-major-version)" -ge 3 -a "$(gcc-minor-version)" -ge 4 ] ; then
		replace-flags -O[3-9] -O2
	fi

	export WANT_AUTOCONF=2.1
	autoconf

	local myconf
	use nls || myconf="${myconf} --disable-nls"
	if use X ; then
		if use motif && use lesstif; then
			append-ldflags -L/usr/X11R6/lib/lesstif -R/usr/X11R6/lib/lesstif
			export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include/lesstif"
		fi
		myconf="${myconf}
			--with-x
			--with-xpm
			--with-jpeg
			--with-tiff
			--with-gif
			--with-png"
		if use Xaw3d ; then
			myconf="${myconf} --with-x-toolkit=athena"
		elif use motif ; then
			myconf="${myconf} --with-x-toolkit=motif"
		else
			# do not build emacs with any toolkit, bug 35300
			myconf="${myconf} --with-x-toolkit=no"
		fi
	else
		myconf="${myconf} --without-x"
	fi
	econf ${myconf} || die
	emake CC="$(tc-getCC)" || die
}

src_install() {
	einstall || die
	for i in ${D}/usr/bin/* ; do
		mv ${i} ${i}.emacs-${SLOT} || die "mv ${i} failed"
	done
	mv ${D}/usr/bin/emacs{-${PV},}.emacs-${SLOT} || die "mv emacs failed"
	dohard /usr/bin/emacs.emacs-${SLOT} /usr/bin/emacs-${SLOT}

	einfo "Fixing info documentation..."
	mkdir ${T}/emacs-${SLOT}
	mv ${D}/usr/share/info/dir ${T}
	for i in ${D}/usr/share/info/*
	do
		mv ${i} ${T}/emacs-${SLOT}/${i##*/}.info
		gzip -9 ${T}/emacs-${SLOT}/${i##*/}.info
	done
	mv ${T}/emacs-${SLOT} ${D}/usr/share/info
	mv ${T}/dir ${D}/usr/share/info/emacs-${SLOT}

	newenvd ${FILESDIR}/60emacs-${SLOT}.envd 60emacs-${SLOT}

	einfo "Fixing manpages..."
	for m in ${D}/usr/share/man/man1/* ; do
		mv ${m} ${m/.1/.emacs-${SLOT}.1} || die "mv ${m} failed"
	done

	einfo "Fixing permissions..."
	find ${D} -perm 664 |xargs chmod 644
	find ${D} -type d |xargs chmod 755

	keepdir /usr/share/emacs/${PV}/leim

	dodoc BUGS ChangeLog README

	if use gnome ; then
		insinto /usr/share/applications
		doins ${FILESDIR}/${DFILE}
	fi
}

update-alternatives() {
	for i in emacs emacsclient etags ctags b2m ebrowse \
		rcs-checkin grep-changelog ; do
		alternatives_auto_makesym "/usr/bin/$i" "/usr/bin/${i}.emacs-*"
	done
}

pkg_postinst() {
	update-alternatives
	if use nosendmail ; then
	ewarn
	ewarn "You disabled sendmail support for Emacs. If you will install any MTA"
	ewarn "you need to recompile Emacs after that. See bug #11104."
	ewarn
	fi
}

pkg_postrm() {
	update-alternatives
}
