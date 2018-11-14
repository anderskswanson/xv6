#ifdef CS333_P3P4
#include "types.h"
#include "user.h"
int 
prioritytest(void)
{
    int start = uptime();

    int end = start + 20000;

    int pid = fork();

    while(start < end) { start = uptime(); }

    if(pid > 0)
        wait();
    exit();
}
#endif
