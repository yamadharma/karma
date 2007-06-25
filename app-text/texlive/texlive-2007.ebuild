# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit eutils flag-o-matic toolchain-funcs versionator virtualx elisp-common

TEXMF_PATH=/var/lib/texmf
#TEXMF_PATH=/etc/texmf

DESCRIPTION="a complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2"

SRC_URI="http://134.60.104.12/gentoo/${P}-src.tar.bz2
	http://134.60.104.12/gentoo/${P}-texmf-dist.tar.bz2
	http://134.60.104.12/gentoo/${P}-texmf.tar.bz2"

KEYWORDS="amd64 x86"
IUSE="X doc tk Xaw3d lesstif motif neXt png zlib emacs"

# This is less than an ideal name
PROVIDE="virtual/tetex"

# I hope to kick this very soon
BLOCKS="!dev-tex/memoir
	!dev-tex/lineno
	!dev-tex/SIunits
	!dev-tex/floatflt
	!dev-tex/g-brief
	!dev-tex/pgf
	!dev-tex/xcolor
	!dev-tex/xkeyval
	!dev-tex/latex-beamer
	!dev-tex/vntex
	!dev-tex/koma-script
	!dev-tex/currvita
	!dev-tex/eurosym
	!dev-tex/extsizes"

MODULAR_X_DEPEND="X? ( || ( (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libXaw
				x11-libs/libXfont
			)
			virtual/x11
		)
	)"

DEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/cstetex
	!app-text/tetex
	X? ( motif? ( lesstif? ( x11-libs/lesstif )
			!lesstif? ( x11-libs/openmotif ) )
		!motif? ( neXt? ( x11-libs/neXtaw )
			!neXt? ( Xaw3d? ( x11-libs/Xaw3d ) ) )
		!app-text/xdvik
	)
	sys-apps/ed
	sys-libs/zlib
	>=media-libs/libpng-1.2.1
	sys-libs/ncurses
	>=net-libs/libwww-5.3.2-r1"

RDEPEND="${DEPEND}
	${BLOCKS}
	>=dev-lang/perl-5.2
	tk? ( dev-perl/perl-tk )
	dev-util/dialog"

ELISP_DIRS="texk/xdvik texk/chktex utils/texinfo/util texmf-dist/doc/latex/curve texmf-dist/doc/mex/utf8mex texk/web2c/cwebdir"

src_unpack() {
	unpack ${P}-src.tar.bz2 || die "unpack src"

	cd "${S}"

	unpack ${P}-texmf.tar.bz2 || die "unpack texmf"
	unpack ${P}-texmf-dist.tar.bz2 || die "unpack texmf-dist"

	epatch "${FILESDIR}/${PV}/${P}-use-system-libtool.patch" || die
	epatch "${FILESDIR}/${PV}/${P}-gentoo-texmf.patch" || die
	epatch "${FILESDIR}/${PV}/${P}-mpware-libtool.patch" || die

	sed -i -e "/mktexlsr/,+3d" -e "s/\(updmap-sys\)/\1 --nohash/" \
		Makefile.in || die "sed"
}

