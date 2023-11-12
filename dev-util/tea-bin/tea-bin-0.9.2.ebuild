# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1

DESCRIPTION="A command line tool to interact with Gitea servers"
HOMEPAGE="https://gitea.com/gitea/tea"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitea.com/gitea/tea.git"
else
	SRC_URI="https://gitea.com/gitea/tea/releases/download/v${PV}/tea-${PV}-linux-amd64.xz"
	KEYWORDS="amd64"
	S=${WORKDIR}
fi

LICENSE="as-is"
SLOT="0"

RDEPEND=">=dev-vcs/git-1.7.3"

RESTRICT="test"



src_compile() {
	:;
}

src_install() {
	newbin ${S}/tea-${PV}-linux-amd64 tea
	newbashcomp ${FILESDIR}/autocomplete.sh tea
}
