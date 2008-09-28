# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-ext

DESCRIPTION="A graphical user interface for the configuration files used by the Spring Framework"
HOMEPAGE="http://springide.org/"
SRC_URI="http://www.kerami-tek.com/~chewi/chewi-overlay/distfiles/${P}.tbz2"
SLOT="1.2"
LICENSE="Apache-2.0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	=dev-util/eclipse-sdk-3.1*
	=dev-eclipse/eclipse-gef-3.1*
	dev-eclipse/eclipse-wst"

RDEPEND=">=virtual/jre-1.4
	=dev-util/eclipse-sdk-3.1*
	=dev-eclipse/eclipse-gef-3.1*
	dev-eclipse/eclipse-wst"

src_compile() {
	eclipse-ext_require-slot 3.1
	
	# The Web Flow Editor has been left out of version 1.2.3 apparently...
	# eclipse-ext_process-features org.springframework.ide.eclipse org.springframework.ide.eclipse.web.flow
	
	eclipse-ext_process-features org.springframework.ide.eclipse
}
