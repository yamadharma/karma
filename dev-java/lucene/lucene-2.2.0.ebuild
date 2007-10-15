# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="http://lucene.apache.org/java"
SRC_URI="mirror://apache/lucene/java/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~ia64 ~ppc x86 ~x86-fbsd"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.6"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf contrib
	epatch ${FILESDIR}/common-build.xml.diff
}

src_compile() {
	eant jar-core $(use_doc javadocs)
}

src_install() {
	dodoc CHANGES.txt README.txt
	java-pkg_newjar build/${PN}-core-${PV}.jar ${PN}.jar

	use doc && java-pkg_dohtml -r docs/* build/docs/*
	use source && java-pkg_dosrc src/java/org

	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r src/demo/* ${D}/usr/share/doc/${PF}/examples
	fi
}
