# -*- mode: sh -*-
# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-fs/samba/samba-2.2.7a.ebuild,v 1.1 2002/12/16 18:19:18 woodchip Exp $

ECVS_SERVER="pserver.samba.org:/cvsroot"
ECVS_MODULE="samba"
ECVS_BRANCH="SAMBA_3_0"
ECVS_USER="cvs"
ECVS_CVS_OPTIONS="-dP"

inherit cvs

IUSE="pam acl cups ldap ssl tcpd oav"

VSCAN_VER=0.2.5e
VSCAN_MODS="fprot mks openantivirus" #kaspersky sophos symantec trend
#need libs/headers/extra support for these ones^; please test!

DESCRIPTION="SAMBA is a suite of SMB and CIFS client/server programs for UNIX"
HOMEPAGE="http://www.samba.org"

#MY_P="${P/_/}"
MY_P=samba
#S=${WORKDIR}/${PN}-3.0alpha21
S=${WORKDIR}/${MY_P}
#SRC_URI="oav? mirror://sourceforge/openantivirus/${PN}-vscan-${VSCAN_VER}.tar.gz
#	http://us3.samba.org/samba/ftp/${P}.tar.bz2"
#SRC_URI="http://us3.samba.org/samba/ftp/alpha/${MY_P}.tar.bz2"
SRC_URI=""
DEPEND=">=sys-libs/glibc-2.1.2
	pam? >=sys-libs/pam-0.72
	acl? sys-apps/acl
	cups? net-print/cups
	ldap? =net-nds/openldap-2*
	ssl? >=dev-libs/openssl-0.9.6
	tcpd? >=sys-apps/tcp-wrappers-7.6
	oav? >=dev-libs/popt-1.6.3
	app-crypt/krb5
	>=dev-libs/libxml2-2*"

KEYWORDS="x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="3"

#src_unpack() {
#	local i
#	unpack ${A} || die
#	cd ${S} || die

#	patch -p0 <${FILESDIR}/samba-2.2.2-smbmount.diff || die
#	patch -p1 <${FILESDIR}/samba-2.2.5-gp-reloc-fix.patch || die
#	cd ${S}/source/client
#	patch -p0 <${FILESDIR}/samba-2.2.6-smbumount_lazy.patch || die

#	if use portldap; then
#		cd ${S}/source
#		patch -p0 <$FILESDIR/nonroot-bind.diff || die
#	fi

#	if use ldap; then
#		cd ${S}
#		patch -p0 <${FILESDIR}/samba-2.2.6-libresolv.patch || die
#	fi

	# fix kerberos include file collision..
#	cd ${S}/source/include
#	mv profile.h smbprofile.h
#	sed -e "s:profile\.h:smbprofile.h:" includes.h > includes.h.new
#	mv includes.h.new includes.h

	# for clean docs packaging sake, make a copy..
#	cp -a ${S}/examples ${S}/examples.bin
#	if use oav; then
#		# prep source for selected vscan plugin modules..
#		for i in ${VSCAN_MODS}
#		do
#			cp -a ${WORKDIR}/${PN}-vscan-${VSCAN_VER}/$i \
#				${S}/examples.bin/VFS
#		done
#	fi
#
#	cd ${S}/source
#	autoconf || die
#}

