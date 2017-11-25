
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 26 14 00 00       	call   1431 <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 26 14 00 00       	call   1439 <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 d0             	lea    -0x30(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 38 12 00 00       	call   125d <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 10 19 00 00       	push   $0x1910
      39:	68 20 19 00 00       	push   $0x1920
      3e:	6a 02                	push   $0x2
      40:	e8 13 15 00 00       	call   1558 <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 97 00 00 00       	jmp    e9 <canRun+0xe9>
  if (uid == st.uid) {
      52:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      56:	0f b7 c0             	movzwl %ax,%eax
      59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      5c:	75 2b                	jne    89 <canRun+0x89>
    if (st.mode.flags.u_x)
      5e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      62:	83 e0 40             	and    $0x40,%eax
      65:	84 c0                	test   %al,%al
      67:	74 07                	je     70 <canRun+0x70>
      return TRUE;
      69:	b8 01 00 00 00       	mov    $0x1,%eax
      6e:	eb 79                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      70:	83 ec 08             	sub    $0x8,%esp
      73:	68 34 19 00 00       	push   $0x1934
      78:	6a 02                	push   $0x2
      7a:	e8 d9 14 00 00       	call   1558 <printf>
      7f:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      82:	b8 00 00 00 00       	mov    $0x0,%eax
      87:	eb 60                	jmp    e9 <canRun+0xe9>
    }
  }
  if (gid == st.gid) {
      89:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
      8d:	0f b7 c0             	movzwl %ax,%eax
      90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
      93:	75 2b                	jne    c0 <canRun+0xc0>
    if (st.mode.flags.g_x)
      95:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      99:	83 e0 08             	and    $0x8,%eax
      9c:	84 c0                	test   %al,%al
      9e:	74 07                	je     a7 <canRun+0xa7>
      return TRUE;
      a0:	b8 01 00 00 00       	mov    $0x1,%eax
      a5:	eb 42                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a7:	83 ec 08             	sub    $0x8,%esp
      aa:	68 68 19 00 00       	push   $0x1968
      af:	6a 02                	push   $0x2
      b1:	e8 a2 14 00 00       	call   1558 <printf>
      b6:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b9:	b8 00 00 00 00       	mov    $0x0,%eax
      be:	eb 29                	jmp    e9 <canRun+0xe9>
    }
  }
  if (st.mode.flags.o_x) {
      c0:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      c4:	83 e0 01             	and    $0x1,%eax
      c7:	84 c0                	test   %al,%al
      c9:	74 07                	je     d2 <canRun+0xd2>
    return TRUE;
      cb:	b8 01 00 00 00       	mov    $0x1,%eax
      d0:	eb 17                	jmp    e9 <canRun+0xe9>
  }

  printf(2, "Execute permission for other not set.\n");
      d2:	83 ec 08             	sub    $0x8,%esp
      d5:	68 9c 19 00 00       	push   $0x199c
      da:	6a 02                	push   $0x2
      dc:	e8 77 14 00 00       	call   1558 <printf>
      e1:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e9:	c9                   	leave  
      ea:	c3                   	ret    

000000eb <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      eb:	55                   	push   %ebp
      ec:	89 e5                	mov    %esp,%ebp
      ee:	53                   	push   %ebx
      ef:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      f2:	c7 45 e0 c3 19 00 00 	movl   $0x19c3,-0x20(%ebp)
      f9:	c7 45 e4 cd 19 00 00 	movl   $0x19cd,-0x1c(%ebp)
     100:	c7 45 e8 d7 19 00 00 	movl   $0x19d7,-0x18(%ebp)
     107:	c7 45 ec dd 19 00 00 	movl   $0x19dd,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10e:	83 ec 08             	sub    $0x8,%esp
     111:	68 e9 19 00 00       	push   $0x19e9
     116:	6a 01                	push   $0x1
     118:	e8 3b 14 00 00       	call   1558 <printf>
     11d:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     127:	e9 71 02 00 00       	jmp    39d <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12f:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     133:	83 ec 04             	sub    $0x4,%esp
     136:	50                   	push   %eax
     137:	68 05 1a 00 00       	push   $0x1a05
     13c:	6a 01                	push   $0x1
     13e:	e8 15 14 00 00       	call   1558 <printf>
     143:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	c1 e0 04             	shl    $0x4,%eax
     14c:	05 c0 25 00 00       	add    $0x25c0,%eax
     151:	8b 00                	mov    (%eax),%eax
     153:	83 ec 0c             	sub    $0xc,%esp
     156:	50                   	push   %eax
     157:	e8 ed 12 00 00       	call   1449 <setuid>
     15c:	83 c4 10             	add    $0x10,%esp
     15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     166:	74 21                	je     189 <doSetuidTest+0x9e>
     168:	83 ec 04             	sub    $0x4,%esp
     16b:	68 19 1a 00 00       	push   $0x1a19
     170:	68 20 19 00 00       	push   $0x1920
     175:	6a 02                	push   $0x2
     177:	e8 dc 13 00 00       	call   1558 <printf>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	b8 00 00 00 00       	mov    $0x0,%eax
     184:	e9 4f 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     189:	8b 45 f4             	mov    -0xc(%ebp),%eax
     18c:	c1 e0 04             	shl    $0x4,%eax
     18f:	05 c4 25 00 00       	add    $0x25c4,%eax
     194:	8b 00                	mov    (%eax),%eax
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	50                   	push   %eax
     19a:	e8 b2 12 00 00       	call   1451 <setgid>
     19f:	83 c4 10             	add    $0x10,%esp
     1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a9:	74 21                	je     1cc <doSetuidTest+0xe1>
     1ab:	83 ec 04             	sub    $0x4,%esp
     1ae:	68 37 1a 00 00       	push   $0x1a37
     1b3:	68 20 19 00 00       	push   $0x1920
     1b8:	6a 02                	push   $0x2
     1ba:	e8 99 13 00 00       	call   1558 <printf>
     1bf:	83 c4 10             	add    $0x10,%esp
     1c2:	b8 00 00 00 00       	mov    $0x0,%eax
     1c7:	e9 0c 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1cc:	e8 68 12 00 00       	call   1439 <getgid>
     1d1:	89 c3                	mov    %eax,%ebx
     1d3:	e8 59 12 00 00       	call   1431 <getuid>
     1d8:	53                   	push   %ebx
     1d9:	50                   	push   %eax
     1da:	68 55 1a 00 00       	push   $0x1a55
     1df:	6a 01                	push   $0x1
     1e1:	e8 72 13 00 00       	call   1558 <printf>
     1e6:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ec:	c1 e0 04             	shl    $0x4,%eax
     1ef:	05 c8 25 00 00       	add    $0x25c8,%eax
     1f4:	8b 10                	mov    (%eax),%edx
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	8b 00                	mov    (%eax),%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	52                   	push   %edx
     1ff:	50                   	push   %eax
     200:	e8 6c 12 00 00       	call   1471 <chown>
     205:	83 c4 10             	add    $0x10,%esp
     208:	89 45 f0             	mov    %eax,-0x10(%ebp)
     20b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20f:	74 21                	je     232 <doSetuidTest+0x147>
     211:	83 ec 04             	sub    $0x4,%esp
     214:	68 70 1a 00 00       	push   $0x1a70
     219:	68 20 19 00 00       	push   $0x1920
     21e:	6a 02                	push   $0x2
     220:	e8 33 13 00 00       	call   1558 <printf>
     225:	83 c4 10             	add    $0x10,%esp
     228:	b8 00 00 00 00       	mov    $0x0,%eax
     22d:	e9 a6 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	c1 e0 04             	shl    $0x4,%eax
     238:	05 cc 25 00 00       	add    $0x25cc,%eax
     23d:	8b 10                	mov    (%eax),%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	8b 00                	mov    (%eax),%eax
     244:	83 ec 08             	sub    $0x8,%esp
     247:	52                   	push   %edx
     248:	50                   	push   %eax
     249:	e8 2b 12 00 00       	call   1479 <chgrp>
     24e:	83 c4 10             	add    $0x10,%esp
     251:	89 45 f0             	mov    %eax,-0x10(%ebp)
     254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     258:	74 21                	je     27b <doSetuidTest+0x190>
     25a:	83 ec 04             	sub    $0x4,%esp
     25d:	68 98 1a 00 00       	push   $0x1a98
     262:	68 20 19 00 00       	push   $0x1920
     267:	6a 02                	push   $0x2
     269:	e8 ea 12 00 00       	call   1558 <printf>
     26e:	83 c4 10             	add    $0x10,%esp
     271:	b8 00 00 00 00       	mov    $0x0,%eax
     276:	e9 5d 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27e:	c1 e0 04             	shl    $0x4,%eax
     281:	05 cc 25 00 00       	add    $0x25cc,%eax
     286:	8b 10                	mov    (%eax),%edx
     288:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28b:	c1 e0 04             	shl    $0x4,%eax
     28e:	05 c8 25 00 00       	add    $0x25c8,%eax
     293:	8b 00                	mov    (%eax),%eax
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	68 bd 1a 00 00       	push   $0x1abd
     29c:	6a 01                	push   $0x1
     29e:	e8 b5 12 00 00       	call   1558 <printf>
     2a3:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a9:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     2b0:	8b 45 08             	mov    0x8(%ebp),%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	83 ec 08             	sub    $0x8,%esp
     2b8:	52                   	push   %edx
     2b9:	50                   	push   %eax
     2ba:	e8 aa 11 00 00       	call   1469 <chmod>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c9:	74 21                	je     2ec <doSetuidTest+0x201>
     2cb:	83 ec 04             	sub    $0x4,%esp
     2ce:	68 d4 1a 00 00       	push   $0x1ad4
     2d3:	68 20 19 00 00       	push   $0x1920
     2d8:	6a 02                	push   $0x2
     2da:	e8 79 12 00 00       	call   1558 <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	b8 00 00 00 00       	mov    $0x0,%eax
     2e7:	e9 ec 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	8b 10                	mov    (%eax),%edx
     2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f4:	8b 04 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%eax
     2fb:	52                   	push   %edx
     2fc:	50                   	push   %eax
     2fd:	68 ec 1a 00 00       	push   $0x1aec
     302:	6a 01                	push   $0x1
     304:	e8 4f 12 00 00       	call   1558 <printf>
     309:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     30c:	e8 68 10 00 00       	call   1379 <fork>
     311:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     318:	79 1c                	jns    336 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     31a:	83 ec 08             	sub    $0x8,%esp
     31d:	68 04 1b 00 00       	push   $0x1b04
     322:	6a 02                	push   $0x2
     324:	e8 2f 12 00 00       	call   1558 <printf>
     329:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     32c:	b8 00 00 00 00       	mov    $0x0,%eax
     331:	e9 a2 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    }
    if (rc == 0) {   // child
     336:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     33a:	75 58                	jne    394 <doSetuidTest+0x2a9>
      exec(cmd[0], cmd);
     33c:	8b 45 08             	mov    0x8(%ebp),%eax
     33f:	8b 00                	mov    (%eax),%eax
     341:	83 ec 08             	sub    $0x8,%esp
     344:	ff 75 08             	pushl  0x8(%ebp)
     347:	50                   	push   %eax
     348:	e8 6c 10 00 00       	call   13b9 <exec>
     34d:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     350:	a1 a0 25 00 00       	mov    0x25a0,%eax
     355:	83 e8 01             	sub    $0x1,%eax
     358:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     35b:	74 1a                	je     377 <doSetuidTest+0x28c>
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8b 00                	mov    (%eax),%eax
     362:	83 ec 04             	sub    $0x4,%esp
     365:	50                   	push   %eax
     366:	68 4c 1b 00 00       	push   $0x1b4c
     36b:	6a 02                	push   $0x2
     36d:	e8 e6 11 00 00       	call   1558 <printf>
     372:	83 c4 10             	add    $0x10,%esp
     375:	eb 18                	jmp    38f <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	8b 00                	mov    (%eax),%eax
     37c:	83 ec 04             	sub    $0x4,%esp
     37f:	50                   	push   %eax
     380:	68 70 1b 00 00       	push   $0x1b70
     385:	6a 02                	push   $0x2
     387:	e8 cc 11 00 00       	call   1558 <printf>
     38c:	83 c4 10             	add    $0x10,%esp
      exit();
     38f:	e8 ed 0f 00 00       	call   1381 <exit>
    }
    wait();
     394:	e8 f0 0f 00 00       	call   1389 <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     399:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     39d:	a1 a0 25 00 00       	mov    0x25a0,%eax
     3a2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3a5:	0f 8c 81 fd ff ff    	jl     12c <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 00755);  // total hack but necessary. sigh
     3ab:	8b 45 08             	mov    0x8(%ebp),%eax
     3ae:	8b 00                	mov    (%eax),%eax
     3b0:	83 ec 08             	sub    $0x8,%esp
     3b3:	68 ed 01 00 00       	push   $0x1ed
     3b8:	50                   	push   %eax
     3b9:	e8 ab 10 00 00       	call   1469 <chmod>
     3be:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3c1:	83 ec 08             	sub    $0x8,%esp
     3c4:	68 9d 1b 00 00       	push   $0x1b9d
     3c9:	6a 01                	push   $0x1
     3cb:	e8 88 11 00 00       	call   1558 <printf>
     3d0:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3db:	c9                   	leave  
     3dc:	c3                   	ret    

