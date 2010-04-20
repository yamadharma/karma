# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit eutils

MY_PV=${PV/./_}
MY_PV=${MY_PV/pre/r}

DESCRIPTION="Open-Source Web-Conferencing"
HOMEPAGE="http://code.google.com/p/openmeetings/"
SRC_URI="http://openmeetings.googlecode.com/files/openmeetings_${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="mysql postgres"
DEPEND=""
RDEPEND="dev-java/sun-jdk
	dev-java/jython
	|| ( app-office/openoffice app-office/openoffice-bin )
	media-gfx/imagemagick
	virtual/ghostscript
	media-gfx/swftools
	media-video/ffmpeg[mp3]
	media-sound/sox
	postgres? ( virtual/postgresql-server 
		dev-java/jdbc-postgresql )
	mysql? ( virtual/mysql 
		dev-java/jdbc-mysql )"

# S=${WORKDIR}/openmeetings_${MY_PV}
S=${WORKDIR}/red5

RED5_HOME=/usr/lib/red5

pkg_setup() {
	enewgroup red5
	enewuser red5 -1 -1 ${RED5_HOME} red5
}

src_install() {
	newinitd "${FILESDIR}"/red5.initd red5
	newconfd "${FILESDIR}"/red5.confd red5
	doenvd "${FILESDIR}"/21red5

	newinitd "${FILESDIR}"/openoffice.initd openoffice

	dodir ${RED5_HOME}
	cp -R ${S}/* ${D}/${RED5_HOME}/

#	if ! use source ; then
#		rm -rf test
#		rm -rf bin
#		rm -rf src
#		rm -rf swf
#		rm -f build.xml
#		rm -f build.properties
#		rm -f Makefile
#	fi
#	if use doc ; then
#		dodoc doc/*
#	fi
#	rm -rf doc

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


#	keepdir /var/lib/red5-webapps
#	fowners red5:red5 /var/lib/red5-webapps/

#	cp -R ${S}/webapps/* ${D}/var/lib/red5-webapps/
#	rm -rf ${D}/${RED5_HOME}/webapps

#	if use examples ; then
#		insopts -m0644
#		insinto /var/lib/red5-webapps
#		doins -r webapps/*
#		fowners -R red5:red5 /var/lib/red5-webapps/
#	fi

#	dosym /var/lib/red5-webapps ${RED5_HOME}/webapps
#	fowners red5:red5 ${RED5_HOME}/webapps

#	insinto /var/lib/red5-webapps
#	doins  webapps/red5-default.xml
#	fowners red5:red5 /var/lib/red5-webapps/red5-default.xml

#	rm -rf webapps

#	rm -rf dumps
#	rm -rf bin
#	rm -rf dist
#	rm -rf *.bat

#	cp -rp * "${D}/${RED5_HOME}"
	fowners -R red5:red5 ${RED5_HOME}
}

