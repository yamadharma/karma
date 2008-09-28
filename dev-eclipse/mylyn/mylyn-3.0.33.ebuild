# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="A task-focused interface for Eclipse"
HOMEPAGE="http://www.eclipse.org/mylyn/"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.lzma"
LICENSE="EPL-1.0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="dev-java/commons-codec
	dev-java/commons-httpclient:3
	dev-java/commons-lang:2.1
	dev-java/commons-logging
	dev-java/xmlrpc:3"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

ECLIPSE_EXT_FEATURES=`echo org.eclipse.mylyn_feature org.eclipse.mylyn.{bugzilla,context,java,monitor,team,trac,ide}_feature`

src_unpack() {
	local plugin
	eclipse-ext-2_src_unpack

	eclipse-ext-2_remove-plugin-from-feature "org\.apache\.|javax\." "${FEATURES_DIR}"/org.eclipse.mylyn{,.monitor,.trac}_feature/feature.xml
	eclipse-ext-2_plugin-to-external "org\.apache\." commons-codec,commons-httpclient:3,commons-lang:2.1,commons-logging "${PLUGINS_DIR}/org.eclipse.mylyn.commons.net/META-INF/MANIFEST.MF"
	eclipse-ext-2_plugin-to-external "org\.apache\." commons-logging "${PLUGINS_DIR}/org.eclipse.mylyn.tasks.ui/META-INF/MANIFEST.MF"

	# This shouldn't be needed but we get errors without it.
	eclipse-ext-2_bundled-to-external "" commons-httpclient:3 "${PLUGINS_DIR}/org.eclipse.mylyn.bugzilla.core/META-INF/MANIFEST.MF"

	for plugin in core tests ; do
		eclipse-ext-2_plugin-to-external "org\.apache\." xmlrpc:3 "${PLUGINS_DIR}/org.eclipse.mylyn.trac.${plugin}/META-INF/MANIFEST.MF"
	done
}
