# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=4

inherit java-pkg-2 java-ant-2

DESCRIPTION="PDF Core Font Information"
HOMEPAGE="https://github.com/jukka/pcfi"
GITHUB_USER="jukka"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/master.zip -> ${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=nomirror

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${PN}-master"

JAVA_PKG_BSFIX="off"

java_prepare() {
	cp -v "${FILESDIR}"/${P}_maven-build.xml build.xml
}

src_install() {
	java-pkg_newjar target/${PN}-SNAPSHOT.jar ${PN}.jar
}
