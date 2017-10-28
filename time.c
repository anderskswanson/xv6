#ifdef CS333_P2
#include "types.h"
#include "user.h"

static void tickasfloat(uint);
    
int
main(int argc, char * argv[])
{
  int ticks_start, ticks_final, pid;

  if(argc <= 1)
  {
      printf(2,"time ran in 0.0 seconds\n");
      exit();
  }

  ticks_start = 0;
  pid = fork();
  if(pid > 0)
  {
      if(ticks_start == 0)
          ticks_start = uptime();
      pid = wait();

      ticks_final = uptime() - ticks_start;
      printf(2,"%s ran in ", argv[1]);
      tickasfloat(ticks_final);
      printf(2," seconds\n");
      
  }
  else if(pid == 0) 
  {
      ticks_start = uptime();
     
      ++argv;
      exec(argv[0], argv);
      printf(2, "exec %s failed\n", argv[0]);

  }
  else
      printf(2, "Fork error\n");
  exit();
}

static void 
tickasfloat(uint tickcount)
{
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    printf(2,"%d.", ticksl);
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d", 0, 0, ticksr);
    else if(ticksr < 100)
        printf(2,"%d%d", 0, ticksr);
    else
        printf(2,"%d", ticksr);

}
#endif
