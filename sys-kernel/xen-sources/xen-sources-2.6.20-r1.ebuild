# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="13"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://www.xensource.com/xen/xen/"

# Basic XEN functionality
XEN_VERSION="3.1.0-fc7-2925"
XEN_BASE_KV="2.6.20"
XEN_PATCH="patch-${XEN_BASE_KV}_to_xen-${XEN_VERSION}.bz2"
#PATCH_URI="mirror://gentoo/${XEN_PATCH}"
PATCH_URI="http://dev.gentoo.org/~marineam/files/xen/${XEN_PATCH}"

# Bugfixes included by fedora
XEN_BUGFIXES="fedora-xen-patches-2.6.20-2925.13.fc7.tar.bz2"
BUGFIX_URI="http://dev.gentoo.org/~rbu/distfiles/${XEN_BUGFIXES}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${PATCH_URI} ${BUGFIX_URI}"

UNIPATCH_LIST="${DISTDIR}/${XEN_PATCH}
			${DISTDIR}/${XEN_BUGFIXES}
			${FILESDIR}/${P}-console-tty-fix.patch
			${FILESDIR}/${P}-quirks-no-smp-fix.patch
			${FILESDIR}/${PN}-2.6.18-make-install.patch"

KEYWORDS="~x86 ~amd64"

DEPEND="${DEPEND}
	>=sys-devel/binutils-2.17"

pkg_postinst() {
	postinst_sources

	elog "This kernel is for Xen 3.1.0 and based on RedHat's patchset in"
	elog "Fedora 7. If you have troubles, try xen-sources-2.6.18* which is"
	elog "based on the patches released with Xen."
}
