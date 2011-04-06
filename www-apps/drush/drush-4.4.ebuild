# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_URI="http://ftp.drupal.org/files/projects/${PN}-7.x-${PV}.tar.gz"
S=${WORKDIR}/${PN}

DESCRIPTION="Drupal-centric shell. Simplifies Drupal installation/management"
HOMEPAGE="http://drupal.org/project/drush"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

#DEPEND="dev-lang/php[cli,simplexml]"
DEPEND="dev-lang/php[cli,simplexml] dev-php/pear"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/drush
	exeinto /usr/share/drush

	dodoc README.txt || die

	doins -r includes commands drush.php drush.info || die

	doexe drush || die

	dosym /usr/share/drush/drush /usr/bin/drush || die

	use examples && cp -R examples ${D}/usr/share/doc/${PF}
}
