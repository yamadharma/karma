# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors:
#  James Le Cuirot <chewi@aura-online.co.uk>

inherit base eutils java-pkg-2

DEPEND="app-arch/lzma-utils
	>=dev-java/javatoolkit-0.3.0
	=dev-eclipse/extensions-base-${SLOT}"

RDEPEND="=dev-eclipse/extensions-base-${SLOT}"

# ------------------------------------------------------------------------------
# @variable-preinherit SLOT
#
# This variable is particularly important to this eclass. It determines which
# version of the Eclipse SDK to build against and install for. Most plugins
# generally only work with one version of Eclipse. Some plugins release slightly
# different versions supporting different versions of Eclipse but under the same
# plugin version number. These different versions are usually held under
# different branches or tags in their repositories. Finally, some smaller
# plugins support more than one version of Eclipse without any differences in
# the source at all. In the latter two cases, separate ebuilds should be created
# with extra version suffixes denoting the Eclipse version. For example,
# mylyn-3.0 would be split into mylyn-3.0.33 for 3.3 and mylyn-3.0.34 for 3.4.
# ------------------------------------------------------------------------------
[[ -z "${SLOT}" ]] && die "SLOT must be set before inheriting eclipse-ext-2"

# ------------------------------------------------------------------------------
# @variable-external ECLIPSE_EXT_FEATURES
#
# Space-separated list of features to build. Note that some features include
# other features so you might not have to specify them all. The order sometimes
# does matter when features that should have been included have not been.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @variable-external PREPARE_USUAL_SDK
#
# Set this to call eclipse-ext-2_prepare-usual-sdk during src_unpack.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @variable-internal BUILDPARSER
#
# Convenience variable for buildparser path.
# ------------------------------------------------------------------------------
BUILDPARSER="/usr/lib/javatoolkit/bin/buildparser"

# ------------------------------------------------------------------------------
# @variable-internal ECLIPSE_EXT_BASEDIR
# @variable-internal ECLIPSE_EXT_EXTDIR
#
# Convenience variables for the locations of the Eclipse SDK installation and
# its respective extensions directory.
# ------------------------------------------------------------------------------
ECLIPSE_EXT_BASEDIR="${ROOT}usr/$(get_libdir)/eclipse-${SLOT}"
ECLIPSE_EXT_EXTDIR="${ROOT}usr/$(get_libdir)/eclipse-extensions-${SLOT}/eclipse"

# ------------------------------------------------------------------------------
# @variable-internal BUILD_DIR
# @variable-internal FEATURES_DIR
# @variable-internal PLUGINS_DIR
#
# Convenience variables for the build, features and plugins directories.
# ------------------------------------------------------------------------------
BUILD_DIR="${WORKDIR}/build"
FEATURES_DIR="${BUILD_DIR}/features"
PLUGINS_DIR="${BUILD_DIR}/plugins"

# ------------------------------------------------------------------------------
# @variable-internal ECLIPSE_ARCH
#
# All Eclipse archs match Portage archs except for x86_64.
# ------------------------------------------------------------------------------
ECLIPSE_ARCH=${ARCH}
use amd64 && ECLIPSE_ARCH="x86_64"

# Default ebuild functions. These can be overridden if necessary.
EXPORT_FUNCTIONS src_unpack src_compile src_install

# ------------------------------------------------------------------------------
# @eclass-src_unpack
# ------------------------------------------------------------------------------
eclipse-ext-2_src_unpack() {
	base_src_unpack

	# See below...
	[[ -n "${PREPARE_USUAL_SDK}" ]] && eclipse-ext-2_prepare-usual-sdk
	eclipse-ext-2_discover-components
}

