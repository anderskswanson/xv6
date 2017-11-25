
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <print_mode>:
#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat* st)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	0f b7 00             	movzwl (%eax),%eax
   c:	98                   	cwtl   
   d:	83 f8 02             	cmp    $0x2,%eax
  10:	74 1e                	je     30 <print_mode+0x30>
  12:	83 f8 03             	cmp    $0x3,%eax
  15:	74 2d                	je     44 <print_mode+0x44>
  17:	83 f8 01             	cmp    $0x1,%eax
  1a:	75 3c                	jne    58 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 4c 0e 00 00       	push   $0xe4c
  24:	6a 01                	push   $0x1
  26:	e8 6a 0a 00 00       	call   a95 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb 3a                	jmp    6a <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 4e 0e 00 00       	push   $0xe4e
  38:	6a 01                	push   $0x1
  3a:	e8 56 0a 00 00       	call   a95 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb 26                	jmp    6a <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 50 0e 00 00       	push   $0xe50
  4c:	6a 01                	push   $0x1
  4e:	e8 42 0a 00 00       	call   a95 <printf>
  53:	83 c4 10             	add    $0x10,%esp
  56:	eb 12                	jmp    6a <print_mode+0x6a>
    default: printf(1, "?");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 52 0e 00 00       	push   $0xe52
  60:	6a 01                	push   $0x1
  62:	e8 2e 0a 00 00       	call   a95 <printf>
  67:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  71:	83 e0 01             	and    $0x1,%eax
  74:	84 c0                	test   %al,%al
  76:	74 14                	je     8c <print_mode+0x8c>
    printf(1, "r");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 54 0e 00 00       	push   $0xe54
  80:	6a 01                	push   $0x1
  82:	e8 0e 0a 00 00       	call   a95 <printf>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <print_mode+0x9e>
  else
    printf(1, "-");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 4e 0e 00 00       	push   $0xe4e
  94:	6a 01                	push   $0x1
  96:	e8 fa 09 00 00       	call   a95 <printf>
  9b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  a5:	83 e0 80             	and    $0xffffff80,%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 14                	je     c0 <print_mode+0xc0>
    printf(1, "w");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 56 0e 00 00       	push   $0xe56
  b4:	6a 01                	push   $0x1
  b6:	e8 da 09 00 00       	call   a95 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 12                	jmp    d2 <print_mode+0xd2>
  else
    printf(1, "-");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 4e 0e 00 00       	push   $0xe4e
  c8:	6a 01                	push   $0x1
  ca:	e8 c6 09 00 00       	call   a95 <printf>
  cf:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  d9:	c0 e8 06             	shr    $0x6,%al
  dc:	83 e0 01             	and    $0x1,%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  e9:	d0 e8                	shr    %al
  eb:	83 e0 01             	and    $0x1,%eax
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	21 d0                	and    %edx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	74 14                	je     10b <print_mode+0x10b>
    printf(1, "S");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 58 0e 00 00       	push   $0xe58
  ff:	6a 01                	push   $0x1
 101:	e8 8f 09 00 00       	call   a95 <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 34                	jmp    13f <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 112:	83 e0 40             	and    $0x40,%eax
 115:	84 c0                	test   %al,%al
 117:	74 14                	je     12d <print_mode+0x12d>
    printf(1, "x");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 5a 0e 00 00       	push   $0xe5a
 121:	6a 01                	push   $0x1
 123:	e8 6d 09 00 00       	call   a95 <printf>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	eb 12                	jmp    13f <print_mode+0x13f>
  else
    printf(1, "-");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 4e 0e 00 00       	push   $0xe4e
 135:	6a 01                	push   $0x1
 137:	e8 59 09 00 00       	call   a95 <printf>
 13c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 146:	83 e0 20             	and    $0x20,%eax
 149:	84 c0                	test   %al,%al
 14b:	74 14                	je     161 <print_mode+0x161>
    printf(1, "r");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 54 0e 00 00       	push   $0xe54
 155:	6a 01                	push   $0x1
 157:	e8 39 09 00 00       	call   a95 <printf>
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	eb 12                	jmp    173 <print_mode+0x173>
  else
    printf(1, "-");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 4e 0e 00 00       	push   $0xe4e
 169:	6a 01                	push   $0x1
 16b:	e8 25 09 00 00       	call   a95 <printf>
 170:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 17a:	83 e0 10             	and    $0x10,%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 14                	je     195 <print_mode+0x195>
    printf(1, "w");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 56 0e 00 00       	push   $0xe56
 189:	6a 01                	push   $0x1
 18b:	e8 05 09 00 00       	call   a95 <printf>
 190:	83 c4 10             	add    $0x10,%esp
 193:	eb 12                	jmp    1a7 <print_mode+0x1a7>
  else
    printf(1, "-");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 4e 0e 00 00       	push   $0xe4e
 19d:	6a 01                	push   $0x1
 19f:	e8 f1 08 00 00       	call   a95 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ae:	83 e0 08             	and    $0x8,%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 14                	je     1c9 <print_mode+0x1c9>
    printf(1, "x");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 5a 0e 00 00       	push   $0xe5a
 1bd:	6a 01                	push   $0x1
 1bf:	e8 d1 08 00 00       	call   a95 <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 12                	jmp    1db <print_mode+0x1db>
  else
    printf(1, "-");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 4e 0e 00 00       	push   $0xe4e
 1d1:	6a 01                	push   $0x1
 1d3:	e8 bd 08 00 00       	call   a95 <printf>
 1d8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1e2:	83 e0 04             	and    $0x4,%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	74 14                	je     1fd <print_mode+0x1fd>
    printf(1, "r");
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 54 0e 00 00       	push   $0xe54
 1f1:	6a 01                	push   $0x1
 1f3:	e8 9d 08 00 00       	call   a95 <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	eb 12                	jmp    20f <print_mode+0x20f>
  else
    printf(1, "-");
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	68 4e 0e 00 00       	push   $0xe4e
 205:	6a 01                	push   $0x1
 207:	e8 89 08 00 00       	call   a95 <printf>
 20c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 216:	83 e0 02             	and    $0x2,%eax
 219:	84 c0                	test   %al,%al
 21b:	74 14                	je     231 <print_mode+0x231>
    printf(1, "w");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 56 0e 00 00       	push   $0xe56
 225:	6a 01                	push   $0x1
 227:	e8 69 08 00 00       	call   a95 <printf>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	eb 12                	jmp    243 <print_mode+0x243>
  else
    printf(1, "-");
 231:	83 ec 08             	sub    $0x8,%esp
 234:	68 4e 0e 00 00       	push   $0xe4e
 239:	6a 01                	push   $0x1
 23b:	e8 55 08 00 00       	call   a95 <printf>
 240:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 24a:	83 e0 01             	and    $0x1,%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 14                	je     265 <print_mode+0x265>
    printf(1, "x");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 5a 0e 00 00       	push   $0xe5a
 259:	6a 01                	push   $0x1
 25b:	e8 35 08 00 00       	call   a95 <printf>
 260:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 263:	eb 13                	jmp    278 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 265:	83 ec 08             	sub    $0x8,%esp
 268:	68 4e 0e 00 00       	push   $0xe4e
 26d:	6a 01                	push   $0x1
 26f:	e8 21 08 00 00       	call   a95 <printf>
 274:	83 c4 10             	add    $0x10,%esp

  return;
 277:	90                   	nop
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <fmtname>:
#include "fs.h"
#include "print_mode.c"

