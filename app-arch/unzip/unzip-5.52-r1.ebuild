# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unzip/unzip-5.52-r2.ebuild,v 1.6 2008/03/29 16:57:06 jer Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="unzipper for pkzip-compressed files"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="mirror://gentoo/${PN}${PV/.}.tar.gz"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="rcc"

DEPEND="rcc? ( app-i18n/librcc )"


DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-no-exec-stack.patch
	epatch "${FILESDIR}"/${P}-CVE-2008-0888.patch #213761
#SDS
	use rcc && ( epatch ${FILESDIR}/${P}-ds-rusxmms.patch || die )
	use rcc && ( epatch ${FILESDIR}/${PN}-ds-unixenc.patch || die )

	ld_opts=""
#	use rcc && ld_opts="-lrcc"
	use rcc && ld_opts="-ldl"
	use rcc && cc_opts="-DRCC_LAZY=1"
#EDS

	sed -i \
		-e 's:-O3:$(CFLAGS) $(CPPFLAGS):' \
		-e 's:-O :$(CFLAGS) $(CPPFLAGS) :' \
		-e "s:CC=gcc :CC=\"$(tc-getCC) ${cc_opts}\" :" \
		-e "s:LD=gcc :LD=\"$(tc-getCC) ${ld_opts}\" :" \
		-e 's:LF2 = -s:LF2 = :' \
		-e 's:LF = :LF = $(LDFLAGS) :' \
		-e 's:SL = :SL = $(LDFLAGS) :' \
		-e 's:FL = :FL = $(LDFLAGS) :' \
		unix/Makefile \
		|| die "sed unix/Makefile failed"
}

src_compile() {
	local TARGET
	case ${CHOST} in
		i?86*-linux*) TARGET=linux_asm ;;
		*-linux*)     TARGET=linux_noasm ;;
		i?86*-freebsd* | i?86*-dragonfly* | i?86*-openbsd* | i?86*-netbsd*)
		              TARGET=freebsd ;; # mislabelled bsd with x86 asm
		*-freebsd* | *-dragonfly* | *-openbsd* | *-netbsd*)
		              TARGET=bsd ;;
		*-darwin*)    TARGET=macosx ;;
		*)            die "Unknown target, you suck" ;;
	esac
	append-lfs-flags #104315
	emake -f unix/Makefile ${TARGET} || die "emake failed"
}

src_install() {
	dobin unzip funzip unzipsfx unix/zipgrep || die "dobin failed"
	dosym unzip /usr/bin/zipinfo || die
	doman man/*.1
	dodoc BUGS History* README ToDo WHERE
}
