
_killtest:     file format elf32-i386


Disassembly of section .text:

00000000 <killtest>:
#include "types.h"
#include "user.h"

int 
killtest(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    int pid;
    pid = fork();
   6:	e8 10 03 00 00       	call   31b <fork>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    for(int i = 0; i < 3 && pid > 0; ++i) 
   e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  15:	eb 54                	jmp    6b <killtest+0x6b>
    {
        pid = fork();
  17:	e8 ff 02 00 00       	call   31b <fork>
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)

        printf(2,"cleanup... \n");
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 90 08 00 00       	push   $0x890
  27:	6a 02                	push   $0x2
  29:	e8 ac 04 00 00       	call   4da <printf>
  2e:	83 c4 10             	add    $0x10,%esp
        kill(pid);
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	ff 75 f4             	pushl  -0xc(%ebp)
  37:	e8 17 03 00 00       	call   353 <kill>
  3c:	83 c4 10             	add    $0x10,%esp
        sleep(2000);
  3f:	83 ec 0c             	sub    $0xc,%esp
  42:	68 d0 07 00 00       	push   $0x7d0
  47:	e8 67 03 00 00       	call   3b3 <sleep>
  4c:	83 c4 10             	add    $0x10,%esp

        if(pid < 0)
  4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  53:	79 12                	jns    67 <killtest+0x67>
            printf(2,"FORKERROR\n");
  55:	83 ec 08             	sub    $0x8,%esp
  58:	68 9d 08 00 00       	push   $0x89d
  5d:	6a 02                	push   $0x2
  5f:	e8 76 04 00 00       	call   4da <printf>
  64:	83 c4 10             	add    $0x10,%esp
killtest(void)
{
    int pid;
    pid = fork();

    for(int i = 0; i < 3 && pid > 0; ++i) 
  67:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  6b:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  6f:	7f 06                	jg     77 <killtest+0x77>
  71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  75:	7f a0                	jg     17 <killtest+0x17>

        if(pid < 0)
            printf(2,"FORKERROR\n");
    }

    if(pid > 0)
  77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  7b:	7e 05                	jle    82 <killtest+0x82>
        wait();
  7d:	e8 a9 02 00 00       	call   32b <wait>
    exit();
  82:	e8 9c 02 00 00       	call   323 <exit>

00000087 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	57                   	push   %edi
  8b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8f:	8b 55 10             	mov    0x10(%ebp),%edx
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	89 cb                	mov    %ecx,%ebx
  97:	89 df                	mov    %ebx,%edi
  99:	89 d1                	mov    %edx,%ecx
  9b:	fc                   	cld    
  9c:	f3 aa                	rep stos %al,%es:(%edi)
  9e:	89 ca                	mov    %ecx,%edx
  a0:	89 fb                	mov    %edi,%ebx
  a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a8:	90                   	nop
  a9:	5b                   	pop    %ebx
  aa:	5f                   	pop    %edi
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret    

000000ad <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  b0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b9:	90                   	nop
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	8d 50 01             	lea    0x1(%eax),%edx
  c0:	89 55 08             	mov    %edx,0x8(%ebp)
  c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  cc:	0f b6 12             	movzbl (%edx),%edx
  cf:	88 10                	mov    %dl,(%eax)
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	75 e2                	jne    ba <strcpy+0xd>
    ;
  return os;
  d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  db:	c9                   	leave  
  dc:	c3                   	ret    

000000dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e0:	eb 08                	jmp    ea <strcmp+0xd>
    p++, q++;
  e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	84 c0                	test   %al,%al
  f2:	74 10                	je     104 <strcmp+0x27>
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	0f b6 10             	movzbl (%eax),%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	38 c2                	cmp    %al,%dl
 102:	74 de                	je     e2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 d0             	movzbl %al,%edx
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 c0             	movzbl %al,%eax
 116:	29 c2                	sub    %eax,%edx
 118:	89 d0                	mov    %edx,%eax
}
 11a:	5d                   	pop    %ebp
 11b:	c3                   	ret    

0000011c <strlen>:

