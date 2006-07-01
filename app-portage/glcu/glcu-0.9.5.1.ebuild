# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="gentoo linux cron update. Full featured semi-automatic updates for your gentoo box."
HOMEPAGE="http://www.panhorst.com/glcu/"
SRC_URI="http://www.panhorst.com/glcu/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="esearch eix"

RDEPEND=">=dev-lang/python-2.2
         >=sys-apps/portage-2.0.50
         >=app-portage/gentoolkit-0.2.0
         mail-client/mailx
         esearch? ( >=app-portage/esearch-0.7 )
         eix? ( >=app-portage/eix-0.2.2 )"

src_install() {
	dodir /usr/sbin/
	dodir /etc/cron.daily/

	exeinto /usr/lib/glcu
	doexe glcu.py || die "doexe failed"

	dosym /usr/lib/glcu/glcu.py /etc/cron.daily/glcu
	dosym /usr/lib/glcu/glcu.py /usr/sbin/glcu

	insinto /etc/conf.d
	doins glcu


#	doman 
#	dodoc 

}

pkg_postinst() {
    einfo ""
    einfo " Before you can use glcu, you must edit the config file:"
    einfo "   /etc/conf.d/glcu"
    einfo ""
    use esearch && einfo " For esearch support set eupdatedb=yes in the config file"
    use eix && einfo " For eix support set updateix=yes in the config file"
}
