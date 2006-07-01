# -*- mode: sh -*-
# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils patch extrafiles

IUSE="kerberos mysql xml acl cups ldap pam readline python"
IUSE="${IUSE} oav"

DESCRIPTION="SAMBA is a suite of SMB and CIFS client/server programs for UNIX"
HOMEPAGE="http://www.samba.org/
	http://www.openantivirus.org/projects.php"

VSCAN_VER=0.3.4
VSCAN_MODS=${VSCAN_MODS:=fprot mks openantivirus sophos trend icap clamav} #kapersky
# To build the "kapersky" plugin, the kapersky lib must be installed.


MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

SRC_URI="mirror://samba/${PN}-${PV/_/}.tar.gz
	oav?	mirror://sourceforge/openantivirus/${PN}-vscan-${VSCAN_VER}.tar.bz2"

#SRC_URI="mirror://samba/${PN}-${PV/_/}.tar.bz2
#	oav?	mirror://sourceforge/openantivirus/${PN}-vscan-${VSCAN_VER}.tar.bz2"

	
DEPEND="sys-devel/autoconf 
	dev-libs/popt
	sys-apps/quota
	readline? sys-libs/readline
	kerberos? virtual/krb5
        >=dev-libs/openssl-0.9.6
	mysql? 	( dev-db/mysql sys-libs/zlib )
	xml? 	( dev-libs/libxml2 sys-libs/zlib )
	acl? 	sys-apps/acl
	cups? 	net-print/cups
	ldap? 	=net-nds/openldap-2*
	pam? 	sys-libs/pam
	python? dev-lang/python"
	

KEYWORDS="x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="0"
PROVIDE="virtual/samba"

src_unpack () 
{
    local i
    
    patch_src_unpack ${A} || die
    cd ${S} || die

    # Clean up CVS
    #find . -name .cvsignore | xargs rm -f
    #find . -name CVS | xargs rm -rf


    #Bug #36200; sys-kernel/linux-headers dependent
    sed -i -e 's:#define LINUX_QUOTAS_2:#define LINUX_QUOTAS_1:' \
    	-e 's:<linux/quota.h>:<sys/quota.h>:' \
	${S}/source/smbd/quotas.c


    # For clean docs packaging sake.
    rm -rf ${S}/examples.bin ; cp -a ${S}/examples ${S}/examples.bin

    # Prep samba-vscan source.
    if ( use oav )
	then
	cp -a ${WORKDIR}/${PN}-vscan-${VSCAN_VER} ${S}/examples.bin/VFS
	for i in ${VSCAN_MODS}
	  do
	  cd ${S}/examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/$i
	  sed -ie "s:^CFLAGS\(.*\):CFLAGS\1 -I/usr/include/heimdal:g" Makefile
        done
    fi

    cd ${S}/source
    ./autogen.sh || die
}

