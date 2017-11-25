
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

static void tickasfloat(uint);
    
int
main(int argc, char * argv[])
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
  int ticks_start, ticks_final, pid;

  if(argc <= 1)
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
  {
      printf(2,"time ran in 0.0 seconds\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 c4 09 00 00       	push   $0x9c4
  21:	6a 02                	push   $0x2
  23:	e8 e6 05 00 00       	call   60e <printf>
  28:	83 c4 10             	add    $0x10,%esp
      exit();
  2b:	e8 07 04 00 00       	call   437 <exit>
  }

  ticks_start = 0;
  30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  pid = fork();
  37:	e8 f3 03 00 00       	call   42f <fork>
  3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid > 0)
  3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  43:	7e 5f                	jle    a4 <main+0xa4>
  {
      if(ticks_start == 0)
  45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  49:	75 08                	jne    53 <main+0x53>
          ticks_start = uptime();
  4b:	e8 7f 04 00 00       	call   4cf <uptime>
  50:	89 45 f4             	mov    %eax,-0xc(%ebp)
      pid = wait();
  53:	e8 e7 03 00 00       	call   43f <wait>
  58:	89 45 f0             	mov    %eax,-0x10(%ebp)

      ticks_final = uptime() - ticks_start;
  5b:	e8 6f 04 00 00       	call   4cf <uptime>
  60:	2b 45 f4             	sub    -0xc(%ebp),%eax
  63:	89 45 ec             	mov    %eax,-0x14(%ebp)
      printf(2,"%s ran in ", argv[1]);
  66:	8b 43 04             	mov    0x4(%ebx),%eax
  69:	83 c0 04             	add    $0x4,%eax
  6c:	8b 00                	mov    (%eax),%eax
  6e:	83 ec 04             	sub    $0x4,%esp
  71:	50                   	push   %eax
  72:	68 dd 09 00 00       	push   $0x9dd
  77:	6a 02                	push   $0x2
  79:	e8 90 05 00 00       	call   60e <printf>
  7e:	83 c4 10             	add    $0x10,%esp
      tickasfloat(ticks_final);
  81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  84:	83 ec 0c             	sub    $0xc,%esp
  87:	50                   	push   %eax
  88:	e8 6e 00 00 00       	call   fb <tickasfloat>
  8d:	83 c4 10             	add    $0x10,%esp
      printf(2," seconds\n");
  90:	83 ec 08             	sub    $0x8,%esp
  93:	68 e8 09 00 00       	push   $0x9e8
  98:	6a 02                	push   $0x2
  9a:	e8 6f 05 00 00       	call   60e <printf>
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	eb 52                	jmp    f6 <main+0xf6>
      
  }
  else if(pid == 0) 
  a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  a8:	75 3a                	jne    e4 <main+0xe4>
  {
      ticks_start = uptime();
  aa:	e8 20 04 00 00       	call   4cf <uptime>
  af:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
      ++argv;
  b2:	83 43 04 04          	addl   $0x4,0x4(%ebx)
      exec(argv[0], argv);
  b6:	8b 43 04             	mov    0x4(%ebx),%eax
  b9:	8b 00                	mov    (%eax),%eax
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	ff 73 04             	pushl  0x4(%ebx)
  c1:	50                   	push   %eax
  c2:	e8 a8 03 00 00       	call   46f <exec>
  c7:	83 c4 10             	add    $0x10,%esp
      printf(2, "exec %s failed\n", argv[0]);
  ca:	8b 43 04             	mov    0x4(%ebx),%eax
  cd:	8b 00                	mov    (%eax),%eax
  cf:	83 ec 04             	sub    $0x4,%esp
  d2:	50                   	push   %eax
  d3:	68 f2 09 00 00       	push   $0x9f2
  d8:	6a 02                	push   $0x2
  da:	e8 2f 05 00 00       	call   60e <printf>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 12                	jmp    f6 <main+0xf6>

  }
  else
      printf(2, "Fork error\n");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 02 0a 00 00       	push   $0xa02
  ec:	6a 02                	push   $0x2
  ee:	e8 1b 05 00 00       	call   60e <printf>
  f3:	83 c4 10             	add    $0x10,%esp
  exit();
  f6:	e8 3c 03 00 00       	call   437 <exit>

000000fb <tickasfloat>:
}

