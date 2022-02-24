#!/usr/bin/bash 
#Start REST Server in Linux
# Author: Grandez
#

function start {
    echo "start"
#RCMD="Rscript --no-save --no-restore "
#$RCMD -e "YATAREST::start(9090)"
    
}
function stop {
 echo "stop"   
}
function restart {
    echo "restart"
}
ACT="start"
if [ $# gt 1 ] ; then ACT=$1
    
if [ "$ACT" == "restart" ] ; tehn
    stop
    start
else
   if [ "$ACT" == "stop" ] ; then
      stop
   else
      start
   fi
fi             