char*
fmtname(char *path)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	53                   	push   %ebx
 27e:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 2b 04 00 00       	call   6b7 <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
 299:	eb 04                	jmp    29f <fmtname+0x25>
 29b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a2:	3b 45 08             	cmp    0x8(%ebp),%eax
 2a5:	72 0a                	jb     2b1 <fmtname+0x37>
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	75 ea                	jne    29b <fmtname+0x21>
    ;
  p++;
 2b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 f7 03 00 00       	call   6b7 <strlen>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	83 f8 0d             	cmp    $0xd,%eax
 2c6:	76 05                	jbe    2cd <fmtname+0x53>
    return p;
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	eb 60                	jmp    32d <fmtname+0xb3>
  memmove(buf, p, strlen(p));
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 df 03 00 00       	call   6b7 <strlen>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	50                   	push   %eax
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	68 a8 11 00 00       	push   $0x11a8
 2e7:	e8 8d 05 00 00       	call   879 <memmove>
 2ec:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 2ef:	83 ec 0c             	sub    $0xc,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	e8 bd 03 00 00       	call   6b7 <strlen>
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	ba 0e 00 00 00       	mov    $0xe,%edx
 302:	89 d3                	mov    %edx,%ebx
 304:	29 c3                	sub    %eax,%ebx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	ff 75 f4             	pushl  -0xc(%ebp)
 30c:	e8 a6 03 00 00       	call   6b7 <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	05 a8 11 00 00       	add    $0x11a8,%eax
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	53                   	push   %ebx
 31d:	6a 20                	push   $0x20
 31f:	50                   	push   %eax
 320:	e8 b9 03 00 00       	call   6de <memset>
 325:	83 c4 10             	add    $0x10,%esp
  return buf;
 328:	b8 a8 11 00 00       	mov    $0x11a8,%eax
}
 32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <ls>:

void
ls(char *path)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	57                   	push   %edi
 336:	56                   	push   %esi
 337:	53                   	push   %ebx
 338:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	6a 00                	push   $0x0
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 b3 05 00 00       	call   8fe <open>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 351:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 355:	79 1a                	jns    371 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	68 5c 0e 00 00       	push   $0xe5c
 362:	6a 02                	push   $0x2
 364:	e8 2c 07 00 00       	call   a95 <printf>
 369:	83 c4 10             	add    $0x10,%esp
    return;
 36c:	e9 33 02 00 00       	jmp    5a4 <ls+0x272>
  }
  
  if(fstat(fd, &st) < 0){
 371:	83 ec 08             	sub    $0x8,%esp
 374:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 37a:	50                   	push   %eax
 37b:	ff 75 e4             	pushl  -0x1c(%ebp)
 37e:	e8 93 05 00 00       	call   916 <fstat>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	79 28                	jns    3b2 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	ff 75 08             	pushl  0x8(%ebp)
 390:	68 70 0e 00 00       	push   $0xe70
 395:	6a 02                	push   $0x2
 397:	e8 f9 06 00 00       	call   a95 <printf>
 39c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 39f:	83 ec 0c             	sub    $0xc,%esp
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	e8 3c 05 00 00       	call   8e6 <close>
 3aa:	83 c4 10             	add    $0x10,%esp
    return;
 3ad:	e9 f2 01 00 00       	jmp    5a4 <ls+0x272>
  }
  

  switch(st.type){
 3b2:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 3b9:	98                   	cwtl   
 3ba:	83 f8 01             	cmp    $0x1,%eax
 3bd:	74 70                	je     42f <ls+0xfd>
 3bf:	83 f8 02             	cmp    $0x2,%eax
 3c2:	0f 85 ce 01 00 00    	jne    596 <ls+0x264>
  case T_FILE:
#ifdef CS333_P5
    print_mode(&st);
 3c8:	83 ec 0c             	sub    $0xc,%esp
 3cb:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 3d1:	50                   	push   %eax
 3d2:	e8 29 fc ff ff       	call   0 <print_mode>
 3d7:	83 c4 10             	add    $0x10,%esp
    printf(1, " %s\t%d\t%d\t%d\t%d\n", fmtname(path), st.uid, st.gid, st.ino, st.size);
 3da:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 3e0:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 3e6:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 3ec:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 3f3:	0f b7 f0             	movzwl %ax,%esi
 3f6:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 3fd:	0f b7 d8             	movzwl %ax,%ebx
 400:	83 ec 0c             	sub    $0xc,%esp
 403:	ff 75 08             	pushl  0x8(%ebp)
 406:	e8 6f fe ff ff       	call   27a <fmtname>
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	83 ec 04             	sub    $0x4,%esp
 411:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 417:	57                   	push   %edi
 418:	56                   	push   %esi
 419:	53                   	push   %ebx
 41a:	50                   	push   %eax
 41b:	68 84 0e 00 00       	push   $0xe84
 420:	6a 01                	push   $0x1
 422:	e8 6e 06 00 00       	call   a95 <printf>
 427:	83 c4 20             	add    $0x20,%esp
#else
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
#endif
    break;
 42a:	e9 67 01 00 00       	jmp    596 <ls+0x264>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	ff 75 08             	pushl  0x8(%ebp)
 435:	e8 7d 02 00 00       	call   6b7 <strlen>
 43a:	83 c4 10             	add    $0x10,%esp
 43d:	83 c0 10             	add    $0x10,%eax
 440:	3d 00 02 00 00       	cmp    $0x200,%eax
 445:	76 17                	jbe    45e <ls+0x12c>
      printf(1, "ls: path too long\n");
 447:	83 ec 08             	sub    $0x8,%esp
 44a:	68 95 0e 00 00       	push   $0xe95
 44f:	6a 01                	push   $0x1
 451:	e8 3f 06 00 00       	call   a95 <printf>
 456:	83 c4 10             	add    $0x10,%esp
      break;
 459:	e9 38 01 00 00       	jmp    596 <ls+0x264>
    }
    strcpy(buf, path);
 45e:	83 ec 08             	sub    $0x8,%esp
 461:	ff 75 08             	pushl  0x8(%ebp)
 464:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 46a:	50                   	push   %eax
 46b:	e8 d8 01 00 00       	call   648 <strcpy>
 470:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 473:	83 ec 0c             	sub    $0xc,%esp
 476:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 47c:	50                   	push   %eax
 47d:	e8 35 02 00 00       	call   6b7 <strlen>
 482:	83 c4 10             	add    $0x10,%esp
 485:	89 c2                	mov    %eax,%edx
 487:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 48d:	01 d0                	add    %edx,%eax
 48f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 492:	8b 45 e0             	mov    -0x20(%ebp),%eax
 495:	8d 50 01             	lea    0x1(%eax),%edx
 498:	89 55 e0             	mov    %edx,-0x20(%ebp)
 49b:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 49e:	e9 d2 00 00 00       	jmp    575 <ls+0x243>
      if(de.inum == 0)
 4a3:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 4aa:	66 85 c0             	test   %ax,%ax
 4ad:	75 05                	jne    4b4 <ls+0x182>
        continue;
 4af:	e9 c1 00 00 00       	jmp    575 <ls+0x243>
      memmove(p, de.name, DIRSIZ);
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	6a 0e                	push   $0xe
 4b9:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 4bf:	83 c0 02             	add    $0x2,%eax
 4c2:	50                   	push   %eax
 4c3:	ff 75 e0             	pushl  -0x20(%ebp)
 4c6:	e8 ae 03 00 00       	call   879 <memmove>
 4cb:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 4ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4d1:	83 c0 0e             	add    $0xe,%eax
 4d4:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4e7:	50                   	push   %eax
 4e8:	e8 ad 02 00 00       	call   79a <stat>
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	85 c0                	test   %eax,%eax
 4f2:	79 1b                	jns    50f <ls+0x1dd>
        printf(1, "ls: cannot stat %s\n", buf);
 4f4:	83 ec 04             	sub    $0x4,%esp
 4f7:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4fd:	50                   	push   %eax
 4fe:	68 70 0e 00 00       	push   $0xe70
 503:	6a 01                	push   $0x1
 505:	e8 8b 05 00 00       	call   a95 <printf>
 50a:	83 c4 10             	add    $0x10,%esp
        continue;
 50d:	eb 66                	jmp    575 <ls+0x243>
      }
