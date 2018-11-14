#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  if(argc != 3) {
      printf(1, "Error: Wrong number of arguments\n");
      exit();
  }

  if(chown(argv[2], atoi(argv[1])) == -1)
      printf(1, "chown failed\n");
  exit();
}

#endif
