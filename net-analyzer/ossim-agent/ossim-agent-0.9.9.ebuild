# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.3"
inherit eutils python

DESCRIPTION="Open Source Security Information Management - Agent"
HOMEPAGE="http://www.ossim.net/"
MY_PN="ossim-agent"
MY_P="${MY_PN}-${PV/_}"

SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

S="${WORKDIR}/${MY_P}"
MY_CONFDIR='/etc/ossim/agent'

src_install() {
	python_version

	cd "${S}"
	${python} ./setup.py install --root "${D}" --install-scripts=/usr/sbin \
		|| die "setup.py failed"
	newinitd ${FILESDIR}/${PN}.initd ${PN} || die 'init.d installation failed.'
	newconfd ${FILESDIR}/${PN}.confd ${PN} || die 'conf.d installation failed.'
	exeinto /usr/share/${PN}/util
	#doexe util/*.pl || die "${PN} utils installation failed"

	cd "${S}"
	diropts "-m 0770"
	dodir /var/log/ossim
	keepdir /var/log/ossim

	dodir ${MY_CONFDIR}

	insinto ${MY_CONFDIR} || die "Unable to insinto ${MY_CONFDIR}."
	doins etc/agent/*.cfg || die "Unable to copy conf files."

	insinto ${MY_CONFDIR}/plugins || die "Unable to insinto ${MY_CONFDIR}/plugins."
	doins etc/agent/plugins/*.cfg || die "Unable to copy plugin files."

	insinto etc/logrotate.d/ && doins etc/logrotate.d/${PN}
	dodoc doc/${PN}.xml
}
