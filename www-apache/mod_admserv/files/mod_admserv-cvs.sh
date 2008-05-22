#!/bin/bash

DATE=`date +%Y%m%d`
CVSTAG=HEAD
VERSION=1.0
PKGNAME=mod_admserv
export CVSROOT=:pserver:anonymous@cvs.fedora.redhat.com:/cvs/dirsec

cvs -d "$CVSROOT" -z3 export -r$CVSTAG -d $PKGNAME-$VERSION-pre$DATE mod_admserv

tar -cjf $PKGNAME-$VERSION-pre$DATE.tar.bz2 $PKGNAME-$VERSION-pre$DATE

rm -rf $PKGNAME-$VERSION-pre$DATE
