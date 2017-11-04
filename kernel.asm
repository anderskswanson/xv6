
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 2d 39 10 80       	mov    $0x8010392d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 a0 95 10 80       	push   $0x801095a0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 93 5e 00 00       	call   80105edf <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 3b 5e 00 00       	call   80105f01 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 57 5e 00 00       	call   80105f68 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 d1 51 00 00       	call   801052fd <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 db 5d 00 00       	call   80105f68 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 a7 95 10 80       	push   $0x801095a7
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 c4 27 00 00       	call   801029ab <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 b8 95 10 80       	push   $0x801095b8
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 83 27 00 00       	call   801029ab <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 bf 95 10 80       	push   $0x801095bf
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 a7 5c 00 00       	call   80105f01 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 f3 51 00 00       	call   801054b1 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 9a 5c 00 00       	call   80105f68 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 1a 5b 00 00       	call   80105f01 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 c6 95 10 80       	push   $0x801095c6
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec cf 95 10 80 	movl   $0x801095cf,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 08 5a 00 00       	call   80105f68 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 d6 95 10 80       	push   $0x801095d6
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 e5 95 10 80       	push   $0x801095e5
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 f3 59 00 00       	call   80105fba <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 e7 95 10 80       	push   $0x801095e7
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 eb 95 10 80       	push   $0x801095eb
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 27 5b 00 00       	call   80106223 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 3e 5a 00 00       	call   80106164 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 6c 74 00 00       	call   80107c27 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 5f 74 00 00       	call   80107c27 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 52 74 00 00       	call   80107c27 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 42 74 00 00       	call   80107c27 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
#ifdef CS333_P3P4
  int ctrls = 0; 
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int ctrlr = 0; 
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int ctrlf = 0;
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int ctrlz = 0;
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
#endif

  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 e0 c5 10 80       	push   $0x8010c5e0
8010082a:	e8 d2 56 00 00       	call   80105f01 <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 9a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	74 44                	je     80100883 <consoleintr+0x8a>
8010083f:	83 f8 12             	cmp    $0x12,%eax
80100842:	7f 18                	jg     8010085c <consoleintr+0x63>
80100844:	83 f8 08             	cmp    $0x8,%eax
80100847:	0f 84 bd 00 00 00    	je     8010090a <consoleintr+0x111>
8010084d:	83 f8 10             	cmp    $0x10,%eax
80100850:	74 61                	je     801008b3 <consoleintr+0xba>
80100852:	83 f8 06             	cmp    $0x6,%eax
80100855:	74 38                	je     8010088f <consoleintr+0x96>
80100857:	e9 e3 00 00 00       	jmp    8010093f <consoleintr+0x146>
8010085c:	83 f8 15             	cmp    $0x15,%eax
8010085f:	74 7b                	je     801008dc <consoleintr+0xe3>
80100861:	83 f8 15             	cmp    $0x15,%eax
80100864:	7f 0a                	jg     80100870 <consoleintr+0x77>
80100866:	83 f8 13             	cmp    $0x13,%eax
80100869:	74 30                	je     8010089b <consoleintr+0xa2>
8010086b:	e9 cf 00 00 00       	jmp    8010093f <consoleintr+0x146>
80100870:	83 f8 1a             	cmp    $0x1a,%eax
80100873:	74 32                	je     801008a7 <consoleintr+0xae>
80100875:	83 f8 7f             	cmp    $0x7f,%eax
80100878:	0f 84 8c 00 00 00    	je     8010090a <consoleintr+0x111>
8010087e:	e9 bc 00 00 00       	jmp    8010093f <consoleintr+0x146>
#ifdef CS333_P3P4
    case C('R'):
      ctrlr = 1;
80100883:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
8010088a:	e9 42 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('F'):
      ctrlf = 1;
8010088f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
80100896:	e9 36 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('S'):
      ctrls = 1;
8010089b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
801008a2:	e9 2a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('Z'):
      ctrlz = 1;
801008a7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
801008ae:	e9 1e 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
#endif
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
801008b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801008ba:	e9 12 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008bf:	a1 28 18 11 80       	mov    0x80111828,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008cc:	83 ec 0c             	sub    $0xc,%esp
801008cf:	68 00 01 00 00       	push   $0x100
801008d4:	e8 b9 fe ff ff       	call   80100792 <consputc>
801008d9:	83 c4 10             	add    $0x10,%esp
#endif
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dc:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008e2:	a1 24 18 11 80       	mov    0x80111824,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 28 18 11 80       	mov    0x80111828,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
#endif
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100901:	3c 0a                	cmp    $0xa,%al
80100903:	75 ba                	jne    801008bf <consoleintr+0xc6>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100905:	e9 c7 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010090a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100910:	a1 24 18 11 80       	mov    0x80111824,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	68 00 01 00 00       	push   $0x100
80100932:	e8 5b fe ff ff       	call   80100792 <consputc>
80100937:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010093a:	e9 92 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100943:	0f 84 87 00 00 00    	je     801009d0 <consoleintr+0x1d7>
80100949:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010094f:	a1 20 18 11 80       	mov    0x80111820,%eax
80100954:	29 c2                	sub    %eax,%edx
80100956:	89 d0                	mov    %edx,%eax
80100958:	83 f8 7f             	cmp    $0x7f,%eax
8010095b:	77 73                	ja     801009d0 <consoleintr+0x1d7>
        c = (c == '\r') ? '\n' : c;
8010095d:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
80100961:	74 05                	je     80100968 <consoleintr+0x16f>
80100963:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100966:	eb 05                	jmp    8010096d <consoleintr+0x174>
80100968:	b8 0a 00 00 00       	mov    $0xa,%eax
8010096d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	a1 28 18 11 80       	mov    0x80111828,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 28 18 11 80    	mov    %edx,0x80111828
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
8010098a:	83 ec 0c             	sub    $0xc,%esp
8010098d:	ff 75 e0             	pushl  -0x20(%ebp)
80100990:	e8 fd fd ff ff       	call   80100792 <consputc>
80100995:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100998:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
8010099c:	74 18                	je     801009b6 <consoleintr+0x1bd>
8010099e:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009a2:	74 12                	je     801009b6 <consoleintr+0x1bd>
801009a4:	a1 28 18 11 80       	mov    0x80111828,%eax
801009a9:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 28 18 11 80       	mov    0x80111828,%eax
801009bb:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 20 18 11 80       	push   $0x80111820
801009c8:	e8 e4 4a 00 00       	call   801054b1 <wakeup>
801009cd:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009d0:	90                   	nop
  int ctrlf = 0;
  int ctrlz = 0;
#endif

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009d1:	8b 45 08             	mov    0x8(%ebp),%eax
801009d4:	ff d0                	call   *%eax
801009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009dd:	0f 89 54 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 e0 c5 10 80       	push   $0x8010c5e0
801009eb:	e8 78 55 00 00       	call   80105f68 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  if(ctrls)
801009f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009f7:	74 05                	je     801009fe <consoleintr+0x205>
    printsleep();  
801009f9:	e8 30 53 00 00       	call   80105d2e <printsleep>
  if(ctrlr)
801009fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a02:	74 05                	je     80100a09 <consoleintr+0x210>
    printready();
80100a04:	e8 74 54 00 00       	call   80105e7d <printready>
  if(ctrlz)
80100a09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a0d:	74 05                	je     80100a14 <consoleintr+0x21b>
    printzombie();
80100a0f:	e8 97 53 00 00       	call   80105dab <printzombie>
  if(ctrlf)
80100a14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a18:	74 05                	je     80100a1f <consoleintr+0x226>
    printfree();
80100a1a:	e8 39 53 00 00       	call   80105d58 <printfree>
#endif
  if(doprocdump) {
80100a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a23:	74 05                	je     80100a2a <consoleintr+0x231>
    procdump();  // now call procdump() wo. cons.lock held
80100a25:	e8 89 4c 00 00       	call   801056b3 <procdump>
  }
}
80100a2a:	90                   	nop
80100a2b:	c9                   	leave  
80100a2c:	c3                   	ret    

80100a2d <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a2d:	55                   	push   %ebp
80100a2e:	89 e5                	mov    %esp,%ebp
80100a30:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a33:	83 ec 0c             	sub    $0xc,%esp
80100a36:	ff 75 08             	pushl  0x8(%ebp)
80100a39:	e8 28 11 00 00       	call   80101b66 <iunlock>
80100a3e:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a41:	8b 45 10             	mov    0x10(%ebp),%eax
80100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a47:	83 ec 0c             	sub    $0xc,%esp
80100a4a:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a4f:	e8 ad 54 00 00       	call   80105f01 <acquire>
80100a54:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a57:	e9 ac 00 00 00       	jmp    80100b08 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a62:	8b 40 24             	mov    0x24(%eax),%eax
80100a65:	85 c0                	test   %eax,%eax
80100a67:	74 28                	je     80100a91 <consoleread+0x64>
        release(&cons.lock);
80100a69:	83 ec 0c             	sub    $0xc,%esp
80100a6c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a71:	e8 f2 54 00 00       	call   80105f68 <release>
80100a76:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a79:	83 ec 0c             	sub    $0xc,%esp
80100a7c:	ff 75 08             	pushl  0x8(%ebp)
80100a7f:	e8 84 0f 00 00       	call   80101a08 <ilock>
80100a84:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a8c:	e9 ab 00 00 00       	jmp    80100b3c <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a91:	83 ec 08             	sub    $0x8,%esp
80100a94:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a99:	68 20 18 11 80       	push   $0x80111820
80100a9e:	e8 5a 48 00 00       	call   801052fd <sleep>
80100aa3:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aa6:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100aac:	a1 24 18 11 80       	mov    0x80111824,%eax
80100ab1:	39 c2                	cmp    %eax,%edx
80100ab3:	74 a7                	je     80100a5c <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ab5:	a1 20 18 11 80       	mov    0x80111820,%eax
80100aba:	8d 50 01             	lea    0x1(%eax),%edx
80100abd:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100ac3:	83 e0 7f             	and    $0x7f,%eax
80100ac6:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100acd:	0f be c0             	movsbl %al,%eax
80100ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ad3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ad7:	75 17                	jne    80100af0 <consoleread+0xc3>
      if(n < target){
80100ad9:	8b 45 10             	mov    0x10(%ebp),%eax
80100adc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100adf:	73 2f                	jae    80100b10 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae1:	a1 20 18 11 80       	mov    0x80111820,%eax
80100ae6:	83 e8 01             	sub    $0x1,%eax
80100ae9:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100aee:	eb 20                	jmp    80100b10 <consoleread+0xe3>
    }
    *dst++ = c;
80100af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af3:	8d 50 01             	lea    0x1(%eax),%edx
80100af6:	89 55 0c             	mov    %edx,0xc(%ebp)
80100af9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100afc:	88 10                	mov    %dl,(%eax)
    --n;
80100afe:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b02:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b06:	74 0b                	je     80100b13 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b0c:	7f 98                	jg     80100aa6 <consoleread+0x79>
80100b0e:	eb 04                	jmp    80100b14 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b10:	90                   	nop
80100b11:	eb 01                	jmp    80100b14 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b13:	90                   	nop
  }
  release(&cons.lock);
80100b14:	83 ec 0c             	sub    $0xc,%esp
80100b17:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b1c:	e8 47 54 00 00       	call   80105f68 <release>
80100b21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b24:	83 ec 0c             	sub    $0xc,%esp
80100b27:	ff 75 08             	pushl  0x8(%ebp)
80100b2a:	e8 d9 0e 00 00       	call   80101a08 <ilock>
80100b2f:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b32:	8b 45 10             	mov    0x10(%ebp),%eax
80100b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b38:	29 c2                	sub    %eax,%edx
80100b3a:	89 d0                	mov    %edx,%eax
}
80100b3c:	c9                   	leave  
80100b3d:	c3                   	ret    

80100b3e <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b3e:	55                   	push   %ebp
80100b3f:	89 e5                	mov    %esp,%ebp
80100b41:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b44:	83 ec 0c             	sub    $0xc,%esp
80100b47:	ff 75 08             	pushl  0x8(%ebp)
80100b4a:	e8 17 10 00 00       	call   80101b66 <iunlock>
80100b4f:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b5a:	e8 a2 53 00 00       	call   80105f01 <acquire>
80100b5f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b69:	eb 21                	jmp    80100b8c <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b71:	01 d0                	add    %edx,%eax
80100b73:	0f b6 00             	movzbl (%eax),%eax
80100b76:	0f be c0             	movsbl %al,%eax
80100b79:	0f b6 c0             	movzbl %al,%eax
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	50                   	push   %eax
80100b80:	e8 0d fc ff ff       	call   80100792 <consputc>
80100b85:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b8f:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b92:	7c d7                	jl     80100b6b <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b94:	83 ec 0c             	sub    $0xc,%esp
80100b97:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b9c:	e8 c7 53 00 00       	call   80105f68 <release>
80100ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ba4:	83 ec 0c             	sub    $0xc,%esp
80100ba7:	ff 75 08             	pushl  0x8(%ebp)
80100baa:	e8 59 0e 00 00       	call   80101a08 <ilock>
80100baf:	83 c4 10             	add    $0x10,%esp

  return n;
80100bb2:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bb5:	c9                   	leave  
80100bb6:	c3                   	ret    

80100bb7 <consoleinit>:

void
consoleinit(void)
{
80100bb7:	55                   	push   %ebp
80100bb8:	89 e5                	mov    %esp,%ebp
80100bba:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bbd:	83 ec 08             	sub    $0x8,%esp
80100bc0:	68 fe 95 10 80       	push   $0x801095fe
80100bc5:	68 e0 c5 10 80       	push   $0x8010c5e0
80100bca:	e8 10 53 00 00       	call   80105edf <initlock>
80100bcf:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd2:	c7 05 ec 21 11 80 3e 	movl   $0x80100b3e,0x801121ec
80100bd9:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bdc:	c7 05 e8 21 11 80 2d 	movl   $0x80100a2d,0x801121e8
80100be3:	0a 10 80 
  cons.locking = 1;
80100be6:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100bed:	00 00 00 

  picenable(IRQ_KBD);
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	6a 01                	push   $0x1
80100bf5:	e8 cf 33 00 00       	call   80103fc9 <picenable>
80100bfa:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bfd:	83 ec 08             	sub    $0x8,%esp
80100c00:	6a 00                	push   $0x0
80100c02:	6a 01                	push   $0x1
80100c04:	e8 6f 1f 00 00       	call   80102b78 <ioapicenable>
80100c09:	83 c4 10             	add    $0x10,%esp
}
80100c0c:	90                   	nop
80100c0d:	c9                   	leave  
80100c0e:	c3                   	ret    

80100c0f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c0f:	55                   	push   %ebp
80100c10:	89 e5                	mov    %esp,%ebp
80100c12:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c18:	e8 ce 29 00 00       	call   801035eb <begin_op>
  if((ip = namei(path)) == 0){
80100c1d:	83 ec 0c             	sub    $0xc,%esp
80100c20:	ff 75 08             	pushl  0x8(%ebp)
80100c23:	e8 9e 19 00 00       	call   801025c6 <namei>
80100c28:	83 c4 10             	add    $0x10,%esp
80100c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c32:	75 0f                	jne    80100c43 <exec+0x34>
    end_op();
80100c34:	e8 3e 2a 00 00       	call   80103677 <end_op>
    return -1;
80100c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3e:	e9 ce 03 00 00       	jmp    80101011 <exec+0x402>
  }
  ilock(ip);
80100c43:	83 ec 0c             	sub    $0xc,%esp
80100c46:	ff 75 d8             	pushl  -0x28(%ebp)
80100c49:	e8 ba 0d 00 00       	call   80101a08 <ilock>
80100c4e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c51:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c58:	6a 34                	push   $0x34
80100c5a:	6a 00                	push   $0x0
80100c5c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c62:	50                   	push   %eax
80100c63:	ff 75 d8             	pushl  -0x28(%ebp)
80100c66:	e8 0b 13 00 00       	call   80101f76 <readi>
80100c6b:	83 c4 10             	add    $0x10,%esp
80100c6e:	83 f8 33             	cmp    $0x33,%eax
80100c71:	0f 86 49 03 00 00    	jbe    80100fc0 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c77:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c7d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c82:	0f 85 3b 03 00 00    	jne    80100fc3 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c88:	e8 ef 80 00 00       	call   80108d7c <setupkvm>
80100c8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c90:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c94:	0f 84 2c 03 00 00    	je     80100fc6 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ca8:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cae:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cb1:	e9 ab 00 00 00       	jmp    80100d61 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cb9:	6a 20                	push   $0x20
80100cbb:	50                   	push   %eax
80100cbc:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cc2:	50                   	push   %eax
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	e8 ab 12 00 00       	call   80101f76 <readi>
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	83 f8 20             	cmp    $0x20,%eax
80100cd1:	0f 85 f2 02 00 00    	jne    80100fc9 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cd7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cdd:	83 f8 01             	cmp    $0x1,%eax
80100ce0:	75 71                	jne    80100d53 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100ce2:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100ce8:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cee:	39 c2                	cmp    %eax,%edx
80100cf0:	0f 82 d6 02 00 00    	jb     80100fcc <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cf6:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cfc:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d02:	01 d0                	add    %edx,%eax
80100d04:	83 ec 04             	sub    $0x4,%esp
80100d07:	50                   	push   %eax
80100d08:	ff 75 e0             	pushl  -0x20(%ebp)
80100d0b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d0e:	e8 10 84 00 00       	call   80109123 <allocuvm>
80100d13:	83 c4 10             	add    $0x10,%esp
80100d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d1d:	0f 84 ac 02 00 00    	je     80100fcf <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d29:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d2f:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d35:	83 ec 0c             	sub    $0xc,%esp
80100d38:	52                   	push   %edx
80100d39:	50                   	push   %eax
80100d3a:	ff 75 d8             	pushl  -0x28(%ebp)
80100d3d:	51                   	push   %ecx
80100d3e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d41:	e8 06 83 00 00       	call   8010904c <loaduvm>
80100d46:	83 c4 20             	add    $0x20,%esp
80100d49:	85 c0                	test   %eax,%eax
80100d4b:	0f 88 81 02 00 00    	js     80100fd2 <exec+0x3c3>
80100d51:	eb 01                	jmp    80100d54 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d53:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d54:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d5b:	83 c0 20             	add    $0x20,%eax
80100d5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d61:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d68:	0f b7 c0             	movzwl %ax,%eax
80100d6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d6e:	0f 8f 42 ff ff ff    	jg     80100cb6 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d74:	83 ec 0c             	sub    $0xc,%esp
80100d77:	ff 75 d8             	pushl  -0x28(%ebp)
80100d7a:	e8 49 0f 00 00       	call   80101cc8 <iunlockput>
80100d7f:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d82:	e8 f0 28 00 00       	call   80103677 <end_op>
  ip = 0;
80100d87:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d91:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da1:	05 00 20 00 00       	add    $0x2000,%eax
80100da6:	83 ec 04             	sub    $0x4,%esp
80100da9:	50                   	push   %eax
80100daa:	ff 75 e0             	pushl  -0x20(%ebp)
80100dad:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db0:	e8 6e 83 00 00       	call   80109123 <allocuvm>
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dbf:	0f 84 10 02 00 00    	je     80100fd5 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc8:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dcd:	83 ec 08             	sub    $0x8,%esp
80100dd0:	50                   	push   %eax
80100dd1:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dd4:	e8 70 85 00 00       	call   80109349 <clearpteu>
80100dd9:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddf:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100de9:	e9 96 00 00 00       	jmp    80100e84 <exec+0x275>
    if(argc >= MAXARG)
80100dee:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df2:	0f 87 e0 01 00 00    	ja     80100fd8 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e05:	01 d0                	add    %edx,%eax
80100e07:	8b 00                	mov    (%eax),%eax
80100e09:	83 ec 0c             	sub    $0xc,%esp
80100e0c:	50                   	push   %eax
80100e0d:	e8 9f 55 00 00       	call   801063b1 <strlen>
80100e12:	83 c4 10             	add    $0x10,%esp
80100e15:	89 c2                	mov    %eax,%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	29 d0                	sub    %edx,%eax
80100e1c:	83 e8 01             	sub    $0x1,%eax
80100e1f:	83 e0 fc             	and    $0xfffffffc,%eax
80100e22:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e32:	01 d0                	add    %edx,%eax
80100e34:	8b 00                	mov    (%eax),%eax
80100e36:	83 ec 0c             	sub    $0xc,%esp
80100e39:	50                   	push   %eax
80100e3a:	e8 72 55 00 00       	call   801063b1 <strlen>
80100e3f:	83 c4 10             	add    $0x10,%esp
80100e42:	83 c0 01             	add    $0x1,%eax
80100e45:	89 c1                	mov    %eax,%ecx
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e51:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e54:	01 d0                	add    %edx,%eax
80100e56:	8b 00                	mov    (%eax),%eax
80100e58:	51                   	push   %ecx
80100e59:	50                   	push   %eax
80100e5a:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e60:	e8 9b 86 00 00       	call   80109500 <copyout>
80100e65:	83 c4 10             	add    $0x10,%esp
80100e68:	85 c0                	test   %eax,%eax
80100e6a:	0f 88 6b 01 00 00    	js     80100fdb <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e73:	8d 50 03             	lea    0x3(%eax),%edx
80100e76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e79:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e80:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e91:	01 d0                	add    %edx,%eax
80100e93:	8b 00                	mov    (%eax),%eax
80100e95:	85 c0                	test   %eax,%eax
80100e97:	0f 85 51 ff ff ff    	jne    80100dee <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea0:	83 c0 03             	add    $0x3,%eax
80100ea3:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100eaa:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eae:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100eb5:	ff ff ff 
  ustack[1] = argc;
80100eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebb:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec4:	83 c0 01             	add    $0x1,%eax
80100ec7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ece:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed1:	29 d0                	sub    %edx,%eax
80100ed3:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edc:	83 c0 04             	add    $0x4,%eax
80100edf:	c1 e0 02             	shl    $0x2,%eax
80100ee2:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee8:	83 c0 04             	add    $0x4,%eax
80100eeb:	c1 e0 02             	shl    $0x2,%eax
80100eee:	50                   	push   %eax
80100eef:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ef5:	50                   	push   %eax
80100ef6:	ff 75 dc             	pushl  -0x24(%ebp)
80100ef9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100efc:	e8 ff 85 00 00       	call   80109500 <copyout>
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	85 c0                	test   %eax,%eax
80100f06:	0f 88 d2 00 00 00    	js     80100fde <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f18:	eb 17                	jmp    80100f31 <exec+0x322>
    if(*s == '/')
80100f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1d:	0f b6 00             	movzbl (%eax),%eax
80100f20:	3c 2f                	cmp    $0x2f,%al
80100f22:	75 09                	jne    80100f2d <exec+0x31e>
      last = s+1;
80100f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f27:	83 c0 01             	add    $0x1,%eax
80100f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f34:	0f b6 00             	movzbl (%eax),%eax
80100f37:	84 c0                	test   %al,%al
80100f39:	75 df                	jne    80100f1a <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f41:	83 c0 6c             	add    $0x6c,%eax
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	6a 10                	push   $0x10
80100f49:	ff 75 f0             	pushl  -0x10(%ebp)
80100f4c:	50                   	push   %eax
80100f4d:	e8 15 54 00 00       	call   80106367 <safestrcpy>
80100f52:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f5b:	8b 40 04             	mov    0x4(%eax),%eax
80100f5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f6a:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f73:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f76:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7e:	8b 40 18             	mov    0x18(%eax),%eax
80100f81:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f87:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f90:	8b 40 18             	mov    0x18(%eax),%eax
80100f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f96:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	50                   	push   %eax
80100fa3:	e8 bb 7e 00 00       	call   80108e63 <switchuvm>
80100fa8:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb1:	e8 f3 82 00 00       	call   801092a9 <freevm>
80100fb6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fb9:	b8 00 00 00 00       	mov    $0x0,%eax
80100fbe:	eb 51                	jmp    80101011 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fc0:	90                   	nop
80100fc1:	eb 1c                	jmp    80100fdf <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fc3:	90                   	nop
80100fc4:	eb 19                	jmp    80100fdf <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fc6:	90                   	nop
80100fc7:	eb 16                	jmp    80100fdf <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fc9:	90                   	nop
80100fca:	eb 13                	jmp    80100fdf <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fcc:	90                   	nop
80100fcd:	eb 10                	jmp    80100fdf <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fcf:	90                   	nop
80100fd0:	eb 0d                	jmp    80100fdf <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fd2:	90                   	nop
80100fd3:	eb 0a                	jmp    80100fdf <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fd5:	90                   	nop
80100fd6:	eb 07                	jmp    80100fdf <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fd8:	90                   	nop
80100fd9:	eb 04                	jmp    80100fdf <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fdb:	90                   	nop
80100fdc:	eb 01                	jmp    80100fdf <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fde:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fe3:	74 0e                	je     80100ff3 <exec+0x3e4>
    freevm(pgdir);
80100fe5:	83 ec 0c             	sub    $0xc,%esp
80100fe8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100feb:	e8 b9 82 00 00       	call   801092a9 <freevm>
80100ff0:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100ff3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ff7:	74 13                	je     8010100c <exec+0x3fd>
    iunlockput(ip);
80100ff9:	83 ec 0c             	sub    $0xc,%esp
80100ffc:	ff 75 d8             	pushl  -0x28(%ebp)
80100fff:	e8 c4 0c 00 00       	call   80101cc8 <iunlockput>
80101004:	83 c4 10             	add    $0x10,%esp
    end_op();
80101007:	e8 6b 26 00 00       	call   80103677 <end_op>
  }
  return -1;
8010100c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101011:	c9                   	leave  
80101012:	c3                   	ret    

80101013 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101013:	55                   	push   %ebp
80101014:	89 e5                	mov    %esp,%ebp
80101016:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101019:	83 ec 08             	sub    $0x8,%esp
8010101c:	68 06 96 10 80       	push   $0x80109606
80101021:	68 40 18 11 80       	push   $0x80111840
80101026:	e8 b4 4e 00 00       	call   80105edf <initlock>
8010102b:	83 c4 10             	add    $0x10,%esp
}
8010102e:	90                   	nop
8010102f:	c9                   	leave  
80101030:	c3                   	ret    

80101031 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101031:	55                   	push   %ebp
80101032:	89 e5                	mov    %esp,%ebp
80101034:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 40 18 11 80       	push   $0x80111840
8010103f:	e8 bd 4e 00 00       	call   80105f01 <acquire>
80101044:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101047:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
8010104e:	eb 2d                	jmp    8010107d <filealloc+0x4c>
    if(f->ref == 0){
80101050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101053:	8b 40 04             	mov    0x4(%eax),%eax
80101056:	85 c0                	test   %eax,%eax
80101058:	75 1f                	jne    80101079 <filealloc+0x48>
      f->ref = 1;
8010105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	68 40 18 11 80       	push   $0x80111840
8010106c:	e8 f7 4e 00 00       	call   80105f68 <release>
80101071:	83 c4 10             	add    $0x10,%esp
      return f;
80101074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101077:	eb 23                	jmp    8010109c <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101079:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010107d:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80101082:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101085:	72 c9                	jb     80101050 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 40 18 11 80       	push   $0x80111840
8010108f:	e8 d4 4e 00 00       	call   80105f68 <release>
80101094:	83 c4 10             	add    $0x10,%esp
  return 0;
80101097:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010109c:	c9                   	leave  
8010109d:	c3                   	ret    

8010109e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010109e:	55                   	push   %ebp
8010109f:	89 e5                	mov    %esp,%ebp
801010a1:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010a4:	83 ec 0c             	sub    $0xc,%esp
801010a7:	68 40 18 11 80       	push   $0x80111840
801010ac:	e8 50 4e 00 00       	call   80105f01 <acquire>
801010b1:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	8b 40 04             	mov    0x4(%eax),%eax
801010ba:	85 c0                	test   %eax,%eax
801010bc:	7f 0d                	jg     801010cb <filedup+0x2d>
    panic("filedup");
801010be:	83 ec 0c             	sub    $0xc,%esp
801010c1:	68 0d 96 10 80       	push   $0x8010960d
801010c6:	e8 9b f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010cb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ce:	8b 40 04             	mov    0x4(%eax),%eax
801010d1:	8d 50 01             	lea    0x1(%eax),%edx
801010d4:	8b 45 08             	mov    0x8(%ebp),%eax
801010d7:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010da:	83 ec 0c             	sub    $0xc,%esp
801010dd:	68 40 18 11 80       	push   $0x80111840
801010e2:	e8 81 4e 00 00       	call   80105f68 <release>
801010e7:	83 c4 10             	add    $0x10,%esp
  return f;
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010ed:	c9                   	leave  
801010ee:	c3                   	ret    

801010ef <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010ef:	55                   	push   %ebp
801010f0:	89 e5                	mov    %esp,%ebp
801010f2:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010f5:	83 ec 0c             	sub    $0xc,%esp
801010f8:	68 40 18 11 80       	push   $0x80111840
801010fd:	e8 ff 4d 00 00       	call   80105f01 <acquire>
80101102:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101105:	8b 45 08             	mov    0x8(%ebp),%eax
80101108:	8b 40 04             	mov    0x4(%eax),%eax
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 0d                	jg     8010111c <fileclose+0x2d>
    panic("fileclose");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 15 96 10 80       	push   $0x80109615
80101117:	e8 4a f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	8b 40 04             	mov    0x4(%eax),%eax
80101122:	8d 50 ff             	lea    -0x1(%eax),%edx
80101125:	8b 45 08             	mov    0x8(%ebp),%eax
80101128:	89 50 04             	mov    %edx,0x4(%eax)
8010112b:	8b 45 08             	mov    0x8(%ebp),%eax
8010112e:	8b 40 04             	mov    0x4(%eax),%eax
80101131:	85 c0                	test   %eax,%eax
80101133:	7e 15                	jle    8010114a <fileclose+0x5b>
    release(&ftable.lock);
80101135:	83 ec 0c             	sub    $0xc,%esp
80101138:	68 40 18 11 80       	push   $0x80111840
8010113d:	e8 26 4e 00 00       	call   80105f68 <release>
80101142:	83 c4 10             	add    $0x10,%esp
80101145:	e9 8b 00 00 00       	jmp    801011d5 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 10                	mov    (%eax),%edx
8010114f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101152:	8b 50 04             	mov    0x4(%eax),%edx
80101155:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101158:	8b 50 08             	mov    0x8(%eax),%edx
8010115b:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010115e:	8b 50 0c             	mov    0xc(%eax),%edx
80101161:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101164:	8b 50 10             	mov    0x10(%eax),%edx
80101167:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010116a:	8b 40 14             	mov    0x14(%eax),%eax
8010116d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	68 40 18 11 80       	push   $0x80111840
8010118b:	e8 d8 4d 00 00       	call   80105f68 <release>
80101190:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101196:	83 f8 01             	cmp    $0x1,%eax
80101199:	75 19                	jne    801011b4 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010119b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010119f:	0f be d0             	movsbl %al,%edx
801011a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011a5:	83 ec 08             	sub    $0x8,%esp
801011a8:	52                   	push   %edx
801011a9:	50                   	push   %eax
801011aa:	e8 83 30 00 00       	call   80104232 <pipeclose>
801011af:	83 c4 10             	add    $0x10,%esp
801011b2:	eb 21                	jmp    801011d5 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b7:	83 f8 02             	cmp    $0x2,%eax
801011ba:	75 19                	jne    801011d5 <fileclose+0xe6>
    begin_op();
801011bc:	e8 2a 24 00 00       	call   801035eb <begin_op>
    iput(ff.ip);
801011c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 0b 0a 00 00       	call   80101bd8 <iput>
801011cd:	83 c4 10             	add    $0x10,%esp
    end_op();
801011d0:	e8 a2 24 00 00       	call   80103677 <end_op>
  }
}
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    

801011d7 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011d7:	55                   	push   %ebp
801011d8:	89 e5                	mov    %esp,%ebp
801011da:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 00                	mov    (%eax),%eax
801011e2:	83 f8 02             	cmp    $0x2,%eax
801011e5:	75 40                	jne    80101227 <filestat+0x50>
    ilock(f->ip);
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 40 10             	mov    0x10(%eax),%eax
801011ed:	83 ec 0c             	sub    $0xc,%esp
801011f0:	50                   	push   %eax
801011f1:	e8 12 08 00 00       	call   80101a08 <ilock>
801011f6:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 40 10             	mov    0x10(%eax),%eax
801011ff:	83 ec 08             	sub    $0x8,%esp
80101202:	ff 75 0c             	pushl  0xc(%ebp)
80101205:	50                   	push   %eax
80101206:	e8 25 0d 00 00       	call   80101f30 <stati>
8010120b:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010120e:	8b 45 08             	mov    0x8(%ebp),%eax
80101211:	8b 40 10             	mov    0x10(%eax),%eax
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	50                   	push   %eax
80101218:	e8 49 09 00 00       	call   80101b66 <iunlock>
8010121d:	83 c4 10             	add    $0x10,%esp
    return 0;
80101220:	b8 00 00 00 00       	mov    $0x0,%eax
80101225:	eb 05                	jmp    8010122c <filestat+0x55>
  }
  return -1;
80101227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010122c:	c9                   	leave  
8010122d:	c3                   	ret    

8010122e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010122e:	55                   	push   %ebp
8010122f:	89 e5                	mov    %esp,%ebp
80101231:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010123b:	84 c0                	test   %al,%al
8010123d:	75 0a                	jne    80101249 <fileread+0x1b>
    return -1;
8010123f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101244:	e9 9b 00 00 00       	jmp    801012e4 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 00                	mov    (%eax),%eax
8010124e:	83 f8 01             	cmp    $0x1,%eax
80101251:	75 1a                	jne    8010126d <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 40 0c             	mov    0xc(%eax),%eax
80101259:	83 ec 04             	sub    $0x4,%esp
8010125c:	ff 75 10             	pushl  0x10(%ebp)
8010125f:	ff 75 0c             	pushl  0xc(%ebp)
80101262:	50                   	push   %eax
80101263:	e8 72 31 00 00       	call   801043da <piperead>
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	eb 77                	jmp    801012e4 <fileread+0xb6>
  if(f->type == FD_INODE){
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 00                	mov    (%eax),%eax
80101272:	83 f8 02             	cmp    $0x2,%eax
80101275:	75 60                	jne    801012d7 <fileread+0xa9>
    ilock(f->ip);
80101277:	8b 45 08             	mov    0x8(%ebp),%eax
8010127a:	8b 40 10             	mov    0x10(%eax),%eax
8010127d:	83 ec 0c             	sub    $0xc,%esp
80101280:	50                   	push   %eax
80101281:	e8 82 07 00 00       	call   80101a08 <ilock>
80101286:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101289:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 50 14             	mov    0x14(%eax),%edx
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	8b 40 10             	mov    0x10(%eax),%eax
80101298:	51                   	push   %ecx
80101299:	52                   	push   %edx
8010129a:	ff 75 0c             	pushl  0xc(%ebp)
8010129d:	50                   	push   %eax
8010129e:	e8 d3 0c 00 00       	call   80101f76 <readi>
801012a3:	83 c4 10             	add    $0x10,%esp
801012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012ad:	7e 11                	jle    801012c0 <fileread+0x92>
      f->off += r;
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	8b 50 14             	mov    0x14(%eax),%edx
801012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b8:	01 c2                	add    %eax,%edx
801012ba:	8b 45 08             	mov    0x8(%ebp),%eax
801012bd:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	50                   	push   %eax
801012ca:	e8 97 08 00 00       	call   80101b66 <iunlock>
801012cf:	83 c4 10             	add    $0x10,%esp
    return r;
801012d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d5:	eb 0d                	jmp    801012e4 <fileread+0xb6>
  }
  panic("fileread");
801012d7:	83 ec 0c             	sub    $0xc,%esp
801012da:	68 1f 96 10 80       	push   $0x8010961f
801012df:	e8 82 f2 ff ff       	call   80100566 <panic>
}
801012e4:	c9                   	leave  
801012e5:	c3                   	ret    

801012e6 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012e6:	55                   	push   %ebp
801012e7:	89 e5                	mov    %esp,%ebp
801012e9:	53                   	push   %ebx
801012ea:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012ed:	8b 45 08             	mov    0x8(%ebp),%eax
801012f0:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012f4:	84 c0                	test   %al,%al
801012f6:	75 0a                	jne    80101302 <filewrite+0x1c>
    return -1;
801012f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012fd:	e9 1b 01 00 00       	jmp    8010141d <filewrite+0x137>
  if(f->type == FD_PIPE)
80101302:	8b 45 08             	mov    0x8(%ebp),%eax
80101305:	8b 00                	mov    (%eax),%eax
80101307:	83 f8 01             	cmp    $0x1,%eax
8010130a:	75 1d                	jne    80101329 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 40 0c             	mov    0xc(%eax),%eax
80101312:	83 ec 04             	sub    $0x4,%esp
80101315:	ff 75 10             	pushl  0x10(%ebp)
80101318:	ff 75 0c             	pushl  0xc(%ebp)
8010131b:	50                   	push   %eax
8010131c:	e8 bb 2f 00 00       	call   801042dc <pipewrite>
80101321:	83 c4 10             	add    $0x10,%esp
80101324:	e9 f4 00 00 00       	jmp    8010141d <filewrite+0x137>
  if(f->type == FD_INODE){
80101329:	8b 45 08             	mov    0x8(%ebp),%eax
8010132c:	8b 00                	mov    (%eax),%eax
8010132e:	83 f8 02             	cmp    $0x2,%eax
80101331:	0f 85 d9 00 00 00    	jne    80101410 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101337:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010133e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101345:	e9 a3 00 00 00       	jmp    801013ed <filewrite+0x107>
      int n1 = n - i;
8010134a:	8b 45 10             	mov    0x10(%ebp),%eax
8010134d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101350:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101356:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101359:	7e 06                	jle    80101361 <filewrite+0x7b>
        n1 = max;
8010135b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010135e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101361:	e8 85 22 00 00       	call   801035eb <begin_op>
      ilock(f->ip);
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 40 10             	mov    0x10(%eax),%eax
8010136c:	83 ec 0c             	sub    $0xc,%esp
8010136f:	50                   	push   %eax
80101370:	e8 93 06 00 00       	call   80101a08 <ilock>
80101375:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101378:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010137b:	8b 45 08             	mov    0x8(%ebp),%eax
8010137e:	8b 50 14             	mov    0x14(%eax),%edx
80101381:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101384:	8b 45 0c             	mov    0xc(%ebp),%eax
80101387:	01 c3                	add    %eax,%ebx
80101389:	8b 45 08             	mov    0x8(%ebp),%eax
8010138c:	8b 40 10             	mov    0x10(%eax),%eax
8010138f:	51                   	push   %ecx
80101390:	52                   	push   %edx
80101391:	53                   	push   %ebx
80101392:	50                   	push   %eax
80101393:	e8 35 0d 00 00       	call   801020cd <writei>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010139e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a2:	7e 11                	jle    801013b5 <filewrite+0xcf>
        f->off += r;
801013a4:	8b 45 08             	mov    0x8(%ebp),%eax
801013a7:	8b 50 14             	mov    0x14(%eax),%edx
801013aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ad:	01 c2                	add    %eax,%edx
801013af:	8b 45 08             	mov    0x8(%ebp),%eax
801013b2:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013b5:	8b 45 08             	mov    0x8(%ebp),%eax
801013b8:	8b 40 10             	mov    0x10(%eax),%eax
801013bb:	83 ec 0c             	sub    $0xc,%esp
801013be:	50                   	push   %eax
801013bf:	e8 a2 07 00 00       	call   80101b66 <iunlock>
801013c4:	83 c4 10             	add    $0x10,%esp
      end_op();
801013c7:	e8 ab 22 00 00       	call   80103677 <end_op>

      if(r < 0)
801013cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d0:	78 29                	js     801013fb <filewrite+0x115>
        break;
      if(r != n1)
801013d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013d8:	74 0d                	je     801013e7 <filewrite+0x101>
        panic("short filewrite");
801013da:	83 ec 0c             	sub    $0xc,%esp
801013dd:	68 28 96 10 80       	push   $0x80109628
801013e2:	e8 7f f1 ff ff       	call   80100566 <panic>
      i += r;
801013e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ea:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f0:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f3:	0f 8c 51 ff ff ff    	jl     8010134a <filewrite+0x64>
801013f9:	eb 01                	jmp    801013fc <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013fb:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ff:	3b 45 10             	cmp    0x10(%ebp),%eax
80101402:	75 05                	jne    80101409 <filewrite+0x123>
80101404:	8b 45 10             	mov    0x10(%ebp),%eax
80101407:	eb 14                	jmp    8010141d <filewrite+0x137>
80101409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010140e:	eb 0d                	jmp    8010141d <filewrite+0x137>
  }
  panic("filewrite");
80101410:	83 ec 0c             	sub    $0xc,%esp
80101413:	68 38 96 10 80       	push   $0x80109638
80101418:	e8 49 f1 ff ff       	call   80100566 <panic>
}
8010141d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101420:	c9                   	leave  
80101421:	c3                   	ret    

80101422 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101422:	55                   	push   %ebp
80101423:	89 e5                	mov    %esp,%ebp
80101425:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	83 ec 08             	sub    $0x8,%esp
8010142e:	6a 01                	push   $0x1
80101430:	50                   	push   %eax
80101431:	e8 80 ed ff ff       	call   801001b6 <bread>
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010143f:	83 c0 18             	add    $0x18,%eax
80101442:	83 ec 04             	sub    $0x4,%esp
80101445:	6a 1c                	push   $0x1c
80101447:	50                   	push   %eax
80101448:	ff 75 0c             	pushl  0xc(%ebp)
8010144b:	e8 d3 4d 00 00       	call   80106223 <memmove>
80101450:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	ff 75 f4             	pushl  -0xc(%ebp)
80101459:	e8 d0 ed ff ff       	call   8010022e <brelse>
8010145e:	83 c4 10             	add    $0x10,%esp
}
80101461:	90                   	nop
80101462:	c9                   	leave  
80101463:	c3                   	ret    

80101464 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010146a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010146d:	8b 45 08             	mov    0x8(%ebp),%eax
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	52                   	push   %edx
80101474:	50                   	push   %eax
80101475:	e8 3c ed ff ff       	call   801001b6 <bread>
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101483:	83 c0 18             	add    $0x18,%eax
80101486:	83 ec 04             	sub    $0x4,%esp
80101489:	68 00 02 00 00       	push   $0x200
8010148e:	6a 00                	push   $0x0
80101490:	50                   	push   %eax
80101491:	e8 ce 4c 00 00       	call   80106164 <memset>
80101496:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101499:	83 ec 0c             	sub    $0xc,%esp
8010149c:	ff 75 f4             	pushl  -0xc(%ebp)
8010149f:	e8 7f 23 00 00       	call   80103823 <log_write>
801014a4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014a7:	83 ec 0c             	sub    $0xc,%esp
801014aa:	ff 75 f4             	pushl  -0xc(%ebp)
801014ad:	e8 7c ed ff ff       	call   8010022e <brelse>
801014b2:	83 c4 10             	add    $0x10,%esp
}
801014b5:	90                   	nop
801014b6:	c9                   	leave  
801014b7:	c3                   	ret    

801014b8 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014b8:	55                   	push   %ebp
801014b9:	89 e5                	mov    %esp,%ebp
801014bb:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014cc:	e9 13 01 00 00       	jmp    801015e4 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014da:	85 c0                	test   %eax,%eax
801014dc:	0f 48 c2             	cmovs  %edx,%eax
801014df:	c1 f8 0c             	sar    $0xc,%eax
801014e2:	89 c2                	mov    %eax,%edx
801014e4:	a1 58 22 11 80       	mov    0x80112258,%eax
801014e9:	01 d0                	add    %edx,%eax
801014eb:	83 ec 08             	sub    $0x8,%esp
801014ee:	50                   	push   %eax
801014ef:	ff 75 08             	pushl  0x8(%ebp)
801014f2:	e8 bf ec ff ff       	call   801001b6 <bread>
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101504:	e9 a6 00 00 00       	jmp    801015af <balloc+0xf7>
      m = 1 << (bi % 8);
80101509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150c:	99                   	cltd   
8010150d:	c1 ea 1d             	shr    $0x1d,%edx
80101510:	01 d0                	add    %edx,%eax
80101512:	83 e0 07             	and    $0x7,%eax
80101515:	29 d0                	sub    %edx,%eax
80101517:	ba 01 00 00 00       	mov    $0x1,%edx
8010151c:	89 c1                	mov    %eax,%ecx
8010151e:	d3 e2                	shl    %cl,%edx
80101520:	89 d0                	mov    %edx,%eax
80101522:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101528:	8d 50 07             	lea    0x7(%eax),%edx
8010152b:	85 c0                	test   %eax,%eax
8010152d:	0f 48 c2             	cmovs  %edx,%eax
80101530:	c1 f8 03             	sar    $0x3,%eax
80101533:	89 c2                	mov    %eax,%edx
80101535:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101538:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010153d:	0f b6 c0             	movzbl %al,%eax
80101540:	23 45 e8             	and    -0x18(%ebp),%eax
80101543:	85 c0                	test   %eax,%eax
80101545:	75 64                	jne    801015ab <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154a:	8d 50 07             	lea    0x7(%eax),%edx
8010154d:	85 c0                	test   %eax,%eax
8010154f:	0f 48 c2             	cmovs  %edx,%eax
80101552:	c1 f8 03             	sar    $0x3,%eax
80101555:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101558:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010155d:	89 d1                	mov    %edx,%ecx
8010155f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101562:	09 ca                	or     %ecx,%edx
80101564:	89 d1                	mov    %edx,%ecx
80101566:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101569:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010156d:	83 ec 0c             	sub    $0xc,%esp
80101570:	ff 75 ec             	pushl  -0x14(%ebp)
80101573:	e8 ab 22 00 00       	call   80103823 <log_write>
80101578:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010157b:	83 ec 0c             	sub    $0xc,%esp
8010157e:	ff 75 ec             	pushl  -0x14(%ebp)
80101581:	e8 a8 ec ff ff       	call   8010022e <brelse>
80101586:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158f:	01 c2                	add    %eax,%edx
80101591:	8b 45 08             	mov    0x8(%ebp),%eax
80101594:	83 ec 08             	sub    $0x8,%esp
80101597:	52                   	push   %edx
80101598:	50                   	push   %eax
80101599:	e8 c6 fe ff ff       	call   80101464 <bzero>
8010159e:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a7:	01 d0                	add    %edx,%eax
801015a9:	eb 57                	jmp    80101602 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015af:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015b6:	7f 17                	jg     801015cf <balloc+0x117>
801015b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015be:	01 d0                	add    %edx,%eax
801015c0:	89 c2                	mov    %eax,%edx
801015c2:	a1 40 22 11 80       	mov    0x80112240,%eax
801015c7:	39 c2                	cmp    %eax,%edx
801015c9:	0f 82 3a ff ff ff    	jb     80101509 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015cf:	83 ec 0c             	sub    $0xc,%esp
801015d2:	ff 75 ec             	pushl  -0x14(%ebp)
801015d5:	e8 54 ec ff ff       	call   8010022e <brelse>
801015da:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015dd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015e4:	8b 15 40 22 11 80    	mov    0x80112240,%edx
801015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ed:	39 c2                	cmp    %eax,%edx
801015ef:	0f 87 dc fe ff ff    	ja     801014d1 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015f5:	83 ec 0c             	sub    $0xc,%esp
801015f8:	68 44 96 10 80       	push   $0x80109644
801015fd:	e8 64 ef ff ff       	call   80100566 <panic>
}
80101602:	c9                   	leave  
80101603:	c3                   	ret    

80101604 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010160a:	83 ec 08             	sub    $0x8,%esp
8010160d:	68 40 22 11 80       	push   $0x80112240
80101612:	ff 75 08             	pushl  0x8(%ebp)
80101615:	e8 08 fe ff ff       	call   80101422 <readsb>
8010161a:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010161d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101620:	c1 e8 0c             	shr    $0xc,%eax
80101623:	89 c2                	mov    %eax,%edx
80101625:	a1 58 22 11 80       	mov    0x80112258,%eax
8010162a:	01 c2                	add    %eax,%edx
8010162c:	8b 45 08             	mov    0x8(%ebp),%eax
8010162f:	83 ec 08             	sub    $0x8,%esp
80101632:	52                   	push   %edx
80101633:	50                   	push   %eax
80101634:	e8 7d eb ff ff       	call   801001b6 <bread>
80101639:	83 c4 10             	add    $0x10,%esp
8010163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010163f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101642:	25 ff 0f 00 00       	and    $0xfff,%eax
80101647:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164d:	99                   	cltd   
8010164e:	c1 ea 1d             	shr    $0x1d,%edx
80101651:	01 d0                	add    %edx,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	29 d0                	sub    %edx,%eax
80101658:	ba 01 00 00 00       	mov    $0x1,%edx
8010165d:	89 c1                	mov    %eax,%ecx
8010165f:	d3 e2                	shl    %cl,%edx
80101661:	89 d0                	mov    %edx,%eax
80101663:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101669:	8d 50 07             	lea    0x7(%eax),%edx
8010166c:	85 c0                	test   %eax,%eax
8010166e:	0f 48 c2             	cmovs  %edx,%eax
80101671:	c1 f8 03             	sar    $0x3,%eax
80101674:	89 c2                	mov    %eax,%edx
80101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101679:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010167e:	0f b6 c0             	movzbl %al,%eax
80101681:	23 45 ec             	and    -0x14(%ebp),%eax
80101684:	85 c0                	test   %eax,%eax
80101686:	75 0d                	jne    80101695 <bfree+0x91>
    panic("freeing free block");
80101688:	83 ec 0c             	sub    $0xc,%esp
8010168b:	68 5a 96 10 80       	push   $0x8010965a
80101690:	e8 d1 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101695:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101698:	8d 50 07             	lea    0x7(%eax),%edx
8010169b:	85 c0                	test   %eax,%eax
8010169d:	0f 48 c2             	cmovs  %edx,%eax
801016a0:	c1 f8 03             	sar    $0x3,%eax
801016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016ab:	89 d1                	mov    %edx,%ecx
801016ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016b0:	f7 d2                	not    %edx
801016b2:	21 ca                	and    %ecx,%edx
801016b4:	89 d1                	mov    %edx,%ecx
801016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b9:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016bd:	83 ec 0c             	sub    $0xc,%esp
801016c0:	ff 75 f4             	pushl  -0xc(%ebp)
801016c3:	e8 5b 21 00 00       	call   80103823 <log_write>
801016c8:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016cb:	83 ec 0c             	sub    $0xc,%esp
801016ce:	ff 75 f4             	pushl  -0xc(%ebp)
801016d1:	e8 58 eb ff ff       	call   8010022e <brelse>
801016d6:	83 c4 10             	add    $0x10,%esp
}
801016d9:	90                   	nop
801016da:	c9                   	leave  
801016db:	c3                   	ret    

801016dc <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016dc:	55                   	push   %ebp
801016dd:	89 e5                	mov    %esp,%ebp
801016df:	57                   	push   %edi
801016e0:	56                   	push   %esi
801016e1:	53                   	push   %ebx
801016e2:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016e5:	83 ec 08             	sub    $0x8,%esp
801016e8:	68 6d 96 10 80       	push   $0x8010966d
801016ed:	68 60 22 11 80       	push   $0x80112260
801016f2:	e8 e8 47 00 00       	call   80105edf <initlock>
801016f7:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016fa:	83 ec 08             	sub    $0x8,%esp
801016fd:	68 40 22 11 80       	push   $0x80112240
80101702:	ff 75 08             	pushl  0x8(%ebp)
80101705:	e8 18 fd ff ff       	call   80101422 <readsb>
8010170a:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010170d:	a1 58 22 11 80       	mov    0x80112258,%eax
80101712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101715:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
8010171b:	8b 35 50 22 11 80    	mov    0x80112250,%esi
80101721:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
80101727:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
8010172d:	8b 15 44 22 11 80    	mov    0x80112244,%edx
80101733:	a1 40 22 11 80       	mov    0x80112240,%eax
80101738:	ff 75 e4             	pushl  -0x1c(%ebp)
8010173b:	57                   	push   %edi
8010173c:	56                   	push   %esi
8010173d:	53                   	push   %ebx
8010173e:	51                   	push   %ecx
8010173f:	52                   	push   %edx
80101740:	50                   	push   %eax
80101741:	68 74 96 10 80       	push   $0x80109674
80101746:	e8 7b ec ff ff       	call   801003c6 <cprintf>
8010174b:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010174e:	90                   	nop
8010174f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101752:	5b                   	pop    %ebx
80101753:	5e                   	pop    %esi
80101754:	5f                   	pop    %edi
80101755:	5d                   	pop    %ebp
80101756:	c3                   	ret    

80101757 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101757:	55                   	push   %ebp
80101758:	89 e5                	mov    %esp,%ebp
8010175a:	83 ec 28             	sub    $0x28,%esp
8010175d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101760:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101764:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010176b:	e9 9e 00 00 00       	jmp    8010180e <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101773:	c1 e8 03             	shr    $0x3,%eax
80101776:	89 c2                	mov    %eax,%edx
80101778:	a1 54 22 11 80       	mov    0x80112254,%eax
8010177d:	01 d0                	add    %edx,%eax
8010177f:	83 ec 08             	sub    $0x8,%esp
80101782:	50                   	push   %eax
80101783:	ff 75 08             	pushl  0x8(%ebp)
80101786:	e8 2b ea ff ff       	call   801001b6 <bread>
8010178b:	83 c4 10             	add    $0x10,%esp
8010178e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101794:	8d 50 18             	lea    0x18(%eax),%edx
80101797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179a:	83 e0 07             	and    $0x7,%eax
8010179d:	c1 e0 06             	shl    $0x6,%eax
801017a0:	01 d0                	add    %edx,%eax
801017a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a8:	0f b7 00             	movzwl (%eax),%eax
801017ab:	66 85 c0             	test   %ax,%ax
801017ae:	75 4c                	jne    801017fc <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b0:	83 ec 04             	sub    $0x4,%esp
801017b3:	6a 40                	push   $0x40
801017b5:	6a 00                	push   $0x0
801017b7:	ff 75 ec             	pushl  -0x14(%ebp)
801017ba:	e8 a5 49 00 00       	call   80106164 <memset>
801017bf:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017c5:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017c9:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017cc:	83 ec 0c             	sub    $0xc,%esp
801017cf:	ff 75 f0             	pushl  -0x10(%ebp)
801017d2:	e8 4c 20 00 00       	call   80103823 <log_write>
801017d7:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	ff 75 f0             	pushl  -0x10(%ebp)
801017e0:	e8 49 ea ff ff       	call   8010022e <brelse>
801017e5:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017eb:	83 ec 08             	sub    $0x8,%esp
801017ee:	50                   	push   %eax
801017ef:	ff 75 08             	pushl  0x8(%ebp)
801017f2:	e8 f8 00 00 00       	call   801018ef <iget>
801017f7:	83 c4 10             	add    $0x10,%esp
801017fa:	eb 30                	jmp    8010182c <ialloc+0xd5>
    }
    brelse(bp);
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	ff 75 f0             	pushl  -0x10(%ebp)
80101802:	e8 27 ea ff ff       	call   8010022e <brelse>
80101807:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010180a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010180e:	8b 15 48 22 11 80    	mov    0x80112248,%edx
80101814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101817:	39 c2                	cmp    %eax,%edx
80101819:	0f 87 51 ff ff ff    	ja     80101770 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	68 c7 96 10 80       	push   $0x801096c7
80101827:	e8 3a ed ff ff       	call   80100566 <panic>
}
8010182c:	c9                   	leave  
8010182d:	c3                   	ret    

8010182e <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010182e:	55                   	push   %ebp
8010182f:	89 e5                	mov    %esp,%ebp
80101831:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101834:	8b 45 08             	mov    0x8(%ebp),%eax
80101837:	8b 40 04             	mov    0x4(%eax),%eax
8010183a:	c1 e8 03             	shr    $0x3,%eax
8010183d:	89 c2                	mov    %eax,%edx
8010183f:	a1 54 22 11 80       	mov    0x80112254,%eax
80101844:	01 c2                	add    %eax,%edx
80101846:	8b 45 08             	mov    0x8(%ebp),%eax
80101849:	8b 00                	mov    (%eax),%eax
8010184b:	83 ec 08             	sub    $0x8,%esp
8010184e:	52                   	push   %edx
8010184f:	50                   	push   %eax
80101850:	e8 61 e9 ff ff       	call   801001b6 <bread>
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185e:	8d 50 18             	lea    0x18(%eax),%edx
80101861:	8b 45 08             	mov    0x8(%ebp),%eax
80101864:	8b 40 04             	mov    0x4(%eax),%eax
80101867:	83 e0 07             	and    $0x7,%eax
8010186a:	c1 e0 06             	shl    $0x6,%eax
8010186d:	01 d0                	add    %edx,%eax
8010186f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101872:	8b 45 08             	mov    0x8(%ebp),%eax
80101875:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101879:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101889:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010188d:	8b 45 08             	mov    0x8(%ebp),%eax
80101890:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101897:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010189b:	8b 45 08             	mov    0x8(%ebp),%eax
8010189e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a5:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	8b 50 18             	mov    0x18(%eax),%edx
801018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018b5:	8b 45 08             	mov    0x8(%ebp),%eax
801018b8:	8d 50 1c             	lea    0x1c(%eax),%edx
801018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018be:	83 c0 0c             	add    $0xc,%eax
801018c1:	83 ec 04             	sub    $0x4,%esp
801018c4:	6a 34                	push   $0x34
801018c6:	52                   	push   %edx
801018c7:	50                   	push   %eax
801018c8:	e8 56 49 00 00       	call   80106223 <memmove>
801018cd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d0:	83 ec 0c             	sub    $0xc,%esp
801018d3:	ff 75 f4             	pushl  -0xc(%ebp)
801018d6:	e8 48 1f 00 00       	call   80103823 <log_write>
801018db:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 f4             	pushl  -0xc(%ebp)
801018e4:	e8 45 e9 ff ff       	call   8010022e <brelse>
801018e9:	83 c4 10             	add    $0x10,%esp
}
801018ec:	90                   	nop
801018ed:	c9                   	leave  
801018ee:	c3                   	ret    

801018ef <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018ef:	55                   	push   %ebp
801018f0:	89 e5                	mov    %esp,%ebp
801018f2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018f5:	83 ec 0c             	sub    $0xc,%esp
801018f8:	68 60 22 11 80       	push   $0x80112260
801018fd:	e8 ff 45 00 00       	call   80105f01 <acquire>
80101902:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101905:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010190c:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80101913:	eb 5d                	jmp    80101972 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101918:	8b 40 08             	mov    0x8(%eax),%eax
8010191b:	85 c0                	test   %eax,%eax
8010191d:	7e 39                	jle    80101958 <iget+0x69>
8010191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101922:	8b 00                	mov    (%eax),%eax
80101924:	3b 45 08             	cmp    0x8(%ebp),%eax
80101927:	75 2f                	jne    80101958 <iget+0x69>
80101929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192c:	8b 40 04             	mov    0x4(%eax),%eax
8010192f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101932:	75 24                	jne    80101958 <iget+0x69>
      ip->ref++;
80101934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101937:	8b 40 08             	mov    0x8(%eax),%eax
8010193a:	8d 50 01             	lea    0x1(%eax),%edx
8010193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101940:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	68 60 22 11 80       	push   $0x80112260
8010194b:	e8 18 46 00 00       	call   80105f68 <release>
80101950:	83 c4 10             	add    $0x10,%esp
      return ip;
80101953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101956:	eb 74                	jmp    801019cc <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010195c:	75 10                	jne    8010196e <iget+0x7f>
8010195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101961:	8b 40 08             	mov    0x8(%eax),%eax
80101964:	85 c0                	test   %eax,%eax
80101966:	75 06                	jne    8010196e <iget+0x7f>
      empty = ip;
80101968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010196e:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101972:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101979:	72 9a                	jb     80101915 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010197b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010197f:	75 0d                	jne    8010198e <iget+0x9f>
    panic("iget: no inodes");
80101981:	83 ec 0c             	sub    $0xc,%esp
80101984:	68 d9 96 10 80       	push   $0x801096d9
80101989:	e8 d8 eb ff ff       	call   80100566 <panic>

  ip = empty;
8010198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101991:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101997:	8b 55 08             	mov    0x8(%ebp),%edx
8010199a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199f:	8b 55 0c             	mov    0xc(%ebp),%edx
801019a2:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019b9:	83 ec 0c             	sub    $0xc,%esp
801019bc:	68 60 22 11 80       	push   $0x80112260
801019c1:	e8 a2 45 00 00       	call   80105f68 <release>
801019c6:	83 c4 10             	add    $0x10,%esp

  return ip;
801019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019cc:	c9                   	leave  
801019cd:	c3                   	ret    

801019ce <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019ce:	55                   	push   %ebp
801019cf:	89 e5                	mov    %esp,%ebp
801019d1:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 60 22 11 80       	push   $0x80112260
801019dc:	e8 20 45 00 00       	call   80105f01 <acquire>
801019e1:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019e4:	8b 45 08             	mov    0x8(%ebp),%eax
801019e7:	8b 40 08             	mov    0x8(%eax),%eax
801019ea:	8d 50 01             	lea    0x1(%eax),%edx
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019f3:	83 ec 0c             	sub    $0xc,%esp
801019f6:	68 60 22 11 80       	push   $0x80112260
801019fb:	e8 68 45 00 00       	call   80105f68 <release>
80101a00:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a06:	c9                   	leave  
80101a07:	c3                   	ret    

80101a08 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a08:	55                   	push   %ebp
80101a09:	89 e5                	mov    %esp,%ebp
80101a0b:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a12:	74 0a                	je     80101a1e <ilock+0x16>
80101a14:	8b 45 08             	mov    0x8(%ebp),%eax
80101a17:	8b 40 08             	mov    0x8(%eax),%eax
80101a1a:	85 c0                	test   %eax,%eax
80101a1c:	7f 0d                	jg     80101a2b <ilock+0x23>
    panic("ilock");
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	68 e9 96 10 80       	push   $0x801096e9
80101a26:	e8 3b eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a2b:	83 ec 0c             	sub    $0xc,%esp
80101a2e:	68 60 22 11 80       	push   $0x80112260
80101a33:	e8 c9 44 00 00       	call   80105f01 <acquire>
80101a38:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a3b:	eb 13                	jmp    80101a50 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a3d:	83 ec 08             	sub    $0x8,%esp
80101a40:	68 60 22 11 80       	push   $0x80112260
80101a45:	ff 75 08             	pushl  0x8(%ebp)
80101a48:	e8 b0 38 00 00       	call   801052fd <sleep>
80101a4d:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a50:	8b 45 08             	mov    0x8(%ebp),%eax
80101a53:	8b 40 0c             	mov    0xc(%eax),%eax
80101a56:	83 e0 01             	and    $0x1,%eax
80101a59:	85 c0                	test   %eax,%eax
80101a5b:	75 e0                	jne    80101a3d <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 c8 01             	or     $0x1,%eax
80101a66:	89 c2                	mov    %eax,%edx
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a6e:	83 ec 0c             	sub    $0xc,%esp
80101a71:	68 60 22 11 80       	push   $0x80112260
80101a76:	e8 ed 44 00 00       	call   80105f68 <release>
80101a7b:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a81:	8b 40 0c             	mov    0xc(%eax),%eax
80101a84:	83 e0 02             	and    $0x2,%eax
80101a87:	85 c0                	test   %eax,%eax
80101a89:	0f 85 d4 00 00 00    	jne    80101b63 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	8b 40 04             	mov    0x4(%eax),%eax
80101a95:	c1 e8 03             	shr    $0x3,%eax
80101a98:	89 c2                	mov    %eax,%edx
80101a9a:	a1 54 22 11 80       	mov    0x80112254,%eax
80101a9f:	01 c2                	add    %eax,%edx
80101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa4:	8b 00                	mov    (%eax),%eax
80101aa6:	83 ec 08             	sub    $0x8,%esp
80101aa9:	52                   	push   %edx
80101aaa:	50                   	push   %eax
80101aab:	e8 06 e7 ff ff       	call   801001b6 <bread>
80101ab0:	83 c4 10             	add    $0x10,%esp
80101ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab9:	8d 50 18             	lea    0x18(%eax),%edx
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 40 04             	mov    0x4(%eax),%eax
80101ac2:	83 e0 07             	and    $0x7,%eax
80101ac5:	c1 e0 06             	shl    $0x6,%eax
80101ac8:	01 d0                	add    %edx,%eax
80101aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad0:	0f b7 10             	movzwl (%eax),%edx
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101add:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aeb:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b07:	8b 50 08             	mov    0x8(%eax),%edx
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b13:	8d 50 0c             	lea    0xc(%eax),%edx
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	83 c0 1c             	add    $0x1c,%eax
80101b1c:	83 ec 04             	sub    $0x4,%esp
80101b1f:	6a 34                	push   $0x34
80101b21:	52                   	push   %edx
80101b22:	50                   	push   %eax
80101b23:	e8 fb 46 00 00       	call   80106223 <memmove>
80101b28:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b2b:	83 ec 0c             	sub    $0xc,%esp
80101b2e:	ff 75 f4             	pushl  -0xc(%ebp)
80101b31:	e8 f8 e6 ff ff       	call   8010022e <brelse>
80101b36:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3f:	83 c8 02             	or     $0x2,%eax
80101b42:	89 c2                	mov    %eax,%edx
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b51:	66 85 c0             	test   %ax,%ax
80101b54:	75 0d                	jne    80101b63 <ilock+0x15b>
      panic("ilock: no type");
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	68 ef 96 10 80       	push   $0x801096ef
80101b5e:	e8 03 ea ff ff       	call   80100566 <panic>
  }
}
80101b63:	90                   	nop
80101b64:	c9                   	leave  
80101b65:	c3                   	ret    

80101b66 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b66:	55                   	push   %ebp
80101b67:	89 e5                	mov    %esp,%ebp
80101b69:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b70:	74 17                	je     80101b89 <iunlock+0x23>
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	8b 40 0c             	mov    0xc(%eax),%eax
80101b78:	83 e0 01             	and    $0x1,%eax
80101b7b:	85 c0                	test   %eax,%eax
80101b7d:	74 0a                	je     80101b89 <iunlock+0x23>
80101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b82:	8b 40 08             	mov    0x8(%eax),%eax
80101b85:	85 c0                	test   %eax,%eax
80101b87:	7f 0d                	jg     80101b96 <iunlock+0x30>
    panic("iunlock");
80101b89:	83 ec 0c             	sub    $0xc,%esp
80101b8c:	68 fe 96 10 80       	push   $0x801096fe
80101b91:	e8 d0 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	68 60 22 11 80       	push   $0x80112260
80101b9e:	e8 5e 43 00 00       	call   80105f01 <acquire>
80101ba3:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 40 0c             	mov    0xc(%eax),%eax
80101bac:	83 e0 fe             	and    $0xfffffffe,%eax
80101baf:	89 c2                	mov    %eax,%edx
80101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb4:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bb7:	83 ec 0c             	sub    $0xc,%esp
80101bba:	ff 75 08             	pushl  0x8(%ebp)
80101bbd:	e8 ef 38 00 00       	call   801054b1 <wakeup>
80101bc2:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bc5:	83 ec 0c             	sub    $0xc,%esp
80101bc8:	68 60 22 11 80       	push   $0x80112260
80101bcd:	e8 96 43 00 00       	call   80105f68 <release>
80101bd2:	83 c4 10             	add    $0x10,%esp
}
80101bd5:	90                   	nop
80101bd6:	c9                   	leave  
80101bd7:	c3                   	ret    

80101bd8 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bd8:	55                   	push   %ebp
80101bd9:	89 e5                	mov    %esp,%ebp
80101bdb:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bde:	83 ec 0c             	sub    $0xc,%esp
80101be1:	68 60 22 11 80       	push   $0x80112260
80101be6:	e8 16 43 00 00       	call   80105f01 <acquire>
80101beb:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bee:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf1:	8b 40 08             	mov    0x8(%eax),%eax
80101bf4:	83 f8 01             	cmp    $0x1,%eax
80101bf7:	0f 85 a9 00 00 00    	jne    80101ca6 <iput+0xce>
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	8b 40 0c             	mov    0xc(%eax),%eax
80101c03:	83 e0 02             	and    $0x2,%eax
80101c06:	85 c0                	test   %eax,%eax
80101c08:	0f 84 98 00 00 00    	je     80101ca6 <iput+0xce>
80101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c11:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c15:	66 85 c0             	test   %ax,%ax
80101c18:	0f 85 88 00 00 00    	jne    80101ca6 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 40 0c             	mov    0xc(%eax),%eax
80101c24:	83 e0 01             	and    $0x1,%eax
80101c27:	85 c0                	test   %eax,%eax
80101c29:	74 0d                	je     80101c38 <iput+0x60>
      panic("iput busy");
80101c2b:	83 ec 0c             	sub    $0xc,%esp
80101c2e:	68 06 97 10 80       	push   $0x80109706
80101c33:	e8 2e e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	8b 40 0c             	mov    0xc(%eax),%eax
80101c3e:	83 c8 01             	or     $0x1,%eax
80101c41:	89 c2                	mov    %eax,%edx
80101c43:	8b 45 08             	mov    0x8(%ebp),%eax
80101c46:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c49:	83 ec 0c             	sub    $0xc,%esp
80101c4c:	68 60 22 11 80       	push   $0x80112260
80101c51:	e8 12 43 00 00       	call   80105f68 <release>
80101c56:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c59:	83 ec 0c             	sub    $0xc,%esp
80101c5c:	ff 75 08             	pushl  0x8(%ebp)
80101c5f:	e8 a8 01 00 00       	call   80101e0c <itrunc>
80101c64:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c67:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6a:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c70:	83 ec 0c             	sub    $0xc,%esp
80101c73:	ff 75 08             	pushl  0x8(%ebp)
80101c76:	e8 b3 fb ff ff       	call   8010182e <iupdate>
80101c7b:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	68 60 22 11 80       	push   $0x80112260
80101c86:	e8 76 42 00 00       	call   80105f01 <acquire>
80101c8b:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	ff 75 08             	pushl  0x8(%ebp)
80101c9e:	e8 0e 38 00 00       	call   801054b1 <wakeup>
80101ca3:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca9:	8b 40 08             	mov    0x8(%eax),%eax
80101cac:	8d 50 ff             	lea    -0x1(%eax),%edx
80101caf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cb5:	83 ec 0c             	sub    $0xc,%esp
80101cb8:	68 60 22 11 80       	push   $0x80112260
80101cbd:	e8 a6 42 00 00       	call   80105f68 <release>
80101cc2:	83 c4 10             	add    $0x10,%esp
}
80101cc5:	90                   	nop
80101cc6:	c9                   	leave  
80101cc7:	c3                   	ret    

80101cc8 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cc8:	55                   	push   %ebp
80101cc9:	89 e5                	mov    %esp,%ebp
80101ccb:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cce:	83 ec 0c             	sub    $0xc,%esp
80101cd1:	ff 75 08             	pushl  0x8(%ebp)
80101cd4:	e8 8d fe ff ff       	call   80101b66 <iunlock>
80101cd9:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	ff 75 08             	pushl  0x8(%ebp)
80101ce2:	e8 f1 fe ff ff       	call   80101bd8 <iput>
80101ce7:	83 c4 10             	add    $0x10,%esp
}
80101cea:	90                   	nop
80101ceb:	c9                   	leave  
80101cec:	c3                   	ret    

80101ced <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ced:	55                   	push   %ebp
80101cee:	89 e5                	mov    %esp,%ebp
80101cf0:	53                   	push   %ebx
80101cf1:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cf4:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cf8:	77 42                	ja     80101d3c <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d00:	83 c2 04             	add    $0x4,%edx
80101d03:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d0e:	75 24                	jne    80101d34 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 00                	mov    (%eax),%eax
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	50                   	push   %eax
80101d19:	e8 9a f7 ff ff       	call   801014b8 <balloc>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d2a:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d30:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d37:	e9 cb 00 00 00       	jmp    80101e07 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d3c:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d40:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d44:	0f 87 b0 00 00 00    	ja     80101dfa <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d57:	75 1d                	jne    80101d76 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d59:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5c:	8b 00                	mov    (%eax),%eax
80101d5e:	83 ec 0c             	sub    $0xc,%esp
80101d61:	50                   	push   %eax
80101d62:	e8 51 f7 ff ff       	call   801014b8 <balloc>
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d73:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d76:	8b 45 08             	mov    0x8(%ebp),%eax
80101d79:	8b 00                	mov    (%eax),%eax
80101d7b:	83 ec 08             	sub    $0x8,%esp
80101d7e:	ff 75 f4             	pushl  -0xc(%ebp)
80101d81:	50                   	push   %eax
80101d82:	e8 2f e4 ff ff       	call   801001b6 <bread>
80101d87:	83 c4 10             	add    $0x10,%esp
80101d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d90:	83 c0 18             	add    $0x18,%eax
80101d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da3:	01 d0                	add    %edx,%eax
80101da5:	8b 00                	mov    (%eax),%eax
80101da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dae:	75 37                	jne    80101de7 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dbd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 00                	mov    (%eax),%eax
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	50                   	push   %eax
80101dc9:	e8 ea f6 ff ff       	call   801014b8 <balloc>
80101dce:	83 c4 10             	add    $0x10,%esp
80101dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dd7:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101dd9:	83 ec 0c             	sub    $0xc,%esp
80101ddc:	ff 75 f0             	pushl  -0x10(%ebp)
80101ddf:	e8 3f 1a 00 00       	call   80103823 <log_write>
80101de4:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101de7:	83 ec 0c             	sub    $0xc,%esp
80101dea:	ff 75 f0             	pushl  -0x10(%ebp)
80101ded:	e8 3c e4 ff ff       	call   8010022e <brelse>
80101df2:	83 c4 10             	add    $0x10,%esp
    return addr;
80101df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101df8:	eb 0d                	jmp    80101e07 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101dfa:	83 ec 0c             	sub    $0xc,%esp
80101dfd:	68 10 97 10 80       	push   $0x80109710
80101e02:	e8 5f e7 ff ff       	call   80100566 <panic>
}
80101e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e0a:	c9                   	leave  
80101e0b:	c3                   	ret    

80101e0c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e0c:	55                   	push   %ebp
80101e0d:	89 e5                	mov    %esp,%ebp
80101e0f:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e19:	eb 45                	jmp    80101e60 <itrunc+0x54>
    if(ip->addrs[i]){
80101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e21:	83 c2 04             	add    $0x4,%edx
80101e24:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e28:	85 c0                	test   %eax,%eax
80101e2a:	74 30                	je     80101e5c <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e32:	83 c2 04             	add    $0x4,%edx
80101e35:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e39:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3c:	8b 12                	mov    (%edx),%edx
80101e3e:	83 ec 08             	sub    $0x8,%esp
80101e41:	50                   	push   %eax
80101e42:	52                   	push   %edx
80101e43:	e8 bc f7 ff ff       	call   80101604 <bfree>
80101e48:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e51:	83 c2 04             	add    $0x4,%edx
80101e54:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e5b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e60:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e64:	7e b5                	jle    80101e1b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e66:	8b 45 08             	mov    0x8(%ebp),%eax
80101e69:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e6c:	85 c0                	test   %eax,%eax
80101e6e:	0f 84 a1 00 00 00    	je     80101f15 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	8b 00                	mov    (%eax),%eax
80101e7f:	83 ec 08             	sub    $0x8,%esp
80101e82:	52                   	push   %edx
80101e83:	50                   	push   %eax
80101e84:	e8 2d e3 ff ff       	call   801001b6 <bread>
80101e89:	83 c4 10             	add    $0x10,%esp
80101e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e92:	83 c0 18             	add    $0x18,%eax
80101e95:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e9f:	eb 3c                	jmp    80101edd <itrunc+0xd1>
      if(a[j])
80101ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eae:	01 d0                	add    %edx,%eax
80101eb0:	8b 00                	mov    (%eax),%eax
80101eb2:	85 c0                	test   %eax,%eax
80101eb4:	74 23                	je     80101ed9 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ec3:	01 d0                	add    %edx,%eax
80101ec5:	8b 00                	mov    (%eax),%eax
80101ec7:	8b 55 08             	mov    0x8(%ebp),%edx
80101eca:	8b 12                	mov    (%edx),%edx
80101ecc:	83 ec 08             	sub    $0x8,%esp
80101ecf:	50                   	push   %eax
80101ed0:	52                   	push   %edx
80101ed1:	e8 2e f7 ff ff       	call   80101604 <bfree>
80101ed6:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ed9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee0:	83 f8 7f             	cmp    $0x7f,%eax
80101ee3:	76 bc                	jbe    80101ea1 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	ff 75 ec             	pushl  -0x14(%ebp)
80101eeb:	e8 3e e3 ff ff       	call   8010022e <brelse>
80101ef0:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ef9:	8b 55 08             	mov    0x8(%ebp),%edx
80101efc:	8b 12                	mov    (%edx),%edx
80101efe:	83 ec 08             	sub    $0x8,%esp
80101f01:	50                   	push   %eax
80101f02:	52                   	push   %edx
80101f03:	e8 fc f6 ff ff       	call   80101604 <bfree>
80101f08:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f15:	8b 45 08             	mov    0x8(%ebp),%eax
80101f18:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f1f:	83 ec 0c             	sub    $0xc,%esp
80101f22:	ff 75 08             	pushl  0x8(%ebp)
80101f25:	e8 04 f9 ff ff       	call   8010182e <iupdate>
80101f2a:	83 c4 10             	add    $0x10,%esp
}
80101f2d:	90                   	nop
80101f2e:	c9                   	leave  
80101f2f:	c3                   	ret    

80101f30 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	8b 00                	mov    (%eax),%eax
80101f38:	89 c2                	mov    %eax,%edx
80101f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f3d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	8b 50 04             	mov    0x4(%eax),%edx
80101f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f49:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4f:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f56:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f59:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f63:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f67:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6a:	8b 50 18             	mov    0x18(%eax),%edx
80101f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f70:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f73:	90                   	nop
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    

80101f76 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f76:	55                   	push   %ebp
80101f77:	89 e5                	mov    %esp,%ebp
80101f79:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f83:	66 83 f8 03          	cmp    $0x3,%ax
80101f87:	75 5c                	jne    80101fe5 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f90:	66 85 c0             	test   %ax,%ax
80101f93:	78 20                	js     80101fb5 <readi+0x3f>
80101f95:	8b 45 08             	mov    0x8(%ebp),%eax
80101f98:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f9c:	66 83 f8 09          	cmp    $0x9,%ax
80101fa0:	7f 13                	jg     80101fb5 <readi+0x3f>
80101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa9:	98                   	cwtl   
80101faa:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fb1:	85 c0                	test   %eax,%eax
80101fb3:	75 0a                	jne    80101fbf <readi+0x49>
      return -1;
80101fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fba:	e9 0c 01 00 00       	jmp    801020cb <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc6:	98                   	cwtl   
80101fc7:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fce:	8b 55 14             	mov    0x14(%ebp),%edx
80101fd1:	83 ec 04             	sub    $0x4,%esp
80101fd4:	52                   	push   %edx
80101fd5:	ff 75 0c             	pushl  0xc(%ebp)
80101fd8:	ff 75 08             	pushl  0x8(%ebp)
80101fdb:	ff d0                	call   *%eax
80101fdd:	83 c4 10             	add    $0x10,%esp
80101fe0:	e9 e6 00 00 00       	jmp    801020cb <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe8:	8b 40 18             	mov    0x18(%eax),%eax
80101feb:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fee:	72 0d                	jb     80101ffd <readi+0x87>
80101ff0:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff3:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff6:	01 d0                	add    %edx,%eax
80101ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ffb:	73 0a                	jae    80102007 <readi+0x91>
    return -1;
80101ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102002:	e9 c4 00 00 00       	jmp    801020cb <readi+0x155>
  if(off + n > ip->size)
80102007:	8b 55 10             	mov    0x10(%ebp),%edx
8010200a:	8b 45 14             	mov    0x14(%ebp),%eax
8010200d:	01 c2                	add    %eax,%edx
8010200f:	8b 45 08             	mov    0x8(%ebp),%eax
80102012:	8b 40 18             	mov    0x18(%eax),%eax
80102015:	39 c2                	cmp    %eax,%edx
80102017:	76 0c                	jbe    80102025 <readi+0xaf>
    n = ip->size - off;
80102019:	8b 45 08             	mov    0x8(%ebp),%eax
8010201c:	8b 40 18             	mov    0x18(%eax),%eax
8010201f:	2b 45 10             	sub    0x10(%ebp),%eax
80102022:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010202c:	e9 8b 00 00 00       	jmp    801020bc <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102031:	8b 45 10             	mov    0x10(%ebp),%eax
80102034:	c1 e8 09             	shr    $0x9,%eax
80102037:	83 ec 08             	sub    $0x8,%esp
8010203a:	50                   	push   %eax
8010203b:	ff 75 08             	pushl  0x8(%ebp)
8010203e:	e8 aa fc ff ff       	call   80101ced <bmap>
80102043:	83 c4 10             	add    $0x10,%esp
80102046:	89 c2                	mov    %eax,%edx
80102048:	8b 45 08             	mov    0x8(%ebp),%eax
8010204b:	8b 00                	mov    (%eax),%eax
8010204d:	83 ec 08             	sub    $0x8,%esp
80102050:	52                   	push   %edx
80102051:	50                   	push   %eax
80102052:	e8 5f e1 ff ff       	call   801001b6 <bread>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010205d:	8b 45 10             	mov    0x10(%ebp),%eax
80102060:	25 ff 01 00 00       	and    $0x1ff,%eax
80102065:	ba 00 02 00 00       	mov    $0x200,%edx
8010206a:	29 c2                	sub    %eax,%edx
8010206c:	8b 45 14             	mov    0x14(%ebp),%eax
8010206f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102072:	39 c2                	cmp    %eax,%edx
80102074:	0f 46 c2             	cmovbe %edx,%eax
80102077:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010207d:	8d 50 18             	lea    0x18(%eax),%edx
80102080:	8b 45 10             	mov    0x10(%ebp),%eax
80102083:	25 ff 01 00 00       	and    $0x1ff,%eax
80102088:	01 d0                	add    %edx,%eax
8010208a:	83 ec 04             	sub    $0x4,%esp
8010208d:	ff 75 ec             	pushl  -0x14(%ebp)
80102090:	50                   	push   %eax
80102091:	ff 75 0c             	pushl  0xc(%ebp)
80102094:	e8 8a 41 00 00       	call   80106223 <memmove>
80102099:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010209c:	83 ec 0c             	sub    $0xc,%esp
8010209f:	ff 75 f0             	pushl  -0x10(%ebp)
801020a2:	e8 87 e1 ff ff       	call   8010022e <brelse>
801020a7:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ad:	01 45 f4             	add    %eax,-0xc(%ebp)
801020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b3:	01 45 10             	add    %eax,0x10(%ebp)
801020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b9:	01 45 0c             	add    %eax,0xc(%ebp)
801020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020bf:	3b 45 14             	cmp    0x14(%ebp),%eax
801020c2:	0f 82 69 ff ff ff    	jb     80102031 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020c8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020cb:	c9                   	leave  
801020cc:	c3                   	ret    

801020cd <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020cd:	55                   	push   %ebp
801020ce:	89 e5                	mov    %esp,%ebp
801020d0:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020d3:	8b 45 08             	mov    0x8(%ebp),%eax
801020d6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020da:	66 83 f8 03          	cmp    $0x3,%ax
801020de:	75 5c                	jne    8010213c <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020e0:	8b 45 08             	mov    0x8(%ebp),%eax
801020e3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020e7:	66 85 c0             	test   %ax,%ax
801020ea:	78 20                	js     8010210c <writei+0x3f>
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f3:	66 83 f8 09          	cmp    $0x9,%ax
801020f7:	7f 13                	jg     8010210c <writei+0x3f>
801020f9:	8b 45 08             	mov    0x8(%ebp),%eax
801020fc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102100:	98                   	cwtl   
80102101:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102108:	85 c0                	test   %eax,%eax
8010210a:	75 0a                	jne    80102116 <writei+0x49>
      return -1;
8010210c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102111:	e9 3d 01 00 00       	jmp    80102253 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102116:	8b 45 08             	mov    0x8(%ebp),%eax
80102119:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010211d:	98                   	cwtl   
8010211e:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102125:	8b 55 14             	mov    0x14(%ebp),%edx
80102128:	83 ec 04             	sub    $0x4,%esp
8010212b:	52                   	push   %edx
8010212c:	ff 75 0c             	pushl  0xc(%ebp)
8010212f:	ff 75 08             	pushl  0x8(%ebp)
80102132:	ff d0                	call   *%eax
80102134:	83 c4 10             	add    $0x10,%esp
80102137:	e9 17 01 00 00       	jmp    80102253 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010213c:	8b 45 08             	mov    0x8(%ebp),%eax
8010213f:	8b 40 18             	mov    0x18(%eax),%eax
80102142:	3b 45 10             	cmp    0x10(%ebp),%eax
80102145:	72 0d                	jb     80102154 <writei+0x87>
80102147:	8b 55 10             	mov    0x10(%ebp),%edx
8010214a:	8b 45 14             	mov    0x14(%ebp),%eax
8010214d:	01 d0                	add    %edx,%eax
8010214f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102152:	73 0a                	jae    8010215e <writei+0x91>
    return -1;
80102154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102159:	e9 f5 00 00 00       	jmp    80102253 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010215e:	8b 55 10             	mov    0x10(%ebp),%edx
80102161:	8b 45 14             	mov    0x14(%ebp),%eax
80102164:	01 d0                	add    %edx,%eax
80102166:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010216b:	76 0a                	jbe    80102177 <writei+0xaa>
    return -1;
8010216d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102172:	e9 dc 00 00 00       	jmp    80102253 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010217e:	e9 99 00 00 00       	jmp    8010221c <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102183:	8b 45 10             	mov    0x10(%ebp),%eax
80102186:	c1 e8 09             	shr    $0x9,%eax
80102189:	83 ec 08             	sub    $0x8,%esp
8010218c:	50                   	push   %eax
8010218d:	ff 75 08             	pushl  0x8(%ebp)
80102190:	e8 58 fb ff ff       	call   80101ced <bmap>
80102195:	83 c4 10             	add    $0x10,%esp
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 45 08             	mov    0x8(%ebp),%eax
8010219d:	8b 00                	mov    (%eax),%eax
8010219f:	83 ec 08             	sub    $0x8,%esp
801021a2:	52                   	push   %edx
801021a3:	50                   	push   %eax
801021a4:	e8 0d e0 ff ff       	call   801001b6 <bread>
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021af:	8b 45 10             	mov    0x10(%ebp),%eax
801021b2:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b7:	ba 00 02 00 00       	mov    $0x200,%edx
801021bc:	29 c2                	sub    %eax,%edx
801021be:	8b 45 14             	mov    0x14(%ebp),%eax
801021c1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021c4:	39 c2                	cmp    %eax,%edx
801021c6:	0f 46 c2             	cmovbe %edx,%eax
801021c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021cf:	8d 50 18             	lea    0x18(%eax),%edx
801021d2:	8b 45 10             	mov    0x10(%ebp),%eax
801021d5:	25 ff 01 00 00       	and    $0x1ff,%eax
801021da:	01 d0                	add    %edx,%eax
801021dc:	83 ec 04             	sub    $0x4,%esp
801021df:	ff 75 ec             	pushl  -0x14(%ebp)
801021e2:	ff 75 0c             	pushl  0xc(%ebp)
801021e5:	50                   	push   %eax
801021e6:	e8 38 40 00 00       	call   80106223 <memmove>
801021eb:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021ee:	83 ec 0c             	sub    $0xc,%esp
801021f1:	ff 75 f0             	pushl  -0x10(%ebp)
801021f4:	e8 2a 16 00 00       	call   80103823 <log_write>
801021f9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021fc:	83 ec 0c             	sub    $0xc,%esp
801021ff:	ff 75 f0             	pushl  -0x10(%ebp)
80102202:	e8 27 e0 ff ff       	call   8010022e <brelse>
80102207:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010220d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102210:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102213:	01 45 10             	add    %eax,0x10(%ebp)
80102216:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102219:	01 45 0c             	add    %eax,0xc(%ebp)
8010221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102222:	0f 82 5b ff ff ff    	jb     80102183 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102228:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010222c:	74 22                	je     80102250 <writei+0x183>
8010222e:	8b 45 08             	mov    0x8(%ebp),%eax
80102231:	8b 40 18             	mov    0x18(%eax),%eax
80102234:	3b 45 10             	cmp    0x10(%ebp),%eax
80102237:	73 17                	jae    80102250 <writei+0x183>
    ip->size = off;
80102239:	8b 45 08             	mov    0x8(%ebp),%eax
8010223c:	8b 55 10             	mov    0x10(%ebp),%edx
8010223f:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102242:	83 ec 0c             	sub    $0xc,%esp
80102245:	ff 75 08             	pushl  0x8(%ebp)
80102248:	e8 e1 f5 ff ff       	call   8010182e <iupdate>
8010224d:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102250:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102253:	c9                   	leave  
80102254:	c3                   	ret    

80102255 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102255:	55                   	push   %ebp
80102256:	89 e5                	mov    %esp,%ebp
80102258:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010225b:	83 ec 04             	sub    $0x4,%esp
8010225e:	6a 0e                	push   $0xe
80102260:	ff 75 0c             	pushl  0xc(%ebp)
80102263:	ff 75 08             	pushl  0x8(%ebp)
80102266:	e8 4e 40 00 00       	call   801062b9 <strncmp>
8010226b:	83 c4 10             	add    $0x10,%esp
}
8010226e:	c9                   	leave  
8010226f:	c3                   	ret    

80102270 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010227d:	66 83 f8 01          	cmp    $0x1,%ax
80102281:	74 0d                	je     80102290 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	68 23 97 10 80       	push   $0x80109723
8010228b:	e8 d6 e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102297:	eb 7b                	jmp    80102314 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102299:	6a 10                	push   $0x10
8010229b:	ff 75 f4             	pushl  -0xc(%ebp)
8010229e:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a1:	50                   	push   %eax
801022a2:	ff 75 08             	pushl  0x8(%ebp)
801022a5:	e8 cc fc ff ff       	call   80101f76 <readi>
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	83 f8 10             	cmp    $0x10,%eax
801022b0:	74 0d                	je     801022bf <dirlookup+0x4f>
      panic("dirlink read");
801022b2:	83 ec 0c             	sub    $0xc,%esp
801022b5:	68 35 97 10 80       	push   $0x80109735
801022ba:	e8 a7 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022bf:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022c3:	66 85 c0             	test   %ax,%ax
801022c6:	74 47                	je     8010230f <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022c8:	83 ec 08             	sub    $0x8,%esp
801022cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ce:	83 c0 02             	add    $0x2,%eax
801022d1:	50                   	push   %eax
801022d2:	ff 75 0c             	pushl  0xc(%ebp)
801022d5:	e8 7b ff ff ff       	call   80102255 <namecmp>
801022da:	83 c4 10             	add    $0x10,%esp
801022dd:	85 c0                	test   %eax,%eax
801022df:	75 2f                	jne    80102310 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022e5:	74 08                	je     801022ef <dirlookup+0x7f>
        *poff = off;
801022e7:	8b 45 10             	mov    0x10(%ebp),%eax
801022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022ed:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022ef:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022f3:	0f b7 c0             	movzwl %ax,%eax
801022f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	8b 00                	mov    (%eax),%eax
801022fe:	83 ec 08             	sub    $0x8,%esp
80102301:	ff 75 f0             	pushl  -0x10(%ebp)
80102304:	50                   	push   %eax
80102305:	e8 e5 f5 ff ff       	call   801018ef <iget>
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	eb 19                	jmp    80102328 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010230f:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102310:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102314:	8b 45 08             	mov    0x8(%ebp),%eax
80102317:	8b 40 18             	mov    0x18(%eax),%eax
8010231a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010231d:	0f 87 76 ff ff ff    	ja     80102299 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102323:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102328:	c9                   	leave  
80102329:	c3                   	ret    

8010232a <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010232a:	55                   	push   %ebp
8010232b:	89 e5                	mov    %esp,%ebp
8010232d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102330:	83 ec 04             	sub    $0x4,%esp
80102333:	6a 00                	push   $0x0
80102335:	ff 75 0c             	pushl  0xc(%ebp)
80102338:	ff 75 08             	pushl  0x8(%ebp)
8010233b:	e8 30 ff ff ff       	call   80102270 <dirlookup>
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010234a:	74 18                	je     80102364 <dirlink+0x3a>
    iput(ip);
8010234c:	83 ec 0c             	sub    $0xc,%esp
8010234f:	ff 75 f0             	pushl  -0x10(%ebp)
80102352:	e8 81 f8 ff ff       	call   80101bd8 <iput>
80102357:	83 c4 10             	add    $0x10,%esp
    return -1;
8010235a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010235f:	e9 9c 00 00 00       	jmp    80102400 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102364:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010236b:	eb 39                	jmp    801023a6 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102370:	6a 10                	push   $0x10
80102372:	50                   	push   %eax
80102373:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102376:	50                   	push   %eax
80102377:	ff 75 08             	pushl  0x8(%ebp)
8010237a:	e8 f7 fb ff ff       	call   80101f76 <readi>
8010237f:	83 c4 10             	add    $0x10,%esp
80102382:	83 f8 10             	cmp    $0x10,%eax
80102385:	74 0d                	je     80102394 <dirlink+0x6a>
      panic("dirlink read");
80102387:	83 ec 0c             	sub    $0xc,%esp
8010238a:	68 35 97 10 80       	push   $0x80109735
8010238f:	e8 d2 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102394:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102398:	66 85 c0             	test   %ax,%ax
8010239b:	74 18                	je     801023b5 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a0:	83 c0 10             	add    $0x10,%eax
801023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
801023a9:	8b 50 18             	mov    0x18(%eax),%edx
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	39 c2                	cmp    %eax,%edx
801023b1:	77 ba                	ja     8010236d <dirlink+0x43>
801023b3:	eb 01                	jmp    801023b6 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023b5:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023b6:	83 ec 04             	sub    $0x4,%esp
801023b9:	6a 0e                	push   $0xe
801023bb:	ff 75 0c             	pushl  0xc(%ebp)
801023be:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023c1:	83 c0 02             	add    $0x2,%eax
801023c4:	50                   	push   %eax
801023c5:	e8 45 3f 00 00       	call   8010630f <strncpy>
801023ca:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023cd:	8b 45 10             	mov    0x10(%ebp),%eax
801023d0:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d7:	6a 10                	push   $0x10
801023d9:	50                   	push   %eax
801023da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023dd:	50                   	push   %eax
801023de:	ff 75 08             	pushl  0x8(%ebp)
801023e1:	e8 e7 fc ff ff       	call   801020cd <writei>
801023e6:	83 c4 10             	add    $0x10,%esp
801023e9:	83 f8 10             	cmp    $0x10,%eax
801023ec:	74 0d                	je     801023fb <dirlink+0xd1>
    panic("dirlink");
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	68 42 97 10 80       	push   $0x80109742
801023f6:	e8 6b e1 ff ff       	call   80100566 <panic>
  
  return 0;
801023fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102400:	c9                   	leave  
80102401:	c3                   	ret    

80102402 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102402:	55                   	push   %ebp
80102403:	89 e5                	mov    %esp,%ebp
80102405:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102408:	eb 04                	jmp    8010240e <skipelem+0xc>
    path++;
8010240a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b6 00             	movzbl (%eax),%eax
80102414:	3c 2f                	cmp    $0x2f,%al
80102416:	74 f2                	je     8010240a <skipelem+0x8>
    path++;
  if(*path == 0)
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
8010241b:	0f b6 00             	movzbl (%eax),%eax
8010241e:	84 c0                	test   %al,%al
80102420:	75 07                	jne    80102429 <skipelem+0x27>
    return 0;
80102422:	b8 00 00 00 00       	mov    $0x0,%eax
80102427:	eb 7b                	jmp    801024a4 <skipelem+0xa2>
  s = path;
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010242f:	eb 04                	jmp    80102435 <skipelem+0x33>
    path++;
80102431:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	0f b6 00             	movzbl (%eax),%eax
8010243b:	3c 2f                	cmp    $0x2f,%al
8010243d:	74 0a                	je     80102449 <skipelem+0x47>
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
80102442:	0f b6 00             	movzbl (%eax),%eax
80102445:	84 c0                	test   %al,%al
80102447:	75 e8                	jne    80102431 <skipelem+0x2f>
    path++;
  len = path - s;
80102449:	8b 55 08             	mov    0x8(%ebp),%edx
8010244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244f:	29 c2                	sub    %eax,%edx
80102451:	89 d0                	mov    %edx,%eax
80102453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102456:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010245a:	7e 15                	jle    80102471 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010245c:	83 ec 04             	sub    $0x4,%esp
8010245f:	6a 0e                	push   $0xe
80102461:	ff 75 f4             	pushl  -0xc(%ebp)
80102464:	ff 75 0c             	pushl  0xc(%ebp)
80102467:	e8 b7 3d 00 00       	call   80106223 <memmove>
8010246c:	83 c4 10             	add    $0x10,%esp
8010246f:	eb 26                	jmp    80102497 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102474:	83 ec 04             	sub    $0x4,%esp
80102477:	50                   	push   %eax
80102478:	ff 75 f4             	pushl  -0xc(%ebp)
8010247b:	ff 75 0c             	pushl  0xc(%ebp)
8010247e:	e8 a0 3d 00 00       	call   80106223 <memmove>
80102483:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102489:	8b 45 0c             	mov    0xc(%ebp),%eax
8010248c:	01 d0                	add    %edx,%eax
8010248e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102491:	eb 04                	jmp    80102497 <skipelem+0x95>
    path++;
80102493:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102497:	8b 45 08             	mov    0x8(%ebp),%eax
8010249a:	0f b6 00             	movzbl (%eax),%eax
8010249d:	3c 2f                	cmp    $0x2f,%al
8010249f:	74 f2                	je     80102493 <skipelem+0x91>
    path++;
  return path;
801024a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024a4:	c9                   	leave  
801024a5:	c3                   	ret    

801024a6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024a6:	55                   	push   %ebp
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	3c 2f                	cmp    $0x2f,%al
801024b4:	75 17                	jne    801024cd <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024b6:	83 ec 08             	sub    $0x8,%esp
801024b9:	6a 01                	push   $0x1
801024bb:	6a 01                	push   $0x1
801024bd:	e8 2d f4 ff ff       	call   801018ef <iget>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024c8:	e9 bb 00 00 00       	jmp    80102588 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024d3:	8b 40 68             	mov    0x68(%eax),%eax
801024d6:	83 ec 0c             	sub    $0xc,%esp
801024d9:	50                   	push   %eax
801024da:	e8 ef f4 ff ff       	call   801019ce <idup>
801024df:	83 c4 10             	add    $0x10,%esp
801024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024e5:	e9 9e 00 00 00       	jmp    80102588 <namex+0xe2>
    ilock(ip);
801024ea:	83 ec 0c             	sub    $0xc,%esp
801024ed:	ff 75 f4             	pushl  -0xc(%ebp)
801024f0:	e8 13 f5 ff ff       	call   80101a08 <ilock>
801024f5:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024fb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024ff:	66 83 f8 01          	cmp    $0x1,%ax
80102503:	74 18                	je     8010251d <namex+0x77>
      iunlockput(ip);
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	ff 75 f4             	pushl  -0xc(%ebp)
8010250b:	e8 b8 f7 ff ff       	call   80101cc8 <iunlockput>
80102510:	83 c4 10             	add    $0x10,%esp
      return 0;
80102513:	b8 00 00 00 00       	mov    $0x0,%eax
80102518:	e9 a7 00 00 00       	jmp    801025c4 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010251d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102521:	74 20                	je     80102543 <namex+0x9d>
80102523:	8b 45 08             	mov    0x8(%ebp),%eax
80102526:	0f b6 00             	movzbl (%eax),%eax
80102529:	84 c0                	test   %al,%al
8010252b:	75 16                	jne    80102543 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010252d:	83 ec 0c             	sub    $0xc,%esp
80102530:	ff 75 f4             	pushl  -0xc(%ebp)
80102533:	e8 2e f6 ff ff       	call   80101b66 <iunlock>
80102538:	83 c4 10             	add    $0x10,%esp
      return ip;
8010253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010253e:	e9 81 00 00 00       	jmp    801025c4 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102543:	83 ec 04             	sub    $0x4,%esp
80102546:	6a 00                	push   $0x0
80102548:	ff 75 10             	pushl  0x10(%ebp)
8010254b:	ff 75 f4             	pushl  -0xc(%ebp)
8010254e:	e8 1d fd ff ff       	call   80102270 <dirlookup>
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010255d:	75 15                	jne    80102574 <namex+0xce>
      iunlockput(ip);
8010255f:	83 ec 0c             	sub    $0xc,%esp
80102562:	ff 75 f4             	pushl  -0xc(%ebp)
80102565:	e8 5e f7 ff ff       	call   80101cc8 <iunlockput>
8010256a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010256d:	b8 00 00 00 00       	mov    $0x0,%eax
80102572:	eb 50                	jmp    801025c4 <namex+0x11e>
    }
    iunlockput(ip);
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	ff 75 f4             	pushl  -0xc(%ebp)
8010257a:	e8 49 f7 ff ff       	call   80101cc8 <iunlockput>
8010257f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102588:	83 ec 08             	sub    $0x8,%esp
8010258b:	ff 75 10             	pushl  0x10(%ebp)
8010258e:	ff 75 08             	pushl  0x8(%ebp)
80102591:	e8 6c fe ff ff       	call   80102402 <skipelem>
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	89 45 08             	mov    %eax,0x8(%ebp)
8010259c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a0:	0f 85 44 ff ff ff    	jne    801024ea <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025aa:	74 15                	je     801025c1 <namex+0x11b>
    iput(ip);
801025ac:	83 ec 0c             	sub    $0xc,%esp
801025af:	ff 75 f4             	pushl  -0xc(%ebp)
801025b2:	e8 21 f6 ff ff       	call   80101bd8 <iput>
801025b7:	83 c4 10             	add    $0x10,%esp
    return 0;
801025ba:	b8 00 00 00 00       	mov    $0x0,%eax
801025bf:	eb 03                	jmp    801025c4 <namex+0x11e>
  }
  return ip;
801025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025c4:	c9                   	leave  
801025c5:	c3                   	ret    

801025c6 <namei>:

struct inode*
namei(char *path)
{
801025c6:	55                   	push   %ebp
801025c7:	89 e5                	mov    %esp,%ebp
801025c9:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025cc:	83 ec 04             	sub    $0x4,%esp
801025cf:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025d2:	50                   	push   %eax
801025d3:	6a 00                	push   $0x0
801025d5:	ff 75 08             	pushl  0x8(%ebp)
801025d8:	e8 c9 fe ff ff       	call   801024a6 <namex>
801025dd:	83 c4 10             	add    $0x10,%esp
}
801025e0:	c9                   	leave  
801025e1:	c3                   	ret    

801025e2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025e2:	55                   	push   %ebp
801025e3:	89 e5                	mov    %esp,%ebp
801025e5:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025e8:	83 ec 04             	sub    $0x4,%esp
801025eb:	ff 75 0c             	pushl  0xc(%ebp)
801025ee:	6a 01                	push   $0x1
801025f0:	ff 75 08             	pushl  0x8(%ebp)
801025f3:	e8 ae fe ff ff       	call   801024a6 <namex>
801025f8:	83 c4 10             	add    $0x10,%esp
}
801025fb:	c9                   	leave  
801025fc:	c3                   	ret    

801025fd <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801025fd:	55                   	push   %ebp
801025fe:	89 e5                	mov    %esp,%ebp
80102600:	83 ec 14             	sub    $0x14,%esp
80102603:	8b 45 08             	mov    0x8(%ebp),%eax
80102606:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010260e:	89 c2                	mov    %eax,%edx
80102610:	ec                   	in     (%dx),%al
80102611:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102614:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102618:	c9                   	leave  
80102619:	c3                   	ret    

8010261a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010261a:	55                   	push   %ebp
8010261b:	89 e5                	mov    %esp,%ebp
8010261d:	57                   	push   %edi
8010261e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010261f:	8b 55 08             	mov    0x8(%ebp),%edx
80102622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102625:	8b 45 10             	mov    0x10(%ebp),%eax
80102628:	89 cb                	mov    %ecx,%ebx
8010262a:	89 df                	mov    %ebx,%edi
8010262c:	89 c1                	mov    %eax,%ecx
8010262e:	fc                   	cld    
8010262f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102631:	89 c8                	mov    %ecx,%eax
80102633:	89 fb                	mov    %edi,%ebx
80102635:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102638:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010263b:	90                   	nop
8010263c:	5b                   	pop    %ebx
8010263d:	5f                   	pop    %edi
8010263e:	5d                   	pop    %ebp
8010263f:	c3                   	ret    

80102640 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 08             	sub    $0x8,%esp
80102646:	8b 55 08             	mov    0x8(%ebp),%edx
80102649:	8b 45 0c             	mov    0xc(%ebp),%eax
8010264c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102650:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102653:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102657:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010265b:	ee                   	out    %al,(%dx)
}
8010265c:	90                   	nop
8010265d:	c9                   	leave  
8010265e:	c3                   	ret    

8010265f <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010265f:	55                   	push   %ebp
80102660:	89 e5                	mov    %esp,%ebp
80102662:	56                   	push   %esi
80102663:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102664:	8b 55 08             	mov    0x8(%ebp),%edx
80102667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010266a:	8b 45 10             	mov    0x10(%ebp),%eax
8010266d:	89 cb                	mov    %ecx,%ebx
8010266f:	89 de                	mov    %ebx,%esi
80102671:	89 c1                	mov    %eax,%ecx
80102673:	fc                   	cld    
80102674:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102676:	89 c8                	mov    %ecx,%eax
80102678:	89 f3                	mov    %esi,%ebx
8010267a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010267d:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102680:	90                   	nop
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret    

80102685 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
80102688:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010268b:	90                   	nop
8010268c:	68 f7 01 00 00       	push   $0x1f7
80102691:	e8 67 ff ff ff       	call   801025fd <inb>
80102696:	83 c4 04             	add    $0x4,%esp
80102699:	0f b6 c0             	movzbl %al,%eax
8010269c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010269f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026a2:	25 c0 00 00 00       	and    $0xc0,%eax
801026a7:	83 f8 40             	cmp    $0x40,%eax
801026aa:	75 e0                	jne    8010268c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026b0:	74 11                	je     801026c3 <idewait+0x3e>
801026b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026b5:	83 e0 21             	and    $0x21,%eax
801026b8:	85 c0                	test   %eax,%eax
801026ba:	74 07                	je     801026c3 <idewait+0x3e>
    return -1;
801026bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026c1:	eb 05                	jmp    801026c8 <idewait+0x43>
  return 0;
801026c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026c8:	c9                   	leave  
801026c9:	c3                   	ret    

801026ca <ideinit>:

void
ideinit(void)
{
801026ca:	55                   	push   %ebp
801026cb:	89 e5                	mov    %esp,%ebp
801026cd:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026d0:	83 ec 08             	sub    $0x8,%esp
801026d3:	68 4a 97 10 80       	push   $0x8010974a
801026d8:	68 20 c6 10 80       	push   $0x8010c620
801026dd:	e8 fd 37 00 00       	call   80105edf <initlock>
801026e2:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026e5:	83 ec 0c             	sub    $0xc,%esp
801026e8:	6a 0e                	push   $0xe
801026ea:	e8 da 18 00 00       	call   80103fc9 <picenable>
801026ef:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026f2:	a1 60 39 11 80       	mov    0x80113960,%eax
801026f7:	83 e8 01             	sub    $0x1,%eax
801026fa:	83 ec 08             	sub    $0x8,%esp
801026fd:	50                   	push   %eax
801026fe:	6a 0e                	push   $0xe
80102700:	e8 73 04 00 00       	call   80102b78 <ioapicenable>
80102705:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	6a 00                	push   $0x0
8010270d:	e8 73 ff ff ff       	call   80102685 <idewait>
80102712:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102715:	83 ec 08             	sub    $0x8,%esp
80102718:	68 f0 00 00 00       	push   $0xf0
8010271d:	68 f6 01 00 00       	push   $0x1f6
80102722:	e8 19 ff ff ff       	call   80102640 <outb>
80102727:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102731:	eb 24                	jmp    80102757 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102733:	83 ec 0c             	sub    $0xc,%esp
80102736:	68 f7 01 00 00       	push   $0x1f7
8010273b:	e8 bd fe ff ff       	call   801025fd <inb>
80102740:	83 c4 10             	add    $0x10,%esp
80102743:	84 c0                	test   %al,%al
80102745:	74 0c                	je     80102753 <ideinit+0x89>
      havedisk1 = 1;
80102747:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010274e:	00 00 00 
      break;
80102751:	eb 0d                	jmp    80102760 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102753:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102757:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010275e:	7e d3                	jle    80102733 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102760:	83 ec 08             	sub    $0x8,%esp
80102763:	68 e0 00 00 00       	push   $0xe0
80102768:	68 f6 01 00 00       	push   $0x1f6
8010276d:	e8 ce fe ff ff       	call   80102640 <outb>
80102772:	83 c4 10             	add    $0x10,%esp
}
80102775:	90                   	nop
80102776:	c9                   	leave  
80102777:	c3                   	ret    

80102778 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102778:	55                   	push   %ebp
80102779:	89 e5                	mov    %esp,%ebp
8010277b:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010277e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102782:	75 0d                	jne    80102791 <idestart+0x19>
    panic("idestart");
80102784:	83 ec 0c             	sub    $0xc,%esp
80102787:	68 4e 97 10 80       	push   $0x8010974e
8010278c:	e8 d5 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102791:	8b 45 08             	mov    0x8(%ebp),%eax
80102794:	8b 40 08             	mov    0x8(%eax),%eax
80102797:	3d cf 07 00 00       	cmp    $0x7cf,%eax
8010279c:	76 0d                	jbe    801027ab <idestart+0x33>
    panic("incorrect blockno");
8010279e:	83 ec 0c             	sub    $0xc,%esp
801027a1:	68 57 97 10 80       	push   $0x80109757
801027a6:	e8 bb dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027b2:	8b 45 08             	mov    0x8(%ebp),%eax
801027b5:	8b 50 08             	mov    0x8(%eax),%edx
801027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027bb:	0f af c2             	imul   %edx,%eax
801027be:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027c1:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027c5:	7e 0d                	jle    801027d4 <idestart+0x5c>
801027c7:	83 ec 0c             	sub    $0xc,%esp
801027ca:	68 4e 97 10 80       	push   $0x8010974e
801027cf:	e8 92 dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027d4:	83 ec 0c             	sub    $0xc,%esp
801027d7:	6a 00                	push   $0x0
801027d9:	e8 a7 fe ff ff       	call   80102685 <idewait>
801027de:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027e1:	83 ec 08             	sub    $0x8,%esp
801027e4:	6a 00                	push   $0x0
801027e6:	68 f6 03 00 00       	push   $0x3f6
801027eb:	e8 50 fe ff ff       	call   80102640 <outb>
801027f0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f6:	0f b6 c0             	movzbl %al,%eax
801027f9:	83 ec 08             	sub    $0x8,%esp
801027fc:	50                   	push   %eax
801027fd:	68 f2 01 00 00       	push   $0x1f2
80102802:	e8 39 fe ff ff       	call   80102640 <outb>
80102807:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280d:	0f b6 c0             	movzbl %al,%eax
80102810:	83 ec 08             	sub    $0x8,%esp
80102813:	50                   	push   %eax
80102814:	68 f3 01 00 00       	push   $0x1f3
80102819:	e8 22 fe ff ff       	call   80102640 <outb>
8010281e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102821:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102824:	c1 f8 08             	sar    $0x8,%eax
80102827:	0f b6 c0             	movzbl %al,%eax
8010282a:	83 ec 08             	sub    $0x8,%esp
8010282d:	50                   	push   %eax
8010282e:	68 f4 01 00 00       	push   $0x1f4
80102833:	e8 08 fe ff ff       	call   80102640 <outb>
80102838:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010283e:	c1 f8 10             	sar    $0x10,%eax
80102841:	0f b6 c0             	movzbl %al,%eax
80102844:	83 ec 08             	sub    $0x8,%esp
80102847:	50                   	push   %eax
80102848:	68 f5 01 00 00       	push   $0x1f5
8010284d:	e8 ee fd ff ff       	call   80102640 <outb>
80102852:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102855:	8b 45 08             	mov    0x8(%ebp),%eax
80102858:	8b 40 04             	mov    0x4(%eax),%eax
8010285b:	83 e0 01             	and    $0x1,%eax
8010285e:	c1 e0 04             	shl    $0x4,%eax
80102861:	89 c2                	mov    %eax,%edx
80102863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102866:	c1 f8 18             	sar    $0x18,%eax
80102869:	83 e0 0f             	and    $0xf,%eax
8010286c:	09 d0                	or     %edx,%eax
8010286e:	83 c8 e0             	or     $0xffffffe0,%eax
80102871:	0f b6 c0             	movzbl %al,%eax
80102874:	83 ec 08             	sub    $0x8,%esp
80102877:	50                   	push   %eax
80102878:	68 f6 01 00 00       	push   $0x1f6
8010287d:	e8 be fd ff ff       	call   80102640 <outb>
80102882:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102885:	8b 45 08             	mov    0x8(%ebp),%eax
80102888:	8b 00                	mov    (%eax),%eax
8010288a:	83 e0 04             	and    $0x4,%eax
8010288d:	85 c0                	test   %eax,%eax
8010288f:	74 30                	je     801028c1 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102891:	83 ec 08             	sub    $0x8,%esp
80102894:	6a 30                	push   $0x30
80102896:	68 f7 01 00 00       	push   $0x1f7
8010289b:	e8 a0 fd ff ff       	call   80102640 <outb>
801028a0:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028a3:	8b 45 08             	mov    0x8(%ebp),%eax
801028a6:	83 c0 18             	add    $0x18,%eax
801028a9:	83 ec 04             	sub    $0x4,%esp
801028ac:	68 80 00 00 00       	push   $0x80
801028b1:	50                   	push   %eax
801028b2:	68 f0 01 00 00       	push   $0x1f0
801028b7:	e8 a3 fd ff ff       	call   8010265f <outsl>
801028bc:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028bf:	eb 12                	jmp    801028d3 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028c1:	83 ec 08             	sub    $0x8,%esp
801028c4:	6a 20                	push   $0x20
801028c6:	68 f7 01 00 00       	push   $0x1f7
801028cb:	e8 70 fd ff ff       	call   80102640 <outb>
801028d0:	83 c4 10             	add    $0x10,%esp
  }
}
801028d3:	90                   	nop
801028d4:	c9                   	leave  
801028d5:	c3                   	ret    

801028d6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028d6:	55                   	push   %ebp
801028d7:	89 e5                	mov    %esp,%ebp
801028d9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028dc:	83 ec 0c             	sub    $0xc,%esp
801028df:	68 20 c6 10 80       	push   $0x8010c620
801028e4:	e8 18 36 00 00       	call   80105f01 <acquire>
801028e9:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ec:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028f8:	75 15                	jne    8010290f <ideintr+0x39>
    release(&idelock);
801028fa:	83 ec 0c             	sub    $0xc,%esp
801028fd:	68 20 c6 10 80       	push   $0x8010c620
80102902:	e8 61 36 00 00       	call   80105f68 <release>
80102907:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010290a:	e9 9a 00 00 00       	jmp    801029a9 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102912:	8b 40 14             	mov    0x14(%eax),%eax
80102915:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291d:	8b 00                	mov    (%eax),%eax
8010291f:	83 e0 04             	and    $0x4,%eax
80102922:	85 c0                	test   %eax,%eax
80102924:	75 2d                	jne    80102953 <ideintr+0x7d>
80102926:	83 ec 0c             	sub    $0xc,%esp
80102929:	6a 01                	push   $0x1
8010292b:	e8 55 fd ff ff       	call   80102685 <idewait>
80102930:	83 c4 10             	add    $0x10,%esp
80102933:	85 c0                	test   %eax,%eax
80102935:	78 1c                	js     80102953 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293a:	83 c0 18             	add    $0x18,%eax
8010293d:	83 ec 04             	sub    $0x4,%esp
80102940:	68 80 00 00 00       	push   $0x80
80102945:	50                   	push   %eax
80102946:	68 f0 01 00 00       	push   $0x1f0
8010294b:	e8 ca fc ff ff       	call   8010261a <insl>
80102950:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102956:	8b 00                	mov    (%eax),%eax
80102958:	83 c8 02             	or     $0x2,%eax
8010295b:	89 c2                	mov    %eax,%edx
8010295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102960:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102965:	8b 00                	mov    (%eax),%eax
80102967:	83 e0 fb             	and    $0xfffffffb,%eax
8010296a:	89 c2                	mov    %eax,%edx
8010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	ff 75 f4             	pushl  -0xc(%ebp)
80102977:	e8 35 2b 00 00       	call   801054b1 <wakeup>
8010297c:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010297f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102984:	85 c0                	test   %eax,%eax
80102986:	74 11                	je     80102999 <ideintr+0xc3>
    idestart(idequeue);
80102988:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010298d:	83 ec 0c             	sub    $0xc,%esp
80102990:	50                   	push   %eax
80102991:	e8 e2 fd ff ff       	call   80102778 <idestart>
80102996:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	68 20 c6 10 80       	push   $0x8010c620
801029a1:	e8 c2 35 00 00       	call   80105f68 <release>
801029a6:	83 c4 10             	add    $0x10,%esp
}
801029a9:	c9                   	leave  
801029aa:	c3                   	ret    

801029ab <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029ab:	55                   	push   %ebp
801029ac:	89 e5                	mov    %esp,%ebp
801029ae:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029b1:	8b 45 08             	mov    0x8(%ebp),%eax
801029b4:	8b 00                	mov    (%eax),%eax
801029b6:	83 e0 01             	and    $0x1,%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	75 0d                	jne    801029ca <iderw+0x1f>
    panic("iderw: buf not busy");
801029bd:	83 ec 0c             	sub    $0xc,%esp
801029c0:	68 69 97 10 80       	push   $0x80109769
801029c5:	e8 9c db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029ca:	8b 45 08             	mov    0x8(%ebp),%eax
801029cd:	8b 00                	mov    (%eax),%eax
801029cf:	83 e0 06             	and    $0x6,%eax
801029d2:	83 f8 02             	cmp    $0x2,%eax
801029d5:	75 0d                	jne    801029e4 <iderw+0x39>
    panic("iderw: nothing to do");
801029d7:	83 ec 0c             	sub    $0xc,%esp
801029da:	68 7d 97 10 80       	push   $0x8010977d
801029df:	e8 82 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029e4:	8b 45 08             	mov    0x8(%ebp),%eax
801029e7:	8b 40 04             	mov    0x4(%eax),%eax
801029ea:	85 c0                	test   %eax,%eax
801029ec:	74 16                	je     80102a04 <iderw+0x59>
801029ee:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029f3:	85 c0                	test   %eax,%eax
801029f5:	75 0d                	jne    80102a04 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029f7:	83 ec 0c             	sub    $0xc,%esp
801029fa:	68 92 97 10 80       	push   $0x80109792
801029ff:	e8 62 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a04:	83 ec 0c             	sub    $0xc,%esp
80102a07:	68 20 c6 10 80       	push   $0x8010c620
80102a0c:	e8 f0 34 00 00       	call   80105f01 <acquire>
80102a11:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a14:	8b 45 08             	mov    0x8(%ebp),%eax
80102a17:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a1e:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102a25:	eb 0b                	jmp    80102a32 <iderw+0x87>
80102a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2a:	8b 00                	mov    (%eax),%eax
80102a2c:	83 c0 14             	add    $0x14,%eax
80102a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a35:	8b 00                	mov    (%eax),%eax
80102a37:	85 c0                	test   %eax,%eax
80102a39:	75 ec                	jne    80102a27 <iderw+0x7c>
    ;
  *pp = b;
80102a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3e:	8b 55 08             	mov    0x8(%ebp),%edx
80102a41:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a43:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a48:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a4b:	75 23                	jne    80102a70 <iderw+0xc5>
    idestart(b);
80102a4d:	83 ec 0c             	sub    $0xc,%esp
80102a50:	ff 75 08             	pushl  0x8(%ebp)
80102a53:	e8 20 fd ff ff       	call   80102778 <idestart>
80102a58:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a5b:	eb 13                	jmp    80102a70 <iderw+0xc5>
    sleep(b, &idelock);
80102a5d:	83 ec 08             	sub    $0x8,%esp
80102a60:	68 20 c6 10 80       	push   $0x8010c620
80102a65:	ff 75 08             	pushl  0x8(%ebp)
80102a68:	e8 90 28 00 00       	call   801052fd <sleep>
80102a6d:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a70:	8b 45 08             	mov    0x8(%ebp),%eax
80102a73:	8b 00                	mov    (%eax),%eax
80102a75:	83 e0 06             	and    $0x6,%eax
80102a78:	83 f8 02             	cmp    $0x2,%eax
80102a7b:	75 e0                	jne    80102a5d <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a7d:	83 ec 0c             	sub    $0xc,%esp
80102a80:	68 20 c6 10 80       	push   $0x8010c620
80102a85:	e8 de 34 00 00       	call   80105f68 <release>
80102a8a:	83 c4 10             	add    $0x10,%esp
}
80102a8d:	90                   	nop
80102a8e:	c9                   	leave  
80102a8f:	c3                   	ret    

80102a90 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a93:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a98:	8b 55 08             	mov    0x8(%ebp),%edx
80102a9b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a9d:	a1 34 32 11 80       	mov    0x80113234,%eax
80102aa2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102aa5:	5d                   	pop    %ebp
80102aa6:	c3                   	ret    

80102aa7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aa7:	55                   	push   %ebp
80102aa8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102aaa:	a1 34 32 11 80       	mov    0x80113234,%eax
80102aaf:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ab4:	a1 34 32 11 80       	mov    0x80113234,%eax
80102ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102abc:	89 50 10             	mov    %edx,0x10(%eax)
}
80102abf:	90                   	nop
80102ac0:	5d                   	pop    %ebp
80102ac1:	c3                   	ret    

80102ac2 <ioapicinit>:

void
ioapicinit(void)
{
80102ac2:	55                   	push   %ebp
80102ac3:	89 e5                	mov    %esp,%ebp
80102ac5:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102ac8:	a1 64 33 11 80       	mov    0x80113364,%eax
80102acd:	85 c0                	test   %eax,%eax
80102acf:	0f 84 a0 00 00 00    	je     80102b75 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ad5:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102adc:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102adf:	6a 01                	push   $0x1
80102ae1:	e8 aa ff ff ff       	call   80102a90 <ioapicread>
80102ae6:	83 c4 04             	add    $0x4,%esp
80102ae9:	c1 e8 10             	shr    $0x10,%eax
80102aec:	25 ff 00 00 00       	and    $0xff,%eax
80102af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102af4:	6a 00                	push   $0x0
80102af6:	e8 95 ff ff ff       	call   80102a90 <ioapicread>
80102afb:	83 c4 04             	add    $0x4,%esp
80102afe:	c1 e8 18             	shr    $0x18,%eax
80102b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b04:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102b0b:	0f b6 c0             	movzbl %al,%eax
80102b0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b11:	74 10                	je     80102b23 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b13:	83 ec 0c             	sub    $0xc,%esp
80102b16:	68 b0 97 10 80       	push   $0x801097b0
80102b1b:	e8 a6 d8 ff ff       	call   801003c6 <cprintf>
80102b20:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b2a:	eb 3f                	jmp    80102b6b <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2f:	83 c0 20             	add    $0x20,%eax
80102b32:	0d 00 00 01 00       	or     $0x10000,%eax
80102b37:	89 c2                	mov    %eax,%edx
80102b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b3c:	83 c0 08             	add    $0x8,%eax
80102b3f:	01 c0                	add    %eax,%eax
80102b41:	83 ec 08             	sub    $0x8,%esp
80102b44:	52                   	push   %edx
80102b45:	50                   	push   %eax
80102b46:	e8 5c ff ff ff       	call   80102aa7 <ioapicwrite>
80102b4b:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b51:	83 c0 08             	add    $0x8,%eax
80102b54:	01 c0                	add    %eax,%eax
80102b56:	83 c0 01             	add    $0x1,%eax
80102b59:	83 ec 08             	sub    $0x8,%esp
80102b5c:	6a 00                	push   $0x0
80102b5e:	50                   	push   %eax
80102b5f:	e8 43 ff ff ff       	call   80102aa7 <ioapicwrite>
80102b64:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b71:	7e b9                	jle    80102b2c <ioapicinit+0x6a>
80102b73:	eb 01                	jmp    80102b76 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b75:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b76:	c9                   	leave  
80102b77:	c3                   	ret    

80102b78 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b78:	55                   	push   %ebp
80102b79:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b7b:	a1 64 33 11 80       	mov    0x80113364,%eax
80102b80:	85 c0                	test   %eax,%eax
80102b82:	74 39                	je     80102bbd <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b84:	8b 45 08             	mov    0x8(%ebp),%eax
80102b87:	83 c0 20             	add    $0x20,%eax
80102b8a:	89 c2                	mov    %eax,%edx
80102b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8f:	83 c0 08             	add    $0x8,%eax
80102b92:	01 c0                	add    %eax,%eax
80102b94:	52                   	push   %edx
80102b95:	50                   	push   %eax
80102b96:	e8 0c ff ff ff       	call   80102aa7 <ioapicwrite>
80102b9b:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ba1:	c1 e0 18             	shl    $0x18,%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba9:	83 c0 08             	add    $0x8,%eax
80102bac:	01 c0                	add    %eax,%eax
80102bae:	83 c0 01             	add    $0x1,%eax
80102bb1:	52                   	push   %edx
80102bb2:	50                   	push   %eax
80102bb3:	e8 ef fe ff ff       	call   80102aa7 <ioapicwrite>
80102bb8:	83 c4 08             	add    $0x8,%esp
80102bbb:	eb 01                	jmp    80102bbe <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bbd:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bbe:	c9                   	leave  
80102bbf:	c3                   	ret    

80102bc0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc6:	05 00 00 00 80       	add    $0x80000000,%eax
80102bcb:	5d                   	pop    %ebp
80102bcc:	c3                   	ret    

80102bcd <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bcd:	55                   	push   %ebp
80102bce:	89 e5                	mov    %esp,%ebp
80102bd0:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bd3:	83 ec 08             	sub    $0x8,%esp
80102bd6:	68 e2 97 10 80       	push   $0x801097e2
80102bdb:	68 40 32 11 80       	push   $0x80113240
80102be0:	e8 fa 32 00 00       	call   80105edf <initlock>
80102be5:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102be8:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102bef:	00 00 00 
  freerange(vstart, vend);
80102bf2:	83 ec 08             	sub    $0x8,%esp
80102bf5:	ff 75 0c             	pushl  0xc(%ebp)
80102bf8:	ff 75 08             	pushl  0x8(%ebp)
80102bfb:	e8 2a 00 00 00       	call   80102c2a <freerange>
80102c00:	83 c4 10             	add    $0x10,%esp
}
80102c03:	90                   	nop
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    

80102c06 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c06:	55                   	push   %ebp
80102c07:	89 e5                	mov    %esp,%ebp
80102c09:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c0c:	83 ec 08             	sub    $0x8,%esp
80102c0f:	ff 75 0c             	pushl  0xc(%ebp)
80102c12:	ff 75 08             	pushl  0x8(%ebp)
80102c15:	e8 10 00 00 00       	call   80102c2a <freerange>
80102c1a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c1d:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102c24:	00 00 00 
}
80102c27:	90                   	nop
80102c28:	c9                   	leave  
80102c29:	c3                   	ret    

80102c2a <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c2a:	55                   	push   %ebp
80102c2b:	89 e5                	mov    %esp,%ebp
80102c2d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c30:	8b 45 08             	mov    0x8(%ebp),%eax
80102c33:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c40:	eb 15                	jmp    80102c57 <freerange+0x2d>
    kfree(p);
80102c42:	83 ec 0c             	sub    $0xc,%esp
80102c45:	ff 75 f4             	pushl  -0xc(%ebp)
80102c48:	e8 1a 00 00 00       	call   80102c67 <kfree>
80102c4d:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5a:	05 00 10 00 00       	add    $0x1000,%eax
80102c5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c62:	76 de                	jbe    80102c42 <freerange+0x18>
    kfree(p);
}
80102c64:	90                   	nop
80102c65:	c9                   	leave  
80102c66:	c3                   	ret    

80102c67 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c67:	55                   	push   %ebp
80102c68:	89 e5                	mov    %esp,%ebp
80102c6a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c70:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	75 1b                	jne    80102c94 <kfree+0x2d>
80102c79:	81 7d 08 3c 67 11 80 	cmpl   $0x8011673c,0x8(%ebp)
80102c80:	72 12                	jb     80102c94 <kfree+0x2d>
80102c82:	ff 75 08             	pushl  0x8(%ebp)
80102c85:	e8 36 ff ff ff       	call   80102bc0 <v2p>
80102c8a:	83 c4 04             	add    $0x4,%esp
80102c8d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c92:	76 0d                	jbe    80102ca1 <kfree+0x3a>
    panic("kfree");
80102c94:	83 ec 0c             	sub    $0xc,%esp
80102c97:	68 e7 97 10 80       	push   $0x801097e7
80102c9c:	e8 c5 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca1:	83 ec 04             	sub    $0x4,%esp
80102ca4:	68 00 10 00 00       	push   $0x1000
80102ca9:	6a 01                	push   $0x1
80102cab:	ff 75 08             	pushl  0x8(%ebp)
80102cae:	e8 b1 34 00 00       	call   80106164 <memset>
80102cb3:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cb6:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cbb:	85 c0                	test   %eax,%eax
80102cbd:	74 10                	je     80102ccf <kfree+0x68>
    acquire(&kmem.lock);
80102cbf:	83 ec 0c             	sub    $0xc,%esp
80102cc2:	68 40 32 11 80       	push   $0x80113240
80102cc7:	e8 35 32 00 00       	call   80105f01 <acquire>
80102ccc:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cd5:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cde:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce3:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ce8:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ced:	85 c0                	test   %eax,%eax
80102cef:	74 10                	je     80102d01 <kfree+0x9a>
    release(&kmem.lock);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	68 40 32 11 80       	push   $0x80113240
80102cf9:	e8 6a 32 00 00       	call   80105f68 <release>
80102cfe:	83 c4 10             	add    $0x10,%esp
}
80102d01:	90                   	nop
80102d02:	c9                   	leave  
80102d03:	c3                   	ret    

80102d04 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d04:	55                   	push   %ebp
80102d05:	89 e5                	mov    %esp,%ebp
80102d07:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d0a:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	74 10                	je     80102d23 <kalloc+0x1f>
    acquire(&kmem.lock);
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	68 40 32 11 80       	push   $0x80113240
80102d1b:	e8 e1 31 00 00       	call   80105f01 <acquire>
80102d20:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d23:	a1 78 32 11 80       	mov    0x80113278,%eax
80102d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d2f:	74 0a                	je     80102d3b <kalloc+0x37>
    kmem.freelist = r->next;
80102d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d34:	8b 00                	mov    (%eax),%eax
80102d36:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102d3b:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d40:	85 c0                	test   %eax,%eax
80102d42:	74 10                	je     80102d54 <kalloc+0x50>
    release(&kmem.lock);
80102d44:	83 ec 0c             	sub    $0xc,%esp
80102d47:	68 40 32 11 80       	push   $0x80113240
80102d4c:	e8 17 32 00 00       	call   80105f68 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d57:	c9                   	leave  
80102d58:	c3                   	ret    

80102d59 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d59:	55                   	push   %ebp
80102d5a:	89 e5                	mov    %esp,%ebp
80102d5c:	83 ec 14             	sub    $0x14,%esp
80102d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d62:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d66:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d6a:	89 c2                	mov    %eax,%edx
80102d6c:	ec                   	in     (%dx),%al
80102d6d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d70:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d74:	c9                   	leave  
80102d75:	c3                   	ret    

80102d76 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d76:	55                   	push   %ebp
80102d77:	89 e5                	mov    %esp,%ebp
80102d79:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d7c:	6a 64                	push   $0x64
80102d7e:	e8 d6 ff ff ff       	call   80102d59 <inb>
80102d83:	83 c4 04             	add    $0x4,%esp
80102d86:	0f b6 c0             	movzbl %al,%eax
80102d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d8f:	83 e0 01             	and    $0x1,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 0a                	jne    80102da0 <kbdgetc+0x2a>
    return -1;
80102d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d9b:	e9 23 01 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102da0:	6a 60                	push   $0x60
80102da2:	e8 b2 ff ff ff       	call   80102d59 <inb>
80102da7:	83 c4 04             	add    $0x4,%esp
80102daa:	0f b6 c0             	movzbl %al,%eax
80102dad:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102db0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102db7:	75 17                	jne    80102dd0 <kbdgetc+0x5a>
    shift |= E0ESC;
80102db9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dbe:	83 c8 40             	or     $0x40,%eax
80102dc1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102dc6:	b8 00 00 00 00       	mov    $0x0,%eax
80102dcb:	e9 f3 00 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd3:	25 80 00 00 00       	and    $0x80,%eax
80102dd8:	85 c0                	test   %eax,%eax
80102dda:	74 45                	je     80102e21 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ddc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102de1:	83 e0 40             	and    $0x40,%eax
80102de4:	85 c0                	test   %eax,%eax
80102de6:	75 08                	jne    80102df0 <kbdgetc+0x7a>
80102de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102deb:	83 e0 7f             	and    $0x7f,%eax
80102dee:	eb 03                	jmp    80102df3 <kbdgetc+0x7d>
80102df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102df6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df9:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dfe:	0f b6 00             	movzbl (%eax),%eax
80102e01:	83 c8 40             	or     $0x40,%eax
80102e04:	0f b6 c0             	movzbl %al,%eax
80102e07:	f7 d0                	not    %eax
80102e09:	89 c2                	mov    %eax,%edx
80102e0b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e10:	21 d0                	and    %edx,%eax
80102e12:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102e17:	b8 00 00 00 00       	mov    $0x0,%eax
80102e1c:	e9 a2 00 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e21:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e26:	83 e0 40             	and    $0x40,%eax
80102e29:	85 c0                	test   %eax,%eax
80102e2b:	74 14                	je     80102e41 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e2d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e34:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e39:	83 e0 bf             	and    $0xffffffbf,%eax
80102e3c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e44:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e49:	0f b6 00             	movzbl (%eax),%eax
80102e4c:	0f b6 d0             	movzbl %al,%edx
80102e4f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e54:	09 d0                	or     %edx,%eax
80102e56:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e5e:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e63:	0f b6 00             	movzbl (%eax),%eax
80102e66:	0f b6 d0             	movzbl %al,%edx
80102e69:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e6e:	31 d0                	xor    %edx,%eax
80102e70:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e75:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e7a:	83 e0 03             	and    $0x3,%eax
80102e7d:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e87:	01 d0                	add    %edx,%eax
80102e89:	0f b6 00             	movzbl (%eax),%eax
80102e8c:	0f b6 c0             	movzbl %al,%eax
80102e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e92:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e97:	83 e0 08             	and    $0x8,%eax
80102e9a:	85 c0                	test   %eax,%eax
80102e9c:	74 22                	je     80102ec0 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e9e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ea2:	76 0c                	jbe    80102eb0 <kbdgetc+0x13a>
80102ea4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ea8:	77 06                	ja     80102eb0 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102eaa:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102eae:	eb 10                	jmp    80102ec0 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102eb0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102eb4:	76 0a                	jbe    80102ec0 <kbdgetc+0x14a>
80102eb6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102eba:	77 04                	ja     80102ec0 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ebc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ec3:	c9                   	leave  
80102ec4:	c3                   	ret    

80102ec5 <kbdintr>:

void
kbdintr(void)
{
80102ec5:	55                   	push   %ebp
80102ec6:	89 e5                	mov    %esp,%ebp
80102ec8:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ecb:	83 ec 0c             	sub    $0xc,%esp
80102ece:	68 76 2d 10 80       	push   $0x80102d76
80102ed3:	e8 21 d9 ff ff       	call   801007f9 <consoleintr>
80102ed8:	83 c4 10             	add    $0x10,%esp
}
80102edb:	90                   	nop
80102edc:	c9                   	leave  
80102edd:	c3                   	ret    

80102ede <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ede:	55                   	push   %ebp
80102edf:	89 e5                	mov    %esp,%ebp
80102ee1:	83 ec 14             	sub    $0x14,%esp
80102ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ee7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eeb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102eef:	89 c2                	mov    %eax,%edx
80102ef1:	ec                   	in     (%dx),%al
80102ef2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ef5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ef9:	c9                   	leave  
80102efa:	c3                   	ret    

80102efb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102efb:	55                   	push   %ebp
80102efc:	89 e5                	mov    %esp,%ebp
80102efe:	83 ec 08             	sub    $0x8,%esp
80102f01:	8b 55 08             	mov    0x8(%ebp),%edx
80102f04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f07:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f0b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f12:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f16:	ee                   	out    %al,(%dx)
}
80102f17:	90                   	nop
80102f18:	c9                   	leave  
80102f19:	c3                   	ret    

80102f1a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f20:	9c                   	pushf  
80102f21:	58                   	pop    %eax
80102f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f28:	c9                   	leave  
80102f29:	c3                   	ret    

80102f2a <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f2a:	55                   	push   %ebp
80102f2b:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f2d:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f32:	8b 55 08             	mov    0x8(%ebp),%edx
80102f35:	c1 e2 02             	shl    $0x2,%edx
80102f38:	01 c2                	add    %eax,%edx
80102f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f3d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f3f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f44:	83 c0 20             	add    $0x20,%eax
80102f47:	8b 00                	mov    (%eax),%eax
}
80102f49:	90                   	nop
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    

80102f4c <lapicinit>:

void
lapicinit(void)
{
80102f4c:	55                   	push   %ebp
80102f4d:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f4f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f54:	85 c0                	test   %eax,%eax
80102f56:	0f 84 0b 01 00 00    	je     80103067 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f5c:	68 3f 01 00 00       	push   $0x13f
80102f61:	6a 3c                	push   $0x3c
80102f63:	e8 c2 ff ff ff       	call   80102f2a <lapicw>
80102f68:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f6b:	6a 0b                	push   $0xb
80102f6d:	68 f8 00 00 00       	push   $0xf8
80102f72:	e8 b3 ff ff ff       	call   80102f2a <lapicw>
80102f77:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f7a:	68 20 00 02 00       	push   $0x20020
80102f7f:	68 c8 00 00 00       	push   $0xc8
80102f84:	e8 a1 ff ff ff       	call   80102f2a <lapicw>
80102f89:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80102f8c:	68 40 42 0f 00       	push   $0xf4240
80102f91:	68 e0 00 00 00       	push   $0xe0
80102f96:	e8 8f ff ff ff       	call   80102f2a <lapicw>
80102f9b:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f9e:	68 00 00 01 00       	push   $0x10000
80102fa3:	68 d4 00 00 00       	push   $0xd4
80102fa8:	e8 7d ff ff ff       	call   80102f2a <lapicw>
80102fad:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fb0:	68 00 00 01 00       	push   $0x10000
80102fb5:	68 d8 00 00 00       	push   $0xd8
80102fba:	e8 6b ff ff ff       	call   80102f2a <lapicw>
80102fbf:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fc2:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fc7:	83 c0 30             	add    $0x30,%eax
80102fca:	8b 00                	mov    (%eax),%eax
80102fcc:	c1 e8 10             	shr    $0x10,%eax
80102fcf:	0f b6 c0             	movzbl %al,%eax
80102fd2:	83 f8 03             	cmp    $0x3,%eax
80102fd5:	76 12                	jbe    80102fe9 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fd7:	68 00 00 01 00       	push   $0x10000
80102fdc:	68 d0 00 00 00       	push   $0xd0
80102fe1:	e8 44 ff ff ff       	call   80102f2a <lapicw>
80102fe6:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102fe9:	6a 33                	push   $0x33
80102feb:	68 dc 00 00 00       	push   $0xdc
80102ff0:	e8 35 ff ff ff       	call   80102f2a <lapicw>
80102ff5:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ff8:	6a 00                	push   $0x0
80102ffa:	68 a0 00 00 00       	push   $0xa0
80102fff:	e8 26 ff ff ff       	call   80102f2a <lapicw>
80103004:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103007:	6a 00                	push   $0x0
80103009:	68 a0 00 00 00       	push   $0xa0
8010300e:	e8 17 ff ff ff       	call   80102f2a <lapicw>
80103013:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103016:	6a 00                	push   $0x0
80103018:	6a 2c                	push   $0x2c
8010301a:	e8 0b ff ff ff       	call   80102f2a <lapicw>
8010301f:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103022:	6a 00                	push   $0x0
80103024:	68 c4 00 00 00       	push   $0xc4
80103029:	e8 fc fe ff ff       	call   80102f2a <lapicw>
8010302e:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103031:	68 00 85 08 00       	push   $0x88500
80103036:	68 c0 00 00 00       	push   $0xc0
8010303b:	e8 ea fe ff ff       	call   80102f2a <lapicw>
80103040:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103043:	90                   	nop
80103044:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103049:	05 00 03 00 00       	add    $0x300,%eax
8010304e:	8b 00                	mov    (%eax),%eax
80103050:	25 00 10 00 00       	and    $0x1000,%eax
80103055:	85 c0                	test   %eax,%eax
80103057:	75 eb                	jne    80103044 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103059:	6a 00                	push   $0x0
8010305b:	6a 20                	push   $0x20
8010305d:	e8 c8 fe ff ff       	call   80102f2a <lapicw>
80103062:	83 c4 08             	add    $0x8,%esp
80103065:	eb 01                	jmp    80103068 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103067:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103068:	c9                   	leave  
80103069:	c3                   	ret    

8010306a <cpunum>:

int
cpunum(void)
{
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103070:	e8 a5 fe ff ff       	call   80102f1a <readeflags>
80103075:	25 00 02 00 00       	and    $0x200,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	74 26                	je     801030a4 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010307e:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80103083:	8d 50 01             	lea    0x1(%eax),%edx
80103086:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
8010308c:	85 c0                	test   %eax,%eax
8010308e:	75 14                	jne    801030a4 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103090:	8b 45 04             	mov    0x4(%ebp),%eax
80103093:	83 ec 08             	sub    $0x8,%esp
80103096:	50                   	push   %eax
80103097:	68 f0 97 10 80       	push   $0x801097f0
8010309c:	e8 25 d3 ff ff       	call   801003c6 <cprintf>
801030a1:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030a4:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030a9:	85 c0                	test   %eax,%eax
801030ab:	74 0f                	je     801030bc <cpunum+0x52>
    return lapic[ID]>>24;
801030ad:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030b2:	83 c0 20             	add    $0x20,%eax
801030b5:	8b 00                	mov    (%eax),%eax
801030b7:	c1 e8 18             	shr    $0x18,%eax
801030ba:	eb 05                	jmp    801030c1 <cpunum+0x57>
  return 0;
801030bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030c1:	c9                   	leave  
801030c2:	c3                   	ret    

801030c3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030c3:	55                   	push   %ebp
801030c4:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030c6:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030cb:	85 c0                	test   %eax,%eax
801030cd:	74 0c                	je     801030db <lapiceoi+0x18>
    lapicw(EOI, 0);
801030cf:	6a 00                	push   $0x0
801030d1:	6a 2c                	push   $0x2c
801030d3:	e8 52 fe ff ff       	call   80102f2a <lapicw>
801030d8:	83 c4 08             	add    $0x8,%esp
}
801030db:	90                   	nop
801030dc:	c9                   	leave  
801030dd:	c3                   	ret    

801030de <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030de:	55                   	push   %ebp
801030df:	89 e5                	mov    %esp,%ebp
}
801030e1:	90                   	nop
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    

801030e4 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030e4:	55                   	push   %ebp
801030e5:	89 e5                	mov    %esp,%ebp
801030e7:	83 ec 14             	sub    $0x14,%esp
801030ea:	8b 45 08             	mov    0x8(%ebp),%eax
801030ed:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030f0:	6a 0f                	push   $0xf
801030f2:	6a 70                	push   $0x70
801030f4:	e8 02 fe ff ff       	call   80102efb <outb>
801030f9:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030fc:	6a 0a                	push   $0xa
801030fe:	6a 71                	push   $0x71
80103100:	e8 f6 fd ff ff       	call   80102efb <outb>
80103105:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103108:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010310f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103112:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010311a:	83 c0 02             	add    $0x2,%eax
8010311d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103120:	c1 ea 04             	shr    $0x4,%edx
80103123:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103126:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010312a:	c1 e0 18             	shl    $0x18,%eax
8010312d:	50                   	push   %eax
8010312e:	68 c4 00 00 00       	push   $0xc4
80103133:	e8 f2 fd ff ff       	call   80102f2a <lapicw>
80103138:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010313b:	68 00 c5 00 00       	push   $0xc500
80103140:	68 c0 00 00 00       	push   $0xc0
80103145:	e8 e0 fd ff ff       	call   80102f2a <lapicw>
8010314a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010314d:	68 c8 00 00 00       	push   $0xc8
80103152:	e8 87 ff ff ff       	call   801030de <microdelay>
80103157:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010315a:	68 00 85 00 00       	push   $0x8500
8010315f:	68 c0 00 00 00       	push   $0xc0
80103164:	e8 c1 fd ff ff       	call   80102f2a <lapicw>
80103169:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010316c:	6a 64                	push   $0x64
8010316e:	e8 6b ff ff ff       	call   801030de <microdelay>
80103173:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010317d:	eb 3d                	jmp    801031bc <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010317f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103183:	c1 e0 18             	shl    $0x18,%eax
80103186:	50                   	push   %eax
80103187:	68 c4 00 00 00       	push   $0xc4
8010318c:	e8 99 fd ff ff       	call   80102f2a <lapicw>
80103191:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103194:	8b 45 0c             	mov    0xc(%ebp),%eax
80103197:	c1 e8 0c             	shr    $0xc,%eax
8010319a:	80 cc 06             	or     $0x6,%ah
8010319d:	50                   	push   %eax
8010319e:	68 c0 00 00 00       	push   $0xc0
801031a3:	e8 82 fd ff ff       	call   80102f2a <lapicw>
801031a8:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031ab:	68 c8 00 00 00       	push   $0xc8
801031b0:	e8 29 ff ff ff       	call   801030de <microdelay>
801031b5:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031bc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031c0:	7e bd                	jle    8010317f <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031c2:	90                   	nop
801031c3:	c9                   	leave  
801031c4:	c3                   	ret    

801031c5 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031c5:	55                   	push   %ebp
801031c6:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031c8:	8b 45 08             	mov    0x8(%ebp),%eax
801031cb:	0f b6 c0             	movzbl %al,%eax
801031ce:	50                   	push   %eax
801031cf:	6a 70                	push   $0x70
801031d1:	e8 25 fd ff ff       	call   80102efb <outb>
801031d6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031d9:	68 c8 00 00 00       	push   $0xc8
801031de:	e8 fb fe ff ff       	call   801030de <microdelay>
801031e3:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031e6:	6a 71                	push   $0x71
801031e8:	e8 f1 fc ff ff       	call   80102ede <inb>
801031ed:	83 c4 04             	add    $0x4,%esp
801031f0:	0f b6 c0             	movzbl %al,%eax
}
801031f3:	c9                   	leave  
801031f4:	c3                   	ret    

801031f5 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031f5:	55                   	push   %ebp
801031f6:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031f8:	6a 00                	push   $0x0
801031fa:	e8 c6 ff ff ff       	call   801031c5 <cmos_read>
801031ff:	83 c4 04             	add    $0x4,%esp
80103202:	89 c2                	mov    %eax,%edx
80103204:	8b 45 08             	mov    0x8(%ebp),%eax
80103207:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103209:	6a 02                	push   $0x2
8010320b:	e8 b5 ff ff ff       	call   801031c5 <cmos_read>
80103210:	83 c4 04             	add    $0x4,%esp
80103213:	89 c2                	mov    %eax,%edx
80103215:	8b 45 08             	mov    0x8(%ebp),%eax
80103218:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010321b:	6a 04                	push   $0x4
8010321d:	e8 a3 ff ff ff       	call   801031c5 <cmos_read>
80103222:	83 c4 04             	add    $0x4,%esp
80103225:	89 c2                	mov    %eax,%edx
80103227:	8b 45 08             	mov    0x8(%ebp),%eax
8010322a:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010322d:	6a 07                	push   $0x7
8010322f:	e8 91 ff ff ff       	call   801031c5 <cmos_read>
80103234:	83 c4 04             	add    $0x4,%esp
80103237:	89 c2                	mov    %eax,%edx
80103239:	8b 45 08             	mov    0x8(%ebp),%eax
8010323c:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010323f:	6a 08                	push   $0x8
80103241:	e8 7f ff ff ff       	call   801031c5 <cmos_read>
80103246:	83 c4 04             	add    $0x4,%esp
80103249:	89 c2                	mov    %eax,%edx
8010324b:	8b 45 08             	mov    0x8(%ebp),%eax
8010324e:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103251:	6a 09                	push   $0x9
80103253:	e8 6d ff ff ff       	call   801031c5 <cmos_read>
80103258:	83 c4 04             	add    $0x4,%esp
8010325b:	89 c2                	mov    %eax,%edx
8010325d:	8b 45 08             	mov    0x8(%ebp),%eax
80103260:	89 50 14             	mov    %edx,0x14(%eax)
}
80103263:	90                   	nop
80103264:	c9                   	leave  
80103265:	c3                   	ret    

80103266 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
80103269:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010326c:	6a 0b                	push   $0xb
8010326e:	e8 52 ff ff ff       	call   801031c5 <cmos_read>
80103273:	83 c4 04             	add    $0x4,%esp
80103276:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327c:	83 e0 04             	and    $0x4,%eax
8010327f:	85 c0                	test   %eax,%eax
80103281:	0f 94 c0             	sete   %al
80103284:	0f b6 c0             	movzbl %al,%eax
80103287:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010328a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010328d:	50                   	push   %eax
8010328e:	e8 62 ff ff ff       	call   801031f5 <fill_rtcdate>
80103293:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103296:	6a 0a                	push   $0xa
80103298:	e8 28 ff ff ff       	call   801031c5 <cmos_read>
8010329d:	83 c4 04             	add    $0x4,%esp
801032a0:	25 80 00 00 00       	and    $0x80,%eax
801032a5:	85 c0                	test   %eax,%eax
801032a7:	75 27                	jne    801032d0 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032a9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032ac:	50                   	push   %eax
801032ad:	e8 43 ff ff ff       	call   801031f5 <fill_rtcdate>
801032b2:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032b5:	83 ec 04             	sub    $0x4,%esp
801032b8:	6a 18                	push   $0x18
801032ba:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032bd:	50                   	push   %eax
801032be:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032c1:	50                   	push   %eax
801032c2:	e8 04 2f 00 00       	call   801061cb <memcmp>
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 05                	je     801032d3 <cmostime+0x6d>
801032ce:	eb ba                	jmp    8010328a <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032d0:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032d1:	eb b7                	jmp    8010328a <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032d3:	90                   	nop
  }

  // convert
  if (bcd) {
801032d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032d8:	0f 84 b4 00 00 00    	je     80103392 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032de:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032e1:	c1 e8 04             	shr    $0x4,%eax
801032e4:	89 c2                	mov    %eax,%edx
801032e6:	89 d0                	mov    %edx,%eax
801032e8:	c1 e0 02             	shl    $0x2,%eax
801032eb:	01 d0                	add    %edx,%eax
801032ed:	01 c0                	add    %eax,%eax
801032ef:	89 c2                	mov    %eax,%edx
801032f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032f4:	83 e0 0f             	and    $0xf,%eax
801032f7:	01 d0                	add    %edx,%eax
801032f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032ff:	c1 e8 04             	shr    $0x4,%eax
80103302:	89 c2                	mov    %eax,%edx
80103304:	89 d0                	mov    %edx,%eax
80103306:	c1 e0 02             	shl    $0x2,%eax
80103309:	01 d0                	add    %edx,%eax
8010330b:	01 c0                	add    %eax,%eax
8010330d:	89 c2                	mov    %eax,%edx
8010330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103312:	83 e0 0f             	and    $0xf,%eax
80103315:	01 d0                	add    %edx,%eax
80103317:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010331a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010331d:	c1 e8 04             	shr    $0x4,%eax
80103320:	89 c2                	mov    %eax,%edx
80103322:	89 d0                	mov    %edx,%eax
80103324:	c1 e0 02             	shl    $0x2,%eax
80103327:	01 d0                	add    %edx,%eax
80103329:	01 c0                	add    %eax,%eax
8010332b:	89 c2                	mov    %eax,%edx
8010332d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103330:	83 e0 0f             	and    $0xf,%eax
80103333:	01 d0                	add    %edx,%eax
80103335:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010333b:	c1 e8 04             	shr    $0x4,%eax
8010333e:	89 c2                	mov    %eax,%edx
80103340:	89 d0                	mov    %edx,%eax
80103342:	c1 e0 02             	shl    $0x2,%eax
80103345:	01 d0                	add    %edx,%eax
80103347:	01 c0                	add    %eax,%eax
80103349:	89 c2                	mov    %eax,%edx
8010334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010334e:	83 e0 0f             	and    $0xf,%eax
80103351:	01 d0                	add    %edx,%eax
80103353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103356:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103359:	c1 e8 04             	shr    $0x4,%eax
8010335c:	89 c2                	mov    %eax,%edx
8010335e:	89 d0                	mov    %edx,%eax
80103360:	c1 e0 02             	shl    $0x2,%eax
80103363:	01 d0                	add    %edx,%eax
80103365:	01 c0                	add    %eax,%eax
80103367:	89 c2                	mov    %eax,%edx
80103369:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010336c:	83 e0 0f             	and    $0xf,%eax
8010336f:	01 d0                	add    %edx,%eax
80103371:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103374:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103377:	c1 e8 04             	shr    $0x4,%eax
8010337a:	89 c2                	mov    %eax,%edx
8010337c:	89 d0                	mov    %edx,%eax
8010337e:	c1 e0 02             	shl    $0x2,%eax
80103381:	01 d0                	add    %edx,%eax
80103383:	01 c0                	add    %eax,%eax
80103385:	89 c2                	mov    %eax,%edx
80103387:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338a:	83 e0 0f             	and    $0xf,%eax
8010338d:	01 d0                	add    %edx,%eax
8010338f:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103392:	8b 45 08             	mov    0x8(%ebp),%eax
80103395:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103398:	89 10                	mov    %edx,(%eax)
8010339a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010339d:	89 50 04             	mov    %edx,0x4(%eax)
801033a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033a3:	89 50 08             	mov    %edx,0x8(%eax)
801033a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033a9:	89 50 0c             	mov    %edx,0xc(%eax)
801033ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033af:	89 50 10             	mov    %edx,0x10(%eax)
801033b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033b5:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033b8:	8b 45 08             	mov    0x8(%ebp),%eax
801033bb:	8b 40 14             	mov    0x14(%eax),%eax
801033be:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033c4:	8b 45 08             	mov    0x8(%ebp),%eax
801033c7:	89 50 14             	mov    %edx,0x14(%eax)
}
801033ca:	90                   	nop
801033cb:	c9                   	leave  
801033cc:	c3                   	ret    

801033cd <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033cd:	55                   	push   %ebp
801033ce:	89 e5                	mov    %esp,%ebp
801033d0:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 1c 98 10 80       	push   $0x8010981c
801033db:	68 80 32 11 80       	push   $0x80113280
801033e0:	e8 fa 2a 00 00       	call   80105edf <initlock>
801033e5:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033e8:	83 ec 08             	sub    $0x8,%esp
801033eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033ee:	50                   	push   %eax
801033ef:	ff 75 08             	pushl  0x8(%ebp)
801033f2:	e8 2b e0 ff ff       	call   80101422 <readsb>
801033f7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fd:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103402:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103405:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
8010340a:	8b 45 08             	mov    0x8(%ebp),%eax
8010340d:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
80103412:	e8 b2 01 00 00       	call   801035c9 <recover_from_log>
}
80103417:	90                   	nop
80103418:	c9                   	leave  
80103419:	c3                   	ret    

8010341a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010341a:	55                   	push   %ebp
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103427:	e9 95 00 00 00       	jmp    801034c1 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010342c:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103435:	01 d0                	add    %edx,%eax
80103437:	83 c0 01             	add    $0x1,%eax
8010343a:	89 c2                	mov    %eax,%edx
8010343c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103441:	83 ec 08             	sub    $0x8,%esp
80103444:	52                   	push   %edx
80103445:	50                   	push   %eax
80103446:	e8 6b cd ff ff       	call   801001b6 <bread>
8010344b:	83 c4 10             	add    $0x10,%esp
8010344e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103454:	83 c0 10             	add    $0x10,%eax
80103457:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010345e:	89 c2                	mov    %eax,%edx
80103460:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103465:	83 ec 08             	sub    $0x8,%esp
80103468:	52                   	push   %edx
80103469:	50                   	push   %eax
8010346a:	e8 47 cd ff ff       	call   801001b6 <bread>
8010346f:	83 c4 10             	add    $0x10,%esp
80103472:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103478:	8d 50 18             	lea    0x18(%eax),%edx
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	83 c0 18             	add    $0x18,%eax
80103481:	83 ec 04             	sub    $0x4,%esp
80103484:	68 00 02 00 00       	push   $0x200
80103489:	52                   	push   %edx
8010348a:	50                   	push   %eax
8010348b:	e8 93 2d 00 00       	call   80106223 <memmove>
80103490:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103493:	83 ec 0c             	sub    $0xc,%esp
80103496:	ff 75 ec             	pushl  -0x14(%ebp)
80103499:	e8 51 cd ff ff       	call   801001ef <bwrite>
8010349e:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034a1:	83 ec 0c             	sub    $0xc,%esp
801034a4:	ff 75 f0             	pushl  -0x10(%ebp)
801034a7:	e8 82 cd ff ff       	call   8010022e <brelse>
801034ac:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034af:	83 ec 0c             	sub    $0xc,%esp
801034b2:	ff 75 ec             	pushl  -0x14(%ebp)
801034b5:	e8 74 cd ff ff       	call   8010022e <brelse>
801034ba:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c1:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034c9:	0f 8f 5d ff ff ff    	jg     8010342c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034cf:	90                   	nop
801034d0:	c9                   	leave  
801034d1:	c3                   	ret    

801034d2 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034d2:	55                   	push   %ebp
801034d3:	89 e5                	mov    %esp,%ebp
801034d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034d8:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801034dd:	89 c2                	mov    %eax,%edx
801034df:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801034e4:	83 ec 08             	sub    $0x8,%esp
801034e7:	52                   	push   %edx
801034e8:	50                   	push   %eax
801034e9:	e8 c8 cc ff ff       	call   801001b6 <bread>
801034ee:	83 c4 10             	add    $0x10,%esp
801034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f7:	83 c0 18             	add    $0x18,%eax
801034fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103500:	8b 00                	mov    (%eax),%eax
80103502:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
80103507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010350e:	eb 1b                	jmp    8010352b <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103513:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103516:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010351a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351d:	83 c2 10             	add    $0x10,%edx
80103520:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103527:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010352b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103530:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103533:	7f db                	jg     80103510 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	ff 75 f0             	pushl  -0x10(%ebp)
8010353b:	e8 ee cc ff ff       	call   8010022e <brelse>
80103540:	83 c4 10             	add    $0x10,%esp
}
80103543:	90                   	nop
80103544:	c9                   	leave  
80103545:	c3                   	ret    

80103546 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
80103549:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010354c:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103551:	89 c2                	mov    %eax,%edx
80103553:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103558:	83 ec 08             	sub    $0x8,%esp
8010355b:	52                   	push   %edx
8010355c:	50                   	push   %eax
8010355d:	e8 54 cc ff ff       	call   801001b6 <bread>
80103562:	83 c4 10             	add    $0x10,%esp
80103565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103568:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010356b:	83 c0 18             	add    $0x18,%eax
8010356e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103571:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103577:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010357a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010357c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103583:	eb 1b                	jmp    801035a0 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103588:	83 c0 10             	add    $0x10,%eax
8010358b:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103592:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103598:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010359c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a0:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801035a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035a8:	7f db                	jg     80103585 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035aa:	83 ec 0c             	sub    $0xc,%esp
801035ad:	ff 75 f0             	pushl  -0x10(%ebp)
801035b0:	e8 3a cc ff ff       	call   801001ef <bwrite>
801035b5:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	ff 75 f0             	pushl  -0x10(%ebp)
801035be:	e8 6b cc ff ff       	call   8010022e <brelse>
801035c3:	83 c4 10             	add    $0x10,%esp
}
801035c6:	90                   	nop
801035c7:	c9                   	leave  
801035c8:	c3                   	ret    

801035c9 <recover_from_log>:

static void
recover_from_log(void)
{
801035c9:	55                   	push   %ebp
801035ca:	89 e5                	mov    %esp,%ebp
801035cc:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035cf:	e8 fe fe ff ff       	call   801034d2 <read_head>
  install_trans(); // if committed, copy from log to disk
801035d4:	e8 41 fe ff ff       	call   8010341a <install_trans>
  log.lh.n = 0;
801035d9:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801035e0:	00 00 00 
  write_head(); // clear the log
801035e3:	e8 5e ff ff ff       	call   80103546 <write_head>
}
801035e8:	90                   	nop
801035e9:	c9                   	leave  
801035ea:	c3                   	ret    

801035eb <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035eb:	55                   	push   %ebp
801035ec:	89 e5                	mov    %esp,%ebp
801035ee:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 03 29 00 00       	call   80105f01 <acquire>
801035fe:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103601:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103606:	85 c0                	test   %eax,%eax
80103608:	74 17                	je     80103621 <begin_op+0x36>
      sleep(&log, &log.lock);
8010360a:	83 ec 08             	sub    $0x8,%esp
8010360d:	68 80 32 11 80       	push   $0x80113280
80103612:	68 80 32 11 80       	push   $0x80113280
80103617:	e8 e1 1c 00 00       	call   801052fd <sleep>
8010361c:	83 c4 10             	add    $0x10,%esp
8010361f:	eb e0                	jmp    80103601 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103621:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
80103627:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010362c:	8d 50 01             	lea    0x1(%eax),%edx
8010362f:	89 d0                	mov    %edx,%eax
80103631:	c1 e0 02             	shl    $0x2,%eax
80103634:	01 d0                	add    %edx,%eax
80103636:	01 c0                	add    %eax,%eax
80103638:	01 c8                	add    %ecx,%eax
8010363a:	83 f8 1e             	cmp    $0x1e,%eax
8010363d:	7e 17                	jle    80103656 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010363f:	83 ec 08             	sub    $0x8,%esp
80103642:	68 80 32 11 80       	push   $0x80113280
80103647:	68 80 32 11 80       	push   $0x80113280
8010364c:	e8 ac 1c 00 00       	call   801052fd <sleep>
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	eb ab                	jmp    80103601 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103656:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010365b:	83 c0 01             	add    $0x1,%eax
8010365e:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103663:	83 ec 0c             	sub    $0xc,%esp
80103666:	68 80 32 11 80       	push   $0x80113280
8010366b:	e8 f8 28 00 00       	call   80105f68 <release>
80103670:	83 c4 10             	add    $0x10,%esp
      break;
80103673:	90                   	nop
    }
  }
}
80103674:	90                   	nop
80103675:	c9                   	leave  
80103676:	c3                   	ret    

80103677 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103677:	55                   	push   %ebp
80103678:	89 e5                	mov    %esp,%ebp
8010367a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010367d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	68 80 32 11 80       	push   $0x80113280
8010368c:	e8 70 28 00 00       	call   80105f01 <acquire>
80103691:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103694:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103699:	83 e8 01             	sub    $0x1,%eax
8010369c:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801036a1:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801036a6:	85 c0                	test   %eax,%eax
801036a8:	74 0d                	je     801036b7 <end_op+0x40>
    panic("log.committing");
801036aa:	83 ec 0c             	sub    $0xc,%esp
801036ad:	68 20 98 10 80       	push   $0x80109820
801036b2:	e8 af ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036b7:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036bc:	85 c0                	test   %eax,%eax
801036be:	75 13                	jne    801036d3 <end_op+0x5c>
    do_commit = 1;
801036c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036c7:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801036ce:	00 00 00 
801036d1:	eb 10                	jmp    801036e3 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	68 80 32 11 80       	push   $0x80113280
801036db:	e8 d1 1d 00 00       	call   801054b1 <wakeup>
801036e0:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036e3:	83 ec 0c             	sub    $0xc,%esp
801036e6:	68 80 32 11 80       	push   $0x80113280
801036eb:	e8 78 28 00 00       	call   80105f68 <release>
801036f0:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036f7:	74 3f                	je     80103738 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036f9:	e8 f5 00 00 00       	call   801037f3 <commit>
    acquire(&log.lock);
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	68 80 32 11 80       	push   $0x80113280
80103706:	e8 f6 27 00 00       	call   80105f01 <acquire>
8010370b:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010370e:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103715:	00 00 00 
    wakeup(&log);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	68 80 32 11 80       	push   $0x80113280
80103720:	e8 8c 1d 00 00       	call   801054b1 <wakeup>
80103725:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103728:	83 ec 0c             	sub    $0xc,%esp
8010372b:	68 80 32 11 80       	push   $0x80113280
80103730:	e8 33 28 00 00       	call   80105f68 <release>
80103735:	83 c4 10             	add    $0x10,%esp
  }
}
80103738:	90                   	nop
80103739:	c9                   	leave  
8010373a:	c3                   	ret    

8010373b <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010373b:	55                   	push   %ebp
8010373c:	89 e5                	mov    %esp,%ebp
8010373e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103741:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103748:	e9 95 00 00 00       	jmp    801037e2 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010374d:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103756:	01 d0                	add    %edx,%eax
80103758:	83 c0 01             	add    $0x1,%eax
8010375b:	89 c2                	mov    %eax,%edx
8010375d:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103762:	83 ec 08             	sub    $0x8,%esp
80103765:	52                   	push   %edx
80103766:	50                   	push   %eax
80103767:	e8 4a ca ff ff       	call   801001b6 <bread>
8010376c:	83 c4 10             	add    $0x10,%esp
8010376f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103775:	83 c0 10             	add    $0x10,%eax
80103778:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010377f:	89 c2                	mov    %eax,%edx
80103781:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103786:	83 ec 08             	sub    $0x8,%esp
80103789:	52                   	push   %edx
8010378a:	50                   	push   %eax
8010378b:	e8 26 ca ff ff       	call   801001b6 <bread>
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103796:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103799:	8d 50 18             	lea    0x18(%eax),%edx
8010379c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010379f:	83 c0 18             	add    $0x18,%eax
801037a2:	83 ec 04             	sub    $0x4,%esp
801037a5:	68 00 02 00 00       	push   $0x200
801037aa:	52                   	push   %edx
801037ab:	50                   	push   %eax
801037ac:	e8 72 2a 00 00       	call   80106223 <memmove>
801037b1:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	ff 75 f0             	pushl  -0x10(%ebp)
801037ba:	e8 30 ca ff ff       	call   801001ef <bwrite>
801037bf:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037c2:	83 ec 0c             	sub    $0xc,%esp
801037c5:	ff 75 ec             	pushl  -0x14(%ebp)
801037c8:	e8 61 ca ff ff       	call   8010022e <brelse>
801037cd:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	ff 75 f0             	pushl  -0x10(%ebp)
801037d6:	e8 53 ca ff ff       	call   8010022e <brelse>
801037db:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037ea:	0f 8f 5d ff ff ff    	jg     8010374d <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037f0:	90                   	nop
801037f1:	c9                   	leave  
801037f2:	c3                   	ret    

801037f3 <commit>:

static void
commit()
{
801037f3:	55                   	push   %ebp
801037f4:	89 e5                	mov    %esp,%ebp
801037f6:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037f9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	7e 1e                	jle    80103820 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103802:	e8 34 ff ff ff       	call   8010373b <write_log>
    write_head();    // Write header to disk -- the real commit
80103807:	e8 3a fd ff ff       	call   80103546 <write_head>
    install_trans(); // Now install writes to home locations
8010380c:	e8 09 fc ff ff       	call   8010341a <install_trans>
    log.lh.n = 0; 
80103811:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103818:	00 00 00 
    write_head();    // Erase the transaction from the log
8010381b:	e8 26 fd ff ff       	call   80103546 <write_head>
  }
}
80103820:	90                   	nop
80103821:	c9                   	leave  
80103822:	c3                   	ret    

80103823 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103823:	55                   	push   %ebp
80103824:	89 e5                	mov    %esp,%ebp
80103826:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103829:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010382e:	83 f8 1d             	cmp    $0x1d,%eax
80103831:	7f 12                	jg     80103845 <log_write+0x22>
80103833:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103838:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
8010383e:	83 ea 01             	sub    $0x1,%edx
80103841:	39 d0                	cmp    %edx,%eax
80103843:	7c 0d                	jl     80103852 <log_write+0x2f>
    panic("too big a transaction");
80103845:	83 ec 0c             	sub    $0xc,%esp
80103848:	68 2f 98 10 80       	push   $0x8010982f
8010384d:	e8 14 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103852:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103857:	85 c0                	test   %eax,%eax
80103859:	7f 0d                	jg     80103868 <log_write+0x45>
    panic("log_write outside of trans");
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	68 45 98 10 80       	push   $0x80109845
80103863:	e8 fe cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	68 80 32 11 80       	push   $0x80113280
80103870:	e8 8c 26 00 00       	call   80105f01 <acquire>
80103875:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010387f:	eb 1d                	jmp    8010389e <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103884:	83 c0 10             	add    $0x10,%eax
80103887:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010388e:	89 c2                	mov    %eax,%edx
80103890:	8b 45 08             	mov    0x8(%ebp),%eax
80103893:	8b 40 08             	mov    0x8(%eax),%eax
80103896:	39 c2                	cmp    %eax,%edx
80103898:	74 10                	je     801038aa <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010389a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010389e:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038a6:	7f d9                	jg     80103881 <log_write+0x5e>
801038a8:	eb 01                	jmp    801038ab <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038aa:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038ab:	8b 45 08             	mov    0x8(%ebp),%eax
801038ae:	8b 40 08             	mov    0x8(%eax),%eax
801038b1:	89 c2                	mov    %eax,%edx
801038b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b6:	83 c0 10             	add    $0x10,%eax
801038b9:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
801038c0:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038c8:	75 0d                	jne    801038d7 <log_write+0xb4>
    log.lh.n++;
801038ca:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038cf:	83 c0 01             	add    $0x1,%eax
801038d2:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 00                	mov    (%eax),%eax
801038dc:	83 c8 04             	or     $0x4,%eax
801038df:	89 c2                	mov    %eax,%edx
801038e1:	8b 45 08             	mov    0x8(%ebp),%eax
801038e4:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038e6:	83 ec 0c             	sub    $0xc,%esp
801038e9:	68 80 32 11 80       	push   $0x80113280
801038ee:	e8 75 26 00 00       	call   80105f68 <release>
801038f3:	83 c4 10             	add    $0x10,%esp
}
801038f6:	90                   	nop
801038f7:	c9                   	leave  
801038f8:	c3                   	ret    

801038f9 <v2p>:
801038f9:	55                   	push   %ebp
801038fa:	89 e5                	mov    %esp,%ebp
801038fc:	8b 45 08             	mov    0x8(%ebp),%eax
801038ff:	05 00 00 00 80       	add    $0x80000000,%eax
80103904:	5d                   	pop    %ebp
80103905:	c3                   	ret    

80103906 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103906:	55                   	push   %ebp
80103907:	89 e5                	mov    %esp,%ebp
80103909:	8b 45 08             	mov    0x8(%ebp),%eax
8010390c:	05 00 00 00 80       	add    $0x80000000,%eax
80103911:	5d                   	pop    %ebp
80103912:	c3                   	ret    

80103913 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103913:	55                   	push   %ebp
80103914:	89 e5                	mov    %esp,%ebp
80103916:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103919:	8b 55 08             	mov    0x8(%ebp),%edx
8010391c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010391f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103922:	f0 87 02             	lock xchg %eax,(%edx)
80103925:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103928:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010392b:	c9                   	leave  
8010392c:	c3                   	ret    

8010392d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010392d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103931:	83 e4 f0             	and    $0xfffffff0,%esp
80103934:	ff 71 fc             	pushl  -0x4(%ecx)
80103937:	55                   	push   %ebp
80103938:	89 e5                	mov    %esp,%ebp
8010393a:	51                   	push   %ecx
8010393b:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010393e:	83 ec 08             	sub    $0x8,%esp
80103941:	68 00 00 40 80       	push   $0x80400000
80103946:	68 3c 67 11 80       	push   $0x8011673c
8010394b:	e8 7d f2 ff ff       	call   80102bcd <kinit1>
80103950:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103953:	e8 d6 54 00 00       	call   80108e2e <kvmalloc>
  mpinit();        // collect info about this machine
80103958:	e8 43 04 00 00       	call   80103da0 <mpinit>
  lapicinit();
8010395d:	e8 ea f5 ff ff       	call   80102f4c <lapicinit>
  seginit();       // set up segments
80103962:	e8 70 4e 00 00       	call   801087d7 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103967:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010396d:	0f b6 00             	movzbl (%eax),%eax
80103970:	0f b6 c0             	movzbl %al,%eax
80103973:	83 ec 08             	sub    $0x8,%esp
80103976:	50                   	push   %eax
80103977:	68 60 98 10 80       	push   $0x80109860
8010397c:	e8 45 ca ff ff       	call   801003c6 <cprintf>
80103981:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103984:	e8 6d 06 00 00       	call   80103ff6 <picinit>
  ioapicinit();    // another interrupt controller
80103989:	e8 34 f1 ff ff       	call   80102ac2 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010398e:	e8 24 d2 ff ff       	call   80100bb7 <consoleinit>
  uartinit();      // serial port
80103993:	e8 9b 41 00 00       	call   80107b33 <uartinit>
  pinit();         // process table
80103998:	e8 5d 0b 00 00       	call   801044fa <pinit>
  tvinit();        // trap vectors
8010399d:	e8 6a 3d 00 00       	call   8010770c <tvinit>
  binit();         // buffer cache
801039a2:	e8 8d c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039a7:	e8 67 d6 ff ff       	call   80101013 <fileinit>
  ideinit();       // disk
801039ac:	e8 19 ed ff ff       	call   801026ca <ideinit>
  if(!ismp)
801039b1:	a1 64 33 11 80       	mov    0x80113364,%eax
801039b6:	85 c0                	test   %eax,%eax
801039b8:	75 05                	jne    801039bf <main+0x92>
    timerinit();   // uniprocessor timer
801039ba:	e8 9e 3c 00 00       	call   8010765d <timerinit>
  startothers();   // start other processors
801039bf:	e8 7f 00 00 00       	call   80103a43 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039c4:	83 ec 08             	sub    $0x8,%esp
801039c7:	68 00 00 00 8e       	push   $0x8e000000
801039cc:	68 00 00 40 80       	push   $0x80400000
801039d1:	e8 30 f2 ff ff       	call   80102c06 <kinit2>
801039d6:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039d9:	e8 13 0d 00 00       	call   801046f1 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039de:	e8 1a 00 00 00       	call   801039fd <mpmain>

801039e3 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039e3:	55                   	push   %ebp
801039e4:	89 e5                	mov    %esp,%ebp
801039e6:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039e9:	e8 58 54 00 00       	call   80108e46 <switchkvm>
  seginit();
801039ee:	e8 e4 4d 00 00       	call   801087d7 <seginit>
  lapicinit();
801039f3:	e8 54 f5 ff ff       	call   80102f4c <lapicinit>
  mpmain();
801039f8:	e8 00 00 00 00       	call   801039fd <mpmain>

801039fd <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039fd:	55                   	push   %ebp
801039fe:	89 e5                	mov    %esp,%ebp
80103a00:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a03:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a09:	0f b6 00             	movzbl (%eax),%eax
80103a0c:	0f b6 c0             	movzbl %al,%eax
80103a0f:	83 ec 08             	sub    $0x8,%esp
80103a12:	50                   	push   %eax
80103a13:	68 77 98 10 80       	push   $0x80109877
80103a18:	e8 a9 c9 ff ff       	call   801003c6 <cprintf>
80103a1d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a20:	e8 48 3e 00 00       	call   8010786d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a2b:	05 a8 00 00 00       	add    $0xa8,%eax
80103a30:	83 ec 08             	sub    $0x8,%esp
80103a33:	6a 01                	push   $0x1
80103a35:	50                   	push   %eax
80103a36:	e8 d8 fe ff ff       	call   80103913 <xchg>
80103a3b:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a3e:	e8 e0 15 00 00       	call   80105023 <scheduler>

80103a43 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a43:	55                   	push   %ebp
80103a44:	89 e5                	mov    %esp,%ebp
80103a46:	53                   	push   %ebx
80103a47:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a4a:	68 00 70 00 00       	push   $0x7000
80103a4f:	e8 b2 fe ff ff       	call   80103906 <p2v>
80103a54:	83 c4 04             	add    $0x4,%esp
80103a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a5a:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a5f:	83 ec 04             	sub    $0x4,%esp
80103a62:	50                   	push   %eax
80103a63:	68 2c c5 10 80       	push   $0x8010c52c
80103a68:	ff 75 f0             	pushl  -0x10(%ebp)
80103a6b:	e8 b3 27 00 00       	call   80106223 <memmove>
80103a70:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a73:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a7a:	e9 90 00 00 00       	jmp    80103b0f <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a7f:	e8 e6 f5 ff ff       	call   8010306a <cpunum>
80103a84:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a8a:	05 80 33 11 80       	add    $0x80113380,%eax
80103a8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a92:	74 73                	je     80103b07 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a94:	e8 6b f2 ff ff       	call   80102d04 <kalloc>
80103a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9f:	83 e8 04             	sub    $0x4,%eax
80103aa2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103aa5:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103aab:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab0:	83 e8 08             	sub    $0x8,%eax
80103ab3:	c7 00 e3 39 10 80    	movl   $0x801039e3,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103abc:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	68 00 b0 10 80       	push   $0x8010b000
80103ac7:	e8 2d fe ff ff       	call   801038f9 <v2p>
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ad1:	83 ec 0c             	sub    $0xc,%esp
80103ad4:	ff 75 f0             	pushl  -0x10(%ebp)
80103ad7:	e8 1d fe ff ff       	call   801038f9 <v2p>
80103adc:	83 c4 10             	add    $0x10,%esp
80103adf:	89 c2                	mov    %eax,%edx
80103ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae4:	0f b6 00             	movzbl (%eax),%eax
80103ae7:	0f b6 c0             	movzbl %al,%eax
80103aea:	83 ec 08             	sub    $0x8,%esp
80103aed:	52                   	push   %edx
80103aee:	50                   	push   %eax
80103aef:	e8 f0 f5 ff ff       	call   801030e4 <lapicstartap>
80103af4:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103af7:	90                   	nop
80103af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afb:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b01:	85 c0                	test   %eax,%eax
80103b03:	74 f3                	je     80103af8 <startothers+0xb5>
80103b05:	eb 01                	jmp    80103b08 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b07:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b08:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b0f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103b14:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b1a:	05 80 33 11 80       	add    $0x80113380,%eax
80103b1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b22:	0f 87 57 ff ff ff    	ja     80103a7f <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b28:	90                   	nop
80103b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2c:	c9                   	leave  
80103b2d:	c3                   	ret    

80103b2e <p2v>:
80103b2e:	55                   	push   %ebp
80103b2f:	89 e5                	mov    %esp,%ebp
80103b31:	8b 45 08             	mov    0x8(%ebp),%eax
80103b34:	05 00 00 00 80       	add    $0x80000000,%eax
80103b39:	5d                   	pop    %ebp
80103b3a:	c3                   	ret    

80103b3b <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b3b:	55                   	push   %ebp
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	83 ec 14             	sub    $0x14,%esp
80103b41:	8b 45 08             	mov    0x8(%ebp),%eax
80103b44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b4c:	89 c2                	mov    %eax,%edx
80103b4e:	ec                   	in     (%dx),%al
80103b4f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b52:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b56:	c9                   	leave  
80103b57:	c3                   	ret    

80103b58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b58:	55                   	push   %ebp
80103b59:	89 e5                	mov    %esp,%ebp
80103b5b:	83 ec 08             	sub    $0x8,%esp
80103b5e:	8b 55 08             	mov    0x8(%ebp),%edx
80103b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b64:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b68:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b6b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b6f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b73:	ee                   	out    %al,(%dx)
}
80103b74:	90                   	nop
80103b75:	c9                   	leave  
80103b76:	c3                   	ret    

80103b77 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b77:	55                   	push   %ebp
80103b78:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b7a:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b7f:	89 c2                	mov    %eax,%edx
80103b81:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103b86:	29 c2                	sub    %eax,%edx
80103b88:	89 d0                	mov    %edx,%eax
80103b8a:	c1 f8 02             	sar    $0x2,%eax
80103b8d:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b93:	5d                   	pop    %ebp
80103b94:	c3                   	ret    

80103b95 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b95:	55                   	push   %ebp
80103b96:	89 e5                	mov    %esp,%ebp
80103b98:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ba9:	eb 15                	jmp    80103bc0 <sum+0x2b>
    sum += addr[i];
80103bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bae:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb1:	01 d0                	add    %edx,%eax
80103bb3:	0f b6 00             	movzbl (%eax),%eax
80103bb6:	0f b6 c0             	movzbl %al,%eax
80103bb9:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bbc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bc6:	7c e3                	jl     80103bab <sum+0x16>
    sum += addr[i];
  return sum;
80103bc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bcb:	c9                   	leave  
80103bcc:	c3                   	ret    

80103bcd <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bcd:	55                   	push   %ebp
80103bce:	89 e5                	mov    %esp,%ebp
80103bd0:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bd3:	ff 75 08             	pushl  0x8(%ebp)
80103bd6:	e8 53 ff ff ff       	call   80103b2e <p2v>
80103bdb:	83 c4 04             	add    $0x4,%esp
80103bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103be1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be7:	01 d0                	add    %edx,%eax
80103be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf2:	eb 36                	jmp    80103c2a <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103bf4:	83 ec 04             	sub    $0x4,%esp
80103bf7:	6a 04                	push   $0x4
80103bf9:	68 88 98 10 80       	push   $0x80109888
80103bfe:	ff 75 f4             	pushl  -0xc(%ebp)
80103c01:	e8 c5 25 00 00       	call   801061cb <memcmp>
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	85 c0                	test   %eax,%eax
80103c0b:	75 19                	jne    80103c26 <mpsearch1+0x59>
80103c0d:	83 ec 08             	sub    $0x8,%esp
80103c10:	6a 10                	push   $0x10
80103c12:	ff 75 f4             	pushl  -0xc(%ebp)
80103c15:	e8 7b ff ff ff       	call   80103b95 <sum>
80103c1a:	83 c4 10             	add    $0x10,%esp
80103c1d:	84 c0                	test   %al,%al
80103c1f:	75 05                	jne    80103c26 <mpsearch1+0x59>
      return (struct mp*)p;
80103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c24:	eb 11                	jmp    80103c37 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c26:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c30:	72 c2                	jb     80103bf4 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c37:	c9                   	leave  
80103c38:	c3                   	ret    

80103c39 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c39:	55                   	push   %ebp
80103c3a:	89 e5                	mov    %esp,%ebp
80103c3c:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c3f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c49:	83 c0 0f             	add    $0xf,%eax
80103c4c:	0f b6 00             	movzbl (%eax),%eax
80103c4f:	0f b6 c0             	movzbl %al,%eax
80103c52:	c1 e0 08             	shl    $0x8,%eax
80103c55:	89 c2                	mov    %eax,%edx
80103c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5a:	83 c0 0e             	add    $0xe,%eax
80103c5d:	0f b6 00             	movzbl (%eax),%eax
80103c60:	0f b6 c0             	movzbl %al,%eax
80103c63:	09 d0                	or     %edx,%eax
80103c65:	c1 e0 04             	shl    $0x4,%eax
80103c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c6f:	74 21                	je     80103c92 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c71:	83 ec 08             	sub    $0x8,%esp
80103c74:	68 00 04 00 00       	push   $0x400
80103c79:	ff 75 f0             	pushl  -0x10(%ebp)
80103c7c:	e8 4c ff ff ff       	call   80103bcd <mpsearch1>
80103c81:	83 c4 10             	add    $0x10,%esp
80103c84:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c8b:	74 51                	je     80103cde <mpsearch+0xa5>
      return mp;
80103c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c90:	eb 61                	jmp    80103cf3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c95:	83 c0 14             	add    $0x14,%eax
80103c98:	0f b6 00             	movzbl (%eax),%eax
80103c9b:	0f b6 c0             	movzbl %al,%eax
80103c9e:	c1 e0 08             	shl    $0x8,%eax
80103ca1:	89 c2                	mov    %eax,%edx
80103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca6:	83 c0 13             	add    $0x13,%eax
80103ca9:	0f b6 00             	movzbl (%eax),%eax
80103cac:	0f b6 c0             	movzbl %al,%eax
80103caf:	09 d0                	or     %edx,%eax
80103cb1:	c1 e0 0a             	shl    $0xa,%eax
80103cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cba:	2d 00 04 00 00       	sub    $0x400,%eax
80103cbf:	83 ec 08             	sub    $0x8,%esp
80103cc2:	68 00 04 00 00       	push   $0x400
80103cc7:	50                   	push   %eax
80103cc8:	e8 00 ff ff ff       	call   80103bcd <mpsearch1>
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cd7:	74 05                	je     80103cde <mpsearch+0xa5>
      return mp;
80103cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cdc:	eb 15                	jmp    80103cf3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cde:	83 ec 08             	sub    $0x8,%esp
80103ce1:	68 00 00 01 00       	push   $0x10000
80103ce6:	68 00 00 0f 00       	push   $0xf0000
80103ceb:	e8 dd fe ff ff       	call   80103bcd <mpsearch1>
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	c9                   	leave  
80103cf4:	c3                   	ret    

80103cf5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103cf5:	55                   	push   %ebp
80103cf6:	89 e5                	mov    %esp,%ebp
80103cf8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cfb:	e8 39 ff ff ff       	call   80103c39 <mpsearch>
80103d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d07:	74 0a                	je     80103d13 <mpconfig+0x1e>
80103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0c:	8b 40 04             	mov    0x4(%eax),%eax
80103d0f:	85 c0                	test   %eax,%eax
80103d11:	75 0a                	jne    80103d1d <mpconfig+0x28>
    return 0;
80103d13:	b8 00 00 00 00       	mov    $0x0,%eax
80103d18:	e9 81 00 00 00       	jmp    80103d9e <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d20:	8b 40 04             	mov    0x4(%eax),%eax
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	50                   	push   %eax
80103d27:	e8 02 fe ff ff       	call   80103b2e <p2v>
80103d2c:	83 c4 10             	add    $0x10,%esp
80103d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d32:	83 ec 04             	sub    $0x4,%esp
80103d35:	6a 04                	push   $0x4
80103d37:	68 8d 98 10 80       	push   $0x8010988d
80103d3c:	ff 75 f0             	pushl  -0x10(%ebp)
80103d3f:	e8 87 24 00 00       	call   801061cb <memcmp>
80103d44:	83 c4 10             	add    $0x10,%esp
80103d47:	85 c0                	test   %eax,%eax
80103d49:	74 07                	je     80103d52 <mpconfig+0x5d>
    return 0;
80103d4b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d50:	eb 4c                	jmp    80103d9e <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d55:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d59:	3c 01                	cmp    $0x1,%al
80103d5b:	74 12                	je     80103d6f <mpconfig+0x7a>
80103d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d60:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d64:	3c 04                	cmp    $0x4,%al
80103d66:	74 07                	je     80103d6f <mpconfig+0x7a>
    return 0;
80103d68:	b8 00 00 00 00       	mov    $0x0,%eax
80103d6d:	eb 2f                	jmp    80103d9e <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d72:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d76:	0f b7 c0             	movzwl %ax,%eax
80103d79:	83 ec 08             	sub    $0x8,%esp
80103d7c:	50                   	push   %eax
80103d7d:	ff 75 f0             	pushl  -0x10(%ebp)
80103d80:	e8 10 fe ff ff       	call   80103b95 <sum>
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	84 c0                	test   %al,%al
80103d8a:	74 07                	je     80103d93 <mpconfig+0x9e>
    return 0;
80103d8c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d91:	eb 0b                	jmp    80103d9e <mpconfig+0xa9>
  *pmp = mp;
80103d93:	8b 45 08             	mov    0x8(%ebp),%eax
80103d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d99:	89 10                	mov    %edx,(%eax)
  return conf;
80103d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d9e:	c9                   	leave  
80103d9f:	c3                   	ret    

80103da0 <mpinit>:

void
mpinit(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103da6:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103dad:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103db6:	50                   	push   %eax
80103db7:	e8 39 ff ff ff       	call   80103cf5 <mpconfig>
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dc6:	0f 84 96 01 00 00    	je     80103f62 <mpinit+0x1c2>
    return;
  ismp = 1;
80103dcc:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103dd3:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dd9:	8b 40 24             	mov    0x24(%eax),%eax
80103ddc:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de4:	83 c0 2c             	add    $0x2c,%eax
80103de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ded:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103df1:	0f b7 d0             	movzwl %ax,%edx
80103df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df7:	01 d0                	add    %edx,%eax
80103df9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dfc:	e9 f2 00 00 00       	jmp    80103ef3 <mpinit+0x153>
    switch(*p){
80103e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e04:	0f b6 00             	movzbl (%eax),%eax
80103e07:	0f b6 c0             	movzbl %al,%eax
80103e0a:	83 f8 04             	cmp    $0x4,%eax
80103e0d:	0f 87 bc 00 00 00    	ja     80103ecf <mpinit+0x12f>
80103e13:	8b 04 85 d0 98 10 80 	mov    -0x7fef6730(,%eax,4),%eax
80103e1a:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e25:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e29:	0f b6 d0             	movzbl %al,%edx
80103e2c:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e31:	39 c2                	cmp    %eax,%edx
80103e33:	74 2b                	je     80103e60 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e38:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e3c:	0f b6 d0             	movzbl %al,%edx
80103e3f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e44:	83 ec 04             	sub    $0x4,%esp
80103e47:	52                   	push   %edx
80103e48:	50                   	push   %eax
80103e49:	68 92 98 10 80       	push   $0x80109892
80103e4e:	e8 73 c5 ff ff       	call   801003c6 <cprintf>
80103e53:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e56:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103e5d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e63:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e67:	0f b6 c0             	movzbl %al,%eax
80103e6a:	83 e0 02             	and    $0x2,%eax
80103e6d:	85 c0                	test   %eax,%eax
80103e6f:	74 15                	je     80103e86 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e71:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e76:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e7c:	05 80 33 11 80       	add    $0x80113380,%eax
80103e81:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e86:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e8b:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e91:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e97:	05 80 33 11 80       	add    $0x80113380,%eax
80103e9c:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e9e:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ea3:	83 c0 01             	add    $0x1,%eax
80103ea6:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103eab:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eaf:	eb 42                	jmp    80103ef3 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eba:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ebe:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103ec3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ec7:	eb 2a                	jmp    80103ef3 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ec9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ecd:	eb 24                	jmp    80103ef3 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed2:	0f b6 00             	movzbl (%eax),%eax
80103ed5:	0f b6 c0             	movzbl %al,%eax
80103ed8:	83 ec 08             	sub    $0x8,%esp
80103edb:	50                   	push   %eax
80103edc:	68 b0 98 10 80       	push   $0x801098b0
80103ee1:	e8 e0 c4 ff ff       	call   801003c6 <cprintf>
80103ee6:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ee9:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103ef0:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ef9:	0f 82 02 ff ff ff    	jb     80103e01 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103eff:	a1 64 33 11 80       	mov    0x80113364,%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	75 1d                	jne    80103f25 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f08:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103f0f:	00 00 00 
    lapic = 0;
80103f12:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103f19:	00 00 00 
    ioapicid = 0;
80103f1c:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103f23:	eb 3e                	jmp    80103f63 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f28:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f2c:	84 c0                	test   %al,%al
80103f2e:	74 33                	je     80103f63 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f30:	83 ec 08             	sub    $0x8,%esp
80103f33:	6a 70                	push   $0x70
80103f35:	6a 22                	push   $0x22
80103f37:	e8 1c fc ff ff       	call   80103b58 <outb>
80103f3c:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f3f:	83 ec 0c             	sub    $0xc,%esp
80103f42:	6a 23                	push   $0x23
80103f44:	e8 f2 fb ff ff       	call   80103b3b <inb>
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	83 c8 01             	or     $0x1,%eax
80103f4f:	0f b6 c0             	movzbl %al,%eax
80103f52:	83 ec 08             	sub    $0x8,%esp
80103f55:	50                   	push   %eax
80103f56:	6a 23                	push   $0x23
80103f58:	e8 fb fb ff ff       	call   80103b58 <outb>
80103f5d:	83 c4 10             	add    $0x10,%esp
80103f60:	eb 01                	jmp    80103f63 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f62:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f63:	c9                   	leave  
80103f64:	c3                   	ret    

80103f65 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f65:	55                   	push   %ebp
80103f66:	89 e5                	mov    %esp,%ebp
80103f68:	83 ec 08             	sub    $0x8,%esp
80103f6b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f71:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f75:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f78:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f7c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f80:	ee                   	out    %al,(%dx)
}
80103f81:	90                   	nop
80103f82:	c9                   	leave  
80103f83:	c3                   	ret    

80103f84 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	83 ec 04             	sub    $0x4,%esp
80103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f91:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f95:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103f9b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f9f:	0f b6 c0             	movzbl %al,%eax
80103fa2:	50                   	push   %eax
80103fa3:	6a 21                	push   $0x21
80103fa5:	e8 bb ff ff ff       	call   80103f65 <outb>
80103faa:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fad:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fb1:	66 c1 e8 08          	shr    $0x8,%ax
80103fb5:	0f b6 c0             	movzbl %al,%eax
80103fb8:	50                   	push   %eax
80103fb9:	68 a1 00 00 00       	push   $0xa1
80103fbe:	e8 a2 ff ff ff       	call   80103f65 <outb>
80103fc3:	83 c4 08             	add    $0x8,%esp
}
80103fc6:	90                   	nop
80103fc7:	c9                   	leave  
80103fc8:	c3                   	ret    

80103fc9 <picenable>:

void
picenable(int irq)
{
80103fc9:	55                   	push   %ebp
80103fca:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcf:	ba 01 00 00 00       	mov    $0x1,%edx
80103fd4:	89 c1                	mov    %eax,%ecx
80103fd6:	d3 e2                	shl    %cl,%edx
80103fd8:	89 d0                	mov    %edx,%eax
80103fda:	f7 d0                	not    %eax
80103fdc:	89 c2                	mov    %eax,%edx
80103fde:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fe5:	21 d0                	and    %edx,%eax
80103fe7:	0f b7 c0             	movzwl %ax,%eax
80103fea:	50                   	push   %eax
80103feb:	e8 94 ff ff ff       	call   80103f84 <picsetmask>
80103ff0:	83 c4 04             	add    $0x4,%esp
}
80103ff3:	90                   	nop
80103ff4:	c9                   	leave  
80103ff5:	c3                   	ret    

80103ff6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ff6:	55                   	push   %ebp
80103ff7:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ff9:	68 ff 00 00 00       	push   $0xff
80103ffe:	6a 21                	push   $0x21
80104000:	e8 60 ff ff ff       	call   80103f65 <outb>
80104005:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104008:	68 ff 00 00 00       	push   $0xff
8010400d:	68 a1 00 00 00       	push   $0xa1
80104012:	e8 4e ff ff ff       	call   80103f65 <outb>
80104017:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
8010401a:	6a 11                	push   $0x11
8010401c:	6a 20                	push   $0x20
8010401e:	e8 42 ff ff ff       	call   80103f65 <outb>
80104023:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104026:	6a 20                	push   $0x20
80104028:	6a 21                	push   $0x21
8010402a:	e8 36 ff ff ff       	call   80103f65 <outb>
8010402f:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104032:	6a 04                	push   $0x4
80104034:	6a 21                	push   $0x21
80104036:	e8 2a ff ff ff       	call   80103f65 <outb>
8010403b:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010403e:	6a 03                	push   $0x3
80104040:	6a 21                	push   $0x21
80104042:	e8 1e ff ff ff       	call   80103f65 <outb>
80104047:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
8010404a:	6a 11                	push   $0x11
8010404c:	68 a0 00 00 00       	push   $0xa0
80104051:	e8 0f ff ff ff       	call   80103f65 <outb>
80104056:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104059:	6a 28                	push   $0x28
8010405b:	68 a1 00 00 00       	push   $0xa1
80104060:	e8 00 ff ff ff       	call   80103f65 <outb>
80104065:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104068:	6a 02                	push   $0x2
8010406a:	68 a1 00 00 00       	push   $0xa1
8010406f:	e8 f1 fe ff ff       	call   80103f65 <outb>
80104074:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104077:	6a 03                	push   $0x3
80104079:	68 a1 00 00 00       	push   $0xa1
8010407e:	e8 e2 fe ff ff       	call   80103f65 <outb>
80104083:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104086:	6a 68                	push   $0x68
80104088:	6a 20                	push   $0x20
8010408a:	e8 d6 fe ff ff       	call   80103f65 <outb>
8010408f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104092:	6a 0a                	push   $0xa
80104094:	6a 20                	push   $0x20
80104096:	e8 ca fe ff ff       	call   80103f65 <outb>
8010409b:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010409e:	6a 68                	push   $0x68
801040a0:	68 a0 00 00 00       	push   $0xa0
801040a5:	e8 bb fe ff ff       	call   80103f65 <outb>
801040aa:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040ad:	6a 0a                	push   $0xa
801040af:	68 a0 00 00 00       	push   $0xa0
801040b4:	e8 ac fe ff ff       	call   80103f65 <outb>
801040b9:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040bc:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040c3:	66 83 f8 ff          	cmp    $0xffff,%ax
801040c7:	74 13                	je     801040dc <picinit+0xe6>
    picsetmask(irqmask);
801040c9:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040d0:	0f b7 c0             	movzwl %ax,%eax
801040d3:	50                   	push   %eax
801040d4:	e8 ab fe ff ff       	call   80103f84 <picsetmask>
801040d9:	83 c4 04             	add    $0x4,%esp
}
801040dc:	90                   	nop
801040dd:	c9                   	leave  
801040de:	c3                   	ret    

801040df <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040df:	55                   	push   %ebp
801040e0:	89 e5                	mov    %esp,%ebp
801040e2:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f8:	8b 10                	mov    (%eax),%edx
801040fa:	8b 45 08             	mov    0x8(%ebp),%eax
801040fd:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040ff:	e8 2d cf ff ff       	call   80101031 <filealloc>
80104104:	89 c2                	mov    %eax,%edx
80104106:	8b 45 08             	mov    0x8(%ebp),%eax
80104109:	89 10                	mov    %edx,(%eax)
8010410b:	8b 45 08             	mov    0x8(%ebp),%eax
8010410e:	8b 00                	mov    (%eax),%eax
80104110:	85 c0                	test   %eax,%eax
80104112:	0f 84 cb 00 00 00    	je     801041e3 <pipealloc+0x104>
80104118:	e8 14 cf ff ff       	call   80101031 <filealloc>
8010411d:	89 c2                	mov    %eax,%edx
8010411f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104122:	89 10                	mov    %edx,(%eax)
80104124:	8b 45 0c             	mov    0xc(%ebp),%eax
80104127:	8b 00                	mov    (%eax),%eax
80104129:	85 c0                	test   %eax,%eax
8010412b:	0f 84 b2 00 00 00    	je     801041e3 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104131:	e8 ce eb ff ff       	call   80102d04 <kalloc>
80104136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010413d:	0f 84 9f 00 00 00    	je     801041e2 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104146:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010414d:	00 00 00 
  p->writeopen = 1;
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010415a:	00 00 00 
  p->nwrite = 0;
8010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104160:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104167:	00 00 00 
  p->nread = 0;
8010416a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104174:	00 00 00 
  initlock(&p->lock, "pipe");
80104177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417a:	83 ec 08             	sub    $0x8,%esp
8010417d:	68 e4 98 10 80       	push   $0x801098e4
80104182:	50                   	push   %eax
80104183:	e8 57 1d 00 00       	call   80105edf <initlock>
80104188:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010418b:	8b 45 08             	mov    0x8(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	8b 00                	mov    (%eax),%eax
8010419b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010419f:	8b 45 08             	mov    0x8(%ebp),%eax
801041a2:	8b 00                	mov    (%eax),%eax
801041a4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041a8:	8b 45 08             	mov    0x8(%ebp),%eax
801041ab:	8b 00                	mov    (%eax),%eax
801041ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b0:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b6:	8b 00                	mov    (%eax),%eax
801041b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041be:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c1:	8b 00                	mov    (%eax),%eax
801041c3:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ca:	8b 00                	mov    (%eax),%eax
801041cc:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d3:	8b 00                	mov    (%eax),%eax
801041d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d8:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041db:	b8 00 00 00 00       	mov    $0x0,%eax
801041e0:	eb 4e                	jmp    80104230 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041e2:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801041e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041e7:	74 0e                	je     801041f7 <pipealloc+0x118>
    kfree((char*)p);
801041e9:	83 ec 0c             	sub    $0xc,%esp
801041ec:	ff 75 f4             	pushl  -0xc(%ebp)
801041ef:	e8 73 ea ff ff       	call   80102c67 <kfree>
801041f4:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 00                	mov    (%eax),%eax
801041fc:	85 c0                	test   %eax,%eax
801041fe:	74 11                	je     80104211 <pipealloc+0x132>
    fileclose(*f0);
80104200:	8b 45 08             	mov    0x8(%ebp),%eax
80104203:	8b 00                	mov    (%eax),%eax
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	50                   	push   %eax
80104209:	e8 e1 ce ff ff       	call   801010ef <fileclose>
8010420e:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	8b 00                	mov    (%eax),%eax
80104216:	85 c0                	test   %eax,%eax
80104218:	74 11                	je     8010422b <pipealloc+0x14c>
    fileclose(*f1);
8010421a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421d:	8b 00                	mov    (%eax),%eax
8010421f:	83 ec 0c             	sub    $0xc,%esp
80104222:	50                   	push   %eax
80104223:	e8 c7 ce ff ff       	call   801010ef <fileclose>
80104228:	83 c4 10             	add    $0x10,%esp
  return -1;
8010422b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104230:	c9                   	leave  
80104231:	c3                   	ret    

80104232 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104232:	55                   	push   %ebp
80104233:	89 e5                	mov    %esp,%ebp
80104235:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104238:	8b 45 08             	mov    0x8(%ebp),%eax
8010423b:	83 ec 0c             	sub    $0xc,%esp
8010423e:	50                   	push   %eax
8010423f:	e8 bd 1c 00 00       	call   80105f01 <acquire>
80104244:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010424b:	74 23                	je     80104270 <pipeclose+0x3e>
    p->writeopen = 0;
8010424d:	8b 45 08             	mov    0x8(%ebp),%eax
80104250:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104257:	00 00 00 
    wakeup(&p->nread);
8010425a:	8b 45 08             	mov    0x8(%ebp),%eax
8010425d:	05 34 02 00 00       	add    $0x234,%eax
80104262:	83 ec 0c             	sub    $0xc,%esp
80104265:	50                   	push   %eax
80104266:	e8 46 12 00 00       	call   801054b1 <wakeup>
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	eb 21                	jmp    80104291 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104270:	8b 45 08             	mov    0x8(%ebp),%eax
80104273:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010427a:	00 00 00 
    wakeup(&p->nwrite);
8010427d:	8b 45 08             	mov    0x8(%ebp),%eax
80104280:	05 38 02 00 00       	add    $0x238,%eax
80104285:	83 ec 0c             	sub    $0xc,%esp
80104288:	50                   	push   %eax
80104289:	e8 23 12 00 00       	call   801054b1 <wakeup>
8010428e:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104291:	8b 45 08             	mov    0x8(%ebp),%eax
80104294:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010429a:	85 c0                	test   %eax,%eax
8010429c:	75 2c                	jne    801042ca <pipeclose+0x98>
8010429e:	8b 45 08             	mov    0x8(%ebp),%eax
801042a1:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042a7:	85 c0                	test   %eax,%eax
801042a9:	75 1f                	jne    801042ca <pipeclose+0x98>
    release(&p->lock);
801042ab:	8b 45 08             	mov    0x8(%ebp),%eax
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	50                   	push   %eax
801042b2:	e8 b1 1c 00 00       	call   80105f68 <release>
801042b7:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	ff 75 08             	pushl  0x8(%ebp)
801042c0:	e8 a2 e9 ff ff       	call   80102c67 <kfree>
801042c5:	83 c4 10             	add    $0x10,%esp
801042c8:	eb 0f                	jmp    801042d9 <pipeclose+0xa7>
  } else
    release(&p->lock);
801042ca:	8b 45 08             	mov    0x8(%ebp),%eax
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	50                   	push   %eax
801042d1:	e8 92 1c 00 00       	call   80105f68 <release>
801042d6:	83 c4 10             	add    $0x10,%esp
}
801042d9:	90                   	nop
801042da:	c9                   	leave  
801042db:	c3                   	ret    

801042dc <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801042dc:	55                   	push   %ebp
801042dd:	89 e5                	mov    %esp,%ebp
801042df:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	83 ec 0c             	sub    $0xc,%esp
801042e8:	50                   	push   %eax
801042e9:	e8 13 1c 00 00       	call   80105f01 <acquire>
801042ee:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042f8:	e9 ad 00 00 00       	jmp    801043aa <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801042fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104300:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104306:	85 c0                	test   %eax,%eax
80104308:	74 0d                	je     80104317 <pipewrite+0x3b>
8010430a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104310:	8b 40 24             	mov    0x24(%eax),%eax
80104313:	85 c0                	test   %eax,%eax
80104315:	74 19                	je     80104330 <pipewrite+0x54>
        release(&p->lock);
80104317:	8b 45 08             	mov    0x8(%ebp),%eax
8010431a:	83 ec 0c             	sub    $0xc,%esp
8010431d:	50                   	push   %eax
8010431e:	e8 45 1c 00 00       	call   80105f68 <release>
80104323:	83 c4 10             	add    $0x10,%esp
        return -1;
80104326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010432b:	e9 a8 00 00 00       	jmp    801043d8 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104330:	8b 45 08             	mov    0x8(%ebp),%eax
80104333:	05 34 02 00 00       	add    $0x234,%eax
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	50                   	push   %eax
8010433c:	e8 70 11 00 00       	call   801054b1 <wakeup>
80104341:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
80104347:	8b 55 08             	mov    0x8(%ebp),%edx
8010434a:	81 c2 38 02 00 00    	add    $0x238,%edx
80104350:	83 ec 08             	sub    $0x8,%esp
80104353:	50                   	push   %eax
80104354:	52                   	push   %edx
80104355:	e8 a3 0f 00 00       	call   801052fd <sleep>
8010435a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010435d:	8b 45 08             	mov    0x8(%ebp),%eax
80104360:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
80104369:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010436f:	05 00 02 00 00       	add    $0x200,%eax
80104374:	39 c2                	cmp    %eax,%edx
80104376:	74 85                	je     801042fd <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104381:	8d 48 01             	lea    0x1(%eax),%ecx
80104384:	8b 55 08             	mov    0x8(%ebp),%edx
80104387:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010438d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104392:	89 c1                	mov    %eax,%ecx
80104394:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010439a:	01 d0                	add    %edx,%eax
8010439c:	0f b6 10             	movzbl (%eax),%edx
8010439f:	8b 45 08             	mov    0x8(%ebp),%eax
801043a2:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ad:	3b 45 10             	cmp    0x10(%ebp),%eax
801043b0:	7c ab                	jl     8010435d <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043b2:	8b 45 08             	mov    0x8(%ebp),%eax
801043b5:	05 34 02 00 00       	add    $0x234,%eax
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	50                   	push   %eax
801043be:	e8 ee 10 00 00       	call   801054b1 <wakeup>
801043c3:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043c6:	8b 45 08             	mov    0x8(%ebp),%eax
801043c9:	83 ec 0c             	sub    $0xc,%esp
801043cc:	50                   	push   %eax
801043cd:	e8 96 1b 00 00       	call   80105f68 <release>
801043d2:	83 c4 10             	add    $0x10,%esp
  return n;
801043d5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043d8:	c9                   	leave  
801043d9:	c3                   	ret    

801043da <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043da:	55                   	push   %ebp
801043db:	89 e5                	mov    %esp,%ebp
801043dd:	53                   	push   %ebx
801043de:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043e1:	8b 45 08             	mov    0x8(%ebp),%eax
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	50                   	push   %eax
801043e8:	e8 14 1b 00 00       	call   80105f01 <acquire>
801043ed:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043f0:	eb 3f                	jmp    80104431 <piperead+0x57>
    if(proc->killed){
801043f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f8:	8b 40 24             	mov    0x24(%eax),%eax
801043fb:	85 c0                	test   %eax,%eax
801043fd:	74 19                	je     80104418 <piperead+0x3e>
      release(&p->lock);
801043ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104402:	83 ec 0c             	sub    $0xc,%esp
80104405:	50                   	push   %eax
80104406:	e8 5d 1b 00 00       	call   80105f68 <release>
8010440b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010440e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104413:	e9 bf 00 00 00       	jmp    801044d7 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104418:	8b 45 08             	mov    0x8(%ebp),%eax
8010441b:	8b 55 08             	mov    0x8(%ebp),%edx
8010441e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	50                   	push   %eax
80104428:	52                   	push   %edx
80104429:	e8 cf 0e 00 00       	call   801052fd <sleep>
8010442e:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104431:	8b 45 08             	mov    0x8(%ebp),%eax
80104434:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010443a:	8b 45 08             	mov    0x8(%ebp),%eax
8010443d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104443:	39 c2                	cmp    %eax,%edx
80104445:	75 0d                	jne    80104454 <piperead+0x7a>
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
8010444a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104450:	85 c0                	test   %eax,%eax
80104452:	75 9e                	jne    801043f2 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010445b:	eb 49                	jmp    801044a6 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010445d:	8b 45 08             	mov    0x8(%ebp),%eax
80104460:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104466:	8b 45 08             	mov    0x8(%ebp),%eax
80104469:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010446f:	39 c2                	cmp    %eax,%edx
80104471:	74 3d                	je     801044b0 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104473:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104476:	8b 45 0c             	mov    0xc(%ebp),%eax
80104479:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010447c:	8b 45 08             	mov    0x8(%ebp),%eax
8010447f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104485:	8d 48 01             	lea    0x1(%eax),%ecx
80104488:	8b 55 08             	mov    0x8(%ebp),%edx
8010448b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104491:	25 ff 01 00 00       	and    $0x1ff,%eax
80104496:	89 c2                	mov    %eax,%edx
80104498:	8b 45 08             	mov    0x8(%ebp),%eax
8010449b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044a0:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	3b 45 10             	cmp    0x10(%ebp),%eax
801044ac:	7c af                	jl     8010445d <piperead+0x83>
801044ae:	eb 01                	jmp    801044b1 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044b0:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044b1:	8b 45 08             	mov    0x8(%ebp),%eax
801044b4:	05 38 02 00 00       	add    $0x238,%eax
801044b9:	83 ec 0c             	sub    $0xc,%esp
801044bc:	50                   	push   %eax
801044bd:	e8 ef 0f 00 00       	call   801054b1 <wakeup>
801044c2:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044c5:	8b 45 08             	mov    0x8(%ebp),%eax
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	50                   	push   %eax
801044cc:	e8 97 1a 00 00       	call   80105f68 <release>
801044d1:	83 c4 10             	add    $0x10,%esp
  return i;
801044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044da:	c9                   	leave  
801044db:	c3                   	ret    

801044dc <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801044dc:	55                   	push   %ebp
801044dd:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044df:	f4                   	hlt    
}
801044e0:	90                   	nop
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    

801044e3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044e3:	55                   	push   %ebp
801044e4:	89 e5                	mov    %esp,%ebp
801044e6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044e9:	9c                   	pushf  
801044ea:	58                   	pop    %eax
801044eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044f1:	c9                   	leave  
801044f2:	c3                   	ret    

801044f3 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044f3:	55                   	push   %ebp
801044f4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044f6:	fb                   	sti    
}
801044f7:	90                   	nop
801044f8:	5d                   	pop    %ebp
801044f9:	c3                   	ret    

801044fa <pinit>:
static int waitSearch(struct proc * sList);
static void ctrlprint(struct proc * sList);
#endif
void
pinit(void)
{
801044fa:	55                   	push   %ebp
801044fb:	89 e5                	mov    %esp,%ebp
801044fd:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104500:	83 ec 08             	sub    $0x8,%esp
80104503:	68 ec 98 10 80       	push   $0x801098ec
80104508:	68 80 39 11 80       	push   $0x80113980
8010450d:	e8 cd 19 00 00       	call   80105edf <initlock>
80104512:	83 c4 10             	add    $0x10,%esp
}
80104515:	90                   	nop
80104516:	c9                   	leave  
80104517:	c3                   	ret    

80104518 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104518:	55                   	push   %ebp
80104519:	89 e5                	mov    %esp,%ebp
8010451b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;
  acquire(&ptable.lock);
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 80 39 11 80       	push   $0x80113980
80104526:	e8 d6 19 00 00       	call   80105f01 <acquire>
8010452b:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  p = removeFromStateListHead(&ptable.pLists.free);
8010452e:	83 ec 0c             	sub    $0xc,%esp
80104531:	68 b8 5e 11 80       	push   $0x80115eb8
80104536:	e8 58 15 00 00       	call   80105a93 <removeFromStateListHead>
8010453b:	83 c4 10             	add    $0x10,%esp
8010453e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p)
80104541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104545:	74 70                	je     801045b7 <allocproc+0x9f>
  {
      assertState(p, UNUSED);
80104547:	83 ec 08             	sub    $0x8,%esp
8010454a:	6a 00                	push   $0x0
8010454c:	ff 75 f4             	pushl  -0xc(%ebp)
8010454f:	e8 23 16 00 00       	call   80105b77 <assertState>
80104554:	83 c4 10             	add    $0x10,%esp
      goto found;
80104557:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
#ifdef CS333_P1
  p->start_ticks = ticks;
80104558:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
8010455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104561:	89 50 7c             	mov    %edx,0x7c(%eax)
#endif
#ifdef CS333_P2  
  p->cpu_ticks_total = 0;
80104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104567:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010456e:	00 00 00 
  p->cpu_ticks_in = 0;
80104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104574:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010457b:	00 00 00 
#endif
  p->state = EMBRYO; 
8010457e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104581:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104588:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010458d:	8d 50 01             	lea    0x1(%eax),%edx
80104590:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104596:	89 c2                	mov    %eax,%edx
80104598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459b:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P3P4
  if(addToStateListHead(&ptable.pLists.embryo, p) == 0)
8010459e:	83 ec 08             	sub    $0x8,%esp
801045a1:	ff 75 f4             	pushl  -0xc(%ebp)
801045a4:	68 c8 5e 11 80       	push   $0x80115ec8
801045a9:	e8 53 16 00 00       	call   80105c01 <addToStateListHead>
801045ae:	83 c4 10             	add    $0x10,%esp
801045b1:	85 c0                	test   %eax,%eax
801045b3:	75 29                	jne    801045de <allocproc+0xc6>
801045b5:	eb 1a                	jmp    801045d1 <allocproc+0xb9>
#else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
#endif
  release(&ptable.lock);
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 80 39 11 80       	push   $0x80113980
801045bf:	e8 a4 19 00 00       	call   80105f68 <release>
801045c4:	83 c4 10             	add    $0x10,%esp
  return 0;
801045c7:	b8 00 00 00 00       	mov    $0x0,%eax
801045cc:	e9 1e 01 00 00       	jmp    801046ef <allocproc+0x1d7>
#endif
  p->state = EMBRYO; 
  p->pid = nextpid++;
#ifdef CS333_P3P4
  if(addToStateListHead(&ptable.pLists.embryo, p) == 0)
      panic("Failed add embryo in allocproc");
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	68 f4 98 10 80       	push   $0x801098f4
801045d9:	e8 88 bf ff ff       	call   80100566 <panic>
#endif
  release(&ptable.lock);
801045de:	83 ec 0c             	sub    $0xc,%esp
801045e1:	68 80 39 11 80       	push   $0x80113980
801045e6:	e8 7d 19 00 00       	call   80105f68 <release>
801045eb:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045ee:	e8 11 e7 ff ff       	call   80102d04 <kalloc>
801045f3:	89 c2                	mov    %eax,%edx
801045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f8:	89 50 08             	mov    %edx,0x8(%eax)
801045fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fe:	8b 40 08             	mov    0x8(%eax),%eax
80104601:	85 c0                	test   %eax,%eax
80104603:	0f 85 89 00 00 00    	jne    80104692 <allocproc+0x17a>
#ifdef CS333_P3P4 //return to free
    acquire(&ptable.lock);
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	68 80 39 11 80       	push   $0x80113980
80104611:	e8 eb 18 00 00       	call   80105f01 <acquire>
80104616:	83 c4 10             	add    $0x10,%esp
    if(removeFromStateList(&ptable.pLists.embryo, p) == 0)
80104619:	83 ec 08             	sub    $0x8,%esp
8010461c:	ff 75 f4             	pushl  -0xc(%ebp)
8010461f:	68 c8 5e 11 80       	push   $0x80115ec8
80104624:	e8 aa 14 00 00       	call   80105ad3 <removeFromStateList>
80104629:	83 c4 10             	add    $0x10,%esp
8010462c:	85 c0                	test   %eax,%eax
8010462e:	75 0d                	jne    8010463d <allocproc+0x125>
        panic("Failed allocproc remove from embryo");
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 14 99 10 80       	push   $0x80109914
80104638:	e8 29 bf ff ff       	call   80100566 <panic>
    assertState(p, EMBRYO);
8010463d:	83 ec 08             	sub    $0x8,%esp
80104640:	6a 01                	push   $0x1
80104642:	ff 75 f4             	pushl  -0xc(%ebp)
80104645:	e8 2d 15 00 00       	call   80105b77 <assertState>
8010464a:	83 c4 10             	add    $0x10,%esp
    if(addToStateListHead(&ptable.pLists.free, p) == 0)
8010464d:	83 ec 08             	sub    $0x8,%esp
80104650:	ff 75 f4             	pushl  -0xc(%ebp)
80104653:	68 b8 5e 11 80       	push   $0x80115eb8
80104658:	e8 a4 15 00 00       	call   80105c01 <addToStateListHead>
8010465d:	83 c4 10             	add    $0x10,%esp
80104660:	85 c0                	test   %eax,%eax
80104662:	75 0d                	jne    80104671 <allocproc+0x159>
        panic("Failed Allocproc Add To Free");
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	68 38 99 10 80       	push   $0x80109938
8010466c:	e8 f5 be ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104671:	83 ec 0c             	sub    $0xc,%esp
80104674:	68 80 39 11 80       	push   $0x80113980
80104679:	e8 ea 18 00 00       	call   80105f68 <release>
8010467e:	83 c4 10             	add    $0x10,%esp
#endif
    p->state = UNUSED;
80104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104684:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010468b:	b8 00 00 00 00       	mov    $0x0,%eax
80104690:	eb 5d                	jmp    801046ef <allocproc+0x1d7>
  }
  sp = p->kstack + KSTACKSIZE;
80104692:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104695:	8b 40 08             	mov    0x8(%eax),%eax
80104698:	05 00 10 00 00       	add    $0x1000,%eax
8010469d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801046a0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046aa:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046ad:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801046b1:	ba ba 76 10 80       	mov    $0x801076ba,%edx
801046b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046b9:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046bb:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046c5:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cb:	8b 40 1c             	mov    0x1c(%eax),%eax
801046ce:	83 ec 04             	sub    $0x4,%esp
801046d1:	6a 14                	push   $0x14
801046d3:	6a 00                	push   $0x0
801046d5:	50                   	push   %eax
801046d6:	e8 89 1a 00 00       	call   80106164 <memset>
801046db:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e1:	8b 40 1c             	mov    0x1c(%eax),%eax
801046e4:	ba b7 52 10 80       	mov    $0x801052b7,%edx
801046e9:	89 50 10             	mov    %edx,0x10(%eax)
  return p;
801046ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046ef:	c9                   	leave  
801046f0:	c3                   	ret    

801046f1 <userinit>:

// Set up first user process.
void
userinit(void)
{
801046f1:	55                   	push   %ebp
801046f2:	89 e5                	mov    %esp,%ebp
801046f4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_P3P4
  acquire(&ptable.lock);
801046f7:	83 ec 0c             	sub    $0xc,%esp
801046fa:	68 80 39 11 80       	push   $0x80113980
801046ff:	e8 fd 17 00 00       	call   80105f01 <acquire>
80104704:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
80104707:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
8010470e:	00 00 00 
  ptable.pLists.ready = 0;
80104711:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
80104718:	00 00 00 
  ptable.pLists.running = 0;
8010471b:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
80104722:	00 00 00 
  ptable.pLists.sleep = 0;
80104725:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
8010472c:	00 00 00 
  ptable.pLists.zombie = 0;
8010472f:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
80104736:	00 00 00 
  ptable.pLists.embryo = 0;
80104739:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
80104740:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104743:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010474a:	eb 35                	jmp    80104781 <userinit+0x90>
  {
      p->state = UNUSED;
8010474c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
      if(addToStateListHead(&ptable.pLists.free, p) == 0)
80104756:	83 ec 08             	sub    $0x8,%esp
80104759:	ff 75 f4             	pushl  -0xc(%ebp)
8010475c:	68 b8 5e 11 80       	push   $0x80115eb8
80104761:	e8 9b 14 00 00       	call   80105c01 <addToStateListHead>
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	85 c0                	test   %eax,%eax
8010476b:	75 0d                	jne    8010477a <userinit+0x89>
          panic("Failed add to free in userinit");
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	68 58 99 10 80       	push   $0x80109958
80104775:	e8 ec bd ff ff       	call   80100566 <panic>
  ptable.pLists.ready = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.embryo = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477a:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104781:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104788:	72 c2                	jb     8010474c <userinit+0x5b>
  {
      p->state = UNUSED;
      if(addToStateListHead(&ptable.pLists.free, p) == 0)
          panic("Failed add to free in userinit");
  }
  release(&ptable.lock);
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	68 80 39 11 80       	push   $0x80113980
80104792:	e8 d1 17 00 00       	call   80105f68 <release>
80104797:	83 c4 10             	add    $0x10,%esp
#endif
  
  p = allocproc();  //free goes to embryo
8010479a:	e8 79 fd ff ff       	call   80104518 <allocproc>
8010479f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a5:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
801047aa:	e8 cd 45 00 00       	call   80108d7c <setupkvm>
801047af:	89 c2                	mov    %eax,%edx
801047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b4:	89 50 04             	mov    %edx,0x4(%eax)
801047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ba:	8b 40 04             	mov    0x4(%eax),%eax
801047bd:	85 c0                	test   %eax,%eax
801047bf:	75 0d                	jne    801047ce <userinit+0xdd>
    panic("userinit: out of memory?");
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 77 99 10 80       	push   $0x80109977
801047c9:	e8 98 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047ce:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d6:	8b 40 04             	mov    0x4(%eax),%eax
801047d9:	83 ec 04             	sub    $0x4,%esp
801047dc:	52                   	push   %edx
801047dd:	68 00 c5 10 80       	push   $0x8010c500
801047e2:	50                   	push   %eax
801047e3:	e8 ee 47 00 00       	call   80108fd6 <inituvm>
801047e8:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ee:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f7:	8b 40 18             	mov    0x18(%eax),%eax
801047fa:	83 ec 04             	sub    $0x4,%esp
801047fd:	6a 4c                	push   $0x4c
801047ff:	6a 00                	push   $0x0
80104801:	50                   	push   %eax
80104802:	e8 5d 19 00 00       	call   80106164 <memset>
80104807:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480d:	8b 40 18             	mov    0x18(%eax),%eax
80104810:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104819:	8b 40 18             	mov    0x18(%eax),%eax
8010481c:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104825:	8b 40 18             	mov    0x18(%eax),%eax
80104828:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010482b:	8b 52 18             	mov    0x18(%edx),%edx
8010482e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104832:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104839:	8b 40 18             	mov    0x18(%eax),%eax
8010483c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010483f:	8b 52 18             	mov    0x18(%edx),%edx
80104842:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104846:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010484a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484d:	8b 40 18             	mov    0x18(%eax),%eax
80104850:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485a:	8b 40 18             	mov    0x18(%eax),%eax
8010485d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104867:	8b 40 18             	mov    0x18(%eax),%eax
8010486a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104874:	83 c0 6c             	add    $0x6c,%eax
80104877:	83 ec 04             	sub    $0x4,%esp
8010487a:	6a 10                	push   $0x10
8010487c:	68 90 99 10 80       	push   $0x80109990
80104881:	50                   	push   %eax
80104882:	e8 e0 1a 00 00       	call   80106367 <safestrcpy>
80104887:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 99 99 10 80       	push   $0x80109999
80104892:	e8 2f dd ff ff       	call   801025c6 <namei>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	89 c2                	mov    %eax,%edx
8010489c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489f:	89 50 68             	mov    %edx,0x68(%eax)
#ifdef CS333_P2
  p->uid = DEF_UID;
801048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801048ac:	00 00 00 
  p->gid = DEF_GID;
801048af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801048b9:	00 00 00 
#endif
#ifdef CS333_P3P4
  //embryo goes to ready
  acquire(&ptable.lock);
801048bc:	83 ec 0c             	sub    $0xc,%esp
801048bf:	68 80 39 11 80       	push   $0x80113980
801048c4:	e8 38 16 00 00       	call   80105f01 <acquire>
801048c9:	83 c4 10             	add    $0x10,%esp
  if(removeFromStateList(&ptable.pLists.embryo, p) == -1)
801048cc:	83 ec 08             	sub    $0x8,%esp
801048cf:	ff 75 f4             	pushl  -0xc(%ebp)
801048d2:	68 c8 5e 11 80       	push   $0x80115ec8
801048d7:	e8 f7 11 00 00       	call   80105ad3 <removeFromStateList>
801048dc:	83 c4 10             	add    $0x10,%esp
801048df:	83 f8 ff             	cmp    $0xffffffff,%eax
801048e2:	75 27                	jne    8010490b <userinit+0x21a>
  {
      assertState(p, EMBRYO);
801048e4:	83 ec 08             	sub    $0x8,%esp
801048e7:	6a 01                	push   $0x1
801048e9:	ff 75 f4             	pushl  -0xc(%ebp)
801048ec:	e8 86 12 00 00       	call   80105b77 <assertState>
801048f1:	83 c4 10             	add    $0x10,%esp
      p->next = 0;
801048f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f7:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801048fe:	00 00 00 
      ptable.pLists.ready = p;
80104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104904:	a3 b4 5e 11 80       	mov    %eax,0x80115eb4
80104909:	eb 0d                	jmp    80104918 <userinit+0x227>
  }
  else
      panic("Error Initializing Ready List");
8010490b:	83 ec 0c             	sub    $0xc,%esp
8010490e:	68 9b 99 10 80       	push   $0x8010999b
80104913:	e8 4e bc ff ff       	call   80100566 <panic>
  release(&ptable.lock);
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	68 80 39 11 80       	push   $0x80113980
80104920:	e8 43 16 00 00       	call   80105f68 <release>
80104925:	83 c4 10             	add    $0x10,%esp
#endif
  p->state = RUNNABLE;
80104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104932:	90                   	nop
80104933:	c9                   	leave  
80104934:	c3                   	ret    

80104935 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104935:	55                   	push   %ebp
80104936:	89 e5                	mov    %esp,%ebp
80104938:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010493b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104941:	8b 00                	mov    (%eax),%eax
80104943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104946:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010494a:	7e 31                	jle    8010497d <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010494c:	8b 55 08             	mov    0x8(%ebp),%edx
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	01 c2                	add    %eax,%edx
80104954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495a:	8b 40 04             	mov    0x4(%eax),%eax
8010495d:	83 ec 04             	sub    $0x4,%esp
80104960:	52                   	push   %edx
80104961:	ff 75 f4             	pushl  -0xc(%ebp)
80104964:	50                   	push   %eax
80104965:	e8 b9 47 00 00       	call   80109123 <allocuvm>
8010496a:	83 c4 10             	add    $0x10,%esp
8010496d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104974:	75 3e                	jne    801049b4 <growproc+0x7f>
      return -1;
80104976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497b:	eb 59                	jmp    801049d6 <growproc+0xa1>
  } else if(n < 0){
8010497d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104981:	79 31                	jns    801049b4 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104983:	8b 55 08             	mov    0x8(%ebp),%edx
80104986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104989:	01 c2                	add    %eax,%edx
8010498b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104991:	8b 40 04             	mov    0x4(%eax),%eax
80104994:	83 ec 04             	sub    $0x4,%esp
80104997:	52                   	push   %edx
80104998:	ff 75 f4             	pushl  -0xc(%ebp)
8010499b:	50                   	push   %eax
8010499c:	e8 4b 48 00 00       	call   801091ec <deallocuvm>
801049a1:	83 c4 10             	add    $0x10,%esp
801049a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049ab:	75 07                	jne    801049b4 <growproc+0x7f>
      return -1;
801049ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b2:	eb 22                	jmp    801049d6 <growproc+0xa1>
  }
  proc->sz = sz;
801049b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049bd:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801049bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c5:	83 ec 0c             	sub    $0xc,%esp
801049c8:	50                   	push   %eax
801049c9:	e8 95 44 00 00       	call   80108e63 <switchuvm>
801049ce:	83 c4 10             	add    $0x10,%esp
  return 0;
801049d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049d6:	c9                   	leave  
801049d7:	c3                   	ret    

801049d8 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int //starts as embryo here
fork(void)
{
801049d8:	55                   	push   %ebp
801049d9:	89 e5                	mov    %esp,%ebp
801049db:	57                   	push   %edi
801049dc:	56                   	push   %esi
801049dd:	53                   	push   %ebx
801049de:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  
  // Allocate process.
  if((np = allocproc()) == 0)
801049e1:	e8 32 fb ff ff       	call   80104518 <allocproc>
801049e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049ed:	75 0a                	jne    801049f9 <fork+0x21>
    return -1;
801049ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f4:	e9 66 02 00 00       	jmp    80104c5f <fork+0x287>


  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ff:	8b 10                	mov    (%eax),%edx
80104a01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a07:	8b 40 04             	mov    0x4(%eax),%eax
80104a0a:	83 ec 08             	sub    $0x8,%esp
80104a0d:	52                   	push   %edx
80104a0e:	50                   	push   %eax
80104a0f:	e8 76 49 00 00       	call   8010938a <copyuvm>
80104a14:	83 c4 10             	add    $0x10,%esp
80104a17:	89 c2                	mov    %eax,%edx
80104a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a1c:	89 50 04             	mov    %edx,0x4(%eax)
80104a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a22:	8b 40 04             	mov    0x4(%eax),%eax
80104a25:	85 c0                	test   %eax,%eax
80104a27:	0f 85 a8 00 00 00    	jne    80104ad5 <fork+0xfd>
    kfree(np->kstack);
80104a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a30:	8b 40 08             	mov    0x8(%eax),%eax
80104a33:	83 ec 0c             	sub    $0xc,%esp
80104a36:	50                   	push   %eax
80104a37:	e8 2b e2 ff ff       	call   80102c67 <kfree>
80104a3c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
#ifdef CS333_P3P4
    acquire(&ptable.lock); 
80104a53:	83 ec 0c             	sub    $0xc,%esp
80104a56:	68 80 39 11 80       	push   $0x80113980
80104a5b:	e8 a1 14 00 00       	call   80105f01 <acquire>
80104a60:	83 c4 10             	add    $0x10,%esp
    //give to free : handle return value?
    if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
80104a63:	83 ec 08             	sub    $0x8,%esp
80104a66:	ff 75 e0             	pushl  -0x20(%ebp)
80104a69:	68 c8 5e 11 80       	push   $0x80115ec8
80104a6e:	e8 60 10 00 00       	call   80105ad3 <removeFromStateList>
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	85 c0                	test   %eax,%eax
80104a78:	75 0d                	jne    80104a87 <fork+0xaf>
        panic("Failed remove from Embryo in fork");
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 bc 99 10 80       	push   $0x801099bc
80104a82:	e8 df ba ff ff       	call   80100566 <panic>
    assertState(np, EMBRYO);    
80104a87:	83 ec 08             	sub    $0x8,%esp
80104a8a:	6a 01                	push   $0x1
80104a8c:	ff 75 e0             	pushl  -0x20(%ebp)
80104a8f:	e8 e3 10 00 00       	call   80105b77 <assertState>
80104a94:	83 c4 10             	add    $0x10,%esp
    if(addToStateListHead(&ptable.pLists.free, np) == 0)
80104a97:	83 ec 08             	sub    $0x8,%esp
80104a9a:	ff 75 e0             	pushl  -0x20(%ebp)
80104a9d:	68 b8 5e 11 80       	push   $0x80115eb8
80104aa2:	e8 5a 11 00 00       	call   80105c01 <addToStateListHead>
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	75 0d                	jne    80104abb <fork+0xe3>
        panic("Failed add to free in fork");
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	68 de 99 10 80       	push   $0x801099de
80104ab6:	e8 ab ba ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	68 80 39 11 80       	push   $0x80113980
80104ac3:	e8 a0 14 00 00       	call   80105f68 <release>
80104ac8:	83 c4 10             	add    $0x10,%esp
#endif
    return -1;
80104acb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad0:	e9 8a 01 00 00       	jmp    80104c5f <fork+0x287>
  }
  np->sz = proc->sz;
80104ad5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104adb:	8b 10                	mov    (%eax),%edx
80104add:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ae0:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104ae2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aec:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af2:	8b 50 18             	mov    0x18(%eax),%edx
80104af5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afb:	8b 40 18             	mov    0x18(%eax),%eax
80104afe:	89 c3                	mov    %eax,%ebx
80104b00:	b8 13 00 00 00       	mov    $0x13,%eax
80104b05:	89 d7                	mov    %edx,%edi
80104b07:	89 de                	mov    %ebx,%esi
80104b09:	89 c1                	mov    %eax,%ecx
80104b0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

#ifdef CS333_P2
  np->uid = proc->uid;
80104b0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b13:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104b22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b28:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b31:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
#endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b3a:	8b 40 18             	mov    0x18(%eax),%eax
80104b3d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b4b:	eb 43                	jmp    80104b90 <fork+0x1b8>
    if(proc->ofile[i])
80104b4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b56:	83 c2 08             	add    $0x8,%edx
80104b59:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b5d:	85 c0                	test   %eax,%eax
80104b5f:	74 2b                	je     80104b8c <fork+0x1b4>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b6a:	83 c2 08             	add    $0x8,%edx
80104b6d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b71:	83 ec 0c             	sub    $0xc,%esp
80104b74:	50                   	push   %eax
80104b75:	e8 24 c5 ff ff       	call   8010109e <filedup>
80104b7a:	83 c4 10             	add    $0x10,%esp
80104b7d:	89 c1                	mov    %eax,%ecx
80104b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b85:	83 c2 08             	add    $0x8,%edx
80104b88:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;
#endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b8c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b90:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b94:	7e b7                	jle    80104b4d <fork+0x175>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9c:	8b 40 68             	mov    0x68(%eax),%eax
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	50                   	push   %eax
80104ba3:	e8 26 ce ff ff       	call   801019ce <idup>
80104ba8:	83 c4 10             	add    $0x10,%esp
80104bab:	89 c2                	mov    %eax,%edx
80104bad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bb0:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104bb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb9:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bbf:	83 c0 6c             	add    $0x6c,%eax
80104bc2:	83 ec 04             	sub    $0x4,%esp
80104bc5:	6a 10                	push   $0x10
80104bc7:	52                   	push   %edx
80104bc8:	50                   	push   %eax
80104bc9:	e8 99 17 00 00       	call   80106367 <safestrcpy>
80104bce:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bd4:	8b 40 10             	mov    0x10(%eax),%eax
80104bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104bda:	83 ec 0c             	sub    $0xc,%esp
80104bdd:	68 80 39 11 80       	push   $0x80113980
80104be2:	e8 1a 13 00 00       	call   80105f01 <acquire>
80104be7:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
80104bea:	83 ec 08             	sub    $0x8,%esp
80104bed:	ff 75 e0             	pushl  -0x20(%ebp)
80104bf0:	68 c8 5e 11 80       	push   $0x80115ec8
80104bf5:	e8 d9 0e 00 00       	call   80105ad3 <removeFromStateList>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	75 0d                	jne    80104c0e <fork+0x236>
      panic("fork fail");
80104c01:	83 ec 0c             	sub    $0xc,%esp
80104c04:	68 f9 99 10 80       	push   $0x801099f9
80104c09:	e8 58 b9 ff ff       	call   80100566 <panic>
  assertState(np, EMBRYO);
80104c0e:	83 ec 08             	sub    $0x8,%esp
80104c11:	6a 01                	push   $0x1
80104c13:	ff 75 e0             	pushl  -0x20(%ebp)
80104c16:	e8 5c 0f 00 00       	call   80105b77 <assertState>
80104c1b:	83 c4 10             	add    $0x10,%esp
  if(addToStateListEnd(&ptable.pLists.ready, np) == 0)
80104c1e:	83 ec 08             	sub    $0x8,%esp
80104c21:	ff 75 e0             	pushl  -0x20(%ebp)
80104c24:	68 b4 5e 11 80       	push   $0x80115eb4
80104c29:	e8 6a 0f 00 00       	call   80105b98 <addToStateListEnd>
80104c2e:	83 c4 10             	add    $0x10,%esp
80104c31:	85 c0                	test   %eax,%eax
80104c33:	75 0d                	jne    80104c42 <fork+0x26a>
      panic("Fork fail 2");
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	68 03 9a 10 80       	push   $0x80109a03
80104c3d:	e8 24 b9 ff ff       	call   80100566 <panic>
#endif
  np->state = RUNNABLE;
80104c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	68 80 39 11 80       	push   $0x80113980
80104c54:	e8 0f 13 00 00       	call   80105f68 <release>
80104c59:	83 c4 10             	add    $0x10,%esp
  return pid;
80104c5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c62:	5b                   	pop    %ebx
80104c63:	5e                   	pop    %esi
80104c64:	5f                   	pop    %edi
80104c65:	5d                   	pop    %ebp
80104c66:	c3                   	ret    

80104c67 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104c67:	55                   	push   %ebp
80104c68:	89 e5                	mov    %esp,%ebp
80104c6a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  //struct proc *current;
  int fd;

  if(proc == initproc)
80104c6d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c74:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104c79:	39 c2                	cmp    %eax,%edx
80104c7b:	75 0d                	jne    80104c8a <exit+0x23>
    panic("init exiting");
80104c7d:	83 ec 0c             	sub    $0xc,%esp
80104c80:	68 0f 9a 10 80       	push   $0x80109a0f
80104c85:	e8 dc b8 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c91:	eb 48                	jmp    80104cdb <exit+0x74>
    if(proc->ofile[fd]){
80104c93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c99:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c9c:	83 c2 08             	add    $0x8,%edx
80104c9f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ca3:	85 c0                	test   %eax,%eax
80104ca5:	74 30                	je     80104cd7 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104ca7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cad:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cb0:	83 c2 08             	add    $0x8,%edx
80104cb3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cb7:	83 ec 0c             	sub    $0xc,%esp
80104cba:	50                   	push   %eax
80104cbb:	e8 2f c4 ff ff       	call   801010ef <fileclose>
80104cc0:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ccc:	83 c2 08             	add    $0x8,%edx
80104ccf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104cd6:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104cd7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104cdb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104cdf:	7e b2                	jle    80104c93 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104ce1:	e8 05 e9 ff ff       	call   801035eb <begin_op>
  iput(proc->cwd);
80104ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cec:	8b 40 68             	mov    0x68(%eax),%eax
80104cef:	83 ec 0c             	sub    $0xc,%esp
80104cf2:	50                   	push   %eax
80104cf3:	e8 e0 ce ff ff       	call   80101bd8 <iput>
80104cf8:	83 c4 10             	add    $0x10,%esp
  end_op();
80104cfb:	e8 77 e9 ff ff       	call   80103677 <end_op>
  proc->cwd = 0;
80104d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d06:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104d0d:	83 ec 0c             	sub    $0xc,%esp
80104d10:	68 80 39 11 80       	push   $0x80113980
80104d15:	e8 e7 11 00 00       	call   80105f01 <acquire>
80104d1a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104d1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d23:	8b 40 14             	mov    0x14(%eax),%eax
80104d26:	83 ec 0c             	sub    $0xc,%esp
80104d29:	50                   	push   %eax
80104d2a:	e8 d7 06 00 00       	call   80105406 <wakeup1>
80104d2f:	83 c4 10             	add    $0x10,%esp

  

  // Pass abandoned children to init.

  exitSearch(ptable.pLists.ready);
80104d32:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80104d37:	83 ec 0c             	sub    $0xc,%esp
80104d3a:	50                   	push   %eax
80104d3b:	e8 ee 0e 00 00       	call   80105c2e <exitSearch>
80104d40:	83 c4 10             	add    $0x10,%esp
  exitSearch(ptable.pLists.running);
80104d43:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	50                   	push   %eax
80104d4c:	e8 dd 0e 00 00       	call   80105c2e <exitSearch>
80104d51:	83 c4 10             	add    $0x10,%esp
  exitSearch(ptable.pLists.sleep);
80104d54:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	50                   	push   %eax
80104d5d:	e8 cc 0e 00 00       	call   80105c2e <exitSearch>
80104d62:	83 c4 10             	add    $0x10,%esp
  exitSearch(ptable.pLists.embryo);
80104d65:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	50                   	push   %eax
80104d6e:	e8 bb 0e 00 00       	call   80105c2e <exitSearch>
80104d73:	83 c4 10             	add    $0x10,%esp

  p = ptable.pLists.zombie;
80104d76:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80104d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80104d7e:	eb 39                	jmp    80104db9 <exit+0x152>
  {
      if(p->parent == proc)
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	8b 50 14             	mov    0x14(%eax),%edx
80104d86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8c:	39 c2                	cmp    %eax,%edx
80104d8e:	75 1d                	jne    80104dad <exit+0x146>
      {
          p->parent = initproc;
80104d90:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d99:	89 50 14             	mov    %edx,0x14(%eax)
          wakeup1(initproc);
80104d9c:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104da1:	83 ec 0c             	sub    $0xc,%esp
80104da4:	50                   	push   %eax
80104da5:	e8 5c 06 00 00       	call   80105406 <wakeup1>
80104daa:	83 c4 10             	add    $0x10,%esp
      }
      p = p->next;
80104dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exitSearch(ptable.pLists.running);
  exitSearch(ptable.pLists.sleep);
  exitSearch(ptable.pLists.embryo);

  p = ptable.pLists.zombie;
  while(p)
80104db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dbd:	75 c1                	jne    80104d80 <exit+0x119>
      p = p->next;
  }

  // Jump into the scheduler, never to return.

  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
80104dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc5:	83 ec 08             	sub    $0x8,%esp
80104dc8:	50                   	push   %eax
80104dc9:	68 c4 5e 11 80       	push   $0x80115ec4
80104dce:	e8 00 0d 00 00       	call   80105ad3 <removeFromStateList>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	75 0d                	jne    80104de7 <exit+0x180>
      panic("exit failed running");
80104dda:	83 ec 0c             	sub    $0xc,%esp
80104ddd:	68 1c 9a 10 80       	push   $0x80109a1c
80104de2:	e8 7f b7 ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
80104de7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ded:	83 ec 08             	sub    $0x8,%esp
80104df0:	6a 04                	push   $0x4
80104df2:	50                   	push   %eax
80104df3:	e8 7f 0d 00 00       	call   80105b77 <assertState>
80104df8:	83 c4 10             	add    $0x10,%esp
  if(addToStateListHead(&ptable.pLists.zombie, proc) == 0)
80104dfb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e01:	83 ec 08             	sub    $0x8,%esp
80104e04:	50                   	push   %eax
80104e05:	68 c0 5e 11 80       	push   $0x80115ec0
80104e0a:	e8 f2 0d 00 00       	call   80105c01 <addToStateListHead>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	75 0d                	jne    80104e23 <exit+0x1bc>
      panic("exit failed zombie");
80104e16:	83 ec 0c             	sub    $0xc,%esp
80104e19:	68 30 9a 10 80       	push   $0x80109a30
80104e1e:	e8 43 b7 ff ff       	call   80100566 <panic>
  proc->state = ZOMBIE;
80104e23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e29:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104e30:	e8 f1 02 00 00       	call   80105126 <sched>
  panic("zombie exit");
80104e35:	83 ec 0c             	sub    $0xc,%esp
80104e38:	68 43 9a 10 80       	push   $0x80109a43
80104e3d:	e8 24 b7 ff ff       	call   80100566 <panic>

80104e42 <wait>:
  }
}
#else
int
wait(void)
{
80104e42:	55                   	push   %ebp
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 80 39 11 80       	push   $0x80113980
80104e50:	e8 ac 10 00 00       	call   80105f01 <acquire>
80104e55:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104e58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    p = ptable.pLists.zombie;
80104e5f:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80104e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(p)
80104e67:	e9 fd 00 00 00       	jmp    80104f69 <wait+0x127>
    {                   
      if(p->parent == proc){
80104e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6f:	8b 50 14             	mov    0x14(%eax),%edx
80104e72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e78:	39 c2                	cmp    %eax,%edx
80104e7a:	0f 85 dd 00 00 00    	jne    80104f5d <wait+0x11b>
        havekids = 1;
80104e80:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        // Found one.
        if(removeFromStateList(&ptable.pLists.zombie, p) == 0)
80104e87:	83 ec 08             	sub    $0x8,%esp
80104e8a:	ff 75 f4             	pushl  -0xc(%ebp)
80104e8d:	68 c0 5e 11 80       	push   $0x80115ec0
80104e92:	e8 3c 0c 00 00       	call   80105ad3 <removeFromStateList>
80104e97:	83 c4 10             	add    $0x10,%esp
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	75 0d                	jne    80104eab <wait+0x69>
            panic("wait zombie");
80104e9e:	83 ec 0c             	sub    $0xc,%esp
80104ea1:	68 4f 9a 10 80       	push   $0x80109a4f
80104ea6:	e8 bb b6 ff ff       	call   80100566 <panic>
        assertState(p, ZOMBIE);
80104eab:	83 ec 08             	sub    $0x8,%esp
80104eae:	6a 05                	push   $0x5
80104eb0:	ff 75 f4             	pushl  -0xc(%ebp)
80104eb3:	e8 bf 0c 00 00       	call   80105b77 <assertState>
80104eb8:	83 c4 10             	add    $0x10,%esp
        pid = p->pid;
80104ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ebe:	8b 40 10             	mov    0x10(%eax),%eax
80104ec1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec7:	8b 40 08             	mov    0x8(%eax),%eax
80104eca:	83 ec 0c             	sub    $0xc,%esp
80104ecd:	50                   	push   %eax
80104ece:	e8 94 dd ff ff       	call   80102c67 <kfree>
80104ed3:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee3:	8b 40 04             	mov    0x4(%eax),%eax
80104ee6:	83 ec 0c             	sub    $0xc,%esp
80104ee9:	50                   	push   %eax
80104eea:	e8 ba 43 00 00       	call   801092a9 <freevm>
80104eef:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eff:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f09:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f13:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        if(addToStateListHead(&ptable.pLists.free, p) == 0)
80104f21:	83 ec 08             	sub    $0x8,%esp
80104f24:	ff 75 f4             	pushl  -0xc(%ebp)
80104f27:	68 b8 5e 11 80       	push   $0x80115eb8
80104f2c:	e8 d0 0c 00 00       	call   80105c01 <addToStateListHead>
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	85 c0                	test   %eax,%eax
80104f36:	75 0d                	jne    80104f45 <wait+0x103>
            panic("wait free");        
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	68 5b 9a 10 80       	push   $0x80109a5b
80104f40:	e8 21 b6 ff ff       	call   80100566 <panic>
        release(&ptable.lock);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	68 80 39 11 80       	push   $0x80113980
80104f4d:	e8 16 10 00 00       	call   80105f68 <release>
80104f52:	83 c4 10             	add    $0x10,%esp
        return pid;
80104f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f58:	e9 c4 00 00 00       	jmp    80105021 <wait+0x1df>
      }
      p = p->next;
80104f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f60:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;
    while(p)
80104f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f6d:	0f 85 f9 fe ff ff    	jne    80104e6c <wait+0x2a>
        return pid;
      }
      p = p->next;
    }

    if(havekids == 0)
80104f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f77:	75 14                	jne    80104f8d <wait+0x14b>
        havekids = waitSearch(ptable.pLists.ready);
80104f79:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80104f7e:	83 ec 0c             	sub    $0xc,%esp
80104f81:	50                   	push   %eax
80104f82:	e8 ec 0c 00 00       	call   80105c73 <waitSearch>
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(havekids == 0)
80104f8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f91:	75 14                	jne    80104fa7 <wait+0x165>
        havekids = waitSearch(ptable.pLists.sleep);
80104f93:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	50                   	push   %eax
80104f9c:	e8 d2 0c 00 00       	call   80105c73 <waitSearch>
80104fa1:	83 c4 10             	add    $0x10,%esp
80104fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(havekids == 0)
80104fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fab:	75 14                	jne    80104fc1 <wait+0x17f>
        havekids = waitSearch(ptable.pLists.running);
80104fad:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80104fb2:	83 ec 0c             	sub    $0xc,%esp
80104fb5:	50                   	push   %eax
80104fb6:	e8 b8 0c 00 00       	call   80105c73 <waitSearch>
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(havekids == 0)
80104fc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fc5:	75 14                	jne    80104fdb <wait+0x199>
        havekids = waitSearch(ptable.pLists.embryo);
80104fc7:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
80104fcc:	83 ec 0c             	sub    $0xc,%esp
80104fcf:	50                   	push   %eax
80104fd0:	e8 9e 0c 00 00       	call   80105c73 <waitSearch>
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fdf:	74 0d                	je     80104fee <wait+0x1ac>
80104fe1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe7:	8b 40 24             	mov    0x24(%eax),%eax
80104fea:	85 c0                	test   %eax,%eax
80104fec:	74 17                	je     80105005 <wait+0x1c3>
      release(&ptable.lock);
80104fee:	83 ec 0c             	sub    $0xc,%esp
80104ff1:	68 80 39 11 80       	push   $0x80113980
80104ff6:	e8 6d 0f 00 00       	call   80105f68 <release>
80104ffb:	83 c4 10             	add    $0x10,%esp
      return -1;
80104ffe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105003:	eb 1c                	jmp    80105021 <wait+0x1df>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105005:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010500b:	83 ec 08             	sub    $0x8,%esp
8010500e:	68 80 39 11 80       	push   $0x80113980
80105013:	50                   	push   %eax
80105014:	e8 e4 02 00 00       	call   801052fd <sleep>
80105019:	83 c4 10             	add    $0x10,%esp
  }
8010501c:	e9 37 fe ff ff       	jmp    80104e58 <wait+0x16>
}
80105021:	c9                   	leave  
80105022:	c3                   	ret    

80105023 <scheduler>:
}

#else
void
scheduler(void)
{
80105023:	55                   	push   %ebp
80105024:	89 e5                	mov    %esp,%ebp
80105026:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80105029:	e8 c5 f4 ff ff       	call   801044f3 <sti>

    idle = 1;  // assume idle unless we schedule a process
8010502e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80105035:	83 ec 0c             	sub    $0xc,%esp
80105038:	68 80 39 11 80       	push   $0x80113980
8010503d:	e8 bf 0e 00 00       	call   80105f01 <acquire>
80105042:	83 c4 10             	add    $0x10,%esp
    p = removeFromStateListHead(&ptable.pLists.ready);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	68 b4 5e 11 80       	push   $0x80115eb4
8010504d:	e8 41 0a 00 00       	call   80105a93 <removeFromStateListHead>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(p)
80105058:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010505c:	0f 84 9b 00 00 00    	je     801050fd <scheduler+0xda>
    {
      assertState(p, RUNNABLE);
80105062:	83 ec 08             	sub    $0x8,%esp
80105065:	6a 03                	push   $0x3
80105067:	ff 75 f0             	pushl  -0x10(%ebp)
8010506a:	e8 08 0b 00 00       	call   80105b77 <assertState>
8010506f:	83 c4 10             	add    $0x10,%esp

//      cprintf("Process entering CPU: %d\n", p->pid);
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80105072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      proc = p;
80105079:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	ff 75 f0             	pushl  -0x10(%ebp)
80105088:	e8 d6 3d 00 00       	call   80108e63 <switchuvm>
8010508d:	83 c4 10             	add    $0x10,%esp

      p->state = RUNNING;
80105090:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105093:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
8010509a:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801050a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050a3:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
#endif
      if(addToStateListHead(&ptable.pLists.running, p) == 0)
801050a9:	83 ec 08             	sub    $0x8,%esp
801050ac:	ff 75 f0             	pushl  -0x10(%ebp)
801050af:	68 c4 5e 11 80       	push   $0x80115ec4
801050b4:	e8 48 0b 00 00       	call   80105c01 <addToStateListHead>
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	85 c0                	test   %eax,%eax
801050be:	75 0d                	jne    801050cd <scheduler+0xaa>
          panic("failed sched add to running");
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	68 65 9a 10 80       	push   $0x80109a65
801050c8:	e8 99 b4 ff ff       	call   80100566 <panic>
      swtch(&cpu->scheduler, proc->context);
801050cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050d3:	8b 40 1c             	mov    0x1c(%eax),%eax
801050d6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050dd:	83 c2 04             	add    $0x4,%edx
801050e0:	83 ec 08             	sub    $0x8,%esp
801050e3:	50                   	push   %eax
801050e4:	52                   	push   %edx
801050e5:	e8 ee 12 00 00       	call   801063d8 <swtch>
801050ea:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801050ed:	e8 54 3d 00 00       	call   80108e46 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801050f2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801050f9:	00 00 00 00 

    }
    release(&ptable.lock);
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	68 80 39 11 80       	push   $0x80113980
80105105:	e8 5e 0e 00 00       	call   80105f68 <release>
8010510a:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
8010510d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105111:	0f 84 12 ff ff ff    	je     80105029 <scheduler+0x6>
      sti();
80105117:	e8 d7 f3 ff ff       	call   801044f3 <sti>
      hlt();
8010511c:	e8 bb f3 ff ff       	call   801044dc <hlt>
    }
  }
80105121:	e9 03 ff ff ff       	jmp    80105029 <scheduler+0x6>

80105126 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105126:	55                   	push   %ebp
80105127:	89 e5                	mov    %esp,%ebp
80105129:	53                   	push   %ebx
8010512a:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	68 80 39 11 80       	push   $0x80113980
80105135:	e8 fa 0e 00 00       	call   80106034 <holding>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	85 c0                	test   %eax,%eax
8010513f:	75 0d                	jne    8010514e <sched+0x28>
    panic("sched ptable.lock");
80105141:	83 ec 0c             	sub    $0xc,%esp
80105144:	68 81 9a 10 80       	push   $0x80109a81
80105149:	e8 18 b4 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
8010514e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105154:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010515a:	83 f8 01             	cmp    $0x1,%eax
8010515d:	74 0d                	je     8010516c <sched+0x46>
    panic("sched locks");
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	68 93 9a 10 80       	push   $0x80109a93
80105167:	e8 fa b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
8010516c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105172:	8b 40 0c             	mov    0xc(%eax),%eax
80105175:	83 f8 04             	cmp    $0x4,%eax
80105178:	75 0d                	jne    80105187 <sched+0x61>
    panic("sched running");
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	68 9f 9a 10 80       	push   $0x80109a9f
80105182:	e8 df b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105187:	e8 57 f3 ff ff       	call   801044e3 <readeflags>
8010518c:	25 00 02 00 00       	and    $0x200,%eax
80105191:	85 c0                	test   %eax,%eax
80105193:	74 0d                	je     801051a2 <sched+0x7c>
    panic("sched interruptible");
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	68 ad 9a 10 80       	push   $0x80109aad
8010519d:	e8 c4 b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801051a2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051a8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
#ifdef CS333_P2
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
801051b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051be:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801051c4:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
801051ca:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051d1:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801051d7:	29 d3                	sub    %edx,%ebx
801051d9:	89 da                	mov    %ebx,%edx
801051db:	01 ca                	add    %ecx,%edx
801051dd:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
#endif
  swtch(&proc->context, cpu->scheduler);
801051e3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051e9:	8b 40 04             	mov    0x4(%eax),%eax
801051ec:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051f3:	83 c2 1c             	add    $0x1c,%edx
801051f6:	83 ec 08             	sub    $0x8,%esp
801051f9:	50                   	push   %eax
801051fa:	52                   	push   %edx
801051fb:	e8 d8 11 00 00       	call   801063d8 <swtch>
80105200:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105203:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105209:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010520c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105212:	90                   	nop
80105213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105216:	c9                   	leave  
80105217:	c3                   	ret    

80105218 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105218:	55                   	push   %ebp
80105219:	89 e5                	mov    %esp,%ebp
8010521b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010521e:	83 ec 0c             	sub    $0xc,%esp
80105221:	68 80 39 11 80       	push   $0x80113980
80105226:	e8 d6 0c 00 00       	call   80105f01 <acquire>
8010522b:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4 //from running to ready
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
8010522e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	50                   	push   %eax
80105238:	68 c4 5e 11 80       	push   $0x80115ec4
8010523d:	e8 91 08 00 00       	call   80105ad3 <removeFromStateList>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	75 0d                	jne    80105256 <yield+0x3e>
      panic("Failed Yield Remove From Running");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 c4 9a 10 80       	push   $0x80109ac4
80105251:	e8 10 b3 ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
80105256:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010525c:	83 ec 08             	sub    $0x8,%esp
8010525f:	6a 04                	push   $0x4
80105261:	50                   	push   %eax
80105262:	e8 10 09 00 00       	call   80105b77 <assertState>
80105267:	83 c4 10             	add    $0x10,%esp
  if(addToStateListEnd(&ptable.pLists.ready, proc) == 0)
8010526a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105270:	83 ec 08             	sub    $0x8,%esp
80105273:	50                   	push   %eax
80105274:	68 b4 5e 11 80       	push   $0x80115eb4
80105279:	e8 1a 09 00 00       	call   80105b98 <addToStateListEnd>
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	85 c0                	test   %eax,%eax
80105283:	75 0d                	jne    80105292 <yield+0x7a>
      panic("Failed Yield Add To Ready");
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	68 e5 9a 10 80       	push   $0x80109ae5
8010528d:	e8 d4 b2 ff ff       	call   80100566 <panic>
#endif
  proc->state = RUNNABLE;
80105292:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105298:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010529f:	e8 82 fe ff ff       	call   80105126 <sched>
  release(&ptable.lock);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	68 80 39 11 80       	push   $0x80113980
801052ac:	e8 b7 0c 00 00       	call   80105f68 <release>
801052b1:	83 c4 10             	add    $0x10,%esp
}
801052b4:	90                   	nop
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    

801052b7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801052b7:	55                   	push   %ebp
801052b8:	89 e5                	mov    %esp,%ebp
801052ba:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	68 80 39 11 80       	push   $0x80113980
801052c5:	e8 9e 0c 00 00       	call   80105f68 <release>
801052ca:	83 c4 10             	add    $0x10,%esp

  if (first) {
801052cd:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801052d2:	85 c0                	test   %eax,%eax
801052d4:	74 24                	je     801052fa <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801052d6:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
801052dd:	00 00 00 
    iinit(ROOTDEV);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	6a 01                	push   $0x1
801052e5:	e8 f2 c3 ff ff       	call   801016dc <iinit>
801052ea:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	6a 01                	push   $0x1
801052f2:	e8 d6 e0 ff ff       	call   801033cd <initlog>
801052f7:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801052fa:	90                   	nop
801052fb:	c9                   	leave  
801052fc:	c3                   	ret    

801052fd <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801052fd:	55                   	push   %ebp
801052fe:	89 e5                	mov    %esp,%ebp
80105300:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105303:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105309:	85 c0                	test   %eax,%eax
8010530b:	75 0d                	jne    8010531a <sleep+0x1d>
    panic("sleep");
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	68 ff 9a 10 80       	push   $0x80109aff
80105315:	e8 4c b2 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
8010531a:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80105321:	74 24                	je     80105347 <sleep+0x4a>
    acquire(&ptable.lock);
80105323:	83 ec 0c             	sub    $0xc,%esp
80105326:	68 80 39 11 80       	push   $0x80113980
8010532b:	e8 d1 0b 00 00       	call   80105f01 <acquire>
80105330:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105333:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105337:	74 0e                	je     80105347 <sleep+0x4a>
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	ff 75 0c             	pushl  0xc(%ebp)
8010533f:	e8 24 0c 00 00       	call   80105f68 <release>
80105344:	83 c4 10             	add    $0x10,%esp
  }

#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
80105347:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534d:	83 ec 08             	sub    $0x8,%esp
80105350:	50                   	push   %eax
80105351:	68 c4 5e 11 80       	push   $0x80115ec4
80105356:	e8 78 07 00 00       	call   80105ad3 <removeFromStateList>
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	85 c0                	test   %eax,%eax
80105360:	75 0d                	jne    8010536f <sleep+0x72>
      panic("Failed In Sleep To Remove From Running");
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	68 08 9b 10 80       	push   $0x80109b08
8010536a:	e8 f7 b1 ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
8010536f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	6a 04                	push   $0x4
8010537a:	50                   	push   %eax
8010537b:	e8 f7 07 00 00       	call   80105b77 <assertState>
80105380:	83 c4 10             	add    $0x10,%esp
  if(addToStateListHead(&ptable.pLists.sleep, proc) == 0)
80105383:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105389:	83 ec 08             	sub    $0x8,%esp
8010538c:	50                   	push   %eax
8010538d:	68 bc 5e 11 80       	push   $0x80115ebc
80105392:	e8 6a 08 00 00       	call   80105c01 <addToStateListHead>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	75 0d                	jne    801053ab <sleep+0xae>
      panic("Failed In Sleep To Add To Sleep");
8010539e:	83 ec 0c             	sub    $0xc,%esp
801053a1:	68 30 9b 10 80       	push   $0x80109b30
801053a6:	e8 bb b1 ff ff       	call   80100566 <panic>
#endif
  // Go to sleep.
  proc->chan = chan;
801053ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b1:	8b 55 08             	mov    0x8(%ebp),%edx
801053b4:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801053b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053bd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801053c4:	e8 5d fd ff ff       	call   80105126 <sched>

  // Tidy up.
  proc->chan = 0;
801053c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053cf:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801053d6:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801053dd:	74 24                	je     80105403 <sleep+0x106>
    release(&ptable.lock);
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	68 80 39 11 80       	push   $0x80113980
801053e7:	e8 7c 0b 00 00       	call   80105f68 <release>
801053ec:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801053ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053f3:	74 0e                	je     80105403 <sleep+0x106>
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	ff 75 0c             	pushl  0xc(%ebp)
801053fb:	e8 01 0b 00 00       	call   80105f01 <acquire>
80105400:	83 c4 10             	add    $0x10,%esp
  }
}
80105403:	90                   	nop
80105404:	c9                   	leave  
80105405:	c3                   	ret    

80105406 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105406:	55                   	push   %ebp
80105407:	89 e5                	mov    %esp,%ebp
80105409:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  struct proc * found;

  current = ptable.pLists.sleep;
8010540c:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(current)
80105414:	e9 8b 00 00 00       	jmp    801054a4 <wakeup1+0x9e>
  {
      if(current->chan == chan)
80105419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541c:	8b 40 20             	mov    0x20(%eax),%eax
8010541f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105422:	75 74                	jne    80105498 <wakeup1+0x92>
      {
          found = current;
80105424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105427:	89 45 f0             	mov    %eax,-0x10(%ebp)
          current = current->next;
8010542a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105433:	89 45 f4             	mov    %eax,-0xc(%ebp)
          if(removeFromStateList(&ptable.pLists.sleep, found) == 0)
80105436:	83 ec 08             	sub    $0x8,%esp
80105439:	ff 75 f0             	pushl  -0x10(%ebp)
8010543c:	68 bc 5e 11 80       	push   $0x80115ebc
80105441:	e8 8d 06 00 00       	call   80105ad3 <removeFromStateList>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	75 0d                	jne    8010545a <wakeup1+0x54>
              panic("Failed Wakeup Remove From Sleep");
8010544d:	83 ec 0c             	sub    $0xc,%esp
80105450:	68 50 9b 10 80       	push   $0x80109b50
80105455:	e8 0c b1 ff ff       	call   80100566 <panic>
          assertState(found, SLEEPING);
8010545a:	83 ec 08             	sub    $0x8,%esp
8010545d:	6a 02                	push   $0x2
8010545f:	ff 75 f0             	pushl  -0x10(%ebp)
80105462:	e8 10 07 00 00       	call   80105b77 <assertState>
80105467:	83 c4 10             	add    $0x10,%esp
          found->state = RUNNABLE;
8010546a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          if(addToStateListEnd(&ptable.pLists.ready, found) == 0)
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	ff 75 f0             	pushl  -0x10(%ebp)
8010547a:	68 b4 5e 11 80       	push   $0x80115eb4
8010547f:	e8 14 07 00 00       	call   80105b98 <addToStateListEnd>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	75 19                	jne    801054a4 <wakeup1+0x9e>
              panic("Failed Wakupe Add To Ready");
8010548b:	83 ec 0c             	sub    $0xc,%esp
8010548e:	68 70 9b 10 80       	push   $0x80109b70
80105493:	e8 ce b0 ff ff       	call   80100566 <panic>
      }
      else
          current = current->next;
80105498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801054a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc * current;
  struct proc * found;

  current = ptable.pLists.sleep;
  while(current)
801054a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054a8:	0f 85 6b ff ff ff    	jne    80105419 <wakeup1+0x13>
              panic("Failed Wakupe Add To Ready");
      }
      else
          current = current->next;
  }
}
801054ae:	90                   	nop
801054af:	c9                   	leave  
801054b0:	c3                   	ret    

801054b1 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801054b1:	55                   	push   %ebp
801054b2:	89 e5                	mov    %esp,%ebp
801054b4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	68 80 39 11 80       	push   $0x80113980
801054bf:	e8 3d 0a 00 00       	call   80105f01 <acquire>
801054c4:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	ff 75 08             	pushl  0x8(%ebp)
801054cd:	e8 34 ff ff ff       	call   80105406 <wakeup1>
801054d2:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801054d5:	83 ec 0c             	sub    $0xc,%esp
801054d8:	68 80 39 11 80       	push   $0x80113980
801054dd:	e8 86 0a 00 00       	call   80105f68 <release>
801054e2:	83 c4 10             	add    $0x10,%esp
}
801054e5:	90                   	nop
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <kill>:
  return -1;
}
#else
int
kill(int pid)
{
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  acquire(&ptable.lock);
801054ee:	83 ec 0c             	sub    $0xc,%esp
801054f1:	68 80 39 11 80       	push   $0x80113980
801054f6:	e8 06 0a 00 00       	call   80105f01 <acquire>
801054fb:	83 c4 10             	add    $0x10,%esp

  //check ready
  p = ptable.pLists.ready;
801054fe:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80105503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105506:	eb 3d                	jmp    80105545 <kill+0x5d>
  {
      if(p->pid == pid)
80105508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550b:	8b 50 10             	mov    0x10(%eax),%edx
8010550e:	8b 45 08             	mov    0x8(%ebp),%eax
80105511:	39 c2                	cmp    %eax,%edx
80105513:	75 24                	jne    80105539 <kill+0x51>
      {          
          p->killed = 1;
80105515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105518:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          release(&ptable.lock);
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 80 39 11 80       	push   $0x80113980
80105527:	e8 3c 0a 00 00       	call   80105f68 <release>
8010552c:	83 c4 10             	add    $0x10,%esp
          return 0;
8010552f:	b8 00 00 00 00       	mov    $0x0,%eax
80105534:	e9 78 01 00 00       	jmp    801056b1 <kill+0x1c9>
      }
      p = p->next;
80105539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc *p;
  acquire(&ptable.lock);

  //check ready
  p = ptable.pLists.ready;
  while(p)
80105545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105549:	75 bd                	jne    80105508 <kill+0x20>
          return 0;
      }
      p = p->next;
  }

  p = ptable.pLists.running;
8010554b:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80105550:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105553:	eb 3d                	jmp    80105592 <kill+0xaa>
  {
      if(p->pid == pid)
80105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105558:	8b 50 10             	mov    0x10(%eax),%edx
8010555b:	8b 45 08             	mov    0x8(%ebp),%eax
8010555e:	39 c2                	cmp    %eax,%edx
80105560:	75 24                	jne    80105586 <kill+0x9e>
      {          
          p->killed = 1;
80105562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105565:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          release(&ptable.lock);
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	68 80 39 11 80       	push   $0x80113980
80105574:	e8 ef 09 00 00       	call   80105f68 <release>
80105579:	83 c4 10             	add    $0x10,%esp
          return 0;
8010557c:	b8 00 00 00 00       	mov    $0x0,%eax
80105581:	e9 2b 01 00 00       	jmp    801056b1 <kill+0x1c9>
      }
      p = p->next;
80105586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105589:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010558f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      }
      p = p->next;
  }

  p = ptable.pLists.running;
  while(p)
80105592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105596:	75 bd                	jne    80105555 <kill+0x6d>
          return 0;
      }
      p = p->next;
  }
  
  p = ptable.pLists.embryo;
80105598:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
8010559d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
801055a0:	eb 3d                	jmp    801055df <kill+0xf7>
  {
      if(p->pid == pid)
801055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a5:	8b 50 10             	mov    0x10(%eax),%edx
801055a8:	8b 45 08             	mov    0x8(%ebp),%eax
801055ab:	39 c2                	cmp    %eax,%edx
801055ad:	75 24                	jne    801055d3 <kill+0xeb>
      {          
          p->killed = 1;
801055af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          release(&ptable.lock);
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 80 39 11 80       	push   $0x80113980
801055c1:	e8 a2 09 00 00       	call   80105f68 <release>
801055c6:	83 c4 10             	add    $0x10,%esp
          return 0;
801055c9:	b8 00 00 00 00       	mov    $0x0,%eax
801055ce:	e9 de 00 00 00       	jmp    801056b1 <kill+0x1c9>
      }
      p = p->next;
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      }
      p = p->next;
  }
  
  p = ptable.pLists.embryo;
  while(p)
801055df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055e3:	75 bd                	jne    801055a2 <kill+0xba>
      }
      p = p->next;
  }

  //check sleep
  p = ptable.pLists.sleep;
801055e5:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
801055ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
801055ed:	e9 a0 00 00 00       	jmp    80105692 <kill+0x1aa>
  {
      if(p->pid == pid)
801055f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f5:	8b 50 10             	mov    0x10(%eax),%edx
801055f8:	8b 45 08             	mov    0x8(%ebp),%eax
801055fb:	39 c2                	cmp    %eax,%edx
801055fd:	0f 85 83 00 00 00    	jne    80105686 <kill+0x19e>
      {
          p->killed = 1;
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          if(removeFromStateList(&ptable.pLists.sleep, p) == 0)
8010560d:	83 ec 08             	sub    $0x8,%esp
80105610:	ff 75 f4             	pushl  -0xc(%ebp)
80105613:	68 bc 5e 11 80       	push   $0x80115ebc
80105618:	e8 b6 04 00 00       	call   80105ad3 <removeFromStateList>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	85 c0                	test   %eax,%eax
80105622:	75 0d                	jne    80105631 <kill+0x149>
              panic("kill sleep");
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	68 8b 9b 10 80       	push   $0x80109b8b
8010562c:	e8 35 af ff ff       	call   80100566 <panic>
          assertState(p, SLEEPING);
80105631:	83 ec 08             	sub    $0x8,%esp
80105634:	6a 02                	push   $0x2
80105636:	ff 75 f4             	pushl  -0xc(%ebp)
80105639:	e8 39 05 00 00       	call   80105b77 <assertState>
8010563e:	83 c4 10             	add    $0x10,%esp
          p->state = RUNNABLE;
80105641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105644:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          if(addToStateListEnd(&ptable.pLists.ready, p) == 0)
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	ff 75 f4             	pushl  -0xc(%ebp)
80105651:	68 b4 5e 11 80       	push   $0x80115eb4
80105656:	e8 3d 05 00 00       	call   80105b98 <addToStateListEnd>
8010565b:	83 c4 10             	add    $0x10,%esp
8010565e:	85 c0                	test   %eax,%eax
80105660:	75 0d                	jne    8010566f <kill+0x187>
              panic("kill ready");
80105662:	83 ec 0c             	sub    $0xc,%esp
80105665:	68 96 9b 10 80       	push   $0x80109b96
8010566a:	e8 f7 ae ff ff       	call   80100566 <panic>
          release(&ptable.lock);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	68 80 39 11 80       	push   $0x80113980
80105677:	e8 ec 08 00 00       	call   80105f68 <release>
8010567c:	83 c4 10             	add    $0x10,%esp
          return 0;
8010567f:	b8 00 00 00 00       	mov    $0x0,%eax
80105684:	eb 2b                	jmp    801056b1 <kill+0x1c9>
      }
      p = p->next;
80105686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105689:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010568f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
  }

  //check sleep
  p = ptable.pLists.sleep;
  while(p)
80105692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105696:	0f 85 56 ff ff ff    	jne    801055f2 <kill+0x10a>
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }
  release(&ptable.lock);
8010569c:	83 ec 0c             	sub    $0xc,%esp
8010569f:	68 80 39 11 80       	push   $0x80113980
801056a4:	e8 bf 08 00 00       	call   80105f68 <release>
801056a9:	83 c4 10             	add    $0x10,%esp
  return -1;
801056ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b1:	c9                   	leave  
801056b2:	c3                   	ret    

801056b3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801056b3:	55                   	push   %ebp
801056b4:	89 e5                	mov    %esp,%ebp
801056b6:	83 ec 48             	sub    $0x48,%esp
  struct proc *p;
  char *state;
  uint pc[10];
 
#ifdef CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");   
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	68 cc 9b 10 80       	push   $0x80109bcc
801056c1:	e8 00 ad ff ff       	call   801003c6 <cprintf>
801056c6:	83 c4 10             	add    $0x10,%esp
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801056c9:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
801056d0:	e9 cd 00 00 00       	jmp    801057a2 <procdump+0xef>
    if(p->state == UNUSED)
801056d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d8:	8b 40 0c             	mov    0xc(%eax),%eax
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 84 b7 00 00 00    	je     8010579a <procdump+0xe7>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801056e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e6:	8b 40 0c             	mov    0xc(%eax),%eax
801056e9:	83 f8 05             	cmp    $0x5,%eax
801056ec:	77 23                	ja     80105711 <procdump+0x5e>
801056ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f1:	8b 40 0c             	mov    0xc(%eax),%eax
801056f4:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801056fb:	85 c0                	test   %eax,%eax
801056fd:	74 12                	je     80105711 <procdump+0x5e>
      state = states[p->state];
801056ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105702:	8b 40 0c             	mov    0xc(%eax),%eax
80105705:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010570c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010570f:	eb 07                	jmp    80105718 <procdump+0x65>
    else
      state = "???";
80105711:	c7 45 ec 00 9c 10 80 	movl   $0x80109c00,-0x14(%ebp)
#ifdef CS333_P2
    printproc(p, state);
80105718:	83 ec 08             	sub    $0x8,%esp
8010571b:	ff 75 ec             	pushl  -0x14(%ebp)
8010571e:	ff 75 f0             	pushl  -0x10(%ebp)
80105721:	e8 8c 00 00 00       	call   801057b2 <printproc>
80105726:	83 c4 10             	add    $0x10,%esp
#else
    cprintf("%d %s %s", p->pid, state, p->name);
#endif

    if(p->state == SLEEPING){
80105729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572c:	8b 40 0c             	mov    0xc(%eax),%eax
8010572f:	83 f8 02             	cmp    $0x2,%eax
80105732:	75 54                	jne    80105788 <procdump+0xd5>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105737:	8b 40 1c             	mov    0x1c(%eax),%eax
8010573a:	8b 40 0c             	mov    0xc(%eax),%eax
8010573d:	83 c0 08             	add    $0x8,%eax
80105740:	89 c2                	mov    %eax,%edx
80105742:	83 ec 08             	sub    $0x8,%esp
80105745:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105748:	50                   	push   %eax
80105749:	52                   	push   %edx
8010574a:	e8 6b 08 00 00       	call   80105fba <getcallerpcs>
8010574f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105752:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105759:	eb 1c                	jmp    80105777 <procdump+0xc4>
        cprintf(" %p", pc[i]);
8010575b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105762:	83 ec 08             	sub    $0x8,%esp
80105765:	50                   	push   %eax
80105766:	68 04 9c 10 80       	push   $0x80109c04
8010576b:	e8 56 ac ff ff       	call   801003c6 <cprintf>
80105770:	83 c4 10             	add    $0x10,%esp
    cprintf("%d %s %s", p->pid, state, p->name);
#endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105773:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105777:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010577b:	7f 0b                	jg     80105788 <procdump+0xd5>
8010577d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105780:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105784:	85 c0                	test   %eax,%eax
80105786:	75 d3                	jne    8010575b <procdump+0xa8>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	68 08 9c 10 80       	push   $0x80109c08
80105790:	e8 31 ac ff ff       	call   801003c6 <cprintf>
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	eb 01                	jmp    8010579b <procdump+0xe8>
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");   
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
8010579a:	90                   	nop
 
#ifdef CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");   
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010579b:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
801057a2:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
801057a9:	0f 82 26 ff ff ff    	jb     801056d5 <procdump+0x22>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801057af:	90                   	nop
801057b0:	c9                   	leave  
801057b1:	c3                   	ret    

801057b2 <printproc>:


#ifdef CS333_P2
static void
printproc(struct proc *p, char * state)
{
801057b2:	55                   	push   %ebp
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	53                   	push   %ebx
801057b6:	83 ec 14             	sub    $0x14,%esp
    uint ppid;
    if(p->pid == 1)
801057b9:	8b 45 08             	mov    0x8(%ebp),%eax
801057bc:	8b 40 10             	mov    0x10(%eax),%eax
801057bf:	83 f8 01             	cmp    $0x1,%eax
801057c2:	75 09                	jne    801057cd <printproc+0x1b>
        ppid = 1;
801057c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801057cb:	eb 0c                	jmp    801057d9 <printproc+0x27>
    else
        ppid = p->parent->pid;
801057cd:	8b 45 08             	mov    0x8(%ebp),%eax
801057d0:	8b 40 14             	mov    0x14(%eax),%eax
801057d3:	8b 40 10             	mov    0x10(%eax),%eax
801057d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d\t%s\t%d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid);
801057d9:	8b 45 08             	mov    0x8(%ebp),%eax
801057dc:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801057e2:	8b 45 08             	mov    0x8(%ebp),%eax
801057e5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801057eb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ee:	8d 58 6c             	lea    0x6c(%eax),%ebx
801057f1:	8b 45 08             	mov    0x8(%ebp),%eax
801057f4:	8b 40 10             	mov    0x10(%eax),%eax
801057f7:	83 ec 08             	sub    $0x8,%esp
801057fa:	ff 75 f4             	pushl  -0xc(%ebp)
801057fd:	51                   	push   %ecx
801057fe:	52                   	push   %edx
801057ff:	53                   	push   %ebx
80105800:	50                   	push   %eax
80105801:	68 0a 9c 10 80       	push   $0x80109c0a
80105806:	e8 bb ab ff ff       	call   801003c6 <cprintf>
8010580b:	83 c4 20             	add    $0x20,%esp
    tickasfloat(ticks - p->start_ticks);
8010580e:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80105814:	8b 45 08             	mov    0x8(%ebp),%eax
80105817:	8b 40 7c             	mov    0x7c(%eax),%eax
8010581a:	29 c2                	sub    %eax,%edx
8010581c:	89 d0                	mov    %edx,%eax
8010581e:	83 ec 0c             	sub    $0xc,%esp
80105821:	50                   	push   %eax
80105822:	e8 37 00 00 00       	call   8010585e <tickasfloat>
80105827:	83 c4 10             	add    $0x10,%esp
    tickasfloat(p->cpu_ticks_total);
8010582a:	8b 45 08             	mov    0x8(%ebp),%eax
8010582d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105833:	83 ec 0c             	sub    $0xc,%esp
80105836:	50                   	push   %eax
80105837:	e8 22 00 00 00       	call   8010585e <tickasfloat>
8010583c:	83 c4 10             	add    $0x10,%esp
    cprintf("%s\t%d\t", state, p->sz);
8010583f:	8b 45 08             	mov    0x8(%ebp),%eax
80105842:	8b 00                	mov    (%eax),%eax
80105844:	83 ec 04             	sub    $0x4,%esp
80105847:	50                   	push   %eax
80105848:	ff 75 0c             	pushl  0xc(%ebp)
8010584b:	68 1a 9c 10 80       	push   $0x80109c1a
80105850:	e8 71 ab ff ff       	call   801003c6 <cprintf>
80105855:	83 c4 10             	add    $0x10,%esp
}
80105858:	90                   	nop
80105859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010585c:	c9                   	leave  
8010585d:	c3                   	ret    

8010585e <tickasfloat>:

static void 
tickasfloat(uint tickcount)
{
8010585e:	55                   	push   %ebp
8010585f:	89 e5                	mov    %esp,%ebp
80105861:	83 ec 18             	sub    $0x18,%esp
    uint ticksl = tickcount / 1000;
80105864:	8b 45 08             	mov    0x8(%ebp),%eax
80105867:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
8010586c:	f7 e2                	mul    %edx
8010586e:	89 d0                	mov    %edx,%eax
80105870:	c1 e8 06             	shr    $0x6,%eax
80105873:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ticksr = tickcount % 1000;
80105876:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105879:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
8010587e:	89 c8                	mov    %ecx,%eax
80105880:	f7 e2                	mul    %edx
80105882:	89 d0                	mov    %edx,%eax
80105884:	c1 e8 06             	shr    $0x6,%eax
80105887:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
8010588d:	29 c1                	sub    %eax,%ecx
8010588f:	89 c8                	mov    %ecx,%eax
80105891:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cprintf("%d.", ticksl);
80105894:	83 ec 08             	sub    $0x8,%esp
80105897:	ff 75 f4             	pushl  -0xc(%ebp)
8010589a:	68 21 9c 10 80       	push   $0x80109c21
8010589f:	e8 22 ab ff ff       	call   801003c6 <cprintf>
801058a4:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
801058a7:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
801058ab:	77 16                	ja     801058c3 <tickasfloat+0x65>
       cprintf("%d%d%d\t", 0, 0, ticksr);
801058ad:	ff 75 f0             	pushl  -0x10(%ebp)
801058b0:	6a 00                	push   $0x0
801058b2:	6a 00                	push   $0x0
801058b4:	68 25 9c 10 80       	push   $0x80109c25
801058b9:	e8 08 ab ff ff       	call   801003c6 <cprintf>
801058be:	83 c4 10             	add    $0x10,%esp
    else if(ticksr < 100)
        cprintf("%d%d\t", 0, ticksr);
    else
        cprintf("%d\t", ticksr);

}
801058c1:	eb 30                	jmp    801058f3 <tickasfloat+0x95>
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    cprintf("%d.", ticksl);
    if(ticksr < 10) //pad zeroes
       cprintf("%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
801058c3:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
801058c7:	77 17                	ja     801058e0 <tickasfloat+0x82>
        cprintf("%d%d\t", 0, ticksr);
801058c9:	83 ec 04             	sub    $0x4,%esp
801058cc:	ff 75 f0             	pushl  -0x10(%ebp)
801058cf:	6a 00                	push   $0x0
801058d1:	68 2d 9c 10 80       	push   $0x80109c2d
801058d6:	e8 eb aa ff ff       	call   801003c6 <cprintf>
801058db:	83 c4 10             	add    $0x10,%esp
    else
        cprintf("%d\t", ticksr);

}
801058de:	eb 13                	jmp    801058f3 <tickasfloat+0x95>
    if(ticksr < 10) //pad zeroes
       cprintf("%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        cprintf("%d%d\t", 0, ticksr);
    else
        cprintf("%d\t", ticksr);
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	ff 75 f0             	pushl  -0x10(%ebp)
801058e6:	68 33 9c 10 80       	push   $0x80109c33
801058eb:	e8 d6 aa ff ff       	call   801003c6 <cprintf>
801058f0:	83 c4 10             	add    $0x10,%esp

}
801058f3:	90                   	nop
801058f4:	c9                   	leave  
801058f5:	c3                   	ret    

801058f6 <getprocdata>:
#endif

#ifdef CS333_P2

int getprocdata(uint max, struct uproc *utable)
{
801058f6:	55                   	push   %ebp
801058f7:	89 e5                	mov    %esp,%ebp
801058f9:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
801058fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc * p;
    
    acquire(&ptable.lock);
80105903:	83 ec 0c             	sub    $0xc,%esp
80105906:	68 80 39 11 80       	push   $0x80113980
8010590b:	e8 f1 05 00 00       	call   80105f01 <acquire>
80105910:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; i < max && p < &ptable.proc[NPROC]; p++)
80105913:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
8010591a:	e9 4a 01 00 00       	jmp    80105a69 <getprocdata+0x173>
    {
        if(p->state != UNUSED && p->state != EMBRYO)
8010591f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105922:	8b 40 0c             	mov    0xc(%eax),%eax
80105925:	85 c0                	test   %eax,%eax
80105927:	0f 84 35 01 00 00    	je     80105a62 <getprocdata+0x16c>
8010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105930:	8b 40 0c             	mov    0xc(%eax),%eax
80105933:	83 f8 01             	cmp    $0x1,%eax
80105936:	0f 84 26 01 00 00    	je     80105a62 <getprocdata+0x16c>
        {
            utable[i].pid             = p->pid;
8010593c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593f:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105942:	8b 45 0c             	mov    0xc(%ebp),%eax
80105945:	01 c2                	add    %eax,%edx
80105947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594a:	8b 40 10             	mov    0x10(%eax),%eax
8010594d:	89 02                	mov    %eax,(%edx)
            utable[i].uid             = p->uid;
8010594f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105952:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105955:	8b 45 0c             	mov    0xc(%ebp),%eax
80105958:	01 c2                	add    %eax,%edx
8010595a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105963:	89 42 04             	mov    %eax,0x4(%edx)
            utable[i].gid             = p->gid;
80105966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105969:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010596c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010596f:	01 c2                	add    %eax,%edx
80105971:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105974:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010597a:	89 42 08             	mov    %eax,0x8(%edx)
            if(p->pid == 1)
8010597d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105980:	8b 40 10             	mov    0x10(%eax),%eax
80105983:	83 f8 01             	cmp    $0x1,%eax
80105986:	75 14                	jne    8010599c <getprocdata+0xa6>
                utable[i].ppid        = 1;
80105988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598b:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010598e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105991:	01 d0                	add    %edx,%eax
80105993:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
8010599a:	eb 17                	jmp    801059b3 <getprocdata+0xbd>
            else
                utable[i].ppid        = p->parent->pid;
8010599c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599f:	6b d0 5c             	imul   $0x5c,%eax,%edx
801059a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a5:	01 c2                	add    %eax,%edx
801059a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059aa:	8b 40 14             	mov    0x14(%eax),%eax
801059ad:	8b 40 10             	mov    0x10(%eax),%eax
801059b0:	89 42 0c             	mov    %eax,0xc(%edx)
            utable[i].elapsed_ticks   = ticks - p->start_ticks;
801059b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b6:	6b d0 5c             	imul   $0x5c,%eax,%edx
801059b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801059bc:	01 c2                	add    %eax,%edx
801059be:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
801059c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c7:	8b 40 7c             	mov    0x7c(%eax),%eax
801059ca:	29 c1                	sub    %eax,%ecx
801059cc:	89 c8                	mov    %ecx,%eax
801059ce:	89 42 10             	mov    %eax,0x10(%edx)
            utable[i].CPU_total_ticks = p->cpu_ticks_total;
801059d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d4:	6b d0 5c             	imul   $0x5c,%eax,%edx
801059d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801059da:	01 c2                	add    %eax,%edx
801059dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059df:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801059e5:	89 42 14             	mov    %eax,0x14(%edx)
            utable[i].size            = p->sz;
801059e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059eb:	6b d0 5c             	imul   $0x5c,%eax,%edx
801059ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801059f1:	01 c2                	add    %eax,%edx
801059f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f6:	8b 00                	mov    (%eax),%eax
801059f8:	89 42 38             	mov    %eax,0x38(%edx)
            if(strncpy(utable[i].state, states[p->state], sizeof(states[p->state])+1) == 0)
801059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fe:	8b 40 0c             	mov    0xc(%eax),%eax
80105a01:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a0b:	6b ca 5c             	imul   $0x5c,%edx,%ecx
80105a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a11:	01 ca                	add    %ecx,%edx
80105a13:	83 c2 18             	add    $0x18,%edx
80105a16:	83 ec 04             	sub    $0x4,%esp
80105a19:	6a 05                	push   $0x5
80105a1b:	50                   	push   %eax
80105a1c:	52                   	push   %edx
80105a1d:	e8 ed 08 00 00       	call   8010630f <strncpy>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	75 07                	jne    80105a30 <getprocdata+0x13a>
                return -1;
80105a29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2e:	eb 61                	jmp    80105a91 <getprocdata+0x19b>
            if(strncpy(utable[i].name, p->name, sizeof(p->name)+1) == 0)
80105a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a33:	8d 50 6c             	lea    0x6c(%eax),%edx
80105a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a39:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a3f:	01 c8                	add    %ecx,%eax
80105a41:	83 c0 3c             	add    $0x3c,%eax
80105a44:	83 ec 04             	sub    $0x4,%esp
80105a47:	6a 11                	push   $0x11
80105a49:	52                   	push   %edx
80105a4a:	50                   	push   %eax
80105a4b:	e8 bf 08 00 00       	call   8010630f <strncpy>
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	85 c0                	test   %eax,%eax
80105a55:	75 07                	jne    80105a5e <getprocdata+0x168>
                return -1;
80105a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5c:	eb 33                	jmp    80105a91 <getprocdata+0x19b>
            ++i;
80105a5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
    int i = 0;
    struct proc * p;
    
    acquire(&ptable.lock);
    for(p = ptable.proc; i < max && p < &ptable.proc[NPROC]; p++)
80105a62:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
80105a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a6f:	73 0d                	jae    80105a7e <getprocdata+0x188>
80105a71:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
80105a78:	0f 82 a1 fe ff ff    	jb     8010591f <getprocdata+0x29>
                return -1;
            ++i;
        }
    }
    
    release(&ptable.lock);    
80105a7e:	83 ec 0c             	sub    $0xc,%esp
80105a81:	68 80 39 11 80       	push   $0x80113980
80105a86:	e8 dd 04 00 00       	call   80105f68 <release>
80105a8b:	83 c4 10             	add    $0x10,%esp

    return i;
80105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a91:	c9                   	leave  
80105a92:	c3                   	ret    

80105a93 <removeFromStateListHead>:
#endif

#ifdef CS333_P3P4
static struct proc *
removeFromStateListHead(struct proc ** sList)
{
80105a93:	55                   	push   %ebp
80105a94:	89 e5                	mov    %esp,%ebp
80105a96:	83 ec 10             	sub    $0x10,%esp
    struct proc * p;
    if(!(*sList))
80105a99:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9c:	8b 00                	mov    (%eax),%eax
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	75 07                	jne    80105aa9 <removeFromStateListHead+0x16>
        return 0;
80105aa2:	b8 00 00 00 00       	mov    $0x0,%eax
80105aa7:	eb 28                	jmp    80105ad1 <removeFromStateListHead+0x3e>

    p = *sList;
80105aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80105aac:	8b 00                	mov    (%eax),%eax
80105aae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    *sList = (*sList)->next;
80105ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ab4:	8b 00                	mov    (%eax),%eax
80105ab6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105abc:	8b 45 08             	mov    0x8(%ebp),%eax
80105abf:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80105ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ac4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105acb:	00 00 00 

    return p;
80105ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ad1:	c9                   	leave  
80105ad2:	c3                   	ret    

80105ad3 <removeFromStateList>:

static int 
removeFromStateList(struct proc ** sList, struct proc * p)
{
80105ad3:	55                   	push   %ebp
80105ad4:	89 e5                	mov    %esp,%ebp
80105ad6:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;
    struct proc * prev = 0;
80105ad9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(!(*sList))
80105ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae3:	8b 00                	mov    (%eax),%eax
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	75 0a                	jne    80105af3 <removeFromStateList+0x20>
        return 0;
80105ae9:	b8 00 00 00 00       	mov    $0x0,%eax
80105aee:	e9 82 00 00 00       	jmp    80105b75 <removeFromStateList+0xa2>

    current = *sList;
80105af3:	8b 45 08             	mov    0x8(%ebp),%eax
80105af6:	8b 00                	mov    (%eax),%eax
80105af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    //search list for p
    while(current->next && (p != current)) 
80105afb:	eb 12                	jmp    80105b0f <removeFromStateList+0x3c>
    {
        prev = current;
80105afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b00:	89 45 f8             	mov    %eax,-0x8(%ebp)
        current = current->next;
80105b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b06:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(!(*sList))
        return 0;

    current = *sList;
    //search list for p
    while(current->next && (p != current)) 
80105b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b12:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	74 08                	je     80105b24 <removeFromStateList+0x51>
80105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105b22:	75 d9                	jne    80105afd <removeFromStateList+0x2a>
    {
        prev = current;
        current = current->next;
    }

    if(p->pid == current->pid)
80105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b27:	8b 50 10             	mov    0x10(%eax),%edx
80105b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b2d:	8b 40 10             	mov    0x10(%eax),%eax
80105b30:	39 c2                	cmp    %eax,%edx
80105b32:	75 3c                	jne    80105b70 <removeFromStateList+0x9d>
    {
        if(prev) //middle of list
80105b34:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80105b38:	74 14                	je     80105b4e <removeFromStateList+0x7b>
            prev->next = current->next;
80105b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105b43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b46:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
80105b4c:	eb 0e                	jmp    80105b5c <removeFromStateList+0x89>
        else //head of list
            *sList = current->next;
80105b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b51:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105b57:	8b 45 08             	mov    0x8(%ebp),%eax
80105b5a:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80105b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b5f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105b66:	00 00 00 
        return -1;
80105b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6e:	eb 05                	jmp    80105b75 <removeFromStateList+0xa2>
    }

    //p not in list
    return 0;
80105b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    

80105b77 <assertState>:

static void 
assertState(struct proc * p, enum procstate state)
{
80105b77:	55                   	push   %ebp
80105b78:	89 e5                	mov    %esp,%ebp
80105b7a:	83 ec 08             	sub    $0x8,%esp
    if(p->state != state)
80105b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80105b80:	8b 40 0c             	mov    0xc(%eax),%eax
80105b83:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105b86:	74 0d                	je     80105b95 <assertState+0x1e>
        panic("Process has invalid state for transition!");
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	68 38 9c 10 80       	push   $0x80109c38
80105b90:	e8 d1 a9 ff ff       	call   80100566 <panic>
}
80105b95:	90                   	nop
80105b96:	c9                   	leave  
80105b97:	c3                   	ret    

80105b98 <addToStateListEnd>:

static int 
addToStateListEnd(struct proc ** sList, struct proc * p)
{
80105b98:	55                   	push   %ebp
80105b99:	89 e5                	mov    %esp,%ebp
80105b9b:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(!p)
80105b9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ba2:	75 07                	jne    80105bab <addToStateListEnd+0x13>
        return 0;
80105ba4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ba9:	eb 54                	jmp    80105bff <addToStateListEnd+0x67>

    p->next = 0;
80105bab:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bae:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105bb5:	00 00 00 
    if(!(*sList))
80105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80105bbb:	8b 00                	mov    (%eax),%eax
80105bbd:	85 c0                	test   %eax,%eax
80105bbf:	75 0a                	jne    80105bcb <addToStateListEnd+0x33>
        *sList = p;
80105bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80105bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bc7:	89 10                	mov    %edx,(%eax)
80105bc9:	eb 2f                	jmp    80105bfa <addToStateListEnd+0x62>
    else
    {
        current = *sList;
80105bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80105bce:	8b 00                	mov    (%eax),%eax
80105bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current->next)
80105bd3:	eb 0c                	jmp    80105be1 <addToStateListEnd+0x49>
            current = current->next;
80105bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bde:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(!(*sList))
        *sList = p;
    else
    {
        current = *sList;
        while(current->next)
80105be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105be4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bea:	85 c0                	test   %eax,%eax
80105bec:	75 e7                	jne    80105bd5 <addToStateListEnd+0x3d>
            current = current->next;

        current->next = p;
80105bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bf4:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    }
    
    return -1;
80105bfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bff:	c9                   	leave  
80105c00:	c3                   	ret    

80105c01 <addToStateListHead>:

static int 
addToStateListHead(struct proc ** sList, struct proc * p)
{
80105c01:	55                   	push   %ebp
80105c02:	89 e5                	mov    %esp,%ebp
    if(p)
80105c04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c08:	74 1d                	je     80105c27 <addToStateListHead+0x26>
    {
        p->next = *sList;
80105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c0d:	8b 10                	mov    (%eax),%edx
80105c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c12:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        *sList = p;
80105c18:	8b 45 08             	mov    0x8(%ebp),%eax
80105c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c1e:	89 10                	mov    %edx,(%eax)
        return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c25:	eb 05                	jmp    80105c2c <addToStateListHead+0x2b>
    }
    else
        return 0;
80105c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c2c:	5d                   	pop    %ebp
80105c2d:	c3                   	ret    

80105c2e <exitSearch>:

static void
exitSearch(struct proc * sList)
{
80105c2e:	55                   	push   %ebp
80105c2f:	89 e5                	mov    %esp,%ebp
80105c31:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(sList)
80105c34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105c38:	74 36                	je     80105c70 <exitSearch+0x42>
    {
        current = sList;
80105c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current)
80105c40:	eb 28                	jmp    80105c6a <exitSearch+0x3c>
        {
            if(current->parent == proc)
80105c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c45:	8b 50 14             	mov    0x14(%eax),%edx
80105c48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c4e:	39 c2                	cmp    %eax,%edx
80105c50:	75 0c                	jne    80105c5e <exitSearch+0x30>
                current->parent = initproc;
80105c52:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80105c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c5b:	89 50 14             	mov    %edx,0x14(%eax)
            current = current->next;
80105c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c61:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c67:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
80105c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105c6e:	75 d2                	jne    80105c42 <exitSearch+0x14>
            if(current->parent == proc)
                current->parent = initproc;
            current = current->next;
        }
    }
}
80105c70:	90                   	nop
80105c71:	c9                   	leave  
80105c72:	c3                   	ret    

80105c73 <waitSearch>:

static int 
waitSearch(struct proc * sList)
{
80105c73:	55                   	push   %ebp
80105c74:	89 e5                	mov    %esp,%ebp
80105c76:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(sList)
80105c79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105c7d:	74 31                	je     80105cb0 <waitSearch+0x3d>
    {
        current = sList;
80105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c82:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current)
80105c85:	eb 23                	jmp    80105caa <waitSearch+0x37>
        {
            if(current->parent == proc)
80105c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c8a:	8b 50 14             	mov    0x14(%eax),%edx
80105c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c93:	39 c2                	cmp    %eax,%edx
80105c95:	75 07                	jne    80105c9e <waitSearch+0x2b>
                return 1;
80105c97:	b8 01 00 00 00       	mov    $0x1,%eax
80105c9c:	eb 17                	jmp    80105cb5 <waitSearch+0x42>
            current = current->next;
80105c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
80105caa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105cae:	75 d7                	jne    80105c87 <waitSearch+0x14>
                return 1;
            current = current->next;
        }
    }

    return 0;
80105cb0:	b8 00 00 00 00       	mov    $0x0,%eax
    
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    

80105cb7 <ctrlprint>:

static void 
ctrlprint(struct proc * sList)
{
80105cb7:	55                   	push   %ebp
80105cb8:	89 e5                	mov    %esp,%ebp
80105cba:	83 ec 18             	sub    $0x18,%esp
    struct proc * current;
    if(sList)
80105cbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105cc1:	74 59                	je     80105d1c <ctrlprint+0x65>
    {
        current = sList;
80105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(current)
80105cc9:	eb 49                	jmp    80105d14 <ctrlprint+0x5d>
        {
            if(current->next)
80105ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cce:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	74 19                	je     80105cf1 <ctrlprint+0x3a>
                cprintf("%d -> ", current->pid);
80105cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cdb:	8b 40 10             	mov    0x10(%eax),%eax
80105cde:	83 ec 08             	sub    $0x8,%esp
80105ce1:	50                   	push   %eax
80105ce2:	68 62 9c 10 80       	push   $0x80109c62
80105ce7:	e8 da a6 ff ff       	call   801003c6 <cprintf>
80105cec:	83 c4 10             	add    $0x10,%esp
80105cef:	eb 17                	jmp    80105d08 <ctrlprint+0x51>
            else
                cprintf("%d\n", current->pid);
80105cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf4:	8b 40 10             	mov    0x10(%eax),%eax
80105cf7:	83 ec 08             	sub    $0x8,%esp
80105cfa:	50                   	push   %eax
80105cfb:	68 69 9c 10 80       	push   $0x80109c69
80105d00:	e8 c1 a6 ff ff       	call   801003c6 <cprintf>
80105d05:	83 c4 10             	add    $0x10,%esp
            current = current->next;
80105d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d0b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
    struct proc * current;
    if(sList)
    {
        current = sList;
        while(current)
80105d14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d18:	75 b1                	jne    80105ccb <ctrlprint+0x14>
            else
                cprintf("%d\n", current->pid);
            current = current->next;
        }

        return;
80105d1a:	eb 10                	jmp    80105d2c <ctrlprint+0x75>

    }

    cprintf("Empty List\n");
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	68 6d 9c 10 80       	push   $0x80109c6d
80105d24:	e8 9d a6 ff ff       	call   801003c6 <cprintf>
80105d29:	83 c4 10             	add    $0x10,%esp
}
80105d2c:	c9                   	leave  
80105d2d:	c3                   	ret    

80105d2e <printsleep>:

void
printsleep(void)
{
80105d2e:	55                   	push   %ebp
80105d2f:	89 e5                	mov    %esp,%ebp
80105d31:	83 ec 08             	sub    $0x8,%esp
    cprintf("Sleep List Processes:\n");
80105d34:	83 ec 0c             	sub    $0xc,%esp
80105d37:	68 79 9c 10 80       	push   $0x80109c79
80105d3c:	e8 85 a6 ff ff       	call   801003c6 <cprintf>
80105d41:	83 c4 10             	add    $0x10,%esp
    ctrlprint(ptable.pLists.sleep);
80105d44:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	50                   	push   %eax
80105d4d:	e8 65 ff ff ff       	call   80105cb7 <ctrlprint>
80105d52:	83 c4 10             	add    $0x10,%esp
}
80105d55:	90                   	nop
80105d56:	c9                   	leave  
80105d57:	c3                   	ret    

80105d58 <printfree>:

void
printfree(void)
{
80105d58:	55                   	push   %ebp
80105d59:	89 e5                	mov    %esp,%ebp
80105d5b:	83 ec 18             	sub    $0x18,%esp
    int count = 0;
80105d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc * current = ptable.pLists.free;
80105d65:	a1 b8 5e 11 80       	mov    0x80115eb8,%eax
80105d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cprintf("Free List Size: ");
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	68 90 9c 10 80       	push   $0x80109c90
80105d75:	e8 4c a6 ff ff       	call   801003c6 <cprintf>
80105d7a:	83 c4 10             	add    $0x10,%esp

    while(current)
80105d7d:	eb 10                	jmp    80105d8f <printfree+0x37>
    {
        ++count;
80105d7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        current = current->next;
80105d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d86:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
    int count = 0;
    struct proc * current = ptable.pLists.free;
    cprintf("Free List Size: ");

    while(current)
80105d8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d93:	75 ea                	jne    80105d7f <printfree+0x27>
    {
        ++count;
        current = current->next;
    }

    cprintf("%d processes\n", count);
80105d95:	83 ec 08             	sub    $0x8,%esp
80105d98:	ff 75 f4             	pushl  -0xc(%ebp)
80105d9b:	68 a1 9c 10 80       	push   $0x80109ca1
80105da0:	e8 21 a6 ff ff       	call   801003c6 <cprintf>
80105da5:	83 c4 10             	add    $0x10,%esp
}
80105da8:	90                   	nop
80105da9:	c9                   	leave  
80105daa:	c3                   	ret    

80105dab <printzombie>:

void
printzombie(void)
{
80105dab:	55                   	push   %ebp
80105dac:	89 e5                	mov    %esp,%ebp
80105dae:	83 ec 18             	sub    $0x18,%esp
    struct proc * current = ptable.pLists.zombie;
80105db1:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80105db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ppid;

    cprintf("Zombie List:\n");
80105db9:	83 ec 0c             	sub    $0xc,%esp
80105dbc:	68 af 9c 10 80       	push   $0x80109caf
80105dc1:	e8 00 a6 ff ff       	call   801003c6 <cprintf>
80105dc6:	83 c4 10             	add    $0x10,%esp
    if(!current)
80105dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dcd:	0f 85 9d 00 00 00    	jne    80105e70 <printzombie+0xc5>
        cprintf("Empty List\n");
80105dd3:	83 ec 0c             	sub    $0xc,%esp
80105dd6:	68 6d 9c 10 80       	push   $0x80109c6d
80105ddb:	e8 e6 a5 ff ff       	call   801003c6 <cprintf>
80105de0:	83 c4 10             	add    $0x10,%esp

    while(current)
80105de3:	e9 88 00 00 00       	jmp    80105e70 <printzombie+0xc5>
    {
        if(current->pid == 1)
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	8b 40 10             	mov    0x10(%eax),%eax
80105dee:	83 f8 01             	cmp    $0x1,%eax
80105df1:	75 09                	jne    80105dfc <printzombie+0x51>
            ppid = 1;
80105df3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80105dfa:	eb 1f                	jmp    80105e1b <printzombie+0x70>
        else if(current->parent)
80105dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dff:	8b 40 14             	mov    0x14(%eax),%eax
80105e02:	85 c0                	test   %eax,%eax
80105e04:	74 0e                	je     80105e14 <printzombie+0x69>
            ppid = current->parent->pid;
80105e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e09:	8b 40 14             	mov    0x14(%eax),%eax
80105e0c:	8b 40 10             	mov    0x10(%eax),%eax
80105e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e12:	eb 07                	jmp    80105e1b <printzombie+0x70>
        else
            ppid = 0;
80105e14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

        cprintf("(%d, %d)", current->pid, ppid);
80105e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1e:	8b 40 10             	mov    0x10(%eax),%eax
80105e21:	83 ec 04             	sub    $0x4,%esp
80105e24:	ff 75 f0             	pushl  -0x10(%ebp)
80105e27:	50                   	push   %eax
80105e28:	68 bd 9c 10 80       	push   $0x80109cbd
80105e2d:	e8 94 a5 ff ff       	call   801003c6 <cprintf>
80105e32:	83 c4 10             	add    $0x10,%esp

        if(current->next)
80105e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e38:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	74 12                	je     80105e54 <printzombie+0xa9>
            cprintf(" -> ");
80105e42:	83 ec 0c             	sub    $0xc,%esp
80105e45:	68 c6 9c 10 80       	push   $0x80109cc6
80105e4a:	e8 77 a5 ff ff       	call   801003c6 <cprintf>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	eb 10                	jmp    80105e64 <printzombie+0xb9>
        else
            cprintf("\n");
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	68 08 9c 10 80       	push   $0x80109c08
80105e5c:	e8 65 a5 ff ff       	call   801003c6 <cprintf>
80105e61:	83 c4 10             	add    $0x10,%esp

        current = current->next;
80105e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e67:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    cprintf("Zombie List:\n");
    if(!current)
        cprintf("Empty List\n");

    while(current)
80105e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e74:	0f 85 6e ff ff ff    	jne    80105de8 <printzombie+0x3d>
        else
            cprintf("\n");

        current = current->next;
    }
}
80105e7a:	90                   	nop
80105e7b:	c9                   	leave  
80105e7c:	c3                   	ret    

80105e7d <printready>:

void
printready(void)
{
80105e7d:	55                   	push   %ebp
80105e7e:	89 e5                	mov    %esp,%ebp
80105e80:	83 ec 08             	sub    $0x8,%esp
    cprintf("Ready List Processes:\n");
80105e83:	83 ec 0c             	sub    $0xc,%esp
80105e86:	68 cb 9c 10 80       	push   $0x80109ccb
80105e8b:	e8 36 a5 ff ff       	call   801003c6 <cprintf>
80105e90:	83 c4 10             	add    $0x10,%esp
    ctrlprint(ptable.pLists.ready);
80105e93:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80105e98:	83 ec 0c             	sub    $0xc,%esp
80105e9b:	50                   	push   %eax
80105e9c:	e8 16 fe ff ff       	call   80105cb7 <ctrlprint>
80105ea1:	83 c4 10             	add    $0x10,%esp
}
80105ea4:	90                   	nop
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    

80105ea7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105ea7:	55                   	push   %ebp
80105ea8:	89 e5                	mov    %esp,%ebp
80105eaa:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105ead:	9c                   	pushf  
80105eae:	58                   	pop    %eax
80105eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    

80105eb7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105eb7:	55                   	push   %ebp
80105eb8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105eba:	fa                   	cli    
}
80105ebb:	90                   	nop
80105ebc:	5d                   	pop    %ebp
80105ebd:	c3                   	ret    

80105ebe <sti>:

static inline void
sti(void)
{
80105ebe:	55                   	push   %ebp
80105ebf:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105ec1:	fb                   	sti    
}
80105ec2:	90                   	nop
80105ec3:	5d                   	pop    %ebp
80105ec4:	c3                   	ret    

80105ec5 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105ec5:	55                   	push   %ebp
80105ec6:	89 e5                	mov    %esp,%ebp
80105ec8:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105ecb:	8b 55 08             	mov    0x8(%ebp),%edx
80105ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ed1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105ed4:	f0 87 02             	lock xchg %eax,(%edx)
80105ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105edd:	c9                   	leave  
80105ede:	c3                   	ret    

80105edf <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105edf:	55                   	push   %ebp
80105ee0:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ee8:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80105eee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105efe:	90                   	nop
80105eff:	5d                   	pop    %ebp
80105f00:	c3                   	ret    

80105f01 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105f01:	55                   	push   %ebp
80105f02:	89 e5                	mov    %esp,%ebp
80105f04:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105f07:	e8 52 01 00 00       	call   8010605e <pushcli>
  if(holding(lk))
80105f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	50                   	push   %eax
80105f13:	e8 1c 01 00 00       	call   80106034 <holding>
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	85 c0                	test   %eax,%eax
80105f1d:	74 0d                	je     80105f2c <acquire+0x2b>
    panic("acquire");
80105f1f:	83 ec 0c             	sub    $0xc,%esp
80105f22:	68 e2 9c 10 80       	push   $0x80109ce2
80105f27:	e8 3a a6 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105f2c:	90                   	nop
80105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80105f30:	83 ec 08             	sub    $0x8,%esp
80105f33:	6a 01                	push   $0x1
80105f35:	50                   	push   %eax
80105f36:	e8 8a ff ff ff       	call   80105ec5 <xchg>
80105f3b:	83 c4 10             	add    $0x10,%esp
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	75 eb                	jne    80105f2d <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105f42:	8b 45 08             	mov    0x8(%ebp),%eax
80105f45:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105f4c:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f52:	83 c0 0c             	add    $0xc,%eax
80105f55:	83 ec 08             	sub    $0x8,%esp
80105f58:	50                   	push   %eax
80105f59:	8d 45 08             	lea    0x8(%ebp),%eax
80105f5c:	50                   	push   %eax
80105f5d:	e8 58 00 00 00       	call   80105fba <getcallerpcs>
80105f62:	83 c4 10             	add    $0x10,%esp
}
80105f65:	90                   	nop
80105f66:	c9                   	leave  
80105f67:	c3                   	ret    

80105f68 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105f68:	55                   	push   %ebp
80105f69:	89 e5                	mov    %esp,%ebp
80105f6b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105f6e:	83 ec 0c             	sub    $0xc,%esp
80105f71:	ff 75 08             	pushl  0x8(%ebp)
80105f74:	e8 bb 00 00 00       	call   80106034 <holding>
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	85 c0                	test   %eax,%eax
80105f7e:	75 0d                	jne    80105f8d <release+0x25>
    panic("release");
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 ea 9c 10 80       	push   $0x80109cea
80105f88:	e8 d9 a5 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80105f90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105f97:	8b 45 08             	mov    0x8(%ebp),%eax
80105f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa4:	83 ec 08             	sub    $0x8,%esp
80105fa7:	6a 00                	push   $0x0
80105fa9:	50                   	push   %eax
80105faa:	e8 16 ff ff ff       	call   80105ec5 <xchg>
80105faf:	83 c4 10             	add    $0x10,%esp

  popcli();
80105fb2:	e8 ec 00 00 00       	call   801060a3 <popcli>
}
80105fb7:	90                   	nop
80105fb8:	c9                   	leave  
80105fb9:	c3                   	ret    

80105fba <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105fba:	55                   	push   %ebp
80105fbb:	89 e5                	mov    %esp,%ebp
80105fbd:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fc3:	83 e8 08             	sub    $0x8,%eax
80105fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105fd0:	eb 38                	jmp    8010600a <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fd6:	74 53                	je     8010602b <getcallerpcs+0x71>
80105fd8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105fdf:	76 4a                	jbe    8010602b <getcallerpcs+0x71>
80105fe1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105fe5:	74 44                	je     8010602b <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105fea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ff4:	01 c2                	add    %eax,%edx
80105ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ff9:	8b 40 04             	mov    0x4(%eax),%eax
80105ffc:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106001:	8b 00                	mov    (%eax),%eax
80106003:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106006:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010600a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010600e:	7e c2                	jle    80105fd2 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106010:	eb 19                	jmp    8010602b <getcallerpcs+0x71>
    pcs[i] = 0;
80106012:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106015:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010601c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010601f:	01 d0                	add    %edx,%eax
80106021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106027:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010602b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010602f:	7e e1                	jle    80106012 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106031:	90                   	nop
80106032:	c9                   	leave  
80106033:	c3                   	ret    

80106034 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106037:	8b 45 08             	mov    0x8(%ebp),%eax
8010603a:	8b 00                	mov    (%eax),%eax
8010603c:	85 c0                	test   %eax,%eax
8010603e:	74 17                	je     80106057 <holding+0x23>
80106040:	8b 45 08             	mov    0x8(%ebp),%eax
80106043:	8b 50 08             	mov    0x8(%eax),%edx
80106046:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010604c:	39 c2                	cmp    %eax,%edx
8010604e:	75 07                	jne    80106057 <holding+0x23>
80106050:	b8 01 00 00 00       	mov    $0x1,%eax
80106055:	eb 05                	jmp    8010605c <holding+0x28>
80106057:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010605c:	5d                   	pop    %ebp
8010605d:	c3                   	ret    

8010605e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010605e:	55                   	push   %ebp
8010605f:	89 e5                	mov    %esp,%ebp
80106061:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106064:	e8 3e fe ff ff       	call   80105ea7 <readeflags>
80106069:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010606c:	e8 46 fe ff ff       	call   80105eb7 <cli>
  if(cpu->ncli++ == 0)
80106071:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106078:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010607e:	8d 48 01             	lea    0x1(%eax),%ecx
80106081:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106087:	85 c0                	test   %eax,%eax
80106089:	75 15                	jne    801060a0 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010608b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106091:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106094:	81 e2 00 02 00 00    	and    $0x200,%edx
8010609a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801060a0:	90                   	nop
801060a1:	c9                   	leave  
801060a2:	c3                   	ret    

801060a3 <popcli>:

void
popcli(void)
{
801060a3:	55                   	push   %ebp
801060a4:	89 e5                	mov    %esp,%ebp
801060a6:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801060a9:	e8 f9 fd ff ff       	call   80105ea7 <readeflags>
801060ae:	25 00 02 00 00       	and    $0x200,%eax
801060b3:	85 c0                	test   %eax,%eax
801060b5:	74 0d                	je     801060c4 <popcli+0x21>
    panic("popcli - interruptible");
801060b7:	83 ec 0c             	sub    $0xc,%esp
801060ba:	68 f2 9c 10 80       	push   $0x80109cf2
801060bf:	e8 a2 a4 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801060c4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801060ca:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801060d0:	83 ea 01             	sub    $0x1,%edx
801060d3:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801060d9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801060df:	85 c0                	test   %eax,%eax
801060e1:	79 0d                	jns    801060f0 <popcli+0x4d>
    panic("popcli");
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	68 09 9d 10 80       	push   $0x80109d09
801060eb:	e8 76 a4 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801060f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801060f6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801060fc:	85 c0                	test   %eax,%eax
801060fe:	75 15                	jne    80106115 <popcli+0x72>
80106100:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106106:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010610c:	85 c0                	test   %eax,%eax
8010610e:	74 05                	je     80106115 <popcli+0x72>
    sti();
80106110:	e8 a9 fd ff ff       	call   80105ebe <sti>
}
80106115:	90                   	nop
80106116:	c9                   	leave  
80106117:	c3                   	ret    

80106118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106118:	55                   	push   %ebp
80106119:	89 e5                	mov    %esp,%ebp
8010611b:	57                   	push   %edi
8010611c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010611d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106120:	8b 55 10             	mov    0x10(%ebp),%edx
80106123:	8b 45 0c             	mov    0xc(%ebp),%eax
80106126:	89 cb                	mov    %ecx,%ebx
80106128:	89 df                	mov    %ebx,%edi
8010612a:	89 d1                	mov    %edx,%ecx
8010612c:	fc                   	cld    
8010612d:	f3 aa                	rep stos %al,%es:(%edi)
8010612f:	89 ca                	mov    %ecx,%edx
80106131:	89 fb                	mov    %edi,%ebx
80106133:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106139:	90                   	nop
8010613a:	5b                   	pop    %ebx
8010613b:	5f                   	pop    %edi
8010613c:	5d                   	pop    %ebp
8010613d:	c3                   	ret    

8010613e <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010613e:	55                   	push   %ebp
8010613f:	89 e5                	mov    %esp,%ebp
80106141:	57                   	push   %edi
80106142:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106143:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106146:	8b 55 10             	mov    0x10(%ebp),%edx
80106149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010614c:	89 cb                	mov    %ecx,%ebx
8010614e:	89 df                	mov    %ebx,%edi
80106150:	89 d1                	mov    %edx,%ecx
80106152:	fc                   	cld    
80106153:	f3 ab                	rep stos %eax,%es:(%edi)
80106155:	89 ca                	mov    %ecx,%edx
80106157:	89 fb                	mov    %edi,%ebx
80106159:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010615c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010615f:	90                   	nop
80106160:	5b                   	pop    %ebx
80106161:	5f                   	pop    %edi
80106162:	5d                   	pop    %ebp
80106163:	c3                   	ret    

80106164 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106167:	8b 45 08             	mov    0x8(%ebp),%eax
8010616a:	83 e0 03             	and    $0x3,%eax
8010616d:	85 c0                	test   %eax,%eax
8010616f:	75 43                	jne    801061b4 <memset+0x50>
80106171:	8b 45 10             	mov    0x10(%ebp),%eax
80106174:	83 e0 03             	and    $0x3,%eax
80106177:	85 c0                	test   %eax,%eax
80106179:	75 39                	jne    801061b4 <memset+0x50>
    c &= 0xFF;
8010617b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106182:	8b 45 10             	mov    0x10(%ebp),%eax
80106185:	c1 e8 02             	shr    $0x2,%eax
80106188:	89 c1                	mov    %eax,%ecx
8010618a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010618d:	c1 e0 18             	shl    $0x18,%eax
80106190:	89 c2                	mov    %eax,%edx
80106192:	8b 45 0c             	mov    0xc(%ebp),%eax
80106195:	c1 e0 10             	shl    $0x10,%eax
80106198:	09 c2                	or     %eax,%edx
8010619a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010619d:	c1 e0 08             	shl    $0x8,%eax
801061a0:	09 d0                	or     %edx,%eax
801061a2:	0b 45 0c             	or     0xc(%ebp),%eax
801061a5:	51                   	push   %ecx
801061a6:	50                   	push   %eax
801061a7:	ff 75 08             	pushl  0x8(%ebp)
801061aa:	e8 8f ff ff ff       	call   8010613e <stosl>
801061af:	83 c4 0c             	add    $0xc,%esp
801061b2:	eb 12                	jmp    801061c6 <memset+0x62>
  } else
    stosb(dst, c, n);
801061b4:	8b 45 10             	mov    0x10(%ebp),%eax
801061b7:	50                   	push   %eax
801061b8:	ff 75 0c             	pushl  0xc(%ebp)
801061bb:	ff 75 08             	pushl  0x8(%ebp)
801061be:	e8 55 ff ff ff       	call   80106118 <stosb>
801061c3:	83 c4 0c             	add    $0xc,%esp
  return dst;
801061c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801061c9:	c9                   	leave  
801061ca:	c3                   	ret    

801061cb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801061cb:	55                   	push   %ebp
801061cc:	89 e5                	mov    %esp,%ebp
801061ce:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801061d1:	8b 45 08             	mov    0x8(%ebp),%eax
801061d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801061d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801061da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801061dd:	eb 30                	jmp    8010620f <memcmp+0x44>
    if(*s1 != *s2)
801061df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061e2:	0f b6 10             	movzbl (%eax),%edx
801061e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061e8:	0f b6 00             	movzbl (%eax),%eax
801061eb:	38 c2                	cmp    %al,%dl
801061ed:	74 18                	je     80106207 <memcmp+0x3c>
      return *s1 - *s2;
801061ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061f2:	0f b6 00             	movzbl (%eax),%eax
801061f5:	0f b6 d0             	movzbl %al,%edx
801061f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061fb:	0f b6 00             	movzbl (%eax),%eax
801061fe:	0f b6 c0             	movzbl %al,%eax
80106201:	29 c2                	sub    %eax,%edx
80106203:	89 d0                	mov    %edx,%eax
80106205:	eb 1a                	jmp    80106221 <memcmp+0x56>
    s1++, s2++;
80106207:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010620b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010620f:	8b 45 10             	mov    0x10(%ebp),%eax
80106212:	8d 50 ff             	lea    -0x1(%eax),%edx
80106215:	89 55 10             	mov    %edx,0x10(%ebp)
80106218:	85 c0                	test   %eax,%eax
8010621a:	75 c3                	jne    801061df <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010621c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106221:	c9                   	leave  
80106222:	c3                   	ret    

80106223 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106223:	55                   	push   %ebp
80106224:	89 e5                	mov    %esp,%ebp
80106226:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106229:	8b 45 0c             	mov    0xc(%ebp),%eax
8010622c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010622f:	8b 45 08             	mov    0x8(%ebp),%eax
80106232:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106235:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106238:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010623b:	73 54                	jae    80106291 <memmove+0x6e>
8010623d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106240:	8b 45 10             	mov    0x10(%ebp),%eax
80106243:	01 d0                	add    %edx,%eax
80106245:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106248:	76 47                	jbe    80106291 <memmove+0x6e>
    s += n;
8010624a:	8b 45 10             	mov    0x10(%ebp),%eax
8010624d:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106250:	8b 45 10             	mov    0x10(%ebp),%eax
80106253:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106256:	eb 13                	jmp    8010626b <memmove+0x48>
      *--d = *--s;
80106258:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010625c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106260:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106263:	0f b6 10             	movzbl (%eax),%edx
80106266:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106269:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010626b:	8b 45 10             	mov    0x10(%ebp),%eax
8010626e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106271:	89 55 10             	mov    %edx,0x10(%ebp)
80106274:	85 c0                	test   %eax,%eax
80106276:	75 e0                	jne    80106258 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106278:	eb 24                	jmp    8010629e <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010627a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010627d:	8d 50 01             	lea    0x1(%eax),%edx
80106280:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106283:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106286:	8d 4a 01             	lea    0x1(%edx),%ecx
80106289:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010628c:	0f b6 12             	movzbl (%edx),%edx
8010628f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106291:	8b 45 10             	mov    0x10(%ebp),%eax
80106294:	8d 50 ff             	lea    -0x1(%eax),%edx
80106297:	89 55 10             	mov    %edx,0x10(%ebp)
8010629a:	85 c0                	test   %eax,%eax
8010629c:	75 dc                	jne    8010627a <memmove+0x57>
      *d++ = *s++;

  return dst;
8010629e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801062a1:	c9                   	leave  
801062a2:	c3                   	ret    

801062a3 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801062a3:	55                   	push   %ebp
801062a4:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801062a6:	ff 75 10             	pushl  0x10(%ebp)
801062a9:	ff 75 0c             	pushl  0xc(%ebp)
801062ac:	ff 75 08             	pushl  0x8(%ebp)
801062af:	e8 6f ff ff ff       	call   80106223 <memmove>
801062b4:	83 c4 0c             	add    $0xc,%esp
}
801062b7:	c9                   	leave  
801062b8:	c3                   	ret    

801062b9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801062b9:	55                   	push   %ebp
801062ba:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801062bc:	eb 0c                	jmp    801062ca <strncmp+0x11>
    n--, p++, q++;
801062be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801062c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801062c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801062ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062ce:	74 1a                	je     801062ea <strncmp+0x31>
801062d0:	8b 45 08             	mov    0x8(%ebp),%eax
801062d3:	0f b6 00             	movzbl (%eax),%eax
801062d6:	84 c0                	test   %al,%al
801062d8:	74 10                	je     801062ea <strncmp+0x31>
801062da:	8b 45 08             	mov    0x8(%ebp),%eax
801062dd:	0f b6 10             	movzbl (%eax),%edx
801062e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801062e3:	0f b6 00             	movzbl (%eax),%eax
801062e6:	38 c2                	cmp    %al,%dl
801062e8:	74 d4                	je     801062be <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801062ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062ee:	75 07                	jne    801062f7 <strncmp+0x3e>
    return 0;
801062f0:	b8 00 00 00 00       	mov    $0x0,%eax
801062f5:	eb 16                	jmp    8010630d <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801062f7:	8b 45 08             	mov    0x8(%ebp),%eax
801062fa:	0f b6 00             	movzbl (%eax),%eax
801062fd:	0f b6 d0             	movzbl %al,%edx
80106300:	8b 45 0c             	mov    0xc(%ebp),%eax
80106303:	0f b6 00             	movzbl (%eax),%eax
80106306:	0f b6 c0             	movzbl %al,%eax
80106309:	29 c2                	sub    %eax,%edx
8010630b:	89 d0                	mov    %edx,%eax
}
8010630d:	5d                   	pop    %ebp
8010630e:	c3                   	ret    

8010630f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010630f:	55                   	push   %ebp
80106310:	89 e5                	mov    %esp,%ebp
80106312:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106315:	8b 45 08             	mov    0x8(%ebp),%eax
80106318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010631b:	90                   	nop
8010631c:	8b 45 10             	mov    0x10(%ebp),%eax
8010631f:	8d 50 ff             	lea    -0x1(%eax),%edx
80106322:	89 55 10             	mov    %edx,0x10(%ebp)
80106325:	85 c0                	test   %eax,%eax
80106327:	7e 2c                	jle    80106355 <strncpy+0x46>
80106329:	8b 45 08             	mov    0x8(%ebp),%eax
8010632c:	8d 50 01             	lea    0x1(%eax),%edx
8010632f:	89 55 08             	mov    %edx,0x8(%ebp)
80106332:	8b 55 0c             	mov    0xc(%ebp),%edx
80106335:	8d 4a 01             	lea    0x1(%edx),%ecx
80106338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010633b:	0f b6 12             	movzbl (%edx),%edx
8010633e:	88 10                	mov    %dl,(%eax)
80106340:	0f b6 00             	movzbl (%eax),%eax
80106343:	84 c0                	test   %al,%al
80106345:	75 d5                	jne    8010631c <strncpy+0xd>
    ;
  while(n-- > 0)
80106347:	eb 0c                	jmp    80106355 <strncpy+0x46>
    *s++ = 0;
80106349:	8b 45 08             	mov    0x8(%ebp),%eax
8010634c:	8d 50 01             	lea    0x1(%eax),%edx
8010634f:	89 55 08             	mov    %edx,0x8(%ebp)
80106352:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106355:	8b 45 10             	mov    0x10(%ebp),%eax
80106358:	8d 50 ff             	lea    -0x1(%eax),%edx
8010635b:	89 55 10             	mov    %edx,0x10(%ebp)
8010635e:	85 c0                	test   %eax,%eax
80106360:	7f e7                	jg     80106349 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106365:	c9                   	leave  
80106366:	c3                   	ret    

80106367 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106367:	55                   	push   %ebp
80106368:	89 e5                	mov    %esp,%ebp
8010636a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010636d:	8b 45 08             	mov    0x8(%ebp),%eax
80106370:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106373:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106377:	7f 05                	jg     8010637e <safestrcpy+0x17>
    return os;
80106379:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010637c:	eb 31                	jmp    801063af <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010637e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106382:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106386:	7e 1e                	jle    801063a6 <safestrcpy+0x3f>
80106388:	8b 45 08             	mov    0x8(%ebp),%eax
8010638b:	8d 50 01             	lea    0x1(%eax),%edx
8010638e:	89 55 08             	mov    %edx,0x8(%ebp)
80106391:	8b 55 0c             	mov    0xc(%ebp),%edx
80106394:	8d 4a 01             	lea    0x1(%edx),%ecx
80106397:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010639a:	0f b6 12             	movzbl (%edx),%edx
8010639d:	88 10                	mov    %dl,(%eax)
8010639f:	0f b6 00             	movzbl (%eax),%eax
801063a2:	84 c0                	test   %al,%al
801063a4:	75 d8                	jne    8010637e <safestrcpy+0x17>
    ;
  *s = 0;
801063a6:	8b 45 08             	mov    0x8(%ebp),%eax
801063a9:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801063ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063af:	c9                   	leave  
801063b0:	c3                   	ret    

801063b1 <strlen>:

int
strlen(const char *s)
{
801063b1:	55                   	push   %ebp
801063b2:	89 e5                	mov    %esp,%ebp
801063b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801063b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801063be:	eb 04                	jmp    801063c4 <strlen+0x13>
801063c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801063c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063c7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ca:	01 d0                	add    %edx,%eax
801063cc:	0f b6 00             	movzbl (%eax),%eax
801063cf:	84 c0                	test   %al,%al
801063d1:	75 ed                	jne    801063c0 <strlen+0xf>
    ;
  return n;
801063d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063d6:	c9                   	leave  
801063d7:	c3                   	ret    

801063d8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801063d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801063dc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801063e0:	55                   	push   %ebp
  pushl %ebx
801063e1:	53                   	push   %ebx
  pushl %esi
801063e2:	56                   	push   %esi
  pushl %edi
801063e3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801063e4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801063e6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801063e8:	5f                   	pop    %edi
  popl %esi
801063e9:	5e                   	pop    %esi
  popl %ebx
801063ea:	5b                   	pop    %ebx
  popl %ebp
801063eb:	5d                   	pop    %ebp
  ret
801063ec:	c3                   	ret    

801063ed <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801063ed:	55                   	push   %ebp
801063ee:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801063f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063f6:	8b 00                	mov    (%eax),%eax
801063f8:	3b 45 08             	cmp    0x8(%ebp),%eax
801063fb:	76 12                	jbe    8010640f <fetchint+0x22>
801063fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106400:	8d 50 04             	lea    0x4(%eax),%edx
80106403:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106409:	8b 00                	mov    (%eax),%eax
8010640b:	39 c2                	cmp    %eax,%edx
8010640d:	76 07                	jbe    80106416 <fetchint+0x29>
    return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106414:	eb 0f                	jmp    80106425 <fetchint+0x38>
  *ip = *(int*)(addr);
80106416:	8b 45 08             	mov    0x8(%ebp),%eax
80106419:	8b 10                	mov    (%eax),%edx
8010641b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010641e:	89 10                	mov    %edx,(%eax)
  return 0;
80106420:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106425:	5d                   	pop    %ebp
80106426:	c3                   	ret    

80106427 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106427:	55                   	push   %ebp
80106428:	89 e5                	mov    %esp,%ebp
8010642a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010642d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106433:	8b 00                	mov    (%eax),%eax
80106435:	3b 45 08             	cmp    0x8(%ebp),%eax
80106438:	77 07                	ja     80106441 <fetchstr+0x1a>
    return -1;
8010643a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010643f:	eb 46                	jmp    80106487 <fetchstr+0x60>
  *pp = (char*)addr;
80106441:	8b 55 08             	mov    0x8(%ebp),%edx
80106444:	8b 45 0c             	mov    0xc(%ebp),%eax
80106447:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010644f:	8b 00                	mov    (%eax),%eax
80106451:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106454:	8b 45 0c             	mov    0xc(%ebp),%eax
80106457:	8b 00                	mov    (%eax),%eax
80106459:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010645c:	eb 1c                	jmp    8010647a <fetchstr+0x53>
    if(*s == 0)
8010645e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106461:	0f b6 00             	movzbl (%eax),%eax
80106464:	84 c0                	test   %al,%al
80106466:	75 0e                	jne    80106476 <fetchstr+0x4f>
      return s - *pp;
80106468:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010646b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010646e:	8b 00                	mov    (%eax),%eax
80106470:	29 c2                	sub    %eax,%edx
80106472:	89 d0                	mov    %edx,%eax
80106474:	eb 11                	jmp    80106487 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106476:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010647a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010647d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106480:	72 dc                	jb     8010645e <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106487:	c9                   	leave  
80106488:	c3                   	ret    

80106489 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106489:	55                   	push   %ebp
8010648a:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010648c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106492:	8b 40 18             	mov    0x18(%eax),%eax
80106495:	8b 40 44             	mov    0x44(%eax),%eax
80106498:	8b 55 08             	mov    0x8(%ebp),%edx
8010649b:	c1 e2 02             	shl    $0x2,%edx
8010649e:	01 d0                	add    %edx,%eax
801064a0:	83 c0 04             	add    $0x4,%eax
801064a3:	ff 75 0c             	pushl  0xc(%ebp)
801064a6:	50                   	push   %eax
801064a7:	e8 41 ff ff ff       	call   801063ed <fetchint>
801064ac:	83 c4 08             	add    $0x8,%esp
}
801064af:	c9                   	leave  
801064b0:	c3                   	ret    

801064b1 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801064b1:	55                   	push   %ebp
801064b2:	89 e5                	mov    %esp,%ebp
801064b4:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801064b7:	8d 45 fc             	lea    -0x4(%ebp),%eax
801064ba:	50                   	push   %eax
801064bb:	ff 75 08             	pushl  0x8(%ebp)
801064be:	e8 c6 ff ff ff       	call   80106489 <argint>
801064c3:	83 c4 08             	add    $0x8,%esp
801064c6:	85 c0                	test   %eax,%eax
801064c8:	79 07                	jns    801064d1 <argptr+0x20>
    return -1;
801064ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cf:	eb 3b                	jmp    8010650c <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801064d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064d7:	8b 00                	mov    (%eax),%eax
801064d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064dc:	39 d0                	cmp    %edx,%eax
801064de:	76 16                	jbe    801064f6 <argptr+0x45>
801064e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064e3:	89 c2                	mov    %eax,%edx
801064e5:	8b 45 10             	mov    0x10(%ebp),%eax
801064e8:	01 c2                	add    %eax,%edx
801064ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064f0:	8b 00                	mov    (%eax),%eax
801064f2:	39 c2                	cmp    %eax,%edx
801064f4:	76 07                	jbe    801064fd <argptr+0x4c>
    return -1;
801064f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fb:	eb 0f                	jmp    8010650c <argptr+0x5b>
  *pp = (char*)i;
801064fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106500:	89 c2                	mov    %eax,%edx
80106502:	8b 45 0c             	mov    0xc(%ebp),%eax
80106505:	89 10                	mov    %edx,(%eax)
  return 0;
80106507:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010650c:	c9                   	leave  
8010650d:	c3                   	ret    

8010650e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010650e:	55                   	push   %ebp
8010650f:	89 e5                	mov    %esp,%ebp
80106511:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106514:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106517:	50                   	push   %eax
80106518:	ff 75 08             	pushl  0x8(%ebp)
8010651b:	e8 69 ff ff ff       	call   80106489 <argint>
80106520:	83 c4 08             	add    $0x8,%esp
80106523:	85 c0                	test   %eax,%eax
80106525:	79 07                	jns    8010652e <argstr+0x20>
    return -1;
80106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652c:	eb 0f                	jmp    8010653d <argstr+0x2f>
  return fetchstr(addr, pp);
8010652e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106531:	ff 75 0c             	pushl  0xc(%ebp)
80106534:	50                   	push   %eax
80106535:	e8 ed fe ff ff       	call   80106427 <fetchstr>
8010653a:	83 c4 08             	add    $0x8,%esp
}
8010653d:	c9                   	leave  
8010653e:	c3                   	ret    

8010653f <syscall>:
};
#endif    

void
syscall(void)
{
8010653f:	55                   	push   %ebp
80106540:	89 e5                	mov    %esp,%ebp
80106542:	53                   	push   %ebx
80106543:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010654c:	8b 40 18             	mov    0x18(%eax),%eax
8010654f:	8b 40 1c             	mov    0x1c(%eax),%eax
80106552:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106559:	7e 30                	jle    8010658b <syscall+0x4c>
8010655b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010655e:	83 f8 1d             	cmp    $0x1d,%eax
80106561:	77 28                	ja     8010658b <syscall+0x4c>
80106563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106566:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010656d:	85 c0                	test   %eax,%eax
8010656f:	74 1a                	je     8010658b <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106571:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106577:	8b 58 18             	mov    0x18(%eax),%ebx
8010657a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80106584:	ff d0                	call   *%eax
80106586:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106589:	eb 34                	jmp    801065bf <syscall+0x80>
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010658b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106591:	8d 50 6c             	lea    0x6c(%eax),%edx
80106594:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#ifdef PRINT_SYSCALLS    
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010659a:	8b 40 10             	mov    0x10(%eax),%eax
8010659d:	ff 75 f4             	pushl  -0xc(%ebp)
801065a0:	52                   	push   %edx
801065a1:	50                   	push   %eax
801065a2:	68 10 9d 10 80       	push   $0x80109d10
801065a7:	e8 1a 9e ff ff       	call   801003c6 <cprintf>
801065ac:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801065af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b5:	8b 40 18             	mov    0x18(%eax),%eax
801065b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801065bf:	90                   	nop
801065c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065c3:	c9                   	leave  
801065c4:	c3                   	ret    

801065c5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801065c5:	55                   	push   %ebp
801065c6:	89 e5                	mov    %esp,%ebp
801065c8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801065cb:	83 ec 08             	sub    $0x8,%esp
801065ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065d1:	50                   	push   %eax
801065d2:	ff 75 08             	pushl  0x8(%ebp)
801065d5:	e8 af fe ff ff       	call   80106489 <argint>
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	85 c0                	test   %eax,%eax
801065df:	79 07                	jns    801065e8 <argfd+0x23>
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e6:	eb 50                	jmp    80106638 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801065e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065eb:	85 c0                	test   %eax,%eax
801065ed:	78 21                	js     80106610 <argfd+0x4b>
801065ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065f2:	83 f8 0f             	cmp    $0xf,%eax
801065f5:	7f 19                	jg     80106610 <argfd+0x4b>
801065f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106600:	83 c2 08             	add    $0x8,%edx
80106603:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106607:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010660a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010660e:	75 07                	jne    80106617 <argfd+0x52>
    return -1;
80106610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106615:	eb 21                	jmp    80106638 <argfd+0x73>
  if(pfd)
80106617:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010661b:	74 08                	je     80106625 <argfd+0x60>
    *pfd = fd;
8010661d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106620:	8b 45 0c             	mov    0xc(%ebp),%eax
80106623:	89 10                	mov    %edx,(%eax)
  if(pf)
80106625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106629:	74 08                	je     80106633 <argfd+0x6e>
    *pf = f;
8010662b:	8b 45 10             	mov    0x10(%ebp),%eax
8010662e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106631:	89 10                	mov    %edx,(%eax)
  return 0;
80106633:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106638:	c9                   	leave  
80106639:	c3                   	ret    

8010663a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010663a:	55                   	push   %ebp
8010663b:	89 e5                	mov    %esp,%ebp
8010663d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106647:	eb 30                	jmp    80106679 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106649:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010664f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106652:	83 c2 08             	add    $0x8,%edx
80106655:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106659:	85 c0                	test   %eax,%eax
8010665b:	75 18                	jne    80106675 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010665d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106663:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106666:	8d 4a 08             	lea    0x8(%edx),%ecx
80106669:	8b 55 08             	mov    0x8(%ebp),%edx
8010666c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106670:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106673:	eb 0f                	jmp    80106684 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106675:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106679:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010667d:	7e ca                	jle    80106649 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010667f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106684:	c9                   	leave  
80106685:	c3                   	ret    

80106686 <sys_dup>:

int
sys_dup(void)
{
80106686:	55                   	push   %ebp
80106687:	89 e5                	mov    %esp,%ebp
80106689:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010668c:	83 ec 04             	sub    $0x4,%esp
8010668f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106692:	50                   	push   %eax
80106693:	6a 00                	push   $0x0
80106695:	6a 00                	push   $0x0
80106697:	e8 29 ff ff ff       	call   801065c5 <argfd>
8010669c:	83 c4 10             	add    $0x10,%esp
8010669f:	85 c0                	test   %eax,%eax
801066a1:	79 07                	jns    801066aa <sys_dup+0x24>
    return -1;
801066a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a8:	eb 31                	jmp    801066db <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801066aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ad:	83 ec 0c             	sub    $0xc,%esp
801066b0:	50                   	push   %eax
801066b1:	e8 84 ff ff ff       	call   8010663a <fdalloc>
801066b6:	83 c4 10             	add    $0x10,%esp
801066b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066c0:	79 07                	jns    801066c9 <sys_dup+0x43>
    return -1;
801066c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c7:	eb 12                	jmp    801066db <sys_dup+0x55>
  filedup(f);
801066c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066cc:	83 ec 0c             	sub    $0xc,%esp
801066cf:	50                   	push   %eax
801066d0:	e8 c9 a9 ff ff       	call   8010109e <filedup>
801066d5:	83 c4 10             	add    $0x10,%esp
  return fd;
801066d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066db:	c9                   	leave  
801066dc:	c3                   	ret    

801066dd <sys_read>:

int
sys_read(void)
{
801066dd:	55                   	push   %ebp
801066de:	89 e5                	mov    %esp,%ebp
801066e0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801066e3:	83 ec 04             	sub    $0x4,%esp
801066e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066e9:	50                   	push   %eax
801066ea:	6a 00                	push   $0x0
801066ec:	6a 00                	push   $0x0
801066ee:	e8 d2 fe ff ff       	call   801065c5 <argfd>
801066f3:	83 c4 10             	add    $0x10,%esp
801066f6:	85 c0                	test   %eax,%eax
801066f8:	78 2e                	js     80106728 <sys_read+0x4b>
801066fa:	83 ec 08             	sub    $0x8,%esp
801066fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106700:	50                   	push   %eax
80106701:	6a 02                	push   $0x2
80106703:	e8 81 fd ff ff       	call   80106489 <argint>
80106708:	83 c4 10             	add    $0x10,%esp
8010670b:	85 c0                	test   %eax,%eax
8010670d:	78 19                	js     80106728 <sys_read+0x4b>
8010670f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106712:	83 ec 04             	sub    $0x4,%esp
80106715:	50                   	push   %eax
80106716:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106719:	50                   	push   %eax
8010671a:	6a 01                	push   $0x1
8010671c:	e8 90 fd ff ff       	call   801064b1 <argptr>
80106721:	83 c4 10             	add    $0x10,%esp
80106724:	85 c0                	test   %eax,%eax
80106726:	79 07                	jns    8010672f <sys_read+0x52>
    return -1;
80106728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672d:	eb 17                	jmp    80106746 <sys_read+0x69>
  return fileread(f, p, n);
8010672f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106732:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106738:	83 ec 04             	sub    $0x4,%esp
8010673b:	51                   	push   %ecx
8010673c:	52                   	push   %edx
8010673d:	50                   	push   %eax
8010673e:	e8 eb aa ff ff       	call   8010122e <fileread>
80106743:	83 c4 10             	add    $0x10,%esp
}
80106746:	c9                   	leave  
80106747:	c3                   	ret    

80106748 <sys_write>:

int
sys_write(void)
{
80106748:	55                   	push   %ebp
80106749:	89 e5                	mov    %esp,%ebp
8010674b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010674e:	83 ec 04             	sub    $0x4,%esp
80106751:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106754:	50                   	push   %eax
80106755:	6a 00                	push   $0x0
80106757:	6a 00                	push   $0x0
80106759:	e8 67 fe ff ff       	call   801065c5 <argfd>
8010675e:	83 c4 10             	add    $0x10,%esp
80106761:	85 c0                	test   %eax,%eax
80106763:	78 2e                	js     80106793 <sys_write+0x4b>
80106765:	83 ec 08             	sub    $0x8,%esp
80106768:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010676b:	50                   	push   %eax
8010676c:	6a 02                	push   $0x2
8010676e:	e8 16 fd ff ff       	call   80106489 <argint>
80106773:	83 c4 10             	add    $0x10,%esp
80106776:	85 c0                	test   %eax,%eax
80106778:	78 19                	js     80106793 <sys_write+0x4b>
8010677a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010677d:	83 ec 04             	sub    $0x4,%esp
80106780:	50                   	push   %eax
80106781:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106784:	50                   	push   %eax
80106785:	6a 01                	push   $0x1
80106787:	e8 25 fd ff ff       	call   801064b1 <argptr>
8010678c:	83 c4 10             	add    $0x10,%esp
8010678f:	85 c0                	test   %eax,%eax
80106791:	79 07                	jns    8010679a <sys_write+0x52>
    return -1;
80106793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106798:	eb 17                	jmp    801067b1 <sys_write+0x69>
  return filewrite(f, p, n);
8010679a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010679d:	8b 55 ec             	mov    -0x14(%ebp),%edx
801067a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a3:	83 ec 04             	sub    $0x4,%esp
801067a6:	51                   	push   %ecx
801067a7:	52                   	push   %edx
801067a8:	50                   	push   %eax
801067a9:	e8 38 ab ff ff       	call   801012e6 <filewrite>
801067ae:	83 c4 10             	add    $0x10,%esp
}
801067b1:	c9                   	leave  
801067b2:	c3                   	ret    

801067b3 <sys_close>:

int
sys_close(void)
{
801067b3:	55                   	push   %ebp
801067b4:	89 e5                	mov    %esp,%ebp
801067b6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801067b9:	83 ec 04             	sub    $0x4,%esp
801067bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067bf:	50                   	push   %eax
801067c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067c3:	50                   	push   %eax
801067c4:	6a 00                	push   $0x0
801067c6:	e8 fa fd ff ff       	call   801065c5 <argfd>
801067cb:	83 c4 10             	add    $0x10,%esp
801067ce:	85 c0                	test   %eax,%eax
801067d0:	79 07                	jns    801067d9 <sys_close+0x26>
    return -1;
801067d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d7:	eb 28                	jmp    80106801 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801067d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067e2:	83 c2 08             	add    $0x8,%edx
801067e5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067ec:	00 
  fileclose(f);
801067ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	50                   	push   %eax
801067f4:	e8 f6 a8 ff ff       	call   801010ef <fileclose>
801067f9:	83 c4 10             	add    $0x10,%esp
  return 0;
801067fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106801:	c9                   	leave  
80106802:	c3                   	ret    

80106803 <sys_fstat>:

int
sys_fstat(void)
{
80106803:	55                   	push   %ebp
80106804:	89 e5                	mov    %esp,%ebp
80106806:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106809:	83 ec 04             	sub    $0x4,%esp
8010680c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010680f:	50                   	push   %eax
80106810:	6a 00                	push   $0x0
80106812:	6a 00                	push   $0x0
80106814:	e8 ac fd ff ff       	call   801065c5 <argfd>
80106819:	83 c4 10             	add    $0x10,%esp
8010681c:	85 c0                	test   %eax,%eax
8010681e:	78 17                	js     80106837 <sys_fstat+0x34>
80106820:	83 ec 04             	sub    $0x4,%esp
80106823:	6a 14                	push   $0x14
80106825:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106828:	50                   	push   %eax
80106829:	6a 01                	push   $0x1
8010682b:	e8 81 fc ff ff       	call   801064b1 <argptr>
80106830:	83 c4 10             	add    $0x10,%esp
80106833:	85 c0                	test   %eax,%eax
80106835:	79 07                	jns    8010683e <sys_fstat+0x3b>
    return -1;
80106837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683c:	eb 13                	jmp    80106851 <sys_fstat+0x4e>
  return filestat(f, st);
8010683e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106844:	83 ec 08             	sub    $0x8,%esp
80106847:	52                   	push   %edx
80106848:	50                   	push   %eax
80106849:	e8 89 a9 ff ff       	call   801011d7 <filestat>
8010684e:	83 c4 10             	add    $0x10,%esp
}
80106851:	c9                   	leave  
80106852:	c3                   	ret    

80106853 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106853:	55                   	push   %ebp
80106854:	89 e5                	mov    %esp,%ebp
80106856:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106859:	83 ec 08             	sub    $0x8,%esp
8010685c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010685f:	50                   	push   %eax
80106860:	6a 00                	push   $0x0
80106862:	e8 a7 fc ff ff       	call   8010650e <argstr>
80106867:	83 c4 10             	add    $0x10,%esp
8010686a:	85 c0                	test   %eax,%eax
8010686c:	78 15                	js     80106883 <sys_link+0x30>
8010686e:	83 ec 08             	sub    $0x8,%esp
80106871:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106874:	50                   	push   %eax
80106875:	6a 01                	push   $0x1
80106877:	e8 92 fc ff ff       	call   8010650e <argstr>
8010687c:	83 c4 10             	add    $0x10,%esp
8010687f:	85 c0                	test   %eax,%eax
80106881:	79 0a                	jns    8010688d <sys_link+0x3a>
    return -1;
80106883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106888:	e9 68 01 00 00       	jmp    801069f5 <sys_link+0x1a2>

  begin_op();
8010688d:	e8 59 cd ff ff       	call   801035eb <begin_op>
  if((ip = namei(old)) == 0){
80106892:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106895:	83 ec 0c             	sub    $0xc,%esp
80106898:	50                   	push   %eax
80106899:	e8 28 bd ff ff       	call   801025c6 <namei>
8010689e:	83 c4 10             	add    $0x10,%esp
801068a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068a8:	75 0f                	jne    801068b9 <sys_link+0x66>
    end_op();
801068aa:	e8 c8 cd ff ff       	call   80103677 <end_op>
    return -1;
801068af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b4:	e9 3c 01 00 00       	jmp    801069f5 <sys_link+0x1a2>
  }

  ilock(ip);
801068b9:	83 ec 0c             	sub    $0xc,%esp
801068bc:	ff 75 f4             	pushl  -0xc(%ebp)
801068bf:	e8 44 b1 ff ff       	call   80101a08 <ilock>
801068c4:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801068c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801068ce:	66 83 f8 01          	cmp    $0x1,%ax
801068d2:	75 1d                	jne    801068f1 <sys_link+0x9e>
    iunlockput(ip);
801068d4:	83 ec 0c             	sub    $0xc,%esp
801068d7:	ff 75 f4             	pushl  -0xc(%ebp)
801068da:	e8 e9 b3 ff ff       	call   80101cc8 <iunlockput>
801068df:	83 c4 10             	add    $0x10,%esp
    end_op();
801068e2:	e8 90 cd ff ff       	call   80103677 <end_op>
    return -1;
801068e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ec:	e9 04 01 00 00       	jmp    801069f5 <sys_link+0x1a2>
  }

  ip->nlink++;
801068f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801068f8:	83 c0 01             	add    $0x1,%eax
801068fb:	89 c2                	mov    %eax,%edx
801068fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106900:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106904:	83 ec 0c             	sub    $0xc,%esp
80106907:	ff 75 f4             	pushl  -0xc(%ebp)
8010690a:	e8 1f af ff ff       	call   8010182e <iupdate>
8010690f:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106912:	83 ec 0c             	sub    $0xc,%esp
80106915:	ff 75 f4             	pushl  -0xc(%ebp)
80106918:	e8 49 b2 ff ff       	call   80101b66 <iunlock>
8010691d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106920:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106923:	83 ec 08             	sub    $0x8,%esp
80106926:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106929:	52                   	push   %edx
8010692a:	50                   	push   %eax
8010692b:	e8 b2 bc ff ff       	call   801025e2 <nameiparent>
80106930:	83 c4 10             	add    $0x10,%esp
80106933:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010693a:	74 71                	je     801069ad <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010693c:	83 ec 0c             	sub    $0xc,%esp
8010693f:	ff 75 f0             	pushl  -0x10(%ebp)
80106942:	e8 c1 b0 ff ff       	call   80101a08 <ilock>
80106947:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010694a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694d:	8b 10                	mov    (%eax),%edx
8010694f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106952:	8b 00                	mov    (%eax),%eax
80106954:	39 c2                	cmp    %eax,%edx
80106956:	75 1d                	jne    80106975 <sys_link+0x122>
80106958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695b:	8b 40 04             	mov    0x4(%eax),%eax
8010695e:	83 ec 04             	sub    $0x4,%esp
80106961:	50                   	push   %eax
80106962:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106965:	50                   	push   %eax
80106966:	ff 75 f0             	pushl  -0x10(%ebp)
80106969:	e8 bc b9 ff ff       	call   8010232a <dirlink>
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	85 c0                	test   %eax,%eax
80106973:	79 10                	jns    80106985 <sys_link+0x132>
    iunlockput(dp);
80106975:	83 ec 0c             	sub    $0xc,%esp
80106978:	ff 75 f0             	pushl  -0x10(%ebp)
8010697b:	e8 48 b3 ff ff       	call   80101cc8 <iunlockput>
80106980:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106983:	eb 29                	jmp    801069ae <sys_link+0x15b>
  }
  iunlockput(dp);
80106985:	83 ec 0c             	sub    $0xc,%esp
80106988:	ff 75 f0             	pushl  -0x10(%ebp)
8010698b:	e8 38 b3 ff ff       	call   80101cc8 <iunlockput>
80106990:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106993:	83 ec 0c             	sub    $0xc,%esp
80106996:	ff 75 f4             	pushl  -0xc(%ebp)
80106999:	e8 3a b2 ff ff       	call   80101bd8 <iput>
8010699e:	83 c4 10             	add    $0x10,%esp

  end_op();
801069a1:	e8 d1 cc ff ff       	call   80103677 <end_op>

  return 0;
801069a6:	b8 00 00 00 00       	mov    $0x0,%eax
801069ab:	eb 48                	jmp    801069f5 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801069ad:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801069ae:	83 ec 0c             	sub    $0xc,%esp
801069b1:	ff 75 f4             	pushl  -0xc(%ebp)
801069b4:	e8 4f b0 ff ff       	call   80101a08 <ilock>
801069b9:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801069bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069bf:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801069c3:	83 e8 01             	sub    $0x1,%eax
801069c6:	89 c2                	mov    %eax,%edx
801069c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cb:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801069cf:	83 ec 0c             	sub    $0xc,%esp
801069d2:	ff 75 f4             	pushl  -0xc(%ebp)
801069d5:	e8 54 ae ff ff       	call   8010182e <iupdate>
801069da:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801069dd:	83 ec 0c             	sub    $0xc,%esp
801069e0:	ff 75 f4             	pushl  -0xc(%ebp)
801069e3:	e8 e0 b2 ff ff       	call   80101cc8 <iunlockput>
801069e8:	83 c4 10             	add    $0x10,%esp
  end_op();
801069eb:	e8 87 cc ff ff       	call   80103677 <end_op>
  return -1;
801069f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069f5:	c9                   	leave  
801069f6:	c3                   	ret    

801069f7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801069f7:	55                   	push   %ebp
801069f8:	89 e5                	mov    %esp,%ebp
801069fa:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801069fd:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106a04:	eb 40                	jmp    80106a46 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a09:	6a 10                	push   $0x10
80106a0b:	50                   	push   %eax
80106a0c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a0f:	50                   	push   %eax
80106a10:	ff 75 08             	pushl  0x8(%ebp)
80106a13:	e8 5e b5 ff ff       	call   80101f76 <readi>
80106a18:	83 c4 10             	add    $0x10,%esp
80106a1b:	83 f8 10             	cmp    $0x10,%eax
80106a1e:	74 0d                	je     80106a2d <isdirempty+0x36>
      panic("isdirempty: readi");
80106a20:	83 ec 0c             	sub    $0xc,%esp
80106a23:	68 2c 9d 10 80       	push   $0x80109d2c
80106a28:	e8 39 9b ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106a2d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106a31:	66 85 c0             	test   %ax,%ax
80106a34:	74 07                	je     80106a3d <isdirempty+0x46>
      return 0;
80106a36:	b8 00 00 00 00       	mov    $0x0,%eax
80106a3b:	eb 1b                	jmp    80106a58 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a40:	83 c0 10             	add    $0x10,%eax
80106a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a46:	8b 45 08             	mov    0x8(%ebp),%eax
80106a49:	8b 50 18             	mov    0x18(%eax),%edx
80106a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a4f:	39 c2                	cmp    %eax,%edx
80106a51:	77 b3                	ja     80106a06 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106a53:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106a58:	c9                   	leave  
80106a59:	c3                   	ret    

80106a5a <sys_unlink>:

int
sys_unlink(void)
{
80106a5a:	55                   	push   %ebp
80106a5b:	89 e5                	mov    %esp,%ebp
80106a5d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106a60:	83 ec 08             	sub    $0x8,%esp
80106a63:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106a66:	50                   	push   %eax
80106a67:	6a 00                	push   $0x0
80106a69:	e8 a0 fa ff ff       	call   8010650e <argstr>
80106a6e:	83 c4 10             	add    $0x10,%esp
80106a71:	85 c0                	test   %eax,%eax
80106a73:	79 0a                	jns    80106a7f <sys_unlink+0x25>
    return -1;
80106a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7a:	e9 bc 01 00 00       	jmp    80106c3b <sys_unlink+0x1e1>

  begin_op();
80106a7f:	e8 67 cb ff ff       	call   801035eb <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106a87:	83 ec 08             	sub    $0x8,%esp
80106a8a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106a8d:	52                   	push   %edx
80106a8e:	50                   	push   %eax
80106a8f:	e8 4e bb ff ff       	call   801025e2 <nameiparent>
80106a94:	83 c4 10             	add    $0x10,%esp
80106a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a9e:	75 0f                	jne    80106aaf <sys_unlink+0x55>
    end_op();
80106aa0:	e8 d2 cb ff ff       	call   80103677 <end_op>
    return -1;
80106aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aaa:	e9 8c 01 00 00       	jmp    80106c3b <sys_unlink+0x1e1>
  }

  ilock(dp);
80106aaf:	83 ec 0c             	sub    $0xc,%esp
80106ab2:	ff 75 f4             	pushl  -0xc(%ebp)
80106ab5:	e8 4e af ff ff       	call   80101a08 <ilock>
80106aba:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106abd:	83 ec 08             	sub    $0x8,%esp
80106ac0:	68 3e 9d 10 80       	push   $0x80109d3e
80106ac5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ac8:	50                   	push   %eax
80106ac9:	e8 87 b7 ff ff       	call   80102255 <namecmp>
80106ace:	83 c4 10             	add    $0x10,%esp
80106ad1:	85 c0                	test   %eax,%eax
80106ad3:	0f 84 4a 01 00 00    	je     80106c23 <sys_unlink+0x1c9>
80106ad9:	83 ec 08             	sub    $0x8,%esp
80106adc:	68 40 9d 10 80       	push   $0x80109d40
80106ae1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ae4:	50                   	push   %eax
80106ae5:	e8 6b b7 ff ff       	call   80102255 <namecmp>
80106aea:	83 c4 10             	add    $0x10,%esp
80106aed:	85 c0                	test   %eax,%eax
80106aef:	0f 84 2e 01 00 00    	je     80106c23 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106af5:	83 ec 04             	sub    $0x4,%esp
80106af8:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106afb:	50                   	push   %eax
80106afc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106aff:	50                   	push   %eax
80106b00:	ff 75 f4             	pushl  -0xc(%ebp)
80106b03:	e8 68 b7 ff ff       	call   80102270 <dirlookup>
80106b08:	83 c4 10             	add    $0x10,%esp
80106b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b12:	0f 84 0a 01 00 00    	je     80106c22 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106b18:	83 ec 0c             	sub    $0xc,%esp
80106b1b:	ff 75 f0             	pushl  -0x10(%ebp)
80106b1e:	e8 e5 ae ff ff       	call   80101a08 <ilock>
80106b23:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b29:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b2d:	66 85 c0             	test   %ax,%ax
80106b30:	7f 0d                	jg     80106b3f <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106b32:	83 ec 0c             	sub    $0xc,%esp
80106b35:	68 43 9d 10 80       	push   $0x80109d43
80106b3a:	e8 27 9a ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b42:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b46:	66 83 f8 01          	cmp    $0x1,%ax
80106b4a:	75 25                	jne    80106b71 <sys_unlink+0x117>
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	ff 75 f0             	pushl  -0x10(%ebp)
80106b52:	e8 a0 fe ff ff       	call   801069f7 <isdirempty>
80106b57:	83 c4 10             	add    $0x10,%esp
80106b5a:	85 c0                	test   %eax,%eax
80106b5c:	75 13                	jne    80106b71 <sys_unlink+0x117>
    iunlockput(ip);
80106b5e:	83 ec 0c             	sub    $0xc,%esp
80106b61:	ff 75 f0             	pushl  -0x10(%ebp)
80106b64:	e8 5f b1 ff ff       	call   80101cc8 <iunlockput>
80106b69:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106b6c:	e9 b2 00 00 00       	jmp    80106c23 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106b71:	83 ec 04             	sub    $0x4,%esp
80106b74:	6a 10                	push   $0x10
80106b76:	6a 00                	push   $0x0
80106b78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b7b:	50                   	push   %eax
80106b7c:	e8 e3 f5 ff ff       	call   80106164 <memset>
80106b81:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106b84:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106b87:	6a 10                	push   $0x10
80106b89:	50                   	push   %eax
80106b8a:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b8d:	50                   	push   %eax
80106b8e:	ff 75 f4             	pushl  -0xc(%ebp)
80106b91:	e8 37 b5 ff ff       	call   801020cd <writei>
80106b96:	83 c4 10             	add    $0x10,%esp
80106b99:	83 f8 10             	cmp    $0x10,%eax
80106b9c:	74 0d                	je     80106bab <sys_unlink+0x151>
    panic("unlink: writei");
80106b9e:	83 ec 0c             	sub    $0xc,%esp
80106ba1:	68 55 9d 10 80       	push   $0x80109d55
80106ba6:	e8 bb 99 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bae:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106bb2:	66 83 f8 01          	cmp    $0x1,%ax
80106bb6:	75 21                	jne    80106bd9 <sys_unlink+0x17f>
    dp->nlink--;
80106bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106bbf:	83 e8 01             	sub    $0x1,%eax
80106bc2:	89 c2                	mov    %eax,%edx
80106bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106bcb:	83 ec 0c             	sub    $0xc,%esp
80106bce:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd1:	e8 58 ac ff ff       	call   8010182e <iupdate>
80106bd6:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106bd9:	83 ec 0c             	sub    $0xc,%esp
80106bdc:	ff 75 f4             	pushl  -0xc(%ebp)
80106bdf:	e8 e4 b0 ff ff       	call   80101cc8 <iunlockput>
80106be4:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bea:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106bee:	83 e8 01             	sub    $0x1,%eax
80106bf1:	89 c2                	mov    %eax,%edx
80106bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bf6:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106bfa:	83 ec 0c             	sub    $0xc,%esp
80106bfd:	ff 75 f0             	pushl  -0x10(%ebp)
80106c00:	e8 29 ac ff ff       	call   8010182e <iupdate>
80106c05:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106c08:	83 ec 0c             	sub    $0xc,%esp
80106c0b:	ff 75 f0             	pushl  -0x10(%ebp)
80106c0e:	e8 b5 b0 ff ff       	call   80101cc8 <iunlockput>
80106c13:	83 c4 10             	add    $0x10,%esp

  end_op();
80106c16:	e8 5c ca ff ff       	call   80103677 <end_op>

  return 0;
80106c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80106c20:	eb 19                	jmp    80106c3b <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106c22:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106c23:	83 ec 0c             	sub    $0xc,%esp
80106c26:	ff 75 f4             	pushl  -0xc(%ebp)
80106c29:	e8 9a b0 ff ff       	call   80101cc8 <iunlockput>
80106c2e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106c31:	e8 41 ca ff ff       	call   80103677 <end_op>
  return -1;
80106c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c3b:	c9                   	leave  
80106c3c:	c3                   	ret    

80106c3d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106c3d:	55                   	push   %ebp
80106c3e:	89 e5                	mov    %esp,%ebp
80106c40:	83 ec 38             	sub    $0x38,%esp
80106c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c46:	8b 55 10             	mov    0x10(%ebp),%edx
80106c49:	8b 45 14             	mov    0x14(%ebp),%eax
80106c4c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106c50:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106c54:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106c58:	83 ec 08             	sub    $0x8,%esp
80106c5b:	8d 45 de             	lea    -0x22(%ebp),%eax
80106c5e:	50                   	push   %eax
80106c5f:	ff 75 08             	pushl  0x8(%ebp)
80106c62:	e8 7b b9 ff ff       	call   801025e2 <nameiparent>
80106c67:	83 c4 10             	add    $0x10,%esp
80106c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c71:	75 0a                	jne    80106c7d <create+0x40>
    return 0;
80106c73:	b8 00 00 00 00       	mov    $0x0,%eax
80106c78:	e9 90 01 00 00       	jmp    80106e0d <create+0x1d0>
  ilock(dp);
80106c7d:	83 ec 0c             	sub    $0xc,%esp
80106c80:	ff 75 f4             	pushl  -0xc(%ebp)
80106c83:	e8 80 ad ff ff       	call   80101a08 <ilock>
80106c88:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106c8b:	83 ec 04             	sub    $0x4,%esp
80106c8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c91:	50                   	push   %eax
80106c92:	8d 45 de             	lea    -0x22(%ebp),%eax
80106c95:	50                   	push   %eax
80106c96:	ff 75 f4             	pushl  -0xc(%ebp)
80106c99:	e8 d2 b5 ff ff       	call   80102270 <dirlookup>
80106c9e:	83 c4 10             	add    $0x10,%esp
80106ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ca8:	74 50                	je     80106cfa <create+0xbd>
    iunlockput(dp);
80106caa:	83 ec 0c             	sub    $0xc,%esp
80106cad:	ff 75 f4             	pushl  -0xc(%ebp)
80106cb0:	e8 13 b0 ff ff       	call   80101cc8 <iunlockput>
80106cb5:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106cb8:	83 ec 0c             	sub    $0xc,%esp
80106cbb:	ff 75 f0             	pushl  -0x10(%ebp)
80106cbe:	e8 45 ad ff ff       	call   80101a08 <ilock>
80106cc3:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106cc6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106ccb:	75 15                	jne    80106ce2 <create+0xa5>
80106ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cd0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cd4:	66 83 f8 02          	cmp    $0x2,%ax
80106cd8:	75 08                	jne    80106ce2 <create+0xa5>
      return ip;
80106cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cdd:	e9 2b 01 00 00       	jmp    80106e0d <create+0x1d0>
    iunlockput(ip);
80106ce2:	83 ec 0c             	sub    $0xc,%esp
80106ce5:	ff 75 f0             	pushl  -0x10(%ebp)
80106ce8:	e8 db af ff ff       	call   80101cc8 <iunlockput>
80106ced:	83 c4 10             	add    $0x10,%esp
    return 0;
80106cf0:	b8 00 00 00 00       	mov    $0x0,%eax
80106cf5:	e9 13 01 00 00       	jmp    80106e0d <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106cfa:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d01:	8b 00                	mov    (%eax),%eax
80106d03:	83 ec 08             	sub    $0x8,%esp
80106d06:	52                   	push   %edx
80106d07:	50                   	push   %eax
80106d08:	e8 4a aa ff ff       	call   80101757 <ialloc>
80106d0d:	83 c4 10             	add    $0x10,%esp
80106d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d17:	75 0d                	jne    80106d26 <create+0xe9>
    panic("create: ialloc");
80106d19:	83 ec 0c             	sub    $0xc,%esp
80106d1c:	68 64 9d 10 80       	push   $0x80109d64
80106d21:	e8 40 98 ff ff       	call   80100566 <panic>

  ilock(ip);
80106d26:	83 ec 0c             	sub    $0xc,%esp
80106d29:	ff 75 f0             	pushl  -0x10(%ebp)
80106d2c:	e8 d7 ac ff ff       	call   80101a08 <ilock>
80106d31:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d37:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106d3b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d42:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106d46:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d4d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106d53:	83 ec 0c             	sub    $0xc,%esp
80106d56:	ff 75 f0             	pushl  -0x10(%ebp)
80106d59:	e8 d0 aa ff ff       	call   8010182e <iupdate>
80106d5e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106d61:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106d66:	75 6a                	jne    80106dd2 <create+0x195>
    dp->nlink++;  // for ".."
80106d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d6f:	83 c0 01             	add    $0x1,%eax
80106d72:	89 c2                	mov    %eax,%edx
80106d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d77:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106d7b:	83 ec 0c             	sub    $0xc,%esp
80106d7e:	ff 75 f4             	pushl  -0xc(%ebp)
80106d81:	e8 a8 aa ff ff       	call   8010182e <iupdate>
80106d86:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d8c:	8b 40 04             	mov    0x4(%eax),%eax
80106d8f:	83 ec 04             	sub    $0x4,%esp
80106d92:	50                   	push   %eax
80106d93:	68 3e 9d 10 80       	push   $0x80109d3e
80106d98:	ff 75 f0             	pushl  -0x10(%ebp)
80106d9b:	e8 8a b5 ff ff       	call   8010232a <dirlink>
80106da0:	83 c4 10             	add    $0x10,%esp
80106da3:	85 c0                	test   %eax,%eax
80106da5:	78 1e                	js     80106dc5 <create+0x188>
80106da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106daa:	8b 40 04             	mov    0x4(%eax),%eax
80106dad:	83 ec 04             	sub    $0x4,%esp
80106db0:	50                   	push   %eax
80106db1:	68 40 9d 10 80       	push   $0x80109d40
80106db6:	ff 75 f0             	pushl  -0x10(%ebp)
80106db9:	e8 6c b5 ff ff       	call   8010232a <dirlink>
80106dbe:	83 c4 10             	add    $0x10,%esp
80106dc1:	85 c0                	test   %eax,%eax
80106dc3:	79 0d                	jns    80106dd2 <create+0x195>
      panic("create dots");
80106dc5:	83 ec 0c             	sub    $0xc,%esp
80106dc8:	68 73 9d 10 80       	push   $0x80109d73
80106dcd:	e8 94 97 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dd5:	8b 40 04             	mov    0x4(%eax),%eax
80106dd8:	83 ec 04             	sub    $0x4,%esp
80106ddb:	50                   	push   %eax
80106ddc:	8d 45 de             	lea    -0x22(%ebp),%eax
80106ddf:	50                   	push   %eax
80106de0:	ff 75 f4             	pushl  -0xc(%ebp)
80106de3:	e8 42 b5 ff ff       	call   8010232a <dirlink>
80106de8:	83 c4 10             	add    $0x10,%esp
80106deb:	85 c0                	test   %eax,%eax
80106ded:	79 0d                	jns    80106dfc <create+0x1bf>
    panic("create: dirlink");
80106def:	83 ec 0c             	sub    $0xc,%esp
80106df2:	68 7f 9d 10 80       	push   $0x80109d7f
80106df7:	e8 6a 97 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	ff 75 f4             	pushl  -0xc(%ebp)
80106e02:	e8 c1 ae ff ff       	call   80101cc8 <iunlockput>
80106e07:	83 c4 10             	add    $0x10,%esp

  return ip;
80106e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106e0d:	c9                   	leave  
80106e0e:	c3                   	ret    

80106e0f <sys_open>:

int
sys_open(void)
{
80106e0f:	55                   	push   %ebp
80106e10:	89 e5                	mov    %esp,%ebp
80106e12:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106e15:	83 ec 08             	sub    $0x8,%esp
80106e18:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106e1b:	50                   	push   %eax
80106e1c:	6a 00                	push   $0x0
80106e1e:	e8 eb f6 ff ff       	call   8010650e <argstr>
80106e23:	83 c4 10             	add    $0x10,%esp
80106e26:	85 c0                	test   %eax,%eax
80106e28:	78 15                	js     80106e3f <sys_open+0x30>
80106e2a:	83 ec 08             	sub    $0x8,%esp
80106e2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e30:	50                   	push   %eax
80106e31:	6a 01                	push   $0x1
80106e33:	e8 51 f6 ff ff       	call   80106489 <argint>
80106e38:	83 c4 10             	add    $0x10,%esp
80106e3b:	85 c0                	test   %eax,%eax
80106e3d:	79 0a                	jns    80106e49 <sys_open+0x3a>
    return -1;
80106e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e44:	e9 61 01 00 00       	jmp    80106faa <sys_open+0x19b>

  begin_op();
80106e49:	e8 9d c7 ff ff       	call   801035eb <begin_op>

  if(omode & O_CREATE){
80106e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e51:	25 00 02 00 00       	and    $0x200,%eax
80106e56:	85 c0                	test   %eax,%eax
80106e58:	74 2a                	je     80106e84 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e5d:	6a 00                	push   $0x0
80106e5f:	6a 00                	push   $0x0
80106e61:	6a 02                	push   $0x2
80106e63:	50                   	push   %eax
80106e64:	e8 d4 fd ff ff       	call   80106c3d <create>
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e73:	75 75                	jne    80106eea <sys_open+0xdb>
      end_op();
80106e75:	e8 fd c7 ff ff       	call   80103677 <end_op>
      return -1;
80106e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e7f:	e9 26 01 00 00       	jmp    80106faa <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e87:	83 ec 0c             	sub    $0xc,%esp
80106e8a:	50                   	push   %eax
80106e8b:	e8 36 b7 ff ff       	call   801025c6 <namei>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e9a:	75 0f                	jne    80106eab <sys_open+0x9c>
      end_op();
80106e9c:	e8 d6 c7 ff ff       	call   80103677 <end_op>
      return -1;
80106ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ea6:	e9 ff 00 00 00       	jmp    80106faa <sys_open+0x19b>
    }
    ilock(ip);
80106eab:	83 ec 0c             	sub    $0xc,%esp
80106eae:	ff 75 f4             	pushl  -0xc(%ebp)
80106eb1:	e8 52 ab ff ff       	call   80101a08 <ilock>
80106eb6:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ebc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106ec0:	66 83 f8 01          	cmp    $0x1,%ax
80106ec4:	75 24                	jne    80106eea <sys_open+0xdb>
80106ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ec9:	85 c0                	test   %eax,%eax
80106ecb:	74 1d                	je     80106eea <sys_open+0xdb>
      iunlockput(ip);
80106ecd:	83 ec 0c             	sub    $0xc,%esp
80106ed0:	ff 75 f4             	pushl  -0xc(%ebp)
80106ed3:	e8 f0 ad ff ff       	call   80101cc8 <iunlockput>
80106ed8:	83 c4 10             	add    $0x10,%esp
      end_op();
80106edb:	e8 97 c7 ff ff       	call   80103677 <end_op>
      return -1;
80106ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee5:	e9 c0 00 00 00       	jmp    80106faa <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106eea:	e8 42 a1 ff ff       	call   80101031 <filealloc>
80106eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ef2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ef6:	74 17                	je     80106f0f <sys_open+0x100>
80106ef8:	83 ec 0c             	sub    $0xc,%esp
80106efb:	ff 75 f0             	pushl  -0x10(%ebp)
80106efe:	e8 37 f7 ff ff       	call   8010663a <fdalloc>
80106f03:	83 c4 10             	add    $0x10,%esp
80106f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106f09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106f0d:	79 2e                	jns    80106f3d <sys_open+0x12e>
    if(f)
80106f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f13:	74 0e                	je     80106f23 <sys_open+0x114>
      fileclose(f);
80106f15:	83 ec 0c             	sub    $0xc,%esp
80106f18:	ff 75 f0             	pushl  -0x10(%ebp)
80106f1b:	e8 cf a1 ff ff       	call   801010ef <fileclose>
80106f20:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106f23:	83 ec 0c             	sub    $0xc,%esp
80106f26:	ff 75 f4             	pushl  -0xc(%ebp)
80106f29:	e8 9a ad ff ff       	call   80101cc8 <iunlockput>
80106f2e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106f31:	e8 41 c7 ff ff       	call   80103677 <end_op>
    return -1;
80106f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f3b:	eb 6d                	jmp    80106faa <sys_open+0x19b>
  }
  iunlock(ip);
80106f3d:	83 ec 0c             	sub    $0xc,%esp
80106f40:	ff 75 f4             	pushl  -0xc(%ebp)
80106f43:	e8 1e ac ff ff       	call   80101b66 <iunlock>
80106f48:	83 c4 10             	add    $0x10,%esp
  end_op();
80106f4b:	e8 27 c7 ff ff       	call   80103677 <end_op>

  f->type = FD_INODE;
80106f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f53:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f5f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f65:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f6f:	83 e0 01             	and    $0x1,%eax
80106f72:	85 c0                	test   %eax,%eax
80106f74:	0f 94 c0             	sete   %al
80106f77:	89 c2                	mov    %eax,%edx
80106f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f7c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f82:	83 e0 01             	and    $0x1,%eax
80106f85:	85 c0                	test   %eax,%eax
80106f87:	75 0a                	jne    80106f93 <sys_open+0x184>
80106f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f8c:	83 e0 02             	and    $0x2,%eax
80106f8f:	85 c0                	test   %eax,%eax
80106f91:	74 07                	je     80106f9a <sys_open+0x18b>
80106f93:	b8 01 00 00 00       	mov    $0x1,%eax
80106f98:	eb 05                	jmp    80106f9f <sys_open+0x190>
80106f9a:	b8 00 00 00 00       	mov    $0x0,%eax
80106f9f:	89 c2                	mov    %eax,%edx
80106fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fa4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106faa:	c9                   	leave  
80106fab:	c3                   	ret    

80106fac <sys_mkdir>:

int
sys_mkdir(void)
{
80106fac:	55                   	push   %ebp
80106fad:	89 e5                	mov    %esp,%ebp
80106faf:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106fb2:	e8 34 c6 ff ff       	call   801035eb <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106fb7:	83 ec 08             	sub    $0x8,%esp
80106fba:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fbd:	50                   	push   %eax
80106fbe:	6a 00                	push   $0x0
80106fc0:	e8 49 f5 ff ff       	call   8010650e <argstr>
80106fc5:	83 c4 10             	add    $0x10,%esp
80106fc8:	85 c0                	test   %eax,%eax
80106fca:	78 1b                	js     80106fe7 <sys_mkdir+0x3b>
80106fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fcf:	6a 00                	push   $0x0
80106fd1:	6a 00                	push   $0x0
80106fd3:	6a 01                	push   $0x1
80106fd5:	50                   	push   %eax
80106fd6:	e8 62 fc ff ff       	call   80106c3d <create>
80106fdb:	83 c4 10             	add    $0x10,%esp
80106fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fe5:	75 0c                	jne    80106ff3 <sys_mkdir+0x47>
    end_op();
80106fe7:	e8 8b c6 ff ff       	call   80103677 <end_op>
    return -1;
80106fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff1:	eb 18                	jmp    8010700b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106ff3:	83 ec 0c             	sub    $0xc,%esp
80106ff6:	ff 75 f4             	pushl  -0xc(%ebp)
80106ff9:	e8 ca ac ff ff       	call   80101cc8 <iunlockput>
80106ffe:	83 c4 10             	add    $0x10,%esp
  end_op();
80107001:	e8 71 c6 ff ff       	call   80103677 <end_op>
  return 0;
80107006:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010700b:	c9                   	leave  
8010700c:	c3                   	ret    

8010700d <sys_mknod>:

int
sys_mknod(void)
{
8010700d:	55                   	push   %ebp
8010700e:	89 e5                	mov    %esp,%ebp
80107010:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107013:	e8 d3 c5 ff ff       	call   801035eb <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107018:	83 ec 08             	sub    $0x8,%esp
8010701b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010701e:	50                   	push   %eax
8010701f:	6a 00                	push   $0x0
80107021:	e8 e8 f4 ff ff       	call   8010650e <argstr>
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010702c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107030:	78 4f                	js     80107081 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107032:	83 ec 08             	sub    $0x8,%esp
80107035:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107038:	50                   	push   %eax
80107039:	6a 01                	push   $0x1
8010703b:	e8 49 f4 ff ff       	call   80106489 <argint>
80107040:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107043:	85 c0                	test   %eax,%eax
80107045:	78 3a                	js     80107081 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107047:	83 ec 08             	sub    $0x8,%esp
8010704a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010704d:	50                   	push   %eax
8010704e:	6a 02                	push   $0x2
80107050:	e8 34 f4 ff ff       	call   80106489 <argint>
80107055:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107058:	85 c0                	test   %eax,%eax
8010705a:	78 25                	js     80107081 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010705c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010705f:	0f bf c8             	movswl %ax,%ecx
80107062:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107065:	0f bf d0             	movswl %ax,%edx
80107068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010706b:	51                   	push   %ecx
8010706c:	52                   	push   %edx
8010706d:	6a 03                	push   $0x3
8010706f:	50                   	push   %eax
80107070:	e8 c8 fb ff ff       	call   80106c3d <create>
80107075:	83 c4 10             	add    $0x10,%esp
80107078:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010707b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010707f:	75 0c                	jne    8010708d <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107081:	e8 f1 c5 ff ff       	call   80103677 <end_op>
    return -1;
80107086:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010708b:	eb 18                	jmp    801070a5 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010708d:	83 ec 0c             	sub    $0xc,%esp
80107090:	ff 75 f0             	pushl  -0x10(%ebp)
80107093:	e8 30 ac ff ff       	call   80101cc8 <iunlockput>
80107098:	83 c4 10             	add    $0x10,%esp
  end_op();
8010709b:	e8 d7 c5 ff ff       	call   80103677 <end_op>
  return 0;
801070a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070a5:	c9                   	leave  
801070a6:	c3                   	ret    

801070a7 <sys_chdir>:

int
sys_chdir(void)
{
801070a7:	55                   	push   %ebp
801070a8:	89 e5                	mov    %esp,%ebp
801070aa:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801070ad:	e8 39 c5 ff ff       	call   801035eb <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801070b2:	83 ec 08             	sub    $0x8,%esp
801070b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070b8:	50                   	push   %eax
801070b9:	6a 00                	push   $0x0
801070bb:	e8 4e f4 ff ff       	call   8010650e <argstr>
801070c0:	83 c4 10             	add    $0x10,%esp
801070c3:	85 c0                	test   %eax,%eax
801070c5:	78 18                	js     801070df <sys_chdir+0x38>
801070c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	50                   	push   %eax
801070ce:	e8 f3 b4 ff ff       	call   801025c6 <namei>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801070d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070dd:	75 0c                	jne    801070eb <sys_chdir+0x44>
    end_op();
801070df:	e8 93 c5 ff ff       	call   80103677 <end_op>
    return -1;
801070e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e9:	eb 6e                	jmp    80107159 <sys_chdir+0xb2>
  }
  ilock(ip);
801070eb:	83 ec 0c             	sub    $0xc,%esp
801070ee:	ff 75 f4             	pushl  -0xc(%ebp)
801070f1:	e8 12 a9 ff ff       	call   80101a08 <ilock>
801070f6:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801070f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070fc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107100:	66 83 f8 01          	cmp    $0x1,%ax
80107104:	74 1a                	je     80107120 <sys_chdir+0x79>
    iunlockput(ip);
80107106:	83 ec 0c             	sub    $0xc,%esp
80107109:	ff 75 f4             	pushl  -0xc(%ebp)
8010710c:	e8 b7 ab ff ff       	call   80101cc8 <iunlockput>
80107111:	83 c4 10             	add    $0x10,%esp
    end_op();
80107114:	e8 5e c5 ff ff       	call   80103677 <end_op>
    return -1;
80107119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010711e:	eb 39                	jmp    80107159 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107120:	83 ec 0c             	sub    $0xc,%esp
80107123:	ff 75 f4             	pushl  -0xc(%ebp)
80107126:	e8 3b aa ff ff       	call   80101b66 <iunlock>
8010712b:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010712e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107134:	8b 40 68             	mov    0x68(%eax),%eax
80107137:	83 ec 0c             	sub    $0xc,%esp
8010713a:	50                   	push   %eax
8010713b:	e8 98 aa ff ff       	call   80101bd8 <iput>
80107140:	83 c4 10             	add    $0x10,%esp
  end_op();
80107143:	e8 2f c5 ff ff       	call   80103677 <end_op>
  proc->cwd = ip;
80107148:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010714e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107151:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107154:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107159:	c9                   	leave  
8010715a:	c3                   	ret    

8010715b <sys_exec>:

int
sys_exec(void)
{
8010715b:	55                   	push   %ebp
8010715c:	89 e5                	mov    %esp,%ebp
8010715e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107164:	83 ec 08             	sub    $0x8,%esp
80107167:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010716a:	50                   	push   %eax
8010716b:	6a 00                	push   $0x0
8010716d:	e8 9c f3 ff ff       	call   8010650e <argstr>
80107172:	83 c4 10             	add    $0x10,%esp
80107175:	85 c0                	test   %eax,%eax
80107177:	78 18                	js     80107191 <sys_exec+0x36>
80107179:	83 ec 08             	sub    $0x8,%esp
8010717c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107182:	50                   	push   %eax
80107183:	6a 01                	push   $0x1
80107185:	e8 ff f2 ff ff       	call   80106489 <argint>
8010718a:	83 c4 10             	add    $0x10,%esp
8010718d:	85 c0                	test   %eax,%eax
8010718f:	79 0a                	jns    8010719b <sys_exec+0x40>
    return -1;
80107191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107196:	e9 c6 00 00 00       	jmp    80107261 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010719b:	83 ec 04             	sub    $0x4,%esp
8010719e:	68 80 00 00 00       	push   $0x80
801071a3:	6a 00                	push   $0x0
801071a5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801071ab:	50                   	push   %eax
801071ac:	e8 b3 ef ff ff       	call   80106164 <memset>
801071b1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801071b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801071bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071be:	83 f8 1f             	cmp    $0x1f,%eax
801071c1:	76 0a                	jbe    801071cd <sys_exec+0x72>
      return -1;
801071c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071c8:	e9 94 00 00 00       	jmp    80107261 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801071cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d0:	c1 e0 02             	shl    $0x2,%eax
801071d3:	89 c2                	mov    %eax,%edx
801071d5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801071db:	01 c2                	add    %eax,%edx
801071dd:	83 ec 08             	sub    $0x8,%esp
801071e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801071e6:	50                   	push   %eax
801071e7:	52                   	push   %edx
801071e8:	e8 00 f2 ff ff       	call   801063ed <fetchint>
801071ed:	83 c4 10             	add    $0x10,%esp
801071f0:	85 c0                	test   %eax,%eax
801071f2:	79 07                	jns    801071fb <sys_exec+0xa0>
      return -1;
801071f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071f9:	eb 66                	jmp    80107261 <sys_exec+0x106>
    if(uarg == 0){
801071fb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107201:	85 c0                	test   %eax,%eax
80107203:	75 27                	jne    8010722c <sys_exec+0xd1>
      argv[i] = 0;
80107205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107208:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010720f:	00 00 00 00 
      break;
80107213:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107214:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107217:	83 ec 08             	sub    $0x8,%esp
8010721a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107220:	52                   	push   %edx
80107221:	50                   	push   %eax
80107222:	e8 e8 99 ff ff       	call   80100c0f <exec>
80107227:	83 c4 10             	add    $0x10,%esp
8010722a:	eb 35                	jmp    80107261 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010722c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107232:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107235:	c1 e2 02             	shl    $0x2,%edx
80107238:	01 c2                	add    %eax,%edx
8010723a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107240:	83 ec 08             	sub    $0x8,%esp
80107243:	52                   	push   %edx
80107244:	50                   	push   %eax
80107245:	e8 dd f1 ff ff       	call   80106427 <fetchstr>
8010724a:	83 c4 10             	add    $0x10,%esp
8010724d:	85 c0                	test   %eax,%eax
8010724f:	79 07                	jns    80107258 <sys_exec+0xfd>
      return -1;
80107251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107256:	eb 09                	jmp    80107261 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107258:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010725c:	e9 5a ff ff ff       	jmp    801071bb <sys_exec+0x60>
  return exec(path, argv);
}
80107261:	c9                   	leave  
80107262:	c3                   	ret    

80107263 <sys_pipe>:

int
sys_pipe(void)
{
80107263:	55                   	push   %ebp
80107264:	89 e5                	mov    %esp,%ebp
80107266:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107269:	83 ec 04             	sub    $0x4,%esp
8010726c:	6a 08                	push   $0x8
8010726e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107271:	50                   	push   %eax
80107272:	6a 00                	push   $0x0
80107274:	e8 38 f2 ff ff       	call   801064b1 <argptr>
80107279:	83 c4 10             	add    $0x10,%esp
8010727c:	85 c0                	test   %eax,%eax
8010727e:	79 0a                	jns    8010728a <sys_pipe+0x27>
    return -1;
80107280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107285:	e9 af 00 00 00       	jmp    80107339 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010728a:	83 ec 08             	sub    $0x8,%esp
8010728d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107290:	50                   	push   %eax
80107291:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107294:	50                   	push   %eax
80107295:	e8 45 ce ff ff       	call   801040df <pipealloc>
8010729a:	83 c4 10             	add    $0x10,%esp
8010729d:	85 c0                	test   %eax,%eax
8010729f:	79 0a                	jns    801072ab <sys_pipe+0x48>
    return -1;
801072a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072a6:	e9 8e 00 00 00       	jmp    80107339 <sys_pipe+0xd6>
  fd0 = -1;
801072ab:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801072b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072b5:	83 ec 0c             	sub    $0xc,%esp
801072b8:	50                   	push   %eax
801072b9:	e8 7c f3 ff ff       	call   8010663a <fdalloc>
801072be:	83 c4 10             	add    $0x10,%esp
801072c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072c8:	78 18                	js     801072e2 <sys_pipe+0x7f>
801072ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072cd:	83 ec 0c             	sub    $0xc,%esp
801072d0:	50                   	push   %eax
801072d1:	e8 64 f3 ff ff       	call   8010663a <fdalloc>
801072d6:	83 c4 10             	add    $0x10,%esp
801072d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072e0:	79 3f                	jns    80107321 <sys_pipe+0xbe>
    if(fd0 >= 0)
801072e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072e6:	78 14                	js     801072fc <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801072e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072f1:	83 c2 08             	add    $0x8,%edx
801072f4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801072fb:	00 
    fileclose(rf);
801072fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	50                   	push   %eax
80107303:	e8 e7 9d ff ff       	call   801010ef <fileclose>
80107308:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010730b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010730e:	83 ec 0c             	sub    $0xc,%esp
80107311:	50                   	push   %eax
80107312:	e8 d8 9d ff ff       	call   801010ef <fileclose>
80107317:	83 c4 10             	add    $0x10,%esp
    return -1;
8010731a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010731f:	eb 18                	jmp    80107339 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107321:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107324:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107327:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107329:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010732c:	8d 50 04             	lea    0x4(%eax),%edx
8010732f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107332:	89 02                	mov    %eax,(%edx)
  return 0;
80107334:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107339:	c9                   	leave  
8010733a:	c3                   	ret    

8010733b <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010733b:	55                   	push   %ebp
8010733c:	89 e5                	mov    %esp,%ebp
8010733e:	83 ec 08             	sub    $0x8,%esp
80107341:	8b 55 08             	mov    0x8(%ebp),%edx
80107344:	8b 45 0c             	mov    0xc(%ebp),%eax
80107347:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010734b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010734f:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107353:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107357:	66 ef                	out    %ax,(%dx)
}
80107359:	90                   	nop
8010735a:	c9                   	leave  
8010735b:	c3                   	ret    

8010735c <sys_fork>:
#endif


int
sys_fork(void)
{
8010735c:	55                   	push   %ebp
8010735d:	89 e5                	mov    %esp,%ebp
8010735f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107362:	e8 71 d6 ff ff       	call   801049d8 <fork>
}
80107367:	c9                   	leave  
80107368:	c3                   	ret    

80107369 <sys_exit>:

int
sys_exit(void)
{
80107369:	55                   	push   %ebp
8010736a:	89 e5                	mov    %esp,%ebp
8010736c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010736f:	e8 f3 d8 ff ff       	call   80104c67 <exit>
  return 0;  // not reached
80107374:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107379:	c9                   	leave  
8010737a:	c3                   	ret    

8010737b <sys_wait>:

int
sys_wait(void)
{
8010737b:	55                   	push   %ebp
8010737c:	89 e5                	mov    %esp,%ebp
8010737e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107381:	e8 bc da ff ff       	call   80104e42 <wait>
}
80107386:	c9                   	leave  
80107387:	c3                   	ret    

80107388 <sys_kill>:

int
sys_kill(void)
{
80107388:	55                   	push   %ebp
80107389:	89 e5                	mov    %esp,%ebp
8010738b:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010738e:	83 ec 08             	sub    $0x8,%esp
80107391:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107394:	50                   	push   %eax
80107395:	6a 00                	push   $0x0
80107397:	e8 ed f0 ff ff       	call   80106489 <argint>
8010739c:	83 c4 10             	add    $0x10,%esp
8010739f:	85 c0                	test   %eax,%eax
801073a1:	79 07                	jns    801073aa <sys_kill+0x22>
    return -1;
801073a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073a8:	eb 0f                	jmp    801073b9 <sys_kill+0x31>
  return kill(pid);
801073aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ad:	83 ec 0c             	sub    $0xc,%esp
801073b0:	50                   	push   %eax
801073b1:	e8 32 e1 ff ff       	call   801054e8 <kill>
801073b6:	83 c4 10             	add    $0x10,%esp
}
801073b9:	c9                   	leave  
801073ba:	c3                   	ret    

801073bb <sys_getpid>:

int
sys_getpid(void)
{
801073bb:	55                   	push   %ebp
801073bc:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801073be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073c4:	8b 40 10             	mov    0x10(%eax),%eax
}
801073c7:	5d                   	pop    %ebp
801073c8:	c3                   	ret    

801073c9 <sys_sbrk>:

int
sys_sbrk(void)
{
801073c9:	55                   	push   %ebp
801073ca:	89 e5                	mov    %esp,%ebp
801073cc:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801073cf:	83 ec 08             	sub    $0x8,%esp
801073d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073d5:	50                   	push   %eax
801073d6:	6a 00                	push   $0x0
801073d8:	e8 ac f0 ff ff       	call   80106489 <argint>
801073dd:	83 c4 10             	add    $0x10,%esp
801073e0:	85 c0                	test   %eax,%eax
801073e2:	79 07                	jns    801073eb <sys_sbrk+0x22>
    return -1;
801073e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073e9:	eb 28                	jmp    80107413 <sys_sbrk+0x4a>
  addr = proc->sz;
801073eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073f1:	8b 00                	mov    (%eax),%eax
801073f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801073f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	50                   	push   %eax
801073fd:	e8 33 d5 ff ff       	call   80104935 <growproc>
80107402:	83 c4 10             	add    $0x10,%esp
80107405:	85 c0                	test   %eax,%eax
80107407:	79 07                	jns    80107410 <sys_sbrk+0x47>
    return -1;
80107409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010740e:	eb 03                	jmp    80107413 <sys_sbrk+0x4a>
  return addr;
80107410:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107413:	c9                   	leave  
80107414:	c3                   	ret    

80107415 <sys_sleep>:

int
sys_sleep(void)
{
80107415:	55                   	push   %ebp
80107416:	89 e5                	mov    %esp,%ebp
80107418:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010741b:	83 ec 08             	sub    $0x8,%esp
8010741e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107421:	50                   	push   %eax
80107422:	6a 00                	push   $0x0
80107424:	e8 60 f0 ff ff       	call   80106489 <argint>
80107429:	83 c4 10             	add    $0x10,%esp
8010742c:	85 c0                	test   %eax,%eax
8010742e:	79 07                	jns    80107437 <sys_sleep+0x22>
    return -1;
80107430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107435:	eb 44                	jmp    8010747b <sys_sleep+0x66>
  ticks0 = ticks;
80107437:	a1 e0 66 11 80       	mov    0x801166e0,%eax
8010743c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010743f:	eb 26                	jmp    80107467 <sys_sleep+0x52>
    if(proc->killed){
80107441:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107447:	8b 40 24             	mov    0x24(%eax),%eax
8010744a:	85 c0                	test   %eax,%eax
8010744c:	74 07                	je     80107455 <sys_sleep+0x40>
      return -1;
8010744e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107453:	eb 26                	jmp    8010747b <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107455:	83 ec 08             	sub    $0x8,%esp
80107458:	6a 00                	push   $0x0
8010745a:	68 e0 66 11 80       	push   $0x801166e0
8010745f:	e8 99 de ff ff       	call   801052fd <sleep>
80107464:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107467:	a1 e0 66 11 80       	mov    0x801166e0,%eax
8010746c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010746f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107472:	39 d0                	cmp    %edx,%eax
80107474:	72 cb                	jb     80107441 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107476:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010747b:	c9                   	leave  
8010747c:	c3                   	ret    

8010747d <sys_date>:

#ifdef CS333_P1
int
sys_date(void)
{
8010747d:	55                   	push   %ebp
8010747e:	89 e5                	mov    %esp,%ebp
80107480:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80107483:	83 ec 04             	sub    $0x4,%esp
80107486:	6a 18                	push   $0x18
80107488:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010748b:	50                   	push   %eax
8010748c:	6a 00                	push   $0x0
8010748e:	e8 1e f0 ff ff       	call   801064b1 <argptr>
80107493:	83 c4 10             	add    $0x10,%esp
80107496:	85 c0                	test   %eax,%eax
80107498:	79 07                	jns    801074a1 <sys_date+0x24>
        return -1;
8010749a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010749f:	eb 14                	jmp    801074b5 <sys_date+0x38>
    cmostime(d);
801074a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a4:	83 ec 0c             	sub    $0xc,%esp
801074a7:	50                   	push   %eax
801074a8:	e8 b9 bd ff ff       	call   80103266 <cmostime>
801074ad:	83 c4 10             	add    $0x10,%esp

    return 0;
801074b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074b5:	c9                   	leave  
801074b6:	c3                   	ret    

801074b7 <sys_getuid>:
#endif

#ifdef CS333_P2
int
sys_getuid(void)
{
801074b7:	55                   	push   %ebp
801074b8:	89 e5                	mov    %esp,%ebp
    return proc->uid;
801074ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074c0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
801074c6:	5d                   	pop    %ebp
801074c7:	c3                   	ret    

801074c8 <sys_getgid>:

int
sys_getgid(void)
{
801074c8:	55                   	push   %ebp
801074c9:	89 e5                	mov    %esp,%ebp
    return proc->gid;
801074cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074d1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801074d7:	5d                   	pop    %ebp
801074d8:	c3                   	ret    

801074d9 <sys_getppid>:

int
sys_getppid(void)
{
801074d9:	55                   	push   %ebp
801074da:	89 e5                	mov    %esp,%ebp
    if(proc->pid == 1)
801074dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074e2:	8b 40 10             	mov    0x10(%eax),%eax
801074e5:	83 f8 01             	cmp    $0x1,%eax
801074e8:	75 07                	jne    801074f1 <sys_getppid+0x18>
        return 1;
801074ea:	b8 01 00 00 00       	mov    $0x1,%eax
801074ef:	eb 0c                	jmp    801074fd <sys_getppid+0x24>
    return proc->parent->pid;
801074f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074f7:	8b 40 14             	mov    0x14(%eax),%eax
801074fa:	8b 40 10             	mov    0x10(%eax),%eax
}
801074fd:	5d                   	pop    %ebp
801074fe:	c3                   	ret    

801074ff <sys_setuid>:

int
sys_setuid(void)
{
801074ff:	55                   	push   %ebp
80107500:	89 e5                	mov    %esp,%ebp
80107502:	83 ec 18             	sub    $0x18,%esp
    int n;

    if(argint(0, &n) < 0)
80107505:	83 ec 08             	sub    $0x8,%esp
80107508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010750b:	50                   	push   %eax
8010750c:	6a 00                	push   $0x0
8010750e:	e8 76 ef ff ff       	call   80106489 <argint>
80107513:	83 c4 10             	add    $0x10,%esp
80107516:	85 c0                	test   %eax,%eax
80107518:	79 07                	jns    80107521 <sys_setuid+0x22>
        return -1;
8010751a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010751f:	eb 2c                	jmp    8010754d <sys_setuid+0x4e>

    if(n > -1 && n < 32768)
80107521:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107524:	85 c0                	test   %eax,%eax
80107526:	78 20                	js     80107548 <sys_setuid+0x49>
80107528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752b:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107530:	7f 16                	jg     80107548 <sys_setuid+0x49>
        proc->uid = n;
80107532:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107538:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010753b:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    else
        return -1;
        
    return 0;
80107541:	b8 00 00 00 00       	mov    $0x0,%eax
80107546:	eb 05                	jmp    8010754d <sys_setuid+0x4e>
        return -1;

    if(n > -1 && n < 32768)
        proc->uid = n;
    else
        return -1;
80107548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        
    return 0;
}
8010754d:	c9                   	leave  
8010754e:	c3                   	ret    

8010754f <sys_setgid>:

int
sys_setgid(void)
{
8010754f:	55                   	push   %ebp
80107550:	89 e5                	mov    %esp,%ebp
80107552:	83 ec 18             	sub    $0x18,%esp
    int n;

    if(argint(0, &n) < 0)
80107555:	83 ec 08             	sub    $0x8,%esp
80107558:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010755b:	50                   	push   %eax
8010755c:	6a 00                	push   $0x0
8010755e:	e8 26 ef ff ff       	call   80106489 <argint>
80107563:	83 c4 10             	add    $0x10,%esp
80107566:	85 c0                	test   %eax,%eax
80107568:	79 07                	jns    80107571 <sys_setgid+0x22>
        return -1;
8010756a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010756f:	eb 2c                	jmp    8010759d <sys_setgid+0x4e>
    if(n > -1 && n < 32768)        
80107571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107574:	85 c0                	test   %eax,%eax
80107576:	78 20                	js     80107598 <sys_setgid+0x49>
80107578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757b:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107580:	7f 16                	jg     80107598 <sys_setgid+0x49>
        proc->gid = n;
80107582:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107588:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010758b:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    else
        return -1;

    return 0;
80107591:	b8 00 00 00 00       	mov    $0x0,%eax
80107596:	eb 05                	jmp    8010759d <sys_setgid+0x4e>
    if(argint(0, &n) < 0)
        return -1;
    if(n > -1 && n < 32768)        
        proc->gid = n;
    else
        return -1;
80107598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

    return 0;
}
8010759d:	c9                   	leave  
8010759e:	c3                   	ret    

8010759f <sys_getprocs>:

int
sys_getprocs(void)
{
8010759f:	55                   	push   %ebp
801075a0:	89 e5                	mov    %esp,%ebp
801075a2:	83 ec 18             	sub    $0x18,%esp
    struct uproc * utable;
    int n;

    if(argint(0, &n) < 0)
801075a5:	83 ec 08             	sub    $0x8,%esp
801075a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075ab:	50                   	push   %eax
801075ac:	6a 00                	push   $0x0
801075ae:	e8 d6 ee ff ff       	call   80106489 <argint>
801075b3:	83 c4 10             	add    $0x10,%esp
801075b6:	85 c0                	test   %eax,%eax
801075b8:	79 07                	jns    801075c1 <sys_getprocs+0x22>
        return -1;
801075ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075bf:	eb 36                	jmp    801075f7 <sys_getprocs+0x58>
    if(argptr(1, (void*)&utable, sizeof(struct uproc) * n) < 0)
801075c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075c4:	6b c0 5c             	imul   $0x5c,%eax,%eax
801075c7:	83 ec 04             	sub    $0x4,%esp
801075ca:	50                   	push   %eax
801075cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075ce:	50                   	push   %eax
801075cf:	6a 01                	push   $0x1
801075d1:	e8 db ee ff ff       	call   801064b1 <argptr>
801075d6:	83 c4 10             	add    $0x10,%esp
801075d9:	85 c0                	test   %eax,%eax
801075db:	79 07                	jns    801075e4 <sys_getprocs+0x45>
        return -1;
801075dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075e2:	eb 13                	jmp    801075f7 <sys_getprocs+0x58>

    return getprocdata(n, utable);
801075e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801075ea:	83 ec 08             	sub    $0x8,%esp
801075ed:	50                   	push   %eax
801075ee:	52                   	push   %edx
801075ef:	e8 02 e3 ff ff       	call   801058f6 <getprocdata>
801075f4:	83 c4 10             	add    $0x10,%esp
}
801075f7:	c9                   	leave  
801075f8:	c3                   	ret    

801075f9 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801075f9:	55                   	push   %ebp
801075fa:	89 e5                	mov    %esp,%ebp
801075fc:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801075ff:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80107604:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010760a:	c9                   	leave  
8010760b:	c3                   	ret    

8010760c <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
8010760c:	55                   	push   %ebp
8010760d:	89 e5                	mov    %esp,%ebp
8010760f:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	68 8f 9d 10 80       	push   $0x80109d8f
8010761a:	e8 a7 8d ff ff       	call   801003c6 <cprintf>
8010761f:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107622:	83 ec 08             	sub    $0x8,%esp
80107625:	68 00 20 00 00       	push   $0x2000
8010762a:	68 04 06 00 00       	push   $0x604
8010762f:	e8 07 fd ff ff       	call   8010733b <outw>
80107634:	83 c4 10             	add    $0x10,%esp
  return 0;
80107637:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010763c:	c9                   	leave  
8010763d:	c3                   	ret    

8010763e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010763e:	55                   	push   %ebp
8010763f:	89 e5                	mov    %esp,%ebp
80107641:	83 ec 08             	sub    $0x8,%esp
80107644:	8b 55 08             	mov    0x8(%ebp),%edx
80107647:	8b 45 0c             	mov    0xc(%ebp),%eax
8010764a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010764e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107651:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107655:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107659:	ee                   	out    %al,(%dx)
}
8010765a:	90                   	nop
8010765b:	c9                   	leave  
8010765c:	c3                   	ret    

8010765d <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010765d:	55                   	push   %ebp
8010765e:	89 e5                	mov    %esp,%ebp
80107660:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107663:	6a 34                	push   $0x34
80107665:	6a 43                	push   $0x43
80107667:	e8 d2 ff ff ff       	call   8010763e <outb>
8010766c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
8010766f:	68 a9 00 00 00       	push   $0xa9
80107674:	6a 40                	push   $0x40
80107676:	e8 c3 ff ff ff       	call   8010763e <outb>
8010767b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
8010767e:	6a 04                	push   $0x4
80107680:	6a 40                	push   $0x40
80107682:	e8 b7 ff ff ff       	call   8010763e <outb>
80107687:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010768a:	83 ec 0c             	sub    $0xc,%esp
8010768d:	6a 00                	push   $0x0
8010768f:	e8 35 c9 ff ff       	call   80103fc9 <picenable>
80107694:	83 c4 10             	add    $0x10,%esp
}
80107697:	90                   	nop
80107698:	c9                   	leave  
80107699:	c3                   	ret    

8010769a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010769a:	1e                   	push   %ds
  pushl %es
8010769b:	06                   	push   %es
  pushl %fs
8010769c:	0f a0                	push   %fs
  pushl %gs
8010769e:	0f a8                	push   %gs
  pushal
801076a0:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801076a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801076a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801076a7:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801076a9:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801076ad:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801076af:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801076b1:	54                   	push   %esp
  call trap
801076b2:	e8 ce 01 00 00       	call   80107885 <trap>
  addl $4, %esp
801076b7:	83 c4 04             	add    $0x4,%esp

801076ba <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801076ba:	61                   	popa   
  popl %gs
801076bb:	0f a9                	pop    %gs
  popl %fs
801076bd:	0f a1                	pop    %fs
  popl %es
801076bf:	07                   	pop    %es
  popl %ds
801076c0:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801076c1:	83 c4 08             	add    $0x8,%esp
  iret
801076c4:	cf                   	iret   

801076c5 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801076c5:	55                   	push   %ebp
801076c6:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801076c8:	8b 45 08             	mov    0x8(%ebp),%eax
801076cb:	f0 ff 00             	lock incl (%eax)
}
801076ce:	90                   	nop
801076cf:	5d                   	pop    %ebp
801076d0:	c3                   	ret    

801076d1 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801076d1:	55                   	push   %ebp
801076d2:	89 e5                	mov    %esp,%ebp
801076d4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801076d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801076da:	83 e8 01             	sub    $0x1,%eax
801076dd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076e1:	8b 45 08             	mov    0x8(%ebp),%eax
801076e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076e8:	8b 45 08             	mov    0x8(%ebp),%eax
801076eb:	c1 e8 10             	shr    $0x10,%eax
801076ee:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801076f2:	8d 45 fa             	lea    -0x6(%ebp),%eax
801076f5:	0f 01 18             	lidtl  (%eax)
}
801076f8:	90                   	nop
801076f9:	c9                   	leave  
801076fa:	c3                   	ret    

801076fb <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801076fb:	55                   	push   %ebp
801076fc:	89 e5                	mov    %esp,%ebp
801076fe:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107701:	0f 20 d0             	mov    %cr2,%eax
80107704:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107707:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010770a:	c9                   	leave  
8010770b:	c3                   	ret    

8010770c <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010770c:	55                   	push   %ebp
8010770d:	89 e5                	mov    %esp,%ebp
8010770f:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107712:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107719:	e9 c3 00 00 00       	jmp    801077e1 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010771e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107721:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80107728:	89 c2                	mov    %eax,%edx
8010772a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010772d:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
80107734:	80 
80107735:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107738:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
8010773f:	80 08 00 
80107742:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107745:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
8010774c:	80 
8010774d:	83 e2 e0             	and    $0xffffffe0,%edx
80107750:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80107757:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010775a:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80107761:	80 
80107762:	83 e2 1f             	and    $0x1f,%edx
80107765:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
8010776c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010776f:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107776:	80 
80107777:	83 e2 f0             	and    $0xfffffff0,%edx
8010777a:	83 ca 0e             	or     $0xe,%edx
8010777d:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107784:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107787:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
8010778e:	80 
8010778f:	83 e2 ef             	and    $0xffffffef,%edx
80107792:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107799:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010779c:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
801077a3:	80 
801077a4:	83 e2 9f             	and    $0xffffff9f,%edx
801077a7:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
801077ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801077b1:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
801077b8:	80 
801077b9:	83 ca 80             	or     $0xffffff80,%edx
801077bc:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
801077c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801077c6:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
801077cd:	c1 e8 10             	shr    $0x10,%eax
801077d0:	89 c2                	mov    %eax,%edx
801077d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801077d5:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
801077dc:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801077dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801077e1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801077e8:	0f 8e 30 ff ff ff    	jle    8010771e <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801077ee:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
801077f3:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
801077f9:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
80107800:	08 00 
80107802:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80107809:	83 e0 e0             	and    $0xffffffe0,%eax
8010780c:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107811:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80107818:	83 e0 1f             	and    $0x1f,%eax
8010781b:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107820:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107827:	83 c8 0f             	or     $0xf,%eax
8010782a:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010782f:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107836:	83 e0 ef             	and    $0xffffffef,%eax
80107839:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010783e:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107845:	83 c8 60             	or     $0x60,%eax
80107848:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010784d:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107854:	83 c8 80             	or     $0xffffff80,%eax
80107857:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010785c:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80107861:	c1 e8 10             	shr    $0x10,%eax
80107864:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
8010786a:	90                   	nop
8010786b:	c9                   	leave  
8010786c:	c3                   	ret    

8010786d <idtinit>:

void
idtinit(void)
{
8010786d:	55                   	push   %ebp
8010786e:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107870:	68 00 08 00 00       	push   $0x800
80107875:	68 e0 5e 11 80       	push   $0x80115ee0
8010787a:	e8 52 fe ff ff       	call   801076d1 <lidt>
8010787f:	83 c4 08             	add    $0x8,%esp
}
80107882:	90                   	nop
80107883:	c9                   	leave  
80107884:	c3                   	ret    

80107885 <trap>:

void
trap(struct trapframe *tf)
{
80107885:	55                   	push   %ebp
80107886:	89 e5                	mov    %esp,%ebp
80107888:	57                   	push   %edi
80107889:	56                   	push   %esi
8010788a:	53                   	push   %ebx
8010788b:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010788e:	8b 45 08             	mov    0x8(%ebp),%eax
80107891:	8b 40 30             	mov    0x30(%eax),%eax
80107894:	83 f8 40             	cmp    $0x40,%eax
80107897:	75 3e                	jne    801078d7 <trap+0x52>
    if(proc->killed)
80107899:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010789f:	8b 40 24             	mov    0x24(%eax),%eax
801078a2:	85 c0                	test   %eax,%eax
801078a4:	74 05                	je     801078ab <trap+0x26>
      exit();
801078a6:	e8 bc d3 ff ff       	call   80104c67 <exit>
    proc->tf = tf;
801078ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078b1:	8b 55 08             	mov    0x8(%ebp),%edx
801078b4:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801078b7:	e8 83 ec ff ff       	call   8010653f <syscall>
    if(proc->killed)
801078bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078c2:	8b 40 24             	mov    0x24(%eax),%eax
801078c5:	85 c0                	test   %eax,%eax
801078c7:	0f 84 21 02 00 00    	je     80107aee <trap+0x269>
      exit();
801078cd:	e8 95 d3 ff ff       	call   80104c67 <exit>
    return;
801078d2:	e9 17 02 00 00       	jmp    80107aee <trap+0x269>
  }

  switch(tf->trapno){
801078d7:	8b 45 08             	mov    0x8(%ebp),%eax
801078da:	8b 40 30             	mov    0x30(%eax),%eax
801078dd:	83 e8 20             	sub    $0x20,%eax
801078e0:	83 f8 1f             	cmp    $0x1f,%eax
801078e3:	0f 87 a3 00 00 00    	ja     8010798c <trap+0x107>
801078e9:	8b 04 85 44 9e 10 80 	mov    -0x7fef61bc(,%eax,4),%eax
801078f0:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801078f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801078f8:	0f b6 00             	movzbl (%eax),%eax
801078fb:	84 c0                	test   %al,%al
801078fd:	75 20                	jne    8010791f <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801078ff:	83 ec 0c             	sub    $0xc,%esp
80107902:	68 e0 66 11 80       	push   $0x801166e0
80107907:	e8 b9 fd ff ff       	call   801076c5 <atom_inc>
8010790c:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
8010790f:	83 ec 0c             	sub    $0xc,%esp
80107912:	68 e0 66 11 80       	push   $0x801166e0
80107917:	e8 95 db ff ff       	call   801054b1 <wakeup>
8010791c:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010791f:	e8 9f b7 ff ff       	call   801030c3 <lapiceoi>
    break;
80107924:	e9 1c 01 00 00       	jmp    80107a45 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107929:	e8 a8 af ff ff       	call   801028d6 <ideintr>
    lapiceoi();
8010792e:	e8 90 b7 ff ff       	call   801030c3 <lapiceoi>
    break;
80107933:	e9 0d 01 00 00       	jmp    80107a45 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107938:	e8 88 b5 ff ff       	call   80102ec5 <kbdintr>
    lapiceoi();
8010793d:	e8 81 b7 ff ff       	call   801030c3 <lapiceoi>
    break;
80107942:	e9 fe 00 00 00       	jmp    80107a45 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107947:	e8 83 03 00 00       	call   80107ccf <uartintr>
    lapiceoi();
8010794c:	e8 72 b7 ff ff       	call   801030c3 <lapiceoi>
    break;
80107951:	e9 ef 00 00 00       	jmp    80107a45 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107956:	8b 45 08             	mov    0x8(%ebp),%eax
80107959:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010795c:	8b 45 08             	mov    0x8(%ebp),%eax
8010795f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107963:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107966:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010796c:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010796f:	0f b6 c0             	movzbl %al,%eax
80107972:	51                   	push   %ecx
80107973:	52                   	push   %edx
80107974:	50                   	push   %eax
80107975:	68 a4 9d 10 80       	push   $0x80109da4
8010797a:	e8 47 8a ff ff       	call   801003c6 <cprintf>
8010797f:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107982:	e8 3c b7 ff ff       	call   801030c3 <lapiceoi>
    break;
80107987:	e9 b9 00 00 00       	jmp    80107a45 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010798c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107992:	85 c0                	test   %eax,%eax
80107994:	74 11                	je     801079a7 <trap+0x122>
80107996:	8b 45 08             	mov    0x8(%ebp),%eax
80107999:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010799d:	0f b7 c0             	movzwl %ax,%eax
801079a0:	83 e0 03             	and    $0x3,%eax
801079a3:	85 c0                	test   %eax,%eax
801079a5:	75 40                	jne    801079e7 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801079a7:	e8 4f fd ff ff       	call   801076fb <rcr2>
801079ac:	89 c3                	mov    %eax,%ebx
801079ae:	8b 45 08             	mov    0x8(%ebp),%eax
801079b1:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801079b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079ba:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801079bd:	0f b6 d0             	movzbl %al,%edx
801079c0:	8b 45 08             	mov    0x8(%ebp),%eax
801079c3:	8b 40 30             	mov    0x30(%eax),%eax
801079c6:	83 ec 0c             	sub    $0xc,%esp
801079c9:	53                   	push   %ebx
801079ca:	51                   	push   %ecx
801079cb:	52                   	push   %edx
801079cc:	50                   	push   %eax
801079cd:	68 c8 9d 10 80       	push   $0x80109dc8
801079d2:	e8 ef 89 ff ff       	call   801003c6 <cprintf>
801079d7:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	68 fa 9d 10 80       	push   $0x80109dfa
801079e2:	e8 7f 8b ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801079e7:	e8 0f fd ff ff       	call   801076fb <rcr2>
801079ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079ef:	8b 45 08             	mov    0x8(%ebp),%eax
801079f2:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801079f5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079fb:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801079fe:	0f b6 d8             	movzbl %al,%ebx
80107a01:	8b 45 08             	mov    0x8(%ebp),%eax
80107a04:	8b 48 34             	mov    0x34(%eax),%ecx
80107a07:	8b 45 08             	mov    0x8(%ebp),%eax
80107a0a:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107a0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a13:	8d 78 6c             	lea    0x6c(%eax),%edi
80107a16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a1c:	8b 40 10             	mov    0x10(%eax),%eax
80107a1f:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a22:	56                   	push   %esi
80107a23:	53                   	push   %ebx
80107a24:	51                   	push   %ecx
80107a25:	52                   	push   %edx
80107a26:	57                   	push   %edi
80107a27:	50                   	push   %eax
80107a28:	68 00 9e 10 80       	push   $0x80109e00
80107a2d:	e8 94 89 ff ff       	call   801003c6 <cprintf>
80107a32:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107a35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a3b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107a42:	eb 01                	jmp    80107a45 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107a44:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107a45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a4b:	85 c0                	test   %eax,%eax
80107a4d:	74 24                	je     80107a73 <trap+0x1ee>
80107a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a55:	8b 40 24             	mov    0x24(%eax),%eax
80107a58:	85 c0                	test   %eax,%eax
80107a5a:	74 17                	je     80107a73 <trap+0x1ee>
80107a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a5f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107a63:	0f b7 c0             	movzwl %ax,%eax
80107a66:	83 e0 03             	and    $0x3,%eax
80107a69:	83 f8 03             	cmp    $0x3,%eax
80107a6c:	75 05                	jne    80107a73 <trap+0x1ee>
    exit();
80107a6e:	e8 f4 d1 ff ff       	call   80104c67 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107a73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a79:	85 c0                	test   %eax,%eax
80107a7b:	74 41                	je     80107abe <trap+0x239>
80107a7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a83:	8b 40 0c             	mov    0xc(%eax),%eax
80107a86:	83 f8 04             	cmp    $0x4,%eax
80107a89:	75 33                	jne    80107abe <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a8e:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107a91:	83 f8 20             	cmp    $0x20,%eax
80107a94:	75 28                	jne    80107abe <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107a96:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
80107a9c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107aa1:	89 c8                	mov    %ecx,%eax
80107aa3:	f7 e2                	mul    %edx
80107aa5:	c1 ea 03             	shr    $0x3,%edx
80107aa8:	89 d0                	mov    %edx,%eax
80107aaa:	c1 e0 02             	shl    $0x2,%eax
80107aad:	01 d0                	add    %edx,%eax
80107aaf:	01 c0                	add    %eax,%eax
80107ab1:	29 c1                	sub    %eax,%ecx
80107ab3:	89 ca                	mov    %ecx,%edx
80107ab5:	85 d2                	test   %edx,%edx
80107ab7:	75 05                	jne    80107abe <trap+0x239>
    yield();
80107ab9:	e8 5a d7 ff ff       	call   80105218 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ac4:	85 c0                	test   %eax,%eax
80107ac6:	74 27                	je     80107aef <trap+0x26a>
80107ac8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ace:	8b 40 24             	mov    0x24(%eax),%eax
80107ad1:	85 c0                	test   %eax,%eax
80107ad3:	74 1a                	je     80107aef <trap+0x26a>
80107ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107adc:	0f b7 c0             	movzwl %ax,%eax
80107adf:	83 e0 03             	and    $0x3,%eax
80107ae2:	83 f8 03             	cmp    $0x3,%eax
80107ae5:	75 08                	jne    80107aef <trap+0x26a>
    exit();
80107ae7:	e8 7b d1 ff ff       	call   80104c67 <exit>
80107aec:	eb 01                	jmp    80107aef <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107aee:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107af2:	5b                   	pop    %ebx
80107af3:	5e                   	pop    %esi
80107af4:	5f                   	pop    %edi
80107af5:	5d                   	pop    %ebp
80107af6:	c3                   	ret    

80107af7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107af7:	55                   	push   %ebp
80107af8:	89 e5                	mov    %esp,%ebp
80107afa:	83 ec 14             	sub    $0x14,%esp
80107afd:	8b 45 08             	mov    0x8(%ebp),%eax
80107b00:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107b04:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107b08:	89 c2                	mov    %eax,%edx
80107b0a:	ec                   	in     (%dx),%al
80107b0b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107b0e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107b12:	c9                   	leave  
80107b13:	c3                   	ret    

80107b14 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107b14:	55                   	push   %ebp
80107b15:	89 e5                	mov    %esp,%ebp
80107b17:	83 ec 08             	sub    $0x8,%esp
80107b1a:	8b 55 08             	mov    0x8(%ebp),%edx
80107b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b20:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107b24:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107b27:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107b2b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107b2f:	ee                   	out    %al,(%dx)
}
80107b30:	90                   	nop
80107b31:	c9                   	leave  
80107b32:	c3                   	ret    

80107b33 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107b33:	55                   	push   %ebp
80107b34:	89 e5                	mov    %esp,%ebp
80107b36:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107b39:	6a 00                	push   $0x0
80107b3b:	68 fa 03 00 00       	push   $0x3fa
80107b40:	e8 cf ff ff ff       	call   80107b14 <outb>
80107b45:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107b48:	68 80 00 00 00       	push   $0x80
80107b4d:	68 fb 03 00 00       	push   $0x3fb
80107b52:	e8 bd ff ff ff       	call   80107b14 <outb>
80107b57:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107b5a:	6a 0c                	push   $0xc
80107b5c:	68 f8 03 00 00       	push   $0x3f8
80107b61:	e8 ae ff ff ff       	call   80107b14 <outb>
80107b66:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107b69:	6a 00                	push   $0x0
80107b6b:	68 f9 03 00 00       	push   $0x3f9
80107b70:	e8 9f ff ff ff       	call   80107b14 <outb>
80107b75:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107b78:	6a 03                	push   $0x3
80107b7a:	68 fb 03 00 00       	push   $0x3fb
80107b7f:	e8 90 ff ff ff       	call   80107b14 <outb>
80107b84:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107b87:	6a 00                	push   $0x0
80107b89:	68 fc 03 00 00       	push   $0x3fc
80107b8e:	e8 81 ff ff ff       	call   80107b14 <outb>
80107b93:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107b96:	6a 01                	push   $0x1
80107b98:	68 f9 03 00 00       	push   $0x3f9
80107b9d:	e8 72 ff ff ff       	call   80107b14 <outb>
80107ba2:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107ba5:	68 fd 03 00 00       	push   $0x3fd
80107baa:	e8 48 ff ff ff       	call   80107af7 <inb>
80107baf:	83 c4 04             	add    $0x4,%esp
80107bb2:	3c ff                	cmp    $0xff,%al
80107bb4:	74 6e                	je     80107c24 <uartinit+0xf1>
    return;
  uart = 1;
80107bb6:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107bbd:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107bc0:	68 fa 03 00 00       	push   $0x3fa
80107bc5:	e8 2d ff ff ff       	call   80107af7 <inb>
80107bca:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107bcd:	68 f8 03 00 00       	push   $0x3f8
80107bd2:	e8 20 ff ff ff       	call   80107af7 <inb>
80107bd7:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107bda:	83 ec 0c             	sub    $0xc,%esp
80107bdd:	6a 04                	push   $0x4
80107bdf:	e8 e5 c3 ff ff       	call   80103fc9 <picenable>
80107be4:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107be7:	83 ec 08             	sub    $0x8,%esp
80107bea:	6a 00                	push   $0x0
80107bec:	6a 04                	push   $0x4
80107bee:	e8 85 af ff ff       	call   80102b78 <ioapicenable>
80107bf3:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107bf6:	c7 45 f4 c4 9e 10 80 	movl   $0x80109ec4,-0xc(%ebp)
80107bfd:	eb 19                	jmp    80107c18 <uartinit+0xe5>
    uartputc(*p);
80107bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c02:	0f b6 00             	movzbl (%eax),%eax
80107c05:	0f be c0             	movsbl %al,%eax
80107c08:	83 ec 0c             	sub    $0xc,%esp
80107c0b:	50                   	push   %eax
80107c0c:	e8 16 00 00 00       	call   80107c27 <uartputc>
80107c11:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107c14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1b:	0f b6 00             	movzbl (%eax),%eax
80107c1e:	84 c0                	test   %al,%al
80107c20:	75 dd                	jne    80107bff <uartinit+0xcc>
80107c22:	eb 01                	jmp    80107c25 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107c24:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107c25:	c9                   	leave  
80107c26:	c3                   	ret    

80107c27 <uartputc>:

void
uartputc(int c)
{
80107c27:	55                   	push   %ebp
80107c28:	89 e5                	mov    %esp,%ebp
80107c2a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107c2d:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107c32:	85 c0                	test   %eax,%eax
80107c34:	74 53                	je     80107c89 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c3d:	eb 11                	jmp    80107c50 <uartputc+0x29>
    microdelay(10);
80107c3f:	83 ec 0c             	sub    $0xc,%esp
80107c42:	6a 0a                	push   $0xa
80107c44:	e8 95 b4 ff ff       	call   801030de <microdelay>
80107c49:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107c4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107c50:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107c54:	7f 1a                	jg     80107c70 <uartputc+0x49>
80107c56:	83 ec 0c             	sub    $0xc,%esp
80107c59:	68 fd 03 00 00       	push   $0x3fd
80107c5e:	e8 94 fe ff ff       	call   80107af7 <inb>
80107c63:	83 c4 10             	add    $0x10,%esp
80107c66:	0f b6 c0             	movzbl %al,%eax
80107c69:	83 e0 20             	and    $0x20,%eax
80107c6c:	85 c0                	test   %eax,%eax
80107c6e:	74 cf                	je     80107c3f <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107c70:	8b 45 08             	mov    0x8(%ebp),%eax
80107c73:	0f b6 c0             	movzbl %al,%eax
80107c76:	83 ec 08             	sub    $0x8,%esp
80107c79:	50                   	push   %eax
80107c7a:	68 f8 03 00 00       	push   $0x3f8
80107c7f:	e8 90 fe ff ff       	call   80107b14 <outb>
80107c84:	83 c4 10             	add    $0x10,%esp
80107c87:	eb 01                	jmp    80107c8a <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107c89:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107c8a:	c9                   	leave  
80107c8b:	c3                   	ret    

80107c8c <uartgetc>:

static int
uartgetc(void)
{
80107c8c:	55                   	push   %ebp
80107c8d:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107c8f:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107c94:	85 c0                	test   %eax,%eax
80107c96:	75 07                	jne    80107c9f <uartgetc+0x13>
    return -1;
80107c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c9d:	eb 2e                	jmp    80107ccd <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107c9f:	68 fd 03 00 00       	push   $0x3fd
80107ca4:	e8 4e fe ff ff       	call   80107af7 <inb>
80107ca9:	83 c4 04             	add    $0x4,%esp
80107cac:	0f b6 c0             	movzbl %al,%eax
80107caf:	83 e0 01             	and    $0x1,%eax
80107cb2:	85 c0                	test   %eax,%eax
80107cb4:	75 07                	jne    80107cbd <uartgetc+0x31>
    return -1;
80107cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cbb:	eb 10                	jmp    80107ccd <uartgetc+0x41>
  return inb(COM1+0);
80107cbd:	68 f8 03 00 00       	push   $0x3f8
80107cc2:	e8 30 fe ff ff       	call   80107af7 <inb>
80107cc7:	83 c4 04             	add    $0x4,%esp
80107cca:	0f b6 c0             	movzbl %al,%eax
}
80107ccd:	c9                   	leave  
80107cce:	c3                   	ret    

80107ccf <uartintr>:

void
uartintr(void)
{
80107ccf:	55                   	push   %ebp
80107cd0:	89 e5                	mov    %esp,%ebp
80107cd2:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107cd5:	83 ec 0c             	sub    $0xc,%esp
80107cd8:	68 8c 7c 10 80       	push   $0x80107c8c
80107cdd:	e8 17 8b ff ff       	call   801007f9 <consoleintr>
80107ce2:	83 c4 10             	add    $0x10,%esp
}
80107ce5:	90                   	nop
80107ce6:	c9                   	leave  
80107ce7:	c3                   	ret    

80107ce8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107ce8:	6a 00                	push   $0x0
  pushl $0
80107cea:	6a 00                	push   $0x0
  jmp alltraps
80107cec:	e9 a9 f9 ff ff       	jmp    8010769a <alltraps>

80107cf1 <vector1>:
.globl vector1
vector1:
  pushl $0
80107cf1:	6a 00                	push   $0x0
  pushl $1
80107cf3:	6a 01                	push   $0x1
  jmp alltraps
80107cf5:	e9 a0 f9 ff ff       	jmp    8010769a <alltraps>

80107cfa <vector2>:
.globl vector2
vector2:
  pushl $0
80107cfa:	6a 00                	push   $0x0
  pushl $2
80107cfc:	6a 02                	push   $0x2
  jmp alltraps
80107cfe:	e9 97 f9 ff ff       	jmp    8010769a <alltraps>

80107d03 <vector3>:
.globl vector3
vector3:
  pushl $0
80107d03:	6a 00                	push   $0x0
  pushl $3
80107d05:	6a 03                	push   $0x3
  jmp alltraps
80107d07:	e9 8e f9 ff ff       	jmp    8010769a <alltraps>

80107d0c <vector4>:
.globl vector4
vector4:
  pushl $0
80107d0c:	6a 00                	push   $0x0
  pushl $4
80107d0e:	6a 04                	push   $0x4
  jmp alltraps
80107d10:	e9 85 f9 ff ff       	jmp    8010769a <alltraps>

80107d15 <vector5>:
.globl vector5
vector5:
  pushl $0
80107d15:	6a 00                	push   $0x0
  pushl $5
80107d17:	6a 05                	push   $0x5
  jmp alltraps
80107d19:	e9 7c f9 ff ff       	jmp    8010769a <alltraps>

80107d1e <vector6>:
.globl vector6
vector6:
  pushl $0
80107d1e:	6a 00                	push   $0x0
  pushl $6
80107d20:	6a 06                	push   $0x6
  jmp alltraps
80107d22:	e9 73 f9 ff ff       	jmp    8010769a <alltraps>

80107d27 <vector7>:
.globl vector7
vector7:
  pushl $0
80107d27:	6a 00                	push   $0x0
  pushl $7
80107d29:	6a 07                	push   $0x7
  jmp alltraps
80107d2b:	e9 6a f9 ff ff       	jmp    8010769a <alltraps>

80107d30 <vector8>:
.globl vector8
vector8:
  pushl $8
80107d30:	6a 08                	push   $0x8
  jmp alltraps
80107d32:	e9 63 f9 ff ff       	jmp    8010769a <alltraps>

80107d37 <vector9>:
.globl vector9
vector9:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $9
80107d39:	6a 09                	push   $0x9
  jmp alltraps
80107d3b:	e9 5a f9 ff ff       	jmp    8010769a <alltraps>

80107d40 <vector10>:
.globl vector10
vector10:
  pushl $10
80107d40:	6a 0a                	push   $0xa
  jmp alltraps
80107d42:	e9 53 f9 ff ff       	jmp    8010769a <alltraps>

80107d47 <vector11>:
.globl vector11
vector11:
  pushl $11
80107d47:	6a 0b                	push   $0xb
  jmp alltraps
80107d49:	e9 4c f9 ff ff       	jmp    8010769a <alltraps>

80107d4e <vector12>:
.globl vector12
vector12:
  pushl $12
80107d4e:	6a 0c                	push   $0xc
  jmp alltraps
80107d50:	e9 45 f9 ff ff       	jmp    8010769a <alltraps>

80107d55 <vector13>:
.globl vector13
vector13:
  pushl $13
80107d55:	6a 0d                	push   $0xd
  jmp alltraps
80107d57:	e9 3e f9 ff ff       	jmp    8010769a <alltraps>

80107d5c <vector14>:
.globl vector14
vector14:
  pushl $14
80107d5c:	6a 0e                	push   $0xe
  jmp alltraps
80107d5e:	e9 37 f9 ff ff       	jmp    8010769a <alltraps>

80107d63 <vector15>:
.globl vector15
vector15:
  pushl $0
80107d63:	6a 00                	push   $0x0
  pushl $15
80107d65:	6a 0f                	push   $0xf
  jmp alltraps
80107d67:	e9 2e f9 ff ff       	jmp    8010769a <alltraps>

80107d6c <vector16>:
.globl vector16
vector16:
  pushl $0
80107d6c:	6a 00                	push   $0x0
  pushl $16
80107d6e:	6a 10                	push   $0x10
  jmp alltraps
80107d70:	e9 25 f9 ff ff       	jmp    8010769a <alltraps>

80107d75 <vector17>:
.globl vector17
vector17:
  pushl $17
80107d75:	6a 11                	push   $0x11
  jmp alltraps
80107d77:	e9 1e f9 ff ff       	jmp    8010769a <alltraps>

80107d7c <vector18>:
.globl vector18
vector18:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $18
80107d7e:	6a 12                	push   $0x12
  jmp alltraps
80107d80:	e9 15 f9 ff ff       	jmp    8010769a <alltraps>

80107d85 <vector19>:
.globl vector19
vector19:
  pushl $0
80107d85:	6a 00                	push   $0x0
  pushl $19
80107d87:	6a 13                	push   $0x13
  jmp alltraps
80107d89:	e9 0c f9 ff ff       	jmp    8010769a <alltraps>

80107d8e <vector20>:
.globl vector20
vector20:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $20
80107d90:	6a 14                	push   $0x14
  jmp alltraps
80107d92:	e9 03 f9 ff ff       	jmp    8010769a <alltraps>

80107d97 <vector21>:
.globl vector21
vector21:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $21
80107d99:	6a 15                	push   $0x15
  jmp alltraps
80107d9b:	e9 fa f8 ff ff       	jmp    8010769a <alltraps>

80107da0 <vector22>:
.globl vector22
vector22:
  pushl $0
80107da0:	6a 00                	push   $0x0
  pushl $22
80107da2:	6a 16                	push   $0x16
  jmp alltraps
80107da4:	e9 f1 f8 ff ff       	jmp    8010769a <alltraps>

80107da9 <vector23>:
.globl vector23
vector23:
  pushl $0
80107da9:	6a 00                	push   $0x0
  pushl $23
80107dab:	6a 17                	push   $0x17
  jmp alltraps
80107dad:	e9 e8 f8 ff ff       	jmp    8010769a <alltraps>

80107db2 <vector24>:
.globl vector24
vector24:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $24
80107db4:	6a 18                	push   $0x18
  jmp alltraps
80107db6:	e9 df f8 ff ff       	jmp    8010769a <alltraps>

80107dbb <vector25>:
.globl vector25
vector25:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $25
80107dbd:	6a 19                	push   $0x19
  jmp alltraps
80107dbf:	e9 d6 f8 ff ff       	jmp    8010769a <alltraps>

80107dc4 <vector26>:
.globl vector26
vector26:
  pushl $0
80107dc4:	6a 00                	push   $0x0
  pushl $26
80107dc6:	6a 1a                	push   $0x1a
  jmp alltraps
80107dc8:	e9 cd f8 ff ff       	jmp    8010769a <alltraps>

80107dcd <vector27>:
.globl vector27
vector27:
  pushl $0
80107dcd:	6a 00                	push   $0x0
  pushl $27
80107dcf:	6a 1b                	push   $0x1b
  jmp alltraps
80107dd1:	e9 c4 f8 ff ff       	jmp    8010769a <alltraps>

80107dd6 <vector28>:
.globl vector28
vector28:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $28
80107dd8:	6a 1c                	push   $0x1c
  jmp alltraps
80107dda:	e9 bb f8 ff ff       	jmp    8010769a <alltraps>

80107ddf <vector29>:
.globl vector29
vector29:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $29
80107de1:	6a 1d                	push   $0x1d
  jmp alltraps
80107de3:	e9 b2 f8 ff ff       	jmp    8010769a <alltraps>

80107de8 <vector30>:
.globl vector30
vector30:
  pushl $0
80107de8:	6a 00                	push   $0x0
  pushl $30
80107dea:	6a 1e                	push   $0x1e
  jmp alltraps
80107dec:	e9 a9 f8 ff ff       	jmp    8010769a <alltraps>

80107df1 <vector31>:
.globl vector31
vector31:
  pushl $0
80107df1:	6a 00                	push   $0x0
  pushl $31
80107df3:	6a 1f                	push   $0x1f
  jmp alltraps
80107df5:	e9 a0 f8 ff ff       	jmp    8010769a <alltraps>

80107dfa <vector32>:
.globl vector32
vector32:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $32
80107dfc:	6a 20                	push   $0x20
  jmp alltraps
80107dfe:	e9 97 f8 ff ff       	jmp    8010769a <alltraps>

80107e03 <vector33>:
.globl vector33
vector33:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $33
80107e05:	6a 21                	push   $0x21
  jmp alltraps
80107e07:	e9 8e f8 ff ff       	jmp    8010769a <alltraps>

80107e0c <vector34>:
.globl vector34
vector34:
  pushl $0
80107e0c:	6a 00                	push   $0x0
  pushl $34
80107e0e:	6a 22                	push   $0x22
  jmp alltraps
80107e10:	e9 85 f8 ff ff       	jmp    8010769a <alltraps>

80107e15 <vector35>:
.globl vector35
vector35:
  pushl $0
80107e15:	6a 00                	push   $0x0
  pushl $35
80107e17:	6a 23                	push   $0x23
  jmp alltraps
80107e19:	e9 7c f8 ff ff       	jmp    8010769a <alltraps>

80107e1e <vector36>:
.globl vector36
vector36:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $36
80107e20:	6a 24                	push   $0x24
  jmp alltraps
80107e22:	e9 73 f8 ff ff       	jmp    8010769a <alltraps>

80107e27 <vector37>:
.globl vector37
vector37:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $37
80107e29:	6a 25                	push   $0x25
  jmp alltraps
80107e2b:	e9 6a f8 ff ff       	jmp    8010769a <alltraps>

80107e30 <vector38>:
.globl vector38
vector38:
  pushl $0
80107e30:	6a 00                	push   $0x0
  pushl $38
80107e32:	6a 26                	push   $0x26
  jmp alltraps
80107e34:	e9 61 f8 ff ff       	jmp    8010769a <alltraps>

80107e39 <vector39>:
.globl vector39
vector39:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $39
80107e3b:	6a 27                	push   $0x27
  jmp alltraps
80107e3d:	e9 58 f8 ff ff       	jmp    8010769a <alltraps>

80107e42 <vector40>:
.globl vector40
vector40:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $40
80107e44:	6a 28                	push   $0x28
  jmp alltraps
80107e46:	e9 4f f8 ff ff       	jmp    8010769a <alltraps>

80107e4b <vector41>:
.globl vector41
vector41:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $41
80107e4d:	6a 29                	push   $0x29
  jmp alltraps
80107e4f:	e9 46 f8 ff ff       	jmp    8010769a <alltraps>

80107e54 <vector42>:
.globl vector42
vector42:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $42
80107e56:	6a 2a                	push   $0x2a
  jmp alltraps
80107e58:	e9 3d f8 ff ff       	jmp    8010769a <alltraps>

80107e5d <vector43>:
.globl vector43
vector43:
  pushl $0
80107e5d:	6a 00                	push   $0x0
  pushl $43
80107e5f:	6a 2b                	push   $0x2b
  jmp alltraps
80107e61:	e9 34 f8 ff ff       	jmp    8010769a <alltraps>

80107e66 <vector44>:
.globl vector44
vector44:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $44
80107e68:	6a 2c                	push   $0x2c
  jmp alltraps
80107e6a:	e9 2b f8 ff ff       	jmp    8010769a <alltraps>

80107e6f <vector45>:
.globl vector45
vector45:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $45
80107e71:	6a 2d                	push   $0x2d
  jmp alltraps
80107e73:	e9 22 f8 ff ff       	jmp    8010769a <alltraps>

80107e78 <vector46>:
.globl vector46
vector46:
  pushl $0
80107e78:	6a 00                	push   $0x0
  pushl $46
80107e7a:	6a 2e                	push   $0x2e
  jmp alltraps
80107e7c:	e9 19 f8 ff ff       	jmp    8010769a <alltraps>

80107e81 <vector47>:
.globl vector47
vector47:
  pushl $0
80107e81:	6a 00                	push   $0x0
  pushl $47
80107e83:	6a 2f                	push   $0x2f
  jmp alltraps
80107e85:	e9 10 f8 ff ff       	jmp    8010769a <alltraps>

80107e8a <vector48>:
.globl vector48
vector48:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $48
80107e8c:	6a 30                	push   $0x30
  jmp alltraps
80107e8e:	e9 07 f8 ff ff       	jmp    8010769a <alltraps>

80107e93 <vector49>:
.globl vector49
vector49:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $49
80107e95:	6a 31                	push   $0x31
  jmp alltraps
80107e97:	e9 fe f7 ff ff       	jmp    8010769a <alltraps>

80107e9c <vector50>:
.globl vector50
vector50:
  pushl $0
80107e9c:	6a 00                	push   $0x0
  pushl $50
80107e9e:	6a 32                	push   $0x32
  jmp alltraps
80107ea0:	e9 f5 f7 ff ff       	jmp    8010769a <alltraps>

80107ea5 <vector51>:
.globl vector51
vector51:
  pushl $0
80107ea5:	6a 00                	push   $0x0
  pushl $51
80107ea7:	6a 33                	push   $0x33
  jmp alltraps
80107ea9:	e9 ec f7 ff ff       	jmp    8010769a <alltraps>

80107eae <vector52>:
.globl vector52
vector52:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $52
80107eb0:	6a 34                	push   $0x34
  jmp alltraps
80107eb2:	e9 e3 f7 ff ff       	jmp    8010769a <alltraps>

80107eb7 <vector53>:
.globl vector53
vector53:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $53
80107eb9:	6a 35                	push   $0x35
  jmp alltraps
80107ebb:	e9 da f7 ff ff       	jmp    8010769a <alltraps>

80107ec0 <vector54>:
.globl vector54
vector54:
  pushl $0
80107ec0:	6a 00                	push   $0x0
  pushl $54
80107ec2:	6a 36                	push   $0x36
  jmp alltraps
80107ec4:	e9 d1 f7 ff ff       	jmp    8010769a <alltraps>

80107ec9 <vector55>:
.globl vector55
vector55:
  pushl $0
80107ec9:	6a 00                	push   $0x0
  pushl $55
80107ecb:	6a 37                	push   $0x37
  jmp alltraps
80107ecd:	e9 c8 f7 ff ff       	jmp    8010769a <alltraps>

80107ed2 <vector56>:
.globl vector56
vector56:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $56
80107ed4:	6a 38                	push   $0x38
  jmp alltraps
80107ed6:	e9 bf f7 ff ff       	jmp    8010769a <alltraps>

80107edb <vector57>:
.globl vector57
vector57:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $57
80107edd:	6a 39                	push   $0x39
  jmp alltraps
80107edf:	e9 b6 f7 ff ff       	jmp    8010769a <alltraps>

80107ee4 <vector58>:
.globl vector58
vector58:
  pushl $0
80107ee4:	6a 00                	push   $0x0
  pushl $58
80107ee6:	6a 3a                	push   $0x3a
  jmp alltraps
80107ee8:	e9 ad f7 ff ff       	jmp    8010769a <alltraps>

80107eed <vector59>:
.globl vector59
vector59:
  pushl $0
80107eed:	6a 00                	push   $0x0
  pushl $59
80107eef:	6a 3b                	push   $0x3b
  jmp alltraps
80107ef1:	e9 a4 f7 ff ff       	jmp    8010769a <alltraps>

80107ef6 <vector60>:
.globl vector60
vector60:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $60
80107ef8:	6a 3c                	push   $0x3c
  jmp alltraps
80107efa:	e9 9b f7 ff ff       	jmp    8010769a <alltraps>

80107eff <vector61>:
.globl vector61
vector61:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $61
80107f01:	6a 3d                	push   $0x3d
  jmp alltraps
80107f03:	e9 92 f7 ff ff       	jmp    8010769a <alltraps>

80107f08 <vector62>:
.globl vector62
vector62:
  pushl $0
80107f08:	6a 00                	push   $0x0
  pushl $62
80107f0a:	6a 3e                	push   $0x3e
  jmp alltraps
80107f0c:	e9 89 f7 ff ff       	jmp    8010769a <alltraps>

80107f11 <vector63>:
.globl vector63
vector63:
  pushl $0
80107f11:	6a 00                	push   $0x0
  pushl $63
80107f13:	6a 3f                	push   $0x3f
  jmp alltraps
80107f15:	e9 80 f7 ff ff       	jmp    8010769a <alltraps>

80107f1a <vector64>:
.globl vector64
vector64:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $64
80107f1c:	6a 40                	push   $0x40
  jmp alltraps
80107f1e:	e9 77 f7 ff ff       	jmp    8010769a <alltraps>

80107f23 <vector65>:
.globl vector65
vector65:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $65
80107f25:	6a 41                	push   $0x41
  jmp alltraps
80107f27:	e9 6e f7 ff ff       	jmp    8010769a <alltraps>

80107f2c <vector66>:
.globl vector66
vector66:
  pushl $0
80107f2c:	6a 00                	push   $0x0
  pushl $66
80107f2e:	6a 42                	push   $0x42
  jmp alltraps
80107f30:	e9 65 f7 ff ff       	jmp    8010769a <alltraps>

80107f35 <vector67>:
.globl vector67
vector67:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $67
80107f37:	6a 43                	push   $0x43
  jmp alltraps
80107f39:	e9 5c f7 ff ff       	jmp    8010769a <alltraps>

80107f3e <vector68>:
.globl vector68
vector68:
  pushl $0
80107f3e:	6a 00                	push   $0x0
  pushl $68
80107f40:	6a 44                	push   $0x44
  jmp alltraps
80107f42:	e9 53 f7 ff ff       	jmp    8010769a <alltraps>

80107f47 <vector69>:
.globl vector69
vector69:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $69
80107f49:	6a 45                	push   $0x45
  jmp alltraps
80107f4b:	e9 4a f7 ff ff       	jmp    8010769a <alltraps>

80107f50 <vector70>:
.globl vector70
vector70:
  pushl $0
80107f50:	6a 00                	push   $0x0
  pushl $70
80107f52:	6a 46                	push   $0x46
  jmp alltraps
80107f54:	e9 41 f7 ff ff       	jmp    8010769a <alltraps>

80107f59 <vector71>:
.globl vector71
vector71:
  pushl $0
80107f59:	6a 00                	push   $0x0
  pushl $71
80107f5b:	6a 47                	push   $0x47
  jmp alltraps
80107f5d:	e9 38 f7 ff ff       	jmp    8010769a <alltraps>

80107f62 <vector72>:
.globl vector72
vector72:
  pushl $0
80107f62:	6a 00                	push   $0x0
  pushl $72
80107f64:	6a 48                	push   $0x48
  jmp alltraps
80107f66:	e9 2f f7 ff ff       	jmp    8010769a <alltraps>

80107f6b <vector73>:
.globl vector73
vector73:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $73
80107f6d:	6a 49                	push   $0x49
  jmp alltraps
80107f6f:	e9 26 f7 ff ff       	jmp    8010769a <alltraps>

80107f74 <vector74>:
.globl vector74
vector74:
  pushl $0
80107f74:	6a 00                	push   $0x0
  pushl $74
80107f76:	6a 4a                	push   $0x4a
  jmp alltraps
80107f78:	e9 1d f7 ff ff       	jmp    8010769a <alltraps>

80107f7d <vector75>:
.globl vector75
vector75:
  pushl $0
80107f7d:	6a 00                	push   $0x0
  pushl $75
80107f7f:	6a 4b                	push   $0x4b
  jmp alltraps
80107f81:	e9 14 f7 ff ff       	jmp    8010769a <alltraps>

80107f86 <vector76>:
.globl vector76
vector76:
  pushl $0
80107f86:	6a 00                	push   $0x0
  pushl $76
80107f88:	6a 4c                	push   $0x4c
  jmp alltraps
80107f8a:	e9 0b f7 ff ff       	jmp    8010769a <alltraps>

80107f8f <vector77>:
.globl vector77
vector77:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $77
80107f91:	6a 4d                	push   $0x4d
  jmp alltraps
80107f93:	e9 02 f7 ff ff       	jmp    8010769a <alltraps>

80107f98 <vector78>:
.globl vector78
vector78:
  pushl $0
80107f98:	6a 00                	push   $0x0
  pushl $78
80107f9a:	6a 4e                	push   $0x4e
  jmp alltraps
80107f9c:	e9 f9 f6 ff ff       	jmp    8010769a <alltraps>

80107fa1 <vector79>:
.globl vector79
vector79:
  pushl $0
80107fa1:	6a 00                	push   $0x0
  pushl $79
80107fa3:	6a 4f                	push   $0x4f
  jmp alltraps
80107fa5:	e9 f0 f6 ff ff       	jmp    8010769a <alltraps>

80107faa <vector80>:
.globl vector80
vector80:
  pushl $0
80107faa:	6a 00                	push   $0x0
  pushl $80
80107fac:	6a 50                	push   $0x50
  jmp alltraps
80107fae:	e9 e7 f6 ff ff       	jmp    8010769a <alltraps>

80107fb3 <vector81>:
.globl vector81
vector81:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $81
80107fb5:	6a 51                	push   $0x51
  jmp alltraps
80107fb7:	e9 de f6 ff ff       	jmp    8010769a <alltraps>

80107fbc <vector82>:
.globl vector82
vector82:
  pushl $0
80107fbc:	6a 00                	push   $0x0
  pushl $82
80107fbe:	6a 52                	push   $0x52
  jmp alltraps
80107fc0:	e9 d5 f6 ff ff       	jmp    8010769a <alltraps>

80107fc5 <vector83>:
.globl vector83
vector83:
  pushl $0
80107fc5:	6a 00                	push   $0x0
  pushl $83
80107fc7:	6a 53                	push   $0x53
  jmp alltraps
80107fc9:	e9 cc f6 ff ff       	jmp    8010769a <alltraps>

80107fce <vector84>:
.globl vector84
vector84:
  pushl $0
80107fce:	6a 00                	push   $0x0
  pushl $84
80107fd0:	6a 54                	push   $0x54
  jmp alltraps
80107fd2:	e9 c3 f6 ff ff       	jmp    8010769a <alltraps>

80107fd7 <vector85>:
.globl vector85
vector85:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $85
80107fd9:	6a 55                	push   $0x55
  jmp alltraps
80107fdb:	e9 ba f6 ff ff       	jmp    8010769a <alltraps>

80107fe0 <vector86>:
.globl vector86
vector86:
  pushl $0
80107fe0:	6a 00                	push   $0x0
  pushl $86
80107fe2:	6a 56                	push   $0x56
  jmp alltraps
80107fe4:	e9 b1 f6 ff ff       	jmp    8010769a <alltraps>

80107fe9 <vector87>:
.globl vector87
vector87:
  pushl $0
80107fe9:	6a 00                	push   $0x0
  pushl $87
80107feb:	6a 57                	push   $0x57
  jmp alltraps
80107fed:	e9 a8 f6 ff ff       	jmp    8010769a <alltraps>

80107ff2 <vector88>:
.globl vector88
vector88:
  pushl $0
80107ff2:	6a 00                	push   $0x0
  pushl $88
80107ff4:	6a 58                	push   $0x58
  jmp alltraps
80107ff6:	e9 9f f6 ff ff       	jmp    8010769a <alltraps>

80107ffb <vector89>:
.globl vector89
vector89:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $89
80107ffd:	6a 59                	push   $0x59
  jmp alltraps
80107fff:	e9 96 f6 ff ff       	jmp    8010769a <alltraps>

80108004 <vector90>:
.globl vector90
vector90:
  pushl $0
80108004:	6a 00                	push   $0x0
  pushl $90
80108006:	6a 5a                	push   $0x5a
  jmp alltraps
80108008:	e9 8d f6 ff ff       	jmp    8010769a <alltraps>

8010800d <vector91>:
.globl vector91
vector91:
  pushl $0
8010800d:	6a 00                	push   $0x0
  pushl $91
8010800f:	6a 5b                	push   $0x5b
  jmp alltraps
80108011:	e9 84 f6 ff ff       	jmp    8010769a <alltraps>

80108016 <vector92>:
.globl vector92
vector92:
  pushl $0
80108016:	6a 00                	push   $0x0
  pushl $92
80108018:	6a 5c                	push   $0x5c
  jmp alltraps
8010801a:	e9 7b f6 ff ff       	jmp    8010769a <alltraps>

8010801f <vector93>:
.globl vector93
vector93:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $93
80108021:	6a 5d                	push   $0x5d
  jmp alltraps
80108023:	e9 72 f6 ff ff       	jmp    8010769a <alltraps>

80108028 <vector94>:
.globl vector94
vector94:
  pushl $0
80108028:	6a 00                	push   $0x0
  pushl $94
8010802a:	6a 5e                	push   $0x5e
  jmp alltraps
8010802c:	e9 69 f6 ff ff       	jmp    8010769a <alltraps>

80108031 <vector95>:
.globl vector95
vector95:
  pushl $0
80108031:	6a 00                	push   $0x0
  pushl $95
80108033:	6a 5f                	push   $0x5f
  jmp alltraps
80108035:	e9 60 f6 ff ff       	jmp    8010769a <alltraps>

8010803a <vector96>:
.globl vector96
vector96:
  pushl $0
8010803a:	6a 00                	push   $0x0
  pushl $96
8010803c:	6a 60                	push   $0x60
  jmp alltraps
8010803e:	e9 57 f6 ff ff       	jmp    8010769a <alltraps>

80108043 <vector97>:
.globl vector97
vector97:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $97
80108045:	6a 61                	push   $0x61
  jmp alltraps
80108047:	e9 4e f6 ff ff       	jmp    8010769a <alltraps>

8010804c <vector98>:
.globl vector98
vector98:
  pushl $0
8010804c:	6a 00                	push   $0x0
  pushl $98
8010804e:	6a 62                	push   $0x62
  jmp alltraps
80108050:	e9 45 f6 ff ff       	jmp    8010769a <alltraps>

80108055 <vector99>:
.globl vector99
vector99:
  pushl $0
80108055:	6a 00                	push   $0x0
  pushl $99
80108057:	6a 63                	push   $0x63
  jmp alltraps
80108059:	e9 3c f6 ff ff       	jmp    8010769a <alltraps>

8010805e <vector100>:
.globl vector100
vector100:
  pushl $0
8010805e:	6a 00                	push   $0x0
  pushl $100
80108060:	6a 64                	push   $0x64
  jmp alltraps
80108062:	e9 33 f6 ff ff       	jmp    8010769a <alltraps>

80108067 <vector101>:
.globl vector101
vector101:
  pushl $0
80108067:	6a 00                	push   $0x0
  pushl $101
80108069:	6a 65                	push   $0x65
  jmp alltraps
8010806b:	e9 2a f6 ff ff       	jmp    8010769a <alltraps>

80108070 <vector102>:
.globl vector102
vector102:
  pushl $0
80108070:	6a 00                	push   $0x0
  pushl $102
80108072:	6a 66                	push   $0x66
  jmp alltraps
80108074:	e9 21 f6 ff ff       	jmp    8010769a <alltraps>

80108079 <vector103>:
.globl vector103
vector103:
  pushl $0
80108079:	6a 00                	push   $0x0
  pushl $103
8010807b:	6a 67                	push   $0x67
  jmp alltraps
8010807d:	e9 18 f6 ff ff       	jmp    8010769a <alltraps>

80108082 <vector104>:
.globl vector104
vector104:
  pushl $0
80108082:	6a 00                	push   $0x0
  pushl $104
80108084:	6a 68                	push   $0x68
  jmp alltraps
80108086:	e9 0f f6 ff ff       	jmp    8010769a <alltraps>

8010808b <vector105>:
.globl vector105
vector105:
  pushl $0
8010808b:	6a 00                	push   $0x0
  pushl $105
8010808d:	6a 69                	push   $0x69
  jmp alltraps
8010808f:	e9 06 f6 ff ff       	jmp    8010769a <alltraps>

80108094 <vector106>:
.globl vector106
vector106:
  pushl $0
80108094:	6a 00                	push   $0x0
  pushl $106
80108096:	6a 6a                	push   $0x6a
  jmp alltraps
80108098:	e9 fd f5 ff ff       	jmp    8010769a <alltraps>

8010809d <vector107>:
.globl vector107
vector107:
  pushl $0
8010809d:	6a 00                	push   $0x0
  pushl $107
8010809f:	6a 6b                	push   $0x6b
  jmp alltraps
801080a1:	e9 f4 f5 ff ff       	jmp    8010769a <alltraps>

801080a6 <vector108>:
.globl vector108
vector108:
  pushl $0
801080a6:	6a 00                	push   $0x0
  pushl $108
801080a8:	6a 6c                	push   $0x6c
  jmp alltraps
801080aa:	e9 eb f5 ff ff       	jmp    8010769a <alltraps>

801080af <vector109>:
.globl vector109
vector109:
  pushl $0
801080af:	6a 00                	push   $0x0
  pushl $109
801080b1:	6a 6d                	push   $0x6d
  jmp alltraps
801080b3:	e9 e2 f5 ff ff       	jmp    8010769a <alltraps>

801080b8 <vector110>:
.globl vector110
vector110:
  pushl $0
801080b8:	6a 00                	push   $0x0
  pushl $110
801080ba:	6a 6e                	push   $0x6e
  jmp alltraps
801080bc:	e9 d9 f5 ff ff       	jmp    8010769a <alltraps>

801080c1 <vector111>:
.globl vector111
vector111:
  pushl $0
801080c1:	6a 00                	push   $0x0
  pushl $111
801080c3:	6a 6f                	push   $0x6f
  jmp alltraps
801080c5:	e9 d0 f5 ff ff       	jmp    8010769a <alltraps>

801080ca <vector112>:
.globl vector112
vector112:
  pushl $0
801080ca:	6a 00                	push   $0x0
  pushl $112
801080cc:	6a 70                	push   $0x70
  jmp alltraps
801080ce:	e9 c7 f5 ff ff       	jmp    8010769a <alltraps>

801080d3 <vector113>:
.globl vector113
vector113:
  pushl $0
801080d3:	6a 00                	push   $0x0
  pushl $113
801080d5:	6a 71                	push   $0x71
  jmp alltraps
801080d7:	e9 be f5 ff ff       	jmp    8010769a <alltraps>

801080dc <vector114>:
.globl vector114
vector114:
  pushl $0
801080dc:	6a 00                	push   $0x0
  pushl $114
801080de:	6a 72                	push   $0x72
  jmp alltraps
801080e0:	e9 b5 f5 ff ff       	jmp    8010769a <alltraps>

801080e5 <vector115>:
.globl vector115
vector115:
  pushl $0
801080e5:	6a 00                	push   $0x0
  pushl $115
801080e7:	6a 73                	push   $0x73
  jmp alltraps
801080e9:	e9 ac f5 ff ff       	jmp    8010769a <alltraps>

801080ee <vector116>:
.globl vector116
vector116:
  pushl $0
801080ee:	6a 00                	push   $0x0
  pushl $116
801080f0:	6a 74                	push   $0x74
  jmp alltraps
801080f2:	e9 a3 f5 ff ff       	jmp    8010769a <alltraps>

801080f7 <vector117>:
.globl vector117
vector117:
  pushl $0
801080f7:	6a 00                	push   $0x0
  pushl $117
801080f9:	6a 75                	push   $0x75
  jmp alltraps
801080fb:	e9 9a f5 ff ff       	jmp    8010769a <alltraps>

80108100 <vector118>:
.globl vector118
vector118:
  pushl $0
80108100:	6a 00                	push   $0x0
  pushl $118
80108102:	6a 76                	push   $0x76
  jmp alltraps
80108104:	e9 91 f5 ff ff       	jmp    8010769a <alltraps>

80108109 <vector119>:
.globl vector119
vector119:
  pushl $0
80108109:	6a 00                	push   $0x0
  pushl $119
8010810b:	6a 77                	push   $0x77
  jmp alltraps
8010810d:	e9 88 f5 ff ff       	jmp    8010769a <alltraps>

80108112 <vector120>:
.globl vector120
vector120:
  pushl $0
80108112:	6a 00                	push   $0x0
  pushl $120
80108114:	6a 78                	push   $0x78
  jmp alltraps
80108116:	e9 7f f5 ff ff       	jmp    8010769a <alltraps>

8010811b <vector121>:
.globl vector121
vector121:
  pushl $0
8010811b:	6a 00                	push   $0x0
  pushl $121
8010811d:	6a 79                	push   $0x79
  jmp alltraps
8010811f:	e9 76 f5 ff ff       	jmp    8010769a <alltraps>

80108124 <vector122>:
.globl vector122
vector122:
  pushl $0
80108124:	6a 00                	push   $0x0
  pushl $122
80108126:	6a 7a                	push   $0x7a
  jmp alltraps
80108128:	e9 6d f5 ff ff       	jmp    8010769a <alltraps>

8010812d <vector123>:
.globl vector123
vector123:
  pushl $0
8010812d:	6a 00                	push   $0x0
  pushl $123
8010812f:	6a 7b                	push   $0x7b
  jmp alltraps
80108131:	e9 64 f5 ff ff       	jmp    8010769a <alltraps>

80108136 <vector124>:
.globl vector124
vector124:
  pushl $0
80108136:	6a 00                	push   $0x0
  pushl $124
80108138:	6a 7c                	push   $0x7c
  jmp alltraps
8010813a:	e9 5b f5 ff ff       	jmp    8010769a <alltraps>

8010813f <vector125>:
.globl vector125
vector125:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $125
80108141:	6a 7d                	push   $0x7d
  jmp alltraps
80108143:	e9 52 f5 ff ff       	jmp    8010769a <alltraps>

80108148 <vector126>:
.globl vector126
vector126:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $126
8010814a:	6a 7e                	push   $0x7e
  jmp alltraps
8010814c:	e9 49 f5 ff ff       	jmp    8010769a <alltraps>

80108151 <vector127>:
.globl vector127
vector127:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $127
80108153:	6a 7f                	push   $0x7f
  jmp alltraps
80108155:	e9 40 f5 ff ff       	jmp    8010769a <alltraps>

8010815a <vector128>:
.globl vector128
vector128:
  pushl $0
8010815a:	6a 00                	push   $0x0
  pushl $128
8010815c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108161:	e9 34 f5 ff ff       	jmp    8010769a <alltraps>

80108166 <vector129>:
.globl vector129
vector129:
  pushl $0
80108166:	6a 00                	push   $0x0
  pushl $129
80108168:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010816d:	e9 28 f5 ff ff       	jmp    8010769a <alltraps>

80108172 <vector130>:
.globl vector130
vector130:
  pushl $0
80108172:	6a 00                	push   $0x0
  pushl $130
80108174:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108179:	e9 1c f5 ff ff       	jmp    8010769a <alltraps>

8010817e <vector131>:
.globl vector131
vector131:
  pushl $0
8010817e:	6a 00                	push   $0x0
  pushl $131
80108180:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108185:	e9 10 f5 ff ff       	jmp    8010769a <alltraps>

8010818a <vector132>:
.globl vector132
vector132:
  pushl $0
8010818a:	6a 00                	push   $0x0
  pushl $132
8010818c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108191:	e9 04 f5 ff ff       	jmp    8010769a <alltraps>

80108196 <vector133>:
.globl vector133
vector133:
  pushl $0
80108196:	6a 00                	push   $0x0
  pushl $133
80108198:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010819d:	e9 f8 f4 ff ff       	jmp    8010769a <alltraps>

801081a2 <vector134>:
.globl vector134
vector134:
  pushl $0
801081a2:	6a 00                	push   $0x0
  pushl $134
801081a4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801081a9:	e9 ec f4 ff ff       	jmp    8010769a <alltraps>

801081ae <vector135>:
.globl vector135
vector135:
  pushl $0
801081ae:	6a 00                	push   $0x0
  pushl $135
801081b0:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801081b5:	e9 e0 f4 ff ff       	jmp    8010769a <alltraps>

801081ba <vector136>:
.globl vector136
vector136:
  pushl $0
801081ba:	6a 00                	push   $0x0
  pushl $136
801081bc:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801081c1:	e9 d4 f4 ff ff       	jmp    8010769a <alltraps>

801081c6 <vector137>:
.globl vector137
vector137:
  pushl $0
801081c6:	6a 00                	push   $0x0
  pushl $137
801081c8:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801081cd:	e9 c8 f4 ff ff       	jmp    8010769a <alltraps>

801081d2 <vector138>:
.globl vector138
vector138:
  pushl $0
801081d2:	6a 00                	push   $0x0
  pushl $138
801081d4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801081d9:	e9 bc f4 ff ff       	jmp    8010769a <alltraps>

801081de <vector139>:
.globl vector139
vector139:
  pushl $0
801081de:	6a 00                	push   $0x0
  pushl $139
801081e0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801081e5:	e9 b0 f4 ff ff       	jmp    8010769a <alltraps>

801081ea <vector140>:
.globl vector140
vector140:
  pushl $0
801081ea:	6a 00                	push   $0x0
  pushl $140
801081ec:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801081f1:	e9 a4 f4 ff ff       	jmp    8010769a <alltraps>

801081f6 <vector141>:
.globl vector141
vector141:
  pushl $0
801081f6:	6a 00                	push   $0x0
  pushl $141
801081f8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801081fd:	e9 98 f4 ff ff       	jmp    8010769a <alltraps>

80108202 <vector142>:
.globl vector142
vector142:
  pushl $0
80108202:	6a 00                	push   $0x0
  pushl $142
80108204:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108209:	e9 8c f4 ff ff       	jmp    8010769a <alltraps>

8010820e <vector143>:
.globl vector143
vector143:
  pushl $0
8010820e:	6a 00                	push   $0x0
  pushl $143
80108210:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108215:	e9 80 f4 ff ff       	jmp    8010769a <alltraps>

8010821a <vector144>:
.globl vector144
vector144:
  pushl $0
8010821a:	6a 00                	push   $0x0
  pushl $144
8010821c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108221:	e9 74 f4 ff ff       	jmp    8010769a <alltraps>

80108226 <vector145>:
.globl vector145
vector145:
  pushl $0
80108226:	6a 00                	push   $0x0
  pushl $145
80108228:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010822d:	e9 68 f4 ff ff       	jmp    8010769a <alltraps>

80108232 <vector146>:
.globl vector146
vector146:
  pushl $0
80108232:	6a 00                	push   $0x0
  pushl $146
80108234:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108239:	e9 5c f4 ff ff       	jmp    8010769a <alltraps>

8010823e <vector147>:
.globl vector147
vector147:
  pushl $0
8010823e:	6a 00                	push   $0x0
  pushl $147
80108240:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108245:	e9 50 f4 ff ff       	jmp    8010769a <alltraps>

8010824a <vector148>:
.globl vector148
vector148:
  pushl $0
8010824a:	6a 00                	push   $0x0
  pushl $148
8010824c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108251:	e9 44 f4 ff ff       	jmp    8010769a <alltraps>

80108256 <vector149>:
.globl vector149
vector149:
  pushl $0
80108256:	6a 00                	push   $0x0
  pushl $149
80108258:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010825d:	e9 38 f4 ff ff       	jmp    8010769a <alltraps>

80108262 <vector150>:
.globl vector150
vector150:
  pushl $0
80108262:	6a 00                	push   $0x0
  pushl $150
80108264:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108269:	e9 2c f4 ff ff       	jmp    8010769a <alltraps>

8010826e <vector151>:
.globl vector151
vector151:
  pushl $0
8010826e:	6a 00                	push   $0x0
  pushl $151
80108270:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108275:	e9 20 f4 ff ff       	jmp    8010769a <alltraps>

8010827a <vector152>:
.globl vector152
vector152:
  pushl $0
8010827a:	6a 00                	push   $0x0
  pushl $152
8010827c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108281:	e9 14 f4 ff ff       	jmp    8010769a <alltraps>

80108286 <vector153>:
.globl vector153
vector153:
  pushl $0
80108286:	6a 00                	push   $0x0
  pushl $153
80108288:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010828d:	e9 08 f4 ff ff       	jmp    8010769a <alltraps>

80108292 <vector154>:
.globl vector154
vector154:
  pushl $0
80108292:	6a 00                	push   $0x0
  pushl $154
80108294:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108299:	e9 fc f3 ff ff       	jmp    8010769a <alltraps>

8010829e <vector155>:
.globl vector155
vector155:
  pushl $0
8010829e:	6a 00                	push   $0x0
  pushl $155
801082a0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801082a5:	e9 f0 f3 ff ff       	jmp    8010769a <alltraps>

801082aa <vector156>:
.globl vector156
vector156:
  pushl $0
801082aa:	6a 00                	push   $0x0
  pushl $156
801082ac:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801082b1:	e9 e4 f3 ff ff       	jmp    8010769a <alltraps>

801082b6 <vector157>:
.globl vector157
vector157:
  pushl $0
801082b6:	6a 00                	push   $0x0
  pushl $157
801082b8:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801082bd:	e9 d8 f3 ff ff       	jmp    8010769a <alltraps>

801082c2 <vector158>:
.globl vector158
vector158:
  pushl $0
801082c2:	6a 00                	push   $0x0
  pushl $158
801082c4:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801082c9:	e9 cc f3 ff ff       	jmp    8010769a <alltraps>

801082ce <vector159>:
.globl vector159
vector159:
  pushl $0
801082ce:	6a 00                	push   $0x0
  pushl $159
801082d0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801082d5:	e9 c0 f3 ff ff       	jmp    8010769a <alltraps>

801082da <vector160>:
.globl vector160
vector160:
  pushl $0
801082da:	6a 00                	push   $0x0
  pushl $160
801082dc:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801082e1:	e9 b4 f3 ff ff       	jmp    8010769a <alltraps>

801082e6 <vector161>:
.globl vector161
vector161:
  pushl $0
801082e6:	6a 00                	push   $0x0
  pushl $161
801082e8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801082ed:	e9 a8 f3 ff ff       	jmp    8010769a <alltraps>

801082f2 <vector162>:
.globl vector162
vector162:
  pushl $0
801082f2:	6a 00                	push   $0x0
  pushl $162
801082f4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801082f9:	e9 9c f3 ff ff       	jmp    8010769a <alltraps>

801082fe <vector163>:
.globl vector163
vector163:
  pushl $0
801082fe:	6a 00                	push   $0x0
  pushl $163
80108300:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108305:	e9 90 f3 ff ff       	jmp    8010769a <alltraps>

8010830a <vector164>:
.globl vector164
vector164:
  pushl $0
8010830a:	6a 00                	push   $0x0
  pushl $164
8010830c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108311:	e9 84 f3 ff ff       	jmp    8010769a <alltraps>

80108316 <vector165>:
.globl vector165
vector165:
  pushl $0
80108316:	6a 00                	push   $0x0
  pushl $165
80108318:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010831d:	e9 78 f3 ff ff       	jmp    8010769a <alltraps>

80108322 <vector166>:
.globl vector166
vector166:
  pushl $0
80108322:	6a 00                	push   $0x0
  pushl $166
80108324:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108329:	e9 6c f3 ff ff       	jmp    8010769a <alltraps>

8010832e <vector167>:
.globl vector167
vector167:
  pushl $0
8010832e:	6a 00                	push   $0x0
  pushl $167
80108330:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108335:	e9 60 f3 ff ff       	jmp    8010769a <alltraps>

8010833a <vector168>:
.globl vector168
vector168:
  pushl $0
8010833a:	6a 00                	push   $0x0
  pushl $168
8010833c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108341:	e9 54 f3 ff ff       	jmp    8010769a <alltraps>

80108346 <vector169>:
.globl vector169
vector169:
  pushl $0
80108346:	6a 00                	push   $0x0
  pushl $169
80108348:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010834d:	e9 48 f3 ff ff       	jmp    8010769a <alltraps>

80108352 <vector170>:
.globl vector170
vector170:
  pushl $0
80108352:	6a 00                	push   $0x0
  pushl $170
80108354:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108359:	e9 3c f3 ff ff       	jmp    8010769a <alltraps>

8010835e <vector171>:
.globl vector171
vector171:
  pushl $0
8010835e:	6a 00                	push   $0x0
  pushl $171
80108360:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108365:	e9 30 f3 ff ff       	jmp    8010769a <alltraps>

8010836a <vector172>:
.globl vector172
vector172:
  pushl $0
8010836a:	6a 00                	push   $0x0
  pushl $172
8010836c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108371:	e9 24 f3 ff ff       	jmp    8010769a <alltraps>

80108376 <vector173>:
.globl vector173
vector173:
  pushl $0
80108376:	6a 00                	push   $0x0
  pushl $173
80108378:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010837d:	e9 18 f3 ff ff       	jmp    8010769a <alltraps>

80108382 <vector174>:
.globl vector174
vector174:
  pushl $0
80108382:	6a 00                	push   $0x0
  pushl $174
80108384:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108389:	e9 0c f3 ff ff       	jmp    8010769a <alltraps>

8010838e <vector175>:
.globl vector175
vector175:
  pushl $0
8010838e:	6a 00                	push   $0x0
  pushl $175
80108390:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108395:	e9 00 f3 ff ff       	jmp    8010769a <alltraps>

8010839a <vector176>:
.globl vector176
vector176:
  pushl $0
8010839a:	6a 00                	push   $0x0
  pushl $176
8010839c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801083a1:	e9 f4 f2 ff ff       	jmp    8010769a <alltraps>

801083a6 <vector177>:
.globl vector177
vector177:
  pushl $0
801083a6:	6a 00                	push   $0x0
  pushl $177
801083a8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801083ad:	e9 e8 f2 ff ff       	jmp    8010769a <alltraps>

801083b2 <vector178>:
.globl vector178
vector178:
  pushl $0
801083b2:	6a 00                	push   $0x0
  pushl $178
801083b4:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801083b9:	e9 dc f2 ff ff       	jmp    8010769a <alltraps>

801083be <vector179>:
.globl vector179
vector179:
  pushl $0
801083be:	6a 00                	push   $0x0
  pushl $179
801083c0:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801083c5:	e9 d0 f2 ff ff       	jmp    8010769a <alltraps>

801083ca <vector180>:
.globl vector180
vector180:
  pushl $0
801083ca:	6a 00                	push   $0x0
  pushl $180
801083cc:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801083d1:	e9 c4 f2 ff ff       	jmp    8010769a <alltraps>

801083d6 <vector181>:
.globl vector181
vector181:
  pushl $0
801083d6:	6a 00                	push   $0x0
  pushl $181
801083d8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801083dd:	e9 b8 f2 ff ff       	jmp    8010769a <alltraps>

801083e2 <vector182>:
.globl vector182
vector182:
  pushl $0
801083e2:	6a 00                	push   $0x0
  pushl $182
801083e4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801083e9:	e9 ac f2 ff ff       	jmp    8010769a <alltraps>

801083ee <vector183>:
.globl vector183
vector183:
  pushl $0
801083ee:	6a 00                	push   $0x0
  pushl $183
801083f0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801083f5:	e9 a0 f2 ff ff       	jmp    8010769a <alltraps>

801083fa <vector184>:
.globl vector184
vector184:
  pushl $0
801083fa:	6a 00                	push   $0x0
  pushl $184
801083fc:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108401:	e9 94 f2 ff ff       	jmp    8010769a <alltraps>

80108406 <vector185>:
.globl vector185
vector185:
  pushl $0
80108406:	6a 00                	push   $0x0
  pushl $185
80108408:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010840d:	e9 88 f2 ff ff       	jmp    8010769a <alltraps>

80108412 <vector186>:
.globl vector186
vector186:
  pushl $0
80108412:	6a 00                	push   $0x0
  pushl $186
80108414:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108419:	e9 7c f2 ff ff       	jmp    8010769a <alltraps>

8010841e <vector187>:
.globl vector187
vector187:
  pushl $0
8010841e:	6a 00                	push   $0x0
  pushl $187
80108420:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108425:	e9 70 f2 ff ff       	jmp    8010769a <alltraps>

8010842a <vector188>:
.globl vector188
vector188:
  pushl $0
8010842a:	6a 00                	push   $0x0
  pushl $188
8010842c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108431:	e9 64 f2 ff ff       	jmp    8010769a <alltraps>

80108436 <vector189>:
.globl vector189
vector189:
  pushl $0
80108436:	6a 00                	push   $0x0
  pushl $189
80108438:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010843d:	e9 58 f2 ff ff       	jmp    8010769a <alltraps>

80108442 <vector190>:
.globl vector190
vector190:
  pushl $0
80108442:	6a 00                	push   $0x0
  pushl $190
80108444:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108449:	e9 4c f2 ff ff       	jmp    8010769a <alltraps>

8010844e <vector191>:
.globl vector191
vector191:
  pushl $0
8010844e:	6a 00                	push   $0x0
  pushl $191
80108450:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108455:	e9 40 f2 ff ff       	jmp    8010769a <alltraps>

8010845a <vector192>:
.globl vector192
vector192:
  pushl $0
8010845a:	6a 00                	push   $0x0
  pushl $192
8010845c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108461:	e9 34 f2 ff ff       	jmp    8010769a <alltraps>

80108466 <vector193>:
.globl vector193
vector193:
  pushl $0
80108466:	6a 00                	push   $0x0
  pushl $193
80108468:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010846d:	e9 28 f2 ff ff       	jmp    8010769a <alltraps>

80108472 <vector194>:
.globl vector194
vector194:
  pushl $0
80108472:	6a 00                	push   $0x0
  pushl $194
80108474:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108479:	e9 1c f2 ff ff       	jmp    8010769a <alltraps>

8010847e <vector195>:
.globl vector195
vector195:
  pushl $0
8010847e:	6a 00                	push   $0x0
  pushl $195
80108480:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108485:	e9 10 f2 ff ff       	jmp    8010769a <alltraps>

8010848a <vector196>:
.globl vector196
vector196:
  pushl $0
8010848a:	6a 00                	push   $0x0
  pushl $196
8010848c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108491:	e9 04 f2 ff ff       	jmp    8010769a <alltraps>

80108496 <vector197>:
.globl vector197
vector197:
  pushl $0
80108496:	6a 00                	push   $0x0
  pushl $197
80108498:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010849d:	e9 f8 f1 ff ff       	jmp    8010769a <alltraps>

801084a2 <vector198>:
.globl vector198
vector198:
  pushl $0
801084a2:	6a 00                	push   $0x0
  pushl $198
801084a4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801084a9:	e9 ec f1 ff ff       	jmp    8010769a <alltraps>

801084ae <vector199>:
.globl vector199
vector199:
  pushl $0
801084ae:	6a 00                	push   $0x0
  pushl $199
801084b0:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801084b5:	e9 e0 f1 ff ff       	jmp    8010769a <alltraps>

801084ba <vector200>:
.globl vector200
vector200:
  pushl $0
801084ba:	6a 00                	push   $0x0
  pushl $200
801084bc:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801084c1:	e9 d4 f1 ff ff       	jmp    8010769a <alltraps>

801084c6 <vector201>:
.globl vector201
vector201:
  pushl $0
801084c6:	6a 00                	push   $0x0
  pushl $201
801084c8:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801084cd:	e9 c8 f1 ff ff       	jmp    8010769a <alltraps>

801084d2 <vector202>:
.globl vector202
vector202:
  pushl $0
801084d2:	6a 00                	push   $0x0
  pushl $202
801084d4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801084d9:	e9 bc f1 ff ff       	jmp    8010769a <alltraps>

801084de <vector203>:
.globl vector203
vector203:
  pushl $0
801084de:	6a 00                	push   $0x0
  pushl $203
801084e0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801084e5:	e9 b0 f1 ff ff       	jmp    8010769a <alltraps>

801084ea <vector204>:
.globl vector204
vector204:
  pushl $0
801084ea:	6a 00                	push   $0x0
  pushl $204
801084ec:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801084f1:	e9 a4 f1 ff ff       	jmp    8010769a <alltraps>

801084f6 <vector205>:
.globl vector205
vector205:
  pushl $0
801084f6:	6a 00                	push   $0x0
  pushl $205
801084f8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801084fd:	e9 98 f1 ff ff       	jmp    8010769a <alltraps>

80108502 <vector206>:
.globl vector206
vector206:
  pushl $0
80108502:	6a 00                	push   $0x0
  pushl $206
80108504:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108509:	e9 8c f1 ff ff       	jmp    8010769a <alltraps>

8010850e <vector207>:
.globl vector207
vector207:
  pushl $0
8010850e:	6a 00                	push   $0x0
  pushl $207
80108510:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108515:	e9 80 f1 ff ff       	jmp    8010769a <alltraps>

8010851a <vector208>:
.globl vector208
vector208:
  pushl $0
8010851a:	6a 00                	push   $0x0
  pushl $208
8010851c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108521:	e9 74 f1 ff ff       	jmp    8010769a <alltraps>

80108526 <vector209>:
.globl vector209
vector209:
  pushl $0
80108526:	6a 00                	push   $0x0
  pushl $209
80108528:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010852d:	e9 68 f1 ff ff       	jmp    8010769a <alltraps>

80108532 <vector210>:
.globl vector210
vector210:
  pushl $0
80108532:	6a 00                	push   $0x0
  pushl $210
80108534:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108539:	e9 5c f1 ff ff       	jmp    8010769a <alltraps>

8010853e <vector211>:
.globl vector211
vector211:
  pushl $0
8010853e:	6a 00                	push   $0x0
  pushl $211
80108540:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108545:	e9 50 f1 ff ff       	jmp    8010769a <alltraps>

8010854a <vector212>:
.globl vector212
vector212:
  pushl $0
8010854a:	6a 00                	push   $0x0
  pushl $212
8010854c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108551:	e9 44 f1 ff ff       	jmp    8010769a <alltraps>

80108556 <vector213>:
.globl vector213
vector213:
  pushl $0
80108556:	6a 00                	push   $0x0
  pushl $213
80108558:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010855d:	e9 38 f1 ff ff       	jmp    8010769a <alltraps>

80108562 <vector214>:
.globl vector214
vector214:
  pushl $0
80108562:	6a 00                	push   $0x0
  pushl $214
80108564:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108569:	e9 2c f1 ff ff       	jmp    8010769a <alltraps>

8010856e <vector215>:
.globl vector215
vector215:
  pushl $0
8010856e:	6a 00                	push   $0x0
  pushl $215
80108570:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108575:	e9 20 f1 ff ff       	jmp    8010769a <alltraps>

8010857a <vector216>:
.globl vector216
vector216:
  pushl $0
8010857a:	6a 00                	push   $0x0
  pushl $216
8010857c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108581:	e9 14 f1 ff ff       	jmp    8010769a <alltraps>

80108586 <vector217>:
.globl vector217
vector217:
  pushl $0
80108586:	6a 00                	push   $0x0
  pushl $217
80108588:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010858d:	e9 08 f1 ff ff       	jmp    8010769a <alltraps>

80108592 <vector218>:
.globl vector218
vector218:
  pushl $0
80108592:	6a 00                	push   $0x0
  pushl $218
80108594:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108599:	e9 fc f0 ff ff       	jmp    8010769a <alltraps>

8010859e <vector219>:
.globl vector219
vector219:
  pushl $0
8010859e:	6a 00                	push   $0x0
  pushl $219
801085a0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801085a5:	e9 f0 f0 ff ff       	jmp    8010769a <alltraps>

801085aa <vector220>:
.globl vector220
vector220:
  pushl $0
801085aa:	6a 00                	push   $0x0
  pushl $220
801085ac:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801085b1:	e9 e4 f0 ff ff       	jmp    8010769a <alltraps>

801085b6 <vector221>:
.globl vector221
vector221:
  pushl $0
801085b6:	6a 00                	push   $0x0
  pushl $221
801085b8:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801085bd:	e9 d8 f0 ff ff       	jmp    8010769a <alltraps>

801085c2 <vector222>:
.globl vector222
vector222:
  pushl $0
801085c2:	6a 00                	push   $0x0
  pushl $222
801085c4:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801085c9:	e9 cc f0 ff ff       	jmp    8010769a <alltraps>

801085ce <vector223>:
.globl vector223
vector223:
  pushl $0
801085ce:	6a 00                	push   $0x0
  pushl $223
801085d0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801085d5:	e9 c0 f0 ff ff       	jmp    8010769a <alltraps>

801085da <vector224>:
.globl vector224
vector224:
  pushl $0
801085da:	6a 00                	push   $0x0
  pushl $224
801085dc:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801085e1:	e9 b4 f0 ff ff       	jmp    8010769a <alltraps>

801085e6 <vector225>:
.globl vector225
vector225:
  pushl $0
801085e6:	6a 00                	push   $0x0
  pushl $225
801085e8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801085ed:	e9 a8 f0 ff ff       	jmp    8010769a <alltraps>

801085f2 <vector226>:
.globl vector226
vector226:
  pushl $0
801085f2:	6a 00                	push   $0x0
  pushl $226
801085f4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801085f9:	e9 9c f0 ff ff       	jmp    8010769a <alltraps>

801085fe <vector227>:
.globl vector227
vector227:
  pushl $0
801085fe:	6a 00                	push   $0x0
  pushl $227
80108600:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108605:	e9 90 f0 ff ff       	jmp    8010769a <alltraps>

8010860a <vector228>:
.globl vector228
vector228:
  pushl $0
8010860a:	6a 00                	push   $0x0
  pushl $228
8010860c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108611:	e9 84 f0 ff ff       	jmp    8010769a <alltraps>

80108616 <vector229>:
.globl vector229
vector229:
  pushl $0
80108616:	6a 00                	push   $0x0
  pushl $229
80108618:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010861d:	e9 78 f0 ff ff       	jmp    8010769a <alltraps>

80108622 <vector230>:
.globl vector230
vector230:
  pushl $0
80108622:	6a 00                	push   $0x0
  pushl $230
80108624:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108629:	e9 6c f0 ff ff       	jmp    8010769a <alltraps>

8010862e <vector231>:
.globl vector231
vector231:
  pushl $0
8010862e:	6a 00                	push   $0x0
  pushl $231
80108630:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108635:	e9 60 f0 ff ff       	jmp    8010769a <alltraps>

8010863a <vector232>:
.globl vector232
vector232:
  pushl $0
8010863a:	6a 00                	push   $0x0
  pushl $232
8010863c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108641:	e9 54 f0 ff ff       	jmp    8010769a <alltraps>

80108646 <vector233>:
.globl vector233
vector233:
  pushl $0
80108646:	6a 00                	push   $0x0
  pushl $233
80108648:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010864d:	e9 48 f0 ff ff       	jmp    8010769a <alltraps>

80108652 <vector234>:
.globl vector234
vector234:
  pushl $0
80108652:	6a 00                	push   $0x0
  pushl $234
80108654:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108659:	e9 3c f0 ff ff       	jmp    8010769a <alltraps>

8010865e <vector235>:
.globl vector235
vector235:
  pushl $0
8010865e:	6a 00                	push   $0x0
  pushl $235
80108660:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108665:	e9 30 f0 ff ff       	jmp    8010769a <alltraps>

8010866a <vector236>:
.globl vector236
vector236:
  pushl $0
8010866a:	6a 00                	push   $0x0
  pushl $236
8010866c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108671:	e9 24 f0 ff ff       	jmp    8010769a <alltraps>

80108676 <vector237>:
.globl vector237
vector237:
  pushl $0
80108676:	6a 00                	push   $0x0
  pushl $237
80108678:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010867d:	e9 18 f0 ff ff       	jmp    8010769a <alltraps>

80108682 <vector238>:
.globl vector238
vector238:
  pushl $0
80108682:	6a 00                	push   $0x0
  pushl $238
80108684:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108689:	e9 0c f0 ff ff       	jmp    8010769a <alltraps>

8010868e <vector239>:
.globl vector239
vector239:
  pushl $0
8010868e:	6a 00                	push   $0x0
  pushl $239
80108690:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108695:	e9 00 f0 ff ff       	jmp    8010769a <alltraps>

8010869a <vector240>:
.globl vector240
vector240:
  pushl $0
8010869a:	6a 00                	push   $0x0
  pushl $240
8010869c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801086a1:	e9 f4 ef ff ff       	jmp    8010769a <alltraps>

801086a6 <vector241>:
.globl vector241
vector241:
  pushl $0
801086a6:	6a 00                	push   $0x0
  pushl $241
801086a8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801086ad:	e9 e8 ef ff ff       	jmp    8010769a <alltraps>

801086b2 <vector242>:
.globl vector242
vector242:
  pushl $0
801086b2:	6a 00                	push   $0x0
  pushl $242
801086b4:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801086b9:	e9 dc ef ff ff       	jmp    8010769a <alltraps>

801086be <vector243>:
.globl vector243
vector243:
  pushl $0
801086be:	6a 00                	push   $0x0
  pushl $243
801086c0:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801086c5:	e9 d0 ef ff ff       	jmp    8010769a <alltraps>

801086ca <vector244>:
.globl vector244
vector244:
  pushl $0
801086ca:	6a 00                	push   $0x0
  pushl $244
801086cc:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801086d1:	e9 c4 ef ff ff       	jmp    8010769a <alltraps>

801086d6 <vector245>:
.globl vector245
vector245:
  pushl $0
801086d6:	6a 00                	push   $0x0
  pushl $245
801086d8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801086dd:	e9 b8 ef ff ff       	jmp    8010769a <alltraps>

801086e2 <vector246>:
.globl vector246
vector246:
  pushl $0
801086e2:	6a 00                	push   $0x0
  pushl $246
801086e4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801086e9:	e9 ac ef ff ff       	jmp    8010769a <alltraps>

801086ee <vector247>:
.globl vector247
vector247:
  pushl $0
801086ee:	6a 00                	push   $0x0
  pushl $247
801086f0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801086f5:	e9 a0 ef ff ff       	jmp    8010769a <alltraps>

801086fa <vector248>:
.globl vector248
vector248:
  pushl $0
801086fa:	6a 00                	push   $0x0
  pushl $248
801086fc:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108701:	e9 94 ef ff ff       	jmp    8010769a <alltraps>

80108706 <vector249>:
.globl vector249
vector249:
  pushl $0
80108706:	6a 00                	push   $0x0
  pushl $249
80108708:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010870d:	e9 88 ef ff ff       	jmp    8010769a <alltraps>

80108712 <vector250>:
.globl vector250
vector250:
  pushl $0
80108712:	6a 00                	push   $0x0
  pushl $250
80108714:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108719:	e9 7c ef ff ff       	jmp    8010769a <alltraps>

8010871e <vector251>:
.globl vector251
vector251:
  pushl $0
8010871e:	6a 00                	push   $0x0
  pushl $251
80108720:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108725:	e9 70 ef ff ff       	jmp    8010769a <alltraps>

8010872a <vector252>:
.globl vector252
vector252:
  pushl $0
8010872a:	6a 00                	push   $0x0
  pushl $252
8010872c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108731:	e9 64 ef ff ff       	jmp    8010769a <alltraps>

80108736 <vector253>:
.globl vector253
vector253:
  pushl $0
80108736:	6a 00                	push   $0x0
  pushl $253
80108738:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010873d:	e9 58 ef ff ff       	jmp    8010769a <alltraps>

80108742 <vector254>:
.globl vector254
vector254:
  pushl $0
80108742:	6a 00                	push   $0x0
  pushl $254
80108744:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108749:	e9 4c ef ff ff       	jmp    8010769a <alltraps>

8010874e <vector255>:
.globl vector255
vector255:
  pushl $0
8010874e:	6a 00                	push   $0x0
  pushl $255
80108750:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108755:	e9 40 ef ff ff       	jmp    8010769a <alltraps>

8010875a <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010875a:	55                   	push   %ebp
8010875b:	89 e5                	mov    %esp,%ebp
8010875d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108760:	8b 45 0c             	mov    0xc(%ebp),%eax
80108763:	83 e8 01             	sub    $0x1,%eax
80108766:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010876a:	8b 45 08             	mov    0x8(%ebp),%eax
8010876d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108771:	8b 45 08             	mov    0x8(%ebp),%eax
80108774:	c1 e8 10             	shr    $0x10,%eax
80108777:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010877b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010877e:	0f 01 10             	lgdtl  (%eax)
}
80108781:	90                   	nop
80108782:	c9                   	leave  
80108783:	c3                   	ret    

80108784 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108784:	55                   	push   %ebp
80108785:	89 e5                	mov    %esp,%ebp
80108787:	83 ec 04             	sub    $0x4,%esp
8010878a:	8b 45 08             	mov    0x8(%ebp),%eax
8010878d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108791:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108795:	0f 00 d8             	ltr    %ax
}
80108798:	90                   	nop
80108799:	c9                   	leave  
8010879a:	c3                   	ret    

8010879b <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010879b:	55                   	push   %ebp
8010879c:	89 e5                	mov    %esp,%ebp
8010879e:	83 ec 04             	sub    $0x4,%esp
801087a1:	8b 45 08             	mov    0x8(%ebp),%eax
801087a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801087a8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801087ac:	8e e8                	mov    %eax,%gs
}
801087ae:	90                   	nop
801087af:	c9                   	leave  
801087b0:	c3                   	ret    

801087b1 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801087b1:	55                   	push   %ebp
801087b2:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801087b4:	8b 45 08             	mov    0x8(%ebp),%eax
801087b7:	0f 22 d8             	mov    %eax,%cr3
}
801087ba:	90                   	nop
801087bb:	5d                   	pop    %ebp
801087bc:	c3                   	ret    

801087bd <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801087bd:	55                   	push   %ebp
801087be:	89 e5                	mov    %esp,%ebp
801087c0:	8b 45 08             	mov    0x8(%ebp),%eax
801087c3:	05 00 00 00 80       	add    $0x80000000,%eax
801087c8:	5d                   	pop    %ebp
801087c9:	c3                   	ret    

801087ca <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801087ca:	55                   	push   %ebp
801087cb:	89 e5                	mov    %esp,%ebp
801087cd:	8b 45 08             	mov    0x8(%ebp),%eax
801087d0:	05 00 00 00 80       	add    $0x80000000,%eax
801087d5:	5d                   	pop    %ebp
801087d6:	c3                   	ret    

801087d7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801087d7:	55                   	push   %ebp
801087d8:	89 e5                	mov    %esp,%ebp
801087da:	53                   	push   %ebx
801087db:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801087de:	e8 87 a8 ff ff       	call   8010306a <cpunum>
801087e3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801087e9:	05 80 33 11 80       	add    $0x80113380,%eax
801087ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801087f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801087fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087fd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108806:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010880a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108811:	83 e2 f0             	and    $0xfffffff0,%edx
80108814:	83 ca 0a             	or     $0xa,%edx
80108817:	88 50 7d             	mov    %dl,0x7d(%eax)
8010881a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010881d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108821:	83 ca 10             	or     $0x10,%edx
80108824:	88 50 7d             	mov    %dl,0x7d(%eax)
80108827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010882e:	83 e2 9f             	and    $0xffffff9f,%edx
80108831:	88 50 7d             	mov    %dl,0x7d(%eax)
80108834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108837:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010883b:	83 ca 80             	or     $0xffffff80,%edx
8010883e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108844:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108848:	83 ca 0f             	or     $0xf,%edx
8010884b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010884e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108851:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108855:	83 e2 ef             	and    $0xffffffef,%edx
80108858:	88 50 7e             	mov    %dl,0x7e(%eax)
8010885b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108862:	83 e2 df             	and    $0xffffffdf,%edx
80108865:	88 50 7e             	mov    %dl,0x7e(%eax)
80108868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010886b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010886f:	83 ca 40             	or     $0x40,%edx
80108872:	88 50 7e             	mov    %dl,0x7e(%eax)
80108875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108878:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010887c:	83 ca 80             	or     $0xffffff80,%edx
8010887f:	88 50 7e             	mov    %dl,0x7e(%eax)
80108882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108885:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010888c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108893:	ff ff 
80108895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108898:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010889f:	00 00 
801088a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801088ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ae:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801088b5:	83 e2 f0             	and    $0xfffffff0,%edx
801088b8:	83 ca 02             	or     $0x2,%edx
801088bb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801088c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801088cb:	83 ca 10             	or     $0x10,%edx
801088ce:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801088d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801088de:	83 e2 9f             	and    $0xffffff9f,%edx
801088e1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801088e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ea:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801088f1:	83 ca 80             	or     $0xffffff80,%edx
801088f4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801088fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108904:	83 ca 0f             	or     $0xf,%edx
80108907:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010890d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108910:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108917:	83 e2 ef             	and    $0xffffffef,%edx
8010891a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108923:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010892a:	83 e2 df             	and    $0xffffffdf,%edx
8010892d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108936:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010893d:	83 ca 40             	or     $0x40,%edx
80108940:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108949:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108950:	83 ca 80             	or     $0xffffff80,%edx
80108953:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108966:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010896d:	ff ff 
8010896f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108972:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108979:	00 00 
8010897b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010897e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108988:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010898f:	83 e2 f0             	and    $0xfffffff0,%edx
80108992:	83 ca 0a             	or     $0xa,%edx
80108995:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010899b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010899e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801089a5:	83 ca 10             	or     $0x10,%edx
801089a8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801089ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801089b8:	83 ca 60             	or     $0x60,%edx
801089bb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801089cb:	83 ca 80             	or     $0xffffff80,%edx
801089ce:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801089d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089de:	83 ca 0f             	or     $0xf,%edx
801089e1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ea:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089f1:	83 e2 ef             	and    $0xffffffef,%edx
801089f4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089fd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108a04:	83 e2 df             	and    $0xffffffdf,%edx
80108a07:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a10:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108a17:	83 ca 40             	or     $0x40,%edx
80108a1a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a23:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108a2a:	83 ca 80             	or     $0xffffff80,%edx
80108a2d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a36:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a40:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108a47:	ff ff 
80108a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108a53:	00 00 
80108a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a58:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a62:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a69:	83 e2 f0             	and    $0xfffffff0,%edx
80108a6c:	83 ca 02             	or     $0x2,%edx
80108a6f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a78:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a7f:	83 ca 10             	or     $0x10,%edx
80108a82:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a8b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a92:	83 ca 60             	or     $0x60,%edx
80108a95:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108aa5:	83 ca 80             	or     $0xffffff80,%edx
80108aa8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ab8:	83 ca 0f             	or     $0xf,%edx
80108abb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108acb:	83 e2 ef             	and    $0xffffffef,%edx
80108ace:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ade:	83 e2 df             	and    $0xffffffdf,%edx
80108ae1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aea:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108af1:	83 ca 40             	or     $0x40,%edx
80108af4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108b04:	83 ca 80             	or     $0xffffff80,%edx
80108b07:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b10:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1a:	05 b4 00 00 00       	add    $0xb4,%eax
80108b1f:	89 c3                	mov    %eax,%ebx
80108b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b24:	05 b4 00 00 00       	add    $0xb4,%eax
80108b29:	c1 e8 10             	shr    $0x10,%eax
80108b2c:	89 c2                	mov    %eax,%edx
80108b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b31:	05 b4 00 00 00       	add    $0xb4,%eax
80108b36:	c1 e8 18             	shr    $0x18,%eax
80108b39:	89 c1                	mov    %eax,%ecx
80108b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3e:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108b45:	00 00 
80108b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b54:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b64:	83 e2 f0             	and    $0xfffffff0,%edx
80108b67:	83 ca 02             	or     $0x2,%edx
80108b6a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b73:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b7a:	83 ca 10             	or     $0x10,%edx
80108b7d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b86:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b8d:	83 e2 9f             	and    $0xffffff9f,%edx
80108b90:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b99:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108ba0:	83 ca 80             	or     $0xffffff80,%edx
80108ba3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bac:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bb3:	83 e2 f0             	and    $0xfffffff0,%edx
80108bb6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbf:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bc6:	83 e2 ef             	and    $0xffffffef,%edx
80108bc9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bd9:	83 e2 df             	and    $0xffffffdf,%edx
80108bdc:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bec:	83 ca 40             	or     $0x40,%edx
80108bef:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bff:	83 ca 80             	or     $0xffffff80,%edx
80108c02:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0b:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c14:	83 c0 70             	add    $0x70,%eax
80108c17:	83 ec 08             	sub    $0x8,%esp
80108c1a:	6a 38                	push   $0x38
80108c1c:	50                   	push   %eax
80108c1d:	e8 38 fb ff ff       	call   8010875a <lgdt>
80108c22:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108c25:	83 ec 0c             	sub    $0xc,%esp
80108c28:	6a 18                	push   $0x18
80108c2a:	e8 6c fb ff ff       	call   8010879b <loadgs>
80108c2f:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c35:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108c3b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108c42:	00 00 00 00 
}
80108c46:	90                   	nop
80108c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108c4a:	c9                   	leave  
80108c4b:	c3                   	ret    

80108c4c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108c4c:	55                   	push   %ebp
80108c4d:	89 e5                	mov    %esp,%ebp
80108c4f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108c52:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c55:	c1 e8 16             	shr    $0x16,%eax
80108c58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80108c62:	01 d0                	add    %edx,%eax
80108c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c6a:	8b 00                	mov    (%eax),%eax
80108c6c:	83 e0 01             	and    $0x1,%eax
80108c6f:	85 c0                	test   %eax,%eax
80108c71:	74 18                	je     80108c8b <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c76:	8b 00                	mov    (%eax),%eax
80108c78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c7d:	50                   	push   %eax
80108c7e:	e8 47 fb ff ff       	call   801087ca <p2v>
80108c83:	83 c4 04             	add    $0x4,%esp
80108c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c89:	eb 48                	jmp    80108cd3 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108c8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108c8f:	74 0e                	je     80108c9f <walkpgdir+0x53>
80108c91:	e8 6e a0 ff ff       	call   80102d04 <kalloc>
80108c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108c9d:	75 07                	jne    80108ca6 <walkpgdir+0x5a>
      return 0;
80108c9f:	b8 00 00 00 00       	mov    $0x0,%eax
80108ca4:	eb 44                	jmp    80108cea <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108ca6:	83 ec 04             	sub    $0x4,%esp
80108ca9:	68 00 10 00 00       	push   $0x1000
80108cae:	6a 00                	push   $0x0
80108cb0:	ff 75 f4             	pushl  -0xc(%ebp)
80108cb3:	e8 ac d4 ff ff       	call   80106164 <memset>
80108cb8:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108cbb:	83 ec 0c             	sub    $0xc,%esp
80108cbe:	ff 75 f4             	pushl  -0xc(%ebp)
80108cc1:	e8 f7 fa ff ff       	call   801087bd <v2p>
80108cc6:	83 c4 10             	add    $0x10,%esp
80108cc9:	83 c8 07             	or     $0x7,%eax
80108ccc:	89 c2                	mov    %eax,%edx
80108cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cd6:	c1 e8 0c             	shr    $0xc,%eax
80108cd9:	25 ff 03 00 00       	and    $0x3ff,%eax
80108cde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce8:	01 d0                	add    %edx,%eax
}
80108cea:	c9                   	leave  
80108ceb:	c3                   	ret    

80108cec <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108cec:	55                   	push   %ebp
80108ced:	89 e5                	mov    %esp,%ebp
80108cef:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d00:	8b 45 10             	mov    0x10(%ebp),%eax
80108d03:	01 d0                	add    %edx,%eax
80108d05:	83 e8 01             	sub    $0x1,%eax
80108d08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108d10:	83 ec 04             	sub    $0x4,%esp
80108d13:	6a 01                	push   $0x1
80108d15:	ff 75 f4             	pushl  -0xc(%ebp)
80108d18:	ff 75 08             	pushl  0x8(%ebp)
80108d1b:	e8 2c ff ff ff       	call   80108c4c <walkpgdir>
80108d20:	83 c4 10             	add    $0x10,%esp
80108d23:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108d26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108d2a:	75 07                	jne    80108d33 <mappages+0x47>
      return -1;
80108d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d31:	eb 47                	jmp    80108d7a <mappages+0x8e>
    if(*pte & PTE_P)
80108d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d36:	8b 00                	mov    (%eax),%eax
80108d38:	83 e0 01             	and    $0x1,%eax
80108d3b:	85 c0                	test   %eax,%eax
80108d3d:	74 0d                	je     80108d4c <mappages+0x60>
      panic("remap");
80108d3f:	83 ec 0c             	sub    $0xc,%esp
80108d42:	68 cc 9e 10 80       	push   $0x80109ecc
80108d47:	e8 1a 78 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108d4c:	8b 45 18             	mov    0x18(%ebp),%eax
80108d4f:	0b 45 14             	or     0x14(%ebp),%eax
80108d52:	83 c8 01             	or     $0x1,%eax
80108d55:	89 c2                	mov    %eax,%edx
80108d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d5a:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108d62:	74 10                	je     80108d74 <mappages+0x88>
      break;
    a += PGSIZE;
80108d64:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108d6b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108d72:	eb 9c                	jmp    80108d10 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108d74:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d7a:	c9                   	leave  
80108d7b:	c3                   	ret    

80108d7c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108d7c:	55                   	push   %ebp
80108d7d:	89 e5                	mov    %esp,%ebp
80108d7f:	53                   	push   %ebx
80108d80:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108d83:	e8 7c 9f ff ff       	call   80102d04 <kalloc>
80108d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108d8f:	75 0a                	jne    80108d9b <setupkvm+0x1f>
    return 0;
80108d91:	b8 00 00 00 00       	mov    $0x0,%eax
80108d96:	e9 8e 00 00 00       	jmp    80108e29 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108d9b:	83 ec 04             	sub    $0x4,%esp
80108d9e:	68 00 10 00 00       	push   $0x1000
80108da3:	6a 00                	push   $0x0
80108da5:	ff 75 f0             	pushl  -0x10(%ebp)
80108da8:	e8 b7 d3 ff ff       	call   80106164 <memset>
80108dad:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108db0:	83 ec 0c             	sub    $0xc,%esp
80108db3:	68 00 00 00 0e       	push   $0xe000000
80108db8:	e8 0d fa ff ff       	call   801087ca <p2v>
80108dbd:	83 c4 10             	add    $0x10,%esp
80108dc0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108dc5:	76 0d                	jbe    80108dd4 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108dc7:	83 ec 0c             	sub    $0xc,%esp
80108dca:	68 d2 9e 10 80       	push   $0x80109ed2
80108dcf:	e8 92 77 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108dd4:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108ddb:	eb 40                	jmp    80108e1d <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de0:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de6:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dec:	8b 58 08             	mov    0x8(%eax),%ebx
80108def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df2:	8b 40 04             	mov    0x4(%eax),%eax
80108df5:	29 c3                	sub    %eax,%ebx
80108df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dfa:	8b 00                	mov    (%eax),%eax
80108dfc:	83 ec 0c             	sub    $0xc,%esp
80108dff:	51                   	push   %ecx
80108e00:	52                   	push   %edx
80108e01:	53                   	push   %ebx
80108e02:	50                   	push   %eax
80108e03:	ff 75 f0             	pushl  -0x10(%ebp)
80108e06:	e8 e1 fe ff ff       	call   80108cec <mappages>
80108e0b:	83 c4 20             	add    $0x20,%esp
80108e0e:	85 c0                	test   %eax,%eax
80108e10:	79 07                	jns    80108e19 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108e12:	b8 00 00 00 00       	mov    $0x0,%eax
80108e17:	eb 10                	jmp    80108e29 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108e19:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108e1d:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108e24:	72 b7                	jb     80108ddd <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108e2c:	c9                   	leave  
80108e2d:	c3                   	ret    

80108e2e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108e2e:	55                   	push   %ebp
80108e2f:	89 e5                	mov    %esp,%ebp
80108e31:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108e34:	e8 43 ff ff ff       	call   80108d7c <setupkvm>
80108e39:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
80108e3e:	e8 03 00 00 00       	call   80108e46 <switchkvm>
}
80108e43:	90                   	nop
80108e44:	c9                   	leave  
80108e45:	c3                   	ret    

80108e46 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108e46:	55                   	push   %ebp
80108e47:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108e49:	a1 38 67 11 80       	mov    0x80116738,%eax
80108e4e:	50                   	push   %eax
80108e4f:	e8 69 f9 ff ff       	call   801087bd <v2p>
80108e54:	83 c4 04             	add    $0x4,%esp
80108e57:	50                   	push   %eax
80108e58:	e8 54 f9 ff ff       	call   801087b1 <lcr3>
80108e5d:	83 c4 04             	add    $0x4,%esp
}
80108e60:	90                   	nop
80108e61:	c9                   	leave  
80108e62:	c3                   	ret    

80108e63 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108e63:	55                   	push   %ebp
80108e64:	89 e5                	mov    %esp,%ebp
80108e66:	56                   	push   %esi
80108e67:	53                   	push   %ebx
  pushcli();
80108e68:	e8 f1 d1 ff ff       	call   8010605e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108e6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108e73:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e7a:	83 c2 08             	add    $0x8,%edx
80108e7d:	89 d6                	mov    %edx,%esi
80108e7f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e86:	83 c2 08             	add    $0x8,%edx
80108e89:	c1 ea 10             	shr    $0x10,%edx
80108e8c:	89 d3                	mov    %edx,%ebx
80108e8e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e95:	83 c2 08             	add    $0x8,%edx
80108e98:	c1 ea 18             	shr    $0x18,%edx
80108e9b:	89 d1                	mov    %edx,%ecx
80108e9d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108ea4:	67 00 
80108ea6:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108ead:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108eb3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108eba:	83 e2 f0             	and    $0xfffffff0,%edx
80108ebd:	83 ca 09             	or     $0x9,%edx
80108ec0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108ec6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108ecd:	83 ca 10             	or     $0x10,%edx
80108ed0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108ed6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108edd:	83 e2 9f             	and    $0xffffff9f,%edx
80108ee0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108ee6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108eed:	83 ca 80             	or     $0xffffff80,%edx
80108ef0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108ef6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108efd:	83 e2 f0             	and    $0xfffffff0,%edx
80108f00:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108f06:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108f0d:	83 e2 ef             	and    $0xffffffef,%edx
80108f10:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108f16:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108f1d:	83 e2 df             	and    $0xffffffdf,%edx
80108f20:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108f26:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108f2d:	83 ca 40             	or     $0x40,%edx
80108f30:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108f36:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108f3d:	83 e2 7f             	and    $0x7f,%edx
80108f40:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108f46:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108f4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f52:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108f59:	83 e2 ef             	and    $0xffffffef,%edx
80108f5c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108f62:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f68:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108f6e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f74:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108f7b:	8b 52 08             	mov    0x8(%edx),%edx
80108f7e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108f84:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108f87:	83 ec 0c             	sub    $0xc,%esp
80108f8a:	6a 30                	push   $0x30
80108f8c:	e8 f3 f7 ff ff       	call   80108784 <ltr>
80108f91:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108f94:	8b 45 08             	mov    0x8(%ebp),%eax
80108f97:	8b 40 04             	mov    0x4(%eax),%eax
80108f9a:	85 c0                	test   %eax,%eax
80108f9c:	75 0d                	jne    80108fab <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108f9e:	83 ec 0c             	sub    $0xc,%esp
80108fa1:	68 e3 9e 10 80       	push   $0x80109ee3
80108fa6:	e8 bb 75 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108fab:	8b 45 08             	mov    0x8(%ebp),%eax
80108fae:	8b 40 04             	mov    0x4(%eax),%eax
80108fb1:	83 ec 0c             	sub    $0xc,%esp
80108fb4:	50                   	push   %eax
80108fb5:	e8 03 f8 ff ff       	call   801087bd <v2p>
80108fba:	83 c4 10             	add    $0x10,%esp
80108fbd:	83 ec 0c             	sub    $0xc,%esp
80108fc0:	50                   	push   %eax
80108fc1:	e8 eb f7 ff ff       	call   801087b1 <lcr3>
80108fc6:	83 c4 10             	add    $0x10,%esp
  popcli();
80108fc9:	e8 d5 d0 ff ff       	call   801060a3 <popcli>
}
80108fce:	90                   	nop
80108fcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108fd2:	5b                   	pop    %ebx
80108fd3:	5e                   	pop    %esi
80108fd4:	5d                   	pop    %ebp
80108fd5:	c3                   	ret    

80108fd6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108fd6:	55                   	push   %ebp
80108fd7:	89 e5                	mov    %esp,%ebp
80108fd9:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108fdc:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108fe3:	76 0d                	jbe    80108ff2 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108fe5:	83 ec 0c             	sub    $0xc,%esp
80108fe8:	68 f7 9e 10 80       	push   $0x80109ef7
80108fed:	e8 74 75 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108ff2:	e8 0d 9d ff ff       	call   80102d04 <kalloc>
80108ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108ffa:	83 ec 04             	sub    $0x4,%esp
80108ffd:	68 00 10 00 00       	push   $0x1000
80109002:	6a 00                	push   $0x0
80109004:	ff 75 f4             	pushl  -0xc(%ebp)
80109007:	e8 58 d1 ff ff       	call   80106164 <memset>
8010900c:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010900f:	83 ec 0c             	sub    $0xc,%esp
80109012:	ff 75 f4             	pushl  -0xc(%ebp)
80109015:	e8 a3 f7 ff ff       	call   801087bd <v2p>
8010901a:	83 c4 10             	add    $0x10,%esp
8010901d:	83 ec 0c             	sub    $0xc,%esp
80109020:	6a 06                	push   $0x6
80109022:	50                   	push   %eax
80109023:	68 00 10 00 00       	push   $0x1000
80109028:	6a 00                	push   $0x0
8010902a:	ff 75 08             	pushl  0x8(%ebp)
8010902d:	e8 ba fc ff ff       	call   80108cec <mappages>
80109032:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109035:	83 ec 04             	sub    $0x4,%esp
80109038:	ff 75 10             	pushl  0x10(%ebp)
8010903b:	ff 75 0c             	pushl  0xc(%ebp)
8010903e:	ff 75 f4             	pushl  -0xc(%ebp)
80109041:	e8 dd d1 ff ff       	call   80106223 <memmove>
80109046:	83 c4 10             	add    $0x10,%esp
}
80109049:	90                   	nop
8010904a:	c9                   	leave  
8010904b:	c3                   	ret    

8010904c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010904c:	55                   	push   %ebp
8010904d:	89 e5                	mov    %esp,%ebp
8010904f:	53                   	push   %ebx
80109050:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109053:	8b 45 0c             	mov    0xc(%ebp),%eax
80109056:	25 ff 0f 00 00       	and    $0xfff,%eax
8010905b:	85 c0                	test   %eax,%eax
8010905d:	74 0d                	je     8010906c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010905f:	83 ec 0c             	sub    $0xc,%esp
80109062:	68 14 9f 10 80       	push   $0x80109f14
80109067:	e8 fa 74 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010906c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109073:	e9 95 00 00 00       	jmp    8010910d <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109078:	8b 55 0c             	mov    0xc(%ebp),%edx
8010907b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010907e:	01 d0                	add    %edx,%eax
80109080:	83 ec 04             	sub    $0x4,%esp
80109083:	6a 00                	push   $0x0
80109085:	50                   	push   %eax
80109086:	ff 75 08             	pushl  0x8(%ebp)
80109089:	e8 be fb ff ff       	call   80108c4c <walkpgdir>
8010908e:	83 c4 10             	add    $0x10,%esp
80109091:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109094:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109098:	75 0d                	jne    801090a7 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010909a:	83 ec 0c             	sub    $0xc,%esp
8010909d:	68 37 9f 10 80       	push   $0x80109f37
801090a2:	e8 bf 74 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801090a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090aa:	8b 00                	mov    (%eax),%eax
801090ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801090b4:	8b 45 18             	mov    0x18(%ebp),%eax
801090b7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801090ba:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801090bf:	77 0b                	ja     801090cc <loaduvm+0x80>
      n = sz - i;
801090c1:	8b 45 18             	mov    0x18(%ebp),%eax
801090c4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801090c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801090ca:	eb 07                	jmp    801090d3 <loaduvm+0x87>
    else
      n = PGSIZE;
801090cc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801090d3:	8b 55 14             	mov    0x14(%ebp),%edx
801090d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090d9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801090dc:	83 ec 0c             	sub    $0xc,%esp
801090df:	ff 75 e8             	pushl  -0x18(%ebp)
801090e2:	e8 e3 f6 ff ff       	call   801087ca <p2v>
801090e7:	83 c4 10             	add    $0x10,%esp
801090ea:	ff 75 f0             	pushl  -0x10(%ebp)
801090ed:	53                   	push   %ebx
801090ee:	50                   	push   %eax
801090ef:	ff 75 10             	pushl  0x10(%ebp)
801090f2:	e8 7f 8e ff ff       	call   80101f76 <readi>
801090f7:	83 c4 10             	add    $0x10,%esp
801090fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801090fd:	74 07                	je     80109106 <loaduvm+0xba>
      return -1;
801090ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109104:	eb 18                	jmp    8010911e <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010910d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109110:	3b 45 18             	cmp    0x18(%ebp),%eax
80109113:	0f 82 5f ff ff ff    	jb     80109078 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109119:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010911e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109121:	c9                   	leave  
80109122:	c3                   	ret    

80109123 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109123:	55                   	push   %ebp
80109124:	89 e5                	mov    %esp,%ebp
80109126:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109129:	8b 45 10             	mov    0x10(%ebp),%eax
8010912c:	85 c0                	test   %eax,%eax
8010912e:	79 0a                	jns    8010913a <allocuvm+0x17>
    return 0;
80109130:	b8 00 00 00 00       	mov    $0x0,%eax
80109135:	e9 b0 00 00 00       	jmp    801091ea <allocuvm+0xc7>
  if(newsz < oldsz)
8010913a:	8b 45 10             	mov    0x10(%ebp),%eax
8010913d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109140:	73 08                	jae    8010914a <allocuvm+0x27>
    return oldsz;
80109142:	8b 45 0c             	mov    0xc(%ebp),%eax
80109145:	e9 a0 00 00 00       	jmp    801091ea <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010914a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010914d:	05 ff 0f 00 00       	add    $0xfff,%eax
80109152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010915a:	eb 7f                	jmp    801091db <allocuvm+0xb8>
    mem = kalloc();
8010915c:	e8 a3 9b ff ff       	call   80102d04 <kalloc>
80109161:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109168:	75 2b                	jne    80109195 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010916a:	83 ec 0c             	sub    $0xc,%esp
8010916d:	68 55 9f 10 80       	push   $0x80109f55
80109172:	e8 4f 72 ff ff       	call   801003c6 <cprintf>
80109177:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010917a:	83 ec 04             	sub    $0x4,%esp
8010917d:	ff 75 0c             	pushl  0xc(%ebp)
80109180:	ff 75 10             	pushl  0x10(%ebp)
80109183:	ff 75 08             	pushl  0x8(%ebp)
80109186:	e8 61 00 00 00       	call   801091ec <deallocuvm>
8010918b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010918e:	b8 00 00 00 00       	mov    $0x0,%eax
80109193:	eb 55                	jmp    801091ea <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109195:	83 ec 04             	sub    $0x4,%esp
80109198:	68 00 10 00 00       	push   $0x1000
8010919d:	6a 00                	push   $0x0
8010919f:	ff 75 f0             	pushl  -0x10(%ebp)
801091a2:	e8 bd cf ff ff       	call   80106164 <memset>
801091a7:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801091aa:	83 ec 0c             	sub    $0xc,%esp
801091ad:	ff 75 f0             	pushl  -0x10(%ebp)
801091b0:	e8 08 f6 ff ff       	call   801087bd <v2p>
801091b5:	83 c4 10             	add    $0x10,%esp
801091b8:	89 c2                	mov    %eax,%edx
801091ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091bd:	83 ec 0c             	sub    $0xc,%esp
801091c0:	6a 06                	push   $0x6
801091c2:	52                   	push   %edx
801091c3:	68 00 10 00 00       	push   $0x1000
801091c8:	50                   	push   %eax
801091c9:	ff 75 08             	pushl  0x8(%ebp)
801091cc:	e8 1b fb ff ff       	call   80108cec <mappages>
801091d1:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801091d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801091db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091de:	3b 45 10             	cmp    0x10(%ebp),%eax
801091e1:	0f 82 75 ff ff ff    	jb     8010915c <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801091e7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801091ea:	c9                   	leave  
801091eb:	c3                   	ret    

801091ec <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801091ec:	55                   	push   %ebp
801091ed:	89 e5                	mov    %esp,%ebp
801091ef:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801091f2:	8b 45 10             	mov    0x10(%ebp),%eax
801091f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801091f8:	72 08                	jb     80109202 <deallocuvm+0x16>
    return oldsz;
801091fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801091fd:	e9 a5 00 00 00       	jmp    801092a7 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109202:	8b 45 10             	mov    0x10(%ebp),%eax
80109205:	05 ff 0f 00 00       	add    $0xfff,%eax
8010920a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010920f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109212:	e9 81 00 00 00       	jmp    80109298 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921a:	83 ec 04             	sub    $0x4,%esp
8010921d:	6a 00                	push   $0x0
8010921f:	50                   	push   %eax
80109220:	ff 75 08             	pushl  0x8(%ebp)
80109223:	e8 24 fa ff ff       	call   80108c4c <walkpgdir>
80109228:	83 c4 10             	add    $0x10,%esp
8010922b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010922e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109232:	75 09                	jne    8010923d <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109234:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010923b:	eb 54                	jmp    80109291 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010923d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109240:	8b 00                	mov    (%eax),%eax
80109242:	83 e0 01             	and    $0x1,%eax
80109245:	85 c0                	test   %eax,%eax
80109247:	74 48                	je     80109291 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010924c:	8b 00                	mov    (%eax),%eax
8010924e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109253:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109256:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010925a:	75 0d                	jne    80109269 <deallocuvm+0x7d>
        panic("kfree");
8010925c:	83 ec 0c             	sub    $0xc,%esp
8010925f:	68 6d 9f 10 80       	push   $0x80109f6d
80109264:	e8 fd 72 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109269:	83 ec 0c             	sub    $0xc,%esp
8010926c:	ff 75 ec             	pushl  -0x14(%ebp)
8010926f:	e8 56 f5 ff ff       	call   801087ca <p2v>
80109274:	83 c4 10             	add    $0x10,%esp
80109277:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010927a:	83 ec 0c             	sub    $0xc,%esp
8010927d:	ff 75 e8             	pushl  -0x18(%ebp)
80109280:	e8 e2 99 ff ff       	call   80102c67 <kfree>
80109285:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109288:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010928b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109291:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010929b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010929e:	0f 82 73 ff ff ff    	jb     80109217 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801092a4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801092a7:	c9                   	leave  
801092a8:	c3                   	ret    

801092a9 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801092a9:	55                   	push   %ebp
801092aa:	89 e5                	mov    %esp,%ebp
801092ac:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801092af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801092b3:	75 0d                	jne    801092c2 <freevm+0x19>
    panic("freevm: no pgdir");
801092b5:	83 ec 0c             	sub    $0xc,%esp
801092b8:	68 73 9f 10 80       	push   $0x80109f73
801092bd:	e8 a4 72 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801092c2:	83 ec 04             	sub    $0x4,%esp
801092c5:	6a 00                	push   $0x0
801092c7:	68 00 00 00 80       	push   $0x80000000
801092cc:	ff 75 08             	pushl  0x8(%ebp)
801092cf:	e8 18 ff ff ff       	call   801091ec <deallocuvm>
801092d4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801092d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801092de:	eb 4f                	jmp    8010932f <freevm+0x86>
    if(pgdir[i] & PTE_P){
801092e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801092ea:	8b 45 08             	mov    0x8(%ebp),%eax
801092ed:	01 d0                	add    %edx,%eax
801092ef:	8b 00                	mov    (%eax),%eax
801092f1:	83 e0 01             	and    $0x1,%eax
801092f4:	85 c0                	test   %eax,%eax
801092f6:	74 33                	je     8010932b <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801092f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109302:	8b 45 08             	mov    0x8(%ebp),%eax
80109305:	01 d0                	add    %edx,%eax
80109307:	8b 00                	mov    (%eax),%eax
80109309:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010930e:	83 ec 0c             	sub    $0xc,%esp
80109311:	50                   	push   %eax
80109312:	e8 b3 f4 ff ff       	call   801087ca <p2v>
80109317:	83 c4 10             	add    $0x10,%esp
8010931a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010931d:	83 ec 0c             	sub    $0xc,%esp
80109320:	ff 75 f0             	pushl  -0x10(%ebp)
80109323:	e8 3f 99 ff ff       	call   80102c67 <kfree>
80109328:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010932b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010932f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109336:	76 a8                	jbe    801092e0 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109338:	83 ec 0c             	sub    $0xc,%esp
8010933b:	ff 75 08             	pushl  0x8(%ebp)
8010933e:	e8 24 99 ff ff       	call   80102c67 <kfree>
80109343:	83 c4 10             	add    $0x10,%esp
}
80109346:	90                   	nop
80109347:	c9                   	leave  
80109348:	c3                   	ret    

80109349 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109349:	55                   	push   %ebp
8010934a:	89 e5                	mov    %esp,%ebp
8010934c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010934f:	83 ec 04             	sub    $0x4,%esp
80109352:	6a 00                	push   $0x0
80109354:	ff 75 0c             	pushl  0xc(%ebp)
80109357:	ff 75 08             	pushl  0x8(%ebp)
8010935a:	e8 ed f8 ff ff       	call   80108c4c <walkpgdir>
8010935f:	83 c4 10             	add    $0x10,%esp
80109362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109369:	75 0d                	jne    80109378 <clearpteu+0x2f>
    panic("clearpteu");
8010936b:	83 ec 0c             	sub    $0xc,%esp
8010936e:	68 84 9f 10 80       	push   $0x80109f84
80109373:	e8 ee 71 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937b:	8b 00                	mov    (%eax),%eax
8010937d:	83 e0 fb             	and    $0xfffffffb,%eax
80109380:	89 c2                	mov    %eax,%edx
80109382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109385:	89 10                	mov    %edx,(%eax)
}
80109387:	90                   	nop
80109388:	c9                   	leave  
80109389:	c3                   	ret    

8010938a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010938a:	55                   	push   %ebp
8010938b:	89 e5                	mov    %esp,%ebp
8010938d:	53                   	push   %ebx
8010938e:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109391:	e8 e6 f9 ff ff       	call   80108d7c <setupkvm>
80109396:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010939d:	75 0a                	jne    801093a9 <copyuvm+0x1f>
    return 0;
8010939f:	b8 00 00 00 00       	mov    $0x0,%eax
801093a4:	e9 f8 00 00 00       	jmp    801094a1 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801093a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801093b0:	e9 c4 00 00 00       	jmp    80109479 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801093b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b8:	83 ec 04             	sub    $0x4,%esp
801093bb:	6a 00                	push   $0x0
801093bd:	50                   	push   %eax
801093be:	ff 75 08             	pushl  0x8(%ebp)
801093c1:	e8 86 f8 ff ff       	call   80108c4c <walkpgdir>
801093c6:	83 c4 10             	add    $0x10,%esp
801093c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801093cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801093d0:	75 0d                	jne    801093df <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801093d2:	83 ec 0c             	sub    $0xc,%esp
801093d5:	68 8e 9f 10 80       	push   $0x80109f8e
801093da:	e8 87 71 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801093df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093e2:	8b 00                	mov    (%eax),%eax
801093e4:	83 e0 01             	and    $0x1,%eax
801093e7:	85 c0                	test   %eax,%eax
801093e9:	75 0d                	jne    801093f8 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801093eb:	83 ec 0c             	sub    $0xc,%esp
801093ee:	68 a8 9f 10 80       	push   $0x80109fa8
801093f3:	e8 6e 71 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801093f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093fb:	8b 00                	mov    (%eax),%eax
801093fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109402:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109405:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109408:	8b 00                	mov    (%eax),%eax
8010940a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010940f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109412:	e8 ed 98 ff ff       	call   80102d04 <kalloc>
80109417:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010941a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010941e:	74 6a                	je     8010948a <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109420:	83 ec 0c             	sub    $0xc,%esp
80109423:	ff 75 e8             	pushl  -0x18(%ebp)
80109426:	e8 9f f3 ff ff       	call   801087ca <p2v>
8010942b:	83 c4 10             	add    $0x10,%esp
8010942e:	83 ec 04             	sub    $0x4,%esp
80109431:	68 00 10 00 00       	push   $0x1000
80109436:	50                   	push   %eax
80109437:	ff 75 e0             	pushl  -0x20(%ebp)
8010943a:	e8 e4 cd ff ff       	call   80106223 <memmove>
8010943f:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109442:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109445:	83 ec 0c             	sub    $0xc,%esp
80109448:	ff 75 e0             	pushl  -0x20(%ebp)
8010944b:	e8 6d f3 ff ff       	call   801087bd <v2p>
80109450:	83 c4 10             	add    $0x10,%esp
80109453:	89 c2                	mov    %eax,%edx
80109455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109458:	83 ec 0c             	sub    $0xc,%esp
8010945b:	53                   	push   %ebx
8010945c:	52                   	push   %edx
8010945d:	68 00 10 00 00       	push   $0x1000
80109462:	50                   	push   %eax
80109463:	ff 75 f0             	pushl  -0x10(%ebp)
80109466:	e8 81 f8 ff ff       	call   80108cec <mappages>
8010946b:	83 c4 20             	add    $0x20,%esp
8010946e:	85 c0                	test   %eax,%eax
80109470:	78 1b                	js     8010948d <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109472:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109479:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010947f:	0f 82 30 ff ff ff    	jb     801093b5 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109485:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109488:	eb 17                	jmp    801094a1 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010948a:	90                   	nop
8010948b:	eb 01                	jmp    8010948e <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010948d:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010948e:	83 ec 0c             	sub    $0xc,%esp
80109491:	ff 75 f0             	pushl  -0x10(%ebp)
80109494:	e8 10 fe ff ff       	call   801092a9 <freevm>
80109499:	83 c4 10             	add    $0x10,%esp
  return 0;
8010949c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801094a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801094a4:	c9                   	leave  
801094a5:	c3                   	ret    

801094a6 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801094a6:	55                   	push   %ebp
801094a7:	89 e5                	mov    %esp,%ebp
801094a9:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801094ac:	83 ec 04             	sub    $0x4,%esp
801094af:	6a 00                	push   $0x0
801094b1:	ff 75 0c             	pushl  0xc(%ebp)
801094b4:	ff 75 08             	pushl  0x8(%ebp)
801094b7:	e8 90 f7 ff ff       	call   80108c4c <walkpgdir>
801094bc:	83 c4 10             	add    $0x10,%esp
801094bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801094c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c5:	8b 00                	mov    (%eax),%eax
801094c7:	83 e0 01             	and    $0x1,%eax
801094ca:	85 c0                	test   %eax,%eax
801094cc:	75 07                	jne    801094d5 <uva2ka+0x2f>
    return 0;
801094ce:	b8 00 00 00 00       	mov    $0x0,%eax
801094d3:	eb 29                	jmp    801094fe <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801094d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d8:	8b 00                	mov    (%eax),%eax
801094da:	83 e0 04             	and    $0x4,%eax
801094dd:	85 c0                	test   %eax,%eax
801094df:	75 07                	jne    801094e8 <uva2ka+0x42>
    return 0;
801094e1:	b8 00 00 00 00       	mov    $0x0,%eax
801094e6:	eb 16                	jmp    801094fe <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801094e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094eb:	8b 00                	mov    (%eax),%eax
801094ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094f2:	83 ec 0c             	sub    $0xc,%esp
801094f5:	50                   	push   %eax
801094f6:	e8 cf f2 ff ff       	call   801087ca <p2v>
801094fb:	83 c4 10             	add    $0x10,%esp
}
801094fe:	c9                   	leave  
801094ff:	c3                   	ret    

80109500 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109500:	55                   	push   %ebp
80109501:	89 e5                	mov    %esp,%ebp
80109503:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109506:	8b 45 10             	mov    0x10(%ebp),%eax
80109509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010950c:	eb 7f                	jmp    8010958d <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010950e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109511:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109516:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010951c:	83 ec 08             	sub    $0x8,%esp
8010951f:	50                   	push   %eax
80109520:	ff 75 08             	pushl  0x8(%ebp)
80109523:	e8 7e ff ff ff       	call   801094a6 <uva2ka>
80109528:	83 c4 10             	add    $0x10,%esp
8010952b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010952e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109532:	75 07                	jne    8010953b <copyout+0x3b>
      return -1;
80109534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109539:	eb 61                	jmp    8010959c <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010953b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010953e:	2b 45 0c             	sub    0xc(%ebp),%eax
80109541:	05 00 10 00 00       	add    $0x1000,%eax
80109546:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010954c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010954f:	76 06                	jbe    80109557 <copyout+0x57>
      n = len;
80109551:	8b 45 14             	mov    0x14(%ebp),%eax
80109554:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109557:	8b 45 0c             	mov    0xc(%ebp),%eax
8010955a:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010955d:	89 c2                	mov    %eax,%edx
8010955f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109562:	01 d0                	add    %edx,%eax
80109564:	83 ec 04             	sub    $0x4,%esp
80109567:	ff 75 f0             	pushl  -0x10(%ebp)
8010956a:	ff 75 f4             	pushl  -0xc(%ebp)
8010956d:	50                   	push   %eax
8010956e:	e8 b0 cc ff ff       	call   80106223 <memmove>
80109573:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109576:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109579:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010957c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010957f:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109582:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109585:	05 00 10 00 00       	add    $0x1000,%eax
8010958a:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010958d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109591:	0f 85 77 ff ff ff    	jne    8010950e <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109597:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010959c:	c9                   	leave  
8010959d:	c3                   	ret    
