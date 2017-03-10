#!/bin/bash

# Docker ENTRYPOINT for training/docker-present

# usage/help
function usage() {
cat << EOF

docker-present
==============

  Available Options:

    -h    Display help
    -p    Specify port (required)

  Usage:

    docker run -ti -v /var/run/docker.sock:/var/run/docker.sock training/docker-present:17.03-v1.0 -p <port>

    Note: Mounting the Docker socket is required.

EOF
exit 1
}

# display usage when executed without args
if [ $# -eq 0 ]; then usage; fi

# process args
while getopts ":p:h" opt; do
  case "${opt}" in
    p)
      PORT=${OPTARG}
      ;;
    h)
      usage
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

OLD_IFS=${IFS}
IFS=":"
PS3=$'\nEnter selection: '
select PRES in ${MENU}; do
  if [ -n "$PRES" ]; then

    printf "\nAttempting to start presentation '${PRES}' on port: ${PORT} ...\n"
    docker run -d --expose=${PORT} \
               -p ${PORT}:${PORT} \
               --entrypoint="$(pwd)/present.py" \
               --volumes-from ${HOSTNAME} \
               training/docker-present:17.03-v1.0 ${PRES} ${PORT}
    exit 1
  fi
done

IFS=${OLD_IFS}
