#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  if(argc != 3) 
      printf(1, "Error: Wrong number of arguments\n");

  if(!chmod(argv[1], atoi(argv[2])))
      printf(1, "chmod failed\n");
  exit();
}
#endif
