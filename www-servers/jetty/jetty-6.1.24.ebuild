# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2

DESCRIPTION="Jetty Web Server; Java Servlet container"

SLOT="6"
SRC_URI="http://dist.codehaus.org/jetty/jetty-${PV}/jetty-${PV}-src.zip"
HOMEPAGE="http://jetty.codehaus.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"

IUSE="ant-tasks client ldap ssl stats"

CDEPEND="dev-java/tomcat-servlet-api:2.5"

# The main pom only requires jre 1.4, but som of the sub-poms use 1.5
DEPEND="${CDEPEND}
	|| (
	   >=dev-java/maven-2.0.6
	   >=dev-java/maven-bin-2.0.6
	)
	>=virtual/jre-1.5"
RDEPEND="${CDEPEND}
	ant-tasks? ( dev-java/ant )
	>=dev-java/slf4j-api-1.3.1
	>=dev-java/sun-javamail-1.4
	>=dev-java/jta-1.0.1
	>=java-virtuals/jaf-1.1
	>=virtual/jdk-1.5"

SLOT="6"

src_prepare() {
    cd "${S}"
    # Remove the test packages so they aren't run by maven
    rm -rf {extras,modules,contrib}/*/src/test/ \
       extras/setuid/modules/native/src/test contrib/*/*/src/test \
       webapps \
       etc/* \
       bin/*

    # minify the poms to reduce testing and compilation
    sed -i -e '/<module>modules\/jsp-.*2\.0<\/module>/d
    	/<module>modules\/.*maven.*<\/module>/d
    	/<module>extras\/win32service<\/module>/d
     	/<module>extras\/spring<\/module>/d
    	/<module>contrib\/cometd<\/module>/d
    	/<module>contrib\/sweeper<\/module>/d
    	/<module>examples\/.*<\/module>/d
    	' ${S}/pom.xml || die "unable to edit pom.xml"

    # remove scope on known dependencies so we can replace them with the system libs
    #find ${S} -name pom.xml -exec sed -i -e '/<dependencies>/,/<\/dependencies>/{
    #	 /<dependency>/,/<\/dependency>/{
    #		/<artifactId>junit</,/<\/scope>/s/<scope>.*<\/scope>//
    #	 	/<artifactId>slf4j-api</,/<\/scope>/s/<scope>.*<\/scope>//
    #	 	/<artifactId>ant</,/<\/scope>/s/<scope>.*<\/scope>//
    #	 	/<artifactId>.*jta</,/<\/scope>/s/<scope>.*<\/scope>//
    #	 	/<artifactId>mail</,/<\/scope>/s/<scope>.*<\/scope>//
    #	 }
    #	 }' '{}' \; || die "unable to edit pom dependencies"

    # use system libraries
    #find ${S} -name pom.xml -exec sed -i -e '/<dependencies>/,/<\/dependencies>/{
    #	 /<artifactId>junit<\/artifactId>/a<scope>test<\/scope>
    #	 /<artifactId>slf4j-api<\/artifactId>/a<scope>system</scope><systemPath>/usr/share/slf4j-api/lib/slf4j-api.jar</systemPath>
    #	 /<artifactId>ant<\/artifactId>/a<scope>system</scope><systemPath>/usr/share/ant/lib/ant.jar</systemPath>
    #	 /<artifactId>.*jta<\/artifactId>/a<scope>system</scope><systemPath>/usr/share/jta/lib/jta.jar</systemPath>
    #	 /<artifactId>mail<\/artifactId>/a<scope>system</scope><systemPath>/usr/share/sun-javamail/lib/mail.jar</systemPath>
    #	}' '{}' \; || die "unable to edit pom dependencies"

    if ! use ant-tasks ; then
       sed -i -e '/<module>contrib\/jetty-ant<\/module>/d' ${S}/pom.xml || die "unable to edit pom.xml"
    fi
    if ! use client ; then
       sed -i -e '/<module>extras\/client<\/module>/d' ${S}/pom.xml || die "unable to edit pom.xml"
    fi
    if ! use ldap ; then
       sed -i -e '/<module>contrib\/jetty-ldap-jaas<\/module>/d' ${S}/pom.xml || die "unable to edit pom.xml"
    fi
    if ! use ssl ; then
       sed -i -e '/<module>extras\/sslengine<\/module>/d' ${S}/pom.xml || die "unable to edit pom.xml"
    fi
    if ! use stats ; then
       sed -i -e '/<module>extras\/jetty-java5-stats<\/module>/d' ${S}/pom.xml || die "unable to edit pom.xml"
    fi
    # remove the test execution from terracotta build
    sed -i -e '45,53d' ${S}/contrib/terracotta/pom.xml || die "unable to edit terracotta pom.xml"
}

src_compile() {
    cd "${S}"
    mvn -ff -s ${FILESDIR}/settings.xml install -Dmaven.test.skip -DWORKDIR="${WORKDIR}" || die
}

src_install() {
    cd "${S}"
    rm -f etc/jetty-sslengine.xml
    java-pkg_dojar start.jar
    java-pkg_newjar lib/${PN}-${PV}.jar ${PN}.jar
    java-pkg_newjar lib/${PN}-util-${PV}.jar ${PN}-util.jar
    java-pkg_newjar lib/jre1.5/${PN}-util5-${PV}.jar ${PN}-util5.jar
    java-pkg_newjar lib/annotations/${PN}-annotations-${PV}.jar ${PN}-annotations.jar
    java-pkg_newjar lib/ext/${PN}-rewrite-handler-${PV}.jar ${PN}-rewrite-handler.jar
    java-pkg_newjar lib/ext/${PN}-html-${PV}.jar ${PN}-html.jar
    java-pkg_newjar lib/ext/${PN}-java5-threadpool-${PV}.jar ${PN}-java5-threadpool.jar
    java-pkg_newjar lib/ext/${PN}-ajp-${PV}.jar ${PN}-ajp.jar
    java-pkg_newjar lib/ext/${PN}-servlet-tester-${PV}.jar ${PN}-servlet-tester.jar
    java-pkg_newjar lib/ext/${PN}-setuid-${PV}.jar ${PN}-setuid.jar
    java-pkg_doso   lib/ext/libsetuid.so
    java-pkg_newjar lib/jsp-2.1/jsp-2.1-${PN}-${PV}.jar jsp-2.1-${PN}.jar
    java-pkg_newjar lib/management/${PN}-management-${PV}.jar ${PN}-management.jar
    java-pkg_newjar lib/naming/${PN}-naming-${PV}.jar ${PN}-naming.jar
    java-pkg_newjar lib/plus/${PN}-plus-${PV}.jar ${PN}-plus.jar
    java-pkg_newjar lib/terracotta/${PN}-terracotta-sessions-${PV}.jar ${PN}-terracotta-sessions.jar
    java-pkg_newjar lib/xbean/${PN}-xbean-${PV}.jar ${PN}-xbean.jar

    if use ant-tasks ; then
       java-pkg_dojar bin/jetty-tasks.xml
       java-pkg_newjar contrib/jetty-ant/target/${PN}-ant-${PV}.jar ${PN}-ant.jar
    fi

    use client && java-pkg_newjar lib/ext/${PN}-client-${PV}.jar ${PN}-client.jar
    if use ldap ; then
       java-pkg_newjar lib/ext/${PN}-ldap-jaas-${PV}.jar ${PN}-ldap-jaas.jar
    else
       rm -f etc/jetty-jaas.xml
    fi
    if use ssl ; then
       java-pkg_newjar lib/ext/${PN}-sslengine-${PV}.jar ${PN}-sslengine.jar
    else
       rm -f etc/jetty-ssl.xml
    fi
    if use stats ; then
       java-pkg_newjar lib/ext/${PN}-java5-stats-${PV}.jar ${PN}-java5-stats.jar
    else
       rm -f etc/jetty-stats.xml
    fi

    MY_JETTY=${PN}-${SLOT}

    dodir /etc/${MY_JETTY}
    insinto /etc/${MY_JETTY}
    doins etc/*

    dodir /etc/conf.d
    insinto /etc/conf.d
    newins ${FILESDIR}/conf.d/${PN} ${MY_JETTY}
    
    dodir /etc/init.d
    exeinto /etc/init.d
    newexe ${FILESDIR}/init.d/${PN} ${MY_JETTY}

    dodir /var/log/${MY_JETTY}

    JETTY_HOME=/var/lib/${MY_JETTY}
    dodir ${JETTY_HOME}/webapps
    dodir ${JETTY_HOME}/contexts
    dodir ${JETTY_HOME}/resources
    dosym ${JAVA_PKG_JARDEST} ${JETTY_HOME}/lib
    dosym ${JAVA_PKG_JARDEST}/start.jar ${JETTY_HOME}/
    dosym /etc/${MY_JETTY} ${JETTY_HOME}/etc
    dosym /var/log/${MY_JETTY} ${JETTY_HOME}/logs

    START_CONFIG=${D}/${JETTY_HOME}/start.config
    echo "\$(jetty.class.path).path                         always" > ${START_CONFIG}
    echo "\$(jetty.lib)/**                                  exists \$(jetty.lib)" >> ${START_CONFIG}
    echo "jetty.home=${JETTY_HOME}" >> ${START_CONFIG}
    echo "org.mortbay.xml.XmlConfiguration.class" >> ${START_CONFIG}
    echo "\$(start.class).class" >> ${START_CONFIG}
    echo "\$(jetty.home)/etc/jetty.xml" >> ${START_CONFIG}
    echo "\$(jetty.home)/lib/*" >> ${START_CONFIG}
    echo "/usr/share/sun-javamail/lib/*" >> ${START_CONFIG}
    echo "/usr/share/ant/lib/*" >> ${START_CONFIG}
    echo "/usr/share/slf4j-api/lib/*" >> ${START_CONFIG}
    echo "/usr/share/jta/lib/*" >> ${START_CONFIG}
    echo "/usr/share/tomcat-servlet-api-2.5/lib/*" >> ${START_CONFIG}
    #echo "" >> ${START_CONFIG}
    #echo "" >> ${START_CONFIG}
    echo "" >> ${START_CONFIG}
    echo "\$(jetty.home)/resources/" >> ${START_CONFIG}
}

pkg_preinst () {
    enewuser jetty
    fowners jetty:jetty /var/log/${MY_JETTY}
    fperms g+w /var/log/${MY_JETTY}
}
