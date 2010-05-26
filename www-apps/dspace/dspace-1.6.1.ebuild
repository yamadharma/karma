# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

SLOT=0

inherit eutils

MY_P=${P}-src-release

DESCRIPTION="DSpace open source software enables open sharing of content that spans organizations, continents and time"
HOMEPAGE="http://www.dspace.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="resin tomcat"

DEPEND="dev-java/maven-bin
	virtual/postgresql-server
	dev-lang/perl
	dev-java/ant
	>=virtual/jdk-1.5
	tomcat? ( www-servers/tomcat )
	resin? ( www-servers/resin )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DSPACE_DIR=/var/lib/dspace
DSPACE_SRC_DIR=/usr/share/dspace-source

src_prepare() {
	sed -i -e "s:^dspace.dir =.*$:dspace.dir = ${DSPACE_DIR}:g" \
		${S}/dspace/config/dspace.cfg
}

src_compile() {
	mvn package
}

src_install() {
	dodir ${DSPACE_DIR}
	cp -R ${S}/dspace/target/${P}-build.dir/* ${D}${DSPACE_DIR}
	chmod +x ${D}${DSPACE_DIR}/bin/*

	dodir /etc
	mv ${D}${DSPACE_DIR}/config ${D}/etc/dspace
	dosym /etc/dspace ${DSPACE_DIR}/config

	dodir /etc/cron.d
	sed -e "s:@DSPACE_DIR@:$DSPACE_DIR:g" ${FILESDIR}/dspace.crond.in > ${D}/etc/cron.d/dspace
	sed -e "s:@DSPACE_DIR@:$DSPACE_DIR:g" ${FILESDIR}/dspace-stat.crond.in > ${D}/etc/cron.d/dspace-stat

	use tomcat && chown -R tomcat:tomcat ${D}${DSPACE_DIR}
	use resin && chown -R resin:resin ${D}${DSPACE_DIR}

	use tomcat && (cd ${D}${DSPACE_DIR}/webapps/; for i in *; do dosym ${DSPACE_DIR}/webapps/${i} /var/lib/tomcat-6/webapps/; done )
	use resin && (cd ${D}${DSPACE_DIR}/webapps/; for i in *; do dosym ${DSPACE_DIR}/webapps/${i} /var/lib/resin/webapps/; done )

	mv ${D}${DSPACE_DIR} ${D}${DSPACE_SRC_DIR}
}

pkg_postinst() {
	if [ -d "${DSPACE_DIR}" ]
	then
		cd ${DSPACE_SRC_DIR}
		ant update
	fi

	use tomcat && chown -R tomcat:tomcat ${DSPACE_DIR}
	use resin && chown -R resin:resin ${DSPACE_DIR}
}

pkg_config() {
	createuser -U postgres -d -A -P dspace
	createdb -U dspace -E UNICODE dspace

	cd ${DSPACE_SRC_DIR}
	ant fresh_install
}
