#ifdef CS333_P2

#include "types.h"
#include "user.h"
#include "date.h"

int testuidgid(void)
{
    uint uid;
    uint gid;
    uint ppid;

    uid = getuid();

    printf(2, "Current UID: %d\n", uid);
    printf(2, "attempting to set uid to 100\n");
    if(setuid(100))
       printf(2, "UID was not set due to bounds checking\n");
    uid = getuid();
    printf(2, "Current UID is now: %d\n", uid);
    printf(2, "attempting to set uid to 40000\n");
    if(setuid(40000))
       printf(2, "UID was not set due to bounds checking\n");
    uid = getuid();
    printf(2, "Current UID is now: %d\n", uid);

    gid = getgid();
    printf(2, "Current GID: %d\n", gid);
    printf(2, "attempting to set gid to 999\n");
    if(setgid(999))
        printf(2, "GID was not set due to bounds checking\n");
    gid = getgid();
    printf(2, "Current GID is now %d\n", gid);

    printf(2, "attempting to set gid to 40000\n");
    if(setgid(40000))
        printf(2, "GID was not set due to bounds checking\n");
    gid = getgid();
    printf(2, "Current GID is now %d\n", gid);

    ppid = getppid();
    printf(2, "Current PPID: %d\n", ppid);

    printf(2, "TESTS COMPLETE\n");

    exit();
}

#endif
