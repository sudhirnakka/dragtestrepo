#!/bin/bash

# Init
pushd `dirname $BASH_SOURCE` > /dev/null
export BASE_DIR=`pwd`
popd > /dev/null

progname=`basename $0`

usage() {
   cat <<EOF

Usage: $progname -a [application_package_name]
  -a    Application name without version or extension eg: for abc-1.2.tar.gz =>> name would be abc
  -p    Previous version of the package eg: 1.1
  -c    Current version of the package eg: 1.2
EOF
   exit 0
}

application_name=""
previous_version=""
upgraded_version=""

while getopts "a:p:c:" opt; do
    echo $opt
   case $opt in
     a ) application_name=$OPTARG ;;
     p ) previous_version=$OPTARG ;;
     c ) upgraded_version=$OPTARG ;;
   \?) usage ;;
   esac
done
shift $(($OPTIND - 1))

if [ -z $application_name ]; then
  echo "ERROR - You must supply an application package name"
  usage
fi

if [ -z $upgraded_version ]; then
  echo "ERROR - You must supply an application version"
  usage
fi

cd $BASE_DIR
if [ -e ".install.success" ]; then
  rm -f .install.success
fi


if [ [$previous_version != ""] ];
then
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=w1h1" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" --extra-vars "PREV_APPLICATION_VERSION=${previous_version}" vagrant-deploy.yml
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=w1h2" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" --extra-vars "PREV_APPLICATION_VERSION=${previous_version}" vagrant-deploy.yml
else
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=w1h1" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" vagrant-deploy.yml
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=w1h2" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" vagrant-deploy.yml
fi


RC=$?
if [ $RC -eq 0 ]; then
  touch .install.success
fi
exit $RC
