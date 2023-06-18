# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

MY_P="common-protos-ruby-googleapis-common-protos-v${PV}"
DESCRIPTION="Common protocol buffer types used by Google APIs"
HOMEPAGE="https://github.com/googleapis/common-protos-ruby"
SRC_URI="https://github.com/googleapis/common-protos-ruby/archive/${PN%-types}/v${PV}.tar.gz -> ${MY_P}.tar.gz"
RUBY_S="${MY_P}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=dev-ruby/google-protobuf-3.14"
