# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm -hppa ~ia64 mips ~ppc ~ppc-macos ~s390 ~sparc x86"
IUSE="readline"

DEPEND=""

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch "${FILESDIR}/${P}-luaconf-paths.patch"
	use readline || epatch "${FILESDIR}/${P}-no-readline.patch"
	sed -i doc/readme.html -e 's:\(/README\)\("\):\1.gz\2:g'
}

src_compile() {
	emake linux INSTALL_TOP=${D}/usr 
}

src_install() {
	make install INSTALL_TOP=${D}/usr
	dohtml doc/*.html doc/*.gif
	for i in `find . -name README -printf "%h\n"`; do
		docinto ${i#.}
		dodoc ${i}/README
	done
	insinto /usr/share/pixmaps
	doins etc/lua.xpm
	insinto /usr/$(get_libdir)/pkgconfig
	sed -i -e "s:^prefix=.*:prefix = /usr:" etc/lua.pc
	doins etc/lua.pc
}

src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve sort trace-calls"
	local negative="readonly undefined"
	local test

	for test in ${positive}; do
		test/lua.static test/${test}.lua || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua && die "test $test failed"
	done
}