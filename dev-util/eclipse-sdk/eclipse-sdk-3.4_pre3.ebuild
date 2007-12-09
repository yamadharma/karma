# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 check-reqs

MY_PV="${PV/_pre/M}"
DMF="R-${MY_PV}-200711012000"
MY_A="eclipse-sourceBuild-srcIncluded-${MY_PV}.zip"

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_A}"

SLOT="3.4"
LICENSE="EPL-1.0"
IUSE="branding"
KEYWORDS="amd64 ~ppc x86"

S=${WORKDIR}
PATCHDIR=${FILESDIR}/${SLOT}
FEDORA=${PATCHDIR}/fedora
ECLIPSE_DIR="/usr/lib/eclipse-${SLOT}"

CDEPEND="=dev-java/ant-eclipse-ecj-${SLOT}*
	>=dev-java/ant-core-1.7.0
	=dev-java/swt-${SLOT}*
	=dev-java/lucene-2.2*
	=dev-java/lucene-analyzers-2.2*
	=dev-java/junit-3*
	=dev-java/junit-4*
	dev-java/jsch"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND="=virtual/jdk-1.5*
	dev-java/ant-nodeps
	${CDEPEND}
	>=sys-apps/findutils-4.1.7
	app-arch/unzip
	app-arch/zip"

JAVA_PKG_BSFIX="off"

pkg_setup() {
	java-pkg-2_pkg_setup

	CHECKREQS_MEMORY="768"
	check_reqs

	eclipsearch=${ARCH}
	use amd64 && eclipsearch=x86_64
}

src_unpack() {
	unpack ${A}

	rm -rf plugins/org.eclipse.swt.*
	mkdir -p plugins/org.eclipse.swt/\@dot
	unzip -q $(java-pkg_getjar --build-only swt-${SLOT} swt.jar) -d plugins/org.eclipse.swt/\@dot

	patch-apply

	# remove pre-built eclipse binaries
	find ${S} -type f -name eclipse | xargs rm
	# ...  .so libraries
	find ${S} -type f -name '*.so' | xargs rm
	# ... .jar files
	rm plugins/org.eclipse.swt/extra_jars/exceptions.jar \
		plugins/org.eclipse.osgi/osgi/osgi*.jar \
		plugins/org.eclipse.osgi/supplement/osgi/osgi.jar

	# no warnings / java5 / all output should be directed to stdout
	find ${S} -type f -name '*.xml' -exec \
		sed -r -e "s:(-encoding ISO-8859-1):\1 -nowarn:g" \
			-e "s:(\"compilerArg\" value=\"):\1-nowarn :g" \
			-e "s:(<property name=\"javacSource\" value=)\".*\":\1\"1.5\":g" \
			-e "s:(<property name=\"javacTarget\" value=)\".*\":\1\"1.5\":g" \
			-e "s:output=\".*(txt|log).*\"::g" -i {} \;

	# jdk home
	sed -r -e "s:^(JAVA_HOME =) .*:\1 $(java-config --jdk-home):" \
		-e "s:gcc :gcc ${CFLAGS} :" \
		-i plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile \
		|| die "sed makefile failed"

	ebegin "Symlinking system jars"
		symlink-ant
		symlink-lucene
		symlink-junit
		symlink-jsch
	eend $?
}

src_compile() {
	# Figure out correct boot classpath
	local bootclasspath=$(java-config --runtime)
	einfo "Using bootclasspath ${bootclasspath}"

	java-pkg_force-compiler ecj-${SLOT}
	ANT_OPTS=-Xmx1024M \
		eant -q -Dnobootstrap=true -Dlibsconfig=true -Dbootclasspath=${bootclasspath} \
		-DinstallOs=linux -DinstallWs=gtk -DinstallArch=${eclipsearch} \
		-Djava5.home=$(java-config --jdk-home)
}

src_install() {
	dodir /usr/lib

	[[ -f result/linux-gtk-${eclipsearch}-sdk.tar.gz ]] \
		|| die "tar.gz bundle was not built properly!"
	tar zxf result/linux-gtk-${eclipsearch}-sdk.tar.gz -C ${D}/usr/lib \
		|| die "Failed to extract the built package"

	mv ${D}/usr/lib/eclipse ${D}/${ECLIPSE_DIR}

	# temp workaround ?! seems not... anyone report upstream?
	mv ${S}/launchertmp/eclipse \
	   ${D}/${ECLIPSE_DIR}
	mv ${S}/launchertmp/library/gtk/eclipse_*.so \
	   ${D}/${ECLIPSE_DIR}/plugins/org.eclipse.equinox.launcher.gtk.linux.*/

	# Install startup script
	exeinto /usr/bin
	doexe ${FILESDIR}/eclipse-${SLOT}
	echo "-Xss2048k" >> ${D}/${ECLIPSE_DIR}/eclipse.ini

	make_desktop_entry eclipse-${SLOT} "Eclipse ${PV}" "${ECLIPSE_DIR}/icon.xpm"

	cd ${D}/${ECLIPSE_DIR}
	install-link-system-jars

	# gcj magic
	if use gcj ; then
		einfo "Check RAM for GCJ native build"
		CHECKREQS_MEMORY="1000"
		if ! check_reqs_conditional ; then
			einfo "This makes just no sense with less than 1GB RAM."
		else
			java-pkg_skip-cachejar 1500 org.eclipse.jdt.core_
			java-pkg_skip-cachejar 2000 org.eclipse.jdt.ui_

			# create Java native libraries
			java-pkg_cachejar
		fi
	fi
}

