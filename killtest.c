#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int 
killtest(void)
{
    int pid;
    pid = fork();

    for(int i = 0; i < 3 && pid > 0; ++i) 
    {
        pid = fork();

        printf(2,"cleanup... \n");
        kill(pid);
        sleep(2000);

        if(pid < 0)
            printf(2,"FORKERROR\n");
    }

    if(pid > 0)
        wait();
    exit();
}

#endif