000003dd <doUidTest>:

static int
doUidTest (char **cmd)
{
     3dd:	55                   	push   %ebp
     3de:	89 e5                	mov    %esp,%ebp
     3e0:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3e3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3ea:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3f1:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     3f8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     3ff:	83 ec 08             	sub    $0x8,%esp
     402:	68 aa 1b 00 00       	push   $0x1baa
     407:	6a 01                	push   $0x1
     409:	e8 4a 11 00 00       	call   1558 <printf>
     40e:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     411:	e8 1b 10 00 00       	call   1431 <getuid>
     416:	89 45 ec             	mov    %eax,-0x14(%ebp)
     419:	8b 45 ec             	mov    -0x14(%ebp),%eax
     41c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     41f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     423:	8b 45 ec             	mov    -0x14(%ebp),%eax
     426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     42c:	83 ec 0c             	sub    $0xc,%esp
     42f:	50                   	push   %eax
     430:	e8 14 10 00 00       	call   1449 <setuid>
     435:	83 c4 10             	add    $0x10,%esp
     438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     43b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43f:	74 1c                	je     45d <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     441:	83 ec 08             	sub    $0x8,%esp
     444:	68 c8 1b 00 00       	push   $0x1bc8
     449:	6a 02                	push   $0x2
     44b:	e8 08 11 00 00       	call   1558 <printf>
     450:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     453:	b8 00 00 00 00       	mov    $0x0,%eax
     458:	e9 07 01 00 00       	jmp    564 <doUidTest+0x187>
  }
  uid = getuid();
     45d:	e8 cf 0f 00 00       	call   1431 <getuid>
     462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     465:	8b 45 ec             	mov    -0x14(%ebp),%eax
     468:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     46b:	74 31                	je     49e <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     46d:	83 ec 08             	sub    $0x8,%esp
     470:	68 f0 1b 00 00       	push   $0x1bf0
     475:	6a 02                	push   $0x2
     477:	e8 dc 10 00 00       	call   1558 <printf>
     47c:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47f:	ff 75 ec             	pushl  -0x14(%ebp)
     482:	ff 75 e4             	pushl  -0x1c(%ebp)
     485:	68 28 1c 00 00       	push   $0x1c28
     48a:	6a 02                	push   $0x2
     48c:	e8 c7 10 00 00       	call   1558 <printf>
     491:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     494:	b8 00 00 00 00       	mov    $0x0,%eax
     499:	e9 c6 00 00 00       	jmp    564 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     49e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4a5:	e9 88 00 00 00       	jmp    532 <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ad:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4b1:	83 ec 0c             	sub    $0xc,%esp
     4b4:	50                   	push   %eax
     4b5:	e8 8f 0f 00 00       	call   1449 <setuid>
     4ba:	83 c4 10             	add    $0x10,%esp
     4bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4c4:	75 21                	jne    4e7 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c9:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4cd:	ff 75 e0             	pushl  -0x20(%ebp)
     4d0:	50                   	push   %eax
     4d1:	68 4c 1c 00 00       	push   $0x1c4c
     4d6:	6a 02                	push   $0x2
     4d8:	e8 7b 10 00 00       	call   1558 <printf>
     4dd:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4e0:	b8 00 00 00 00       	mov    $0x0,%eax
     4e5:	eb 7d                	jmp    564 <doUidTest+0x187>
    }
    rc = getuid();
     4e7:	e8 45 0f 00 00       	call   1431 <getuid>
     4ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f2:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     4f9:	75 33                	jne    52e <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fe:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     502:	ff 75 e0             	pushl  -0x20(%ebp)
     505:	50                   	push   %eax
     506:	68 9c 1c 00 00       	push   $0x1c9c
     50b:	6a 02                	push   $0x2
     50d:	e8 46 10 00 00       	call   1558 <printf>
     512:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     515:	83 ec 08             	sub    $0x8,%esp
     518:	68 e4 1c 00 00       	push   $0x1ce4
     51d:	6a 02                	push   $0x2
     51f:	e8 34 10 00 00       	call   1558 <printf>
     524:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     527:	b8 00 00 00 00       	mov    $0x0,%eax
     52c:	eb 36                	jmp    564 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     52e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     532:	8b 45 f4             	mov    -0xc(%ebp),%eax
     535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     538:	0f 8c 6c ff ff ff    	jl     4aa <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     541:	83 ec 0c             	sub    $0xc,%esp
     544:	50                   	push   %eax
     545:	e8 ff 0e 00 00       	call   1449 <setuid>
     54a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     54d:	83 ec 08             	sub    $0x8,%esp
     550:	68 9d 1b 00 00       	push   $0x1b9d
     555:	6a 01                	push   $0x1
     557:	e8 fc 0f 00 00       	call   1558 <printf>
     55c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     55f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     564:	c9                   	leave  
     565:	c3                   	ret    

00000566 <doGidTest>:

static int
doGidTest (char **cmd)
{
     566:	55                   	push   %ebp
     567:	89 e5                	mov    %esp,%ebp
     569:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     56c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     573:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     57a:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     581:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     588:	83 ec 08             	sub    $0x8,%esp
     58b:	68 12 1d 00 00       	push   $0x1d12
     590:	6a 01                	push   $0x1
     592:	e8 c1 0f 00 00       	call   1558 <printf>
     597:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     59a:	e8 9a 0e 00 00       	call   1439 <getgid>
     59f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     5a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5b5:	83 ec 0c             	sub    $0xc,%esp
     5b8:	50                   	push   %eax
     5b9:	e8 93 0e 00 00       	call   1451 <setgid>
     5be:	83 c4 10             	add    $0x10,%esp
     5c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c8:	74 1c                	je     5e6 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5ca:	83 ec 08             	sub    $0x8,%esp
     5cd:	68 30 1d 00 00       	push   $0x1d30
     5d2:	6a 02                	push   $0x2
     5d4:	e8 7f 0f 00 00       	call   1558 <printf>
     5d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5dc:	b8 00 00 00 00       	mov    $0x0,%eax
     5e1:	e9 07 01 00 00       	jmp    6ed <doGidTest+0x187>
  }
  gid = getgid();
     5e6:	e8 4e 0e 00 00       	call   1439 <getgid>
     5eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f4:	74 31                	je     627 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f6:	83 ec 08             	sub    $0x8,%esp
     5f9:	68 58 1d 00 00       	push   $0x1d58
     5fe:	6a 02                	push   $0x2
     600:	e8 53 0f 00 00       	call   1558 <printf>
     605:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     608:	ff 75 ec             	pushl  -0x14(%ebp)
     60b:	ff 75 e4             	pushl  -0x1c(%ebp)
     60e:	68 90 1d 00 00       	push   $0x1d90
     613:	6a 02                	push   $0x2
     615:	e8 3e 0f 00 00       	call   1558 <printf>
     61a:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     61d:	b8 00 00 00 00       	mov    $0x0,%eax
     622:	e9 c6 00 00 00       	jmp    6ed <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     62e:	e9 88 00 00 00       	jmp    6bb <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     63a:	83 ec 0c             	sub    $0xc,%esp
     63d:	50                   	push   %eax
     63e:	e8 0e 0e 00 00       	call   1451 <setgid>
     643:	83 c4 10             	add    $0x10,%esp
     646:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     649:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     64d:	75 21                	jne    670 <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     652:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     656:	ff 75 e0             	pushl  -0x20(%ebp)
     659:	50                   	push   %eax
     65a:	68 b4 1d 00 00       	push   $0x1db4
     65f:	6a 02                	push   $0x2
     661:	e8 f2 0e 00 00       	call   1558 <printf>
     666:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     669:	b8 00 00 00 00       	mov    $0x0,%eax
     66e:	eb 7d                	jmp    6ed <doGidTest+0x187>
    }
    rc = getgid();
     670:	e8 c4 0d 00 00       	call   1439 <getgid>
     675:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     678:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67b:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     67f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     682:	75 33                	jne    6b7 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     684:	8b 45 f4             	mov    -0xc(%ebp),%eax
     687:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     68b:	ff 75 e0             	pushl  -0x20(%ebp)
     68e:	50                   	push   %eax
     68f:	68 04 1e 00 00       	push   $0x1e04
     694:	6a 02                	push   $0x2
     696:	e8 bd 0e 00 00       	call   1558 <printf>
     69b:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69e:	83 ec 08             	sub    $0x8,%esp
     6a1:	68 4c 1e 00 00       	push   $0x1e4c
     6a6:	6a 02                	push   $0x2
     6a8:	e8 ab 0e 00 00       	call   1558 <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6b0:	b8 00 00 00 00       	mov    $0x0,%eax
     6b5:	eb 36                	jmp    6ed <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6c1:	0f 8c 6c ff ff ff    	jl     633 <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6ca:	83 ec 0c             	sub    $0xc,%esp
     6cd:	50                   	push   %eax
     6ce:	e8 7e 0d 00 00       	call   1451 <setgid>
     6d3:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d6:	83 ec 08             	sub    $0x8,%esp
     6d9:	68 9d 1b 00 00       	push   $0x1b9d
     6de:	6a 01                	push   $0x1
     6e0:	e8 73 0e 00 00       	call   1558 <printf>
     6e5:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6ed:	c9                   	leave  
     6ee:	c3                   	ret    

