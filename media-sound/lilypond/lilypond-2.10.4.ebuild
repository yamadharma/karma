# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils

IUSE="debug emacs profile doc vim gtk2"

DESCRIPTION="GNU Music Typesetter"
SRC_URI="http://lilypond.org/download/sources/v$(get_version_component_range 1-2)/${P}.tar.gz
	doc? ( http://lilypond.org/download/binaries/documentation/${P}-1.documentation.tar.bz2 )"
HOMEPAGE="http://lilypond.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~sparc"

#NOTE: Lilypond chokes on guile 1.6.8
RDEPEND="|| ( =dev-scheme/guile-1.6.7 >=dev-scheme/guile-1.8.0 )
	|| (
		>app-text/ghostscript-gnu-8
		>app-text/ghostscript-gpl-8
		>app-text/ghostscript-esp-8
	)
	virtual/tetex
	>=dev-lang/python-2.3
	>=media-libs/freetype-2
	>=media-libs/fontconfig-2.2
	>=x11-libs/pango-1.12
	gtk2? ( >=x11-libs/gtk+-2.4 )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5.8.0-r12
	>=sys-apps/texinfo-4.8
	>=sys-devel/flex-2.5.4a-r5
	>=sys-devel/gcc-4.0
	>=sys-devel/make-3.80
	>=app-text/mftrace-1.1.19
	>=media-gfx/fontforge-20060125
	sys-devel/bison !=sys-devel/bison-1.75"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/lilypond-2.10.2-version.patch
	# lilypond python scripts *prepend* /usr/share/lilypond/2.10.3/python to
	# sys.path, causing python to attempt to rebuild the pyc, which generates
	# sandbox errors (and is wrong anyway).  Change this policy to use
	# sys.path.append so that PYTHONPATH, set by the Makefiles, takes
	# precendence.
	grep -rlZ sys.path.insert --include \*.py ${S} \
		| xargs -0r sed -i 's/sys.path.insert \?(0, /sys.path.append (/'
}

src_compile() {
	addwrite /root/.PfaEdit  # fontforge < 20060406, see bug 127723
	addwrite /var/cache/fonts
	addwrite /usr/share/texmf/fonts
	addwrite /usr/share/texmf/ls-R

	# parallel make used to cause problems when processing fonts
	# export MAKEOPTS="${MAKEOPTS} -j1"

	econf \
		$(use_enable debug debugging) \
		$(use_enable profile profiling) \
		$(use_enable gtk2 gui) \
		--with-ncsb-dir=/usr/share/fonts/default/ghostscript \
		|| die "econf failed"
	LC_ALL=C emake || die "emake failed"
}

src_install () {
	make install DESTDIR=${D} || die "install failed"

	dodoc COPYING ChangeLog NEWS.txt README.txt || die "dodoc failed"

	if use doc; then
		einfo "Installing documentation"
		cp -dr ${WORKDIR}/{Documentation,examples.html,input} \
			${D}/usr/share/doc/${PF}/ || die "doc install failed"

		# lilypond fails to uninstall docs cleanly because of recursive
		# symlinks. Here we eliminate the symlinks entirely and rebuild
		# all the html links that used them.
		find ${D}/usr/share/doc/${PF}/Documentation/user/{lilypond,music-glossary} \
			-maxdepth 1 -name "*.html" | xargs sed -i -e 's:source/:../../../:g'
		find ${D}/usr/share/doc/${PF}/Documentation/user -maxdepth 1 \
			-name "*.html" | xargs sed -i -e 's:source/:../../:g'
		rm ${D}/usr/share/doc/${PF}/Documentation/user/lilypond/source \
			${D}/usr/share/doc/${PF}/Documentation/user/source \
			${D}/usr/share/doc/${PF}/Documentation/user/music-glossary/source
	fi
	einfo "Fixing paths in python scripts"
	cd ${D}/usr/bin
	sed -i -e 's:/usr/lib/lilypond:/usr/share/lilypond:g' etf2ly
	sed -i -e 's:/usr/lib/lilypond:/usr/share/lilypond:g' midi2ly

	# vim support
	if use vim; then
		einfo "Installing vim support files"
		dodir /usr/share/vim
		mv ${D}/usr/share/lilypond/${PV}/vim \
			${D}/usr/share/vim/vimfiles || die "lilypond vim install failed"
	else
		rm -r ${D}/usr/share/lilypond/${PV}/vim
	fi

	# emacs (non-)support
	if ! use emacs; then
		rm -r ${D}/usr/share/emacs
	fi
}
