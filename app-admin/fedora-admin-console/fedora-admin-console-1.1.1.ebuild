# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 eutils java-ant-2

MY_V=1.1.1
MY_MV=1.1

DESCRIPTION="Fedora Admin Server Management Console"
HOMEPAGE="http://directory.fedoraproject.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="amd64 x86"
IUSE="doc source"

COMMON_DEP="=dev-java/jss-4*
	>=dev-java/ldapsdk-4.0
	>=dev-java/idm-console-framework-1.1"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# gentoo java rules say no jars with version number
	# so sed away the version indicator '-'
	sed -e "s!-\*!\*!g" -i build.xml

	java-pkg_jarfrom ldapsdk-4.1 ldapjdk.jar
	java-pkg_jarfrom jss-3.4 xpclass.jar jss4.jar
	java-pkg_jarfrom idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
	     -Dldapjdk.location="${S}" \
	     -Djss.location="${S}" \
	     -Dconsole.location="${S}" ${antflags}

	use doc && eant -Dbuilt.dir="${S}"/build \
	     -Dldapjdk.location="${S}" \
	     -Djss.location="${S}" \
	     -Dconsole.location="${S}" ${antflags} javadoc

}

src_install() {
	java-pkg_jarinto /usr/share/dirsrv/html/java
	java-pkg_newjar "${S}"/build/package/fedora-admin-${MY_V}.jar fedora-admin.jar
	java-pkg_newjar "${S}"/build/package/fedora-admin-${MY_V}_en.jar fedora-admin_en.jar
	dosym fedora-admin.jar /usr/share/dirsrv/html/java/fedora-admin-${MY_MV}.jar
	dosym fedora-admin_en.jar /usr/share/dirsrv/html/java/fedora-admin-${MY_MV}_en.jar
	insinto /usr/share/dirsrv/manual/en/admin
	doins "${S}"/help/en/*.html
	doins "${S}"/help/en/tokens.map
	insinto /usr/share/dirsrv/manual/en/admin/help
	doins "${S}"/help/en/help/*.html
	use doc && java-pkg_dojavadoc build/doc
	use source && java-pkg_dosrc src/com
}