000006ef <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6ef:	55                   	push   %ebp
     6f0:	89 e5                	mov    %esp,%ebp
     6f2:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     6f5:	83 ec 08             	sub    $0x8,%esp
     6f8:	68 7a 1e 00 00       	push   $0x1e7a
     6fd:	6a 01                	push   $0x1
     6ff:	e8 54 0e 00 00       	call   1558 <printf>
     704:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     707:	8b 45 08             	mov    0x8(%ebp),%eax
     70a:	8b 00                	mov    (%eax),%eax
     70c:	83 ec 08             	sub    $0x8,%esp
     70f:	8d 55 cc             	lea    -0x34(%ebp),%edx
     712:	52                   	push   %edx
     713:	50                   	push   %eax
     714:	e8 44 0b 00 00       	call   125d <stat>
     719:	83 c4 10             	add    $0x10,%esp
     71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     723:	74 21                	je     746 <doChmodTest+0x57>
     725:	83 ec 04             	sub    $0x4,%esp
     728:	68 95 1e 00 00       	push   $0x1e95
     72d:	68 20 19 00 00       	push   $0x1920
     732:	6a 02                	push   $0x2
     734:	e8 1f 0e 00 00       	call   1558 <printf>
     739:	83 c4 10             	add    $0x10,%esp
     73c:	b8 00 00 00 00       	mov    $0x0,%eax
     741:	e9 1e 01 00 00       	jmp    864 <doChmodTest+0x175>
  mode = st.mode.asInt;
     746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     749:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     753:	e9 d1 00 00 00       	jmp    829 <doChmodTest+0x13a>
    check(chmod(cmd[0], perms[i]));
     758:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75b:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     762:	8b 45 08             	mov    0x8(%ebp),%eax
     765:	8b 00                	mov    (%eax),%eax
     767:	83 ec 08             	sub    $0x8,%esp
     76a:	52                   	push   %edx
     76b:	50                   	push   %eax
     76c:	e8 f8 0c 00 00       	call   1469 <chmod>
     771:	83 c4 10             	add    $0x10,%esp
     774:	89 45 f0             	mov    %eax,-0x10(%ebp)
     777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     77b:	74 21                	je     79e <doChmodTest+0xaf>
     77d:	83 ec 04             	sub    $0x4,%esp
     780:	68 d4 1a 00 00       	push   $0x1ad4
     785:	68 20 19 00 00       	push   $0x1920
     78a:	6a 02                	push   $0x2
     78c:	e8 c7 0d 00 00       	call   1558 <printf>
     791:	83 c4 10             	add    $0x10,%esp
     794:	b8 00 00 00 00       	mov    $0x0,%eax
     799:	e9 c6 00 00 00       	jmp    864 <doChmodTest+0x175>
    check(stat(cmd[0], &st));
     79e:	8b 45 08             	mov    0x8(%ebp),%eax
     7a1:	8b 00                	mov    (%eax),%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	8d 55 cc             	lea    -0x34(%ebp),%edx
     7a9:	52                   	push   %edx
     7aa:	50                   	push   %eax
     7ab:	e8 ad 0a 00 00       	call   125d <stat>
     7b0:	83 c4 10             	add    $0x10,%esp
     7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7ba:	74 21                	je     7dd <doChmodTest+0xee>
     7bc:	83 ec 04             	sub    $0x4,%esp
     7bf:	68 95 1e 00 00       	push   $0x1e95
     7c4:	68 20 19 00 00       	push   $0x1920
     7c9:	6a 02                	push   $0x2
     7cb:	e8 88 0d 00 00       	call   1558 <printf>
     7d0:	83 c4 10             	add    $0x10,%esp
     7d3:	b8 00 00 00 00       	mov    $0x0,%eax
     7d8:	e9 87 00 00 00       	jmp    864 <doChmodTest+0x175>
    testmode = st.mode.asInt;
     7dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e9:	75 3a                	jne    825 <doChmodTest+0x136>
      printf(2, "Error! Unable to test.\n");
     7eb:	83 ec 08             	sub    $0x8,%esp
     7ee:	68 a7 1e 00 00       	push   $0x1ea7
     7f3:	6a 02                	push   $0x2
     7f5:	e8 5e 0d 00 00       	call   1558 <printf>
     7fa:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     7fd:	8b 45 08             	mov    0x8(%ebp),%eax
     800:	8b 00                	mov    (%eax),%eax
     802:	83 ec 08             	sub    $0x8,%esp
     805:	ff 75 f4             	pushl  -0xc(%ebp)
     808:	50                   	push   %eax
     809:	ff 75 e8             	pushl  -0x18(%ebp)
     80c:	ff 75 ec             	pushl  -0x14(%ebp)
     80f:	68 c0 1e 00 00       	push   $0x1ec0
     814:	6a 02                	push   $0x2
     816:	e8 3d 0d 00 00       	call   1558 <printf>
     81b:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     81e:	b8 00 00 00 00       	mov    $0x0,%eax
     823:	eb 3f                	jmp    864 <doChmodTest+0x175>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.asInt;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     825:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     829:	a1 a0 25 00 00       	mov    0x25a0,%eax
     82e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     831:	0f 8c 21 ff ff ff    	jl     758 <doChmodTest+0x69>
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
		     mode, testmode, cmd[0], i);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     837:	8b 45 08             	mov    0x8(%ebp),%eax
     83a:	8b 00                	mov    (%eax),%eax
     83c:	83 ec 08             	sub    $0x8,%esp
     83f:	68 ed 01 00 00       	push   $0x1ed
     844:	50                   	push   %eax
     845:	e8 1f 0c 00 00       	call   1469 <chmod>
     84a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     84d:	83 ec 08             	sub    $0x8,%esp
     850:	68 9d 1b 00 00       	push   $0x1b9d
     855:	6a 01                	push   $0x1
     857:	e8 fc 0c 00 00       	call   1558 <printf>
     85c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     85f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     864:	c9                   	leave  
     865:	c3                   	ret    

00000866 <doChownTest>:

static int
doChownTest(char **cmd) 
{
     866:	55                   	push   %ebp
     867:	89 e5                	mov    %esp,%ebp
     869:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     86c:	83 ec 08             	sub    $0x8,%esp
     86f:	68 fb 1e 00 00       	push   $0x1efb
     874:	6a 01                	push   $0x1
     876:	e8 dd 0c 00 00       	call   1558 <printf>
     87b:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     87e:	8b 45 08             	mov    0x8(%ebp),%eax
     881:	8b 00                	mov    (%eax),%eax
     883:	83 ec 08             	sub    $0x8,%esp
     886:	8d 55 d0             	lea    -0x30(%ebp),%edx
     889:	52                   	push   %edx
     88a:	50                   	push   %eax
     88b:	e8 cd 09 00 00       	call   125d <stat>
     890:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     893:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
     897:	0f b7 c0             	movzwl %ax,%eax
     89a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a0:	8d 50 01             	lea    0x1(%eax),%edx
     8a3:	8b 45 08             	mov    0x8(%ebp),%eax
     8a6:	8b 00                	mov    (%eax),%eax
     8a8:	83 ec 08             	sub    $0x8,%esp
     8ab:	52                   	push   %edx
     8ac:	50                   	push   %eax
     8ad:	e8 bf 0b 00 00       	call   1471 <chown>
     8b2:	83 c4 10             	add    $0x10,%esp
     8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8bc:	74 1c                	je     8da <doChownTest+0x74>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8be:	83 ec 04             	sub    $0x4,%esp
     8c1:	ff 75 f0             	pushl  -0x10(%ebp)
     8c4:	68 14 1f 00 00       	push   $0x1f14
     8c9:	6a 02                	push   $0x2
     8cb:	e8 88 0c 00 00       	call   1558 <printf>
     8d0:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8d3:	b8 00 00 00 00       	mov    $0x0,%eax
     8d8:	eb 6e                	jmp    948 <doChownTest+0xe2>
  }

  stat(cmd[0], &st);
     8da:	8b 45 08             	mov    0x8(%ebp),%eax
     8dd:	8b 00                	mov    (%eax),%eax
     8df:	83 ec 08             	sub    $0x8,%esp
     8e2:	8d 55 d0             	lea    -0x30(%ebp),%edx
     8e5:	52                   	push   %edx
     8e6:	50                   	push   %eax
     8e7:	e8 71 09 00 00       	call   125d <stat>
     8ec:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     8ef:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
     8f3:	0f b7 c0             	movzwl %ax,%eax
     8f6:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     8ff:	75 1c                	jne    91d <doChownTest+0xb7>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     901:	ff 75 ec             	pushl  -0x14(%ebp)
     904:	ff 75 f4             	pushl  -0xc(%ebp)
     907:	68 4c 1f 00 00       	push   $0x1f4c
     90c:	6a 02                	push   $0x2
     90e:	e8 45 0c 00 00       	call   1558 <printf>
     913:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     916:	b8 00 00 00 00       	mov    $0x0,%eax
     91b:	eb 2b                	jmp    948 <doChownTest+0xe2>
  }
  chown(cmd[0], uid1);  // put back the original
     91d:	8b 45 08             	mov    0x8(%ebp),%eax
     920:	8b 00                	mov    (%eax),%eax
     922:	83 ec 08             	sub    $0x8,%esp
     925:	ff 75 f4             	pushl  -0xc(%ebp)
     928:	50                   	push   %eax
     929:	e8 43 0b 00 00       	call   1471 <chown>
     92e:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     931:	83 ec 08             	sub    $0x8,%esp
     934:	68 9d 1b 00 00       	push   $0x1b9d
     939:	6a 01                	push   $0x1
     93b:	e8 18 0c 00 00       	call   1558 <printf>
     940:	83 c4 10             	add    $0x10,%esp
  return PASS;
     943:	b8 01 00 00 00       	mov    $0x1,%eax
}
     948:	c9                   	leave  
     949:	c3                   	ret    

0000094a <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     94a:	55                   	push   %ebp
     94b:	89 e5                	mov    %esp,%ebp
     94d:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     950:	83 ec 08             	sub    $0x8,%esp
     953:	68 8b 1f 00 00       	push   $0x1f8b
     958:	6a 01                	push   $0x1
     95a:	e8 f9 0b 00 00       	call   1558 <printf>
     95f:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     962:	8b 45 08             	mov    0x8(%ebp),%eax
     965:	8b 00                	mov    (%eax),%eax
     967:	83 ec 08             	sub    $0x8,%esp
     96a:	8d 55 d0             	lea    -0x30(%ebp),%edx
     96d:	52                   	push   %edx
     96e:	50                   	push   %eax
     96f:	e8 e9 08 00 00       	call   125d <stat>
     974:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     977:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
     97b:	0f b7 c0             	movzwl %ax,%eax
     97e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     981:	8b 45 f4             	mov    -0xc(%ebp),%eax
     984:	8d 50 01             	lea    0x1(%eax),%edx
     987:	8b 45 08             	mov    0x8(%ebp),%eax
     98a:	8b 00                	mov    (%eax),%eax
     98c:	83 ec 08             	sub    $0x8,%esp
     98f:	52                   	push   %edx
     990:	50                   	push   %eax
     991:	e8 e3 0a 00 00       	call   1479 <chgrp>
     996:	83 c4 10             	add    $0x10,%esp
     999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     99c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9a0:	74 19                	je     9bb <doChgrpTest+0x71>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     9a2:	83 ec 08             	sub    $0x8,%esp
     9a5:	68 a4 1f 00 00       	push   $0x1fa4
     9aa:	6a 02                	push   $0x2
     9ac:	e8 a7 0b 00 00       	call   1558 <printf>
     9b1:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9b4:	b8 00 00 00 00       	mov    $0x0,%eax
     9b9:	eb 6e                	jmp    a29 <doChgrpTest+0xdf>
  }

  stat(cmd[0], &st);
     9bb:	8b 45 08             	mov    0x8(%ebp),%eax
     9be:	8b 00                	mov    (%eax),%eax
     9c0:	83 ec 08             	sub    $0x8,%esp
     9c3:	8d 55 d0             	lea    -0x30(%ebp),%edx
     9c6:	52                   	push   %edx
     9c7:	50                   	push   %eax
     9c8:	e8 90 08 00 00       	call   125d <stat>
     9cd:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9d0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
     9d4:	0f b7 c0             	movzwl %ax,%eax
     9d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     9e0:	75 1c                	jne    9fe <doChgrpTest+0xb4>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     9e2:	ff 75 ec             	pushl  -0x14(%ebp)
     9e5:	ff 75 f4             	pushl  -0xc(%ebp)
     9e8:	68 d4 1f 00 00       	push   $0x1fd4
     9ed:	6a 02                	push   $0x2
     9ef:	e8 64 0b 00 00       	call   1558 <printf>
     9f4:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     9f7:	b8 00 00 00 00       	mov    $0x0,%eax
     9fc:	eb 2b                	jmp    a29 <doChgrpTest+0xdf>
  }
  chgrp(cmd[0], gid1);  // put back the original
     9fe:	8b 45 08             	mov    0x8(%ebp),%eax
     a01:	8b 00                	mov    (%eax),%eax
     a03:	83 ec 08             	sub    $0x8,%esp
     a06:	ff 75 f4             	pushl  -0xc(%ebp)
     a09:	50                   	push   %eax
     a0a:	e8 6a 0a 00 00       	call   1479 <chgrp>
     a0f:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     a12:	83 ec 08             	sub    $0x8,%esp
     a15:	68 9d 1b 00 00       	push   $0x1b9d
     a1a:	6a 01                	push   $0x1
     a1c:	e8 37 0b 00 00       	call   1558 <printf>
     a21:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a24:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a29:	c9                   	leave  
     a2a:	c3                   	ret    

