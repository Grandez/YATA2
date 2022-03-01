/*! cc yata_mqcli.c yata_mq.c -o yata_mqcli -lrt */
/*
 * El server procesa los mensajes:
 * - start: Un cliente se ha conectado
 * - stop : Un cliente se ha desconectado
 * - halt : para el proceso (metodo de seguridad)  
 * Cada vez que se conecta un cliente (Web) envia una notificacion start
 * Cada vez que se descaonecta el cliente envia una notificacion stop
 * Cuando la suma de starts y stop es cero; es decir, no hay clientes
 * Esperamos un tiempo para parar el hilo
 * Eso lo sabemos por que la cola tiene timeout
 *    Es decir, si clients = 1 y salta por timeout seguimos
 *    pero  si clients = 0 y salta por timeout quiere decir que nadie esta
 *    desde el timeout (1 hora poor ejemplo) y paramos el hilo
 *    
 *    El hilo lo que hace es cargar la tabla de sessiones periodicamente
 * Para no interrumpir el proceso hijo no usamos semaforos, simplemente
 * miramos el flag compartido esperando un cero
 * Es decir, el hilo lo pone a 1 y a 0 (Ocupado/inactivo)
 * El padre solo busca por el 0 (sleep 1) para hacer kill del hilo
 * El hijo se para cuando el main acaba
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

#include <mqueue.h>

#define __YATA_MAIN__
#include "yata_mq.h"

void startServer() {
  char **argv = NULL;
  pid_t pid = 33;
  printf("Chequea %s - %d\n", PID_FILE, pid);
  int rc = access(PID_FILE, F_OK) ;
  printf("access devuelve %d\n", rc);
  if (rc != 0) {
  printf("hace fork\n");
      pid = fork();
  } else {
  printf("no hace fork\n");
  }
  if (pid == 0) {
      printf("Hace exec\n");
      execv("yata_mqsrv", argv);
  }
}

int main (int argc, char **argv) {
    int rc = 0;
    int len = 0; 
    char *buff = NULL;
    
    mqStart(0);
    
    for (int i = 1; i < argc; i++) len += (strlen(argv[1]) + 1);
    buff = (char *) calloc(1, len + 1);
    for (int i = 1; i < argc; i++) {
         strcat(buff, argv[i]);
         strcat(buff, " ");
    }
    qdef = mq_open (QNAME, O_WRONLY, 0666, &attr);     
    if (qdef == -1) mqEnd(1, "ERROR %d opening queue", errno);

  printf("Envia mensaje %s\n", buff);
    rc = mq_send (qdef, buff, len + 1, 0); 
    if ( rc == -1) mqEnd(1, "ERROR %d writting message", errno);
        
    startServer();

    printf("Fin main\n");
    mqEnd(0, "Normal");
    return 0;
}   

