
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 5b 09 00 00       	push   $0x95b
  30:	6a 01                	push   $0x1
  32:	e8 6e 05 00 00       	call   5a5 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 85 03 00 00       	call   3e6 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 6e 09 00 00       	push   $0x96e
  7d:	6a 01                	push   $0x1
  7f:	e8 21 05 00 00       	call   5a5 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 88 03 00 00       	call   42e <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 42 03 00 00       	call   40e <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 32 03 00 00       	call   416 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 78 09 00 00       	push   $0x978
  ef:	6a 01                	push   $0x1
  f1:	e8 af 04 00 00       	call   5a5 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 27 03 00 00       	call   42e <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 d9 02 00 00       	call   406 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 d1 02 00 00       	call   416 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 a9 02 00 00       	call   3f6 <wait>
  
  exit();
 14d:	e8 9c 02 00 00       	call   3ee <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 8c 01 00 00       	call   406 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 51 01 00 00       	call   42e <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 48 01 00 00       	call   446 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 07 01 00 00       	call   416 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 324:	eb 04                	jmp    32a <atoi+0x13>
 326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	3c 20                	cmp    $0x20,%al
 332:	74 f2                	je     326 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	3c 2d                	cmp    $0x2d,%al
 33c:	75 07                	jne    345 <atoi+0x2e>
 33e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 343:	eb 05                	jmp    34a <atoi+0x33>
 345:	b8 01 00 00 00       	mov    $0x1,%eax
 34a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	0f b6 00             	movzbl (%eax),%eax
 353:	3c 2b                	cmp    $0x2b,%al
 355:	74 0a                	je     361 <atoi+0x4a>
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	3c 2d                	cmp    $0x2d,%al
 35f:	75 2b                	jne    38c <atoi+0x75>
    s++;
 361:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 365:	eb 25                	jmp    38c <atoi+0x75>
    n = n*10 + *s++ - '0';
 367:	8b 55 fc             	mov    -0x4(%ebp),%edx
 36a:	89 d0                	mov    %edx,%eax
 36c:	c1 e0 02             	shl    $0x2,%eax
 36f:	01 d0                	add    %edx,%eax
 371:	01 c0                	add    %eax,%eax
 373:	89 c1                	mov    %eax,%ecx
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	8d 50 01             	lea    0x1(%eax),%edx
 37b:	89 55 08             	mov    %edx,0x8(%ebp)
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	0f be c0             	movsbl %al,%eax
 384:	01 c8                	add    %ecx,%eax
 386:	83 e8 30             	sub    $0x30,%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	3c 2f                	cmp    $0x2f,%al
 394:	7e 0a                	jle    3a0 <atoi+0x89>
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 39                	cmp    $0x39,%al
 39e:	7e c7                	jle    367 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3bb:	eb 17                	jmp    3d4 <memmove+0x2b>
    *dst++ = *src++;
 3bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c0:	8d 50 01             	lea    0x1(%eax),%edx
 3c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3c9:	8d 4a 01             	lea    0x1(%edx),%ecx
 3cc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3cf:	0f b6 12             	movzbl (%edx),%edx
 3d2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d4:	8b 45 10             	mov    0x10(%ebp),%eax
 3d7:	8d 50 ff             	lea    -0x1(%eax),%edx
 3da:	89 55 10             	mov    %edx,0x10(%ebp)
 3dd:	85 c0                	test   %eax,%eax
 3df:	7f dc                	jg     3bd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3e6:	b8 01 00 00 00       	mov    $0x1,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <exit>:
SYSCALL(exit)
 3ee:	b8 02 00 00 00       	mov    $0x2,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <wait>:
SYSCALL(wait)
 3f6:	b8 03 00 00 00       	mov    $0x3,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <pipe>:
SYSCALL(pipe)
 3fe:	b8 04 00 00 00       	mov    $0x4,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <read>:
SYSCALL(read)
 406:	b8 05 00 00 00       	mov    $0x5,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <write>:
SYSCALL(write)
 40e:	b8 10 00 00 00       	mov    $0x10,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <close>:
SYSCALL(close)
 416:	b8 15 00 00 00       	mov    $0x15,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <kill>:
SYSCALL(kill)
 41e:	b8 06 00 00 00       	mov    $0x6,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <exec>:
SYSCALL(exec)
 426:	b8 07 00 00 00       	mov    $0x7,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <open>:
SYSCALL(open)
 42e:	b8 0f 00 00 00       	mov    $0xf,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <mknod>:
SYSCALL(mknod)
 436:	b8 11 00 00 00       	mov    $0x11,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <unlink>:
SYSCALL(unlink)
 43e:	b8 12 00 00 00       	mov    $0x12,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <fstat>:
SYSCALL(fstat)
 446:	b8 08 00 00 00       	mov    $0x8,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <link>:
SYSCALL(link)
 44e:	b8 13 00 00 00       	mov    $0x13,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <mkdir>:
SYSCALL(mkdir)
 456:	b8 14 00 00 00       	mov    $0x14,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <chdir>:
SYSCALL(chdir)
 45e:	b8 09 00 00 00       	mov    $0x9,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <dup>:
SYSCALL(dup)
 466:	b8 0a 00 00 00       	mov    $0xa,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <getpid>:
SYSCALL(getpid)
 46e:	b8 0b 00 00 00       	mov    $0xb,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <sbrk>:
SYSCALL(sbrk)
 476:	b8 0c 00 00 00       	mov    $0xc,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <sleep>:
SYSCALL(sleep)
 47e:	b8 0d 00 00 00       	mov    $0xd,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <uptime>:
SYSCALL(uptime)
 486:	b8 0e 00 00 00       	mov    $0xe,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <halt>:
SYSCALL(halt)
 48e:	b8 16 00 00 00       	mov    $0x16,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <date>:
SYSCALL(date)
 496:	b8 17 00 00 00       	mov    $0x17,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <getuid>:
SYSCALL(getuid)
 49e:	b8 18 00 00 00       	mov    $0x18,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <getgid>:
SYSCALL(getgid)
 4a6:	b8 19 00 00 00       	mov    $0x19,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <getppid>:
SYSCALL(getppid)
 4ae:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <setuid>:
SYSCALL(setuid)
 4b6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <setgid>:
SYSCALL(setgid)
 4be:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <getprocs>:
SYSCALL(getprocs)
 4c6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	83 ec 18             	sub    $0x18,%esp
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4da:	83 ec 04             	sub    $0x4,%esp
 4dd:	6a 01                	push   $0x1
 4df:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e2:	50                   	push   %eax
 4e3:	ff 75 08             	pushl  0x8(%ebp)
 4e6:	e8 23 ff ff ff       	call   40e <write>
 4eb:	83 c4 10             	add    $0x10,%esp
}
 4ee:	90                   	nop
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f1:	55                   	push   %ebp
 4f2:	89 e5                	mov    %esp,%ebp
 4f4:	53                   	push   %ebx
 4f5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 503:	74 17                	je     51c <printint+0x2b>
 505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 509:	79 11                	jns    51c <printint+0x2b>
    neg = 1;
 50b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	f7 d8                	neg    %eax
 517:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51a:	eb 06                	jmp    522 <printint+0x31>
  } else {
    x = xx;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 529:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 52c:	8d 41 01             	lea    0x1(%ecx),%eax
 52f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 532:	8b 5d 10             	mov    0x10(%ebp),%ebx
 535:	8b 45 ec             	mov    -0x14(%ebp),%eax
 538:	ba 00 00 00 00       	mov    $0x0,%edx
 53d:	f7 f3                	div    %ebx
 53f:	89 d0                	mov    %edx,%eax
 541:	0f b6 80 d0 0b 00 00 	movzbl 0xbd0(%eax),%eax
 548:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 54c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 552:	ba 00 00 00 00       	mov    $0x0,%edx
 557:	f7 f3                	div    %ebx
 559:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 560:	75 c7                	jne    529 <printint+0x38>
  if(neg)
 562:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 566:	74 2d                	je     595 <printint+0xa4>
    buf[i++] = '-';
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	8d 50 01             	lea    0x1(%eax),%edx
 56e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 571:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 576:	eb 1d                	jmp    595 <printint+0xa4>
    putc(fd, buf[i]);
 578:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	01 d0                	add    %edx,%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	83 ec 08             	sub    $0x8,%esp
 589:	50                   	push   %eax
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 3c ff ff ff       	call   4ce <putc>
 592:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 595:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59d:	79 d9                	jns    578 <printint+0x87>
    putc(fd, buf[i]);
}
 59f:	90                   	nop
 5a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a3:	c9                   	leave  
 5a4:	c3                   	ret    

