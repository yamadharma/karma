# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg unpacker systemd

DESCRIPTION="Amnezia VPN Client"
HOMEPAGE="https://amnezia.org"

MY_PN=${PN/-bin}

SRC_URI="https://github.com/amnezia-vpn/${MY_PN}/releases/download/${PV}/AmneziaVPN_${PV}_linux_x64.tar -> ${P}.tar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase
	dev-qt/qtremoteobjects
	net-firewall/iptables
	x11-libs/libxcb
	x11-libs/xcb-util-cursor
"

RDEPEND="
    ${DEPEND}
"

RESTRICT="bindist mirror strip"

S=${WORKDIR}

#src_unpack() {
#	unpack_zip "${A}" || die
#	unpacker "AmneziaVPN_Linux_Installer.tar" || die
#}

src_install() {
	mv "AmneziaVPN_Linux_Installer.bin" "${D}" || die

	# Установка конфигурации для загрузки модуля
	insinto "/etc/modules-load.d"
	newins "${FILESDIR}/tun.conf" "tun_amnezia-client.conf"

	# Устанавливаем сценарий запуска для работы с open-rc
	if which rc-service >/dev/null 2>&1; then
		doinitd "${FILESDIR}/AmneziaVPN" || die
		elog "Служба AmneziaVPNd для Open-RC установлена."
	fi
}

pkg_postinst() {
	# Sandbox	Disabled

	modprobe tun

	# Проверка, установлен ли пакет
	if [ -f "/opt/AmneziaVPN/maintenancetool" ]; then
		einfo "Обнаружен установленный пакет, выполняем удаление"
		"/opt/AmneziaVPN/maintenancetool" purge --start-uninstaller --default-answer --confirm-command || die
	fi

	"/AmneziaVPN_Linux_Installer.bin" install --default-answer --accept-licenses --confirm-command || die
	rm -f "/AmneziaVPN_Linux_Installer.bin" || die

	# Устанавливаем и запускаем службу
	if [ "$(systemd_is_booted)" ]; then
		systemct enable "AmneziaVPN.service"
		systemct start "AmneziaVPN.service"
	else
		rc-update add AmneziaVPN
		rc-service AmneziaVPN start

		elog "Для систем без SystemD не работает замена DNS на предоставляемые этим клиентом."
		elog "Для корректной работы DNS при включенном подключении"
		elog "следует выключить функцию KillSwitch. Либо в настройках KillSwitch"
		elog "добавить внешние DNS в исключения, а в настройках вашего"
		elog "подключения к сети указать эти внешние DNS."
		elog ""
		elog "Но перед этим сначала убедитесь, что эти внешние DNS не заблокированы!"
		elog ""
		elog "К сожалению, использование внутренних DNS с включенным KillSwitch не работает!"
		elog ""
	fi

	xdg_desktop_database_update
}

pkg_prerm() {
	# Удаляем службу "AmneziaVPN с автозапуска и останавливаем его
	if systemd_is_booted; then
		systemct disable "AmneziaVPN.service"
		systemct stop "AmneziaVPN.service"
	else
		rc-update delete AmneziaVPN
		rc-service AmneziaVPN stop
	fi

	if [ "${REPLACED_BY_VERSION}" = "" ]; then
		elog "Пакет окончательно удаляется"
		/opt/AmneziaVPN/maintenancetool purge --start-uninstaller --default-answer --confirm-command || die
	fi
}

pkg_postrm() {

	xdg_desktop_database_update
}
