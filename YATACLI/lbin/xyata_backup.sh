#!/usr/bin/bash 
# Author: Grandez
#
# Se llama como script paquete puerto accion
local PKG=$1
local PORT=$2

base=${YATA_SITE}/YATAData/bck
wrk=${YATA_SITE}/YATAData/wrk
day=`date +%Y%m%d`
# Si no existe el fichero database_day.zip hacer backup

function backupdb {
}

CWD=`cwd`
cd $wrk

bbdd=( "YATA" )
if [ $* ]
    
while [ ] ; do
done
        
cd $CWD