00000a2b <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a2b:	55                   	push   %ebp
     a2c:	89 e5                	mov    %esp,%ebp
     a2e:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a31:	83 ec 08             	sub    $0x8,%esp
     a34:	68 13 20 00 00       	push   $0x2013
     a39:	6a 01                	push   $0x1
     a3b:	e8 18 0b 00 00       	call   1558 <printf>
     a40:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a43:	8b 45 08             	mov    0x8(%ebp),%eax
     a46:	8b 00                	mov    (%eax),%eax
     a48:	83 ec 0c             	sub    $0xc,%esp
     a4b:	50                   	push   %eax
     a4c:	e8 af f5 ff ff       	call   0 <canRun>
     a51:	83 c4 10             	add    $0x10,%esp
     a54:	85 c0                	test   %eax,%eax
     a56:	75 22                	jne    a7a <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a58:	8b 45 08             	mov    0x8(%ebp),%eax
     a5b:	8b 00                	mov    (%eax),%eax
     a5d:	83 ec 04             	sub    $0x4,%esp
     a60:	50                   	push   %eax
     a61:	68 2c 20 00 00       	push   $0x202c
     a66:	6a 02                	push   $0x2
     a68:	e8 eb 0a 00 00       	call   1558 <printf>
     a6d:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a70:	b8 00 00 00 00       	mov    $0x0,%eax
     a75:	e9 e4 02 00 00       	jmp    d5e <doExecTest+0x333>
  }

  check(stat(cmd[0], &st));
     a7a:	8b 45 08             	mov    0x8(%ebp),%eax
     a7d:	8b 00                	mov    (%eax),%eax
     a7f:	83 ec 08             	sub    $0x8,%esp
     a82:	8d 55 cc             	lea    -0x34(%ebp),%edx
     a85:	52                   	push   %edx
     a86:	50                   	push   %eax
     a87:	e8 d1 07 00 00       	call   125d <stat>
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a96:	74 21                	je     ab9 <doExecTest+0x8e>
     a98:	83 ec 04             	sub    $0x4,%esp
     a9b:	68 95 1e 00 00       	push   $0x1e95
     aa0:	68 20 19 00 00       	push   $0x1920
     aa5:	6a 02                	push   $0x2
     aa7:	e8 ac 0a 00 00       	call   1558 <printf>
     aac:	83 c4 10             	add    $0x10,%esp
     aaf:	b8 00 00 00 00       	mov    $0x0,%eax
     ab4:	e9 a5 02 00 00       	jmp    d5e <doExecTest+0x333>
  uid = st.uid;
     ab9:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     abd:	0f b7 c0             	movzwl %ax,%eax
     ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     ac3:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
     ac7:	0f b7 c0             	movzwl %ax,%eax
     aca:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     acd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ad4:	e9 22 02 00 00       	jmp    cfb <doExecTest+0x2d0>
    check(setuid(testperms[i][procuid]));
     ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     adc:	c1 e0 04             	shl    $0x4,%eax
     adf:	05 c0 25 00 00       	add    $0x25c0,%eax
     ae4:	8b 00                	mov    (%eax),%eax
     ae6:	83 ec 0c             	sub    $0xc,%esp
     ae9:	50                   	push   %eax
     aea:	e8 5a 09 00 00       	call   1449 <setuid>
     aef:	83 c4 10             	add    $0x10,%esp
     af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     af9:	74 21                	je     b1c <doExecTest+0xf1>
     afb:	83 ec 04             	sub    $0x4,%esp
     afe:	68 19 1a 00 00       	push   $0x1a19
     b03:	68 20 19 00 00       	push   $0x1920
     b08:	6a 02                	push   $0x2
     b0a:	e8 49 0a 00 00       	call   1558 <printf>
     b0f:	83 c4 10             	add    $0x10,%esp
     b12:	b8 00 00 00 00       	mov    $0x0,%eax
     b17:	e9 42 02 00 00       	jmp    d5e <doExecTest+0x333>
    check(setgid(testperms[i][procgid]));
     b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1f:	c1 e0 04             	shl    $0x4,%eax
     b22:	05 c4 25 00 00       	add    $0x25c4,%eax
     b27:	8b 00                	mov    (%eax),%eax
     b29:	83 ec 0c             	sub    $0xc,%esp
     b2c:	50                   	push   %eax
     b2d:	e8 1f 09 00 00       	call   1451 <setgid>
     b32:	83 c4 10             	add    $0x10,%esp
     b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b3c:	74 21                	je     b5f <doExecTest+0x134>
     b3e:	83 ec 04             	sub    $0x4,%esp
     b41:	68 37 1a 00 00       	push   $0x1a37
     b46:	68 20 19 00 00       	push   $0x1920
     b4b:	6a 02                	push   $0x2
     b4d:	e8 06 0a 00 00       	call   1558 <printf>
     b52:	83 c4 10             	add    $0x10,%esp
     b55:	b8 00 00 00 00       	mov    $0x0,%eax
     b5a:	e9 ff 01 00 00       	jmp    d5e <doExecTest+0x333>
    check(chown(cmd[0], testperms[i][fileuid]));
     b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b62:	c1 e0 04             	shl    $0x4,%eax
     b65:	05 c8 25 00 00       	add    $0x25c8,%eax
     b6a:	8b 10                	mov    (%eax),%edx
     b6c:	8b 45 08             	mov    0x8(%ebp),%eax
     b6f:	8b 00                	mov    (%eax),%eax
     b71:	83 ec 08             	sub    $0x8,%esp
     b74:	52                   	push   %edx
     b75:	50                   	push   %eax
     b76:	e8 f6 08 00 00       	call   1471 <chown>
     b7b:	83 c4 10             	add    $0x10,%esp
     b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b85:	74 21                	je     ba8 <doExecTest+0x17d>
     b87:	83 ec 04             	sub    $0x4,%esp
     b8a:	68 70 1a 00 00       	push   $0x1a70
     b8f:	68 20 19 00 00       	push   $0x1920
     b94:	6a 02                	push   $0x2
     b96:	e8 bd 09 00 00       	call   1558 <printf>
     b9b:	83 c4 10             	add    $0x10,%esp
     b9e:	b8 00 00 00 00       	mov    $0x0,%eax
     ba3:	e9 b6 01 00 00       	jmp    d5e <doExecTest+0x333>
    check(chgrp(cmd[0], testperms[i][filegid]));
     ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bab:	c1 e0 04             	shl    $0x4,%eax
     bae:	05 cc 25 00 00       	add    $0x25cc,%eax
     bb3:	8b 10                	mov    (%eax),%edx
     bb5:	8b 45 08             	mov    0x8(%ebp),%eax
     bb8:	8b 00                	mov    (%eax),%eax
     bba:	83 ec 08             	sub    $0x8,%esp
     bbd:	52                   	push   %edx
     bbe:	50                   	push   %eax
     bbf:	e8 b5 08 00 00       	call   1479 <chgrp>
     bc4:	83 c4 10             	add    $0x10,%esp
     bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bce:	74 21                	je     bf1 <doExecTest+0x1c6>
     bd0:	83 ec 04             	sub    $0x4,%esp
     bd3:	68 98 1a 00 00       	push   $0x1a98
     bd8:	68 20 19 00 00       	push   $0x1920
     bdd:	6a 02                	push   $0x2
     bdf:	e8 74 09 00 00       	call   1558 <printf>
     be4:	83 c4 10             	add    $0x10,%esp
     be7:	b8 00 00 00 00       	mov    $0x0,%eax
     bec:	e9 6d 01 00 00       	jmp    d5e <doExecTest+0x333>
    check(chmod(cmd[0], perms[i]));
     bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bf4:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     bfb:	8b 45 08             	mov    0x8(%ebp),%eax
     bfe:	8b 00                	mov    (%eax),%eax
     c00:	83 ec 08             	sub    $0x8,%esp
     c03:	52                   	push   %edx
     c04:	50                   	push   %eax
     c05:	e8 5f 08 00 00       	call   1469 <chmod>
     c0a:	83 c4 10             	add    $0x10,%esp
     c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c14:	74 21                	je     c37 <doExecTest+0x20c>
     c16:	83 ec 04             	sub    $0x4,%esp
     c19:	68 d4 1a 00 00       	push   $0x1ad4
     c1e:	68 20 19 00 00       	push   $0x1920
     c23:	6a 02                	push   $0x2
     c25:	e8 2e 09 00 00       	call   1558 <printf>
     c2a:	83 c4 10             	add    $0x10,%esp
     c2d:	b8 00 00 00 00       	mov    $0x0,%eax
     c32:	e9 27 01 00 00       	jmp    d5e <doExecTest+0x333>
    if (i != NUMPERMSTOCHECK-1)
     c37:	a1 a0 25 00 00       	mov    0x25a0,%eax
     c3c:	83 e8 01             	sub    $0x1,%eax
     c3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c42:	74 14                	je     c58 <doExecTest+0x22d>
      printf(2, "The following test should not produce an error.\n");
     c44:	83 ec 08             	sub    $0x8,%esp
     c47:	68 50 20 00 00       	push   $0x2050
     c4c:	6a 02                	push   $0x2
     c4e:	e8 05 09 00 00       	call   1558 <printf>
     c53:	83 c4 10             	add    $0x10,%esp
     c56:	eb 12                	jmp    c6a <doExecTest+0x23f>
    else
      printf(2, "The following test should fail.\n");
     c58:	83 ec 08             	sub    $0x8,%esp
     c5b:	68 84 20 00 00       	push   $0x2084
     c60:	6a 02                	push   $0x2
     c62:	e8 f1 08 00 00       	call   1558 <printf>
     c67:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c6a:	e8 0a 07 00 00       	call   1379 <fork>
     c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c76:	79 1c                	jns    c94 <doExecTest+0x269>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     c78:	83 ec 08             	sub    $0x8,%esp
     c7b:	68 04 1b 00 00       	push   $0x1b04
     c80:	6a 02                	push   $0x2
     c82:	e8 d1 08 00 00       	call   1558 <printf>
     c87:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     c8a:	b8 00 00 00 00       	mov    $0x0,%eax
     c8f:	e9 ca 00 00 00       	jmp    d5e <doExecTest+0x333>
    }
    if (rc == 0) {   // child
     c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c98:	75 58                	jne    cf2 <doExecTest+0x2c7>
      exec(cmd[0], cmd);
     c9a:	8b 45 08             	mov    0x8(%ebp),%eax
     c9d:	8b 00                	mov    (%eax),%eax
     c9f:	83 ec 08             	sub    $0x8,%esp
     ca2:	ff 75 08             	pushl  0x8(%ebp)
     ca5:	50                   	push   %eax
     ca6:	e8 0e 07 00 00       	call   13b9 <exec>
     cab:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     cae:	a1 a0 25 00 00       	mov    0x25a0,%eax
     cb3:	83 e8 01             	sub    $0x1,%eax
     cb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     cb9:	74 1a                	je     cd5 <doExecTest+0x2aa>
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	8b 00                	mov    (%eax),%eax
     cc0:	83 ec 04             	sub    $0x4,%esp
     cc3:	50                   	push   %eax
     cc4:	68 4c 1b 00 00       	push   $0x1b4c
     cc9:	6a 02                	push   $0x2
     ccb:	e8 88 08 00 00       	call   1558 <printf>
     cd0:	83 c4 10             	add    $0x10,%esp
     cd3:	eb 18                	jmp    ced <doExecTest+0x2c2>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cd5:	8b 45 08             	mov    0x8(%ebp),%eax
     cd8:	8b 00                	mov    (%eax),%eax
     cda:	83 ec 04             	sub    $0x4,%esp
     cdd:	50                   	push   %eax
     cde:	68 70 1b 00 00       	push   $0x1b70
     ce3:	6a 02                	push   $0x2
     ce5:	e8 6e 08 00 00       	call   1558 <printf>
     cea:	83 c4 10             	add    $0x10,%esp
      exit();
     ced:	e8 8f 06 00 00       	call   1381 <exit>
    }
    wait();
     cf2:	e8 92 06 00 00       	call   1389 <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     cf7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cfb:	a1 a0 25 00 00       	mov    0x25a0,%eax
     d00:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d03:	0f 8c d0 fd ff ff    	jl     ad9 <doExecTest+0xae>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     d09:	8b 45 08             	mov    0x8(%ebp),%eax
     d0c:	8b 00                	mov    (%eax),%eax
     d0e:	83 ec 08             	sub    $0x8,%esp
     d11:	ff 75 ec             	pushl  -0x14(%ebp)
     d14:	50                   	push   %eax
     d15:	e8 57 07 00 00       	call   1471 <chown>
     d1a:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d1d:	8b 45 08             	mov    0x8(%ebp),%eax
     d20:	8b 00                	mov    (%eax),%eax
     d22:	83 ec 08             	sub    $0x8,%esp
     d25:	ff 75 e8             	pushl  -0x18(%ebp)
     d28:	50                   	push   %eax
     d29:	e8 4b 07 00 00       	call   1479 <chgrp>
     d2e:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d31:	8b 45 08             	mov    0x8(%ebp),%eax
     d34:	8b 00                	mov    (%eax),%eax
     d36:	83 ec 08             	sub    $0x8,%esp
     d39:	68 ed 01 00 00       	push   $0x1ed
     d3e:	50                   	push   %eax
     d3f:	e8 25 07 00 00       	call   1469 <chmod>
     d44:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d47:	83 ec 08             	sub    $0x8,%esp
     d4a:	68 a8 20 00 00       	push   $0x20a8
     d4f:	6a 01                	push   $0x1
     d51:	e8 02 08 00 00       	call   1558 <printf>
     d56:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d59:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d5e:	c9                   	leave  
     d5f:	c3                   	ret    

