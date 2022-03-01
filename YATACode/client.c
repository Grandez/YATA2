#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mqueue.h>

#include "yata_mq.h"

int main (int argc, char **argv) {
    int rc = 0;
    mqd_t qdef;
    int len = 0; 
    char *buff = NULL;
    
    if (argc == 1) {
        perror("Falta mensaje");
        exit(12);
    }
    for (int i = 1; i < argc; i++) len += (strlen(argv[1]) + 1);
    buff = (char *) calloc(1, len + 1);
    for (int i = 1; i < argc; i++) {
         strcat(buff, argv[i]);
         strcat(buff, " ");
    }
         
    if ((qdef = mq_open (QNAME, O_WRONLY)) == -1) {
        perror ("Client: mq_open (server)");
        exit (1);
    }
  
    rc = mq_send (qdef, buff, len + 1, 0); 
    if ( rc == -1) perror ("Client: Not able to send message to server");
        
    mq_close (qdef);

    exit (rc);
}

