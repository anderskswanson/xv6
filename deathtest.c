#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int 
deathtest(void)
{
    int pid = fork();

    if(pid > 0)
    {
        printf(2,"ENTERING PARENT\n");
        sleep(2000);
    }
    if(pid == 0)
        exit();
    if(pid < 0)
        printf(2, "FORKERROR\n");


    exit();
}

#endif
