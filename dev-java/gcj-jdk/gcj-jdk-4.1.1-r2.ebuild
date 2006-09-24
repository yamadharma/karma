# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

JAVA_SUPPORTS_GENERATION_1="true"
inherit java-vm-2 multilib

ECJ_VER="3.2"
GCJ_HOME="/usr/lib/gcj-${PV}"
COMPAT="java-gcj-compat-1.0.56"
S="${WORKDIR}/${COMPAT}"

DESCRIPTION="Java wrappers around GCJ"
HOMEPAGE="http://www.gentoo.org/ ftp://sourceware.org/pub/rhug/"
SRC_URI="ftp://sourceware.org/pub/rhug/${COMPAT}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
SLOT="4.1"

RDEPEND="~dev-java/gcj-${PV}
	=dev-java/eclipse-ecj-${ECJ_VER}*
	>=dev-java/java-config-2"
DEPEND="${RDEPEND}"

#PDEPEND="dev-java/gjdoc"

JAVA_PROVIDE="jdbc-stdext"

src_unpack() {
	unpack ${A}
	cd ${S}

	# some love ...
	sed -e "s:^sdk_dir=.*:sdk_dir=:" \
		-e "s:^jre_dir=.*:jre_dir=jre:" \
		-e "s:\$JAR_INST_DIR:$(java-config -p eclipse-ecj-${ECJ_VER}):" \
		-i configure \
		|| die "..."

	# a bit more love ...
	epatch ${FILESDIR}/clean-Makefile.patch
}

src_compile() {
	# We want to bytecompile with gcj!
	JAVAC="${GCJ_HOME}/bin/gcj -C" JAR="${GCJ_HOME}/bin/fastjar" \
		./configure --with-jvm-root-dir=${GCJ_HOME} || die "..."
	make || die "..."
}

src_install() {
	dodir ${GCJ_HOME}/bin ${GCJ_HOME}/$(get_libdir)

	# evil compat hacks
	insinto ${GCJ_HOME}/$(get_libdir)
	doins ${S}/tools.jar

	# create javac wrapper
	sed -e "s:@HOME@:${GCJ_HOME}:g" \
		-e "s:@ECJ_VER@:${ECJ_VER}:g" \
		< ${FILESDIR}/javac.in \
		> ${D}${GCJ_HOME}/bin/javac \
		|| die "javac wrapper failed"
	
	# create java wrapper
	sed -e "s:@HOME@:${GCJ_HOME}:g" \
		< ${FILESDIR}/java.in \
		> ${D}${GCJ_HOME}/bin/java \
		|| die "java wrapper failed"

	# fix permissions
	fperms 755 ${GCJ_HOME}/bin/java{,c}

	# copy javadoc wrapper
	exeinto ${GCJ_HOME}/bin
	doexe ${FILESDIR}/javadoc

	# link jar, javah, rmic, rmiregistry, libjawt, rt.jar
	dosym ${GCJ_HOME}/bin/fastjar ${GCJ_HOME}/bin/jar
	dosym ${GCJ_HOME}/bin/gjnih ${GCJ_HOME}/bin/javah
	dosym ${GCJ_HOME}/bin/grmic ${GCJ_HOME}/bin/rmic
	dosym ${GCJ_HOME}/bin/grmiregistry ${GCJ_HOME}/bin/rmiregistry
	dosym ${GCJ_HOME}/$(get_libdir)/libgcjawt.so ${GCJ_HOME}/$(get_libdir)/libjawt.so
	dosym ${GCJ_HOME}/share/java/libgcj-${PV//_/-}.jar ${GCJ_HOME}/$(get_libdir)/rt.jar

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
	echo
	ewarn "Set 'gcj' useflag in /etc/make.conf"
	echo
	ewarn "Check if gcj-jdk is set as Java SDK"
	ewarn "	# java-config -L"
	ewarn
	ewarn "Set gcj-jdk as Java SDK"
	ewarn "	# java-config -S ${PN}-${SLOT}"
	ewarn
	ewarn "Edit /etc/java-config-2/build/jdk.conf"
	ewarn "	*=${PN}-${SLOT}"
	echo
	ewarn "Install GCJ's javadoc"
	ewarn "	# emerge gjdoc"
}