src_compile() {
	local my_conf

	export LC_ALL=C

	filter-flags "-fstack-protector" "-Os"
	use amd64 && replace-flags "-O3" "-O2"

	if use X ; then
		addwrite /var/cache/fonts
		my_conf="${my_conf} --with-xdvik --with-oxdvik"
		if use motif ; then
			if use lesstif ; then
				append-ldflags -L/usr/X11R6/lib/lesstif -R/usr/X11R6/lib/lesstif
				export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include/lesstif"
			fi
			my_conf="${my_conf} --with-xdvi-x-toolkit=motif"
		elif use neXt ; then
			my_conf="${my_conf} --with-xdvi-x-toolkit=neXtaw"
		elif use Xaw3d ; then
			my_conf="${my_conf} --with-xdvi-x-toolkit=xaw3d"
		else
			my_conf="${my_conf} --with-xdvi-x-toolkit=xaw"
		fi
	else
		my_conf="${my_conf} --without-xdvik --without-oxdvik"
	fi

	if use zlib ; then
		my_conf="${my_conf} --with-system-zlib"
	fi

	if use png ; then
		my_conf="${my_conf} --with-system-pnglib"
	fi

	econf --bindir=/usr/bin \
		--datadir="${S}" \
		--with-system-ncurses \
		--with-system-freetype2 \
		--with-freetype2-include=/usr/include \
		--without-texinfo \
		--without-dialog \
		--without-texi2html \
		--disable-multiplatform \
		--with-epsfwin \
		--with-mftalkwin \
		--with-regiswin \
		--with-tektronixwin \
		--with-unitermwin \
		--with-ps=gs \
		--enable-ipc \
		--without-dvipng \
		--without-dvipdfm \
		--without-dvipdfmx \
		--without-psutils \
		--without-t1utils \
		$(use_with X x) \
		${my_conf} || die "econf"

	if use X && use ppc-macos ; then
		for f in $(find "${S}" -name config.status) ; do
			sed -i -e "s:-ldl::g" $f
		done
	fi

	emake -j1 texmf=${TEXMF_PATH:-/usr/share/texmf} || die "make"

	if ( use emacs )
	then
	    for i in ${ELISP_DIRS}
	    do
		elisp-compile ${S}/$i/*.el
	    done	
	fi


}

src_test() {
	fmtutil --fmtdir "${S}/texk/web2c" --all
	Xmake check || die "Xmake check failed."
}

src_install() {
	dodir /usr/share/
	cp -R texmf "${D}/usr/share"
	cp -R texmf-dist "${D}/usr/share"

	dodir ${TEXMF_PATH:-/usr/share/texmf}/web2c
	einstall \
		bindir="${D}/usr/bin" \
		texmf="${D}${TEXMF_PATH:-/usr/share/texmf}" \
	|| die "install"

	dosbin "${FILESDIR}/texmf-update"

	docinto texk
	cd "${S}/texk"
	dodoc ChangeLog README

	docinto kpathesa
	cd "${S}/texk/kpathsea"
	dodoc BUGS ChangeLog NEWS PROJECTS README

	docinto dviljk
	cd "${S}/texk/dviljk"
	dodoc ChangeLog README NEWS

	docinto dvipsk
	cd "${S}/texk/dvipsk"
	dodoc ChangeLog README

	docinto makeindexk
	cd "${S}/texk/makeindexk"
	dodoc ChangeLog NEWS NOTES README

	docinto ps2pkm
	cd "${S}/texk/ps2pkm"
	dodoc ChangeLog README README.14m

	docinto web2c
	cd "${S}/texk/web2c"
	dodoc ChangeLog NEWS PROJECTS README

	if use doc ; then
		dodir /usr/share/doc/${PF}/texmf
		mv ${D}/usr/share/texmf/doc/* \
			"${D}/usr/share/doc/${PF}/texmf" \
			|| die "mv texmf doc failed."
		cd "${D}/usr/share/texmf"
		rmdir doc
		ln -s ../doc/${PF}/texmf doc || die "ln -s doc failed."
		cd -
		dodir /usr/share/doc/${PF}/texmf-dist
		mv ${D}/usr/share/texmf-dist/doc/* \
			"${D}/usr/share/doc/${PF}/texmf-dist" \
			|| die "mv texmf-dist doc failed."
		cd "${D}/usr/share/texmf-dist"
		rmdir doc
		ln -s ../doc/${PF}/texmf-dist doc || die "ln -s doc failed."
		cd -
	else
		rm -rf "${D}/usr/share/texmf/doc"
		rm -rf "${D}/usr/share/texmf-dist/doc"
	fi

	dodir /var/cache/fonts

	# root group name doesn't exist on Mac OS X
	chown -R 0:0 "${D}/usr/share/texmf"

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c"' > "${D}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c
	# _not_ ${TEXMF_PATH}
	cd "${D}/usr/share/texmf"
	for d in $(find . -name config -type d | sed -e "s:\./::g") ; do
		dodir /etc/texmf/${d}
		for f in $(find "${D}usr/share/texmf/$d" -maxdepth 1 -mindepth 1); do
			mv $f "${D}/etc/texmf/$d" || die "mv $f failed"
			dosym /etc/texmf/$d/$(basename $f) /usr/share/texmf/$d/$(basename $f)
		done
	done
	cd -
	cd "${D}/${TEXMF_PATH}"
	for f in $(find . -name '*.cnf' -o -name '*.cfg' -type f | sed -e "s:\./::g") ; do
		if [ "${f/config/}" != "${f}" ] ; then
			continue
		fi
		dodir /etc/texmf/$(dirname $f)
		mv "${D}/${TEXMF_PATH}/$f" "${D}/etc/texmf/$(dirname $f)" || die "mv $f failed."
		dosym /etc/texmf/$f ${TEXMF_PATH}/$f
	done

	# take care of updmap.cfg, fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{updmap.d,fmtutil.d,texmf.d}
	dosym /etc/texmf/web2c/updmap.cfg ${TEXMF_PATH}/web2c/updmap.cfg
	dosym /etc/texmf/web2c/fmtutil.cnf ${TEXMF_PATH}/web2c/fmtutil.cnf
	dosym /etc/texmf/web2c/texmf.cnf ${TEXMF_PATH}/web2c/texmf.cnf
	mv "${D}/usr/share/texmf/web2c/updmap.cfg" "${D}/etc/texmf/updmap.d/00updmap.cfg"
	mv "${D}/usr/share/texmf/web2c/fmtutil.cnf" "${D}/etc/texmf/fmtutil.d/00fmtutil.cnf"
	mv "${S}/texk/kpathsea/texmf.cnf" "${D}/etc/texmf/texmf.d/00texmf.cnf"
	find ${D}/usr/share/texmf/web2c -name texmf.\* -exec rm -f {} \;

	# xdvi
	if use X ; then
		dodir /etc/X11/app-defaults /etc/texmf/xdvi
		mv "${D}${TEXMF_PATH}/xdvi/XDvi" "${D}/etc/X11/app-defaults" || die "mv XDvi failed"
		dosym /etc/X11/app-defaults/XDvi ${TEXMF_PATH}/xdvi/XDvi
	fi

	keepdir /usr/share/texmf-site

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	cd "${D}/usr/bin/"
	ln -snf platex latex
	ln -snf pdftex pdflatex
	ln -snf tex virtex
	ln -snf pdftex pdfvirtex

	if ( use emacs )
	then
	    for i in ${ELISP_DIRS}
	    do
		elisp-install tex-utils ${S}/$i/*.el ${S}/$i/*.elc
	    done	
	fi
	
}

pkg_preinst() {
	ewarn "Removing ${ROOT}usr/share/texmf/web2c"
	rm -rf "${ROOT}usr/share/texmf/web2c"
	ewarn "Removing ${ROOT}var/lib/texmf/web2c"
	rm -rf "${ROOT}var/lib/texmf/web2c"
	ewarn "Removing ${ROOT}etc/texmf/web2c"
	rm -rf "${ROOT}etc/texmf/web2c"
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi

	elog
	elog "If you have configuration files in /etc/texmf to merge,"
	elog "please update them and run /usr/sbin/texmf-update."
	elog
}
