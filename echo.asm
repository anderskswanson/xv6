
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 6e 08 00 00       	mov    $0x86e,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 70 08 00 00       	mov    $0x870,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 72 08 00 00       	push   $0x872
  4b:	6a 01                	push   $0x1
  4d:	e8 66 04 00 00       	call   4b8 <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 9c 02 00 00       	call   301 <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 8c 01 00 00       	call   319 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 51 01 00 00       	call   341 <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 48 01 00 00       	call   359 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 07 01 00 00       	call   329 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 237:	eb 04                	jmp    23d <atoi+0x13>
 239:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 20                	cmp    $0x20,%al
 245:	74 f2                	je     239 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 2d                	cmp    $0x2d,%al
 24f:	75 07                	jne    258 <atoi+0x2e>
 251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 256:	eb 05                	jmp    25d <atoi+0x33>
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	3c 2b                	cmp    $0x2b,%al
 268:	74 0a                	je     274 <atoi+0x4a>
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 2d                	cmp    $0x2d,%al
 272:	75 2b                	jne    29f <atoi+0x75>
    s++;
 274:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 278:	eb 25                	jmp    29f <atoi+0x75>
    n = n*10 + *s++ - '0';
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	89 d0                	mov    %edx,%eax
 27f:	c1 e0 02             	shl    $0x2,%eax
 282:	01 d0                	add    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	89 c1                	mov    %eax,%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 08             	mov    %edx,0x8(%ebp)
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	0f be c0             	movsbl %al,%eax
 297:	01 c8                	add    %ecx,%eax
 299:	83 e8 30             	sub    $0x30,%eax
 29c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2f                	cmp    $0x2f,%al
 2a7:	7e 0a                	jle    2b3 <atoi+0x89>
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 39                	cmp    $0x39,%al
 2b1:	7e c7                	jle    27a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ce:	eb 17                	jmp    2e7 <memmove+0x2b>
    *dst++ = *src++;
 2d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2df:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e2:	0f b6 12             	movzbl (%edx),%edx
 2e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ed:	89 55 10             	mov    %edx,0x10(%ebp)
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7f dc                	jg     2d0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exit>:
SYSCALL(exit)
 301:	b8 02 00 00 00       	mov    $0x2,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <wait>:
SYSCALL(wait)
 309:	b8 03 00 00 00       	mov    $0x3,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <pipe>:
SYSCALL(pipe)
 311:	b8 04 00 00 00       	mov    $0x4,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <read>:
SYSCALL(read)
 319:	b8 05 00 00 00       	mov    $0x5,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <write>:
SYSCALL(write)
 321:	b8 10 00 00 00       	mov    $0x10,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <close>:
SYSCALL(close)
 329:	b8 15 00 00 00       	mov    $0x15,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <kill>:
SYSCALL(kill)
 331:	b8 06 00 00 00       	mov    $0x6,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <exec>:
SYSCALL(exec)
 339:	b8 07 00 00 00       	mov    $0x7,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <open>:
SYSCALL(open)
 341:	b8 0f 00 00 00       	mov    $0xf,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <mknod>:
SYSCALL(mknod)
 349:	b8 11 00 00 00       	mov    $0x11,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <unlink>:
SYSCALL(unlink)
 351:	b8 12 00 00 00       	mov    $0x12,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <fstat>:
SYSCALL(fstat)
 359:	b8 08 00 00 00       	mov    $0x8,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <link>:
SYSCALL(link)
 361:	b8 13 00 00 00       	mov    $0x13,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mkdir>:
SYSCALL(mkdir)
 369:	b8 14 00 00 00       	mov    $0x14,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <chdir>:
SYSCALL(chdir)
 371:	b8 09 00 00 00       	mov    $0x9,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <dup>:
SYSCALL(dup)
 379:	b8 0a 00 00 00       	mov    $0xa,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <getpid>:
SYSCALL(getpid)
 381:	b8 0b 00 00 00       	mov    $0xb,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sbrk>:
SYSCALL(sbrk)
 389:	b8 0c 00 00 00       	mov    $0xc,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <sleep>:
SYSCALL(sleep)
 391:	b8 0d 00 00 00       	mov    $0xd,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <uptime>:
SYSCALL(uptime)
 399:	b8 0e 00 00 00       	mov    $0xe,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <halt>:
