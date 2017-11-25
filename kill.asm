
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 9b 08 00 00       	push   $0x89b
  21:	6a 02                	push   $0x2
  23:	e8 bd 04 00 00       	call   4e5 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 de 02 00 00       	call   30e <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 df 02 00 00       	call   33e <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 9c 02 00 00       	call   30e <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 8c 01 00 00       	call   326 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 51 01 00 00       	call   34e <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 48 01 00 00       	call   366 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 07 01 00 00       	call   336 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 244:	eb 04                	jmp    24a <atoi+0x13>
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 20                	cmp    $0x20,%al
 252:	74 f2                	je     246 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	3c 2d                	cmp    $0x2d,%al
 25c:	75 07                	jne    265 <atoi+0x2e>
 25e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 263:	eb 05                	jmp    26a <atoi+0x33>
 265:	b8 01 00 00 00       	mov    $0x1,%eax
 26a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2b                	cmp    $0x2b,%al
 275:	74 0a                	je     281 <atoi+0x4a>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2d                	cmp    $0x2d,%al
 27f:	75 2b                	jne    2ac <atoi+0x75>
    s++;
 281:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 285:	eb 25                	jmp    2ac <atoi+0x75>
    n = n*10 + *s++ - '0';
 287:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28a:	89 d0                	mov    %edx,%eax
 28c:	c1 e0 02             	shl    $0x2,%eax
 28f:	01 d0                	add    %edx,%eax
 291:	01 c0                	add    %eax,%eax
 293:	89 c1                	mov    %eax,%ecx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8d 50 01             	lea    0x1(%eax),%edx
 29b:	89 55 08             	mov    %edx,0x8(%ebp)
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	0f be c0             	movsbl %al,%eax
 2a4:	01 c8                	add    %ecx,%eax
 2a6:	83 e8 30             	sub    $0x30,%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	3c 2f                	cmp    $0x2f,%al
 2b4:	7e 0a                	jle    2c0 <atoi+0x89>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	3c 39                	cmp    $0x39,%al
 2be:	7e c7                	jle    287 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2db:	eb 17                	jmp    2f4 <memmove+0x2b>
    *dst++ = *src++;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ec:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ef:	0f b6 12             	movzbl (%edx),%edx
 2f2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fa:	89 55 10             	mov    %edx,0x10(%ebp)
 2fd:	85 c0                	test   %eax,%eax
 2ff:	7f dc                	jg     2dd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 306:	b8 01 00 00 00       	mov    $0x1,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exit>:
SYSCALL(exit)
 30e:	b8 02 00 00 00       	mov    $0x2,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <wait>:
SYSCALL(wait)
 316:	b8 03 00 00 00       	mov    $0x3,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <pipe>:
SYSCALL(pipe)
 31e:	b8 04 00 00 00       	mov    $0x4,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <read>:
SYSCALL(read)
 326:	b8 05 00 00 00       	mov    $0x5,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <write>:
SYSCALL(write)
 32e:	b8 10 00 00 00       	mov    $0x10,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <close>:
SYSCALL(close)
 336:	b8 15 00 00 00       	mov    $0x15,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <kill>:
SYSCALL(kill)
 33e:	b8 06 00 00 00       	mov    $0x6,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <exec>:
SYSCALL(exec)
 346:	b8 07 00 00 00       	mov    $0x7,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <open>:
SYSCALL(open)
 34e:	b8 0f 00 00 00       	mov    $0xf,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mknod>:
SYSCALL(mknod)
 356:	b8 11 00 00 00       	mov    $0x11,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <unlink>:
SYSCALL(unlink)
 35e:	b8 12 00 00 00       	mov    $0x12,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <fstat>:
SYSCALL(fstat)
 366:	b8 08 00 00 00       	mov    $0x8,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <link>:
SYSCALL(link)
 36e:	b8 13 00 00 00       	mov    $0x13,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <mkdir>:
SYSCALL(mkdir)
 376:	b8 14 00 00 00       	mov    $0x14,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <chdir>:
SYSCALL(chdir)
 37e:	b8 09 00 00 00       	mov    $0x9,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <dup>:
SYSCALL(dup)
 386:	b8 0a 00 00 00       	mov    $0xa,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <getpid>:
SYSCALL(getpid)
 38e:	b8 0b 00 00 00       	mov    $0xb,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <sbrk>:
SYSCALL(sbrk)
 396:	b8 0c 00 00 00       	mov    $0xc,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sleep>:
SYSCALL(sleep)
 39e:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <uptime>:
SYSCALL(uptime)
 3a6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <halt>:
SYSCALL(halt)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <date>:
SYSCALL(date)
 3b6:	b8 17 00 00 00       	mov    $0x17,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <getuid>:
SYSCALL(getuid)
 3be:	b8 18 00 00 00       	mov    $0x18,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <getgid>:
SYSCALL(getgid)
 3c6:	b8 19 00 00 00       	mov    $0x19,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <getppid>:
SYSCALL(getppid)
 3ce:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <setuid>:
SYSCALL(setuid)
 3d6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <setgid>:
SYSCALL(setgid)
 3de:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getprocs>:
SYSCALL(getprocs)
 3e6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <setpriority>:
SYSCALL(setpriority)
 3ee:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <chmod>:
SYSCALL(chmod)
 3f6:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <chown>:
SYSCALL(chown)
 3fe:	b8 20 00 00 00       	mov    $0x20,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <chgrp>:
SYSCALL(chgrp)    
 406:	b8 21 00 00 00       	mov    $0x21,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 18             	sub    $0x18,%esp
 414:	8b 45 0c             	mov    0xc(%ebp),%eax
 417:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41a:	83 ec 04             	sub    $0x4,%esp
 41d:	6a 01                	push   $0x1
 41f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 422:	50                   	push   %eax
 423:	ff 75 08             	pushl  0x8(%ebp)
 426:	e8 03 ff ff ff       	call   32e <write>
 42b:	83 c4 10             	add    $0x10,%esp
}
 42e:	90                   	nop
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	53                   	push   %ebx
 435:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 438:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 443:	74 17                	je     45c <printint+0x2b>
 445:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 449:	79 11                	jns    45c <printint+0x2b>
    neg = 1;
 44b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	f7 d8                	neg    %eax
 457:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45a:	eb 06                	jmp    462 <printint+0x31>
  } else {
    x = xx;
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 469:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 46c:	8d 41 01             	lea    0x1(%ecx),%eax
 46f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 472:	8b 5d 10             	mov    0x10(%ebp),%ebx
 475:	8b 45 ec             	mov    -0x14(%ebp),%eax
 478:	ba 00 00 00 00       	mov    $0x0,%edx
 47d:	f7 f3                	div    %ebx
 47f:	89 d0                	mov    %edx,%eax
 481:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 488:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 48c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 492:	ba 00 00 00 00       	mov    $0x0,%edx
 497:	f7 f3                	div    %ebx
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a0:	75 c7                	jne    469 <printint+0x38>
  if(neg)
 4a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a6:	74 2d                	je     4d5 <printint+0xa4>
    buf[i++] = '-';
 4a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ab:	8d 50 01             	lea    0x1(%eax),%edx
 4ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b6:	eb 1d                	jmp    4d5 <printint+0xa4>
    putc(fd, buf[i]);
 4b8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4be:	01 d0                	add    %edx,%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	0f be c0             	movsbl %al,%eax
 4c6:	83 ec 08             	sub    $0x8,%esp
 4c9:	50                   	push   %eax
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 3c ff ff ff       	call   40e <putc>
 4d2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	79 d9                	jns    4b8 <printint+0x87>
    putc(fd, buf[i]);
}
 4df:	90                   	nop
 4e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e3:	c9                   	leave  
 4e4:	c3                   	ret    

