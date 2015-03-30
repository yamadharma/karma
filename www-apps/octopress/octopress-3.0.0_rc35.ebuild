# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorator/colorator-0.1-r1.ebuild,v 1.3 2015/02/25 18:02:33 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_EXTRAINSTALL="assets local scaffold site"

RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION:-${PV/_rc/.rc.}}"

inherit ruby-fakegem

DESCRIPTION="Octopress is an obsessively designed toolkit for writing and deploying Jekyll blogs"
HOMEPAGE="https://github.com/octopress/octopress"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/mercenary-0.3.2
        www-apps/jekyll
	www-apps/octopress-deploy
	www-apps/octopress-hooks
	www-apps/octopress-escape-code
	dev-ruby/titlecase"

ruby_add_bdepend "test? ( www-apps/octopress-ink
	dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	dev-ruby/pry-byebug )"
