# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

IS_SOURCE=""

MY_PV=${PV//./}
MY_PV=${MY_PV/_/}

if [[ -n ${IS_SOURCE} ]]
then
    MY_P=${PN}${MY_PV}source
else
MY_P=${PN}${MY_PV}
fi

OFFICE_REQ_USE="java"

# OFFICE_EXTENSIONS=(writer2latex.oxt writer2xhtml.oxt xhtml-config-sample.oxt writer4latex.oxt)
OFFICE_EXTENSIONS=(writer2latex.oxt)

# inherit eutils latex-package java-pkg-2 java-ant-2 multilib office-ext-r1
inherit java-pkg-2 java-ant-2 multilib office-ext-r1

DESCRIPTION="Writer2Latex (w2l) - converter from OpenDocument .odt format"
HOMEPAGE="http://writer2latex.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="x86 amd64"
IUSE="doc examples"

RESTRICT=mirror

DEPEND=">=virtual/jdk-1.8
	virtual/latex-base"
RDEPEND=">=virtual/jre-1.8"

S=${WORKDIR}/${PN}19
if [[ -n ${IS_SOURCE} ]]
then
    S_DISTRO=${S}/source/distro
    S_TARGETLIB=${S}/target/lib
else
    S_DISTRO=${S}
    S_TARGETLIB=${S}
fi

OFFICE_EXTENSIONS_LOCATION="${S}"

# EANT_EXTRA_ARGS="-DOFFICE_HOME=/usr/lib/openoffice"
# EANT_EXTRA_ARGS="-DOFFICE_HOME=${S}/openoffice"
EANT_BUILD_TARGET="all"

src_prepare(){
	default
	# Hack for OOo-3
#	mkdir -p openoffice/program/classes
#	cd openoffice/program/classes
#	find "${OOO_ROOT_DIR}" -name "*.jar" -exec ln -snf {} . \;
#	
	sed -i -e "s:W2LPATH=.*:W2LPATH=/usr/$(get_libdir)/${PN}:" ${S_DISTRO}/w2l || die "Sed failed"
}

src_compile() {
	echo 'nothing to compile'
}

src_install() {

	java-pkg_jarinto /usr/$(get_libdir)/${PN}
	java-pkg_dojar "${S_TARGETLIB}/${PN}.jar"

	cd ${S_DISTRO}

	dobin w2l

	insinto /usr/$(get_libdir)/${PN}
	cd ${S_DISTRO}/config
	doins *.xml
	
	#cd ${S_DISTRO}/latex
	#latex-package_src_install


	cd ${S_DISTRO}
	dodoc History.txt Readme.txt changelog.txt COPYING.TXT

	if [[ -n ${IS_SOURCE} ]]
	then
		dodoc ${S}/source/oxt/xhtml-config-sample/config/*
	fi

	#insinto "${OOO_EXT_DIR}"
	#for i in ${OOO_EXTENSIONS}
	#do
	#	doins ${S_TARGETLIB}/${i}
	#done
	office-ext-r1_src_install
	
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
		cp -R samples config "${D}"/usr/share/doc/${PF} || die "Failed to copy samples"
	    
	fi
}
