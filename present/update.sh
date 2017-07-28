#!/bin/bash
# update material files in running present container,
# this is intended to assist in presentation material development by
# allowing the running present container to render updated files without
# having to be restarted,
# when invoked this will copy all module files into the revealjs directory,
# a browser refresh will show the updated material

function usage() {
cat <<EOF
    Usage:
      /tmp/prompt.sh class-name

    Example:  /tmp/prompt.sh class-name

EOF
exit 1
}

UPDATESCRIPT=/tmp/update.py
MODULESDIR=/tmp/src/modules/

# we are expecting only the presentation material directory as an argument
if [ $# -ne 1 ]; then usage; fi

if [ ! -d $MODULESDIR ]
then
    echo "error, $MODULESDIR not found"
    exit 1
fi

# copy all module files to the rendering directory
cp -R $MODULESDIR /opt/revealjs/src/

# invoke the update script to regenerate the presentation
$UPDATESCRIPT $1