# ------------------------------------------------------------------------------
# @eclass-src_compile
# ------------------------------------------------------------------------------
eclipse-ext-2_src_compile() {
	local x y z
	cd "${BUILD_DIR}" || die

	# Make a generic build.properties file for each feature if necessary.
	# This is needed after when using prepare-usual-sdk.
	for x in features/* ; do
		if [[ ! -f "${x}/build.properties" ]] ; then
			ebegin "Writing build.properties for feature: ${x##*/}"
			y=`ls -1F "${x}/" | tr "\n" "," || die`
			echo "bin.includes = ${y}" > "${x}/build.properties" || die
			eend 0
		fi
	done

	# Make a generic build.properties file for each plugin if necessary.
	# This is needed after when using prepare-usual-sdk.
	for x in plugins/* ; do
		if [[ ! -f "${x}/build.properties" ]] ; then
			ebegin "Writing build.properties for plugin: ${x##*/}"
			y=`ls -1F "${x}/" | grep -v "^src/" | tr "\n" "," || die`

			if ! [[ -d "${x}/src" ]] ; then
				# Not all plugins have Java source code.
				echo -e "bin.includes = ${y}" > "${x}/build.properties" || die
			elif ! [[ -f "${x}/META-INF/MANIFEST.MF" ]] ; then
				# No MANIFEST.MF to get information from.
				# Hopefully we don't need this plugin.
				eend 1
				continue
			else
				z=`${BUILDPARSER} -w Bundle-ClassPath "${x}/META-INF/MANIFEST.MF" | grep -v "^external:"`
				z="${z%,}"

				if [[ -z "${z}" ]] || [[ "${z}" == "." ]] ; then
					# Most plugins store their classes together with the other files.
					echo -e "source.. = src/\noutput.. = bin/\nbin.includes = .,${y}" > "${x}/build.properties" || die
				elif [[ `echo -e "${z}" | wc -l` == "1" ]] ; then
					# Some plugins store their classes in their own JAR.
					echo -e "source.${z} = src/\noutput.${z} = bin/\nbin.includes = ${y}" > "${x}/build.properties" || die
				else
					# If there is more than one JAR, we can't reliably determine what to do.
					# Hopefully we don't need this plugin.
					eend 1
					continue
				fi
			fi

			eend 0
		fi
	done

cat > allElements.xml <<EOF
<project name="allElements Delegator">
 	<target name="allElementsDelegator">
EOF

for x in ${ECLIPSE_EXT_FEATURES} ; do
cat >> allElements.xml <<EOF
 		<ant antfile="\${genericTargets}" target="\${target}">
	 		<property name="type" value="feature" />
	 		<property name="id" value="${x}" />
 		</ant>
EOF
done

cat >> allElements.xml <<EOF
 	</target>

 	<target name="assemble.element.id[.config.spec]">
 		<ant antfile="\${assembleScriptName}" dir="\${buildDirectory}"/>
 	</target>
EOF

for x in ${ECLIPSE_EXT_FEATURES} ; do
cat >> allElements.xml <<EOF
	<target name="assemble.${x}.linux.gtk.${ECLIPSE_ARCH}">
		<ant antfile="\${assembleScriptName}" dir="\${buildDirectory}"/>
	</target>
EOF
done

cat >> allElements.xml <<EOF
</project>
EOF

cat > build.properties << EOF
builder=${BUILD_DIR}
buildDirectory=${BUILD_DIR}
baseLocation=${ECLIPSE_EXT_BASEDIR}
pluginPath=${BUILD_DIR}/eclipse-extensions
bootclasspath=`java-config -r`:${ECLIPSE_EXT_BASEDIR}/plugins/swt.jar

archivesFormat=linux,gtk,${ECLIPSE_ARCH} - folder
archivePrefix=
collectingFolder=

buildId=${PV}
buildLabel=${P}
forceContextQualifier=gentoo

baseos=linux
basews=gtk
basearch=${ECLIPSE_ARCH}
configs=linux,gtk,${ECLIPSE_ARCH}

skipBase=true
skipMaps=true
skipFetch=true

javacFailOnError=true
groupConfigurations=false
outputUpdateJars=false
compilerArg=-nowarn

javacSource=`java-pkg_get-source`
javacTarget=`java-pkg_get-target`
EOF

cat > build.xml << EOF
<project name="Build ${PN}" default="main">
        <property file="\${basedir}/build.properties" />

	<target name="main" description="build everything">
		<ant antfile="`echo "${ECLIPSE_EXT_BASEDIR}"/plugins/org.eclipse.pde.build_*`/scripts/build.xml" dir="\${builder}" />
	</target>
</project>
EOF

	# Here we go...
	`java-config -J` -Duser.home="${T}" -cp "${ECLIPSE_EXT_BASEDIR}"/plugins/org.eclipse.equinox.launcher_*.jar org.eclipse.equinox.launcher.Main -application org.eclipse.ant.core.antRunner -buildfile build.xml || die
}

# ------------------------------------------------------------------------------
# @eclass-src_install
# ------------------------------------------------------------------------------
function eclipse-ext-2_src_install() {
	dodir "${ECLIPSE_EXT_EXTDIR}"/{features,plugins} || die
	cp -r "${BUILD_DIR}/tmp"/{features,plugins} "${D}/${ECLIPSE_EXT_EXTDIR}" || die
}

