# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mount-boot eutils flag-o-matic toolchain-funcs versionator

MY_PV=$(replace_version_separator 2 '+')
MY_PN=${PN}2
MY_P=${MY_PN}_${MY_PV}
DEB_PATCH_V=1

S=${WORKDIR}/${MY_P/_/-}.orig

DESCRIPTION="GNU GRUB 2 boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
#SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
#	mirror://gentoo/${P}.tar.gz"

SRC_URI="mirror://debian/pool/main/g/${MY_PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/g/${MY_PN}/${MY_P}-${DEB_PATCH_V}.diff.gz"
# 	mirror://debian/pool/main/g/grub2-splashimages/grub2-splashimages_1.0.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
# KEYWORDS="x86 amd64"
KEYWORDS=""
IUSE="custom-cflags debug doc multilib static"

DEPEND="!sys-boot/grub4dos
	>=sys-libs/ncurses-5.2-r5"
PROVIDE="virtual/bootloader"

# RESTRICT="strip"

SPLASH_DIR=/usr/share/images/grub/

export STRIP_MASK="*/grub/*/*.mod"
QA_EXECSTACK="sbin/grub-probe sbin/grub-setup"

src_prepare() {
	cd ${WORKDIR}
	epatch ${WORKDIR}/${MY_P}-${DEB_PATCH_V}.diff

	cd ${S}
	for i in debian/patches/*.diff
	do
	    epatch ${i}
	done
	
#	epatch ${FILESDIR}/grub-1.96-915resolution-0.5.2-3.patch
	
	# FIXME! File missing
	touch ${S}/docs/version.texi

	./autogen.sh
}

src_configure() {
	use custom-cflags || unset CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static

	local libdir="/$(get_libdir)"
	# on multilib'ed x86_64 put them in the right place
	use amd64 && use multilib && libdir="/lib32"

	econf \
		--sbindir=/sbin \
		--bindir=/bin \
		--libdir="${libdir}" \
		$(use_enable debug grub-emu) \
		$(use_enable debug grub-emu-usb) \
		$(use_enable debug grub-fstest) \
		--enable-grub-pe2elf \
		--enable-grub-mkfont

#		--enable-efiemu \
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
