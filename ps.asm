
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

static void tickasfloat(uint);

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp

  struct uproc * utable;  
  int max = 72;
  14:	c7 45 e0 48 00 00 00 	movl   $0x48,-0x20(%ebp)
  int uprocsize;
  utable = (struct uproc *) malloc(sizeof(struct uproc) * max);
  1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1e:	89 d0                	mov    %edx,%eax
  20:	01 c0                	add    %eax,%eax
  22:	01 d0                	add    %edx,%eax
  24:	c1 e0 05             	shl    $0x5,%eax
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	50                   	push   %eax
  2b:	e8 7e 09 00 00       	call   9ae <malloc>
  30:	83 c4 10             	add    $0x10,%esp
  33:	89 45 dc             	mov    %eax,-0x24(%ebp)

  uprocsize = getprocs(max, utable);
  36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	ff 75 dc             	pushl  -0x24(%ebp)
  3f:	50                   	push   %eax
  40:	e8 97 05 00 00       	call   5dc <getprocs>
  45:	83 c4 10             	add    $0x10,%esp
  48:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(uprocsize >= 0)
  4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  4f:	0f 88 4e 01 00 00    	js     1a3 <main+0x1a3>
  {
#ifdef CS333_P3P4
      printf(2, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  55:	83 ec 08             	sub    $0x8,%esp
  58:	68 94 0a 00 00       	push   $0xa94
  5d:	6a 02                	push   $0x2
  5f:	e8 77 06 00 00       	call   6db <printf>
  64:	83 c4 10             	add    $0x10,%esp
#else
      printf(2, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
#endif
      for(int i = 0; i < uprocsize; ++i)
  67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6e:	e9 22 01 00 00       	jmp    195 <main+0x195>
      {
#ifdef CS333_P3P4
          printf(2, "%d\t%s\t%d\t%d\t%d\t%d\t", utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
  73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  76:	89 d0                	mov    %edx,%eax
  78:	01 c0                	add    %eax,%eax
  7a:	01 d0                	add    %edx,%eax
  7c:	c1 e0 05             	shl    $0x5,%eax
  7f:	89 c2                	mov    %eax,%edx
  81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  84:	01 d0                	add    %edx,%eax
  86:	8b 78 5c             	mov    0x5c(%eax),%edi
  89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8c:	89 d0                	mov    %edx,%eax
  8e:	01 c0                	add    %eax,%eax
  90:	01 d0                	add    %edx,%eax
  92:	c1 e0 05             	shl    $0x5,%eax
  95:	89 c2                	mov    %eax,%edx
  97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  9a:	01 d0                	add    %edx,%eax
  9c:	8b 70 0c             	mov    0xc(%eax),%esi
  9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a2:	89 d0                	mov    %edx,%eax
  a4:	01 c0                	add    %eax,%eax
  a6:	01 d0                	add    %edx,%eax
  a8:	c1 e0 05             	shl    $0x5,%eax
  ab:	89 c2                	mov    %eax,%edx
  ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b0:	01 d0                	add    %edx,%eax
  b2:	8b 58 08             	mov    0x8(%eax),%ebx
  b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  b8:	89 d0                	mov    %edx,%eax
  ba:	01 c0                	add    %eax,%eax
  bc:	01 d0                	add    %edx,%eax
  be:	c1 e0 05             	shl    $0x5,%eax
  c1:	89 c2                	mov    %eax,%edx
  c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  c6:	01 d0                	add    %edx,%eax
  c8:	8b 48 04             	mov    0x4(%eax),%ecx
  cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ce:	89 d0                	mov    %edx,%eax
  d0:	01 c0                	add    %eax,%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	c1 e0 05             	shl    $0x5,%eax
  d7:	89 c2                	mov    %eax,%edx
  d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  dc:	01 d0                	add    %edx,%eax
  de:	83 c0 3c             	add    $0x3c,%eax
  e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  e7:	89 d0                	mov    %edx,%eax
  e9:	01 c0                	add    %eax,%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	c1 e0 05             	shl    $0x5,%eax
  f0:	89 c2                	mov    %eax,%edx
  f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  f5:	01 d0                	add    %edx,%eax
  f7:	8b 00                	mov    (%eax),%eax
  f9:	57                   	push   %edi
  fa:	56                   	push   %esi
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	ff 75 d4             	pushl  -0x2c(%ebp)
 100:	50                   	push   %eax
 101:	68 c7 0a 00 00       	push   $0xac7
 106:	6a 02                	push   $0x2
 108:	e8 ce 05 00 00       	call   6db <printf>
 10d:	83 c4 20             	add    $0x20,%esp
#else
          printf(2, "%d\t%s\t%d\t%d\t%d\t", utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
#endif
          tickasfloat(utable[i].elapsed_ticks);
 110:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 113:	89 d0                	mov    %edx,%eax
 115:	01 c0                	add    %eax,%eax
 117:	01 d0                	add    %edx,%eax
 119:	c1 e0 05             	shl    $0x5,%eax
 11c:	89 c2                	mov    %eax,%edx
 11e:	8b 45 dc             	mov    -0x24(%ebp),%eax
 121:	01 d0                	add    %edx,%eax
 123:	8b 40 10             	mov    0x10(%eax),%eax
 126:	83 ec 0c             	sub    $0xc,%esp
 129:	50                   	push   %eax
 12a:	e8 99 00 00 00       	call   1c8 <tickasfloat>
 12f:	83 c4 10             	add    $0x10,%esp
          tickasfloat(utable[i].CPU_total_ticks);
 132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 135:	89 d0                	mov    %edx,%eax
 137:	01 c0                	add    %eax,%eax
 139:	01 d0                	add    %edx,%eax
 13b:	c1 e0 05             	shl    $0x5,%eax
 13e:	89 c2                	mov    %eax,%edx
 140:	8b 45 dc             	mov    -0x24(%ebp),%eax
 143:	01 d0                	add    %edx,%eax
 145:	8b 40 14             	mov    0x14(%eax),%eax
 148:	83 ec 0c             	sub    $0xc,%esp
 14b:	50                   	push   %eax
 14c:	e8 77 00 00 00       	call   1c8 <tickasfloat>
 151:	83 c4 10             	add    $0x10,%esp
          printf(2, "%s\t%d\n", utable[i].state, utable[i].size);
 154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 157:	89 d0                	mov    %edx,%eax
 159:	01 c0                	add    %eax,%eax
 15b:	01 d0                	add    %edx,%eax
 15d:	c1 e0 05             	shl    $0x5,%eax
 160:	89 c2                	mov    %eax,%edx
 162:	8b 45 dc             	mov    -0x24(%ebp),%eax
 165:	01 d0                	add    %edx,%eax
 167:	8b 48 38             	mov    0x38(%eax),%ecx
 16a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 16d:	89 d0                	mov    %edx,%eax
 16f:	01 c0                	add    %eax,%eax
 171:	01 d0                	add    %edx,%eax
 173:	c1 e0 05             	shl    $0x5,%eax
 176:	89 c2                	mov    %eax,%edx
 178:	8b 45 dc             	mov    -0x24(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	83 c0 18             	add    $0x18,%eax
 180:	51                   	push   %ecx
 181:	50                   	push   %eax
 182:	68 da 0a 00 00       	push   $0xada
 187:	6a 02                	push   $0x2
 189:	e8 4d 05 00 00       	call   6db <printf>
 18e:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
      printf(2, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
#else
      printf(2, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
#endif
      for(int i = 0; i < uprocsize; ++i)
 191:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 198:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 19b:	0f 8c d2 fe ff ff    	jl     73 <main+0x73>
 1a1:	eb 12                	jmp    1b5 <main+0x1b5>
          tickasfloat(utable[i].CPU_total_ticks);
          printf(2, "%s\t%d\n", utable[i].state, utable[i].size);
      }
  }
  else
      printf(2, "Error getting processes\n");
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	68 e1 0a 00 00       	push   $0xae1
 1ab:	6a 02                	push   $0x2
 1ad:	e8 29 05 00 00       	call   6db <printf>
 1b2:	83 c4 10             	add    $0x10,%esp

  free(utable);
 1b5:	83 ec 0c             	sub    $0xc,%esp
 1b8:	ff 75 dc             	pushl  -0x24(%ebp)
 1bb:	e8 ac 06 00 00       	call   86c <free>
 1c0:	83 c4 10             	add    $0x10,%esp
  exit();
 1c3:	e8 3c 03 00 00       	call   504 <exit>

000001c8 <tickasfloat>:
}

static void 
tickasfloat(uint tickcount)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 18             	sub    $0x18,%esp
    uint ticksl = tickcount / 1000;
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1d6:	f7 e2                	mul    %edx
 1d8:	89 d0                	mov    %edx,%eax
 1da:	c1 e8 06             	shr    $0x6,%eax
 1dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ticksr = tickcount % 1000;
 1e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1e8:	89 c8                	mov    %ecx,%eax
 1ea:	f7 e2                	mul    %edx
 1ec:	89 d0                	mov    %edx,%eax
 1ee:	c1 e8 06             	shr    $0x6,%eax
 1f1:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 1f7:	29 c1                	sub    %eax,%ecx
 1f9:	89 c8                	mov    %ecx,%eax
 1fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2,"%d.", ticksl);
 1fe:	83 ec 04             	sub    $0x4,%esp
 201:	ff 75 f4             	pushl  -0xc(%ebp)
 204:	68 fa 0a 00 00       	push   $0xafa
 209:	6a 02                	push   $0x2
 20b:	e8 cb 04 00 00       	call   6db <printf>
 210:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
 213:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 217:	77 1b                	ja     234 <tickasfloat+0x6c>
        printf(2,"%d%d%d\t", 0, 0, ticksr);
 219:	83 ec 0c             	sub    $0xc,%esp
 21c:	ff 75 f0             	pushl  -0x10(%ebp)
 21f:	6a 00                	push   $0x0
 221:	6a 00                	push   $0x0
 223:	68 fe 0a 00 00       	push   $0xafe
 228:	6a 02                	push   $0x2
 22a:	e8 ac 04 00 00       	call   6db <printf>
 22f:	83 c4 20             	add    $0x20,%esp
    else if(ticksr < 100)
        printf(2,"%d%d\t", 0, ticksr);
    else
        printf(2,"%d\t", ticksr);

}
 232:	eb 31                	jmp    265 <tickasfloat+0x9d>
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    printf(2,"%d.", ticksl);
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
 234:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 238:	77 16                	ja     250 <tickasfloat+0x88>
        printf(2,"%d%d\t", 0, ticksr);
 23a:	ff 75 f0             	pushl  -0x10(%ebp)
 23d:	6a 00                	push   $0x0
 23f:	68 06 0b 00 00       	push   $0xb06
 244:	6a 02                	push   $0x2
 246:	e8 90 04 00 00       	call   6db <printf>
 24b:	83 c4 10             	add    $0x10,%esp
    else
        printf(2,"%d\t", ticksr);

}
 24e:	eb 15                	jmp    265 <tickasfloat+0x9d>
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        printf(2,"%d%d\t", 0, ticksr);
    else
        printf(2,"%d\t", ticksr);
 250:	83 ec 04             	sub    $0x4,%esp
 253:	ff 75 f0             	pushl  -0x10(%ebp)
 256:	68 0c 0b 00 00       	push   $0xb0c
 25b:	6a 02                	push   $0x2
 25d:	e8 79 04 00 00       	call   6db <printf>
 262:	83 c4 10             	add    $0x10,%esp

}
 265:	90                   	nop
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	57                   	push   %edi
 26c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 26d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 270:	8b 55 10             	mov    0x10(%ebp),%edx
 273:	8b 45 0c             	mov    0xc(%ebp),%eax
 276:	89 cb                	mov    %ecx,%ebx
 278:	89 df                	mov    %ebx,%edi
 27a:	89 d1                	mov    %edx,%ecx
 27c:	fc                   	cld    
 27d:	f3 aa                	rep stos %al,%es:(%edi)
 27f:	89 ca                	mov    %ecx,%edx
 281:	89 fb                	mov    %edi,%ebx
 283:	89 5d 08             	mov    %ebx,0x8(%ebp)
 286:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 289:	90                   	nop
 28a:	5b                   	pop    %ebx
 28b:	5f                   	pop    %edi
 28c:	5d                   	pop    %ebp
 28d:	c3                   	ret    

0000028e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 29a:	90                   	nop
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	8d 50 01             	lea    0x1(%eax),%edx
 2a1:	89 55 08             	mov    %edx,0x8(%ebp)
 2a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a7:	8d 4a 01             	lea    0x1(%edx),%ecx
 2aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2ad:	0f b6 12             	movzbl (%edx),%edx
 2b0:	88 10                	mov    %dl,(%eax)
 2b2:	0f b6 00             	movzbl (%eax),%eax
 2b5:	84 c0                	test   %al,%al
 2b7:	75 e2                	jne    29b <strcpy+0xd>
    ;
  return os;
 2b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2c1:	eb 08                	jmp    2cb <strcmp+0xd>
    p++, q++;
 2c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 10                	je     2e5 <strcmp+0x27>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 10             	movzbl (%eax),%edx
 2db:	8b 45 0c             	mov    0xc(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	38 c2                	cmp    %al,%dl
 2e3:	74 de                	je     2c3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	0f b6 d0             	movzbl %al,%edx
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	0f b6 c0             	movzbl %al,%eax
 2f7:	29 c2                	sub    %eax,%edx
 2f9:	89 d0                	mov    %edx,%eax
}
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    

000002fd <strlen>:

uint
strlen(char *s)
{
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 303:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 30a:	eb 04                	jmp    310 <strlen+0x13>
 30c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 310:	8b 55 fc             	mov    -0x4(%ebp),%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	01 d0                	add    %edx,%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	84 c0                	test   %al,%al
 31d:	75 ed                	jne    30c <strlen+0xf>
    ;
  return n;
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 322:	c9                   	leave  
 323:	c3                   	ret    

00000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 327:	8b 45 10             	mov    0x10(%ebp),%eax
 32a:	50                   	push   %eax
 32b:	ff 75 0c             	pushl  0xc(%ebp)
 32e:	ff 75 08             	pushl  0x8(%ebp)
 331:	e8 32 ff ff ff       	call   268 <stosb>
 336:	83 c4 0c             	add    $0xc,%esp
  return dst;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33c:	c9                   	leave  
 33d:	c3                   	ret    

0000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	83 ec 04             	sub    $0x4,%esp
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 34a:	eb 14                	jmp    360 <strchr+0x22>
    if(*s == c)
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3a 45 fc             	cmp    -0x4(%ebp),%al
 355:	75 05                	jne    35c <strchr+0x1e>
      return (char*)s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	eb 13                	jmp    36f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 35c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	84 c0                	test   %al,%al
 368:	75 e2                	jne    34c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 36a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <gets>:

char*
gets(char *buf, int max)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 37e:	eb 42                	jmp    3c2 <gets+0x51>
    cc = read(0, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	8d 45 ef             	lea    -0x11(%ebp),%eax
 388:	50                   	push   %eax
 389:	6a 00                	push   $0x0
 38b:	e8 8c 01 00 00       	call   51c <read>
 390:	83 c4 10             	add    $0x10,%esp
 393:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 396:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 39a:	7e 33                	jle    3cf <gets+0x5e>
      break;
    buf[i++] = c;
 39c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39f:	8d 50 01             	lea    0x1(%eax),%edx
 3a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3a5:	89 c2                	mov    %eax,%edx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	01 c2                	add    %eax,%edx
 3ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3b6:	3c 0a                	cmp    $0xa,%al
 3b8:	74 16                	je     3d0 <gets+0x5f>
 3ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3be:	3c 0d                	cmp    $0xd,%al
 3c0:	74 0e                	je     3d0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c5:	83 c0 01             	add    $0x1,%eax
 3c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3cb:	7c b3                	jl     380 <gets+0xf>
 3cd:	eb 01                	jmp    3d0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3cf:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	01 d0                	add    %edx,%eax
 3d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3de:	c9                   	leave  
 3df:	c3                   	ret    

000003e0 <stat>:

int
stat(char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e6:	83 ec 08             	sub    $0x8,%esp
 3e9:	6a 00                	push   $0x0
 3eb:	ff 75 08             	pushl  0x8(%ebp)
 3ee:	e8 51 01 00 00       	call   544 <open>
 3f3:	83 c4 10             	add    $0x10,%esp
 3f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3fd:	79 07                	jns    406 <stat+0x26>
    return -1;
 3ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 404:	eb 25                	jmp    42b <stat+0x4b>
  r = fstat(fd, st);
 406:	83 ec 08             	sub    $0x8,%esp
 409:	ff 75 0c             	pushl  0xc(%ebp)
 40c:	ff 75 f4             	pushl  -0xc(%ebp)
 40f:	e8 48 01 00 00       	call   55c <fstat>
 414:	83 c4 10             	add    $0x10,%esp
 417:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 41a:	83 ec 0c             	sub    $0xc,%esp
 41d:	ff 75 f4             	pushl  -0xc(%ebp)
 420:	e8 07 01 00 00       	call   52c <close>
 425:	83 c4 10             	add    $0x10,%esp
  return r;
 428:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 42b:	c9                   	leave  
 42c:	c3                   	ret    

0000042d <atoi>:

int
atoi(const char *s)
{
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 43a:	eb 04                	jmp    440 <atoi+0x13>
 43c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	0f b6 00             	movzbl (%eax),%eax
 446:	3c 20                	cmp    $0x20,%al
 448:	74 f2                	je     43c <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3c 2d                	cmp    $0x2d,%al
 452:	75 07                	jne    45b <atoi+0x2e>
 454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 459:	eb 05                	jmp    460 <atoi+0x33>
 45b:	b8 01 00 00 00       	mov    $0x1,%eax
 460:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	3c 2b                	cmp    $0x2b,%al
 46b:	74 0a                	je     477 <atoi+0x4a>
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	0f b6 00             	movzbl (%eax),%eax
 473:	3c 2d                	cmp    $0x2d,%al
 475:	75 2b                	jne    4a2 <atoi+0x75>
    s++;
 477:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 47b:	eb 25                	jmp    4a2 <atoi+0x75>
    n = n*10 + *s++ - '0';
 47d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 480:	89 d0                	mov    %edx,%eax
 482:	c1 e0 02             	shl    $0x2,%eax
 485:	01 d0                	add    %edx,%eax
 487:	01 c0                	add    %eax,%eax
 489:	89 c1                	mov    %eax,%ecx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	8d 50 01             	lea    0x1(%eax),%edx
 491:	89 55 08             	mov    %edx,0x8(%ebp)
 494:	0f b6 00             	movzbl (%eax),%eax
 497:	0f be c0             	movsbl %al,%eax
 49a:	01 c8                	add    %ecx,%eax
 49c:	83 e8 30             	sub    $0x30,%eax
 49f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	3c 2f                	cmp    $0x2f,%al
 4aa:	7e 0a                	jle    4b6 <atoi+0x89>
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	3c 39                	cmp    $0x39,%al
 4b4:	7e c7                	jle    47d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4b9:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4bf:	55                   	push   %ebp
 4c0:	89 e5                	mov    %esp,%ebp
 4c2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
 4c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4d1:	eb 17                	jmp    4ea <memmove+0x2b>
    *dst++ = *src++;
 4d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d6:	8d 50 01             	lea    0x1(%eax),%edx
 4d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4df:	8d 4a 01             	lea    0x1(%edx),%ecx
 4e2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4e5:	0f b6 12             	movzbl (%edx),%edx
 4e8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ea:	8b 45 10             	mov    0x10(%ebp),%eax
 4ed:	8d 50 ff             	lea    -0x1(%eax),%edx
 4f0:	89 55 10             	mov    %edx,0x10(%ebp)
 4f3:	85 c0                	test   %eax,%eax
 4f5:	7f dc                	jg     4d3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fa:	c9                   	leave  
 4fb:	c3                   	ret    

000004fc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4fc:	b8 01 00 00 00       	mov    $0x1,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <exit>:
SYSCALL(exit)
 504:	b8 02 00 00 00       	mov    $0x2,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <wait>:
SYSCALL(wait)
 50c:	b8 03 00 00 00       	mov    $0x3,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <pipe>:
SYSCALL(pipe)
 514:	b8 04 00 00 00       	mov    $0x4,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <read>:
SYSCALL(read)
 51c:	b8 05 00 00 00       	mov    $0x5,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <write>:
SYSCALL(write)
 524:	b8 10 00 00 00       	mov    $0x10,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <close>:
SYSCALL(close)
 52c:	b8 15 00 00 00       	mov    $0x15,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <kill>:
SYSCALL(kill)
 534:	b8 06 00 00 00       	mov    $0x6,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <exec>:
SYSCALL(exec)
 53c:	b8 07 00 00 00       	mov    $0x7,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <open>:
SYSCALL(open)
 544:	b8 0f 00 00 00       	mov    $0xf,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <mknod>:
SYSCALL(mknod)
 54c:	b8 11 00 00 00       	mov    $0x11,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <unlink>:
SYSCALL(unlink)
 554:	b8 12 00 00 00       	mov    $0x12,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <fstat>:
SYSCALL(fstat)
 55c:	b8 08 00 00 00       	mov    $0x8,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <link>:
SYSCALL(link)
 564:	b8 13 00 00 00       	mov    $0x13,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <mkdir>:
SYSCALL(mkdir)
 56c:	b8 14 00 00 00       	mov    $0x14,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <chdir>:
SYSCALL(chdir)
 574:	b8 09 00 00 00       	mov    $0x9,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <dup>:
SYSCALL(dup)
 57c:	b8 0a 00 00 00       	mov    $0xa,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <getpid>:
SYSCALL(getpid)
 584:	b8 0b 00 00 00       	mov    $0xb,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <sbrk>:
SYSCALL(sbrk)
 58c:	b8 0c 00 00 00       	mov    $0xc,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <sleep>:
SYSCALL(sleep)
 594:	b8 0d 00 00 00       	mov    $0xd,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <uptime>:
SYSCALL(uptime)
 59c:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <halt>:
SYSCALL(halt)
 5a4:	b8 16 00 00 00       	mov    $0x16,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <date>:
SYSCALL(date)
 5ac:	b8 17 00 00 00       	mov    $0x17,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <getuid>:
SYSCALL(getuid)
 5b4:	b8 18 00 00 00       	mov    $0x18,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <getgid>:
SYSCALL(getgid)
 5bc:	b8 19 00 00 00       	mov    $0x19,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <getppid>:
SYSCALL(getppid)
 5c4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <setuid>:
SYSCALL(setuid)
 5cc:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <setgid>:
SYSCALL(setgid)
 5d4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <getprocs>:
SYSCALL(getprocs)
 5dc:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <setpriority>:
SYSCALL(setpriority)
 5e4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <chmod>:
SYSCALL(chmod)
 5ec:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <chown>:
SYSCALL(chown)
 5f4:	b8 20 00 00 00       	mov    $0x20,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <chgrp>:
SYSCALL(chgrp)    
 5fc:	b8 21 00 00 00       	mov    $0x21,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 18             	sub    $0x18,%esp
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	6a 01                	push   $0x1
 615:	8d 45 f4             	lea    -0xc(%ebp),%eax
 618:	50                   	push   %eax
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 03 ff ff ff       	call   524 <write>
 621:	83 c4 10             	add    $0x10,%esp
}
 624:	90                   	nop
 625:	c9                   	leave  
 626:	c3                   	ret    

00000627 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 627:	55                   	push   %ebp
 628:	89 e5                	mov    %esp,%ebp
 62a:	53                   	push   %ebx
 62b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 62e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 635:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 639:	74 17                	je     652 <printint+0x2b>
 63b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 63f:	79 11                	jns    652 <printint+0x2b>
    neg = 1;
 641:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 648:	8b 45 0c             	mov    0xc(%ebp),%eax
 64b:	f7 d8                	neg    %eax
 64d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 650:	eb 06                	jmp    658 <printint+0x31>
  } else {
    x = xx;
 652:	8b 45 0c             	mov    0xc(%ebp),%eax
 655:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 658:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 65f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 662:	8d 41 01             	lea    0x1(%ecx),%eax
 665:	89 45 f4             	mov    %eax,-0xc(%ebp)
 668:	8b 5d 10             	mov    0x10(%ebp),%ebx
 66b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66e:	ba 00 00 00 00       	mov    $0x0,%edx
 673:	f7 f3                	div    %ebx
 675:	89 d0                	mov    %edx,%eax
 677:	0f b6 80 8c 0d 00 00 	movzbl 0xd8c(%eax),%eax
 67e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 682:	8b 5d 10             	mov    0x10(%ebp),%ebx
 685:	8b 45 ec             	mov    -0x14(%ebp),%eax
 688:	ba 00 00 00 00       	mov    $0x0,%edx
 68d:	f7 f3                	div    %ebx
 68f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 692:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 696:	75 c7                	jne    65f <printint+0x38>
  if(neg)
 698:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69c:	74 2d                	je     6cb <printint+0xa4>
    buf[i++] = '-';
 69e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a1:	8d 50 01             	lea    0x1(%eax),%edx
 6a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ac:	eb 1d                	jmp    6cb <printint+0xa4>
    putc(fd, buf[i]);
 6ae:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	0f b6 00             	movzbl (%eax),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	83 ec 08             	sub    $0x8,%esp
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 3c ff ff ff       	call   604 <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6cb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d3:	79 d9                	jns    6ae <printint+0x87>
    putc(fd, buf[i]);
}
 6d5:	90                   	nop
 6d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6e8:	8d 45 0c             	lea    0xc(%ebp),%eax
 6eb:	83 c0 04             	add    $0x4,%eax
 6ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6f8:	e9 59 01 00 00       	jmp    856 <printf+0x17b>
    c = fmt[i] & 0xff;
 6fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	0f b6 00             	movzbl (%eax),%eax
 708:	0f be c0             	movsbl %al,%eax
 70b:	25 ff 00 00 00       	and    $0xff,%eax
 710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 713:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 717:	75 2c                	jne    745 <printf+0x6a>
      if(c == '%'){
 719:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71d:	75 0c                	jne    72b <printf+0x50>
        state = '%';
 71f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 726:	e9 27 01 00 00       	jmp    852 <printf+0x177>
      } else {
        putc(fd, c);
 72b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72e:	0f be c0             	movsbl %al,%eax
 731:	83 ec 08             	sub    $0x8,%esp
 734:	50                   	push   %eax
 735:	ff 75 08             	pushl  0x8(%ebp)
 738:	e8 c7 fe ff ff       	call   604 <putc>
 73d:	83 c4 10             	add    $0x10,%esp
 740:	e9 0d 01 00 00       	jmp    852 <printf+0x177>
      }
    } else if(state == '%'){
 745:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 749:	0f 85 03 01 00 00    	jne    852 <printf+0x177>
      if(c == 'd'){
 74f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 753:	75 1e                	jne    773 <printf+0x98>
        printint(fd, *ap, 10, 1);
 755:	8b 45 e8             	mov    -0x18(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	6a 01                	push   $0x1
 75c:	6a 0a                	push   $0xa
 75e:	50                   	push   %eax
 75f:	ff 75 08             	pushl  0x8(%ebp)
 762:	e8 c0 fe ff ff       	call   627 <printint>
 767:	83 c4 10             	add    $0x10,%esp
        ap++;
 76a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76e:	e9 d8 00 00 00       	jmp    84b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 773:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 777:	74 06                	je     77f <printf+0xa4>
 779:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 77d:	75 1e                	jne    79d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 77f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	6a 00                	push   $0x0
 786:	6a 10                	push   $0x10
 788:	50                   	push   %eax
 789:	ff 75 08             	pushl  0x8(%ebp)
 78c:	e8 96 fe ff ff       	call   627 <printint>
 791:	83 c4 10             	add    $0x10,%esp
        ap++;
 794:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 798:	e9 ae 00 00 00       	jmp    84b <printf+0x170>
      } else if(c == 's'){
 79d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7a1:	75 43                	jne    7e6 <printf+0x10b>
        s = (char*)*ap;
 7a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b3:	75 25                	jne    7da <printf+0xff>
          s = "(null)";
 7b5:	c7 45 f4 10 0b 00 00 	movl   $0xb10,-0xc(%ebp)
        while(*s != 0){
 7bc:	eb 1c                	jmp    7da <printf+0xff>
          putc(fd, *s);
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	0f b6 00             	movzbl (%eax),%eax
 7c4:	0f be c0             	movsbl %al,%eax
 7c7:	83 ec 08             	sub    $0x8,%esp
 7ca:	50                   	push   %eax
 7cb:	ff 75 08             	pushl  0x8(%ebp)
 7ce:	e8 31 fe ff ff       	call   604 <putc>
 7d3:	83 c4 10             	add    $0x10,%esp
          s++;
 7d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	0f b6 00             	movzbl (%eax),%eax
 7e0:	84 c0                	test   %al,%al
 7e2:	75 da                	jne    7be <printf+0xe3>
 7e4:	eb 65                	jmp    84b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7e6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ea:	75 1d                	jne    809 <printf+0x12e>
        putc(fd, *ap);
 7ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	0f be c0             	movsbl %al,%eax
 7f4:	83 ec 08             	sub    $0x8,%esp
 7f7:	50                   	push   %eax
 7f8:	ff 75 08             	pushl  0x8(%ebp)
 7fb:	e8 04 fe ff ff       	call   604 <putc>
 800:	83 c4 10             	add    $0x10,%esp
        ap++;
 803:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 807:	eb 42                	jmp    84b <printf+0x170>
      } else if(c == '%'){
 809:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 80d:	75 17                	jne    826 <printf+0x14b>
        putc(fd, c);
 80f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 812:	0f be c0             	movsbl %al,%eax
 815:	83 ec 08             	sub    $0x8,%esp
 818:	50                   	push   %eax
 819:	ff 75 08             	pushl  0x8(%ebp)
 81c:	e8 e3 fd ff ff       	call   604 <putc>
 821:	83 c4 10             	add    $0x10,%esp
 824:	eb 25                	jmp    84b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 826:	83 ec 08             	sub    $0x8,%esp
 829:	6a 25                	push   $0x25
 82b:	ff 75 08             	pushl  0x8(%ebp)
 82e:	e8 d1 fd ff ff       	call   604 <putc>
 833:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 839:	0f be c0             	movsbl %al,%eax
 83c:	83 ec 08             	sub    $0x8,%esp
 83f:	50                   	push   %eax
 840:	ff 75 08             	pushl  0x8(%ebp)
 843:	e8 bc fd ff ff       	call   604 <putc>
 848:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 84b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 852:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 856:	8b 55 0c             	mov    0xc(%ebp),%edx
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	01 d0                	add    %edx,%eax
 85e:	0f b6 00             	movzbl (%eax),%eax
 861:	84 c0                	test   %al,%al
 863:	0f 85 94 fe ff ff    	jne    6fd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 869:	90                   	nop
 86a:	c9                   	leave  
 86b:	c3                   	ret    

0000086c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86c:	55                   	push   %ebp
 86d:	89 e5                	mov    %esp,%ebp
 86f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 872:	8b 45 08             	mov    0x8(%ebp),%eax
 875:	83 e8 08             	sub    $0x8,%eax
 878:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87b:	a1 a8 0d 00 00       	mov    0xda8,%eax
 880:	89 45 fc             	mov    %eax,-0x4(%ebp)
 883:	eb 24                	jmp    8a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 00                	mov    (%eax),%eax
 88a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88d:	77 12                	ja     8a1 <free+0x35>
 88f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 892:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 895:	77 24                	ja     8bb <free+0x4f>
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89f:	77 1a                	ja     8bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8af:	76 d4                	jbe    885 <free+0x19>
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b9:	76 ca                	jbe    885 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cb:	01 c2                	add    %eax,%edx
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	39 c2                	cmp    %eax,%edx
 8d4:	75 24                	jne    8fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d9:	8b 50 04             	mov    0x4(%eax),%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	01 c2                	add    %eax,%edx
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	8b 10                	mov    (%eax),%edx
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	89 10                	mov    %edx,(%eax)
 8f8:	eb 0a                	jmp    904 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 10                	mov    (%eax),%edx
 8ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 902:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
 907:	8b 40 04             	mov    0x4(%eax),%eax
 90a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	01 d0                	add    %edx,%eax
 916:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 919:	75 20                	jne    93b <free+0xcf>
    p->s.size += bp->s.size;
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 50 04             	mov    0x4(%eax),%edx
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	01 c2                	add    %eax,%edx
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 92f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 fc             	mov    -0x4(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
 939:	eb 08                	jmp    943 <free+0xd7>
  } else
    p->s.ptr = bp;
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 941:	89 10                	mov    %edx,(%eax)
  freep = p;
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	a3 a8 0d 00 00       	mov    %eax,0xda8
}
 94b:	90                   	nop
 94c:	c9                   	leave  
 94d:	c3                   	ret    

0000094e <morecore>:

static Header*
morecore(uint nu)
{
 94e:	55                   	push   %ebp
 94f:	89 e5                	mov    %esp,%ebp
 951:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 954:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 95b:	77 07                	ja     964 <morecore+0x16>
    nu = 4096;
 95d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 964:	8b 45 08             	mov    0x8(%ebp),%eax
 967:	c1 e0 03             	shl    $0x3,%eax
 96a:	83 ec 0c             	sub    $0xc,%esp
 96d:	50                   	push   %eax
 96e:	e8 19 fc ff ff       	call   58c <sbrk>
 973:	83 c4 10             	add    $0x10,%esp
 976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 979:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 97d:	75 07                	jne    986 <morecore+0x38>
    return 0;
 97f:	b8 00 00 00 00       	mov    $0x0,%eax
 984:	eb 26                	jmp    9ac <morecore+0x5e>
  hp = (Header*)p;
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 98c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98f:	8b 55 08             	mov    0x8(%ebp),%edx
 992:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 995:	8b 45 f0             	mov    -0x10(%ebp),%eax
 998:	83 c0 08             	add    $0x8,%eax
 99b:	83 ec 0c             	sub    $0xc,%esp
 99e:	50                   	push   %eax
 99f:	e8 c8 fe ff ff       	call   86c <free>
 9a4:	83 c4 10             	add    $0x10,%esp
  return freep;
 9a7:	a1 a8 0d 00 00       	mov    0xda8,%eax
}
 9ac:	c9                   	leave  
 9ad:	c3                   	ret    

000009ae <malloc>:

void*
malloc(uint nbytes)
{
 9ae:	55                   	push   %ebp
 9af:	89 e5                	mov    %esp,%ebp
 9b1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b4:	8b 45 08             	mov    0x8(%ebp),%eax
 9b7:	83 c0 07             	add    $0x7,%eax
 9ba:	c1 e8 03             	shr    $0x3,%eax
 9bd:	83 c0 01             	add    $0x1,%eax
 9c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9c3:	a1 a8 0d 00 00       	mov    0xda8,%eax
 9c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9cf:	75 23                	jne    9f4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9d1:	c7 45 f0 a0 0d 00 00 	movl   $0xda0,-0x10(%ebp)
 9d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9db:	a3 a8 0d 00 00       	mov    %eax,0xda8
 9e0:	a1 a8 0d 00 00       	mov    0xda8,%eax
 9e5:	a3 a0 0d 00 00       	mov    %eax,0xda0
    base.s.size = 0;
 9ea:	c7 05 a4 0d 00 00 00 	movl   $0x0,0xda4
 9f1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	8b 00                	mov    (%eax),%eax
 9f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	8b 40 04             	mov    0x4(%eax),%eax
 a02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a05:	72 4d                	jb     a54 <malloc+0xa6>
      if(p->s.size == nunits)
 a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0a:	8b 40 04             	mov    0x4(%eax),%eax
 a0d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a10:	75 0c                	jne    a1e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a15:	8b 10                	mov    (%eax),%edx
 a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1a:	89 10                	mov    %edx,(%eax)
 a1c:	eb 26                	jmp    a44 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	8b 40 04             	mov    0x4(%eax),%eax
 a24:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a27:	89 c2                	mov    %eax,%edx
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	8b 40 04             	mov    0x4(%eax),%eax
 a35:	c1 e0 03             	shl    $0x3,%eax
 a38:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a41:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a47:	a3 a8 0d 00 00       	mov    %eax,0xda8
      return (void*)(p + 1);
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	83 c0 08             	add    $0x8,%eax
 a52:	eb 3b                	jmp    a8f <malloc+0xe1>
    }
    if(p == freep)
 a54:	a1 a8 0d 00 00       	mov    0xda8,%eax
 a59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a5c:	75 1e                	jne    a7c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a5e:	83 ec 0c             	sub    $0xc,%esp
 a61:	ff 75 ec             	pushl  -0x14(%ebp)
 a64:	e8 e5 fe ff ff       	call   94e <morecore>
 a69:	83 c4 10             	add    $0x10,%esp
 a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a73:	75 07                	jne    a7c <malloc+0xce>
        return 0;
 a75:	b8 00 00 00 00       	mov    $0x0,%eax
 a7a:	eb 13                	jmp    a8f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 00                	mov    (%eax),%eax
 a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a8a:	e9 6d ff ff ff       	jmp    9fc <malloc+0x4e>
}
 a8f:	c9                   	leave  
 a90:	c3                   	ret    
