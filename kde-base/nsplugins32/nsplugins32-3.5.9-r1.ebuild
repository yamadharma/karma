# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="32-bit Netscape plugins support for 64-bit Konqueror"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://debian/pool/main/k/kdelibs/kdelibs4c2a_3.5.9.dfsg.1-4_i386.deb
	mirror://debian/pool/main/k/kdebase/konqueror-nsplugins_3.5.9.dfsg.1-2+b1_i386.deb
	mirror://debian/pool/main/liba/libart-lgpl/libart-2.0-2_2.3.20-1_i386.deb
	mirror://debian/pool/main/libi/libidn/libidn11_1.7-1_i386.deb
	mirror://debian/pool/main/a/acl/libacl1_2.2.45-1_i386.deb
	mirror://debian/pool/main/a/attr/libattr1_2.4.41-1_i386.deb"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""
LOCKFILE="/var/lib/${PN}/lockfile"
DEPEND="|| ( ( ~kde-base/konqueror-3.5.9 ~kde-base/nsplugins-3.5.9 )
			~kde-base/kdebase-3.5.9 )
	app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-compat
	app-emulation/emul-linux-x86-gtklibs
	app-emulation/emul-linux-x86-qtlibs
	app-emulation/emul-linux-x86-sdl
	app-emulation/emul-linux-x86-soundlibs
	app-arch/dpkg"

pkg_setup() {
	elog "This package leads to file collisions with nspluginscan and"
	elog "nspluginviewer provided by the 64bits nsplugins package. These file"
	elog "collisions are not critical, as the 64bits files are backed-up and"
	elog "will be restored when this package is unmerged."
}

src_unpack() {
	cd "${WORKDIR}"
	for pkg in ${A}
	do
		/usr/bin/dpkg --extract "${DISTDIR}"/$pkg "${WORKDIR}"
	done
}

src_install() {
	local KDEDIR=`kde-config --prefix`
	cd "${WORKDIR}"
	echo "Installing - please don't remove manually" > ${T}/lockfile \
		|| die "Can't create lockfile."
	insinto /var/lib/${PN}/
	doins ${T}/lockfile || die "Can't install lockfile."

	# copy over the needed libraries, preserving their symlinks
	dodir "${KDEDIR}"/lib32/
	for i in usr/lib/libkdesu.so* usr/lib/libkdeui.so* usr/lib/libkio.so* \
		usr/lib/libkwalletclient.so* usr/lib/libart_lgpl_2.so* \
		usr/lib/libidn.so* usr/lib/libkparts.so* lib/libattr.so* \
		lib/libacl.so* ; do
			cp -pPv $i "${D}"/"${KDEDIR}"/lib32/
	done

	into "${KDEDIR}"
	dobin usr/bin/nsplugin*

	# make backup copy of 64bits versions
	cp "${ROOT}"/"${KDEDIR}"/bin/nspluginscan "${D}"/"${KDEDIR}"/bin/nspluginscan64
	cp "${ROOT}"/"${KDEDIR}"/bin/nspluginviewer "${D}"/"${KDEDIR}"/bin/nspluginviewer64
}

pkg_postinst() {
	rm ${LOCKFILE}
}

pkg_prerm() {
	local KDEDIR=`kde-config --prefix`
	if [ ! -r ${LOCKFILE} ]; then
		cp "${ROOT}"/"${KDEDIR}"/bin/nspluginscan64 "${ROOT}"/var/lib/${PN}/nspluginscan
		cp "${ROOT}"/"${KDEDIR}"/bin/nspluginviewer64 "${ROOT}"/var/lib/${PN}/nspluginviewer
	fi
}

pkg_postrm() {
	local KDEDIR=`kde-config --prefix`
	if [ ! -r ${LOCKFILE} ]; then
		einfo "Restoring 64-bit Konqueror plugins"
		mv "${ROOT}"/var/lib/${PN}/nsplugin* "${ROOT}"/"${KDEDIR}"/bin
	else
		einfo "Upgrading or rebuilding package. Not restoring 64-bit plugins."
	fi
}