#ifdef CS333_P5
      print_mode(&st);
 50f:	83 ec 0c             	sub    $0xc,%esp
 512:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 518:	50                   	push   %eax
 519:	e8 e2 fa ff ff       	call   0 <print_mode>
 51e:	83 c4 10             	add    $0x10,%esp
      printf(1, " %s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
 521:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 527:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 52d:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 533:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 53a:	0f b7 f0             	movzwl %ax,%esi
 53d:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 544:	0f b7 d8             	movzwl %ax,%ebx
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 550:	50                   	push   %eax
 551:	e8 24 fd ff ff       	call   27a <fmtname>
 556:	83 c4 10             	add    $0x10,%esp
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 562:	57                   	push   %edi
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	50                   	push   %eax
 566:	68 84 0e 00 00       	push   $0xe84
 56b:	6a 01                	push   $0x1
 56d:	e8 23 05 00 00       	call   a95 <printf>
 572:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 575:	83 ec 04             	sub    $0x4,%esp
 578:	6a 10                	push   $0x10
 57a:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 580:	50                   	push   %eax
 581:	ff 75 e4             	pushl  -0x1c(%ebp)
 584:	e8 4d 03 00 00       	call   8d6 <read>
 589:	83 c4 10             	add    $0x10,%esp
 58c:	83 f8 10             	cmp    $0x10,%eax
 58f:	0f 84 0e ff ff ff    	je     4a3 <ls+0x171>
      printf(1, " %s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
#else      
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
#endif
    }
    break;
 595:	90                   	nop
  }
  close(fd);
 596:	83 ec 0c             	sub    $0xc,%esp
 599:	ff 75 e4             	pushl  -0x1c(%ebp)
 59c:	e8 45 03 00 00       	call   8e6 <close>
 5a1:	83 c4 10             	add    $0x10,%esp
}
 5a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a7:	5b                   	pop    %ebx
 5a8:	5e                   	pop    %esi
 5a9:	5f                   	pop    %edi
 5aa:	5d                   	pop    %ebp
 5ab:	c3                   	ret    

000005ac <main>:

