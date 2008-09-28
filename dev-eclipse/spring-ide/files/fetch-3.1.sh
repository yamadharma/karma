#!/bin/sh

REV="release-1-2-3"
NAME="spring-ide"
LOCATION="http://springide.org/repos/tags/"

#------------------------------------------------------------------------------#

TIME=$(date +%s)

mkdir "${NAME}-${TIME}"
cd "${NAME}-${TIME}"

svn export ${LOCATION}${REV}
mv ${REV}/* .
rmdir ${REV}

unset HIGHEST
unset VERSION

while read x; do

	VERSION=$(cat ${x} | xml2 | egrep "^/[^/]+/@version=" | sed -r "s:^/[^/]+/@version=(.+)$:\1:")
	[[ "${VERSION}" > "${HIGHEST}" ]] && HIGHEST="${VERSION}"

done <<EOF
$(find -name "plugin.xml" -o -name "feature.xml")
EOF

echo
echo "** This package contains the following JARs..."
find -iname "*.jar" -type f

cd ..
echo

if [[ -n "${HIGHEST}" ]]; then
	mv "${NAME}-${TIME}" "${NAME}-${HIGHEST}"
	echo "** This is (probably) version ${HIGHEST}."
	echo "** Downloaded to ${NAME}-${HIGHEST}."
else
	echo "** Unable to detect version."
	echo "** Downloaded to ${NAME}-${HIGHEST}."
fi

echo 
