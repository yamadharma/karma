# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit x-modular

EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"

DESCRIPTION="nouveau X.Org libdrm library"
HOMEPAGE="http://nouveau.freedesktop.org"
# KEYWORDS="x86 amd64"
KEYWORDS=""

src_compile() {
	x-modular_src_compile

	cd ${S}/tests
	emake dristat || die "Making test apps failed"
	emake drmstat || die "Making test apps failed"
}

src_install() {
	x-modular_src_install

	cd ${S}/tests/.libs
	dobin dristat
	dobin drmstat
}

pkg_preinst() {
	x-modular_pkg_preinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		cp -pPR "${ROOT}"/usr/$(get_libdir)/libdrm.so.{1,1.0.0} "${D}"/usr/$(get_libdir)/
	fi
}

pkg_postinst() {
	x-modular_pkg_postinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		elog "You must re-compile all packages that are linked against"
		elog "libdrm 1 by using revdep-rebuild from gentoolkit:"
		elog "# revdep-rebuild --library libdrm.so.1"
		elog "After this, you can delete /usr/$(get_libdir)/libdrm.so.1"
		elog "and /usr/$(get_libdir)/libdrm.so.1.0.0 ."
		epause
	fi
}