uint
strlen(char *s)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 129:	eb 04                	jmp    12f <strlen+0x13>
 12b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	01 d0                	add    %edx,%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	84 c0                	test   %al,%al
 13c:	75 ed                	jne    12b <strlen+0xf>
    ;
  return n;
 13e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 141:	c9                   	leave  
 142:	c3                   	ret    

00000143 <memset>:

void*
memset(void *dst, int c, uint n)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 146:	8b 45 10             	mov    0x10(%ebp),%eax
 149:	50                   	push   %eax
 14a:	ff 75 0c             	pushl  0xc(%ebp)
 14d:	ff 75 08             	pushl  0x8(%ebp)
 150:	e8 32 ff ff ff       	call   87 <stosb>
 155:	83 c4 0c             	add    $0xc,%esp
  return dst;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <strchr>:

char*
strchr(const char *s, char c)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 04             	sub    $0x4,%esp
 163:	8b 45 0c             	mov    0xc(%ebp),%eax
 166:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 169:	eb 14                	jmp    17f <strchr+0x22>
    if(*s == c)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	3a 45 fc             	cmp    -0x4(%ebp),%al
 174:	75 05                	jne    17b <strchr+0x1e>
      return (char*)s;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	eb 13                	jmp    18e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	75 e2                	jne    16b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 189:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19d:	eb 42                	jmp    1e1 <gets+0x51>
    cc = read(0, &c, 1);
 19f:	83 ec 04             	sub    $0x4,%esp
 1a2:	6a 01                	push   $0x1
 1a4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a7:	50                   	push   %eax
 1a8:	6a 00                	push   $0x0
 1aa:	e8 8c 01 00 00       	call   33b <read>
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b9:	7e 33                	jle    1ee <gets+0x5e>
      break;
    buf[i++] = c;
 1bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1be:	8d 50 01             	lea    0x1(%eax),%edx
 1c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c4:	89 c2                	mov    %eax,%edx
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	01 c2                	add    %eax,%edx
 1cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cf:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0a                	cmp    $0xa,%al
 1d7:	74 16                	je     1ef <gets+0x5f>
 1d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dd:	3c 0d                	cmp    $0xd,%al
 1df:	74 0e                	je     1ef <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ea:	7c b3                	jl     19f <gets+0xf>
 1ec:	eb 01                	jmp    1ef <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ee:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	01 d0                	add    %edx,%eax
 1f7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fd:	c9                   	leave  
 1fe:	c3                   	ret    

000001ff <stat>:

