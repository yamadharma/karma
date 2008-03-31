# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.3"
WEBAPP_MANUAL_SLOT="yes"
inherit eutils python depend.php php-lib-r1 depend.apache

DESCRIPTION="Open Source Security Information Management - Web Framework"
HOMEPAGE="http://www.ossim.net/"
MY_PN="os-sim"
MY_P="${MY_PN}-${PV/_}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="mysql nagios nessus nmap ntop postgres fpdf"

need_php
want_apache
# 
RDEPEND="${RDEPEND}
	>=dev-php/adodb-4.64
	fpdf? ( >=dev-php/fpdf-1.53 )
	>=my/phpgacl-3.3.6
	|| ( >=dev-php4/jpgraph-1.5.2 >=dev-php5/jpgraph-2.0 )
	>dev-python/py-rrdtool-0.2.1
	>=dev-python/adodb-py-2.00
	>=net-analyzer/base-1.0
	nagios? ( >=net-analyzer/nagios-core-1.4.1 )
	nessus? ( >=net-analyzer/nessus-2.0.12 )
	nmap? ( >=net-analyzer/nmap-3.70 )
	ntop? ( >=net-analyzer/ntop-2.2.93 )
	mysql? ( =net-analyzer/ossim-db-${PV}
		>=dev-python/mysql-python-1.0.0 )
	postgres? ( =net-analyzer/ossim-db-${PV}
		>=dev-python/pypgsql-2.4 )
	>net-analyzer/rrdtool-1.2"

S=${WORKDIR}/${MY_PN}-${PV%_*}
MY_DATADIR=/usr/share/ossim
MY_WWWDIR="${MY_DATADIR}/www"
MY_VARDIR="/var/lib/ossim"
MY_CONFDIR='/etc/ossim/framework'
MY_HTTP_GROUP='root'

pkg_setup() {
	enewgroup ossim || die 'Cannot create ossim group.'
	enewuser ossim -1 -1 /etc/ossim ossim || die 'Cannot create ossim user.'
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die "unpack to ${S} failed"
	rm -rf contrib/py-rrdtool
	for localdir in etc contrib pixmaps scripts www; do
		find ${localdir} -name 'Makefile*' -delete
	done
	mv contrib/fonts fonts

	#gentoo phplib paths
	local conf='etc/framework/ossim.conf'
	local phpdir="/usr/share/php4"
	has_version ">=dev-php5/jpgraph-2.0" && phpdir="/usr/share/php5"
	sed -i -e "s:#.*jpgraph_path.*:jpgraph_path=${phpdir}/jpgraph:" \
		${conf}
	phpdir="/usr/share/php"
	sed -i -e "s:adodb_path.*:adodb_path=${phpdir}/adodb:" \
		${conf}
	sed -i -e "s:phpgacl_path.*:phpgacl_path=${phpdir}/phpgacl:" \
		${conf}
	sed -i -e "s:#.*fpdf_path.*:fpdf_path=${phpdir}/fpdf:" \
		${conf}
	use postgres && sed -i -e 's:^([a-z_])_type=mysql:\1_type=postgres:' \
		${conf}
	sed -i -e "s:ossim_link.*:ossim_link=/ossim/:" ${conf}

	#config 'sane' paths
	for var in host net global level; do
		sed -i -e "s:#.*rrdpath_${var}=.*:rrdpath_${var}=${MY_VARDIR}/rrd/${var}_qualification/:" \
			${conf}
	done
	sed -i -e "s:#.*acid_link.*:acid_link=/base:" ${conf}
	sed -i -e "s:#.*acid_path.*:acid_path=/var/www/localhost/htdocs/base:" \
		${conf}
	echo 'event_viewer=base' >> ${conf}
	use nagios && sed -i -e "s:#.*nagios_link.*:nagios_link=/nagios:" \
		${conf}
	if use nessus; then
		sed -i -e "s:#.*nessus_host.*:nessus_host=localhost:" ${conf}
		sed -i -e "s:#.*nessus_port.*:nessus_port=1241:" ${conf}
		sed -i -e "s:#.*nessus_rpt_path.*:nessus_rpt_path=${MY_VARDIR}/vulnmeter:" \
			${conf}
		sed -i -e "/nessus_rpt_path/ a \
nessusrc_path=${MY_VARDIR}/vulnmeter/tmp/.nessusrc" ${conf}
	fi
	use ntop && sed -i -e "s%#.*ntop_link=.*%ntop_link=http://`hostname`:3000%" \
		${conf}
}