pkg_postinst() {
	einfo
	einfo "Users can now install plugins via Update Manager without any"
	einfo "tweaking."
	einfo
	einfo "Eclipse plugin packages (ie eclipse-cdt) will likely go away in"
	einfo "the near future until they can be properly packaged. Update Manager"
	einfo "is prefered in the meantime."
	einfo
	einfo "If you plan to use heavy plugins, mind to read"
	einfo "file://${ECLIPSE_DIR}/readme/readme_eclipse.html#Running%20Eclipse"
	einfo "about memory issues"
	einfo "(and to eventually modify ${ECLIPSE_DIR}/eclipse.ini)"
	einfo

	if use gcj ; then
		rm -f /usr/lib/eclipse-${ECLIPSE_VER}/eclipse.gcjdb
		${FILESDIR}/build-eclipse-classmap ${SLOT}
	fi
}

# -----------------------------------------------------------------------------
#  Helper functions
# -----------------------------------------------------------------------------

install-link-system-jars() {
	local ant_dir="$(basename plugins/org.apache.ant_*)"
	rm -rf plugins/org.apache.ant_*
	dosym /usr/share/ant-core ${ECLIPSE_DIR}/plugins/${ant_dir}

	symlink-lucene
	symlink-junit
	symlink-jsch
}

symlink-ant() {
	pushd plugins/org.apache.ant_*/lib/
	rm *.jar
	java-pkg_jarfrom ant-core
	java-pkg_jarfrom --build-only ant-nodeps
	popd
}

symlink-lucene() {
	pushd plugins/
	local lucene_jar="$(basename org.apache.lucene_*.jar)"
	local lucene_analysis_jar="$(basename org.apache.lucene.analysis_*.jar)"
	rm ${lucene_jar} ${lucene_analysis_jar}
	java-pkg_jar-from lucene-2 lucene.jar ${lucene_jar}
	java-pkg_jar-from lucene-analyzers-2 lucene-analyzers.jar ${lucene_analysis_jar}
	popd
}

symlink-junit() {
	pushd plugins/org.junit_*/
	rm *.jar
	java-pkg_jarfrom junit
	popd

	pushd plugins/org.junit4*/
	rm *.jar
	java-pkg_jarfrom junit-4
	popd
}

symlink-jsch() {
	pushd plugins/
	local jsch_jar="$(basename com.jcraft.jsch_*.jar)"
	rm ${jsch_jar}
	java-pkg_jar-from jsch jsch.jar ${jsch_jar}
	popd
}

patch-apply() {
	# patch launcher source
	mkdir launchertmp
	unzip -qq -d launchertmp plugins/org.eclipse.platform/launchersrc.zip >/dev/null || die "unzip failed"
	pushd launchertmp/
	epatch ${PATCHDIR}/launcher_double-free.diff
	sed -r -e "s/CFLAGS = -O -s -Wall/CFLAGS = ${CFLAGS} -Wall/" \
		-i library/gtk/make_linux.mak || die "Failed to tweak make_linux.mak"
	zip -q -6 -r ../launchersrc.zip * >/dev/null || die "zip failed"
	popd
	mv launchersrc.zip plugins/org.eclipse.platform/launchersrc.zip
	rm -rf launchertmp

	# disable swt, jdk6
	epatch ${PATCHDIR}/eclipse_disable-swt.diff
	epatch ${PATCHDIR}/eclipse_disable-jdt-tool.diff
	epatch ${PATCHDIR}/eclipse_disable-jdk6.diff

	# waaaaahhhhhhk !!!!11oneone
	epatch ${PATCHDIR}/how_to_loose_sanity_on_freaky_env_vars_argh.diff

	# JNI
	epatch ${FEDORA}/eclipse-libupdatebuild2.patch

	# fedora does not apply this anymore because they checkout
	# org.eclipse.equinox.initializer project from cvs. 'till a fix, we'll
	# keep the old patch
	pushd plugins/org.eclipse.core.runtime >/dev/null
	epatch ${FEDORA}/eclipse-fileinitializer.patch
	popd >/dev/null

	# generic releng plugins that can be used to build plugins
	# https://www.redhat.com/archives/fedora-devel-java-list/2006-April/msg00048.html
	pushd plugins/org.eclipse.pde.build >/dev/null
	# %patch53
	epatch ${FEDORA}/eclipse-pde.build-add-package-build.patch
	sed -e "s:@eclipse_base@:${ECLIPSE_DIR}:g" \
		-i templates/package-build/build.properties
	popd >/dev/null

	# BRANDING
# FIXME link?
#	if use branding; then
#		pushd plugins/org.eclipse.platform >/dev/null
#		cp ${WORKDIR}/splash.bmp .
#		popd >/dev/null
#	fi
}
