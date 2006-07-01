# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils 

SUB_PV=-1

DESCRIPTION="Bean Script Framework"
HOMEPAGE="http://www.opennms.org"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}${SUB_PV}.tar.gz"
LICENSE="Apache-1.1"
SLOT="2.3"
KEYWORDS="x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4.1
	>=dev-java/ant-1.5.4
	>=dev-db/postgresql-7.2
	net-analyzer/rrdtool
	=www-servers/tomcat-4*"

RDEPEND="${DEPEND}
	dev-perl/DBD-Pg
	net-mail/metamail
	net-misc/curl"

S=${WORKDIR}/${P}${SUB_PV}/source


OPENNMS_HOME="/opt/${PN}"

src_compile () 
{
    local myconf=""
    
    chmod +x build.sh
    
    source /etc/conf.d/tomcat4
    
    echo "build.postgresql.include.dir=/usr/include/postgresql/server" >> build.properties
    echo "install.dir=${OPENNMS_HOME}" >> build.properties
    echo "install.init.dir=/etc/init.d" >> build.properties
#    echo "install.servlet.dir=${CATALINA_HOME}/webapps/opennms" >> build.properties
    echo "install.logs.dir=/var/log/opennms" >> build.properties
    echo "install.etc.dir=/etc/opennms" >> build.properties
    echo "install.share.dir=/var/lib/opennms" >> build.properties
    echo "install.webapps.dir=${OPENNMS_HOME}/webapps" >> build.properties
#    echo "install.postgresql.dir=/usr/lib/postgresql/opennms" >> build.properties
    echo "install.pid.file=/var/run/opennms.pid" >> build.properties
    echo "install.prefix=${D}" >> build.properties

    ./build.sh \
	sources

    ./build.sh \
	 ${myconf} \
	all

    if ( use doc )
	then
	./build.sh \
	    ${myconf} \
	    docs
    fi
}

src_install () 
{
    ./build.sh install
    
    rm -rf ${D}/etc/init.d
    
    dodir /etc/opennms
    mv ${D}/opt/opennms/etc/* ${D}/etc/opennms
    rm -r ${D}/opt/opennms/etc
    dosym /etc/opennms /opt/opennms/etc
    
    dodoc CHANGELOG README* *.launch

    if ( use doc )
	then
	cp -a ${S}/work/docs/* ${D}/usr/share/doc/${PF}
    fi
    
    keepdir /var/log/opennms
    
    newinitd ${FILESDIR}/opennms.rc opennms
}

pkg_preinst () 
{
	source /etc/conf.d/tomcat4

	chgrp -R tomcat ${D}/etc/opennms
	chmod -R g+w ${D}/etc/opennms
	chgrp -R tomcat ${D}/var/log/opennms
	chmod -R g+w ${D}/var/log/opennms
	chown -R tomcat:tomcat ${D}/var/lib/opennms
	chown -R tomcat:tomcat ${D}${OPENNMS_HOME}/webapps
}

pkg_config ()
{
    source /etc/conf.d/tomcat4
    
    # Java config
    ${OPENNMS_HOME}/bin/runjava -s
    
    # Database install
    /etc/init.d/postgresql start
    java -jar /opt/opennms/lib/opennms_install.jar -disU
    
    # Webapps install
    ${OPENNMS_HOME}/bin/install -y -w ${CATALINA_HOME}/webapps -W ${CATALINA_HOME}/server/lib
    
    touch /etc/opennms/configured
}

