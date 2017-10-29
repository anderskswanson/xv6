
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 aa 02 00 00       	call   2c0 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 34 03 00 00       	call   358 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 9c 02 00 00       	call   2c8 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 8c 01 00 00       	call   2e0 <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 51 01 00 00       	call   308 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 48 01 00 00       	call   320 <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 07 01 00 00       	call   2f0 <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fe:	eb 04                	jmp    204 <atoi+0x13>
 200:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	3c 20                	cmp    $0x20,%al
 20c:	74 f2                	je     200 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	3c 2d                	cmp    $0x2d,%al
 216:	75 07                	jne    21f <atoi+0x2e>
 218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21d:	eb 05                	jmp    224 <atoi+0x33>
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3c 2b                	cmp    $0x2b,%al
 22f:	74 0a                	je     23b <atoi+0x4a>
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	0f b6 00             	movzbl (%eax),%eax
 237:	3c 2d                	cmp    $0x2d,%al
 239:	75 2b                	jne    266 <atoi+0x75>
    s++;
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 25                	jmp    266 <atoi+0x75>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c1                	mov    %eax,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8d 50 01             	lea    0x1(%eax),%edx
 255:	89 55 08             	mov    %edx,0x8(%ebp)
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 c8                	add    %ecx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 2f                	cmp    $0x2f,%al
 26e:	7e 0a                	jle    27a <atoi+0x89>
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 39                	cmp    $0x39,%al
 278:	7e c7                	jle    241 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 27a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 295:	eb 17                	jmp    2ae <memmove+0x2b>
    *dst++ = *src++;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a9:	0f b6 12             	movzbl (%edx),%edx
 2ac:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	8b 45 10             	mov    0x10(%ebp),%eax
 2b1:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b4:	89 55 10             	mov    %edx,0x10(%ebp)
 2b7:	85 c0                	test   %eax,%eax
 2b9:	7f dc                	jg     297 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <halt>:
SYSCALL(halt)
 368:	b8 16 00 00 00       	mov    $0x16,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <date>:
SYSCALL(date)
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getuid>:
SYSCALL(getuid)
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getgid>:
SYSCALL(getgid)
 380:	b8 19 00 00 00       	mov    $0x19,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <getppid>:
SYSCALL(getppid)
 388:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <setuid>:
SYSCALL(setuid)
 390:	b8 1b 00 00 00       	mov    $0x1b,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <setgid>:
SYSCALL(setgid)
 398:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <getprocs>:
SYSCALL(getprocs)
 3a0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 18             	sub    $0x18,%esp
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b4:	83 ec 04             	sub    $0x4,%esp
 3b7:	6a 01                	push   $0x1
 3b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bc:	50                   	push   %eax
 3bd:	ff 75 08             	pushl  0x8(%ebp)
 3c0:	e8 23 ff ff ff       	call   2e8 <write>
 3c5:	83 c4 10             	add    $0x10,%esp
}
 3c8:	90                   	nop
 3c9:	c9                   	leave  
 3ca:	c3                   	ret    

000003cb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	53                   	push   %ebx
 3cf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3dd:	74 17                	je     3f6 <printint+0x2b>
 3df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e3:	79 11                	jns    3f6 <printint+0x2b>
    neg = 1;
 3e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	f7 d8                	neg    %eax
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f4:	eb 06                	jmp    3fc <printint+0x31>
  } else {
    x = xx;
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 403:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 406:	8d 41 01             	lea    0x1(%ecx),%eax
 409:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 412:	ba 00 00 00 00       	mov    $0x0,%edx
 417:	f7 f3                	div    %ebx
 419:	89 d0                	mov    %edx,%eax
 41b:	0f b6 80 84 0a 00 00 	movzbl 0xa84(%eax),%eax
 422:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 426:	8b 5d 10             	mov    0x10(%ebp),%ebx
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	ba 00 00 00 00       	mov    $0x0,%edx
 431:	f7 f3                	div    %ebx
 433:	89 45 ec             	mov    %eax,-0x14(%ebp)
 436:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43a:	75 c7                	jne    403 <printint+0x38>
  if(neg)
 43c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 440:	74 2d                	je     46f <printint+0xa4>
    buf[i++] = '-';
 442:	8b 45 f4             	mov    -0xc(%ebp),%eax
 445:	8d 50 01             	lea    0x1(%eax),%edx
 448:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 450:	eb 1d                	jmp    46f <printint+0xa4>
    putc(fd, buf[i]);
 452:	8d 55 dc             	lea    -0x24(%ebp),%edx
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	01 d0                	add    %edx,%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	83 ec 08             	sub    $0x8,%esp
 463:	50                   	push   %eax
 464:	ff 75 08             	pushl  0x8(%ebp)
 467:	e8 3c ff ff ff       	call   3a8 <putc>
 46c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 477:	79 d9                	jns    452 <printint+0x87>
    putc(fd, buf[i]);
}
 479:	90                   	nop
 47a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 47d:	c9                   	leave  
 47e:	c3                   	ret    

