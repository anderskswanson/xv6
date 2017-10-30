
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
  11:	83 ec 18             	sub    $0x18,%esp

  struct uproc * utable;  
  int max = 72;
  14:	c7 45 e0 48 00 00 00 	movl   $0x48,-0x20(%ebp)
  int uprocsize;
  utable = (struct uproc *) malloc(sizeof(struct uproc) * max);
  1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1e:	6b c0 5c             	imul   $0x5c,%eax,%eax
  21:	83 ec 0c             	sub    $0xc,%esp
  24:	50                   	push   %eax
  25:	e8 fd 08 00 00       	call   927 <malloc>
  2a:	83 c4 10             	add    $0x10,%esp
  2d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  uprocsize = getprocs(max, utable);
  30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  33:	83 ec 08             	sub    $0x8,%esp
  36:	ff 75 dc             	pushl  -0x24(%ebp)
  39:	50                   	push   %eax
  3a:	e8 36 05 00 00       	call   575 <getprocs>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(uprocsize >= 0)
  45:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  49:	0f 88 ed 00 00 00    	js     13c <main+0x13c>
  {
      printf(2, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  4f:	83 ec 08             	sub    $0x8,%esp
  52:	68 0c 0a 00 00       	push   $0xa0c
  57:	6a 02                	push   $0x2
  59:	e8 f6 05 00 00       	call   654 <printf>
  5e:	83 c4 10             	add    $0x10,%esp
      for(int i = 0; i < uprocsize; ++i)
  61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  68:	e9 c1 00 00 00       	jmp    12e <main+0x12e>
      {
          printf(2, "%d\t%s\t%d\t%d\t%d\t", utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
  6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  70:	6b d0 5c             	imul   $0x5c,%eax,%edx
  73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  76:	01 d0                	add    %edx,%eax
  78:	8b 58 0c             	mov    0xc(%eax),%ebx
  7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7e:	6b d0 5c             	imul   $0x5c,%eax,%edx
  81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  84:	01 d0                	add    %edx,%eax
  86:	8b 48 08             	mov    0x8(%eax),%ecx
  89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8c:	6b d0 5c             	imul   $0x5c,%eax,%edx
  8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  92:	01 d0                	add    %edx,%eax
  94:	8b 50 04             	mov    0x4(%eax),%edx
  97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9a:	6b f0 5c             	imul   $0x5c,%eax,%esi
  9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  a0:	01 f0                	add    %esi,%eax
  a2:	8d 70 3c             	lea    0x3c(%eax),%esi
  a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a8:	6b f8 5c             	imul   $0x5c,%eax,%edi
  ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  ae:	01 f8                	add    %edi,%eax
  b0:	8b 00                	mov    (%eax),%eax
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	53                   	push   %ebx
  b6:	51                   	push   %ecx
  b7:	52                   	push   %edx
  b8:	56                   	push   %esi
  b9:	50                   	push   %eax
  ba:	68 3a 0a 00 00       	push   $0xa3a
  bf:	6a 02                	push   $0x2
  c1:	e8 8e 05 00 00       	call   654 <printf>
  c6:	83 c4 20             	add    $0x20,%esp
          tickasfloat(utable[i].elapsed_ticks);
  c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  cc:	6b d0 5c             	imul   $0x5c,%eax,%edx
  cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	8b 40 10             	mov    0x10(%eax),%eax
  d7:	83 ec 0c             	sub    $0xc,%esp
  da:	50                   	push   %eax
  db:	e8 81 00 00 00       	call   161 <tickasfloat>
  e0:	83 c4 10             	add    $0x10,%esp
          tickasfloat(utable[i].CPU_total_ticks);
  e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  e6:	6b d0 5c             	imul   $0x5c,%eax,%edx
  e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  ec:	01 d0                	add    %edx,%eax
  ee:	8b 40 14             	mov    0x14(%eax),%eax
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	50                   	push   %eax
  f5:	e8 67 00 00 00       	call   161 <tickasfloat>
  fa:	83 c4 10             	add    $0x10,%esp
          printf(2, "%s\t%d\n", utable[i].state, utable[i].size);
  fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 100:	6b d0 5c             	imul   $0x5c,%eax,%edx
 103:	8b 45 dc             	mov    -0x24(%ebp),%eax
 106:	01 d0                	add    %edx,%eax
 108:	8b 40 38             	mov    0x38(%eax),%eax
 10b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 10e:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 111:	8b 55 dc             	mov    -0x24(%ebp),%edx
 114:	01 ca                	add    %ecx,%edx
 116:	83 c2 18             	add    $0x18,%edx
 119:	50                   	push   %eax
 11a:	52                   	push   %edx
 11b:	68 4a 0a 00 00       	push   $0xa4a
 120:	6a 02                	push   $0x2
 122:	e8 2d 05 00 00       	call   654 <printf>
 127:	83 c4 10             	add    $0x10,%esp

  uprocsize = getprocs(max, utable);
  if(uprocsize >= 0)
  {
      printf(2, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
      for(int i = 0; i < uprocsize; ++i)
 12a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 12e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 131:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 134:	0f 8c 33 ff ff ff    	jl     6d <main+0x6d>
 13a:	eb 12                	jmp    14e <main+0x14e>
          tickasfloat(utable[i].CPU_total_ticks);
          printf(2, "%s\t%d\n", utable[i].state, utable[i].size);
      }
  }
  else
      printf(2, "Error getting processes\n");
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	68 51 0a 00 00       	push   $0xa51
 144:	6a 02                	push   $0x2
 146:	e8 09 05 00 00       	call   654 <printf>
 14b:	83 c4 10             	add    $0x10,%esp

  free(utable);
 14e:	83 ec 0c             	sub    $0xc,%esp
 151:	ff 75 dc             	pushl  -0x24(%ebp)
 154:	e8 8c 06 00 00       	call   7e5 <free>
 159:	83 c4 10             	add    $0x10,%esp
  exit();
 15c:	e8 3c 03 00 00       	call   49d <exit>

00000161 <tickasfloat>:
}

static void 
tickasfloat(uint tickcount)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 18             	sub    $0x18,%esp
    uint ticksl = tickcount / 1000;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 16f:	f7 e2                	mul    %edx
 171:	89 d0                	mov    %edx,%eax
 173:	c1 e8 06             	shr    $0x6,%eax
 176:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ticksr = tickcount % 1000;
 179:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17c:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 181:	89 c8                	mov    %ecx,%eax
 183:	f7 e2                	mul    %edx
 185:	89 d0                	mov    %edx,%eax
 187:	c1 e8 06             	shr    $0x6,%eax
 18a:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 190:	29 c1                	sub    %eax,%ecx
 192:	89 c8                	mov    %ecx,%eax
 194:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2,"%d.", ticksl);
 197:	83 ec 04             	sub    $0x4,%esp
 19a:	ff 75 f4             	pushl  -0xc(%ebp)
 19d:	68 6a 0a 00 00       	push   $0xa6a
 1a2:	6a 02                	push   $0x2
 1a4:	e8 ab 04 00 00       	call   654 <printf>
 1a9:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
 1ac:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 1b0:	77 1b                	ja     1cd <tickasfloat+0x6c>
        printf(2,"%d%d%d\t", 0, 0, ticksr);
 1b2:	83 ec 0c             	sub    $0xc,%esp
 1b5:	ff 75 f0             	pushl  -0x10(%ebp)
 1b8:	6a 00                	push   $0x0
 1ba:	6a 00                	push   $0x0
 1bc:	68 6e 0a 00 00       	push   $0xa6e
 1c1:	6a 02                	push   $0x2
 1c3:	e8 8c 04 00 00       	call   654 <printf>
 1c8:	83 c4 20             	add    $0x20,%esp
    else if(ticksr < 100)
        printf(2,"%d%d\t", 0, ticksr);
    else
        printf(2,"%d\t", ticksr);

}
 1cb:	eb 31                	jmp    1fe <tickasfloat+0x9d>
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    printf(2,"%d.", ticksl);
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
 1cd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 1d1:	77 16                	ja     1e9 <tickasfloat+0x88>
        printf(2,"%d%d\t", 0, ticksr);
 1d3:	ff 75 f0             	pushl  -0x10(%ebp)
 1d6:	6a 00                	push   $0x0
 1d8:	68 76 0a 00 00       	push   $0xa76
 1dd:	6a 02                	push   $0x2
 1df:	e8 70 04 00 00       	call   654 <printf>
 1e4:	83 c4 10             	add    $0x10,%esp
    else
        printf(2,"%d\t", ticksr);

}
 1e7:	eb 15                	jmp    1fe <tickasfloat+0x9d>
    if(ticksr < 10) //pad zeroes
        printf(2,"%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        printf(2,"%d%d\t", 0, ticksr);
    else
        printf(2,"%d\t", ticksr);
 1e9:	83 ec 04             	sub    $0x4,%esp
 1ec:	ff 75 f0             	pushl  -0x10(%ebp)
 1ef:	68 7c 0a 00 00       	push   $0xa7c
 1f4:	6a 02                	push   $0x2
 1f6:	e8 59 04 00 00       	call   654 <printf>
 1fb:	83 c4 10             	add    $0x10,%esp

}
 1fe:	90                   	nop
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	57                   	push   %edi
 205:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 206:	8b 4d 08             	mov    0x8(%ebp),%ecx
 209:	8b 55 10             	mov    0x10(%ebp),%edx
 20c:	8b 45 0c             	mov    0xc(%ebp),%eax
 20f:	89 cb                	mov    %ecx,%ebx
 211:	89 df                	mov    %ebx,%edi
 213:	89 d1                	mov    %edx,%ecx
 215:	fc                   	cld    
 216:	f3 aa                	rep stos %al,%es:(%edi)
 218:	89 ca                	mov    %ecx,%edx
 21a:	89 fb                	mov    %edi,%ebx
 21c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 21f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 222:	90                   	nop
 223:	5b                   	pop    %ebx
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    

