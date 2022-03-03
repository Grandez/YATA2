/*! cc yata_mqsrv.c yata_mq.c -o yata_mqsrv -lrt -lpthread */
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
#include <time.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <pthread.h>
#include <stdarg.h>

#define __YATA_MAIN__

#include "yata_mq.h"

int   contador =  0;
int   listen   =  1;
int   interval = QPERIOD;
int   alive    = QIDLE;

char *tokens[12];

int   clients =  0; 
int   total   =  0;   

void *threadLaunch (void *arg)  {
   time_t tt;
   struct tm * tmInfo;

   time(&tt);
   tmInfo = localtime(&tt);
   
   int prev = QPERIOD - (tmInfo.tm_min % QPERIOD) + 1;
   sleep(prev * 60);

   while (1) {
     printf("Ejecuta hilo\n");
     sleep(QPERIOD * 60);
     // sleep(QPERIOD);
   }
}


void sig_handler (int signal) { 
listen = 0;
//JGG Hay que chequear que se acabe lo que se esta haciendo
mqEnd(32, "Stopping via signal %d", signal);
 
}

void cleanTokens() {
   int idx = 0;
   while (idx < 12 && tokens[idx] != NULL) {
      free(tokens[idx]);
      tokens[idx++] = NULL;
   }
}
void splitMessage(char *msg) {
   int   idx = 0;
   char *token;
   cleanTokens();

   token = strtok(msg, " ");
   while (token != NULL) {
      tokens[idx++] = strdup(token);
      token = strtok(NULL, " ");
  }
}
void parseMessage(char *msg) {
   char strdate[21];
   time_t tt;
   struct tm  *now;
   
   time(&tt);
   now = localtime(&tt);
   
   printf("interval: %d\n", interval);
   printf("alive   : %d\n", alive);
   
   splitMessage(msg);

   if (strcasecmp(tokens[0], "stop")  == 0) {
       clients--;
       if (tokens[1] != NULL) listen = 0;
       return;
   }
   if (strcasecmp(tokens[0], "status") == 0) {
       strftime(strdate,20, "%Y-%m-%d-%H:%M:%S", now);
       msglog("Server Status :");
       msglog("Last message  : %s", strdate);
       msglog("Total clients : %d", total);
       msglog("Active clients: %d", clients); 
       return;
   }
   if (strcasecmp(tokens[0], "start") == 0) {
       clients++;
       total++;
       if (tokens[1] != NULL) interval = atoi(tokens[1]);
       if (tokens[2] != NULL) alive    = atoi(tokens[2]);
       return;
   }
   if (strcasecmp(tokens[0], "interval") == 0) {
       if (tokens[1] != NULL) interval = atoi(tokens[1]);
       return;
   }
   if (strcasecmp(tokens[0], "alive") == 0) {
       if (tokens[1] != NULL) alive    = atoi(tokens[1]);
       return;
   }
}
int main (int argc, char **argv) {
    int    rc = 0; 
    char   msg[QUEUE_BUFF_SIZE + 1];
    char  *token;
    time_t tt;
    struct tm  *now;
    struct timespec until;
    unsigned int tout = 0; // Control first timeout
    pthread_t idThread;    

    mqStart(1);
        
    memset(tokens, 0x0, 12 * sizeof(char *));
    qdef = -1;
    
    time(&tt); 
    until.tv_sec  = tt + (alive * 60);
    until.tv_nsec = 0;

    if (!access(PID_FILE, F_OK)) {
        msglog("Server already started");
        exit(0);
    } 

    msglog("Server started");

    signal(SIGINT,  sig_handler);
    signal(SIGTERM, sig_handler);

    pid_t  pid  = getpid();
    FILE  *fpid = fopen(PID_FILE, "wt");
    fprintf(fpid,"%d\n", pid);
    fclose(fpid);

    rc = pthread_create (&idThread, NULL, threadLaunch, NULL);
    if (rc) {
                  printf("ERROR %d creating thread - rc: %d\n", errno, rc);
                      mqEnd(14,"ERROR %d creating thread", errno);
                  }
     
    qdef = mq_open(QNAME, O_RDONLY | O_CREAT, QMODE, &attr);
    if (qdef == -1) mqEnd(1, "ERROR %d opening queue", errno);
    
    while (listen) {
       rc = mq_timedreceive (qdef, msg, QUEUE_BUFF_SIZE, NULL, &until);

       time(&tt);
       now = localtime(&tt);
       until.tv_sec  = tt + (alive * 60);

       if (rc == -1) {
           if (errno   == ETIMEDOUT) tout++;
           if (errno   != ETIMEDOUT) mqEnd(15, "ERROR %d reading from queue", errno);
           if (clients <= 0 && tout != 1) listen = 0;
           continue;
       }
       if (rc > 2) parseMessage(msg);
    }
    mqEnd(0, "Normal");
}   


