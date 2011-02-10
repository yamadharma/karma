# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

SLOT=0

inherit eutils versionator

MY_P=${P}-src-release

DESCRIPTION="DSpace open source software enables open sharing of content that spans organizations, continents and time"
HOMEPAGE="http://www.dspace.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
#         doc? ( http://www.dspace.org/${PV//./_}Documentation/DSpace-Manual.pdf -> DSpace-Manual-${PV}.pdf ) "

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~alpha ~amd64-fbsd ~arm ~hppa ~ia64 ~m68k ~mips ~ppc
          ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86-fbsd"
IUSE="resin tomcat doc javadoc"

RDEPEND="
	dev-db/postgresql-server
	dev-lang/perl
	>=virtual/jdk-1.5
	tomcat? ( www-servers/tomcat )
	resin? ( www-servers/resin )
"

DEPEND="${RDEPEND}
	dev-java/maven-bin
	dev-java/ant
"

S="${WORKDIR}/${MY_P}"

DSPACE_DIR=/usr/share/webapps/${PN}
DSPACE_SRC_DIR_PREFIX=/usr/src
DSPACE_SRC_DIR=${DSPACE_SRC_DIR_PREFIX}/${PF}

pkg_setup() {
	use tomcat && TOMCAT_V=7
	#use tomcat && TOMCAT_V=$(best_version www-servers/tomcat)
	#TOMCAT_V=${TOMCAT_V%*.*.*}
}

src_prepare() {
	sed -i -e "s:^dspace.dir =.*$:dspace.dir = ${DSPACE_DIR}:g" \
		${S}/dspace/config/dspace.cfg
}

src_compile() {
	if ! eselect maven show >/dev/null 2>&1; then
		eerror
		eerror No maven target is set. Please run \'eselect maven update\' \(as root\)
		eerror
		die "No maven target is set."
	fi
	mvn package
	use javadoc && mvn javadoc:javadoc
}

src_install() {
	dodir ${DSPACE_DIR}
	dodir ${DSPACE_SRC_DIR}
	rmdir ${D}${DSPACE_SRC_DIR}
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

	use tomcat && ( cd ${D}${DSPACE_DIR}/webapps/; for i in *; do dosym ${DSPACE_DIR}/webapps/${i} /var/lib/tomcat-${TOMCAT_V}/webapps/; done )
	use resin && ( cd ${D}${DSPACE_DIR}/webapps/; for i in *; do dosym ${DSPACE_DIR}/webapps/${i} /var/lib/resin/webapps/; done )

	mv ${D}${DSPACE_DIR} ${D}${DSPACE_SRC_DIR} || die
	dosym ${PF} ${DSPACE_SRC_DIR_PREFIX}/${PN}

	use doc && ( cd dspace/docs/pdf && dodoc DSpace-Manual.pdf || die )
}

pkg_postinst() {
	if [ -d "${DSPACE_DIR}" ]
	then
		cd ${DSPACE_SRC_DIR}
		ant update
	fi

	use tomcat && chown -R tomcat:tomcat ${DSPACE_DIR}
	use resin && chown -R resin:resin ${DSPACE_DIR}

	elog If you are installing ${PN} for the first time,
	elog you will need to run
	elog \ \ \ \ emerge --config =${CATEGORY}/${PF}
	elog in order to create initial ${PN} database
	elog
	elog If you are upgrading an existing installation of
	elog ${PN}, then you MUST follow the upgrade procedure
	elog outlined in http://www.dspace.org/${PV//./_}Documentation/ch04.html
	elog
}

pkg_config() {
	createuser -U postgres -d -A -P dspace
	createdb -U dspace -E UNICODE dspace

	cd ${DSPACE_SRC_DIR}
	ant fresh_install
}