00000227 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 233:	90                   	nop
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 08             	mov    %edx,0x8(%ebp)
 23d:	8b 55 0c             	mov    0xc(%ebp),%edx
 240:	8d 4a 01             	lea    0x1(%edx),%ecx
 243:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 246:	0f b6 12             	movzbl (%edx),%edx
 249:	88 10                	mov    %dl,(%eax)
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 e2                	jne    234 <strcpy+0xd>
    ;
  return os;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 25a:	eb 08                	jmp    264 <strcmp+0xd>
    p++, q++;
 25c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 260:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	84 c0                	test   %al,%al
 26c:	74 10                	je     27e <strcmp+0x27>
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 10             	movzbl (%eax),%edx
 274:	8b 45 0c             	mov    0xc(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	38 c2                	cmp    %al,%dl
 27c:	74 de                	je     25c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	0f b6 d0             	movzbl %al,%edx
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	0f b6 c0             	movzbl %al,%eax
 290:	29 c2                	sub    %eax,%edx
 292:	89 d0                	mov    %edx,%eax
}
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    

00000296 <strlen>:

uint
strlen(char *s)
{
 296:	55                   	push   %ebp
 297:	89 e5                	mov    %esp,%ebp
 299:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 29c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a3:	eb 04                	jmp    2a9 <strlen+0x13>
 2a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	01 d0                	add    %edx,%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	84 c0                	test   %al,%al
 2b6:	75 ed                	jne    2a5 <strlen+0xf>
    ;
  return n;
 2b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2c0:	8b 45 10             	mov    0x10(%ebp),%eax
 2c3:	50                   	push   %eax
 2c4:	ff 75 0c             	pushl  0xc(%ebp)
 2c7:	ff 75 08             	pushl  0x8(%ebp)
 2ca:	e8 32 ff ff ff       	call   201 <stosb>
 2cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <strchr>:

char*
strchr(const char *s, char c)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 04             	sub    $0x4,%esp
 2dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2e3:	eb 14                	jmp    2f9 <strchr+0x22>
    if(*s == c)
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ee:	75 05                	jne    2f5 <strchr+0x1e>
      return (char*)s;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	eb 13                	jmp    308 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 00             	movzbl (%eax),%eax
 2ff:	84 c0                	test   %al,%al
 301:	75 e2                	jne    2e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 303:	b8 00 00 00 00       	mov    $0x0,%eax
}
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <gets>:

char*
gets(char *buf, int max)
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 317:	eb 42                	jmp    35b <gets+0x51>
    cc = read(0, &c, 1);
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	6a 01                	push   $0x1
 31e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 321:	50                   	push   %eax
 322:	6a 00                	push   $0x0
 324:	e8 8c 01 00 00       	call   4b5 <read>
 329:	83 c4 10             	add    $0x10,%esp
 32c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 32f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 333:	7e 33                	jle    368 <gets+0x5e>
      break;
    buf[i++] = c;
 335:	8b 45 f4             	mov    -0xc(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 33e:	89 c2                	mov    %eax,%edx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	01 c2                	add    %eax,%edx
 345:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 349:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 34b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34f:	3c 0a                	cmp    $0xa,%al
 351:	74 16                	je     369 <gets+0x5f>
 353:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 357:	3c 0d                	cmp    $0xd,%al
 359:	74 0e                	je     369 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35e:	83 c0 01             	add    $0x1,%eax
 361:	3b 45 0c             	cmp    0xc(%ebp),%eax
 364:	7c b3                	jl     319 <gets+0xf>
 366:	eb 01                	jmp    369 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 368:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 369:	8b 55 f4             	mov    -0xc(%ebp),%edx
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	01 d0                	add    %edx,%eax
 371:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 374:	8b 45 08             	mov    0x8(%ebp),%eax
}
 377:	c9                   	leave  
 378:	c3                   	ret    

