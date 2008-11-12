# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mount-boot eutils flag-o-matic toolchain-funcs versionator

MY_PV=$(replace_version_separator 2 '+')
MY_PN=${PN}2
MY_P=${MY_PN}_${MY_PV}
DEB_PATCH_V=1

S=${WORKDIR}/${MY_P/_/-}

DESCRIPTION="GNU GRUB 2 boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
#SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
#	mirror://gentoo/${P}.tar.gz"

SRC_URI="mirror://debian/pool/main/g/${MY_PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/g/${MY_PN}/${MY_P}-${DEB_PATCH_V}.diff.gz
	mirror://debian/pool/main/g/grub2-splashimages/grub2-splashimages_1.0.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS="x86 amd64"
KEYWORDS=""
IUSE="static custom-cflags"

DEPEND=">=sys-libs/ncurses-5.2-r5
	dev-libs/lzo"
PROVIDE="virtual/bootloader"

RESTRICT="strip"

SPLASH_DIR=/usr/share/images/grub/

src_prepare() {
	cd ${WORKDIR}
	epatch ${WORKDIR}/${MY_P}-${DEB_PATCH_V}.diff

	cd ${S}
	for i in debian/patches/*.diff
	do
	    epatch ${i}
	done
	
	touch ${S}/docs/version.texi
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86
	use custom-cflags || unset CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static

	econf \
		--prefix=/ \
		--datadir=/usr/lib \
		|| die "econf failed"
	emake -j1 || die "making regular stuff"

	cd ${S}/docs
	makeinfo --force grub.texi
	use doc && texi2pdf grub.texi

}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	
#	exeinto /etc/grub.d
#	doexe ${S}/debian/grub.d/*
	
#	into /
#	dosbin ${S}/debian/legacy/*
	
	
	cd ${WORKDIR}/grub2-splashimages-1.0.0
	dodir ${SPLASH_DIR}
	cp *.tga ${D}${SPLASH_DIR}
	newdoc README README.splashimages
	dodoc commons2tga.pl
	
	dodoc ${S}/docs/grub.cfg
	doinfo	${S}/docs/grub.info
	use doc && dodoc ${S}/docs/grub.pdf
	
}
