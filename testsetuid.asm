
_testsetuid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  11:	e8 69 03 00 00       	call   37f <getuid>
  16:	89 c2                	mov    %eax,%edx
  18:	8b 43 04             	mov    0x4(%ebx),%eax
  1b:	8b 00                	mov    (%eax),%eax
  1d:	52                   	push   %edx
  1e:	50                   	push   %eax
  1f:	68 5c 08 00 00       	push   $0x85c
  24:	6a 01                	push   $0x1
  26:	e8 7b 04 00 00       	call   4a6 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  exit();
  2e:	e8 9c 02 00 00       	call   2cf <exit>

00000033 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	57                   	push   %edi
  37:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 55 10             	mov    0x10(%ebp),%edx
  3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  41:	89 cb                	mov    %ecx,%ebx
  43:	89 df                	mov    %ebx,%edi
  45:	89 d1                	mov    %edx,%ecx
  47:	fc                   	cld    
  48:	f3 aa                	rep stos %al,%es:(%edi)
  4a:	89 ca                	mov    %ecx,%edx
  4c:	89 fb                	mov    %edi,%ebx
  4e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  51:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  54:	90                   	nop
  55:	5b                   	pop    %ebx
  56:	5f                   	pop    %edi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  65:	90                   	nop
  66:	8b 45 08             	mov    0x8(%ebp),%eax
  69:	8d 50 01             	lea    0x1(%eax),%edx
  6c:	89 55 08             	mov    %edx,0x8(%ebp)
  6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  72:	8d 4a 01             	lea    0x1(%edx),%ecx
  75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  78:	0f b6 12             	movzbl (%edx),%edx
  7b:	88 10                	mov    %dl,(%eax)
  7d:	0f b6 00             	movzbl (%eax),%eax
  80:	84 c0                	test   %al,%al
  82:	75 e2                	jne    66 <strcpy+0xd>
    ;
  return os;
  84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  87:	c9                   	leave  
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8c:	eb 08                	jmp    96 <strcmp+0xd>
    p++, q++;
  8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	84 c0                	test   %al,%al
  9e:	74 10                	je     b0 <strcmp+0x27>
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 10             	movzbl (%eax),%edx
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	0f b6 00             	movzbl (%eax),%eax
  ac:	38 c2                	cmp    %al,%dl
  ae:	74 de                	je     8e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	0f b6 d0             	movzbl %al,%edx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 c2                	sub    %eax,%edx
  c4:	89 d0                	mov    %edx,%eax
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strlen>:

uint
strlen(char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d5:	eb 04                	jmp    db <strlen+0x13>
  d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	01 d0                	add    %edx,%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	75 ed                	jne    d7 <strlen+0xf>
    ;
  return n;
  ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <memset>:

void*
memset(void *dst, int c, uint n)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f2:	8b 45 10             	mov    0x10(%ebp),%eax
  f5:	50                   	push   %eax
  f6:	ff 75 0c             	pushl  0xc(%ebp)
  f9:	ff 75 08             	pushl  0x8(%ebp)
  fc:	e8 32 ff ff ff       	call   33 <stosb>
 101:	83 c4 0c             	add    $0xc,%esp
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 42                	jmp    18d <gets+0x51>
    cc = read(0, &c, 1);
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	6a 01                	push   $0x1
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	50                   	push   %eax
 154:	6a 00                	push   $0x0
 156:	e8 8c 01 00 00       	call   2e7 <read>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 165:	7e 33                	jle    19a <gets+0x5e>
      break;
    buf[i++] = c;
 167:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16a:	8d 50 01             	lea    0x1(%eax),%edx
 16d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 170:	89 c2                	mov    %eax,%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 c2                	add    %eax,%edx
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 17d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 181:	3c 0a                	cmp    $0xa,%al
 183:	74 16                	je     19b <gets+0x5f>
 185:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 189:	3c 0d                	cmp    $0xd,%al
 18b:	74 0e                	je     19b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 190:	83 c0 01             	add    $0x1,%eax
 193:	3b 45 0c             	cmp    0xc(%ebp),%eax
 196:	7c b3                	jl     14b <gets+0xf>
 198:	eb 01                	jmp    19b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	6a 00                	push   $0x0
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	e8 51 01 00 00       	call   30f <open>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x26>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 25                	jmp    1f6 <stat+0x4b>
  r = fstat(fd, st);
 1d1:	83 ec 08             	sub    $0x8,%esp
 1d4:	ff 75 0c             	pushl  0xc(%ebp)
 1d7:	ff 75 f4             	pushl  -0xc(%ebp)
 1da:	e8 48 01 00 00       	call   327 <fstat>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e5:	83 ec 0c             	sub    $0xc,%esp
 1e8:	ff 75 f4             	pushl  -0xc(%ebp)
 1eb:	e8 07 01 00 00       	call   2f7 <close>
 1f0:	83 c4 10             	add    $0x10,%esp
  return r;
 1f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f6:	c9                   	leave  
 1f7:	c3                   	ret    

000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 205:	eb 04                	jmp    20b <atoi+0x13>
 207:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	3c 20                	cmp    $0x20,%al
 213:	74 f2                	je     207 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	3c 2d                	cmp    $0x2d,%al
 21d:	75 07                	jne    226 <atoi+0x2e>
 21f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 224:	eb 05                	jmp    22b <atoi+0x33>
 226:	b8 01 00 00 00       	mov    $0x1,%eax
 22b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3c 2b                	cmp    $0x2b,%al
 236:	74 0a                	je     242 <atoi+0x4a>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	3c 2d                	cmp    $0x2d,%al
 240:	75 2b                	jne    26d <atoi+0x75>
    s++;
 242:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x75>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x89>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 281:	8b 45 f8             	mov    -0x8(%ebp),%eax
 284:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getpid>:
SYSCALL(getpid)
 34f:	b8 0b 00 00 00       	mov    $0xb,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <halt>:
SYSCALL(halt)
 36f:	b8 16 00 00 00       	mov    $0x16,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <date>:
SYSCALL(date)
 377:	b8 17 00 00 00       	mov    $0x17,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <getuid>:
SYSCALL(getuid)
 37f:	b8 18 00 00 00       	mov    $0x18,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <getgid>:
SYSCALL(getgid)
 387:	b8 19 00 00 00       	mov    $0x19,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getppid>:
SYSCALL(getppid)
 38f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <setuid>:
SYSCALL(setuid)
 397:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <setgid>:
SYSCALL(setgid)
 39f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <getprocs>:
SYSCALL(getprocs)
 3a7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <setpriority>:
SYSCALL(setpriority)
 3af:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <chmod>:
SYSCALL(chmod)
 3b7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <chown>:
SYSCALL(chown)
 3bf:	b8 20 00 00 00       	mov    $0x20,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <chgrp>:
SYSCALL(chgrp)    
 3c7:	b8 21 00 00 00       	mov    $0x21,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 18             	sub    $0x18,%esp
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3db:	83 ec 04             	sub    $0x4,%esp
 3de:	6a 01                	push   $0x1
 3e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e3:	50                   	push   %eax
 3e4:	ff 75 08             	pushl  0x8(%ebp)
 3e7:	e8 03 ff ff ff       	call   2ef <write>
 3ec:	83 c4 10             	add    $0x10,%esp
}
 3ef:	90                   	nop
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	53                   	push   %ebx
 3f6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 400:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 404:	74 17                	je     41d <printint+0x2b>
 406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40a:	79 11                	jns    41d <printint+0x2b>
    neg = 1;
 40c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	f7 d8                	neg    %eax
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41b:	eb 06                	jmp    423 <printint+0x31>
  } else {
    x = xx;
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 42a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42d:	8d 41 01             	lea    0x1(%ecx),%eax
 430:	89 45 f4             	mov    %eax,-0xc(%ebp)
 433:	8b 5d 10             	mov    0x10(%ebp),%ebx
 436:	8b 45 ec             	mov    -0x14(%ebp),%eax
 439:	ba 00 00 00 00       	mov    $0x0,%edx
 43e:	f7 f3                	div    %ebx
 440:	89 d0                	mov    %edx,%eax
 442:	0f b6 80 cc 0a 00 00 	movzbl 0xacc(%eax),%eax
 449:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 450:	8b 45 ec             	mov    -0x14(%ebp),%eax
 453:	ba 00 00 00 00       	mov    $0x0,%edx
 458:	f7 f3                	div    %ebx
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 461:	75 c7                	jne    42a <printint+0x38>
  if(neg)
 463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 467:	74 2d                	je     496 <printint+0xa4>
    buf[i++] = '-';
 469:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46c:	8d 50 01             	lea    0x1(%eax),%edx
 46f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 472:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 477:	eb 1d                	jmp    496 <printint+0xa4>
    putc(fd, buf[i]);
 479:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	83 ec 08             	sub    $0x8,%esp
 48a:	50                   	push   %eax
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 3c ff ff ff       	call   3cf <putc>
 493:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 496:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 49a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49e:	79 d9                	jns    479 <printint+0x87>
    putc(fd, buf[i]);
}
 4a0:	90                   	nop
 4a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b6:	83 c0 04             	add    $0x4,%eax
 4b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c3:	e9 59 01 00 00       	jmp    621 <printf+0x17b>
    c = fmt[i] & 0xff;
 4c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ce:	01 d0                	add    %edx,%eax
 4d0:	0f b6 00             	movzbl (%eax),%eax
 4d3:	0f be c0             	movsbl %al,%eax
 4d6:	25 ff 00 00 00       	and    $0xff,%eax
 4db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e2:	75 2c                	jne    510 <printf+0x6a>
      if(c == '%'){
 4e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e8:	75 0c                	jne    4f6 <printf+0x50>
        state = '%';
 4ea:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f1:	e9 27 01 00 00       	jmp    61d <printf+0x177>
      } else {
        putc(fd, c);
 4f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f9:	0f be c0             	movsbl %al,%eax
 4fc:	83 ec 08             	sub    $0x8,%esp
 4ff:	50                   	push   %eax
 500:	ff 75 08             	pushl  0x8(%ebp)
 503:	e8 c7 fe ff ff       	call   3cf <putc>
 508:	83 c4 10             	add    $0x10,%esp
 50b:	e9 0d 01 00 00       	jmp    61d <printf+0x177>
      }
    } else if(state == '%'){
 510:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 514:	0f 85 03 01 00 00    	jne    61d <printf+0x177>
      if(c == 'd'){
 51a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51e:	75 1e                	jne    53e <printf+0x98>
        printint(fd, *ap, 10, 1);
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	6a 01                	push   $0x1
 527:	6a 0a                	push   $0xa
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 c0 fe ff ff       	call   3f2 <printint>
 532:	83 c4 10             	add    $0x10,%esp
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	e9 d8 00 00 00       	jmp    616 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 542:	74 06                	je     54a <printf+0xa4>
 544:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 548:	75 1e                	jne    568 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	6a 00                	push   $0x0
 551:	6a 10                	push   $0x10
 553:	50                   	push   %eax
 554:	ff 75 08             	pushl  0x8(%ebp)
 557:	e8 96 fe ff ff       	call   3f2 <printint>
 55c:	83 c4 10             	add    $0x10,%esp
        ap++;
 55f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 563:	e9 ae 00 00 00       	jmp    616 <printf+0x170>
      } else if(c == 's'){
 568:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56c:	75 43                	jne    5b1 <printf+0x10b>
        s = (char*)*ap;
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 576:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57e:	75 25                	jne    5a5 <printf+0xff>
          s = "(null)";
 580:	c7 45 f4 78 08 00 00 	movl   $0x878,-0xc(%ebp)
        while(*s != 0){
 587:	eb 1c                	jmp    5a5 <printf+0xff>
          putc(fd, *s);
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 31 fe ff ff       	call   3cf <putc>
 59e:	83 c4 10             	add    $0x10,%esp
          s++;
 5a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	84 c0                	test   %al,%al
 5ad:	75 da                	jne    589 <printf+0xe3>
 5af:	eb 65                	jmp    616 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b5:	75 1d                	jne    5d4 <printf+0x12e>
        putc(fd, *ap);
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	83 ec 08             	sub    $0x8,%esp
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 04 fe ff ff       	call   3cf <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	eb 42                	jmp    616 <printf+0x170>
      } else if(c == '%'){
 5d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d8:	75 17                	jne    5f1 <printf+0x14b>
        putc(fd, c);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 e3 fd ff ff       	call   3cf <putc>
 5ec:	83 c4 10             	add    $0x10,%esp
 5ef:	eb 25                	jmp    616 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	6a 25                	push   $0x25
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 d1 fd ff ff       	call   3cf <putc>
 5fe:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	83 ec 08             	sub    $0x8,%esp
 60a:	50                   	push   %eax
 60b:	ff 75 08             	pushl  0x8(%ebp)
 60e:	e8 bc fd ff ff       	call   3cf <putc>
 613:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 616:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 621:	8b 55 0c             	mov    0xc(%ebp),%edx
 624:	8b 45 f0             	mov    -0x10(%ebp),%eax
 627:	01 d0                	add    %edx,%eax
 629:	0f b6 00             	movzbl (%eax),%eax
 62c:	84 c0                	test   %al,%al
 62e:	0f 85 94 fe ff ff    	jne    4c8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 634:	90                   	nop
 635:	c9                   	leave  
 636:	c3                   	ret    

00000637 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	83 e8 08             	sub    $0x8,%eax
 643:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	a1 e8 0a 00 00       	mov    0xae8,%eax
 64b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64e:	eb 24                	jmp    674 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	77 12                	ja     66c <free+0x35>
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	77 24                	ja     686 <free+0x4f>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	77 1a                	ja     686 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	89 45 fc             	mov    %eax,-0x4(%ebp)
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67a:	76 d4                	jbe    650 <free+0x19>
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 684:	76 ca                	jbe    650 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	01 c2                	add    %eax,%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	39 c2                	cmp    %eax,%edx
 69f:	75 24                	jne    6c5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	01 c2                	add    %eax,%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	89 10                	mov    %edx,(%eax)
 6c3:	eb 0a                	jmp    6cf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	01 d0                	add    %edx,%eax
 6e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e4:	75 20                	jne    706 <free+0xcf>
    p->s.size += bp->s.size;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 50 04             	mov    0x4(%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	01 c2                	add    %eax,%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	89 10                	mov    %edx,(%eax)
 704:	eb 08                	jmp    70e <free+0xd7>
  } else
    p->s.ptr = bp;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70c:	89 10                	mov    %edx,(%eax)
  freep = p;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	a3 e8 0a 00 00       	mov    %eax,0xae8
}
 716:	90                   	nop
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <morecore>:

static Header*
morecore(uint nu)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 726:	77 07                	ja     72f <morecore+0x16>
    nu = 4096;
 728:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	c1 e0 03             	shl    $0x3,%eax
 735:	83 ec 0c             	sub    $0xc,%esp
 738:	50                   	push   %eax
 739:	e8 19 fc ff ff       	call   357 <sbrk>
 73e:	83 c4 10             	add    $0x10,%esp
 741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 744:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 748:	75 07                	jne    751 <morecore+0x38>
    return 0;
 74a:	b8 00 00 00 00       	mov    $0x0,%eax
 74f:	eb 26                	jmp    777 <morecore+0x5e>
  hp = (Header*)p;
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	8b 55 08             	mov    0x8(%ebp),%edx
 75d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	83 c0 08             	add    $0x8,%eax
 766:	83 ec 0c             	sub    $0xc,%esp
 769:	50                   	push   %eax
 76a:	e8 c8 fe ff ff       	call   637 <free>
 76f:	83 c4 10             	add    $0x10,%esp
  return freep;
 772:	a1 e8 0a 00 00       	mov    0xae8,%eax
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <malloc>:

void*
malloc(uint nbytes)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	83 c0 07             	add    $0x7,%eax
 785:	c1 e8 03             	shr    $0x3,%eax
 788:	83 c0 01             	add    $0x1,%eax
 78b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78e:	a1 e8 0a 00 00       	mov    0xae8,%eax
 793:	89 45 f0             	mov    %eax,-0x10(%ebp)
 796:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79a:	75 23                	jne    7bf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79c:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	a3 e8 0a 00 00       	mov    %eax,0xae8
 7ab:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7b0:	a3 e0 0a 00 00       	mov    %eax,0xae0
    base.s.size = 0;
 7b5:	c7 05 e4 0a 00 00 00 	movl   $0x0,0xae4
 7bc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d0:	72 4d                	jb     81f <malloc+0xa6>
      if(p->s.size == nunits)
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7db:	75 0c                	jne    7e9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 10                	mov    (%eax),%edx
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	89 10                	mov    %edx,(%eax)
 7e7:	eb 26                	jmp    80f <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f2:	89 c2                	mov    %eax,%edx
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	c1 e0 03             	shl    $0x3,%eax
 803:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	a3 e8 0a 00 00       	mov    %eax,0xae8
      return (void*)(p + 1);
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	eb 3b                	jmp    85a <malloc+0xe1>
    }
    if(p == freep)
 81f:	a1 e8 0a 00 00       	mov    0xae8,%eax
 824:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 827:	75 1e                	jne    847 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 829:	83 ec 0c             	sub    $0xc,%esp
 82c:	ff 75 ec             	pushl  -0x14(%ebp)
 82f:	e8 e5 fe ff ff       	call   719 <morecore>
 834:	83 c4 10             	add    $0x10,%esp
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
 83a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83e:	75 07                	jne    847 <malloc+0xce>
        return 0;
 840:	b8 00 00 00 00       	mov    $0x0,%eax
 845:	eb 13                	jmp    85a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 855:	e9 6d ff ff ff       	jmp    7c7 <malloc+0x4e>
}
 85a:	c9                   	leave  
 85b:	c3                   	ret    
