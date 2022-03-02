cc yata_mqsrv.c yata_mq.c -o ../bin/yata_mqsrv -lrt -lpthread 
if [ $? -ne 0 ] ; then exit 1 ; fi

cc yata_mqcli.c yata_mq.c -o ../bin/yata_mqcli -lrt 
if [ $? -ne 0 ] ; then exit 1 ; fi

cc yata_mqdel.c           -o ../bin/yata_mqdel -lrt  
if [ $? -ne 0 ] ; then exit 1 ; fi
