#!/usr/bin/bash 
#Start REST Server in Linux
# Author: Grandez
#
# Use: yata_service [action] port
PORT=$2
PID=0
checkport() {
    PID=0
    line=`echo "jgg" | sudo -S -u root netstat -nlp | grep :$PORT`
    if [ -n "$line" ] ; then
        PID=`echo $line | cut -d ' ' -f 7 | cut -d '/' -f 1`
    fi
}
function start {
    checkport
    if [ $PID -eq 0 ] ; then
        Rscript --no-save --no-restore -e "YATAREST::start($PORT)" &
    fi    
}
function stop {
    while : ; do
       checkport
       [[ $PID -eq 0 ]] || break
       kill -s KILL -- $PID
       sleep 1
    done    

}
function status {
   st=""
   checkport
   if [ $PID -eq 0 ] ; then st="NOT" ; fi
   echo "Service at port" $PORT "is" $st "active"
}

case $1 in
  "stop")    stop ;;    
  "status")  status ;;
  "restart") stop
             start ;;
  *) start
esac
             

