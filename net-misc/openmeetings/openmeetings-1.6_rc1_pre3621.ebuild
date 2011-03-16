# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit eutils multilib

MY_PV=${PV//./_}
MY_PV=${MY_PV/pre/r}

DESCRIPTION="Open-Source Web-Conferencing"
HOMEPAGE="http://code.google.com/p/openmeetings/"
SRC_URI="http://openmeetings.googlecode.com/files/openmeetings_${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="mysql postgres openoffice"
DEPEND=""
RDEPEND="dev-java/sun-jdk
	dev-java/jython
	openoffice? ( virtual/ooo )
	media-gfx/imagemagick
	virtual/ghostscript
	media-gfx/swftools
	media-video/ffmpeg[mp3]
	media-sound/sox
	postgres? ( virtual/postgresql-server 
		dev-java/jdbc-postgresql )
	mysql? ( virtual/mysql
		dev-java/jdbc-mysql )"

S=${WORKDIR}/red5

RED5_HOME=/usr/$(get_libdir)/red5

pkg_setup() {
	enewgroup red5
	enewuser red5 -1 -1 ${RED5_HOME} red5
}

src_install() {
	newinitd "${FILESDIR}"/red5.initd red5
	newconfd "${FILESDIR}"/red5.confd red5
	doenvd "${FILESDIR}"/21red5

	use openoffice && newinitd "${FILESDIR}"/openoffice.initd openoffice

	dodir ${RED5_HOME}
	cp -R ${S}/* ${D}/${RED5_HOME}/

	keepdir /var/log/red5
	fowners red5:red5 /var/log/red5
	rm -rf ${D}/${RED5_HOME}/log
	dosym /var/log/red5 ${RED5_HOME}/log

	keepdir /var/lib/red5/webapps/openmeetings/upload
	keepdir /var/lib/red5/webapps/openmeetings/uploadtemp
	fowners red5:red5 /var/lib/red5/webapps/openmeetings/upload
	fowners red5:red5 /var/lib/red5/webapps/openmeetings/uploadtemp

	rm -rf ${D}/${RED5_HOME}/webapps/openmeetings/upload
	dosym /var/lib/red5/webapps/openmeetings/upload ${RED5_HOME}/webapps/openmeetings/upload

	rm -rf ${D}/${RED5_HOME}/webapps/openmeetings/uploadtemp
	dosym /var/lib/red5/webapps/openmeetings/uploadtemp ${RED5_HOME}/webapps/openmeetings/uploadtemp

	mv ${D}/${RED5_HOME}/webapps/openmeetings/streams  ${D}/var/lib/red5/webapps/openmeetings
	dosym /var/lib/red5/webapps/openmeetings/streams ${RED5_HOME}/webapps/openmeetings/streams

	dodir /etc/red5
	mv ${D}/${RED5_HOME}/conf ${D}/etc/red5
	rm -rf ${D}/${RED5_HOME}/conf
	dosym /etc/red5/conf ${RED5_HOME}/conf

	dodir /etc/red5/webapps/openmeetings/
	mv ${D}/${RED5_HOME}/webapps/openmeetings/conf ${D}/etc/red5/webapps/openmeetings/
	rm -rf ${D}/${RED5_HOME}/webapps/openmeetings/conf
	dosym /etc/red5/webapps/openmeetings/conf ${RED5_HOME}/webapps/openmeetings/conf


	fowners -R red5:red5 ${RED5_HOME}
}

