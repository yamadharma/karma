# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dmitry S. Kulyabov <dharma@mx.pfu.edu.ru>
# $Header: $

# This eclass sets the site-lisp directory for emacs-related packages.

ECLASS=doc-tex
INHERITED="$INHERITED $ECLASS"

IUSE="doc"

EXPORT_FUNCTIONS pkg_setup

DEPEND="${DEPEND}
	doc? app-text/tetex"
#		dev-tex/latex2html
#		app-text/texi2html )"
		
export MT_FEATURES=varfonts
export VARTEXFONTS=${T}/var/cache/fonts

doc-tex_pkg_setup ()
{
    mkdir -p ${T}/var/cache/fonts
    chmod -R a+w ${T}/var/cache/fonts
}

# Local Variables:
# mode: sh
# End:
