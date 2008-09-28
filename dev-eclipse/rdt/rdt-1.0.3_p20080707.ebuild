# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE TO MAINTAINERS: To save space, when creating the tarball, you should...
#  - Delete plugins/*.pluginbuilder
#  - Delete plugins/org.jruby/lib and plugins/org.jruby/src.zip
#  - Delete plugins/org.rubypeople.rdt.doc.user/lib
#  - Delete plugins/org.epic.regexp/gnu-regexp-1.1.4.jar

EAPI="1"
SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="An open source Ruby IDE for the Eclipse platform"
HOMEPAGE="http://rubyeclipse.sourceforge.net/"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.lzma"
LICENSE="CPL-1.0"
KEYWORDS="~amd64"
IUSE="doc"

CDEPEND="=dev-java/gnu-regexp-1*
	>=dev-java/jruby-1.1.2"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	doc? (
		dev-java/ant-trax
		dev-java/saxon:6.5
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

PATCHES=( "${FILESDIR}/jruby-1.1.2.patch" "${FILESDIR}/eclipse-3.3.patch" )
ECLIPSE_EXT_FEATURES="org.rubypeople.rdt"

pkg_setup() {
	use doc && ECLIPSE_EXT_FEATURES="${ECLIPSE_EXT_FEATURES} org.rubypeople.rdt.doc_feature"
}

src_unpack() {
	eclipse-ext-2_src_unpack

	# Fix silly typo from Eclipse 3.2.
	sed -i "s/Lanuch/Launch/" "${PLUGINS_DIR}/org.rubypeople.rdt.branding/src/org/rubypeople/rdt/internal/cheatsheets/webservice/OpenRunConfigurationAction.java" || die

	# Externally source GNU Regexp.
	rm -vf "${PLUGINS_DIR}/org.epic.regexp/gnu-regexp-1.1.4.jar" || die
	eclipse-ext-2_bundled-to-external "gnu-regexp" gnu-regexp-1 "${PLUGINS_DIR}/org.epic.regexp/META-INF/MANIFEST.MF" || die

	if use doc ; then
		# Externally source doc dependencies.
		cd "${PLUGINS_DIR}/org.rubypeople.rdt.doc.user" || die
		mkdir -p lib || die
		java-pkg_jar-from --into lib --with-dependencies --build-only ant-trax,saxon-6.5
		ln -snf saxon.jar lib/saxon_6.6.5.jar || die
	fi

	# Now onto JRuby...
	cd "${PLUGINS_DIR}/org.jruby" || die

	# Remove Windows batch files.
	rm -vf bin/*.bat || die

	# Symlink required JARs.
	mkdir -p lib || die
	ln -snf /usr/share/jruby/lib/ruby lib || die
	java-pkg_jar-from --into lib --with-dependencies jruby

	# List those JARs in the manifest.
	local jars=`echo lib/*.jar`
	${BUILDPARSER} -i Bundle-ClassPath "${jars// /,}" META-INF/MANIFEST.MF || die

	# Symlinks ARE followed so don't automatically install the lib directory.
	sed -i "/lib\//d" build.properties || die
}

src_install() {
	# Install the lib directory for org.jruby manually to preserve symlinks.
	cp -a plugins/org.jruby/lib "${BUILD_DIR}/tmp/plugins/org.jruby_"* || die

	eclipse-ext-2_src_install
}
