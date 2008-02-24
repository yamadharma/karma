# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit java-vm-2 multilib

ECJ_VER="3.4"
GCJ_HOME="/usr/lib/gcj-${PV}"

DESCRIPTION="Java wrappers around GCJ"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
IUSE="nsplugin"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="4.3"

RDEPEND="~dev-java/gcj-${PV}
	=dev-java/eclipse-ecj-${ECJ_VER}*
	>=dev-java/java-config-2"
DEPEND="${RDEPEND}"
#PDEPEND="dev-java/gjdoc"

JAVA_PROVIDE="jdbc-stdext jdbc2-stdext gnu-jaxp"

src_install() {
	# jre lib paths ...
	local libarch="${ARCH}"
	[ ${ARCH} == x86 ] && libarch="i386"
	[ ${ARCH} == x86_64 ] && libarch="amd64"

	# links
	dosym ${GCJ_HOME}/bin/java ${GCJ_HOME}/jre/bin/java
	dosym ${GCJ_HOME}/bin/gjar ${GCJ_HOME}/bin/jar
	dosym /usr/bin/gjdoc ${GCJ_HOME}/bin/javadoc
	dosym ${GCJ_HOME}/bin/grmic ${GCJ_HOME}/bin/rmic
	dosym ${GCJ_HOME}/bin/gjavah ${GCJ_HOME}/bin/javah
	dosym ${GCJ_HOME}/bin/gappletviewer ${GCJ_HOME}/bin/appletviewer
	dosym ${GCJ_HOME}/bin/gjarsigner ${GCJ_HOME}/bin/jarsigner
	dosym ${GCJ_HOME}/bin/grmiregistry ${GCJ_HOME}/bin/rmiregistry
	dosym ${GCJ_HOME}/bin/grmiregistry ${GCJ_HOME}/jre/bin/rmiregistry
	dosym ${GCJ_HOME}/bin/gkeytool ${GCJ_HOME}/bin/keytool
	dosym ${GCJ_HOME}/bin/gkeytool ${GCJ_HOME}/jre/bin/keytool
	dosym ${GCJ_HOME}/$(get_libdir)/libjvm.so ${GCJ_HOME}/jre/lib/${libarch}/client/libjvm.so
	dosym ${GCJ_HOME}/$(get_libdir)/libjawt.so ${GCJ_HOME}/jre/lib/${libarch}/libjawt.so
	dosym ${GCJ_HOME}/share/java/libgcj-tools-${PV/_/-}.jar ${GCJ_HOME}/$(get_libdir)/tools.jar

	# javac wrapper
	sed -e "s:@HOME@:${GCJ_HOME}:g" \
		-e "s:@ECJ_VER@:${ECJ_VER}:g" \
		< ${FILESDIR}/javac.in \
		> ${D}${GCJ_HOME}/bin/javac \
		|| die "javac wrapper failed"
	
	# java wrapper
	sed -e "s:@HOME@:${GCJ_HOME}:g" \
		< ${FILESDIR}/java.in \
		> ${D}${GCJ_HOME}/bin/java \
		|| die "java wrapper failed"

	# permissions
	fperms 755 ${GCJ_HOME}/bin/java{,c}

	if use nsplugin ; then
		touch ${D}/${GCJ_HOME}/$(get_libdir)/libgcjwebplugin.so
		install_mozilla_plugin ${GCJ_HOME}/$(get_libdir)/libgcjwebplugin.so
		rm ${D}/${GCJ_HOME}/$(get_libdir)/libgcjwebplugin.so
	fi

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	ewarn "This gcj-jdk ebuild is provided for your convenience, and the use"
	ewarn "of this JDK replacement is not supported by the Gentoo Developers."
	ewarn
	ewarn "You are on your own using this! If you have any interesting news"
	ewarn "let us know: http://forums.gentoo.org/viewtopic-t-379693.html"
	ewarn
	ewarn "Set 'gcj' useflag in /etc/make.conf"
	ewarn
	ewarn "Check if gcj-jdk is set as Java SDK"
	ewarn "	# java-config -L"
	ewarn
	ewarn "Set gcj-jdk as Java SDK"
	ewarn "	# java-config -S ${PN}-${SLOT}"
	ewarn
	ewarn "Edit /etc/java-config-2/build/jdk.conf"
	ewarn "	*=${PN}-${SLOT}"
	ewarn
	ewarn "Install GCJ's javadoc"
	ewarn "	# emerge gjdoc"
}
