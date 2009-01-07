# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg

DESCRIPTION="Spark is an Open Source, cross-platform IM client optimized for businesses and organizations"
HOMEPAGE="http://www.igniterealtime.org/projects/spark/"
SRC_URI="http://www.igniterealtime.org/builds/spark/${PN//-/_}_${PV//./_}.tar.gz"
RESTRICT=""
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

src_unpack() {
	unpack ${A}
}

src_install() {
	java-pkg_dojar ${WORKDIR}/Spark/lib/*.jar
	java-pkg_dojar ${WORKDIR}/Spark/.install4j/*.jar
	
	insinto /usr/share/spark
	doins -r ${WORKDIR}/Spark/resources
	doins -r ${WORKDIR}/Spark/xtra
	doins -r ${WORKDIR}/Spark/plugins
	
	dobin ${FILESDIR}/spark
	
	unzip -qq ${WORKDIR}/Spark/lib/spark.jar
	doicon ${WORKDIR}/images/spark-64x64.png
	
	make_desktop_entry spark "Spark IM" spark-64x64 "Network;InstantMessaging"
	
	if use doc; then
		dohtml -r documentation/*
	fi
}

