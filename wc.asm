
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 c0 0c 00 00       	add    $0xcc0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 c0 0c 00 00       	add    $0xcc0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 c6 09 00 00       	push   $0x9c6
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 c0 0c 00 00       	push   $0xcc0
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 d1 03 00 00       	call   471 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 cc 09 00 00       	push   $0x9cc
  be:	6a 01                	push   $0x1
  c0:	e8 4b 05 00 00       	call   610 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 8c 03 00 00       	call   459 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 dc 09 00 00       	push   $0x9dc
  e1:	6a 01                	push   $0x1
  e3:	e8 28 05 00 00       	call   610 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 e9 09 00 00       	push   $0x9e9
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 3b 03 00 00       	call   459 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 53 03 00 00       	call   499 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 ea 09 00 00       	push   $0x9ea
 16c:	6a 01                	push   $0x1
 16e:	e8 9d 04 00 00       	call   610 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 de 02 00 00       	call   459 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 db 02 00 00       	call   481 <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 9c 02 00 00       	call   459 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 8c 01 00 00       	call   471 <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 51 01 00 00       	call   499 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 48 01 00 00       	call   4b1 <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 07 01 00 00       	call   481 <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 38f:	eb 04                	jmp    395 <atoi+0x13>
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	3c 20                	cmp    $0x20,%al
 39d:	74 f2                	je     391 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	3c 2d                	cmp    $0x2d,%al
 3a7:	75 07                	jne    3b0 <atoi+0x2e>
 3a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ae:	eb 05                	jmp    3b5 <atoi+0x33>
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	3c 2b                	cmp    $0x2b,%al
 3c0:	74 0a                	je     3cc <atoi+0x4a>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	3c 2d                	cmp    $0x2d,%al
 3ca:	75 2b                	jne    3f7 <atoi+0x75>
    s++;
 3cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3d0:	eb 25                	jmp    3f7 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	c1 e0 02             	shl    $0x2,%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	01 c0                	add    %eax,%eax
 3de:	89 c1                	mov    %eax,%ecx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	8d 50 01             	lea    0x1(%eax),%edx
 3e6:	89 55 08             	mov    %edx,0x8(%ebp)
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	0f be c0             	movsbl %al,%eax
 3ef:	01 c8                	add    %ecx,%eax
 3f1:	83 e8 30             	sub    $0x30,%eax
 3f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3c 2f                	cmp    $0x2f,%al
 3ff:	7e 0a                	jle    40b <atoi+0x89>
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	3c 39                	cmp    $0x39,%al
 409:	7e c7                	jle    3d2 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 40b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 426:	eb 17                	jmp    43f <memmove+0x2b>
    *dst++ = *src++;
 428:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42b:	8d 50 01             	lea    0x1(%eax),%edx
 42e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 431:	8b 55 f8             	mov    -0x8(%ebp),%edx
 434:	8d 4a 01             	lea    0x1(%edx),%ecx
 437:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 43a:	0f b6 12             	movzbl (%edx),%edx
 43d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43f:	8b 45 10             	mov    0x10(%ebp),%eax
 442:	8d 50 ff             	lea    -0x1(%eax),%edx
 445:	89 55 10             	mov    %edx,0x10(%ebp)
 448:	85 c0                	test   %eax,%eax
 44a:	7f dc                	jg     428 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 451:	b8 01 00 00 00       	mov    $0x1,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <exit>:
SYSCALL(exit)
 459:	b8 02 00 00 00       	mov    $0x2,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <wait>:
SYSCALL(wait)
 461:	b8 03 00 00 00       	mov    $0x3,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <pipe>:
SYSCALL(pipe)
 469:	b8 04 00 00 00       	mov    $0x4,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <read>:
SYSCALL(read)
 471:	b8 05 00 00 00       	mov    $0x5,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <write>:
SYSCALL(write)
 479:	b8 10 00 00 00       	mov    $0x10,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <close>:
SYSCALL(close)
 481:	b8 15 00 00 00       	mov    $0x15,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <kill>:
SYSCALL(kill)
 489:	b8 06 00 00 00       	mov    $0x6,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <exec>:
SYSCALL(exec)
 491:	b8 07 00 00 00       	mov    $0x7,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <open>:
SYSCALL(open)
 499:	b8 0f 00 00 00       	mov    $0xf,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mknod>:
SYSCALL(mknod)
 4a1:	b8 11 00 00 00       	mov    $0x11,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <unlink>:
SYSCALL(unlink)
 4a9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <fstat>:
SYSCALL(fstat)
 4b1:	b8 08 00 00 00       	mov    $0x8,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <link>:
SYSCALL(link)
 4b9:	b8 13 00 00 00       	mov    $0x13,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mkdir>:
SYSCALL(mkdir)
 4c1:	b8 14 00 00 00       	mov    $0x14,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <chdir>:
SYSCALL(chdir)
 4c9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <dup>:
SYSCALL(dup)
 4d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getpid>:
SYSCALL(getpid)
 4d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sbrk>:
SYSCALL(sbrk)
 4e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sleep>:
SYSCALL(sleep)
 4e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <uptime>:
SYSCALL(uptime)
 4f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <halt>:
SYSCALL(halt)
 4f9:	b8 16 00 00 00       	mov    $0x16,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <date>:
SYSCALL(date)
 501:	b8 17 00 00 00       	mov    $0x17,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <getuid>:
SYSCALL(getuid)
 509:	b8 18 00 00 00       	mov    $0x18,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <getgid>:
SYSCALL(getgid)
 511:	b8 19 00 00 00       	mov    $0x19,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <getppid>:
SYSCALL(getppid)
 519:	b8 1a 00 00 00       	mov    $0x1a,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <setuid>:
SYSCALL(setuid)
 521:	b8 1b 00 00 00       	mov    $0x1b,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <setgid>:
SYSCALL(setgid)
 529:	b8 1c 00 00 00       	mov    $0x1c,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <getprocs>:
SYSCALL(getprocs)
 531:	b8 1d 00 00 00       	mov    $0x1d,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	83 ec 18             	sub    $0x18,%esp
 53f:	8b 45 0c             	mov    0xc(%ebp),%eax
 542:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 545:	83 ec 04             	sub    $0x4,%esp
 548:	6a 01                	push   $0x1
 54a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 23 ff ff ff       	call   479 <write>
 556:	83 c4 10             	add    $0x10,%esp
}
 559:	90                   	nop
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	53                   	push   %ebx
 560:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 563:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56e:	74 17                	je     587 <printint+0x2b>
 570:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 574:	79 11                	jns    587 <printint+0x2b>
    neg = 1;
 576:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57d:	8b 45 0c             	mov    0xc(%ebp),%eax
 580:	f7 d8                	neg    %eax
 582:	89 45 ec             	mov    %eax,-0x14(%ebp)
 585:	eb 06                	jmp    58d <printint+0x31>
  } else {
    x = xx;
 587:	8b 45 0c             	mov    0xc(%ebp),%eax
 58a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 594:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 597:	8d 41 01             	lea    0x1(%ecx),%eax
 59a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a3:	ba 00 00 00 00       	mov    $0x0,%edx
 5a8:	f7 f3                	div    %ebx
 5aa:	89 d0                	mov    %edx,%eax
 5ac:	0f b6 80 74 0c 00 00 	movzbl 0xc74(%eax),%eax
 5b3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bd:	ba 00 00 00 00       	mov    $0x0,%edx
 5c2:	f7 f3                	div    %ebx
 5c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cb:	75 c7                	jne    594 <printint+0x38>
  if(neg)
 5cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d1:	74 2d                	je     600 <printint+0xa4>
    buf[i++] = '-';
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	8d 50 01             	lea    0x1(%eax),%edx
 5d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5dc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e1:	eb 1d                	jmp    600 <printint+0xa4>
    putc(fd, buf[i]);
 5e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e9:	01 d0                	add    %edx,%eax
 5eb:	0f b6 00             	movzbl (%eax),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 3c ff ff ff       	call   539 <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 600:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 608:	79 d9                	jns    5e3 <printint+0x87>
    putc(fd, buf[i]);
}
 60a:	90                   	nop
 60b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 60e:	c9                   	leave  
 60f:	c3                   	ret    

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 616:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61d:	8d 45 0c             	lea    0xc(%ebp),%eax
 620:	83 c0 04             	add    $0x4,%eax
 623:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62d:	e9 59 01 00 00       	jmp    78b <printf+0x17b>
    c = fmt[i] & 0xff;
 632:	8b 55 0c             	mov    0xc(%ebp),%edx
 635:	8b 45 f0             	mov    -0x10(%ebp),%eax
 638:	01 d0                	add    %edx,%eax
 63a:	0f b6 00             	movzbl (%eax),%eax
 63d:	0f be c0             	movsbl %al,%eax
 640:	25 ff 00 00 00       	and    $0xff,%eax
 645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 648:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64c:	75 2c                	jne    67a <printf+0x6a>
      if(c == '%'){
 64e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 652:	75 0c                	jne    660 <printf+0x50>
        state = '%';
 654:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 65b:	e9 27 01 00 00       	jmp    787 <printf+0x177>
      } else {
        putc(fd, c);
 660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 663:	0f be c0             	movsbl %al,%eax
 666:	83 ec 08             	sub    $0x8,%esp
 669:	50                   	push   %eax
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 c7 fe ff ff       	call   539 <putc>
 672:	83 c4 10             	add    $0x10,%esp
 675:	e9 0d 01 00 00       	jmp    787 <printf+0x177>
      }
    } else if(state == '%'){
 67a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67e:	0f 85 03 01 00 00    	jne    787 <printf+0x177>
      if(c == 'd'){
 684:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 688:	75 1e                	jne    6a8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 68a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	6a 01                	push   $0x1
 691:	6a 0a                	push   $0xa
 693:	50                   	push   %eax
 694:	ff 75 08             	pushl  0x8(%ebp)
 697:	e8 c0 fe ff ff       	call   55c <printint>
 69c:	83 c4 10             	add    $0x10,%esp
        ap++;
 69f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a3:	e9 d8 00 00 00       	jmp    780 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ac:	74 06                	je     6b4 <printf+0xa4>
 6ae:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b2:	75 1e                	jne    6d2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	6a 00                	push   $0x0
 6bb:	6a 10                	push   $0x10
 6bd:	50                   	push   %eax
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 96 fe ff ff       	call   55c <printint>
 6c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cd:	e9 ae 00 00 00       	jmp    780 <printf+0x170>
      } else if(c == 's'){
 6d2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d6:	75 43                	jne    71b <printf+0x10b>
        s = (char*)*ap;
 6d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e8:	75 25                	jne    70f <printf+0xff>
          s = "(null)";
 6ea:	c7 45 f4 fe 09 00 00 	movl   $0x9fe,-0xc(%ebp)
        while(*s != 0){
 6f1:	eb 1c                	jmp    70f <printf+0xff>
          putc(fd, *s);
 6f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f6:	0f b6 00             	movzbl (%eax),%eax
 6f9:	0f be c0             	movsbl %al,%eax
 6fc:	83 ec 08             	sub    $0x8,%esp
 6ff:	50                   	push   %eax
 700:	ff 75 08             	pushl  0x8(%ebp)
 703:	e8 31 fe ff ff       	call   539 <putc>
 708:	83 c4 10             	add    $0x10,%esp
          s++;
 70b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	0f b6 00             	movzbl (%eax),%eax
 715:	84 c0                	test   %al,%al
 717:	75 da                	jne    6f3 <printf+0xe3>
 719:	eb 65                	jmp    780 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 71f:	75 1d                	jne    73e <printf+0x12e>
        putc(fd, *ap);
 721:	8b 45 e8             	mov    -0x18(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	0f be c0             	movsbl %al,%eax
 729:	83 ec 08             	sub    $0x8,%esp
 72c:	50                   	push   %eax
 72d:	ff 75 08             	pushl  0x8(%ebp)
 730:	e8 04 fe ff ff       	call   539 <putc>
 735:	83 c4 10             	add    $0x10,%esp
        ap++;
 738:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73c:	eb 42                	jmp    780 <printf+0x170>
      } else if(c == '%'){
 73e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 742:	75 17                	jne    75b <printf+0x14b>
        putc(fd, c);
 744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	83 ec 08             	sub    $0x8,%esp
 74d:	50                   	push   %eax
 74e:	ff 75 08             	pushl  0x8(%ebp)
 751:	e8 e3 fd ff ff       	call   539 <putc>
 756:	83 c4 10             	add    $0x10,%esp
 759:	eb 25                	jmp    780 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75b:	83 ec 08             	sub    $0x8,%esp
 75e:	6a 25                	push   $0x25
 760:	ff 75 08             	pushl  0x8(%ebp)
 763:	e8 d1 fd ff ff       	call   539 <putc>
 768:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 76b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76e:	0f be c0             	movsbl %al,%eax
 771:	83 ec 08             	sub    $0x8,%esp
 774:	50                   	push   %eax
 775:	ff 75 08             	pushl  0x8(%ebp)
 778:	e8 bc fd ff ff       	call   539 <putc>
 77d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 780:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 787:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 78b:	8b 55 0c             	mov    0xc(%ebp),%edx
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	01 d0                	add    %edx,%eax
 793:	0f b6 00             	movzbl (%eax),%eax
 796:	84 c0                	test   %al,%al
 798:	0f 85 94 fe ff ff    	jne    632 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79e:	90                   	nop
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	83 e8 08             	sub    $0x8,%eax
 7ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	a1 a8 0c 00 00       	mov    0xca8,%eax
 7b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b8:	eb 24                	jmp    7de <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c2:	77 12                	ja     7d6 <free+0x35>
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ca:	77 24                	ja     7f0 <free+0x4f>
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d4:	77 1a                	ja     7f0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e4:	76 d4                	jbe    7ba <free+0x19>
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ee:	76 ca                	jbe    7ba <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	01 c2                	add    %eax,%edx
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	39 c2                	cmp    %eax,%edx
 809:	75 24                	jne    82f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	8b 50 04             	mov    0x4(%eax),%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	01 c2                	add    %eax,%edx
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 0a                	jmp    839 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 10                	mov    (%eax),%edx
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	01 d0                	add    %edx,%eax
 84b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84e:	75 20                	jne    870 <free+0xcf>
    p->s.size += bp->s.size;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 50 04             	mov    0x4(%eax),%edx
 856:	8b 45 f8             	mov    -0x8(%ebp),%eax
 859:	8b 40 04             	mov    0x4(%eax),%eax
 85c:	01 c2                	add    %eax,%edx
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	8b 10                	mov    (%eax),%edx
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	89 10                	mov    %edx,(%eax)
 86e:	eb 08                	jmp    878 <free+0xd7>
  } else
    p->s.ptr = bp;
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 55 f8             	mov    -0x8(%ebp),%edx
 876:	89 10                	mov    %edx,(%eax)
  freep = p;
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87b:	a3 a8 0c 00 00       	mov    %eax,0xca8
}
 880:	90                   	nop
 881:	c9                   	leave  
 882:	c3                   	ret    

00000883 <morecore>:

static Header*
morecore(uint nu)
{
 883:	55                   	push   %ebp
 884:	89 e5                	mov    %esp,%ebp
 886:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 889:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 890:	77 07                	ja     899 <morecore+0x16>
    nu = 4096;
 892:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	c1 e0 03             	shl    $0x3,%eax
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	50                   	push   %eax
 8a3:	e8 39 fc ff ff       	call   4e1 <sbrk>
 8a8:	83 c4 10             	add    $0x10,%esp
 8ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b2:	75 07                	jne    8bb <morecore+0x38>
    return 0;
 8b4:	b8 00 00 00 00       	mov    $0x0,%eax
 8b9:	eb 26                	jmp    8e1 <morecore+0x5e>
  hp = (Header*)p;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	8b 55 08             	mov    0x8(%ebp),%edx
 8c7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	83 c0 08             	add    $0x8,%eax
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	50                   	push   %eax
 8d4:	e8 c8 fe ff ff       	call   7a1 <free>
 8d9:	83 c4 10             	add    $0x10,%esp
  return freep;
 8dc:	a1 a8 0c 00 00       	mov    0xca8,%eax
}
 8e1:	c9                   	leave  
 8e2:	c3                   	ret    

000008e3 <malloc>:

void*
malloc(uint nbytes)
{
 8e3:	55                   	push   %ebp
 8e4:	89 e5                	mov    %esp,%ebp
 8e6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ec:	83 c0 07             	add    $0x7,%eax
 8ef:	c1 e8 03             	shr    $0x3,%eax
 8f2:	83 c0 01             	add    $0x1,%eax
 8f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f8:	a1 a8 0c 00 00       	mov    0xca8,%eax
 8fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 904:	75 23                	jne    929 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 906:	c7 45 f0 a0 0c 00 00 	movl   $0xca0,-0x10(%ebp)
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	a3 a8 0c 00 00       	mov    %eax,0xca8
 915:	a1 a8 0c 00 00       	mov    0xca8,%eax
 91a:	a3 a0 0c 00 00       	mov    %eax,0xca0
    base.s.size = 0;
 91f:	c7 05 a4 0c 00 00 00 	movl   $0x0,0xca4
 926:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93a:	72 4d                	jb     989 <malloc+0xa6>
      if(p->s.size == nunits)
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 40 04             	mov    0x4(%eax),%eax
 942:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 945:	75 0c                	jne    953 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 947:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94a:	8b 10                	mov    (%eax),%edx
 94c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94f:	89 10                	mov    %edx,(%eax)
 951:	eb 26                	jmp    979 <malloc+0x96>
      else {
        p->s.size -= nunits;
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 40 04             	mov    0x4(%eax),%eax
 959:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95c:	89 c2                	mov    %eax,%edx
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 40 04             	mov    0x4(%eax),%eax
 96a:	c1 e0 03             	shl    $0x3,%eax
 96d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 55 ec             	mov    -0x14(%ebp),%edx
 976:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 979:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97c:	a3 a8 0c 00 00       	mov    %eax,0xca8
      return (void*)(p + 1);
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	83 c0 08             	add    $0x8,%eax
 987:	eb 3b                	jmp    9c4 <malloc+0xe1>
    }
    if(p == freep)
 989:	a1 a8 0c 00 00       	mov    0xca8,%eax
 98e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 991:	75 1e                	jne    9b1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 993:	83 ec 0c             	sub    $0xc,%esp
 996:	ff 75 ec             	pushl  -0x14(%ebp)
 999:	e8 e5 fe ff ff       	call   883 <morecore>
 99e:	83 c4 10             	add    $0x10,%esp
 9a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a8:	75 07                	jne    9b1 <malloc+0xce>
        return 0;
 9aa:	b8 00 00 00 00       	mov    $0x0,%eax
 9af:	eb 13                	jmp    9c4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8b 00                	mov    (%eax),%eax
 9bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bf:	e9 6d ff ff ff       	jmp    931 <malloc+0x4e>
}
 9c4:	c9                   	leave  
 9c5:	c3                   	ret    
