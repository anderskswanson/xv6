#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

#define posval 100
#define negval -1
int 
testsetpriority(void)
{

/*    int pid;
    
    for(int i = 0; i < 8; ++i)
    {
        pid = fork();

        if(pid == 0)
            while(1) {}
        else if(pid > 0) {
            printf(1, "SETTING PID = %d to prio 1\n", pid);
            if(setpriority(pid, 1) == -1)
                printf(1, "SET PRIO FAIL");
            printf(1, "SETTING PID = %d to prio 1 \n", pid);
            if(setpriority(pid, 1) == -1)
                printf(1, "SET PRIO FAIL");
        }

    }
    if(pid > 0)
        wait();

*/

/*    printf(1,"attempting set priority calls with invalid parameters\n");

    if(setpriority(posval, 1) == -1)
        printf(1, "failed setting prio of pid = %d to 1\n", posval);
     
    
    if(setpriority(negval, 1) == -1)
        printf(1, "failed setting prio of pid = %d to 1\n", negval);
    
    if(setpriority(1, posval) == -1)
        printf(1, "failed setting prio of pid = 1 to %d\n", posval);
    if(setpriority(1, negval) == -1)
        printf(1, "failed setting prio of pid = 1 to %d\n", negval);
  
*/
    int pid = getpid();
    printf(1, "parent: %d\n", pid);


    for(int i = 0; i < 10; ++i)
    {
      

        if(!fork())
            while(1) {
                setpriority(pid, 5);
                sleep(10000);
            }
        else
        {
            if(!fork())
                while(1) {}
            sleep(10000);
        }
    }

   


    exit();
}

#endif