int
stat(char *n, struct stat *st)
{
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
 202:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 51 01 00 00       	call   363 <open>
 212:	83 c4 10             	add    $0x10,%esp
 215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21c:	79 07                	jns    225 <stat+0x26>
    return -1;
 21e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 223:	eb 25                	jmp    24a <stat+0x4b>
  r = fstat(fd, st);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	ff 75 0c             	pushl  0xc(%ebp)
 22b:	ff 75 f4             	pushl  -0xc(%ebp)
 22e:	e8 48 01 00 00       	call   37b <fstat>
 233:	83 c4 10             	add    $0x10,%esp
 236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 239:	83 ec 0c             	sub    $0xc,%esp
 23c:	ff 75 f4             	pushl  -0xc(%ebp)
 23f:	e8 07 01 00 00       	call   34b <close>
 244:	83 c4 10             	add    $0x10,%esp
  return r;
 247:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24a:	c9                   	leave  
 24b:	c3                   	ret    

0000024c <atoi>:

int
atoi(const char *s)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 259:	eb 04                	jmp    25f <atoi+0x13>
 25b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	3c 20                	cmp    $0x20,%al
 267:	74 f2                	je     25b <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2d                	cmp    $0x2d,%al
 271:	75 07                	jne    27a <atoi+0x2e>
 273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 278:	eb 05                	jmp    27f <atoi+0x33>
 27a:	b8 01 00 00 00       	mov    $0x1,%eax
 27f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	3c 2b                	cmp    $0x2b,%al
 28a:	74 0a                	je     296 <atoi+0x4a>
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	0f b6 00             	movzbl (%eax),%eax
 292:	3c 2d                	cmp    $0x2d,%al
 294:	75 2b                	jne    2c1 <atoi+0x75>
    s++;
 296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 29a:	eb 25                	jmp    2c1 <atoi+0x75>
    n = n*10 + *s++ - '0';
 29c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29f:	89 d0                	mov    %edx,%eax
 2a1:	c1 e0 02             	shl    $0x2,%eax
 2a4:	01 d0                	add    %edx,%eax
 2a6:	01 c0                	add    %eax,%eax
 2a8:	89 c1                	mov    %eax,%ecx
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	8d 50 01             	lea    0x1(%eax),%edx
 2b0:	89 55 08             	mov    %edx,0x8(%ebp)
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	0f be c0             	movsbl %al,%eax
 2b9:	01 c8                	add    %ecx,%eax
 2bb:	83 e8 30             	sub    $0x30,%eax
 2be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	3c 2f                	cmp    $0x2f,%al
 2c9:	7e 0a                	jle    2d5 <atoi+0x89>
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3c 39                	cmp    $0x39,%al
 2d3:	7e c7                	jle    29c <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2d8:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f0:	eb 17                	jmp    309 <memmove+0x2b>
    *dst++ = *src++;
 2f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f5:	8d 50 01             	lea    0x1(%eax),%edx
 2f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2fe:	8d 4a 01             	lea    0x1(%edx),%ecx
 301:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 304:	0f b6 12             	movzbl (%edx),%edx
 307:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 309:	8b 45 10             	mov    0x10(%ebp),%eax
 30c:	8d 50 ff             	lea    -0x1(%eax),%edx
 30f:	89 55 10             	mov    %edx,0x10(%ebp)
 312:	85 c0                	test   %eax,%eax
 314:	7f dc                	jg     2f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 316:	8b 45 08             	mov    0x8(%ebp),%eax
}
 319:	c9                   	leave  
 31a:	c3                   	ret    

0000031b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31b:	b8 01 00 00 00       	mov    $0x1,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exit>:
SYSCALL(exit)
 323:	b8 02 00 00 00       	mov    $0x2,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <wait>:
SYSCALL(wait)
 32b:	b8 03 00 00 00       	mov    $0x3,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <pipe>:
SYSCALL(pipe)
 333:	b8 04 00 00 00       	mov    $0x4,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <read>:
SYSCALL(read)
 33b:	b8 05 00 00 00       	mov    $0x5,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <write>:
SYSCALL(write)
 343:	b8 10 00 00 00       	mov    $0x10,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <close>:
SYSCALL(close)
 34b:	b8 15 00 00 00       	mov    $0x15,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <kill>:
SYSCALL(kill)
 353:	b8 06 00 00 00       	mov    $0x6,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <exec>:
SYSCALL(exec)
 35b:	b8 07 00 00 00       	mov    $0x7,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <open>:
SYSCALL(open)
 363:	b8 0f 00 00 00       	mov    $0xf,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mknod>:
SYSCALL(mknod)
 36b:	b8 11 00 00 00       	mov    $0x11,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <unlink>:
SYSCALL(unlink)
 373:	b8 12 00 00 00       	mov    $0x12,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <fstat>:
SYSCALL(fstat)
 37b:	b8 08 00 00 00       	mov    $0x8,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <link>:
SYSCALL(link)
 383:	b8 13 00 00 00       	mov    $0x13,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mkdir>:
SYSCALL(mkdir)
 38b:	b8 14 00 00 00       	mov    $0x14,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <chdir>:
SYSCALL(chdir)
 393:	b8 09 00 00 00       	mov    $0x9,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <dup>:
SYSCALL(dup)
 39b:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getpid>:
SYSCALL(getpid)
 3a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <sbrk>:
SYSCALL(sbrk)
 3ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <sleep>:
SYSCALL(sleep)
 3b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <uptime>:
SYSCALL(uptime)
 3bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <halt>:
SYSCALL(halt)
 3c3:	b8 16 00 00 00       	mov    $0x16,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <date>:
SYSCALL(date)
 3cb:	b8 17 00 00 00       	mov    $0x17,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <getuid>:
