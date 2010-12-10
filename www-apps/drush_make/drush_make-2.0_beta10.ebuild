# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

if [ "${PV##*.}" = "9999" ]; then
	inherit cvs
	ECVS_SERVER="cvs.drupal.org:/cvs/drupal-contrib"
	ECVS_USER="anonymous"
	ECVS_PASS="anonymous"
	ECVS_MODULE="contributions/modules/drush_make"
	S=${WORKDIR}/${ECVS_MODULE}
else
	SRC_URI="http://ftp.drupal.org/files/projects/${PN}-6.x-${PV/_/-}.tar.gz"
	S=${WORKDIR}/${PN}
fi

DESCRIPTION="Drush Make"
HOMEPAGE="http://drupal.org/project/drush_make"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/php[cli,pcre,simplexml]"
RDEPEND="${DEPEND}
	www-apps/drush"

src_prepare() {
	find . -name "CVS" -exec rm -rf {} \;
}

src_install() {
	dodir /usr/share/drush/commands/${PN}
	cp -R ${S}/* ${D}/usr/share/drush/commands/${PN}

	rm ${D}/usr/share/drush/commands/${PN}/*.txt
	rm ${D}/usr/share/drush/commands/${PN}/EXAMPLE.make
	dodoc *.txt EXAMPLE.make || die
}