src_compile() 
{
  cd ${S}/source
  autoheader
#  WANT_AUTOCONF_2_5=1 libtoolize --copy --force --automake
#  WANT_AUTOCONF_2_5=1 aclocal
  WANT_AUTOCONF_2_5=1 autoconf -f
  
  
	local i myconf
#	myconf="`use_enable ldap cups`"
	use acl && myconf="${myconf} --with-acl-support" ||  myconf="${myconf} --without-acl-support"
	use ssl && myconf="${myconf} --with-ssl" || myconf="${myconf} --without-ssl"
	use pam && myconf="${myconf} --with-pam --with-pam_smbpass" || \
		myconf="${myconf} --without-pam --without-pam_smbpass"
  use cups && myconf="${myconf} --enable-cups" || myconf="${myconf} --disable-cups"
#  myconf="${myconf} `use_enable cups`"
#  myconf="${myconf} `use_enable ldap cups`"
  use ldap && myconf="${myconf} --with-ldap" || myconf="${myconf} --without-ldap"

	cd ${S}/source
	./configure \
		--prefix=/usr \
		--bindir=/usr/sbin \
		--libdir=/etc/samba \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc/samba \
		--localstatedir=/var/log \
		--with-configdir=/etc/samba \
		--with-mandir=/usr/share/man \
		--with-piddir=/var/run/samba \
		--with-swatdir=/usr/share/samba/swat \
		--with-sambabook=/usr/share/swat/using_samba \
		--with-lockdir=/var/cache/samba \
		--with-privatedir=/etc/samba/private \
		--with-codepagedir=/var/lib/samba/codepages \
		--with-libiconv \
		--with-sendfile-support \
		--without-sambabook \
		--with-automount \
		--without-spinlocks \
		--with-libsmbclient \
		--with-smbwrapper \
		--with-netatalk \
		--with-smbmount \
		--with-profile \
		--with-syslog \
		--with-msdfs \
		--with-utmp \
		--with-vfs \
		--with-ads \
		--with-fhs \
		--with-krb5 \
		--with-winbind-ldap-hack \
		--with-python \
		--host=${CHOST} ${myconf} || die "bad ./configure"
		#--with-quotas \

  # compile samba..
  emake proto
  emake all nsswitch/libnss_wins.so modules || die "compile problem"
  emake debug2html
  emake bin/smbspool
  
  if use pam; then
    make pam_smbpass || die "pam_smbpass compile problem"
  fi
  
  # Remove some permission bits to avoid to many dependencies
  find examples docs -type f | xargs -r chmod -x


# compile the bundled vfs modules..
#	cd ${S}/examples.bin/VFS
#	./configure \
#		--prefix=/usr \
#		--mandir=/usr/share/man || die "bad ./configure"
#	make || die "VFS modules compile problem"

#   # compile mkntpasswd in examples/LDAP/ for smbldaptools..
#   if use ldap; 
#   then
#     cd ${S}/examples.bin/LDAP/smbldap-tools/mkntpwd
#     VISUAL="" make || die "mkntpwd compile problem"
#   fi

	# Compile the selected antivirus vfs plugins..
#	if use oav; then
#		for i in ${VSCAN_MODS}
#		do
#			cd ${S}/examples.bin/VFS/$i && make
#			assert "problem building $i vscan module"
#		done
#	fi
}

