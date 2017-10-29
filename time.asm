
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
  1c:	68 a4 09 00 00       	push   $0x9a4
  21:	6a 02                	push   $0x2
  23:	e8 c6 05 00 00       	call   5ee <printf>
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
  72:	68 bd 09 00 00       	push   $0x9bd
  77:	6a 02                	push   $0x2
  79:	e8 70 05 00 00       	call   5ee <printf>
  7e:	83 c4 10             	add    $0x10,%esp
      tickasfloat(ticks_final);
  81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  84:	83 ec 0c             	sub    $0xc,%esp
  87:	50                   	push   %eax
  88:	e8 6e 00 00 00       	call   fb <tickasfloat>
  8d:	83 c4 10             	add    $0x10,%esp
      printf(2," seconds\n");
  90:	83 ec 08             	sub    $0x8,%esp
  93:	68 c8 09 00 00       	push   $0x9c8
  98:	6a 02                	push   $0x2
  9a:	e8 4f 05 00 00       	call   5ee <printf>
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
  d3:	68 d2 09 00 00       	push   $0x9d2
  d8:	6a 02                	push   $0x2
  da:	e8 0f 05 00 00       	call   5ee <printf>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 12                	jmp    f6 <main+0xf6>

  }
  else
      printf(2, "Fork error\n");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 e2 09 00 00       	push   $0x9e2
  ec:	6a 02                	push   $0x2
  ee:	e8 fb 04 00 00       	call   5ee <printf>
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
 137:	68 ee 09 00 00       	push   $0x9ee
 13c:	6a 02                	push   $0x2
 13e:	e8 ab 04 00 00       	call   5ee <printf>
 143:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
 146:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 14a:	77 1b                	ja     167 <tickasfloat+0x6c>
        printf(2,"%d%d%d", 0, 0, ticksr);
 14c:	83 ec 0c             	sub    $0xc,%esp
 14f:	ff 75 f0             	pushl  -0x10(%ebp)
 152:	6a 00                	push   $0x0
 154:	6a 00                	push   $0x0
 156:	68 f2 09 00 00       	push   $0x9f2
 15b:	6a 02                	push   $0x2
 15d:	e8 8c 04 00 00       	call   5ee <printf>
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
 172:	68 f9 09 00 00       	push   $0x9f9
 177:	6a 02                	push   $0x2
 179:	e8 70 04 00 00       	call   5ee <printf>
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
 189:	68 fe 09 00 00       	push   $0x9fe
 18e:	6a 02                	push   $0x2
 190:	e8 59 04 00 00       	call   5ee <printf>
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

00000517 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	83 ec 18             	sub    $0x18,%esp
 51d:	8b 45 0c             	mov    0xc(%ebp),%eax
 520:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 523:	83 ec 04             	sub    $0x4,%esp
 526:	6a 01                	push   $0x1
 528:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52b:	50                   	push   %eax
 52c:	ff 75 08             	pushl  0x8(%ebp)
 52f:	e8 23 ff ff ff       	call   457 <write>
 534:	83 c4 10             	add    $0x10,%esp
}
 537:	90                   	nop
 538:	c9                   	leave  
 539:	c3                   	ret    

