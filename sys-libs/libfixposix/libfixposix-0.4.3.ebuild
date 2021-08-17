# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Thin wrapper over POSIX syscalls"
HOMEPAGE="https://github.com/sionescu/libfixposix"
SRC_URI="https://github.com/sionescu/libfixposix/archive/v${PV}.tar.gz -> libfixposix-${PV}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-libs/glibc"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	default
}