src_install() {
	local i

	# we may as well do this all manually since it was starting
	# to get out of control and samba _does_ have some rather
	# silly installation quirks ;)  much of this was adapted
	# from mandrake's .spec file..
	#
	# // woodchip - 5 May 2002

  # Install standard binary files
  for i in nmblookup smbclient smbpasswd smbstatus testparm testprns \
	rpcclient smbspool smbcacls smbcontrol wbinfo smbmnt net smbgroupedit \
	smbcacls pdbedit tdbbackup smbtree smbsh
  do
    exeinto /usr/bin
    doexe source/bin/${i}
  done

  # some utility scripts..
  for i in mksmbpasswd.sh smbtar findsmb \
    convert_smbpasswd
  do
    exeinto /usr/bin
    doexe source/script/${i}
  done

  # Install secure binary files
  for i in smbd nmbd swat smbmount smbumount debug2html winbindd wrepld
  do
    exeinto /usr/bin
    doexe source/bin/${i}  
  done

  # we need a symlink for mount to recognise the smb and smbfs filesystem types
  dodir /sbin
  dosym /usr/bin/smbmount /sbin/mount.smbfs
  dosym /usr/bin/smbmount /sbin/mount.smb

  # make users lives easier..
  fperms 4755 /usr/bin/smbumount

  # This allows us to get away without duplicating code that 
  #  sombody else can maintain for us.  
  cd ${S}/source
  make BASEDIR=${D}/usr \
	CONFIGDIR=${D}/etc/samba \
	LIBDIR=${D}/usr/lib/samba \
	VARDIR=${D}/var \
	SBINDIR=${D}/usr/sbin \
	BINDIR=${D}/usr/bin \
	MANDIR=${D}/usr/share/man \
	SWATDIR=${D}/usr/share/swat \
	SAMBABOOK=${D}/usr/share/swat/using_samba \
	installman installswat installdat installmodules

# {{{ Install libraries

  # Install the nsswitch wins library
  cd ${S}
  exeinto /lib
  newexe source/nsswitch/libnss_wins.so libnss_wins.so.2
  # Make link for wins resolver
  dosym /lib/libnss_wins.so.2 /lib/libnss_wins.so

  # Install winbind shared libraries
  exeinto /lib
  newexe source/nsswitch/libnss_winbind.so libnss_winbind.so.2
  dosym /lib/libnss_winbind.so.2 /lib/libnss_winbind.so
  exeinto /lib/security
  doexe source/nsswitch/pam_winbind.so

  # Install pam_smbpass.so
  exeinto /lib/security
  doexe source/bin/pam_smbpass.so
  
  # libsmbclient
  into /
  dolib.so source/bin/libsmbclient.so
  into /usr
  dolib.a source/bin/libsmbclient.a
  insinto /usr/include/
  doins source/include/libsmbclient.h

  into /
  dolib.so source/bin/smbwrapper.so
  # make a symlink on /usr/lib/smbwrapper.so in /usr/sbin
  # to fix smbsh problem.  #6936
  dosym /usr/lib/smbwrapper.so /usr/sbin/smbwrapper.so

  into /usr
  dolib.so source/bin/pdb_*

  # vfs modules
  exeinto /usr/lib/samba/vfs
  doexe source/bin/vfs_*

  doexe examples.bin/VFS/audit.so
  doexe examples.bin/VFS/block/block.so
  doexe examples.bin/VFS/recycle/recycle.so
  use oav && doexe examples.bin/VFS/*/vscan-*.so

# }}}


#	# and this handy one..
#	doexe packaging/Mandrake/findsmb


	# make users lives easier..
	fperms 4755 /usr/sbin/smbmnt


	# man pages..
	doman docs/manpages/*


	# codepage source files
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251
	do
		insinto /var/lib/samba/codepages/src
		doins source/codepages/codepage_def.${i}
	done
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251 \
		ISO8859-1 ISO8859-2 ISO8859-5 ISO8859-7 \
		ISO8859-9 ISO8859-13 ISO8859-15 KOI8-R KOI8-U
	do
		insinto /var/lib/samba/codepages/src
		doins source/codepages/CP${i}.TXT
	done


	# build codepage load files..
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251
	do
		${D}/usr/bin/make_smbcodepage c ${i} \
			${D}/var/lib/samba/codepages/src/codepage_def.${i} \
			${D}/var/lib/samba/codepages/codepage.${i}
	done


	# build unicode load files..
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251 \
		ISO8859-1 ISO8859-2 ISO8859-5 ISO8859-7 \
		ISO8859-9 ISO8859-13 ISO8859-15 KOI8-R KOI8-U
	do
		${D}/usr/bin/make_unicodemap ${i} \
			${D}/var/lib/samba/codepages/src/CP${i}.TXT \
			${D}/var/lib/samba/codepages/unicode_map.${i}
	done
	rm -rf ${D}/var/lib/samba/codepages/src


	# install SWAT helper files..
	for i in swat/help/*.html docs/htmldocs/*.html
	do
		insinto /usr/share/swat/help
		doins ${i}
	done
	for i in swat/images/*.gif
	do
		insinto /usr/share/swat/images
		doins ${i}
	done
	for i in swat/include/*.html
	do
		insinto /usr/share/swat/include
		doins ${i}
	done


#  # install the O'Reilly "Using Samba" book..
#  for i in docs/htmldocs/using_samba/*.html
#  do
#    insinto /usr/share/swat/using_samba
#    doins ${i}
#  done
#  for i in docs/htmldocs/using_samba/gifs/*.gif
#  do
#    insinto /usr/share/swat/using_samba/gifs
#    doins ${i}
#  done
#  for i in docs/htmldocs/using_samba/figs/*.gif
#  do
#    insinto /usr/share/swat/using_samba/figs
#    doins ${i}
#  done


  # install the utilities from LDAP/smbldap-tools
  if use ldap; then
		exeinto /usr/share/samba/smbldap-tools
		doexe examples/LDAP/smbldap-tools/*.pl
		doexe examples/LDAP/smbldap-tools/smbldap_tools.pm
		doexe examples/LDAP/{import,export}_smbpasswd.pl
		chmod 0700 ${D}/usr/share/samba/smbldap-tools/{import,export}_smbpasswd.pl
		exeinto /usr/sbin
		doexe examples.bin/LDAP/smbldap-tools/mkntpwd/mkntpwd
		#dodir /usr/lib/perl5/site_perl/5.6.1
    eval `perl '-V:installarchlib'`
    dodir ${installarchlib}
    dosym /etc/samba/smbldap_conf.pm ${installarchlib}
    dosym /usr/share/samba/smbldap-tools/smbldap_tools.pm ${installarchlib}
  fi
	
# {{{ Install docs

  cd ${S}
  dodoc COPYING Manifest README Roadmap WHATSNEW.txt
  
  cp -R docs ${D}/usr/share/doc/${PF}
  cp -R examples ${D}/usr/share/doc/${PF}

  docinto misc/msdfs
  dodoc source/msdfs/README

  docinto misc/nsswitch
  dodoc source/nsswitch/README

  docinto misc/pam_smbpass
  cd ${S}/source/pam_smbpass
  dodoc README CHANGELOG INSTALL TODO
  cp -R examples ${D}/usr/share/doc/${PF}/misc/pam_smbpass
  cd ${S}

  docinto misc/pythons
  cd ${S}/source/pythons
  dodoc README
  cp -R examples ${D}/usr/share/doc/${PF}/misc/pythons
  cd ${S}

  docinto misc/smbwrapper
  cd ${S}/source/smbwrapper
  dodoc README PORTING
  cd ${S}

  docinto misc/tdb
  dodoc source/tdb/README

# }}}

#	# we don't want two copies of the book or manpages
#	rm -rf docs/htmldocs/using_samba docs/manpages
#	# attempt to install all the docs as easily as possible :/
#	dodoc COPYING Manifest README Roadmap WHATSNEW.txt
#	docinto full_docs
#	cp -a docs/* ${D}/usr/share/doc/${PF}/full_docs
#	docinto examples
#	cp -a examples/* ${D}/usr/share/doc/${PF}/examples
#	prepalldocs
#	# keep this next line *after* prepalldocs!
#	dosym /usr/share/swat/using_samba /usr/share/doc/${PF}/using_samba
#	# and we should unzip the html docs..
#	gunzip ${D}/usr/share/doc/${PF}/full_docs/faq/*
#	gunzip ${D}/usr/share/doc/${PF}/full_docs/htmldocs/*
	
  if use oav; then
		docinto vscan-modules
		cd ${WORKDIR}/${PN}-vscan-${VSCAN_VER}
		dodoc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS README TODO
		for i in ${VSCAN_MODS}
		do
			docinto vscan-modules/$i
			dodoc $i/INSTALL
		done
	fi
	cd ${S} # hyaah; thems a lotta docs!




	# make the smb backend symlink for cups printing support..
	if use cups; then
		dodir /usr/lib/cups/backend
		dosym /usr/bin/smbspool /usr/lib/cups/backend/smb
	fi


# {{{ Install config files

  insinto /etc
  doins ${FILESDIR}/nsswitch.conf-winbind
  doins ${FILESDIR}/nsswitch.conf-wins

  insinto /etc/samba
  doins ${FILESDIR}/smbusers
  doins ${FILESDIR}/smb.conf.example
  doins ${FILESDIR}/lmhosts
  doins ${FILESDIR}/recycle.conf
  if use ldap; then
    doins ${FILESDIR}/smbldap_conf.pm
    doins ${FILESDIR}/samba-slapd-include.conf
  fi

  insinto /etc/pam.d
  newins ${FILESDIR}/samba.pam samba
  doins ${FILESDIR}/system-auth-winbind

  exeinto /etc/init.d
  newexe ${FILESDIR}/samba-init samba
  newexe ${FILESDIR}/winbind-init winbind

  insinto /etc/xinetd.d
  newins ${FILESDIR}/swat.xinetd swat

# }}}
}

pkg_postinst() 
{
  # touch /etc/samba/smb.conf so that people installing samba just
  # to mount smb shares don't get annoying warnings all the time..
  if [ ! -e ${ROOT}/etc/samba/smb.conf ] ; 
  then
    touch ${ROOT}/etc/samba/smb.conf
  fi

  # empty dirs..
  install -m0700 -o root -g root -d ${ROOT}/etc/samba/private
  install -m1777 -o root -g root -d ${ROOT}/var/spool/samba
  install -m0755 -o root -g root -d ${ROOT}/var/log/samba
  install -m0755 -o root -g root -d ${ROOT}/var/run/samba
  install -m0755 -o root -g root -d ${ROOT}/var/cache/samba
  install -m0755 -o root -g root -d ${ROOT}/var/lib/samba/{netlogon,profiles}
  install -m0755 -o root -g root -d \
  ${ROOT}/var/lib/samba/printers/{W32X86,WIN40,W32ALPHA,W32MIPS,W32PPC}
}
