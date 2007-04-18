# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a modification of the official qca ebuild

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qca"
inherit eutils qt4 subversion

#MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
#SRC_URI="http://delta.affinix.com/qca/2.0/beta1/${MY_P}.tar.bz2"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 mips ppc ppc64 sparc ~x86"
IUSE="ssl"

DEPEND=">=x11-libs/qt-4.1.0
	>=sys-devel/qconf-cvs-1.1"

S=${WORKDIR}/${PN}

#pkg_setup()
#{
#    if ! built_with_use x11-libs/qt debug ; then
#	echo
#        eerror "In order to compile qca, you need to have x11-libs/qt emerged"
#        eerror "with 'debug' in your USE flags. Please add that flag, re-emerge"
#        eerror "qt, and then emerge qca."
#        die "x11-libs/qt is missing the debug flag."
#    fi
#}

src_compile() {
	qconf
	./configure --enable-debug --prefix=/usr --qtdir=/usr || die "configure failed"
	sed -i \
		-e "/^CFLAGS/s:$: ${CFLAGS}:" \
		-e "/^CXXFLAGS/s:$: ${CXXFLAGS}:" \
		-e "/-strip/d" \
		Makefile
	make || die
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi
}