# ------------------------------------------------------------------------------
# @ebuild-function eclipse-ext-2_bundled-to-external
#
# Sometimes JARs are bundled within a plugin. This function changes the
# classpath so that it points to external versions of the JARs instead.
#
# @param $opt - Same options as java-pkg_getjars.
# @param $1 - Regexp for classpath entries to delete. Specify "" to not delete.
# @param $2 - List of packages to get JARs from.
# @param $3 - Manifest file to operate on. Defaults to MANIFEST.MF.
# ------------------------------------------------------------------------------
eclipse-ext-2_bundled-to-external() {
	local x options

	while [[ "$1" == --* ]]; do
		options="${options} $1"
		shift
	done

	# Default to MANIFEST.MF.
	local file=${3:-MANIFEST.MF}

	if [[ "$1" != "" ]] ; then
		# Fetch the existing Bundle-ClassPath and delete some entries.
		x=`${BUILDPARSER} -w Bundle-ClassPath "${file}" | sed -r "/$1/d" | tr -d "\n" || die`
	else
		# Fetch the existing Bundle-ClassPath.
		x=`${BUILDPARSER} Bundle-ClassPath "${file}" || die`
	fi

	# Default to . if there is no Bundle-ClassPath.
	[[ -z "${x}" ]] && x="."

	# Set the new Bundle-ClassPath.
	x=${x%,}`java-pkg_getjars ${options} $2 | sed -r "s/(^|:)/,external:/g" || die`
	${BUILDPARSER} -i Bundle-ClassPath "${x#,}" "${file}" || die
}

# ------------------------------------------------------------------------------
# @ebuild-function eclipse-ext-2_plugin-to-external
#
# It is now common practise to bundle JARs as Eclipse plugins, presumably to
# reduce the amount of duplication between plugins. This function removes those
# plugin dependencies and adds external JARs to the classpath. This may not
# always work properly though. For example, RDT has major problems when JRuby is
# not installed as a plugin.
#
# @param $opt - Same options as java-pkg_getjars.
# @param $1 - Regexp for plugin entries to delete.
# @param $2 - List of packages to get JARs from.
# @param $3 - Manifest file to operate on. Defaults to MANIFEST.MF.
# ------------------------------------------------------------------------------
eclipse-ext-2_plugin-to-external() {
	local x options

	while [[ "$1" == --* ]]; do
		options="${options} $1"
		shift
	done

	# Default to MANIFEST.MF.
	local file=${3:-MANIFEST.MF}

	# Delete the plugin entries from Require-Bundle.
	x=`${BUILDPARSER} -w Require-Bundle "${file}" | sed -r "/$1/d" | tr -d "\n" || die`
	${BUILDPARSER} -i Require-Bundle "${x%,}" "${file}" || die

	# Fetch the existing Bundle-ClassPath.
	x=`${BUILDPARSER} Bundle-ClassPath "${file}" || die`
	[[ -z "${x}" ]] && x="."

	# Set the new Bundle-ClassPath.
	x=${x}`java-pkg_getjars ${options} $2 | sed -r "s/(^|:)/,external:/g" || die`
	${BUILDPARSER} -i Bundle-ClassPath "${x#,}" "${file}" || die
}

# ------------------------------------------------------------------------------
# @ebuild-function eclipse-ext-2_remove-plugin-from-feature
#
# Removes plugin references from feature.xml files. This is very evil but all
# feature.xml files are formatted this way so it should work in all cases.
#
# @param $@ - One or more feature.xml files to operate on.
# ------------------------------------------------------------------------------
eclipse-ext-2_remove-plugin-from-feature() {
	local plugin=$1
	shift

	sed -i -r \
		-e "/<plugin/{:x;/id=\"[^\"]*(${plugin})[^\"]*\"/{:y;/\/>/d;N;by};/\/>/b;N;bx}" \
		-e "/<import plugin=\"[^\"]*(${plugin})[^\"]*\"/d" \
		${@} || die
}

