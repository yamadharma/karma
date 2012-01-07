# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

INSTALL_DIR="/opt/twonkymedia"
DATA_DIR="/var/lib/${PN}"

EAPI=4
inherit eutils savedconfig
DESCRIPTION="Use Twonky to share your favorite media with PCs, TVs, stereos and other devices connected to your network"
HOMEPAGE="http://www.twonkymedia.com/"
SRC_URI="http://www.twonkymedia.com/upfiles/${PN}-i386-glibc-2.2.5-${PV}.zip"
LICENSE=""
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="compile build"
QA_PREBUILT="opt/twonkymedia/cgi-bin/cgi-jpegscale
  opt/twonkymedia/cgi-bin/convert
  opt/twonkymedia/twonkymediaserver
  opt/twonkymedia/twonkymedia
  opt/twonkymedia/plugins/mediafusion-integration-plugin
  opt/twonkymedia/plugins/itunes-import
  opt/twonkymedia/twonkywebdav"

pkg_setup() {
enewgroup twonkymedia
enewuser twonkymedia -1 -1 $DATA_DIR twonkymedia
}

src_unpack() {
mkdir ${WORKDIR}/${P}
cd "${WORKDIR}/${P}"
unpack ${A}
}

src_prepare() {
cp twonkymedia-server-default.ini twonkyvision-mediaserver.ini
sed -i `grep --line-number ^ignoredir twonkyvision-mediaserver.ini | sed s/:.*//`s/$/,\$RECYCLE.BIN/ twonkyvision-mediaserver.ini
touch twonkymedia-config.html
echo "#Enter your IP address here" > ${T}/${PN}
echo "#TVMSIP=192.168.2.40" >> ${T}/${PN}
use savedconfig && restore_config ${DATA_DIR}/twonkyvision-mediaserver.ini ${DATA_DIR}/twonkymedia-config.html
}

src_install() {
dodoc Linux-HowTo.txt RevisionHistory
doinitd ${FILESDIR}/${PN}
doconfd ${T}/${PN}
dodir ${DATA_DIR}
fowners twonkymedia:twonkymedia ${DATA_DIR}
insinto ${DATA_DIR}
use savedconfig && doins var/lib/twonkymedia/twonkymedia-config.html var/lib/twonkymedia/twonkyvision-mediaserver.ini || doins twonkymedia-config.html twonkyvision-mediaserver.ini
rm -Rf var
fowners twonkymedia:twonkymedia ${DATA_DIR}/twonkymedia-config.html ${DATA_DIR}/twonkyvision-mediaserver.ini
dodir /var/log/${PN}
fowners twonkymedia:twonkymedia /var/log/${PN}
rm twonkymedia-config.html twonkyvision-mediaserver.ini
dosym ${DATA_DIR}/twonkymedia-config.html /opt/${PN}/twonkymedia-config.html 
insinto /opt/${PN}
doins -r *
fperms 755 /opt/${PN}/{twonkymedia,twonkymediaserver,twonkywebdav}
fperms 755 /opt/twonkymedia/resources/remote/{remoteaccess.swf,playerProductInstall.swf,themes/default/defaultStyles.swf}
fperms 755 /opt/twonkymedia/cgi-bin/{cgi-jpegscale,convert}
fperms 755 /opt/twonkymedia/plugins/{itunes-import,mediafusion-integration-plugin}
use savedconfig || save_config ${DATA_DIR}/twonkyvision-mediaserver.ini ${DATA_DIR}/twonkymedia-config.html
}
