#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following complex command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
#NAME='mvn help:evaluate -Dexpression=project.name | grep "^[^\[]"'
NAME=$(mvn help:evaluate -Dexpression=project.name | grep "^[^\[]")
NAME=$(echo "$NAME" | tr -d '\r\n')
set +x

echo 'The following complex command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
#VERSION='mvn help:evaluate -Dexpression=project.version | grep "^[^\[]"'
VERSION=$(mvn help:evaluate -Dexpression=project.version | grep "^[^\[]")
VERSION=$(echo "$VERSION" | tr -d '\r\n')
set +x

clean_name=$(echo "$NAME" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
clean_version=$(echo "$VERSION" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

echo "Cleaned NAME: $clean_name"
echo "Cleaned VERSION: $clean_version"

# Construct the file path using cleaned variables
FILE="target/${clean_name}-${clean_version}.jar"

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x

#java -jar "target/${NAME}-${VERSION}.jar"
java -jar ${FILE}
