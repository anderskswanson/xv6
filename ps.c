#ifdef CS333_P2
#include "types.h"
#include "uproc.h"
#include "user.h"

static void tickasfloat(uint);

int
main(void)
{

  struct uproc * utable;  
  int max = 72;
  int uprocsize;
  utable = (struct uproc *) malloc(sizeof(struct uproc) * max);

  uprocsize = getprocs(max, utable);
  if(uprocsize >= 0)
  {
      printf(2, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
      for(int i = 0; i < uprocsize; ++i)
      {
          printf(2, "%d\t%s\t%d\t%d\t%d\t", utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
          tickasfloat(utable[i].elapsed_ticks);
          tickasfloat(utable[i].CPU_total_ticks);
          printf(2, "%s\t%d\n", utable[i].state, utable[i].size);
      }
  }
  else
      printf(2, "Error getting processes\n");

  free(utable);
  exit();
}

static void 
tickasfloat(uint tickcount)
{
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    printf(2,"%d.", ticksl);
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        printf(2,"%d%d\t", 0, ticksr);
    else
        printf(2,"%d\t", ticksr);

}
#endif