0000053a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	53                   	push   %ebx
 53e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 548:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 54c:	74 17                	je     565 <printint+0x2b>
 54e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 552:	79 11                	jns    565 <printint+0x2b>
    neg = 1;
 554:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 55b:	8b 45 0c             	mov    0xc(%ebp),%eax
 55e:	f7 d8                	neg    %eax
 560:	89 45 ec             	mov    %eax,-0x14(%ebp)
 563:	eb 06                	jmp    56b <printint+0x31>
  } else {
    x = xx;
 565:	8b 45 0c             	mov    0xc(%ebp),%eax
 568:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 56b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 572:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 575:	8d 41 01             	lea    0x1(%ecx),%eax
 578:	89 45 f4             	mov    %eax,-0xc(%ebp)
 57b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 581:	ba 00 00 00 00       	mov    $0x0,%edx
 586:	f7 f3                	div    %ebx
 588:	89 d0                	mov    %edx,%eax
 58a:	0f b6 80 74 0c 00 00 	movzbl 0xc74(%eax),%eax
 591:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 595:	8b 5d 10             	mov    0x10(%ebp),%ebx
 598:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59b:	ba 00 00 00 00       	mov    $0x0,%edx
 5a0:	f7 f3                	div    %ebx
 5a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a9:	75 c7                	jne    572 <printint+0x38>
  if(neg)
 5ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5af:	74 2d                	je     5de <printint+0xa4>
    buf[i++] = '-';
 5b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b4:	8d 50 01             	lea    0x1(%eax),%edx
 5b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ba:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5bf:	eb 1d                	jmp    5de <printint+0xa4>
    putc(fd, buf[i]);
 5c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c7:	01 d0                	add    %edx,%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	83 ec 08             	sub    $0x8,%esp
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 3c ff ff ff       	call   517 <putc>
 5db:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e6:	79 d9                	jns    5c1 <printint+0x87>
    putc(fd, buf[i]);
}
 5e8:	90                   	nop
 5e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ec:	c9                   	leave  
 5ed:	c3                   	ret    

