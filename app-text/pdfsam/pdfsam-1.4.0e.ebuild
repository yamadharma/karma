# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc"
inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="A free open source tool to split and merge pdf documents"
HOMEPAGE="http://www.pdfsam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-out-src.zip"
LICENSE="GPL-2"
SLOT="1.4"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/pdfsam"

COMMON_DEP="dev-java/dom4j:1
	dev-java/log4j
	dev-java/itext
	dev-java/jaxen:1.1
	dev-java/bcmail
	dev-java/bcprov
	dev-java/jgoodies-looks:2.0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	sys-devel/gettext
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	mkdir "${S}"
	cd "${S}"
	for zip in "${WORKDIR}"/*.zip
	do
	    unzip -oq ${zip} || die "unpacking ${zip} failed"
	done

	for bldprop in emp4j jcmdline pdfsam-console pdfsam-encrypt pdfsam-merge pdfsam-split pdfsam-cover pdfsam-langpack pdfsam-maine pdfsam-mix
	do
	    echo > ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam.deploy.dir=${S}/deploy" >> ${S}/${bldprop}/ant/build.properties
	    echo "workspace.dir=${S}" >> ${S}/${bldprop}/ant/build.properties
	    echo "build.dir=${S}/build" >> ${S}/${bldprop}/ant/build.properties
	    echo "libs.dir=${S}" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam.version=enhanced" >> ${S}/${bldprop}/ant/build.properties
	    echo "itext.jar.name=iText" >> ${S}/${bldprop}/ant/build.properties
	    echo "log4j.jar.name=log4j" >> ${S}/${bldprop}/ant/build.properties
	    echo "dom4j.jar.name=dom4j" >> ${S}/${bldprop}/ant/build.properties
	    echo "jaxen.jar.name=jaxen" >> ${S}/${bldprop}/ant/build.properties
	    echo "bcmail.jar.name=bcmail" >> ${S}/${bldprop}/ant/build.properties
	    echo "bcprov.jar.name=bcprov" >> ${S}/${bldprop}/ant/build.properties
	    echo "looks.jar.name=looks" >> ${S}/${bldprop}/ant/build.properties
	    echo "jcmdline.jar.name=pdfsam-jcmdline" >> ${S}/${bldprop}/ant/build.properties
	    echo "emp4j.jar.name=emp4j" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam.jar.name=pdfsam" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-console.jar.name=pdfsam-console" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-split.jar.name=pdfsam-split" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-merge.jar.name=pdfsam-merge" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-cover.jar.name=pdfsam-cover" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-encrypt.jar.name=pdfsam-encrypt" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-mix.jar.name=pdfsam-mix" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-unpack.jar.name=pdfsam-unpack" >> ${S}/${bldprop}/ant/build.properties
	    echo "pdfsam-langpack.jar.name=pdfsam-langpack" >> ${S}/${bldprop}/ant/build.properties

	done

	java-pkg_jarfrom itext
	java-pkg_jarfrom dom4j-1
	java-pkg_jarfrom log4j
	java-pkg_jarfrom jaxen-1.1
	java-pkg_jarfrom bcmail
	java-pkg_jarfrom bcprov
	java-pkg_jarfrom jgoodies-looks-2.0
}

src_compile() {
	eant ${antflags} -buildfile pdfsam-maine/ant/build.xml

	use doc && eant ${antflags} -buildfile pdfsam-maine/ant/build.xml javadoc
}

src_install() {
	insinto /usr/share/${PN}-${SLOT}/lib
	doins "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/*.xml
	java-pkg_dojar "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/pdfsam.jar
	java-pkg_dojar "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/lib/pdfsam-*.jar
	java-pkg_dojar "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/lib/emp4j.jar

	for plugins in merge cover split encrypt mix
	do
	    java-pkg_jarinto /usr/share/${PN}-${SLOT}/lib/plugins/${plugins}
	    insinto /usr/share/${PN}-${SLOT}/lib/plugins/${plugins}

	    java-pkg_dojar "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/plugins/${plugins}/*.jar
	    doins "${S}"/build/pdfsam-maine/release/dist/pdfsam-enhanced/plugins/${plugins}/*.xml
	done

	java-pkg_dolauncher ${PN}-${SLOT} --main org.pdfsam.guiclient.GuiClient --pwd "/usr/share/${PN}-${SLOT}/lib"
	java-pkg_dolauncher ${PN}-console-${SLOT} --main org.pdfsam.console.ConsoleClient --pwd "/usr/share/${PN}-${SLOT}/lib"

	newicon "${S}"/pdfsam-maine/images/pdf.png pdfsam-${SLOT}.png
	make_desktop_entry ${PN} "PDF Split and Merge ${PV}" pdfsam-${SLOT}.png Office

	use doc && dodoc pdfsam-maine/doc/enhanced/*

	use doc && java-pkg_dojavadoc "${S}"/build/pdfsam-maine/apidocs
}