000004e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f5:	83 c0 04             	add    $0x4,%eax
 4f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 502:	e9 59 01 00 00       	jmp    660 <printf+0x17b>
    c = fmt[i] & 0xff;
 507:	8b 55 0c             	mov    0xc(%ebp),%edx
 50a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50d:	01 d0                	add    %edx,%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	25 ff 00 00 00       	and    $0xff,%eax
 51a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 521:	75 2c                	jne    54f <printf+0x6a>
      if(c == '%'){
 523:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 527:	75 0c                	jne    535 <printf+0x50>
        state = '%';
 529:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 530:	e9 27 01 00 00       	jmp    65c <printf+0x177>
      } else {
        putc(fd, c);
 535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	pushl  0x8(%ebp)
 542:	e8 c7 fe ff ff       	call   40e <putc>
 547:	83 c4 10             	add    $0x10,%esp
 54a:	e9 0d 01 00 00       	jmp    65c <printf+0x177>
      }
    } else if(state == '%'){
 54f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 553:	0f 85 03 01 00 00    	jne    65c <printf+0x177>
      if(c == 'd'){
 559:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55d:	75 1e                	jne    57d <printf+0x98>
        printint(fd, *ap, 10, 1);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	6a 01                	push   $0x1
 566:	6a 0a                	push   $0xa
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 c0 fe ff ff       	call   431 <printint>
 571:	83 c4 10             	add    $0x10,%esp
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	e9 d8 00 00 00       	jmp    655 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 581:	74 06                	je     589 <printf+0xa4>
 583:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 587:	75 1e                	jne    5a7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	6a 00                	push   $0x0
 590:	6a 10                	push   $0x10
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 96 fe ff ff       	call   431 <printint>
 59b:	83 c4 10             	add    $0x10,%esp
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 ae 00 00 00       	jmp    655 <printf+0x170>
      } else if(c == 's'){
 5a7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ab:	75 43                	jne    5f0 <printf+0x10b>
        s = (char*)*ap;
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bd:	75 25                	jne    5e4 <printf+0xff>
          s = "(null)";
 5bf:	c7 45 f4 af 08 00 00 	movl   $0x8af,-0xc(%ebp)
        while(*s != 0){
 5c6:	eb 1c                	jmp    5e4 <printf+0xff>
          putc(fd, *s);
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	pushl  0x8(%ebp)
 5d8:	e8 31 fe ff ff       	call   40e <putc>
 5dd:	83 c4 10             	add    $0x10,%esp
          s++;
 5e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	84 c0                	test   %al,%al
 5ec:	75 da                	jne    5c8 <printf+0xe3>
 5ee:	eb 65                	jmp    655 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f4:	75 1d                	jne    613 <printf+0x12e>
        putc(fd, *ap);
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	0f be c0             	movsbl %al,%eax
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 04 fe ff ff       	call   40e <putc>
 60a:	83 c4 10             	add    $0x10,%esp
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 611:	eb 42                	jmp    655 <printf+0x170>
      } else if(c == '%'){
 613:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 617:	75 17                	jne    630 <printf+0x14b>
        putc(fd, c);
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	50                   	push   %eax
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 e3 fd ff ff       	call   40e <putc>
 62b:	83 c4 10             	add    $0x10,%esp
 62e:	eb 25                	jmp    655 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 630:	83 ec 08             	sub    $0x8,%esp
 633:	6a 25                	push   $0x25
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 d1 fd ff ff       	call   40e <putc>
 63d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	83 ec 08             	sub    $0x8,%esp
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 bc fd ff ff       	call   40e <putc>
 652:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 655:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 660:	8b 55 0c             	mov    0xc(%ebp),%edx
 663:	8b 45 f0             	mov    -0x10(%ebp),%eax
 666:	01 d0                	add    %edx,%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	84 c0                	test   %al,%al
 66d:	0f 85 94 fe ff ff    	jne    507 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 673:	90                   	nop
 674:	c9                   	leave  
 675:	c3                   	ret    

00000676 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	55                   	push   %ebp
 677:	89 e5                	mov    %esp,%ebp
 679:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	83 e8 08             	sub    $0x8,%eax
 682:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 685:	a1 20 0b 00 00       	mov    0xb20,%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68d:	eb 24                	jmp    6b3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 697:	77 12                	ja     6ab <free+0x35>
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69f:	77 24                	ja     6c5 <free+0x4f>
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a9:	77 1a                	ja     6c5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	76 d4                	jbe    68f <free+0x19>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c3:	76 ca                	jbe    68f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	39 c2                	cmp    %eax,%edx
 6de:	75 24                	jne    704 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 50 04             	mov    0x4(%eax),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
 702:	eb 0a                	jmp    70e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 723:	75 20                	jne    745 <free+0xcf>
    p->s.size += bp->s.size;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 50 04             	mov    0x4(%eax),%edx
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	01 c2                	add    %eax,%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
 743:	eb 08                	jmp    74d <free+0xd7>
  } else
    p->s.ptr = bp;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74b:	89 10                	mov    %edx,(%eax)
  freep = p;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 755:	90                   	nop
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <morecore>:

static Header*
morecore(uint nu)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 765:	77 07                	ja     76e <morecore+0x16>
    nu = 4096;
 767:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	c1 e0 03             	shl    $0x3,%eax
 774:	83 ec 0c             	sub    $0xc,%esp
 777:	50                   	push   %eax
 778:	e8 19 fc ff ff       	call   396 <sbrk>
 77d:	83 c4 10             	add    $0x10,%esp
 780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 783:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 787:	75 07                	jne    790 <morecore+0x38>
    return 0;
 789:	b8 00 00 00 00       	mov    $0x0,%eax
 78e:	eb 26                	jmp    7b6 <morecore+0x5e>
  hp = (Header*)p;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	8b 55 08             	mov    0x8(%ebp),%edx
 79c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	83 c0 08             	add    $0x8,%eax
 7a5:	83 ec 0c             	sub    $0xc,%esp
 7a8:	50                   	push   %eax
 7a9:	e8 c8 fe ff ff       	call   676 <free>
 7ae:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b1:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <malloc>:

void*
malloc(uint nbytes)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	83 c0 07             	add    $0x7,%eax
 7c4:	c1 e8 03             	shr    $0x3,%eax
 7c7:	83 c0 01             	add    $0x1,%eax
 7ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7cd:	a1 20 0b 00 00       	mov    0xb20,%eax
 7d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d9:	75 23                	jne    7fe <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7db:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	a3 20 0b 00 00       	mov    %eax,0xb20
 7ea:	a1 20 0b 00 00       	mov    0xb20,%eax
 7ef:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7f4:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7fb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	72 4d                	jb     85e <malloc+0xa6>
      if(p->s.size == nunits)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81a:	75 0c                	jne    828 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 26                	jmp    84e <malloc+0x96>
      else {
        p->s.size -= nunits;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 831:	89 c2                	mov    %eax,%edx
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	c1 e0 03             	shl    $0x3,%eax
 842:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	83 c0 08             	add    $0x8,%eax
 85c:	eb 3b                	jmp    899 <malloc+0xe1>
    }
    if(p == freep)
 85e:	a1 20 0b 00 00       	mov    0xb20,%eax
 863:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 866:	75 1e                	jne    886 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	ff 75 ec             	pushl  -0x14(%ebp)
 86e:	e8 e5 fe ff ff       	call   758 <morecore>
 873:	83 c4 10             	add    $0x10,%esp
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
 879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87d:	75 07                	jne    886 <malloc+0xce>
        return 0;
 87f:	b8 00 00 00 00       	mov    $0x0,%eax
 884:	eb 13                	jmp    899 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 894:	e9 6d ff ff ff       	jmp    806 <malloc+0x4e>
}
 899:	c9                   	leave  
 89a:	c3                   	ret    