0000047f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48c:	8d 45 0c             	lea    0xc(%ebp),%eax
 48f:	83 c0 04             	add    $0x4,%eax
 492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49c:	e9 59 01 00 00       	jmp    5fa <printf+0x17b>
    c = fmt[i] & 0xff;
 4a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	0f b6 00             	movzbl (%eax),%eax
 4ac:	0f be c0             	movsbl %al,%eax
 4af:	25 ff 00 00 00       	and    $0xff,%eax
 4b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bb:	75 2c                	jne    4e9 <printf+0x6a>
      if(c == '%'){
 4bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c1:	75 0c                	jne    4cf <printf+0x50>
        state = '%';
 4c3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ca:	e9 27 01 00 00       	jmp    5f6 <printf+0x177>
      } else {
        putc(fd, c);
 4cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d2:	0f be c0             	movsbl %al,%eax
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	50                   	push   %eax
 4d9:	ff 75 08             	pushl  0x8(%ebp)
 4dc:	e8 c7 fe ff ff       	call   3a8 <putc>
 4e1:	83 c4 10             	add    $0x10,%esp
 4e4:	e9 0d 01 00 00       	jmp    5f6 <printf+0x177>
      }
    } else if(state == '%'){
 4e9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ed:	0f 85 03 01 00 00    	jne    5f6 <printf+0x177>
      if(c == 'd'){
 4f3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f7:	75 1e                	jne    517 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	6a 01                	push   $0x1
 500:	6a 0a                	push   $0xa
 502:	50                   	push   %eax
 503:	ff 75 08             	pushl  0x8(%ebp)
 506:	e8 c0 fe ff ff       	call   3cb <printint>
 50b:	83 c4 10             	add    $0x10,%esp
        ap++;
 50e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 512:	e9 d8 00 00 00       	jmp    5ef <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 517:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51b:	74 06                	je     523 <printf+0xa4>
 51d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 521:	75 1e                	jne    541 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 523:	8b 45 e8             	mov    -0x18(%ebp),%eax
 526:	8b 00                	mov    (%eax),%eax
 528:	6a 00                	push   $0x0
 52a:	6a 10                	push   $0x10
 52c:	50                   	push   %eax
 52d:	ff 75 08             	pushl  0x8(%ebp)
 530:	e8 96 fe ff ff       	call   3cb <printint>
 535:	83 c4 10             	add    $0x10,%esp
        ap++;
 538:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53c:	e9 ae 00 00 00       	jmp    5ef <printf+0x170>
      } else if(c == 's'){
 541:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 545:	75 43                	jne    58a <printf+0x10b>
        s = (char*)*ap;
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 557:	75 25                	jne    57e <printf+0xff>
          s = "(null)";
 559:	c7 45 f4 35 08 00 00 	movl   $0x835,-0xc(%ebp)
        while(*s != 0){
 560:	eb 1c                	jmp    57e <printf+0xff>
          putc(fd, *s);
 562:	8b 45 f4             	mov    -0xc(%ebp),%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	83 ec 08             	sub    $0x8,%esp
 56e:	50                   	push   %eax
 56f:	ff 75 08             	pushl  0x8(%ebp)
 572:	e8 31 fe ff ff       	call   3a8 <putc>
 577:	83 c4 10             	add    $0x10,%esp
          s++;
 57a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	0f b6 00             	movzbl (%eax),%eax
 584:	84 c0                	test   %al,%al
 586:	75 da                	jne    562 <printf+0xe3>
 588:	eb 65                	jmp    5ef <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58e:	75 1d                	jne    5ad <printf+0x12e>
        putc(fd, *ap);
 590:	8b 45 e8             	mov    -0x18(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	83 ec 08             	sub    $0x8,%esp
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 04 fe ff ff       	call   3a8 <putc>
 5a4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ab:	eb 42                	jmp    5ef <printf+0x170>
      } else if(c == '%'){
 5ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b1:	75 17                	jne    5ca <printf+0x14b>
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 e3 fd ff ff       	call   3a8 <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	eb 25                	jmp    5ef <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ca:	83 ec 08             	sub    $0x8,%esp
 5cd:	6a 25                	push   $0x25
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 d1 fd ff ff       	call   3a8 <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 bc fd ff ff       	call   3a8 <putc>
 5ec:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 600:	01 d0                	add    %edx,%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	84 c0                	test   %al,%al
 607:	0f 85 94 fe ff ff    	jne    4a1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 60d:	90                   	nop
 60e:	c9                   	leave  
 60f:	c3                   	ret    

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	83 e8 08             	sub    $0x8,%eax
 61c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61f:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 624:	89 45 fc             	mov    %eax,-0x4(%ebp)
 627:	eb 24                	jmp    64d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	77 12                	ja     645 <free+0x35>
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 24                	ja     65f <free+0x4f>
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 643:	77 1a                	ja     65f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 653:	76 d4                	jbe    629 <free+0x19>
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65d:	76 ca                	jbe    629 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	8b 40 04             	mov    0x4(%eax),%eax
 665:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	01 c2                	add    %eax,%edx
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	39 c2                	cmp    %eax,%edx
 678:	75 24                	jne    69e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	01 c2                	add    %eax,%edx
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
 69c:	eb 0a                	jmp    6a8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 10                	mov    (%eax),%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	01 d0                	add    %edx,%eax
 6ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bd:	75 20                	jne    6df <free+0xcf>
    p->s.size += bp->s.size;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 50 04             	mov    0x4(%eax),%edx
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	01 c2                	add    %eax,%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	8b 10                	mov    (%eax),%edx
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	89 10                	mov    %edx,(%eax)
 6dd:	eb 08                	jmp    6e7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	a3 a0 0a 00 00       	mov    %eax,0xaa0
}
 6ef:	90                   	nop
 6f0:	c9                   	leave  
 6f1:	c3                   	ret    

000006f2 <morecore>:

static Header*
morecore(uint nu)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ff:	77 07                	ja     708 <morecore+0x16>
    nu = 4096;
 701:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	c1 e0 03             	shl    $0x3,%eax
 70e:	83 ec 0c             	sub    $0xc,%esp
 711:	50                   	push   %eax
 712:	e8 39 fc ff ff       	call   350 <sbrk>
 717:	83 c4 10             	add    $0x10,%esp
 71a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 721:	75 07                	jne    72a <morecore+0x38>
    return 0;
 723:	b8 00 00 00 00       	mov    $0x0,%eax
 728:	eb 26                	jmp    750 <morecore+0x5e>
  hp = (Header*)p;
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	8b 55 08             	mov    0x8(%ebp),%edx
 736:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	83 c0 08             	add    $0x8,%eax
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	50                   	push   %eax
 743:	e8 c8 fe ff ff       	call   610 <free>
 748:	83 c4 10             	add    $0x10,%esp
  return freep;
 74b:	a1 a0 0a 00 00       	mov    0xaa0,%eax
}
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <malloc>:

void*
malloc(uint nbytes)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	83 c0 07             	add    $0x7,%eax
 75e:	c1 e8 03             	shr    $0x3,%eax
 761:	83 c0 01             	add    $0x1,%eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 767:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 76c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 773:	75 23                	jne    798 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 775:	c7 45 f0 98 0a 00 00 	movl   $0xa98,-0x10(%ebp)
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	a3 a0 0a 00 00       	mov    %eax,0xaa0
 784:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 789:	a3 98 0a 00 00       	mov    %eax,0xa98
    base.s.size = 0;
 78e:	c7 05 9c 0a 00 00 00 	movl   $0x0,0xa9c
 795:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a9:	72 4d                	jb     7f8 <malloc+0xa6>
      if(p->s.size == nunits)
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b4:	75 0c                	jne    7c2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 26                	jmp    7e8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cb:	89 c2                	mov    %eax,%edx
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	c1 e0 03             	shl    $0x3,%eax
 7dc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 a0 0a 00 00       	mov    %eax,0xaa0
      return (void*)(p + 1);
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	eb 3b                	jmp    833 <malloc+0xe1>
    }
    if(p == freep)
 7f8:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 7fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 800:	75 1e                	jne    820 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 802:	83 ec 0c             	sub    $0xc,%esp
 805:	ff 75 ec             	pushl  -0x14(%ebp)
 808:	e8 e5 fe ff ff       	call   6f2 <morecore>
 80d:	83 c4 10             	add    $0x10,%esp
 810:	89 45 f4             	mov    %eax,-0xc(%ebp)
 813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 817:	75 07                	jne    820 <malloc+0xce>
        return 0;
 819:	b8 00 00 00 00       	mov    $0x0,%eax
 81e:	eb 13                	jmp    833 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	89 45 f0             	mov    %eax,-0x10(%ebp)
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82e:	e9 6d ff ff ff       	jmp    7a0 <malloc+0x4e>
}
 833:	c9                   	leave  
 834:	c3                   	ret    
