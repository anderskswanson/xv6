
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 a0 0e 00 00       	add    $0xea0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 a0 0e 00 00 	movl   $0xea0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 88 05 00 00       	call   5f2 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 a0 0e 00 00 	cmpl   $0xea0,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba a0 0e 00 00       	mov    $0xea0,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 a0 0e 00 00       	push   $0xea0
  c0:	e8 c8 04 00 00       	call   58d <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 a0 0e 00 00       	add    $0xea0,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 ff 04 00 00       	call   5ea <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 60 0b 00 00       	push   $0xb60
 11f:	6a 02                	push   $0x2
 121:	e8 83 06 00 00       	call   7a9 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 a4 04 00 00       	call   5d2 <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 81 04 00 00       	call   5d2 <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 9c 04 00 00       	call   612 <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 80 0b 00 00       	push   $0xb80
 19c:	6a 01                	push   $0x1
 19e:	e8 06 06 00 00       	call   7a9 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 27 04 00 00       	call   5d2 <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 33 04 00 00       	call   5fa <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 f8 03 00 00       	call   5d2 <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 8c 01 00 00       	call   5ea <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	3b 45 0c             	cmp    0xc(%ebp),%eax
 499:	7c b3                	jl     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 51 01 00 00       	call   612 <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 48 01 00 00       	call   62a <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 07 01 00 00       	call   5fa <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 508:	eb 04                	jmp    50e <atoi+0x13>
 50a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	3c 20                	cmp    $0x20,%al
 516:	74 f2                	je     50a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	3c 2d                	cmp    $0x2d,%al
 520:	75 07                	jne    529 <atoi+0x2e>
 522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 527:	eb 05                	jmp    52e <atoi+0x33>
 529:	b8 01 00 00 00       	mov    $0x1,%eax
 52e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	3c 2b                	cmp    $0x2b,%al
 539:	74 0a                	je     545 <atoi+0x4a>
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	3c 2d                	cmp    $0x2d,%al
 543:	75 2b                	jne    570 <atoi+0x75>
    s++;
 545:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 549:	eb 25                	jmp    570 <atoi+0x75>
    n = n*10 + *s++ - '0';
 54b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54e:	89 d0                	mov    %edx,%eax
 550:	c1 e0 02             	shl    $0x2,%eax
 553:	01 d0                	add    %edx,%eax
 555:	01 c0                	add    %eax,%eax
 557:	89 c1                	mov    %eax,%ecx
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	8d 50 01             	lea    0x1(%eax),%edx
 55f:	89 55 08             	mov    %edx,0x8(%ebp)
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	01 c8                	add    %ecx,%eax
 56a:	83 e8 30             	sub    $0x30,%eax
 56d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	3c 2f                	cmp    $0x2f,%al
 578:	7e 0a                	jle    584 <atoi+0x89>
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	3c 39                	cmp    $0x39,%al
 582:	7e c7                	jle    54b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 584:	8b 45 f8             	mov    -0x8(%ebp),%eax
 587:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 58b:	c9                   	leave  
 58c:	c3                   	ret    

0000058d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 599:	8b 45 0c             	mov    0xc(%ebp),%eax
 59c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59f:	eb 17                	jmp    5b8 <memmove+0x2b>
    *dst++ = *src++;
 5a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a4:	8d 50 01             	lea    0x1(%eax),%edx
 5a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b3:	0f b6 12             	movzbl (%edx),%edx
 5b6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b8:	8b 45 10             	mov    0x10(%ebp),%eax
 5bb:	8d 50 ff             	lea    -0x1(%eax),%edx
 5be:	89 55 10             	mov    %edx,0x10(%ebp)
 5c1:	85 c0                	test   %eax,%eax
 5c3:	7f dc                	jg     5a1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ca:	b8 01 00 00 00       	mov    $0x1,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <exit>:
SYSCALL(exit)
 5d2:	b8 02 00 00 00       	mov    $0x2,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <wait>:
SYSCALL(wait)
 5da:	b8 03 00 00 00       	mov    $0x3,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <pipe>:
SYSCALL(pipe)
 5e2:	b8 04 00 00 00       	mov    $0x4,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <read>:
SYSCALL(read)
 5ea:	b8 05 00 00 00       	mov    $0x5,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <write>:
SYSCALL(write)
 5f2:	b8 10 00 00 00       	mov    $0x10,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <close>:
SYSCALL(close)
 5fa:	b8 15 00 00 00       	mov    $0x15,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <kill>:
SYSCALL(kill)
 602:	b8 06 00 00 00       	mov    $0x6,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <exec>:
SYSCALL(exec)
 60a:	b8 07 00 00 00       	mov    $0x7,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <open>:
SYSCALL(open)
 612:	b8 0f 00 00 00       	mov    $0xf,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mknod>:
SYSCALL(mknod)
 61a:	b8 11 00 00 00       	mov    $0x11,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <unlink>:
SYSCALL(unlink)
 622:	b8 12 00 00 00       	mov    $0x12,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <fstat>:
SYSCALL(fstat)
 62a:	b8 08 00 00 00       	mov    $0x8,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <link>:
SYSCALL(link)
 632:	b8 13 00 00 00       	mov    $0x13,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mkdir>:
SYSCALL(mkdir)
 63a:	b8 14 00 00 00       	mov    $0x14,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <chdir>:
SYSCALL(chdir)
 642:	b8 09 00 00 00       	mov    $0x9,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <dup>:
SYSCALL(dup)
 64a:	b8 0a 00 00 00       	mov    $0xa,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <getpid>:
SYSCALL(getpid)
 652:	b8 0b 00 00 00       	mov    $0xb,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <sbrk>:
SYSCALL(sbrk)
 65a:	b8 0c 00 00 00       	mov    $0xc,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <sleep>:
SYSCALL(sleep)
 662:	b8 0d 00 00 00       	mov    $0xd,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <uptime>:
SYSCALL(uptime)
 66a:	b8 0e 00 00 00       	mov    $0xe,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <halt>:
SYSCALL(halt)
 672:	b8 16 00 00 00       	mov    $0x16,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <date>:
SYSCALL(date)
 67a:	b8 17 00 00 00       	mov    $0x17,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <getuid>:
SYSCALL(getuid)
 682:	b8 18 00 00 00       	mov    $0x18,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <getgid>:
SYSCALL(getgid)
 68a:	b8 19 00 00 00       	mov    $0x19,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <getppid>:
SYSCALL(getppid)
 692:	b8 1a 00 00 00       	mov    $0x1a,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <setuid>:
SYSCALL(setuid)
 69a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <setgid>:
SYSCALL(setgid)
 6a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <getprocs>:
SYSCALL(getprocs)
 6aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <setpriority>:
SYSCALL(setpriority)
 6b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <chmod>:
SYSCALL(chmod)
 6ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <chown>:
SYSCALL(chown)
 6c2:	b8 20 00 00 00       	mov    $0x20,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <chgrp>:
SYSCALL(chgrp)    
 6ca:	b8 21 00 00 00       	mov    $0x21,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6d2:	55                   	push   %ebp
 6d3:	89 e5                	mov    %esp,%ebp
 6d5:	83 ec 18             	sub    $0x18,%esp
 6d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6db:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6de:	83 ec 04             	sub    $0x4,%esp
 6e1:	6a 01                	push   $0x1
 6e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 03 ff ff ff       	call   5f2 <write>
 6ef:	83 c4 10             	add    $0x10,%esp
}
 6f2:	90                   	nop
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	53                   	push   %ebx
 6f9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 703:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 707:	74 17                	je     720 <printint+0x2b>
 709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 70d:	79 11                	jns    720 <printint+0x2b>
    neg = 1;
 70f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 716:	8b 45 0c             	mov    0xc(%ebp),%eax
 719:	f7 d8                	neg    %eax
 71b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71e:	eb 06                	jmp    726 <printint+0x31>
  } else {
    x = xx;
 720:	8b 45 0c             	mov    0xc(%ebp),%eax
 723:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 72d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 730:	8d 41 01             	lea    0x1(%ecx),%eax
 733:	89 45 f4             	mov    %eax,-0xc(%ebp)
 736:	8b 5d 10             	mov    0x10(%ebp),%ebx
 739:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73c:	ba 00 00 00 00       	mov    $0x0,%edx
 741:	f7 f3                	div    %ebx
 743:	89 d0                	mov    %edx,%eax
 745:	0f b6 80 6c 0e 00 00 	movzbl 0xe6c(%eax),%eax
 74c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 750:	8b 5d 10             	mov    0x10(%ebp),%ebx
 753:	8b 45 ec             	mov    -0x14(%ebp),%eax
 756:	ba 00 00 00 00       	mov    $0x0,%edx
 75b:	f7 f3                	div    %ebx
 75d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 760:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 764:	75 c7                	jne    72d <printint+0x38>
  if(neg)
 766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76a:	74 2d                	je     799 <printint+0xa4>
    buf[i++] = '-';
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8d 50 01             	lea    0x1(%eax),%edx
 772:	89 55 f4             	mov    %edx,-0xc(%ebp)
 775:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 77a:	eb 1d                	jmp    799 <printint+0xa4>
    putc(fd, buf[i]);
 77c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	01 d0                	add    %edx,%eax
 784:	0f b6 00             	movzbl (%eax),%eax
 787:	0f be c0             	movsbl %al,%eax
 78a:	83 ec 08             	sub    $0x8,%esp
 78d:	50                   	push   %eax
 78e:	ff 75 08             	pushl  0x8(%ebp)
 791:	e8 3c ff ff ff       	call   6d2 <putc>
 796:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 799:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 79d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a1:	79 d9                	jns    77c <printint+0x87>
    putc(fd, buf[i]);
}
 7a3:	90                   	nop
 7a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7b6:	8d 45 0c             	lea    0xc(%ebp),%eax
 7b9:	83 c0 04             	add    $0x4,%eax
 7bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7c6:	e9 59 01 00 00       	jmp    924 <printf+0x17b>
    c = fmt[i] & 0xff;
 7cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	01 d0                	add    %edx,%eax
 7d3:	0f b6 00             	movzbl (%eax),%eax
 7d6:	0f be c0             	movsbl %al,%eax
 7d9:	25 ff 00 00 00       	and    $0xff,%eax
 7de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7e5:	75 2c                	jne    813 <printf+0x6a>
      if(c == '%'){
 7e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7eb:	75 0c                	jne    7f9 <printf+0x50>
        state = '%';
 7ed:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7f4:	e9 27 01 00 00       	jmp    920 <printf+0x177>
      } else {
        putc(fd, c);
 7f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7fc:	0f be c0             	movsbl %al,%eax
 7ff:	83 ec 08             	sub    $0x8,%esp
 802:	50                   	push   %eax
 803:	ff 75 08             	pushl  0x8(%ebp)
 806:	e8 c7 fe ff ff       	call   6d2 <putc>
 80b:	83 c4 10             	add    $0x10,%esp
 80e:	e9 0d 01 00 00       	jmp    920 <printf+0x177>
      }
    } else if(state == '%'){
 813:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 817:	0f 85 03 01 00 00    	jne    920 <printf+0x177>
      if(c == 'd'){
 81d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 821:	75 1e                	jne    841 <printf+0x98>
        printint(fd, *ap, 10, 1);
 823:	8b 45 e8             	mov    -0x18(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	6a 01                	push   $0x1
 82a:	6a 0a                	push   $0xa
 82c:	50                   	push   %eax
 82d:	ff 75 08             	pushl  0x8(%ebp)
 830:	e8 c0 fe ff ff       	call   6f5 <printint>
 835:	83 c4 10             	add    $0x10,%esp
        ap++;
 838:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83c:	e9 d8 00 00 00       	jmp    919 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 841:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 845:	74 06                	je     84d <printf+0xa4>
 847:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 84b:	75 1e                	jne    86b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 84d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	6a 00                	push   $0x0
 854:	6a 10                	push   $0x10
 856:	50                   	push   %eax
 857:	ff 75 08             	pushl  0x8(%ebp)
 85a:	e8 96 fe ff ff       	call   6f5 <printint>
 85f:	83 c4 10             	add    $0x10,%esp
        ap++;
 862:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 866:	e9 ae 00 00 00       	jmp    919 <printf+0x170>
      } else if(c == 's'){
 86b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 86f:	75 43                	jne    8b4 <printf+0x10b>
        s = (char*)*ap;
 871:	8b 45 e8             	mov    -0x18(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 879:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 87d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 881:	75 25                	jne    8a8 <printf+0xff>
          s = "(null)";
 883:	c7 45 f4 96 0b 00 00 	movl   $0xb96,-0xc(%ebp)
        while(*s != 0){
 88a:	eb 1c                	jmp    8a8 <printf+0xff>
          putc(fd, *s);
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	0f b6 00             	movzbl (%eax),%eax
 892:	0f be c0             	movsbl %al,%eax
 895:	83 ec 08             	sub    $0x8,%esp
 898:	50                   	push   %eax
 899:	ff 75 08             	pushl  0x8(%ebp)
 89c:	e8 31 fe ff ff       	call   6d2 <putc>
 8a1:	83 c4 10             	add    $0x10,%esp
          s++;
 8a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	0f b6 00             	movzbl (%eax),%eax
 8ae:	84 c0                	test   %al,%al
 8b0:	75 da                	jne    88c <printf+0xe3>
 8b2:	eb 65                	jmp    919 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8b4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b8:	75 1d                	jne    8d7 <printf+0x12e>
        putc(fd, *ap);
 8ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	0f be c0             	movsbl %al,%eax
 8c2:	83 ec 08             	sub    $0x8,%esp
 8c5:	50                   	push   %eax
 8c6:	ff 75 08             	pushl  0x8(%ebp)
 8c9:	e8 04 fe ff ff       	call   6d2 <putc>
 8ce:	83 c4 10             	add    $0x10,%esp
        ap++;
 8d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8d5:	eb 42                	jmp    919 <printf+0x170>
      } else if(c == '%'){
 8d7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8db:	75 17                	jne    8f4 <printf+0x14b>
        putc(fd, c);
 8dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e0:	0f be c0             	movsbl %al,%eax
 8e3:	83 ec 08             	sub    $0x8,%esp
 8e6:	50                   	push   %eax
 8e7:	ff 75 08             	pushl  0x8(%ebp)
 8ea:	e8 e3 fd ff ff       	call   6d2 <putc>
 8ef:	83 c4 10             	add    $0x10,%esp
 8f2:	eb 25                	jmp    919 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8f4:	83 ec 08             	sub    $0x8,%esp
 8f7:	6a 25                	push   $0x25
 8f9:	ff 75 08             	pushl  0x8(%ebp)
 8fc:	e8 d1 fd ff ff       	call   6d2 <putc>
 901:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 907:	0f be c0             	movsbl %al,%eax
 90a:	83 ec 08             	sub    $0x8,%esp
 90d:	50                   	push   %eax
 90e:	ff 75 08             	pushl  0x8(%ebp)
 911:	e8 bc fd ff ff       	call   6d2 <putc>
 916:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 919:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 920:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 924:	8b 55 0c             	mov    0xc(%ebp),%edx
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	01 d0                	add    %edx,%eax
 92c:	0f b6 00             	movzbl (%eax),%eax
 92f:	84 c0                	test   %al,%al
 931:	0f 85 94 fe ff ff    	jne    7cb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 937:	90                   	nop
 938:	c9                   	leave  
 939:	c3                   	ret    

0000093a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93a:	55                   	push   %ebp
 93b:	89 e5                	mov    %esp,%ebp
 93d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	8b 45 08             	mov    0x8(%ebp),%eax
 943:	83 e8 08             	sub    $0x8,%eax
 946:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 949:	a1 88 0e 00 00       	mov    0xe88,%eax
 94e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 951:	eb 24                	jmp    977 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 953:	8b 45 fc             	mov    -0x4(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95b:	77 12                	ja     96f <free+0x35>
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 963:	77 24                	ja     989 <free+0x4f>
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96d:	77 1a                	ja     989 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	89 45 fc             	mov    %eax,-0x4(%ebp)
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 97d:	76 d4                	jbe    953 <free+0x19>
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	8b 00                	mov    (%eax),%eax
 984:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 987:	76 ca                	jbe    953 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 989:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98c:	8b 40 04             	mov    0x4(%eax),%eax
 98f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	01 c2                	add    %eax,%edx
 99b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99e:	8b 00                	mov    (%eax),%eax
 9a0:	39 c2                	cmp    %eax,%edx
 9a2:	75 24                	jne    9c8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a7:	8b 50 04             	mov    0x4(%eax),%edx
 9aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ad:	8b 00                	mov    (%eax),%eax
 9af:	8b 40 04             	mov    0x4(%eax),%eax
 9b2:	01 c2                	add    %eax,%edx
 9b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	8b 10                	mov    (%eax),%edx
 9c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c4:	89 10                	mov    %edx,(%eax)
 9c6:	eb 0a                	jmp    9d2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	8b 10                	mov    (%eax),%edx
 9cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e2:	01 d0                	add    %edx,%eax
 9e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e7:	75 20                	jne    a09 <free+0xcf>
    p->s.size += bp->s.size;
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	8b 50 04             	mov    0x4(%eax),%edx
 9ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f2:	8b 40 04             	mov    0x4(%eax),%eax
 9f5:	01 c2                	add    %eax,%edx
 9f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a00:	8b 10                	mov    (%eax),%edx
 a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a05:	89 10                	mov    %edx,(%eax)
 a07:	eb 08                	jmp    a11 <free+0xd7>
  } else
    p->s.ptr = bp;
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a0f:	89 10                	mov    %edx,(%eax)
  freep = p;
 a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a14:	a3 88 0e 00 00       	mov    %eax,0xe88
}
 a19:	90                   	nop
 a1a:	c9                   	leave  
 a1b:	c3                   	ret    

00000a1c <morecore>:

static Header*
morecore(uint nu)
{
 a1c:	55                   	push   %ebp
 a1d:	89 e5                	mov    %esp,%ebp
 a1f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a22:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a29:	77 07                	ja     a32 <morecore+0x16>
    nu = 4096;
 a2b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a32:	8b 45 08             	mov    0x8(%ebp),%eax
 a35:	c1 e0 03             	shl    $0x3,%eax
 a38:	83 ec 0c             	sub    $0xc,%esp
 a3b:	50                   	push   %eax
 a3c:	e8 19 fc ff ff       	call   65a <sbrk>
 a41:	83 c4 10             	add    $0x10,%esp
 a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a47:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a4b:	75 07                	jne    a54 <morecore+0x38>
    return 0;
 a4d:	b8 00 00 00 00       	mov    $0x0,%eax
 a52:	eb 26                	jmp    a7a <morecore+0x5e>
  hp = (Header*)p;
 a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5d:	8b 55 08             	mov    0x8(%ebp),%edx
 a60:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a66:	83 c0 08             	add    $0x8,%eax
 a69:	83 ec 0c             	sub    $0xc,%esp
 a6c:	50                   	push   %eax
 a6d:	e8 c8 fe ff ff       	call   93a <free>
 a72:	83 c4 10             	add    $0x10,%esp
  return freep;
 a75:	a1 88 0e 00 00       	mov    0xe88,%eax
}
 a7a:	c9                   	leave  
 a7b:	c3                   	ret    

00000a7c <malloc>:

void*
malloc(uint nbytes)
{
 a7c:	55                   	push   %ebp
 a7d:	89 e5                	mov    %esp,%ebp
 a7f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	8b 45 08             	mov    0x8(%ebp),%eax
 a85:	83 c0 07             	add    $0x7,%eax
 a88:	c1 e8 03             	shr    $0x3,%eax
 a8b:	83 c0 01             	add    $0x1,%eax
 a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a91:	a1 88 0e 00 00       	mov    0xe88,%eax
 a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a9d:	75 23                	jne    ac2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a9f:	c7 45 f0 80 0e 00 00 	movl   $0xe80,-0x10(%ebp)
 aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa9:	a3 88 0e 00 00       	mov    %eax,0xe88
 aae:	a1 88 0e 00 00       	mov    0xe88,%eax
 ab3:	a3 80 0e 00 00       	mov    %eax,0xe80
    base.s.size = 0;
 ab8:	c7 05 84 0e 00 00 00 	movl   $0x0,0xe84
 abf:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac5:	8b 00                	mov    (%eax),%eax
 ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	8b 40 04             	mov    0x4(%eax),%eax
 ad0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad3:	72 4d                	jb     b22 <malloc+0xa6>
      if(p->s.size == nunits)
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	8b 40 04             	mov    0x4(%eax),%eax
 adb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ade:	75 0c                	jne    aec <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae3:	8b 10                	mov    (%eax),%edx
 ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae8:	89 10                	mov    %edx,(%eax)
 aea:	eb 26                	jmp    b12 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	8b 40 04             	mov    0x4(%eax),%eax
 af2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 af5:	89 c2                	mov    %eax,%edx
 af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b00:	8b 40 04             	mov    0x4(%eax),%eax
 b03:	c1 e0 03             	shl    $0x3,%eax
 b06:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b0f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b15:	a3 88 0e 00 00       	mov    %eax,0xe88
      return (void*)(p + 1);
 b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1d:	83 c0 08             	add    $0x8,%eax
 b20:	eb 3b                	jmp    b5d <malloc+0xe1>
    }
    if(p == freep)
 b22:	a1 88 0e 00 00       	mov    0xe88,%eax
 b27:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b2a:	75 1e                	jne    b4a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b2c:	83 ec 0c             	sub    $0xc,%esp
 b2f:	ff 75 ec             	pushl  -0x14(%ebp)
 b32:	e8 e5 fe ff ff       	call   a1c <morecore>
 b37:	83 c4 10             	add    $0x10,%esp
 b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b41:	75 07                	jne    b4a <malloc+0xce>
        return 0;
 b43:	b8 00 00 00 00       	mov    $0x0,%eax
 b48:	eb 13                	jmp    b5d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b53:	8b 00                	mov    (%eax),%eax
 b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b58:	e9 6d ff ff ff       	jmp    aca <malloc+0x4e>
}
 b5d:	c9                   	leave  
 b5e:	c3                   	ret    