int
main(int argc, char *argv[])
{
 5ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 5b0:	83 e4 f0             	and    $0xfffffff0,%esp
 5b3:	ff 71 fc             	pushl  -0x4(%ecx)
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	53                   	push   %ebx
 5ba:	51                   	push   %ecx
 5bb:	83 ec 10             	sub    $0x10,%esp
 5be:	89 cb                	mov    %ecx,%ebx
#ifdef CS333_P5
    printf(1,"mode\t\tname\t\tuid\tgid\tinode\tsize\n");
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	68 a8 0e 00 00       	push   $0xea8
 5c8:	6a 01                	push   $0x1
 5ca:	e8 c6 04 00 00       	call   a95 <printf>
 5cf:	83 c4 10             	add    $0x10,%esp
#endif
  int i;

  if(argc < 2){
 5d2:	83 3b 01             	cmpl   $0x1,(%ebx)
 5d5:	7f 15                	jg     5ec <main+0x40>
    ls(".");
 5d7:	83 ec 0c             	sub    $0xc,%esp
 5da:	68 c8 0e 00 00       	push   $0xec8
 5df:	e8 4e fd ff ff       	call   332 <ls>
 5e4:	83 c4 10             	add    $0x10,%esp
    exit();
 5e7:	e8 d2 02 00 00       	call   8be <exit>
  }
  for(i=1; i<argc; i++)
 5ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 5f3:	eb 21                	jmp    616 <main+0x6a>
    ls(argv[i]);
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 5ff:	8b 43 04             	mov    0x4(%ebx),%eax
 602:	01 d0                	add    %edx,%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	83 ec 0c             	sub    $0xc,%esp
 609:	50                   	push   %eax
 60a:	e8 23 fd ff ff       	call   332 <ls>
 60f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 616:	8b 45 f4             	mov    -0xc(%ebp),%eax
 619:	3b 03                	cmp    (%ebx),%eax
 61b:	7c d8                	jl     5f5 <main+0x49>
    ls(argv[i]);
  exit();
 61d:	e8 9c 02 00 00       	call   8be <exit>

00000622 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 622:	55                   	push   %ebp
 623:	89 e5                	mov    %esp,%ebp
 625:	57                   	push   %edi
 626:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 627:	8b 4d 08             	mov    0x8(%ebp),%ecx
 62a:	8b 55 10             	mov    0x10(%ebp),%edx
 62d:	8b 45 0c             	mov    0xc(%ebp),%eax
 630:	89 cb                	mov    %ecx,%ebx
 632:	89 df                	mov    %ebx,%edi
 634:	89 d1                	mov    %edx,%ecx
 636:	fc                   	cld    
 637:	f3 aa                	rep stos %al,%es:(%edi)
 639:	89 ca                	mov    %ecx,%edx
 63b:	89 fb                	mov    %edi,%ebx
 63d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 640:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 643:	90                   	nop
 644:	5b                   	pop    %ebx
 645:	5f                   	pop    %edi
 646:	5d                   	pop    %ebp
 647:	c3                   	ret    

00000648 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 654:	90                   	nop
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	8d 50 01             	lea    0x1(%eax),%edx
 65b:	89 55 08             	mov    %edx,0x8(%ebp)
 65e:	8b 55 0c             	mov    0xc(%ebp),%edx
 661:	8d 4a 01             	lea    0x1(%edx),%ecx
 664:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 667:	0f b6 12             	movzbl (%edx),%edx
 66a:	88 10                	mov    %dl,(%eax)
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	75 e2                	jne    655 <strcpy+0xd>
    ;
  return os;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 676:	c9                   	leave  
 677:	c3                   	ret    

00000678 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 67b:	eb 08                	jmp    685 <strcmp+0xd>
    p++, q++;
 67d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 681:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	84 c0                	test   %al,%al
 68d:	74 10                	je     69f <strcmp+0x27>
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	0f b6 10             	movzbl (%eax),%edx
 695:	8b 45 0c             	mov    0xc(%ebp),%eax
 698:	0f b6 00             	movzbl (%eax),%eax
 69b:	38 c2                	cmp    %al,%dl
 69d:	74 de                	je     67d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f b6 d0             	movzbl %al,%edx
 6a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f b6 c0             	movzbl %al,%eax
 6b1:	29 c2                	sub    %eax,%edx
 6b3:	89 d0                	mov    %edx,%eax
}
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    

000006b7 <strlen>:

uint
strlen(char *s)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6c4:	eb 04                	jmp    6ca <strlen+0x13>
 6c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	84 c0                	test   %al,%al
 6d7:	75 ed                	jne    6c6 <strlen+0xf>
    ;
  return n;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6dc:	c9                   	leave  
 6dd:	c3                   	ret    

000006de <memset>:

void*
memset(void *dst, int c, uint n)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6e1:	8b 45 10             	mov    0x10(%ebp),%eax
 6e4:	50                   	push   %eax
 6e5:	ff 75 0c             	pushl  0xc(%ebp)
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 32 ff ff ff       	call   622 <stosb>
 6f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6f6:	c9                   	leave  
 6f7:	c3                   	ret    

000006f8 <strchr>:

char*
strchr(const char *s, char c)
{
 6f8:	55                   	push   %ebp
 6f9:	89 e5                	mov    %esp,%ebp
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 701:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 704:	eb 14                	jmp    71a <strchr+0x22>
    if(*s == c)
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 70f:	75 05                	jne    716 <strchr+0x1e>
      return (char*)s;
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	eb 13                	jmp    729 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 716:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	0f b6 00             	movzbl (%eax),%eax
 720:	84 c0                	test   %al,%al
 722:	75 e2                	jne    706 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 724:	b8 00 00 00 00       	mov    $0x0,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <gets>:

char*
gets(char *buf, int max)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 738:	eb 42                	jmp    77c <gets+0x51>
    cc = read(0, &c, 1);
 73a:	83 ec 04             	sub    $0x4,%esp
 73d:	6a 01                	push   $0x1
 73f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 742:	50                   	push   %eax
 743:	6a 00                	push   $0x0
 745:	e8 8c 01 00 00       	call   8d6 <read>
 74a:	83 c4 10             	add    $0x10,%esp
 74d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 750:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 754:	7e 33                	jle    789 <gets+0x5e>
      break;
    buf[i++] = c;
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	8d 50 01             	lea    0x1(%eax),%edx
 75c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75f:	89 c2                	mov    %eax,%edx
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	01 c2                	add    %eax,%edx
 766:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 76a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 76c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 770:	3c 0a                	cmp    $0xa,%al
 772:	74 16                	je     78a <gets+0x5f>
 774:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 778:	3c 0d                	cmp    $0xd,%al
 77a:	74 0e                	je     78a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	83 c0 01             	add    $0x1,%eax
 782:	3b 45 0c             	cmp    0xc(%ebp),%eax
 785:	7c b3                	jl     73a <gets+0xf>
 787:	eb 01                	jmp    78a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 789:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 78a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	01 d0                	add    %edx,%eax
 792:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
}
 798:	c9                   	leave  
 799:	c3                   	ret    

0000079a <stat>:

