# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils latex-package java-pkg-2 java-ant-2 multilib openoffice-ext

IS_SOURCE=

MY_PV=${PV//./}
MY_PV=${MY_PV/_/}

if [[ -n ${IS_SOURCE} ]]
then
    MY_P=${PN}${MY_PV}source
else
MY_P=${PN}${MY_PV}
fi

DESCRIPTION="Writer2Latex (w2l) - converter from OpenDocument .odt format"
HOMEPAGE="http://writer2latex.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="doc examples"

DEPEND=">=virtual/jdk-1.5
	virtual/latex-base"
RDEPEND=">=virtual/jre-1.5"

S=${WORKDIR}/${PN}10
if [[ -n ${IS_SOURCE} ]]
then
    S_DISTRO=${S}/source/distro
    S_TARGETLIB=${S}/target/lib
else
    S_DISTRO=${S}
    S_TARGETLIB=${S}
fi

OOO_EXTENSIONS="writer2latex.oxt writer2xhtml.oxt xhtml-config-sample.oxt" 

# EANT_EXTRA_ARGS="-DOFFICE_HOME=/usr/lib/openoffice"
EANT_EXTRA_ARGS="-DOFFICE_HOME=${S}/openoffice"
EANT_BUILD_TARGET="all"

src_prepare(){
	# Hack for OOo-3
	mkdir -p openoffice/program/classes
	cd openoffice/program/classes
	find /usr/lib/openoffice -name "*.jar" -exec ln -snf {} . \;
	
	sed -i -e "s:W2LPATH=.*:W2LPATH=/usr/$(get_libdir)/${PN}:" ${S_DISTRO}/w2l || die "Sed failed"
}

src_install() {

	java-pkg_jarinto /usr/$(get_libdir)/${PN}
	java-pkg_dojar "${S_TARGETLIB}/${PN}.jar"

	cd ${S_DISTRO}

	dobin w2l

	insinto /usr/$(get_libdir)/${PN}
	cd ${S_DISTRO}/xslt
	doins *.xsl
	
	cd ${S_DISTRO}/latex
	latex-package_src_install


	cd ${S_DISTRO}
	dodoc History.txt Readme.txt changelog.txt COPYING.TXT

	if [[ -n ${IS_SOURCE} ]]
	then
		dodoc ${S}/source/oxt/xhtml-config-sample/config/*
	else
		dodoc ${S}/samples/config/*
	fi

	insinto /usr/$(get_libdir)/openoffice/share/extension/install
	for i in ${OOO_EXTENSIONS}
	do
		doins ${S_TARGETLIB}/${i}
	done
	
	if use doc 
        then
	#	dohtml -r doc
		cd ${S_DISTRO}
		cp doc/* "${D}"/usr/share/doc/${PF} || die "Failed to copy .odts"
		if [[ -n ${IS_SOURCE} ]]
		then
			java-pkg_dojavadoc ${S}/target/javadoc
		fi

	fi
	
	if use examples
	then
		cd ${S_DISTRO}
		cp -R samples "${D}"/usr/share/doc/${PF} || die "Failed to copy samples"
	fi
	
}
