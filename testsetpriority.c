#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int 
testsetpriority(void)
{

    if(setpriority(getpid(), 2) == -1)
        printf(2, "HELP\n");
    sleep(2000);
    exit();
}

#endif
