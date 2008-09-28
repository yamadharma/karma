# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE TO MAINTAINERS: When creating the tarball, you should...
#  - Delete plugins/org.radrails.pluginbuilder
#  - Fetch com.aptana.ide.editor.sql into the plugins directory.

EAPI="1"
SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="A Ruby on Rails IDE for the Eclipse platform"
HOMEPAGE="http://www.aptana.com/radrails/"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.lzma"
LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE="mssql mysql oracle postgres"

CDEPEND="=dev-eclipse/aptana-core-1.1*:${SLOT}
	=dev-eclipse/rdt-1.0*:${SLOT}
	mssql? ( dev-java/jdbc-mssqlserver )
	mysql? ( dev-java/jdbc-mysql )
	oracle? ( dev-java/jdbc3-oracle )
	postgres? ( dev-java/jdbc-postgresql )"
#	db2? (dev-java/jdbc-ibmdb2) -- TODO: No ebuild yet!
#	sqlite? (dev-java/javasqlite) -- TODO: No ebuild yet!

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

ECLIPSE_EXT_FEATURES="org.radrails.rails"

src_unpack() {
	local jars
	eclipse-ext-2_src_unpack

	# This plugin should be marked as win32 only. Remove it.
	eclipse-ext-2_remove-plugin-from-feature "com\.aptana\.radrails\.sqlite3\.win32" "${FEATURES_DIR}/org.radrails.rails/feature.xml"

	# Get classpaths for the database drivers we want.
	use mssql && jars=${jars}"jdbc-mssqlserver,"
	use mysql && jars=${jars}"jdbc-mysql,"
	use oracle && jars=${jars}"jdbc3-oracle,"
	use postgres && jars=${jars}"jdbc-postgresql,"

	# Add the classpaths to the manifest file.
	eclipse-ext-2_plugin-to-external '(com|org)\.[^\.]+\.driver' "${jars%,}" "${PLUGINS_DIR}/org.radrails.db.core/META-INF/MANIFEST.MF"

	# Remove more references to the database driver plugins.
	eclipse-ext-2_remove-plugin-from-feature "(com|org)\.[^\.]+\.driver" "${FEATURES_DIR}/org.radrails.rails/feature.xml" "${PLUGINS_DIR}/org.radrails.ide.ui/RadRails.product"
	sed -i -r 's/\.\.\/(com|org)\.[^\.]+\.driver:?//g' "${PLUGINS_DIR}/org.radrails.ide.ui/javadoc.xml"

	cd "${PLUGINS_DIR}/org.radrails.db.core/src/org/radrails/db/core"
	local x="DatabaseHelper.java IDatabaseConstants.java"

	# Remove these driver adapters. We don't support them (yet).
	rm -rf ibmdb2; sed -i '/db2/Id' ${x}
	rm -rf sqlite; sed -i '/sqlite/Id' ${x}

	# Remove these driver adapters if we don't want them.
	use mssql || ( rm -rf sqlserver && sed -i '/sqlserver/Id' ${x} )
	use mysql || ( rm -rf mysql && sed -i '/mysql/Id' ${x} )
	use oracle || ( rm -rf oracle && sed -i '/oracle/Id' ${x} && sed -i '/OCI/d' ${x} )
	use postgres || ( rm -rf postgresql && sed -i '/postgresql/Id' ${x} )
}
