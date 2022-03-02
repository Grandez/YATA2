function makemq {
  cc yata_mqsrv.c yata_mq.c -o ../bin/yata_mqsrv -lrt -lpthread && return 1
  cc yata_mqcli.c yata_mq.c -o ../bin/yata_mqcli -lrt           && return 1
  cc yata_mqdel.c           -o ../bin/yata_mqdel -lrt           && return 1
  return 0
}
rc = makemq
exit $rc
