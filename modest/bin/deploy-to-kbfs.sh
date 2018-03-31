#!/bin/bash -eu
#
## expects to be executed in CWD of the top level of the repository
#
## requires at least one parameter
# $1=keybase username
#
## further params are passed to rsync
#
# $ ./bin/deploy-to-kbfs.sh kourier --exclude '*.html' --delete-excluded
#

[[ ${#@} -gt 0 ]] || {
  echo "need Keybase username in \$1 to deploy in public tree, bye"
  exit 1
}

DST=$1;shift

rsync -ai $@ --exclude .git/ ./output/ /keybase/public/$DST/
