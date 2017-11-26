
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
  32:	05 e0 0c 00 00       	add    $0xce0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 e0 0c 00 00       	add    $0xce0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 e6 09 00 00       	push   $0x9e6
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
  93:	68 e0 0c 00 00       	push   $0xce0
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
  b9:	68 ec 09 00 00       	push   $0x9ec
  be:	6a 01                	push   $0x1
  c0:	e8 6b 05 00 00       	call   630 <printf>
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
  dc:	68 fc 09 00 00       	push   $0x9fc
  e1:	6a 01                	push   $0x1
  e3:	e8 48 05 00 00       	call   630 <printf>
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
 10a:	68 09 0a 00 00       	push   $0xa09
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
 167:	68 0a 0a 00 00       	push   $0xa0a
 16c:	6a 01                	push   $0x1
 16e:	e8 bd 04 00 00       	call   630 <printf>
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

00000539 <setpriority>:
SYSCALL(setpriority)
 539:	b8 1e 00 00 00       	mov    $0x1e,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <chmod>:
SYSCALL(chmod)
 541:	b8 1f 00 00 00       	mov    $0x1f,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <chown>:
SYSCALL(chown)
 549:	b8 20 00 00 00       	mov    $0x20,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <chgrp>:
SYSCALL(chgrp)    
 551:	b8 21 00 00 00       	mov    $0x21,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 559:	55                   	push   %ebp
 55a:	89 e5                	mov    %esp,%ebp
 55c:	83 ec 18             	sub    $0x18,%esp
 55f:	8b 45 0c             	mov    0xc(%ebp),%eax
 562:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 565:	83 ec 04             	sub    $0x4,%esp
 568:	6a 01                	push   $0x1
 56a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 56d:	50                   	push   %eax
 56e:	ff 75 08             	pushl  0x8(%ebp)
 571:	e8 03 ff ff ff       	call   479 <write>
 576:	83 c4 10             	add    $0x10,%esp
}
 579:	90                   	nop
 57a:	c9                   	leave  
 57b:	c3                   	ret    

0000057c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57c:	55                   	push   %ebp
 57d:	89 e5                	mov    %esp,%ebp
 57f:	53                   	push   %ebx
 580:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 583:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 58a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 58e:	74 17                	je     5a7 <printint+0x2b>
 590:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 594:	79 11                	jns    5a7 <printint+0x2b>
    neg = 1;
 596:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 59d:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a0:	f7 d8                	neg    %eax
 5a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a5:	eb 06                	jmp    5ad <printint+0x31>
  } else {
    x = xx;
 5a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5b7:	8d 41 01             	lea    0x1(%ecx),%eax
 5ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c3:	ba 00 00 00 00       	mov    $0x0,%edx
 5c8:	f7 f3                	div    %ebx
 5ca:	89 d0                	mov    %edx,%eax
 5cc:	0f b6 80 94 0c 00 00 	movzbl 0xc94(%eax),%eax
 5d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5dd:	ba 00 00 00 00       	mov    $0x0,%edx
 5e2:	f7 f3                	div    %ebx
 5e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5eb:	75 c7                	jne    5b4 <printint+0x38>
  if(neg)
 5ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f1:	74 2d                	je     620 <printint+0xa4>
    buf[i++] = '-';
 5f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f6:	8d 50 01             	lea    0x1(%eax),%edx
 5f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 601:	eb 1d                	jmp    620 <printint+0xa4>
    putc(fd, buf[i]);
 603:	8d 55 dc             	lea    -0x24(%ebp),%edx
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	01 d0                	add    %edx,%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	83 ec 08             	sub    $0x8,%esp
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 3c ff ff ff       	call   559 <putc>
 61d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 620:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 628:	79 d9                	jns    603 <printint+0x87>
    putc(fd, buf[i]);
}
 62a:	90                   	nop
 62b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 62e:	c9                   	leave  
 62f:	c3                   	ret    

