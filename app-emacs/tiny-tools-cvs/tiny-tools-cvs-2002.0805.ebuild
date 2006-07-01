# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/auctex/auctex-10.0g.ebuild,v 1.1 2002/11/01 02:52:00 mkennedy Exp $


ECVS_SERVER="offline"

#ECVS_SERVER="cvs.tiny-tools.sourceforge.net:/cvsroot/tiny-tools"
ECVS_MODULE="tiny-tools"
# ECVS_BRANCH="SAMBA_3_0"
# ECVS_USER="cvs"
ECVS_CVS_OPTIONS="-dP"

inherit elisp cvs

IUSE=""


DESCRIPTION="Emacs Tiny Tools is a collection of libraries and packages"
HOMEPAGE="http://tiny-tools.sourceforge.net"
# SRC_URI="mirror://sourceforge/${PN}/emacs-${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	dev-lang/perl"

S="${WORKDIR}/tiny-tools"

#src_unpack() 
#{
#	unpack ${A}
#	cd ${S}
##	sed -e 's,/usr/local/lib/texmf/tex/,/usr/share/texmf/tex/,g' tex.el >tex.el.new && \
##		mv tex.el.new tex.el || die
#}

src_compile() 
{
  cd ${S}/bin
  perl makefile.pl  \
    --binary emacs \
    --Gzip \
    --perlfix /usr/bin/perl \
    dos2unix \
    all
#  make || die
}

src_install() 
{

  dodir ${SITELISP}/tiny
  cd ${S}/lisp/tiny
  cp *.elc ${D}/${SITELISP}/tiny
  cp *.el ${D}/${SITELISP}/tiny
  cd ${D}/${SITELISP}/tiny
  for i in *.el; do
    gzip $i
  done
  rm -f load-path*
  gzip -d tinypath.el.gz

  dodir ${SITELISP}/other
  cd ${S}/lisp/other
  cp *.elc ${D}/${SITELISP}/other
  cp *.el ${D}/${SITELISP}/other
  cd ${D}/${SITELISP}/other
  for i in *.el; do
    gzip $i
  done
#  rm -f tiny-autoload*

  dodir ${SITELISPDOC}/${PN}/${PV}
  cd ${S}/doc
  cp -r * ${D}/${SITELISPDOC}/${PN}/${PV}

#  exeinto /usr/bin
#  cd ${S}/bin
#  doexe emacs-util.pl
  
	# this is insane...
#	pushd ${D}/${SITELISP}
#	sed -e "s,${D}/,,g" tex-site.el >tex-site.el.new && \
#		mv tex-site.el.new tex-site.el || die
#	popd
#	pushd doc
#	dodir /usr/share/info
#	make infodir=${D}/usr/share/info install || die
#	popd
# 	elisp-site-file-install ${FILESDIR}/50auctex-gentoo.el
# 	dodoc ChangeLog CHANGES COPYING INSTALLATION PROBLEMS README NEWS INSTALL
}

#pkg_postinst() {
#	elisp-site-regen
#}

#pkg_postrm() {
#	elisp-site-regen
##}
