# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="3"

CABAL_FEATURES="lib profile haddock hscolour"
inherit haskell-cabal

DESCRIPTION="arbtt is a background daemon that stores which windows are open, which one has the focus and how long since your last action (and possbly more sources later), and stores this"
HOMEPAGE="http://hackage.haskell.org/package/arbtt
http://www.joachim-breitner.de/projects#arbtt"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz
http://www.joachim-breitner.de/archive/${PN}/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/binary
		dev-haskell/bytestring
		dev-haskell/containers
		dev-haskell/deepseq
		dev-haskell/directory
		dev-haskell/filepath
		dev-haskell/mtl
		dev-haskell/parsec:3
		dev-haskell/pcre-light
		dev-haskell/time
		dev-haskell/unix
		dev-haskell/utf8-string
		dev-haskell/x11
		dev-haskell/old-locale
		>=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
