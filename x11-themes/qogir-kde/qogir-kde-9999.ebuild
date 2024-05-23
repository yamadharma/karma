# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Qogir theme for kde plasma desktop"
HOMEPAGE="https://github.com/vinceliuice/Qogir-kde"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vinceliuice/Qogir-kde.git"
	KEYWORDS="amd64 ~x86"
else
	SRC_URI="https://github.com/vinceliuice/Qogir-kde/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		x11-themes/kvantum"
BDEPEND=""

src_install() {
		export AURORAE_DIR="${D}/usr/share/aurorae/themes"
		export SCHEMES_DIR="${D}/usr/share/color-schemes"
		export PLASMA_DIR="${D}/usr/share/plasma/desktoptheme"
		export LOOKFEEL_DIR="${D}/usr/share/plasma/look-and-feel"
		export KVANTUM_DIR="${D}/usr/share/Kvantum"
		export WALLPAPER_DIR="${D}/usr/share/wallpapers"
		export PLASMOIDS_DIR="${D}/usr/share/plasma/plasmoids"
		export LAYOUT_DIR="${D}/usr/share/plasma/layout-templates"

		SRC_DIR=${S}

		[[ ! -d ${AURORAE_DIR} ]] && mkdir -p ${AURORAE_DIR}
		[[ ! -d ${SCHEMES_DIR} ]] && mkdir -p ${SCHEMES_DIR}
		[[ ! -d ${PLASMA_DIR} ]] && mkdir -p ${PLASMA_DIR}
		[[ ! -d ${LOOKFEEL_DIR} ]] && mkdir -p ${LOOKFEEL_DIR}
		[[ ! -d ${KVANTUM_DIR} ]] && mkdir -p ${KVANTUM_DIR}
		[[ ! -d ${WALLPAPER_DIR} ]] && mkdir -p ${WALLPAPER_DIR}
		[[ ! -d ${PLASMOIDS_DIR} ]] && mkdir -p ${PLASMOIDS_DIR}
		[[ ! -d ${LAYOUT_DIR} ]] && mkdir -p ${LAYOUT_DIR}

		[[ -d ${AURORAE_DIR}/${THEME_NAME} ]] && rm -rf ${AURORAE_DIR}/${THEME_NAME}*
		[[ -d ${PLASMA_DIR}/${THEME_NAME} ]] && rm -rf ${PLASMA_DIR}/${THEME_NAME}*
		[[ -f ${SCHEMES_DIR}/${THEME_NAME}.colors ]] && rm -rf ${SCHEMES_DIR}/${THEME_NAME}*.colors
		[[ -d ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME} ]] && rm -rf ${LOOKFEEL_DIR}/com.github.vinceliuice.${THEME_NAME}*
		[[ -d ${KVANTUM_DIR}/${THEME_NAME} ]] && rm -rf ${KVANTUM_DIR}/${THEME_NAME}*
		[[ -d ${WALLPAPER_DIR}/${THEME_NAME} ]] && rm -rf ${WALLPAPER_DIR}/${THEME_NAME}

		name=Qogir

		for color in '' '-light' '-dark'; do
		for theme in ''; do


		cp -r ${SRC_DIR}/aurorae/themes/*                                                  ${AURORAE_DIR}
		cp -r ${SRC_DIR}/color-schemes/*.colors                                            ${SCHEMES_DIR}
		cp -r ${SRC_DIR}/wallpaper/${name}${theme}${ELSE_DARK}                             ${WALLPAPER_DIR}

		mkdir -p                                                                           ${KVANTUM_DIR}/${name}${theme}${color}
		cp -r ${SRC_DIR}/Kvantum/Qogir${color}/Qogir${color}.svg                           ${KVANTUM_DIR}/${name}${theme}${color}/${name}${theme}${color}.svg
		cp -r ${SRC_DIR}/Kvantum/Qogir${color}/Qogir${color}.kvconfig                      ${KVANTUM_DIR}/${name}${theme}${color}/${name}${theme}${color}.kvconfig
		mkdir -p                                                                           ${KVANTUM_DIR}/${name}${theme}${color}-solid
		cp -r ${KVANTUM_DIR}/${name}${theme}${color}/${name}${theme}${color}.svg           ${KVANTUM_DIR}/${name}${theme}${color}-solid/${name}${theme}${color}-solid.svg
		cp -r ${SRC_DIR}/Kvantum/${name}${color}-solid/${name}${color}-solid.kvconfig      ${KVANTUM_DIR}/${name}${theme}${color}-solid/${name}${theme}${color}-solid.kvconfig


		mkdir -p                                                                           ${PLASMA_DIR}/${name}${theme}${ELSE_DARK}
		cp -r ${SRC_DIR}/plasma/desktoptheme/Qogir/*                                       ${PLASMA_DIR}/${name}${theme}${ELSE_DARK}
		sed -i "s|Name=Qogir|Name=${name}${theme}${ELSE_DARK}|"                            ${PLASMA_DIR}/${name}${theme}${ELSE_DARK}/metadata.desktop
		sed -i "s|defaultWallpaperTheme=Qogir|defaultWallpaperTheme=${name}${theme}${ELSE_DARK}|" ${PLASMA_DIR}/${name}${theme}${ELSE_DARK}/metadata.desktop

		if [[ ${color} == '-dark' ]]; then
		cp -r ${SRC_DIR}/color-schemes/${name}${a_theme}Dark.colors                      ${PLASMA_DIR}/${name}${theme}-dark/colors
		cp -r ${SRC_DIR}/plasma/desktoptheme/Qogir-dark/*                                ${PLASMA_DIR}/${name}${theme}-dark
		else
		cp -r ${SRC_DIR}/color-schemes/${name}${a_theme}Light.colors                     ${PLASMA_DIR}/${name}${theme}/colors
		fi

		cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${theme}${color} ${LOOKFEEL_DIR}
		cp -ur ${SRC_DIR}/plasma/plasmoids/*                                               ${PLASMOIDS_DIR}
		cp -ur ${SRC_DIR}/plasma/layout-templates/*                                        ${LAYOUT_DIR}

		done
		done

}

