inherit eutils fdo-mime rpm multilib

IUSE="gnome java"

BUILDID="9311"

MY_PV0="${PV/_p/-}" # "2.4.1_p1" -> "2.4.1-1"

PACKED="ru"

S="${WORKDIR}/${PACKED}/RPMS"

DESCRIPTION="OpenOffice productivity suite Infra-Resource edition for russian-speaking users"

MIRROR_BASE="http://ftp.chg.ru/pub/OpenOffice-RU/${MY_PV0}/ru"
SRC_URI="x86? ( ${MIRROR_BASE}/OOo_${MY_PV0}_LinuxIntel_install_ru_infra.tar.gz )
	amd64? ( ${MIRROR_BASE}/OOo_${MY_PV0}_LinuxX86-64_install_ru_infra.tar.gz )"

HOMEPAGE="http://www.i-rs.ru"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!app-office/openoffice
	!app-office/openoffice-bin
	virtual/pam
	x11-libs/libXaw
	sys-libs/glibc
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	>=media-libs/freetype-2.1.10-r2
	>=app-admin/eselect-oodict-20060706
	java? ( >=virtual/jre-1.4  )"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PROVIDE="virtual/ooo"
RESTRICT="strip mirror"

QA_EXECSTACK="usr/$(get_libdir)/openoffice/program/*"
QA_TEXTRELS="usr/$(get_libdir)/openoffice/program/libvclplug_gen680li.so.1.1 \
	usr/$(get_libdir)/openoffice/program/python-core-${MY_PV0}/lib/lib-dynload/_curses_panel.so \
	usr/$(get_libdir)/openoffice/program/python-core-${MY_PV0}/lib/lib-dynload/_curses.so"

pkg_setup(){
	ewarn "This ebuild is aimed at russian speaking users and contain only ru_RU locale"
	epause 5
}

src_unpack() {
	OOO_MODULES="base calc core01 core02 core03 core03u core04 core04u core05
			core05u core06 core07 core08 core09 core10 draw emailmerge graphicfilter
			headless impress math pyuno testtool writer xsltfilter"
	MY_PV1=$( echo -n "${PV}" | sed "s/_p.*$/-${BUILDID}/" ) # "2.4.1_p1" -> "2.4.1-9311"
	MY_PV2=$( echo -n "${PV}" | sed "s/\.[0-9]_p.*$/-${BUILDID}/" ) # "2.4.1_p1" -> "2.4-9311"

	unpack ${A}

	local ooo_arch="i586"
	use amd64 && ooo_arch="x86_64"

	use gnome && OOO_MODULES="${OOO_MODULES} gnome-integration"
	# Where is KDE integration? O_O
	#use kde && OOO_MODULES="${OOO_MODULES} kde-integration"
	use java && OOO_MODULES="${OOO_MODULES} javafilter"
	for i in $OOO_MODULES; do
		einfo "Unpacking ${i}..."
		rpm_unpack "${S}/openoffice.org-${i}-${MY_PV1}.${ooo_arch}.rpm" || die "Can't unpack"
	done

	einfo "Unpacking freedesktop-menus..."
	rpm_unpack "${S}/desktop-integration/openoffice.org-freedesktop-menus-${MY_PV2}.noarch.rpm" || die "Can't unpack"

	#strip-linguas en ${LANGS}

	#for i in ${LINGUAS}; do
	#	i="${i/_/-}"
	#	if [[ ${i} != "en" ]] ; then
	#		LANGDIR="${WORKDIR}/${PACKED}_${i}.${BUILDID}/RPMS/"
	#		rpm_unpack ${LANGDIR}/openoffice.org-${i}-${MY_PV1}.${ooo_arch}.rpm
	#		rpm_unpack ${LANGDIR}/openoffice.org-${i}-help-${MY_PV1}.${ooo_arch}.rpm
	#		rpm_unpack ${LANGDIR}/openoffice.org-${i}-res-${MY_PV1}.${ooo_arch}.rpm
	#	fi
	#done
}

src_install () {
	MY_PV1=$( echo -n "${PV}" | sed "s/\.[0-9]_p.*$//" ) # "2.4.1_p1" -> "2.4"
	OOO_PROGRAMS="base calc draw impress math printeradmin writer"
	INSTDIR="/usr/$(get_libdir)/openoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/openoffice.org${MY_PV1}/* "${D}${INSTDIR}"

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/share/xdg/"

	for desk in $OOO_PROGRAMS; do
		mv ${desk}.desktop openoffice.org-${MY_PV1}-${desk}.desktop
		sed -i -e s/openoffice.org${MY_PV1}/ooffice/g openoffice.org-${MY_PV1}-${desk}.desktop || die
		sed -i -e s/openofficeorg24-${desk}/ooo-${desk}/g openoffice.org-${MY_PV1}-${desk}.desktop || die
		domenu openoffice.org-${MY_PV1}-${desk}.desktop
		insinto /usr/share/pixmaps
		newins "${WORKDIR}/usr/share/icons/gnome/48x48/apps/openofficeorg24-${desk}.png" ooo-${desk}.png
	done

	insinto /usr/share/mime/packages
	doins "${WORKDIR}/usr/share/mime/packages/openoffice.org.xml"

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

	# Remove the provided dictionaries, we use our own instead
	rm -f "${D}"${INSTDIR}/share/dict/ooo/*

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-openoffice-bin"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	eselect oodict update --libdir $(get_libdir)

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	elog " To start OpenOffice.org, run:"
	elog
	elog " $ ooffice"
	elog
	elog " Also, for individual components, you can use any of:"
	elog
	elog " oobase, oocalc, oodraw, ooimpress, oomath, or oowriter"
	elog
	elog " Spell checking is now provided through our own myspell-ebuilds, "
	elog " if you want to use it, please install the correct myspell package "
	elog " according to your language needs. "
}