00000379 <stat>:

int
stat(char *n, struct stat *st)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37f:	83 ec 08             	sub    $0x8,%esp
 382:	6a 00                	push   $0x0
 384:	ff 75 08             	pushl  0x8(%ebp)
 387:	e8 51 01 00 00       	call   4dd <open>
 38c:	83 c4 10             	add    $0x10,%esp
 38f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 392:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 396:	79 07                	jns    39f <stat+0x26>
    return -1;
 398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 39d:	eb 25                	jmp    3c4 <stat+0x4b>
  r = fstat(fd, st);
 39f:	83 ec 08             	sub    $0x8,%esp
 3a2:	ff 75 0c             	pushl  0xc(%ebp)
 3a5:	ff 75 f4             	pushl  -0xc(%ebp)
 3a8:	e8 48 01 00 00       	call   4f5 <fstat>
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3b3:	83 ec 0c             	sub    $0xc,%esp
 3b6:	ff 75 f4             	pushl  -0xc(%ebp)
 3b9:	e8 07 01 00 00       	call   4c5 <close>
 3be:	83 c4 10             	add    $0x10,%esp
  return r;
 3c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <atoi>:

int
atoi(const char *s)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3d3:	eb 04                	jmp    3d9 <atoi+0x13>
 3d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	3c 20                	cmp    $0x20,%al
 3e1:	74 f2                	je     3d5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	3c 2d                	cmp    $0x2d,%al
 3eb:	75 07                	jne    3f4 <atoi+0x2e>
 3ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f2:	eb 05                	jmp    3f9 <atoi+0x33>
 3f4:	b8 01 00 00 00       	mov    $0x1,%eax
 3f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	0f b6 00             	movzbl (%eax),%eax
 402:	3c 2b                	cmp    $0x2b,%al
 404:	74 0a                	je     410 <atoi+0x4a>
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	3c 2d                	cmp    $0x2d,%al
 40e:	75 2b                	jne    43b <atoi+0x75>
    s++;
 410:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 414:	eb 25                	jmp    43b <atoi+0x75>
    n = n*10 + *s++ - '0';
 416:	8b 55 fc             	mov    -0x4(%ebp),%edx
 419:	89 d0                	mov    %edx,%eax
 41b:	c1 e0 02             	shl    $0x2,%eax
 41e:	01 d0                	add    %edx,%eax
 420:	01 c0                	add    %eax,%eax
 422:	89 c1                	mov    %eax,%ecx
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	8d 50 01             	lea    0x1(%eax),%edx
 42a:	89 55 08             	mov    %edx,0x8(%ebp)
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	0f be c0             	movsbl %al,%eax
 433:	01 c8                	add    %ecx,%eax
 435:	83 e8 30             	sub    $0x30,%eax
 438:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	0f b6 00             	movzbl (%eax),%eax
 441:	3c 2f                	cmp    $0x2f,%al
 443:	7e 0a                	jle    44f <atoi+0x89>
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	0f b6 00             	movzbl (%eax),%eax
 44b:	3c 39                	cmp    $0x39,%al
 44d:	7e c7                	jle    416 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 44f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 452:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 456:	c9                   	leave  
 457:	c3                   	ret    

