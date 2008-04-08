# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod eutils linux-info

MY_P="cifs-${PV}"
DESCRIPTION="Advanced Common Internet File System for Linux with Etersoft extension"
HOMEPAGE="http://us1.samba.org/samba/Linux_CIFS_client.html"
SRC_URI="http://pserver.samba.org/samba/ftp/cifs-cvs/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="-* x86 amd64"
IUSE="kernel_linux"

DEPEND="kernel_linux? ( virtual/linux-sources )"

S=${WORKDIR}/new-cifs-backport

pkg_setup() {
	if use kernel_linux ; then
		MODULE_NAMES="cifs(eter-cifs:${S})"
		CONFIG_CHECK="CIFS"

		linux-mod_pkg_setup
		kernel_is 2 4 && die "kernel 2.4 is not supported by this ebuild. Get an older version from viewcvs"

		BUILD_PARAMS="-C ${KERNEL_DIR} M=${WORKDIR}/cifs-bld-tmp/fs/cifs"
		BUILD_TARGETS="modules"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/linux-cifs-shared-1.50c.patch
}

src_compile() {
	if use kernel_linux ; then
		cd "${S}"
		linux-mod_src_compile
	fi
}

src_install() {

	if use kernel_linux ; then
		linux-mod_src_install
	fi

}

pkg_postinst() {
	use kernel_linux && linux-mod_pkg_postinst
	
	elog ""
	elog "Don't forget to add module cifs to /etc/modules.autoload.d/kernel-2.6"
	elog "and switch off the Linux Extensions for cifs by adding:"
	elog ""
	elog "echo 0 > /proc/fs/cifs/LinuxExtensionsEnable to /etc/conf.d/local.start"
	elog ""
}