SYSCALL(halt)
 3a1:	b8 16 00 00 00       	mov    $0x16,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <date>:
SYSCALL(date)
 3a9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <getuid>:
SYSCALL(getuid)
 3b1:	b8 18 00 00 00       	mov    $0x18,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <getgid>:
SYSCALL(getgid)
 3b9:	b8 19 00 00 00       	mov    $0x19,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getppid>:
SYSCALL(getppid)
 3c1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <setuid>:
SYSCALL(setuid)
 3c9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <setgid>:
SYSCALL(setgid)
 3d1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <getprocs>:
SYSCALL(getprocs)
 3d9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 18             	sub    $0x18,%esp
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ed:	83 ec 04             	sub    $0x4,%esp
 3f0:	6a 01                	push   $0x1
 3f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f5:	50                   	push   %eax
 3f6:	ff 75 08             	pushl  0x8(%ebp)
 3f9:	e8 23 ff ff ff       	call   321 <write>
 3fe:	83 c4 10             	add    $0x10,%esp
}
 401:	90                   	nop
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	53                   	push   %ebx
 408:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 412:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 416:	74 17                	je     42f <printint+0x2b>
 418:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41c:	79 11                	jns    42f <printint+0x2b>
    neg = 1;
 41e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	f7 d8                	neg    %eax
 42a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42d:	eb 06                	jmp    435 <printint+0x31>
  } else {
    x = xx;
 42f:	8b 45 0c             	mov    0xc(%ebp),%eax
 432:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 435:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 43f:	8d 41 01             	lea    0x1(%ecx),%eax
 442:	89 45 f4             	mov    %eax,-0xc(%ebp)
 445:	8b 5d 10             	mov    0x10(%ebp),%ebx
 448:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44b:	ba 00 00 00 00       	mov    $0x0,%edx
 450:	f7 f3                	div    %ebx
 452:	89 d0                	mov    %edx,%eax
 454:	0f b6 80 cc 0a 00 00 	movzbl 0xacc(%eax),%eax
 45b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 45f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f3                	div    %ebx
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 473:	75 c7                	jne    43c <printint+0x38>
  if(neg)
 475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 479:	74 2d                	je     4a8 <printint+0xa4>
    buf[i++] = '-';
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	8d 50 01             	lea    0x1(%eax),%edx
 481:	89 55 f4             	mov    %edx,-0xc(%ebp)
 484:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 489:	eb 1d                	jmp    4a8 <printint+0xa4>
    putc(fd, buf[i]);
 48b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 491:	01 d0                	add    %edx,%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	0f be c0             	movsbl %al,%eax
 499:	83 ec 08             	sub    $0x8,%esp
 49c:	50                   	push   %eax
 49d:	ff 75 08             	pushl  0x8(%ebp)
 4a0:	e8 3c ff ff ff       	call   3e1 <putc>
 4a5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b0:	79 d9                	jns    48b <printint+0x87>
    putc(fd, buf[i]);
}
 4b2:	90                   	nop
 4b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4b6:	c9                   	leave  
 4b7:	c3                   	ret    

