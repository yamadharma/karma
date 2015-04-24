# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorator/colorator-0.1-r1.ebuild,v 1.3 2015/02/25 18:02:33 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_EXTRAINSTALL="assets"

RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION:-${PV/_rc/.rc.}}"

inherit ruby-fakegem

DESCRIPTION="A framework creating Jekyll/Octopress themes and plugins."
HOMEPAGE="https://github.com/octopress/ink"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/uglifier-2.5
        www-apps/jekyll
	www-apps/octopress-include-tag
	www-apps/octopress-hooks
	www-apps/octopress-filters
	www-apps/octopress-date-format
	www-apps/octopress-autoprefixer
	www-apps/octopress
"

ruby_add_bdepend "test? ( 
	dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	dev-ruby/pry-byebug )"