000005a5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a5:	55                   	push   %ebp
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b5:	83 c0 04             	add    $0x4,%eax
 5b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c2:	e9 59 01 00 00       	jmp    720 <printf+0x17b>
    c = fmt[i] & 0xff;
 5c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cd:	01 d0                	add    %edx,%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	25 ff 00 00 00       	and    $0xff,%eax
 5da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e1:	75 2c                	jne    60f <printf+0x6a>
      if(c == '%'){
 5e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e7:	75 0c                	jne    5f5 <printf+0x50>
        state = '%';
 5e9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f0:	e9 27 01 00 00       	jmp    71c <printf+0x177>
      } else {
        putc(fd, c);
 5f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 c7 fe ff ff       	call   4ce <putc>
 607:	83 c4 10             	add    $0x10,%esp
 60a:	e9 0d 01 00 00       	jmp    71c <printf+0x177>
      }
    } else if(state == '%'){
 60f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 613:	0f 85 03 01 00 00    	jne    71c <printf+0x177>
      if(c == 'd'){
 619:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61d:	75 1e                	jne    63d <printf+0x98>
        printint(fd, *ap, 10, 1);
 61f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	6a 01                	push   $0x1
 626:	6a 0a                	push   $0xa
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 c0 fe ff ff       	call   4f1 <printint>
 631:	83 c4 10             	add    $0x10,%esp
        ap++;
 634:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 638:	e9 d8 00 00 00       	jmp    715 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 63d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 641:	74 06                	je     649 <printf+0xa4>
 643:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 647:	75 1e                	jne    667 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	6a 00                	push   $0x0
 650:	6a 10                	push   $0x10
 652:	50                   	push   %eax
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 96 fe ff ff       	call   4f1 <printint>
 65b:	83 c4 10             	add    $0x10,%esp
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 662:	e9 ae 00 00 00       	jmp    715 <printf+0x170>
      } else if(c == 's'){
 667:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 66b:	75 43                	jne    6b0 <printf+0x10b>
        s = (char*)*ap;
 66d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 675:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67d:	75 25                	jne    6a4 <printf+0xff>
          s = "(null)";
 67f:	c7 45 f4 7e 09 00 00 	movl   $0x97e,-0xc(%ebp)
        while(*s != 0){
 686:	eb 1c                	jmp    6a4 <printf+0xff>
          putc(fd, *s);
 688:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68b:	0f b6 00             	movzbl (%eax),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	83 ec 08             	sub    $0x8,%esp
 694:	50                   	push   %eax
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 31 fe ff ff       	call   4ce <putc>
 69d:	83 c4 10             	add    $0x10,%esp
          s++;
 6a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a7:	0f b6 00             	movzbl (%eax),%eax
 6aa:	84 c0                	test   %al,%al
 6ac:	75 da                	jne    688 <printf+0xe3>
 6ae:	eb 65                	jmp    715 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b4:	75 1d                	jne    6d3 <printf+0x12e>
        putc(fd, *ap);
 6b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	83 ec 08             	sub    $0x8,%esp
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	e8 04 fe ff ff       	call   4ce <putc>
 6ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d1:	eb 42                	jmp    715 <printf+0x170>
      } else if(c == '%'){
 6d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d7:	75 17                	jne    6f0 <printf+0x14b>
        putc(fd, c);
 6d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	83 ec 08             	sub    $0x8,%esp
 6e2:	50                   	push   %eax
 6e3:	ff 75 08             	pushl  0x8(%ebp)
 6e6:	e8 e3 fd ff ff       	call   4ce <putc>
 6eb:	83 c4 10             	add    $0x10,%esp
 6ee:	eb 25                	jmp    715 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f0:	83 ec 08             	sub    $0x8,%esp
 6f3:	6a 25                	push   $0x25
 6f5:	ff 75 08             	pushl  0x8(%ebp)
 6f8:	e8 d1 fd ff ff       	call   4ce <putc>
 6fd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 703:	0f be c0             	movsbl %al,%eax
 706:	83 ec 08             	sub    $0x8,%esp
 709:	50                   	push   %eax
 70a:	ff 75 08             	pushl  0x8(%ebp)
 70d:	e8 bc fd ff ff       	call   4ce <putc>
 712:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 715:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 720:	8b 55 0c             	mov    0xc(%ebp),%edx
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	01 d0                	add    %edx,%eax
 728:	0f b6 00             	movzbl (%eax),%eax
 72b:	84 c0                	test   %al,%al
 72d:	0f 85 94 fe ff ff    	jne    5c7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 733:	90                   	nop
 734:	c9                   	leave  
 735:	c3                   	ret    

00000736 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 736:	55                   	push   %ebp
 737:	89 e5                	mov    %esp,%ebp
 739:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73c:	8b 45 08             	mov    0x8(%ebp),%eax
 73f:	83 e8 08             	sub    $0x8,%eax
 742:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 745:	a1 ec 0b 00 00       	mov    0xbec,%eax
 74a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74d:	eb 24                	jmp    773 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 757:	77 12                	ja     76b <free+0x35>
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75f:	77 24                	ja     785 <free+0x4f>
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	8b 00                	mov    (%eax),%eax
 766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 769:	77 1a                	ja     785 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	89 45 fc             	mov    %eax,-0x4(%ebp)
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	76 d4                	jbe    74f <free+0x19>
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	76 ca                	jbe    74f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 792:	8b 45 f8             	mov    -0x8(%ebp),%eax
 795:	01 c2                	add    %eax,%edx
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	39 c2                	cmp    %eax,%edx
 79e:	75 24                	jne    7c4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	8b 50 04             	mov    0x4(%eax),%edx
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	01 c2                	add    %eax,%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
 7c2:	eb 0a                	jmp    7ce <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 10                	mov    (%eax),%edx
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	01 d0                	add    %edx,%eax
 7e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e3:	75 20                	jne    805 <free+0xcf>
    p->s.size += bp->s.size;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8b 50 04             	mov    0x4(%eax),%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	01 c2                	add    %eax,%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	8b 10                	mov    (%eax),%edx
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	89 10                	mov    %edx,(%eax)
 803:	eb 08                	jmp    80d <free+0xd7>
  } else
    p->s.ptr = bp;
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80b:	89 10                	mov    %edx,(%eax)
  freep = p;
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	a3 ec 0b 00 00       	mov    %eax,0xbec
}
 815:	90                   	nop
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <morecore>:

static Header*
morecore(uint nu)
{
 818:	55                   	push   %ebp
 819:	89 e5                	mov    %esp,%ebp
 81b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 825:	77 07                	ja     82e <morecore+0x16>
    nu = 4096;
 827:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	c1 e0 03             	shl    $0x3,%eax
 834:	83 ec 0c             	sub    $0xc,%esp
 837:	50                   	push   %eax
 838:	e8 39 fc ff ff       	call   476 <sbrk>
 83d:	83 c4 10             	add    $0x10,%esp
 840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 843:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 847:	75 07                	jne    850 <morecore+0x38>
    return 0;
 849:	b8 00 00 00 00       	mov    $0x0,%eax
 84e:	eb 26                	jmp    876 <morecore+0x5e>
  hp = (Header*)p;
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	8b 55 08             	mov    0x8(%ebp),%edx
 85c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	83 c0 08             	add    $0x8,%eax
 865:	83 ec 0c             	sub    $0xc,%esp
 868:	50                   	push   %eax
 869:	e8 c8 fe ff ff       	call   736 <free>
 86e:	83 c4 10             	add    $0x10,%esp
  return freep;
 871:	a1 ec 0b 00 00       	mov    0xbec,%eax
}
 876:	c9                   	leave  
 877:	c3                   	ret    

00000878 <malloc>:

void*
malloc(uint nbytes)
{
 878:	55                   	push   %ebp
 879:	89 e5                	mov    %esp,%ebp
 87b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	83 c0 07             	add    $0x7,%eax
 884:	c1 e8 03             	shr    $0x3,%eax
 887:	83 c0 01             	add    $0x1,%eax
 88a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 88d:	a1 ec 0b 00 00       	mov    0xbec,%eax
 892:	89 45 f0             	mov    %eax,-0x10(%ebp)
 895:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 899:	75 23                	jne    8be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 89b:	c7 45 f0 e4 0b 00 00 	movl   $0xbe4,-0x10(%ebp)
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	a3 ec 0b 00 00       	mov    %eax,0xbec
 8aa:	a1 ec 0b 00 00       	mov    0xbec,%eax
 8af:	a3 e4 0b 00 00       	mov    %eax,0xbe4
    base.s.size = 0;
 8b4:	c7 05 e8 0b 00 00 00 	movl   $0x0,0xbe8
 8bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 40 04             	mov    0x4(%eax),%eax
 8cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cf:	72 4d                	jb     91e <malloc+0xa6>
      if(p->s.size == nunits)
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	8b 40 04             	mov    0x4(%eax),%eax
 8d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8da:	75 0c                	jne    8e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 10                	mov    (%eax),%edx
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	89 10                	mov    %edx,(%eax)
 8e6:	eb 26                	jmp    90e <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8f1:	89 c2                	mov    %eax,%edx
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	8b 40 04             	mov    0x4(%eax),%eax
 8ff:	c1 e0 03             	shl    $0x3,%eax
 902:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 905:	8b 45 f4             	mov    -0xc(%ebp),%eax
 908:	8b 55 ec             	mov    -0x14(%ebp),%edx
 90b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	a3 ec 0b 00 00       	mov    %eax,0xbec
      return (void*)(p + 1);
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	83 c0 08             	add    $0x8,%eax
 91c:	eb 3b                	jmp    959 <malloc+0xe1>
    }
    if(p == freep)
 91e:	a1 ec 0b 00 00       	mov    0xbec,%eax
 923:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 926:	75 1e                	jne    946 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 928:	83 ec 0c             	sub    $0xc,%esp
 92b:	ff 75 ec             	pushl  -0x14(%ebp)
 92e:	e8 e5 fe ff ff       	call   818 <morecore>
 933:	83 c4 10             	add    $0x10,%esp
 936:	89 45 f4             	mov    %eax,-0xc(%ebp)
 939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 93d:	75 07                	jne    946 <malloc+0xce>
        return 0;
 93f:	b8 00 00 00 00       	mov    $0x0,%eax
 944:	eb 13                	jmp    959 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 954:	e9 6d ff ff ff       	jmp    8c6 <malloc+0x4e>
}
 959:	c9                   	leave  
 95a:	c3                   	ret    
