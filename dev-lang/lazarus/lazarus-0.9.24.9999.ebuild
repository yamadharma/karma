# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib autotools subversion

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"
# ESVN_REPO_URI="http://svn.freepascal.org/svn/lazarus/trunk"
ESVN_PROJECT="lazarus"

# bug #183604
RESTRICT="strip"

FPCVER="2.2.2"

SLOT="0" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
LICENSE="GPL-2 LGPL-2.1 LGPL-2.1-linking-exception"
KEYWORDS="amd64 ~ppc x86"
DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi."
HOMEPAGE="http://www.lazarus.freepascal.org/"
# SRC_URI="mirror://sourceforge/lazarus/${P}-0.tar.gz"
IUSE="gtk gtk2 qt"

DEPEND="~dev-lang/fpc-${FPCVER}
	net-misc/rsync
	gtk? ( >=x11-libs/gtk+-1.0 )
	gtk2? ( >=x11-libs/gtk+-2.0 )
	qt? ( >=x11-libs/qt-4.0 )"
RDEPEND="${DEPEND}
	!=gnome-base/librsvg-2.16.1"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use "dev-lang/fpc" source; then
	    eerror "You need to build dev-lang/fpc with the 'source' USE flag"
	    eerror "in order for lazarus to work properly."
	    die "lazarus needs fpc built with the 'source' USE to work."
	fi

	if use gtk; then
		if use gtk2 || use qt; then
	    	eerror 'You selected the old gtk1 and gtk2 or Qt interface.'
			eerror 'Please disable all but one USE flag.'
			die "too many interfaces selected"
		fi
	elif use qt ; then
		if use gtk || use gtk2; then
	  		eerror 'You selected the Qt and the old gtk1 or gtk2 interface.'
			eerror 'Please disable all but one USE flag.'
			die "too many interfaces selected"
		fi
	elif use gtk2; then
		if use gtk || use qt; then
			eerror 'You selected the gtk2 and the old gtk or Qt interface.'
			eerror 'Please disable all but one USE flag.'
			die "too many interfaces selected"
		fi
	fi

	if use !qt && use !gtk && use !gtk2; then
		eerror 'You did not select any graphical interface.'
		eerror 'Please enable one single USE flag!'
		die 'no interface selected'
	fi
}

src_unpack() {
	# check for broken fpc.cfg
	# don't check in pkg_setup since it won't harm binpkgs
	if grep -q '^[ 	]*-Fu.*/lcl$' /etc/fpc.cfg
	then
		eerror "Your /etc/fpc.cfg automatically adds a LCL directory"
		eerror "to the list of unit directories. This will break the"
		eerror "build of lazarus."
		die "don't set the LCL path in /etc/fpc.cfg"
	fi

	subversion_src_unpack 
	sed -e "s/@FPCVER@/${FPCVER}/" "${FILESDIR}"/${P}-fpcsrc.patch \
		> "${T}"/fpcsrc.patch || die "could not sed fpcsrc patch"

	cd "${S}"
	epatch "${T}"/fpcsrc.patch

	eautomake
}

src_compile() {
	for i in configure.ac aclocal.m4 configure config.h.in; do
		touch "$i"
	done

	find . -name Makefile.in | xargs touch

	if use gtk; then
		LAZ_GUI="gtk"
	elif use gtk2; then
		LAZ_GUI="gtk2"
	elif use qt; then
		LAZ_GUI="qt"
	fi

	LCL_PLATFORM="${LAZ_GUI}" emake -j1 || die "make failed!"
}

src_install() {
	diropts -m0755
	dodir /usr/share
	# Using rsync to avoid unnecessary copies and cleaning...
	# Note: *.o and *.ppu are needed
	rsync -a \
		--exclude="CVS"     --exclude=".cvsignore" \
		--exclude="*.ppw"   --exclude="*.ppl" \
		--exclude="*.ow"    --exclude="*.a"\
		--exclude="*.rst"   --exclude=".#*" \
		--exclude="*.~*"    --exclude="*.bak" \
		--exclude="*.orig"  --exclude="*.rej" \
		--exclude=".xvpics" --exclude="*.compiled" \
		--exclude="killme*" --exclude=".gdb_hist*" \
		--exclude="debian"  --exclude="COPYING*" \
		--exclude="*.app" \
		"${S}" "${D}"usr/share \
	|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../lazarus/images/mainicon.xpm /usr/share/pixmaps/lazarus.xpm

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus" || die "Failed making desktop entry!"
}
