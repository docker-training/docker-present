#!/bin/bash

# Docker ENTRYPOINT for mirantistraining/docker-present

# usage/help
function usage() {
cat << EOF

docker-present
==============

  Available Options:

    -h    Display help
    -p    Specify port (required)
    -x    Default presentation name

  Usage:

    docker run -ti -v /var/run/docker.sock:/var/run/docker.sock mirantistraining/docker-present:PLATFORM-vRELEASE -p <port>

    Note: Mounting the Docker socket is required.

EOF
exit 1
}

function run() {

  printf "\nAttempting to start presentation '$1' on port: $2 ...\n"
  docker run -d --expose=$2 \
             -p $2:$2 \
             --entrypoint="$(pwd)/present.py" \
             --volumes-from ${HOSTNAME} \
             mirantistraining/docker-present:PLATFORM-vRELEASE $1 $2
  exit 1
}

# display usage when executed without args
if [ $# -eq 0 ]; then usage; fi

# process args
while getopts ":p:hx:" opt; do
  case "${opt}" in
    p)
      PORT=${OPTARG}
      ;;
    h)
      usage
      ;;
    x)
      EX=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;
  esac
done

# check for custom repository
if [ -d "/tmp/src" ]; then
  rm -r /opt/revealjs/src
  cp -r /tmp/src /opt/revealjs/
fi

# prompt/serve selected presentation
DIR=/opt/revealjs/src/presentations/*
MENU=$(find ${DIR} -printf "%f:");

printf "\nAvailable Presentations\n"
printf "=======================\n\n"
find ${DIR} -printf "%f:@" -exec head -qn1 {} \; | column -t -s@ | sed 's/# //g'
printf "\n---\n\n"

if [ -n "$EX" ]; then
  run ${EX} ${PORT}
fi

OLD_IFS=${IFS}
IFS=":"
PS3=$'\nEnter selection: '
select PRES in ${MENU}; do
  if [ -n "$PRES" ]; then
    run ${PRES} ${PORT}
    exit 1
  fi
done

IFS=${OLD_IFS}
