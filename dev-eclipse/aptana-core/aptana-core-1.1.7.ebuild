# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE TO MAINTAINERS: To save space, when creating the tarball, you should...
#  - Delete builders and doc
#  - Delete plugins/org.mozilla.*
#  - Delete plugins/com.aptana.ide.editors.junit/*.jar
#  - Delete plugins/com.aptana.ide.syncing/*.jar
#  - Delete plugins/com.aptana.ide.js.docgen/*.jar
#  - Delete plugins/com.aptana.ide.libraries/*.jar
#  - Delete plugins/com.aptana.ide.libraries.jetty/*servlet*.jar
#  - Delete plugins/*.test* (until we figure out how to run tests)
#  - Delete plugins/org.dojotoolkit.dojo.* (until it is included again)

EAPI="1"
SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="Web development IDE for the Eclipse platform"
HOMEPAGE="http://www.aptana.com/studio"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.lzma"
LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="dev-db/derby
	dev-java/edtftpj
	dev-java/jaxen:1.1
	dev-java/jtidy
	dev-java/rhino:1.6
	dev-java/saxon:0
	dev-java/tomcat-servlet-api:2.5
	dev-java/velocity
	dev-java/xerces:2
	dev-java/xml-commons-external:1.3
	dev-java/xpp3
	dev-java/xstream
	www-misc/css-validator"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

PATCHES=( "${FILESDIR}/eclipse-3.3.patch" )
ECLIPSE_EXT_FEATURES="com.aptana.ide.feature"

src_unpack() {
	local x
	eclipse-ext-2_src_unpack

	# For some reason, this plugin is misnamed and needs to be renamed to be found.
	mv plugins/com.aptana.ide.logviewer plugins/com.aptana.ide.logging || die

	# Don't include any dependencies except velocity here, otherwise we end up in JAR hell.
	eclipse-ext-2_bundled-to-external "." css-validator,derby,jaxen:1.1,jtidy,velocity,xerces:2,xml-commons-external:1.3 "${PLUGINS_DIR}/com.aptana.ide.libraries/META-INF/MANIFEST.MF"

	# We keep jetty bundled to preserve our sanity for the time being.
	eclipse-ext-2_bundled-to-external --with-dependencies "servlet" tomcat-servlet-api:2.5 "${PLUGINS_DIR}/com.aptana.ide.libraries.jetty/META-INF/MANIFEST.MF"

	eclipse-ext-2_bundled-to-external "xpp3|xstream" xpp3,xstream "${PLUGINS_DIR}/com.aptana.ide.editors.junit/META-INF/MANIFEST.MF"
	eclipse-ext-2_bundled-to-external "saxon" saxon "${PLUGINS_DIR}/com.aptana.ide.js.docgen/META-INF/MANIFEST.MF"
	eclipse-ext-2_bundled-to-external "edtftpj" edtftpj "${PLUGINS_DIR}/com.aptana.ide.syncing/META-INF/MANIFEST.MF"

	for x in com.aptana.ide.{editor.js,editors{,.codeassist,.junit},scripting} org.eclipse.eclipsemonkey.{lang.javascript,ui} ; do
		eclipse-ext-2_plugin-to-external --with-dependencies "org\.mozilla\.rhino" rhino:1.6 "${PLUGINS_DIR}/${x}/META-INF/MANIFEST.MF"
	done

	for x in com.aptana.ide.feature{,.editor.js,.editors} org.eclipse.eclipsemonkey ; do
		eclipse-ext-2_remove-plugin-from-feature "org\.mozilla\.rhino" "${FEATURES_DIR}/${x}/feature.xml"
	done
}
