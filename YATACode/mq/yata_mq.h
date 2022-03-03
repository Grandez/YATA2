
#ifndef __YATA__
   #define __YATA__
   
   #include <mqueue.h>

   #define QNAME "/yata"
   #define PID_FILE "/tmp/yata_mqs.pid"
   #define LOG_FILE "/tmp/yata.log"
   #define QIDLE    60  // Minutes idle before end server
   #define QPERIOD  15  // Interval in minutes to launch external process
   #define QMODE          0660
   #define QUEUE_MSG_MAX   100
   #define QUEUE_SIZE_MAX  256
   #define QUEUE_BUFF_SIZE 272


#undef __EXT__
#ifdef __YATA_MAIN__
#define __EXT__
struct mq_attr  attr = { .mq_flags = 0
                        ,.mq_maxmsg  = 9// QUEUE_MSG_MAX;
                        ,.mq_msgsize = QUEUE_BUFF_SIZE
                        ,.mq_curmsgs = 0
                       };         
#else
#define __EXT__ extern
__EXT__ struct mq_attr  attr;
#endif

__EXT__ mqd_t qdef;
__EXT__ void msglog  (char *fmt, ...);
__EXT__ void mqEnd   (int rc, char *fmt, ...);
__EXT__ void mqStart (int type);


#endif   
