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
  
  //check that an octal number was entered
  int i = 0;
  char *c = argv[1];
  while(*c) {
      if(*c > '7' || *c < '0') {
          printf(1, "octal digits only!\n");
          exit();
      }
      ++i;
      ++c;
  }
 
  //check that the input is 4 digits
  if(i != 4) {
      printf(1, "octal number must be 4 digits counting leading zeroes!\n");
      exit();
  }

  //convert to int
  char *oct = argv[1];
  int dec = 0;

  dec += oct[3] - '0';
  dec += (oct[2] - '0') * 8;
  dec += (oct[1] - '0') * 8 * 8;
  dec += (oct[0] - '0') * 8 * 8 * 8;

  //check if characters are in range
  if(chmod(argv[2], dec) == -1)
      printf(1, "chmod failed\n");
  exit();
}
#endif

