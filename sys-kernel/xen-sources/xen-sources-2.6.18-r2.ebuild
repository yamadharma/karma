# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xen-sources/xen-sources-2.6.16.49.ebuild,v 1.1 2007/05/02 03:31:45 marineam Exp $

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="10"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://www.xensource.com/xen/xen/"

XEN_VERSION="3.1.0"
XEN_BASE_KV="2.6.18.2"
XEN_PATCH="patch-${XEN_BASE_KV}_to_xen-${XEN_VERSION}.bz2"
#PATCH_URI="mirror://gentoo/${XEN_PATCH}"
PATCH_URI="http://dev.gentoo.org/~marineam/files/xen/${XEN_PATCH}"

# Security bugfixes included by Debian
SECURITY_BUGFIXES="debian-security-patches-2.6.18.1-12etch2.tar.bz2"
SECURITY_URI="http://dev.gentoo.org/~rbu/distfiles/${SECURITY_BUGFIXES}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${PATCH_URI} ${SECURITY_URI}"

UNIPATCH_LIST="${DISTDIR}/${XEN_PATCH}
			${DISTDIR}/${SECURITY_BUGFIXES}
			${FILESDIR}/${P}-make-install.patch"

KEYWORDS="x86 amd64"

#pkg_postinst() {
#	postinst_sources
#
#	elog "This kernel uses the linux patches released with Xen 3.0.4"
#	elog "It claims to have a 3.0.2 compatibility option but it may not work."
#}
