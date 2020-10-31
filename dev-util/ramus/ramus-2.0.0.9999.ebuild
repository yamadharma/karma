# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java-based IDEF0 & DFD Modeler"
HOMEPAGE="http://ramussoftware.com/"

if [[ ${PV} = *.9999* ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/Vitaliy-Yakovchuk/ramus.git"
        KEYWORDS="amd64 ~x86"
        S="${WORKDIR}"/${P}
else
        SRC_URI="https://github.com/isu-enterprise/ramus/archive/v-${PV}.zip -> ${P}.zip"
        KEYWORDS="amd64 ~x86"
        S="${WORKDIR}/${PN}-v-${PV}"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""


CDEPEND=""

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
"


#JAVA_GENTOO_CLASSPATH="stringtemplate-4,treelayout"

#java_prepare() {
#	java-pkg_clean
#}

#src_configure() {
#	# TODO: Make java-config accept a jar@package query.
#	JAVA_GENTOO_CLASSPATH_EXTRA="${S}/${PN}-runtime.jar:$(java-pkg_getjar antlr-3.5 antlr-runtime.jar)"
#}

src_compile() {
	pwd
	./gradlew build
	./gradlew copyFiles
}

src_install() {
	install -d "${D}/usr/share/doc/$pkgname/"{ru,en}
	install -d "${D}/usr/share/java/$pkgname"

	install -t "${D}/usr/share/doc/$pkgname"/ru "${S}/dest/doc/ru"/*
	install -t "${D}/usr/share/doc/$pkgname"/en "${S}/dest/doc/en"/*
	mv "${S}/dest/full/lib/thirdparty/"{local-client-1.0-SNAPSHOT.jar,ramus-modeler.jar}
	install -C -t "${D}/usr/share/java/$pkgname" "${S}/dest/full/lib/$coname/"*.jar "${S}/dest/full/lib/thirdparty/"*.jar
	install -Dm755 "$startdir/$pkgname.sh" "${D}/usr/bin/$pkgname"
	install -Dm644 "${S}/dest/izpack/icon.png" "${D}/usr/share/icons/32x32/$pkgname/icon.png"
	install -Dm644 $pkgname.desktop "${D}/usr/share/applications/$pkgname.desktop"
}

