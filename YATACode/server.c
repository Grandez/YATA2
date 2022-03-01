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

#include <mqueue.h>

#include "yata_mq.h"

int   contador = 0;
int   listen   = 1;
FILE *flog     = NULL;


void *threadLaunch (void *parametro)
{
   /* Bucle infinito para decrementar contador y mostrarlo en pantalla. */
	while (1)
	{
	sleep(1);
//		contador--;
//		printf ("Hilo  : %d\n", contador);
	}
}

void msglog (char *fmt, ...) {
   time_t tt;
   struct tm *now;
   char strdate[21];
   char buff[512];
   
   if (flog != NULL) {
       va_list args;
       va_start(args, fmt);
       vsprintf(buff, fmt, args);
       va_end(args);
       time(&tt);
       now = localtime(&tt);
       strftime(strdate,20, "%Y-%m-%d-%H:%M:%S", now);
       fprintf(flog,"%s;YATAMQ;%s\n", strdate, buff);
   }   
}
void end(int rc) {
printf("Acaba con codigo %d\n", rc);
   remove(PID_FILE);
   if (flog != NULL) fclose(flog);
   exit(rc);
}

void sig_handler (int signal) { 
listen = 0;
//JGG Hay que chequear que se acabe lo que se esta haciendo
msglog("Stopping via signal %d", signal);
end(32); 
}

int main (int argc, char **argv) {
    int    rc = 0; 
    int    clients = 0; 
    int    total   = 0;   
    char   msg [QUEUE_BUFF_SIZE + 1];
    char  *token;
    time_t tt;
    struct tm  *now;
    struct timespec until;
    struct timespec tout;
    struct mq_attr  attr; 
    pthread_t idThread;    
    mqd_t qdef;

printf("Entra en main\n");    
    flog = fopen(LOG_FILE, "at");
    
    if (access(PID_FILE, F_OK)) {
        msglog("Server started");
    } else {
    printf("Ha encontrado %s\n", PID_FILE);
        msglog("Server already started");
        if (flog != NULL) fclose(flog);
        exit(4);
    }    
    printf ("Server: Hello, World!\n");

    signal(SIGINT,  sig_handler);
    signal(SIGTERM, sig_handler);

    pid_t pid = getpid();
    printf("El pid es %d\n", pid);
    FILE *fpid = fopen(PID_FILE, "wt");
    fprintf(fpid,"%d\n", pid);
    fclose(fpid);

    attr.mq_flags = 0;
    attr.mq_maxmsg  = QUEUE_MSG_MAX;
    attr.mq_msgsize = QUEUE_SIZE_MAX;
    attr.mq_curmsgs = 0;
     
    time(&tt); 
    until.tv_sec  = tt + (MQ_WAIT * 60);
    until.tv_nsec = 0;
    tout = until;
     
    qdef = mq_open(QNAME, O_RDONLY| O_CREAT, QUEUE_MODE, &attr);
    if (qdef == -1) {
        msglog("ERROR %d opening queue", errno);
        end(1);
    }    
    
    while (listen) {
       rc = mq_timedreceive (qdef, msg, QUEUE_BUFF_SIZE, NULL, &tout);
       time(&tt);
        
       if (rc == -1) {
       printf("timeout: %d\n", errno);
           if (errno != ETIMEDOUT)  {
               msglog("ERROR %d reading from queue", errno);
               end(16);
           }
           if (clients <= 0) { // && tt > until.tv_sec) {
               listen = 0;
               continue;
           }    
       }
       
       now = localtime(&tt);
       until.tv_sec  = tt + (MQ_WAIT * 60);
       tout = until;
       
       while ((token = strtok(msg, " ")) != NULL) {
           if (strcasecmp(msg, "start") == 0) {
               clients++;
               total++;
               if (clients == 1) {
                   rc = pthread_create (&idThread, NULL, threadLaunch, NULL);
                   if (rc) {
                       msglog("ERROR %d creating thread", errno);
                       end(16);
                   }
               }    
           }
           if (strcasecmp(msg, "stop") == 0) {
               clients--;
            }
            if (strcasecmp(msg, "status") == 0) {
                char strdate[21];
                strftime(strdate,20, "%Y-%m-%d-%H:%M:%S", now);
                msglog("Server Status :");
                msglog("Last message  : %s", strdate);
                msglog("Total clients : %d", total);
                msglog("Active clients: %d", clients); 
            }

       }      
    }
    end(0);
}