src_install() {
	einfo "Installing frameworkd"
	python_version
	cd "${S}/frameworkd"
	${python} ./setup.py install --root "${D}" --install-scripts=/usr/sbin \
		|| die 'setup.py failed.'
	newinitd ${FILESDIR}/${PN}.initd ${PN} || die 'init.d installation failed.'
	newconfd ${FILESDIR}/${PN}.confd ${PN} || die 'conf.d installation failed.'

	einfo "Installing php includes"
	cd "${S}/include"
	php-lib-r1_src_install . `find . -name '*.php' -o -name '*.inc' \
		-o -name '*.sql'` || die 'Unable to install php includes.'

	cd "${S}"
	einfo "Installing www files"
	insinto ${MY_WWWDIR} || die "Unable to insinto ${MY_WWWDIR}."
	doins -r www/* || die "Unable to copy www files."

	einfo "Installing scripts and shared files"
	local version
	eval `perl '-V:version'`
	local perl_dir="/usr/lib/perl5/${version}"
	insinto  ${perl_dir} || die "Unable to insinto ${perl_dir}."
	doins include/*.pm || die 'Could not create perl modules.'
	insinto  ${MY_DATADIR} || die "Unable to insinto ${MY_DATADIR}."
	doins -r contrib etc/cron.daily fonts pixmaps || die "Unable to install shared files."
	exeinto ${MY_DATADIR}/scripts || die "Unable to exinto ${MY_DATADIR}/scripts."
	doexe scripts/* || die "Unable to install scripts."

	einfo 'Installing config files and docs'
	if use apache; then
		insinto ${APACHE1_VHOSTDIR}
		doins ${FILESDIR}/99_ossim.conf
	fi
	if use apache2; then
		insinto ${APACHE2_VHOSTDIR}
		doins ${FILESDIR}/99_ossim.conf
	fi
	diropts "-m 0770 -o ossim -g ossim"
	dodir /var/log/ossim
	keepdir /var/log/ossim
	dodir ${MY_CONFDIR}
	insinto ${MY_CONFDIR} || die "Unable to insinto ${MY_CONFDIR}."
	doins etc/framework/ossim.conf || die "Unable to copy conf files."
	insinto etc/logrotate.d/ && doins etc/logrotate.d/${PN}
	dodoc README* AUTHORS BUGS CONFIG COPYING ChangeLog FAQ FILES LICENSE \
		NEWS TODO doc/${PN}.xml
}

pkg_postinst() {
	local var_dir="${ROOT}${MY_VARDIR}"
	local opts="-g ossim -o ossim -m 0770"
	einfo "Configuring ${var_dir}"
	install ${opts} -d "${var_dir}/rrd"
	for var in host net global level; do
		install ${opts} -d "${var_dir}/rrd/${var}_qualification"
	done
	install ${opts} -d "${var_dir}/backup"
	install ${opts} -d "${var_dir}/vulnmeter"
	install ${opts} -d "${var_dir}/vulnmeter/tmp"
	touch "${var_dir}/vulnmeter/tmp/.nessusrc"
	chown ossim:ossim ${ROOT}/etc/ossim
	chown ossim:ossim ${ROOT}/var/log/ossim
	einfo ''
	ewarn 'You have to include the webserver user into group ossim,'
	ewarn "in order for ${ROOT}${MY_CONFDIR} to be readable."
	einfo ''
	einfo 'In order to enable daily database backup, please copy:'
	einfo "	${ROOT}${MY_DATADIR}/cron.daily/ scripts to ${ROOT}etc/cron.daily/"
}

