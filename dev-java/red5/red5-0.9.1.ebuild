# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-utils-2 java-pkg-2 java-ant-2

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Open Source Flash Server written in Java"
HOMEPAGE="http://osflash.org/red5"
SRC_URI="http://dl.fancycode.com/red5/${PV}/src/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.5"
RDEPEND=">=virtual/jdk-1.5"

RED5_HOME=/opt/red5

pkg_setup() {
	enewgroup red5
	enewuser red5 -1 -1 ${RED5_HOME} red5
}

src_compile() {
	echo >> build.properties
	echo "java.target_version=$(java-pkg_get-vm-version)" >> build.properties
	sed -i -r "s/<conf (.*)$/<conf defaultCache=\"${S//\//\\/}\/.ivy\/cache\" \1/" ivyconfig.xml
	eant
}

src_install() {
	newinitd "${FILESDIR}"/red5.initd red5
	newconfd "${FILESDIR}"/red5.confd red5
	doenvd "${FILESDIR}"/21red5

	if ! use source ; then
		rm -rf test
		rm -rf bin
		rm -rf src
		rm -rf swf
		rm -f build.xml
		rm -f build.properties
		rm -f Makefile
	fi
	if use doc ; then
		dodoc doc/*
	fi
	rm -rf doc

	keepdir /var/lib/red5-webapps
	fowners red5:red5 /var/lib/red5-webapps/

	if use examples ; then
		insopts -m0644
		insinto /var/lib/red5-webapps
		doins -r webapps/*
		fowners -R red5:red5 /var/lib/red5-webapps/
	fi

	dosym /var/lib/red5-webapps ${RED5_HOME}/webapps
#	fowners red5:red5 ${RED5_HOME}/webapps

	insinto /var/lib/red5-webapps
	doins  webapps/red5-default.xml
	fowners red5:red5 /var/lib/red5-webapps/red5-default.xml

	rm -rf webapps

	rm -rf dumps
	rm -rf bin
	rm -rf dist
	rm -rf *.bat

	cp -rp * "${D}/${RED5_HOME}"
	fowners -R red5:red5 ${RED5_HOME}
}