SYSCALL(getuid)
 3d3:	b8 18 00 00 00       	mov    $0x18,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <getgid>:
SYSCALL(getgid)
 3db:	b8 19 00 00 00       	mov    $0x19,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getppid>:
SYSCALL(getppid)
 3e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <setuid>:
SYSCALL(setuid)
 3eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <setgid>:
SYSCALL(setgid)
 3f3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <getprocs>:
SYSCALL(getprocs)
 3fb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	83 ec 18             	sub    $0x18,%esp
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	6a 01                	push   $0x1
 414:	8d 45 f4             	lea    -0xc(%ebp),%eax
 417:	50                   	push   %eax
 418:	ff 75 08             	pushl  0x8(%ebp)
 41b:	e8 23 ff ff ff       	call   343 <write>
 420:	83 c4 10             	add    $0x10,%esp
}
 423:	90                   	nop
 424:	c9                   	leave  
 425:	c3                   	ret    

00000426 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 426:	55                   	push   %ebp
 427:	89 e5                	mov    %esp,%ebp
 429:	53                   	push   %ebx
 42a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 434:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 438:	74 17                	je     451 <printint+0x2b>
 43a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43e:	79 11                	jns    451 <printint+0x2b>
    neg = 1;
 440:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 447:	8b 45 0c             	mov    0xc(%ebp),%eax
 44a:	f7 d8                	neg    %eax
 44c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44f:	eb 06                	jmp    457 <printint+0x31>
  } else {
    x = xx;
 451:	8b 45 0c             	mov    0xc(%ebp),%eax
 454:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 457:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 461:	8d 41 01             	lea    0x1(%ecx),%eax
 464:	89 45 f4             	mov    %eax,-0xc(%ebp)
 467:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46d:	ba 00 00 00 00       	mov    $0x0,%edx
 472:	f7 f3                	div    %ebx
 474:	89 d0                	mov    %edx,%eax
 476:	0f b6 80 f0 0a 00 00 	movzbl 0xaf0(%eax),%eax
 47d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 481:	8b 5d 10             	mov    0x10(%ebp),%ebx
 484:	8b 45 ec             	mov    -0x14(%ebp),%eax
 487:	ba 00 00 00 00       	mov    $0x0,%edx
 48c:	f7 f3                	div    %ebx
 48e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 491:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 495:	75 c7                	jne    45e <printint+0x38>
  if(neg)
 497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49b:	74 2d                	je     4ca <printint+0xa4>
    buf[i++] = '-';
 49d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a0:	8d 50 01             	lea    0x1(%eax),%edx
 4a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ab:	eb 1d                	jmp    4ca <printint+0xa4>
    putc(fd, buf[i]);
 4ad:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b3:	01 d0                	add    %edx,%eax
 4b5:	0f b6 00             	movzbl (%eax),%eax
 4b8:	0f be c0             	movsbl %al,%eax
 4bb:	83 ec 08             	sub    $0x8,%esp
 4be:	50                   	push   %eax
 4bf:	ff 75 08             	pushl  0x8(%ebp)
 4c2:	e8 3c ff ff ff       	call   403 <putc>
 4c7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d2:	79 d9                	jns    4ad <printint+0x87>
    putc(fd, buf[i]);
}
 4d4:	90                   	nop
 4d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d8:	c9                   	leave  
 4d9:	c3                   	ret    