00000458 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 464:	8b 45 0c             	mov    0xc(%ebp),%eax
 467:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 46a:	eb 17                	jmp    483 <memmove+0x2b>
    *dst++ = *src++;
 46c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 46f:	8d 50 01             	lea    0x1(%eax),%edx
 472:	89 55 fc             	mov    %edx,-0x4(%ebp)
 475:	8b 55 f8             	mov    -0x8(%ebp),%edx
 478:	8d 4a 01             	lea    0x1(%edx),%ecx
 47b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 47e:	0f b6 12             	movzbl (%edx),%edx
 481:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 483:	8b 45 10             	mov    0x10(%ebp),%eax
 486:	8d 50 ff             	lea    -0x1(%eax),%edx
 489:	89 55 10             	mov    %edx,0x10(%ebp)
 48c:	85 c0                	test   %eax,%eax
 48e:	7f dc                	jg     46c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 490:	8b 45 08             	mov    0x8(%ebp),%eax
}
 493:	c9                   	leave  
 494:	c3                   	ret    

00000495 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 495:	b8 01 00 00 00       	mov    $0x1,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <exit>:
SYSCALL(exit)
 49d:	b8 02 00 00 00       	mov    $0x2,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <wait>:
SYSCALL(wait)
 4a5:	b8 03 00 00 00       	mov    $0x3,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <pipe>:
SYSCALL(pipe)
 4ad:	b8 04 00 00 00       	mov    $0x4,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <read>:
SYSCALL(read)
 4b5:	b8 05 00 00 00       	mov    $0x5,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <write>:
SYSCALL(write)
 4bd:	b8 10 00 00 00       	mov    $0x10,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <close>:
SYSCALL(close)
 4c5:	b8 15 00 00 00       	mov    $0x15,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <kill>:
SYSCALL(kill)
 4cd:	b8 06 00 00 00       	mov    $0x6,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <exec>:
SYSCALL(exec)
 4d5:	b8 07 00 00 00       	mov    $0x7,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <open>:
SYSCALL(open)
 4dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <mknod>:
SYSCALL(mknod)
 4e5:	b8 11 00 00 00       	mov    $0x11,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <unlink>:
SYSCALL(unlink)
 4ed:	b8 12 00 00 00       	mov    $0x12,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <fstat>:
SYSCALL(fstat)
 4f5:	b8 08 00 00 00       	mov    $0x8,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <link>:
SYSCALL(link)
 4fd:	b8 13 00 00 00       	mov    $0x13,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <mkdir>:
SYSCALL(mkdir)
 505:	b8 14 00 00 00       	mov    $0x14,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <chdir>:
SYSCALL(chdir)
 50d:	b8 09 00 00 00       	mov    $0x9,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <dup>:
SYSCALL(dup)
 515:	b8 0a 00 00 00       	mov    $0xa,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <getpid>:
SYSCALL(getpid)
 51d:	b8 0b 00 00 00       	mov    $0xb,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <sbrk>:
SYSCALL(sbrk)
 525:	b8 0c 00 00 00       	mov    $0xc,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <sleep>:
SYSCALL(sleep)
 52d:	b8 0d 00 00 00       	mov    $0xd,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <uptime>:
SYSCALL(uptime)
 535:	b8 0e 00 00 00       	mov    $0xe,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <halt>:
SYSCALL(halt)
 53d:	b8 16 00 00 00       	mov    $0x16,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <date>:
SYSCALL(date)
 545:	b8 17 00 00 00       	mov    $0x17,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <getuid>:
SYSCALL(getuid)
 54d:	b8 18 00 00 00       	mov    $0x18,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <getgid>:
SYSCALL(getgid)
 555:	b8 19 00 00 00       	mov    $0x19,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <getppid>:
SYSCALL(getppid)
 55d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <setuid>:
SYSCALL(setuid)
 565:	b8 1b 00 00 00       	mov    $0x1b,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <setgid>:
SYSCALL(setgid)
 56d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <getprocs>:
SYSCALL(getprocs)
 575:	b8 1d 00 00 00       	mov    $0x1d,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 57d:	55                   	push   %ebp
 57e:	89 e5                	mov    %esp,%ebp
 580:	83 ec 18             	sub    $0x18,%esp
 583:	8b 45 0c             	mov    0xc(%ebp),%eax
 586:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 589:	83 ec 04             	sub    $0x4,%esp
 58c:	6a 01                	push   $0x1
 58e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 591:	50                   	push   %eax
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 23 ff ff ff       	call   4bd <write>
 59a:	83 c4 10             	add    $0x10,%esp
}
 59d:	90                   	nop
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	53                   	push   %ebx
 5a4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b2:	74 17                	je     5cb <printint+0x2b>
 5b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5b8:	79 11                	jns    5cb <printint+0x2b>
    neg = 1;
 5ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c4:	f7 d8                	neg    %eax
 5c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c9:	eb 06                	jmp    5d1 <printint+0x31>
  } else {
    x = xx;
 5cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5d8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5db:	8d 41 01             	lea    0x1(%ecx),%eax
 5de:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e7:	ba 00 00 00 00       	mov    $0x0,%edx
 5ec:	f7 f3                	div    %ebx
 5ee:	89 d0                	mov    %edx,%eax
 5f0:	0f b6 80 fc 0c 00 00 	movzbl 0xcfc(%eax),%eax
 5f7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 601:	ba 00 00 00 00       	mov    $0x0,%edx
 606:	f7 f3                	div    %ebx
 608:	89 45 ec             	mov    %eax,-0x14(%ebp)
 60b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60f:	75 c7                	jne    5d8 <printint+0x38>
  if(neg)
 611:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 615:	74 2d                	je     644 <printint+0xa4>
    buf[i++] = '-';
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	8d 50 01             	lea    0x1(%eax),%edx
 61d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 620:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 625:	eb 1d                	jmp    644 <printint+0xa4>
    putc(fd, buf[i]);
 627:	8d 55 dc             	lea    -0x24(%ebp),%edx
 62a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62d:	01 d0                	add    %edx,%eax
 62f:	0f b6 00             	movzbl (%eax),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 3c ff ff ff       	call   57d <putc>
 641:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 644:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64c:	79 d9                	jns    627 <printint+0x87>
    putc(fd, buf[i]);
}
 64e:	90                   	nop
 64f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 652:	c9                   	leave  
 653:	c3                   	ret    