00000d60 <printMenu>:

void
printMenu(void)
{
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d6d:	83 ec 08             	sub    $0x8,%esp
     d70:	68 d3 20 00 00       	push   $0x20d3
     d75:	6a 01                	push   $0x1
     d77:	e8 dc 07 00 00       	call   1558 <printf>
     d7c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d82:	8d 50 01             	lea    0x1(%eax),%edx
     d85:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d88:	83 ec 04             	sub    $0x4,%esp
     d8b:	50                   	push   %eax
     d8c:	68 d5 20 00 00       	push   $0x20d5
     d91:	6a 01                	push   $0x1
     d93:	e8 c0 07 00 00       	call   1558 <printf>
     d98:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9e:	8d 50 01             	lea    0x1(%eax),%edx
     da1:	89 55 f4             	mov    %edx,-0xc(%ebp)
     da4:	83 ec 04             	sub    $0x4,%esp
     da7:	50                   	push   %eax
     da8:	68 e7 20 00 00       	push   $0x20e7
     dad:	6a 01                	push   $0x1
     daf:	e8 a4 07 00 00       	call   1558 <printf>
     db4:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dba:	8d 50 01             	lea    0x1(%eax),%edx
     dbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dc0:	83 ec 04             	sub    $0x4,%esp
     dc3:	50                   	push   %eax
     dc4:	68 f5 20 00 00       	push   $0x20f5
     dc9:	6a 01                	push   $0x1
     dcb:	e8 88 07 00 00       	call   1558 <printf>
     dd0:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd6:	8d 50 01             	lea    0x1(%eax),%edx
     dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ddc:	83 ec 04             	sub    $0x4,%esp
     ddf:	50                   	push   %eax
     de0:	68 03 21 00 00       	push   $0x2103
     de5:	6a 01                	push   $0x1
     de7:	e8 6c 07 00 00       	call   1558 <printf>
     dec:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     def:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df2:	8d 50 01             	lea    0x1(%eax),%edx
     df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     df8:	83 ec 04             	sub    $0x4,%esp
     dfb:	50                   	push   %eax
     dfc:	68 10 21 00 00       	push   $0x2110
     e01:	6a 01                	push   $0x1
     e03:	e8 50 07 00 00       	call   1558 <printf>
     e08:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e0e:	8d 50 01             	lea    0x1(%eax),%edx
     e11:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e14:	83 ec 04             	sub    $0x4,%esp
     e17:	50                   	push   %eax
     e18:	68 1d 21 00 00       	push   $0x211d
     e1d:	6a 01                	push   $0x1
     e1f:	e8 34 07 00 00       	call   1558 <printf>
     e24:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e2a:	8d 50 01             	lea    0x1(%eax),%edx
     e2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e30:	83 ec 04             	sub    $0x4,%esp
     e33:	50                   	push   %eax
     e34:	68 2a 21 00 00       	push   $0x212a
     e39:	6a 01                	push   $0x1
     e3b:	e8 18 07 00 00       	call   1558 <printf>
     e40:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e46:	8d 50 01             	lea    0x1(%eax),%edx
     e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e4c:	83 ec 04             	sub    $0x4,%esp
     e4f:	50                   	push   %eax
     e50:	68 36 21 00 00       	push   $0x2136
     e55:	6a 01                	push   $0x1
     e57:	e8 fc 06 00 00       	call   1558 <printf>
     e5c:	83 c4 10             	add    $0x10,%esp
}
     e5f:	90                   	nop
     e60:	c9                   	leave  
     e61:	c3                   	ret    

00000e62 <main>:

int
main(int argc, char *argv[])
{
     e62:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e66:	83 e4 f0             	and    $0xfffffff0,%esp
     e69:	ff 71 fc             	pushl  -0x4(%ecx)
     e6c:	55                   	push   %ebp
     e6d:	89 e5                	mov    %esp,%ebp
     e6f:	51                   	push   %ecx
     e70:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     e7a:	c7 45 d8 42 21 00 00 	movl   $0x2142,-0x28(%ebp)
     e81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     e88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     e8f:	e8 cc fe ff ff       	call   d60 <printMenu>
    printf(1, "Enter test number: ");
     e94:	83 ec 08             	sub    $0x8,%esp
     e97:	68 4d 21 00 00       	push   $0x214d
     e9c:	6a 01                	push   $0x1
     e9e:	e8 b5 06 00 00       	call   1558 <printf>
     ea3:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     ea6:	83 ec 08             	sub    $0x8,%esp
     ea9:	6a 05                	push   $0x5
     eab:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eae:	50                   	push   %eax
     eaf:	e8 3a 03 00 00       	call   11ee <gets>
     eb4:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     eb7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ebb:	3c 0a                	cmp    $0xa,%al
     ebd:	0f 84 f5 01 00 00    	je     10b8 <main+0x256>
     ec3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ec7:	84 c0                	test   %al,%al
     ec9:	0f 84 e9 01 00 00    	je     10b8 <main+0x256>
    select = atoi(buf);
     ecf:	83 ec 0c             	sub    $0xc,%esp
     ed2:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ed5:	50                   	push   %eax
     ed6:	e8 cf 03 00 00       	call   12aa <atoi>
     edb:	83 c4 10             	add    $0x10,%esp
     ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     ee1:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     ee5:	0f 87 9b 01 00 00    	ja     1086 <main+0x224>
     eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eee:	c1 e0 02             	shl    $0x2,%eax
     ef1:	05 f0 21 00 00       	add    $0x21f0,%eax
     ef6:	8b 00                	mov    (%eax),%eax
     ef8:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     efa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     f01:	e9 a7 01 00 00       	jmp    10ad <main+0x24b>
	    case 1:
		  doTest(doUidTest,    t0); break;
     f06:	83 ec 0c             	sub    $0xc,%esp
     f09:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f0c:	50                   	push   %eax
     f0d:	e8 cb f4 ff ff       	call   3dd <doUidTest>
     f12:	83 c4 10             	add    $0x10,%esp
     f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f1c:	0f 85 78 01 00 00    	jne    109a <main+0x238>
     f22:	83 ec 04             	sub    $0x4,%esp
     f25:	68 61 21 00 00       	push   $0x2161
     f2a:	68 6b 21 00 00       	push   $0x216b
     f2f:	6a 02                	push   $0x2
     f31:	e8 22 06 00 00       	call   1558 <printf>
     f36:	83 c4 10             	add    $0x10,%esp
     f39:	e8 43 04 00 00       	call   1381 <exit>
	    case 2:
		  doTest(doGidTest,    t0); break;
     f3e:	83 ec 0c             	sub    $0xc,%esp
     f41:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f44:	50                   	push   %eax
     f45:	e8 1c f6 ff ff       	call   566 <doGidTest>
     f4a:	83 c4 10             	add    $0x10,%esp
     f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f54:	0f 85 43 01 00 00    	jne    109d <main+0x23b>
     f5a:	83 ec 04             	sub    $0x4,%esp
     f5d:	68 7d 21 00 00       	push   $0x217d
     f62:	68 6b 21 00 00       	push   $0x216b
     f67:	6a 02                	push   $0x2
     f69:	e8 ea 05 00 00       	call   1558 <printf>
     f6e:	83 c4 10             	add    $0x10,%esp
     f71:	e8 0b 04 00 00       	call   1381 <exit>
	    case 3:
		  doTest(doChmodTest,  t1); break;
     f76:	83 ec 0c             	sub    $0xc,%esp
     f79:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f7c:	50                   	push   %eax
     f7d:	e8 6d f7 ff ff       	call   6ef <doChmodTest>
     f82:	83 c4 10             	add    $0x10,%esp
     f85:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f8c:	0f 85 0e 01 00 00    	jne    10a0 <main+0x23e>
     f92:	83 ec 04             	sub    $0x4,%esp
     f95:	68 87 21 00 00       	push   $0x2187
     f9a:	68 6b 21 00 00       	push   $0x216b
     f9f:	6a 02                	push   $0x2
     fa1:	e8 b2 05 00 00       	call   1558 <printf>
     fa6:	83 c4 10             	add    $0x10,%esp
     fa9:	e8 d3 03 00 00       	call   1381 <exit>
	    case 4:
		  doTest(doChownTest,  t1); break;
     fae:	83 ec 0c             	sub    $0xc,%esp
     fb1:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fb4:	50                   	push   %eax
     fb5:	e8 ac f8 ff ff       	call   866 <doChownTest>
     fba:	83 c4 10             	add    $0x10,%esp
     fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fc4:	0f 85 d9 00 00 00    	jne    10a3 <main+0x241>
     fca:	83 ec 04             	sub    $0x4,%esp
     fcd:	68 93 21 00 00       	push   $0x2193
     fd2:	68 6b 21 00 00       	push   $0x216b
     fd7:	6a 02                	push   $0x2
     fd9:	e8 7a 05 00 00       	call   1558 <printf>
     fde:	83 c4 10             	add    $0x10,%esp
     fe1:	e8 9b 03 00 00       	call   1381 <exit>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
     fe6:	83 ec 0c             	sub    $0xc,%esp
     fe9:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fec:	50                   	push   %eax
     fed:	e8 58 f9 ff ff       	call   94a <doChgrpTest>
     ff2:	83 c4 10             	add    $0x10,%esp
     ff5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ff8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ffc:	0f 85 a4 00 00 00    	jne    10a6 <main+0x244>
    1002:	83 ec 04             	sub    $0x4,%esp
    1005:	68 9f 21 00 00       	push   $0x219f
    100a:	68 6b 21 00 00       	push   $0x216b
    100f:	6a 02                	push   $0x2
    1011:	e8 42 05 00 00       	call   1558 <printf>
    1016:	83 c4 10             	add    $0x10,%esp
    1019:	e8 63 03 00 00       	call   1381 <exit>
	    case 6:
		  doTest(doExecTest,   t1); break;
    101e:	83 ec 0c             	sub    $0xc,%esp
    1021:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1024:	50                   	push   %eax
    1025:	e8 01 fa ff ff       	call   a2b <doExecTest>
    102a:	83 c4 10             	add    $0x10,%esp
    102d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1030:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1034:	75 73                	jne    10a9 <main+0x247>
    1036:	83 ec 04             	sub    $0x4,%esp
    1039:	68 ab 21 00 00       	push   $0x21ab
    103e:	68 6b 21 00 00       	push   $0x216b
    1043:	6a 02                	push   $0x2
    1045:	e8 0e 05 00 00       	call   1558 <printf>
    104a:	83 c4 10             	add    $0x10,%esp
    104d:	e8 2f 03 00 00       	call   1381 <exit>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    1052:	83 ec 0c             	sub    $0xc,%esp
    1055:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1058:	50                   	push   %eax
    1059:	e8 8d f0 ff ff       	call   eb <doSetuidTest>
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1064:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1068:	75 42                	jne    10ac <main+0x24a>
    106a:	83 ec 04             	sub    $0x4,%esp
    106d:	68 b6 21 00 00       	push   $0x21b6
    1072:	68 6b 21 00 00       	push   $0x216b
    1077:	6a 02                	push   $0x2
    1079:	e8 da 04 00 00       	call   1558 <printf>
    107e:	83 c4 10             	add    $0x10,%esp
    1081:	e8 fb 02 00 00       	call   1381 <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    1086:	83 ec 08             	sub    $0x8,%esp
    1089:	68 c3 21 00 00       	push   $0x21c3
    108e:	6a 01                	push   $0x1
    1090:	e8 c3 04 00 00       	call   1558 <printf>
    1095:	83 c4 10             	add    $0x10,%esp
    1098:	eb 13                	jmp    10ad <main+0x24b>
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1:
		  doTest(doUidTest,    t0); break;
    109a:	90                   	nop
    109b:	eb 10                	jmp    10ad <main+0x24b>
	    case 2:
		  doTest(doGidTest,    t0); break;
    109d:	90                   	nop
    109e:	eb 0d                	jmp    10ad <main+0x24b>
	    case 3:
		  doTest(doChmodTest,  t1); break;
    10a0:	90                   	nop
    10a1:	eb 0a                	jmp    10ad <main+0x24b>
	    case 4:
		  doTest(doChownTest,  t1); break;
    10a3:	90                   	nop
    10a4:	eb 07                	jmp    10ad <main+0x24b>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
    10a6:	90                   	nop
    10a7:	eb 04                	jmp    10ad <main+0x24b>
	    case 6:
		  doTest(doExecTest,   t1); break;
    10a9:	90                   	nop
    10aa:	eb 01                	jmp    10ad <main+0x24b>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    10ac:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10b1:	75 0b                	jne    10be <main+0x25c>
    10b3:	e9 d0 fd ff ff       	jmp    e88 <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    10b8:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    10b9:	e9 ca fd ff ff       	jmp    e88 <main+0x26>
		  doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10be:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	68 df 21 00 00       	push   $0x21df
    10c7:	6a 01                	push   $0x1
    10c9:	e8 8a 04 00 00       	call   1558 <printf>
    10ce:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10d1:	83 ec 0c             	sub    $0xc,%esp
    10d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10d7:	50                   	push   %eax
    10d8:	e8 0c 06 00 00       	call   16e9 <free>
    10dd:	83 c4 10             	add    $0x10,%esp
  exit();
    10e0:	e8 9c 02 00 00       	call   1381 <exit>

000010e5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10e5:	55                   	push   %ebp
    10e6:	89 e5                	mov    %esp,%ebp
    10e8:	57                   	push   %edi
    10e9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10ed:	8b 55 10             	mov    0x10(%ebp),%edx
    10f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f3:	89 cb                	mov    %ecx,%ebx
    10f5:	89 df                	mov    %ebx,%edi
    10f7:	89 d1                	mov    %edx,%ecx
    10f9:	fc                   	cld    
    10fa:	f3 aa                	rep stos %al,%es:(%edi)
    10fc:	89 ca                	mov    %ecx,%edx
    10fe:	89 fb                	mov    %edi,%ebx
    1100:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1103:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1106:	90                   	nop
    1107:	5b                   	pop    %ebx
    1108:	5f                   	pop    %edi
    1109:	5d                   	pop    %ebp
    110a:	c3                   	ret    

0000110b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    110b:	55                   	push   %ebp
    110c:	89 e5                	mov    %esp,%ebp
    110e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1117:	90                   	nop
    1118:	8b 45 08             	mov    0x8(%ebp),%eax
    111b:	8d 50 01             	lea    0x1(%eax),%edx
    111e:	89 55 08             	mov    %edx,0x8(%ebp)
    1121:	8b 55 0c             	mov    0xc(%ebp),%edx
    1124:	8d 4a 01             	lea    0x1(%edx),%ecx
    1127:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    112a:	0f b6 12             	movzbl (%edx),%edx
    112d:	88 10                	mov    %dl,(%eax)
    112f:	0f b6 00             	movzbl (%eax),%eax
    1132:	84 c0                	test   %al,%al
    1134:	75 e2                	jne    1118 <strcpy+0xd>
    ;
  return os;
    1136:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1139:	c9                   	leave  
    113a:	c3                   	ret    

0000113b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    113b:	55                   	push   %ebp
    113c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    113e:	eb 08                	jmp    1148 <strcmp+0xd>
    p++, q++;
    1140:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1144:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	0f b6 00             	movzbl (%eax),%eax
    114e:	84 c0                	test   %al,%al
    1150:	74 10                	je     1162 <strcmp+0x27>
    1152:	8b 45 08             	mov    0x8(%ebp),%eax
    1155:	0f b6 10             	movzbl (%eax),%edx
    1158:	8b 45 0c             	mov    0xc(%ebp),%eax
    115b:	0f b6 00             	movzbl (%eax),%eax
    115e:	38 c2                	cmp    %al,%dl
    1160:	74 de                	je     1140 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1162:	8b 45 08             	mov    0x8(%ebp),%eax
    1165:	0f b6 00             	movzbl (%eax),%eax
    1168:	0f b6 d0             	movzbl %al,%edx
    116b:	8b 45 0c             	mov    0xc(%ebp),%eax
    116e:	0f b6 00             	movzbl (%eax),%eax
    1171:	0f b6 c0             	movzbl %al,%eax
    1174:	29 c2                	sub    %eax,%edx
    1176:	89 d0                	mov    %edx,%eax
}
    1178:	5d                   	pop    %ebp
    1179:	c3                   	ret    