src_compile () 
{
    local i
    local myconf
    local mymods
    local cppflags
    
    cppflags="${CPPFLAGS}"
    
    #this is deprecated...
    #mymods="nisplussam"
    use xml && mymods="xml,${mymods}"
    use mysql && mymods="mysql,${mymods}"

    myconf="--with-expsam=${mymods}"

    myconf="${myconf} `use_with acl acl-support`"
    myconf="${myconf} `use_with readline`"	
    myconf="${myconf} `use_enable cups`"

    use pam \
	&& myconf="${myconf} --with-pam --with-pam_smbpass" \
	|| myconf="${myconf} --without-pam --without-pam_smbpass"

    use ldap \
	&& myconf="${myconf} --with-ldap" \
	|| myconf="${myconf} --without-ldap"

    #this is for old samba 2.x compat
    #myconf="${myconf} --with-ldapsam" 
    myconf="${myconf} --without-ldapsam"

    if use kerberos 
    then
	myconf="${myconf} --with-ads" 
	cppflags="${cppflags} -I/usr/include/heimdal"
	else
	myconf="${myconf} --without-ads"
    fi
    
    use python \
	&& myconf="${myconf} --with-python=yes" \
	|| myconf="${myconf} --with-python=no"

    einfo "\$myconf is: $myconf"

    
   #  myconf="${myconf} --with-afs"


   #default_{static,shared}_modules|source/configure
   #/usr/lib/samba/auth/.............      AUTH_MODULES
   #/usr/lib/samba/charset/                CHARSET_MODULES
   #/usr/lib/samba/pdb/..............      PDB_MODULES
   #/usr/lib/samba/rpc/                    RPC_MODULES
   #/usr/lib/samba/vfs/..............      VFS_MODULES|source/Makefile
   #/usr/lib/samba/lowcase.dat
   #/usr/lib/samba/upcase.dat
   #/usr/lib/samba/valid.dat

    cd source
    
    CPPFLAGS=${cppflags} \
    ./configure \
	--prefix=/usr \
	--sysconfdir=/etc/samba \
	--localstatedir=/var \
	--libdir=/usr/lib/samba \
	--with-mandir=/usr/share/man \
	--with-privatedir=/etc/samba/private \
	--with-lockdir=/var/cache/samba \
	--with-piddir=/var/run/samba \
	--with-swatdir=/usr/share/swat \
	--with-configdir=/etc/samba \
	--with-sambabook=/usr/share/swat/using_samba \
	--with-logfilebase=/var/log/samba \
	\
	--enable-static \
	--enable-shared \
	--with-manpages-langs=en \
	--without-spinlocks \
	--with-libsmbclient \
	--with-automount \
	--with-smbmount \
	--with-smbwrapper \
	--with-winbind \
	--with-libsmbclient \
	--with-utmp \
	--with-quotas \
	--with-syslog \
	--with-idmap \
	--with-fhs \
	--with-syslog \
	--host=${CHOST} ${myconf} || die

#		--with-configdir=/etc/samba 
#		--with-python=python2.2 


    # Compile main SAMBA pieces.
    make everything || die "SAMBA pieces"
    make rpctorture || ewarn "rpctorture didnt build"
    make bin/editreg

    # make_cifsvfs
    cd ${S}/source/client
    export CFLAGS="$CFLAGS -Wall -O -D_GNU_SOURCE -D_LARGEFILE64_SOURCE"
    gcc mount.cifs.c -o mount.cifs
    cp mount.cifs ../bin
    cd ${S}



    # Build selected samba-vscan plugins.
    if use oav; 
	then
	cd ${S}/examples.bin/VFS/${PN}-vscan-${VSCAN_VER}
	CPPFLAGS=${cppflags} \
	./configure || die "bad ${PN}-vscan-${VSCAN_VER} ./configure"
	make 
	for i in ${VSCAN_MODS}
	  do
	  cd ${S}/examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/$i
	  make USE_INCLMKSDLIB=1 #needed for the mks build
	  assert "problem building $i vscan module"
        done
    fi
}


