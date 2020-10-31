# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SLOT="${PV%%.*}"
DOWNLOAD_URL="https://www.oracle.com/java/technologies/javase-jdk${SLOT}-doc-downloads.html"

DESCRIPTION="Oracle's documentation bundle (including API) for Java SE"
HOMEPAGE="https://docs.oracle.com/javase/${SLOT}"
SRC_URI="jdk-${PV}_doc-all.zip"
LICENSE="oracle-java-documentation-${SLOT}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="fetch"

DEPEND="app-arch/unzip"

S="${WORKDIR}/docs"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from"
	einfo "${DOWNLOAD_URL}"
	einfo "by agreeing to the license and place it in your distfiles directory."
}

src_install() {
	insinto /usr/share/doc/${PN}-${SLOT}/html
	doins -r index.html */
}