static void 
tickasfloat(uint tickcount)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 18             	sub    $0x18,%esp
    uint ticksl = tickcount / 1000;
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 109:	f7 e2                	mul    %edx
 10b:	89 d0                	mov    %edx,%eax
 10d:	c1 e8 06             	shr    $0x6,%eax
 110:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ticksr = tickcount % 1000;
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
 116:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 11b:	89 c8                	mov    %ecx,%eax
 11d:	f7 e2                	mul    %edx
 11f:	89 d0                	mov    %edx,%eax
 121:	c1 e8 06             	shr    $0x6,%eax
 124:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 12a:	29 c1                	sub    %eax,%ecx
 12c:	89 c8                	mov    %ecx,%eax
 12e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2,"%d.", ticksl);
 131:	83 ec 04             	sub    $0x4,%esp
 134:	ff 75 f4             	pushl  -0xc(%ebp)
 137:	68 0e 0a 00 00       	push   $0xa0e
 13c:	6a 02                	push   $0x2
 13e:	e8 cb 04 00 00       	call   60e <printf>
 143:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
 146:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 14a:	77 1b                	ja     167 <tickasfloat+0x6c>
        printf(2,"%d%d%d", 0, 0, ticksr);
 14c:	83 ec 0c             	sub    $0xc,%esp
 14f:	ff 75 f0             	pushl  -0x10(%ebp)
 152:	6a 00                	push   $0x0
 154:	6a 00                	push   $0x0
 156:	68 12 0a 00 00       	push   $0xa12
 15b:	6a 02                	push   $0x2
 15d:	e8 ac 04 00 00       	call   60e <printf>
 162:	83 c4 20             	add    $0x20,%esp
    else if(ticksr < 100)
        printf(2,"%d%d", 0, ticksr);
    else
        printf(2,"%d", ticksr);

}
 165:	eb 31                	jmp    198 <tickasfloat+0x9d>
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    printf(2,"%d.", ticksl);
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d", 0, 0, ticksr);
    else if(ticksr < 100)
 167:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 16b:	77 16                	ja     183 <tickasfloat+0x88>
        printf(2,"%d%d", 0, ticksr);
 16d:	ff 75 f0             	pushl  -0x10(%ebp)
 170:	6a 00                	push   $0x0
 172:	68 19 0a 00 00       	push   $0xa19
 177:	6a 02                	push   $0x2
 179:	e8 90 04 00 00       	call   60e <printf>
 17e:	83 c4 10             	add    $0x10,%esp
    else
        printf(2,"%d", ticksr);

}
 181:	eb 15                	jmp    198 <tickasfloat+0x9d>
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d", 0, 0, ticksr);
    else if(ticksr < 100)
        printf(2,"%d%d", 0, ticksr);
    else
        printf(2,"%d", ticksr);
 183:	83 ec 04             	sub    $0x4,%esp
 186:	ff 75 f0             	pushl  -0x10(%ebp)
 189:	68 1e 0a 00 00       	push   $0xa1e
 18e:	6a 02                	push   $0x2
 190:	e8 79 04 00 00       	call   60e <printf>
 195:	83 c4 10             	add    $0x10,%esp

}
 198:	90                   	nop
 199:	c9                   	leave  
 19a:	c3                   	ret    

0000019b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	57                   	push   %edi
 19f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a3:	8b 55 10             	mov    0x10(%ebp),%edx
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	89 cb                	mov    %ecx,%ebx
 1ab:	89 df                	mov    %ebx,%edi
 1ad:	89 d1                	mov    %edx,%ecx
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
 1b2:	89 ca                	mov    %ecx,%edx
 1b4:	89 fb                	mov    %edi,%ebx
 1b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1b9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1bc:	90                   	nop
 1bd:	5b                   	pop    %ebx
 1be:	5f                   	pop    %edi
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    