00000654 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 65a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 661:	8d 45 0c             	lea    0xc(%ebp),%eax
 664:	83 c0 04             	add    $0x4,%eax
 667:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 66a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 671:	e9 59 01 00 00       	jmp    7cf <printf+0x17b>
    c = fmt[i] & 0xff;
 676:	8b 55 0c             	mov    0xc(%ebp),%edx
 679:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67c:	01 d0                	add    %edx,%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	25 ff 00 00 00       	and    $0xff,%eax
 689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 68c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 690:	75 2c                	jne    6be <printf+0x6a>
      if(c == '%'){
 692:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 696:	75 0c                	jne    6a4 <printf+0x50>
        state = '%';
 698:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 69f:	e9 27 01 00 00       	jmp    7cb <printf+0x177>
      } else {
        putc(fd, c);
 6a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a7:	0f be c0             	movsbl %al,%eax
 6aa:	83 ec 08             	sub    $0x8,%esp
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 c7 fe ff ff       	call   57d <putc>
 6b6:	83 c4 10             	add    $0x10,%esp
 6b9:	e9 0d 01 00 00       	jmp    7cb <printf+0x177>
      }
    } else if(state == '%'){
 6be:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6c2:	0f 85 03 01 00 00    	jne    7cb <printf+0x177>
      if(c == 'd'){
 6c8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6cc:	75 1e                	jne    6ec <printf+0x98>
        printint(fd, *ap, 10, 1);
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	6a 01                	push   $0x1
 6d5:	6a 0a                	push   $0xa
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 c0 fe ff ff       	call   5a0 <printint>
 6e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e7:	e9 d8 00 00 00       	jmp    7c4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ec:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6f0:	74 06                	je     6f8 <printf+0xa4>
 6f2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6f6:	75 1e                	jne    716 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	6a 00                	push   $0x0
 6ff:	6a 10                	push   $0x10
 701:	50                   	push   %eax
 702:	ff 75 08             	pushl  0x8(%ebp)
 705:	e8 96 fe ff ff       	call   5a0 <printint>
 70a:	83 c4 10             	add    $0x10,%esp
        ap++;
 70d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 711:	e9 ae 00 00 00       	jmp    7c4 <printf+0x170>
      } else if(c == 's'){
 716:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 71a:	75 43                	jne    75f <printf+0x10b>
        s = (char*)*ap;
 71c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 724:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72c:	75 25                	jne    753 <printf+0xff>
          s = "(null)";
 72e:	c7 45 f4 80 0a 00 00 	movl   $0xa80,-0xc(%ebp)
        while(*s != 0){
 735:	eb 1c                	jmp    753 <printf+0xff>
          putc(fd, *s);
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	0f b6 00             	movzbl (%eax),%eax
 73d:	0f be c0             	movsbl %al,%eax
 740:	83 ec 08             	sub    $0x8,%esp
 743:	50                   	push   %eax
 744:	ff 75 08             	pushl  0x8(%ebp)
 747:	e8 31 fe ff ff       	call   57d <putc>
 74c:	83 c4 10             	add    $0x10,%esp
          s++;
 74f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	0f b6 00             	movzbl (%eax),%eax
 759:	84 c0                	test   %al,%al
 75b:	75 da                	jne    737 <printf+0xe3>
 75d:	eb 65                	jmp    7c4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 75f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 763:	75 1d                	jne    782 <printf+0x12e>
        putc(fd, *ap);
 765:	8b 45 e8             	mov    -0x18(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	0f be c0             	movsbl %al,%eax
 76d:	83 ec 08             	sub    $0x8,%esp
 770:	50                   	push   %eax
 771:	ff 75 08             	pushl  0x8(%ebp)
 774:	e8 04 fe ff ff       	call   57d <putc>
 779:	83 c4 10             	add    $0x10,%esp
        ap++;
 77c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 780:	eb 42                	jmp    7c4 <printf+0x170>
      } else if(c == '%'){
 782:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 786:	75 17                	jne    79f <printf+0x14b>
        putc(fd, c);
 788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78b:	0f be c0             	movsbl %al,%eax
 78e:	83 ec 08             	sub    $0x8,%esp
 791:	50                   	push   %eax
 792:	ff 75 08             	pushl  0x8(%ebp)
 795:	e8 e3 fd ff ff       	call   57d <putc>
 79a:	83 c4 10             	add    $0x10,%esp
 79d:	eb 25                	jmp    7c4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79f:	83 ec 08             	sub    $0x8,%esp
 7a2:	6a 25                	push   $0x25
 7a4:	ff 75 08             	pushl  0x8(%ebp)
 7a7:	e8 d1 fd ff ff       	call   57d <putc>
 7ac:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b2:	0f be c0             	movsbl %al,%eax
 7b5:	83 ec 08             	sub    $0x8,%esp
 7b8:	50                   	push   %eax
 7b9:	ff 75 08             	pushl  0x8(%ebp)
 7bc:	e8 bc fd ff ff       	call   57d <putc>
 7c1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	01 d0                	add    %edx,%eax
 7d7:	0f b6 00             	movzbl (%eax),%eax
 7da:	84 c0                	test   %al,%al
 7dc:	0f 85 94 fe ff ff    	jne    676 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e2:	90                   	nop
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	83 e8 08             	sub    $0x8,%eax
 7f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	a1 18 0d 00 00       	mov    0xd18,%eax
 7f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fc:	eb 24                	jmp    822 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 806:	77 12                	ja     81a <free+0x35>
 808:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80e:	77 24                	ja     834 <free+0x4f>
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 818:	77 1a                	ja     834 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 828:	76 d4                	jbe    7fe <free+0x19>
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 832:	76 ca                	jbe    7fe <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	01 c2                	add    %eax,%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	39 c2                	cmp    %eax,%edx
 84d:	75 24                	jne    873 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 50 04             	mov    0x4(%eax),%edx
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	01 c2                	add    %eax,%edx
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	8b 10                	mov    (%eax),%edx
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	89 10                	mov    %edx,(%eax)
 871:	eb 0a                	jmp    87d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 40 04             	mov    0x4(%eax),%eax
 883:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	01 d0                	add    %edx,%eax
 88f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 892:	75 20                	jne    8b4 <free+0xcf>
    p->s.size += bp->s.size;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 50 04             	mov    0x4(%eax),%edx
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	01 c2                	add    %eax,%edx
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	8b 10                	mov    (%eax),%edx
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	89 10                	mov    %edx,(%eax)
 8b2:	eb 08                	jmp    8bc <free+0xd7>
  } else
    p->s.ptr = bp;
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8ba:	89 10                	mov    %edx,(%eax)
  freep = p;
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	a3 18 0d 00 00       	mov    %eax,0xd18
}
 8c4:	90                   	nop
 8c5:	c9                   	leave  
 8c6:	c3                   	ret    

000008c7 <morecore>:

static Header*
morecore(uint nu)
{
 8c7:	55                   	push   %ebp
 8c8:	89 e5                	mov    %esp,%ebp
 8ca:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8cd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d4:	77 07                	ja     8dd <morecore+0x16>
    nu = 4096;
 8d6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8dd:	8b 45 08             	mov    0x8(%ebp),%eax
 8e0:	c1 e0 03             	shl    $0x3,%eax
 8e3:	83 ec 0c             	sub    $0xc,%esp
 8e6:	50                   	push   %eax
 8e7:	e8 39 fc ff ff       	call   525 <sbrk>
 8ec:	83 c4 10             	add    $0x10,%esp
 8ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f6:	75 07                	jne    8ff <morecore+0x38>
    return 0;
 8f8:	b8 00 00 00 00       	mov    $0x0,%eax
 8fd:	eb 26                	jmp    925 <morecore+0x5e>
  hp = (Header*)p;
 8ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 902:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	8b 55 08             	mov    0x8(%ebp),%edx
 90b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	83 c0 08             	add    $0x8,%eax
 914:	83 ec 0c             	sub    $0xc,%esp
 917:	50                   	push   %eax
 918:	e8 c8 fe ff ff       	call   7e5 <free>
 91d:	83 c4 10             	add    $0x10,%esp
  return freep;
 920:	a1 18 0d 00 00       	mov    0xd18,%eax
}
 925:	c9                   	leave  
 926:	c3                   	ret    

00000927 <malloc>:

void*
malloc(uint nbytes)
{
 927:	55                   	push   %ebp
 928:	89 e5                	mov    %esp,%ebp
 92a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	83 c0 07             	add    $0x7,%eax
 933:	c1 e8 03             	shr    $0x3,%eax
 936:	83 c0 01             	add    $0x1,%eax
 939:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 93c:	a1 18 0d 00 00       	mov    0xd18,%eax
 941:	89 45 f0             	mov    %eax,-0x10(%ebp)
 944:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 948:	75 23                	jne    96d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 94a:	c7 45 f0 10 0d 00 00 	movl   $0xd10,-0x10(%ebp)
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	a3 18 0d 00 00       	mov    %eax,0xd18
 959:	a1 18 0d 00 00       	mov    0xd18,%eax
 95e:	a3 10 0d 00 00       	mov    %eax,0xd10
    base.s.size = 0;
 963:	c7 05 14 0d 00 00 00 	movl   $0x0,0xd14
 96a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	8b 40 04             	mov    0x4(%eax),%eax
 97b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 97e:	72 4d                	jb     9cd <malloc+0xa6>
      if(p->s.size == nunits)
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 989:	75 0c                	jne    997 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	8b 10                	mov    (%eax),%edx
 990:	8b 45 f0             	mov    -0x10(%ebp),%eax
 993:	89 10                	mov    %edx,(%eax)
 995:	eb 26                	jmp    9bd <malloc+0x96>
      else {
        p->s.size -= nunits;
 997:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99a:	8b 40 04             	mov    0x4(%eax),%eax
 99d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9a0:	89 c2                	mov    %eax,%edx
 9a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ab:	8b 40 04             	mov    0x4(%eax),%eax
 9ae:	c1 e0 03             	shl    $0x3,%eax
 9b1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c0:	a3 18 0d 00 00       	mov    %eax,0xd18
      return (void*)(p + 1);
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	83 c0 08             	add    $0x8,%eax
 9cb:	eb 3b                	jmp    a08 <malloc+0xe1>
    }
    if(p == freep)
 9cd:	a1 18 0d 00 00       	mov    0xd18,%eax
 9d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9d5:	75 1e                	jne    9f5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9d7:	83 ec 0c             	sub    $0xc,%esp
 9da:	ff 75 ec             	pushl  -0x14(%ebp)
 9dd:	e8 e5 fe ff ff       	call   8c7 <morecore>
 9e2:	83 c4 10             	add    $0x10,%esp
 9e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ec:	75 07                	jne    9f5 <malloc+0xce>
        return 0;
 9ee:	b8 00 00 00 00       	mov    $0x0,%eax
 9f3:	eb 13                	jmp    a08 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 00                	mov    (%eax),%eax
 a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a03:	e9 6d ff ff ff       	jmp    975 <malloc+0x4e>
}
 a08:	c9                   	leave  
 a09:	c3                   	ret    