int
stat(char *n, struct stat *st)
{
 79a:	55                   	push   %ebp
 79b:	89 e5                	mov    %esp,%ebp
 79d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7a0:	83 ec 08             	sub    $0x8,%esp
 7a3:	6a 00                	push   $0x0
 7a5:	ff 75 08             	pushl  0x8(%ebp)
 7a8:	e8 51 01 00 00       	call   8fe <open>
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b7:	79 07                	jns    7c0 <stat+0x26>
    return -1;
 7b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7be:	eb 25                	jmp    7e5 <stat+0x4b>
  r = fstat(fd, st);
 7c0:	83 ec 08             	sub    $0x8,%esp
 7c3:	ff 75 0c             	pushl  0xc(%ebp)
 7c6:	ff 75 f4             	pushl  -0xc(%ebp)
 7c9:	e8 48 01 00 00       	call   916 <fstat>
 7ce:	83 c4 10             	add    $0x10,%esp
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7d4:	83 ec 0c             	sub    $0xc,%esp
 7d7:	ff 75 f4             	pushl  -0xc(%ebp)
 7da:	e8 07 01 00 00       	call   8e6 <close>
 7df:	83 c4 10             	add    $0x10,%esp
  return r;
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <atoi>:

int
atoi(const char *s)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 7ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 7f4:	eb 04                	jmp    7fa <atoi+0x13>
 7f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	0f b6 00             	movzbl (%eax),%eax
 800:	3c 20                	cmp    $0x20,%al
 802:	74 f2                	je     7f6 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	0f b6 00             	movzbl (%eax),%eax
 80a:	3c 2d                	cmp    $0x2d,%al
 80c:	75 07                	jne    815 <atoi+0x2e>
 80e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 813:	eb 05                	jmp    81a <atoi+0x33>
 815:	b8 01 00 00 00       	mov    $0x1,%eax
 81a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	0f b6 00             	movzbl (%eax),%eax
 823:	3c 2b                	cmp    $0x2b,%al
 825:	74 0a                	je     831 <atoi+0x4a>
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	0f b6 00             	movzbl (%eax),%eax
 82d:	3c 2d                	cmp    $0x2d,%al
 82f:	75 2b                	jne    85c <atoi+0x75>
    s++;
 831:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 835:	eb 25                	jmp    85c <atoi+0x75>
    n = n*10 + *s++ - '0';
 837:	8b 55 fc             	mov    -0x4(%ebp),%edx
 83a:	89 d0                	mov    %edx,%eax
 83c:	c1 e0 02             	shl    $0x2,%eax
 83f:	01 d0                	add    %edx,%eax
 841:	01 c0                	add    %eax,%eax
 843:	89 c1                	mov    %eax,%ecx
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	8d 50 01             	lea    0x1(%eax),%edx
 84b:	89 55 08             	mov    %edx,0x8(%ebp)
 84e:	0f b6 00             	movzbl (%eax),%eax
 851:	0f be c0             	movsbl %al,%eax
 854:	01 c8                	add    %ecx,%eax
 856:	83 e8 30             	sub    $0x30,%eax
 859:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 85c:	8b 45 08             	mov    0x8(%ebp),%eax
 85f:	0f b6 00             	movzbl (%eax),%eax
 862:	3c 2f                	cmp    $0x2f,%al
 864:	7e 0a                	jle    870 <atoi+0x89>
 866:	8b 45 08             	mov    0x8(%ebp),%eax
 869:	0f b6 00             	movzbl (%eax),%eax
 86c:	3c 39                	cmp    $0x39,%al
 86e:	7e c7                	jle    837 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 879:	55                   	push   %ebp
 87a:	89 e5                	mov    %esp,%ebp
 87c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 885:	8b 45 0c             	mov    0xc(%ebp),%eax
 888:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 88b:	eb 17                	jmp    8a4 <memmove+0x2b>
    *dst++ = *src++;
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	8d 50 01             	lea    0x1(%eax),%edx
 893:	89 55 fc             	mov    %edx,-0x4(%ebp)
 896:	8b 55 f8             	mov    -0x8(%ebp),%edx
 899:	8d 4a 01             	lea    0x1(%edx),%ecx
 89c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 89f:	0f b6 12             	movzbl (%edx),%edx
 8a2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8a4:	8b 45 10             	mov    0x10(%ebp),%eax
 8a7:	8d 50 ff             	lea    -0x1(%eax),%edx
 8aa:	89 55 10             	mov    %edx,0x10(%ebp)
 8ad:	85 c0                	test   %eax,%eax
 8af:	7f dc                	jg     88d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    

000008b6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8b6:	b8 01 00 00 00       	mov    $0x1,%eax
 8bb:	cd 40                	int    $0x40
 8bd:	c3                   	ret    

000008be <exit>:
SYSCALL(exit)
 8be:	b8 02 00 00 00       	mov    $0x2,%eax
 8c3:	cd 40                	int    $0x40
 8c5:	c3                   	ret    

000008c6 <wait>:
SYSCALL(wait)
 8c6:	b8 03 00 00 00       	mov    $0x3,%eax
 8cb:	cd 40                	int    $0x40
 8cd:	c3                   	ret    

000008ce <pipe>:
SYSCALL(pipe)
 8ce:	b8 04 00 00 00       	mov    $0x4,%eax
 8d3:	cd 40                	int    $0x40
 8d5:	c3                   	ret    

000008d6 <read>:
SYSCALL(read)
 8d6:	b8 05 00 00 00       	mov    $0x5,%eax
 8db:	cd 40                	int    $0x40
 8dd:	c3                   	ret    

000008de <write>:
SYSCALL(write)
 8de:	b8 10 00 00 00       	mov    $0x10,%eax
 8e3:	cd 40                	int    $0x40
 8e5:	c3                   	ret    

000008e6 <close>:
SYSCALL(close)
 8e6:	b8 15 00 00 00       	mov    $0x15,%eax
 8eb:	cd 40                	int    $0x40
 8ed:	c3                   	ret    

000008ee <kill>:
SYSCALL(kill)
 8ee:	b8 06 00 00 00       	mov    $0x6,%eax
 8f3:	cd 40                	int    $0x40
 8f5:	c3                   	ret    

000008f6 <exec>:
SYSCALL(exec)
 8f6:	b8 07 00 00 00       	mov    $0x7,%eax
 8fb:	cd 40                	int    $0x40
 8fd:	c3                   	ret    

000008fe <open>:
SYSCALL(open)
 8fe:	b8 0f 00 00 00       	mov    $0xf,%eax
 903:	cd 40                	int    $0x40
 905:	c3                   	ret    

00000906 <mknod>:
SYSCALL(mknod)
 906:	b8 11 00 00 00       	mov    $0x11,%eax
 90b:	cd 40                	int    $0x40
 90d:	c3                   	ret    

0000090e <unlink>:
SYSCALL(unlink)
 90e:	b8 12 00 00 00       	mov    $0x12,%eax
 913:	cd 40                	int    $0x40
 915:	c3                   	ret    

00000916 <fstat>:
SYSCALL(fstat)
 916:	b8 08 00 00 00       	mov    $0x8,%eax
 91b:	cd 40                	int    $0x40
 91d:	c3                   	ret    

0000091e <link>:
SYSCALL(link)
 91e:	b8 13 00 00 00       	mov    $0x13,%eax
 923:	cd 40                	int    $0x40
 925:	c3                   	ret    

00000926 <mkdir>:
SYSCALL(mkdir)
 926:	b8 14 00 00 00       	mov    $0x14,%eax
 92b:	cd 40                	int    $0x40
 92d:	c3                   	ret    

0000092e <chdir>:
SYSCALL(chdir)
 92e:	b8 09 00 00 00       	mov    $0x9,%eax
 933:	cd 40                	int    $0x40
 935:	c3                   	ret    

00000936 <dup>:
SYSCALL(dup)
 936:	b8 0a 00 00 00       	mov    $0xa,%eax
 93b:	cd 40                	int    $0x40
 93d:	c3                   	ret    

0000093e <getpid>:
SYSCALL(getpid)
 93e:	b8 0b 00 00 00       	mov    $0xb,%eax
 943:	cd 40                	int    $0x40
 945:	c3                   	ret    

00000946 <sbrk>:
SYSCALL(sbrk)
 946:	b8 0c 00 00 00       	mov    $0xc,%eax
 94b:	cd 40                	int    $0x40
 94d:	c3                   	ret    

0000094e <sleep>:
SYSCALL(sleep)
 94e:	b8 0d 00 00 00       	mov    $0xd,%eax
 953:	cd 40                	int    $0x40
 955:	c3                   	ret    

00000956 <uptime>:
SYSCALL(uptime)
 956:	b8 0e 00 00 00       	mov    $0xe,%eax
 95b:	cd 40                	int    $0x40
 95d:	c3                   	ret    

0000095e <halt>:
SYSCALL(halt)
 95e:	b8 16 00 00 00       	mov    $0x16,%eax
 963:	cd 40                	int    $0x40
 965:	c3                   	ret    

00000966 <date>:
SYSCALL(date)
 966:	b8 17 00 00 00       	mov    $0x17,%eax
 96b:	cd 40                	int    $0x40
 96d:	c3                   	ret    

0000096e <getuid>:
SYSCALL(getuid)
 96e:	b8 18 00 00 00       	mov    $0x18,%eax
 973:	cd 40                	int    $0x40
 975:	c3                   	ret    

00000976 <getgid>:
SYSCALL(getgid)
 976:	b8 19 00 00 00       	mov    $0x19,%eax
 97b:	cd 40                	int    $0x40
 97d:	c3                   	ret    

0000097e <getppid>:
SYSCALL(getppid)
 97e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 983:	cd 40                	int    $0x40
 985:	c3                   	ret    

00000986 <setuid>:
SYSCALL(setuid)
 986:	b8 1b 00 00 00       	mov    $0x1b,%eax
 98b:	cd 40                	int    $0x40
 98d:	c3                   	ret    

0000098e <setgid>:
SYSCALL(setgid)
 98e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 993:	cd 40                	int    $0x40
 995:	c3                   	ret    

00000996 <getprocs>:
SYSCALL(getprocs)
 996:	b8 1d 00 00 00       	mov    $0x1d,%eax
 99b:	cd 40                	int    $0x40
 99d:	c3                   	ret    

0000099e <setpriority>:
SYSCALL(setpriority)
 99e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 9a3:	cd 40                	int    $0x40
 9a5:	c3                   	ret    

000009a6 <chmod>:
SYSCALL(chmod)
 9a6:	b8 1f 00 00 00       	mov    $0x1f,%eax
 9ab:	cd 40                	int    $0x40
 9ad:	c3                   	ret    

000009ae <chown>:
SYSCALL(chown)
 9ae:	b8 20 00 00 00       	mov    $0x20,%eax
 9b3:	cd 40                	int    $0x40
 9b5:	c3                   	ret    

000009b6 <chgrp>:
SYSCALL(chgrp)    
 9b6:	b8 21 00 00 00       	mov    $0x21,%eax
 9bb:	cd 40                	int    $0x40
 9bd:	c3                   	ret    

000009be <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9be:	55                   	push   %ebp
 9bf:	89 e5                	mov    %esp,%ebp
 9c1:	83 ec 18             	sub    $0x18,%esp
 9c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 9c7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9ca:	83 ec 04             	sub    $0x4,%esp
 9cd:	6a 01                	push   $0x1
 9cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9d2:	50                   	push   %eax
 9d3:	ff 75 08             	pushl  0x8(%ebp)
 9d6:	e8 03 ff ff ff       	call   8de <write>
 9db:	83 c4 10             	add    $0x10,%esp
}
 9de:	90                   	nop
 9df:	c9                   	leave  
 9e0:	c3                   	ret    