000004da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ea:	83 c0 04             	add    $0x4,%eax
 4ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f7:	e9 59 01 00 00       	jmp    655 <printf+0x17b>
    c = fmt[i] & 0xff;
 4fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 502:	01 d0                	add    %edx,%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	25 ff 00 00 00       	and    $0xff,%eax
 50f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 516:	75 2c                	jne    544 <printf+0x6a>
      if(c == '%'){
 518:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51c:	75 0c                	jne    52a <printf+0x50>
        state = '%';
 51e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 525:	e9 27 01 00 00       	jmp    651 <printf+0x177>
      } else {
        putc(fd, c);
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 c7 fe ff ff       	call   403 <putc>
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	e9 0d 01 00 00       	jmp    651 <printf+0x177>
      }
    } else if(state == '%'){
 544:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 548:	0f 85 03 01 00 00    	jne    651 <printf+0x177>
      if(c == 'd'){
 54e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 552:	75 1e                	jne    572 <printf+0x98>
        printint(fd, *ap, 10, 1);
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	6a 01                	push   $0x1
 55b:	6a 0a                	push   $0xa
 55d:	50                   	push   %eax
 55e:	ff 75 08             	pushl  0x8(%ebp)
 561:	e8 c0 fe ff ff       	call   426 <printint>
 566:	83 c4 10             	add    $0x10,%esp
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56d:	e9 d8 00 00 00       	jmp    64a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 572:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 576:	74 06                	je     57e <printf+0xa4>
 578:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 57c:	75 1e                	jne    59c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 57e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 581:	8b 00                	mov    (%eax),%eax
 583:	6a 00                	push   $0x0
 585:	6a 10                	push   $0x10
 587:	50                   	push   %eax
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 96 fe ff ff       	call   426 <printint>
 590:	83 c4 10             	add    $0x10,%esp
        ap++;
 593:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 597:	e9 ae 00 00 00       	jmp    64a <printf+0x170>
      } else if(c == 's'){
 59c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a0:	75 43                	jne    5e5 <printf+0x10b>
        s = (char*)*ap;
 5a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a5:	8b 00                	mov    (%eax),%eax
 5a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b2:	75 25                	jne    5d9 <printf+0xff>
          s = "(null)";
 5b4:	c7 45 f4 a8 08 00 00 	movl   $0x8a8,-0xc(%ebp)
        while(*s != 0){
 5bb:	eb 1c                	jmp    5d9 <printf+0xff>
          putc(fd, *s);
 5bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 31 fe ff ff       	call   403 <putc>
 5d2:	83 c4 10             	add    $0x10,%esp
          s++;
 5d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	84 c0                	test   %al,%al
 5e1:	75 da                	jne    5bd <printf+0xe3>
 5e3:	eb 65                	jmp    64a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e9:	75 1d                	jne    608 <printf+0x12e>
        putc(fd, *ap);
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 04 fe ff ff       	call   403 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 602:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 606:	eb 42                	jmp    64a <printf+0x170>
      } else if(c == '%'){
 608:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60c:	75 17                	jne    625 <printf+0x14b>
        putc(fd, c);
 60e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 611:	0f be c0             	movsbl %al,%eax
 614:	83 ec 08             	sub    $0x8,%esp
 617:	50                   	push   %eax
 618:	ff 75 08             	pushl  0x8(%ebp)
 61b:	e8 e3 fd ff ff       	call   403 <putc>
 620:	83 c4 10             	add    $0x10,%esp
 623:	eb 25                	jmp    64a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 625:	83 ec 08             	sub    $0x8,%esp
 628:	6a 25                	push   $0x25
 62a:	ff 75 08             	pushl  0x8(%ebp)
 62d:	e8 d1 fd ff ff       	call   403 <putc>
 632:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	83 ec 08             	sub    $0x8,%esp
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 bc fd ff ff       	call   403 <putc>
 647:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 64a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 651:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 655:	8b 55 0c             	mov    0xc(%ebp),%edx
 658:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65b:	01 d0                	add    %edx,%eax
 65d:	0f b6 00             	movzbl (%eax),%eax
 660:	84 c0                	test   %al,%al
 662:	0f 85 94 fe ff ff    	jne    4fc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 668:	90                   	nop
 669:	c9                   	leave  
 66a:	c3                   	ret    

0000066b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66b:	55                   	push   %ebp
 66c:	89 e5                	mov    %esp,%ebp
 66e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 671:	8b 45 08             	mov    0x8(%ebp),%eax
 674:	83 e8 08             	sub    $0x8,%eax
 677:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 67f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 682:	eb 24                	jmp    6a8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68c:	77 12                	ja     6a0 <free+0x35>
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 694:	77 24                	ja     6ba <free+0x4f>
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69e:	77 1a                	ja     6ba <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ae:	76 d4                	jbe    684 <free+0x19>
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b8:	76 ca                	jbe    684 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 40 04             	mov    0x4(%eax),%eax
 6c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	01 c2                	add    %eax,%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	39 c2                	cmp    %eax,%edx
 6d3:	75 24                	jne    6f9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 50 04             	mov    0x4(%eax),%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	8b 40 04             	mov    0x4(%eax),%eax
 6e3:	01 c2                	add    %eax,%edx
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	89 10                	mov    %edx,(%eax)
 6f7:	eb 0a                	jmp    703 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 10                	mov    (%eax),%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 40 04             	mov    0x4(%eax),%eax
 709:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	01 d0                	add    %edx,%eax
 715:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 718:	75 20                	jne    73a <free+0xcf>
    p->s.size += bp->s.size;
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	01 c2                	add    %eax,%edx
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
 738:	eb 08                	jmp    742 <free+0xd7>
  } else
    p->s.ptr = bp;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 740:	89 10                	mov    %edx,(%eax)
  freep = p;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	a3 0c 0b 00 00       	mov    %eax,0xb0c
}
 74a:	90                   	nop
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <morecore>:

static Header*
morecore(uint nu)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 753:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75a:	77 07                	ja     763 <morecore+0x16>
    nu = 4096;
 75c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	c1 e0 03             	shl    $0x3,%eax
 769:	83 ec 0c             	sub    $0xc,%esp
 76c:	50                   	push   %eax
 76d:	e8 39 fc ff ff       	call   3ab <sbrk>
 772:	83 c4 10             	add    $0x10,%esp
 775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 778:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77c:	75 07                	jne    785 <morecore+0x38>
    return 0;
 77e:	b8 00 00 00 00       	mov    $0x0,%eax
 783:	eb 26                	jmp    7ab <morecore+0x5e>
  hp = (Header*)p;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	8b 55 08             	mov    0x8(%ebp),%edx
 791:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	83 c0 08             	add    $0x8,%eax
 79a:	83 ec 0c             	sub    $0xc,%esp
 79d:	50                   	push   %eax
 79e:	e8 c8 fe ff ff       	call   66b <free>
 7a3:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a6:	a1 0c 0b 00 00       	mov    0xb0c,%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <malloc>:

void*
malloc(uint nbytes)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	83 c0 07             	add    $0x7,%eax
 7b9:	c1 e8 03             	shr    $0x3,%eax
 7bc:	83 c0 01             	add    $0x1,%eax
 7bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c2:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ce:	75 23                	jne    7f3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 45 f0 04 0b 00 00 	movl   $0xb04,-0x10(%ebp)
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	a3 0c 0b 00 00       	mov    %eax,0xb0c
 7df:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7e4:	a3 04 0b 00 00       	mov    %eax,0xb04
    base.s.size = 0;
 7e9:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7f0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804:	72 4d                	jb     853 <malloc+0xa6>
      if(p->s.size == nunits)
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	75 0c                	jne    81d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f0             	mov    -0x10(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 26                	jmp    843 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	2b 45 ec             	sub    -0x14(%ebp),%eax
 826:	89 c2                	mov    %eax,%edx
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	c1 e0 03             	shl    $0x3,%eax
 837:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 840:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	a3 0c 0b 00 00       	mov    %eax,0xb0c
      return (void*)(p + 1);
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	83 c0 08             	add    $0x8,%eax
 851:	eb 3b                	jmp    88e <malloc+0xe1>
    }
    if(p == freep)
 853:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 858:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85b:	75 1e                	jne    87b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 85d:	83 ec 0c             	sub    $0xc,%esp
 860:	ff 75 ec             	pushl  -0x14(%ebp)
 863:	e8 e5 fe ff ff       	call   74d <morecore>
 868:	83 c4 10             	add    $0x10,%esp
 86b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 872:	75 07                	jne    87b <malloc+0xce>
        return 0;
 874:	b8 00 00 00 00       	mov    $0x0,%eax
 879:	eb 13                	jmp    88e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 889:	e9 6d ff ff ff       	jmp    7fb <malloc+0x4e>
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    
