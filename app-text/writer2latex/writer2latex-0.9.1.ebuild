# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils latex-package java-pkg-2 java-ant-2 multilib openoffice-ext

MY_PV=${PV//./}
MY_PV=${MY_PV/_/}
MY_P=${PN}${MY_PV}source

DESCRIPTION="Writer2Latex (w2l) - converter from OpenDocument .odt format"
HOMEPAGE="http://www.hj-gym.dk/~hj/writer2latex"
SRC_URI="http://www.hj-gym.dk/~hj/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="doc examples"

DEPEND=">=virtual/jdk-1.5
	virtual/latex-base"
RDEPEND=">=virtual/jre-1.5"

S=${WORKDIR}/${PN}09

OOO_EXTENSIONS="writer2latex.oxt writer2xhtml.oxt xhtml-config-sample.oxt" 

# EANT_EXTRA_ARGS="-DOFFICE_HOME=/usr/lib/openoffice"
EANT_EXTRA_ARGS="-DOFFICE_HOME=${S}/openoffice"
EANT_BUILD_TARGET="all"

src_prepare(){
	# Hack for OOo-3
	mkdir -p openoffice/program/classes
	cd openoffice/program/classes
	find /usr/lib/openoffice -name "*.jar" -exec ln -snf {} . \;
	
	sed -i -e "s:W2LPATH=.*:W2LPATH=/usr/$(get_libdir)/${PN}:" "${S}"/source/distro/w2l || die "Sed failed"
}

src_install() {

	java-pkg_jarinto /usr/$(get_libdir)/${PN}
	java-pkg_dojar "${S}/target/lib/${PN}.jar"

	cd ${S}/source/distro

	dobin w2l

	insinto /usr/$(get_libdir)/${PN}
	cd ${S}/source/distro/xslt
	doins *.xsl
	
	cd "${S}"/source/distro/latex
	latex-package_src_install


	cd ${S}/source/distro
	dodoc History.txt Readme.txt changelog.txt COPYING.TXT

	dodoc ${S}/source/oxt/xhtml-config-sample/config/*

	insinto /usr/$(get_libdir)/openoffice/share/extension/install
	for i in ${OOO_EXTENSIONS}
	do
		doins "${S}"/target/lib/${i}
	done
	
	if use doc 
        then
	#	dohtml -r doc
		cd ${S}/source/distro
		cp doc/* "${D}"/usr/share/doc/${PF} || die "Failed to copy .odts"

		java-pkg_dojavadoc ${S}/target/javadoc

	fi
	
	if use examples
	then
		cd ${S}/source/distro
		cp -R samples "${D}"/usr/share/doc/${PF} || die "Failed to copy samples"
	fi
	
}
