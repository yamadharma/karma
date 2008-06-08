# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bzr distutils multilib

DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="https://launchpad.net/ami"
EBZR_REPO_URI="lp:///~yamadharma/ami/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""
DEPEND="
	|| (
		(
			x11-libs/libICE
			x11-libs/libXext
			x11-libs/libSM
			iontruetype? ( x11-libs/libXft )
		)
		virtual/x11
	)
	dev-util/pkgconfig
	app-misc/run-mailcap
	>=dev-lang/lua-5.1.1
	doc? ( dev-tex/latex2html
			virtual/tetex )"

S=${WORKDIR}/${P}

SCRIPTS_DIRS="keybindings scripts statusbar statusd styles"

#pkg_setup() {
#	export EBZR_REVISION=`echo "${PV}" | sed -e 's:^.\+_pre\(.*\)$:\1:g' `
#}

src_unpack() {
	bzr_src_unpack
}

src_compile() {
	local myconf=""

	make \
		LIBDIR=/usr/$(get_libdir) \
		DOCDIR=/usr/share/doc/${PF} || die
}

src_install() {

	emake \
		DESTDIR=${D} \
		DOCDIR=/usr/share/doc/${PF} \
		LIBDIR=/usr/$(get_libdir) \
	install || die

	echo -e "#!/bin/sh\n/usr/bin/ami" > ${T}/ami
	exeinto /etc/X11/Sessions
	doexe ${T}/ami

	insinto /usr/share/xsessions
	doins ${FILESDIR}/ami.desktop

	cd ${S}/scripts
	insinto /usr/share/ami
	find $SCRIPTS_DIRS -type f |\
		while read FILE
		do
			doins $PWD/$FILE
		done

}

