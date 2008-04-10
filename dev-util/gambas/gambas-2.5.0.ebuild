# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt3

MY_P="${PN}2-${PV}"
DESCRIPTION="A RAD tool for BASIC"
HOMEPAGE="http://gambas.sourceforge.net"
SRC_URI="mirror://sourceforge/gambas/${MY_P}.tar.bz2"
#echo -e "Version" ${V}

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="x86 amd64"
IUSE="postgres mysql sdl doc curl sqlite xml zlib kde bzip2 odbc ldap pdf opengl sqlite3 pcre gtk"

RDEPEND="$(qt_min_version 3.2)
	kde? ( >=kde-base/kdelibs-3.2 )
	sdl? ( media-libs/libsdl media-libs/sdl-mixer )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	curl? ( net-misc/curl )
	sqlite? ( =dev-db/sqlite-2* )
	sqlite3? ( >=dev-db/sqlite-3 )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	zlib? ( sys-libs/zlib )
	bzip2? ( app-arch/bzip2 )
	odbc? ( dev-db/unixODBC )
	ldap? ( net-nds/openldap )
	gtk? ( >=x11-libs/gtk+-2.6.4 )
	pdf? ( app-text/poppler )
	pcre? ( dev-libs/libpcre )"

DEPEND="dev-libs/libffi"
#DEPEND="dev-libs/openssl"

S="${WORKDIR}/${MY_P}"

src_compile() {

	local ext_conf=""

# TODO: work opengl deps out first
#if use opengl; then
#	ext_conf="${ext_conf} $(use_enable sdl sdlopengl)"
#	ext_conf="${ext_conf} $(use_enable qt qtopengl)"
#fi

	

	econf \
		--enable-qt \
		--enable-net \
		--enable-crypt \
		--enable-vb \
		--disable-corba \
		--enable-opengl \
		--enable-sdlopengl \
		--enable-sdl_opengl \
		--enable-qtopengl \
		$(use_enable mysql) \
		$(use_enable postgres) \
		$(use_enable sqlite) \
		$(use_enable sqlite3) \
		$(use_enable sdl) \
		$(use_enable curl) \
		$(use_enable zlib) \
		$(use_enable xml) \
		$(use_enable bzip2 bzlib2) \
		$(use_enable kde) \
		$(use_enable gtk) \
		$(use_enable odbc) \
		$(use_enable pdf) \
		$(use_enable pcre) \
		$(use_enable ldap) \
		${ext_conf} \
		--disable-optimization \
		--disable-debug \
		--disable-profiling \
		|| die "econf failed"

	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "Compile failed"
}

src_install() {
	
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc README INSTALL NEWS AUTHORS ChangeLog TODO

}