000005ee <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5fb:	8d 45 0c             	lea    0xc(%ebp),%eax
 5fe:	83 c0 04             	add    $0x4,%eax
 601:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 60b:	e9 59 01 00 00       	jmp    769 <printf+0x17b>
    c = fmt[i] & 0xff;
 610:	8b 55 0c             	mov    0xc(%ebp),%edx
 613:	8b 45 f0             	mov    -0x10(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	25 ff 00 00 00       	and    $0xff,%eax
 623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 626:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62a:	75 2c                	jne    658 <printf+0x6a>
      if(c == '%'){
 62c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 630:	75 0c                	jne    63e <printf+0x50>
        state = '%';
 632:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 639:	e9 27 01 00 00       	jmp    765 <printf+0x177>
      } else {
        putc(fd, c);
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	83 ec 08             	sub    $0x8,%esp
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 c7 fe ff ff       	call   517 <putc>
 650:	83 c4 10             	add    $0x10,%esp
 653:	e9 0d 01 00 00       	jmp    765 <printf+0x177>
      }
    } else if(state == '%'){
 658:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 65c:	0f 85 03 01 00 00    	jne    765 <printf+0x177>
      if(c == 'd'){
 662:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 666:	75 1e                	jne    686 <printf+0x98>
        printint(fd, *ap, 10, 1);
 668:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	6a 01                	push   $0x1
 66f:	6a 0a                	push   $0xa
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 c0 fe ff ff       	call   53a <printint>
 67a:	83 c4 10             	add    $0x10,%esp
        ap++;
 67d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 681:	e9 d8 00 00 00       	jmp    75e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 686:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 68a:	74 06                	je     692 <printf+0xa4>
 68c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 690:	75 1e                	jne    6b0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	6a 00                	push   $0x0
 699:	6a 10                	push   $0x10
 69b:	50                   	push   %eax
 69c:	ff 75 08             	pushl  0x8(%ebp)
 69f:	e8 96 fe ff ff       	call   53a <printint>
 6a4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ab:	e9 ae 00 00 00       	jmp    75e <printf+0x170>
      } else if(c == 's'){
 6b0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6b4:	75 43                	jne    6f9 <printf+0x10b>
        s = (char*)*ap;
 6b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c6:	75 25                	jne    6ed <printf+0xff>
          s = "(null)";
 6c8:	c7 45 f4 01 0a 00 00 	movl   $0xa01,-0xc(%ebp)
        while(*s != 0){
 6cf:	eb 1c                	jmp    6ed <printf+0xff>
          putc(fd, *s);
 6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d4:	0f b6 00             	movzbl (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 31 fe ff ff       	call   517 <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
          s++;
 6e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f0:	0f b6 00             	movzbl (%eax),%eax
 6f3:	84 c0                	test   %al,%al
 6f5:	75 da                	jne    6d1 <printf+0xe3>
 6f7:	eb 65                	jmp    75e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6fd:	75 1d                	jne    71c <printf+0x12e>
        putc(fd, *ap);
 6ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	0f be c0             	movsbl %al,%eax
 707:	83 ec 08             	sub    $0x8,%esp
 70a:	50                   	push   %eax
 70b:	ff 75 08             	pushl  0x8(%ebp)
 70e:	e8 04 fe ff ff       	call   517 <putc>
 713:	83 c4 10             	add    $0x10,%esp
        ap++;
 716:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71a:	eb 42                	jmp    75e <printf+0x170>
      } else if(c == '%'){
 71c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 720:	75 17                	jne    739 <printf+0x14b>
        putc(fd, c);
 722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 725:	0f be c0             	movsbl %al,%eax
 728:	83 ec 08             	sub    $0x8,%esp
 72b:	50                   	push   %eax
 72c:	ff 75 08             	pushl  0x8(%ebp)
 72f:	e8 e3 fd ff ff       	call   517 <putc>
 734:	83 c4 10             	add    $0x10,%esp
 737:	eb 25                	jmp    75e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 739:	83 ec 08             	sub    $0x8,%esp
 73c:	6a 25                	push   $0x25
 73e:	ff 75 08             	pushl  0x8(%ebp)
 741:	e8 d1 fd ff ff       	call   517 <putc>
 746:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 bc fd ff ff       	call   517 <putc>
 75b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 75e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 765:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 769:	8b 55 0c             	mov    0xc(%ebp),%edx
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	01 d0                	add    %edx,%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	84 c0                	test   %al,%al
 776:	0f 85 94 fe ff ff    	jne    610 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 77c:	90                   	nop
 77d:	c9                   	leave  
 77e:	c3                   	ret    

0000077f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77f:	55                   	push   %ebp
 780:	89 e5                	mov    %esp,%ebp
 782:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 785:	8b 45 08             	mov    0x8(%ebp),%eax
 788:	83 e8 08             	sub    $0x8,%eax
 78b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	a1 90 0c 00 00       	mov    0xc90,%eax
 793:	89 45 fc             	mov    %eax,-0x4(%ebp)
 796:	eb 24                	jmp    7bc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a0:	77 12                	ja     7b4 <free+0x35>
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a8:	77 24                	ja     7ce <free+0x4f>
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b2:	77 1a                	ja     7ce <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c2:	76 d4                	jbe    798 <free+0x19>
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cc:	76 ca                	jbe    798 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	01 c2                	add    %eax,%edx
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	39 c2                	cmp    %eax,%edx
 7e7:	75 24                	jne    80d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 50 04             	mov    0x4(%eax),%edx
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	01 c2                	add    %eax,%edx
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	8b 10                	mov    (%eax),%edx
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	89 10                	mov    %edx,(%eax)
 80b:	eb 0a                	jmp    817 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	01 d0                	add    %edx,%eax
 829:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 82c:	75 20                	jne    84e <free+0xcf>
    p->s.size += bp->s.size;
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	8b 50 04             	mov    0x4(%eax),%edx
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	01 c2                	add    %eax,%edx
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	8b 10                	mov    (%eax),%edx
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	89 10                	mov    %edx,(%eax)
 84c:	eb 08                	jmp    856 <free+0xd7>
  } else
    p->s.ptr = bp;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 55 f8             	mov    -0x8(%ebp),%edx
 854:	89 10                	mov    %edx,(%eax)
  freep = p;
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	a3 90 0c 00 00       	mov    %eax,0xc90
}
 85e:	90                   	nop
 85f:	c9                   	leave  
 860:	c3                   	ret    

00000861 <morecore>:

static Header*
morecore(uint nu)
{
 861:	55                   	push   %ebp
 862:	89 e5                	mov    %esp,%ebp
 864:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 867:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 86e:	77 07                	ja     877 <morecore+0x16>
    nu = 4096;
 870:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 877:	8b 45 08             	mov    0x8(%ebp),%eax
 87a:	c1 e0 03             	shl    $0x3,%eax
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	50                   	push   %eax
 881:	e8 39 fc ff ff       	call   4bf <sbrk>
 886:	83 c4 10             	add    $0x10,%esp
 889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 88c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 890:	75 07                	jne    899 <morecore+0x38>
    return 0;
 892:	b8 00 00 00 00       	mov    $0x0,%eax
 897:	eb 26                	jmp    8bf <morecore+0x5e>
  hp = (Header*)p;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	8b 55 08             	mov    0x8(%ebp),%edx
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ab:	83 c0 08             	add    $0x8,%eax
 8ae:	83 ec 0c             	sub    $0xc,%esp
 8b1:	50                   	push   %eax
 8b2:	e8 c8 fe ff ff       	call   77f <free>
 8b7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ba:	a1 90 0c 00 00       	mov    0xc90,%eax
}
 8bf:	c9                   	leave  
 8c0:	c3                   	ret    

000008c1 <malloc>:

void*
malloc(uint nbytes)
{
 8c1:	55                   	push   %ebp
 8c2:	89 e5                	mov    %esp,%ebp
 8c4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ca:	83 c0 07             	add    $0x7,%eax
 8cd:	c1 e8 03             	shr    $0x3,%eax
 8d0:	83 c0 01             	add    $0x1,%eax
 8d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d6:	a1 90 0c 00 00       	mov    0xc90,%eax
 8db:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e2:	75 23                	jne    907 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e4:	c7 45 f0 88 0c 00 00 	movl   $0xc88,-0x10(%ebp)
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	a3 90 0c 00 00       	mov    %eax,0xc90
 8f3:	a1 90 0c 00 00       	mov    0xc90,%eax
 8f8:	a3 88 0c 00 00       	mov    %eax,0xc88
    base.s.size = 0;
 8fd:	c7 05 8c 0c 00 00 00 	movl   $0x0,0xc8c
 904:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	8b 00                	mov    (%eax),%eax
 90c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 40 04             	mov    0x4(%eax),%eax
 915:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 918:	72 4d                	jb     967 <malloc+0xa6>
      if(p->s.size == nunits)
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 923:	75 0c                	jne    931 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 10                	mov    (%eax),%edx
 92a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92d:	89 10                	mov    %edx,(%eax)
 92f:	eb 26                	jmp    957 <malloc+0x96>
      else {
        p->s.size -= nunits;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	2b 45 ec             	sub    -0x14(%ebp),%eax
 93a:	89 c2                	mov    %eax,%edx
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	c1 e0 03             	shl    $0x3,%eax
 94b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	8b 55 ec             	mov    -0x14(%ebp),%edx
 954:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 957:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95a:	a3 90 0c 00 00       	mov    %eax,0xc90
      return (void*)(p + 1);
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	83 c0 08             	add    $0x8,%eax
 965:	eb 3b                	jmp    9a2 <malloc+0xe1>
    }
    if(p == freep)
 967:	a1 90 0c 00 00       	mov    0xc90,%eax
 96c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96f:	75 1e                	jne    98f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 971:	83 ec 0c             	sub    $0xc,%esp
 974:	ff 75 ec             	pushl  -0x14(%ebp)
 977:	e8 e5 fe ff ff       	call   861 <morecore>
 97c:	83 c4 10             	add    $0x10,%esp
 97f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 986:	75 07                	jne    98f <malloc+0xce>
        return 0;
 988:	b8 00 00 00 00       	mov    $0x0,%eax
 98d:	eb 13                	jmp    9a2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	89 45 f0             	mov    %eax,-0x10(%ebp)
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 99d:	e9 6d ff ff ff       	jmp    90f <malloc+0x4e>
}
 9a2:	c9                   	leave  
 9a3:	c3                   	ret    