000001c1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1cd:	90                   	nop
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	8d 50 01             	lea    0x1(%eax),%edx
 1d4:	89 55 08             	mov    %edx,0x8(%ebp)
 1d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1da:	8d 4a 01             	lea    0x1(%edx),%ecx
 1dd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1e0:	0f b6 12             	movzbl (%edx),%edx
 1e3:	88 10                	mov    %dl,(%eax)
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	84 c0                	test   %al,%al
 1ea:	75 e2                	jne    1ce <strcpy+0xd>
    ;
  return os;
 1ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1f4:	eb 08                	jmp    1fe <strcmp+0xd>
    p++, q++;
 1f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	84 c0                	test   %al,%al
 206:	74 10                	je     218 <strcmp+0x27>
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	38 c2                	cmp    %al,%dl
 216:	74 de                	je     1f6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	0f b6 d0             	movzbl %al,%edx
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	0f b6 c0             	movzbl %al,%eax
 22a:	29 c2                	sub    %eax,%edx
 22c:	89 d0                	mov    %edx,%eax
}
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    

00000230 <strlen>:

uint
strlen(char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 23d:	eb 04                	jmp    243 <strlen+0x13>
 23f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 243:	8b 55 fc             	mov    -0x4(%ebp),%edx
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	01 d0                	add    %edx,%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 ed                	jne    23f <strlen+0xf>
    ;
  return n;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <memset>:

void*
memset(void *dst, int c, uint n)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
 25d:	50                   	push   %eax
 25e:	ff 75 0c             	pushl  0xc(%ebp)
 261:	ff 75 08             	pushl  0x8(%ebp)
 264:	e8 32 ff ff ff       	call   19b <stosb>
 269:	83 c4 0c             	add    $0xc,%esp
  return dst;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <strchr>:

char*
strchr(const char *s, char c)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 04             	sub    $0x4,%esp
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 27d:	eb 14                	jmp    293 <strchr+0x22>
    if(*s == c)
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	3a 45 fc             	cmp    -0x4(%ebp),%al
 288:	75 05                	jne    28f <strchr+0x1e>
      return (char*)s;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	eb 13                	jmp    2a2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 28f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	75 e2                	jne    27f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 29d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <gets>:

char*
gets(char *buf, int max)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b1:	eb 42                	jmp    2f5 <gets+0x51>
    cc = read(0, &c, 1);
 2b3:	83 ec 04             	sub    $0x4,%esp
 2b6:	6a 01                	push   $0x1
 2b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2bb:	50                   	push   %eax
 2bc:	6a 00                	push   $0x0
 2be:	e8 8c 01 00 00       	call   44f <read>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2cd:	7e 33                	jle    302 <gets+0x5e>
      break;
    buf[i++] = c;
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	8d 50 01             	lea    0x1(%eax),%edx
 2d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2d8:	89 c2                	mov    %eax,%edx
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	01 c2                	add    %eax,%edx
 2df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e9:	3c 0a                	cmp    $0xa,%al
 2eb:	74 16                	je     303 <gets+0x5f>
 2ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f1:	3c 0d                	cmp    $0xd,%al
 2f3:	74 0e                	je     303 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2fe:	7c b3                	jl     2b3 <gets+0xf>
 300:	eb 01                	jmp    303 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 302:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 303:	8b 55 f4             	mov    -0xc(%ebp),%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	01 d0                	add    %edx,%eax
 30b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <stat>:

int
stat(char *n, struct stat *st)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 319:	83 ec 08             	sub    $0x8,%esp
 31c:	6a 00                	push   $0x0
 31e:	ff 75 08             	pushl  0x8(%ebp)
 321:	e8 51 01 00 00       	call   477 <open>
 326:	83 c4 10             	add    $0x10,%esp
 329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 32c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 330:	79 07                	jns    339 <stat+0x26>
    return -1;
 332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 337:	eb 25                	jmp    35e <stat+0x4b>
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	ff 75 f4             	pushl  -0xc(%ebp)
 342:	e8 48 01 00 00       	call   48f <fstat>
 347:	83 c4 10             	add    $0x10,%esp
 34a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 34d:	83 ec 0c             	sub    $0xc,%esp
 350:	ff 75 f4             	pushl  -0xc(%ebp)
 353:	e8 07 01 00 00       	call   45f <close>
 358:	83 c4 10             	add    $0x10,%esp
  return r;
 35b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 36d:	eb 04                	jmp    373 <atoi+0x13>
 36f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 20                	cmp    $0x20,%al
 37b:	74 f2                	je     36f <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3c 2d                	cmp    $0x2d,%al
 385:	75 07                	jne    38e <atoi+0x2e>
 387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38c:	eb 05                	jmp    393 <atoi+0x33>
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2b                	cmp    $0x2b,%al
 39e:	74 0a                	je     3aa <atoi+0x4a>
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 2d                	cmp    $0x2d,%al
 3a8:	75 2b                	jne    3d5 <atoi+0x75>
    s++;
 3aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3ae:	eb 25                	jmp    3d5 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b3:	89 d0                	mov    %edx,%eax
 3b5:	c1 e0 02             	shl    $0x2,%eax
 3b8:	01 d0                	add    %edx,%eax
 3ba:	01 c0                	add    %eax,%eax
 3bc:	89 c1                	mov    %eax,%ecx
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	8d 50 01             	lea    0x1(%eax),%edx
 3c4:	89 55 08             	mov    %edx,0x8(%ebp)
 3c7:	0f b6 00             	movzbl (%eax),%eax
 3ca:	0f be c0             	movsbl %al,%eax
 3cd:	01 c8                	add    %ecx,%eax
 3cf:	83 e8 30             	sub    $0x30,%eax
 3d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 00             	movzbl (%eax),%eax
 3db:	3c 2f                	cmp    $0x2f,%al
 3dd:	7e 0a                	jle    3e9 <atoi+0x89>
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	0f b6 00             	movzbl (%eax),%eax
 3e5:	3c 39                	cmp    $0x39,%al
 3e7:	7e c7                	jle    3b0 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ec:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 401:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 404:	eb 17                	jmp    41d <memmove+0x2b>
    *dst++ = *src++;
 406:	8b 45 fc             	mov    -0x4(%ebp),%eax
 409:	8d 50 01             	lea    0x1(%eax),%edx
 40c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 40f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 412:	8d 4a 01             	lea    0x1(%edx),%ecx
 415:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 418:	0f b6 12             	movzbl (%edx),%edx
 41b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 41d:	8b 45 10             	mov    0x10(%ebp),%eax
 420:	8d 50 ff             	lea    -0x1(%eax),%edx
 423:	89 55 10             	mov    %edx,0x10(%ebp)
 426:	85 c0                	test   %eax,%eax
 428:	7f dc                	jg     406 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42f:	b8 01 00 00 00       	mov    $0x1,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <exit>:
SYSCALL(exit)
 437:	b8 02 00 00 00       	mov    $0x2,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <wait>:
SYSCALL(wait)
 43f:	b8 03 00 00 00       	mov    $0x3,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <pipe>:
SYSCALL(pipe)
 447:	b8 04 00 00 00       	mov    $0x4,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <read>:
SYSCALL(read)
 44f:	b8 05 00 00 00       	mov    $0x5,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <write>:
SYSCALL(write)
 457:	b8 10 00 00 00       	mov    $0x10,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <close>:
SYSCALL(close)
 45f:	b8 15 00 00 00       	mov    $0x15,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <kill>:
SYSCALL(kill)
 467:	b8 06 00 00 00       	mov    $0x6,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <exec>:
SYSCALL(exec)
 46f:	b8 07 00 00 00       	mov    $0x7,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <open>:
SYSCALL(open)
 477:	b8 0f 00 00 00       	mov    $0xf,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <mknod>:
SYSCALL(mknod)
 47f:	b8 11 00 00 00       	mov    $0x11,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <unlink>:
SYSCALL(unlink)
 487:	b8 12 00 00 00       	mov    $0x12,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <fstat>:
SYSCALL(fstat)
 48f:	b8 08 00 00 00       	mov    $0x8,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <link>:
SYSCALL(link)
 497:	b8 13 00 00 00       	mov    $0x13,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <mkdir>:
SYSCALL(mkdir)
 49f:	b8 14 00 00 00       	mov    $0x14,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <chdir>:
SYSCALL(chdir)
 4a7:	b8 09 00 00 00       	mov    $0x9,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <dup>:
SYSCALL(dup)
 4af:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <getpid>:
SYSCALL(getpid)
 4b7:	b8 0b 00 00 00       	mov    $0xb,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <sbrk>:
SYSCALL(sbrk)
 4bf:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <sleep>:
SYSCALL(sleep)
 4c7:	b8 0d 00 00 00       	mov    $0xd,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <uptime>:
SYSCALL(uptime)
 4cf:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <halt>:
SYSCALL(halt)
 4d7:	b8 16 00 00 00       	mov    $0x16,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <date>:
SYSCALL(date)
 4df:	b8 17 00 00 00       	mov    $0x17,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <getuid>:
SYSCALL(getuid)
 4e7:	b8 18 00 00 00       	mov    $0x18,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <getgid>:
SYSCALL(getgid)
 4ef:	b8 19 00 00 00       	mov    $0x19,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <getppid>:
SYSCALL(getppid)
 4f7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <setuid>:
SYSCALL(setuid)
 4ff:	b8 1b 00 00 00       	mov    $0x1b,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <setgid>:
SYSCALL(setgid)
 507:	b8 1c 00 00 00       	mov    $0x1c,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <getprocs>:
SYSCALL(getprocs)
 50f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <setpriority>:
SYSCALL(setpriority)
 517:	b8 1e 00 00 00       	mov    $0x1e,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <chmod>:
SYSCALL(chmod)
 51f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <chown>:
SYSCALL(chown)
 527:	b8 20 00 00 00       	mov    $0x20,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <chgrp>:
SYSCALL(chgrp)    
 52f:	b8 21 00 00 00       	mov    $0x21,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 537:	55                   	push   %ebp
 538:	89 e5                	mov    %esp,%ebp
 53a:	83 ec 18             	sub    $0x18,%esp
 53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 540:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
 546:	6a 01                	push   $0x1
 548:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 03 ff ff ff       	call   457 <write>
 554:	83 c4 10             	add    $0x10,%esp
}
 557:	90                   	nop
 558:	c9                   	leave  
 559:	c3                   	ret    