000009e1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9e1:	55                   	push   %ebp
 9e2:	89 e5                	mov    %esp,%ebp
 9e4:	53                   	push   %ebx
 9e5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9ef:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9f3:	74 17                	je     a0c <printint+0x2b>
 9f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9f9:	79 11                	jns    a0c <printint+0x2b>
    neg = 1;
 9fb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a02:	8b 45 0c             	mov    0xc(%ebp),%eax
 a05:	f7 d8                	neg    %eax
 a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a0a:	eb 06                	jmp    a12 <printint+0x31>
  } else {
    x = xx;
 a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
 a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a1c:	8d 41 01             	lea    0x1(%ecx),%eax
 a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a22:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a28:	ba 00 00 00 00       	mov    $0x0,%edx
 a2d:	f7 f3                	div    %ebx
 a2f:	89 d0                	mov    %edx,%eax
 a31:	0f b6 80 94 11 00 00 	movzbl 0x1194(%eax),%eax
 a38:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a42:	ba 00 00 00 00       	mov    $0x0,%edx
 a47:	f7 f3                	div    %ebx
 a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a50:	75 c7                	jne    a19 <printint+0x38>
  if(neg)
 a52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a56:	74 2d                	je     a85 <printint+0xa4>
    buf[i++] = '-';
 a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5b:	8d 50 01             	lea    0x1(%eax),%edx
 a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a61:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a66:	eb 1d                	jmp    a85 <printint+0xa4>
    putc(fd, buf[i]);
 a68:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	01 d0                	add    %edx,%eax
 a70:	0f b6 00             	movzbl (%eax),%eax
 a73:	0f be c0             	movsbl %al,%eax
 a76:	83 ec 08             	sub    $0x8,%esp
 a79:	50                   	push   %eax
 a7a:	ff 75 08             	pushl  0x8(%ebp)
 a7d:	e8 3c ff ff ff       	call   9be <putc>
 a82:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a85:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a8d:	79 d9                	jns    a68 <printint+0x87>
    putc(fd, buf[i]);
}
 a8f:	90                   	nop
 a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a93:	c9                   	leave  
 a94:	c3                   	ret    

