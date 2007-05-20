# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-opt-2 java-ant-2 latex-package

MY_PV=${PV//./}
MY_PV=${MY_PV/_/}

S=${WORKDIR}/${PN}${MY_PV%beta}

DESCRIPTION=""
HOMEPAGE="http://www.hj-gym.dk/~hj/writer2latex"
SRC_URI="http://www.hj-gym.dk/~hj/writer2latex/${PN}${MY_PV}.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

IUSE="doc"
DEPEND="=virtual/jdk-1.4*
	>=dev-java/ant-1.6
	virtual/tetex"
RDEPEND=">=virtual/jre-1.4"

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/handleheading-0.5_beta.patch"
	
	sed -i -e "s:W2LPATH=.*:W2LPATH=/usr/lib/${PN}:" ${S}/w2l
}

src_compile() {
	eant -DOFFICE_HOME=/usr/lib/openoffice all
}

src_install() {

	dobin w2l

	rm build.xml	
	insinto /usr/lib/${PN}
	doins *.xml
	doins *.xsl	
	doins writer2latex.jar

	cd ${S}
	latex-package_src_install
	
	if ( use doc )
	then
	    dohtml -r ${S}/doc
	    cp ${S}/doc/*.pdf ${D}/usr/share/doc/${PF}    
    	    cp ${S}/doc/*.odt ${D}/usr/share/doc/${PF}    	
		
	    dohtml -r ${S}/target/javadoc
	
	    cp -R ${S}/samples ${D}/usr/share/doc/${PF}    	
	fi
	
	cd ${S}
	dodoc History.txt Readme.txt changelog05.txt
}