000004b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c8:	83 c0 04             	add    $0x4,%eax
 4cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d5:	e9 59 01 00 00       	jmp    633 <printf+0x17b>
    c = fmt[i] & 0xff;
 4da:	8b 55 0c             	mov    0xc(%ebp),%edx
 4dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e0:	01 d0                	add    %edx,%eax
 4e2:	0f b6 00             	movzbl (%eax),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	25 ff 00 00 00       	and    $0xff,%eax
 4ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f4:	75 2c                	jne    522 <printf+0x6a>
      if(c == '%'){
 4f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fa:	75 0c                	jne    508 <printf+0x50>
        state = '%';
 4fc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 503:	e9 27 01 00 00       	jmp    62f <printf+0x177>
      } else {
        putc(fd, c);
 508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50b:	0f be c0             	movsbl %al,%eax
 50e:	83 ec 08             	sub    $0x8,%esp
 511:	50                   	push   %eax
 512:	ff 75 08             	pushl  0x8(%ebp)
 515:	e8 c7 fe ff ff       	call   3e1 <putc>
 51a:	83 c4 10             	add    $0x10,%esp
 51d:	e9 0d 01 00 00       	jmp    62f <printf+0x177>
      }
    } else if(state == '%'){
 522:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 526:	0f 85 03 01 00 00    	jne    62f <printf+0x177>
      if(c == 'd'){
 52c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 530:	75 1e                	jne    550 <printf+0x98>
        printint(fd, *ap, 10, 1);
 532:	8b 45 e8             	mov    -0x18(%ebp),%eax
 535:	8b 00                	mov    (%eax),%eax
 537:	6a 01                	push   $0x1
 539:	6a 0a                	push   $0xa
 53b:	50                   	push   %eax
 53c:	ff 75 08             	pushl  0x8(%ebp)
 53f:	e8 c0 fe ff ff       	call   404 <printint>
 544:	83 c4 10             	add    $0x10,%esp
        ap++;
 547:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54b:	e9 d8 00 00 00       	jmp    628 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 550:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 554:	74 06                	je     55c <printf+0xa4>
 556:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55a:	75 1e                	jne    57a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 55c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55f:	8b 00                	mov    (%eax),%eax
 561:	6a 00                	push   $0x0
 563:	6a 10                	push   $0x10
 565:	50                   	push   %eax
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 96 fe ff ff       	call   404 <printint>
 56e:	83 c4 10             	add    $0x10,%esp
        ap++;
 571:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 575:	e9 ae 00 00 00       	jmp    628 <printf+0x170>
      } else if(c == 's'){
 57a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57e:	75 43                	jne    5c3 <printf+0x10b>
        s = (char*)*ap;
 580:	8b 45 e8             	mov    -0x18(%ebp),%eax
 583:	8b 00                	mov    (%eax),%eax
 585:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 590:	75 25                	jne    5b7 <printf+0xff>
          s = "(null)";
 592:	c7 45 f4 77 08 00 00 	movl   $0x877,-0xc(%ebp)
        while(*s != 0){
 599:	eb 1c                	jmp    5b7 <printf+0xff>
          putc(fd, *s);
 59b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	83 ec 08             	sub    $0x8,%esp
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 31 fe ff ff       	call   3e1 <putc>
 5b0:	83 c4 10             	add    $0x10,%esp
          s++;
 5b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	84 c0                	test   %al,%al
 5bf:	75 da                	jne    59b <printf+0xe3>
 5c1:	eb 65                	jmp    628 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c7:	75 1d                	jne    5e6 <printf+0x12e>
        putc(fd, *ap);
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	pushl  0x8(%ebp)
 5d8:	e8 04 fe ff ff       	call   3e1 <putc>
 5dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e4:	eb 42                	jmp    628 <printf+0x170>
      } else if(c == '%'){
 5e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ea:	75 17                	jne    603 <printf+0x14b>
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	83 ec 08             	sub    $0x8,%esp
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 e3 fd ff ff       	call   3e1 <putc>
 5fe:	83 c4 10             	add    $0x10,%esp
 601:	eb 25                	jmp    628 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 603:	83 ec 08             	sub    $0x8,%esp
 606:	6a 25                	push   $0x25
 608:	ff 75 08             	pushl  0x8(%ebp)
 60b:	e8 d1 fd ff ff       	call   3e1 <putc>
 610:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 bc fd ff ff       	call   3e1 <putc>
 625:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 628:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 633:	8b 55 0c             	mov    0xc(%ebp),%edx
 636:	8b 45 f0             	mov    -0x10(%ebp),%eax
 639:	01 d0                	add    %edx,%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	84 c0                	test   %al,%al
 640:	0f 85 94 fe ff ff    	jne    4da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 646:	90                   	nop
 647:	c9                   	leave  
 648:	c3                   	ret    

00000649 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	83 e8 08             	sub    $0x8,%eax
 655:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	a1 e8 0a 00 00       	mov    0xae8,%eax
 65d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 660:	eb 24                	jmp    686 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66a:	77 12                	ja     67e <free+0x35>
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 672:	77 24                	ja     698 <free+0x4f>
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67c:	77 1a                	ja     698 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	89 45 fc             	mov    %eax,-0x4(%ebp)
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68c:	76 d4                	jbe    662 <free+0x19>
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 696:	76 ca                	jbe    662 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	8b 40 04             	mov    0x4(%eax),%eax
 69e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	01 c2                	add    %eax,%edx
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	39 c2                	cmp    %eax,%edx
 6b1:	75 24                	jne    6d7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	01 c2                	add    %eax,%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
 6d5:	eb 0a                	jmp    6e1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 10                	mov    (%eax),%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	01 d0                	add    %edx,%eax
 6f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f6:	75 20                	jne    718 <free+0xcf>
    p->s.size += bp->s.size;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 50 04             	mov    0x4(%eax),%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	01 c2                	add    %eax,%edx
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	8b 10                	mov    (%eax),%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	89 10                	mov    %edx,(%eax)
 716:	eb 08                	jmp    720 <free+0xd7>
  } else
    p->s.ptr = bp;
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71e:	89 10                	mov    %edx,(%eax)
  freep = p;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	a3 e8 0a 00 00       	mov    %eax,0xae8
}
 728:	90                   	nop
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <morecore>:

static Header*
morecore(uint nu)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 731:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 738:	77 07                	ja     741 <morecore+0x16>
    nu = 4096;
 73a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 741:	8b 45 08             	mov    0x8(%ebp),%eax
 744:	c1 e0 03             	shl    $0x3,%eax
 747:	83 ec 0c             	sub    $0xc,%esp
 74a:	50                   	push   %eax
 74b:	e8 39 fc ff ff       	call   389 <sbrk>
 750:	83 c4 10             	add    $0x10,%esp
 753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 756:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 75a:	75 07                	jne    763 <morecore+0x38>
    return 0;
 75c:	b8 00 00 00 00       	mov    $0x0,%eax
 761:	eb 26                	jmp    789 <morecore+0x5e>
  hp = (Header*)p;
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	8b 55 08             	mov    0x8(%ebp),%edx
 76f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	83 c0 08             	add    $0x8,%eax
 778:	83 ec 0c             	sub    $0xc,%esp
 77b:	50                   	push   %eax
 77c:	e8 c8 fe ff ff       	call   649 <free>
 781:	83 c4 10             	add    $0x10,%esp
  return freep;
 784:	a1 e8 0a 00 00       	mov    0xae8,%eax
}
 789:	c9                   	leave  
 78a:	c3                   	ret    

