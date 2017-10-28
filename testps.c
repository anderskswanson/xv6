#ifdef CS333_P2

#include "types.h"
#include "user.h"
#include "uproc.h"

void 
pstest(void)
{
    int maxprocs = 64;
    int pid, uprocsize, i;

    struct uproc * utable;

    for(i = 0; i < maxprocs; ++i)
    {
        pid = fork();
        if (pid < 0)
            break; //bad fork

        if(pid == 0)
            sleep(pid);

        if(pid > 0)            
        {
            wait();
            exit();
        }
    }

    utable = (struct uproc *) malloc(sizeof(struct uproc) * 1);
    uprocsize = getprocs(1, utable);
    printf(2, "proc count with max of 1:%d\n", uprocsize);
    free(utable);
    sleep(5000);

    utable = (struct uproc *) malloc(sizeof(struct uproc) * 16);
    uprocsize = getprocs(16, utable);
    printf(2, "proc count with max of 16:%d\n", uprocsize);
    free(utable);
    sleep(5000);

    utable = (struct uproc *) malloc(sizeof(struct uproc) * 64);
    uprocsize = getprocs(64, utable);
    printf(2, "proc count with max of 64:%d\n", uprocsize);
    free(utable);
    sleep(5000);

    utable = (struct uproc *) malloc(sizeof(struct uproc) * 72);
    uprocsize = getprocs(72, utable);
    printf(2, "proc count with max of 72:%d\n", uprocsize);
    free(utable);
    sleep(5000);
   

}

int
main()
{
    
    pstest();
    exit();
}
#endif
