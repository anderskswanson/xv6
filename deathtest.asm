
_deathtest:     file format elf32-i386


Disassembly of section .text:

00000000 <deathtest>:
#include "types.h"
#include "user.h"

int 
deathtest(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	81 ec 18 01 00 00    	sub    $0x118,%esp

    int pid;
    int pids[64];
    int kids = 0;
   9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    pid = fork();
  10:	e8 17 03 00 00       	call   32c <fork>
  15:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while(pid > 0)
  18:	eb 44                	jmp    5e <deathtest+0x5e>
    {
        pids[kids] = pid;
  1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  20:	89 94 85 ec fe ff ff 	mov    %edx,-0x114(%ebp,%eax,4)
        pid = fork();
  27:	e8 00 03 00 00       	call   32c <fork>
  2c:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if(pid < 0)
  2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  33:	79 25                	jns    5a <deathtest+0x5a>
        {
            printf(2,"num kids: %d\n", kids);
  35:	83 ec 04             	sub    $0x4,%esp
  38:	ff 75 f0             	pushl  -0x10(%ebp)
  3b:	68 a1 08 00 00       	push   $0x8a1
  40:	6a 02                	push   $0x2
  42:	e8 a4 04 00 00       	call   4eb <printf>
  47:	83 c4 10             	add    $0x10,%esp
            sleep(3000);
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	68 b8 0b 00 00       	push   $0xbb8
  52:	e8 6d 03 00 00       	call   3c4 <sleep>
  57:	83 c4 10             	add    $0x10,%esp
        }
//        if(pid == 0)
  //          while(1) {}
        ++kids;
  5a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    int pid;
    int pids[64];
    int kids = 0;
    pid = fork();

    while(pid > 0)
  5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  62:	7f b6                	jg     1a <deathtest+0x1a>
//        if(pid == 0)
  //          while(1) {}
        ++kids;
    }
    
    if(pid > 0)
  64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  68:	7e 29                	jle    93 <deathtest+0x93>
    {
        for(int i = 0; i < 64; ++i)
  6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  71:	eb 1a                	jmp    8d <deathtest+0x8d>
            kill(pids[i]);
  73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  76:	8b 84 85 ec fe ff ff 	mov    -0x114(%ebp,%eax,4),%eax
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	50                   	push   %eax
  81:	e8 de 02 00 00       	call   364 <kill>
  86:	83 c4 10             	add    $0x10,%esp
        ++kids;
    }
    
    if(pid > 0)
    {
        for(int i = 0; i < 64; ++i)
  89:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  8d:	83 7d ec 3f          	cmpl   $0x3f,-0x14(%ebp)
  91:	7e e0                	jle    73 <deathtest+0x73>
            kill(pids[i]);
    }


    exit();
  93:	e8 9c 02 00 00       	call   334 <exit>

00000098 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	57                   	push   %edi
  9c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a0:	8b 55 10             	mov    0x10(%ebp),%edx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	89 cb                	mov    %ecx,%ebx
  a8:	89 df                	mov    %ebx,%edi
  aa:	89 d1                	mov    %edx,%ecx
  ac:	fc                   	cld    
  ad:	f3 aa                	rep stos %al,%es:(%edi)
  af:	89 ca                	mov    %ecx,%edx
  b1:	89 fb                	mov    %edi,%ebx
  b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b9:	90                   	nop
  ba:	5b                   	pop    %ebx
  bb:	5f                   	pop    %edi
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	8d 50 01             	lea    0x1(%eax),%edx
  d1:	89 55 08             	mov    %edx,0x8(%ebp)
  d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  da:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0xd>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f1:	eb 08                	jmp    fb <strcmp+0xd>
    p++, q++;
  f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	84 c0                	test   %al,%al
 103:	74 10                	je     115 <strcmp+0x27>
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b6 10             	movzbl (%eax),%edx
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	38 c2                	cmp    %al,%dl
 113:	74 de                	je     f3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 d0             	movzbl %al,%edx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	0f b6 c0             	movzbl %al,%eax
 127:	29 c2                	sub    %eax,%edx
 129:	89 d0                	mov    %edx,%eax
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <strlen>:

uint
strlen(char *s)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13a:	eb 04                	jmp    140 <strlen+0x13>
 13c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 140:	8b 55 fc             	mov    -0x4(%ebp),%edx
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 ed                	jne    13c <strlen+0xf>
    ;
  return n;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 157:	8b 45 10             	mov    0x10(%ebp),%eax
 15a:	50                   	push   %eax
 15b:	ff 75 0c             	pushl  0xc(%ebp)
 15e:	ff 75 08             	pushl  0x8(%ebp)
 161:	e8 32 ff ff ff       	call   98 <stosb>
 166:	83 c4 0c             	add    $0xc,%esp
  return dst;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 04             	sub    $0x4,%esp
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17a:	eb 14                	jmp    190 <strchr+0x22>
    if(*s == c)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	3a 45 fc             	cmp    -0x4(%ebp),%al
 185:	75 05                	jne    18c <strchr+0x1e>
      return (char*)s;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	eb 13                	jmp    19f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 e2                	jne    17c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <gets>:

char*
gets(char *buf, int max)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ae:	eb 42                	jmp    1f2 <gets+0x51>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b8:	50                   	push   %eax
 1b9:	6a 00                	push   $0x0
 1bb:	e8 8c 01 00 00       	call   34c <read>
 1c0:	83 c4 10             	add    $0x10,%esp
 1c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ca:	7e 33                	jle    1ff <gets+0x5e>
      break;
    buf[i++] = c;
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	8d 50 01             	lea    0x1(%eax),%edx
 1d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d5:	89 c2                	mov    %eax,%edx
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	01 c2                	add    %eax,%edx
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0a                	cmp    $0xa,%al
 1e8:	74 16                	je     200 <gets+0x5f>
 1ea:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ee:	3c 0d                	cmp    $0xd,%al
 1f0:	74 0e                	je     200 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f5:	83 c0 01             	add    $0x1,%eax
 1f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1fb:	7c b3                	jl     1b0 <gets+0xf>
 1fd:	eb 01                	jmp    200 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ff:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 200:	8b 55 f4             	mov    -0xc(%ebp),%edx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	01 d0                	add    %edx,%eax
 208:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <stat>:

int
stat(char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	83 ec 08             	sub    $0x8,%esp
 219:	6a 00                	push   $0x0
 21b:	ff 75 08             	pushl  0x8(%ebp)
 21e:	e8 51 01 00 00       	call   374 <open>
 223:	83 c4 10             	add    $0x10,%esp
 226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 22d:	79 07                	jns    236 <stat+0x26>
    return -1;
 22f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 234:	eb 25                	jmp    25b <stat+0x4b>
  r = fstat(fd, st);
 236:	83 ec 08             	sub    $0x8,%esp
 239:	ff 75 0c             	pushl  0xc(%ebp)
 23c:	ff 75 f4             	pushl  -0xc(%ebp)
 23f:	e8 48 01 00 00       	call   38c <fstat>
 244:	83 c4 10             	add    $0x10,%esp
 247:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24a:	83 ec 0c             	sub    $0xc,%esp
 24d:	ff 75 f4             	pushl  -0xc(%ebp)
 250:	e8 07 01 00 00       	call   35c <close>
 255:	83 c4 10             	add    $0x10,%esp
  return r;
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25b:	c9                   	leave  
 25c:	c3                   	ret    

0000025d <atoi>:

int
atoi(const char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 26a:	eb 04                	jmp    270 <atoi+0x13>
 26c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 20                	cmp    $0x20,%al
 278:	74 f2                	je     26c <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	0f b6 00             	movzbl (%eax),%eax
 280:	3c 2d                	cmp    $0x2d,%al
 282:	75 07                	jne    28b <atoi+0x2e>
 284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 289:	eb 05                	jmp    290 <atoi+0x33>
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 2b                	cmp    $0x2b,%al
 29b:	74 0a                	je     2a7 <atoi+0x4a>
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 2d                	cmp    $0x2d,%al
 2a5:	75 2b                	jne    2d2 <atoi+0x75>
    s++;
 2a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2ab:	eb 25                	jmp    2d2 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b0:	89 d0                	mov    %edx,%eax
 2b2:	c1 e0 02             	shl    $0x2,%eax
 2b5:	01 d0                	add    %edx,%eax
 2b7:	01 c0                	add    %eax,%eax
 2b9:	89 c1                	mov    %eax,%ecx
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	8d 50 01             	lea    0x1(%eax),%edx
 2c1:	89 55 08             	mov    %edx,0x8(%ebp)
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f be c0             	movsbl %al,%eax
 2ca:	01 c8                	add    %ecx,%eax
 2cc:	83 e8 30             	sub    $0x30,%eax
 2cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	0f b6 00             	movzbl (%eax),%eax
 2d8:	3c 2f                	cmp    $0x2f,%al
 2da:	7e 0a                	jle    2e6 <atoi+0x89>
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	3c 39                	cmp    $0x39,%al
 2e4:	7e c7                	jle    2ad <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e9:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    

000002ef <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ef:	55                   	push   %ebp
 2f0:	89 e5                	mov    %esp,%ebp
 2f2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 301:	eb 17                	jmp    31a <memmove+0x2b>
    *dst++ = *src++;
 303:	8b 45 fc             	mov    -0x4(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30f:	8d 4a 01             	lea    0x1(%edx),%ecx
 312:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 315:	0f b6 12             	movzbl (%edx),%edx
 318:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31a:	8b 45 10             	mov    0x10(%ebp),%eax
 31d:	8d 50 ff             	lea    -0x1(%eax),%edx
 320:	89 55 10             	mov    %edx,0x10(%ebp)
 323:	85 c0                	test   %eax,%eax
 325:	7f dc                	jg     303 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32a:	c9                   	leave  
 32b:	c3                   	ret    

0000032c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32c:	b8 01 00 00 00       	mov    $0x1,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <exit>:
SYSCALL(exit)
 334:	b8 02 00 00 00       	mov    $0x2,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <wait>:
SYSCALL(wait)
 33c:	b8 03 00 00 00       	mov    $0x3,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <pipe>:
SYSCALL(pipe)
 344:	b8 04 00 00 00       	mov    $0x4,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <read>:
SYSCALL(read)
 34c:	b8 05 00 00 00       	mov    $0x5,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <write>:
SYSCALL(write)
 354:	b8 10 00 00 00       	mov    $0x10,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <close>:
SYSCALL(close)
 35c:	b8 15 00 00 00       	mov    $0x15,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <kill>:
SYSCALL(kill)
 364:	b8 06 00 00 00       	mov    $0x6,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exec>:
SYSCALL(exec)
 36c:	b8 07 00 00 00       	mov    $0x7,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <open>:
SYSCALL(open)
 374:	b8 0f 00 00 00       	mov    $0xf,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <mknod>:
SYSCALL(mknod)
 37c:	b8 11 00 00 00       	mov    $0x11,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <unlink>:
SYSCALL(unlink)
 384:	b8 12 00 00 00       	mov    $0x12,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <fstat>:
SYSCALL(fstat)
 38c:	b8 08 00 00 00       	mov    $0x8,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <link>:
SYSCALL(link)
 394:	b8 13 00 00 00       	mov    $0x13,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mkdir>:
SYSCALL(mkdir)
 39c:	b8 14 00 00 00       	mov    $0x14,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <chdir>:
SYSCALL(chdir)
 3a4:	b8 09 00 00 00       	mov    $0x9,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <dup>:
SYSCALL(dup)
 3ac:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <getpid>:
SYSCALL(getpid)
 3b4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <sbrk>:
SYSCALL(sbrk)
 3bc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <sleep>:
SYSCALL(sleep)
 3c4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <uptime>:
SYSCALL(uptime)
 3cc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <halt>:
SYSCALL(halt)
 3d4:	b8 16 00 00 00       	mov    $0x16,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <date>:
SYSCALL(date)
 3dc:	b8 17 00 00 00       	mov    $0x17,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <getuid>:
SYSCALL(getuid)
 3e4:	b8 18 00 00 00       	mov    $0x18,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getgid>:
SYSCALL(getgid)
 3ec:	b8 19 00 00 00       	mov    $0x19,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getppid>:
SYSCALL(getppid)
 3f4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <setuid>:
SYSCALL(setuid)
 3fc:	b8 1b 00 00 00       	mov    $0x1b,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <setgid>:
SYSCALL(setgid)
 404:	b8 1c 00 00 00       	mov    $0x1c,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <getprocs>:
SYSCALL(getprocs)
 40c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 18             	sub    $0x18,%esp
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	8d 45 f4             	lea    -0xc(%ebp),%eax
 428:	50                   	push   %eax
 429:	ff 75 08             	pushl  0x8(%ebp)
 42c:	e8 23 ff ff ff       	call   354 <write>
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	90                   	nop
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	53                   	push   %ebx
 43b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 445:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 449:	74 17                	je     462 <printint+0x2b>
 44b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44f:	79 11                	jns    462 <printint+0x2b>
    neg = 1;
 451:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	f7 d8                	neg    %eax
 45d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 460:	eb 06                	jmp    468 <printint+0x31>
  } else {
    x = xx;
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 468:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 472:	8d 41 01             	lea    0x1(%ecx),%eax
 475:	89 45 f4             	mov    %eax,-0xc(%ebp)
 478:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47e:	ba 00 00 00 00       	mov    $0x0,%edx
 483:	f7 f3                	div    %ebx
 485:	89 d0                	mov    %edx,%eax
 487:	0f b6 80 f8 0a 00 00 	movzbl 0xaf8(%eax),%eax
 48e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 492:	8b 5d 10             	mov    0x10(%ebp),%ebx
 495:	8b 45 ec             	mov    -0x14(%ebp),%eax
 498:	ba 00 00 00 00       	mov    $0x0,%edx
 49d:	f7 f3                	div    %ebx
 49f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a6:	75 c7                	jne    46f <printint+0x38>
  if(neg)
 4a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ac:	74 2d                	je     4db <printint+0xa4>
    buf[i++] = '-';
 4ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b1:	8d 50 01             	lea    0x1(%eax),%edx
 4b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4bc:	eb 1d                	jmp    4db <printint+0xa4>
    putc(fd, buf[i]);
 4be:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	0f b6 00             	movzbl (%eax),%eax
 4c9:	0f be c0             	movsbl %al,%eax
 4cc:	83 ec 08             	sub    $0x8,%esp
 4cf:	50                   	push   %eax
 4d0:	ff 75 08             	pushl  0x8(%ebp)
 4d3:	e8 3c ff ff ff       	call   414 <putc>
 4d8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4db:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e3:	79 d9                	jns    4be <printint+0x87>
    putc(fd, buf[i]);
}
 4e5:	90                   	nop
 4e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e9:	c9                   	leave  
 4ea:	c3                   	ret    

000004eb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fb:	83 c0 04             	add    $0x4,%eax
 4fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 508:	e9 59 01 00 00       	jmp    666 <printf+0x17b>
    c = fmt[i] & 0xff;
 50d:	8b 55 0c             	mov    0xc(%ebp),%edx
 510:	8b 45 f0             	mov    -0x10(%ebp),%eax
 513:	01 d0                	add    %edx,%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	25 ff 00 00 00       	and    $0xff,%eax
 520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 523:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 527:	75 2c                	jne    555 <printf+0x6a>
      if(c == '%'){
 529:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52d:	75 0c                	jne    53b <printf+0x50>
        state = '%';
 52f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 536:	e9 27 01 00 00       	jmp    662 <printf+0x177>
      } else {
        putc(fd, c);
 53b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53e:	0f be c0             	movsbl %al,%eax
 541:	83 ec 08             	sub    $0x8,%esp
 544:	50                   	push   %eax
 545:	ff 75 08             	pushl  0x8(%ebp)
 548:	e8 c7 fe ff ff       	call   414 <putc>
 54d:	83 c4 10             	add    $0x10,%esp
 550:	e9 0d 01 00 00       	jmp    662 <printf+0x177>
      }
    } else if(state == '%'){
 555:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 559:	0f 85 03 01 00 00    	jne    662 <printf+0x177>
      if(c == 'd'){
 55f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 563:	75 1e                	jne    583 <printf+0x98>
        printint(fd, *ap, 10, 1);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	6a 01                	push   $0x1
 56c:	6a 0a                	push   $0xa
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 c0 fe ff ff       	call   437 <printint>
 577:	83 c4 10             	add    $0x10,%esp
        ap++;
 57a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57e:	e9 d8 00 00 00       	jmp    65b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 583:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 587:	74 06                	je     58f <printf+0xa4>
 589:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58d:	75 1e                	jne    5ad <printf+0xc2>
        printint(fd, *ap, 16, 0);
 58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	6a 00                	push   $0x0
 596:	6a 10                	push   $0x10
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 96 fe ff ff       	call   437 <printint>
 5a1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a8:	e9 ae 00 00 00       	jmp    65b <printf+0x170>
      } else if(c == 's'){
 5ad:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b1:	75 43                	jne    5f6 <printf+0x10b>
        s = (char*)*ap;
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c3:	75 25                	jne    5ea <printf+0xff>
          s = "(null)";
 5c5:	c7 45 f4 af 08 00 00 	movl   $0x8af,-0xc(%ebp)
        while(*s != 0){
 5cc:	eb 1c                	jmp    5ea <printf+0xff>
          putc(fd, *s);
 5ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d1:	0f b6 00             	movzbl (%eax),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	50                   	push   %eax
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 31 fe ff ff       	call   414 <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
          s++;
 5e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	84 c0                	test   %al,%al
 5f2:	75 da                	jne    5ce <printf+0xe3>
 5f4:	eb 65                	jmp    65b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5fa:	75 1d                	jne    619 <printf+0x12e>
        putc(fd, *ap);
 5fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	83 ec 08             	sub    $0x8,%esp
 607:	50                   	push   %eax
 608:	ff 75 08             	pushl  0x8(%ebp)
 60b:	e8 04 fe ff ff       	call   414 <putc>
 610:	83 c4 10             	add    $0x10,%esp
        ap++;
 613:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 617:	eb 42                	jmp    65b <printf+0x170>
      } else if(c == '%'){
 619:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61d:	75 17                	jne    636 <printf+0x14b>
        putc(fd, c);
 61f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	83 ec 08             	sub    $0x8,%esp
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 e3 fd ff ff       	call   414 <putc>
 631:	83 c4 10             	add    $0x10,%esp
 634:	eb 25                	jmp    65b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 636:	83 ec 08             	sub    $0x8,%esp
 639:	6a 25                	push   $0x25
 63b:	ff 75 08             	pushl  0x8(%ebp)
 63e:	e8 d1 fd ff ff       	call   414 <putc>
 643:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 649:	0f be c0             	movsbl %al,%eax
 64c:	83 ec 08             	sub    $0x8,%esp
 64f:	50                   	push   %eax
 650:	ff 75 08             	pushl  0x8(%ebp)
 653:	e8 bc fd ff ff       	call   414 <putc>
 658:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 65b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 662:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 666:	8b 55 0c             	mov    0xc(%ebp),%edx
 669:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66c:	01 d0                	add    %edx,%eax
 66e:	0f b6 00             	movzbl (%eax),%eax
 671:	84 c0                	test   %al,%al
 673:	0f 85 94 fe ff ff    	jne    50d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 679:	90                   	nop
 67a:	c9                   	leave  
 67b:	c3                   	ret    

0000067c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67c:	55                   	push   %ebp
 67d:	89 e5                	mov    %esp,%ebp
 67f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	83 e8 08             	sub    $0x8,%eax
 688:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68b:	a1 14 0b 00 00       	mov    0xb14,%eax
 690:	89 45 fc             	mov    %eax,-0x4(%ebp)
 693:	eb 24                	jmp    6b9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	77 12                	ja     6b1 <free+0x35>
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a5:	77 24                	ja     6cb <free+0x4f>
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6af:	77 1a                	ja     6cb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bf:	76 d4                	jbe    695 <free+0x19>
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c9:	76 ca                	jbe    695 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	01 c2                	add    %eax,%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	39 c2                	cmp    %eax,%edx
 6e4:	75 24                	jne    70a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	8b 50 04             	mov    0x4(%eax),%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	8b 40 04             	mov    0x4(%eax),%eax
 6f4:	01 c2                	add    %eax,%edx
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	8b 10                	mov    (%eax),%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	89 10                	mov    %edx,(%eax)
 708:	eb 0a                	jmp    714 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 40 04             	mov    0x4(%eax),%eax
 71a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 729:	75 20                	jne    74b <free+0xcf>
    p->s.size += bp->s.size;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 50 04             	mov    0x4(%eax),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	8b 40 04             	mov    0x4(%eax),%eax
 737:	01 c2                	add    %eax,%edx
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 10                	mov    (%eax),%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	89 10                	mov    %edx,(%eax)
 749:	eb 08                	jmp    753 <free+0xd7>
  } else
    p->s.ptr = bp;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 751:	89 10                	mov    %edx,(%eax)
  freep = p;
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	a3 14 0b 00 00       	mov    %eax,0xb14
}
 75b:	90                   	nop
 75c:	c9                   	leave  
 75d:	c3                   	ret    

0000075e <morecore>:

static Header*
morecore(uint nu)
{
 75e:	55                   	push   %ebp
 75f:	89 e5                	mov    %esp,%ebp
 761:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 764:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76b:	77 07                	ja     774 <morecore+0x16>
    nu = 4096;
 76d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	c1 e0 03             	shl    $0x3,%eax
 77a:	83 ec 0c             	sub    $0xc,%esp
 77d:	50                   	push   %eax
 77e:	e8 39 fc ff ff       	call   3bc <sbrk>
 783:	83 c4 10             	add    $0x10,%esp
 786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 789:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 78d:	75 07                	jne    796 <morecore+0x38>
    return 0;
 78f:	b8 00 00 00 00       	mov    $0x0,%eax
 794:	eb 26                	jmp    7bc <morecore+0x5e>
  hp = (Header*)p;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	8b 55 08             	mov    0x8(%ebp),%edx
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	83 c0 08             	add    $0x8,%eax
 7ab:	83 ec 0c             	sub    $0xc,%esp
 7ae:	50                   	push   %eax
 7af:	e8 c8 fe ff ff       	call   67c <free>
 7b4:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b7:	a1 14 0b 00 00       	mov    0xb14,%eax
}
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    

000007be <malloc>:

void*
malloc(uint nbytes)
{
 7be:	55                   	push   %ebp
 7bf:	89 e5                	mov    %esp,%ebp
 7c1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	83 c0 07             	add    $0x7,%eax
 7ca:	c1 e8 03             	shr    $0x3,%eax
 7cd:	83 c0 01             	add    $0x1,%eax
 7d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d3:	a1 14 0b 00 00       	mov    0xb14,%eax
 7d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7df:	75 23                	jne    804 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e1:	c7 45 f0 0c 0b 00 00 	movl   $0xb0c,-0x10(%ebp)
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 14 0b 00 00       	mov    %eax,0xb14
 7f0:	a1 14 0b 00 00       	mov    0xb14,%eax
 7f5:	a3 0c 0b 00 00       	mov    %eax,0xb0c
    base.s.size = 0;
 7fa:	c7 05 10 0b 00 00 00 	movl   $0x0,0xb10
 801:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 815:	72 4d                	jb     864 <malloc+0xa6>
      if(p->s.size == nunits)
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 820:	75 0c                	jne    82e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 10                	mov    (%eax),%edx
 827:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82a:	89 10                	mov    %edx,(%eax)
 82c:	eb 26                	jmp    854 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	2b 45 ec             	sub    -0x14(%ebp),%eax
 837:	89 c2                	mov    %eax,%edx
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	c1 e0 03             	shl    $0x3,%eax
 848:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 851:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	a3 14 0b 00 00       	mov    %eax,0xb14
      return (void*)(p + 1);
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	83 c0 08             	add    $0x8,%eax
 862:	eb 3b                	jmp    89f <malloc+0xe1>
    }
    if(p == freep)
 864:	a1 14 0b 00 00       	mov    0xb14,%eax
 869:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86c:	75 1e                	jne    88c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 86e:	83 ec 0c             	sub    $0xc,%esp
 871:	ff 75 ec             	pushl  -0x14(%ebp)
 874:	e8 e5 fe ff ff       	call   75e <morecore>
 879:	83 c4 10             	add    $0x10,%esp
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 883:	75 07                	jne    88c <malloc+0xce>
        return 0;
 885:	b8 00 00 00 00       	mov    $0x0,%eax
 88a:	eb 13                	jmp    89f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89a:	e9 6d ff ff ff       	jmp    80c <malloc+0x4e>
}
 89f:	c9                   	leave  
 8a0:	c3                   	ret    