0000055a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55a:	55                   	push   %ebp
 55b:	89 e5                	mov    %esp,%ebp
 55d:	53                   	push   %ebx
 55e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 561:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 568:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56c:	74 17                	je     585 <printint+0x2b>
 56e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 572:	79 11                	jns    585 <printint+0x2b>
    neg = 1;
 574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
 57e:	f7 d8                	neg    %eax
 580:	89 45 ec             	mov    %eax,-0x14(%ebp)
 583:	eb 06                	jmp    58b <printint+0x31>
  } else {
    x = xx;
 585:	8b 45 0c             	mov    0xc(%ebp),%eax
 588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 592:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 595:	8d 41 01             	lea    0x1(%ecx),%eax
 598:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a1:	ba 00 00 00 00       	mov    $0x0,%edx
 5a6:	f7 f3                	div    %ebx
 5a8:	89 d0                	mov    %edx,%eax
 5aa:	0f b6 80 94 0c 00 00 	movzbl 0xc94(%eax),%eax
 5b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bb:	ba 00 00 00 00       	mov    $0x0,%edx
 5c0:	f7 f3                	div    %ebx
 5c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c9:	75 c7                	jne    592 <printint+0x38>
  if(neg)
 5cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5cf:	74 2d                	je     5fe <printint+0xa4>
    buf[i++] = '-';
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	8d 50 01             	lea    0x1(%eax),%edx
 5d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5df:	eb 1d                	jmp    5fe <printint+0xa4>
    putc(fd, buf[i]);
 5e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	01 d0                	add    %edx,%eax
 5e9:	0f b6 00             	movzbl (%eax),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 3c ff ff ff       	call   537 <putc>
 5fb:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 606:	79 d9                	jns    5e1 <printint+0x87>
    putc(fd, buf[i]);
}
 608:	90                   	nop
 609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 60c:	c9                   	leave  
 60d:	c3                   	ret    

