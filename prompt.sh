#!/bin/bash

# Usage/Help
function usage() {
cat << EOF

docker-present

  A RevealJS Engine

  Available Options:

    -h    Display help
    -p    Specify port (required)

EOF
exit 1
}

# Display usage when executed without args
if [ $# -eq 0 ]; then usage; fi


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

DIR=/opt/revealjs/src/presentations/*
FILELIST=$(find ${DIR} -printf "%f\n");

printf "\nAvailable Presentations:\n\n"
PS3=$'\nEnter selection: '
select FILE in ${FILELIST}; do
  if [ -n "$FILE" ]; then

    echo "Attempting to start presentation '${FILE}' on port: ${PORT} ..."
    docker run -d --expose=${PORT} \
               -p ${PORT}:${PORT} \
               --entrypoint="$(pwd)/present.py" \
               -v /var/run/docker.sock:/var/run/docker.sock \
               kizbitz/docker-present ${FILE} ${PORT}
    exit 1
  fi
done
