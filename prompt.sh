#!/bin/bash

# defaults
DIR=/opt/revealjs/src/presentations/*
FILES=$(find ${DIR} -printf "%f\n");


# usage/help
function usage() {
cat << EOF

docker-present

  A RevealJS Engine

  Available Options:

    -h    Display help
    -p    Specify port (required)

  Usage:

    docker run -ti -v /var/run/docker.sock:/var/run/docker.sock training/docker-present -p <port>

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
printf "\nAvailable Presentations:\n\n"
PS3=$'\nEnter selection: '
select PRES in ${FILES}; do
  if [ -n "$PRES" ]; then

    echo "Attempting to start presentation '${PRES}' on port: ${PORT} ..."
    docker run -d --expose=${PORT} \
               -p ${PORT}:${PORT} \
               --entrypoint="$(pwd)/present.py" \
               -v /var/run/docker.sock:/var/run/docker.sock \
               training/docker-present ${PRES} ${PORT}
    exit 1
  fi
done
