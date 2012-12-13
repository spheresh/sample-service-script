#!/bin/sh
### BEGIN INIT INFO
# Provides:          <NAME>
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       <DESCRIPTION>
### END INIT INFO

SCRIPT='<COMMAND>'
RUNAS='<USER>'

PIDNAME=$(basename "$0")


start() {
  if [ -f /var/run/$PIDNAME ] && kill -0 $(cat /var/run/$PIDNAME); then
    echo 'Service already running' >&2
    exit 1
  fi
  echo 'Starting service…' >&2
  local CMD="$SCRIPT &> /dev/stderr & echo \$!"
  su -c "$CMD" $RUNAS > /var/run/$PIDNAME
  echo 'Service started' >&2
}

stop() {
  if [ ! -f /var/run/$PIDNAME ] || ! kill -0 $(cat /var/run/$PIDNAME); then
    echo 'Service not running' >&2
    exit 1
  fi
  echo 'Stopping service…' >&2
  kill -15 $(cat /var/run/$PIDNAME) && rm -f /var/run/$PIDNAME
  echo 'Service stopped' >&2
}

case "$1" in
 start)
     start
     ;;
 stop)
     stop
     ;;
 retart)
     stop
     start
     ;;
 *)
     echo "Usage: $0 {start|stop|restart}"
esac
