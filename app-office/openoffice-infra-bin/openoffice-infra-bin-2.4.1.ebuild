# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openoffice-bin/openoffice-bin-2.4.0.ebuild,v 1.1 2008/03/27 08:14:06 suka Exp $

inherit eutils fdo-mime multilib

#IUSE="gnome java kde"

BUILDID="9286"
MY_PV="${PV}rc6"
MY_PV2="${MY_PV}_20080314"
MY_PV3="${PV/_rc6/}-${BUILDID}"
PACKED="OOH680_m12_native_packed-1"
S="${WORKDIR}/${PACKED}_en-US.${BUILDID}/RPMS"
DESCRIPTION="Сборка OpenOffice от компании Инфра-ресурс"

SRC_URI="x86?	( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxIntel_ru_infra.tar.gz )
	amd64?	( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxX86-64_ru_infra.tar.gz )"

HOMEPAGE="http://www.i-rs.ru/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!app-office/openoffice
	x11-libs/libXaw
	sys-libs/glibc
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	>=media-libs/freetype-2.1.10-r2
	>=app-admin/eselect-oodict-20060706
	java? ( !amd64? ( >=virtual/jre-1.4 )
		amd64? ( app-emulation/emul-linux-x86-java ) )
	amd64? ( >=app-emulation/emul-linux-x86-xlibs-1.0 )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PROVIDE="virtual/ooo"
RESTRICT="strip"

QA_EXECSTACK="usr/$(get_libdir)/openoffice/program/*"
QA_TEXTRELS="usr/$(get_libdir)/openoffice/program/libvclplug_gen680li.so.1.1 \
	usr/$(get_libdir)/openoffice/program/python-core-2.3.4/lib/lib-dynload/_curses_panel.so \
	usr/$(get_libdir)/openoffice/program/python-core-2.3.4/lib/lib-dynload/_curses.so"

src_unpack() {
	unpack ${A}
}

src_install () {

	#Multilib install dir magic for AMD64
	has_multilib_profile && ABI=x86
	INSTDIR="/usr/$(get_libdir)/openoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv "${WORKDIR}"/openoffice.org2.4/* "${D}${INSTDIR}"

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/share/xdg/"

	for desk in base calc draw impress math printeradmin writer; do
		mv ${desk}.desktop openoffice.org-2.4-${desk}.desktop
		sed -i -e s/openoffice.org2.4/ooffice/g openoffice.org-2.4-${desk}.desktop || die
		sed -i -e s/openofficeorg24-${desk}/ooo-${desk}/g openoffice.org-2.4-${desk}.desktop || die
		domenu openoffice.org-2.4-${desk}.desktop
		insinto /usr/share/pixmaps
		newins "${FILESDIR}/oo_${desk}_v2.png" ooo-${desk}.png
	done

	#insinto /usr/share/mime/packages
	#doins "${WORKDIR}/usr/share/mime/packages/openoffice.org.xml"

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}/usr/bin/ooffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/oo${app}
	done

	dosym ${INSTDIR}/program/spadmin.bin /usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	# Change user install dir
	sed -i -e s/.openoffice.org2/.ooo-2.0/g "${D}${INSTDIR}/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/program/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-openoffice-bin"

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	eselect oodict update --libdir $(get_libdir)

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	elog " Чтобы запустить OpenOffice.org ${PV} Pro, выполните:"
	elog
	elog " $ ooffice"
	elog
	elog " Также, для конкретных компонентов, вы можете использовать следующее:"
	elog
	elog " oobase, oocalc, oodraw, ooimpress, oomath, или oowriter"
}
