#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mqueue.h>

int main (int argc, char **argv) {
    printf("deleting queue\n");
    return mq_unlink(argv[1]);
}   

