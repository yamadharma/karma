# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="F4 file manager - бинарная ночная сборка (клон Far Manager на Go)"
HOMEPAGE="https://github.com/unxed/f4"

SRC_URI="https://github.com/unxed/f4/releases/download/v${PV/_/-}/f4-linux-amd64.tar.gz -> f4-linux-amd64-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"   # замените на свою архитектуру, если нужно
RESTRICT="mirror strip"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_install() {
	# 1. Устанавливаем бинарник в /usr/libexec/f4/
	exeinto /usr/libexec/f4
	doexe f4

	# 2. Устанавливаем все остальные каталоги и файлы в /usr/share/f4/
	#    Исключаем сам бинарник (он уже установлен)
	for item in *; do
		if [[ -d "$item" ]]; then
			# Копируем каталог рекурсивно
			insinto /usr/share/f4
			doins -r "$item"
		elif [[ -f "$item" && "$item" != "f4" ]]; then
			# Копируем отдельные файлы (если есть)
			insinto /usr/share/f4
			doins "$item"
		fi
	done

	# 3. Создаём скрипт-обёртку в /usr/bin/f4
	cat > "${T}/f4-wrapper" <<-EOF
#!/bin/sh
export F4_SHARE_DIR="/usr/share/f4"
exec /usr/libexec/f4/f4 "\$@"
EOF
	exeinto /usr/bin
	doexe "${T}/f4-wrapper"
	# Переименовываем в f4
	mv "${D}/usr/bin/f4-wrapper" "${D}/usr/bin/f4" || die
}
