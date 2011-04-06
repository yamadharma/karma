# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

if [ "${PV##*.}" = "9999" ]; then
	inherit cvs
	ECVS_SERVER="cvs.drupal.org:/cvs/drupal-contrib"
	ECVS_USER="anonymous"
	ECVS_PASS="anonymous"
	ECVS_MODULE="contributions/modules/drush"
	S=${WORKDIR}/${ECVS_MODULE}
else
	SRC_URI="http://ftp.drupal.org/files/projects/${PN}-All-Versions-${PV}.tar.gz"
	S=${WORKDIR}/${PN}
fi

DESCRIPTION="Drupal-centric shell. Simplifies Drupal installation/management"
HOMEPAGE="http://drupal.org/project/drush"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="dev-lang/php[cli,simplexml]"
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