0000060e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61b:	8d 45 0c             	lea    0xc(%ebp),%eax
 61e:	83 c0 04             	add    $0x4,%eax
 621:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 624:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62b:	e9 59 01 00 00       	jmp    789 <printf+0x17b>
    c = fmt[i] & 0xff;
 630:	8b 55 0c             	mov    0xc(%ebp),%edx
 633:	8b 45 f0             	mov    -0x10(%ebp),%eax
 636:	01 d0                	add    %edx,%eax
 638:	0f b6 00             	movzbl (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	25 ff 00 00 00       	and    $0xff,%eax
 643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64a:	75 2c                	jne    678 <printf+0x6a>
      if(c == '%'){
 64c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 650:	75 0c                	jne    65e <printf+0x50>
        state = '%';
 652:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 659:	e9 27 01 00 00       	jmp    785 <printf+0x177>
      } else {
        putc(fd, c);
 65e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 c7 fe ff ff       	call   537 <putc>
 670:	83 c4 10             	add    $0x10,%esp
 673:	e9 0d 01 00 00       	jmp    785 <printf+0x177>
      }
    } else if(state == '%'){
 678:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67c:	0f 85 03 01 00 00    	jne    785 <printf+0x177>
      if(c == 'd'){
 682:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 686:	75 1e                	jne    6a6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 688:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	6a 01                	push   $0x1
 68f:	6a 0a                	push   $0xa
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 c0 fe ff ff       	call   55a <printint>
 69a:	83 c4 10             	add    $0x10,%esp
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	e9 d8 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6aa:	74 06                	je     6b2 <printf+0xa4>
 6ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b0:	75 1e                	jne    6d0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	6a 00                	push   $0x0
 6b9:	6a 10                	push   $0x10
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 96 fe ff ff       	call   55a <printint>
 6c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cb:	e9 ae 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 's'){
 6d0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d4:	75 43                	jne    719 <printf+0x10b>
        s = (char*)*ap;
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e6:	75 25                	jne    70d <printf+0xff>
          s = "(null)";
 6e8:	c7 45 f4 21 0a 00 00 	movl   $0xa21,-0xc(%ebp)
        while(*s != 0){
 6ef:	eb 1c                	jmp    70d <printf+0xff>
          putc(fd, *s);
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 31 fe ff ff       	call   537 <putc>
 706:	83 c4 10             	add    $0x10,%esp
          s++;
 709:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	0f b6 00             	movzbl (%eax),%eax
 713:	84 c0                	test   %al,%al
 715:	75 da                	jne    6f1 <printf+0xe3>
 717:	eb 65                	jmp    77e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 719:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 71d:	75 1d                	jne    73c <printf+0x12e>
        putc(fd, *ap);
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	83 ec 08             	sub    $0x8,%esp
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 04 fe ff ff       	call   537 <putc>
 733:	83 c4 10             	add    $0x10,%esp
        ap++;
 736:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73a:	eb 42                	jmp    77e <printf+0x170>
      } else if(c == '%'){
 73c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 740:	75 17                	jne    759 <printf+0x14b>
        putc(fd, c);
 742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	83 ec 08             	sub    $0x8,%esp
 74b:	50                   	push   %eax
 74c:	ff 75 08             	pushl  0x8(%ebp)
 74f:	e8 e3 fd ff ff       	call   537 <putc>
 754:	83 c4 10             	add    $0x10,%esp
 757:	eb 25                	jmp    77e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 759:	83 ec 08             	sub    $0x8,%esp
 75c:	6a 25                	push   $0x25
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 d1 fd ff ff       	call   537 <putc>
 766:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	83 ec 08             	sub    $0x8,%esp
 772:	50                   	push   %eax
 773:	ff 75 08             	pushl  0x8(%ebp)
 776:	e8 bc fd ff ff       	call   537 <putc>
 77b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 77e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 785:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 789:	8b 55 0c             	mov    0xc(%ebp),%edx
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	01 d0                	add    %edx,%eax
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	84 c0                	test   %al,%al
 796:	0f 85 94 fe ff ff    	jne    630 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79c:	90                   	nop
 79d:	c9                   	leave  
 79e:	c3                   	ret    

0000079f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	83 e8 08             	sub    $0x8,%eax
 7ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	eb 24                	jmp    7dc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c0:	77 12                	ja     7d4 <free+0x35>
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c8:	77 24                	ja     7ee <free+0x4f>
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d2:	77 1a                	ja     7ee <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e2:	76 d4                	jbe    7b8 <free+0x19>
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ec:	76 ca                	jbe    7b8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	39 c2                	cmp    %eax,%edx
 807:	75 24                	jne    82d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 50 04             	mov    0x4(%eax),%edx
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 10                	mov    (%eax),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	89 10                	mov    %edx,(%eax)
 82b:	eb 0a                	jmp    837 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 10                	mov    (%eax),%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	01 d0                	add    %edx,%eax
 849:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84c:	75 20                	jne    86e <free+0xcf>
    p->s.size += bp->s.size;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 50 04             	mov    0x4(%eax),%edx
 854:	8b 45 f8             	mov    -0x8(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	01 c2                	add    %eax,%edx
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	8b 10                	mov    (%eax),%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	89 10                	mov    %edx,(%eax)
 86c:	eb 08                	jmp    876 <free+0xd7>
  } else
    p->s.ptr = bp;
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	8b 55 f8             	mov    -0x8(%ebp),%edx
 874:	89 10                	mov    %edx,(%eax)
  freep = p;
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	a3 b0 0c 00 00       	mov    %eax,0xcb0
}
 87e:	90                   	nop
 87f:	c9                   	leave  
 880:	c3                   	ret    

00000881 <morecore>:

static Header*
morecore(uint nu)
{
 881:	55                   	push   %ebp
 882:	89 e5                	mov    %esp,%ebp
 884:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 887:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88e:	77 07                	ja     897 <morecore+0x16>
    nu = 4096;
 890:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	c1 e0 03             	shl    $0x3,%eax
 89d:	83 ec 0c             	sub    $0xc,%esp
 8a0:	50                   	push   %eax
 8a1:	e8 19 fc ff ff       	call   4bf <sbrk>
 8a6:	83 c4 10             	add    $0x10,%esp
 8a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b0:	75 07                	jne    8b9 <morecore+0x38>
    return 0;
 8b2:	b8 00 00 00 00       	mov    $0x0,%eax
 8b7:	eb 26                	jmp    8df <morecore+0x5e>
  hp = (Header*)p;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c2:	8b 55 08             	mov    0x8(%ebp),%edx
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cb:	83 c0 08             	add    $0x8,%eax
 8ce:	83 ec 0c             	sub    $0xc,%esp
 8d1:	50                   	push   %eax
 8d2:	e8 c8 fe ff ff       	call   79f <free>
 8d7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8da:	a1 b0 0c 00 00       	mov    0xcb0,%eax
}
 8df:	c9                   	leave  
 8e0:	c3                   	ret    

000008e1 <malloc>:

void*
malloc(uint nbytes)
{
 8e1:	55                   	push   %ebp
 8e2:	89 e5                	mov    %esp,%ebp
 8e4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ea:	83 c0 07             	add    $0x7,%eax
 8ed:	c1 e8 03             	shr    $0x3,%eax
 8f0:	83 c0 01             	add    $0x1,%eax
 8f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f6:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 8fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 902:	75 23                	jne    927 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 904:	c7 45 f0 a8 0c 00 00 	movl   $0xca8,-0x10(%ebp)
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	a3 b0 0c 00 00       	mov    %eax,0xcb0
 913:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 918:	a3 a8 0c 00 00       	mov    %eax,0xca8
    base.s.size = 0;
 91d:	c7 05 ac 0c 00 00 00 	movl   $0x0,0xcac
 924:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 40 04             	mov    0x4(%eax),%eax
 935:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 938:	72 4d                	jb     987 <malloc+0xa6>
      if(p->s.size == nunits)
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 943:	75 0c                	jne    951 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 10                	mov    (%eax),%edx
 94a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94d:	89 10                	mov    %edx,(%eax)
 94f:	eb 26                	jmp    977 <malloc+0x96>
      else {
        p->s.size -= nunits;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95a:	89 c2                	mov    %eax,%edx
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	c1 e0 03             	shl    $0x3,%eax
 96b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	8b 55 ec             	mov    -0x14(%ebp),%edx
 974:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 977:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97a:	a3 b0 0c 00 00       	mov    %eax,0xcb0
      return (void*)(p + 1);
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	83 c0 08             	add    $0x8,%eax
 985:	eb 3b                	jmp    9c2 <malloc+0xe1>
    }
    if(p == freep)
 987:	a1 b0 0c 00 00       	mov    0xcb0,%eax
 98c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98f:	75 1e                	jne    9af <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 991:	83 ec 0c             	sub    $0xc,%esp
 994:	ff 75 ec             	pushl  -0x14(%ebp)
 997:	e8 e5 fe ff ff       	call   881 <morecore>
 99c:	83 c4 10             	add    $0x10,%esp
 99f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a6:	75 07                	jne    9af <malloc+0xce>
        return 0;
 9a8:	b8 00 00 00 00       	mov    $0x0,%eax
 9ad:	eb 13                	jmp    9c2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bd:	e9 6d ff ff ff       	jmp    92f <malloc+0x4e>
}
 9c2:	c9                   	leave  
 9c3:	c3                   	ret    