00000a95 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a95:	55                   	push   %ebp
 a96:	89 e5                	mov    %esp,%ebp
 a98:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 aa2:	8d 45 0c             	lea    0xc(%ebp),%eax
 aa5:	83 c0 04             	add    $0x4,%eax
 aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 ab2:	e9 59 01 00 00       	jmp    c10 <printf+0x17b>
    c = fmt[i] & 0xff;
 ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
 aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abd:	01 d0                	add    %edx,%eax
 abf:	0f b6 00             	movzbl (%eax),%eax
 ac2:	0f be c0             	movsbl %al,%eax
 ac5:	25 ff 00 00 00       	and    $0xff,%eax
 aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 acd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad1:	75 2c                	jne    aff <printf+0x6a>
      if(c == '%'){
 ad3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ad7:	75 0c                	jne    ae5 <printf+0x50>
        state = '%';
 ad9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ae0:	e9 27 01 00 00       	jmp    c0c <printf+0x177>
      } else {
        putc(fd, c);
 ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ae8:	0f be c0             	movsbl %al,%eax
 aeb:	83 ec 08             	sub    $0x8,%esp
 aee:	50                   	push   %eax
 aef:	ff 75 08             	pushl  0x8(%ebp)
 af2:	e8 c7 fe ff ff       	call   9be <putc>
 af7:	83 c4 10             	add    $0x10,%esp
 afa:	e9 0d 01 00 00       	jmp    c0c <printf+0x177>
      }
    } else if(state == '%'){
 aff:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b03:	0f 85 03 01 00 00    	jne    c0c <printf+0x177>
      if(c == 'd'){
 b09:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b0d:	75 1e                	jne    b2d <printf+0x98>
        printint(fd, *ap, 10, 1);
 b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b12:	8b 00                	mov    (%eax),%eax
 b14:	6a 01                	push   $0x1
 b16:	6a 0a                	push   $0xa
 b18:	50                   	push   %eax
 b19:	ff 75 08             	pushl  0x8(%ebp)
 b1c:	e8 c0 fe ff ff       	call   9e1 <printint>
 b21:	83 c4 10             	add    $0x10,%esp
        ap++;
 b24:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b28:	e9 d8 00 00 00       	jmp    c05 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 b2d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b31:	74 06                	je     b39 <printf+0xa4>
 b33:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b37:	75 1e                	jne    b57 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b3c:	8b 00                	mov    (%eax),%eax
 b3e:	6a 00                	push   $0x0
 b40:	6a 10                	push   $0x10
 b42:	50                   	push   %eax
 b43:	ff 75 08             	pushl  0x8(%ebp)
 b46:	e8 96 fe ff ff       	call   9e1 <printint>
 b4b:	83 c4 10             	add    $0x10,%esp
        ap++;
 b4e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b52:	e9 ae 00 00 00       	jmp    c05 <printf+0x170>
      } else if(c == 's'){
 b57:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b5b:	75 43                	jne    ba0 <printf+0x10b>
        s = (char*)*ap;
 b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b60:	8b 00                	mov    (%eax),%eax
 b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b65:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b6d:	75 25                	jne    b94 <printf+0xff>
          s = "(null)";
 b6f:	c7 45 f4 ca 0e 00 00 	movl   $0xeca,-0xc(%ebp)
        while(*s != 0){
 b76:	eb 1c                	jmp    b94 <printf+0xff>
          putc(fd, *s);
 b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7b:	0f b6 00             	movzbl (%eax),%eax
 b7e:	0f be c0             	movsbl %al,%eax
 b81:	83 ec 08             	sub    $0x8,%esp
 b84:	50                   	push   %eax
 b85:	ff 75 08             	pushl  0x8(%ebp)
 b88:	e8 31 fe ff ff       	call   9be <putc>
 b8d:	83 c4 10             	add    $0x10,%esp
          s++;
 b90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b97:	0f b6 00             	movzbl (%eax),%eax
 b9a:	84 c0                	test   %al,%al
 b9c:	75 da                	jne    b78 <printf+0xe3>
 b9e:	eb 65                	jmp    c05 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ba0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ba4:	75 1d                	jne    bc3 <printf+0x12e>
        putc(fd, *ap);
 ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ba9:	8b 00                	mov    (%eax),%eax
 bab:	0f be c0             	movsbl %al,%eax
 bae:	83 ec 08             	sub    $0x8,%esp
 bb1:	50                   	push   %eax
 bb2:	ff 75 08             	pushl  0x8(%ebp)
 bb5:	e8 04 fe ff ff       	call   9be <putc>
 bba:	83 c4 10             	add    $0x10,%esp
        ap++;
 bbd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bc1:	eb 42                	jmp    c05 <printf+0x170>
      } else if(c == '%'){
 bc3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bc7:	75 17                	jne    be0 <printf+0x14b>
        putc(fd, c);
 bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bcc:	0f be c0             	movsbl %al,%eax
 bcf:	83 ec 08             	sub    $0x8,%esp
 bd2:	50                   	push   %eax
 bd3:	ff 75 08             	pushl  0x8(%ebp)
 bd6:	e8 e3 fd ff ff       	call   9be <putc>
 bdb:	83 c4 10             	add    $0x10,%esp
 bde:	eb 25                	jmp    c05 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 be0:	83 ec 08             	sub    $0x8,%esp
 be3:	6a 25                	push   $0x25
 be5:	ff 75 08             	pushl  0x8(%ebp)
 be8:	e8 d1 fd ff ff       	call   9be <putc>
 bed:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bf3:	0f be c0             	movsbl %al,%eax
 bf6:	83 ec 08             	sub    $0x8,%esp
 bf9:	50                   	push   %eax
 bfa:	ff 75 08             	pushl  0x8(%ebp)
 bfd:	e8 bc fd ff ff       	call   9be <putc>
 c02:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c10:	8b 55 0c             	mov    0xc(%ebp),%edx
 c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c16:	01 d0                	add    %edx,%eax
 c18:	0f b6 00             	movzbl (%eax),%eax
 c1b:	84 c0                	test   %al,%al
 c1d:	0f 85 94 fe ff ff    	jne    ab7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c23:	90                   	nop
 c24:	c9                   	leave  
 c25:	c3                   	ret    

00000c26 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c26:	55                   	push   %ebp
 c27:	89 e5                	mov    %esp,%ebp
 c29:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c2c:	8b 45 08             	mov    0x8(%ebp),%eax
 c2f:	83 e8 08             	sub    $0x8,%eax
 c32:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c35:	a1 c0 11 00 00       	mov    0x11c0,%eax
 c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c3d:	eb 24                	jmp    c63 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c42:	8b 00                	mov    (%eax),%eax
 c44:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c47:	77 12                	ja     c5b <free+0x35>
 c49:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c4f:	77 24                	ja     c75 <free+0x4f>
 c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c54:	8b 00                	mov    (%eax),%eax
 c56:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c59:	77 1a                	ja     c75 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5e:	8b 00                	mov    (%eax),%eax
 c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c66:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c69:	76 d4                	jbe    c3f <free+0x19>
 c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6e:	8b 00                	mov    (%eax),%eax
 c70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c73:	76 ca                	jbe    c3f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c78:	8b 40 04             	mov    0x4(%eax),%eax
 c7b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c82:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c85:	01 c2                	add    %eax,%edx
 c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8a:	8b 00                	mov    (%eax),%eax
 c8c:	39 c2                	cmp    %eax,%edx
 c8e:	75 24                	jne    cb4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c93:	8b 50 04             	mov    0x4(%eax),%edx
 c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c99:	8b 00                	mov    (%eax),%eax
 c9b:	8b 40 04             	mov    0x4(%eax),%eax
 c9e:	01 c2                	add    %eax,%edx
 ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca9:	8b 00                	mov    (%eax),%eax
 cab:	8b 10                	mov    (%eax),%edx
 cad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb0:	89 10                	mov    %edx,(%eax)
 cb2:	eb 0a                	jmp    cbe <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb7:	8b 10                	mov    (%eax),%edx
 cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cbc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc1:	8b 40 04             	mov    0x4(%eax),%eax
 cc4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cce:	01 d0                	add    %edx,%eax
 cd0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cd3:	75 20                	jne    cf5 <free+0xcf>
    p->s.size += bp->s.size;
 cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd8:	8b 50 04             	mov    0x4(%eax),%edx
 cdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cde:	8b 40 04             	mov    0x4(%eax),%eax
 ce1:	01 c2                	add    %eax,%edx
 ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cec:	8b 10                	mov    (%eax),%edx
 cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf1:	89 10                	mov    %edx,(%eax)
 cf3:	eb 08                	jmp    cfd <free+0xd7>
  } else
    p->s.ptr = bp;
 cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cfb:	89 10                	mov    %edx,(%eax)
  freep = p;
 cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d00:	a3 c0 11 00 00       	mov    %eax,0x11c0
}
 d05:	90                   	nop
 d06:	c9                   	leave  
 d07:	c3                   	ret    

00000d08 <morecore>:

static Header*
morecore(uint nu)
{
 d08:	55                   	push   %ebp
 d09:	89 e5                	mov    %esp,%ebp
 d0b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d0e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d15:	77 07                	ja     d1e <morecore+0x16>
    nu = 4096;
 d17:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d1e:	8b 45 08             	mov    0x8(%ebp),%eax
 d21:	c1 e0 03             	shl    $0x3,%eax
 d24:	83 ec 0c             	sub    $0xc,%esp
 d27:	50                   	push   %eax
 d28:	e8 19 fc ff ff       	call   946 <sbrk>
 d2d:	83 c4 10             	add    $0x10,%esp
 d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d33:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d37:	75 07                	jne    d40 <morecore+0x38>
    return 0;
 d39:	b8 00 00 00 00       	mov    $0x0,%eax
 d3e:	eb 26                	jmp    d66 <morecore+0x5e>
  hp = (Header*)p;
 d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d49:	8b 55 08             	mov    0x8(%ebp),%edx
 d4c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d52:	83 c0 08             	add    $0x8,%eax
 d55:	83 ec 0c             	sub    $0xc,%esp
 d58:	50                   	push   %eax
 d59:	e8 c8 fe ff ff       	call   c26 <free>
 d5e:	83 c4 10             	add    $0x10,%esp
  return freep;
 d61:	a1 c0 11 00 00       	mov    0x11c0,%eax
}
 d66:	c9                   	leave  
 d67:	c3                   	ret    

00000d68 <malloc>:

void*
malloc(uint nbytes)
{
 d68:	55                   	push   %ebp
 d69:	89 e5                	mov    %esp,%ebp
 d6b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d6e:	8b 45 08             	mov    0x8(%ebp),%eax
 d71:	83 c0 07             	add    $0x7,%eax
 d74:	c1 e8 03             	shr    $0x3,%eax
 d77:	83 c0 01             	add    $0x1,%eax
 d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d7d:	a1 c0 11 00 00       	mov    0x11c0,%eax
 d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d89:	75 23                	jne    dae <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d8b:	c7 45 f0 b8 11 00 00 	movl   $0x11b8,-0x10(%ebp)
 d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d95:	a3 c0 11 00 00       	mov    %eax,0x11c0
 d9a:	a1 c0 11 00 00       	mov    0x11c0,%eax
 d9f:	a3 b8 11 00 00       	mov    %eax,0x11b8
    base.s.size = 0;
 da4:	c7 05 bc 11 00 00 00 	movl   $0x0,0x11bc
 dab:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db1:	8b 00                	mov    (%eax),%eax
 db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db9:	8b 40 04             	mov    0x4(%eax),%eax
 dbc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dbf:	72 4d                	jb     e0e <malloc+0xa6>
      if(p->s.size == nunits)
 dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc4:	8b 40 04             	mov    0x4(%eax),%eax
 dc7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dca:	75 0c                	jne    dd8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcf:	8b 10                	mov    (%eax),%edx
 dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd4:	89 10                	mov    %edx,(%eax)
 dd6:	eb 26                	jmp    dfe <malloc+0x96>
      else {
        p->s.size -= nunits;
 dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ddb:	8b 40 04             	mov    0x4(%eax),%eax
 dde:	2b 45 ec             	sub    -0x14(%ebp),%eax
 de1:	89 c2                	mov    %eax,%edx
 de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dec:	8b 40 04             	mov    0x4(%eax),%eax
 def:	c1 e0 03             	shl    $0x3,%eax
 df2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dfb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e01:	a3 c0 11 00 00       	mov    %eax,0x11c0
      return (void*)(p + 1);
 e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e09:	83 c0 08             	add    $0x8,%eax
 e0c:	eb 3b                	jmp    e49 <malloc+0xe1>
    }
    if(p == freep)
 e0e:	a1 c0 11 00 00       	mov    0x11c0,%eax
 e13:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e16:	75 1e                	jne    e36 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 e18:	83 ec 0c             	sub    $0xc,%esp
 e1b:	ff 75 ec             	pushl  -0x14(%ebp)
 e1e:	e8 e5 fe ff ff       	call   d08 <morecore>
 e23:	83 c4 10             	add    $0x10,%esp
 e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e2d:	75 07                	jne    e36 <malloc+0xce>
        return 0;
 e2f:	b8 00 00 00 00       	mov    $0x0,%eax
 e34:	eb 13                	jmp    e49 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3f:	8b 00                	mov    (%eax),%eax
 e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e44:	e9 6d ff ff ff       	jmp    db6 <malloc+0x4e>
}
 e49:	c9                   	leave  
 e4a:	c3                   	ret    
