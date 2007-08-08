# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Secure PIN handling using NSS crypto"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/v${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="ipv6 debug sasl"

DEPEND="dev-libs/nspr
	dev-libs/nss
	dev-libs/svrcore"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/mozilla/directory/c-sdk
S1=${WORKDIR}/${P}/mozilla/dist

src_compile() {
	local myconf
	use amd64 && myconf="${myconf} --enable-64bit"

	use ipv6 && myconf="${myconf} --enable-ipv6"

	econf \
	    $(use_enable debug) $(use_with sasl) \
	    --with-system-nss \
	    --with-system-nspr \
	    --with-system-svrcore \
	    --with-sasl \
	    --enable-clu \
	    --with-pthreads \
	    --enable-optimize \
	    ${myconf} || die
	
	emake || die	    
}

src_install () {
	# Copy the binary libraries we want
	dodir /usr/lib
	cp -L ${S1}/lib/*.so ${D}/usr/lib
	cp -L ${S1}/lib/*.a ${D}/usr/lib

	# Copy the binaries we want
	# placement like Fedora (not Debian)
	cd ${S1}/bin
	exeinto /usr/lib/${PN}
	for i in ldap*
	do
		doexe ${i}
	done

	# Copy the include files
	insinto /usr/include/mozldap
	doins ${S1}/public/ldap/*.h
#	doins ${S1}/mozilla/dist/public/ldap-private/*.h	

	# Copy the developer files
	dodir /usr/share/mozldap
	cp -rL ${S}/ldap/examples ${D}/usr/share/mozldap
	
	cp -rL ${S1}/etc ${D}/usr/share/mozldap

	# Set up our package file
	dodir /usr/lib/pkgconfig
	sed \
	    -e "s,%bindir%,\${libdir}/${PN},g" \
	    -e "s,%libdir%,\${exec_prefix}/lib,g" \
	    -e "s,%prefix%,/usr,g" \
	    -e "s,%exec_prefix%,\${prefix},g" \
	    -e "s,%includedir%,\${prefix}/include/mozldap,g" \
	    -e "s,%major%,6,g" \
	    -e "s,%minor%,0,g" \
	    -e "s,%submin%,3,g" \
	    -e "s,%libsuffix%,60,g" \
	    -e "s,%NSPR_VERSION%,$(pkg-config --modversion nspr),g" \
	    -e "s,%NSS_VERSION%,$(pkg-config --modversion nss),g" \
	    -e "s,%MOZLDAP_VERSION%,${PV},g" \
	    ${S}/mozldap.pc.in > \
	    ${D}/usr/lib/pkgconfig/mozldap.pc

	dodoc ${S}/README*
}
