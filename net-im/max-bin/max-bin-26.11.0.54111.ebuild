# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm desktop

DESCRIPTION="MAX Messenger — российский мессенджер от VK с поддержкой звонков, каналов и ботов"
HOMEPAGE="https://max.ru"
SRC_URI="https://download.max.ru/linux/rpm/el/9/x86_64/MAX-26.11.0.54111.rpm"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""
RESTRICT="mirror"

# Зависимости на основе анализа deb-пакета
RDEPEND="
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	dodir /opt
	cp -R "${S}/usr/max" ${D}/opt

	dodir /usr/share/icons/hicolor
	cp -R ${S}/usr/share/icons/hicolor/* ${D}/usr/share/icons/hicolor

	dodir /usr/share/pixmaps
	cp -R ${S}/usr/share/pixmaps/* ${D}/usr/share/pixmaps

	insinto /usr/share/applications
	doins "${S}/usr/share/applications/max.desktop" || die
	sed -i "s:/usr/share/max/bin/:/opt/max/bin/:g" ${D}/usr/share/applications/max.desktop

	dodir /opt
	cp -R ${S}/usr/share/max ${D}/opt/

	dodir /usr/bin
	dosym /opt/max/bin/max /usr/bin/max

}
