#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>

#define __YATA_MQ__
#include "yata_mq.h"

FILE *flog     = NULL;
int mqtype     = -1; // 0 -Server, 1- Client

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
       printf("%s;YATAMQ;%s\n", strdate, buff);
   }   
}
void mqStart(int type) {
  flog = fopen(LOG_FILE, "at");
  mqtype = type;
}

void mqEnd(int rc, char *fmt, ...) {
   char buff[512];
   if (rc != 0) {
      va_list args;
      va_start(args, fmt);
      vsprintf(buff, fmt, args);
      va_end(args);
      msglog(buff);
   }  
       
   msglog("Server stopped");
   if (mqtype) remove(PID_FILE);
   if (flog != NULL) fclose(flog);
   if (qdef != -1)   mq_close(qdef);
   exit(rc);
}


