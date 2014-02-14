# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-ru/aspell-ru-0.99.1-r1.ebuild,v 1.9 2012/05/17 20:07:41 aballier Exp $

ASPELL_LANG="Russian + English"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-3"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

# very strange filename not supported by the gentoo naming scheme
#FILENAME=aspell6-ru-0.99f7-1

SRC_URI=""
#S=${WORKDIR}/${FILENAME}

src_compile() {
	ru_list=$(aspell dump dicts | grep -e "^ru.*")

	for i in ${ru_list}
	do
	    aspell dump master en >words.en
	    aspell dump master ${i} >words.${i}
	    cat words.${i} words.en >words.en${i}
    	    aspell --dict-dir="`pwd`" --lang=ru --encoding=UTF-8 create master en${i}.rws < words.en${i}
	    echo "add en${i}.rws" > en${i}.multi
	done

	echo -en "name enru\ncharset utf-8\naffix ru\naffix-compress true\n" > enru.dat
}

src_install() {
	dodir /usr/lib64/aspell-0.60
	cp *.rws *.multi *.dat ${D}/usr/lib64/aspell-0.60
}