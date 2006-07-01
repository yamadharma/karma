# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/net-mail/amavis/amavis-0.2.1-r2.ebuild,v 1.7 2002/08/14 12:05:25 murphy Exp $

# inherit perl-module

P_R=9 # Subversion
DESCRIPTION="MailScanner is a freely distributable E-Mail gateway virus scanner and spam detector."
SRC_URI="http://www.sng.ecs.soton.ac.uk/mailscanner/files/4/tar/${P}-${P_R}.tar.gz"
HOMEPAGE="http://www.mailscanner.info/"

S=${WORKDIR}/${P}-${P_R}

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 sparc sparc64"

#DEPEND="dev-perl/File-MMagic
#	dev-perl/Compress-Zlib
#	dev-perl/Archive-Tar
#	dev-perl/Archive-Zip
#	dev-perl/Config-IniFiles
#	dev-perl/Convert-TNEF
#	>=dev-perl/MIME-tools-5.411
#	app-arch/unrar
#	app-arch/unarj
#	app-arch/zip
#	app-arch/zoo
#	app-arch/arc
#	app-arch/lha"

DEPEND=">=dev-perl/MIME-tools-5.411
	>=net-mail/tnef-1.1.1"

RDEPEND=${DEPEND}

#src_unpack() 
#{
#  local myconf
#  local mylibs
#  unpack ${A}
#  cd ${S}
#  sed -e "s:.*amavis-milter.*$::g" Makefile.PL > Makefile.PL.tmp
#  mv -f Makefile.PL.tmp Makefile.PL
#}

src_install() 
{

#  perl-module_src_install

  cd ${S}
  for i in etc/MailScanner.conf etc/virus.scanners.conf bin/MailScanner bin/Sophos.install bin/update_virus_scanners 
  do
  sed \
    -e "s+/opt/MailScanner/etc/mailscanner.conf+/etc/MailScanner/MailScanner.conf+" \
    -e "s./opt/MailScanner/var./var/run." \
    -e "s./opt/MailScanner/bin/tnef./usr/bin/tnef." \
    -e "s./opt/MailScanner/etc/reports./etc/MailScanner/reports." \
    -e "s./opt/MailScanner/etc/rules./etc/MailScanner/rules." \
    -e "s./opt/MailScanner/etc./etc/MailScanner." \
    -e "s./opt/MailScanner/lib./usr/lib/MailScanner." \
    -e "s./opt/MailScanner/bin./usr/lib/MailScanner." \
    -e "s./usr/lib/sendmail./usr/sbin/sendmail." \
    $i > $i.tmp
    mv $i.tmp $i
  done
  
  

  cd ${S}
  dosbin bin/df2mbox
  dosbin bin/MailScanner
  newsbin bin/check_mailscanner.linux	check_mailscanner
  newsbin bin/Sophos.install.linux	Sophos.install
  dosbin bin/update_virus_scanners

#install MailScanner.opts.rh    ${RPM_BUILD_ROOT}/etc/sysconfig/MailScanner
#install MailScanner.init.rh    ${RPM_BUILD_ROOT}%{_sysconfdir}/rc.d/init.d/MailScanner
#install check_MailScanner.cron ${RPM_BUILD_ROOT}/etc/cron.hourly/check_MailScanner
#install update_virus_scanners.cron ${RPM_BUILD_ROOT}/etc/cron.hourly/update_virus_scanners
#install clean.quarantine.cron  ${RPM_BUILD_ROOT}/etc/cron.daily/clean.quarantine
#install doc/MailScanner.8.gz   ${RPM_BUILD_ROOT}/usr/share/man/man8/

  doman docs/man/MailScanner.8
  doman docs/man/MailScanner.conf.5

#  cd ${S}
#  while read f 
#  do
#    install etc/$f ${D}/etc/MailScanner/
#  done << EOF
#  filename.rules.conf
#  MailScanner.conf
#  spam.assassin.prefs.conf
#  spam.lists.conf
#  virus.scanners.conf
#  EOF
  
  insinto /etc/MailScanner
  doins ${S}/etc/*.conf
  cp -R ${S}/etc/reports ${D}/etc/MailScanner/
  
  cd ${S}
  insinto /usr/lib/MailScanner
  insopts -m755
  doins lib/*wrapper
  doins lib/*autoupdate

  insinto /usr/lib/MailScanner  
  insopts -m644
  doins lib/MailScanner.pm
  
  cp -R ${S}/lib/MailScanner ${D}/usr/lib/MailScanner
  rm ${D}/usr/lib/MailScanner/MailScanner/.#*
  
  dosed "s:/usr/local/f-prot:/opt/f-prot:g" /usr/lib/MailScanner/f-prot-autoupdate
  dosed "s:/usr/local/f-prot:/opt/f-prot:g" /usr/lib/MailScanner/f-prot-wrapper
  
}

#pkg_postinst()
#{
#
#}
