#Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Open Source Security Information Management"
HOMEPAGE="http://www.ossim.net/"

MY_PN="os-sim"
MY_P="${MY_PN}-${PV/_}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc mysql postgres eventdb-only ossimdb-only"

DEPEND=""
RDEPEND="mysql? ( >=dev-db/mysql-4.1 )
	postgres? ( !mysql? ( >=dev-db/postgresql-7.3 ) )"

# S="${WORKDIR}/${MY_P}"
S=${WORKDIR}/${MY_PN}-${PV%_*}

pkg_setup()
{
	use eventdb-only && use ossimdb-only && \
		ewarn 'Conflicting flags: eventdb-only and ossimdb-only. ' \
		'No database will be configured on emerge --config.' && ebeep
	use mysql && use postgres && \
		ewarn 'Both flags activated: mysql and postgres. mySQL will be used.'
	if ! use mysql && ! use postgres; then
		die 'One flag must be activated: mysql or postgres.'
	fi
}

src_install() {
	cd "${S}"
	insinto /usr/share/${PN}
	if ! use eventdb-only; then
		doins db/*.sql || die 'Unable to copy ossim db files.'
		doins db/*.sql.bz2 || die 'Unable to copy ossim db files.'
	fi
	if ! use ossimdb-only; then
		doins contrib/{acid,snort}/*.sql \
			|| die 'Unable to copy event db files.'
	fi
	
	insinto /usr/share/${PN}/plugins
	doins db/plugins/*
	
	use doc && dodoc doc/ossim_db_structure.txt
}

pkg_postinst() {
	einfo
	einfo "OSSIM sql scripts  have been installed under /usr/share/${PN}."
	einfo "To setup the initial database, launch:"
	einfo "	emerge --config ${PN}"
	einfo
}

pkg_config() {
	local tmp_sql="/tmp/ossim_sql"
	if built_with_use ${PN} mysql; then
		ewarn 'Please type in the mysql root password when asked:'
		local cmd_fill_db="mysql -u root -p < $tmp_sql"
	else
		local cmd_fill_db="psql -U postgres -f $tmp_sql template1"
	fi
	local share_sql="${ROOT}/usr/share/${PN}"
	if ! built_with_use ${PN} eventdb-only; then
		einfo 'Creating ossim database...'
		if built_with_use ${PN} mysql; then
			#bugfix: mysql ossim_acl table creation from phpgacl schema
			echo 'CREATE DATABASE ossim;
CREATE DATABASE ossim_acl CHARACTER SET latin1;
USE ossim;' > $tmp_sql
			cat ${share_sql}/create_mysql.sql >> $tmp_sql
		else
			echo 'CREATE DATABASE ossim;
CREATE DATABASE ossim_acl;
\connect "ossim"' > $tmp_sql
			cat ${share_sql}/create_pgsql.sql >> $tmp_sql
		fi
		cat ${share_sql}/ossim_config.sql \
			${share_sql}/ossim_data.sql \
			${share_sql}/snort_nessus.sql \
			>> $tmp_sql
# FIXME where is realsecure.sql ?    
#			${share_sql}/realsecure.sql \			
		eval "${cmd_fill_db}" || die "Error executing '${cmd_fill_db}'."
	fi
	if ! built_with_use ${PN} ossimdb-only; then
		einfo 'Creating event database...'
		if built_with_use ${PN} mysql; then
			echo 'CREATE DATABASE snort;
USE snort;' > $tmp_sql;
		else
			echo 'CREATE DATABASE snort;
\connect "snort"' > $tmp_sql;
		fi
		cat ${share_sql}/create_acid_tbls_mysql.sql \
			${share_sql}/create_snort_tbls_mysql.sql \
			>> $tmp_sql
		eval "${cmd_fill_db}" || die "Error executing '${cmd_fill_db}'."
	fi
	rm -f $tmp_sql
	einfo 'Initial OSSIM DB setup completed.'
}