0000078b <malloc>:

void*
malloc(uint nbytes)
{
 78b:	55                   	push   %ebp
 78c:	89 e5                	mov    %esp,%ebp
 78e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 791:	8b 45 08             	mov    0x8(%ebp),%eax
 794:	83 c0 07             	add    $0x7,%eax
 797:	c1 e8 03             	shr    $0x3,%eax
 79a:	83 c0 01             	add    $0x1,%eax
 79d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a0:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ac:	75 23                	jne    7d1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ae:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	a3 e8 0a 00 00       	mov    %eax,0xae8
 7bd:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7c2:	a3 e0 0a 00 00       	mov    %eax,0xae0
    base.s.size = 0;
 7c7:	c7 05 e4 0a 00 00 00 	movl   $0x0,0xae4
 7ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e2:	72 4d                	jb     831 <malloc+0xa6>
      if(p->s.size == nunits)
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ed:	75 0c                	jne    7fb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 10                	mov    (%eax),%edx
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	89 10                	mov    %edx,(%eax)
 7f9:	eb 26                	jmp    821 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	2b 45 ec             	sub    -0x14(%ebp),%eax
 804:	89 c2                	mov    %eax,%edx
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	c1 e0 03             	shl    $0x3,%eax
 815:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 81e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	a3 e8 0a 00 00       	mov    %eax,0xae8
      return (void*)(p + 1);
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	83 c0 08             	add    $0x8,%eax
 82f:	eb 3b                	jmp    86c <malloc+0xe1>
    }
    if(p == freep)
 831:	a1 e8 0a 00 00       	mov    0xae8,%eax
 836:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 839:	75 1e                	jne    859 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	ff 75 ec             	pushl  -0x14(%ebp)
 841:	e8 e5 fe ff ff       	call   72b <morecore>
 846:	83 c4 10             	add    $0x10,%esp
 849:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 850:	75 07                	jne    859 <malloc+0xce>
        return 0;
 852:	b8 00 00 00 00       	mov    $0x0,%eax
 857:	eb 13                	jmp    86c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 867:	e9 6d ff ff ff       	jmp    7d9 <malloc+0x4e>
}
 86c:	c9                   	leave  
 86d:	c3                   	ret    
