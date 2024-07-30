#!/usr/bin/env bash
##
# This section should match your Makefile
##
PY=${PY:-python3}
PELICAN=${PELICAN:-pelican}
PELICANOPTS="--delete-output-directory"

BASEDIR=$(pwd)
INPUTDIR=$BASEDIR/content
OUTPUTDIR=$BASEDIR/output
CONFFILE=$BASEDIR/pelicanconf.py

###
# Don't change stuff below here unless you are sure
###

function usage(){
  echo "usage: $0 (stop) (start) (restart) [port]"
  echo "This starts Pelican in debug and reload mode and then launches"
  echo "an HTTP server to help site development. It doesn't read"
  echo "your Pelican settings, so if you edit any paths in your Makefile"
  echo "you will need to edit your settings as well."
  exit 3
}

function alive() {
  kill -0 $1 >/dev/null 2>&1
}

function shut_down(){
  pkill -f 'pelican .*pelicanconf\.py'
}

function start_up(){
  local port=$1
  echo "Starting up Pelican and HTTP server"
  shift
  $PELICAN \
    --debug \
    --autoreload \
    --output $OUTPUTDIR \
    --settings $CONFFILE \
    --listen \
    --port $port \
    $PELICANOPTS \
    $INPUTDIR 
}

###
#  MAIN
###
[[ ($# -eq 0) || ($# -gt 2) ]] && usage
port=''
[[ $# -eq 2 ]] && port=$2 || port=8000

if [[ $1 == "stop" ]]; then
  shut_down
elif [[ $1 == "restart" ]]; then
  shut_down
  start_up $port
elif [[ $1 == "start" ]]; then
  if ! start_up $port; then
    shut_down
  fi
else
  usage
fi