00000630 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 63d:	8d 45 0c             	lea    0xc(%ebp),%eax
 640:	83 c0 04             	add    $0x4,%eax
 643:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 646:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 64d:	e9 59 01 00 00       	jmp    7ab <printf+0x17b>
    c = fmt[i] & 0xff;
 652:	8b 55 0c             	mov    0xc(%ebp),%edx
 655:	8b 45 f0             	mov    -0x10(%ebp),%eax
 658:	01 d0                	add    %edx,%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	25 ff 00 00 00       	and    $0xff,%eax
 665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 668:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 66c:	75 2c                	jne    69a <printf+0x6a>
      if(c == '%'){
 66e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 672:	75 0c                	jne    680 <printf+0x50>
        state = '%';
 674:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 67b:	e9 27 01 00 00       	jmp    7a7 <printf+0x177>
      } else {
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 c7 fe ff ff       	call   559 <putc>
 692:	83 c4 10             	add    $0x10,%esp
 695:	e9 0d 01 00 00       	jmp    7a7 <printf+0x177>
      }
    } else if(state == '%'){
 69a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 69e:	0f 85 03 01 00 00    	jne    7a7 <printf+0x177>
      if(c == 'd'){
 6a4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6a8:	75 1e                	jne    6c8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	6a 01                	push   $0x1
 6b1:	6a 0a                	push   $0xa
 6b3:	50                   	push   %eax
 6b4:	ff 75 08             	pushl  0x8(%ebp)
 6b7:	e8 c0 fe ff ff       	call   57c <printint>
 6bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 6bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c3:	e9 d8 00 00 00       	jmp    7a0 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6c8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6cc:	74 06                	je     6d4 <printf+0xa4>
 6ce:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6d2:	75 1e                	jne    6f2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	6a 00                	push   $0x0
 6db:	6a 10                	push   $0x10
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 96 fe ff ff       	call   57c <printint>
 6e6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ed:	e9 ae 00 00 00       	jmp    7a0 <printf+0x170>
      } else if(c == 's'){
 6f2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6f6:	75 43                	jne    73b <printf+0x10b>
        s = (char*)*ap;
 6f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 700:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 708:	75 25                	jne    72f <printf+0xff>
          s = "(null)";
 70a:	c7 45 f4 1e 0a 00 00 	movl   $0xa1e,-0xc(%ebp)
        while(*s != 0){
 711:	eb 1c                	jmp    72f <printf+0xff>
          putc(fd, *s);
 713:	8b 45 f4             	mov    -0xc(%ebp),%eax
 716:	0f b6 00             	movzbl (%eax),%eax
 719:	0f be c0             	movsbl %al,%eax
 71c:	83 ec 08             	sub    $0x8,%esp
 71f:	50                   	push   %eax
 720:	ff 75 08             	pushl  0x8(%ebp)
 723:	e8 31 fe ff ff       	call   559 <putc>
 728:	83 c4 10             	add    $0x10,%esp
          s++;
 72b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	0f b6 00             	movzbl (%eax),%eax
 735:	84 c0                	test   %al,%al
 737:	75 da                	jne    713 <printf+0xe3>
 739:	eb 65                	jmp    7a0 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 73b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 73f:	75 1d                	jne    75e <printf+0x12e>
        putc(fd, *ap);
 741:	8b 45 e8             	mov    -0x18(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	0f be c0             	movsbl %al,%eax
 749:	83 ec 08             	sub    $0x8,%esp
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 04 fe ff ff       	call   559 <putc>
 755:	83 c4 10             	add    $0x10,%esp
        ap++;
 758:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 75c:	eb 42                	jmp    7a0 <printf+0x170>
      } else if(c == '%'){
 75e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 762:	75 17                	jne    77b <printf+0x14b>
        putc(fd, c);
 764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 e3 fd ff ff       	call   559 <putc>
 776:	83 c4 10             	add    $0x10,%esp
 779:	eb 25                	jmp    7a0 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 77b:	83 ec 08             	sub    $0x8,%esp
 77e:	6a 25                	push   $0x25
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 d1 fd ff ff       	call   559 <putc>
 788:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 78b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78e:	0f be c0             	movsbl %al,%eax
 791:	83 ec 08             	sub    $0x8,%esp
 794:	50                   	push   %eax
 795:	ff 75 08             	pushl  0x8(%ebp)
 798:	e8 bc fd ff ff       	call   559 <putc>
 79d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7ab:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	01 d0                	add    %edx,%eax
 7b3:	0f b6 00             	movzbl (%eax),%eax
 7b6:	84 c0                	test   %al,%al
 7b8:	0f 85 94 fe ff ff    	jne    652 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7be:	90                   	nop
 7bf:	c9                   	leave  
 7c0:	c3                   	ret    

000007c1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c1:	55                   	push   %ebp
 7c2:	89 e5                	mov    %esp,%ebp
 7c4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	83 e8 08             	sub    $0x8,%eax
 7cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 7d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d8:	eb 24                	jmp    7fe <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e2:	77 12                	ja     7f6 <free+0x35>
 7e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ea:	77 24                	ja     810 <free+0x4f>
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f4:	77 1a                	ja     810 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 00                	mov    (%eax),%eax
 7fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 804:	76 d4                	jbe    7da <free+0x19>
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 00                	mov    (%eax),%eax
 80b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80e:	76 ca                	jbe    7da <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 810:	8b 45 f8             	mov    -0x8(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	01 c2                	add    %eax,%edx
 822:	8b 45 fc             	mov    -0x4(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	39 c2                	cmp    %eax,%edx
 829:	75 24                	jne    84f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	8b 50 04             	mov    0x4(%eax),%edx
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	01 c2                	add    %eax,%edx
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84b:	89 10                	mov    %edx,(%eax)
 84d:	eb 0a                	jmp    859 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	8b 10                	mov    (%eax),%edx
 854:	8b 45 f8             	mov    -0x8(%ebp),%eax
 857:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	01 d0                	add    %edx,%eax
 86b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86e:	75 20                	jne    890 <free+0xcf>
    p->s.size += bp->s.size;
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 50 04             	mov    0x4(%eax),%edx
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	01 c2                	add    %eax,%edx
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 884:	8b 45 f8             	mov    -0x8(%ebp),%eax
 887:	8b 10                	mov    (%eax),%edx
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	89 10                	mov    %edx,(%eax)
 88e:	eb 08                	jmp    898 <free+0xd7>
  } else
    p->s.ptr = bp;
 890:	8b 45 fc             	mov    -0x4(%ebp),%eax
 893:	8b 55 f8             	mov    -0x8(%ebp),%edx
 896:	89 10                	mov    %edx,(%eax)
  freep = p;
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	a3 c8 0c 00 00       	mov    %eax,0xcc8
}
 8a0:	90                   	nop
 8a1:	c9                   	leave  
 8a2:	c3                   	ret    

000008a3 <morecore>:

static Header*
morecore(uint nu)
{
 8a3:	55                   	push   %ebp
 8a4:	89 e5                	mov    %esp,%ebp
 8a6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8b0:	77 07                	ja     8b9 <morecore+0x16>
    nu = 4096;
 8b2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	c1 e0 03             	shl    $0x3,%eax
 8bf:	83 ec 0c             	sub    $0xc,%esp
 8c2:	50                   	push   %eax
 8c3:	e8 19 fc ff ff       	call   4e1 <sbrk>
 8c8:	83 c4 10             	add    $0x10,%esp
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ce:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8d2:	75 07                	jne    8db <morecore+0x38>
    return 0;
 8d4:	b8 00 00 00 00       	mov    $0x0,%eax
 8d9:	eb 26                	jmp    901 <morecore+0x5e>
  hp = (Header*)p;
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	8b 55 08             	mov    0x8(%ebp),%edx
 8e7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	83 c0 08             	add    $0x8,%eax
 8f0:	83 ec 0c             	sub    $0xc,%esp
 8f3:	50                   	push   %eax
 8f4:	e8 c8 fe ff ff       	call   7c1 <free>
 8f9:	83 c4 10             	add    $0x10,%esp
  return freep;
 8fc:	a1 c8 0c 00 00       	mov    0xcc8,%eax
}
 901:	c9                   	leave  
 902:	c3                   	ret    

00000903 <malloc>:

void*
malloc(uint nbytes)
{
 903:	55                   	push   %ebp
 904:	89 e5                	mov    %esp,%ebp
 906:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 909:	8b 45 08             	mov    0x8(%ebp),%eax
 90c:	83 c0 07             	add    $0x7,%eax
 90f:	c1 e8 03             	shr    $0x3,%eax
 912:	83 c0 01             	add    $0x1,%eax
 915:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 918:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 91d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 920:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 924:	75 23                	jne    949 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 926:	c7 45 f0 c0 0c 00 00 	movl   $0xcc0,-0x10(%ebp)
 92d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 930:	a3 c8 0c 00 00       	mov    %eax,0xcc8
 935:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 93a:	a3 c0 0c 00 00       	mov    %eax,0xcc0
    base.s.size = 0;
 93f:	c7 05 c4 0c 00 00 00 	movl   $0x0,0xcc4
 946:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 949:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94c:	8b 00                	mov    (%eax),%eax
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 95a:	72 4d                	jb     9a9 <malloc+0xa6>
      if(p->s.size == nunits)
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 965:	75 0c                	jne    973 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	8b 10                	mov    (%eax),%edx
 96c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96f:	89 10                	mov    %edx,(%eax)
 971:	eb 26                	jmp    999 <malloc+0x96>
      else {
        p->s.size -= nunits;
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	8b 40 04             	mov    0x4(%eax),%eax
 979:	2b 45 ec             	sub    -0x14(%ebp),%eax
 97c:	89 c2                	mov    %eax,%edx
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	c1 e0 03             	shl    $0x3,%eax
 98d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	8b 55 ec             	mov    -0x14(%ebp),%edx
 996:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 999:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99c:	a3 c8 0c 00 00       	mov    %eax,0xcc8
      return (void*)(p + 1);
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	83 c0 08             	add    $0x8,%eax
 9a7:	eb 3b                	jmp    9e4 <malloc+0xe1>
    }
    if(p == freep)
 9a9:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 9ae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9b1:	75 1e                	jne    9d1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9b3:	83 ec 0c             	sub    $0xc,%esp
 9b6:	ff 75 ec             	pushl  -0x14(%ebp)
 9b9:	e8 e5 fe ff ff       	call   8a3 <morecore>
 9be:	83 c4 10             	add    $0x10,%esp
 9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c8:	75 07                	jne    9d1 <malloc+0xce>
        return 0;
 9ca:	b8 00 00 00 00       	mov    $0x0,%eax
 9cf:	eb 13                	jmp    9e4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	8b 00                	mov    (%eax),%eax
 9dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9df:	e9 6d ff ff ff       	jmp    951 <malloc+0x4e>
}
 9e4:	c9                   	leave  
 9e5:	c3                   	ret    
