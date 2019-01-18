# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils fdo-mime multilib

DESCRIPTION="Cisco's Packet Tracer"
HOMEPAGE="https://www.netacad.com"
SRC_URI="Packet_Tracer_${PV}_for_Linux_64_bit.tar.gz"


RESTRICT="fetch mirror strip userpriv"
LICENSE="Cisco_EULA"

SLOT="0"
# KEYWORDS="~amd64"
IUSE="doc online-exam"

DEPEND="app-arch/gzip"

RDEPEND="
	doc? ( www-plugins/adobe-flash  )
"

S=${WORKDIR}

pkg_nofetch () {
	ewarn "To fetch sources you need cisco account which is available in case"
	ewarn "you are cisco web-learning student, instructor or you sale cisco hardware, etc..  "
	einfo ""
	einfo ""
	einfo "After that point your browser at http://www.netacad.net/"
	einfo "Login, go to PacketTracer image and download:"
	einfo "Cisco Packet Tracer ${PV} for Linux - Ubuntu installation"
	einfo "file and save it to ${DISTDIR}"
}

#src_prepare(){
#
#	for file in install set_ptenv.sh tpl.linguist tpl.packettracer \
#							extensions/ptaplayer bin/linguist; do
#		 rm -fr  ${file} || die "unable to rm ${file}"
#	done
#	use !doc && rm -fr "${S}/"help/default/tutorials
#}

src_install () {

	local PKT_HOME="/opt/${P}"

	dodir "${PKT_HOME}"

	cp -r "${S}/"*   "${D}/${PKT_HOME}"  || die "Install failed!"

	doicon "${S}/art/"{app,pka,pkt,pkz}.{ico,png}

	# make_wrapper packettracer "./bin/PacketTracer7" "${PKT_HOME}" "${PKT_HOME}/lib"
	dosym "${D}${PKT_HOME}/bin/PacketTracer7" /usr/bin/packettracer
	make_desktop_entry "packettracer"  "PacketTracer 7.1 (Student)" "app" "Education;Emulator;System"

	insinto /usr/share/mime/applications
	doins bin/*.xml

	rm -f "${D}${PKT_HOME}/bin/"*.xml

	dodir /etc/env.d
	cat <<- --PKTHOME-- > "${D}/etc/env.d/50${P}" || die "env.d files install failed"
	PT6HOME="${PKT_HOME}" 
	--PKTHOME--
}

pkg_postinst(){

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	einfo ""
	einfo " If you have multiuser enviroment"
	einfo " you mist configure you firewall to use UPnP protocol."
	einfo " Additional information see in packettracer user manual "

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

}
