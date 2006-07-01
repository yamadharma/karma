# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Matthew Kennedy <mkennedy@gentoo.org>
# $Header: /home/cvsroot/gentoo-x86/eclass/elisp.eclass,v 1.1 2002/10/29 04:40:18 mkennedy Exp $

# This eclass sets the site-lisp directory for emacs-related packages.

ECLASS=kbd
INHERITED="$INHERITED $ECLASS"

KBD_TRANSDIR=/usr/share/consoletrans
KBD_KEYMAPSDIR_ROOT=/usr/share/keymaps

kbd-trans-install ()
{
  if [ ! -d "${D}/${KBD_TRANSDIR}" ] ; then
	install -d "${D}/${KBD_TRANSDIR}"
  fi

  for x in "$@" ; do
    if [ -e "${x}" ] ; then
      install -m644 "${x}" "${D}/${KBD_TRANSDIR}"
    else
      echo "${0}: ${x} does not exist"
    fi
  done
}

