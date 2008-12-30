# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit stardict

DESCRIPTION="Mueller English to Russian Dictionary, 7th edition"
HOMEPAGE="http://mueller-dic.chat.ru/ http://stardict.sourceforge.net/Dictionaries_dictd-www.mova.org.php"
SRC_URI="build? ( accent? ( http://mueller-dic.chat.ru/Mueller7accentGPL.tgz )
					!accent? ( http://mueller-dic.chat.ru/Mueller7GPL.tgz ) )
		accent? ( mirror://sourceforge/stardict/stardict-Mueller7accentGPL-2.4.2.tar.bz2 )
		!accent? ( mirror://sourceforge/stardict/stardict-mueller7-2.4.2.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="build accent"

DEPEND="build? ( app-dict/makedict )"

S=${WORKDIR}

get_S() {
	if use build; then
		echo "${WORKDIR}/usr/local/share/dict"
	else
		use accent && \
			echo "${WORKDIR}/stardict-Mueller7accentGPL-2.4.2" || \
			echo "${WORKDIR}/stardict-mueller7-2.4.2"
	fi
}

src_compile() {
	cd "$(get_S)"
	if use build; then
		if use accent; then
			makedict -i mueller7 -o stardict Mueller7accentGPL.koi
			cd stardict-Mueller7accentGPL-2.4.2
		else
			makedict -i mueller7 -o stardict Mueller7GPL.koi
			cd stardict-Mueller7GPL-2.4.2
		fi
	fi
	stardict_src_compile
}

src_install() {
	cd "$(get_S)"
	if use build; then
		insinto /usr/share/stardict/dic
		if use accent; then
			doins -r stardict-Mueller7accentGPL-2.4.2
		else
			doins -r stardict-Mueller7GPL-2.4.2
		fi
	else
		stardict_src_install
	fi
}