0000117a <strlen>:

uint
strlen(char *s)
{
    117a:	55                   	push   %ebp
    117b:	89 e5                	mov    %esp,%ebp
    117d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1187:	eb 04                	jmp    118d <strlen+0x13>
    1189:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    118d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	01 d0                	add    %edx,%eax
    1195:	0f b6 00             	movzbl (%eax),%eax
    1198:	84 c0                	test   %al,%al
    119a:	75 ed                	jne    1189 <strlen+0xf>
    ;
  return n;
    119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11a4:	8b 45 10             	mov    0x10(%ebp),%eax
    11a7:	50                   	push   %eax
    11a8:	ff 75 0c             	pushl  0xc(%ebp)
    11ab:	ff 75 08             	pushl  0x8(%ebp)
    11ae:	e8 32 ff ff ff       	call   10e5 <stosb>
    11b3:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11b9:	c9                   	leave  
    11ba:	c3                   	ret    

000011bb <strchr>:

char*
strchr(const char *s, char c)
{
    11bb:	55                   	push   %ebp
    11bc:	89 e5                	mov    %esp,%ebp
    11be:	83 ec 04             	sub    $0x4,%esp
    11c1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11c7:	eb 14                	jmp    11dd <strchr+0x22>
    if(*s == c)
    11c9:	8b 45 08             	mov    0x8(%ebp),%eax
    11cc:	0f b6 00             	movzbl (%eax),%eax
    11cf:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11d2:	75 05                	jne    11d9 <strchr+0x1e>
      return (char*)s;
    11d4:	8b 45 08             	mov    0x8(%ebp),%eax
    11d7:	eb 13                	jmp    11ec <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
    11e0:	0f b6 00             	movzbl (%eax),%eax
    11e3:	84 c0                	test   %al,%al
    11e5:	75 e2                	jne    11c9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11ec:	c9                   	leave  
    11ed:	c3                   	ret    

000011ee <gets>:

char*
gets(char *buf, int max)
{
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11fb:	eb 42                	jmp    123f <gets+0x51>
    cc = read(0, &c, 1);
    11fd:	83 ec 04             	sub    $0x4,%esp
    1200:	6a 01                	push   $0x1
    1202:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1205:	50                   	push   %eax
    1206:	6a 00                	push   $0x0
    1208:	e8 8c 01 00 00       	call   1399 <read>
    120d:	83 c4 10             	add    $0x10,%esp
    1210:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1213:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1217:	7e 33                	jle    124c <gets+0x5e>
      break;
    buf[i++] = c;
    1219:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121c:	8d 50 01             	lea    0x1(%eax),%edx
    121f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1222:	89 c2                	mov    %eax,%edx
    1224:	8b 45 08             	mov    0x8(%ebp),%eax
    1227:	01 c2                	add    %eax,%edx
    1229:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    122d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    122f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1233:	3c 0a                	cmp    $0xa,%al
    1235:	74 16                	je     124d <gets+0x5f>
    1237:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    123b:	3c 0d                	cmp    $0xd,%al
    123d:	74 0e                	je     124d <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1242:	83 c0 01             	add    $0x1,%eax
    1245:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1248:	7c b3                	jl     11fd <gets+0xf>
    124a:	eb 01                	jmp    124d <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    124c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	01 d0                	add    %edx,%eax
    1255:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1258:	8b 45 08             	mov    0x8(%ebp),%eax
}
    125b:	c9                   	leave  
    125c:	c3                   	ret    

0000125d <stat>:

int
stat(char *n, struct stat *st)
{
    125d:	55                   	push   %ebp
    125e:	89 e5                	mov    %esp,%ebp
    1260:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1263:	83 ec 08             	sub    $0x8,%esp
    1266:	6a 00                	push   $0x0
    1268:	ff 75 08             	pushl  0x8(%ebp)
    126b:	e8 51 01 00 00       	call   13c1 <open>
    1270:	83 c4 10             	add    $0x10,%esp
    1273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    127a:	79 07                	jns    1283 <stat+0x26>
    return -1;
    127c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1281:	eb 25                	jmp    12a8 <stat+0x4b>
  r = fstat(fd, st);
    1283:	83 ec 08             	sub    $0x8,%esp
    1286:	ff 75 0c             	pushl  0xc(%ebp)
    1289:	ff 75 f4             	pushl  -0xc(%ebp)
    128c:	e8 48 01 00 00       	call   13d9 <fstat>
    1291:	83 c4 10             	add    $0x10,%esp
    1294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1297:	83 ec 0c             	sub    $0xc,%esp
    129a:	ff 75 f4             	pushl  -0xc(%ebp)
    129d:	e8 07 01 00 00       	call   13a9 <close>
    12a2:	83 c4 10             	add    $0x10,%esp
  return r;
    12a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12a8:	c9                   	leave  
    12a9:	c3                   	ret    

000012aa <atoi>:

int
atoi(const char *s)
{
    12aa:	55                   	push   %ebp
    12ab:	89 e5                	mov    %esp,%ebp
    12ad:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    12b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    12b7:	eb 04                	jmp    12bd <atoi+0x13>
    12b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12bd:	8b 45 08             	mov    0x8(%ebp),%eax
    12c0:	0f b6 00             	movzbl (%eax),%eax
    12c3:	3c 20                	cmp    $0x20,%al
    12c5:	74 f2                	je     12b9 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ca:	0f b6 00             	movzbl (%eax),%eax
    12cd:	3c 2d                	cmp    $0x2d,%al
    12cf:	75 07                	jne    12d8 <atoi+0x2e>
    12d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12d6:	eb 05                	jmp    12dd <atoi+0x33>
    12d8:	b8 01 00 00 00       	mov    $0x1,%eax
    12dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    12e0:	8b 45 08             	mov    0x8(%ebp),%eax
    12e3:	0f b6 00             	movzbl (%eax),%eax
    12e6:	3c 2b                	cmp    $0x2b,%al
    12e8:	74 0a                	je     12f4 <atoi+0x4a>
    12ea:	8b 45 08             	mov    0x8(%ebp),%eax
    12ed:	0f b6 00             	movzbl (%eax),%eax
    12f0:	3c 2d                	cmp    $0x2d,%al
    12f2:	75 2b                	jne    131f <atoi+0x75>
    s++;
    12f4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    12f8:	eb 25                	jmp    131f <atoi+0x75>
    n = n*10 + *s++ - '0';
    12fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12fd:	89 d0                	mov    %edx,%eax
    12ff:	c1 e0 02             	shl    $0x2,%eax
    1302:	01 d0                	add    %edx,%eax
    1304:	01 c0                	add    %eax,%eax
    1306:	89 c1                	mov    %eax,%ecx
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	8d 50 01             	lea    0x1(%eax),%edx
    130e:	89 55 08             	mov    %edx,0x8(%ebp)
    1311:	0f b6 00             	movzbl (%eax),%eax
    1314:	0f be c0             	movsbl %al,%eax
    1317:	01 c8                	add    %ecx,%eax
    1319:	83 e8 30             	sub    $0x30,%eax
    131c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    131f:	8b 45 08             	mov    0x8(%ebp),%eax
    1322:	0f b6 00             	movzbl (%eax),%eax
    1325:	3c 2f                	cmp    $0x2f,%al
    1327:	7e 0a                	jle    1333 <atoi+0x89>
    1329:	8b 45 08             	mov    0x8(%ebp),%eax
    132c:	0f b6 00             	movzbl (%eax),%eax
    132f:	3c 39                	cmp    $0x39,%al
    1331:	7e c7                	jle    12fa <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    1333:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1336:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    133a:	c9                   	leave  
    133b:	c3                   	ret    

0000133c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    133c:	55                   	push   %ebp
    133d:	89 e5                	mov    %esp,%ebp
    133f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1342:	8b 45 08             	mov    0x8(%ebp),%eax
    1345:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1348:	8b 45 0c             	mov    0xc(%ebp),%eax
    134b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    134e:	eb 17                	jmp    1367 <memmove+0x2b>
    *dst++ = *src++;
    1350:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1353:	8d 50 01             	lea    0x1(%eax),%edx
    1356:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1359:	8b 55 f8             	mov    -0x8(%ebp),%edx
    135c:	8d 4a 01             	lea    0x1(%edx),%ecx
    135f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1362:	0f b6 12             	movzbl (%edx),%edx
    1365:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1367:	8b 45 10             	mov    0x10(%ebp),%eax
    136a:	8d 50 ff             	lea    -0x1(%eax),%edx
    136d:	89 55 10             	mov    %edx,0x10(%ebp)
    1370:	85 c0                	test   %eax,%eax
    1372:	7f dc                	jg     1350 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1374:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1377:	c9                   	leave  
    1378:	c3                   	ret    

00001379 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1379:	b8 01 00 00 00       	mov    $0x1,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <exit>:
SYSCALL(exit)
    1381:	b8 02 00 00 00       	mov    $0x2,%eax
    1386:	cd 40                	int    $0x40
    1388:	c3                   	ret    

00001389 <wait>:
SYSCALL(wait)
    1389:	b8 03 00 00 00       	mov    $0x3,%eax
    138e:	cd 40                	int    $0x40
    1390:	c3                   	ret    

00001391 <pipe>:
SYSCALL(pipe)
    1391:	b8 04 00 00 00       	mov    $0x4,%eax
    1396:	cd 40                	int    $0x40
    1398:	c3                   	ret    

00001399 <read>:
SYSCALL(read)
    1399:	b8 05 00 00 00       	mov    $0x5,%eax
    139e:	cd 40                	int    $0x40
    13a0:	c3                   	ret    

000013a1 <write>:
SYSCALL(write)
    13a1:	b8 10 00 00 00       	mov    $0x10,%eax
    13a6:	cd 40                	int    $0x40
    13a8:	c3                   	ret    

000013a9 <close>:
SYSCALL(close)
    13a9:	b8 15 00 00 00       	mov    $0x15,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <kill>:
SYSCALL(kill)
    13b1:	b8 06 00 00 00       	mov    $0x6,%eax
    13b6:	cd 40                	int    $0x40
    13b8:	c3                   	ret    

000013b9 <exec>:
SYSCALL(exec)
    13b9:	b8 07 00 00 00       	mov    $0x7,%eax
    13be:	cd 40                	int    $0x40
    13c0:	c3                   	ret    

000013c1 <open>:
SYSCALL(open)
    13c1:	b8 0f 00 00 00       	mov    $0xf,%eax
    13c6:	cd 40                	int    $0x40
    13c8:	c3                   	ret    

000013c9 <mknod>:
SYSCALL(mknod)
    13c9:	b8 11 00 00 00       	mov    $0x11,%eax
    13ce:	cd 40                	int    $0x40
    13d0:	c3                   	ret    

000013d1 <unlink>:
SYSCALL(unlink)
    13d1:	b8 12 00 00 00       	mov    $0x12,%eax
    13d6:	cd 40                	int    $0x40
    13d8:	c3                   	ret    

000013d9 <fstat>:
SYSCALL(fstat)
    13d9:	b8 08 00 00 00       	mov    $0x8,%eax
    13de:	cd 40                	int    $0x40
    13e0:	c3                   	ret    

000013e1 <link>:
SYSCALL(link)
    13e1:	b8 13 00 00 00       	mov    $0x13,%eax
    13e6:	cd 40                	int    $0x40
    13e8:	c3                   	ret    

000013e9 <mkdir>:
SYSCALL(mkdir)
    13e9:	b8 14 00 00 00       	mov    $0x14,%eax
    13ee:	cd 40                	int    $0x40
    13f0:	c3                   	ret    

000013f1 <chdir>:
SYSCALL(chdir)
    13f1:	b8 09 00 00 00       	mov    $0x9,%eax
    13f6:	cd 40                	int    $0x40
    13f8:	c3                   	ret    

000013f9 <dup>:
SYSCALL(dup)
    13f9:	b8 0a 00 00 00       	mov    $0xa,%eax
    13fe:	cd 40                	int    $0x40
    1400:	c3                   	ret    

00001401 <getpid>:
SYSCALL(getpid)
    1401:	b8 0b 00 00 00       	mov    $0xb,%eax
    1406:	cd 40                	int    $0x40
    1408:	c3                   	ret    

00001409 <sbrk>:
SYSCALL(sbrk)
    1409:	b8 0c 00 00 00       	mov    $0xc,%eax
    140e:	cd 40                	int    $0x40
    1410:	c3                   	ret    

00001411 <sleep>:
SYSCALL(sleep)
    1411:	b8 0d 00 00 00       	mov    $0xd,%eax
    1416:	cd 40                	int    $0x40
    1418:	c3                   	ret    

00001419 <uptime>:
SYSCALL(uptime)
    1419:	b8 0e 00 00 00       	mov    $0xe,%eax
    141e:	cd 40                	int    $0x40
    1420:	c3                   	ret    

00001421 <halt>:
SYSCALL(halt)
    1421:	b8 16 00 00 00       	mov    $0x16,%eax
    1426:	cd 40                	int    $0x40
    1428:	c3                   	ret    

00001429 <date>:
SYSCALL(date)
    1429:	b8 17 00 00 00       	mov    $0x17,%eax
    142e:	cd 40                	int    $0x40
    1430:	c3                   	ret    

00001431 <getuid>:
SYSCALL(getuid)
    1431:	b8 18 00 00 00       	mov    $0x18,%eax
    1436:	cd 40                	int    $0x40
    1438:	c3                   	ret    

00001439 <getgid>:
SYSCALL(getgid)
    1439:	b8 19 00 00 00       	mov    $0x19,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <getppid>:
SYSCALL(getppid)
    1441:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <setuid>:
SYSCALL(setuid)
    1449:	b8 1b 00 00 00       	mov    $0x1b,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <setgid>:
SYSCALL(setgid)
    1451:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <getprocs>:
SYSCALL(getprocs)
    1459:	b8 1d 00 00 00       	mov    $0x1d,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <setpriority>:
SYSCALL(setpriority)
    1461:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1466:	cd 40                	int    $0x40
    1468:	c3                   	ret    

00001469 <chmod>:
SYSCALL(chmod)
    1469:	b8 1f 00 00 00       	mov    $0x1f,%eax
    146e:	cd 40                	int    $0x40
    1470:	c3                   	ret    

00001471 <chown>:
SYSCALL(chown)
    1471:	b8 20 00 00 00       	mov    $0x20,%eax
    1476:	cd 40                	int    $0x40
    1478:	c3                   	ret    

00001479 <chgrp>:
SYSCALL(chgrp)    
    1479:	b8 21 00 00 00       	mov    $0x21,%eax
    147e:	cd 40                	int    $0x40
    1480:	c3                   	ret    

00001481 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1481:	55                   	push   %ebp
    1482:	89 e5                	mov    %esp,%ebp
    1484:	83 ec 18             	sub    $0x18,%esp
    1487:	8b 45 0c             	mov    0xc(%ebp),%eax
    148a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    148d:	83 ec 04             	sub    $0x4,%esp
    1490:	6a 01                	push   $0x1
    1492:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1495:	50                   	push   %eax
    1496:	ff 75 08             	pushl  0x8(%ebp)
    1499:	e8 03 ff ff ff       	call   13a1 <write>
    149e:	83 c4 10             	add    $0x10,%esp
}
    14a1:	90                   	nop
    14a2:	c9                   	leave  
    14a3:	c3                   	ret    

000014a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14a4:	55                   	push   %ebp
    14a5:	89 e5                	mov    %esp,%ebp
    14a7:	53                   	push   %ebx
    14a8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    14b6:	74 17                	je     14cf <printint+0x2b>
    14b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14bc:	79 11                	jns    14cf <printint+0x2b>
    neg = 1;
    14be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14c8:	f7 d8                	neg    %eax
    14ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14cd:	eb 06                	jmp    14d5 <printint+0x31>
  } else {
    x = xx;
    14cf:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14df:	8d 41 01             	lea    0x1(%ecx),%eax
    14e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14eb:	ba 00 00 00 00       	mov    $0x0,%edx
    14f0:	f7 f3                	div    %ebx
    14f2:	89 d0                	mov    %edx,%eax
    14f4:	0f b6 80 00 26 00 00 	movzbl 0x2600(%eax),%eax
    14fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1502:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1505:	ba 00 00 00 00       	mov    $0x0,%edx
    150a:	f7 f3                	div    %ebx
    150c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    150f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1513:	75 c7                	jne    14dc <printint+0x38>
  if(neg)
    1515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1519:	74 2d                	je     1548 <printint+0xa4>
    buf[i++] = '-';
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	8d 50 01             	lea    0x1(%eax),%edx
    1521:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1524:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1529:	eb 1d                	jmp    1548 <printint+0xa4>
    putc(fd, buf[i]);
    152b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    152e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1531:	01 d0                	add    %edx,%eax
    1533:	0f b6 00             	movzbl (%eax),%eax
    1536:	0f be c0             	movsbl %al,%eax
    1539:	83 ec 08             	sub    $0x8,%esp
    153c:	50                   	push   %eax
    153d:	ff 75 08             	pushl  0x8(%ebp)
    1540:	e8 3c ff ff ff       	call   1481 <putc>
    1545:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1548:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    154c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1550:	79 d9                	jns    152b <printint+0x87>
    putc(fd, buf[i]);
}
    1552:	90                   	nop
    1553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1556:	c9                   	leave  
    1557:	c3                   	ret    

00001558 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1558:	55                   	push   %ebp
    1559:	89 e5                	mov    %esp,%ebp
    155b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    155e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1565:	8d 45 0c             	lea    0xc(%ebp),%eax
    1568:	83 c0 04             	add    $0x4,%eax
    156b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    156e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1575:	e9 59 01 00 00       	jmp    16d3 <printf+0x17b>
    c = fmt[i] & 0xff;
    157a:	8b 55 0c             	mov    0xc(%ebp),%edx
    157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1580:	01 d0                	add    %edx,%eax
    1582:	0f b6 00             	movzbl (%eax),%eax
    1585:	0f be c0             	movsbl %al,%eax
    1588:	25 ff 00 00 00       	and    $0xff,%eax
    158d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1594:	75 2c                	jne    15c2 <printf+0x6a>
      if(c == '%'){
    1596:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    159a:	75 0c                	jne    15a8 <printf+0x50>
        state = '%';
    159c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15a3:	e9 27 01 00 00       	jmp    16cf <printf+0x177>
      } else {
        putc(fd, c);
    15a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15ab:	0f be c0             	movsbl %al,%eax
    15ae:	83 ec 08             	sub    $0x8,%esp
    15b1:	50                   	push   %eax
    15b2:	ff 75 08             	pushl  0x8(%ebp)
    15b5:	e8 c7 fe ff ff       	call   1481 <putc>
    15ba:	83 c4 10             	add    $0x10,%esp
    15bd:	e9 0d 01 00 00       	jmp    16cf <printf+0x177>
      }
    } else if(state == '%'){
    15c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15c6:	0f 85 03 01 00 00    	jne    16cf <printf+0x177>
      if(c == 'd'){
    15cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15d0:	75 1e                	jne    15f0 <printf+0x98>
        printint(fd, *ap, 10, 1);
    15d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15d5:	8b 00                	mov    (%eax),%eax
    15d7:	6a 01                	push   $0x1
    15d9:	6a 0a                	push   $0xa
    15db:	50                   	push   %eax
    15dc:	ff 75 08             	pushl  0x8(%ebp)
    15df:	e8 c0 fe ff ff       	call   14a4 <printint>
    15e4:	83 c4 10             	add    $0x10,%esp
        ap++;
    15e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15eb:	e9 d8 00 00 00       	jmp    16c8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    15f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15f4:	74 06                	je     15fc <printf+0xa4>
    15f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15fa:	75 1e                	jne    161a <printf+0xc2>
        printint(fd, *ap, 16, 0);
    15fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15ff:	8b 00                	mov    (%eax),%eax
    1601:	6a 00                	push   $0x0
    1603:	6a 10                	push   $0x10
    1605:	50                   	push   %eax
    1606:	ff 75 08             	pushl  0x8(%ebp)
    1609:	e8 96 fe ff ff       	call   14a4 <printint>
    160e:	83 c4 10             	add    $0x10,%esp
        ap++;
    1611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1615:	e9 ae 00 00 00       	jmp    16c8 <printf+0x170>
      } else if(c == 's'){
    161a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    161e:	75 43                	jne    1663 <printf+0x10b>
        s = (char*)*ap;
    1620:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1623:	8b 00                	mov    (%eax),%eax
    1625:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1628:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    162c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1630:	75 25                	jne    1657 <printf+0xff>
          s = "(null)";
    1632:	c7 45 f4 10 22 00 00 	movl   $0x2210,-0xc(%ebp)
        while(*s != 0){
    1639:	eb 1c                	jmp    1657 <printf+0xff>
          putc(fd, *s);
    163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163e:	0f b6 00             	movzbl (%eax),%eax
    1641:	0f be c0             	movsbl %al,%eax
    1644:	83 ec 08             	sub    $0x8,%esp
    1647:	50                   	push   %eax
    1648:	ff 75 08             	pushl  0x8(%ebp)
    164b:	e8 31 fe ff ff       	call   1481 <putc>
    1650:	83 c4 10             	add    $0x10,%esp
          s++;
    1653:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1657:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165a:	0f b6 00             	movzbl (%eax),%eax
    165d:	84 c0                	test   %al,%al
    165f:	75 da                	jne    163b <printf+0xe3>
    1661:	eb 65                	jmp    16c8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1663:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1667:	75 1d                	jne    1686 <printf+0x12e>
        putc(fd, *ap);
    1669:	8b 45 e8             	mov    -0x18(%ebp),%eax
    166c:	8b 00                	mov    (%eax),%eax
    166e:	0f be c0             	movsbl %al,%eax
    1671:	83 ec 08             	sub    $0x8,%esp
    1674:	50                   	push   %eax
    1675:	ff 75 08             	pushl  0x8(%ebp)
    1678:	e8 04 fe ff ff       	call   1481 <putc>
    167d:	83 c4 10             	add    $0x10,%esp
        ap++;
    1680:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1684:	eb 42                	jmp    16c8 <printf+0x170>
      } else if(c == '%'){
    1686:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    168a:	75 17                	jne    16a3 <printf+0x14b>
        putc(fd, c);
    168c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168f:	0f be c0             	movsbl %al,%eax
    1692:	83 ec 08             	sub    $0x8,%esp
    1695:	50                   	push   %eax
    1696:	ff 75 08             	pushl  0x8(%ebp)
    1699:	e8 e3 fd ff ff       	call   1481 <putc>
    169e:	83 c4 10             	add    $0x10,%esp
    16a1:	eb 25                	jmp    16c8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16a3:	83 ec 08             	sub    $0x8,%esp
    16a6:	6a 25                	push   $0x25
    16a8:	ff 75 08             	pushl  0x8(%ebp)
    16ab:	e8 d1 fd ff ff       	call   1481 <putc>
    16b0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    16b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b6:	0f be c0             	movsbl %al,%eax
    16b9:	83 ec 08             	sub    $0x8,%esp
    16bc:	50                   	push   %eax
    16bd:	ff 75 08             	pushl  0x8(%ebp)
    16c0:	e8 bc fd ff ff       	call   1481 <putc>
    16c5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    16c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d3:	8b 55 0c             	mov    0xc(%ebp),%edx
    16d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d9:	01 d0                	add    %edx,%eax
    16db:	0f b6 00             	movzbl (%eax),%eax
    16de:	84 c0                	test   %al,%al
    16e0:	0f 85 94 fe ff ff    	jne    157a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16e6:	90                   	nop
    16e7:	c9                   	leave  
    16e8:	c3                   	ret    

000016e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16e9:	55                   	push   %ebp
    16ea:	89 e5                	mov    %esp,%ebp
    16ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16ef:	8b 45 08             	mov    0x8(%ebp),%eax
    16f2:	83 e8 08             	sub    $0x8,%eax
    16f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f8:	a1 1c 26 00 00       	mov    0x261c,%eax
    16fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1700:	eb 24                	jmp    1726 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1702:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1705:	8b 00                	mov    (%eax),%eax
    1707:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170a:	77 12                	ja     171e <free+0x35>
    170c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1712:	77 24                	ja     1738 <free+0x4f>
    1714:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1717:	8b 00                	mov    (%eax),%eax
    1719:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    171c:	77 1a                	ja     1738 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1721:	8b 00                	mov    (%eax),%eax
    1723:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1726:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1729:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    172c:	76 d4                	jbe    1702 <free+0x19>
    172e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1731:	8b 00                	mov    (%eax),%eax
    1733:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1736:	76 ca                	jbe    1702 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1738:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173b:	8b 40 04             	mov    0x4(%eax),%eax
    173e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1745:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1748:	01 c2                	add    %eax,%edx
    174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174d:	8b 00                	mov    (%eax),%eax
    174f:	39 c2                	cmp    %eax,%edx
    1751:	75 24                	jne    1777 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1753:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1756:	8b 50 04             	mov    0x4(%eax),%edx
    1759:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175c:	8b 00                	mov    (%eax),%eax
    175e:	8b 40 04             	mov    0x4(%eax),%eax
    1761:	01 c2                	add    %eax,%edx
    1763:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1766:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1769:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176c:	8b 00                	mov    (%eax),%eax
    176e:	8b 10                	mov    (%eax),%edx
    1770:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1773:	89 10                	mov    %edx,(%eax)
    1775:	eb 0a                	jmp    1781 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1777:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177a:	8b 10                	mov    (%eax),%edx
    177c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    177f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1781:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1784:	8b 40 04             	mov    0x4(%eax),%eax
    1787:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    178e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1791:	01 d0                	add    %edx,%eax
    1793:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1796:	75 20                	jne    17b8 <free+0xcf>
    p->s.size += bp->s.size;
    1798:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179b:	8b 50 04             	mov    0x4(%eax),%edx
    179e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a1:	8b 40 04             	mov    0x4(%eax),%eax
    17a4:	01 c2                	add    %eax,%edx
    17a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17af:	8b 10                	mov    (%eax),%edx
    17b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b4:	89 10                	mov    %edx,(%eax)
    17b6:	eb 08                	jmp    17c0 <free+0xd7>
  } else
    p->s.ptr = bp;
    17b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17be:	89 10                	mov    %edx,(%eax)
  freep = p;
    17c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c3:	a3 1c 26 00 00       	mov    %eax,0x261c
}
    17c8:	90                   	nop
    17c9:	c9                   	leave  
    17ca:	c3                   	ret    

000017cb <morecore>:

static Header*
morecore(uint nu)
{
    17cb:	55                   	push   %ebp
    17cc:	89 e5                	mov    %esp,%ebp
    17ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17d8:	77 07                	ja     17e1 <morecore+0x16>
    nu = 4096;
    17da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17e1:	8b 45 08             	mov    0x8(%ebp),%eax
    17e4:	c1 e0 03             	shl    $0x3,%eax
    17e7:	83 ec 0c             	sub    $0xc,%esp
    17ea:	50                   	push   %eax
    17eb:	e8 19 fc ff ff       	call   1409 <sbrk>
    17f0:	83 c4 10             	add    $0x10,%esp
    17f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17fa:	75 07                	jne    1803 <morecore+0x38>
    return 0;
    17fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1801:	eb 26                	jmp    1829 <morecore+0x5e>
  hp = (Header*)p;
    1803:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1809:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180c:	8b 55 08             	mov    0x8(%ebp),%edx
    180f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1812:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1815:	83 c0 08             	add    $0x8,%eax
    1818:	83 ec 0c             	sub    $0xc,%esp
    181b:	50                   	push   %eax
    181c:	e8 c8 fe ff ff       	call   16e9 <free>
    1821:	83 c4 10             	add    $0x10,%esp
  return freep;
    1824:	a1 1c 26 00 00       	mov    0x261c,%eax
}
    1829:	c9                   	leave  
    182a:	c3                   	ret    

0000182b <malloc>:

void*
malloc(uint nbytes)
{
    182b:	55                   	push   %ebp
    182c:	89 e5                	mov    %esp,%ebp
    182e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1831:	8b 45 08             	mov    0x8(%ebp),%eax
    1834:	83 c0 07             	add    $0x7,%eax
    1837:	c1 e8 03             	shr    $0x3,%eax
    183a:	83 c0 01             	add    $0x1,%eax
    183d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1840:	a1 1c 26 00 00       	mov    0x261c,%eax
    1845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    184c:	75 23                	jne    1871 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    184e:	c7 45 f0 14 26 00 00 	movl   $0x2614,-0x10(%ebp)
    1855:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1858:	a3 1c 26 00 00       	mov    %eax,0x261c
    185d:	a1 1c 26 00 00       	mov    0x261c,%eax
    1862:	a3 14 26 00 00       	mov    %eax,0x2614
    base.s.size = 0;
    1867:	c7 05 18 26 00 00 00 	movl   $0x0,0x2618
    186e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1871:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1874:	8b 00                	mov    (%eax),%eax
    1876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1879:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187c:	8b 40 04             	mov    0x4(%eax),%eax
    187f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1882:	72 4d                	jb     18d1 <malloc+0xa6>
      if(p->s.size == nunits)
    1884:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1887:	8b 40 04             	mov    0x4(%eax),%eax
    188a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    188d:	75 0c                	jne    189b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1892:	8b 10                	mov    (%eax),%edx
    1894:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1897:	89 10                	mov    %edx,(%eax)
    1899:	eb 26                	jmp    18c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189e:	8b 40 04             	mov    0x4(%eax),%eax
    18a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18a4:	89 c2                	mov    %eax,%edx
    18a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18af:	8b 40 04             	mov    0x4(%eax),%eax
    18b2:	c1 e0 03             	shl    $0x3,%eax
    18b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c4:	a3 1c 26 00 00       	mov    %eax,0x261c
      return (void*)(p + 1);
    18c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cc:	83 c0 08             	add    $0x8,%eax
    18cf:	eb 3b                	jmp    190c <malloc+0xe1>
    }
    if(p == freep)
    18d1:	a1 1c 26 00 00       	mov    0x261c,%eax
    18d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18d9:	75 1e                	jne    18f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    18db:	83 ec 0c             	sub    $0xc,%esp
    18de:	ff 75 ec             	pushl  -0x14(%ebp)
    18e1:	e8 e5 fe ff ff       	call   17cb <morecore>
    18e6:	83 c4 10             	add    $0x10,%esp
    18e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18f0:	75 07                	jne    18f9 <malloc+0xce>
        return 0;
    18f2:	b8 00 00 00 00       	mov    $0x0,%eax
    18f7:	eb 13                	jmp    190c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1902:	8b 00                	mov    (%eax),%eax
    1904:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1907:	e9 6d ff ff ff       	jmp    1879 <malloc+0x4e>
}
    190c:	c9                   	leave  
    190d:	c3                   	ret    
