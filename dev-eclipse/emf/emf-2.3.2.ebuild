# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

BUILD="R200802051830"

SLOT="3.3"
inherit eclipse-ext-2

DESCRIPTION="A modeling framework and code generation facility"
HOMEPAGE="http://www.eclipse.org/emf/"
SRC_URI="mirror://eclipse/modeling/emf/emf/downloads/drops/${PV}/${BUILD}/emf-sdo-xsd-SDK-${PV}.zip"
LICENSE="EPL-1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.4"

ECLIPSE_EXT_FEATURES=`echo org.eclipse.emf{,.converter,.doc,.ecore.sdo,.ecore.sdo.doc} org.eclipse.xsd{,.edit,.editor,.mapping,.mapping.editor,.ecore.converter,.doc}`
PREPARE_USUAL_SDK=1
S="${WORKDIR}/eclipse"
