# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

RESTRICT="strip" # Gentoo bug 269221.

FPCVER="2.4.0"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1 LGPL-2.1-linking-exception"
KEYWORDS="~amd64 ~ppc ~x86"
DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi."
HOMEPAGE="http://www.lazarus.freepascal.org/"
IUSE=""
SRC_URI="mirror://sourceforge/lazarus/${P}-src.tar.bz2"

DEPEND="~dev-lang/fpc-${FPCVER}[source]
	net-misc/rsync
	>=x11-libs/gtk+-2.0	
	>=sys-devel/binutils-2.19.1-r1"

RDEPEND="${DEPEND}
	!=gnome-base/librsvg-2.16.1"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fpcsrc.patch

	# Use default configuration (minus stripping) unless specifically requested otherwise.
	if ! test ${PPC_CONFIG_PATH+set} ; then
		local FPCVER=$(fpc -iV)
		export PPC_CONFIG_PATH="${WORKDIR}"
		sed -e 's/^FPBIN=/#&/' /usr/lib/fpc/${FPCVER}/samplecfg |
			sh -s /usr/lib/fpc/${FPCVER} "${PPC_CONFIG_PATH}" || die
	fi		
}

src_compile() {
	LCL_PLATFORM=gtk2 emake -j1 || die "make failed!"
}

src_install() {
	diropts -m0755
	dodir /usr/share
	# Using rsync to avoid unnecessary copies and cleaning...
	# Note: *.o and *.ppu are needed

	# Why we do not install these files:	
	#  Exclude '*.rst' is a temporary file.
	#  Exclude 'debian' Debian files.
	#  Exclude 'COPYING*' licenses files.
	#  Exclude '*.app' Mac OS X files.
	rsync -a \
		--exclude="*.rst" \
		--exclude="debian" \
		--exclude="COPYING*" \
		--exclude="*.app" \
		"${S}" "${D}"usr/share \
	|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../share/lazarus/startlazarus /usr/bin/lazarus || die "Looks like you have found a conflict. Please run 'equery belongs /usr/bin/lazarus' and file a bug report with the information."
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus" || die "Failed making desktop entry!"
}

