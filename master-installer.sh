#!/bin/bash

# Init
pushd `dirname $BASH_SOURCE` > /dev/null
export BASE_DIR=`pwd`
popd > /dev/null

progname=`basename $0`

usage() {
   cat <<EOF

Usage: $progname -a [application_package_name] -p [] -c [] -t [topology]

  -a    Application name without version or extension eg: for abc-1.2.tar.gz =>> name would be abc
  -p    Previous version of the package eg: 1.1
  -c    Current version of the package eg: 1.2
  -t    The desired topology to be installed. Valid values are: w1h1, w1h2.

EOF
   exit 0
}

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

application_name=""
previous_version=""
upgraded_version=""
topology=""
valid_topologies=("w1h1" "w1h2")

while getopts "a:p:c:t:s" opt; do
   case $opt in
   a ) application_name=$OPTARG ;;
   p ) previous_version=$OPTARG ;;
   c ) upgraded_version=$OPTARG ;;
   t ) topology=$OPTARG ;;
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

if [ -z $topology ]; then
  echo "ERROR - You must specify a topology"
  usage
fi

containsElement "${topology}" "${valid_topologies[@]}"
if [ $? -eq 1 ]; then
  echo "ERROR - You must specify a valid topology"
  usage
fi

cd $BASE_DIR
if [ -e ".install.success" ]; then
  rm -f .install.success
fi

if [ [$previous_version != ""] ];
then
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=${topology}" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" --extra-vars "PREV_APPLICATION_VERSION=${previous_version}" vagrant-deploy.yml -v
else
  ANSIBLE_LOG_PATH=$BASE_DIR/$progname.log ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i env-local --extra-vars "TOPOLOGY=${topology}" --extra-vars "APPLICATION_NAME=${application_name}" --extra-vars "APPLICATION_VERSION=${upgraded_version}" vagrant-deploy.yml -v
fi


RC=$?
if [ $RC -eq 0 ]; then
  touch .install.success
fi
exit $RC
