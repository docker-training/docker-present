#!/bin/bash

# Docker ENTRYPOINT for training/docker-present

# defaults
DIR=/opt/revealjs/src/presentations/*
MENU=$(find ${DIR} -printf "%f ");

# usage/help
function usage() {
cat << EOF

docker-present
==============

  Available Options:

    -h    Display help
    -p    Specify port (required)

  Usage:

    docker run -ti -v /var/run/docker.sock:/var/run/docker.sock training/docker-present -p <port>

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

# prompt/serve selected presentation
printf "\nAvailable Presentations\n"
printf "=======================\n\n"
find ${DIR} -printf "%f:@" -exec head -qn1 {} \; | column -t -s@ | sed 's/# //g'
printf "\n---\n\n"
PS3=$'\nEnter selection: '
select PRES in ${MENU}; do
  if [ -n "$PRES" ]; then

    printf "\nAttempting to start presentation '${PRES}' on port: ${PORT} ...\n"
    docker run -d --expose=${PORT} \
               -p ${PORT}:${PORT} \
               --entrypoint="$(pwd)/present.py" \
               -v /var/run/docker.sock:/var/run/docker.sock \
               --volumes-from ${HOSTNAME} \
               training/docker-present ${PRES} ${PORT}
    exit 1
  fi
done