src_install () 
{
    local i

    # This allows us to get away without duplicating code that 
    #  sombody else can maintain for us.  

    cd ${S}/source
    make DESTDIR=${D} install
    make DESTDIR=${D} installmodules
    make DESTDIR=${D} install_python
  
    #install: installbin installman installscripts installdat installswat 
    #install-everything: install installmodules

    # we may as well do this all manually since it was starting
    # to get out of control and samba _does_ have some rather
    # silly installation quirks ;)  much of this was adapted
    # from mandrake's .spec file..
    #
    # // woodchip - 5 May 2002

    cd ${S}
    # Install standard binary files
    for i in smbclient net smbspool testparm testprns smbstatus \
	smbcontrol smbtree tdbbackup nmblookup pdbedit \
	smbpasswd rpcclient smbcacls profiles ntlm_auth \
	smbcquotas smbmount smbmnt smbumount wbinfo \
	debug2html smbfilter talloctort smbsh editreg
      do
      exeinto /usr/bin
      doexe source/bin/${i}
    done

    # TORTURE_PROGS / Testing stuff, if they built they will come.
    for i in smbtorture msgtest masktest locktest locktest2 \
	nsstest vfstest rpctorture
      do
      if [ -x source/bin/${i} ]
	  then
	  exeinto /usr/bin
	  doexe source/bin/${i}
      fi
    done
    
    # some utility scripts..
    for i in smbtar findsmb \
	convert_smbpasswd mksmbpasswd.sh
      do
      exeinto /usr/bin
      doexe source/script/${i}
    done

    # Install secure binary files
    for i in smbd nmbd swat smbmount smbumount debug2html winbindd wrepld \
	mount.cifs
      do
      dosbin source/bin/${i} 
    done

    # we need a symlink for mount to recognise the smb and smbfs filesystem types
    dodir /sbin
    dosym /usr/sbin/smbmount /sbin/mount.smbfs
    dosym /usr/sbin/smbmount /sbin/mount.smb
    dosym /usr/sbin/mount.cifs /sbin/mount.cifs

    # Installing these two setuid-root allows users to (un)mount smbfs.
    fperms 4111 /usr/bin/smbumount
    fperms 4111 /usr/bin/smbmnt


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

    into /usr
    dolib.so source/bin/smbwrapper.so
    # make a symlink on /usr/lib/smbwrapper.so in /usr/sbin
    # to fix smbsh problem.  #6936
    dosym /usr/lib/smbwrapper.so /usr/sbin/smbwrapper.so

    into /usr
    dolib.so source/bin/pdb_*

# }}}
# {{{ Modules install

    # Python extensions.
    if use python; 
	then
	cd source
	python python/setup.py install --root=${D} || die
	cd ..
    fi

    # VFS plugin modules.
    exeinto /usr/lib/samba/vfs

    use oav && doexe examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/*/vscan-*.so

    for i in audit cap default_quota extd_audit fake_perms \
	netatalk readonly recycle
      do
      if [ -x source/bin/${i}.so ]
	  then
	  doexe source/bin/${i}.so
      fi
    done

    # vfs modules
    exeinto /usr/lib/samba/vfs
    doexe source/bin/vfs_*


    # Passdb modules.
    exeinto /usr/lib/samba/pdb
    use mysql && doexe source/bin/mysql.so
    use xml && doexe source/bin/xml.so

    # Install codepage data files.
    insinto /usr/lib/samba
    doins source/codepages/*.dat

# }}}

    cd ${S}
  # and this handy one..
#	doexe packaging/Mandrake/findsmb


  # make users lives easier..
    fperms 4755 /usr/sbin/smbmnt

    # Install codepage data files.
    insinto /usr/lib/samba
    doins source/codepages/*.dat

    # Install SWAT helper files.
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

# {{{ Share data
    
    dodir /usr/share/samba
    dosym /usr/lib/samba/lowcase.dat /usr/share/samba/lowcase.dat
    dosym /usr/lib/samba/upcase.dat /usr/share/samba/upcase.dat
    
# }}}
    # install the utilities from LDAP/smbldap-tools
    cd ${S}
    if use ldap; 
	then
	dodir /etc/openldap/schema
	cp examples/LDAP/samba.schema ${D}/etc/openldap/schema
    fi
	
# {{{ Install docs

    # man pages..
    doman docs/manpages/*

    # SAMBA has a lot of docs, so this just basically
    # installs them all!  We don't want two copies of
    # the book or manpages though, so:
    rm -rf docs/htmldocs/using_samba docs/manpages

    docinto full_docs
    cp -a docs/* ${D}/usr/share/doc/${PF}/full_docs
    docinto examples
    cp -a examples/* ${D}/usr/share/doc/${PF}/examples
    prepalldocs
    # and we should unzip the html docs..
    gunzip ${D}/usr/share/doc/${PF}/full_docs/faq/*
    gunzip ${D}/usr/share/doc/${PF}/full_docs/htmldocs/*
    if use oav; 
	then
	docinto ${PN}-vscan-${VSCAN_VER}
	cd ${WORKDIR}/${PN}-vscan-${VSCAN_VER}
	dodoc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS README TODO
	dodoc */*.conf
	cd ${S}
    fi
    chown -R root.root ${D}/usr/share/doc/${PF}
    
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
    cp -R samples ${D}/usr/share/doc/${PF}/misc/pam_smbpass
    cd ${S}

    docinto misc/python
    cd ${S}/source/python
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
    
    if use oav
	then
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
    if use cups 
	then
	dodir /usr/lib/cups/backend
	dosym /usr/bin/smbspool /usr/lib/cups/backend/smb
    fi


    extrafiles_install
    
# {{{ Install config files

    insinto /etc/samba
    doins ${FILESDIR}/smbusers
    doins ${FILESDIR}/smb.conf.example
    doins ${FILESDIR}/lmhosts
    doins ${FILESDIR}/recycle.conf
    if use ldap; 
	then
	doins ${FILESDIR}/smbldap_conf.pm
    fi

    dodir /usr/share/doc/${PF}/scripts/migration
    cp ${FILESDIR}/misc/version/${PV}/* ${D}/usr/share/doc/${PF}/scripts/migration

# }}}
# {{{
  
    

# }}}  
}

pkg_postinst () 
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

	ewarn ""
	ewarn "If you are upgrading from a Samba version prior to 3.0.2, and you"
	ewarn "use Samba's password database, you must run the following command:"
	ewarn ""
	ewarn "  pdbedit --force-initialized-passwords"
	ewarn ""
	if use ldap
	    then
		ewarn "If you are upgrading from prior to 3.0.2, and you are using LDAP"
		ewarn "for Samba authentication, you must check the sambaPwdLastSet"
		ewarn "attribute on all accounts, and ensure it is not 0."
		ewarn ""
	fi
  
    einfo
    einfo   "To migrate from samba version pre 3.0alpha24 use script"
    einfo   "/usr/share/doc/${PF}/scripts/migration/ldif2samAcount.awk"
    einfo
}


# Local Variables:
# mode: sh
# End:

