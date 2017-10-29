#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int 
deathtest(void)
{

    int pid;
    int pids[64];
    int kids = 0;
    pid = fork();

    while(pid > 0)
    {
        pids[kids] = pid;
        pid = fork();

        if(pid < 0)
        {
            printf(2,"num kids: %d\n", kids);
            sleep(3000);
        }
//        if(pid == 0)
  //          while(1) {}
        ++kids;
    }
    
    if(pid > 0)
    {
        for(int i = 0; i < 64; ++i)
            kill(pids[i]);
    }


    exit();
}

#endif
