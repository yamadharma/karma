# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.17.50.0.5.ebuild,v 1.1 2006/09/27 23:57:32 vapier Exp $

PATCHVER="1.0"
UCLIBC_PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils
IUSE="nls multitarget multislot test vanilla bdirect"

# ARCH - packages to test before marking
KEYWORDS="-* amd64 x86"

src_unpack() {
	tc-binutils_unpack

	cd "${S}"

	if use bdirect; then
		epatch ${FILESDIR}/${PV}/${PN}-suse-bdirect.diff
		epatch ${FILESDIR}/${PV}/${PN}-suse-dynsort.diff
		epatch ${FILESDIR}/${PV}/${PN}-suse-hashvals.diff

	        # Filter --hash-style or build breaks..
	        filter-flags -Wl,--hash-style=*
	        filter-ldflags --hash-style=*
	        filter-ldflags -Wl,--hash-style=*
	fi

	epatch ${FILESDIR}/${PV}/${P}-fix-linker-alignment.patch

	tc-binutils_apply_patches
}

