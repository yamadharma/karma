# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Openfire (formerly Wildfire) Jabber server"
HOMEPAGE="http://www.igniterealtime.org"
#SRC_URI="http://www.igniterealtime.org/downloads/download-landing.jsp?file=openfire/${PN//-/_}_src_${PV//./_}.tar.gz"
#SRC_URI="http://www.igniterealtime.org/downloadServlet?filename=openfire/${PN//-/_}_src_${PV//./_}.tar.gz"
SRC_URI="mirror://gentoo/${PN//-/_}_src_${PV//./_}.tar.gz"
RESTRICT=""
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86 amd64"
IUSE="doc"

# For transports
PROVIDE="virtual/jabber-server"

RDEPEND=">=virtual/jre-1.5"
# Doesn't build against Java 1.6 due to changes in JDBC API
DEPEND="net-im/jabber-base
		=virtual/jdk-1.5*
		>=dev-java/ant-1.6
		dev-java/ant-contrib
		>=dev-java/commons-net-1.4"

S=${WORKDIR}/${PN//-/_}_src

pkg_setup() {
	if [ -f /etc/env.d/98openfire ]; then
		einfo "This is an upgrade"
	else
		ewarn "If this is an upgrade stop right ( CONTROL-C ) and run the command:"
		ewarn "echo 'CONFIG_PROTECT=\"/opt/openfire/resources/security/\"' > /etc/env.d/98openfire "
		ewarn "For more info see bug #139708"
		sleep 11
	fi
}

#src_unpack() {
#	unpack ${A}
#	cd ${S}
#	cp ${FILESDIR}/build.xml-${PV}.bz2 .
#	bunzip2 build.xml-${PV}.bz2
#	mv build.xml-${PV} build/build.xml
#	# TODO should replace jars in build/lib with ones packaged by us -nichoj
#}

src_compile() {
	# Jikes doesn't support -source 1.5
	java-pkg_filter-compiler jikes

	eant -f build/build.xml openfire plugins plugins-dev $(use_doc)
}

src_install() {
	doinitd ${FILESDIR}/init.d/openfire
	doconfd ${FILESDIR}/conf.d/openfire

	insinto /opt/openfire/conf
	newins target/openfire/conf/openfire.xml openfire.xml.sample

	keedir /opt/openfire/logs

	insinto /opt/openfire/lib
	doins target/openfire/lib/*

	insinto /opt/openfire/plugins
	doins -r target/openfire/plugins/*

	insinto /opt/openfire/resources
	doins -r target/openfire/resources/*

	if use doc; then
		dohtml -r documentation/docs/*
	fi
	dodoc documentation/dist/*

	#Protect ssl key on upgrade
	dodir /etc/env.d/
	echo 'CONFIG_PROTECT="/opt/openfire/resources/security/"' > ${D}/etc/env.d/98openfire
}

pkg_postinst() {
	chown -R jabber:jabber /opt/openfire

	ewarn If this is a new install, please edit /opt/openfire/conf/openfire.xml.sample
	ewarn and save it as /opt/openfire/conf/openfire.xml
	einfo
	ewarn The following must be be owned or writable by the jabber user.
	einfo /opt/openfire/conf/openfire.xml
}
