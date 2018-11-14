#include "types.h"
#include "user.h"

int sleeptest(void)
{
    int pid = fork();

    if(pid > 0)
    {
        printf(2, "Entering parent\n");
        sleep(4000);
    }
    if(pid < 0)
        printf(2, "FORKERROR\n");
    
    
    if(pid > 0)
        wait();
    exit();
}