# ------------------------------------------------------------------------------
# @ebuild-function eclipse-ext-2_prepare-usual-sdk
#
# SDK bundles, particularly official ones from eclipse.org, generally follow the
# same layout. This allows us to prepare these bundles for building in the same
# manner using this function. Unofficial plugins don't tend to provide source
# bundles at all, which is why we often have to prepare our own tarballs.
# ------------------------------------------------------------------------------
eclipse-ext-2_prepare-usual-sdk() {
	local x plugin jar=`java-config -j`

	cd "${S}"
	for x in `find features plugins -maxdepth 1 -name "*.jar"` ; do
		ebegin "Unpacking ${x##*/}"
		mkdir -p "${S}/${x%.jar}" || die
		cd "${S}/${x%.jar}" || die
		${jar} xf "${S}/${x}" `${jar} tf "${S}/${x}" | egrep -v ".class$|\/$"` || die
		rm -f "${S}/${x}" || die
		eend 0
	done

	cd "${S}"
	for x in `find -mindepth 5 -maxdepth 5 -path "*/src/*src.zip"` ; do
		plugin=${x%/*}
		plugin=${plugin##*/}
		ebegin "Unpacking sources for ${plugin}"
		unzip -q "${x}" -d "plugins/${plugin}/src" || die
		rm -f "${x}" || die
		eend 0
	done
}

# ------------------------------------------------------------------------------
# @ebuild-function eclipse-ext-2_discover-components
#
# This function is the main part of src_unpack. It is separated from src_unpack
# itself so that ebuilds can easily perform custom actions immediately before
# and after eclipse-ext-2_prepare-usual-sdk.
# ------------------------------------------------------------------------------
eclipse-ext-2_discover-components() {
	local x y z

	# Create build directory.
	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die

	# Create directories for symlinks to our extension.
	mkdir -p features plugins || die

	# Create directories for symlinks to installed extensions.
	mkdir -p eclipse-extensions/{features,plugins} || die

	# Create symlinks to installed extensions.
	ln -snf "${ECLIPSE_EXT_EXTDIR}/features"/* eclipse-extensions/features || die
	ln -snf "${ECLIPSE_EXT_EXTDIR}/plugins"/* eclipse-extensions/plugins || die

	# Locate and symlink any features.
	# Ignore paths with spaces. These cause problems and are probably not real features anyway.
	for x in `find "${S}" ! -path "*/sourceTemplate*" ! -path "* *" \( -name "feature.properties" -o -name "feature.xml" \) -printf "%h\n" | uniq` ; do
		ln -s "${x}" features 2> /dev/null && einfo "Found feature: ${x##*/}"
	done

	# Locate and symlink any plugins. Check that each isn't really a feature since they contain META-INF too.
	# Ignore paths with spaces. These cause problems and are probably not real plugins anyway.
	for x in `find "${S}" ! -path "*/sourceTemplate*" ! -path "* *" \( -name "plugin.xml" -o -name "fragment.xml" -o -name "META-INF" \) -printf "%h\n" | uniq` ; do
		y=`basename "${x}"`
		z=`readlink "features/${y}"`

		if [[ ! -e "features/${y}" ]] || [[ "${x}" != "${z}" ]] ; then
			ln -s "${x}" plugins 2> /dev/null && einfo "Found plugin: ${y}"
		fi
	done

	# These files need to be deleted, otherwise Eclipse complains that the plugin has been tampered with. Wasn't us, honest. ;)
	find "${S}" \( -path "*/META-INF/ECLIPSE.RSA" -o -path "*/META-INF/ECLIPSE.SF" \) -delete

	# Feature directories must be correctly named to be found so rename if necessary.
	for x in features/*/feature.xml ; do
		y=`egrep -m1 -o "id=[\'\"][^\'\"]+[\'\"]" "${x}" | tr -d "\'\""`
		y=${y#id=}

		if [[ ! -e "features/${y}" ]] ; then
			x=${x%/feature.xml}
			einfo "Renaming feature: ${x##*/} -> ${y}"
			mv "${x}" "features/${y}"
		fi
	done

	# Setting the plugin versions to 0.0.0 here makes the PDE use whatever plugin versions we have available.
	# We skip the first 10 lines to avoid the xml header and the feature version.
	for x in features/*/feature.xml ; do
		sed -i -r '10,$ s:version="[^"]*":version="0.0.0":g' "${x}" || die
	done

	# Remove links to any already-installed versions of this extension.
	for x in features/* plugins/* ; do
		rm -f eclipse-extensions/${x%%_*}_*
	done 2> /dev/null

	# The above doesn't cover all cases.
	for x in ${ECLIPSE_EXT_FEATURES} ; do
		rm -f eclipse-extensions/*/${x}{_,.}* eclipse-extensions/*/${x%?feature}{_,.}*
	done 2> /dev/null
}
