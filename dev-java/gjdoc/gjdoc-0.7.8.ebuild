# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit autotools eutils java-pkg-2 flag-o-matic

DESCRIPTION="A javadoc compatible Java source documentation generator."
HOMEPAGE="http://www.gnu.org/software/cp-tools/"
SRC_URI="mirror://gnu/classpath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd"

# Possible USE flags.
#
# native: to --enable-native
# doc:    to generate javadoc
# debug:  There is a debug doclet installed by default but maybe could
#         have a wrapper that uses it.
#
IUSE="gcj xmldoclet source"

# Refused to emerge with sun-jdk-1.3* complaining about wanting a bigger stack size
DEPEND=">=dev-java/antlr-2.7.5
	>=virtual/jdk-1.4
	source? ( app-arch/zip )"

RDEPEND=">=virtual/jre-1.4
	>=dev-java/antlr-2.7.5"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch ${FILESDIR}/${PN}-0.7.7-gcp.patch
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	# sanitize CFLAGS for gcj
	use gcj && java-pkg_gcjflags
	append-ldflags -Wl,-rpath=/usr/lib/gcj/lib

	# Does not work with gcc 3.* and without these it tries to use gij
	# see bug #116804 for details

	export GCJ="$(gcj-config --gcj)"
	export GCJFLAGS="${CFLAGS}"
	export JAVAC_FLAGS="$(java-pkg_javac-args)"
	JAVA="java" JAVAC="javac" econf \
		--with-antlr-jar="$(java-config --classpath=antlr)" \
		--disable-dependency-tracking \
		$(use_enable xmldoclet) \
		$(use_enable gcj native) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	local jars="com-sun-tools-doclets-Taglet gnu-classpath-tools-gjdoc com-sun-javadoc"
	for jar in ${jars}; do
		java-pkg_newjar ${jar}-${PV}.jar ${jar}.jar
	done

	if use gcj; then
		# install native gjdoc and libs
		make DESTDIR=${D} install-exec || die "Failed to install native gjdoc!"
		# move native gjdoc
		mv ${D}usr/bin/gjdoc ${D}usr/bin/gjdoc-native
	fi

	dobin ${FILESDIR}/gjdoc
	dodoc AUTHORS ChangeLog NEWS README

	cd ${S}/docs
	make DESTDIR=${D} install || die "Failed to install documentation"

	use source && java-pkg_dosrc "${S}/src"/{com,gnu}
}
