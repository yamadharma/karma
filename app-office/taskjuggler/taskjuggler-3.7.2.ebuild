# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

USE_RUBY="ruby26 ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_GEMSPEC="taskjuggler.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL="benchmarks data examples manual"

inherit ruby-fakegem

MY_PN="TaskJuggler"

DESCRIPTION="Project Management beyond Gantt Chart Drawing"
SRC_URI="https://github.com/taskjuggler/TaskJuggler/archive/refs/tags/v${PV}.tar.gz  -> ${P}.tar.gz"
HOMEPAGE="http://taskjuggler.org/"


LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
SLOT="0"

RDEPEND="dev-ruby/mail
	dev-ruby/term-ansicolor"

#S=${WORKDIR}/all/${MY_PN}-${PV}

each_ruby_prepare() {
	cd ${MY_PN}-${PV}
	mv * ../ || die
}