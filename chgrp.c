#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  if(argc != 3) 
      printf(1, "Error: Wrong number of arguments\n");

  if(!chgrp(argv[1], atoi(argv[2])))
      printf(1, "chgrp failed\n");
  exit();
}

#endif
