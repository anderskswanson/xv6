
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 19 3c 10 80       	mov    $0x80103c19,%eax
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
8010003d:	68 18 a1 10 80       	push   $0x8010a118
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 2e 68 00 00       	call   8010687a <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
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
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 d6 67 00 00       	call   8010689c <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
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
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 f2 67 00 00       	call   80106903 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 f7 56 00 00       	call   80105823 <sleep>
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
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
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
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 76 67 00 00       	call   80106903 <release>
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
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 1f a1 10 80       	push   $0x8010a11f
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
801001e2:	e8 b0 2a 00 00       	call   80102c97 <iderw>
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
80100204:	68 30 a1 10 80       	push   $0x8010a130
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
80100223:	e8 6f 2a 00 00       	call   80102c97 <iderw>
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
80100243:	68 37 a1 10 80       	push   $0x8010a137
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 42 66 00 00       	call   8010689c <acquire>
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
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

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
801002b9:	e8 55 57 00 00       	call   80105a13 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 35 66 00 00       	call   80106903 <release>
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
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
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
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 b5 64 00 00       	call   8010689c <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 3e a1 10 80       	push   $0x8010a13e
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
801004cd:	c7 45 ec 47 a1 10 80 	movl   $0x8010a147,-0x14(%ebp)
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
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 a3 63 00 00       	call   80106903 <release>
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
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 4e a1 10 80       	push   $0x8010a14e
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
801005aa:	68 5d a1 10 80       	push   $0x8010a15d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 8e 63 00 00       	call   80106955 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 5f a1 10 80       	push   $0x8010a15f
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
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
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
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
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
801006ca:	68 63 a1 10 80       	push   $0x8010a163
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 c2 64 00 00       	call   80106bbe <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 d9 63 00 00       	call   80106aff <memset>
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
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
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
801007b6:	e8 e4 7f 00 00       	call   8010879f <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 d7 7f 00 00       	call   8010879f <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 ca 7f 00 00       	call   8010879f <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 ba 7f 00 00       	call   8010879f <uartputc>
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
80100825:	68 00 d6 10 80       	push   $0x8010d600
8010082a:	e8 6d 60 00 00       	call   8010689c <acquire>
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
801008bf:	a1 48 28 11 80       	mov    0x80112848,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 48 28 11 80       	mov    %eax,0x80112848
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
801008dc:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008e2:	a1 44 28 11 80       	mov    0x80112844,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 48 28 11 80       	mov    0x80112848,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
8010090a:	8b 15 48 28 11 80    	mov    0x80112848,%edx
80100910:	a1 44 28 11 80       	mov    0x80112844,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 48 28 11 80       	mov    0x80112848,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 48 28 11 80       	mov    %eax,0x80112848
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
80100949:	8b 15 48 28 11 80    	mov    0x80112848,%edx
8010094f:	a1 40 28 11 80       	mov    0x80112840,%eax
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
80100970:	a1 48 28 11 80       	mov    0x80112848,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 48 28 11 80    	mov    %edx,0x80112848
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
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
801009a4:	a1 48 28 11 80       	mov    0x80112848,%eax
801009a9:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 48 28 11 80       	mov    0x80112848,%eax
801009bb:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 40 28 11 80       	push   $0x80112840
801009c8:	e8 46 50 00 00       	call   80105a13 <wakeup>
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
801009e6:	68 00 d6 10 80       	push   $0x8010d600
801009eb:	e8 13 5f 00 00       	call   80106903 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  if(ctrls)
801009f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009f7:	74 05                	je     801009fe <consoleintr+0x205>
    printsleep();  
801009f9:	e8 4d 59 00 00       	call   8010634b <printsleep>
  if(ctrlr)
801009fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a02:	74 05                	je     80100a09 <consoleintr+0x210>
    printready();
80100a04:	e8 91 5a 00 00       	call   8010649a <printready>
  if(ctrlz)
80100a09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a0d:	74 05                	je     80100a14 <consoleintr+0x21b>
    printzombie();
80100a0f:	e8 b4 59 00 00       	call   801063c8 <printzombie>
  if(ctrlf)
80100a14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a18:	74 05                	je     80100a1f <consoleintr+0x226>
    printfree();
80100a1a:	e8 56 59 00 00       	call   80106375 <printfree>
#endif
  if(doprocdump) {
80100a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a23:	74 05                	je     80100a2a <consoleintr+0x231>
    procdump();  // now call procdump() wo. cons.lock held
80100a25:	e8 2a 52 00 00       	call   80105c54 <procdump>
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
80100a39:	e8 ec 13 00 00       	call   80101e2a <iunlock>
80100a3e:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a41:	8b 45 10             	mov    0x10(%ebp),%eax
80100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a47:	83 ec 0c             	sub    $0xc,%esp
80100a4a:	68 00 d6 10 80       	push   $0x8010d600
80100a4f:	e8 48 5e 00 00       	call   8010689c <acquire>
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
80100a6c:	68 00 d6 10 80       	push   $0x8010d600
80100a71:	e8 8d 5e 00 00       	call   80106903 <release>
80100a76:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a79:	83 ec 0c             	sub    $0xc,%esp
80100a7c:	ff 75 08             	pushl  0x8(%ebp)
80100a7f:	e8 20 12 00 00       	call   80101ca4 <ilock>
80100a84:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a8c:	e9 ab 00 00 00       	jmp    80100b3c <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a91:	83 ec 08             	sub    $0x8,%esp
80100a94:	68 00 d6 10 80       	push   $0x8010d600
80100a99:	68 40 28 11 80       	push   $0x80112840
80100a9e:	e8 80 4d 00 00       	call   80105823 <sleep>
80100aa3:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aa6:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100aac:	a1 44 28 11 80       	mov    0x80112844,%eax
80100ab1:	39 c2                	cmp    %eax,%edx
80100ab3:	74 a7                	je     80100a5c <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ab5:	a1 40 28 11 80       	mov    0x80112840,%eax
80100aba:	8d 50 01             	lea    0x1(%eax),%edx
80100abd:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100ac3:	83 e0 7f             	and    $0x7f,%eax
80100ac6:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
80100ae1:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ae6:	83 e8 01             	sub    $0x1,%eax
80100ae9:	a3 40 28 11 80       	mov    %eax,0x80112840
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
80100b17:	68 00 d6 10 80       	push   $0x8010d600
80100b1c:	e8 e2 5d 00 00       	call   80106903 <release>
80100b21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b24:	83 ec 0c             	sub    $0xc,%esp
80100b27:	ff 75 08             	pushl  0x8(%ebp)
80100b2a:	e8 75 11 00 00       	call   80101ca4 <ilock>
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
80100b4a:	e8 db 12 00 00       	call   80101e2a <iunlock>
80100b4f:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	68 00 d6 10 80       	push   $0x8010d600
80100b5a:	e8 3d 5d 00 00       	call   8010689c <acquire>
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
80100b97:	68 00 d6 10 80       	push   $0x8010d600
80100b9c:	e8 62 5d 00 00       	call   80106903 <release>
80100ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ba4:	83 ec 0c             	sub    $0xc,%esp
80100ba7:	ff 75 08             	pushl  0x8(%ebp)
80100baa:	e8 f5 10 00 00       	call   80101ca4 <ilock>
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
80100bc0:	68 76 a1 10 80       	push   $0x8010a176
80100bc5:	68 00 d6 10 80       	push   $0x8010d600
80100bca:	e8 ab 5c 00 00       	call   8010687a <initlock>
80100bcf:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd2:	c7 05 0c 32 11 80 3e 	movl   $0x80100b3e,0x8011320c
80100bd9:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bdc:	c7 05 08 32 11 80 2d 	movl   $0x80100a2d,0x80113208
80100be3:	0a 10 80 
  cons.locking = 1;
80100be6:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bed:	00 00 00 

  picenable(IRQ_KBD);
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	6a 01                	push   $0x1
80100bf5:	e8 bb 36 00 00       	call   801042b5 <picenable>
80100bfa:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bfd:	83 ec 08             	sub    $0x8,%esp
80100c00:	6a 00                	push   $0x0
80100c02:	6a 01                	push   $0x1
80100c04:	e8 5b 22 00 00       	call   80102e64 <ioapicenable>
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
  pde_t *pgdir, *oldpgdir;
#ifdef CS333_P5
  int ipuid;
#endif

  begin_op();
80100c18:	e8 ba 2c 00 00       	call   801038d7 <begin_op>
  if((ip = namei(path)) == 0){
80100c1d:	83 ec 0c             	sub    $0xc,%esp
80100c20:	ff 75 08             	pushl  0x8(%ebp)
80100c23:	e8 8a 1c 00 00       	call   801028b2 <namei>
80100c28:	83 c4 10             	add    $0x10,%esp
80100c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c32:	75 0f                	jne    80100c43 <exec+0x34>
    end_op();
80100c34:	e8 2a 2d 00 00       	call   80103963 <end_op>
    return -1;
80100c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3e:	e9 43 04 00 00       	jmp    80101086 <exec+0x477>
  }
  
  ilock(ip);
80100c43:	83 ec 0c             	sub    $0xc,%esp
80100c46:	ff 75 d8             	pushl  -0x28(%ebp)
80100c49:	e8 56 10 00 00       	call   80101ca4 <ilock>
80100c4e:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P5
  ipuid = checksetuid(ip);
80100c51:	83 ec 0c             	sub    $0xc,%esp
80100c54:	ff 75 d8             	pushl  -0x28(%ebp)
80100c57:	e8 79 09 00 00       	call   801015d5 <checksetuid>
80100c5c:	83 c4 10             	add    $0x10,%esp
80100c5f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(!fscheckperms(ip, proc->uid, proc->gid))
80100c62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c68:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100c6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c74:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80100c7a:	83 ec 04             	sub    $0x4,%esp
80100c7d:	52                   	push   %edx
80100c7e:	50                   	push   %eax
80100c7f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c82:	e8 7f 09 00 00       	call   80101606 <fscheckperms>
80100c87:	83 c4 10             	add    $0x10,%esp
80100c8a:	85 c0                	test   %eax,%eax
80100c8c:	75 23                	jne    80100cb1 <exec+0xa2>
  {
      if(ip){
80100c8e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c92:	74 13                	je     80100ca7 <exec+0x98>
        iunlockput(ip);
80100c94:	83 ec 0c             	sub    $0xc,%esp
80100c97:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9a:	e8 ed 12 00 00       	call   80101f8c <iunlockput>
80100c9f:	83 c4 10             	add    $0x10,%esp
        end_op();
80100ca2:	e8 bc 2c 00 00       	call   80103963 <end_op>
      }
      return -1;
80100ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cac:	e9 d5 03 00 00       	jmp    80101086 <exec+0x477>
  }
#endif
  pgdir = 0;
80100cb1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100cb8:	6a 34                	push   $0x34
80100cba:	6a 00                	push   $0x0
80100cbc:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100cc2:	50                   	push   %eax
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	e8 97 15 00 00       	call   80102262 <readi>
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	83 f8 33             	cmp    $0x33,%eax
80100cd1:	0f 86 5e 03 00 00    	jbe    80101035 <exec+0x426>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cd7:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100cdd:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100ce2:	0f 85 50 03 00 00    	jne    80101038 <exec+0x429>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100ce8:	e8 07 8c 00 00       	call   801098f4 <setupkvm>
80100ced:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100cf0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cf4:	0f 84 41 03 00 00    	je     8010103b <exec+0x42c>
    goto bad;

  // Load program into memory.
  sz = 0;
80100cfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d08:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100d0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d11:	e9 ab 00 00 00       	jmp    80100dc1 <exec+0x1b2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d19:	6a 20                	push   $0x20
80100d1b:	50                   	push   %eax
80100d1c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100d22:	50                   	push   %eax
80100d23:	ff 75 d8             	pushl  -0x28(%ebp)
80100d26:	e8 37 15 00 00       	call   80102262 <readi>
80100d2b:	83 c4 10             	add    $0x10,%esp
80100d2e:	83 f8 20             	cmp    $0x20,%eax
80100d31:	0f 85 07 03 00 00    	jne    8010103e <exec+0x42f>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d37:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d3d:	83 f8 01             	cmp    $0x1,%eax
80100d40:	75 71                	jne    80100db3 <exec+0x1a4>
      continue;
    if(ph.memsz < ph.filesz)
80100d42:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d48:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d4e:	39 c2                	cmp    %eax,%edx
80100d50:	0f 82 eb 02 00 00    	jb     80101041 <exec+0x432>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d56:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d5c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d62:	01 d0                	add    %edx,%eax
80100d64:	83 ec 04             	sub    $0x4,%esp
80100d67:	50                   	push   %eax
80100d68:	ff 75 e0             	pushl  -0x20(%ebp)
80100d6b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d6e:	e8 28 8f 00 00       	call   80109c9b <allocuvm>
80100d73:	83 c4 10             	add    $0x10,%esp
80100d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7d:	0f 84 c1 02 00 00    	je     80101044 <exec+0x435>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d83:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d89:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d8f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d95:	83 ec 0c             	sub    $0xc,%esp
80100d98:	52                   	push   %edx
80100d99:	50                   	push   %eax
80100d9a:	ff 75 d8             	pushl  -0x28(%ebp)
80100d9d:	51                   	push   %ecx
80100d9e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da1:	e8 1e 8e 00 00       	call   80109bc4 <loaduvm>
80100da6:	83 c4 20             	add    $0x20,%esp
80100da9:	85 c0                	test   %eax,%eax
80100dab:	0f 88 96 02 00 00    	js     80101047 <exec+0x438>
80100db1:	eb 01                	jmp    80100db4 <exec+0x1a5>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100db3:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100db4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dbb:	83 c0 20             	add    $0x20,%eax
80100dbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dc1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100dc8:	0f b7 c0             	movzwl %ax,%eax
80100dcb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dce:	0f 8f 42 ff ff ff    	jg     80100d16 <exec+0x107>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100dd4:	83 ec 0c             	sub    $0xc,%esp
80100dd7:	ff 75 d8             	pushl  -0x28(%ebp)
80100dda:	e8 ad 11 00 00       	call   80101f8c <iunlockput>
80100ddf:	83 c4 10             	add    $0x10,%esp
  end_op();
80100de2:	e8 7c 2b 00 00       	call   80103963 <end_op>
  ip = 0;
80100de7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100df1:	05 ff 0f 00 00       	add    $0xfff,%eax
80100df6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100dfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	05 00 20 00 00       	add    $0x2000,%eax
80100e06:	83 ec 04             	sub    $0x4,%esp
80100e09:	50                   	push   %eax
80100e0a:	ff 75 e0             	pushl  -0x20(%ebp)
80100e0d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e10:	e8 86 8e 00 00       	call   80109c9b <allocuvm>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e1f:	0f 84 25 02 00 00    	je     8010104a <exec+0x43b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e28:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e2d:	83 ec 08             	sub    $0x8,%esp
80100e30:	50                   	push   %eax
80100e31:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e34:	e8 88 90 00 00       	call   80109ec1 <clearpteu>
80100e39:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e3f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e49:	e9 96 00 00 00       	jmp    80100ee4 <exec+0x2d5>
    if(argc >= MAXARG)
80100e4e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e52:	0f 87 f5 01 00 00    	ja     8010104d <exec+0x43e>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e65:	01 d0                	add    %edx,%eax
80100e67:	8b 00                	mov    (%eax),%eax
80100e69:	83 ec 0c             	sub    $0xc,%esp
80100e6c:	50                   	push   %eax
80100e6d:	e8 da 5e 00 00       	call   80106d4c <strlen>
80100e72:	83 c4 10             	add    $0x10,%esp
80100e75:	89 c2                	mov    %eax,%edx
80100e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e7a:	29 d0                	sub    %edx,%eax
80100e7c:	83 e8 01             	sub    $0x1,%eax
80100e7f:	83 e0 fc             	and    $0xfffffffc,%eax
80100e82:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e92:	01 d0                	add    %edx,%eax
80100e94:	8b 00                	mov    (%eax),%eax
80100e96:	83 ec 0c             	sub    $0xc,%esp
80100e99:	50                   	push   %eax
80100e9a:	e8 ad 5e 00 00       	call   80106d4c <strlen>
80100e9f:	83 c4 10             	add    $0x10,%esp
80100ea2:	83 c0 01             	add    $0x1,%eax
80100ea5:	89 c1                	mov    %eax,%ecx
80100ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eaa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb4:	01 d0                	add    %edx,%eax
80100eb6:	8b 00                	mov    (%eax),%eax
80100eb8:	51                   	push   %ecx
80100eb9:	50                   	push   %eax
80100eba:	ff 75 dc             	pushl  -0x24(%ebp)
80100ebd:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ec0:	e8 b3 91 00 00       	call   8010a078 <copyout>
80100ec5:	83 c4 10             	add    $0x10,%esp
80100ec8:	85 c0                	test   %eax,%eax
80100eca:	0f 88 80 01 00 00    	js     80101050 <exec+0x441>
      goto bad;
    ustack[3+argc] = sp;
80100ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed3:	8d 50 03             	lea    0x3(%eax),%edx
80100ed6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed9:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ee0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eee:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ef1:	01 d0                	add    %edx,%eax
80100ef3:	8b 00                	mov    (%eax),%eax
80100ef5:	85 c0                	test   %eax,%eax
80100ef7:	0f 85 51 ff ff ff    	jne    80100e4e <exec+0x23f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100efd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f00:	83 c0 03             	add    $0x3,%eax
80100f03:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f0a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f0e:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f15:	ff ff ff 
  ustack[1] = argc;
80100f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f1b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f24:	83 c0 01             	add    $0x1,%eax
80100f27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f31:	29 d0                	sub    %edx,%eax
80100f33:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f3c:	83 c0 04             	add    $0x4,%eax
80100f3f:	c1 e0 02             	shl    $0x2,%eax
80100f42:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f48:	83 c0 04             	add    $0x4,%eax
80100f4b:	c1 e0 02             	shl    $0x2,%eax
80100f4e:	50                   	push   %eax
80100f4f:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f55:	50                   	push   %eax
80100f56:	ff 75 dc             	pushl  -0x24(%ebp)
80100f59:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f5c:	e8 17 91 00 00       	call   8010a078 <copyout>
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	85 c0                	test   %eax,%eax
80100f66:	0f 88 e7 00 00 00    	js     80101053 <exec+0x444>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f78:	eb 17                	jmp    80100f91 <exec+0x382>
    if(*s == '/')
80100f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7d:	0f b6 00             	movzbl (%eax),%eax
80100f80:	3c 2f                	cmp    $0x2f,%al
80100f82:	75 09                	jne    80100f8d <exec+0x37e>
      last = s+1;
80100f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f87:	83 c0 01             	add    $0x1,%eax
80100f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f94:	0f b6 00             	movzbl (%eax),%eax
80100f97:	84 c0                	test   %al,%al
80100f99:	75 df                	jne    80100f7a <exec+0x36b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fa1:	83 c0 6c             	add    $0x6c,%eax
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	6a 10                	push   $0x10
80100fa9:	ff 75 f0             	pushl  -0x10(%ebp)
80100fac:	50                   	push   %eax
80100fad:	e8 50 5d 00 00       	call   80106d02 <safestrcpy>
80100fb2:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fbb:	8b 40 04             	mov    0x4(%eax),%eax
80100fbe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100fc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fca:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100fcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fd3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fd6:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100fd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fde:	8b 40 18             	mov    0x18(%eax),%eax
80100fe1:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100fe7:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100fea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff0:	8b 40 18             	mov    0x18(%eax),%eax
80100ff3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ff6:	89 50 44             	mov    %edx,0x44(%eax)
#ifdef CS333_P5
  if(ipuid != -1)
80100ff9:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
80100ffd:	74 0f                	je     8010100e <exec+0x3ff>
      proc->uid = ipuid;
80100fff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101005:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101008:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
#endif
  switchuvm(proc);
8010100e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	50                   	push   %eax
80101018:	e8 be 89 00 00       	call   801099db <switchuvm>
8010101d:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	ff 75 cc             	pushl  -0x34(%ebp)
80101026:	e8 f6 8d 00 00       	call   80109e21 <freevm>
8010102b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010102e:	b8 00 00 00 00       	mov    $0x0,%eax
80101033:	eb 51                	jmp    80101086 <exec+0x477>
#endif
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101035:	90                   	nop
80101036:	eb 1c                	jmp    80101054 <exec+0x445>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101038:	90                   	nop
80101039:	eb 19                	jmp    80101054 <exec+0x445>

  if((pgdir = setupkvm()) == 0)
    goto bad;
8010103b:	90                   	nop
8010103c:	eb 16                	jmp    80101054 <exec+0x445>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010103e:	90                   	nop
8010103f:	eb 13                	jmp    80101054 <exec+0x445>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80101041:	90                   	nop
80101042:	eb 10                	jmp    80101054 <exec+0x445>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101044:	90                   	nop
80101045:	eb 0d                	jmp    80101054 <exec+0x445>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101047:	90                   	nop
80101048:	eb 0a                	jmp    80101054 <exec+0x445>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
8010104a:	90                   	nop
8010104b:	eb 07                	jmp    80101054 <exec+0x445>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010104d:	90                   	nop
8010104e:	eb 04                	jmp    80101054 <exec+0x445>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80101050:	90                   	nop
80101051:	eb 01                	jmp    80101054 <exec+0x445>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101053:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101054:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101058:	74 0e                	je     80101068 <exec+0x459>
    freevm(pgdir);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	ff 75 d4             	pushl  -0x2c(%ebp)
80101060:	e8 bc 8d 00 00       	call   80109e21 <freevm>
80101065:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101068:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010106c:	74 13                	je     80101081 <exec+0x472>
    iunlockput(ip);
8010106e:	83 ec 0c             	sub    $0xc,%esp
80101071:	ff 75 d8             	pushl  -0x28(%ebp)
80101074:	e8 13 0f 00 00       	call   80101f8c <iunlockput>
80101079:	83 c4 10             	add    $0x10,%esp
    end_op();
8010107c:	e8 e2 28 00 00       	call   80103963 <end_op>
  }
  return -1;
80101081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101086:	c9                   	leave  
80101087:	c3                   	ret    

80101088 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101088:	55                   	push   %ebp
80101089:	89 e5                	mov    %esp,%ebp
8010108b:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010108e:	83 ec 08             	sub    $0x8,%esp
80101091:	68 7e a1 10 80       	push   $0x8010a17e
80101096:	68 60 28 11 80       	push   $0x80112860
8010109b:	e8 da 57 00 00       	call   8010687a <initlock>
801010a0:	83 c4 10             	add    $0x10,%esp
}
801010a3:	90                   	nop
801010a4:	c9                   	leave  
801010a5:	c3                   	ret    

801010a6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010a6:	55                   	push   %ebp
801010a7:	89 e5                	mov    %esp,%ebp
801010a9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 60 28 11 80       	push   $0x80112860
801010b4:	e8 e3 57 00 00       	call   8010689c <acquire>
801010b9:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010bc:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
801010c3:	eb 2d                	jmp    801010f2 <filealloc+0x4c>
    if(f->ref == 0){
801010c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010c8:	8b 40 04             	mov    0x4(%eax),%eax
801010cb:	85 c0                	test   %eax,%eax
801010cd:	75 1f                	jne    801010ee <filealloc+0x48>
      f->ref = 1;
801010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010d2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 60 28 11 80       	push   $0x80112860
801010e1:	e8 1d 58 00 00       	call   80106903 <release>
801010e6:	83 c4 10             	add    $0x10,%esp
      return f;
801010e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010ec:	eb 23                	jmp    80101111 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010ee:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801010f2:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
801010f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801010fa:	72 c9                	jb     801010c5 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801010fc:	83 ec 0c             	sub    $0xc,%esp
801010ff:	68 60 28 11 80       	push   $0x80112860
80101104:	e8 fa 57 00 00       	call   80106903 <release>
80101109:	83 c4 10             	add    $0x10,%esp
  return 0;
8010110c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101111:	c9                   	leave  
80101112:	c3                   	ret    

80101113 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101113:	55                   	push   %ebp
80101114:	89 e5                	mov    %esp,%ebp
80101116:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101119:	83 ec 0c             	sub    $0xc,%esp
8010111c:	68 60 28 11 80       	push   $0x80112860
80101121:	e8 76 57 00 00       	call   8010689c <acquire>
80101126:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 04             	mov    0x4(%eax),%eax
8010112f:	85 c0                	test   %eax,%eax
80101131:	7f 0d                	jg     80101140 <filedup+0x2d>
    panic("filedup");
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	68 85 a1 10 80       	push   $0x8010a185
8010113b:	e8 26 f4 ff ff       	call   80100566 <panic>
  f->ref++;
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 04             	mov    0x4(%eax),%eax
80101146:	8d 50 01             	lea    0x1(%eax),%edx
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	68 60 28 11 80       	push   $0x80112860
80101157:	e8 a7 57 00 00       	call   80106903 <release>
8010115c:	83 c4 10             	add    $0x10,%esp
  return f;
8010115f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101162:	c9                   	leave  
80101163:	c3                   	ret    

80101164 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101164:	55                   	push   %ebp
80101165:	89 e5                	mov    %esp,%ebp
80101167:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	68 60 28 11 80       	push   $0x80112860
80101172:	e8 25 57 00 00       	call   8010689c <acquire>
80101177:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 04             	mov    0x4(%eax),%eax
80101180:	85 c0                	test   %eax,%eax
80101182:	7f 0d                	jg     80101191 <fileclose+0x2d>
    panic("fileclose");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 8d a1 10 80       	push   $0x8010a18d
8010118c:	e8 d5 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101191:	8b 45 08             	mov    0x8(%ebp),%eax
80101194:	8b 40 04             	mov    0x4(%eax),%eax
80101197:	8d 50 ff             	lea    -0x1(%eax),%edx
8010119a:	8b 45 08             	mov    0x8(%ebp),%eax
8010119d:	89 50 04             	mov    %edx,0x4(%eax)
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 40 04             	mov    0x4(%eax),%eax
801011a6:	85 c0                	test   %eax,%eax
801011a8:	7e 15                	jle    801011bf <fileclose+0x5b>
    release(&ftable.lock);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	68 60 28 11 80       	push   $0x80112860
801011b2:	e8 4c 57 00 00       	call   80106903 <release>
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	e9 8b 00 00 00       	jmp    8010124a <fileclose+0xe6>
    return;
  }
  ff = *f;
801011bf:	8b 45 08             	mov    0x8(%ebp),%eax
801011c2:	8b 10                	mov    (%eax),%edx
801011c4:	89 55 e0             	mov    %edx,-0x20(%ebp)
801011c7:	8b 50 04             	mov    0x4(%eax),%edx
801011ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011cd:	8b 50 08             	mov    0x8(%eax),%edx
801011d0:	89 55 e8             	mov    %edx,-0x18(%ebp)
801011d3:	8b 50 0c             	mov    0xc(%eax),%edx
801011d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
801011d9:	8b 50 10             	mov    0x10(%eax),%edx
801011dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801011df:	8b 40 14             	mov    0x14(%eax),%eax
801011e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801011e5:	8b 45 08             	mov    0x8(%ebp),%eax
801011e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801011ef:	8b 45 08             	mov    0x8(%ebp),%eax
801011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801011f8:	83 ec 0c             	sub    $0xc,%esp
801011fb:	68 60 28 11 80       	push   $0x80112860
80101200:	e8 fe 56 00 00       	call   80106903 <release>
80101205:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101208:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010120b:	83 f8 01             	cmp    $0x1,%eax
8010120e:	75 19                	jne    80101229 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101210:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101214:	0f be d0             	movsbl %al,%edx
80101217:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010121a:	83 ec 08             	sub    $0x8,%esp
8010121d:	52                   	push   %edx
8010121e:	50                   	push   %eax
8010121f:	e8 fa 32 00 00       	call   8010451e <pipeclose>
80101224:	83 c4 10             	add    $0x10,%esp
80101227:	eb 21                	jmp    8010124a <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101229:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010122c:	83 f8 02             	cmp    $0x2,%eax
8010122f:	75 19                	jne    8010124a <fileclose+0xe6>
    begin_op();
80101231:	e8 a1 26 00 00       	call   801038d7 <begin_op>
    iput(ff.ip);
80101236:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	50                   	push   %eax
8010123d:	e8 5a 0c 00 00       	call   80101e9c <iput>
80101242:	83 c4 10             	add    $0x10,%esp
    end_op();
80101245:	e8 19 27 00 00       	call   80103963 <end_op>
  }
}
8010124a:	c9                   	leave  
8010124b:	c3                   	ret    

8010124c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010124c:	55                   	push   %ebp
8010124d:	89 e5                	mov    %esp,%ebp
8010124f:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 00                	mov    (%eax),%eax
80101257:	83 f8 02             	cmp    $0x2,%eax
8010125a:	75 40                	jne    8010129c <filestat+0x50>
    ilock(f->ip);
8010125c:	8b 45 08             	mov    0x8(%ebp),%eax
8010125f:	8b 40 10             	mov    0x10(%eax),%eax
80101262:	83 ec 0c             	sub    $0xc,%esp
80101265:	50                   	push   %eax
80101266:	e8 39 0a 00 00       	call   80101ca4 <ilock>
8010126b:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 10             	mov    0x10(%eax),%eax
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	ff 75 0c             	pushl  0xc(%ebp)
8010127a:	50                   	push   %eax
8010127b:	e8 74 0f 00 00       	call   801021f4 <stati>
80101280:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101283:	8b 45 08             	mov    0x8(%ebp),%eax
80101286:	8b 40 10             	mov    0x10(%eax),%eax
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	50                   	push   %eax
8010128d:	e8 98 0b 00 00       	call   80101e2a <iunlock>
80101292:	83 c4 10             	add    $0x10,%esp
    return 0;
80101295:	b8 00 00 00 00       	mov    $0x0,%eax
8010129a:	eb 05                	jmp    801012a1 <filestat+0x55>
  }
  return -1;
8010129c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012a1:	c9                   	leave  
801012a2:	c3                   	ret    

801012a3 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012a3:	55                   	push   %ebp
801012a4:	89 e5                	mov    %esp,%ebp
801012a6:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012a9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ac:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012b0:	84 c0                	test   %al,%al
801012b2:	75 0a                	jne    801012be <fileread+0x1b>
    return -1;
801012b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012b9:	e9 9b 00 00 00       	jmp    80101359 <fileread+0xb6>
  if(f->type == FD_PIPE)
801012be:	8b 45 08             	mov    0x8(%ebp),%eax
801012c1:	8b 00                	mov    (%eax),%eax
801012c3:	83 f8 01             	cmp    $0x1,%eax
801012c6:	75 1a                	jne    801012e2 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 0c             	mov    0xc(%eax),%eax
801012ce:	83 ec 04             	sub    $0x4,%esp
801012d1:	ff 75 10             	pushl  0x10(%ebp)
801012d4:	ff 75 0c             	pushl  0xc(%ebp)
801012d7:	50                   	push   %eax
801012d8:	e8 e9 33 00 00       	call   801046c6 <piperead>
801012dd:	83 c4 10             	add    $0x10,%esp
801012e0:	eb 77                	jmp    80101359 <fileread+0xb6>
  if(f->type == FD_INODE){
801012e2:	8b 45 08             	mov    0x8(%ebp),%eax
801012e5:	8b 00                	mov    (%eax),%eax
801012e7:	83 f8 02             	cmp    $0x2,%eax
801012ea:	75 60                	jne    8010134c <fileread+0xa9>
    ilock(f->ip);
801012ec:	8b 45 08             	mov    0x8(%ebp),%eax
801012ef:	8b 40 10             	mov    0x10(%eax),%eax
801012f2:	83 ec 0c             	sub    $0xc,%esp
801012f5:	50                   	push   %eax
801012f6:	e8 a9 09 00 00       	call   80101ca4 <ilock>
801012fb:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801012fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101301:	8b 45 08             	mov    0x8(%ebp),%eax
80101304:	8b 50 14             	mov    0x14(%eax),%edx
80101307:	8b 45 08             	mov    0x8(%ebp),%eax
8010130a:	8b 40 10             	mov    0x10(%eax),%eax
8010130d:	51                   	push   %ecx
8010130e:	52                   	push   %edx
8010130f:	ff 75 0c             	pushl  0xc(%ebp)
80101312:	50                   	push   %eax
80101313:	e8 4a 0f 00 00       	call   80102262 <readi>
80101318:	83 c4 10             	add    $0x10,%esp
8010131b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010131e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101322:	7e 11                	jle    80101335 <fileread+0x92>
      f->off += r;
80101324:	8b 45 08             	mov    0x8(%ebp),%eax
80101327:	8b 50 14             	mov    0x14(%eax),%edx
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	01 c2                	add    %eax,%edx
8010132f:	8b 45 08             	mov    0x8(%ebp),%eax
80101332:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 40 10             	mov    0x10(%eax),%eax
8010133b:	83 ec 0c             	sub    $0xc,%esp
8010133e:	50                   	push   %eax
8010133f:	e8 e6 0a 00 00       	call   80101e2a <iunlock>
80101344:	83 c4 10             	add    $0x10,%esp
    return r;
80101347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134a:	eb 0d                	jmp    80101359 <fileread+0xb6>
  }
  panic("fileread");
8010134c:	83 ec 0c             	sub    $0xc,%esp
8010134f:	68 97 a1 10 80       	push   $0x8010a197
80101354:	e8 0d f2 ff ff       	call   80100566 <panic>
}
80101359:	c9                   	leave  
8010135a:	c3                   	ret    

8010135b <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010135b:	55                   	push   %ebp
8010135c:	89 e5                	mov    %esp,%ebp
8010135e:	53                   	push   %ebx
8010135f:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101362:	8b 45 08             	mov    0x8(%ebp),%eax
80101365:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101369:	84 c0                	test   %al,%al
8010136b:	75 0a                	jne    80101377 <filewrite+0x1c>
    return -1;
8010136d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101372:	e9 1b 01 00 00       	jmp    80101492 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101377:	8b 45 08             	mov    0x8(%ebp),%eax
8010137a:	8b 00                	mov    (%eax),%eax
8010137c:	83 f8 01             	cmp    $0x1,%eax
8010137f:	75 1d                	jne    8010139e <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101381:	8b 45 08             	mov    0x8(%ebp),%eax
80101384:	8b 40 0c             	mov    0xc(%eax),%eax
80101387:	83 ec 04             	sub    $0x4,%esp
8010138a:	ff 75 10             	pushl  0x10(%ebp)
8010138d:	ff 75 0c             	pushl  0xc(%ebp)
80101390:	50                   	push   %eax
80101391:	e8 32 32 00 00       	call   801045c8 <pipewrite>
80101396:	83 c4 10             	add    $0x10,%esp
80101399:	e9 f4 00 00 00       	jmp    80101492 <filewrite+0x137>
  if(f->type == FD_INODE){
8010139e:	8b 45 08             	mov    0x8(%ebp),%eax
801013a1:	8b 00                	mov    (%eax),%eax
801013a3:	83 f8 02             	cmp    $0x2,%eax
801013a6:	0f 85 d9 00 00 00    	jne    80101485 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013ac:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013ba:	e9 a3 00 00 00       	jmp    80101462 <filewrite+0x107>
      int n1 = n - i;
801013bf:	8b 45 10             	mov    0x10(%ebp),%eax
801013c2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801013ce:	7e 06                	jle    801013d6 <filewrite+0x7b>
        n1 = max;
801013d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013d3:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801013d6:	e8 fc 24 00 00       	call   801038d7 <begin_op>
      ilock(f->ip);
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	8b 40 10             	mov    0x10(%eax),%eax
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	50                   	push   %eax
801013e5:	e8 ba 08 00 00       	call   80101ca4 <ilock>
801013ea:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801013f0:	8b 45 08             	mov    0x8(%ebp),%eax
801013f3:	8b 50 14             	mov    0x14(%eax),%edx
801013f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801013fc:	01 c3                	add    %eax,%ebx
801013fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101401:	8b 40 10             	mov    0x10(%eax),%eax
80101404:	51                   	push   %ecx
80101405:	52                   	push   %edx
80101406:	53                   	push   %ebx
80101407:	50                   	push   %eax
80101408:	e8 ac 0f 00 00       	call   801023b9 <writei>
8010140d:	83 c4 10             	add    $0x10,%esp
80101410:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101413:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101417:	7e 11                	jle    8010142a <filewrite+0xcf>
        f->off += r;
80101419:	8b 45 08             	mov    0x8(%ebp),%eax
8010141c:	8b 50 14             	mov    0x14(%eax),%edx
8010141f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101422:	01 c2                	add    %eax,%edx
80101424:	8b 45 08             	mov    0x8(%ebp),%eax
80101427:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010142a:	8b 45 08             	mov    0x8(%ebp),%eax
8010142d:	8b 40 10             	mov    0x10(%eax),%eax
80101430:	83 ec 0c             	sub    $0xc,%esp
80101433:	50                   	push   %eax
80101434:	e8 f1 09 00 00       	call   80101e2a <iunlock>
80101439:	83 c4 10             	add    $0x10,%esp
      end_op();
8010143c:	e8 22 25 00 00       	call   80103963 <end_op>

      if(r < 0)
80101441:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101445:	78 29                	js     80101470 <filewrite+0x115>
        break;
      if(r != n1)
80101447:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010144a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010144d:	74 0d                	je     8010145c <filewrite+0x101>
        panic("short filewrite");
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	68 a0 a1 10 80       	push   $0x8010a1a0
80101457:	e8 0a f1 ff ff       	call   80100566 <panic>
      i += r;
8010145c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010145f:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101465:	3b 45 10             	cmp    0x10(%ebp),%eax
80101468:	0f 8c 51 ff ff ff    	jl     801013bf <filewrite+0x64>
8010146e:	eb 01                	jmp    80101471 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101470:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101474:	3b 45 10             	cmp    0x10(%ebp),%eax
80101477:	75 05                	jne    8010147e <filewrite+0x123>
80101479:	8b 45 10             	mov    0x10(%ebp),%eax
8010147c:	eb 14                	jmp    80101492 <filewrite+0x137>
8010147e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101483:	eb 0d                	jmp    80101492 <filewrite+0x137>
  }
  panic("filewrite");
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	68 b0 a1 10 80       	push   $0x8010a1b0
8010148d:	e8 d4 f0 ff ff       	call   80100566 <panic>
}
80101492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101495:	c9                   	leave  
80101496:	c3                   	ret    

80101497 <fschmod>:

#ifdef CS333_P5
//System call implementations for chown, chmod, chgrp
int
fschmod(char * pathname, int mode)
{
80101497:	55                   	push   %ebp
80101498:	89 e5                	mov    %esp,%ebp
8010149a:	83 ec 18             	sub    $0x18,%esp
    struct inode* node = namei(pathname);
8010149d:	83 ec 0c             	sub    $0xc,%esp
801014a0:	ff 75 08             	pushl  0x8(%ebp)
801014a3:	e8 0a 14 00 00       	call   801028b2 <namei>
801014a8:	83 c4 10             	add    $0x10,%esp
801014ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!node) return -1;
801014ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801014b2:	75 07                	jne    801014bb <fschmod+0x24>
801014b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014b9:	eb 42                	jmp    801014fd <fschmod+0x66>

    begin_op();
801014bb:	e8 17 24 00 00       	call   801038d7 <begin_op>
    ilock(node);
801014c0:	83 ec 0c             	sub    $0xc,%esp
801014c3:	ff 75 f4             	pushl  -0xc(%ebp)
801014c6:	e8 d9 07 00 00       	call   80101ca4 <ilock>
801014cb:	83 c4 10             	add    $0x10,%esp
    node->mode.asInt = mode;
801014ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d4:	89 50 1c             	mov    %edx,0x1c(%eax)
    iupdate(node);
801014d7:	83 ec 0c             	sub    $0xc,%esp
801014da:	ff 75 f4             	pushl  -0xc(%ebp)
801014dd:	e8 c0 05 00 00       	call   80101aa2 <iupdate>
801014e2:	83 c4 10             	add    $0x10,%esp
    iunlock(node);
801014e5:	83 ec 0c             	sub    $0xc,%esp
801014e8:	ff 75 f4             	pushl  -0xc(%ebp)
801014eb:	e8 3a 09 00 00       	call   80101e2a <iunlock>
801014f0:	83 c4 10             	add    $0x10,%esp
    end_op();
801014f3:	e8 6b 24 00 00       	call   80103963 <end_op>

    return 0;
801014f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801014fd:	c9                   	leave  
801014fe:	c3                   	ret    

801014ff <fschown>:

int 
fschown(char * pathname, int owner)
{
801014ff:	55                   	push   %ebp
80101500:	89 e5                	mov    %esp,%ebp
80101502:	83 ec 18             	sub    $0x18,%esp
    struct inode* node = namei(pathname);
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	ff 75 08             	pushl  0x8(%ebp)
8010150b:	e8 a2 13 00 00       	call   801028b2 <namei>
80101510:	83 c4 10             	add    $0x10,%esp
80101513:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!node) return -1;
80101516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010151a:	75 07                	jne    80101523 <fschown+0x24>
8010151c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101521:	eb 45                	jmp    80101568 <fschown+0x69>

    begin_op();
80101523:	e8 af 23 00 00       	call   801038d7 <begin_op>
    ilock(node);
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	ff 75 f4             	pushl  -0xc(%ebp)
8010152e:	e8 71 07 00 00       	call   80101ca4 <ilock>
80101533:	83 c4 10             	add    $0x10,%esp
    node->uid = owner;
80101536:	8b 45 0c             	mov    0xc(%ebp),%eax
80101539:	89 c2                	mov    %eax,%edx
8010153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010153e:	66 89 50 18          	mov    %dx,0x18(%eax)
    iupdate(node);
80101542:	83 ec 0c             	sub    $0xc,%esp
80101545:	ff 75 f4             	pushl  -0xc(%ebp)
80101548:	e8 55 05 00 00       	call   80101aa2 <iupdate>
8010154d:	83 c4 10             	add    $0x10,%esp
    iunlock(node);
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	ff 75 f4             	pushl  -0xc(%ebp)
80101556:	e8 cf 08 00 00       	call   80101e2a <iunlock>
8010155b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010155e:	e8 00 24 00 00       	call   80103963 <end_op>

    return 0;
80101563:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101568:	c9                   	leave  
80101569:	c3                   	ret    

8010156a <fschgrp>:

int 
fschgrp(char * pathname, int group)
{
8010156a:	55                   	push   %ebp
8010156b:	89 e5                	mov    %esp,%ebp
8010156d:	83 ec 18             	sub    $0x18,%esp
    struct inode* node = namei(pathname);
80101570:	83 ec 0c             	sub    $0xc,%esp
80101573:	ff 75 08             	pushl  0x8(%ebp)
80101576:	e8 37 13 00 00       	call   801028b2 <namei>
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!node) return -1;
80101581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101585:	75 07                	jne    8010158e <fschgrp+0x24>
80101587:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010158c:	eb 45                	jmp    801015d3 <fschgrp+0x69>
    
    begin_op();
8010158e:	e8 44 23 00 00       	call   801038d7 <begin_op>
    ilock(node);
80101593:	83 ec 0c             	sub    $0xc,%esp
80101596:	ff 75 f4             	pushl  -0xc(%ebp)
80101599:	e8 06 07 00 00       	call   80101ca4 <ilock>
8010159e:	83 c4 10             	add    $0x10,%esp
    node->gid = group;
801015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a4:	89 c2                	mov    %eax,%edx
801015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a9:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    iupdate(node);
801015ad:	83 ec 0c             	sub    $0xc,%esp
801015b0:	ff 75 f4             	pushl  -0xc(%ebp)
801015b3:	e8 ea 04 00 00       	call   80101aa2 <iupdate>
801015b8:	83 c4 10             	add    $0x10,%esp
    iunlock(node);
801015bb:	83 ec 0c             	sub    $0xc,%esp
801015be:	ff 75 f4             	pushl  -0xc(%ebp)
801015c1:	e8 64 08 00 00       	call   80101e2a <iunlock>
801015c6:	83 c4 10             	add    $0x10,%esp
    end_op();
801015c9:	e8 95 23 00 00       	call   80103963 <end_op>

    return 0;
801015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801015d3:	c9                   	leave  
801015d4:	c3                   	ret    

801015d5 <checksetuid>:

int 
checksetuid(struct inode* ip)
{
801015d5:	55                   	push   %ebp
801015d6:	89 e5                	mov    %esp,%ebp
    if(!ip) return -1;
801015d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801015dc:	75 07                	jne    801015e5 <checksetuid+0x10>
801015de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015e3:	eb 1f                	jmp    80101604 <checksetuid+0x2f>

    if(ip->mode.flags.setuid == 1)
801015e5:	8b 45 08             	mov    0x8(%ebp),%eax
801015e8:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
801015ec:	83 e0 02             	and    $0x2,%eax
801015ef:	84 c0                	test   %al,%al
801015f1:	74 0c                	je     801015ff <checksetuid+0x2a>
        return ip->uid;
801015f3:	8b 45 08             	mov    0x8(%ebp),%eax
801015f6:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801015fa:	0f b7 c0             	movzwl %ax,%eax
801015fd:	eb 05                	jmp    80101604 <checksetuid+0x2f>
    else
        return -1;
801015ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101604:	5d                   	pop    %ebp
80101605:	c3                   	ret    

80101606 <fscheckperms>:

int
fscheckperms(struct inode* ip, uint uid, uint gid)
{
80101606:	55                   	push   %ebp
80101607:	89 e5                	mov    %esp,%ebp
    if(!ip) return 0;
80101609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010160d:	75 07                	jne    80101616 <fscheckperms+0x10>
8010160f:	b8 00 00 00 00       	mov    $0x0,%eax
80101614:	eb 62                	jmp    80101678 <fscheckperms+0x72>

    if(ip->uid == uid && ip->mode.flags.u_x != 0)
80101616:	8b 45 08             	mov    0x8(%ebp),%eax
80101619:	0f b7 40 18          	movzwl 0x18(%eax),%eax
8010161d:	0f b7 c0             	movzwl %ax,%eax
80101620:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101623:	75 15                	jne    8010163a <fscheckperms+0x34>
80101625:	8b 45 08             	mov    0x8(%ebp),%eax
80101628:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
8010162c:	83 e0 40             	and    $0x40,%eax
8010162f:	84 c0                	test   %al,%al
80101631:	74 07                	je     8010163a <fscheckperms+0x34>
        return 1;
80101633:	b8 01 00 00 00       	mov    $0x1,%eax
80101638:	eb 3e                	jmp    80101678 <fscheckperms+0x72>
    if(ip->gid == gid && ip->mode.flags.g_x != 0)
8010163a:	8b 45 08             	mov    0x8(%ebp),%eax
8010163d:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80101641:	0f b7 c0             	movzwl %ax,%eax
80101644:	3b 45 10             	cmp    0x10(%ebp),%eax
80101647:	75 15                	jne    8010165e <fscheckperms+0x58>
80101649:	8b 45 08             	mov    0x8(%ebp),%eax
8010164c:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
80101650:	83 e0 08             	and    $0x8,%eax
80101653:	84 c0                	test   %al,%al
80101655:	74 07                	je     8010165e <fscheckperms+0x58>
        return 1;
80101657:	b8 01 00 00 00       	mov    $0x1,%eax
8010165c:	eb 1a                	jmp    80101678 <fscheckperms+0x72>
    if(ip->mode.flags.o_x == 1)
8010165e:	8b 45 08             	mov    0x8(%ebp),%eax
80101661:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
80101665:	83 e0 01             	and    $0x1,%eax
80101668:	84 c0                	test   %al,%al
8010166a:	74 07                	je     80101673 <fscheckperms+0x6d>
        return 1;
8010166c:	b8 01 00 00 00       	mov    $0x1,%eax
80101671:	eb 05                	jmp    80101678 <fscheckperms+0x72>

    return 0;
80101673:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101678:	5d                   	pop    %ebp
80101679:	c3                   	ret    

8010167a <readsb>:
#endif

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010167a:	55                   	push   %ebp
8010167b:	89 e5                	mov    %esp,%ebp
8010167d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101680:	8b 45 08             	mov    0x8(%ebp),%eax
80101683:	83 ec 08             	sub    $0x8,%esp
80101686:	6a 01                	push   $0x1
80101688:	50                   	push   %eax
80101689:	e8 28 eb ff ff       	call   801001b6 <bread>
8010168e:	83 c4 10             	add    $0x10,%esp
80101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101697:	83 c0 18             	add    $0x18,%eax
8010169a:	83 ec 04             	sub    $0x4,%esp
8010169d:	6a 1c                	push   $0x1c
8010169f:	50                   	push   %eax
801016a0:	ff 75 0c             	pushl  0xc(%ebp)
801016a3:	e8 16 55 00 00       	call   80106bbe <memmove>
801016a8:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016ab:	83 ec 0c             	sub    $0xc,%esp
801016ae:	ff 75 f4             	pushl  -0xc(%ebp)
801016b1:	e8 78 eb ff ff       	call   8010022e <brelse>
801016b6:	83 c4 10             	add    $0x10,%esp
}
801016b9:	90                   	nop
801016ba:	c9                   	leave  
801016bb:	c3                   	ret    

801016bc <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801016bc:	55                   	push   %ebp
801016bd:	89 e5                	mov    %esp,%ebp
801016bf:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801016c5:	8b 45 08             	mov    0x8(%ebp),%eax
801016c8:	83 ec 08             	sub    $0x8,%esp
801016cb:	52                   	push   %edx
801016cc:	50                   	push   %eax
801016cd:	e8 e4 ea ff ff       	call   801001b6 <bread>
801016d2:	83 c4 10             	add    $0x10,%esp
801016d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016db:	83 c0 18             	add    $0x18,%eax
801016de:	83 ec 04             	sub    $0x4,%esp
801016e1:	68 00 02 00 00       	push   $0x200
801016e6:	6a 00                	push   $0x0
801016e8:	50                   	push   %eax
801016e9:	e8 11 54 00 00       	call   80106aff <memset>
801016ee:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801016f1:	83 ec 0c             	sub    $0xc,%esp
801016f4:	ff 75 f4             	pushl  -0xc(%ebp)
801016f7:	e8 13 24 00 00       	call   80103b0f <log_write>
801016fc:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016ff:	83 ec 0c             	sub    $0xc,%esp
80101702:	ff 75 f4             	pushl  -0xc(%ebp)
80101705:	e8 24 eb ff ff       	call   8010022e <brelse>
8010170a:	83 c4 10             	add    $0x10,%esp
}
8010170d:	90                   	nop
8010170e:	c9                   	leave  
8010170f:	c3                   	ret    

80101710 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101716:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010171d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101724:	e9 13 01 00 00       	jmp    8010183c <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101732:	85 c0                	test   %eax,%eax
80101734:	0f 48 c2             	cmovs  %edx,%eax
80101737:	c1 f8 0c             	sar    $0xc,%eax
8010173a:	89 c2                	mov    %eax,%edx
8010173c:	a1 78 32 11 80       	mov    0x80113278,%eax
80101741:	01 d0                	add    %edx,%eax
80101743:	83 ec 08             	sub    $0x8,%esp
80101746:	50                   	push   %eax
80101747:	ff 75 08             	pushl  0x8(%ebp)
8010174a:	e8 67 ea ff ff       	call   801001b6 <bread>
8010174f:	83 c4 10             	add    $0x10,%esp
80101752:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010175c:	e9 a6 00 00 00       	jmp    80101807 <balloc+0xf7>
      m = 1 << (bi % 8);
80101761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101764:	99                   	cltd   
80101765:	c1 ea 1d             	shr    $0x1d,%edx
80101768:	01 d0                	add    %edx,%eax
8010176a:	83 e0 07             	and    $0x7,%eax
8010176d:	29 d0                	sub    %edx,%eax
8010176f:	ba 01 00 00 00       	mov    $0x1,%edx
80101774:	89 c1                	mov    %eax,%ecx
80101776:	d3 e2                	shl    %cl,%edx
80101778:	89 d0                	mov    %edx,%eax
8010177a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101780:	8d 50 07             	lea    0x7(%eax),%edx
80101783:	85 c0                	test   %eax,%eax
80101785:	0f 48 c2             	cmovs  %edx,%eax
80101788:	c1 f8 03             	sar    $0x3,%eax
8010178b:	89 c2                	mov    %eax,%edx
8010178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101790:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101795:	0f b6 c0             	movzbl %al,%eax
80101798:	23 45 e8             	and    -0x18(%ebp),%eax
8010179b:	85 c0                	test   %eax,%eax
8010179d:	75 64                	jne    80101803 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010179f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a2:	8d 50 07             	lea    0x7(%eax),%edx
801017a5:	85 c0                	test   %eax,%eax
801017a7:	0f 48 c2             	cmovs  %edx,%eax
801017aa:	c1 f8 03             	sar    $0x3,%eax
801017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
801017b0:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801017b5:	89 d1                	mov    %edx,%ecx
801017b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801017ba:	09 ca                	or     %ecx,%edx
801017bc:	89 d1                	mov    %edx,%ecx
801017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
801017c1:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801017c5:	83 ec 0c             	sub    $0xc,%esp
801017c8:	ff 75 ec             	pushl  -0x14(%ebp)
801017cb:	e8 3f 23 00 00       	call   80103b0f <log_write>
801017d0:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 75 ec             	pushl  -0x14(%ebp)
801017d9:	e8 50 ea ff ff       	call   8010022e <brelse>
801017de:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801017e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e7:	01 c2                	add    %eax,%edx
801017e9:	8b 45 08             	mov    0x8(%ebp),%eax
801017ec:	83 ec 08             	sub    $0x8,%esp
801017ef:	52                   	push   %edx
801017f0:	50                   	push   %eax
801017f1:	e8 c6 fe ff ff       	call   801016bc <bzero>
801017f6:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801017f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ff:	01 d0                	add    %edx,%eax
80101801:	eb 57                	jmp    8010185a <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101803:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101807:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010180e:	7f 17                	jg     80101827 <balloc+0x117>
80101810:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101816:	01 d0                	add    %edx,%eax
80101818:	89 c2                	mov    %eax,%edx
8010181a:	a1 60 32 11 80       	mov    0x80113260,%eax
8010181f:	39 c2                	cmp    %eax,%edx
80101821:	0f 82 3a ff ff ff    	jb     80101761 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	ff 75 ec             	pushl  -0x14(%ebp)
8010182d:	e8 fc e9 ff ff       	call   8010022e <brelse>
80101832:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101835:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010183c:	8b 15 60 32 11 80    	mov    0x80113260,%edx
80101842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101845:	39 c2                	cmp    %eax,%edx
80101847:	0f 87 dc fe ff ff    	ja     80101729 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010184d:	83 ec 0c             	sub    $0xc,%esp
80101850:	68 bc a1 10 80       	push   $0x8010a1bc
80101855:	e8 0c ed ff ff       	call   80100566 <panic>
}
8010185a:	c9                   	leave  
8010185b:	c3                   	ret    

8010185c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010185c:	55                   	push   %ebp
8010185d:	89 e5                	mov    %esp,%ebp
8010185f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101862:	83 ec 08             	sub    $0x8,%esp
80101865:	68 60 32 11 80       	push   $0x80113260
8010186a:	ff 75 08             	pushl  0x8(%ebp)
8010186d:	e8 08 fe ff ff       	call   8010167a <readsb>
80101872:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101875:	8b 45 0c             	mov    0xc(%ebp),%eax
80101878:	c1 e8 0c             	shr    $0xc,%eax
8010187b:	89 c2                	mov    %eax,%edx
8010187d:	a1 78 32 11 80       	mov    0x80113278,%eax
80101882:	01 c2                	add    %eax,%edx
80101884:	8b 45 08             	mov    0x8(%ebp),%eax
80101887:	83 ec 08             	sub    $0x8,%esp
8010188a:	52                   	push   %edx
8010188b:	50                   	push   %eax
8010188c:	e8 25 e9 ff ff       	call   801001b6 <bread>
80101891:	83 c4 10             	add    $0x10,%esp
80101894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101897:	8b 45 0c             	mov    0xc(%ebp),%eax
8010189a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a5:	99                   	cltd   
801018a6:	c1 ea 1d             	shr    $0x1d,%edx
801018a9:	01 d0                	add    %edx,%eax
801018ab:	83 e0 07             	and    $0x7,%eax
801018ae:	29 d0                	sub    %edx,%eax
801018b0:	ba 01 00 00 00       	mov    $0x1,%edx
801018b5:	89 c1                	mov    %eax,%ecx
801018b7:	d3 e2                	shl    %cl,%edx
801018b9:	89 d0                	mov    %edx,%eax
801018bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c1:	8d 50 07             	lea    0x7(%eax),%edx
801018c4:	85 c0                	test   %eax,%eax
801018c6:	0f 48 c2             	cmovs  %edx,%eax
801018c9:	c1 f8 03             	sar    $0x3,%eax
801018cc:	89 c2                	mov    %eax,%edx
801018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d1:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801018d6:	0f b6 c0             	movzbl %al,%eax
801018d9:	23 45 ec             	and    -0x14(%ebp),%eax
801018dc:	85 c0                	test   %eax,%eax
801018de:	75 0d                	jne    801018ed <bfree+0x91>
    panic("freeing free block");
801018e0:	83 ec 0c             	sub    $0xc,%esp
801018e3:	68 d2 a1 10 80       	push   $0x8010a1d2
801018e8:	e8 79 ec ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f0:	8d 50 07             	lea    0x7(%eax),%edx
801018f3:	85 c0                	test   %eax,%eax
801018f5:	0f 48 c2             	cmovs  %edx,%eax
801018f8:	c1 f8 03             	sar    $0x3,%eax
801018fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801018fe:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101903:	89 d1                	mov    %edx,%ecx
80101905:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101908:	f7 d2                	not    %edx
8010190a:	21 ca                	and    %ecx,%edx
8010190c:	89 d1                	mov    %edx,%ecx
8010190e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101911:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101915:	83 ec 0c             	sub    $0xc,%esp
80101918:	ff 75 f4             	pushl  -0xc(%ebp)
8010191b:	e8 ef 21 00 00       	call   80103b0f <log_write>
80101920:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101923:	83 ec 0c             	sub    $0xc,%esp
80101926:	ff 75 f4             	pushl  -0xc(%ebp)
80101929:	e8 00 e9 ff ff       	call   8010022e <brelse>
8010192e:	83 c4 10             	add    $0x10,%esp
}
80101931:	90                   	nop
80101932:	c9                   	leave  
80101933:	c3                   	ret    

80101934 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101934:	55                   	push   %ebp
80101935:	89 e5                	mov    %esp,%ebp
80101937:	57                   	push   %edi
80101938:	56                   	push   %esi
80101939:	53                   	push   %ebx
8010193a:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010193d:	83 ec 08             	sub    $0x8,%esp
80101940:	68 e5 a1 10 80       	push   $0x8010a1e5
80101945:	68 80 32 11 80       	push   $0x80113280
8010194a:	e8 2b 4f 00 00       	call   8010687a <initlock>
8010194f:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101952:	83 ec 08             	sub    $0x8,%esp
80101955:	68 60 32 11 80       	push   $0x80113260
8010195a:	ff 75 08             	pushl  0x8(%ebp)
8010195d:	e8 18 fd ff ff       	call   8010167a <readsb>
80101962:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101965:	a1 78 32 11 80       	mov    0x80113278,%eax
8010196a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010196d:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
80101973:	8b 35 70 32 11 80    	mov    0x80113270,%esi
80101979:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
8010197f:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
80101985:	8b 15 64 32 11 80    	mov    0x80113264,%edx
8010198b:	a1 60 32 11 80       	mov    0x80113260,%eax
80101990:	ff 75 e4             	pushl  -0x1c(%ebp)
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	51                   	push   %ecx
80101997:	52                   	push   %edx
80101998:	50                   	push   %eax
80101999:	68 ec a1 10 80       	push   $0x8010a1ec
8010199e:	e8 23 ea ff ff       	call   801003c6 <cprintf>
801019a3:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801019a6:	90                   	nop
801019a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019aa:	5b                   	pop    %ebx
801019ab:	5e                   	pop    %esi
801019ac:	5f                   	pop    %edi
801019ad:	5d                   	pop    %ebp
801019ae:	c3                   	ret    

801019af <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801019af:	55                   	push   %ebp
801019b0:	89 e5                	mov    %esp,%ebp
801019b2:	83 ec 28             	sub    $0x28,%esp
801019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801019b8:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801019bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801019c3:	e9 ba 00 00 00       	jmp    80101a82 <ialloc+0xd3>
    bp = bread(dev, IBLOCK(inum, sb));
801019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cb:	c1 e8 03             	shr    $0x3,%eax
801019ce:	89 c2                	mov    %eax,%edx
801019d0:	a1 74 32 11 80       	mov    0x80113274,%eax
801019d5:	01 d0                	add    %edx,%eax
801019d7:	83 ec 08             	sub    $0x8,%esp
801019da:	50                   	push   %eax
801019db:	ff 75 08             	pushl  0x8(%ebp)
801019de:	e8 d3 e7 ff ff       	call   801001b6 <bread>
801019e3:	83 c4 10             	add    $0x10,%esp
801019e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801019e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ec:	8d 50 18             	lea    0x18(%eax),%edx
801019ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f2:	83 e0 07             	and    $0x7,%eax
801019f5:	c1 e0 06             	shl    $0x6,%eax
801019f8:	01 d0                	add    %edx,%eax
801019fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801019fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101a00:	0f b7 00             	movzwl (%eax),%eax
80101a03:	66 85 c0             	test   %ax,%ax
80101a06:	75 68                	jne    80101a70 <ialloc+0xc1>
      memset(dip, 0, sizeof(*dip));
80101a08:	83 ec 04             	sub    $0x4,%esp
80101a0b:	6a 40                	push   $0x40
80101a0d:	6a 00                	push   $0x0
80101a0f:	ff 75 ec             	pushl  -0x14(%ebp)
80101a12:	e8 e8 50 00 00       	call   80106aff <memset>
80101a17:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101a1d:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101a21:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101a24:	83 ec 0c             	sub    $0xc,%esp
80101a27:	ff 75 f0             	pushl  -0x10(%ebp)
80101a2a:	e8 e0 20 00 00       	call   80103b0f <log_write>
80101a2f:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	ff 75 f0             	pushl  -0x10(%ebp)
80101a38:	e8 f1 e7 ff ff       	call   8010022e <brelse>
80101a3d:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P5
      dip->uid = DEFAULT_UID;
80101a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101a43:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = DEFAULT_UID;
80101a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101a4c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
      dip->mode.asInt = DEFAULT_MODE;
80101a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101a55:	c7 40 0c fd 01 00 00 	movl   $0x1fd,0xc(%eax)
#endif
      return iget(dev, inum);
80101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 75 08             	pushl  0x8(%ebp)
80101a66:	e8 20 01 00 00       	call   80101b8b <iget>
80101a6b:	83 c4 10             	add    $0x10,%esp
80101a6e:	eb 30                	jmp    80101aa0 <ialloc+0xf1>
    }
    brelse(bp);
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	ff 75 f0             	pushl  -0x10(%ebp)
80101a76:	e8 b3 e7 ff ff       	call   8010022e <brelse>
80101a7b:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101a7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101a82:	8b 15 68 32 11 80    	mov    0x80113268,%edx
80101a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a8b:	39 c2                	cmp    %eax,%edx
80101a8d:	0f 87 35 ff ff ff    	ja     801019c8 <ialloc+0x19>
#endif
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 3f a2 10 80       	push   $0x8010a23f
80101a9b:	e8 c6 ea ff ff       	call   80100566 <panic>
}
80101aa0:	c9                   	leave  
80101aa1:	c3                   	ret    

80101aa2 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101aa2:	55                   	push   %ebp
80101aa3:	89 e5                	mov    %esp,%ebp
80101aa5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	8b 40 04             	mov    0x4(%eax),%eax
80101aae:	c1 e8 03             	shr    $0x3,%eax
80101ab1:	89 c2                	mov    %eax,%edx
80101ab3:	a1 74 32 11 80       	mov    0x80113274,%eax
80101ab8:	01 c2                	add    %eax,%edx
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	8b 00                	mov    (%eax),%eax
80101abf:	83 ec 08             	sub    $0x8,%esp
80101ac2:	52                   	push   %edx
80101ac3:	50                   	push   %eax
80101ac4:	e8 ed e6 ff ff       	call   801001b6 <bread>
80101ac9:	83 c4 10             	add    $0x10,%esp
80101acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ad2:	8d 50 18             	lea    0x18(%eax),%edx
80101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad8:	8b 40 04             	mov    0x4(%eax),%eax
80101adb:	83 e0 07             	and    $0x7,%eax
80101ade:	c1 e0 06             	shl    $0x6,%eax
80101ae1:	01 d0                	add    %edx,%eax
80101ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af0:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101afd:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101b01:	8b 45 08             	mov    0x8(%ebp),%eax
80101b04:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0b:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b12:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b19:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b20:	8b 50 20             	mov    0x20(%eax),%edx
80101b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b26:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P5
  dip->uid = ip->uid;
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80101b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b33:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101b37:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3a:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80101b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b41:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	8b 50 1c             	mov    0x1c(%eax),%edx
80101b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b4e:	89 50 0c             	mov    %edx,0xc(%eax)
#endif
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8d 50 24             	lea    0x24(%eax),%edx
80101b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b5a:	83 c0 14             	add    $0x14,%eax
80101b5d:	83 ec 04             	sub    $0x4,%esp
80101b60:	6a 2c                	push   $0x2c
80101b62:	52                   	push   %edx
80101b63:	50                   	push   %eax
80101b64:	e8 55 50 00 00       	call   80106bbe <memmove>
80101b69:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101b6c:	83 ec 0c             	sub    $0xc,%esp
80101b6f:	ff 75 f4             	pushl  -0xc(%ebp)
80101b72:	e8 98 1f 00 00       	call   80103b0f <log_write>
80101b77:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101b7a:	83 ec 0c             	sub    $0xc,%esp
80101b7d:	ff 75 f4             	pushl  -0xc(%ebp)
80101b80:	e8 a9 e6 ff ff       	call   8010022e <brelse>
80101b85:	83 c4 10             	add    $0x10,%esp
}
80101b88:	90                   	nop
80101b89:	c9                   	leave  
80101b8a:	c3                   	ret    

80101b8b <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101b8b:	55                   	push   %ebp
80101b8c:	89 e5                	mov    %esp,%ebp
80101b8e:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101b91:	83 ec 0c             	sub    $0xc,%esp
80101b94:	68 80 32 11 80       	push   $0x80113280
80101b99:	e8 fe 4c 00 00       	call   8010689c <acquire>
80101b9e:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101ba1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ba8:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
80101baf:	eb 5d                	jmp    80101c0e <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bb4:	8b 40 08             	mov    0x8(%eax),%eax
80101bb7:	85 c0                	test   %eax,%eax
80101bb9:	7e 39                	jle    80101bf4 <iget+0x69>
80101bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bbe:	8b 00                	mov    (%eax),%eax
80101bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
80101bc3:	75 2f                	jne    80101bf4 <iget+0x69>
80101bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc8:	8b 40 04             	mov    0x4(%eax),%eax
80101bcb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101bce:	75 24                	jne    80101bf4 <iget+0x69>
      ip->ref++;
80101bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bd3:	8b 40 08             	mov    0x8(%eax),%eax
80101bd6:	8d 50 01             	lea    0x1(%eax),%edx
80101bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bdc:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101bdf:	83 ec 0c             	sub    $0xc,%esp
80101be2:	68 80 32 11 80       	push   $0x80113280
80101be7:	e8 17 4d 00 00       	call   80106903 <release>
80101bec:	83 c4 10             	add    $0x10,%esp
      return ip;
80101bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf2:	eb 74                	jmp    80101c68 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101bf8:	75 10                	jne    80101c0a <iget+0x7f>
80101bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bfd:	8b 40 08             	mov    0x8(%eax),%eax
80101c00:	85 c0                	test   %eax,%eax
80101c02:	75 06                	jne    80101c0a <iget+0x7f>
      empty = ip;
80101c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c07:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c0a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101c0e:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101c15:	72 9a                	jb     80101bb1 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101c1b:	75 0d                	jne    80101c2a <iget+0x9f>
    panic("iget: no inodes");
80101c1d:	83 ec 0c             	sub    $0xc,%esp
80101c20:	68 51 a2 10 80       	push   $0x8010a251
80101c25:	e8 3c e9 ff ff       	call   80100566 <panic>

  ip = empty;
80101c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c33:	8b 55 08             	mov    0x8(%ebp),%edx
80101c36:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c3e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c44:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 80 32 11 80       	push   $0x80113280
80101c5d:	e8 a1 4c 00 00       	call   80106903 <release>
80101c62:	83 c4 10             	add    $0x10,%esp

  return ip;
80101c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101c68:	c9                   	leave  
80101c69:	c3                   	ret    

80101c6a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101c6a:	55                   	push   %ebp
80101c6b:	89 e5                	mov    %esp,%ebp
80101c6d:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101c70:	83 ec 0c             	sub    $0xc,%esp
80101c73:	68 80 32 11 80       	push   $0x80113280
80101c78:	e8 1f 4c 00 00       	call   8010689c <acquire>
80101c7d:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101c80:	8b 45 08             	mov    0x8(%ebp),%eax
80101c83:	8b 40 08             	mov    0x8(%eax),%eax
80101c86:	8d 50 01             	lea    0x1(%eax),%edx
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c8f:	83 ec 0c             	sub    $0xc,%esp
80101c92:	68 80 32 11 80       	push   $0x80113280
80101c97:	e8 67 4c 00 00       	call   80106903 <release>
80101c9c:	83 c4 10             	add    $0x10,%esp
  return ip;
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ca2:	c9                   	leave  
80101ca3:	c3                   	ret    

80101ca4 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101cae:	74 0a                	je     80101cba <ilock+0x16>
80101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb3:	8b 40 08             	mov    0x8(%eax),%eax
80101cb6:	85 c0                	test   %eax,%eax
80101cb8:	7f 0d                	jg     80101cc7 <ilock+0x23>
    panic("ilock");
80101cba:	83 ec 0c             	sub    $0xc,%esp
80101cbd:	68 61 a2 10 80       	push   $0x8010a261
80101cc2:	e8 9f e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101cc7:	83 ec 0c             	sub    $0xc,%esp
80101cca:	68 80 32 11 80       	push   $0x80113280
80101ccf:	e8 c8 4b 00 00       	call   8010689c <acquire>
80101cd4:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101cd7:	eb 13                	jmp    80101cec <ilock+0x48>
    sleep(ip, &icache.lock);
80101cd9:	83 ec 08             	sub    $0x8,%esp
80101cdc:	68 80 32 11 80       	push   $0x80113280
80101ce1:	ff 75 08             	pushl  0x8(%ebp)
80101ce4:	e8 3a 3b 00 00       	call   80105823 <sleep>
80101ce9:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101cec:	8b 45 08             	mov    0x8(%ebp),%eax
80101cef:	8b 40 0c             	mov    0xc(%eax),%eax
80101cf2:	83 e0 01             	and    $0x1,%eax
80101cf5:	85 c0                	test   %eax,%eax
80101cf7:	75 e0                	jne    80101cd9 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfc:	8b 40 0c             	mov    0xc(%eax),%eax
80101cff:	83 c8 01             	or     $0x1,%eax
80101d02:	89 c2                	mov    %eax,%edx
80101d04:	8b 45 08             	mov    0x8(%ebp),%eax
80101d07:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101d0a:	83 ec 0c             	sub    $0xc,%esp
80101d0d:	68 80 32 11 80       	push   $0x80113280
80101d12:	e8 ec 4b 00 00       	call   80106903 <release>
80101d17:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1d:	8b 40 0c             	mov    0xc(%eax),%eax
80101d20:	83 e0 02             	and    $0x2,%eax
80101d23:	85 c0                	test   %eax,%eax
80101d25:	0f 85 fc 00 00 00    	jne    80101e27 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	8b 40 04             	mov    0x4(%eax),%eax
80101d31:	c1 e8 03             	shr    $0x3,%eax
80101d34:	89 c2                	mov    %eax,%edx
80101d36:	a1 74 32 11 80       	mov    0x80113274,%eax
80101d3b:	01 c2                	add    %eax,%edx
80101d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d40:	8b 00                	mov    (%eax),%eax
80101d42:	83 ec 08             	sub    $0x8,%esp
80101d45:	52                   	push   %edx
80101d46:	50                   	push   %eax
80101d47:	e8 6a e4 ff ff       	call   801001b6 <bread>
80101d4c:	83 c4 10             	add    $0x10,%esp
80101d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d55:	8d 50 18             	lea    0x18(%eax),%edx
80101d58:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5b:	8b 40 04             	mov    0x4(%eax),%eax
80101d5e:	83 e0 07             	and    $0x7,%eax
80101d61:	c1 e0 06             	shl    $0x6,%eax
80101d64:	01 d0                	add    %edx,%eax
80101d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d6c:	0f b7 10             	movzwl (%eax),%edx
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d79:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d87:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8e:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d95:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9c:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da3:	8b 50 10             	mov    0x10(%eax),%edx
80101da6:	8b 45 08             	mov    0x8(%ebp),%eax
80101da9:	89 50 20             	mov    %edx,0x20(%eax)
#ifdef CS333_P5
    ip->uid = dip->uid;
80101dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101daf:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101db3:	8b 45 08             	mov    0x8(%ebp),%eax
80101db6:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dbd:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc4:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dcb:	8b 50 0c             	mov    0xc(%eax),%edx
80101dce:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd1:	89 50 1c             	mov    %edx,0x1c(%eax)
#endif
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd7:	8d 50 14             	lea    0x14(%eax),%edx
80101dda:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddd:	83 c0 24             	add    $0x24,%eax
80101de0:	83 ec 04             	sub    $0x4,%esp
80101de3:	6a 2c                	push   $0x2c
80101de5:	52                   	push   %edx
80101de6:	50                   	push   %eax
80101de7:	e8 d2 4d 00 00       	call   80106bbe <memmove>
80101dec:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	ff 75 f4             	pushl  -0xc(%ebp)
80101df5:	e8 34 e4 ff ff       	call   8010022e <brelse>
80101dfa:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 40 0c             	mov    0xc(%eax),%eax
80101e03:	83 c8 02             	or     $0x2,%eax
80101e06:	89 c2                	mov    %eax,%edx
80101e08:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e11:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e15:	66 85 c0             	test   %ax,%ax
80101e18:	75 0d                	jne    80101e27 <ilock+0x183>
      panic("ilock: no type");
80101e1a:	83 ec 0c             	sub    $0xc,%esp
80101e1d:	68 67 a2 10 80       	push   $0x8010a267
80101e22:	e8 3f e7 ff ff       	call   80100566 <panic>
  }
}
80101e27:	90                   	nop
80101e28:	c9                   	leave  
80101e29:	c3                   	ret    

80101e2a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101e2a:	55                   	push   %ebp
80101e2b:	89 e5                	mov    %esp,%ebp
80101e2d:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101e34:	74 17                	je     80101e4d <iunlock+0x23>
80101e36:	8b 45 08             	mov    0x8(%ebp),%eax
80101e39:	8b 40 0c             	mov    0xc(%eax),%eax
80101e3c:	83 e0 01             	and    $0x1,%eax
80101e3f:	85 c0                	test   %eax,%eax
80101e41:	74 0a                	je     80101e4d <iunlock+0x23>
80101e43:	8b 45 08             	mov    0x8(%ebp),%eax
80101e46:	8b 40 08             	mov    0x8(%eax),%eax
80101e49:	85 c0                	test   %eax,%eax
80101e4b:	7f 0d                	jg     80101e5a <iunlock+0x30>
    panic("iunlock");
80101e4d:	83 ec 0c             	sub    $0xc,%esp
80101e50:	68 76 a2 10 80       	push   $0x8010a276
80101e55:	e8 0c e7 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101e5a:	83 ec 0c             	sub    $0xc,%esp
80101e5d:	68 80 32 11 80       	push   $0x80113280
80101e62:	e8 35 4a 00 00       	call   8010689c <acquire>
80101e67:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6d:	8b 40 0c             	mov    0xc(%eax),%eax
80101e70:	83 e0 fe             	and    $0xfffffffe,%eax
80101e73:	89 c2                	mov    %eax,%edx
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101e7b:	83 ec 0c             	sub    $0xc,%esp
80101e7e:	ff 75 08             	pushl  0x8(%ebp)
80101e81:	e8 8d 3b 00 00       	call   80105a13 <wakeup>
80101e86:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101e89:	83 ec 0c             	sub    $0xc,%esp
80101e8c:	68 80 32 11 80       	push   $0x80113280
80101e91:	e8 6d 4a 00 00       	call   80106903 <release>
80101e96:	83 c4 10             	add    $0x10,%esp
}
80101e99:	90                   	nop
80101e9a:	c9                   	leave  
80101e9b:	c3                   	ret    

80101e9c <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101e9c:	55                   	push   %ebp
80101e9d:	89 e5                	mov    %esp,%ebp
80101e9f:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ea2:	83 ec 0c             	sub    $0xc,%esp
80101ea5:	68 80 32 11 80       	push   $0x80113280
80101eaa:	e8 ed 49 00 00       	call   8010689c <acquire>
80101eaf:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb5:	8b 40 08             	mov    0x8(%eax),%eax
80101eb8:	83 f8 01             	cmp    $0x1,%eax
80101ebb:	0f 85 a9 00 00 00    	jne    80101f6a <iput+0xce>
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	8b 40 0c             	mov    0xc(%eax),%eax
80101ec7:	83 e0 02             	and    $0x2,%eax
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	0f 84 98 00 00 00    	je     80101f6a <iput+0xce>
80101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101ed9:	66 85 c0             	test   %ax,%ax
80101edc:	0f 85 88 00 00 00    	jne    80101f6a <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	8b 40 0c             	mov    0xc(%eax),%eax
80101ee8:	83 e0 01             	and    $0x1,%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	74 0d                	je     80101efc <iput+0x60>
      panic("iput busy");
80101eef:	83 ec 0c             	sub    $0xc,%esp
80101ef2:	68 7e a2 10 80       	push   $0x8010a27e
80101ef7:	e8 6a e6 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101efc:	8b 45 08             	mov    0x8(%ebp),%eax
80101eff:	8b 40 0c             	mov    0xc(%eax),%eax
80101f02:	83 c8 01             	or     $0x1,%eax
80101f05:	89 c2                	mov    %eax,%edx
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101f0d:	83 ec 0c             	sub    $0xc,%esp
80101f10:	68 80 32 11 80       	push   $0x80113280
80101f15:	e8 e9 49 00 00       	call   80106903 <release>
80101f1a:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101f1d:	83 ec 0c             	sub    $0xc,%esp
80101f20:	ff 75 08             	pushl  0x8(%ebp)
80101f23:	e8 a8 01 00 00       	call   801020d0 <itrunc>
80101f28:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	ff 75 08             	pushl  0x8(%ebp)
80101f3a:	e8 63 fb ff ff       	call   80101aa2 <iupdate>
80101f3f:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101f42:	83 ec 0c             	sub    $0xc,%esp
80101f45:	68 80 32 11 80       	push   $0x80113280
80101f4a:	e8 4d 49 00 00       	call   8010689c <acquire>
80101f4f:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101f52:	8b 45 08             	mov    0x8(%ebp),%eax
80101f55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101f5c:	83 ec 0c             	sub    $0xc,%esp
80101f5f:	ff 75 08             	pushl  0x8(%ebp)
80101f62:	e8 ac 3a 00 00       	call   80105a13 <wakeup>
80101f67:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6d:	8b 40 08             	mov    0x8(%eax),%eax
80101f70:	8d 50 ff             	lea    -0x1(%eax),%edx
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101f79:	83 ec 0c             	sub    $0xc,%esp
80101f7c:	68 80 32 11 80       	push   $0x80113280
80101f81:	e8 7d 49 00 00       	call   80106903 <release>
80101f86:	83 c4 10             	add    $0x10,%esp
}
80101f89:	90                   	nop
80101f8a:	c9                   	leave  
80101f8b:	c3                   	ret    

80101f8c <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101f8c:	55                   	push   %ebp
80101f8d:	89 e5                	mov    %esp,%ebp
80101f8f:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101f92:	83 ec 0c             	sub    $0xc,%esp
80101f95:	ff 75 08             	pushl  0x8(%ebp)
80101f98:	e8 8d fe ff ff       	call   80101e2a <iunlock>
80101f9d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101fa0:	83 ec 0c             	sub    $0xc,%esp
80101fa3:	ff 75 08             	pushl  0x8(%ebp)
80101fa6:	e8 f1 fe ff ff       	call   80101e9c <iput>
80101fab:	83 c4 10             	add    $0x10,%esp
}
80101fae:	90                   	nop
80101faf:	c9                   	leave  
80101fb0:	c3                   	ret    

80101fb1 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101fb1:	55                   	push   %ebp
80101fb2:	89 e5                	mov    %esp,%ebp
80101fb4:	53                   	push   %ebx
80101fb5:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101fb8:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101fbc:	77 42                	ja     80102000 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc4:	83 c2 08             	add    $0x8,%edx
80101fc7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101fd2:	75 24                	jne    80101ff8 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd7:	8b 00                	mov    (%eax),%eax
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	50                   	push   %eax
80101fdd:	e8 2e f7 ff ff       	call   80101710 <balloc>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80101feb:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fee:	8d 4a 08             	lea    0x8(%edx),%ecx
80101ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ff4:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ffb:	e9 cb 00 00 00       	jmp    801020cb <bmap+0x11a>
  }
  bn -= NDIRECT;
80102000:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80102004:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80102008:	0f 87 b0 00 00 00    	ja     801020be <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010200e:	8b 45 08             	mov    0x8(%ebp),%eax
80102011:	8b 40 4c             	mov    0x4c(%eax),%eax
80102014:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010201b:	75 1d                	jne    8010203a <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010201d:	8b 45 08             	mov    0x8(%ebp),%eax
80102020:	8b 00                	mov    (%eax),%eax
80102022:	83 ec 0c             	sub    $0xc,%esp
80102025:	50                   	push   %eax
80102026:	e8 e5 f6 ff ff       	call   80101710 <balloc>
8010202b:	83 c4 10             	add    $0x10,%esp
8010202e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102031:	8b 45 08             	mov    0x8(%ebp),%eax
80102034:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102037:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	8b 00                	mov    (%eax),%eax
8010203f:	83 ec 08             	sub    $0x8,%esp
80102042:	ff 75 f4             	pushl  -0xc(%ebp)
80102045:	50                   	push   %eax
80102046:	e8 6b e1 ff ff       	call   801001b6 <bread>
8010204b:	83 c4 10             	add    $0x10,%esp
8010204e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80102051:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102054:	83 c0 18             	add    $0x18,%eax
80102057:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
8010205a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102064:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102067:	01 d0                	add    %edx,%eax
80102069:	8b 00                	mov    (%eax),%eax
8010206b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010206e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102072:	75 37                	jne    801020ab <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80102074:	8b 45 0c             	mov    0xc(%ebp),%eax
80102077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010207e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102081:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80102084:	8b 45 08             	mov    0x8(%ebp),%eax
80102087:	8b 00                	mov    (%eax),%eax
80102089:	83 ec 0c             	sub    $0xc,%esp
8010208c:	50                   	push   %eax
8010208d:	e8 7e f6 ff ff       	call   80101710 <balloc>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010209b:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
8010209d:	83 ec 0c             	sub    $0xc,%esp
801020a0:	ff 75 f0             	pushl  -0x10(%ebp)
801020a3:	e8 67 1a 00 00       	call   80103b0f <log_write>
801020a8:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801020ab:	83 ec 0c             	sub    $0xc,%esp
801020ae:	ff 75 f0             	pushl  -0x10(%ebp)
801020b1:	e8 78 e1 ff ff       	call   8010022e <brelse>
801020b6:	83 c4 10             	add    $0x10,%esp
    return addr;
801020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020bc:	eb 0d                	jmp    801020cb <bmap+0x11a>
  }

  panic("bmap: out of range");
801020be:	83 ec 0c             	sub    $0xc,%esp
801020c1:	68 88 a2 10 80       	push   $0x8010a288
801020c6:	e8 9b e4 ff ff       	call   80100566 <panic>
}
801020cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020ce:	c9                   	leave  
801020cf:	c3                   	ret    

801020d0 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801020d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020dd:	eb 45                	jmp    80102124 <itrunc+0x54>
    if(ip->addrs[i]){
801020df:	8b 45 08             	mov    0x8(%ebp),%eax
801020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020e5:	83 c2 08             	add    $0x8,%edx
801020e8:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801020ec:	85 c0                	test   %eax,%eax
801020ee:	74 30                	je     80102120 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
801020f0:	8b 45 08             	mov    0x8(%ebp),%eax
801020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020f6:	83 c2 08             	add    $0x8,%edx
801020f9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801020fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102100:	8b 12                	mov    (%edx),%edx
80102102:	83 ec 08             	sub    $0x8,%esp
80102105:	50                   	push   %eax
80102106:	52                   	push   %edx
80102107:	e8 50 f7 ff ff       	call   8010185c <bfree>
8010210c:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
8010210f:	8b 45 08             	mov    0x8(%ebp),%eax
80102112:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102115:	83 c2 08             	add    $0x8,%edx
80102118:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
8010211f:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102120:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102124:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80102128:	7e b5                	jle    801020df <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
8010212a:	8b 45 08             	mov    0x8(%ebp),%eax
8010212d:	8b 40 4c             	mov    0x4c(%eax),%eax
80102130:	85 c0                	test   %eax,%eax
80102132:	0f 84 a1 00 00 00    	je     801021d9 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	8b 50 4c             	mov    0x4c(%eax),%edx
8010213e:	8b 45 08             	mov    0x8(%ebp),%eax
80102141:	8b 00                	mov    (%eax),%eax
80102143:	83 ec 08             	sub    $0x8,%esp
80102146:	52                   	push   %edx
80102147:	50                   	push   %eax
80102148:	e8 69 e0 ff ff       	call   801001b6 <bread>
8010214d:	83 c4 10             	add    $0x10,%esp
80102150:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80102153:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102156:	83 c0 18             	add    $0x18,%eax
80102159:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010215c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102163:	eb 3c                	jmp    801021a1 <itrunc+0xd1>
      if(a[j])
80102165:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010216f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102172:	01 d0                	add    %edx,%eax
80102174:	8b 00                	mov    (%eax),%eax
80102176:	85 c0                	test   %eax,%eax
80102178:	74 23                	je     8010219d <itrunc+0xcd>
        bfree(ip->dev, a[j]);
8010217a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010217d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102184:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102187:	01 d0                	add    %edx,%eax
80102189:	8b 00                	mov    (%eax),%eax
8010218b:	8b 55 08             	mov    0x8(%ebp),%edx
8010218e:	8b 12                	mov    (%edx),%edx
80102190:	83 ec 08             	sub    $0x8,%esp
80102193:	50                   	push   %eax
80102194:	52                   	push   %edx
80102195:	e8 c2 f6 ff ff       	call   8010185c <bfree>
8010219a:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010219d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021a4:	83 f8 7f             	cmp    $0x7f,%eax
801021a7:	76 bc                	jbe    80102165 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
801021a9:	83 ec 0c             	sub    $0xc,%esp
801021ac:	ff 75 ec             	pushl  -0x14(%ebp)
801021af:	e8 7a e0 ff ff       	call   8010022e <brelse>
801021b4:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
801021b7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ba:	8b 40 4c             	mov    0x4c(%eax),%eax
801021bd:	8b 55 08             	mov    0x8(%ebp),%edx
801021c0:	8b 12                	mov    (%edx),%edx
801021c2:	83 ec 08             	sub    $0x8,%esp
801021c5:	50                   	push   %eax
801021c6:	52                   	push   %edx
801021c7:	e8 90 f6 ff ff       	call   8010185c <bfree>
801021cc:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
801021cf:	8b 45 08             	mov    0x8(%ebp),%eax
801021d2:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
801021d9:	8b 45 08             	mov    0x8(%ebp),%eax
801021dc:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
801021e3:	83 ec 0c             	sub    $0xc,%esp
801021e6:	ff 75 08             	pushl  0x8(%ebp)
801021e9:	e8 b4 f8 ff ff       	call   80101aa2 <iupdate>
801021ee:	83 c4 10             	add    $0x10,%esp
}
801021f1:	90                   	nop
801021f2:	c9                   	leave  
801021f3:	c3                   	ret    

801021f4 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
  st->dev   = ip->dev;
801021f7:	8b 45 08             	mov    0x8(%ebp),%eax
801021fa:	8b 00                	mov    (%eax),%eax
801021fc:	89 c2                	mov    %eax,%edx
801021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102201:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino   = ip->inum;
80102204:	8b 45 08             	mov    0x8(%ebp),%eax
80102207:	8b 50 04             	mov    0x4(%eax),%edx
8010220a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010220d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type  = ip->type;
80102210:	8b 45 08             	mov    0x8(%ebp),%eax
80102213:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80102217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010221a:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
8010221d:	8b 45 08             	mov    0x8(%ebp),%eax
80102220:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80102224:	8b 45 0c             	mov    0xc(%ebp),%eax
80102227:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size  = ip->size;
8010222b:	8b 45 08             	mov    0x8(%ebp),%eax
8010222e:	8b 50 20             	mov    0x20(%eax),%edx
80102231:	8b 45 0c             	mov    0xc(%ebp),%eax
80102234:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P5
  st->uid   = ip->uid;
80102237:	8b 45 08             	mov    0x8(%ebp),%eax
8010223a:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010223e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102241:	66 89 50 14          	mov    %dx,0x14(%eax)
  st->gid   = ip->gid;
80102245:	8b 45 08             	mov    0x8(%ebp),%eax
80102248:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
8010224c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010224f:	66 89 50 16          	mov    %dx,0x16(%eax)
  st->mode.asInt  = ip->mode.asInt;
80102253:	8b 45 08             	mov    0x8(%ebp),%eax
80102256:	8b 50 1c             	mov    0x1c(%eax),%edx
80102259:	8b 45 0c             	mov    0xc(%ebp),%eax
8010225c:	89 50 18             	mov    %edx,0x18(%eax)
#endif
}
8010225f:	90                   	nop
80102260:	5d                   	pop    %ebp
80102261:	c3                   	ret    

80102262 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102262:	55                   	push   %ebp
80102263:	89 e5                	mov    %esp,%ebp
80102265:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102268:	8b 45 08             	mov    0x8(%ebp),%eax
8010226b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010226f:	66 83 f8 03          	cmp    $0x3,%ax
80102273:	75 5c                	jne    801022d1 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102275:	8b 45 08             	mov    0x8(%ebp),%eax
80102278:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010227c:	66 85 c0             	test   %ax,%ax
8010227f:	78 20                	js     801022a1 <readi+0x3f>
80102281:	8b 45 08             	mov    0x8(%ebp),%eax
80102284:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102288:	66 83 f8 09          	cmp    $0x9,%ax
8010228c:	7f 13                	jg     801022a1 <readi+0x3f>
8010228e:	8b 45 08             	mov    0x8(%ebp),%eax
80102291:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102295:	98                   	cwtl   
80102296:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
8010229d:	85 c0                	test   %eax,%eax
8010229f:	75 0a                	jne    801022ab <readi+0x49>
      return -1;
801022a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a6:	e9 0c 01 00 00       	jmp    801023b7 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
801022ae:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801022b2:	98                   	cwtl   
801022b3:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
801022ba:	8b 55 14             	mov    0x14(%ebp),%edx
801022bd:	83 ec 04             	sub    $0x4,%esp
801022c0:	52                   	push   %edx
801022c1:	ff 75 0c             	pushl  0xc(%ebp)
801022c4:	ff 75 08             	pushl  0x8(%ebp)
801022c7:	ff d0                	call   *%eax
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	e9 e6 00 00 00       	jmp    801023b7 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
801022d1:	8b 45 08             	mov    0x8(%ebp),%eax
801022d4:	8b 40 20             	mov    0x20(%eax),%eax
801022d7:	3b 45 10             	cmp    0x10(%ebp),%eax
801022da:	72 0d                	jb     801022e9 <readi+0x87>
801022dc:	8b 55 10             	mov    0x10(%ebp),%edx
801022df:	8b 45 14             	mov    0x14(%ebp),%eax
801022e2:	01 d0                	add    %edx,%eax
801022e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801022e7:	73 0a                	jae    801022f3 <readi+0x91>
    return -1;
801022e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022ee:	e9 c4 00 00 00       	jmp    801023b7 <readi+0x155>
  if(off + n > ip->size)
801022f3:	8b 55 10             	mov    0x10(%ebp),%edx
801022f6:	8b 45 14             	mov    0x14(%ebp),%eax
801022f9:	01 c2                	add    %eax,%edx
801022fb:	8b 45 08             	mov    0x8(%ebp),%eax
801022fe:	8b 40 20             	mov    0x20(%eax),%eax
80102301:	39 c2                	cmp    %eax,%edx
80102303:	76 0c                	jbe    80102311 <readi+0xaf>
    n = ip->size - off;
80102305:	8b 45 08             	mov    0x8(%ebp),%eax
80102308:	8b 40 20             	mov    0x20(%eax),%eax
8010230b:	2b 45 10             	sub    0x10(%ebp),%eax
8010230e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102311:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102318:	e9 8b 00 00 00       	jmp    801023a8 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010231d:	8b 45 10             	mov    0x10(%ebp),%eax
80102320:	c1 e8 09             	shr    $0x9,%eax
80102323:	83 ec 08             	sub    $0x8,%esp
80102326:	50                   	push   %eax
80102327:	ff 75 08             	pushl  0x8(%ebp)
8010232a:	e8 82 fc ff ff       	call   80101fb1 <bmap>
8010232f:	83 c4 10             	add    $0x10,%esp
80102332:	89 c2                	mov    %eax,%edx
80102334:	8b 45 08             	mov    0x8(%ebp),%eax
80102337:	8b 00                	mov    (%eax),%eax
80102339:	83 ec 08             	sub    $0x8,%esp
8010233c:	52                   	push   %edx
8010233d:	50                   	push   %eax
8010233e:	e8 73 de ff ff       	call   801001b6 <bread>
80102343:	83 c4 10             	add    $0x10,%esp
80102346:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102349:	8b 45 10             	mov    0x10(%ebp),%eax
8010234c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102351:	ba 00 02 00 00       	mov    $0x200,%edx
80102356:	29 c2                	sub    %eax,%edx
80102358:	8b 45 14             	mov    0x14(%ebp),%eax
8010235b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010235e:	39 c2                	cmp    %eax,%edx
80102360:	0f 46 c2             	cmovbe %edx,%eax
80102363:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102366:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102369:	8d 50 18             	lea    0x18(%eax),%edx
8010236c:	8b 45 10             	mov    0x10(%ebp),%eax
8010236f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102374:	01 d0                	add    %edx,%eax
80102376:	83 ec 04             	sub    $0x4,%esp
80102379:	ff 75 ec             	pushl  -0x14(%ebp)
8010237c:	50                   	push   %eax
8010237d:	ff 75 0c             	pushl  0xc(%ebp)
80102380:	e8 39 48 00 00       	call   80106bbe <memmove>
80102385:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102388:	83 ec 0c             	sub    $0xc,%esp
8010238b:	ff 75 f0             	pushl  -0x10(%ebp)
8010238e:	e8 9b de ff ff       	call   8010022e <brelse>
80102393:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102396:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102399:	01 45 f4             	add    %eax,-0xc(%ebp)
8010239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010239f:	01 45 10             	add    %eax,0x10(%ebp)
801023a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023a5:	01 45 0c             	add    %eax,0xc(%ebp)
801023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ab:	3b 45 14             	cmp    0x14(%ebp),%eax
801023ae:	0f 82 69 ff ff ff    	jb     8010231d <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801023b4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801023b7:	c9                   	leave  
801023b8:	c3                   	ret    

801023b9 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801023b9:	55                   	push   %ebp
801023ba:	89 e5                	mov    %esp,%ebp
801023bc:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023bf:	8b 45 08             	mov    0x8(%ebp),%eax
801023c2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023c6:	66 83 f8 03          	cmp    $0x3,%ax
801023ca:	75 5c                	jne    80102428 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801023cc:	8b 45 08             	mov    0x8(%ebp),%eax
801023cf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801023d3:	66 85 c0             	test   %ax,%ax
801023d6:	78 20                	js     801023f8 <writei+0x3f>
801023d8:	8b 45 08             	mov    0x8(%ebp),%eax
801023db:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801023df:	66 83 f8 09          	cmp    $0x9,%ax
801023e3:	7f 13                	jg     801023f8 <writei+0x3f>
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
801023e8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801023ec:	98                   	cwtl   
801023ed:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
801023f4:	85 c0                	test   %eax,%eax
801023f6:	75 0a                	jne    80102402 <writei+0x49>
      return -1;
801023f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023fd:	e9 3d 01 00 00       	jmp    8010253f <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102402:	8b 45 08             	mov    0x8(%ebp),%eax
80102405:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102409:	98                   	cwtl   
8010240a:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102411:	8b 55 14             	mov    0x14(%ebp),%edx
80102414:	83 ec 04             	sub    $0x4,%esp
80102417:	52                   	push   %edx
80102418:	ff 75 0c             	pushl  0xc(%ebp)
8010241b:	ff 75 08             	pushl  0x8(%ebp)
8010241e:	ff d0                	call   *%eax
80102420:	83 c4 10             	add    $0x10,%esp
80102423:	e9 17 01 00 00       	jmp    8010253f <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102428:	8b 45 08             	mov    0x8(%ebp),%eax
8010242b:	8b 40 20             	mov    0x20(%eax),%eax
8010242e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102431:	72 0d                	jb     80102440 <writei+0x87>
80102433:	8b 55 10             	mov    0x10(%ebp),%edx
80102436:	8b 45 14             	mov    0x14(%ebp),%eax
80102439:	01 d0                	add    %edx,%eax
8010243b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010243e:	73 0a                	jae    8010244a <writei+0x91>
    return -1;
80102440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102445:	e9 f5 00 00 00       	jmp    8010253f <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010244a:	8b 55 10             	mov    0x10(%ebp),%edx
8010244d:	8b 45 14             	mov    0x14(%ebp),%eax
80102450:	01 d0                	add    %edx,%eax
80102452:	3d 00 14 01 00       	cmp    $0x11400,%eax
80102457:	76 0a                	jbe    80102463 <writei+0xaa>
    return -1;
80102459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010245e:	e9 dc 00 00 00       	jmp    8010253f <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010246a:	e9 99 00 00 00       	jmp    80102508 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010246f:	8b 45 10             	mov    0x10(%ebp),%eax
80102472:	c1 e8 09             	shr    $0x9,%eax
80102475:	83 ec 08             	sub    $0x8,%esp
80102478:	50                   	push   %eax
80102479:	ff 75 08             	pushl  0x8(%ebp)
8010247c:	e8 30 fb ff ff       	call   80101fb1 <bmap>
80102481:	83 c4 10             	add    $0x10,%esp
80102484:	89 c2                	mov    %eax,%edx
80102486:	8b 45 08             	mov    0x8(%ebp),%eax
80102489:	8b 00                	mov    (%eax),%eax
8010248b:	83 ec 08             	sub    $0x8,%esp
8010248e:	52                   	push   %edx
8010248f:	50                   	push   %eax
80102490:	e8 21 dd ff ff       	call   801001b6 <bread>
80102495:	83 c4 10             	add    $0x10,%esp
80102498:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010249b:	8b 45 10             	mov    0x10(%ebp),%eax
8010249e:	25 ff 01 00 00       	and    $0x1ff,%eax
801024a3:	ba 00 02 00 00       	mov    $0x200,%edx
801024a8:	29 c2                	sub    %eax,%edx
801024aa:	8b 45 14             	mov    0x14(%ebp),%eax
801024ad:	2b 45 f4             	sub    -0xc(%ebp),%eax
801024b0:	39 c2                	cmp    %eax,%edx
801024b2:	0f 46 c2             	cmovbe %edx,%eax
801024b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024bb:	8d 50 18             	lea    0x18(%eax),%edx
801024be:	8b 45 10             	mov    0x10(%ebp),%eax
801024c1:	25 ff 01 00 00       	and    $0x1ff,%eax
801024c6:	01 d0                	add    %edx,%eax
801024c8:	83 ec 04             	sub    $0x4,%esp
801024cb:	ff 75 ec             	pushl  -0x14(%ebp)
801024ce:	ff 75 0c             	pushl  0xc(%ebp)
801024d1:	50                   	push   %eax
801024d2:	e8 e7 46 00 00       	call   80106bbe <memmove>
801024d7:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801024da:	83 ec 0c             	sub    $0xc,%esp
801024dd:	ff 75 f0             	pushl  -0x10(%ebp)
801024e0:	e8 2a 16 00 00       	call   80103b0f <log_write>
801024e5:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f0             	pushl  -0x10(%ebp)
801024ee:	e8 3b dd ff ff       	call   8010022e <brelse>
801024f3:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024f9:	01 45 f4             	add    %eax,-0xc(%ebp)
801024fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024ff:	01 45 10             	add    %eax,0x10(%ebp)
80102502:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102505:	01 45 0c             	add    %eax,0xc(%ebp)
80102508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010250b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010250e:	0f 82 5b ff ff ff    	jb     8010246f <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102514:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102518:	74 22                	je     8010253c <writei+0x183>
8010251a:	8b 45 08             	mov    0x8(%ebp),%eax
8010251d:	8b 40 20             	mov    0x20(%eax),%eax
80102520:	3b 45 10             	cmp    0x10(%ebp),%eax
80102523:	73 17                	jae    8010253c <writei+0x183>
    ip->size = off;
80102525:	8b 45 08             	mov    0x8(%ebp),%eax
80102528:	8b 55 10             	mov    0x10(%ebp),%edx
8010252b:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
8010252e:	83 ec 0c             	sub    $0xc,%esp
80102531:	ff 75 08             	pushl  0x8(%ebp)
80102534:	e8 69 f5 ff ff       	call   80101aa2 <iupdate>
80102539:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010253c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010253f:	c9                   	leave  
80102540:	c3                   	ret    

80102541 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102541:	55                   	push   %ebp
80102542:	89 e5                	mov    %esp,%ebp
80102544:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	6a 0e                	push   $0xe
8010254c:	ff 75 0c             	pushl  0xc(%ebp)
8010254f:	ff 75 08             	pushl  0x8(%ebp)
80102552:	e8 fd 46 00 00       	call   80106c54 <strncmp>
80102557:	83 c4 10             	add    $0x10,%esp
}
8010255a:	c9                   	leave  
8010255b:	c3                   	ret    

8010255c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
8010255f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102562:	8b 45 08             	mov    0x8(%ebp),%eax
80102565:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102569:	66 83 f8 01          	cmp    $0x1,%ax
8010256d:	74 0d                	je     8010257c <dirlookup+0x20>
    panic("dirlookup not DIR");
8010256f:	83 ec 0c             	sub    $0xc,%esp
80102572:	68 9b a2 10 80       	push   $0x8010a29b
80102577:	e8 ea df ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010257c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102583:	eb 7b                	jmp    80102600 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102585:	6a 10                	push   $0x10
80102587:	ff 75 f4             	pushl  -0xc(%ebp)
8010258a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010258d:	50                   	push   %eax
8010258e:	ff 75 08             	pushl  0x8(%ebp)
80102591:	e8 cc fc ff ff       	call   80102262 <readi>
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	83 f8 10             	cmp    $0x10,%eax
8010259c:	74 0d                	je     801025ab <dirlookup+0x4f>
      panic("dirlink read");
8010259e:	83 ec 0c             	sub    $0xc,%esp
801025a1:	68 ad a2 10 80       	push   $0x8010a2ad
801025a6:	e8 bb df ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801025ab:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801025af:	66 85 c0             	test   %ax,%ax
801025b2:	74 47                	je     801025fb <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801025b4:	83 ec 08             	sub    $0x8,%esp
801025b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025ba:	83 c0 02             	add    $0x2,%eax
801025bd:	50                   	push   %eax
801025be:	ff 75 0c             	pushl  0xc(%ebp)
801025c1:	e8 7b ff ff ff       	call   80102541 <namecmp>
801025c6:	83 c4 10             	add    $0x10,%esp
801025c9:	85 c0                	test   %eax,%eax
801025cb:	75 2f                	jne    801025fc <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801025cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801025d1:	74 08                	je     801025db <dirlookup+0x7f>
        *poff = off;
801025d3:	8b 45 10             	mov    0x10(%ebp),%eax
801025d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801025d9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801025db:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801025df:	0f b7 c0             	movzwl %ax,%eax
801025e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
801025e8:	8b 00                	mov    (%eax),%eax
801025ea:	83 ec 08             	sub    $0x8,%esp
801025ed:	ff 75 f0             	pushl  -0x10(%ebp)
801025f0:	50                   	push   %eax
801025f1:	e8 95 f5 ff ff       	call   80101b8b <iget>
801025f6:	83 c4 10             	add    $0x10,%esp
801025f9:	eb 19                	jmp    80102614 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801025fb:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801025fc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102600:	8b 45 08             	mov    0x8(%ebp),%eax
80102603:	8b 40 20             	mov    0x20(%eax),%eax
80102606:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102609:	0f 87 76 ff ff ff    	ja     80102585 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010260f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102614:	c9                   	leave  
80102615:	c3                   	ret    

80102616 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102616:	55                   	push   %ebp
80102617:	89 e5                	mov    %esp,%ebp
80102619:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010261c:	83 ec 04             	sub    $0x4,%esp
8010261f:	6a 00                	push   $0x0
80102621:	ff 75 0c             	pushl  0xc(%ebp)
80102624:	ff 75 08             	pushl  0x8(%ebp)
80102627:	e8 30 ff ff ff       	call   8010255c <dirlookup>
8010262c:	83 c4 10             	add    $0x10,%esp
8010262f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102636:	74 18                	je     80102650 <dirlink+0x3a>
    iput(ip);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	ff 75 f0             	pushl  -0x10(%ebp)
8010263e:	e8 59 f8 ff ff       	call   80101e9c <iput>
80102643:	83 c4 10             	add    $0x10,%esp
    return -1;
80102646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264b:	e9 9c 00 00 00       	jmp    801026ec <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102657:	eb 39                	jmp    80102692 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010265c:	6a 10                	push   $0x10
8010265e:	50                   	push   %eax
8010265f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102662:	50                   	push   %eax
80102663:	ff 75 08             	pushl  0x8(%ebp)
80102666:	e8 f7 fb ff ff       	call   80102262 <readi>
8010266b:	83 c4 10             	add    $0x10,%esp
8010266e:	83 f8 10             	cmp    $0x10,%eax
80102671:	74 0d                	je     80102680 <dirlink+0x6a>
      panic("dirlink read");
80102673:	83 ec 0c             	sub    $0xc,%esp
80102676:	68 ad a2 10 80       	push   $0x8010a2ad
8010267b:	e8 e6 de ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102680:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102684:	66 85 c0             	test   %ax,%ax
80102687:	74 18                	je     801026a1 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010268c:	83 c0 10             	add    $0x10,%eax
8010268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102692:	8b 45 08             	mov    0x8(%ebp),%eax
80102695:	8b 50 20             	mov    0x20(%eax),%edx
80102698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010269b:	39 c2                	cmp    %eax,%edx
8010269d:	77 ba                	ja     80102659 <dirlink+0x43>
8010269f:	eb 01                	jmp    801026a2 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801026a1:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801026a2:	83 ec 04             	sub    $0x4,%esp
801026a5:	6a 0e                	push   $0xe
801026a7:	ff 75 0c             	pushl  0xc(%ebp)
801026aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801026ad:	83 c0 02             	add    $0x2,%eax
801026b0:	50                   	push   %eax
801026b1:	e8 f4 45 00 00       	call   80106caa <strncpy>
801026b6:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801026b9:	8b 45 10             	mov    0x10(%ebp),%eax
801026bc:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026c3:	6a 10                	push   $0x10
801026c5:	50                   	push   %eax
801026c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801026c9:	50                   	push   %eax
801026ca:	ff 75 08             	pushl  0x8(%ebp)
801026cd:	e8 e7 fc ff ff       	call   801023b9 <writei>
801026d2:	83 c4 10             	add    $0x10,%esp
801026d5:	83 f8 10             	cmp    $0x10,%eax
801026d8:	74 0d                	je     801026e7 <dirlink+0xd1>
    panic("dirlink");
801026da:	83 ec 0c             	sub    $0xc,%esp
801026dd:	68 ba a2 10 80       	push   $0x8010a2ba
801026e2:	e8 7f de ff ff       	call   80100566 <panic>
  
  return 0;
801026e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    

801026ee <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801026ee:	55                   	push   %ebp
801026ef:	89 e5                	mov    %esp,%ebp
801026f1:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801026f4:	eb 04                	jmp    801026fa <skipelem+0xc>
    path++;
801026f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801026fa:	8b 45 08             	mov    0x8(%ebp),%eax
801026fd:	0f b6 00             	movzbl (%eax),%eax
80102700:	3c 2f                	cmp    $0x2f,%al
80102702:	74 f2                	je     801026f6 <skipelem+0x8>
    path++;
  if(*path == 0)
80102704:	8b 45 08             	mov    0x8(%ebp),%eax
80102707:	0f b6 00             	movzbl (%eax),%eax
8010270a:	84 c0                	test   %al,%al
8010270c:	75 07                	jne    80102715 <skipelem+0x27>
    return 0;
8010270e:	b8 00 00 00 00       	mov    $0x0,%eax
80102713:	eb 7b                	jmp    80102790 <skipelem+0xa2>
  s = path;
80102715:	8b 45 08             	mov    0x8(%ebp),%eax
80102718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010271b:	eb 04                	jmp    80102721 <skipelem+0x33>
    path++;
8010271d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	0f b6 00             	movzbl (%eax),%eax
80102727:	3c 2f                	cmp    $0x2f,%al
80102729:	74 0a                	je     80102735 <skipelem+0x47>
8010272b:	8b 45 08             	mov    0x8(%ebp),%eax
8010272e:	0f b6 00             	movzbl (%eax),%eax
80102731:	84 c0                	test   %al,%al
80102733:	75 e8                	jne    8010271d <skipelem+0x2f>
    path++;
  len = path - s;
80102735:	8b 55 08             	mov    0x8(%ebp),%edx
80102738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273b:	29 c2                	sub    %eax,%edx
8010273d:	89 d0                	mov    %edx,%eax
8010273f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102742:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102746:	7e 15                	jle    8010275d <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102748:	83 ec 04             	sub    $0x4,%esp
8010274b:	6a 0e                	push   $0xe
8010274d:	ff 75 f4             	pushl  -0xc(%ebp)
80102750:	ff 75 0c             	pushl  0xc(%ebp)
80102753:	e8 66 44 00 00       	call   80106bbe <memmove>
80102758:	83 c4 10             	add    $0x10,%esp
8010275b:	eb 26                	jmp    80102783 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010275d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102760:	83 ec 04             	sub    $0x4,%esp
80102763:	50                   	push   %eax
80102764:	ff 75 f4             	pushl  -0xc(%ebp)
80102767:	ff 75 0c             	pushl  0xc(%ebp)
8010276a:	e8 4f 44 00 00       	call   80106bbe <memmove>
8010276f:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102772:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102775:	8b 45 0c             	mov    0xc(%ebp),%eax
80102778:	01 d0                	add    %edx,%eax
8010277a:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010277d:	eb 04                	jmp    80102783 <skipelem+0x95>
    path++;
8010277f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102783:	8b 45 08             	mov    0x8(%ebp),%eax
80102786:	0f b6 00             	movzbl (%eax),%eax
80102789:	3c 2f                	cmp    $0x2f,%al
8010278b:	74 f2                	je     8010277f <skipelem+0x91>
    path++;
  return path;
8010278d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102790:	c9                   	leave  
80102791:	c3                   	ret    

80102792 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102792:	55                   	push   %ebp
80102793:	89 e5                	mov    %esp,%ebp
80102795:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102798:	8b 45 08             	mov    0x8(%ebp),%eax
8010279b:	0f b6 00             	movzbl (%eax),%eax
8010279e:	3c 2f                	cmp    $0x2f,%al
801027a0:	75 17                	jne    801027b9 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801027a2:	83 ec 08             	sub    $0x8,%esp
801027a5:	6a 01                	push   $0x1
801027a7:	6a 01                	push   $0x1
801027a9:	e8 dd f3 ff ff       	call   80101b8b <iget>
801027ae:	83 c4 10             	add    $0x10,%esp
801027b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b4:	e9 bb 00 00 00       	jmp    80102874 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801027b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801027bf:	8b 40 68             	mov    0x68(%eax),%eax
801027c2:	83 ec 0c             	sub    $0xc,%esp
801027c5:	50                   	push   %eax
801027c6:	e8 9f f4 ff ff       	call   80101c6a <idup>
801027cb:	83 c4 10             	add    $0x10,%esp
801027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801027d1:	e9 9e 00 00 00       	jmp    80102874 <namex+0xe2>
    ilock(ip);
801027d6:	83 ec 0c             	sub    $0xc,%esp
801027d9:	ff 75 f4             	pushl  -0xc(%ebp)
801027dc:	e8 c3 f4 ff ff       	call   80101ca4 <ilock>
801027e1:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801027eb:	66 83 f8 01          	cmp    $0x1,%ax
801027ef:	74 18                	je     80102809 <namex+0x77>
      iunlockput(ip);
801027f1:	83 ec 0c             	sub    $0xc,%esp
801027f4:	ff 75 f4             	pushl  -0xc(%ebp)
801027f7:	e8 90 f7 ff ff       	call   80101f8c <iunlockput>
801027fc:	83 c4 10             	add    $0x10,%esp
      return 0;
801027ff:	b8 00 00 00 00       	mov    $0x0,%eax
80102804:	e9 a7 00 00 00       	jmp    801028b0 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102809:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010280d:	74 20                	je     8010282f <namex+0x9d>
8010280f:	8b 45 08             	mov    0x8(%ebp),%eax
80102812:	0f b6 00             	movzbl (%eax),%eax
80102815:	84 c0                	test   %al,%al
80102817:	75 16                	jne    8010282f <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102819:	83 ec 0c             	sub    $0xc,%esp
8010281c:	ff 75 f4             	pushl  -0xc(%ebp)
8010281f:	e8 06 f6 ff ff       	call   80101e2a <iunlock>
80102824:	83 c4 10             	add    $0x10,%esp
      return ip;
80102827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282a:	e9 81 00 00 00       	jmp    801028b0 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010282f:	83 ec 04             	sub    $0x4,%esp
80102832:	6a 00                	push   $0x0
80102834:	ff 75 10             	pushl  0x10(%ebp)
80102837:	ff 75 f4             	pushl  -0xc(%ebp)
8010283a:	e8 1d fd ff ff       	call   8010255c <dirlookup>
8010283f:	83 c4 10             	add    $0x10,%esp
80102842:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102849:	75 15                	jne    80102860 <namex+0xce>
      iunlockput(ip);
8010284b:	83 ec 0c             	sub    $0xc,%esp
8010284e:	ff 75 f4             	pushl  -0xc(%ebp)
80102851:	e8 36 f7 ff ff       	call   80101f8c <iunlockput>
80102856:	83 c4 10             	add    $0x10,%esp
      return 0;
80102859:	b8 00 00 00 00       	mov    $0x0,%eax
8010285e:	eb 50                	jmp    801028b0 <namex+0x11e>
    }
    iunlockput(ip);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	ff 75 f4             	pushl  -0xc(%ebp)
80102866:	e8 21 f7 ff ff       	call   80101f8c <iunlockput>
8010286b:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102871:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102874:	83 ec 08             	sub    $0x8,%esp
80102877:	ff 75 10             	pushl  0x10(%ebp)
8010287a:	ff 75 08             	pushl  0x8(%ebp)
8010287d:	e8 6c fe ff ff       	call   801026ee <skipelem>
80102882:	83 c4 10             	add    $0x10,%esp
80102885:	89 45 08             	mov    %eax,0x8(%ebp)
80102888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010288c:	0f 85 44 ff ff ff    	jne    801027d6 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102892:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102896:	74 15                	je     801028ad <namex+0x11b>
    iput(ip);
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	ff 75 f4             	pushl  -0xc(%ebp)
8010289e:	e8 f9 f5 ff ff       	call   80101e9c <iput>
801028a3:	83 c4 10             	add    $0x10,%esp
    return 0;
801028a6:	b8 00 00 00 00       	mov    $0x0,%eax
801028ab:	eb 03                	jmp    801028b0 <namex+0x11e>
  }
  return ip;
801028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801028b0:	c9                   	leave  
801028b1:	c3                   	ret    

801028b2 <namei>:

struct inode*
namei(char *path)
{
801028b2:	55                   	push   %ebp
801028b3:	89 e5                	mov    %esp,%ebp
801028b5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801028b8:	83 ec 04             	sub    $0x4,%esp
801028bb:	8d 45 ea             	lea    -0x16(%ebp),%eax
801028be:	50                   	push   %eax
801028bf:	6a 00                	push   $0x0
801028c1:	ff 75 08             	pushl  0x8(%ebp)
801028c4:	e8 c9 fe ff ff       	call   80102792 <namex>
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    

801028ce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801028ce:	55                   	push   %ebp
801028cf:	89 e5                	mov    %esp,%ebp
801028d1:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801028d4:	83 ec 04             	sub    $0x4,%esp
801028d7:	ff 75 0c             	pushl  0xc(%ebp)
801028da:	6a 01                	push   $0x1
801028dc:	ff 75 08             	pushl  0x8(%ebp)
801028df:	e8 ae fe ff ff       	call   80102792 <namex>
801028e4:	83 c4 10             	add    $0x10,%esp
}
801028e7:	c9                   	leave  
801028e8:	c3                   	ret    

801028e9 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801028e9:	55                   	push   %ebp
801028ea:	89 e5                	mov    %esp,%ebp
801028ec:	83 ec 14             	sub    $0x14,%esp
801028ef:	8b 45 08             	mov    0x8(%ebp),%eax
801028f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	ec                   	in     (%dx),%al
801028fd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102900:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102904:	c9                   	leave  
80102905:	c3                   	ret    

80102906 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102906:	55                   	push   %ebp
80102907:	89 e5                	mov    %esp,%ebp
80102909:	57                   	push   %edi
8010290a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010290b:	8b 55 08             	mov    0x8(%ebp),%edx
8010290e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102911:	8b 45 10             	mov    0x10(%ebp),%eax
80102914:	89 cb                	mov    %ecx,%ebx
80102916:	89 df                	mov    %ebx,%edi
80102918:	89 c1                	mov    %eax,%ecx
8010291a:	fc                   	cld    
8010291b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010291d:	89 c8                	mov    %ecx,%eax
8010291f:	89 fb                	mov    %edi,%ebx
80102921:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102924:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102927:	90                   	nop
80102928:	5b                   	pop    %ebx
80102929:	5f                   	pop    %edi
8010292a:	5d                   	pop    %ebp
8010292b:	c3                   	ret    

8010292c <outb>:

static inline void
outb(ushort port, uchar data)
{
8010292c:	55                   	push   %ebp
8010292d:	89 e5                	mov    %esp,%ebp
8010292f:	83 ec 08             	sub    $0x8,%esp
80102932:	8b 55 08             	mov    0x8(%ebp),%edx
80102935:	8b 45 0c             	mov    0xc(%ebp),%eax
80102938:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010293c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010293f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102943:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102947:	ee                   	out    %al,(%dx)
}
80102948:	90                   	nop
80102949:	c9                   	leave  
8010294a:	c3                   	ret    

8010294b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010294b:	55                   	push   %ebp
8010294c:	89 e5                	mov    %esp,%ebp
8010294e:	56                   	push   %esi
8010294f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102950:	8b 55 08             	mov    0x8(%ebp),%edx
80102953:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102956:	8b 45 10             	mov    0x10(%ebp),%eax
80102959:	89 cb                	mov    %ecx,%ebx
8010295b:	89 de                	mov    %ebx,%esi
8010295d:	89 c1                	mov    %eax,%ecx
8010295f:	fc                   	cld    
80102960:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102962:	89 c8                	mov    %ecx,%eax
80102964:	89 f3                	mov    %esi,%ebx
80102966:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102969:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010296c:	90                   	nop
8010296d:	5b                   	pop    %ebx
8010296e:	5e                   	pop    %esi
8010296f:	5d                   	pop    %ebp
80102970:	c3                   	ret    

80102971 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102971:	55                   	push   %ebp
80102972:	89 e5                	mov    %esp,%ebp
80102974:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102977:	90                   	nop
80102978:	68 f7 01 00 00       	push   $0x1f7
8010297d:	e8 67 ff ff ff       	call   801028e9 <inb>
80102982:	83 c4 04             	add    $0x4,%esp
80102985:	0f b6 c0             	movzbl %al,%eax
80102988:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010298b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010298e:	25 c0 00 00 00       	and    $0xc0,%eax
80102993:	83 f8 40             	cmp    $0x40,%eax
80102996:	75 e0                	jne    80102978 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010299c:	74 11                	je     801029af <idewait+0x3e>
8010299e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801029a1:	83 e0 21             	and    $0x21,%eax
801029a4:	85 c0                	test   %eax,%eax
801029a6:	74 07                	je     801029af <idewait+0x3e>
    return -1;
801029a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801029ad:	eb 05                	jmp    801029b4 <idewait+0x43>
  return 0;
801029af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801029b4:	c9                   	leave  
801029b5:	c3                   	ret    

801029b6 <ideinit>:

void
ideinit(void)
{
801029b6:	55                   	push   %ebp
801029b7:	89 e5                	mov    %esp,%ebp
801029b9:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801029bc:	83 ec 08             	sub    $0x8,%esp
801029bf:	68 c2 a2 10 80       	push   $0x8010a2c2
801029c4:	68 40 d6 10 80       	push   $0x8010d640
801029c9:	e8 ac 3e 00 00       	call   8010687a <initlock>
801029ce:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801029d1:	83 ec 0c             	sub    $0xc,%esp
801029d4:	6a 0e                	push   $0xe
801029d6:	e8 da 18 00 00       	call   801042b5 <picenable>
801029db:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801029de:	a1 80 49 11 80       	mov    0x80114980,%eax
801029e3:	83 e8 01             	sub    $0x1,%eax
801029e6:	83 ec 08             	sub    $0x8,%esp
801029e9:	50                   	push   %eax
801029ea:	6a 0e                	push   $0xe
801029ec:	e8 73 04 00 00       	call   80102e64 <ioapicenable>
801029f1:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	6a 00                	push   $0x0
801029f9:	e8 73 ff ff ff       	call   80102971 <idewait>
801029fe:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102a01:	83 ec 08             	sub    $0x8,%esp
80102a04:	68 f0 00 00 00       	push   $0xf0
80102a09:	68 f6 01 00 00       	push   $0x1f6
80102a0e:	e8 19 ff ff ff       	call   8010292c <outb>
80102a13:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a1d:	eb 24                	jmp    80102a43 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102a1f:	83 ec 0c             	sub    $0xc,%esp
80102a22:	68 f7 01 00 00       	push   $0x1f7
80102a27:	e8 bd fe ff ff       	call   801028e9 <inb>
80102a2c:	83 c4 10             	add    $0x10,%esp
80102a2f:	84 c0                	test   %al,%al
80102a31:	74 0c                	je     80102a3f <ideinit+0x89>
      havedisk1 = 1;
80102a33:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
80102a3a:	00 00 00 
      break;
80102a3d:	eb 0d                	jmp    80102a4c <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102a3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a43:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102a4a:	7e d3                	jle    80102a1f <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102a4c:	83 ec 08             	sub    $0x8,%esp
80102a4f:	68 e0 00 00 00       	push   $0xe0
80102a54:	68 f6 01 00 00       	push   $0x1f6
80102a59:	e8 ce fe ff ff       	call   8010292c <outb>
80102a5e:	83 c4 10             	add    $0x10,%esp
}
80102a61:	90                   	nop
80102a62:	c9                   	leave  
80102a63:	c3                   	ret    

80102a64 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102a6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a6e:	75 0d                	jne    80102a7d <idestart+0x19>
    panic("idestart");
80102a70:	83 ec 0c             	sub    $0xc,%esp
80102a73:	68 c6 a2 10 80       	push   $0x8010a2c6
80102a78:	e8 e9 da ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a80:	8b 40 08             	mov    0x8(%eax),%eax
80102a83:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102a88:	76 0d                	jbe    80102a97 <idestart+0x33>
    panic("incorrect blockno");
80102a8a:	83 ec 0c             	sub    $0xc,%esp
80102a8d:	68 cf a2 10 80       	push   $0x8010a2cf
80102a92:	e8 cf da ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102a97:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa1:	8b 50 08             	mov    0x8(%eax),%edx
80102aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa7:	0f af c2             	imul   %edx,%eax
80102aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102aad:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102ab1:	7e 0d                	jle    80102ac0 <idestart+0x5c>
80102ab3:	83 ec 0c             	sub    $0xc,%esp
80102ab6:	68 c6 a2 10 80       	push   $0x8010a2c6
80102abb:	e8 a6 da ff ff       	call   80100566 <panic>
  
  idewait(0);
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	6a 00                	push   $0x0
80102ac5:	e8 a7 fe ff ff       	call   80102971 <idewait>
80102aca:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	6a 00                	push   $0x0
80102ad2:	68 f6 03 00 00       	push   $0x3f6
80102ad7:	e8 50 fe ff ff       	call   8010292c <outb>
80102adc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae2:	0f b6 c0             	movzbl %al,%eax
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	50                   	push   %eax
80102ae9:	68 f2 01 00 00       	push   $0x1f2
80102aee:	e8 39 fe ff ff       	call   8010292c <outb>
80102af3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102af9:	0f b6 c0             	movzbl %al,%eax
80102afc:	83 ec 08             	sub    $0x8,%esp
80102aff:	50                   	push   %eax
80102b00:	68 f3 01 00 00       	push   $0x1f3
80102b05:	e8 22 fe ff ff       	call   8010292c <outb>
80102b0a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b10:	c1 f8 08             	sar    $0x8,%eax
80102b13:	0f b6 c0             	movzbl %al,%eax
80102b16:	83 ec 08             	sub    $0x8,%esp
80102b19:	50                   	push   %eax
80102b1a:	68 f4 01 00 00       	push   $0x1f4
80102b1f:	e8 08 fe ff ff       	call   8010292c <outb>
80102b24:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b2a:	c1 f8 10             	sar    $0x10,%eax
80102b2d:	0f b6 c0             	movzbl %al,%eax
80102b30:	83 ec 08             	sub    $0x8,%esp
80102b33:	50                   	push   %eax
80102b34:	68 f5 01 00 00       	push   $0x1f5
80102b39:	e8 ee fd ff ff       	call   8010292c <outb>
80102b3e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102b41:	8b 45 08             	mov    0x8(%ebp),%eax
80102b44:	8b 40 04             	mov    0x4(%eax),%eax
80102b47:	83 e0 01             	and    $0x1,%eax
80102b4a:	c1 e0 04             	shl    $0x4,%eax
80102b4d:	89 c2                	mov    %eax,%edx
80102b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b52:	c1 f8 18             	sar    $0x18,%eax
80102b55:	83 e0 0f             	and    $0xf,%eax
80102b58:	09 d0                	or     %edx,%eax
80102b5a:	83 c8 e0             	or     $0xffffffe0,%eax
80102b5d:	0f b6 c0             	movzbl %al,%eax
80102b60:	83 ec 08             	sub    $0x8,%esp
80102b63:	50                   	push   %eax
80102b64:	68 f6 01 00 00       	push   $0x1f6
80102b69:	e8 be fd ff ff       	call   8010292c <outb>
80102b6e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102b71:	8b 45 08             	mov    0x8(%ebp),%eax
80102b74:	8b 00                	mov    (%eax),%eax
80102b76:	83 e0 04             	and    $0x4,%eax
80102b79:	85 c0                	test   %eax,%eax
80102b7b:	74 30                	je     80102bad <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102b7d:	83 ec 08             	sub    $0x8,%esp
80102b80:	6a 30                	push   $0x30
80102b82:	68 f7 01 00 00       	push   $0x1f7
80102b87:	e8 a0 fd ff ff       	call   8010292c <outb>
80102b8c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b92:	83 c0 18             	add    $0x18,%eax
80102b95:	83 ec 04             	sub    $0x4,%esp
80102b98:	68 80 00 00 00       	push   $0x80
80102b9d:	50                   	push   %eax
80102b9e:	68 f0 01 00 00       	push   $0x1f0
80102ba3:	e8 a3 fd ff ff       	call   8010294b <outsl>
80102ba8:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102bab:	eb 12                	jmp    80102bbf <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102bad:	83 ec 08             	sub    $0x8,%esp
80102bb0:	6a 20                	push   $0x20
80102bb2:	68 f7 01 00 00       	push   $0x1f7
80102bb7:	e8 70 fd ff ff       	call   8010292c <outb>
80102bbc:	83 c4 10             	add    $0x10,%esp
  }
}
80102bbf:	90                   	nop
80102bc0:	c9                   	leave  
80102bc1:	c3                   	ret    

80102bc2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102bc2:	55                   	push   %ebp
80102bc3:	89 e5                	mov    %esp,%ebp
80102bc5:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102bc8:	83 ec 0c             	sub    $0xc,%esp
80102bcb:	68 40 d6 10 80       	push   $0x8010d640
80102bd0:	e8 c7 3c 00 00       	call   8010689c <acquire>
80102bd5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102bd8:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102be4:	75 15                	jne    80102bfb <ideintr+0x39>
    release(&idelock);
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	68 40 d6 10 80       	push   $0x8010d640
80102bee:	e8 10 3d 00 00       	call   80106903 <release>
80102bf3:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102bf6:	e9 9a 00 00 00       	jmp    80102c95 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfe:	8b 40 14             	mov    0x14(%eax),%eax
80102c01:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c09:	8b 00                	mov    (%eax),%eax
80102c0b:	83 e0 04             	and    $0x4,%eax
80102c0e:	85 c0                	test   %eax,%eax
80102c10:	75 2d                	jne    80102c3f <ideintr+0x7d>
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	6a 01                	push   $0x1
80102c17:	e8 55 fd ff ff       	call   80102971 <idewait>
80102c1c:	83 c4 10             	add    $0x10,%esp
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	78 1c                	js     80102c3f <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c26:	83 c0 18             	add    $0x18,%eax
80102c29:	83 ec 04             	sub    $0x4,%esp
80102c2c:	68 80 00 00 00       	push   $0x80
80102c31:	50                   	push   %eax
80102c32:	68 f0 01 00 00       	push   $0x1f0
80102c37:	e8 ca fc ff ff       	call   80102906 <insl>
80102c3c:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c42:	8b 00                	mov    (%eax),%eax
80102c44:	83 c8 02             	or     $0x2,%eax
80102c47:	89 c2                	mov    %eax,%edx
80102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c4c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c51:	8b 00                	mov    (%eax),%eax
80102c53:	83 e0 fb             	and    $0xfffffffb,%eax
80102c56:	89 c2                	mov    %eax,%edx
80102c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102c5d:	83 ec 0c             	sub    $0xc,%esp
80102c60:	ff 75 f4             	pushl  -0xc(%ebp)
80102c63:	e8 ab 2d 00 00       	call   80105a13 <wakeup>
80102c68:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102c6b:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c70:	85 c0                	test   %eax,%eax
80102c72:	74 11                	je     80102c85 <ideintr+0xc3>
    idestart(idequeue);
80102c74:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c79:	83 ec 0c             	sub    $0xc,%esp
80102c7c:	50                   	push   %eax
80102c7d:	e8 e2 fd ff ff       	call   80102a64 <idestart>
80102c82:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102c85:	83 ec 0c             	sub    $0xc,%esp
80102c88:	68 40 d6 10 80       	push   $0x8010d640
80102c8d:	e8 71 3c 00 00       	call   80106903 <release>
80102c92:	83 c4 10             	add    $0x10,%esp
}
80102c95:	c9                   	leave  
80102c96:	c3                   	ret    

80102c97 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c97:	55                   	push   %ebp
80102c98:	89 e5                	mov    %esp,%ebp
80102c9a:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca0:	8b 00                	mov    (%eax),%eax
80102ca2:	83 e0 01             	and    $0x1,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	75 0d                	jne    80102cb6 <iderw+0x1f>
    panic("iderw: buf not busy");
80102ca9:	83 ec 0c             	sub    $0xc,%esp
80102cac:	68 e1 a2 10 80       	push   $0x8010a2e1
80102cb1:	e8 b0 d8 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb9:	8b 00                	mov    (%eax),%eax
80102cbb:	83 e0 06             	and    $0x6,%eax
80102cbe:	83 f8 02             	cmp    $0x2,%eax
80102cc1:	75 0d                	jne    80102cd0 <iderw+0x39>
    panic("iderw: nothing to do");
80102cc3:	83 ec 0c             	sub    $0xc,%esp
80102cc6:	68 f5 a2 10 80       	push   $0x8010a2f5
80102ccb:	e8 96 d8 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd3:	8b 40 04             	mov    0x4(%eax),%eax
80102cd6:	85 c0                	test   %eax,%eax
80102cd8:	74 16                	je     80102cf0 <iderw+0x59>
80102cda:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	75 0d                	jne    80102cf0 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102ce3:	83 ec 0c             	sub    $0xc,%esp
80102ce6:	68 0a a3 10 80       	push   $0x8010a30a
80102ceb:	e8 76 d8 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	68 40 d6 10 80       	push   $0x8010d640
80102cf8:	e8 9f 3b 00 00       	call   8010689c <acquire>
80102cfd:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102d00:	8b 45 08             	mov    0x8(%ebp),%eax
80102d03:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d0a:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102d11:	eb 0b                	jmp    80102d1e <iderw+0x87>
80102d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d16:	8b 00                	mov    (%eax),%eax
80102d18:	83 c0 14             	add    $0x14,%eax
80102d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d21:	8b 00                	mov    (%eax),%eax
80102d23:	85 c0                	test   %eax,%eax
80102d25:	75 ec                	jne    80102d13 <iderw+0x7c>
    ;
  *pp = b;
80102d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d2a:	8b 55 08             	mov    0x8(%ebp),%edx
80102d2d:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102d2f:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102d34:	3b 45 08             	cmp    0x8(%ebp),%eax
80102d37:	75 23                	jne    80102d5c <iderw+0xc5>
    idestart(b);
80102d39:	83 ec 0c             	sub    $0xc,%esp
80102d3c:	ff 75 08             	pushl  0x8(%ebp)
80102d3f:	e8 20 fd ff ff       	call   80102a64 <idestart>
80102d44:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d47:	eb 13                	jmp    80102d5c <iderw+0xc5>
    sleep(b, &idelock);
80102d49:	83 ec 08             	sub    $0x8,%esp
80102d4c:	68 40 d6 10 80       	push   $0x8010d640
80102d51:	ff 75 08             	pushl  0x8(%ebp)
80102d54:	e8 ca 2a 00 00       	call   80105823 <sleep>
80102d59:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d5f:	8b 00                	mov    (%eax),%eax
80102d61:	83 e0 06             	and    $0x6,%eax
80102d64:	83 f8 02             	cmp    $0x2,%eax
80102d67:	75 e0                	jne    80102d49 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102d69:	83 ec 0c             	sub    $0xc,%esp
80102d6c:	68 40 d6 10 80       	push   $0x8010d640
80102d71:	e8 8d 3b 00 00       	call   80106903 <release>
80102d76:	83 c4 10             	add    $0x10,%esp
}
80102d79:	90                   	nop
80102d7a:	c9                   	leave  
80102d7b:	c3                   	ret    

80102d7c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102d7c:	55                   	push   %ebp
80102d7d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d7f:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d84:	8b 55 08             	mov    0x8(%ebp),%edx
80102d87:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102d89:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d8e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102d91:	5d                   	pop    %ebp
80102d92:	c3                   	ret    

80102d93 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102d93:	55                   	push   %ebp
80102d94:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d96:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d9b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d9e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102da0:	a1 54 42 11 80       	mov    0x80114254,%eax
80102da5:	8b 55 0c             	mov    0xc(%ebp),%edx
80102da8:	89 50 10             	mov    %edx,0x10(%eax)
}
80102dab:	90                   	nop
80102dac:	5d                   	pop    %ebp
80102dad:	c3                   	ret    

80102dae <ioapicinit>:

void
ioapicinit(void)
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102db4:	a1 84 43 11 80       	mov    0x80114384,%eax
80102db9:	85 c0                	test   %eax,%eax
80102dbb:	0f 84 a0 00 00 00    	je     80102e61 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102dc1:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102dc8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102dcb:	6a 01                	push   $0x1
80102dcd:	e8 aa ff ff ff       	call   80102d7c <ioapicread>
80102dd2:	83 c4 04             	add    $0x4,%esp
80102dd5:	c1 e8 10             	shr    $0x10,%eax
80102dd8:	25 ff 00 00 00       	and    $0xff,%eax
80102ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102de0:	6a 00                	push   $0x0
80102de2:	e8 95 ff ff ff       	call   80102d7c <ioapicread>
80102de7:	83 c4 04             	add    $0x4,%esp
80102dea:	c1 e8 18             	shr    $0x18,%eax
80102ded:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102df0:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102df7:	0f b6 c0             	movzbl %al,%eax
80102dfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102dfd:	74 10                	je     80102e0f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102dff:	83 ec 0c             	sub    $0xc,%esp
80102e02:	68 28 a3 10 80       	push   $0x8010a328
80102e07:	e8 ba d5 ff ff       	call   801003c6 <cprintf>
80102e0c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e16:	eb 3f                	jmp    80102e57 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e1b:	83 c0 20             	add    $0x20,%eax
80102e1e:	0d 00 00 01 00       	or     $0x10000,%eax
80102e23:	89 c2                	mov    %eax,%edx
80102e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e28:	83 c0 08             	add    $0x8,%eax
80102e2b:	01 c0                	add    %eax,%eax
80102e2d:	83 ec 08             	sub    $0x8,%esp
80102e30:	52                   	push   %edx
80102e31:	50                   	push   %eax
80102e32:	e8 5c ff ff ff       	call   80102d93 <ioapicwrite>
80102e37:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e3d:	83 c0 08             	add    $0x8,%eax
80102e40:	01 c0                	add    %eax,%eax
80102e42:	83 c0 01             	add    $0x1,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	6a 00                	push   $0x0
80102e4a:	50                   	push   %eax
80102e4b:	e8 43 ff ff ff       	call   80102d93 <ioapicwrite>
80102e50:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e5d:	7e b9                	jle    80102e18 <ioapicinit+0x6a>
80102e5f:	eb 01                	jmp    80102e62 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102e61:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102e62:	c9                   	leave  
80102e63:	c3                   	ret    

80102e64 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102e64:	55                   	push   %ebp
80102e65:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102e67:	a1 84 43 11 80       	mov    0x80114384,%eax
80102e6c:	85 c0                	test   %eax,%eax
80102e6e:	74 39                	je     80102ea9 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102e70:	8b 45 08             	mov    0x8(%ebp),%eax
80102e73:	83 c0 20             	add    $0x20,%eax
80102e76:	89 c2                	mov    %eax,%edx
80102e78:	8b 45 08             	mov    0x8(%ebp),%eax
80102e7b:	83 c0 08             	add    $0x8,%eax
80102e7e:	01 c0                	add    %eax,%eax
80102e80:	52                   	push   %edx
80102e81:	50                   	push   %eax
80102e82:	e8 0c ff ff ff       	call   80102d93 <ioapicwrite>
80102e87:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e8d:	c1 e0 18             	shl    $0x18,%eax
80102e90:	89 c2                	mov    %eax,%edx
80102e92:	8b 45 08             	mov    0x8(%ebp),%eax
80102e95:	83 c0 08             	add    $0x8,%eax
80102e98:	01 c0                	add    %eax,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	52                   	push   %edx
80102e9e:	50                   	push   %eax
80102e9f:	e8 ef fe ff ff       	call   80102d93 <ioapicwrite>
80102ea4:	83 c4 08             	add    $0x8,%esp
80102ea7:	eb 01                	jmp    80102eaa <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102ea9:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102eaa:	c9                   	leave  
80102eab:	c3                   	ret    

80102eac <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102eac:	55                   	push   %ebp
80102ead:	89 e5                	mov    %esp,%ebp
80102eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80102eb2:	05 00 00 00 80       	add    $0x80000000,%eax
80102eb7:	5d                   	pop    %ebp
80102eb8:	c3                   	ret    

80102eb9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102eb9:	55                   	push   %ebp
80102eba:	89 e5                	mov    %esp,%ebp
80102ebc:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 5a a3 10 80       	push   $0x8010a35a
80102ec7:	68 60 42 11 80       	push   $0x80114260
80102ecc:	e8 a9 39 00 00       	call   8010687a <initlock>
80102ed1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ed4:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80102edb:	00 00 00 
  freerange(vstart, vend);
80102ede:	83 ec 08             	sub    $0x8,%esp
80102ee1:	ff 75 0c             	pushl  0xc(%ebp)
80102ee4:	ff 75 08             	pushl  0x8(%ebp)
80102ee7:	e8 2a 00 00 00       	call   80102f16 <freerange>
80102eec:	83 c4 10             	add    $0x10,%esp
}
80102eef:	90                   	nop
80102ef0:	c9                   	leave  
80102ef1:	c3                   	ret    

80102ef2 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ef2:	55                   	push   %ebp
80102ef3:	89 e5                	mov    %esp,%ebp
80102ef5:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	ff 75 0c             	pushl  0xc(%ebp)
80102efe:	ff 75 08             	pushl  0x8(%ebp)
80102f01:	e8 10 00 00 00       	call   80102f16 <freerange>
80102f06:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102f09:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80102f10:	00 00 00 
}
80102f13:	90                   	nop
80102f14:	c9                   	leave  
80102f15:	c3                   	ret    

80102f16 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102f16:	55                   	push   %ebp
80102f17:	89 e5                	mov    %esp,%ebp
80102f19:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1f:	05 ff 0f 00 00       	add    $0xfff,%eax
80102f24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f2c:	eb 15                	jmp    80102f43 <freerange+0x2d>
    kfree(p);
80102f2e:	83 ec 0c             	sub    $0xc,%esp
80102f31:	ff 75 f4             	pushl  -0xc(%ebp)
80102f34:	e8 1a 00 00 00       	call   80102f53 <kfree>
80102f39:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f3c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f46:	05 00 10 00 00       	add    $0x1000,%eax
80102f4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102f4e:	76 de                	jbe    80102f2e <freerange+0x18>
    kfree(p);
}
80102f50:	90                   	nop
80102f51:	c9                   	leave  
80102f52:	c3                   	ret    

80102f53 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f53:	55                   	push   %ebp
80102f54:	89 e5                	mov    %esp,%ebp
80102f56:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102f59:	8b 45 08             	mov    0x8(%ebp),%eax
80102f5c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f61:	85 c0                	test   %eax,%eax
80102f63:	75 1b                	jne    80102f80 <kfree+0x2d>
80102f65:	81 7d 08 7c 79 11 80 	cmpl   $0x8011797c,0x8(%ebp)
80102f6c:	72 12                	jb     80102f80 <kfree+0x2d>
80102f6e:	ff 75 08             	pushl  0x8(%ebp)
80102f71:	e8 36 ff ff ff       	call   80102eac <v2p>
80102f76:	83 c4 04             	add    $0x4,%esp
80102f79:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f7e:	76 0d                	jbe    80102f8d <kfree+0x3a>
    panic("kfree");
80102f80:	83 ec 0c             	sub    $0xc,%esp
80102f83:	68 5f a3 10 80       	push   $0x8010a35f
80102f88:	e8 d9 d5 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f8d:	83 ec 04             	sub    $0x4,%esp
80102f90:	68 00 10 00 00       	push   $0x1000
80102f95:	6a 01                	push   $0x1
80102f97:	ff 75 08             	pushl  0x8(%ebp)
80102f9a:	e8 60 3b 00 00       	call   80106aff <memset>
80102f9f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102fa2:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fa7:	85 c0                	test   %eax,%eax
80102fa9:	74 10                	je     80102fbb <kfree+0x68>
    acquire(&kmem.lock);
80102fab:	83 ec 0c             	sub    $0xc,%esp
80102fae:	68 60 42 11 80       	push   $0x80114260
80102fb3:	e8 e4 38 00 00       	call   8010689c <acquire>
80102fb8:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80102fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102fc1:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80102fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fca:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fcf:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102fd4:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fd9:	85 c0                	test   %eax,%eax
80102fdb:	74 10                	je     80102fed <kfree+0x9a>
    release(&kmem.lock);
80102fdd:	83 ec 0c             	sub    $0xc,%esp
80102fe0:	68 60 42 11 80       	push   $0x80114260
80102fe5:	e8 19 39 00 00       	call   80106903 <release>
80102fea:	83 c4 10             	add    $0x10,%esp
}
80102fed:	90                   	nop
80102fee:	c9                   	leave  
80102fef:	c3                   	ret    

80102ff0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102ff6:	a1 94 42 11 80       	mov    0x80114294,%eax
80102ffb:	85 c0                	test   %eax,%eax
80102ffd:	74 10                	je     8010300f <kalloc+0x1f>
    acquire(&kmem.lock);
80102fff:	83 ec 0c             	sub    $0xc,%esp
80103002:	68 60 42 11 80       	push   $0x80114260
80103007:	e8 90 38 00 00       	call   8010689c <acquire>
8010300c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
8010300f:	a1 98 42 11 80       	mov    0x80114298,%eax
80103014:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80103017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010301b:	74 0a                	je     80103027 <kalloc+0x37>
    kmem.freelist = r->next;
8010301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103020:	8b 00                	mov    (%eax),%eax
80103022:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80103027:	a1 94 42 11 80       	mov    0x80114294,%eax
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 10                	je     80103040 <kalloc+0x50>
    release(&kmem.lock);
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 60 42 11 80       	push   $0x80114260
80103038:	e8 c6 38 00 00       	call   80106903 <release>
8010303d:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103043:	c9                   	leave  
80103044:	c3                   	ret    

80103045 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103045:	55                   	push   %ebp
80103046:	89 e5                	mov    %esp,%ebp
80103048:	83 ec 14             	sub    $0x14,%esp
8010304b:	8b 45 08             	mov    0x8(%ebp),%eax
8010304e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103052:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103056:	89 c2                	mov    %eax,%edx
80103058:	ec                   	in     (%dx),%al
80103059:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010305c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103060:	c9                   	leave  
80103061:	c3                   	ret    

80103062 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103062:	55                   	push   %ebp
80103063:	89 e5                	mov    %esp,%ebp
80103065:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80103068:	6a 64                	push   $0x64
8010306a:	e8 d6 ff ff ff       	call   80103045 <inb>
8010306f:	83 c4 04             	add    $0x4,%esp
80103072:	0f b6 c0             	movzbl %al,%eax
80103075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80103078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010307b:	83 e0 01             	and    $0x1,%eax
8010307e:	85 c0                	test   %eax,%eax
80103080:	75 0a                	jne    8010308c <kbdgetc+0x2a>
    return -1;
80103082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103087:	e9 23 01 00 00       	jmp    801031af <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010308c:	6a 60                	push   $0x60
8010308e:	e8 b2 ff ff ff       	call   80103045 <inb>
80103093:	83 c4 04             	add    $0x4,%esp
80103096:	0f b6 c0             	movzbl %al,%eax
80103099:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010309c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
801030a3:	75 17                	jne    801030bc <kbdgetc+0x5a>
    shift |= E0ESC;
801030a5:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030aa:	83 c8 40             	or     $0x40,%eax
801030ad:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
801030b2:	b8 00 00 00 00       	mov    $0x0,%eax
801030b7:	e9 f3 00 00 00       	jmp    801031af <kbdgetc+0x14d>
  } else if(data & 0x80){
801030bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030bf:	25 80 00 00 00       	and    $0x80,%eax
801030c4:	85 c0                	test   %eax,%eax
801030c6:	74 45                	je     8010310d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801030c8:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030cd:	83 e0 40             	and    $0x40,%eax
801030d0:	85 c0                	test   %eax,%eax
801030d2:	75 08                	jne    801030dc <kbdgetc+0x7a>
801030d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030d7:	83 e0 7f             	and    $0x7f,%eax
801030da:	eb 03                	jmp    801030df <kbdgetc+0x7d>
801030dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030df:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
801030e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030e5:	05 20 b0 10 80       	add    $0x8010b020,%eax
801030ea:	0f b6 00             	movzbl (%eax),%eax
801030ed:	83 c8 40             	or     $0x40,%eax
801030f0:	0f b6 c0             	movzbl %al,%eax
801030f3:	f7 d0                	not    %eax
801030f5:	89 c2                	mov    %eax,%edx
801030f7:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030fc:	21 d0                	and    %edx,%eax
801030fe:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103103:	b8 00 00 00 00       	mov    $0x0,%eax
80103108:	e9 a2 00 00 00       	jmp    801031af <kbdgetc+0x14d>
  } else if(shift & E0ESC){
8010310d:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103112:	83 e0 40             	and    $0x40,%eax
80103115:	85 c0                	test   %eax,%eax
80103117:	74 14                	je     8010312d <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103119:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80103120:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103125:	83 e0 bf             	and    $0xffffffbf,%eax
80103128:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
8010312d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103130:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103135:	0f b6 00             	movzbl (%eax),%eax
80103138:	0f b6 d0             	movzbl %al,%edx
8010313b:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103140:	09 d0                	or     %edx,%eax
80103142:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
80103147:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010314a:	05 20 b1 10 80       	add    $0x8010b120,%eax
8010314f:	0f b6 00             	movzbl (%eax),%eax
80103152:	0f b6 d0             	movzbl %al,%edx
80103155:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010315a:	31 d0                	xor    %edx,%eax
8010315c:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
80103161:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103166:	83 e0 03             	and    $0x3,%eax
80103169:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80103170:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103173:	01 d0                	add    %edx,%eax
80103175:	0f b6 00             	movzbl (%eax),%eax
80103178:	0f b6 c0             	movzbl %al,%eax
8010317b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
8010317e:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103183:	83 e0 08             	and    $0x8,%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 22                	je     801031ac <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010318a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010318e:	76 0c                	jbe    8010319c <kbdgetc+0x13a>
80103190:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103194:	77 06                	ja     8010319c <kbdgetc+0x13a>
      c += 'A' - 'a';
80103196:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010319a:	eb 10                	jmp    801031ac <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010319c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801031a0:	76 0a                	jbe    801031ac <kbdgetc+0x14a>
801031a2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801031a6:	77 04                	ja     801031ac <kbdgetc+0x14a>
      c += 'a' - 'A';
801031a8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
801031ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801031af:	c9                   	leave  
801031b0:	c3                   	ret    

801031b1 <kbdintr>:

void
kbdintr(void)
{
801031b1:	55                   	push   %ebp
801031b2:	89 e5                	mov    %esp,%ebp
801031b4:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
801031b7:	83 ec 0c             	sub    $0xc,%esp
801031ba:	68 62 30 10 80       	push   $0x80103062
801031bf:	e8 35 d6 ff ff       	call   801007f9 <consoleintr>
801031c4:	83 c4 10             	add    $0x10,%esp
}
801031c7:	90                   	nop
801031c8:	c9                   	leave  
801031c9:	c3                   	ret    

801031ca <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801031ca:	55                   	push   %ebp
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	83 ec 14             	sub    $0x14,%esp
801031d0:	8b 45 08             	mov    0x8(%ebp),%eax
801031d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801031db:	89 c2                	mov    %eax,%edx
801031dd:	ec                   	in     (%dx),%al
801031de:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801031e1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801031e5:	c9                   	leave  
801031e6:	c3                   	ret    

801031e7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801031e7:	55                   	push   %ebp
801031e8:	89 e5                	mov    %esp,%ebp
801031ea:	83 ec 08             	sub    $0x8,%esp
801031ed:	8b 55 08             	mov    0x8(%ebp),%edx
801031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801031f3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801031f7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031fa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801031fe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103202:	ee                   	out    %al,(%dx)
}
80103203:	90                   	nop
80103204:	c9                   	leave  
80103205:	c3                   	ret    

80103206 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103206:	55                   	push   %ebp
80103207:	89 e5                	mov    %esp,%ebp
80103209:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010320c:	9c                   	pushf  
8010320d:	58                   	pop    %eax
8010320e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103211:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103214:	c9                   	leave  
80103215:	c3                   	ret    

80103216 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103216:	55                   	push   %ebp
80103217:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103219:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010321e:	8b 55 08             	mov    0x8(%ebp),%edx
80103221:	c1 e2 02             	shl    $0x2,%edx
80103224:	01 c2                	add    %eax,%edx
80103226:	8b 45 0c             	mov    0xc(%ebp),%eax
80103229:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010322b:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103230:	83 c0 20             	add    $0x20,%eax
80103233:	8b 00                	mov    (%eax),%eax
}
80103235:	90                   	nop
80103236:	5d                   	pop    %ebp
80103237:	c3                   	ret    

80103238 <lapicinit>:

void
lapicinit(void)
{
80103238:	55                   	push   %ebp
80103239:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010323b:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103240:	85 c0                	test   %eax,%eax
80103242:	0f 84 0b 01 00 00    	je     80103353 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103248:	68 3f 01 00 00       	push   $0x13f
8010324d:	6a 3c                	push   $0x3c
8010324f:	e8 c2 ff ff ff       	call   80103216 <lapicw>
80103254:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103257:	6a 0b                	push   $0xb
80103259:	68 f8 00 00 00       	push   $0xf8
8010325e:	e8 b3 ff ff ff       	call   80103216 <lapicw>
80103263:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103266:	68 20 00 02 00       	push   $0x20020
8010326b:	68 c8 00 00 00       	push   $0xc8
80103270:	e8 a1 ff ff ff       	call   80103216 <lapicw>
80103275:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80103278:	68 40 42 0f 00       	push   $0xf4240
8010327d:	68 e0 00 00 00       	push   $0xe0
80103282:	e8 8f ff ff ff       	call   80103216 <lapicw>
80103287:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010328a:	68 00 00 01 00       	push   $0x10000
8010328f:	68 d4 00 00 00       	push   $0xd4
80103294:	e8 7d ff ff ff       	call   80103216 <lapicw>
80103299:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010329c:	68 00 00 01 00       	push   $0x10000
801032a1:	68 d8 00 00 00       	push   $0xd8
801032a6:	e8 6b ff ff ff       	call   80103216 <lapicw>
801032ab:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801032ae:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801032b3:	83 c0 30             	add    $0x30,%eax
801032b6:	8b 00                	mov    (%eax),%eax
801032b8:	c1 e8 10             	shr    $0x10,%eax
801032bb:	0f b6 c0             	movzbl %al,%eax
801032be:	83 f8 03             	cmp    $0x3,%eax
801032c1:	76 12                	jbe    801032d5 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
801032c3:	68 00 00 01 00       	push   $0x10000
801032c8:	68 d0 00 00 00       	push   $0xd0
801032cd:	e8 44 ff ff ff       	call   80103216 <lapicw>
801032d2:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801032d5:	6a 33                	push   $0x33
801032d7:	68 dc 00 00 00       	push   $0xdc
801032dc:	e8 35 ff ff ff       	call   80103216 <lapicw>
801032e1:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801032e4:	6a 00                	push   $0x0
801032e6:	68 a0 00 00 00       	push   $0xa0
801032eb:	e8 26 ff ff ff       	call   80103216 <lapicw>
801032f0:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801032f3:	6a 00                	push   $0x0
801032f5:	68 a0 00 00 00       	push   $0xa0
801032fa:	e8 17 ff ff ff       	call   80103216 <lapicw>
801032ff:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103302:	6a 00                	push   $0x0
80103304:	6a 2c                	push   $0x2c
80103306:	e8 0b ff ff ff       	call   80103216 <lapicw>
8010330b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010330e:	6a 00                	push   $0x0
80103310:	68 c4 00 00 00       	push   $0xc4
80103315:	e8 fc fe ff ff       	call   80103216 <lapicw>
8010331a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010331d:	68 00 85 08 00       	push   $0x88500
80103322:	68 c0 00 00 00       	push   $0xc0
80103327:	e8 ea fe ff ff       	call   80103216 <lapicw>
8010332c:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010332f:	90                   	nop
80103330:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103335:	05 00 03 00 00       	add    $0x300,%eax
8010333a:	8b 00                	mov    (%eax),%eax
8010333c:	25 00 10 00 00       	and    $0x1000,%eax
80103341:	85 c0                	test   %eax,%eax
80103343:	75 eb                	jne    80103330 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103345:	6a 00                	push   $0x0
80103347:	6a 20                	push   $0x20
80103349:	e8 c8 fe ff ff       	call   80103216 <lapicw>
8010334e:	83 c4 08             	add    $0x8,%esp
80103351:	eb 01                	jmp    80103354 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103353:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103354:	c9                   	leave  
80103355:	c3                   	ret    

80103356 <cpunum>:

int
cpunum(void)
{
80103356:	55                   	push   %ebp
80103357:	89 e5                	mov    %esp,%ebp
80103359:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010335c:	e8 a5 fe ff ff       	call   80103206 <readeflags>
80103361:	25 00 02 00 00       	and    $0x200,%eax
80103366:	85 c0                	test   %eax,%eax
80103368:	74 26                	je     80103390 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010336a:	a1 80 d6 10 80       	mov    0x8010d680,%eax
8010336f:	8d 50 01             	lea    0x1(%eax),%edx
80103372:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
80103378:	85 c0                	test   %eax,%eax
8010337a:	75 14                	jne    80103390 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010337c:	8b 45 04             	mov    0x4(%ebp),%eax
8010337f:	83 ec 08             	sub    $0x8,%esp
80103382:	50                   	push   %eax
80103383:	68 68 a3 10 80       	push   $0x8010a368
80103388:	e8 39 d0 ff ff       	call   801003c6 <cprintf>
8010338d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103390:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103395:	85 c0                	test   %eax,%eax
80103397:	74 0f                	je     801033a8 <cpunum+0x52>
    return lapic[ID]>>24;
80103399:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010339e:	83 c0 20             	add    $0x20,%eax
801033a1:	8b 00                	mov    (%eax),%eax
801033a3:	c1 e8 18             	shr    $0x18,%eax
801033a6:	eb 05                	jmp    801033ad <cpunum+0x57>
  return 0;
801033a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033ad:	c9                   	leave  
801033ae:	c3                   	ret    

801033af <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801033af:	55                   	push   %ebp
801033b0:	89 e5                	mov    %esp,%ebp
  if(lapic)
801033b2:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033b7:	85 c0                	test   %eax,%eax
801033b9:	74 0c                	je     801033c7 <lapiceoi+0x18>
    lapicw(EOI, 0);
801033bb:	6a 00                	push   $0x0
801033bd:	6a 2c                	push   $0x2c
801033bf:	e8 52 fe ff ff       	call   80103216 <lapicw>
801033c4:	83 c4 08             	add    $0x8,%esp
}
801033c7:	90                   	nop
801033c8:	c9                   	leave  
801033c9:	c3                   	ret    

801033ca <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801033ca:	55                   	push   %ebp
801033cb:	89 e5                	mov    %esp,%ebp
}
801033cd:	90                   	nop
801033ce:	5d                   	pop    %ebp
801033cf:	c3                   	ret    

801033d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	83 ec 14             	sub    $0x14,%esp
801033d6:	8b 45 08             	mov    0x8(%ebp),%eax
801033d9:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801033dc:	6a 0f                	push   $0xf
801033de:	6a 70                	push   $0x70
801033e0:	e8 02 fe ff ff       	call   801031e7 <outb>
801033e5:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801033e8:	6a 0a                	push   $0xa
801033ea:	6a 71                	push   $0x71
801033ec:	e8 f6 fd ff ff       	call   801031e7 <outb>
801033f1:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801033f4:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801033fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033fe:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103403:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103406:	83 c0 02             	add    $0x2,%eax
80103409:	8b 55 0c             	mov    0xc(%ebp),%edx
8010340c:	c1 ea 04             	shr    $0x4,%edx
8010340f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103412:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103416:	c1 e0 18             	shl    $0x18,%eax
80103419:	50                   	push   %eax
8010341a:	68 c4 00 00 00       	push   $0xc4
8010341f:	e8 f2 fd ff ff       	call   80103216 <lapicw>
80103424:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103427:	68 00 c5 00 00       	push   $0xc500
8010342c:	68 c0 00 00 00       	push   $0xc0
80103431:	e8 e0 fd ff ff       	call   80103216 <lapicw>
80103436:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103439:	68 c8 00 00 00       	push   $0xc8
8010343e:	e8 87 ff ff ff       	call   801033ca <microdelay>
80103443:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103446:	68 00 85 00 00       	push   $0x8500
8010344b:	68 c0 00 00 00       	push   $0xc0
80103450:	e8 c1 fd ff ff       	call   80103216 <lapicw>
80103455:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103458:	6a 64                	push   $0x64
8010345a:	e8 6b ff ff ff       	call   801033ca <microdelay>
8010345f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103469:	eb 3d                	jmp    801034a8 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010346b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010346f:	c1 e0 18             	shl    $0x18,%eax
80103472:	50                   	push   %eax
80103473:	68 c4 00 00 00       	push   $0xc4
80103478:	e8 99 fd ff ff       	call   80103216 <lapicw>
8010347d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103480:	8b 45 0c             	mov    0xc(%ebp),%eax
80103483:	c1 e8 0c             	shr    $0xc,%eax
80103486:	80 cc 06             	or     $0x6,%ah
80103489:	50                   	push   %eax
8010348a:	68 c0 00 00 00       	push   $0xc0
8010348f:	e8 82 fd ff ff       	call   80103216 <lapicw>
80103494:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103497:	68 c8 00 00 00       	push   $0xc8
8010349c:	e8 29 ff ff ff       	call   801033ca <microdelay>
801034a1:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801034a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801034a8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801034ac:	7e bd                	jle    8010346b <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801034ae:	90                   	nop
801034af:	c9                   	leave  
801034b0:	c3                   	ret    

801034b1 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801034b1:	55                   	push   %ebp
801034b2:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801034b4:	8b 45 08             	mov    0x8(%ebp),%eax
801034b7:	0f b6 c0             	movzbl %al,%eax
801034ba:	50                   	push   %eax
801034bb:	6a 70                	push   $0x70
801034bd:	e8 25 fd ff ff       	call   801031e7 <outb>
801034c2:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801034c5:	68 c8 00 00 00       	push   $0xc8
801034ca:	e8 fb fe ff ff       	call   801033ca <microdelay>
801034cf:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801034d2:	6a 71                	push   $0x71
801034d4:	e8 f1 fc ff ff       	call   801031ca <inb>
801034d9:	83 c4 04             	add    $0x4,%esp
801034dc:	0f b6 c0             	movzbl %al,%eax
}
801034df:	c9                   	leave  
801034e0:	c3                   	ret    

801034e1 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801034e1:	55                   	push   %ebp
801034e2:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801034e4:	6a 00                	push   $0x0
801034e6:	e8 c6 ff ff ff       	call   801034b1 <cmos_read>
801034eb:	83 c4 04             	add    $0x4,%esp
801034ee:	89 c2                	mov    %eax,%edx
801034f0:	8b 45 08             	mov    0x8(%ebp),%eax
801034f3:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801034f5:	6a 02                	push   $0x2
801034f7:	e8 b5 ff ff ff       	call   801034b1 <cmos_read>
801034fc:	83 c4 04             	add    $0x4,%esp
801034ff:	89 c2                	mov    %eax,%edx
80103501:	8b 45 08             	mov    0x8(%ebp),%eax
80103504:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103507:	6a 04                	push   $0x4
80103509:	e8 a3 ff ff ff       	call   801034b1 <cmos_read>
8010350e:	83 c4 04             	add    $0x4,%esp
80103511:	89 c2                	mov    %eax,%edx
80103513:	8b 45 08             	mov    0x8(%ebp),%eax
80103516:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103519:	6a 07                	push   $0x7
8010351b:	e8 91 ff ff ff       	call   801034b1 <cmos_read>
80103520:	83 c4 04             	add    $0x4,%esp
80103523:	89 c2                	mov    %eax,%edx
80103525:	8b 45 08             	mov    0x8(%ebp),%eax
80103528:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010352b:	6a 08                	push   $0x8
8010352d:	e8 7f ff ff ff       	call   801034b1 <cmos_read>
80103532:	83 c4 04             	add    $0x4,%esp
80103535:	89 c2                	mov    %eax,%edx
80103537:	8b 45 08             	mov    0x8(%ebp),%eax
8010353a:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010353d:	6a 09                	push   $0x9
8010353f:	e8 6d ff ff ff       	call   801034b1 <cmos_read>
80103544:	83 c4 04             	add    $0x4,%esp
80103547:	89 c2                	mov    %eax,%edx
80103549:	8b 45 08             	mov    0x8(%ebp),%eax
8010354c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010354f:	90                   	nop
80103550:	c9                   	leave  
80103551:	c3                   	ret    

80103552 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103552:	55                   	push   %ebp
80103553:	89 e5                	mov    %esp,%ebp
80103555:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103558:	6a 0b                	push   $0xb
8010355a:	e8 52 ff ff ff       	call   801034b1 <cmos_read>
8010355f:	83 c4 04             	add    $0x4,%esp
80103562:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103568:	83 e0 04             	and    $0x4,%eax
8010356b:	85 c0                	test   %eax,%eax
8010356d:	0f 94 c0             	sete   %al
80103570:	0f b6 c0             	movzbl %al,%eax
80103573:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103576:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103579:	50                   	push   %eax
8010357a:	e8 62 ff ff ff       	call   801034e1 <fill_rtcdate>
8010357f:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103582:	6a 0a                	push   $0xa
80103584:	e8 28 ff ff ff       	call   801034b1 <cmos_read>
80103589:	83 c4 04             	add    $0x4,%esp
8010358c:	25 80 00 00 00       	and    $0x80,%eax
80103591:	85 c0                	test   %eax,%eax
80103593:	75 27                	jne    801035bc <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103595:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103598:	50                   	push   %eax
80103599:	e8 43 ff ff ff       	call   801034e1 <fill_rtcdate>
8010359e:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801035a1:	83 ec 04             	sub    $0x4,%esp
801035a4:	6a 18                	push   $0x18
801035a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801035a9:	50                   	push   %eax
801035aa:	8d 45 d8             	lea    -0x28(%ebp),%eax
801035ad:	50                   	push   %eax
801035ae:	e8 b3 35 00 00       	call   80106b66 <memcmp>
801035b3:	83 c4 10             	add    $0x10,%esp
801035b6:	85 c0                	test   %eax,%eax
801035b8:	74 05                	je     801035bf <cmostime+0x6d>
801035ba:	eb ba                	jmp    80103576 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801035bc:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801035bd:	eb b7                	jmp    80103576 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801035bf:	90                   	nop
  }

  // convert
  if (bcd) {
801035c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801035c4:	0f 84 b4 00 00 00    	je     8010367e <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801035ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
801035cd:	c1 e8 04             	shr    $0x4,%eax
801035d0:	89 c2                	mov    %eax,%edx
801035d2:	89 d0                	mov    %edx,%eax
801035d4:	c1 e0 02             	shl    $0x2,%eax
801035d7:	01 d0                	add    %edx,%eax
801035d9:	01 c0                	add    %eax,%eax
801035db:	89 c2                	mov    %eax,%edx
801035dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801035e0:	83 e0 0f             	and    $0xf,%eax
801035e3:	01 d0                	add    %edx,%eax
801035e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801035e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035eb:	c1 e8 04             	shr    $0x4,%eax
801035ee:	89 c2                	mov    %eax,%edx
801035f0:	89 d0                	mov    %edx,%eax
801035f2:	c1 e0 02             	shl    $0x2,%eax
801035f5:	01 d0                	add    %edx,%eax
801035f7:	01 c0                	add    %eax,%eax
801035f9:	89 c2                	mov    %eax,%edx
801035fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035fe:	83 e0 0f             	and    $0xf,%eax
80103601:	01 d0                	add    %edx,%eax
80103603:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103606:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103609:	c1 e8 04             	shr    $0x4,%eax
8010360c:	89 c2                	mov    %eax,%edx
8010360e:	89 d0                	mov    %edx,%eax
80103610:	c1 e0 02             	shl    $0x2,%eax
80103613:	01 d0                	add    %edx,%eax
80103615:	01 c0                	add    %eax,%eax
80103617:	89 c2                	mov    %eax,%edx
80103619:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010361c:	83 e0 0f             	and    $0xf,%eax
8010361f:	01 d0                	add    %edx,%eax
80103621:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103627:	c1 e8 04             	shr    $0x4,%eax
8010362a:	89 c2                	mov    %eax,%edx
8010362c:	89 d0                	mov    %edx,%eax
8010362e:	c1 e0 02             	shl    $0x2,%eax
80103631:	01 d0                	add    %edx,%eax
80103633:	01 c0                	add    %eax,%eax
80103635:	89 c2                	mov    %eax,%edx
80103637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010363a:	83 e0 0f             	and    $0xf,%eax
8010363d:	01 d0                	add    %edx,%eax
8010363f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103642:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103645:	c1 e8 04             	shr    $0x4,%eax
80103648:	89 c2                	mov    %eax,%edx
8010364a:	89 d0                	mov    %edx,%eax
8010364c:	c1 e0 02             	shl    $0x2,%eax
8010364f:	01 d0                	add    %edx,%eax
80103651:	01 c0                	add    %eax,%eax
80103653:	89 c2                	mov    %eax,%edx
80103655:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103658:	83 e0 0f             	and    $0xf,%eax
8010365b:	01 d0                	add    %edx,%eax
8010365d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103660:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103663:	c1 e8 04             	shr    $0x4,%eax
80103666:	89 c2                	mov    %eax,%edx
80103668:	89 d0                	mov    %edx,%eax
8010366a:	c1 e0 02             	shl    $0x2,%eax
8010366d:	01 d0                	add    %edx,%eax
8010366f:	01 c0                	add    %eax,%eax
80103671:	89 c2                	mov    %eax,%edx
80103673:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103676:	83 e0 0f             	and    $0xf,%eax
80103679:	01 d0                	add    %edx,%eax
8010367b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010367e:	8b 45 08             	mov    0x8(%ebp),%eax
80103681:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103684:	89 10                	mov    %edx,(%eax)
80103686:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103689:	89 50 04             	mov    %edx,0x4(%eax)
8010368c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010368f:	89 50 08             	mov    %edx,0x8(%eax)
80103692:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103695:	89 50 0c             	mov    %edx,0xc(%eax)
80103698:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010369b:	89 50 10             	mov    %edx,0x10(%eax)
8010369e:	8b 55 ec             	mov    -0x14(%ebp),%edx
801036a1:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801036a4:	8b 45 08             	mov    0x8(%ebp),%eax
801036a7:	8b 40 14             	mov    0x14(%eax),%eax
801036aa:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801036b0:	8b 45 08             	mov    0x8(%ebp),%eax
801036b3:	89 50 14             	mov    %edx,0x14(%eax)
}
801036b6:	90                   	nop
801036b7:	c9                   	leave  
801036b8:	c3                   	ret    

801036b9 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801036b9:	55                   	push   %ebp
801036ba:	89 e5                	mov    %esp,%ebp
801036bc:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801036bf:	83 ec 08             	sub    $0x8,%esp
801036c2:	68 94 a3 10 80       	push   $0x8010a394
801036c7:	68 a0 42 11 80       	push   $0x801142a0
801036cc:	e8 a9 31 00 00       	call   8010687a <initlock>
801036d1:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801036d4:	83 ec 08             	sub    $0x8,%esp
801036d7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801036da:	50                   	push   %eax
801036db:	ff 75 08             	pushl  0x8(%ebp)
801036de:	e8 97 df ff ff       	call   8010167a <readsb>
801036e3:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801036e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036e9:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
801036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801036f1:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
801036f6:	8b 45 08             	mov    0x8(%ebp),%eax
801036f9:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
801036fe:	e8 b2 01 00 00       	call   801038b5 <recover_from_log>
}
80103703:	90                   	nop
80103704:	c9                   	leave  
80103705:	c3                   	ret    

80103706 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103706:	55                   	push   %ebp
80103707:	89 e5                	mov    %esp,%ebp
80103709:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010370c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103713:	e9 95 00 00 00       	jmp    801037ad <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103718:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
8010371e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103721:	01 d0                	add    %edx,%eax
80103723:	83 c0 01             	add    $0x1,%eax
80103726:	89 c2                	mov    %eax,%edx
80103728:	a1 e4 42 11 80       	mov    0x801142e4,%eax
8010372d:	83 ec 08             	sub    $0x8,%esp
80103730:	52                   	push   %edx
80103731:	50                   	push   %eax
80103732:	e8 7f ca ff ff       	call   801001b6 <bread>
80103737:	83 c4 10             	add    $0x10,%esp
8010373a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010373d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103740:	83 c0 10             	add    $0x10,%eax
80103743:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
8010374a:	89 c2                	mov    %eax,%edx
8010374c:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103751:	83 ec 08             	sub    $0x8,%esp
80103754:	52                   	push   %edx
80103755:	50                   	push   %eax
80103756:	e8 5b ca ff ff       	call   801001b6 <bread>
8010375b:	83 c4 10             	add    $0x10,%esp
8010375e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103764:	8d 50 18             	lea    0x18(%eax),%edx
80103767:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010376a:	83 c0 18             	add    $0x18,%eax
8010376d:	83 ec 04             	sub    $0x4,%esp
80103770:	68 00 02 00 00       	push   $0x200
80103775:	52                   	push   %edx
80103776:	50                   	push   %eax
80103777:	e8 42 34 00 00       	call   80106bbe <memmove>
8010377c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010377f:	83 ec 0c             	sub    $0xc,%esp
80103782:	ff 75 ec             	pushl  -0x14(%ebp)
80103785:	e8 65 ca ff ff       	call   801001ef <bwrite>
8010378a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010378d:	83 ec 0c             	sub    $0xc,%esp
80103790:	ff 75 f0             	pushl  -0x10(%ebp)
80103793:	e8 96 ca ff ff       	call   8010022e <brelse>
80103798:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	ff 75 ec             	pushl  -0x14(%ebp)
801037a1:	e8 88 ca ff ff       	call   8010022e <brelse>
801037a6:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037ad:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801037b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037b5:	0f 8f 5d ff ff ff    	jg     80103718 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801037bb:	90                   	nop
801037bc:	c9                   	leave  
801037bd:	c3                   	ret    

801037be <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801037be:	55                   	push   %ebp
801037bf:	89 e5                	mov    %esp,%ebp
801037c1:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801037c4:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801037c9:	89 c2                	mov    %eax,%edx
801037cb:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801037d0:	83 ec 08             	sub    $0x8,%esp
801037d3:	52                   	push   %edx
801037d4:	50                   	push   %eax
801037d5:	e8 dc c9 ff ff       	call   801001b6 <bread>
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801037e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e3:	83 c0 18             	add    $0x18,%eax
801037e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ec:	8b 00                	mov    (%eax),%eax
801037ee:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
801037f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037fa:	eb 1b                	jmp    80103817 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103802:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103809:	83 c2 10             	add    $0x10,%edx
8010380c:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103813:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103817:	a1 e8 42 11 80       	mov    0x801142e8,%eax
8010381c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010381f:	7f db                	jg     801037fc <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103821:	83 ec 0c             	sub    $0xc,%esp
80103824:	ff 75 f0             	pushl  -0x10(%ebp)
80103827:	e8 02 ca ff ff       	call   8010022e <brelse>
8010382c:	83 c4 10             	add    $0x10,%esp
}
8010382f:	90                   	nop
80103830:	c9                   	leave  
80103831:	c3                   	ret    

80103832 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103832:	55                   	push   %ebp
80103833:	89 e5                	mov    %esp,%ebp
80103835:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103838:	a1 d4 42 11 80       	mov    0x801142d4,%eax
8010383d:	89 c2                	mov    %eax,%edx
8010383f:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103844:	83 ec 08             	sub    $0x8,%esp
80103847:	52                   	push   %edx
80103848:	50                   	push   %eax
80103849:	e8 68 c9 ff ff       	call   801001b6 <bread>
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103854:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103857:	83 c0 18             	add    $0x18,%eax
8010385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010385d:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
80103863:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103866:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010386f:	eb 1b                	jmp    8010388c <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103874:	83 c0 10             	add    $0x10,%eax
80103877:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
8010387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103881:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103884:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103888:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010388c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103891:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103894:	7f db                	jg     80103871 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	ff 75 f0             	pushl  -0x10(%ebp)
8010389c:	e8 4e c9 ff ff       	call   801001ef <bwrite>
801038a1:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801038a4:	83 ec 0c             	sub    $0xc,%esp
801038a7:	ff 75 f0             	pushl  -0x10(%ebp)
801038aa:	e8 7f c9 ff ff       	call   8010022e <brelse>
801038af:	83 c4 10             	add    $0x10,%esp
}
801038b2:	90                   	nop
801038b3:	c9                   	leave  
801038b4:	c3                   	ret    

801038b5 <recover_from_log>:

static void
recover_from_log(void)
{
801038b5:	55                   	push   %ebp
801038b6:	89 e5                	mov    %esp,%ebp
801038b8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801038bb:	e8 fe fe ff ff       	call   801037be <read_head>
  install_trans(); // if committed, copy from log to disk
801038c0:	e8 41 fe ff ff       	call   80103706 <install_trans>
  log.lh.n = 0;
801038c5:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
801038cc:	00 00 00 
  write_head(); // clear the log
801038cf:	e8 5e ff ff ff       	call   80103832 <write_head>
}
801038d4:	90                   	nop
801038d5:	c9                   	leave  
801038d6:	c3                   	ret    

801038d7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801038d7:	55                   	push   %ebp
801038d8:	89 e5                	mov    %esp,%ebp
801038da:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801038dd:	83 ec 0c             	sub    $0xc,%esp
801038e0:	68 a0 42 11 80       	push   $0x801142a0
801038e5:	e8 b2 2f 00 00       	call   8010689c <acquire>
801038ea:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801038ed:	a1 e0 42 11 80       	mov    0x801142e0,%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 17                	je     8010390d <begin_op+0x36>
      sleep(&log, &log.lock);
801038f6:	83 ec 08             	sub    $0x8,%esp
801038f9:	68 a0 42 11 80       	push   $0x801142a0
801038fe:	68 a0 42 11 80       	push   $0x801142a0
80103903:	e8 1b 1f 00 00       	call   80105823 <sleep>
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	eb e0                	jmp    801038ed <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010390d:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
80103913:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103918:	8d 50 01             	lea    0x1(%eax),%edx
8010391b:	89 d0                	mov    %edx,%eax
8010391d:	c1 e0 02             	shl    $0x2,%eax
80103920:	01 d0                	add    %edx,%eax
80103922:	01 c0                	add    %eax,%eax
80103924:	01 c8                	add    %ecx,%eax
80103926:	83 f8 1e             	cmp    $0x1e,%eax
80103929:	7e 17                	jle    80103942 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010392b:	83 ec 08             	sub    $0x8,%esp
8010392e:	68 a0 42 11 80       	push   $0x801142a0
80103933:	68 a0 42 11 80       	push   $0x801142a0
80103938:	e8 e6 1e 00 00       	call   80105823 <sleep>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	eb ab                	jmp    801038ed <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103942:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103947:	83 c0 01             	add    $0x1,%eax
8010394a:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
8010394f:	83 ec 0c             	sub    $0xc,%esp
80103952:	68 a0 42 11 80       	push   $0x801142a0
80103957:	e8 a7 2f 00 00       	call   80106903 <release>
8010395c:	83 c4 10             	add    $0x10,%esp
      break;
8010395f:	90                   	nop
    }
  }
}
80103960:	90                   	nop
80103961:	c9                   	leave  
80103962:	c3                   	ret    

80103963 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103963:	55                   	push   %ebp
80103964:	89 e5                	mov    %esp,%ebp
80103966:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	68 a0 42 11 80       	push   $0x801142a0
80103978:	e8 1f 2f 00 00       	call   8010689c <acquire>
8010397d:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103980:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103985:	83 e8 01             	sub    $0x1,%eax
80103988:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
8010398d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	74 0d                	je     801039a3 <end_op+0x40>
    panic("log.committing");
80103996:	83 ec 0c             	sub    $0xc,%esp
80103999:	68 98 a3 10 80       	push   $0x8010a398
8010399e:	e8 c3 cb ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801039a3:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801039a8:	85 c0                	test   %eax,%eax
801039aa:	75 13                	jne    801039bf <end_op+0x5c>
    do_commit = 1;
801039ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801039b3:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
801039ba:	00 00 00 
801039bd:	eb 10                	jmp    801039cf <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801039bf:	83 ec 0c             	sub    $0xc,%esp
801039c2:	68 a0 42 11 80       	push   $0x801142a0
801039c7:	e8 47 20 00 00       	call   80105a13 <wakeup>
801039cc:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801039cf:	83 ec 0c             	sub    $0xc,%esp
801039d2:	68 a0 42 11 80       	push   $0x801142a0
801039d7:	e8 27 2f 00 00       	call   80106903 <release>
801039dc:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801039df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801039e3:	74 3f                	je     80103a24 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801039e5:	e8 f5 00 00 00       	call   80103adf <commit>
    acquire(&log.lock);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	68 a0 42 11 80       	push   $0x801142a0
801039f2:	e8 a5 2e 00 00       	call   8010689c <acquire>
801039f7:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801039fa:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
80103a01:	00 00 00 
    wakeup(&log);
80103a04:	83 ec 0c             	sub    $0xc,%esp
80103a07:	68 a0 42 11 80       	push   $0x801142a0
80103a0c:	e8 02 20 00 00       	call   80105a13 <wakeup>
80103a11:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103a14:	83 ec 0c             	sub    $0xc,%esp
80103a17:	68 a0 42 11 80       	push   $0x801142a0
80103a1c:	e8 e2 2e 00 00       	call   80106903 <release>
80103a21:	83 c4 10             	add    $0x10,%esp
  }
}
80103a24:	90                   	nop
80103a25:	c9                   	leave  
80103a26:	c3                   	ret    

80103a27 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103a27:	55                   	push   %ebp
80103a28:	89 e5                	mov    %esp,%ebp
80103a2a:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a34:	e9 95 00 00 00       	jmp    80103ace <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103a39:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
80103a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a42:	01 d0                	add    %edx,%eax
80103a44:	83 c0 01             	add    $0x1,%eax
80103a47:	89 c2                	mov    %eax,%edx
80103a49:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a4e:	83 ec 08             	sub    $0x8,%esp
80103a51:	52                   	push   %edx
80103a52:	50                   	push   %eax
80103a53:	e8 5e c7 ff ff       	call   801001b6 <bread>
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a61:	83 c0 10             	add    $0x10,%eax
80103a64:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103a6b:	89 c2                	mov    %eax,%edx
80103a6d:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a72:	83 ec 08             	sub    $0x8,%esp
80103a75:	52                   	push   %edx
80103a76:	50                   	push   %eax
80103a77:	e8 3a c7 ff ff       	call   801001b6 <bread>
80103a7c:	83 c4 10             	add    $0x10,%esp
80103a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a85:	8d 50 18             	lea    0x18(%eax),%edx
80103a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a8b:	83 c0 18             	add    $0x18,%eax
80103a8e:	83 ec 04             	sub    $0x4,%esp
80103a91:	68 00 02 00 00       	push   $0x200
80103a96:	52                   	push   %edx
80103a97:	50                   	push   %eax
80103a98:	e8 21 31 00 00       	call   80106bbe <memmove>
80103a9d:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	ff 75 f0             	pushl  -0x10(%ebp)
80103aa6:	e8 44 c7 ff ff       	call   801001ef <bwrite>
80103aab:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103aae:	83 ec 0c             	sub    $0xc,%esp
80103ab1:	ff 75 ec             	pushl  -0x14(%ebp)
80103ab4:	e8 75 c7 ff ff       	call   8010022e <brelse>
80103ab9:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103abc:	83 ec 0c             	sub    $0xc,%esp
80103abf:	ff 75 f0             	pushl  -0x10(%ebp)
80103ac2:	e8 67 c7 ff ff       	call   8010022e <brelse>
80103ac7:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103aca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ace:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103ad3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ad6:	0f 8f 5d ff ff ff    	jg     80103a39 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103adc:	90                   	nop
80103add:	c9                   	leave  
80103ade:	c3                   	ret    

80103adf <commit>:

static void
commit()
{
80103adf:	55                   	push   %ebp
80103ae0:	89 e5                	mov    %esp,%ebp
80103ae2:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103ae5:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aea:	85 c0                	test   %eax,%eax
80103aec:	7e 1e                	jle    80103b0c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103aee:	e8 34 ff ff ff       	call   80103a27 <write_log>
    write_head();    // Write header to disk -- the real commit
80103af3:	e8 3a fd ff ff       	call   80103832 <write_head>
    install_trans(); // Now install writes to home locations
80103af8:	e8 09 fc ff ff       	call   80103706 <install_trans>
    log.lh.n = 0; 
80103afd:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103b04:	00 00 00 
    write_head();    // Erase the transaction from the log
80103b07:	e8 26 fd ff ff       	call   80103832 <write_head>
  }
}
80103b0c:	90                   	nop
80103b0d:	c9                   	leave  
80103b0e:	c3                   	ret    

80103b0f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103b0f:	55                   	push   %ebp
80103b10:	89 e5                	mov    %esp,%ebp
80103b12:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103b15:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b1a:	83 f8 1d             	cmp    $0x1d,%eax
80103b1d:	7f 12                	jg     80103b31 <log_write+0x22>
80103b1f:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b24:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103b2a:	83 ea 01             	sub    $0x1,%edx
80103b2d:	39 d0                	cmp    %edx,%eax
80103b2f:	7c 0d                	jl     80103b3e <log_write+0x2f>
    panic("too big a transaction");
80103b31:	83 ec 0c             	sub    $0xc,%esp
80103b34:	68 a7 a3 10 80       	push   $0x8010a3a7
80103b39:	e8 28 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103b3e:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b43:	85 c0                	test   %eax,%eax
80103b45:	7f 0d                	jg     80103b54 <log_write+0x45>
    panic("log_write outside of trans");
80103b47:	83 ec 0c             	sub    $0xc,%esp
80103b4a:	68 bd a3 10 80       	push   $0x8010a3bd
80103b4f:	e8 12 ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103b54:	83 ec 0c             	sub    $0xc,%esp
80103b57:	68 a0 42 11 80       	push   $0x801142a0
80103b5c:	e8 3b 2d 00 00       	call   8010689c <acquire>
80103b61:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b6b:	eb 1d                	jmp    80103b8a <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b70:	83 c0 10             	add    $0x10,%eax
80103b73:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103b7a:	89 c2                	mov    %eax,%edx
80103b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b7f:	8b 40 08             	mov    0x8(%eax),%eax
80103b82:	39 c2                	cmp    %eax,%edx
80103b84:	74 10                	je     80103b96 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b86:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b8a:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b92:	7f d9                	jg     80103b6d <log_write+0x5e>
80103b94:	eb 01                	jmp    80103b97 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103b96:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103b97:	8b 45 08             	mov    0x8(%ebp),%eax
80103b9a:	8b 40 08             	mov    0x8(%eax),%eax
80103b9d:	89 c2                	mov    %eax,%edx
80103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba2:	83 c0 10             	add    $0x10,%eax
80103ba5:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103bac:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103bb1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103bb4:	75 0d                	jne    80103bc3 <log_write+0xb4>
    log.lh.n++;
80103bb6:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103bbb:	83 c0 01             	add    $0x1,%eax
80103bbe:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc6:	8b 00                	mov    (%eax),%eax
80103bc8:	83 c8 04             	or     $0x4,%eax
80103bcb:	89 c2                	mov    %eax,%edx
80103bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103bd0:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103bd2:	83 ec 0c             	sub    $0xc,%esp
80103bd5:	68 a0 42 11 80       	push   $0x801142a0
80103bda:	e8 24 2d 00 00       	call   80106903 <release>
80103bdf:	83 c4 10             	add    $0x10,%esp
}
80103be2:	90                   	nop
80103be3:	c9                   	leave  
80103be4:	c3                   	ret    

80103be5 <v2p>:
80103be5:	55                   	push   %ebp
80103be6:	89 e5                	mov    %esp,%ebp
80103be8:	8b 45 08             	mov    0x8(%ebp),%eax
80103beb:	05 00 00 00 80       	add    $0x80000000,%eax
80103bf0:	5d                   	pop    %ebp
80103bf1:	c3                   	ret    

80103bf2 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103bf2:	55                   	push   %ebp
80103bf3:	89 e5                	mov    %esp,%ebp
80103bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf8:	05 00 00 00 80       	add    $0x80000000,%eax
80103bfd:	5d                   	pop    %ebp
80103bfe:	c3                   	ret    

80103bff <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103bff:	55                   	push   %ebp
80103c00:	89 e5                	mov    %esp,%ebp
80103c02:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103c05:	8b 55 08             	mov    0x8(%ebp),%edx
80103c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103c0e:	f0 87 02             	lock xchg %eax,(%edx)
80103c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103c17:	c9                   	leave  
80103c18:	c3                   	ret    

80103c19 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103c19:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103c1d:	83 e4 f0             	and    $0xfffffff0,%esp
80103c20:	ff 71 fc             	pushl  -0x4(%ecx)
80103c23:	55                   	push   %ebp
80103c24:	89 e5                	mov    %esp,%ebp
80103c26:	51                   	push   %ecx
80103c27:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103c2a:	83 ec 08             	sub    $0x8,%esp
80103c2d:	68 00 00 40 80       	push   $0x80400000
80103c32:	68 7c 79 11 80       	push   $0x8011797c
80103c37:	e8 7d f2 ff ff       	call   80102eb9 <kinit1>
80103c3c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103c3f:	e8 62 5d 00 00       	call   801099a6 <kvmalloc>
  mpinit();        // collect info about this machine
80103c44:	e8 43 04 00 00       	call   8010408c <mpinit>
  lapicinit();
80103c49:	e8 ea f5 ff ff       	call   80103238 <lapicinit>
  seginit();       // set up segments
80103c4e:	e8 fc 56 00 00       	call   8010934f <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103c53:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c59:	0f b6 00             	movzbl (%eax),%eax
80103c5c:	0f b6 c0             	movzbl %al,%eax
80103c5f:	83 ec 08             	sub    $0x8,%esp
80103c62:	50                   	push   %eax
80103c63:	68 d8 a3 10 80       	push   $0x8010a3d8
80103c68:	e8 59 c7 ff ff       	call   801003c6 <cprintf>
80103c6d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103c70:	e8 6d 06 00 00       	call   801042e2 <picinit>
  ioapicinit();    // another interrupt controller
80103c75:	e8 34 f1 ff ff       	call   80102dae <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103c7a:	e8 38 cf ff ff       	call   80100bb7 <consoleinit>
  uartinit();      // serial port
80103c7f:	e8 27 4a 00 00       	call   801086ab <uartinit>
  pinit();         // process table
80103c84:	e8 5d 0b 00 00       	call   801047e6 <pinit>
  tvinit();        // trap vectors
80103c89:	e8 f6 45 00 00       	call   80108284 <tvinit>
  binit();         // buffer cache
80103c8e:	e8 a1 c3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c93:	e8 f0 d3 ff ff       	call   80101088 <fileinit>
  ideinit();       // disk
80103c98:	e8 19 ed ff ff       	call   801029b6 <ideinit>
  if(!ismp)
80103c9d:	a1 84 43 11 80       	mov    0x80114384,%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 05                	jne    80103cab <main+0x92>
    timerinit();   // uniprocessor timer
80103ca6:	e8 2a 45 00 00       	call   801081d5 <timerinit>
  startothers();   // start other processors
80103cab:	e8 7f 00 00 00       	call   80103d2f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103cb0:	83 ec 08             	sub    $0x8,%esp
80103cb3:	68 00 00 00 8e       	push   $0x8e000000
80103cb8:	68 00 00 40 80       	push   $0x80400000
80103cbd:	e8 30 f2 ff ff       	call   80102ef2 <kinit2>
80103cc2:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103cc5:	e8 2d 0d 00 00       	call   801049f7 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103cca:	e8 1a 00 00 00       	call   80103ce9 <mpmain>

80103ccf <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103ccf:	55                   	push   %ebp
80103cd0:	89 e5                	mov    %esp,%ebp
80103cd2:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103cd5:	e8 e4 5c 00 00       	call   801099be <switchkvm>
  seginit();
80103cda:	e8 70 56 00 00       	call   8010934f <seginit>
  lapicinit();
80103cdf:	e8 54 f5 ff ff       	call   80103238 <lapicinit>
  mpmain();
80103ce4:	e8 00 00 00 00       	call   80103ce9 <mpmain>

80103ce9 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103ce9:	55                   	push   %ebp
80103cea:	89 e5                	mov    %esp,%ebp
80103cec:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103cef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cf5:	0f b6 00             	movzbl (%eax),%eax
80103cf8:	0f b6 c0             	movzbl %al,%eax
80103cfb:	83 ec 08             	sub    $0x8,%esp
80103cfe:	50                   	push   %eax
80103cff:	68 ef a3 10 80       	push   $0x8010a3ef
80103d04:	e8 bd c6 ff ff       	call   801003c6 <cprintf>
80103d09:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103d0c:	e8 d4 46 00 00       	call   801083e5 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103d11:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103d17:	05 a8 00 00 00       	add    $0xa8,%eax
80103d1c:	83 ec 08             	sub    $0x8,%esp
80103d1f:	6a 01                	push   $0x1
80103d21:	50                   	push   %eax
80103d22:	e8 d8 fe ff ff       	call   80103bff <xchg>
80103d27:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103d2a:	e8 68 16 00 00       	call   80105397 <scheduler>

80103d2f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103d2f:	55                   	push   %ebp
80103d30:	89 e5                	mov    %esp,%ebp
80103d32:	53                   	push   %ebx
80103d33:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103d36:	68 00 70 00 00       	push   $0x7000
80103d3b:	e8 b2 fe ff ff       	call   80103bf2 <p2v>
80103d40:	83 c4 04             	add    $0x4,%esp
80103d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103d46:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103d4b:	83 ec 04             	sub    $0x4,%esp
80103d4e:	50                   	push   %eax
80103d4f:	68 4c d5 10 80       	push   $0x8010d54c
80103d54:	ff 75 f0             	pushl  -0x10(%ebp)
80103d57:	e8 62 2e 00 00       	call   80106bbe <memmove>
80103d5c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103d5f:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103d66:	e9 90 00 00 00       	jmp    80103dfb <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103d6b:	e8 e6 f5 ff ff       	call   80103356 <cpunum>
80103d70:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d76:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103d7b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d7e:	74 73                	je     80103df3 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103d80:	e8 6b f2 ff ff       	call   80102ff0 <kalloc>
80103d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d8b:	83 e8 04             	sub    $0x4,%eax
80103d8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103d91:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103d97:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9c:	83 e8 08             	sub    $0x8,%eax
80103d9f:	c7 00 cf 3c 10 80    	movl   $0x80103ccf,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103da8:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103dab:	83 ec 0c             	sub    $0xc,%esp
80103dae:	68 00 c0 10 80       	push   $0x8010c000
80103db3:	e8 2d fe ff ff       	call   80103be5 <v2p>
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103dbd:	83 ec 0c             	sub    $0xc,%esp
80103dc0:	ff 75 f0             	pushl  -0x10(%ebp)
80103dc3:	e8 1d fe ff ff       	call   80103be5 <v2p>
80103dc8:	83 c4 10             	add    $0x10,%esp
80103dcb:	89 c2                	mov    %eax,%edx
80103dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd0:	0f b6 00             	movzbl (%eax),%eax
80103dd3:	0f b6 c0             	movzbl %al,%eax
80103dd6:	83 ec 08             	sub    $0x8,%esp
80103dd9:	52                   	push   %edx
80103dda:	50                   	push   %eax
80103ddb:	e8 f0 f5 ff ff       	call   801033d0 <lapicstartap>
80103de0:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103de3:	90                   	nop
80103de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ded:	85 c0                	test   %eax,%eax
80103def:	74 f3                	je     80103de4 <startothers+0xb5>
80103df1:	eb 01                	jmp    80103df4 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103df3:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103df4:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103dfb:	a1 80 49 11 80       	mov    0x80114980,%eax
80103e00:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e06:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103e0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103e0e:	0f 87 57 ff ff ff    	ja     80103d6b <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103e14:	90                   	nop
80103e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    

80103e1a <p2v>:
80103e1a:	55                   	push   %ebp
80103e1b:	89 e5                	mov    %esp,%ebp
80103e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e20:	05 00 00 00 80       	add    $0x80000000,%eax
80103e25:	5d                   	pop    %ebp
80103e26:	c3                   	ret    

80103e27 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103e27:	55                   	push   %ebp
80103e28:	89 e5                	mov    %esp,%ebp
80103e2a:	83 ec 14             	sub    $0x14,%esp
80103e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e30:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e34:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103e38:	89 c2                	mov    %eax,%edx
80103e3a:	ec                   	in     (%dx),%al
80103e3b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103e3e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103e42:	c9                   	leave  
80103e43:	c3                   	ret    

80103e44 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	83 ec 08             	sub    $0x8,%esp
80103e4a:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e50:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e54:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e57:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e5b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e5f:	ee                   	out    %al,(%dx)
}
80103e60:	90                   	nop
80103e61:	c9                   	leave  
80103e62:	c3                   	ret    

80103e63 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103e63:	55                   	push   %ebp
80103e64:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103e66:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103e6b:	89 c2                	mov    %eax,%edx
80103e6d:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103e72:	29 c2                	sub    %eax,%edx
80103e74:	89 d0                	mov    %edx,%eax
80103e76:	c1 f8 02             	sar    $0x2,%eax
80103e79:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103e7f:	5d                   	pop    %ebp
80103e80:	c3                   	ret    

80103e81 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103e81:	55                   	push   %ebp
80103e82:	89 e5                	mov    %esp,%ebp
80103e84:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103e87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103e8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103e95:	eb 15                	jmp    80103eac <sum+0x2b>
    sum += addr[i];
80103e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9d:	01 d0                	add    %edx,%eax
80103e9f:	0f b6 00             	movzbl (%eax),%eax
80103ea2:	0f b6 c0             	movzbl %al,%eax
80103ea5:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103ea8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103eaf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103eb2:	7c e3                	jl     80103e97 <sum+0x16>
    sum += addr[i];
  return sum;
80103eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103eb7:	c9                   	leave  
80103eb8:	c3                   	ret    

80103eb9 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103eb9:	55                   	push   %ebp
80103eba:	89 e5                	mov    %esp,%ebp
80103ebc:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103ebf:	ff 75 08             	pushl  0x8(%ebp)
80103ec2:	e8 53 ff ff ff       	call   80103e1a <p2v>
80103ec7:	83 c4 04             	add    $0x4,%esp
80103eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ed3:	01 d0                	add    %edx,%eax
80103ed5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ede:	eb 36                	jmp    80103f16 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ee0:	83 ec 04             	sub    $0x4,%esp
80103ee3:	6a 04                	push   $0x4
80103ee5:	68 00 a4 10 80       	push   $0x8010a400
80103eea:	ff 75 f4             	pushl  -0xc(%ebp)
80103eed:	e8 74 2c 00 00       	call   80106b66 <memcmp>
80103ef2:	83 c4 10             	add    $0x10,%esp
80103ef5:	85 c0                	test   %eax,%eax
80103ef7:	75 19                	jne    80103f12 <mpsearch1+0x59>
80103ef9:	83 ec 08             	sub    $0x8,%esp
80103efc:	6a 10                	push   $0x10
80103efe:	ff 75 f4             	pushl  -0xc(%ebp)
80103f01:	e8 7b ff ff ff       	call   80103e81 <sum>
80103f06:	83 c4 10             	add    $0x10,%esp
80103f09:	84 c0                	test   %al,%al
80103f0b:	75 05                	jne    80103f12 <mpsearch1+0x59>
      return (struct mp*)p;
80103f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f10:	eb 11                	jmp    80103f23 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103f12:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f19:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f1c:	72 c2                	jb     80103ee0 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103f1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f23:	c9                   	leave  
80103f24:	c3                   	ret    

80103f25 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103f25:	55                   	push   %ebp
80103f26:	89 e5                	mov    %esp,%ebp
80103f28:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103f2b:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f35:	83 c0 0f             	add    $0xf,%eax
80103f38:	0f b6 00             	movzbl (%eax),%eax
80103f3b:	0f b6 c0             	movzbl %al,%eax
80103f3e:	c1 e0 08             	shl    $0x8,%eax
80103f41:	89 c2                	mov    %eax,%edx
80103f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f46:	83 c0 0e             	add    $0xe,%eax
80103f49:	0f b6 00             	movzbl (%eax),%eax
80103f4c:	0f b6 c0             	movzbl %al,%eax
80103f4f:	09 d0                	or     %edx,%eax
80103f51:	c1 e0 04             	shl    $0x4,%eax
80103f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f5b:	74 21                	je     80103f7e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103f5d:	83 ec 08             	sub    $0x8,%esp
80103f60:	68 00 04 00 00       	push   $0x400
80103f65:	ff 75 f0             	pushl  -0x10(%ebp)
80103f68:	e8 4c ff ff ff       	call   80103eb9 <mpsearch1>
80103f6d:	83 c4 10             	add    $0x10,%esp
80103f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f77:	74 51                	je     80103fca <mpsearch+0xa5>
      return mp;
80103f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f7c:	eb 61                	jmp    80103fdf <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f81:	83 c0 14             	add    $0x14,%eax
80103f84:	0f b6 00             	movzbl (%eax),%eax
80103f87:	0f b6 c0             	movzbl %al,%eax
80103f8a:	c1 e0 08             	shl    $0x8,%eax
80103f8d:	89 c2                	mov    %eax,%edx
80103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f92:	83 c0 13             	add    $0x13,%eax
80103f95:	0f b6 00             	movzbl (%eax),%eax
80103f98:	0f b6 c0             	movzbl %al,%eax
80103f9b:	09 d0                	or     %edx,%eax
80103f9d:	c1 e0 0a             	shl    $0xa,%eax
80103fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fa6:	2d 00 04 00 00       	sub    $0x400,%eax
80103fab:	83 ec 08             	sub    $0x8,%esp
80103fae:	68 00 04 00 00       	push   $0x400
80103fb3:	50                   	push   %eax
80103fb4:	e8 00 ff ff ff       	call   80103eb9 <mpsearch1>
80103fb9:	83 c4 10             	add    $0x10,%esp
80103fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103fbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103fc3:	74 05                	je     80103fca <mpsearch+0xa5>
      return mp;
80103fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fc8:	eb 15                	jmp    80103fdf <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103fca:	83 ec 08             	sub    $0x8,%esp
80103fcd:	68 00 00 01 00       	push   $0x10000
80103fd2:	68 00 00 0f 00       	push   $0xf0000
80103fd7:	e8 dd fe ff ff       	call   80103eb9 <mpsearch1>
80103fdc:	83 c4 10             	add    $0x10,%esp
}
80103fdf:	c9                   	leave  
80103fe0:	c3                   	ret    

80103fe1 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103fe1:	55                   	push   %ebp
80103fe2:	89 e5                	mov    %esp,%ebp
80103fe4:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103fe7:	e8 39 ff ff ff       	call   80103f25 <mpsearch>
80103fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ff3:	74 0a                	je     80103fff <mpconfig+0x1e>
80103ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff8:	8b 40 04             	mov    0x4(%eax),%eax
80103ffb:	85 c0                	test   %eax,%eax
80103ffd:	75 0a                	jne    80104009 <mpconfig+0x28>
    return 0;
80103fff:	b8 00 00 00 00       	mov    $0x0,%eax
80104004:	e9 81 00 00 00       	jmp    8010408a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80104009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010400c:	8b 40 04             	mov    0x4(%eax),%eax
8010400f:	83 ec 0c             	sub    $0xc,%esp
80104012:	50                   	push   %eax
80104013:	e8 02 fe ff ff       	call   80103e1a <p2v>
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010401e:	83 ec 04             	sub    $0x4,%esp
80104021:	6a 04                	push   $0x4
80104023:	68 05 a4 10 80       	push   $0x8010a405
80104028:	ff 75 f0             	pushl  -0x10(%ebp)
8010402b:	e8 36 2b 00 00       	call   80106b66 <memcmp>
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	85 c0                	test   %eax,%eax
80104035:	74 07                	je     8010403e <mpconfig+0x5d>
    return 0;
80104037:	b8 00 00 00 00       	mov    $0x0,%eax
8010403c:	eb 4c                	jmp    8010408a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
8010403e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104041:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104045:	3c 01                	cmp    $0x1,%al
80104047:	74 12                	je     8010405b <mpconfig+0x7a>
80104049:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010404c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104050:	3c 04                	cmp    $0x4,%al
80104052:	74 07                	je     8010405b <mpconfig+0x7a>
    return 0;
80104054:	b8 00 00 00 00       	mov    $0x0,%eax
80104059:	eb 2f                	jmp    8010408a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
8010405b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010405e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104062:	0f b7 c0             	movzwl %ax,%eax
80104065:	83 ec 08             	sub    $0x8,%esp
80104068:	50                   	push   %eax
80104069:	ff 75 f0             	pushl  -0x10(%ebp)
8010406c:	e8 10 fe ff ff       	call   80103e81 <sum>
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	84 c0                	test   %al,%al
80104076:	74 07                	je     8010407f <mpconfig+0x9e>
    return 0;
80104078:	b8 00 00 00 00       	mov    $0x0,%eax
8010407d:	eb 0b                	jmp    8010408a <mpconfig+0xa9>
  *pmp = mp;
8010407f:	8b 45 08             	mov    0x8(%ebp),%eax
80104082:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104085:	89 10                	mov    %edx,(%eax)
  return conf;
80104087:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010408a:	c9                   	leave  
8010408b:	c3                   	ret    

8010408c <mpinit>:

void
mpinit(void)
{
8010408c:	55                   	push   %ebp
8010408d:	89 e5                	mov    %esp,%ebp
8010408f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104092:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104099:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801040a2:	50                   	push   %eax
801040a3:	e8 39 ff ff ff       	call   80103fe1 <mpconfig>
801040a8:	83 c4 10             	add    $0x10,%esp
801040ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801040ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801040b2:	0f 84 96 01 00 00    	je     8010424e <mpinit+0x1c2>
    return;
  ismp = 1;
801040b8:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
801040bf:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801040c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040c5:	8b 40 24             	mov    0x24(%eax),%eax
801040c8:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801040cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040d0:	83 c0 2c             	add    $0x2c,%eax
801040d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040d9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801040dd:	0f b7 d0             	movzwl %ax,%edx
801040e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040e3:	01 d0                	add    %edx,%eax
801040e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801040e8:	e9 f2 00 00 00       	jmp    801041df <mpinit+0x153>
    switch(*p){
801040ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f0:	0f b6 00             	movzbl (%eax),%eax
801040f3:	0f b6 c0             	movzbl %al,%eax
801040f6:	83 f8 04             	cmp    $0x4,%eax
801040f9:	0f 87 bc 00 00 00    	ja     801041bb <mpinit+0x12f>
801040ff:	8b 04 85 48 a4 10 80 	mov    -0x7fef5bb8(,%eax,4),%eax
80104106:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80104108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010410e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104111:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104115:	0f b6 d0             	movzbl %al,%edx
80104118:	a1 80 49 11 80       	mov    0x80114980,%eax
8010411d:	39 c2                	cmp    %eax,%edx
8010411f:	74 2b                	je     8010414c <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80104121:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104124:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104128:	0f b6 d0             	movzbl %al,%edx
8010412b:	a1 80 49 11 80       	mov    0x80114980,%eax
80104130:	83 ec 04             	sub    $0x4,%esp
80104133:	52                   	push   %edx
80104134:	50                   	push   %eax
80104135:	68 0a a4 10 80       	push   $0x8010a40a
8010413a:	e8 87 c2 ff ff       	call   801003c6 <cprintf>
8010413f:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80104142:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104149:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010414c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010414f:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80104153:	0f b6 c0             	movzbl %al,%eax
80104156:	83 e0 02             	and    $0x2,%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	74 15                	je     80104172 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
8010415d:	a1 80 49 11 80       	mov    0x80114980,%eax
80104162:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104168:	05 a0 43 11 80       	add    $0x801143a0,%eax
8010416d:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
80104172:	a1 80 49 11 80       	mov    0x80114980,%eax
80104177:	8b 15 80 49 11 80    	mov    0x80114980,%edx
8010417d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104183:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104188:	88 10                	mov    %dl,(%eax)
      ncpu++;
8010418a:	a1 80 49 11 80       	mov    0x80114980,%eax
8010418f:	83 c0 01             	add    $0x1,%eax
80104192:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
80104197:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010419b:	eb 42                	jmp    801041df <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010419d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801041a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801041a6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801041aa:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
801041af:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801041b3:	eb 2a                	jmp    801041df <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801041b5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801041b9:	eb 24                	jmp    801041df <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041be:	0f b6 00             	movzbl (%eax),%eax
801041c1:	0f b6 c0             	movzbl %al,%eax
801041c4:	83 ec 08             	sub    $0x8,%esp
801041c7:	50                   	push   %eax
801041c8:	68 28 a4 10 80       	push   $0x8010a428
801041cd:	e8 f4 c1 ff ff       	call   801003c6 <cprintf>
801041d2:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
801041d5:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
801041dc:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801041e5:	0f 82 02 ff ff ff    	jb     801040ed <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801041eb:	a1 84 43 11 80       	mov    0x80114384,%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	75 1d                	jne    80104211 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801041f4:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
801041fb:	00 00 00 
    lapic = 0;
801041fe:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
80104205:	00 00 00 
    ioapicid = 0;
80104208:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
8010420f:	eb 3e                	jmp    8010424f <mpinit+0x1c3>
  }

  if(mp->imcrp){
80104211:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104214:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104218:	84 c0                	test   %al,%al
8010421a:	74 33                	je     8010424f <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010421c:	83 ec 08             	sub    $0x8,%esp
8010421f:	6a 70                	push   $0x70
80104221:	6a 22                	push   $0x22
80104223:	e8 1c fc ff ff       	call   80103e44 <outb>
80104228:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	6a 23                	push   $0x23
80104230:	e8 f2 fb ff ff       	call   80103e27 <inb>
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	83 c8 01             	or     $0x1,%eax
8010423b:	0f b6 c0             	movzbl %al,%eax
8010423e:	83 ec 08             	sub    $0x8,%esp
80104241:	50                   	push   %eax
80104242:	6a 23                	push   $0x23
80104244:	e8 fb fb ff ff       	call   80103e44 <outb>
80104249:	83 c4 10             	add    $0x10,%esp
8010424c:	eb 01                	jmp    8010424f <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
8010424e:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010424f:	c9                   	leave  
80104250:	c3                   	ret    

80104251 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104251:	55                   	push   %ebp
80104252:	89 e5                	mov    %esp,%ebp
80104254:	83 ec 08             	sub    $0x8,%esp
80104257:	8b 55 08             	mov    0x8(%ebp),%edx
8010425a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010425d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104261:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104264:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104268:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010426c:	ee                   	out    %al,(%dx)
}
8010426d:	90                   	nop
8010426e:	c9                   	leave  
8010426f:	c3                   	ret    

80104270 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	83 ec 04             	sub    $0x4,%esp
80104276:	8b 45 08             	mov    0x8(%ebp),%eax
80104279:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010427d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104281:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104287:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010428b:	0f b6 c0             	movzbl %al,%eax
8010428e:	50                   	push   %eax
8010428f:	6a 21                	push   $0x21
80104291:	e8 bb ff ff ff       	call   80104251 <outb>
80104296:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104299:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010429d:	66 c1 e8 08          	shr    $0x8,%ax
801042a1:	0f b6 c0             	movzbl %al,%eax
801042a4:	50                   	push   %eax
801042a5:	68 a1 00 00 00       	push   $0xa1
801042aa:	e8 a2 ff ff ff       	call   80104251 <outb>
801042af:	83 c4 08             	add    $0x8,%esp
}
801042b2:	90                   	nop
801042b3:	c9                   	leave  
801042b4:	c3                   	ret    

801042b5 <picenable>:

void
picenable(int irq)
{
801042b5:	55                   	push   %ebp
801042b6:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
801042b8:	8b 45 08             	mov    0x8(%ebp),%eax
801042bb:	ba 01 00 00 00       	mov    $0x1,%edx
801042c0:	89 c1                	mov    %eax,%ecx
801042c2:	d3 e2                	shl    %cl,%edx
801042c4:	89 d0                	mov    %edx,%eax
801042c6:	f7 d0                	not    %eax
801042c8:	89 c2                	mov    %eax,%edx
801042ca:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801042d1:	21 d0                	and    %edx,%eax
801042d3:	0f b7 c0             	movzwl %ax,%eax
801042d6:	50                   	push   %eax
801042d7:	e8 94 ff ff ff       	call   80104270 <picsetmask>
801042dc:	83 c4 04             	add    $0x4,%esp
}
801042df:	90                   	nop
801042e0:	c9                   	leave  
801042e1:	c3                   	ret    

801042e2 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801042e2:	55                   	push   %ebp
801042e3:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801042e5:	68 ff 00 00 00       	push   $0xff
801042ea:	6a 21                	push   $0x21
801042ec:	e8 60 ff ff ff       	call   80104251 <outb>
801042f1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801042f4:	68 ff 00 00 00       	push   $0xff
801042f9:	68 a1 00 00 00       	push   $0xa1
801042fe:	e8 4e ff ff ff       	call   80104251 <outb>
80104303:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104306:	6a 11                	push   $0x11
80104308:	6a 20                	push   $0x20
8010430a:	e8 42 ff ff ff       	call   80104251 <outb>
8010430f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104312:	6a 20                	push   $0x20
80104314:	6a 21                	push   $0x21
80104316:	e8 36 ff ff ff       	call   80104251 <outb>
8010431b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010431e:	6a 04                	push   $0x4
80104320:	6a 21                	push   $0x21
80104322:	e8 2a ff ff ff       	call   80104251 <outb>
80104327:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010432a:	6a 03                	push   $0x3
8010432c:	6a 21                	push   $0x21
8010432e:	e8 1e ff ff ff       	call   80104251 <outb>
80104333:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104336:	6a 11                	push   $0x11
80104338:	68 a0 00 00 00       	push   $0xa0
8010433d:	e8 0f ff ff ff       	call   80104251 <outb>
80104342:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104345:	6a 28                	push   $0x28
80104347:	68 a1 00 00 00       	push   $0xa1
8010434c:	e8 00 ff ff ff       	call   80104251 <outb>
80104351:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104354:	6a 02                	push   $0x2
80104356:	68 a1 00 00 00       	push   $0xa1
8010435b:	e8 f1 fe ff ff       	call   80104251 <outb>
80104360:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104363:	6a 03                	push   $0x3
80104365:	68 a1 00 00 00       	push   $0xa1
8010436a:	e8 e2 fe ff ff       	call   80104251 <outb>
8010436f:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104372:	6a 68                	push   $0x68
80104374:	6a 20                	push   $0x20
80104376:	e8 d6 fe ff ff       	call   80104251 <outb>
8010437b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010437e:	6a 0a                	push   $0xa
80104380:	6a 20                	push   $0x20
80104382:	e8 ca fe ff ff       	call   80104251 <outb>
80104387:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010438a:	6a 68                	push   $0x68
8010438c:	68 a0 00 00 00       	push   $0xa0
80104391:	e8 bb fe ff ff       	call   80104251 <outb>
80104396:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104399:	6a 0a                	push   $0xa
8010439b:	68 a0 00 00 00       	push   $0xa0
801043a0:	e8 ac fe ff ff       	call   80104251 <outb>
801043a5:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801043a8:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801043af:	66 83 f8 ff          	cmp    $0xffff,%ax
801043b3:	74 13                	je     801043c8 <picinit+0xe6>
    picsetmask(irqmask);
801043b5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801043bc:	0f b7 c0             	movzwl %ax,%eax
801043bf:	50                   	push   %eax
801043c0:	e8 ab fe ff ff       	call   80104270 <picsetmask>
801043c5:	83 c4 04             	add    $0x4,%esp
}
801043c8:	90                   	nop
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    

801043cb <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801043cb:	55                   	push   %ebp
801043cc:	89 e5                	mov    %esp,%ebp
801043ce:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801043d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801043d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e4:	8b 10                	mov    (%eax),%edx
801043e6:	8b 45 08             	mov    0x8(%ebp),%eax
801043e9:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801043eb:	e8 b6 cc ff ff       	call   801010a6 <filealloc>
801043f0:	89 c2                	mov    %eax,%edx
801043f2:	8b 45 08             	mov    0x8(%ebp),%eax
801043f5:	89 10                	mov    %edx,(%eax)
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	8b 00                	mov    (%eax),%eax
801043fc:	85 c0                	test   %eax,%eax
801043fe:	0f 84 cb 00 00 00    	je     801044cf <pipealloc+0x104>
80104404:	e8 9d cc ff ff       	call   801010a6 <filealloc>
80104409:	89 c2                	mov    %eax,%edx
8010440b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440e:	89 10                	mov    %edx,(%eax)
80104410:	8b 45 0c             	mov    0xc(%ebp),%eax
80104413:	8b 00                	mov    (%eax),%eax
80104415:	85 c0                	test   %eax,%eax
80104417:	0f 84 b2 00 00 00    	je     801044cf <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010441d:	e8 ce eb ff ff       	call   80102ff0 <kalloc>
80104422:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104429:	0f 84 9f 00 00 00    	je     801044ce <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010442f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104432:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104439:	00 00 00 
  p->writeopen = 1;
8010443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104446:	00 00 00 
  p->nwrite = 0;
80104449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104453:	00 00 00 
  p->nread = 0;
80104456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104459:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104460:	00 00 00 
  initlock(&p->lock, "pipe");
80104463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104466:	83 ec 08             	sub    $0x8,%esp
80104469:	68 5c a4 10 80       	push   $0x8010a45c
8010446e:	50                   	push   %eax
8010446f:	e8 06 24 00 00       	call   8010687a <initlock>
80104474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104477:	8b 45 08             	mov    0x8(%ebp),%eax
8010447a:	8b 00                	mov    (%eax),%eax
8010447c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104482:	8b 45 08             	mov    0x8(%ebp),%eax
80104485:	8b 00                	mov    (%eax),%eax
80104487:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010448b:	8b 45 08             	mov    0x8(%ebp),%eax
8010448e:	8b 00                	mov    (%eax),%eax
80104490:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104494:	8b 45 08             	mov    0x8(%ebp),%eax
80104497:	8b 00                	mov    (%eax),%eax
80104499:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010449c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010449f:	8b 45 0c             	mov    0xc(%ebp),%eax
801044a2:	8b 00                	mov    (%eax),%eax
801044a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801044aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ad:	8b 00                	mov    (%eax),%eax
801044af:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801044b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b6:	8b 00                	mov    (%eax),%eax
801044b8:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801044bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801044bf:	8b 00                	mov    (%eax),%eax
801044c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c4:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801044c7:	b8 00 00 00 00       	mov    $0x0,%eax
801044cc:	eb 4e                	jmp    8010451c <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801044ce:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801044cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044d3:	74 0e                	je     801044e3 <pipealloc+0x118>
    kfree((char*)p);
801044d5:	83 ec 0c             	sub    $0xc,%esp
801044d8:	ff 75 f4             	pushl  -0xc(%ebp)
801044db:	e8 73 ea ff ff       	call   80102f53 <kfree>
801044e0:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
801044e6:	8b 00                	mov    (%eax),%eax
801044e8:	85 c0                	test   %eax,%eax
801044ea:	74 11                	je     801044fd <pipealloc+0x132>
    fileclose(*f0);
801044ec:	8b 45 08             	mov    0x8(%ebp),%eax
801044ef:	8b 00                	mov    (%eax),%eax
801044f1:	83 ec 0c             	sub    $0xc,%esp
801044f4:	50                   	push   %eax
801044f5:	e8 6a cc ff ff       	call   80101164 <fileclose>
801044fa:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801044fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104500:	8b 00                	mov    (%eax),%eax
80104502:	85 c0                	test   %eax,%eax
80104504:	74 11                	je     80104517 <pipealloc+0x14c>
    fileclose(*f1);
80104506:	8b 45 0c             	mov    0xc(%ebp),%eax
80104509:	8b 00                	mov    (%eax),%eax
8010450b:	83 ec 0c             	sub    $0xc,%esp
8010450e:	50                   	push   %eax
8010450f:	e8 50 cc ff ff       	call   80101164 <fileclose>
80104514:	83 c4 10             	add    $0x10,%esp
  return -1;
80104517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010451c:	c9                   	leave  
8010451d:	c3                   	ret    

8010451e <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010451e:	55                   	push   %ebp
8010451f:	89 e5                	mov    %esp,%ebp
80104521:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	83 ec 0c             	sub    $0xc,%esp
8010452a:	50                   	push   %eax
8010452b:	e8 6c 23 00 00       	call   8010689c <acquire>
80104530:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104533:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104537:	74 23                	je     8010455c <pipeclose+0x3e>
    p->writeopen = 0;
80104539:	8b 45 08             	mov    0x8(%ebp),%eax
8010453c:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104543:	00 00 00 
    wakeup(&p->nread);
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
80104549:	05 34 02 00 00       	add    $0x234,%eax
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	50                   	push   %eax
80104552:	e8 bc 14 00 00       	call   80105a13 <wakeup>
80104557:	83 c4 10             	add    $0x10,%esp
8010455a:	eb 21                	jmp    8010457d <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010455c:	8b 45 08             	mov    0x8(%ebp),%eax
8010455f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104566:	00 00 00 
    wakeup(&p->nwrite);
80104569:	8b 45 08             	mov    0x8(%ebp),%eax
8010456c:	05 38 02 00 00       	add    $0x238,%eax
80104571:	83 ec 0c             	sub    $0xc,%esp
80104574:	50                   	push   %eax
80104575:	e8 99 14 00 00       	call   80105a13 <wakeup>
8010457a:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010457d:	8b 45 08             	mov    0x8(%ebp),%eax
80104580:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104586:	85 c0                	test   %eax,%eax
80104588:	75 2c                	jne    801045b6 <pipeclose+0x98>
8010458a:	8b 45 08             	mov    0x8(%ebp),%eax
8010458d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104593:	85 c0                	test   %eax,%eax
80104595:	75 1f                	jne    801045b6 <pipeclose+0x98>
    release(&p->lock);
80104597:	8b 45 08             	mov    0x8(%ebp),%eax
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	50                   	push   %eax
8010459e:	e8 60 23 00 00       	call   80106903 <release>
801045a3:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	ff 75 08             	pushl  0x8(%ebp)
801045ac:	e8 a2 e9 ff ff       	call   80102f53 <kfree>
801045b1:	83 c4 10             	add    $0x10,%esp
801045b4:	eb 0f                	jmp    801045c5 <pipeclose+0xa7>
  } else
    release(&p->lock);
801045b6:	8b 45 08             	mov    0x8(%ebp),%eax
801045b9:	83 ec 0c             	sub    $0xc,%esp
801045bc:	50                   	push   %eax
801045bd:	e8 41 23 00 00       	call   80106903 <release>
801045c2:	83 c4 10             	add    $0x10,%esp
}
801045c5:	90                   	nop
801045c6:	c9                   	leave  
801045c7:	c3                   	ret    

801045c8 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801045c8:	55                   	push   %ebp
801045c9:	89 e5                	mov    %esp,%ebp
801045cb:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801045ce:	8b 45 08             	mov    0x8(%ebp),%eax
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	50                   	push   %eax
801045d5:	e8 c2 22 00 00       	call   8010689c <acquire>
801045da:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801045dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045e4:	e9 ad 00 00 00       	jmp    80104696 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801045e9:	8b 45 08             	mov    0x8(%ebp),%eax
801045ec:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801045f2:	85 c0                	test   %eax,%eax
801045f4:	74 0d                	je     80104603 <pipewrite+0x3b>
801045f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045fc:	8b 40 24             	mov    0x24(%eax),%eax
801045ff:	85 c0                	test   %eax,%eax
80104601:	74 19                	je     8010461c <pipewrite+0x54>
        release(&p->lock);
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
80104606:	83 ec 0c             	sub    $0xc,%esp
80104609:	50                   	push   %eax
8010460a:	e8 f4 22 00 00       	call   80106903 <release>
8010460f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104617:	e9 a8 00 00 00       	jmp    801046c4 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010461c:	8b 45 08             	mov    0x8(%ebp),%eax
8010461f:	05 34 02 00 00       	add    $0x234,%eax
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	50                   	push   %eax
80104628:	e8 e6 13 00 00       	call   80105a13 <wakeup>
8010462d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104630:	8b 45 08             	mov    0x8(%ebp),%eax
80104633:	8b 55 08             	mov    0x8(%ebp),%edx
80104636:	81 c2 38 02 00 00    	add    $0x238,%edx
8010463c:	83 ec 08             	sub    $0x8,%esp
8010463f:	50                   	push   %eax
80104640:	52                   	push   %edx
80104641:	e8 dd 11 00 00       	call   80105823 <sleep>
80104646:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104649:	8b 45 08             	mov    0x8(%ebp),%eax
8010464c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104652:	8b 45 08             	mov    0x8(%ebp),%eax
80104655:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010465b:	05 00 02 00 00       	add    $0x200,%eax
80104660:	39 c2                	cmp    %eax,%edx
80104662:	74 85                	je     801045e9 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104664:	8b 45 08             	mov    0x8(%ebp),%eax
80104667:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010466d:	8d 48 01             	lea    0x1(%eax),%ecx
80104670:	8b 55 08             	mov    0x8(%ebp),%edx
80104673:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104679:	25 ff 01 00 00       	and    $0x1ff,%eax
8010467e:	89 c1                	mov    %eax,%ecx
80104680:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104683:	8b 45 0c             	mov    0xc(%ebp),%eax
80104686:	01 d0                	add    %edx,%eax
80104688:	0f b6 10             	movzbl (%eax),%edx
8010468b:	8b 45 08             	mov    0x8(%ebp),%eax
8010468e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104692:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104699:	3b 45 10             	cmp    0x10(%ebp),%eax
8010469c:	7c ab                	jl     80104649 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010469e:	8b 45 08             	mov    0x8(%ebp),%eax
801046a1:	05 34 02 00 00       	add    $0x234,%eax
801046a6:	83 ec 0c             	sub    $0xc,%esp
801046a9:	50                   	push   %eax
801046aa:	e8 64 13 00 00       	call   80105a13 <wakeup>
801046af:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801046b2:	8b 45 08             	mov    0x8(%ebp),%eax
801046b5:	83 ec 0c             	sub    $0xc,%esp
801046b8:	50                   	push   %eax
801046b9:	e8 45 22 00 00       	call   80106903 <release>
801046be:	83 c4 10             	add    $0x10,%esp
  return n;
801046c1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801046c4:	c9                   	leave  
801046c5:	c3                   	ret    

801046c6 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801046c6:	55                   	push   %ebp
801046c7:	89 e5                	mov    %esp,%ebp
801046c9:	53                   	push   %ebx
801046ca:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801046cd:	8b 45 08             	mov    0x8(%ebp),%eax
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	50                   	push   %eax
801046d4:	e8 c3 21 00 00       	call   8010689c <acquire>
801046d9:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046dc:	eb 3f                	jmp    8010471d <piperead+0x57>
    if(proc->killed){
801046de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e4:	8b 40 24             	mov    0x24(%eax),%eax
801046e7:	85 c0                	test   %eax,%eax
801046e9:	74 19                	je     80104704 <piperead+0x3e>
      release(&p->lock);
801046eb:	8b 45 08             	mov    0x8(%ebp),%eax
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	50                   	push   %eax
801046f2:	e8 0c 22 00 00       	call   80106903 <release>
801046f7:	83 c4 10             	add    $0x10,%esp
      return -1;
801046fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ff:	e9 bf 00 00 00       	jmp    801047c3 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104704:	8b 45 08             	mov    0x8(%ebp),%eax
80104707:	8b 55 08             	mov    0x8(%ebp),%edx
8010470a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104710:	83 ec 08             	sub    $0x8,%esp
80104713:	50                   	push   %eax
80104714:	52                   	push   %edx
80104715:	e8 09 11 00 00       	call   80105823 <sleep>
8010471a:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010471d:	8b 45 08             	mov    0x8(%ebp),%eax
80104720:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104726:	8b 45 08             	mov    0x8(%ebp),%eax
80104729:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010472f:	39 c2                	cmp    %eax,%edx
80104731:	75 0d                	jne    80104740 <piperead+0x7a>
80104733:	8b 45 08             	mov    0x8(%ebp),%eax
80104736:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010473c:	85 c0                	test   %eax,%eax
8010473e:	75 9e                	jne    801046de <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104740:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104747:	eb 49                	jmp    80104792 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104749:	8b 45 08             	mov    0x8(%ebp),%eax
8010474c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104752:	8b 45 08             	mov    0x8(%ebp),%eax
80104755:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010475b:	39 c2                	cmp    %eax,%edx
8010475d:	74 3d                	je     8010479c <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010475f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104762:	8b 45 0c             	mov    0xc(%ebp),%eax
80104765:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104768:	8b 45 08             	mov    0x8(%ebp),%eax
8010476b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104771:	8d 48 01             	lea    0x1(%eax),%ecx
80104774:	8b 55 08             	mov    0x8(%ebp),%edx
80104777:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010477d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104782:	89 c2                	mov    %eax,%edx
80104784:	8b 45 08             	mov    0x8(%ebp),%eax
80104787:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010478c:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010478e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104795:	3b 45 10             	cmp    0x10(%ebp),%eax
80104798:	7c af                	jl     80104749 <piperead+0x83>
8010479a:	eb 01                	jmp    8010479d <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010479c:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010479d:	8b 45 08             	mov    0x8(%ebp),%eax
801047a0:	05 38 02 00 00       	add    $0x238,%eax
801047a5:	83 ec 0c             	sub    $0xc,%esp
801047a8:	50                   	push   %eax
801047a9:	e8 65 12 00 00       	call   80105a13 <wakeup>
801047ae:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801047b1:	8b 45 08             	mov    0x8(%ebp),%eax
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	50                   	push   %eax
801047b8:	e8 46 21 00 00       	call   80106903 <release>
801047bd:	83 c4 10             	add    $0x10,%esp
  return i;
801047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801047c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c6:	c9                   	leave  
801047c7:	c3                   	ret    

801047c8 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801047c8:	55                   	push   %ebp
801047c9:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801047cb:	f4                   	hlt    
}
801047cc:	90                   	nop
801047cd:	5d                   	pop    %ebp
801047ce:	c3                   	ret    

801047cf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801047cf:	55                   	push   %ebp
801047d0:	89 e5                	mov    %esp,%ebp
801047d2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047d5:	9c                   	pushf  
801047d6:	58                   	pop    %eax
801047d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801047da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801047dd:	c9                   	leave  
801047de:	c3                   	ret    

801047df <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801047df:	55                   	push   %ebp
801047e0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801047e2:	fb                   	sti    
}
801047e3:	90                   	nop
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    

801047e6 <pinit>:
static void bumpPriority(struct proc * sList);
static int findProcSetPrio(uint pid, struct proc * sList, uint prio);
#endif
void
pinit(void)
{
801047e6:	55                   	push   %ebp
801047e7:	89 e5                	mov    %esp,%ebp
801047e9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801047ec:	83 ec 08             	sub    $0x8,%esp
801047ef:	68 64 a4 10 80       	push   $0x8010a464
801047f4:	68 a0 49 11 80       	push   $0x801149a0
801047f9:	e8 7c 20 00 00       	call   8010687a <initlock>
801047fe:	83 c4 10             	add    $0x10,%esp
}
80104801:	90                   	nop
80104802:	c9                   	leave  
80104803:	c3                   	ret    

80104804 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;
  acquire(&ptable.lock);
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	68 a0 49 11 80       	push   $0x801149a0
80104812:	e8 85 20 00 00       	call   8010689c <acquire>
80104817:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  p = removeFromStateListHead(&ptable.pLists.free);
8010481a:	83 ec 0c             	sub    $0xc,%esp
8010481d:	68 f0 70 11 80       	push   $0x801170f0
80104822:	e8 89 18 00 00       	call   801060b0 <removeFromStateListHead>
80104827:	83 c4 10             	add    $0x10,%esp
8010482a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p)
8010482d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104831:	74 70                	je     801048a3 <allocproc+0x9f>
  {
      assertState(p, UNUSED);
80104833:	83 ec 08             	sub    $0x8,%esp
80104836:	6a 00                	push   $0x0
80104838:	ff 75 f4             	pushl  -0xc(%ebp)
8010483b:	e8 54 19 00 00       	call   80106194 <assertState>
80104840:	83 c4 10             	add    $0x10,%esp
      goto found;
80104843:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
#ifdef CS333_P1
  p->start_ticks = ticks;
80104844:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010484a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484d:	89 50 7c             	mov    %edx,0x7c(%eax)
#endif
#ifdef CS333_P2  
  p->cpu_ticks_total = 0;
80104850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104853:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010485a:	00 00 00 
  p->cpu_ticks_in = 0;
8010485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104860:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104867:	00 00 00 
#endif
  p->state = EMBRYO; 
8010486a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486d:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104874:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104879:	8d 50 01             	lea    0x1(%eax),%edx
8010487c:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104882:	89 c2                	mov    %eax,%edx
80104884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104887:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P3P4
  if(addToStateListHead(&ptable.pLists.embryo, p) == 0)
8010488a:	83 ec 08             	sub    $0x8,%esp
8010488d:	ff 75 f4             	pushl  -0xc(%ebp)
80104890:	68 00 71 11 80       	push   $0x80117100
80104895:	e8 84 19 00 00       	call   8010621e <addToStateListHead>
8010489a:	83 c4 10             	add    $0x10,%esp
8010489d:	85 c0                	test   %eax,%eax
8010489f:	75 29                	jne    801048ca <allocproc+0xc6>
801048a1:	eb 1a                	jmp    801048bd <allocproc+0xb9>
#else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
#endif
  release(&ptable.lock);
801048a3:	83 ec 0c             	sub    $0xc,%esp
801048a6:	68 a0 49 11 80       	push   $0x801149a0
801048ab:	e8 53 20 00 00       	call   80106903 <release>
801048b0:	83 c4 10             	add    $0x10,%esp
  return 0;
801048b3:	b8 00 00 00 00       	mov    $0x0,%eax
801048b8:	e9 38 01 00 00       	jmp    801049f5 <allocproc+0x1f1>
#endif
  p->state = EMBRYO; 
  p->pid = nextpid++;
#ifdef CS333_P3P4
  if(addToStateListHead(&ptable.pLists.embryo, p) == 0)
      panic("Failed add embryo in allocproc");
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	68 6c a4 10 80       	push   $0x8010a46c
801048c5:	e8 9c bc ff ff       	call   80100566 <panic>
  p->priority = 0;
801048ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cd:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801048d4:	00 00 00 
  p->budget = BUDGET_NEW;
801048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048da:	c7 80 98 00 00 00 f4 	movl   $0x1f4,0x98(%eax)
801048e1:	01 00 00 
#endif
  release(&ptable.lock);
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	68 a0 49 11 80       	push   $0x801149a0
801048ec:	e8 12 20 00 00       	call   80106903 <release>
801048f1:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801048f4:	e8 f7 e6 ff ff       	call   80102ff0 <kalloc>
801048f9:	89 c2                	mov    %eax,%edx
801048fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fe:	89 50 08             	mov    %edx,0x8(%eax)
80104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104904:	8b 40 08             	mov    0x8(%eax),%eax
80104907:	85 c0                	test   %eax,%eax
80104909:	0f 85 89 00 00 00    	jne    80104998 <allocproc+0x194>
#ifdef CS333_P3P4 //return to free
    acquire(&ptable.lock);
8010490f:	83 ec 0c             	sub    $0xc,%esp
80104912:	68 a0 49 11 80       	push   $0x801149a0
80104917:	e8 80 1f 00 00       	call   8010689c <acquire>
8010491c:	83 c4 10             	add    $0x10,%esp
    if(removeFromStateList(&ptable.pLists.embryo, p) == 0)
8010491f:	83 ec 08             	sub    $0x8,%esp
80104922:	ff 75 f4             	pushl  -0xc(%ebp)
80104925:	68 00 71 11 80       	push   $0x80117100
8010492a:	e8 c1 17 00 00       	call   801060f0 <removeFromStateList>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	75 0d                	jne    80104943 <allocproc+0x13f>
        panic("Failed allocproc remove from embryo");
80104936:	83 ec 0c             	sub    $0xc,%esp
80104939:	68 8c a4 10 80       	push   $0x8010a48c
8010493e:	e8 23 bc ff ff       	call   80100566 <panic>
    assertState(p, EMBRYO);
80104943:	83 ec 08             	sub    $0x8,%esp
80104946:	6a 01                	push   $0x1
80104948:	ff 75 f4             	pushl  -0xc(%ebp)
8010494b:	e8 44 18 00 00       	call   80106194 <assertState>
80104950:	83 c4 10             	add    $0x10,%esp
    if(addToStateListHead(&ptable.pLists.free, p) == 0)
80104953:	83 ec 08             	sub    $0x8,%esp
80104956:	ff 75 f4             	pushl  -0xc(%ebp)
80104959:	68 f0 70 11 80       	push   $0x801170f0
8010495e:	e8 bb 18 00 00       	call   8010621e <addToStateListHead>
80104963:	83 c4 10             	add    $0x10,%esp
80104966:	85 c0                	test   %eax,%eax
80104968:	75 0d                	jne    80104977 <allocproc+0x173>
        panic("Failed Allocproc Add To Free");
8010496a:	83 ec 0c             	sub    $0xc,%esp
8010496d:	68 b0 a4 10 80       	push   $0x8010a4b0
80104972:	e8 ef bb ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104977:	83 ec 0c             	sub    $0xc,%esp
8010497a:	68 a0 49 11 80       	push   $0x801149a0
8010497f:	e8 7f 1f 00 00       	call   80106903 <release>
80104984:	83 c4 10             	add    $0x10,%esp
#endif
    p->state = UNUSED;
80104987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010498a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104991:	b8 00 00 00 00       	mov    $0x0,%eax
80104996:	eb 5d                	jmp    801049f5 <allocproc+0x1f1>
  }
  sp = p->kstack + KSTACKSIZE;
80104998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010499b:	8b 40 08             	mov    0x8(%eax),%eax
8010499e:	05 00 10 00 00       	add    $0x1000,%eax
801049a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801049a6:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801049aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049b0:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801049b3:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801049b7:	ba 32 82 10 80       	mov    $0x80108232,%edx
801049bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049bf:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801049c1:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049cb:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801049ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d1:	8b 40 1c             	mov    0x1c(%eax),%eax
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	6a 14                	push   $0x14
801049d9:	6a 00                	push   $0x0
801049db:	50                   	push   %eax
801049dc:	e8 1e 21 00 00       	call   80106aff <memset>
801049e1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801049e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e7:	8b 40 1c             	mov    0x1c(%eax),%eax
801049ea:	ba dd 57 10 80       	mov    $0x801057dd,%edx
801049ef:	89 50 10             	mov    %edx,0x10(%eax)
  return p;
801049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801049f5:	c9                   	leave  
801049f6:	c3                   	ret    

801049f7 <userinit>:

// Set up first user process.
void
userinit(void)
{
801049f7:	55                   	push   %ebp
801049f8:	89 e5                	mov    %esp,%ebp
801049fa:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_P3P4
  acquire(&ptable.lock);
801049fd:	83 ec 0c             	sub    $0xc,%esp
80104a00:	68 a0 49 11 80       	push   $0x801149a0
80104a05:	e8 92 1e 00 00       	call   8010689c <acquire>
80104a0a:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
80104a0d:	c7 05 f0 70 11 80 00 	movl   $0x0,0x801170f0
80104a14:	00 00 00 
  ptable.pLists.running = 0;
80104a17:	c7 05 fc 70 11 80 00 	movl   $0x0,0x801170fc
80104a1e:	00 00 00 
  ptable.pLists.sleep = 0;
80104a21:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
80104a28:	00 00 00 
  ptable.pLists.zombie = 0;
80104a2b:	c7 05 f8 70 11 80 00 	movl   $0x0,0x801170f8
80104a32:	00 00 00 
  ptable.pLists.embryo = 0;
80104a35:	c7 05 00 71 11 80 00 	movl   $0x0,0x80117100
80104a3c:	00 00 00 
  ptable.PromoteAtTime = TIME_TO_PROMOTE + ticks;
80104a3f:	a1 20 79 11 80       	mov    0x80117920,%eax
80104a44:	05 d0 07 00 00       	add    $0x7d0,%eax
80104a49:	a3 04 71 11 80       	mov    %eax,0x80117104
  //initialize the ready lists
  for(int i = 0; i <= MAX; ++i)
80104a4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a55:	eb 17                	jmp    80104a6e <userinit+0x77>
      ptable.pLists.ready[i] = 0;
80104a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a5a:	05 cc 09 00 00       	add    $0x9cc,%eax
80104a5f:	c7 04 85 a4 49 11 80 	movl   $0x0,-0x7feeb65c(,%eax,4)
80104a66:	00 00 00 00 
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.embryo = 0;
  ptable.PromoteAtTime = TIME_TO_PROMOTE + ticks;
  //initialize the ready lists
  for(int i = 0; i <= MAX; ++i)
80104a6a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a6e:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
80104a72:	7e e3                	jle    80104a57 <userinit+0x60>
      ptable.pLists.ready[i] = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a74:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80104a7b:	eb 35                	jmp    80104ab2 <userinit+0xbb>
  {
      p->state = UNUSED;
80104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
      if(addToStateListHead(&ptable.pLists.free, p) == 0)
80104a87:	83 ec 08             	sub    $0x8,%esp
80104a8a:	ff 75 f4             	pushl  -0xc(%ebp)
80104a8d:	68 f0 70 11 80       	push   $0x801170f0
80104a92:	e8 87 17 00 00       	call   8010621e <addToStateListHead>
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	75 0d                	jne    80104aab <userinit+0xb4>
          panic("Failed add to free in userinit");
80104a9e:	83 ec 0c             	sub    $0xc,%esp
80104aa1:	68 d0 a4 10 80       	push   $0x8010a4d0
80104aa6:	e8 bb ba ff ff       	call   80100566 <panic>
  ptable.PromoteAtTime = TIME_TO_PROMOTE + ticks;
  //initialize the ready lists
  for(int i = 0; i <= MAX; ++i)
      ptable.pLists.ready[i] = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aab:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104ab2:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80104ab9:	72 c2                	jb     80104a7d <userinit+0x86>
  {
      p->state = UNUSED;
      if(addToStateListHead(&ptable.pLists.free, p) == 0)
          panic("Failed add to free in userinit");
  }
  release(&ptable.lock);
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	68 a0 49 11 80       	push   $0x801149a0
80104ac3:	e8 3b 1e 00 00       	call   80106903 <release>
80104ac8:	83 c4 10             	add    $0x10,%esp
#endif
  
  p = allocproc();  //free goes to embryo
80104acb:	e8 34 fd ff ff       	call   80104804 <allocproc>
80104ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad6:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104adb:	e8 14 4e 00 00       	call   801098f4 <setupkvm>
80104ae0:	89 c2                	mov    %eax,%edx
80104ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae5:	89 50 04             	mov    %edx,0x4(%eax)
80104ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aeb:	8b 40 04             	mov    0x4(%eax),%eax
80104aee:	85 c0                	test   %eax,%eax
80104af0:	75 0d                	jne    80104aff <userinit+0x108>
    panic("userinit: out of memory?");
80104af2:	83 ec 0c             	sub    $0xc,%esp
80104af5:	68 ef a4 10 80       	push   $0x8010a4ef
80104afa:	e8 67 ba ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104aff:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b07:	8b 40 04             	mov    0x4(%eax),%eax
80104b0a:	83 ec 04             	sub    $0x4,%esp
80104b0d:	52                   	push   %edx
80104b0e:	68 20 d5 10 80       	push   $0x8010d520
80104b13:	50                   	push   %eax
80104b14:	e8 35 50 00 00       	call   80109b4e <inituvm>
80104b19:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1f:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b28:	8b 40 18             	mov    0x18(%eax),%eax
80104b2b:	83 ec 04             	sub    $0x4,%esp
80104b2e:	6a 4c                	push   $0x4c
80104b30:	6a 00                	push   $0x0
80104b32:	50                   	push   %eax
80104b33:	e8 c7 1f 00 00       	call   80106aff <memset>
80104b38:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3e:	8b 40 18             	mov    0x18(%eax),%eax
80104b41:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4a:	8b 40 18             	mov    0x18(%eax),%eax
80104b4d:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	8b 40 18             	mov    0x18(%eax),%eax
80104b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5c:	8b 52 18             	mov    0x18(%edx),%edx
80104b5f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104b63:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6a:	8b 40 18             	mov    0x18(%eax),%eax
80104b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b70:	8b 52 18             	mov    0x18(%edx),%edx
80104b73:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104b77:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7e:	8b 40 18             	mov    0x18(%eax),%eax
80104b81:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8b:	8b 40 18             	mov    0x18(%eax),%eax
80104b8e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b98:	8b 40 18             	mov    0x18(%eax),%eax
80104b9b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba5:	83 c0 6c             	add    $0x6c,%eax
80104ba8:	83 ec 04             	sub    $0x4,%esp
80104bab:	6a 10                	push   $0x10
80104bad:	68 08 a5 10 80       	push   $0x8010a508
80104bb2:	50                   	push   %eax
80104bb3:	e8 4a 21 00 00       	call   80106d02 <safestrcpy>
80104bb8:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	68 11 a5 10 80       	push   $0x8010a511
80104bc3:	e8 ea dc ff ff       	call   801028b2 <namei>
80104bc8:	83 c4 10             	add    $0x10,%esp
80104bcb:	89 c2                	mov    %eax,%edx
80104bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd0:	89 50 68             	mov    %edx,0x68(%eax)
#ifdef CS333_P2
  p->uid = DEF_UID;
80104bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104bdd:	00 00 00 
  p->gid = DEF_GID;
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104bea:	00 00 00 
#endif
#ifdef CS333_P3P4
  //embryo goes to ready
  acquire(&ptable.lock);
80104bed:	83 ec 0c             	sub    $0xc,%esp
80104bf0:	68 a0 49 11 80       	push   $0x801149a0
80104bf5:	e8 a2 1c 00 00       	call   8010689c <acquire>
80104bfa:	83 c4 10             	add    $0x10,%esp
  if(removeFromStateList(&ptable.pLists.embryo, p) == -1)
80104bfd:	83 ec 08             	sub    $0x8,%esp
80104c00:	ff 75 f4             	pushl  -0xc(%ebp)
80104c03:	68 00 71 11 80       	push   $0x80117100
80104c08:	e8 e3 14 00 00       	call   801060f0 <removeFromStateList>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	83 f8 ff             	cmp    $0xffffffff,%eax
80104c13:	75 27                	jne    80104c3c <userinit+0x245>
  {
      assertState(p, EMBRYO);
80104c15:	83 ec 08             	sub    $0x8,%esp
80104c18:	6a 01                	push   $0x1
80104c1a:	ff 75 f4             	pushl  -0xc(%ebp)
80104c1d:	e8 72 15 00 00       	call   80106194 <assertState>
80104c22:	83 c4 10             	add    $0x10,%esp
      p->next = 0;
80104c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c28:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104c2f:	00 00 00 
      ptable.pLists.ready[0] = p;
80104c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c35:	a3 d4 70 11 80       	mov    %eax,0x801170d4
80104c3a:	eb 0d                	jmp    80104c49 <userinit+0x252>
  }
  else
      panic("Error Initializing Ready List");
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	68 13 a5 10 80       	push   $0x8010a513
80104c44:	e8 1d b9 ff ff       	call   80100566 <panic>
  release(&ptable.lock);
80104c49:	83 ec 0c             	sub    $0xc,%esp
80104c4c:	68 a0 49 11 80       	push   $0x801149a0
80104c51:	e8 ad 1c 00 00       	call   80106903 <release>
80104c56:	83 c4 10             	add    $0x10,%esp
#endif
  p->state = RUNNABLE;
80104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104c63:	90                   	nop
80104c64:	c9                   	leave  
80104c65:	c3                   	ret    

80104c66 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104c66:	55                   	push   %ebp
80104c67:	89 e5                	mov    %esp,%ebp
80104c69:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104c6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c72:	8b 00                	mov    (%eax),%eax
80104c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104c7b:	7e 31                	jle    80104cae <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c83:	01 c2                	add    %eax,%edx
80104c85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8b:	8b 40 04             	mov    0x4(%eax),%eax
80104c8e:	83 ec 04             	sub    $0x4,%esp
80104c91:	52                   	push   %edx
80104c92:	ff 75 f4             	pushl  -0xc(%ebp)
80104c95:	50                   	push   %eax
80104c96:	e8 00 50 00 00       	call   80109c9b <allocuvm>
80104c9b:	83 c4 10             	add    $0x10,%esp
80104c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ca5:	75 3e                	jne    80104ce5 <growproc+0x7f>
      return -1;
80104ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cac:	eb 59                	jmp    80104d07 <growproc+0xa1>
  } else if(n < 0){
80104cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104cb2:	79 31                	jns    80104ce5 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104cb4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cba:	01 c2                	add    %eax,%edx
80104cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc2:	8b 40 04             	mov    0x4(%eax),%eax
80104cc5:	83 ec 04             	sub    $0x4,%esp
80104cc8:	52                   	push   %edx
80104cc9:	ff 75 f4             	pushl  -0xc(%ebp)
80104ccc:	50                   	push   %eax
80104ccd:	e8 92 50 00 00       	call   80109d64 <deallocuvm>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104cd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104cdc:	75 07                	jne    80104ce5 <growproc+0x7f>
      return -1;
80104cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce3:	eb 22                	jmp    80104d07 <growproc+0xa1>
  }
  proc->sz = sz;
80104ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cee:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf6:	83 ec 0c             	sub    $0xc,%esp
80104cf9:	50                   	push   %eax
80104cfa:	e8 dc 4c 00 00       	call   801099db <switchuvm>
80104cff:	83 c4 10             	add    $0x10,%esp
  return 0;
80104d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d07:	c9                   	leave  
80104d08:	c3                   	ret    

80104d09 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int //starts as embryo here
fork(void)
{
80104d09:	55                   	push   %ebp
80104d0a:	89 e5                	mov    %esp,%ebp
80104d0c:	57                   	push   %edi
80104d0d:	56                   	push   %esi
80104d0e:	53                   	push   %ebx
80104d0f:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  
  // Allocate process.
  if((np = allocproc()) == 0)
80104d12:	e8 ed fa ff ff       	call   80104804 <allocproc>
80104d17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104d1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104d1e:	75 0a                	jne    80104d2a <fork+0x21>
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	e9 66 02 00 00       	jmp    80104f90 <fork+0x287>


  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104d2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d30:	8b 10                	mov    (%eax),%edx
80104d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d38:	8b 40 04             	mov    0x4(%eax),%eax
80104d3b:	83 ec 08             	sub    $0x8,%esp
80104d3e:	52                   	push   %edx
80104d3f:	50                   	push   %eax
80104d40:	e8 bd 51 00 00       	call   80109f02 <copyuvm>
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	89 c2                	mov    %eax,%edx
80104d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d4d:	89 50 04             	mov    %edx,0x4(%eax)
80104d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d53:	8b 40 04             	mov    0x4(%eax),%eax
80104d56:	85 c0                	test   %eax,%eax
80104d58:	0f 85 a8 00 00 00    	jne    80104e06 <fork+0xfd>
    kfree(np->kstack);
80104d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d61:	8b 40 08             	mov    0x8(%eax),%eax
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	50                   	push   %eax
80104d68:	e8 e6 e1 ff ff       	call   80102f53 <kfree>
80104d6d:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
    acquire(&ptable.lock); 
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 a0 49 11 80       	push   $0x801149a0
80104d78:	e8 1f 1b 00 00       	call   8010689c <acquire>
80104d7d:	83 c4 10             	add    $0x10,%esp
    //give to free : handle return value?
    if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
80104d80:	83 ec 08             	sub    $0x8,%esp
80104d83:	ff 75 e0             	pushl  -0x20(%ebp)
80104d86:	68 00 71 11 80       	push   $0x80117100
80104d8b:	e8 60 13 00 00       	call   801060f0 <removeFromStateList>
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	85 c0                	test   %eax,%eax
80104d95:	75 0d                	jne    80104da4 <fork+0x9b>
        panic("Failed remove from Embryo in fork");
80104d97:	83 ec 0c             	sub    $0xc,%esp
80104d9a:	68 34 a5 10 80       	push   $0x8010a534
80104d9f:	e8 c2 b7 ff ff       	call   80100566 <panic>
    assertState(np, EMBRYO);    
80104da4:	83 ec 08             	sub    $0x8,%esp
80104da7:	6a 01                	push   $0x1
80104da9:	ff 75 e0             	pushl  -0x20(%ebp)
80104dac:	e8 e3 13 00 00       	call   80106194 <assertState>
80104db1:	83 c4 10             	add    $0x10,%esp
    if(addToStateListHead(&ptable.pLists.free, np) == 0)
80104db4:	83 ec 08             	sub    $0x8,%esp
80104db7:	ff 75 e0             	pushl  -0x20(%ebp)
80104dba:	68 f0 70 11 80       	push   $0x801170f0
80104dbf:	e8 5a 14 00 00       	call   8010621e <addToStateListHead>
80104dc4:	83 c4 10             	add    $0x10,%esp
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	75 0d                	jne    80104dd8 <fork+0xcf>
        panic("Failed add to free in fork");
80104dcb:	83 ec 0c             	sub    $0xc,%esp
80104dce:	68 56 a5 10 80       	push   $0x8010a556
80104dd3:	e8 8e b7 ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	68 a0 49 11 80       	push   $0x801149a0
80104de0:	e8 1e 1b 00 00       	call   80106903 <release>
80104de5:	83 c4 10             	add    $0x10,%esp
#endif
    np->kstack = 0;
80104de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104deb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104df2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104df5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e01:	e9 8a 01 00 00       	jmp    80104f90 <fork+0x287>
  }
  np->sz = proc->sz;
80104e06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0c:	8b 10                	mov    (%eax),%edx
80104e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e11:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104e13:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e1d:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e23:	8b 50 18             	mov    0x18(%eax),%edx
80104e26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2c:	8b 40 18             	mov    0x18(%eax),%eax
80104e2f:	89 c3                	mov    %eax,%ebx
80104e31:	b8 13 00 00 00       	mov    $0x13,%eax
80104e36:	89 d7                	mov    %edx,%edi
80104e38:	89 de                	mov    %ebx,%esi
80104e3a:	89 c1                	mov    %eax,%ecx
80104e3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

#ifdef CS333_P2
  np->uid = proc->uid;
80104e3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e44:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e4d:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e59:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e62:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
#endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e6b:	8b 40 18             	mov    0x18(%eax),%eax
80104e6e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104e75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104e7c:	eb 43                	jmp    80104ec1 <fork+0x1b8>
    if(proc->ofile[i])
80104e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e87:	83 c2 08             	add    $0x8,%edx
80104e8a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104e8e:	85 c0                	test   %eax,%eax
80104e90:	74 2b                	je     80104ebd <fork+0x1b4>
      np->ofile[i] = filedup(proc->ofile[i]);
80104e92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e9b:	83 c2 08             	add    $0x8,%edx
80104e9e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	50                   	push   %eax
80104ea6:	e8 68 c2 ff ff       	call   80101113 <filedup>
80104eab:	83 c4 10             	add    $0x10,%esp
80104eae:	89 c1                	mov    %eax,%ecx
80104eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104eb6:	83 c2 08             	add    $0x8,%edx
80104eb9:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;
#endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104ebd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ec1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104ec5:	7e b7                	jle    80104e7e <fork+0x175>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104ec7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecd:	8b 40 68             	mov    0x68(%eax),%eax
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	50                   	push   %eax
80104ed4:	e8 91 cd ff ff       	call   80101c6a <idup>
80104ed9:	83 c4 10             	add    $0x10,%esp
80104edc:	89 c2                	mov    %eax,%edx
80104ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ee1:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104ee4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eea:	8d 50 6c             	lea    0x6c(%eax),%edx
80104eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ef0:	83 c0 6c             	add    $0x6c,%eax
80104ef3:	83 ec 04             	sub    $0x4,%esp
80104ef6:	6a 10                	push   $0x10
80104ef8:	52                   	push   %edx
80104ef9:	50                   	push   %eax
80104efa:	e8 03 1e 00 00       	call   80106d02 <safestrcpy>
80104eff:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f05:	8b 40 10             	mov    0x10(%eax),%eax
80104f08:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104f0b:	83 ec 0c             	sub    $0xc,%esp
80104f0e:	68 a0 49 11 80       	push   $0x801149a0
80104f13:	e8 84 19 00 00       	call   8010689c <acquire>
80104f18:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
80104f1b:	83 ec 08             	sub    $0x8,%esp
80104f1e:	ff 75 e0             	pushl  -0x20(%ebp)
80104f21:	68 00 71 11 80       	push   $0x80117100
80104f26:	e8 c5 11 00 00       	call   801060f0 <removeFromStateList>
80104f2b:	83 c4 10             	add    $0x10,%esp
80104f2e:	85 c0                	test   %eax,%eax
80104f30:	75 0d                	jne    80104f3f <fork+0x236>
      panic("fork fail");
80104f32:	83 ec 0c             	sub    $0xc,%esp
80104f35:	68 71 a5 10 80       	push   $0x8010a571
80104f3a:	e8 27 b6 ff ff       	call   80100566 <panic>
  assertState(np, EMBRYO);
80104f3f:	83 ec 08             	sub    $0x8,%esp
80104f42:	6a 01                	push   $0x1
80104f44:	ff 75 e0             	pushl  -0x20(%ebp)
80104f47:	e8 48 12 00 00       	call   80106194 <assertState>
80104f4c:	83 c4 10             	add    $0x10,%esp
  if(addToStateListEnd(&ptable.pLists.ready[0], np) == 0)
80104f4f:	83 ec 08             	sub    $0x8,%esp
80104f52:	ff 75 e0             	pushl  -0x20(%ebp)
80104f55:	68 d4 70 11 80       	push   $0x801170d4
80104f5a:	e8 56 12 00 00       	call   801061b5 <addToStateListEnd>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	85 c0                	test   %eax,%eax
80104f64:	75 0d                	jne    80104f73 <fork+0x26a>
      panic("Fork fail 2");
80104f66:	83 ec 0c             	sub    $0xc,%esp
80104f69:	68 7b a5 10 80       	push   $0x8010a57b
80104f6e:	e8 f3 b5 ff ff       	call   80100566 <panic>
#endif
  np->state = RUNNABLE;
80104f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f76:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	68 a0 49 11 80       	push   $0x801149a0
80104f85:	e8 79 19 00 00       	call   80106903 <release>
80104f8a:	83 c4 10             	add    $0x10,%esp
  return pid;
80104f8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f93:	5b                   	pop    %ebx
80104f94:	5e                   	pop    %esi
80104f95:	5f                   	pop    %edi
80104f96:	5d                   	pop    %ebp
80104f97:	c3                   	ret    

80104f98 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104f98:	55                   	push   %ebp
80104f99:	89 e5                	mov    %esp,%ebp
80104f9b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  //struct proc *current;
  int fd;

  if(proc == initproc)
80104f9e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fa5:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104faa:	39 c2                	cmp    %eax,%edx
80104fac:	75 0d                	jne    80104fbb <exit+0x23>
    panic("init exiting");
80104fae:	83 ec 0c             	sub    $0xc,%esp
80104fb1:	68 87 a5 10 80       	push   $0x8010a587
80104fb6:	e8 ab b5 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104fbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104fc2:	eb 48                	jmp    8010500c <exit+0x74>
    if(proc->ofile[fd]){
80104fc4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fcd:	83 c2 08             	add    $0x8,%edx
80104fd0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	74 30                	je     80105008 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104fd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fe1:	83 c2 08             	add    $0x8,%edx
80104fe4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	50                   	push   %eax
80104fec:	e8 73 c1 ff ff       	call   80101164 <fileclose>
80104ff1:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104ff4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ffa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ffd:	83 c2 08             	add    $0x8,%edx
80105000:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105007:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80105008:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010500c:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105010:	7e b2                	jle    80104fc4 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80105012:	e8 c0 e8 ff ff       	call   801038d7 <begin_op>
  iput(proc->cwd);
80105017:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501d:	8b 40 68             	mov    0x68(%eax),%eax
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	50                   	push   %eax
80105024:	e8 73 ce ff ff       	call   80101e9c <iput>
80105029:	83 c4 10             	add    $0x10,%esp
  end_op();
8010502c:	e8 32 e9 ff ff       	call   80103963 <end_op>
  proc->cwd = 0;
80105031:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105037:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010503e:	83 ec 0c             	sub    $0xc,%esp
80105041:	68 a0 49 11 80       	push   $0x801149a0
80105046:	e8 51 18 00 00       	call   8010689c <acquire>
8010504b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010504e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105054:	8b 40 14             	mov    0x14(%eax),%eax
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	50                   	push   %eax
8010505b:	e8 ef 08 00 00       	call   8010594f <wakeup1>
80105060:	83 c4 10             	add    $0x10,%esp

  

  // Pass abandoned children to init.
  for(int i = 0; i < MAX; ++i)
80105063:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010506a:	eb 1f                	jmp    8010508b <exit+0xf3>
      exitSearch(ptable.pLists.ready[i]);
8010506c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010506f:	05 cc 09 00 00       	add    $0x9cc,%eax
80105074:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
8010507b:	83 ec 0c             	sub    $0xc,%esp
8010507e:	50                   	push   %eax
8010507f:	e8 c7 11 00 00       	call   8010624b <exitSearch>
80105084:	83 c4 10             	add    $0x10,%esp
  wakeup1(proc->parent);

  

  // Pass abandoned children to init.
  for(int i = 0; i < MAX; ++i)
80105087:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010508b:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
8010508f:	7e db                	jle    8010506c <exit+0xd4>
      exitSearch(ptable.pLists.ready[i]);

  exitSearch(ptable.pLists.running);
80105091:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80105096:	83 ec 0c             	sub    $0xc,%esp
80105099:	50                   	push   %eax
8010509a:	e8 ac 11 00 00       	call   8010624b <exitSearch>
8010509f:	83 c4 10             	add    $0x10,%esp
  exitSearch(ptable.pLists.sleep);
801050a2:	a1 f4 70 11 80       	mov    0x801170f4,%eax
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	50                   	push   %eax
801050ab:	e8 9b 11 00 00       	call   8010624b <exitSearch>
801050b0:	83 c4 10             	add    $0x10,%esp
  exitSearch(ptable.pLists.embryo);
801050b3:	a1 00 71 11 80       	mov    0x80117100,%eax
801050b8:	83 ec 0c             	sub    $0xc,%esp
801050bb:	50                   	push   %eax
801050bc:	e8 8a 11 00 00       	call   8010624b <exitSearch>
801050c1:	83 c4 10             	add    $0x10,%esp

  p = ptable.pLists.zombie;
801050c4:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801050c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
801050cc:	eb 39                	jmp    80105107 <exit+0x16f>
  {
      if(p->parent == proc)
801050ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d1:	8b 50 14             	mov    0x14(%eax),%edx
801050d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050da:	39 c2                	cmp    %eax,%edx
801050dc:	75 1d                	jne    801050fb <exit+0x163>
      {
          p->parent = initproc;
801050de:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
801050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e7:	89 50 14             	mov    %edx,0x14(%eax)
          wakeup1(initproc);
801050ea:	a1 88 d6 10 80       	mov    0x8010d688,%eax
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	50                   	push   %eax
801050f3:	e8 57 08 00 00       	call   8010594f <wakeup1>
801050f8:	83 c4 10             	add    $0x10,%esp
      }
      p = p->next;
801050fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050fe:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exitSearch(ptable.pLists.running);
  exitSearch(ptable.pLists.sleep);
  exitSearch(ptable.pLists.embryo);

  p = ptable.pLists.zombie;
  while(p)
80105107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010510b:	75 c1                	jne    801050ce <exit+0x136>
      p = p->next;
  }

  // Jump into the scheduler, never to return.

  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
8010510d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105113:	83 ec 08             	sub    $0x8,%esp
80105116:	50                   	push   %eax
80105117:	68 fc 70 11 80       	push   $0x801170fc
8010511c:	e8 cf 0f 00 00       	call   801060f0 <removeFromStateList>
80105121:	83 c4 10             	add    $0x10,%esp
80105124:	85 c0                	test   %eax,%eax
80105126:	75 0d                	jne    80105135 <exit+0x19d>
      panic("exit failed running");
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	68 94 a5 10 80       	push   $0x8010a594
80105130:	e8 31 b4 ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
80105135:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513b:	83 ec 08             	sub    $0x8,%esp
8010513e:	6a 04                	push   $0x4
80105140:	50                   	push   %eax
80105141:	e8 4e 10 00 00       	call   80106194 <assertState>
80105146:	83 c4 10             	add    $0x10,%esp
  if(addToStateListHead(&ptable.pLists.zombie, proc) == 0)
80105149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514f:	83 ec 08             	sub    $0x8,%esp
80105152:	50                   	push   %eax
80105153:	68 f8 70 11 80       	push   $0x801170f8
80105158:	e8 c1 10 00 00       	call   8010621e <addToStateListHead>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	75 0d                	jne    80105171 <exit+0x1d9>
      panic("exit failed zombie");
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	68 a8 a5 10 80       	push   $0x8010a5a8
8010516c:	e8 f5 b3 ff ff       	call   80100566 <panic>
  proc->state = ZOMBIE;
80105171:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105177:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010517e:	e8 8b 04 00 00       	call   8010560e <sched>
  panic("zombie exit");
80105183:	83 ec 0c             	sub    $0xc,%esp
80105186:	68 bb a5 10 80       	push   $0x8010a5bb
8010518b:	e8 d6 b3 ff ff       	call   80100566 <panic>

80105190 <wait>:
  }
}
#else
int
wait(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80105196:	83 ec 0c             	sub    $0xc,%esp
80105199:	68 a0 49 11 80       	push   $0x801149a0
8010519e:	e8 f9 16 00 00       	call   8010689c <acquire>
801051a3:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801051a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    p = ptable.pLists.zombie;
801051ad:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801051b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(p)
801051b5:	e9 fd 00 00 00       	jmp    801052b7 <wait+0x127>
    {                   
      if(p->parent == proc){
801051ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bd:	8b 50 14             	mov    0x14(%eax),%edx
801051c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c6:	39 c2                	cmp    %eax,%edx
801051c8:	0f 85 dd 00 00 00    	jne    801052ab <wait+0x11b>
        havekids = 1;
801051ce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        // Found one.
        if(removeFromStateList(&ptable.pLists.zombie, p) == 0)
801051d5:	83 ec 08             	sub    $0x8,%esp
801051d8:	ff 75 f4             	pushl  -0xc(%ebp)
801051db:	68 f8 70 11 80       	push   $0x801170f8
801051e0:	e8 0b 0f 00 00       	call   801060f0 <removeFromStateList>
801051e5:	83 c4 10             	add    $0x10,%esp
801051e8:	85 c0                	test   %eax,%eax
801051ea:	75 0d                	jne    801051f9 <wait+0x69>
            panic("wait zombie");
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	68 c7 a5 10 80       	push   $0x8010a5c7
801051f4:	e8 6d b3 ff ff       	call   80100566 <panic>
        assertState(p, ZOMBIE);
801051f9:	83 ec 08             	sub    $0x8,%esp
801051fc:	6a 05                	push   $0x5
801051fe:	ff 75 f4             	pushl  -0xc(%ebp)
80105201:	e8 8e 0f 00 00       	call   80106194 <assertState>
80105206:	83 c4 10             	add    $0x10,%esp
        pid = p->pid;
80105209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520c:	8b 40 10             	mov    0x10(%eax),%eax
8010520f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80105212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105215:	8b 40 08             	mov    0x8(%eax),%eax
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	50                   	push   %eax
8010521c:	e8 32 dd ff ff       	call   80102f53 <kfree>
80105221:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80105224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105227:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010522e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105231:	8b 40 04             	mov    0x4(%eax),%eax
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	50                   	push   %eax
80105238:	e8 e4 4b 00 00       	call   80109e21 <freevm>
8010523d:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80105240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105243:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010524a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80105254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105257:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010525e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105261:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80105265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105268:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        if(addToStateListHead(&ptable.pLists.free, p) == 0)
8010526f:	83 ec 08             	sub    $0x8,%esp
80105272:	ff 75 f4             	pushl  -0xc(%ebp)
80105275:	68 f0 70 11 80       	push   $0x801170f0
8010527a:	e8 9f 0f 00 00       	call   8010621e <addToStateListHead>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	85 c0                	test   %eax,%eax
80105284:	75 0d                	jne    80105293 <wait+0x103>
            panic("wait free");        
80105286:	83 ec 0c             	sub    $0xc,%esp
80105289:	68 d3 a5 10 80       	push   $0x8010a5d3
8010528e:	e8 d3 b2 ff ff       	call   80100566 <panic>
        release(&ptable.lock);
80105293:	83 ec 0c             	sub    $0xc,%esp
80105296:	68 a0 49 11 80       	push   $0x801149a0
8010529b:	e8 63 16 00 00       	call   80106903 <release>
801052a0:	83 c4 10             	add    $0x10,%esp
        return pid;
801052a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801052a6:	e9 ea 00 00 00       	jmp    80105395 <wait+0x205>
      }
      p = p->next;
801052ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ae:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801052b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;
    while(p)
801052b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052bb:	0f 85 f9 fe ff ff    	jne    801051ba <wait+0x2a>
        return pid;
      }
      p = p->next;
    }

    if(havekids == 0)
801052c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052c5:	75 3a                	jne    80105301 <wait+0x171>
    {
        for(int i = 0; i <= MAX; ++i)
801052c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801052ce:	eb 28                	jmp    801052f8 <wait+0x168>
        {
            havekids = waitSearch(ptable.pLists.ready[i]);
801052d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052d3:	05 cc 09 00 00       	add    $0x9cc,%eax
801052d8:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
801052df:	83 ec 0c             	sub    $0xc,%esp
801052e2:	50                   	push   %eax
801052e3:	e8 a8 0f 00 00       	call   80106290 <waitSearch>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(havekids == 1) break;
801052ee:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801052f2:	74 0c                	je     80105300 <wait+0x170>
      p = p->next;
    }

    if(havekids == 0)
    {
        for(int i = 0; i <= MAX; ++i)
801052f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801052f8:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
801052fc:	7e d2                	jle    801052d0 <wait+0x140>
801052fe:	eb 01                	jmp    80105301 <wait+0x171>
        {
            havekids = waitSearch(ptable.pLists.ready[i]);
            if(havekids == 1) break;
80105300:	90                   	nop
        }
    }
    if(havekids == 0)
80105301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105305:	75 14                	jne    8010531b <wait+0x18b>
        havekids = waitSearch(ptable.pLists.sleep);
80105307:	a1 f4 70 11 80       	mov    0x801170f4,%eax
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	50                   	push   %eax
80105310:	e8 7b 0f 00 00       	call   80106290 <waitSearch>
80105315:	83 c4 10             	add    $0x10,%esp
80105318:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(havekids == 0)
8010531b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010531f:	75 14                	jne    80105335 <wait+0x1a5>
        havekids = waitSearch(ptable.pLists.running);
80105321:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80105326:	83 ec 0c             	sub    $0xc,%esp
80105329:	50                   	push   %eax
8010532a:	e8 61 0f 00 00       	call   80106290 <waitSearch>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(havekids == 0)
80105335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105339:	75 14                	jne    8010534f <wait+0x1bf>
        havekids = waitSearch(ptable.pLists.embryo);
8010533b:	a1 00 71 11 80       	mov    0x80117100,%eax
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	50                   	push   %eax
80105344:	e8 47 0f 00 00       	call   80106290 <waitSearch>
80105349:	83 c4 10             	add    $0x10,%esp
8010534c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010534f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105353:	74 0d                	je     80105362 <wait+0x1d2>
80105355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535b:	8b 40 24             	mov    0x24(%eax),%eax
8010535e:	85 c0                	test   %eax,%eax
80105360:	74 17                	je     80105379 <wait+0x1e9>
      release(&ptable.lock);
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	68 a0 49 11 80       	push   $0x801149a0
8010536a:	e8 94 15 00 00       	call   80106903 <release>
8010536f:	83 c4 10             	add    $0x10,%esp
      return -1;
80105372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105377:	eb 1c                	jmp    80105395 <wait+0x205>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105379:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010537f:	83 ec 08             	sub    $0x8,%esp
80105382:	68 a0 49 11 80       	push   $0x801149a0
80105387:	50                   	push   %eax
80105388:	e8 96 04 00 00       	call   80105823 <sleep>
8010538d:	83 c4 10             	add    $0x10,%esp
  }
80105390:	e9 11 fe ff ff       	jmp    801051a6 <wait+0x16>
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    

80105397 <scheduler>:
}

#else
void
scheduler(void)
{
80105397:	55                   	push   %ebp
80105398:	89 e5                	mov    %esp,%ebp
8010539a:	83 ec 28             	sub    $0x28,%esp
  struct proc * found;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
8010539d:	e8 3d f4 ff ff       	call   801047df <sti>

    idle = 1;  // assume idle unless we schedule a process
801053a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    acquire(&ptable.lock);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	68 a0 49 11 80       	push   $0x801149a0
801053b1:	e8 e6 14 00 00       	call   8010689c <acquire>
801053b6:	83 c4 10             	add    $0x10,%esp
    //if it's time to promote, move up in queue
    if(ticks >= ptable.PromoteAtTime)
801053b9:	8b 15 04 71 11 80    	mov    0x80117104,%edx
801053bf:	a1 20 79 11 80       	mov    0x80117920,%eax
801053c4:	39 c2                	cmp    %eax,%edx
801053c6:	0f 87 36 01 00 00    	ja     80105502 <scheduler+0x16b>
    {

//        printready();
        for(int i = 1; i <= MAX; ++i)
801053cc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
801053d3:	e9 ef 00 00 00       	jmp    801054c7 <scheduler+0x130>
        {
            curr = ptable.pLists.ready[i];
801053d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801053db:	05 cc 09 00 00       	add    $0x9cc,%eax
801053e0:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
801053e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
            while(curr)
801053ea:	e9 ca 00 00 00       	jmp    801054b9 <scheduler+0x122>
            {
                found = curr;
801053ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
                curr = curr->next;
801053f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801053fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if(removeFromStateList(&ptable.pLists.ready[i], found) == 0)
80105401:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105404:	05 cc 09 00 00       	add    $0x9cc,%eax
80105409:	c1 e0 02             	shl    $0x2,%eax
8010540c:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105411:	83 c0 04             	add    $0x4,%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	ff 75 e0             	pushl  -0x20(%ebp)
8010541a:	50                   	push   %eax
8010541b:	e8 d0 0c 00 00       	call   801060f0 <removeFromStateList>
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	85 c0                	test   %eax,%eax
80105425:	75 0d                	jne    80105434 <scheduler+0x9d>
                    panic("FAILED PROMOTE REMOVE SCHEDULER");
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010542f:	e8 32 b1 ff ff       	call   80100566 <panic>
                assertState(found, RUNNABLE);
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	6a 03                	push   $0x3
80105439:	ff 75 e0             	pushl  -0x20(%ebp)
8010543c:	e8 53 0d 00 00       	call   80106194 <assertState>
80105441:	83 c4 10             	add    $0x10,%esp
                
//              cprintf("BUMPING PRIORITY IN SCHEDLER\n");
                if(found->priority != i)
80105444:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105447:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010544d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105450:	39 c2                	cmp    %eax,%edx
80105452:	74 0d                	je     80105461 <scheduler+0xca>
                    panic("PRIORITY WRONG IN SCHEDULER");
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	68 00 a6 10 80       	push   $0x8010a600
8010545c:	e8 05 b1 ff ff       	call   80100566 <panic>

                found->priority = found->priority - 1;
80105461:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105464:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010546a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010546d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105470:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                found->budget = BUDGET_NEW;
80105476:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105479:	c7 80 98 00 00 00 f4 	movl   $0x1f4,0x98(%eax)
80105480:	01 00 00 
                
                if(addToStateListEnd(&ptable.pLists.ready[i - 1], found) == 0)
80105483:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105486:	83 e8 01             	sub    $0x1,%eax
80105489:	05 cc 09 00 00       	add    $0x9cc,%eax
8010548e:	c1 e0 02             	shl    $0x2,%eax
80105491:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105496:	83 c0 04             	add    $0x4,%eax
80105499:	83 ec 08             	sub    $0x8,%esp
8010549c:	ff 75 e0             	pushl  -0x20(%ebp)
8010549f:	50                   	push   %eax
801054a0:	e8 10 0d 00 00       	call   801061b5 <addToStateListEnd>
801054a5:	83 c4 10             	add    $0x10,%esp
801054a8:	85 c0                	test   %eax,%eax
801054aa:	75 0d                	jne    801054b9 <scheduler+0x122>
                    panic("FAILED PROMOTE ADD SCHEDULER");
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	68 1c a6 10 80       	push   $0x8010a61c
801054b4:	e8 ad b0 ff ff       	call   80100566 <panic>

//        printready();
        for(int i = 1; i <= MAX; ++i)
        {
            curr = ptable.pLists.ready[i];
            while(curr)
801054b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054bd:	0f 85 2c ff ff ff    	jne    801053ef <scheduler+0x58>
    //if it's time to promote, move up in queue
    if(ticks >= ptable.PromoteAtTime)
    {

//        printready();
        for(int i = 1; i <= MAX; ++i)
801054c3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
801054c7:	83 7d e8 06          	cmpl   $0x6,-0x18(%ebp)
801054cb:	0f 8e 07 ff ff ff    	jle    801053d8 <scheduler+0x41>
                    panic("FAILED PROMOTE ADD SCHEDULER");
            }
        }

//        printready();
        bumpPriority(ptable.pLists.sleep);
801054d1:	a1 f4 70 11 80       	mov    0x801170f4,%eax
801054d6:	83 ec 0c             	sub    $0xc,%esp
801054d9:	50                   	push   %eax
801054da:	e8 12 11 00 00       	call   801065f1 <bumpPriority>
801054df:	83 c4 10             	add    $0x10,%esp
        bumpPriority(ptable.pLists.running);
801054e2:	a1 fc 70 11 80       	mov    0x801170fc,%eax
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	50                   	push   %eax
801054eb:	e8 01 11 00 00       	call   801065f1 <bumpPriority>
801054f0:	83 c4 10             	add    $0x10,%esp

        ptable.PromoteAtTime = ticks + TIME_TO_PROMOTE;
801054f3:	a1 20 79 11 80       	mov    0x80117920,%eax
801054f8:	05 d0 07 00 00       	add    $0x7d0,%eax
801054fd:	a3 04 71 11 80       	mov    %eax,0x80117104
    }

    //we need to modify this to search through each ready list
    //looking for a process
    for(int i = 0; i <= MAX; ++i)
80105502:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105509:	eb 2c                	jmp    80105537 <scheduler+0x1a0>
    {
        p = removeFromStateListHead(&ptable.pLists.ready[i]);
8010550b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010550e:	05 cc 09 00 00       	add    $0x9cc,%eax
80105513:	c1 e0 02             	shl    $0x2,%eax
80105516:	05 a0 49 11 80       	add    $0x801149a0,%eax
8010551b:	83 c0 04             	add    $0x4,%eax
8010551e:	83 ec 0c             	sub    $0xc,%esp
80105521:	50                   	push   %eax
80105522:	e8 89 0b 00 00       	call   801060b0 <removeFromStateListHead>
80105527:	83 c4 10             	add    $0x10,%esp
8010552a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p) break; 
8010552d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105531:	75 0c                	jne    8010553f <scheduler+0x1a8>
        ptable.PromoteAtTime = ticks + TIME_TO_PROMOTE;
    }

    //we need to modify this to search through each ready list
    //looking for a process
    for(int i = 0; i <= MAX; ++i)
80105533:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105537:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
8010553b:	7e ce                	jle    8010550b <scheduler+0x174>
8010553d:	eb 01                	jmp    80105540 <scheduler+0x1a9>
    {
        p = removeFromStateListHead(&ptable.pLists.ready[i]);
        if(p) break; 
8010553f:	90                   	nop
    }
    if(p)
80105540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105544:	0f 84 9b 00 00 00    	je     801055e5 <scheduler+0x24e>
    {
      assertState(p, RUNNABLE);
8010554a:	83 ec 08             	sub    $0x8,%esp
8010554d:	6a 03                	push   $0x3
8010554f:	ff 75 f4             	pushl  -0xc(%ebp)
80105552:	e8 3d 0c 00 00       	call   80106194 <assertState>
80105557:	83 c4 10             	add    $0x10,%esp

      //cprintf("Process entering CPU: %d\n", p->pid);
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
8010555a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
      proc = p;
80105561:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105564:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	ff 75 f4             	pushl  -0xc(%ebp)
80105570:	e8 66 44 00 00       	call   801099db <switchuvm>
80105575:	83 c4 10             	add    $0x10,%esp

      p->state = RUNNING;
80105578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
80105582:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010558b:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
#endif
      if(addToStateListHead(&ptable.pLists.running, p) == 0)
80105591:	83 ec 08             	sub    $0x8,%esp
80105594:	ff 75 f4             	pushl  -0xc(%ebp)
80105597:	68 fc 70 11 80       	push   $0x801170fc
8010559c:	e8 7d 0c 00 00       	call   8010621e <addToStateListHead>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	75 0d                	jne    801055b5 <scheduler+0x21e>
          panic("failed sched add to running");
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	68 39 a6 10 80       	push   $0x8010a639
801055b0:	e8 b1 af ff ff       	call   80100566 <panic>
      swtch(&cpu->scheduler, proc->context);
801055b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801055be:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055c5:	83 c2 04             	add    $0x4,%edx
801055c8:	83 ec 08             	sub    $0x8,%esp
801055cb:	50                   	push   %eax
801055cc:	52                   	push   %edx
801055cd:	e8 a1 17 00 00       	call   80106d73 <swtch>
801055d2:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801055d5:	e8 e4 43 00 00       	call   801099be <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801055da:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801055e1:	00 00 00 00 

    }
    release(&ptable.lock);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	68 a0 49 11 80       	push   $0x801149a0
801055ed:	e8 11 13 00 00       	call   80106903 <release>
801055f2:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
801055f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801055f9:	0f 84 9e fd ff ff    	je     8010539d <scheduler+0x6>
      sti();
801055ff:	e8 db f1 ff ff       	call   801047df <sti>
      hlt();
80105604:	e8 bf f1 ff ff       	call   801047c8 <hlt>
    }
  }
80105609:	e9 8f fd ff ff       	jmp    8010539d <scheduler+0x6>

8010560e <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
8010560e:	55                   	push   %ebp
8010560f:	89 e5                	mov    %esp,%ebp
80105611:	53                   	push   %ebx
80105612:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105615:	83 ec 0c             	sub    $0xc,%esp
80105618:	68 a0 49 11 80       	push   $0x801149a0
8010561d:	e8 ad 13 00 00       	call   801069cf <holding>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	75 0d                	jne    80105636 <sched+0x28>
    panic("sched ptable.lock");
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	68 55 a6 10 80       	push   $0x8010a655
80105631:	e8 30 af ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105636:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010563c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105642:	83 f8 01             	cmp    $0x1,%eax
80105645:	74 0d                	je     80105654 <sched+0x46>
    panic("sched locks");
80105647:	83 ec 0c             	sub    $0xc,%esp
8010564a:	68 67 a6 10 80       	push   $0x8010a667
8010564f:	e8 12 af ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105654:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010565a:	8b 40 0c             	mov    0xc(%eax),%eax
8010565d:	83 f8 04             	cmp    $0x4,%eax
80105660:	75 0d                	jne    8010566f <sched+0x61>
    panic("sched running");
80105662:	83 ec 0c             	sub    $0xc,%esp
80105665:	68 73 a6 10 80       	push   $0x8010a673
8010566a:	e8 f7 ae ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010566f:	e8 5b f1 ff ff       	call   801047cf <readeflags>
80105674:	25 00 02 00 00       	and    $0x200,%eax
80105679:	85 c0                	test   %eax,%eax
8010567b:	74 0d                	je     8010568a <sched+0x7c>
    panic("sched interruptible");
8010567d:	83 ec 0c             	sub    $0xc,%esp
80105680:	68 81 a6 10 80       	push   $0x8010a681
80105685:	e8 dc ae ff ff       	call   80100566 <panic>
  intena = cpu->intena;
8010568a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105690:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105696:	89 45 f4             	mov    %eax,-0xc(%ebp)
#ifdef CS333_P2
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
80105699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010569f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056a6:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801056ac:	8b 1d 20 79 11 80    	mov    0x80117920,%ebx
801056b2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056b9:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801056bf:	29 d3                	sub    %edx,%ebx
801056c1:	89 da                	mov    %ebx,%edx
801056c3:	01 ca                	add    %ecx,%edx
801056c5:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
#endif
  swtch(&proc->context, cpu->scheduler);
801056cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056d1:	8b 40 04             	mov    0x4(%eax),%eax
801056d4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056db:	83 c2 1c             	add    $0x1c,%edx
801056de:	83 ec 08             	sub    $0x8,%esp
801056e1:	50                   	push   %eax
801056e2:	52                   	push   %edx
801056e3:	e8 8b 16 00 00       	call   80106d73 <swtch>
801056e8:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801056eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056f4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801056fa:	90                   	nop
801056fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056fe:	c9                   	leave  
801056ff:	c3                   	ret    

80105700 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105706:	83 ec 0c             	sub    $0xc,%esp
80105709:	68 a0 49 11 80       	push   $0x801149a0
8010570e:	e8 89 11 00 00       	call   8010689c <acquire>
80105713:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4 //from running to ready
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
80105716:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010571c:	83 ec 08             	sub    $0x8,%esp
8010571f:	50                   	push   %eax
80105720:	68 fc 70 11 80       	push   $0x801170fc
80105725:	e8 c6 09 00 00       	call   801060f0 <removeFromStateList>
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	85 c0                	test   %eax,%eax
8010572f:	75 0d                	jne    8010573e <yield+0x3e>
      panic("Failed Yield Remove From Running");
80105731:	83 ec 0c             	sub    $0xc,%esp
80105734:	68 98 a6 10 80       	push   $0x8010a698
80105739:	e8 28 ae ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
8010573e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	6a 04                	push   $0x4
80105749:	50                   	push   %eax
8010574a:	e8 45 0a 00 00       	call   80106194 <assertState>
8010574f:	83 c4 10             	add    $0x10,%esp
  if(checkForDemotion(proc) == 0)
80105752:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	50                   	push   %eax
8010575c:	e8 f3 0d 00 00       	call   80106554 <checkForDemotion>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	75 0d                	jne    80105775 <yield+0x75>
      panic("FAILED DEMOTION YIELD");
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	68 b9 a6 10 80       	push   $0x8010a6b9
80105770:	e8 f1 ad ff ff       	call   80100566 <panic>
  if(addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) == 0)
80105775:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010577b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105782:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105788:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010578e:	c1 e2 02             	shl    $0x2,%edx
80105791:	81 c2 a0 49 11 80    	add    $0x801149a0,%edx
80105797:	83 c2 04             	add    $0x4,%edx
8010579a:	83 ec 08             	sub    $0x8,%esp
8010579d:	50                   	push   %eax
8010579e:	52                   	push   %edx
8010579f:	e8 11 0a 00 00       	call   801061b5 <addToStateListEnd>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	75 0d                	jne    801057b8 <yield+0xb8>
      panic("Failed Yield Add To Ready");
801057ab:	83 ec 0c             	sub    $0xc,%esp
801057ae:	68 cf a6 10 80       	push   $0x8010a6cf
801057b3:	e8 ae ad ff ff       	call   80100566 <panic>
#endif
  proc->state = RUNNABLE;
801057b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801057c5:	e8 44 fe ff ff       	call   8010560e <sched>
  release(&ptable.lock);
801057ca:	83 ec 0c             	sub    $0xc,%esp
801057cd:	68 a0 49 11 80       	push   $0x801149a0
801057d2:	e8 2c 11 00 00       	call   80106903 <release>
801057d7:	83 c4 10             	add    $0x10,%esp
}
801057da:	90                   	nop
801057db:	c9                   	leave  
801057dc:	c3                   	ret    

801057dd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801057dd:	55                   	push   %ebp
801057de:	89 e5                	mov    %esp,%ebp
801057e0:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801057e3:	83 ec 0c             	sub    $0xc,%esp
801057e6:	68 a0 49 11 80       	push   $0x801149a0
801057eb:	e8 13 11 00 00       	call   80106903 <release>
801057f0:	83 c4 10             	add    $0x10,%esp

  if (first) {
801057f3:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801057f8:	85 c0                	test   %eax,%eax
801057fa:	74 24                	je     80105820 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801057fc:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105803:	00 00 00 
    iinit(ROOTDEV);
80105806:	83 ec 0c             	sub    $0xc,%esp
80105809:	6a 01                	push   $0x1
8010580b:	e8 24 c1 ff ff       	call   80101934 <iinit>
80105810:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105813:	83 ec 0c             	sub    $0xc,%esp
80105816:	6a 01                	push   $0x1
80105818:	e8 9c de ff ff       	call   801036b9 <initlog>
8010581d:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105820:	90                   	nop
80105821:	c9                   	leave  
80105822:	c3                   	ret    

80105823 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105823:	55                   	push   %ebp
80105824:	89 e5                	mov    %esp,%ebp
80105826:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105829:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582f:	85 c0                	test   %eax,%eax
80105831:	75 0d                	jne    80105840 <sleep+0x1d>
    panic("sleep");
80105833:	83 ec 0c             	sub    $0xc,%esp
80105836:	68 e9 a6 10 80       	push   $0x8010a6e9
8010583b:	e8 26 ad ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105840:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105847:	74 24                	je     8010586d <sleep+0x4a>
    acquire(&ptable.lock);
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	68 a0 49 11 80       	push   $0x801149a0
80105851:	e8 46 10 00 00       	call   8010689c <acquire>
80105856:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105859:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010585d:	74 0e                	je     8010586d <sleep+0x4a>
8010585f:	83 ec 0c             	sub    $0xc,%esp
80105862:	ff 75 0c             	pushl  0xc(%ebp)
80105865:	e8 99 10 00 00       	call   80106903 <release>
8010586a:	83 c4 10             	add    $0x10,%esp
  }

#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
8010586d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105873:	83 ec 08             	sub    $0x8,%esp
80105876:	50                   	push   %eax
80105877:	68 fc 70 11 80       	push   $0x801170fc
8010587c:	e8 6f 08 00 00       	call   801060f0 <removeFromStateList>
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	85 c0                	test   %eax,%eax
80105886:	75 0d                	jne    80105895 <sleep+0x72>
      panic("Failed In Sleep To Remove From Running");
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	68 f0 a6 10 80       	push   $0x8010a6f0
80105890:	e8 d1 ac ff ff       	call   80100566 <panic>
  assertState(proc, RUNNING);
80105895:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	6a 04                	push   $0x4
801058a0:	50                   	push   %eax
801058a1:	e8 ee 08 00 00       	call   80106194 <assertState>
801058a6:	83 c4 10             	add    $0x10,%esp
  if(addToStateListHead(&ptable.pLists.sleep, proc) == 0)
801058a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058af:	83 ec 08             	sub    $0x8,%esp
801058b2:	50                   	push   %eax
801058b3:	68 f4 70 11 80       	push   $0x801170f4
801058b8:	e8 61 09 00 00       	call   8010621e <addToStateListHead>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	75 0d                	jne    801058d1 <sleep+0xae>
      panic("Failed In Sleep To Add To Sleep");
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	68 18 a7 10 80       	push   $0x8010a718
801058cc:	e8 95 ac ff ff       	call   80100566 <panic>
  
  //proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
  if(checkForDemotion(proc) == 0)
801058d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	50                   	push   %eax
801058db:	e8 74 0c 00 00       	call   80106554 <checkForDemotion>
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	85 c0                	test   %eax,%eax
801058e5:	75 0d                	jne    801058f4 <sleep+0xd1>
      panic("FAILED DEMOTION SLEEP");  
801058e7:	83 ec 0c             	sub    $0xc,%esp
801058ea:	68 38 a7 10 80       	push   $0x8010a738
801058ef:	e8 72 ac ff ff       	call   80100566 <panic>
#endif
  // Go to sleep.
  proc->chan = chan;
801058f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058fa:	8b 55 08             	mov    0x8(%ebp),%edx
801058fd:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80105900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105906:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010590d:	e8 fc fc ff ff       	call   8010560e <sched>

  // Tidy up.
  proc->chan = 0;
80105912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105918:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
8010591f:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105926:	74 24                	je     8010594c <sleep+0x129>
    release(&ptable.lock);
80105928:	83 ec 0c             	sub    $0xc,%esp
8010592b:	68 a0 49 11 80       	push   $0x801149a0
80105930:	e8 ce 0f 00 00       	call   80106903 <release>
80105935:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105938:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010593c:	74 0e                	je     8010594c <sleep+0x129>
8010593e:	83 ec 0c             	sub    $0xc,%esp
80105941:	ff 75 0c             	pushl  0xc(%ebp)
80105944:	e8 53 0f 00 00       	call   8010689c <acquire>
80105949:	83 c4 10             	add    $0x10,%esp
  }
}
8010594c:	90                   	nop
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    

8010594f <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
8010594f:	55                   	push   %ebp
80105950:	89 e5                	mov    %esp,%ebp
80105952:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  struct proc * found;

  current = ptable.pLists.sleep;
80105955:	a1 f4 70 11 80       	mov    0x801170f4,%eax
8010595a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(current)
8010595d:	e9 a4 00 00 00       	jmp    80105a06 <wakeup1+0xb7>
  {
      if(current->chan == chan)
80105962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105965:	8b 40 20             	mov    0x20(%eax),%eax
80105968:	3b 45 08             	cmp    0x8(%ebp),%eax
8010596b:	0f 85 89 00 00 00    	jne    801059fa <wakeup1+0xab>
      {
          found = current;
80105971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105974:	89 45 f0             	mov    %eax,-0x10(%ebp)
          current = current->next;
80105977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105980:	89 45 f4             	mov    %eax,-0xc(%ebp)
          if(removeFromStateList(&ptable.pLists.sleep, found) == 0)
80105983:	83 ec 08             	sub    $0x8,%esp
80105986:	ff 75 f0             	pushl  -0x10(%ebp)
80105989:	68 f4 70 11 80       	push   $0x801170f4
8010598e:	e8 5d 07 00 00       	call   801060f0 <removeFromStateList>
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	75 0d                	jne    801059a7 <wakeup1+0x58>
              panic("Failed Wakeup Remove From Sleep");
8010599a:	83 ec 0c             	sub    $0xc,%esp
8010599d:	68 50 a7 10 80       	push   $0x8010a750
801059a2:	e8 bf ab ff ff       	call   80100566 <panic>
          assertState(found, SLEEPING);
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	6a 02                	push   $0x2
801059ac:	ff 75 f0             	pushl  -0x10(%ebp)
801059af:	e8 e0 07 00 00       	call   80106194 <assertState>
801059b4:	83 c4 10             	add    $0x10,%esp
          found->state = RUNNABLE;
801059b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          if(addToStateListEnd(&ptable.pLists.ready[found->priority], found) == 0)
801059c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801059ca:	05 cc 09 00 00       	add    $0x9cc,%eax
801059cf:	c1 e0 02             	shl    $0x2,%eax
801059d2:	05 a0 49 11 80       	add    $0x801149a0,%eax
801059d7:	83 c0 04             	add    $0x4,%eax
801059da:	83 ec 08             	sub    $0x8,%esp
801059dd:	ff 75 f0             	pushl  -0x10(%ebp)
801059e0:	50                   	push   %eax
801059e1:	e8 cf 07 00 00       	call   801061b5 <addToStateListEnd>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	75 19                	jne    80105a06 <wakeup1+0xb7>
              panic("Failed Wakeup Add To Ready");
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	68 70 a7 10 80       	push   $0x8010a770
801059f5:	e8 6c ab ff ff       	call   80100566 <panic>
      }
      else
          current = current->next;
801059fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc * current;
  struct proc * found;

  current = ptable.pLists.sleep;
  while(current)
80105a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a0a:	0f 85 52 ff ff ff    	jne    80105962 <wakeup1+0x13>
              panic("Failed Wakeup Add To Ready");
      }
      else
          current = current->next;
  }
}
80105a10:	90                   	nop
80105a11:	c9                   	leave  
80105a12:	c3                   	ret    

80105a13 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105a13:	55                   	push   %ebp
80105a14:	89 e5                	mov    %esp,%ebp
80105a16:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105a19:	83 ec 0c             	sub    $0xc,%esp
80105a1c:	68 a0 49 11 80       	push   $0x801149a0
80105a21:	e8 76 0e 00 00       	call   8010689c <acquire>
80105a26:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	ff 75 08             	pushl  0x8(%ebp)
80105a2f:	e8 1b ff ff ff       	call   8010594f <wakeup1>
80105a34:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105a37:	83 ec 0c             	sub    $0xc,%esp
80105a3a:	68 a0 49 11 80       	push   $0x801149a0
80105a3f:	e8 bf 0e 00 00       	call   80106903 <release>
80105a44:	83 c4 10             	add    $0x10,%esp
}
80105a47:	90                   	nop
80105a48:	c9                   	leave  
80105a49:	c3                   	ret    

80105a4a <kill>:
  return -1;
}
#else
int
kill(int pid)
{
80105a4a:	55                   	push   %ebp
80105a4b:	89 e5                	mov    %esp,%ebp
80105a4d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint priority = 0;
80105a50:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  acquire(&ptable.lock);
80105a57:	83 ec 0c             	sub    $0xc,%esp
80105a5a:	68 a0 49 11 80       	push   $0x801149a0
80105a5f:	e8 38 0e 00 00       	call   8010689c <acquire>
80105a64:	83 c4 10             	add    $0x10,%esp

  //check ready
  //we need to modify this to check every ready list
  for(int i = 0; i <= MAX; ++i)
80105a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105a6e:	eb 5b                	jmp    80105acb <kill+0x81>
  {
      p = ptable.pLists.ready[i];
80105a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a73:	05 cc 09 00 00       	add    $0x9cc,%eax
80105a78:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80105a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while(p)
80105a82:	eb 3d                	jmp    80105ac1 <kill+0x77>
      {
          if(p->pid == pid)
80105a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a87:	8b 50 10             	mov    0x10(%eax),%edx
80105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8d:	39 c2                	cmp    %eax,%edx
80105a8f:	75 24                	jne    80105ab5 <kill+0x6b>
          {          
              p->killed = 1;
80105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a94:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
              release(&ptable.lock);
80105a9b:	83 ec 0c             	sub    $0xc,%esp
80105a9e:	68 a0 49 11 80       	push   $0x801149a0
80105aa3:	e8 5b 0e 00 00       	call   80106903 <release>
80105aa8:	83 c4 10             	add    $0x10,%esp
              return 0;
80105aab:	b8 00 00 00 00       	mov    $0x0,%eax
80105ab0:	e9 9d 01 00 00       	jmp    80105c52 <kill+0x208>
          }
          p = p->next;
80105ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //check ready
  //we need to modify this to check every ready list
  for(int i = 0; i <= MAX; ++i)
  {
      p = ptable.pLists.ready[i];
      while(p)
80105ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ac5:	75 bd                	jne    80105a84 <kill+0x3a>
  uint priority = 0;
  acquire(&ptable.lock);

  //check ready
  //we need to modify this to check every ready list
  for(int i = 0; i <= MAX; ++i)
80105ac7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105acb:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
80105acf:	7e 9f                	jle    80105a70 <kill+0x26>
          }
          p = p->next;
      }
  }

  p = ptable.pLists.running;
80105ad1:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80105ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105ad9:	eb 3d                	jmp    80105b18 <kill+0xce>
  {
      if(p->pid == pid)
80105adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ade:	8b 50 10             	mov    0x10(%eax),%edx
80105ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae4:	39 c2                	cmp    %eax,%edx
80105ae6:	75 24                	jne    80105b0c <kill+0xc2>
      {          
          p->killed = 1;
80105ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aeb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          release(&ptable.lock);
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	68 a0 49 11 80       	push   $0x801149a0
80105afa:	e8 04 0e 00 00       	call   80106903 <release>
80105aff:	83 c4 10             	add    $0x10,%esp
          return 0;
80105b02:	b8 00 00 00 00       	mov    $0x0,%eax
80105b07:	e9 46 01 00 00       	jmp    80105c52 <kill+0x208>
      }
      p = p->next;
80105b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
          p = p->next;
      }
  }

  p = ptable.pLists.running;
  while(p)
80105b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b1c:	75 bd                	jne    80105adb <kill+0x91>
          return 0;
      }
      p = p->next;
  }
  
  p = ptable.pLists.embryo;
80105b1e:	a1 00 71 11 80       	mov    0x80117100,%eax
80105b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105b26:	eb 3d                	jmp    80105b65 <kill+0x11b>
  {
      if(p->pid == pid)
80105b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2b:	8b 50 10             	mov    0x10(%eax),%edx
80105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80105b31:	39 c2                	cmp    %eax,%edx
80105b33:	75 24                	jne    80105b59 <kill+0x10f>
      {          
          p->killed = 1;
80105b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b38:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          release(&ptable.lock);
80105b3f:	83 ec 0c             	sub    $0xc,%esp
80105b42:	68 a0 49 11 80       	push   $0x801149a0
80105b47:	e8 b7 0d 00 00       	call   80106903 <release>
80105b4c:	83 c4 10             	add    $0x10,%esp
          return 0;
80105b4f:	b8 00 00 00 00       	mov    $0x0,%eax
80105b54:	e9 f9 00 00 00       	jmp    80105c52 <kill+0x208>
      }
      p = p->next;
80105b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
      }
      p = p->next;
  }
  
  p = ptable.pLists.embryo;
  while(p)
80105b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b69:	75 bd                	jne    80105b28 <kill+0xde>
      }
      p = p->next;
  }

  //check sleep
  p = ptable.pLists.sleep;
80105b6b:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80105b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105b73:	e9 bb 00 00 00       	jmp    80105c33 <kill+0x1e9>
  {
      if(p->pid == pid)
80105b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7b:	8b 50 10             	mov    0x10(%eax),%edx
80105b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80105b81:	39 c2                	cmp    %eax,%edx
80105b83:	0f 85 9e 00 00 00    	jne    80105c27 <kill+0x1dd>
      {
          p->killed = 1;
80105b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          if(removeFromStateList(&ptable.pLists.sleep, p) == 0)
80105b93:	83 ec 08             	sub    $0x8,%esp
80105b96:	ff 75 f4             	pushl  -0xc(%ebp)
80105b99:	68 f4 70 11 80       	push   $0x801170f4
80105b9e:	e8 4d 05 00 00       	call   801060f0 <removeFromStateList>
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	75 0d                	jne    80105bb7 <kill+0x16d>
              panic("kill sleep");
80105baa:	83 ec 0c             	sub    $0xc,%esp
80105bad:	68 8b a7 10 80       	push   $0x8010a78b
80105bb2:	e8 af a9 ff ff       	call   80100566 <panic>
          assertState(p, SLEEPING);
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	6a 02                	push   $0x2
80105bbc:	ff 75 f4             	pushl  -0xc(%ebp)
80105bbf:	e8 d0 05 00 00       	call   80106194 <assertState>
80105bc4:	83 c4 10             	add    $0x10,%esp
          p->state = RUNNABLE;
80105bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bca:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          priority = p->priority;
80105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
          if(addToStateListEnd(&ptable.pLists.ready[priority], p) == 0)
80105bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105be0:	05 cc 09 00 00       	add    $0x9cc,%eax
80105be5:	c1 e0 02             	shl    $0x2,%eax
80105be8:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105bed:	83 c0 04             	add    $0x4,%eax
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf6:	50                   	push   %eax
80105bf7:	e8 b9 05 00 00       	call   801061b5 <addToStateListEnd>
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	85 c0                	test   %eax,%eax
80105c01:	75 0d                	jne    80105c10 <kill+0x1c6>
              panic("kill ready");
80105c03:	83 ec 0c             	sub    $0xc,%esp
80105c06:	68 96 a7 10 80       	push   $0x8010a796
80105c0b:	e8 56 a9 ff ff       	call   80100566 <panic>
          release(&ptable.lock);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	68 a0 49 11 80       	push   $0x801149a0
80105c18:	e8 e6 0c 00 00       	call   80106903 <release>
80105c1d:	83 c4 10             	add    $0x10,%esp
          return 0;
80105c20:	b8 00 00 00 00       	mov    $0x0,%eax
80105c25:	eb 2b                	jmp    80105c52 <kill+0x208>
      }
      p = p->next;
80105c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
  }

  //check sleep
  p = ptable.pLists.sleep;
  while(p)
80105c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c37:	0f 85 3b ff ff ff    	jne    80105b78 <kill+0x12e>
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }
  release(&ptable.lock);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	68 a0 49 11 80       	push   $0x801149a0
80105c45:	e8 b9 0c 00 00       	call   80106903 <release>
80105c4a:	83 c4 10             	add    $0x10,%esp
  return -1;
80105c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c52:	c9                   	leave  
80105c53:	c3                   	ret    

80105c54 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 48             	sub    $0x48,%esp
  struct proc *p;
  char *state;
  uint pc[10];
 
#ifdef CS333_P3P4
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n");   
80105c5a:	83 ec 0c             	sub    $0xc,%esp
80105c5d:	68 cc a7 10 80       	push   $0x8010a7cc
80105c62:	e8 5f a7 ff ff       	call   801003c6 <cprintf>
80105c67:	83 c4 10             	add    $0x10,%esp
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105c6a:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105c71:	e9 cd 00 00 00       	jmp    80105d43 <procdump+0xef>
    if(p->state == UNUSED)
80105c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c79:	8b 40 0c             	mov    0xc(%eax),%eax
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	0f 84 b7 00 00 00    	je     80105d3b <procdump+0xe7>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c87:	8b 40 0c             	mov    0xc(%eax),%eax
80105c8a:	83 f8 05             	cmp    $0x5,%eax
80105c8d:	77 23                	ja     80105cb2 <procdump+0x5e>
80105c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c92:	8b 40 0c             	mov    0xc(%eax),%eax
80105c95:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c9c:	85 c0                	test   %eax,%eax
80105c9e:	74 12                	je     80105cb2 <procdump+0x5e>
      state = states[p->state];
80105ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca3:	8b 40 0c             	mov    0xc(%eax),%eax
80105ca6:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105cb0:	eb 07                	jmp    80105cb9 <procdump+0x65>
    else
      state = "???";
80105cb2:	c7 45 ec 05 a8 10 80 	movl   $0x8010a805,-0x14(%ebp)
#ifdef CS333_P3P4
    printproc(p, state);
80105cb9:	83 ec 08             	sub    $0x8,%esp
80105cbc:	ff 75 ec             	pushl  -0x14(%ebp)
80105cbf:	ff 75 f0             	pushl  -0x10(%ebp)
80105cc2:	e8 8c 00 00 00       	call   80105d53 <printproc>
80105cc7:	83 c4 10             	add    $0x10,%esp
#else
    cprintf("%d %s %s", p->pid, state, p->name);
#endif

    if(p->state == SLEEPING){
80105cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccd:	8b 40 0c             	mov    0xc(%eax),%eax
80105cd0:	83 f8 02             	cmp    $0x2,%eax
80105cd3:	75 54                	jne    80105d29 <procdump+0xd5>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd8:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cdb:	8b 40 0c             	mov    0xc(%eax),%eax
80105cde:	83 c0 08             	add    $0x8,%eax
80105ce1:	89 c2                	mov    %eax,%edx
80105ce3:	83 ec 08             	sub    $0x8,%esp
80105ce6:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	52                   	push   %edx
80105ceb:	e8 65 0c 00 00       	call   80106955 <getcallerpcs>
80105cf0:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105cf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105cfa:	eb 1c                	jmp    80105d18 <procdump+0xc4>
        cprintf(" %p", pc[i]);
80105cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cff:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105d03:	83 ec 08             	sub    $0x8,%esp
80105d06:	50                   	push   %eax
80105d07:	68 09 a8 10 80       	push   $0x8010a809
80105d0c:	e8 b5 a6 ff ff       	call   801003c6 <cprintf>
80105d11:	83 c4 10             	add    $0x10,%esp
    cprintf("%d %s %s", p->pid, state, p->name);
#endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105d14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d18:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105d1c:	7f 0b                	jg     80105d29 <procdump+0xd5>
80105d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d21:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105d25:	85 c0                	test   %eax,%eax
80105d27:	75 d3                	jne    80105cfc <procdump+0xa8>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105d29:	83 ec 0c             	sub    $0xc,%esp
80105d2c:	68 0d a8 10 80       	push   $0x8010a80d
80105d31:	e8 90 a6 ff ff       	call   801003c6 <cprintf>
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	eb 01                	jmp    80105d3c <procdump+0xe8>
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n");   
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105d3b:	90                   	nop
 
#ifdef CS333_P3P4
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n");   
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d3c:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105d43:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105d4a:	0f 82 26 ff ff ff    	jb     80105c76 <procdump+0x22>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105d50:	90                   	nop
80105d51:	c9                   	leave  
80105d52:	c3                   	ret    

80105d53 <printproc>:


#ifdef CS333_P3P4
static void
printproc(struct proc *p, char * state)
{
80105d53:	55                   	push   %ebp
80105d54:	89 e5                	mov    %esp,%ebp
80105d56:	56                   	push   %esi
80105d57:	53                   	push   %ebx
80105d58:	83 ec 10             	sub    $0x10,%esp
    uint ppid;
    if(p->pid == 1)
80105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d5e:	8b 40 10             	mov    0x10(%eax),%eax
80105d61:	83 f8 01             	cmp    $0x1,%eax
80105d64:	75 09                	jne    80105d6f <printproc+0x1c>
        ppid = 1;
80105d66:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80105d6d:	eb 0c                	jmp    80105d7b <printproc+0x28>
    else
        ppid = p->parent->pid;
80105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105d72:	8b 40 14             	mov    0x14(%eax),%eax
80105d75:	8b 40 10             	mov    0x10(%eax),%eax
80105d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid, p->priority);
80105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7e:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
80105d84:	8b 45 08             	mov    0x8(%ebp),%eax
80105d87:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80105d90:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105d96:	8b 45 08             	mov    0x8(%ebp),%eax
80105d99:	8d 70 6c             	lea    0x6c(%eax),%esi
80105d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80105d9f:	8b 40 10             	mov    0x10(%eax),%eax
80105da2:	83 ec 04             	sub    $0x4,%esp
80105da5:	53                   	push   %ebx
80105da6:	ff 75 f4             	pushl  -0xc(%ebp)
80105da9:	51                   	push   %ecx
80105daa:	52                   	push   %edx
80105dab:	56                   	push   %esi
80105dac:	50                   	push   %eax
80105dad:	68 0f a8 10 80       	push   $0x8010a80f
80105db2:	e8 0f a6 ff ff       	call   801003c6 <cprintf>
80105db7:	83 c4 20             	add    $0x20,%esp
    tickasfloat(ticks - p->start_ticks);
80105dba:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80105dc3:	8b 40 7c             	mov    0x7c(%eax),%eax
80105dc6:	29 c2                	sub    %eax,%edx
80105dc8:	89 d0                	mov    %edx,%eax
80105dca:	83 ec 0c             	sub    $0xc,%esp
80105dcd:	50                   	push   %eax
80105dce:	e8 39 00 00 00       	call   80105e0c <tickasfloat>
80105dd3:	83 c4 10             	add    $0x10,%esp
    tickasfloat(p->cpu_ticks_total);
80105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd9:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	50                   	push   %eax
80105de3:	e8 24 00 00 00       	call   80105e0c <tickasfloat>
80105de8:	83 c4 10             	add    $0x10,%esp
    cprintf("%s\t%d\t", state, p->sz);
80105deb:	8b 45 08             	mov    0x8(%ebp),%eax
80105dee:	8b 00                	mov    (%eax),%eax
80105df0:	83 ec 04             	sub    $0x4,%esp
80105df3:	50                   	push   %eax
80105df4:	ff 75 0c             	pushl  0xc(%ebp)
80105df7:	68 22 a8 10 80       	push   $0x8010a822
80105dfc:	e8 c5 a5 ff ff       	call   801003c6 <cprintf>
80105e01:	83 c4 10             	add    $0x10,%esp
}
80105e04:	90                   	nop
80105e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e08:	5b                   	pop    %ebx
80105e09:	5e                   	pop    %esi
80105e0a:	5d                   	pop    %ebp
80105e0b:	c3                   	ret    

80105e0c <tickasfloat>:
#endif

#ifdef CS333_P2
static void 
tickasfloat(uint tickcount)
{
80105e0c:	55                   	push   %ebp
80105e0d:	89 e5                	mov    %esp,%ebp
80105e0f:	83 ec 18             	sub    $0x18,%esp
    uint ticksl = tickcount / 1000;
80105e12:	8b 45 08             	mov    0x8(%ebp),%eax
80105e15:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105e1a:	f7 e2                	mul    %edx
80105e1c:	89 d0                	mov    %edx,%eax
80105e1e:	c1 e8 06             	shr    $0x6,%eax
80105e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ticksr = tickcount % 1000;
80105e24:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e27:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105e2c:	89 c8                	mov    %ecx,%eax
80105e2e:	f7 e2                	mul    %edx
80105e30:	89 d0                	mov    %edx,%eax
80105e32:	c1 e8 06             	shr    $0x6,%eax
80105e35:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105e3b:	29 c1                	sub    %eax,%ecx
80105e3d:	89 c8                	mov    %ecx,%eax
80105e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cprintf("%d.", ticksl);
80105e42:	83 ec 08             	sub    $0x8,%esp
80105e45:	ff 75 f4             	pushl  -0xc(%ebp)
80105e48:	68 29 a8 10 80       	push   $0x8010a829
80105e4d:	e8 74 a5 ff ff       	call   801003c6 <cprintf>
80105e52:	83 c4 10             	add    $0x10,%esp
    if(ticksr < 10) //pad zeroes
80105e55:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
80105e59:	77 16                	ja     80105e71 <tickasfloat+0x65>
       cprintf("%d%d%d\t", 0, 0, ticksr);
80105e5b:	ff 75 f0             	pushl  -0x10(%ebp)
80105e5e:	6a 00                	push   $0x0
80105e60:	6a 00                	push   $0x0
80105e62:	68 2d a8 10 80       	push   $0x8010a82d
80105e67:	e8 5a a5 ff ff       	call   801003c6 <cprintf>
80105e6c:	83 c4 10             	add    $0x10,%esp
    else if(ticksr < 100)
        cprintf("%d%d\t", 0, ticksr);
    else
        cprintf("%d\t", ticksr);

}
80105e6f:	eb 30                	jmp    80105ea1 <tickasfloat+0x95>
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    cprintf("%d.", ticksl);
    if(ticksr < 10) //pad zeroes
       cprintf("%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
80105e71:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
80105e75:	77 17                	ja     80105e8e <tickasfloat+0x82>
        cprintf("%d%d\t", 0, ticksr);
80105e77:	83 ec 04             	sub    $0x4,%esp
80105e7a:	ff 75 f0             	pushl  -0x10(%ebp)
80105e7d:	6a 00                	push   $0x0
80105e7f:	68 35 a8 10 80       	push   $0x8010a835
80105e84:	e8 3d a5 ff ff       	call   801003c6 <cprintf>
80105e89:	83 c4 10             	add    $0x10,%esp
    else
        cprintf("%d\t", ticksr);

}
80105e8c:	eb 13                	jmp    80105ea1 <tickasfloat+0x95>
    if(ticksr < 10) //pad zeroes
       cprintf("%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        cprintf("%d%d\t", 0, ticksr);
    else
        cprintf("%d\t", ticksr);
80105e8e:	83 ec 08             	sub    $0x8,%esp
80105e91:	ff 75 f0             	pushl  -0x10(%ebp)
80105e94:	68 3b a8 10 80       	push   $0x8010a83b
80105e99:	e8 28 a5 ff ff       	call   801003c6 <cprintf>
80105e9e:	83 c4 10             	add    $0x10,%esp

}
80105ea1:	90                   	nop
80105ea2:	c9                   	leave  
80105ea3:	c3                   	ret    

80105ea4 <getprocdata>:

int 
getprocdata(uint max, struct uproc *utable)
{
80105ea4:	55                   	push   %ebp
80105ea5:	89 e5                	mov    %esp,%ebp
80105ea7:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc * p;
    
    acquire(&ptable.lock);
80105eb1:	83 ec 0c             	sub    $0xc,%esp
80105eb4:	68 a0 49 11 80       	push   $0x801149a0
80105eb9:	e8 de 09 00 00       	call   8010689c <acquire>
80105ebe:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; i < max && p < &ptable.proc[NPROC]; p++)
80105ec1:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105ec8:	e9 b9 01 00 00       	jmp    80106086 <getprocdata+0x1e2>
    {
        if(p->state != UNUSED && p->state != EMBRYO)
80105ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed0:	8b 40 0c             	mov    0xc(%eax),%eax
80105ed3:	85 c0                	test   %eax,%eax
80105ed5:	0f 84 a4 01 00 00    	je     8010607f <getprocdata+0x1db>
80105edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ede:	8b 40 0c             	mov    0xc(%eax),%eax
80105ee1:	83 f8 01             	cmp    $0x1,%eax
80105ee4:	0f 84 95 01 00 00    	je     8010607f <getprocdata+0x1db>
        {
            utable[i].pid             = p->pid;
80105eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eed:	89 d0                	mov    %edx,%eax
80105eef:	01 c0                	add    %eax,%eax
80105ef1:	01 d0                	add    %edx,%eax
80105ef3:	c1 e0 05             	shl    $0x5,%eax
80105ef6:	89 c2                	mov    %eax,%edx
80105ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105efb:	01 c2                	add    %eax,%edx
80105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f00:	8b 40 10             	mov    0x10(%eax),%eax
80105f03:	89 02                	mov    %eax,(%edx)
            utable[i].uid             = p->uid;
80105f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f08:	89 d0                	mov    %edx,%eax
80105f0a:	01 c0                	add    %eax,%eax
80105f0c:	01 d0                	add    %edx,%eax
80105f0e:	c1 e0 05             	shl    $0x5,%eax
80105f11:	89 c2                	mov    %eax,%edx
80105f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f16:	01 c2                	add    %eax,%edx
80105f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105f21:	89 42 04             	mov    %eax,0x4(%edx)
            utable[i].gid             = p->gid;
80105f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f27:	89 d0                	mov    %edx,%eax
80105f29:	01 c0                	add    %eax,%eax
80105f2b:	01 d0                	add    %edx,%eax
80105f2d:	c1 e0 05             	shl    $0x5,%eax
80105f30:	89 c2                	mov    %eax,%edx
80105f32:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f35:	01 c2                	add    %eax,%edx
80105f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105f40:	89 42 08             	mov    %eax,0x8(%edx)
            if(p->pid == 1)
80105f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f46:	8b 40 10             	mov    0x10(%eax),%eax
80105f49:	83 f8 01             	cmp    $0x1,%eax
80105f4c:	75 1c                	jne    80105f6a <getprocdata+0xc6>
                utable[i].ppid        = 1;
80105f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f51:	89 d0                	mov    %edx,%eax
80105f53:	01 c0                	add    %eax,%eax
80105f55:	01 d0                	add    %edx,%eax
80105f57:	c1 e0 05             	shl    $0x5,%eax
80105f5a:	89 c2                	mov    %eax,%edx
80105f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f5f:	01 d0                	add    %edx,%eax
80105f61:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105f68:	eb 1f                	jmp    80105f89 <getprocdata+0xe5>
            else
                utable[i].ppid        = p->parent->pid;
80105f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f6d:	89 d0                	mov    %edx,%eax
80105f6f:	01 c0                	add    %eax,%eax
80105f71:	01 d0                	add    %edx,%eax
80105f73:	c1 e0 05             	shl    $0x5,%eax
80105f76:	89 c2                	mov    %eax,%edx
80105f78:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f7b:	01 c2                	add    %eax,%edx
80105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f80:	8b 40 14             	mov    0x14(%eax),%eax
80105f83:	8b 40 10             	mov    0x10(%eax),%eax
80105f86:	89 42 0c             	mov    %eax,0xc(%edx)
            utable[i].elapsed_ticks   = ticks - p->start_ticks;
80105f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f8c:	89 d0                	mov    %edx,%eax
80105f8e:	01 c0                	add    %eax,%eax
80105f90:	01 d0                	add    %edx,%eax
80105f92:	c1 e0 05             	shl    $0x5,%eax
80105f95:	89 c2                	mov    %eax,%edx
80105f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f9a:	01 c2                	add    %eax,%edx
80105f9c:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa5:	8b 40 7c             	mov    0x7c(%eax),%eax
80105fa8:	29 c1                	sub    %eax,%ecx
80105faa:	89 c8                	mov    %ecx,%eax
80105fac:	89 42 10             	mov    %eax,0x10(%edx)
            utable[i].CPU_total_ticks = p->cpu_ticks_total;
80105faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fb2:	89 d0                	mov    %edx,%eax
80105fb4:	01 c0                	add    %eax,%eax
80105fb6:	01 d0                	add    %edx,%eax
80105fb8:	c1 e0 05             	shl    $0x5,%eax
80105fbb:	89 c2                	mov    %eax,%edx
80105fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc0:	01 c2                	add    %eax,%edx
80105fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc5:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105fcb:	89 42 14             	mov    %eax,0x14(%edx)
            utable[i].size            = p->sz;
80105fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd1:	89 d0                	mov    %edx,%eax
80105fd3:	01 c0                	add    %eax,%eax
80105fd5:	01 d0                	add    %edx,%eax
80105fd7:	c1 e0 05             	shl    $0x5,%eax
80105fda:	89 c2                	mov    %eax,%edx
80105fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fdf:	01 c2                	add    %eax,%edx
80105fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe4:	8b 00                	mov    (%eax),%eax
80105fe6:	89 42 38             	mov    %eax,0x38(%edx)
#ifdef CS333_P3P4
            utable[i].priority          = p->priority;
80105fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fec:	89 d0                	mov    %edx,%eax
80105fee:	01 c0                	add    %eax,%eax
80105ff0:	01 d0                	add    %edx,%eax
80105ff2:	c1 e0 05             	shl    $0x5,%eax
80105ff5:	89 c2                	mov    %eax,%edx
80105ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ffa:	01 c2                	add    %eax,%edx
80105ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fff:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106005:	89 42 5c             	mov    %eax,0x5c(%edx)
#endif
            if(strncpy(utable[i].state, states[p->state], sizeof(states[p->state])+1) == 0)
80106008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600b:	8b 40 0c             	mov    0xc(%eax),%eax
8010600e:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80106015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106018:	89 d0                	mov    %edx,%eax
8010601a:	01 c0                	add    %eax,%eax
8010601c:	01 d0                	add    %edx,%eax
8010601e:	c1 e0 05             	shl    $0x5,%eax
80106021:	89 c2                	mov    %eax,%edx
80106023:	8b 45 0c             	mov    0xc(%ebp),%eax
80106026:	01 d0                	add    %edx,%eax
80106028:	83 c0 18             	add    $0x18,%eax
8010602b:	83 ec 04             	sub    $0x4,%esp
8010602e:	6a 05                	push   $0x5
80106030:	51                   	push   %ecx
80106031:	50                   	push   %eax
80106032:	e8 73 0c 00 00       	call   80106caa <strncpy>
80106037:	83 c4 10             	add    $0x10,%esp
8010603a:	85 c0                	test   %eax,%eax
8010603c:	75 07                	jne    80106045 <getprocdata+0x1a1>
                return -1;
8010603e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106043:	eb 69                	jmp    801060ae <getprocdata+0x20a>
            if(strncpy(utable[i].name, p->name, sizeof(p->name)+1) == 0)
80106045:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106048:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010604b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010604e:	89 d0                	mov    %edx,%eax
80106050:	01 c0                	add    %eax,%eax
80106052:	01 d0                	add    %edx,%eax
80106054:	c1 e0 05             	shl    $0x5,%eax
80106057:	89 c2                	mov    %eax,%edx
80106059:	8b 45 0c             	mov    0xc(%ebp),%eax
8010605c:	01 d0                	add    %edx,%eax
8010605e:	83 c0 3c             	add    $0x3c,%eax
80106061:	83 ec 04             	sub    $0x4,%esp
80106064:	6a 11                	push   $0x11
80106066:	51                   	push   %ecx
80106067:	50                   	push   %eax
80106068:	e8 3d 0c 00 00       	call   80106caa <strncpy>
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	85 c0                	test   %eax,%eax
80106072:	75 07                	jne    8010607b <getprocdata+0x1d7>
                return -1;
80106074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106079:	eb 33                	jmp    801060ae <getprocdata+0x20a>
            ++i;
8010607b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
    int i = 0;
    struct proc * p;
    
    acquire(&ptable.lock);
    for(p = ptable.proc; i < max && p < &ptable.proc[NPROC]; p++)
8010607f:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80106086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106089:	3b 45 08             	cmp    0x8(%ebp),%eax
8010608c:	73 0d                	jae    8010609b <getprocdata+0x1f7>
8010608e:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80106095:	0f 82 32 fe ff ff    	jb     80105ecd <getprocdata+0x29>
                return -1;
            ++i;
        }
    }
    
    release(&ptable.lock);    
8010609b:	83 ec 0c             	sub    $0xc,%esp
8010609e:	68 a0 49 11 80       	push   $0x801149a0
801060a3:	e8 5b 08 00 00       	call   80106903 <release>
801060a8:	83 c4 10             	add    $0x10,%esp

    return i;
801060ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801060ae:	c9                   	leave  
801060af:	c3                   	ret    

801060b0 <removeFromStateListHead>:
#endif

#ifdef CS333_P3P4
static struct proc *
removeFromStateListHead(struct proc ** sList)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 10             	sub    $0x10,%esp
    struct proc * p;
    if(!(*sList))
801060b6:	8b 45 08             	mov    0x8(%ebp),%eax
801060b9:	8b 00                	mov    (%eax),%eax
801060bb:	85 c0                	test   %eax,%eax
801060bd:	75 07                	jne    801060c6 <removeFromStateListHead+0x16>
        return 0;
801060bf:	b8 00 00 00 00       	mov    $0x0,%eax
801060c4:	eb 28                	jmp    801060ee <removeFromStateListHead+0x3e>

    p = *sList;
801060c6:	8b 45 08             	mov    0x8(%ebp),%eax
801060c9:	8b 00                	mov    (%eax),%eax
801060cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    *sList = (*sList)->next;
801060ce:	8b 45 08             	mov    0x8(%ebp),%eax
801060d1:	8b 00                	mov    (%eax),%eax
801060d3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801060d9:	8b 45 08             	mov    0x8(%ebp),%eax
801060dc:	89 10                	mov    %edx,(%eax)
    p->next = 0;
801060de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060e1:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060e8:	00 00 00 

    return p;
801060eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801060ee:	c9                   	leave  
801060ef:	c3                   	ret    

801060f0 <removeFromStateList>:

static int 
removeFromStateList(struct proc ** sList, struct proc * p)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;
    struct proc * prev = 0;
801060f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(!(*sList))
801060fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106100:	8b 00                	mov    (%eax),%eax
80106102:	85 c0                	test   %eax,%eax
80106104:	75 0a                	jne    80106110 <removeFromStateList+0x20>
        return 0;
80106106:	b8 00 00 00 00       	mov    $0x0,%eax
8010610b:	e9 82 00 00 00       	jmp    80106192 <removeFromStateList+0xa2>

    current = *sList;
80106110:	8b 45 08             	mov    0x8(%ebp),%eax
80106113:	8b 00                	mov    (%eax),%eax
80106115:	89 45 fc             	mov    %eax,-0x4(%ebp)
    //search list for p
    while(current->next && (p != current)) 
80106118:	eb 12                	jmp    8010612c <removeFromStateList+0x3c>
    {
        prev = current;
8010611a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010611d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        current = current->next;
80106120:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106123:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106129:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(!(*sList))
        return 0;

    current = *sList;
    //search list for p
    while(current->next && (p != current)) 
8010612c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010612f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106135:	85 c0                	test   %eax,%eax
80106137:	74 08                	je     80106141 <removeFromStateList+0x51>
80106139:	8b 45 0c             	mov    0xc(%ebp),%eax
8010613c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010613f:	75 d9                	jne    8010611a <removeFromStateList+0x2a>
    {
        prev = current;
        current = current->next;
    }

    if(p->pid == current->pid)
80106141:	8b 45 0c             	mov    0xc(%ebp),%eax
80106144:	8b 50 10             	mov    0x10(%eax),%edx
80106147:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010614a:	8b 40 10             	mov    0x10(%eax),%eax
8010614d:	39 c2                	cmp    %eax,%edx
8010614f:	75 3c                	jne    8010618d <removeFromStateList+0x9d>
    {
        if(prev) //middle of list
80106151:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80106155:	74 14                	je     8010616b <removeFromStateList+0x7b>
            prev->next = current->next;
80106157:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010615a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106160:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106163:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
80106169:	eb 0e                	jmp    80106179 <removeFromStateList+0x89>
        else //head of list
            *sList = current->next;
8010616b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010616e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106174:	8b 45 08             	mov    0x8(%ebp),%eax
80106177:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80106179:	8b 45 0c             	mov    0xc(%ebp),%eax
8010617c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106183:	00 00 00 
        return -1;
80106186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010618b:	eb 05                	jmp    80106192 <removeFromStateList+0xa2>
    }

    //p not in list
    return 0;
8010618d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106192:	c9                   	leave  
80106193:	c3                   	ret    

80106194 <assertState>:

static void 
assertState(struct proc * p, enum procstate state)
{
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	83 ec 08             	sub    $0x8,%esp
    if(p->state != state)
8010619a:	8b 45 08             	mov    0x8(%ebp),%eax
8010619d:	8b 40 0c             	mov    0xc(%eax),%eax
801061a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801061a3:	74 0d                	je     801061b2 <assertState+0x1e>
        panic("Process has invalid state for transition!");
801061a5:	83 ec 0c             	sub    $0xc,%esp
801061a8:	68 40 a8 10 80       	push   $0x8010a840
801061ad:	e8 b4 a3 ff ff       	call   80100566 <panic>
}
801061b2:	90                   	nop
801061b3:	c9                   	leave  
801061b4:	c3                   	ret    

801061b5 <addToStateListEnd>:

static int 
addToStateListEnd(struct proc ** sList, struct proc * p)
{
801061b5:	55                   	push   %ebp
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(!p)
801061bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801061bf:	75 07                	jne    801061c8 <addToStateListEnd+0x13>
        return 0;
801061c1:	b8 00 00 00 00       	mov    $0x0,%eax
801061c6:	eb 54                	jmp    8010621c <addToStateListEnd+0x67>

    p->next = 0;
801061c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801061cb:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801061d2:	00 00 00 
    if(!(*sList))
801061d5:	8b 45 08             	mov    0x8(%ebp),%eax
801061d8:	8b 00                	mov    (%eax),%eax
801061da:	85 c0                	test   %eax,%eax
801061dc:	75 0a                	jne    801061e8 <addToStateListEnd+0x33>
        *sList = p;
801061de:	8b 45 08             	mov    0x8(%ebp),%eax
801061e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801061e4:	89 10                	mov    %edx,(%eax)
801061e6:	eb 2f                	jmp    80106217 <addToStateListEnd+0x62>
    else
    {
        current = *sList;
801061e8:	8b 45 08             	mov    0x8(%ebp),%eax
801061eb:	8b 00                	mov    (%eax),%eax
801061ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current->next)
801061f0:	eb 0c                	jmp    801061fe <addToStateListEnd+0x49>
            current = current->next;
801061f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061f5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(!(*sList))
        *sList = p;
    else
    {
        current = *sList;
        while(current->next)
801061fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106201:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106207:	85 c0                	test   %eax,%eax
80106209:	75 e7                	jne    801061f2 <addToStateListEnd+0x3d>
            current = current->next;

        current->next = p;
8010620b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010620e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106211:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    }
    
    return -1;
80106217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010621c:	c9                   	leave  
8010621d:	c3                   	ret    

8010621e <addToStateListHead>:

static int 
addToStateListHead(struct proc ** sList, struct proc * p)
{
8010621e:	55                   	push   %ebp
8010621f:	89 e5                	mov    %esp,%ebp
    if(p)
80106221:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106225:	74 1d                	je     80106244 <addToStateListHead+0x26>
    {
        p->next = *sList;
80106227:	8b 45 08             	mov    0x8(%ebp),%eax
8010622a:	8b 10                	mov    (%eax),%edx
8010622c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010622f:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        *sList = p;
80106235:	8b 45 08             	mov    0x8(%ebp),%eax
80106238:	8b 55 0c             	mov    0xc(%ebp),%edx
8010623b:	89 10                	mov    %edx,(%eax)
        return -1;
8010623d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106242:	eb 05                	jmp    80106249 <addToStateListHead+0x2b>
    }
    else
        return 0;
80106244:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106249:	5d                   	pop    %ebp
8010624a:	c3                   	ret    

8010624b <exitSearch>:

static void
exitSearch(struct proc * sList)
{
8010624b:	55                   	push   %ebp
8010624c:	89 e5                	mov    %esp,%ebp
8010624e:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(sList)
80106251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106255:	74 36                	je     8010628d <exitSearch+0x42>
    {
        current = sList;
80106257:	8b 45 08             	mov    0x8(%ebp),%eax
8010625a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current)
8010625d:	eb 28                	jmp    80106287 <exitSearch+0x3c>
        {
            if(current->parent == proc)
8010625f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106262:	8b 50 14             	mov    0x14(%eax),%edx
80106265:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010626b:	39 c2                	cmp    %eax,%edx
8010626d:	75 0c                	jne    8010627b <exitSearch+0x30>
                current->parent = initproc;
8010626f:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80106275:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106278:	89 50 14             	mov    %edx,0x14(%eax)
            current = current->next;
8010627b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010627e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106284:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
80106287:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010628b:	75 d2                	jne    8010625f <exitSearch+0x14>
            if(current->parent == proc)
                current->parent = initproc;
            current = current->next;
        }
    }
}
8010628d:	90                   	nop
8010628e:	c9                   	leave  
8010628f:	c3                   	ret    

80106290 <waitSearch>:

static int 
waitSearch(struct proc * sList)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;

    if(sList)
80106296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010629a:	74 31                	je     801062cd <waitSearch+0x3d>
    {
        current = sList;
8010629c:	8b 45 08             	mov    0x8(%ebp),%eax
8010629f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while(current)
801062a2:	eb 23                	jmp    801062c7 <waitSearch+0x37>
        {
            if(current->parent == proc)
801062a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062a7:	8b 50 14             	mov    0x14(%eax),%edx
801062aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062b0:	39 c2                	cmp    %eax,%edx
801062b2:	75 07                	jne    801062bb <waitSearch+0x2b>
                return 1;
801062b4:	b8 01 00 00 00       	mov    $0x1,%eax
801062b9:	eb 17                	jmp    801062d2 <waitSearch+0x42>
            current = current->next;
801062bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062be:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
801062c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801062cb:	75 d7                	jne    801062a4 <waitSearch+0x14>
                return 1;
            current = current->next;
        }
    }

    return 0;
801062cd:	b8 00 00 00 00       	mov    $0x0,%eax
    
}
801062d2:	c9                   	leave  
801062d3:	c3                   	ret    

801062d4 <ctrlprint>:

static void 
ctrlprint(struct proc * sList)
{
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	83 ec 18             	sub    $0x18,%esp
    struct proc * current;
    if(sList)
801062da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801062de:	74 59                	je     80106339 <ctrlprint+0x65>
    {
        current = sList;
801062e0:	8b 45 08             	mov    0x8(%ebp),%eax
801062e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(current)
801062e6:	eb 49                	jmp    80106331 <ctrlprint+0x5d>
        {
            if(current->next)
801062e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062eb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062f1:	85 c0                	test   %eax,%eax
801062f3:	74 19                	je     8010630e <ctrlprint+0x3a>
                cprintf("%d -> ", current->pid);
801062f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f8:	8b 40 10             	mov    0x10(%eax),%eax
801062fb:	83 ec 08             	sub    $0x8,%esp
801062fe:	50                   	push   %eax
801062ff:	68 6a a8 10 80       	push   $0x8010a86a
80106304:	e8 bd a0 ff ff       	call   801003c6 <cprintf>
80106309:	83 c4 10             	add    $0x10,%esp
8010630c:	eb 17                	jmp    80106325 <ctrlprint+0x51>
            else
                cprintf("%d\n", current->pid);
8010630e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106311:	8b 40 10             	mov    0x10(%eax),%eax
80106314:	83 ec 08             	sub    $0x8,%esp
80106317:	50                   	push   %eax
80106318:	68 71 a8 10 80       	push   $0x8010a871
8010631d:	e8 a4 a0 ff ff       	call   801003c6 <cprintf>
80106322:	83 c4 10             	add    $0x10,%esp
            current = current->next;
80106325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106328:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010632e:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
    struct proc * current;
    if(sList)
    {
        current = sList;
        while(current)
80106331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106335:	75 b1                	jne    801062e8 <ctrlprint+0x14>
            else
                cprintf("%d\n", current->pid);
            current = current->next;
        }

        return;
80106337:	eb 10                	jmp    80106349 <ctrlprint+0x75>

    }

    cprintf("Empty List\n");
80106339:	83 ec 0c             	sub    $0xc,%esp
8010633c:	68 75 a8 10 80       	push   $0x8010a875
80106341:	e8 80 a0 ff ff       	call   801003c6 <cprintf>
80106346:	83 c4 10             	add    $0x10,%esp
}
80106349:	c9                   	leave  
8010634a:	c3                   	ret    

8010634b <printsleep>:

void
printsleep(void)
{
8010634b:	55                   	push   %ebp
8010634c:	89 e5                	mov    %esp,%ebp
8010634e:	83 ec 08             	sub    $0x8,%esp
    cprintf("Sleep List Processes:\n");
80106351:	83 ec 0c             	sub    $0xc,%esp
80106354:	68 81 a8 10 80       	push   $0x8010a881
80106359:	e8 68 a0 ff ff       	call   801003c6 <cprintf>
8010635e:	83 c4 10             	add    $0x10,%esp
    ctrlprint(ptable.pLists.sleep);
80106361:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80106366:	83 ec 0c             	sub    $0xc,%esp
80106369:	50                   	push   %eax
8010636a:	e8 65 ff ff ff       	call   801062d4 <ctrlprint>
8010636f:	83 c4 10             	add    $0x10,%esp
}
80106372:	90                   	nop
80106373:	c9                   	leave  
80106374:	c3                   	ret    

80106375 <printfree>:

void
printfree(void)
{
80106375:	55                   	push   %ebp
80106376:	89 e5                	mov    %esp,%ebp
80106378:	83 ec 18             	sub    $0x18,%esp
    int count = 0;
8010637b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc * current = ptable.pLists.free;
80106382:	a1 f0 70 11 80       	mov    0x801170f0,%eax
80106387:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cprintf("Free List Size: ");
8010638a:	83 ec 0c             	sub    $0xc,%esp
8010638d:	68 98 a8 10 80       	push   $0x8010a898
80106392:	e8 2f a0 ff ff       	call   801003c6 <cprintf>
80106397:	83 c4 10             	add    $0x10,%esp

    while(current)
8010639a:	eb 10                	jmp    801063ac <printfree+0x37>
    {
        ++count;
8010639c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        current = current->next;
801063a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801063a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
    int count = 0;
    struct proc * current = ptable.pLists.free;
    cprintf("Free List Size: ");

    while(current)
801063ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063b0:	75 ea                	jne    8010639c <printfree+0x27>
    {
        ++count;
        current = current->next;
    }

    cprintf("%d processes\n", count);
801063b2:	83 ec 08             	sub    $0x8,%esp
801063b5:	ff 75 f4             	pushl  -0xc(%ebp)
801063b8:	68 a9 a8 10 80       	push   $0x8010a8a9
801063bd:	e8 04 a0 ff ff       	call   801003c6 <cprintf>
801063c2:	83 c4 10             	add    $0x10,%esp
}
801063c5:	90                   	nop
801063c6:	c9                   	leave  
801063c7:	c3                   	ret    

801063c8 <printzombie>:

void
printzombie(void)
{
801063c8:	55                   	push   %ebp
801063c9:	89 e5                	mov    %esp,%ebp
801063cb:	83 ec 18             	sub    $0x18,%esp
    struct proc * current = ptable.pLists.zombie;
801063ce:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801063d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint ppid;

    cprintf("Zombie List:\n");
801063d6:	83 ec 0c             	sub    $0xc,%esp
801063d9:	68 b7 a8 10 80       	push   $0x8010a8b7
801063de:	e8 e3 9f ff ff       	call   801003c6 <cprintf>
801063e3:	83 c4 10             	add    $0x10,%esp
    if(!current)
801063e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063ea:	0f 85 9d 00 00 00    	jne    8010648d <printzombie+0xc5>
        cprintf("Empty List\n");
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 75 a8 10 80       	push   $0x8010a875
801063f8:	e8 c9 9f ff ff       	call   801003c6 <cprintf>
801063fd:	83 c4 10             	add    $0x10,%esp

    while(current)
80106400:	e9 88 00 00 00       	jmp    8010648d <printzombie+0xc5>
    {
        if(current->pid == 1)
80106405:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106408:	8b 40 10             	mov    0x10(%eax),%eax
8010640b:	83 f8 01             	cmp    $0x1,%eax
8010640e:	75 09                	jne    80106419 <printzombie+0x51>
            ppid = 1;
80106410:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80106417:	eb 1f                	jmp    80106438 <printzombie+0x70>
        else if(current->parent)
80106419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641c:	8b 40 14             	mov    0x14(%eax),%eax
8010641f:	85 c0                	test   %eax,%eax
80106421:	74 0e                	je     80106431 <printzombie+0x69>
            ppid = current->parent->pid;
80106423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106426:	8b 40 14             	mov    0x14(%eax),%eax
80106429:	8b 40 10             	mov    0x10(%eax),%eax
8010642c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010642f:	eb 07                	jmp    80106438 <printzombie+0x70>
        else
            ppid = 0;
80106431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

        cprintf("(%d, %d)", current->pid, ppid);
80106438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643b:	8b 40 10             	mov    0x10(%eax),%eax
8010643e:	83 ec 04             	sub    $0x4,%esp
80106441:	ff 75 f0             	pushl  -0x10(%ebp)
80106444:	50                   	push   %eax
80106445:	68 c5 a8 10 80       	push   $0x8010a8c5
8010644a:	e8 77 9f ff ff       	call   801003c6 <cprintf>
8010644f:	83 c4 10             	add    $0x10,%esp

        if(current->next)
80106452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106455:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010645b:	85 c0                	test   %eax,%eax
8010645d:	74 12                	je     80106471 <printzombie+0xa9>
            cprintf(" -> ");
8010645f:	83 ec 0c             	sub    $0xc,%esp
80106462:	68 ce a8 10 80       	push   $0x8010a8ce
80106467:	e8 5a 9f ff ff       	call   801003c6 <cprintf>
8010646c:	83 c4 10             	add    $0x10,%esp
8010646f:	eb 10                	jmp    80106481 <printzombie+0xb9>
        else
            cprintf("\n");
80106471:	83 ec 0c             	sub    $0xc,%esp
80106474:	68 0d a8 10 80       	push   $0x8010a80d
80106479:	e8 48 9f ff ff       	call   801003c6 <cprintf>
8010647e:	83 c4 10             	add    $0x10,%esp

        current = current->next;
80106481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106484:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010648a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    cprintf("Zombie List:\n");
    if(!current)
        cprintf("Empty List\n");

    while(current)
8010648d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106491:	0f 85 6e ff ff ff    	jne    80106405 <printzombie+0x3d>
        else
            cprintf("\n");

        current = current->next;
    }
}
80106497:	90                   	nop
80106498:	c9                   	leave  
80106499:	c3                   	ret    

8010649a <printready>:

void
printready(void)
{
8010649a:	55                   	push   %ebp
8010649b:	89 e5                	mov    %esp,%ebp
8010649d:	83 ec 18             	sub    $0x18,%esp
    struct proc * current;

    cprintf("Ready Lists\n");
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	68 d3 a8 10 80       	push   $0x8010a8d3
801064a8:	e8 19 9f ff ff       	call   801003c6 <cprintf>
801064ad:	83 c4 10             	add    $0x10,%esp

    for(int i = 0; i <= MAX; ++i) 
801064b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801064b7:	e9 8b 00 00 00       	jmp    80106547 <printready+0xad>
    {
        cprintf("%d: ", i);
801064bc:	83 ec 08             	sub    $0x8,%esp
801064bf:	ff 75 f0             	pushl  -0x10(%ebp)
801064c2:	68 e0 a8 10 80       	push   $0x8010a8e0
801064c7:	e8 fa 9e ff ff       	call   801003c6 <cprintf>
801064cc:	83 c4 10             	add    $0x10,%esp
        current = ptable.pLists.ready[i];
801064cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d2:	05 cc 09 00 00       	add    $0x9cc,%eax
801064d7:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
801064de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(current)
801064e1:	eb 4a                	jmp    8010652d <printready+0x93>
        {
            cprintf("(%d, %d)", current->pid, current->budget);
801064e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e6:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801064ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ef:	8b 40 10             	mov    0x10(%eax),%eax
801064f2:	83 ec 04             	sub    $0x4,%esp
801064f5:	52                   	push   %edx
801064f6:	50                   	push   %eax
801064f7:	68 c5 a8 10 80       	push   $0x8010a8c5
801064fc:	e8 c5 9e ff ff       	call   801003c6 <cprintf>
80106501:	83 c4 10             	add    $0x10,%esp
            if(current->next)
80106504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106507:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010650d:	85 c0                	test   %eax,%eax
8010650f:	74 10                	je     80106521 <printready+0x87>
                cprintf(" -> ");
80106511:	83 ec 0c             	sub    $0xc,%esp
80106514:	68 ce a8 10 80       	push   $0x8010a8ce
80106519:	e8 a8 9e ff ff       	call   801003c6 <cprintf>
8010651e:	83 c4 10             	add    $0x10,%esp
            current = current->next;
80106521:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106524:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010652a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    for(int i = 0; i <= MAX; ++i) 
    {
        cprintf("%d: ", i);
        current = ptable.pLists.ready[i];
        while(current)
8010652d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106531:	75 b0                	jne    801064e3 <printready+0x49>
            cprintf("(%d, %d)", current->pid, current->budget);
            if(current->next)
                cprintf(" -> ");
            current = current->next;
        }
        cprintf("\n");
80106533:	83 ec 0c             	sub    $0xc,%esp
80106536:	68 0d a8 10 80       	push   $0x8010a80d
8010653b:	e8 86 9e ff ff       	call   801003c6 <cprintf>
80106540:	83 c4 10             	add    $0x10,%esp
{
    struct proc * current;

    cprintf("Ready Lists\n");

    for(int i = 0; i <= MAX; ++i) 
80106543:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106547:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
8010654b:	0f 8e 6b ff ff ff    	jle    801064bc <printready+0x22>
                cprintf(" -> ");
            current = current->next;
        }
        cprintf("\n");
    }
}
80106551:	90                   	nop
80106552:	c9                   	leave  
80106553:	c3                   	ret    

80106554 <checkForDemotion>:

int 
checkForDemotion(struct proc * p)
{
80106554:	55                   	push   %ebp
80106555:	89 e5                	mov    %esp,%ebp
80106557:	53                   	push   %ebx
    if(!p) return 0;        
80106558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010655c:	75 0a                	jne    80106568 <checkForDemotion+0x14>
8010655e:	b8 00 00 00 00       	mov    $0x0,%eax
80106563:	e9 86 00 00 00       	jmp    801065ee <checkForDemotion+0x9a>

    proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
80106568:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010656e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106575:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010657b:	89 d3                	mov    %edx,%ebx
8010657d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106584:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010658a:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80106590:	29 d1                	sub    %edx,%ecx
80106592:	89 ca                	mov    %ecx,%edx
80106594:	01 da                	add    %ebx,%edx
80106596:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if(proc->budget <= 0)
8010659c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801065a8:	85 c0                	test   %eax,%eax
801065aa:	7f 3d                	jg     801065e9 <checkForDemotion+0x95>
    {
/*        procdump();
        cprintf("DEMOTION TEST FOR PID = %d\n", proc->pid);
        cprintf("priority old: %d, budget old = %d\n", proc->priority, proc->budget);
*/        
        proc->budget = BUDGET_NEW;
801065ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b2:	c7 80 98 00 00 00 f4 	movl   $0x1f4,0x98(%eax)
801065b9:	01 00 00 
        if(proc->priority < MAX)
801065bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065c2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065c8:	83 f8 05             	cmp    $0x5,%eax
801065cb:	77 1c                	ja     801065e9 <checkForDemotion+0x95>
            proc->priority = proc->priority + 1;
801065cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065d3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801065da:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
801065e0:	83 c2 01             	add    $0x1,%edx
801065e3:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

//        cprintf("priority new: %d, budget new = %d\n", proc->priority, proc->budget);
//        procdump();
    }
    return -1; 
801065e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065ee:	5b                   	pop    %ebx
801065ef:	5d                   	pop    %ebp
801065f0:	c3                   	ret    

801065f1 <bumpPriority>:

void 
bumpPriority(struct proc * sList)
{
801065f1:	55                   	push   %ebp
801065f2:	89 e5                	mov    %esp,%ebp
801065f4:	83 ec 10             	sub    $0x10,%esp
    if(!sList) return;
801065f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801065fb:	74 4b                	je     80106648 <bumpPriority+0x57>

    struct proc *current = sList;
801065fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106600:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(current)
80106603:	eb 3b                	jmp    80106640 <bumpPriority+0x4f>
    {
        if (current->priority > 0)
80106605:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106608:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010660e:	85 c0                	test   %eax,%eax
80106610:	74 22                	je     80106634 <bumpPriority+0x43>
        {           
            --current->priority;        
80106612:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106615:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010661b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010661e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106621:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            current->budget = BUDGET_NEW;
80106627:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010662a:	c7 80 98 00 00 00 f4 	movl   $0x1f4,0x98(%eax)
80106631:	01 00 00 
        }
        current = current->next;
80106634:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106637:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010663d:	89 45 fc             	mov    %eax,-0x4(%ebp)
bumpPriority(struct proc * sList)
{
    if(!sList) return;

    struct proc *current = sList;
    while(current)
80106640:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106644:	75 bf                	jne    80106605 <bumpPriority+0x14>
80106646:	eb 01                	jmp    80106649 <bumpPriority+0x58>
}

void 
bumpPriority(struct proc * sList)
{
    if(!sList) return;
80106648:	90                   	nop
            --current->priority;        
            current->budget = BUDGET_NEW;
        }
        current = current->next;
    }
}
80106649:	c9                   	leave  
8010664a:	c3                   	ret    

8010664b <findProcSetPrio>:

static int
findProcSetPrio(uint pid, struct proc * sList, uint prio)
{
8010664b:	55                   	push   %ebp
8010664c:	89 e5                	mov    %esp,%ebp
8010664e:	83 ec 10             	sub    $0x10,%esp
    struct proc * curr = sList;
80106651:	8b 45 0c             	mov    0xc(%ebp),%eax
80106654:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while(curr)
80106657:	eb 2a                	jmp    80106683 <findProcSetPrio+0x38>
    {
        if(curr->pid == pid)
80106659:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010665c:	8b 40 10             	mov    0x10(%eax),%eax
8010665f:	3b 45 08             	cmp    0x8(%ebp),%eax
80106662:	75 13                	jne    80106677 <findProcSetPrio+0x2c>
        {
            curr->priority = prio;
80106664:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106667:	8b 55 10             	mov    0x10(%ebp),%edx
8010666a:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            return -1;
80106670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106675:	eb 17                	jmp    8010668e <findProcSetPrio+0x43>
        }
        curr = curr->next;
80106677:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010667a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106680:	89 45 fc             	mov    %eax,-0x4(%ebp)
static int
findProcSetPrio(uint pid, struct proc * sList, uint prio)
{
    struct proc * curr = sList;

    while(curr)
80106683:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106687:	75 d0                	jne    80106659 <findProcSetPrio+0xe>
            return -1;
        }
        curr = curr->next;
    }

    return 0;
80106689:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010668e:	c9                   	leave  
8010668f:	c3                   	ret    

80106690 <setprocpriority>:

int
setprocpriority(uint pid, uint prio)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 18             	sub    $0x18,%esp
    struct proc * curr;
    //first we gotta find that proc
    if(findProcSetPrio(pid, ptable.pLists.running, prio) == -1)
80106696:	a1 fc 70 11 80       	mov    0x801170fc,%eax
8010669b:	ff 75 0c             	pushl  0xc(%ebp)
8010669e:	50                   	push   %eax
8010669f:	ff 75 08             	pushl  0x8(%ebp)
801066a2:	e8 a4 ff ff ff       	call   8010664b <findProcSetPrio>
801066a7:	83 c4 0c             	add    $0xc,%esp
801066aa:	83 f8 ff             	cmp    $0xffffffff,%eax
801066ad:	75 0a                	jne    801066b9 <setprocpriority+0x29>
        return 0;
801066af:	b8 00 00 00 00       	mov    $0x0,%eax
801066b4:	e9 87 01 00 00       	jmp    80106840 <setprocpriority+0x1b0>
    if(findProcSetPrio(pid, ptable.pLists.sleep, prio) == -1)
801066b9:	a1 f4 70 11 80       	mov    0x801170f4,%eax
801066be:	ff 75 0c             	pushl  0xc(%ebp)
801066c1:	50                   	push   %eax
801066c2:	ff 75 08             	pushl  0x8(%ebp)
801066c5:	e8 81 ff ff ff       	call   8010664b <findProcSetPrio>
801066ca:	83 c4 0c             	add    $0xc,%esp
801066cd:	83 f8 ff             	cmp    $0xffffffff,%eax
801066d0:	75 0a                	jne    801066dc <setprocpriority+0x4c>
        return 0;
801066d2:	b8 00 00 00 00       	mov    $0x0,%eax
801066d7:	e9 64 01 00 00       	jmp    80106840 <setprocpriority+0x1b0>

    for(int i = 0; i <= MAX; ++i)
801066dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801066e3:	e9 49 01 00 00       	jmp    80106831 <setprocpriority+0x1a1>
    {
        curr = ptable.pLists.ready[i];
801066e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066eb:	05 cc 09 00 00       	add    $0x9cc,%eax
801066f0:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
801066f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(curr)
801066fa:	e9 24 01 00 00       	jmp    80106823 <setprocpriority+0x193>
        {
            if(curr->pid == pid)
801066ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106702:	8b 40 10             	mov    0x10(%eax),%eax
80106705:	3b 45 08             	cmp    0x8(%ebp),%eax
80106708:	0f 85 09 01 00 00    	jne    80106817 <setprocpriority+0x187>
            {   
                if(!holding(&ptable.lock))
8010670e:	83 ec 0c             	sub    $0xc,%esp
80106711:	68 a0 49 11 80       	push   $0x801149a0
80106716:	e8 b4 02 00 00       	call   801069cf <holding>
8010671b:	83 c4 10             	add    $0x10,%esp
8010671e:	85 c0                	test   %eax,%eax
80106720:	75 10                	jne    80106732 <setprocpriority+0xa2>
                    acquire(&ptable.lock);
80106722:	83 ec 0c             	sub    $0xc,%esp
80106725:	68 a0 49 11 80       	push   $0x801149a0
8010672a:	e8 6d 01 00 00       	call   8010689c <acquire>
8010672f:	83 c4 10             	add    $0x10,%esp
//                printready();
                if(curr->priority != prio)
80106732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106735:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010673b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010673e:	74 76                	je     801067b6 <setprocpriority+0x126>
                {
//                    cprintf("SETTING READY PROCESS PRIORITY\n");
                    if(removeFromStateList(&ptable.pLists.ready[i], curr) == 0)
80106740:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106743:	05 cc 09 00 00       	add    $0x9cc,%eax
80106748:	c1 e0 02             	shl    $0x2,%eax
8010674b:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106750:	83 c0 04             	add    $0x4,%eax
80106753:	83 ec 08             	sub    $0x8,%esp
80106756:	ff 75 f4             	pushl  -0xc(%ebp)
80106759:	50                   	push   %eax
8010675a:	e8 91 f9 ff ff       	call   801060f0 <removeFromStateList>
8010675f:	83 c4 10             	add    $0x10,%esp
80106762:	85 c0                	test   %eax,%eax
80106764:	75 0d                	jne    80106773 <setprocpriority+0xe3>
                        panic("FAILED REMOVE SET PRIORITY");
80106766:	83 ec 0c             	sub    $0xc,%esp
80106769:	68 e5 a8 10 80       	push   $0x8010a8e5
8010676e:	e8 f3 9d ff ff       	call   80100566 <panic>
                    assertState(curr, RUNNABLE);
80106773:	83 ec 08             	sub    $0x8,%esp
80106776:	6a 03                	push   $0x3
80106778:	ff 75 f4             	pushl  -0xc(%ebp)
8010677b:	e8 14 fa ff ff       	call   80106194 <assertState>
80106780:	83 c4 10             	add    $0x10,%esp
                    if(addToStateListEnd(&ptable.pLists.ready[prio], curr) == 0)
80106783:	8b 45 0c             	mov    0xc(%ebp),%eax
80106786:	05 cc 09 00 00       	add    $0x9cc,%eax
8010678b:	c1 e0 02             	shl    $0x2,%eax
8010678e:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106793:	83 c0 04             	add    $0x4,%eax
80106796:	83 ec 08             	sub    $0x8,%esp
80106799:	ff 75 f4             	pushl  -0xc(%ebp)
8010679c:	50                   	push   %eax
8010679d:	e8 13 fa ff ff       	call   801061b5 <addToStateListEnd>
801067a2:	83 c4 10             	add    $0x10,%esp
801067a5:	85 c0                	test   %eax,%eax
801067a7:	75 0d                	jne    801067b6 <setprocpriority+0x126>
                            panic("FAILED ADD IN SET PRIORITY");
801067a9:	83 ec 0c             	sub    $0xc,%esp
801067ac:	68 00 a9 10 80       	push   $0x8010a900
801067b1:	e8 b0 9d ff ff       	call   80100566 <panic>
                }
                if(curr->priority != i)
801067b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b9:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801067bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c2:	39 c2                	cmp    %eax,%edx
801067c4:	74 0d                	je     801067d3 <setprocpriority+0x143>
                    panic("PRIORITY WRONG IN SET PRIORITY");
801067c6:	83 ec 0c             	sub    $0xc,%esp
801067c9:	68 1c a9 10 80       	push   $0x8010a91c
801067ce:	e8 93 9d ff ff       	call   80100566 <panic>
                curr->priority = prio;
801067d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801067d9:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                curr->budget = BUDGET_NEW;
801067df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e2:	c7 80 98 00 00 00 f4 	movl   $0x1f4,0x98(%eax)
801067e9:	01 00 00 
  //              printready();
                if(holding(&ptable.lock))
801067ec:	83 ec 0c             	sub    $0xc,%esp
801067ef:	68 a0 49 11 80       	push   $0x801149a0
801067f4:	e8 d6 01 00 00       	call   801069cf <holding>
801067f9:	83 c4 10             	add    $0x10,%esp
801067fc:	85 c0                	test   %eax,%eax
801067fe:	74 10                	je     80106810 <setprocpriority+0x180>
                    release(&ptable.lock);
80106800:	83 ec 0c             	sub    $0xc,%esp
80106803:	68 a0 49 11 80       	push   $0x801149a0
80106808:	e8 f6 00 00 00       	call   80106903 <release>
8010680d:	83 c4 10             	add    $0x10,%esp
                return 0;
80106810:	b8 00 00 00 00       	mov    $0x0,%eax
80106815:	eb 29                	jmp    80106840 <setprocpriority+0x1b0>
            }
            curr = curr->next;
80106817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106820:	89 45 f4             	mov    %eax,-0xc(%ebp)
        return 0;

    for(int i = 0; i <= MAX; ++i)
    {
        curr = ptable.pLists.ready[i];
        while(curr)
80106823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106827:	0f 85 d2 fe ff ff    	jne    801066ff <setprocpriority+0x6f>
    if(findProcSetPrio(pid, ptable.pLists.running, prio) == -1)
        return 0;
    if(findProcSetPrio(pid, ptable.pLists.sleep, prio) == -1)
        return 0;

    for(int i = 0; i <= MAX; ++i)
8010682d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106831:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
80106835:	0f 8e ad fe ff ff    	jle    801066e8 <setprocpriority+0x58>
            }
            curr = curr->next;
        }
    }

    return -1; //whoops, no proc found!
8010683b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106840:	c9                   	leave  
80106841:	c3                   	ret    

80106842 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106842:	55                   	push   %ebp
80106843:	89 e5                	mov    %esp,%ebp
80106845:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106848:	9c                   	pushf  
80106849:	58                   	pop    %eax
8010684a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010684d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106850:	c9                   	leave  
80106851:	c3                   	ret    

80106852 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106852:	55                   	push   %ebp
80106853:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106855:	fa                   	cli    
}
80106856:	90                   	nop
80106857:	5d                   	pop    %ebp
80106858:	c3                   	ret    

80106859 <sti>:

static inline void
sti(void)
{
80106859:	55                   	push   %ebp
8010685a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010685c:	fb                   	sti    
}
8010685d:	90                   	nop
8010685e:	5d                   	pop    %ebp
8010685f:	c3                   	ret    

80106860 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106866:	8b 55 08             	mov    0x8(%ebp),%edx
80106869:	8b 45 0c             	mov    0xc(%ebp),%eax
8010686c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010686f:	f0 87 02             	lock xchg %eax,(%edx)
80106872:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106875:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106878:	c9                   	leave  
80106879:	c3                   	ret    

8010687a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010687a:	55                   	push   %ebp
8010687b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010687d:	8b 45 08             	mov    0x8(%ebp),%eax
80106880:	8b 55 0c             	mov    0xc(%ebp),%edx
80106883:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106886:	8b 45 08             	mov    0x8(%ebp),%eax
80106889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010688f:	8b 45 08             	mov    0x8(%ebp),%eax
80106892:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106899:	90                   	nop
8010689a:	5d                   	pop    %ebp
8010689b:	c3                   	ret    

8010689c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010689c:	55                   	push   %ebp
8010689d:	89 e5                	mov    %esp,%ebp
8010689f:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801068a2:	e8 52 01 00 00       	call   801069f9 <pushcli>
  if(holding(lk))
801068a7:	8b 45 08             	mov    0x8(%ebp),%eax
801068aa:	83 ec 0c             	sub    $0xc,%esp
801068ad:	50                   	push   %eax
801068ae:	e8 1c 01 00 00       	call   801069cf <holding>
801068b3:	83 c4 10             	add    $0x10,%esp
801068b6:	85 c0                	test   %eax,%eax
801068b8:	74 0d                	je     801068c7 <acquire+0x2b>
    panic("acquire");
801068ba:	83 ec 0c             	sub    $0xc,%esp
801068bd:	68 3b a9 10 80       	push   $0x8010a93b
801068c2:	e8 9f 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801068c7:	90                   	nop
801068c8:	8b 45 08             	mov    0x8(%ebp),%eax
801068cb:	83 ec 08             	sub    $0x8,%esp
801068ce:	6a 01                	push   $0x1
801068d0:	50                   	push   %eax
801068d1:	e8 8a ff ff ff       	call   80106860 <xchg>
801068d6:	83 c4 10             	add    $0x10,%esp
801068d9:	85 c0                	test   %eax,%eax
801068db:	75 eb                	jne    801068c8 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801068dd:	8b 45 08             	mov    0x8(%ebp),%eax
801068e0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801068e7:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801068ea:	8b 45 08             	mov    0x8(%ebp),%eax
801068ed:	83 c0 0c             	add    $0xc,%eax
801068f0:	83 ec 08             	sub    $0x8,%esp
801068f3:	50                   	push   %eax
801068f4:	8d 45 08             	lea    0x8(%ebp),%eax
801068f7:	50                   	push   %eax
801068f8:	e8 58 00 00 00       	call   80106955 <getcallerpcs>
801068fd:	83 c4 10             	add    $0x10,%esp
}
80106900:	90                   	nop
80106901:	c9                   	leave  
80106902:	c3                   	ret    

80106903 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106903:	55                   	push   %ebp
80106904:	89 e5                	mov    %esp,%ebp
80106906:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80106909:	83 ec 0c             	sub    $0xc,%esp
8010690c:	ff 75 08             	pushl  0x8(%ebp)
8010690f:	e8 bb 00 00 00       	call   801069cf <holding>
80106914:	83 c4 10             	add    $0x10,%esp
80106917:	85 c0                	test   %eax,%eax
80106919:	75 0d                	jne    80106928 <release+0x25>
    panic("release");
8010691b:	83 ec 0c             	sub    $0xc,%esp
8010691e:	68 43 a9 10 80       	push   $0x8010a943
80106923:	e8 3e 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106928:	8b 45 08             	mov    0x8(%ebp),%eax
8010692b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106932:	8b 45 08             	mov    0x8(%ebp),%eax
80106935:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010693c:	8b 45 08             	mov    0x8(%ebp),%eax
8010693f:	83 ec 08             	sub    $0x8,%esp
80106942:	6a 00                	push   $0x0
80106944:	50                   	push   %eax
80106945:	e8 16 ff ff ff       	call   80106860 <xchg>
8010694a:	83 c4 10             	add    $0x10,%esp

  popcli();
8010694d:	e8 ec 00 00 00       	call   80106a3e <popcli>
}
80106952:	90                   	nop
80106953:	c9                   	leave  
80106954:	c3                   	ret    

80106955 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106955:	55                   	push   %ebp
80106956:	89 e5                	mov    %esp,%ebp
80106958:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010695b:	8b 45 08             	mov    0x8(%ebp),%eax
8010695e:	83 e8 08             	sub    $0x8,%eax
80106961:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106964:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010696b:	eb 38                	jmp    801069a5 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010696d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106971:	74 53                	je     801069c6 <getcallerpcs+0x71>
80106973:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010697a:	76 4a                	jbe    801069c6 <getcallerpcs+0x71>
8010697c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106980:	74 44                	je     801069c6 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106982:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106985:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010698c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010698f:	01 c2                	add    %eax,%edx
80106991:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106994:	8b 40 04             	mov    0x4(%eax),%eax
80106997:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106999:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010699c:	8b 00                	mov    (%eax),%eax
8010699e:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801069a1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069a5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069a9:	7e c2                	jle    8010696d <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069ab:	eb 19                	jmp    801069c6 <getcallerpcs+0x71>
    pcs[i] = 0;
801069ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ba:	01 d0                	add    %edx,%eax
801069bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069c2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069c6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069ca:	7e e1                	jle    801069ad <getcallerpcs+0x58>
    pcs[i] = 0;
}
801069cc:	90                   	nop
801069cd:	c9                   	leave  
801069ce:	c3                   	ret    

801069cf <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801069cf:	55                   	push   %ebp
801069d0:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801069d2:	8b 45 08             	mov    0x8(%ebp),%eax
801069d5:	8b 00                	mov    (%eax),%eax
801069d7:	85 c0                	test   %eax,%eax
801069d9:	74 17                	je     801069f2 <holding+0x23>
801069db:	8b 45 08             	mov    0x8(%ebp),%eax
801069de:	8b 50 08             	mov    0x8(%eax),%edx
801069e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069e7:	39 c2                	cmp    %eax,%edx
801069e9:	75 07                	jne    801069f2 <holding+0x23>
801069eb:	b8 01 00 00 00       	mov    $0x1,%eax
801069f0:	eb 05                	jmp    801069f7 <holding+0x28>
801069f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    

801069f9 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801069f9:	55                   	push   %ebp
801069fa:	89 e5                	mov    %esp,%ebp
801069fc:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801069ff:	e8 3e fe ff ff       	call   80106842 <readeflags>
80106a04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106a07:	e8 46 fe ff ff       	call   80106852 <cli>
  if(cpu->ncli++ == 0)
80106a0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a13:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106a19:	8d 48 01             	lea    0x1(%eax),%ecx
80106a1c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106a22:	85 c0                	test   %eax,%eax
80106a24:	75 15                	jne    80106a3b <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106a26:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a2f:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a35:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a3b:	90                   	nop
80106a3c:	c9                   	leave  
80106a3d:	c3                   	ret    

80106a3e <popcli>:

void
popcli(void)
{
80106a3e:	55                   	push   %ebp
80106a3f:	89 e5                	mov    %esp,%ebp
80106a41:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a44:	e8 f9 fd ff ff       	call   80106842 <readeflags>
80106a49:	25 00 02 00 00       	and    $0x200,%eax
80106a4e:	85 c0                	test   %eax,%eax
80106a50:	74 0d                	je     80106a5f <popcli+0x21>
    panic("popcli - interruptible");
80106a52:	83 ec 0c             	sub    $0xc,%esp
80106a55:	68 4b a9 10 80       	push   $0x8010a94b
80106a5a:	e8 07 9b ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a5f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a65:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a6b:	83 ea 01             	sub    $0x1,%edx
80106a6e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a74:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a7a:	85 c0                	test   %eax,%eax
80106a7c:	79 0d                	jns    80106a8b <popcli+0x4d>
    panic("popcli");
80106a7e:	83 ec 0c             	sub    $0xc,%esp
80106a81:	68 62 a9 10 80       	push   $0x8010a962
80106a86:	e8 db 9a ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106a8b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a91:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a97:	85 c0                	test   %eax,%eax
80106a99:	75 15                	jne    80106ab0 <popcli+0x72>
80106a9b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106aa1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	74 05                	je     80106ab0 <popcli+0x72>
    sti();
80106aab:	e8 a9 fd ff ff       	call   80106859 <sti>
}
80106ab0:	90                   	nop
80106ab1:	c9                   	leave  
80106ab2:	c3                   	ret    

80106ab3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106ab3:	55                   	push   %ebp
80106ab4:	89 e5                	mov    %esp,%ebp
80106ab6:	57                   	push   %edi
80106ab7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106abb:	8b 55 10             	mov    0x10(%ebp),%edx
80106abe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac1:	89 cb                	mov    %ecx,%ebx
80106ac3:	89 df                	mov    %ebx,%edi
80106ac5:	89 d1                	mov    %edx,%ecx
80106ac7:	fc                   	cld    
80106ac8:	f3 aa                	rep stos %al,%es:(%edi)
80106aca:	89 ca                	mov    %ecx,%edx
80106acc:	89 fb                	mov    %edi,%ebx
80106ace:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ad1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106ad4:	90                   	nop
80106ad5:	5b                   	pop    %ebx
80106ad6:	5f                   	pop    %edi
80106ad7:	5d                   	pop    %ebp
80106ad8:	c3                   	ret    

80106ad9 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106ad9:	55                   	push   %ebp
80106ada:	89 e5                	mov    %esp,%ebp
80106adc:	57                   	push   %edi
80106add:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106ae1:	8b 55 10             	mov    0x10(%ebp),%edx
80106ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ae7:	89 cb                	mov    %ecx,%ebx
80106ae9:	89 df                	mov    %ebx,%edi
80106aeb:	89 d1                	mov    %edx,%ecx
80106aed:	fc                   	cld    
80106aee:	f3 ab                	rep stos %eax,%es:(%edi)
80106af0:	89 ca                	mov    %ecx,%edx
80106af2:	89 fb                	mov    %edi,%ebx
80106af4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106af7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106afa:	90                   	nop
80106afb:	5b                   	pop    %ebx
80106afc:	5f                   	pop    %edi
80106afd:	5d                   	pop    %ebp
80106afe:	c3                   	ret    

80106aff <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106aff:	55                   	push   %ebp
80106b00:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106b02:	8b 45 08             	mov    0x8(%ebp),%eax
80106b05:	83 e0 03             	and    $0x3,%eax
80106b08:	85 c0                	test   %eax,%eax
80106b0a:	75 43                	jne    80106b4f <memset+0x50>
80106b0c:	8b 45 10             	mov    0x10(%ebp),%eax
80106b0f:	83 e0 03             	and    $0x3,%eax
80106b12:	85 c0                	test   %eax,%eax
80106b14:	75 39                	jne    80106b4f <memset+0x50>
    c &= 0xFF;
80106b16:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106b1d:	8b 45 10             	mov    0x10(%ebp),%eax
80106b20:	c1 e8 02             	shr    $0x2,%eax
80106b23:	89 c1                	mov    %eax,%ecx
80106b25:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b28:	c1 e0 18             	shl    $0x18,%eax
80106b2b:	89 c2                	mov    %eax,%edx
80106b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b30:	c1 e0 10             	shl    $0x10,%eax
80106b33:	09 c2                	or     %eax,%edx
80106b35:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b38:	c1 e0 08             	shl    $0x8,%eax
80106b3b:	09 d0                	or     %edx,%eax
80106b3d:	0b 45 0c             	or     0xc(%ebp),%eax
80106b40:	51                   	push   %ecx
80106b41:	50                   	push   %eax
80106b42:	ff 75 08             	pushl  0x8(%ebp)
80106b45:	e8 8f ff ff ff       	call   80106ad9 <stosl>
80106b4a:	83 c4 0c             	add    $0xc,%esp
80106b4d:	eb 12                	jmp    80106b61 <memset+0x62>
  } else
    stosb(dst, c, n);
80106b4f:	8b 45 10             	mov    0x10(%ebp),%eax
80106b52:	50                   	push   %eax
80106b53:	ff 75 0c             	pushl  0xc(%ebp)
80106b56:	ff 75 08             	pushl  0x8(%ebp)
80106b59:	e8 55 ff ff ff       	call   80106ab3 <stosb>
80106b5e:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b61:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b64:	c9                   	leave  
80106b65:	c3                   	ret    

80106b66 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b66:	55                   	push   %ebp
80106b67:	89 e5                	mov    %esp,%ebp
80106b69:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b72:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b75:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b78:	eb 30                	jmp    80106baa <memcmp+0x44>
    if(*s1 != *s2)
80106b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b7d:	0f b6 10             	movzbl (%eax),%edx
80106b80:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b83:	0f b6 00             	movzbl (%eax),%eax
80106b86:	38 c2                	cmp    %al,%dl
80106b88:	74 18                	je     80106ba2 <memcmp+0x3c>
      return *s1 - *s2;
80106b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b8d:	0f b6 00             	movzbl (%eax),%eax
80106b90:	0f b6 d0             	movzbl %al,%edx
80106b93:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b96:	0f b6 00             	movzbl (%eax),%eax
80106b99:	0f b6 c0             	movzbl %al,%eax
80106b9c:	29 c2                	sub    %eax,%edx
80106b9e:	89 d0                	mov    %edx,%eax
80106ba0:	eb 1a                	jmp    80106bbc <memcmp+0x56>
    s1++, s2++;
80106ba2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106ba6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106baa:	8b 45 10             	mov    0x10(%ebp),%eax
80106bad:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bb0:	89 55 10             	mov    %edx,0x10(%ebp)
80106bb3:	85 c0                	test   %eax,%eax
80106bb5:	75 c3                	jne    80106b7a <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bbc:	c9                   	leave  
80106bbd:	c3                   	ret    

80106bbe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106bbe:	55                   	push   %ebp
80106bbf:	89 e5                	mov    %esp,%ebp
80106bc1:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106bca:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bd3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bd6:	73 54                	jae    80106c2c <memmove+0x6e>
80106bd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bdb:	8b 45 10             	mov    0x10(%ebp),%eax
80106bde:	01 d0                	add    %edx,%eax
80106be0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106be3:	76 47                	jbe    80106c2c <memmove+0x6e>
    s += n;
80106be5:	8b 45 10             	mov    0x10(%ebp),%eax
80106be8:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106beb:	8b 45 10             	mov    0x10(%ebp),%eax
80106bee:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106bf1:	eb 13                	jmp    80106c06 <memmove+0x48>
      *--d = *--s;
80106bf3:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106bf7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bfe:	0f b6 10             	movzbl (%eax),%edx
80106c01:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c04:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106c06:	8b 45 10             	mov    0x10(%ebp),%eax
80106c09:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c0c:	89 55 10             	mov    %edx,0x10(%ebp)
80106c0f:	85 c0                	test   %eax,%eax
80106c11:	75 e0                	jne    80106bf3 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106c13:	eb 24                	jmp    80106c39 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106c15:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c18:	8d 50 01             	lea    0x1(%eax),%edx
80106c1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106c1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c21:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c24:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c27:	0f b6 12             	movzbl (%edx),%edx
80106c2a:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c2c:	8b 45 10             	mov    0x10(%ebp),%eax
80106c2f:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c32:	89 55 10             	mov    %edx,0x10(%ebp)
80106c35:	85 c0                	test   %eax,%eax
80106c37:	75 dc                	jne    80106c15 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c39:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c3c:	c9                   	leave  
80106c3d:	c3                   	ret    

80106c3e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c3e:	55                   	push   %ebp
80106c3f:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c41:	ff 75 10             	pushl  0x10(%ebp)
80106c44:	ff 75 0c             	pushl  0xc(%ebp)
80106c47:	ff 75 08             	pushl  0x8(%ebp)
80106c4a:	e8 6f ff ff ff       	call   80106bbe <memmove>
80106c4f:	83 c4 0c             	add    $0xc,%esp
}
80106c52:	c9                   	leave  
80106c53:	c3                   	ret    

80106c54 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c57:	eb 0c                	jmp    80106c65 <strncmp+0x11>
    n--, p++, q++;
80106c59:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c61:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c69:	74 1a                	je     80106c85 <strncmp+0x31>
80106c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6e:	0f b6 00             	movzbl (%eax),%eax
80106c71:	84 c0                	test   %al,%al
80106c73:	74 10                	je     80106c85 <strncmp+0x31>
80106c75:	8b 45 08             	mov    0x8(%ebp),%eax
80106c78:	0f b6 10             	movzbl (%eax),%edx
80106c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c7e:	0f b6 00             	movzbl (%eax),%eax
80106c81:	38 c2                	cmp    %al,%dl
80106c83:	74 d4                	je     80106c59 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106c85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c89:	75 07                	jne    80106c92 <strncmp+0x3e>
    return 0;
80106c8b:	b8 00 00 00 00       	mov    $0x0,%eax
80106c90:	eb 16                	jmp    80106ca8 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106c92:	8b 45 08             	mov    0x8(%ebp),%eax
80106c95:	0f b6 00             	movzbl (%eax),%eax
80106c98:	0f b6 d0             	movzbl %al,%edx
80106c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c9e:	0f b6 00             	movzbl (%eax),%eax
80106ca1:	0f b6 c0             	movzbl %al,%eax
80106ca4:	29 c2                	sub    %eax,%edx
80106ca6:	89 d0                	mov    %edx,%eax
}
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    

80106caa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106caa:	55                   	push   %ebp
80106cab:	89 e5                	mov    %esp,%ebp
80106cad:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106cb6:	90                   	nop
80106cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80106cba:	8d 50 ff             	lea    -0x1(%eax),%edx
80106cbd:	89 55 10             	mov    %edx,0x10(%ebp)
80106cc0:	85 c0                	test   %eax,%eax
80106cc2:	7e 2c                	jle    80106cf0 <strncpy+0x46>
80106cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc7:	8d 50 01             	lea    0x1(%eax),%edx
80106cca:	89 55 08             	mov    %edx,0x8(%ebp)
80106ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cd0:	8d 4a 01             	lea    0x1(%edx),%ecx
80106cd3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106cd6:	0f b6 12             	movzbl (%edx),%edx
80106cd9:	88 10                	mov    %dl,(%eax)
80106cdb:	0f b6 00             	movzbl (%eax),%eax
80106cde:	84 c0                	test   %al,%al
80106ce0:	75 d5                	jne    80106cb7 <strncpy+0xd>
    ;
  while(n-- > 0)
80106ce2:	eb 0c                	jmp    80106cf0 <strncpy+0x46>
    *s++ = 0;
80106ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce7:	8d 50 01             	lea    0x1(%eax),%edx
80106cea:	89 55 08             	mov    %edx,0x8(%ebp)
80106ced:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106cf0:	8b 45 10             	mov    0x10(%ebp),%eax
80106cf3:	8d 50 ff             	lea    -0x1(%eax),%edx
80106cf6:	89 55 10             	mov    %edx,0x10(%ebp)
80106cf9:	85 c0                	test   %eax,%eax
80106cfb:	7f e7                	jg     80106ce4 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d00:	c9                   	leave  
80106d01:	c3                   	ret    

80106d02 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106d02:	55                   	push   %ebp
80106d03:	89 e5                	mov    %esp,%ebp
80106d05:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106d08:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106d0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d12:	7f 05                	jg     80106d19 <safestrcpy+0x17>
    return os;
80106d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d17:	eb 31                	jmp    80106d4a <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106d19:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d21:	7e 1e                	jle    80106d41 <safestrcpy+0x3f>
80106d23:	8b 45 08             	mov    0x8(%ebp),%eax
80106d26:	8d 50 01             	lea    0x1(%eax),%edx
80106d29:	89 55 08             	mov    %edx,0x8(%ebp)
80106d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d2f:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d32:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d35:	0f b6 12             	movzbl (%edx),%edx
80106d38:	88 10                	mov    %dl,(%eax)
80106d3a:	0f b6 00             	movzbl (%eax),%eax
80106d3d:	84 c0                	test   %al,%al
80106d3f:	75 d8                	jne    80106d19 <safestrcpy+0x17>
    ;
  *s = 0;
80106d41:	8b 45 08             	mov    0x8(%ebp),%eax
80106d44:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d4a:	c9                   	leave  
80106d4b:	c3                   	ret    

80106d4c <strlen>:

int
strlen(const char *s)
{
80106d4c:	55                   	push   %ebp
80106d4d:	89 e5                	mov    %esp,%ebp
80106d4f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d59:	eb 04                	jmp    80106d5f <strlen+0x13>
80106d5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d62:	8b 45 08             	mov    0x8(%ebp),%eax
80106d65:	01 d0                	add    %edx,%eax
80106d67:	0f b6 00             	movzbl (%eax),%eax
80106d6a:	84 c0                	test   %al,%al
80106d6c:	75 ed                	jne    80106d5b <strlen+0xf>
    ;
  return n;
80106d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d71:	c9                   	leave  
80106d72:	c3                   	ret    

80106d73 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d7b:	55                   	push   %ebp
  pushl %ebx
80106d7c:	53                   	push   %ebx
  pushl %esi
80106d7d:	56                   	push   %esi
  pushl %edi
80106d7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d81:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106d83:	5f                   	pop    %edi
  popl %esi
80106d84:	5e                   	pop    %esi
  popl %ebx
80106d85:	5b                   	pop    %ebx
  popl %ebp
80106d86:	5d                   	pop    %ebp
  ret
80106d87:	c3                   	ret    

80106d88 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106d88:	55                   	push   %ebp
80106d89:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106d8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d91:	8b 00                	mov    (%eax),%eax
80106d93:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d96:	76 12                	jbe    80106daa <fetchint+0x22>
80106d98:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9b:	8d 50 04             	lea    0x4(%eax),%edx
80106d9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da4:	8b 00                	mov    (%eax),%eax
80106da6:	39 c2                	cmp    %eax,%edx
80106da8:	76 07                	jbe    80106db1 <fetchint+0x29>
    return -1;
80106daa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106daf:	eb 0f                	jmp    80106dc0 <fetchint+0x38>
  *ip = *(int*)(addr);
80106db1:	8b 45 08             	mov    0x8(%ebp),%eax
80106db4:	8b 10                	mov    (%eax),%edx
80106db6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106db9:	89 10                	mov    %edx,(%eax)
  return 0;
80106dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106dc0:	5d                   	pop    %ebp
80106dc1:	c3                   	ret    

80106dc2 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106dc2:	55                   	push   %ebp
80106dc3:	89 e5                	mov    %esp,%ebp
80106dc5:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106dc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dce:	8b 00                	mov    (%eax),%eax
80106dd0:	3b 45 08             	cmp    0x8(%ebp),%eax
80106dd3:	77 07                	ja     80106ddc <fetchstr+0x1a>
    return -1;
80106dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dda:	eb 46                	jmp    80106e22 <fetchstr+0x60>
  *pp = (char*)addr;
80106ddc:	8b 55 08             	mov    0x8(%ebp),%edx
80106ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de2:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106de4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dea:	8b 00                	mov    (%eax),%eax
80106dec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106def:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df2:	8b 00                	mov    (%eax),%eax
80106df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106df7:	eb 1c                	jmp    80106e15 <fetchstr+0x53>
    if(*s == 0)
80106df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dfc:	0f b6 00             	movzbl (%eax),%eax
80106dff:	84 c0                	test   %al,%al
80106e01:	75 0e                	jne    80106e11 <fetchstr+0x4f>
      return s - *pp;
80106e03:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e06:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e09:	8b 00                	mov    (%eax),%eax
80106e0b:	29 c2                	sub    %eax,%edx
80106e0d:	89 d0                	mov    %edx,%eax
80106e0f:	eb 11                	jmp    80106e22 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106e11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e18:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e1b:	72 dc                	jb     80106df9 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e22:	c9                   	leave  
80106e23:	c3                   	ret    

80106e24 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106e24:	55                   	push   %ebp
80106e25:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e2d:	8b 40 18             	mov    0x18(%eax),%eax
80106e30:	8b 40 44             	mov    0x44(%eax),%eax
80106e33:	8b 55 08             	mov    0x8(%ebp),%edx
80106e36:	c1 e2 02             	shl    $0x2,%edx
80106e39:	01 d0                	add    %edx,%eax
80106e3b:	83 c0 04             	add    $0x4,%eax
80106e3e:	ff 75 0c             	pushl  0xc(%ebp)
80106e41:	50                   	push   %eax
80106e42:	e8 41 ff ff ff       	call   80106d88 <fetchint>
80106e47:	83 c4 08             	add    $0x8,%esp
}
80106e4a:	c9                   	leave  
80106e4b:	c3                   	ret    

80106e4c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e4c:	55                   	push   %ebp
80106e4d:	89 e5                	mov    %esp,%ebp
80106e4f:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106e52:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e55:	50                   	push   %eax
80106e56:	ff 75 08             	pushl  0x8(%ebp)
80106e59:	e8 c6 ff ff ff       	call   80106e24 <argint>
80106e5e:	83 c4 08             	add    $0x8,%esp
80106e61:	85 c0                	test   %eax,%eax
80106e63:	79 07                	jns    80106e6c <argptr+0x20>
    return -1;
80106e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e6a:	eb 3b                	jmp    80106ea7 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e72:	8b 00                	mov    (%eax),%eax
80106e74:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e77:	39 d0                	cmp    %edx,%eax
80106e79:	76 16                	jbe    80106e91 <argptr+0x45>
80106e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e7e:	89 c2                	mov    %eax,%edx
80106e80:	8b 45 10             	mov    0x10(%ebp),%eax
80106e83:	01 c2                	add    %eax,%edx
80106e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e8b:	8b 00                	mov    (%eax),%eax
80106e8d:	39 c2                	cmp    %eax,%edx
80106e8f:	76 07                	jbe    80106e98 <argptr+0x4c>
    return -1;
80106e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e96:	eb 0f                	jmp    80106ea7 <argptr+0x5b>
  *pp = (char*)i;
80106e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e9b:	89 c2                	mov    %eax,%edx
80106e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ea0:	89 10                	mov    %edx,(%eax)
  return 0;
80106ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ea7:	c9                   	leave  
80106ea8:	c3                   	ret    

80106ea9 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106ea9:	55                   	push   %ebp
80106eaa:	89 e5                	mov    %esp,%ebp
80106eac:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106eaf:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106eb2:	50                   	push   %eax
80106eb3:	ff 75 08             	pushl  0x8(%ebp)
80106eb6:	e8 69 ff ff ff       	call   80106e24 <argint>
80106ebb:	83 c4 08             	add    $0x8,%esp
80106ebe:	85 c0                	test   %eax,%eax
80106ec0:	79 07                	jns    80106ec9 <argstr+0x20>
    return -1;
80106ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ec7:	eb 0f                	jmp    80106ed8 <argstr+0x2f>
  return fetchstr(addr, pp);
80106ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ecc:	ff 75 0c             	pushl  0xc(%ebp)
80106ecf:	50                   	push   %eax
80106ed0:	e8 ed fe ff ff       	call   80106dc2 <fetchstr>
80106ed5:	83 c4 08             	add    $0x8,%esp
}
80106ed8:	c9                   	leave  
80106ed9:	c3                   	ret    

80106eda <syscall>:
};
#endif    

void
syscall(void)
{
80106eda:	55                   	push   %ebp
80106edb:	89 e5                	mov    %esp,%ebp
80106edd:	53                   	push   %ebx
80106ede:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106ee1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee7:	8b 40 18             	mov    0x18(%eax),%eax
80106eea:	8b 40 1c             	mov    0x1c(%eax),%eax
80106eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ef4:	7e 30                	jle    80106f26 <syscall+0x4c>
80106ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef9:	83 f8 21             	cmp    $0x21,%eax
80106efc:	77 28                	ja     80106f26 <syscall+0x4c>
80106efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f01:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f08:	85 c0                	test   %eax,%eax
80106f0a:	74 1a                	je     80106f26 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106f0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f12:	8b 58 18             	mov    0x18(%eax),%ebx
80106f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f18:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f1f:	ff d0                	call   *%eax
80106f21:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106f24:	eb 34                	jmp    80106f5a <syscall+0x80>
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106f26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f2c:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#ifdef PRINT_SYSCALLS    
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106f35:	8b 40 10             	mov    0x10(%eax),%eax
80106f38:	ff 75 f4             	pushl  -0xc(%ebp)
80106f3b:	52                   	push   %edx
80106f3c:	50                   	push   %eax
80106f3d:	68 69 a9 10 80       	push   $0x8010a969
80106f42:	e8 7f 94 ff ff       	call   801003c6 <cprintf>
80106f47:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106f4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f50:	8b 40 18             	mov    0x18(%eax),%eax
80106f53:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106f5a:	90                   	nop
80106f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f5e:	c9                   	leave  
80106f5f:	c3                   	ret    

80106f60 <sys_chmod>:
#include "fcntl.h"

#ifdef CS333_P5
int
sys_chmod(void)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 18             	sub    $0x18,%esp
    char * pathname;
    int n;

    if(argint(1, &n) < 0)
80106f66:	83 ec 08             	sub    $0x8,%esp
80106f69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f6c:	50                   	push   %eax
80106f6d:	6a 01                	push   $0x1
80106f6f:	e8 b0 fe ff ff       	call   80106e24 <argint>
80106f74:	83 c4 10             	add    $0x10,%esp
80106f77:	85 c0                	test   %eax,%eax
80106f79:	79 07                	jns    80106f82 <sys_chmod+0x22>
        return - 1;
80106f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f80:	eb 50                	jmp    80106fd2 <sys_chmod+0x72>
    if(argptr(0, (void*)&pathname, sizeof(pathname)) < 0)
80106f82:	83 ec 04             	sub    $0x4,%esp
80106f85:	6a 04                	push   $0x4
80106f87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f8a:	50                   	push   %eax
80106f8b:	6a 00                	push   $0x0
80106f8d:	e8 ba fe ff ff       	call   80106e4c <argptr>
80106f92:	83 c4 10             	add    $0x10,%esp
80106f95:	85 c0                	test   %eax,%eax
80106f97:	79 07                	jns    80106fa0 <sys_chmod+0x40>
        return -1;
80106f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f9e:	eb 32                	jmp    80106fd2 <sys_chmod+0x72>

    //if val out of range
    if(n < 0 || n > 1023  || !pathname)
80106fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fa3:	85 c0                	test   %eax,%eax
80106fa5:	78 11                	js     80106fb8 <sys_chmod+0x58>
80106fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106faa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80106faf:	7f 07                	jg     80106fb8 <sys_chmod+0x58>
80106fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fb4:	85 c0                	test   %eax,%eax
80106fb6:	75 07                	jne    80106fbf <sys_chmod+0x5f>
        return -1;
80106fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fbd:	eb 13                	jmp    80106fd2 <sys_chmod+0x72>

    //set permission bits for target specified by pathname
    return fschmod(pathname, n);
80106fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc5:	83 ec 08             	sub    $0x8,%esp
80106fc8:	52                   	push   %edx
80106fc9:	50                   	push   %eax
80106fca:	e8 c8 a4 ff ff       	call   80101497 <fschmod>
80106fcf:	83 c4 10             	add    $0x10,%esp
}
80106fd2:	c9                   	leave  
80106fd3:	c3                   	ret    

80106fd4 <sys_chown>:

int
sys_chown(void)
{
80106fd4:	55                   	push   %ebp
80106fd5:	89 e5                	mov    %esp,%ebp
80106fd7:	83 ec 18             	sub    $0x18,%esp
    char * pathname;
    int n;
    
    if(argint(1, &n) < 0)
80106fda:	83 ec 08             	sub    $0x8,%esp
80106fdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fe0:	50                   	push   %eax
80106fe1:	6a 01                	push   $0x1
80106fe3:	e8 3c fe ff ff       	call   80106e24 <argint>
80106fe8:	83 c4 10             	add    $0x10,%esp
80106feb:	85 c0                	test   %eax,%eax
80106fed:	79 07                	jns    80106ff6 <sys_chown+0x22>
        return - 1;
80106fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff4:	eb 50                	jmp    80107046 <sys_chown+0x72>
    if(argptr(0, (void*)&pathname, sizeof(pathname)) < 0)
80106ff6:	83 ec 04             	sub    $0x4,%esp
80106ff9:	6a 04                	push   $0x4
80106ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ffe:	50                   	push   %eax
80106fff:	6a 00                	push   $0x0
80107001:	e8 46 fe ff ff       	call   80106e4c <argptr>
80107006:	83 c4 10             	add    $0x10,%esp
80107009:	85 c0                	test   %eax,%eax
8010700b:	79 07                	jns    80107014 <sys_chown+0x40>
        return -1;
8010700d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107012:	eb 32                	jmp    80107046 <sys_chown+0x72>
    if(n < 1 || n > 32768 || !pathname)
80107014:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107017:	85 c0                	test   %eax,%eax
80107019:	7e 11                	jle    8010702c <sys_chown+0x58>
8010701b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010701e:	3d 00 80 00 00       	cmp    $0x8000,%eax
80107023:	7f 07                	jg     8010702c <sys_chown+0x58>
80107025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107028:	85 c0                	test   %eax,%eax
8010702a:	75 07                	jne    80107033 <sys_chown+0x5f>
        return -1;
8010702c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107031:	eb 13                	jmp    80107046 <sys_chown+0x72>

    //set uid for target specified by pathname
    return fschown(pathname, n);
80107033:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107039:	83 ec 08             	sub    $0x8,%esp
8010703c:	52                   	push   %edx
8010703d:	50                   	push   %eax
8010703e:	e8 bc a4 ff ff       	call   801014ff <fschown>
80107043:	83 c4 10             	add    $0x10,%esp
}
80107046:	c9                   	leave  
80107047:	c3                   	ret    

80107048 <sys_chgrp>:

int
sys_chgrp(void)
{
80107048:	55                   	push   %ebp
80107049:	89 e5                	mov    %esp,%ebp
8010704b:	83 ec 18             	sub    $0x18,%esp
    char * pathname;
    int n;
    if(argint(1, &n) < 0)
8010704e:	83 ec 08             	sub    $0x8,%esp
80107051:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107054:	50                   	push   %eax
80107055:	6a 01                	push   $0x1
80107057:	e8 c8 fd ff ff       	call   80106e24 <argint>
8010705c:	83 c4 10             	add    $0x10,%esp
8010705f:	85 c0                	test   %eax,%eax
80107061:	79 07                	jns    8010706a <sys_chgrp+0x22>
        return - 1;
80107063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107068:	eb 50                	jmp    801070ba <sys_chgrp+0x72>
    if(argptr(0, (void*)&pathname, sizeof(pathname)) < 0)
8010706a:	83 ec 04             	sub    $0x4,%esp
8010706d:	6a 04                	push   $0x4
8010706f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107072:	50                   	push   %eax
80107073:	6a 00                	push   $0x0
80107075:	e8 d2 fd ff ff       	call   80106e4c <argptr>
8010707a:	83 c4 10             	add    $0x10,%esp
8010707d:	85 c0                	test   %eax,%eax
8010707f:	79 07                	jns    80107088 <sys_chgrp+0x40>
        return -1;
80107081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107086:	eb 32                	jmp    801070ba <sys_chgrp+0x72>

    if(n < 1 || n > 32768 || !pathname)
80107088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010708b:	85 c0                	test   %eax,%eax
8010708d:	7e 11                	jle    801070a0 <sys_chgrp+0x58>
8010708f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107092:	3d 00 80 00 00       	cmp    $0x8000,%eax
80107097:	7f 07                	jg     801070a0 <sys_chgrp+0x58>
80107099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010709c:	85 c0                	test   %eax,%eax
8010709e:	75 07                	jne    801070a7 <sys_chgrp+0x5f>
        return -1;
801070a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070a5:	eb 13                	jmp    801070ba <sys_chgrp+0x72>

    //set gid for target specified by pathname
    return fschgrp(pathname, n);
801070a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801070aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ad:	83 ec 08             	sub    $0x8,%esp
801070b0:	52                   	push   %edx
801070b1:	50                   	push   %eax
801070b2:	e8 b3 a4 ff ff       	call   8010156a <fschgrp>
801070b7:	83 c4 10             	add    $0x10,%esp
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    

801070bc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801070bc:	55                   	push   %ebp
801070bd:	89 e5                	mov    %esp,%ebp
801070bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801070c2:	83 ec 08             	sub    $0x8,%esp
801070c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070c8:	50                   	push   %eax
801070c9:	ff 75 08             	pushl  0x8(%ebp)
801070cc:	e8 53 fd ff ff       	call   80106e24 <argint>
801070d1:	83 c4 10             	add    $0x10,%esp
801070d4:	85 c0                	test   %eax,%eax
801070d6:	79 07                	jns    801070df <argfd+0x23>
    return -1;
801070d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070dd:	eb 50                	jmp    8010712f <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801070df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070e2:	85 c0                	test   %eax,%eax
801070e4:	78 21                	js     80107107 <argfd+0x4b>
801070e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070e9:	83 f8 0f             	cmp    $0xf,%eax
801070ec:	7f 19                	jg     80107107 <argfd+0x4b>
801070ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801070f7:	83 c2 08             	add    $0x8,%edx
801070fa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801070fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107105:	75 07                	jne    8010710e <argfd+0x52>
    return -1;
80107107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710c:	eb 21                	jmp    8010712f <argfd+0x73>
  if(pfd)
8010710e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80107112:	74 08                	je     8010711c <argfd+0x60>
    *pfd = fd;
80107114:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107117:	8b 45 0c             	mov    0xc(%ebp),%eax
8010711a:	89 10                	mov    %edx,(%eax)
  if(pf)
8010711c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107120:	74 08                	je     8010712a <argfd+0x6e>
    *pf = f;
80107122:	8b 45 10             	mov    0x10(%ebp),%eax
80107125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107128:	89 10                	mov    %edx,(%eax)
  return 0;
8010712a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010712f:	c9                   	leave  
80107130:	c3                   	ret    

80107131 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80107131:	55                   	push   %ebp
80107132:	89 e5                	mov    %esp,%ebp
80107134:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80107137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010713e:	eb 30                	jmp    80107170 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80107140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107146:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107149:	83 c2 08             	add    $0x8,%edx
8010714c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80107150:	85 c0                	test   %eax,%eax
80107152:	75 18                	jne    8010716c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80107154:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010715a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010715d:	8d 4a 08             	lea    0x8(%edx),%ecx
80107160:	8b 55 08             	mov    0x8(%ebp),%edx
80107163:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80107167:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010716a:	eb 0f                	jmp    8010717b <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010716c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107170:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80107174:	7e ca                	jle    80107140 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80107176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010717b:	c9                   	leave  
8010717c:	c3                   	ret    

8010717d <sys_dup>:

int
sys_dup(void)
{
8010717d:	55                   	push   %ebp
8010717e:	89 e5                	mov    %esp,%ebp
80107180:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80107183:	83 ec 04             	sub    $0x4,%esp
80107186:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107189:	50                   	push   %eax
8010718a:	6a 00                	push   $0x0
8010718c:	6a 00                	push   $0x0
8010718e:	e8 29 ff ff ff       	call   801070bc <argfd>
80107193:	83 c4 10             	add    $0x10,%esp
80107196:	85 c0                	test   %eax,%eax
80107198:	79 07                	jns    801071a1 <sys_dup+0x24>
    return -1;
8010719a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010719f:	eb 31                	jmp    801071d2 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801071a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071a4:	83 ec 0c             	sub    $0xc,%esp
801071a7:	50                   	push   %eax
801071a8:	e8 84 ff ff ff       	call   80107131 <fdalloc>
801071ad:	83 c4 10             	add    $0x10,%esp
801071b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071b7:	79 07                	jns    801071c0 <sys_dup+0x43>
    return -1;
801071b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071be:	eb 12                	jmp    801071d2 <sys_dup+0x55>
  filedup(f);
801071c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071c3:	83 ec 0c             	sub    $0xc,%esp
801071c6:	50                   	push   %eax
801071c7:	e8 47 9f ff ff       	call   80101113 <filedup>
801071cc:	83 c4 10             	add    $0x10,%esp
  return fd;
801071cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801071d2:	c9                   	leave  
801071d3:	c3                   	ret    

801071d4 <sys_read>:

int
sys_read(void)
{
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801071da:	83 ec 04             	sub    $0x4,%esp
801071dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071e0:	50                   	push   %eax
801071e1:	6a 00                	push   $0x0
801071e3:	6a 00                	push   $0x0
801071e5:	e8 d2 fe ff ff       	call   801070bc <argfd>
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	85 c0                	test   %eax,%eax
801071ef:	78 2e                	js     8010721f <sys_read+0x4b>
801071f1:	83 ec 08             	sub    $0x8,%esp
801071f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071f7:	50                   	push   %eax
801071f8:	6a 02                	push   $0x2
801071fa:	e8 25 fc ff ff       	call   80106e24 <argint>
801071ff:	83 c4 10             	add    $0x10,%esp
80107202:	85 c0                	test   %eax,%eax
80107204:	78 19                	js     8010721f <sys_read+0x4b>
80107206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107209:	83 ec 04             	sub    $0x4,%esp
8010720c:	50                   	push   %eax
8010720d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107210:	50                   	push   %eax
80107211:	6a 01                	push   $0x1
80107213:	e8 34 fc ff ff       	call   80106e4c <argptr>
80107218:	83 c4 10             	add    $0x10,%esp
8010721b:	85 c0                	test   %eax,%eax
8010721d:	79 07                	jns    80107226 <sys_read+0x52>
    return -1;
8010721f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107224:	eb 17                	jmp    8010723d <sys_read+0x69>
  return fileread(f, p, n);
80107226:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107229:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010722c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722f:	83 ec 04             	sub    $0x4,%esp
80107232:	51                   	push   %ecx
80107233:	52                   	push   %edx
80107234:	50                   	push   %eax
80107235:	e8 69 a0 ff ff       	call   801012a3 <fileread>
8010723a:	83 c4 10             	add    $0x10,%esp
}
8010723d:	c9                   	leave  
8010723e:	c3                   	ret    

8010723f <sys_write>:

int
sys_write(void)
{
8010723f:	55                   	push   %ebp
80107240:	89 e5                	mov    %esp,%ebp
80107242:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107245:	83 ec 04             	sub    $0x4,%esp
80107248:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010724b:	50                   	push   %eax
8010724c:	6a 00                	push   $0x0
8010724e:	6a 00                	push   $0x0
80107250:	e8 67 fe ff ff       	call   801070bc <argfd>
80107255:	83 c4 10             	add    $0x10,%esp
80107258:	85 c0                	test   %eax,%eax
8010725a:	78 2e                	js     8010728a <sys_write+0x4b>
8010725c:	83 ec 08             	sub    $0x8,%esp
8010725f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107262:	50                   	push   %eax
80107263:	6a 02                	push   $0x2
80107265:	e8 ba fb ff ff       	call   80106e24 <argint>
8010726a:	83 c4 10             	add    $0x10,%esp
8010726d:	85 c0                	test   %eax,%eax
8010726f:	78 19                	js     8010728a <sys_write+0x4b>
80107271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107274:	83 ec 04             	sub    $0x4,%esp
80107277:	50                   	push   %eax
80107278:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010727b:	50                   	push   %eax
8010727c:	6a 01                	push   $0x1
8010727e:	e8 c9 fb ff ff       	call   80106e4c <argptr>
80107283:	83 c4 10             	add    $0x10,%esp
80107286:	85 c0                	test   %eax,%eax
80107288:	79 07                	jns    80107291 <sys_write+0x52>
    return -1;
8010728a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010728f:	eb 17                	jmp    801072a8 <sys_write+0x69>
  return filewrite(f, p, n);
80107291:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107294:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729a:	83 ec 04             	sub    $0x4,%esp
8010729d:	51                   	push   %ecx
8010729e:	52                   	push   %edx
8010729f:	50                   	push   %eax
801072a0:	e8 b6 a0 ff ff       	call   8010135b <filewrite>
801072a5:	83 c4 10             	add    $0x10,%esp
}
801072a8:	c9                   	leave  
801072a9:	c3                   	ret    

801072aa <sys_close>:

int
sys_close(void)
{
801072aa:	55                   	push   %ebp
801072ab:	89 e5                	mov    %esp,%ebp
801072ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801072b0:	83 ec 04             	sub    $0x4,%esp
801072b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072b6:	50                   	push   %eax
801072b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801072ba:	50                   	push   %eax
801072bb:	6a 00                	push   $0x0
801072bd:	e8 fa fd ff ff       	call   801070bc <argfd>
801072c2:	83 c4 10             	add    $0x10,%esp
801072c5:	85 c0                	test   %eax,%eax
801072c7:	79 07                	jns    801072d0 <sys_close+0x26>
    return -1;
801072c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072ce:	eb 28                	jmp    801072f8 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801072d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072d9:	83 c2 08             	add    $0x8,%edx
801072dc:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801072e3:	00 
  fileclose(f);
801072e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072e7:	83 ec 0c             	sub    $0xc,%esp
801072ea:	50                   	push   %eax
801072eb:	e8 74 9e ff ff       	call   80101164 <fileclose>
801072f0:	83 c4 10             	add    $0x10,%esp
  return 0;
801072f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801072f8:	c9                   	leave  
801072f9:	c3                   	ret    

801072fa <sys_fstat>:

int
sys_fstat(void)
{
801072fa:	55                   	push   %ebp
801072fb:	89 e5                	mov    %esp,%ebp
801072fd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80107300:	83 ec 04             	sub    $0x4,%esp
80107303:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107306:	50                   	push   %eax
80107307:	6a 00                	push   $0x0
80107309:	6a 00                	push   $0x0
8010730b:	e8 ac fd ff ff       	call   801070bc <argfd>
80107310:	83 c4 10             	add    $0x10,%esp
80107313:	85 c0                	test   %eax,%eax
80107315:	78 17                	js     8010732e <sys_fstat+0x34>
80107317:	83 ec 04             	sub    $0x4,%esp
8010731a:	6a 1c                	push   $0x1c
8010731c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010731f:	50                   	push   %eax
80107320:	6a 01                	push   $0x1
80107322:	e8 25 fb ff ff       	call   80106e4c <argptr>
80107327:	83 c4 10             	add    $0x10,%esp
8010732a:	85 c0                	test   %eax,%eax
8010732c:	79 07                	jns    80107335 <sys_fstat+0x3b>
    return -1;
8010732e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107333:	eb 13                	jmp    80107348 <sys_fstat+0x4e>
  return filestat(f, st);
80107335:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733b:	83 ec 08             	sub    $0x8,%esp
8010733e:	52                   	push   %edx
8010733f:	50                   	push   %eax
80107340:	e8 07 9f ff ff       	call   8010124c <filestat>
80107345:	83 c4 10             	add    $0x10,%esp
}
80107348:	c9                   	leave  
80107349:	c3                   	ret    

8010734a <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010734a:	55                   	push   %ebp
8010734b:	89 e5                	mov    %esp,%ebp
8010734d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107350:	83 ec 08             	sub    $0x8,%esp
80107353:	8d 45 d8             	lea    -0x28(%ebp),%eax
80107356:	50                   	push   %eax
80107357:	6a 00                	push   $0x0
80107359:	e8 4b fb ff ff       	call   80106ea9 <argstr>
8010735e:	83 c4 10             	add    $0x10,%esp
80107361:	85 c0                	test   %eax,%eax
80107363:	78 15                	js     8010737a <sys_link+0x30>
80107365:	83 ec 08             	sub    $0x8,%esp
80107368:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010736b:	50                   	push   %eax
8010736c:	6a 01                	push   $0x1
8010736e:	e8 36 fb ff ff       	call   80106ea9 <argstr>
80107373:	83 c4 10             	add    $0x10,%esp
80107376:	85 c0                	test   %eax,%eax
80107378:	79 0a                	jns    80107384 <sys_link+0x3a>
    return -1;
8010737a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010737f:	e9 68 01 00 00       	jmp    801074ec <sys_link+0x1a2>

  begin_op();
80107384:	e8 4e c5 ff ff       	call   801038d7 <begin_op>
  if((ip = namei(old)) == 0){
80107389:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010738c:	83 ec 0c             	sub    $0xc,%esp
8010738f:	50                   	push   %eax
80107390:	e8 1d b5 ff ff       	call   801028b2 <namei>
80107395:	83 c4 10             	add    $0x10,%esp
80107398:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010739b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010739f:	75 0f                	jne    801073b0 <sys_link+0x66>
    end_op();
801073a1:	e8 bd c5 ff ff       	call   80103963 <end_op>
    return -1;
801073a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ab:	e9 3c 01 00 00       	jmp    801074ec <sys_link+0x1a2>
  }

  ilock(ip);
801073b0:	83 ec 0c             	sub    $0xc,%esp
801073b3:	ff 75 f4             	pushl  -0xc(%ebp)
801073b6:	e8 e9 a8 ff ff       	call   80101ca4 <ilock>
801073bb:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801073be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801073c5:	66 83 f8 01          	cmp    $0x1,%ax
801073c9:	75 1d                	jne    801073e8 <sys_link+0x9e>
    iunlockput(ip);
801073cb:	83 ec 0c             	sub    $0xc,%esp
801073ce:	ff 75 f4             	pushl  -0xc(%ebp)
801073d1:	e8 b6 ab ff ff       	call   80101f8c <iunlockput>
801073d6:	83 c4 10             	add    $0x10,%esp
    end_op();
801073d9:	e8 85 c5 ff ff       	call   80103963 <end_op>
    return -1;
801073de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073e3:	e9 04 01 00 00       	jmp    801074ec <sys_link+0x1a2>
  }

  ip->nlink++;
801073e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073eb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801073ef:	83 c0 01             	add    $0x1,%eax
801073f2:	89 c2                	mov    %eax,%edx
801073f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801073fb:	83 ec 0c             	sub    $0xc,%esp
801073fe:	ff 75 f4             	pushl  -0xc(%ebp)
80107401:	e8 9c a6 ff ff       	call   80101aa2 <iupdate>
80107406:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80107409:	83 ec 0c             	sub    $0xc,%esp
8010740c:	ff 75 f4             	pushl  -0xc(%ebp)
8010740f:	e8 16 aa ff ff       	call   80101e2a <iunlock>
80107414:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80107417:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010741a:	83 ec 08             	sub    $0x8,%esp
8010741d:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80107420:	52                   	push   %edx
80107421:	50                   	push   %eax
80107422:	e8 a7 b4 ff ff       	call   801028ce <nameiparent>
80107427:	83 c4 10             	add    $0x10,%esp
8010742a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010742d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107431:	74 71                	je     801074a4 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80107433:	83 ec 0c             	sub    $0xc,%esp
80107436:	ff 75 f0             	pushl  -0x10(%ebp)
80107439:	e8 66 a8 ff ff       	call   80101ca4 <ilock>
8010743e:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107444:	8b 10                	mov    (%eax),%edx
80107446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107449:	8b 00                	mov    (%eax),%eax
8010744b:	39 c2                	cmp    %eax,%edx
8010744d:	75 1d                	jne    8010746c <sys_link+0x122>
8010744f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107452:	8b 40 04             	mov    0x4(%eax),%eax
80107455:	83 ec 04             	sub    $0x4,%esp
80107458:	50                   	push   %eax
80107459:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010745c:	50                   	push   %eax
8010745d:	ff 75 f0             	pushl  -0x10(%ebp)
80107460:	e8 b1 b1 ff ff       	call   80102616 <dirlink>
80107465:	83 c4 10             	add    $0x10,%esp
80107468:	85 c0                	test   %eax,%eax
8010746a:	79 10                	jns    8010747c <sys_link+0x132>
    iunlockput(dp);
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	ff 75 f0             	pushl  -0x10(%ebp)
80107472:	e8 15 ab ff ff       	call   80101f8c <iunlockput>
80107477:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010747a:	eb 29                	jmp    801074a5 <sys_link+0x15b>
  }
  iunlockput(dp);
8010747c:	83 ec 0c             	sub    $0xc,%esp
8010747f:	ff 75 f0             	pushl  -0x10(%ebp)
80107482:	e8 05 ab ff ff       	call   80101f8c <iunlockput>
80107487:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010748a:	83 ec 0c             	sub    $0xc,%esp
8010748d:	ff 75 f4             	pushl  -0xc(%ebp)
80107490:	e8 07 aa ff ff       	call   80101e9c <iput>
80107495:	83 c4 10             	add    $0x10,%esp

  end_op();
80107498:	e8 c6 c4 ff ff       	call   80103963 <end_op>

  return 0;
8010749d:	b8 00 00 00 00       	mov    $0x0,%eax
801074a2:	eb 48                	jmp    801074ec <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801074a4:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801074a5:	83 ec 0c             	sub    $0xc,%esp
801074a8:	ff 75 f4             	pushl  -0xc(%ebp)
801074ab:	e8 f4 a7 ff ff       	call   80101ca4 <ilock>
801074b0:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801074b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074ba:	83 e8 01             	sub    $0x1,%eax
801074bd:	89 c2                	mov    %eax,%edx
801074bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c2:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	ff 75 f4             	pushl  -0xc(%ebp)
801074cc:	e8 d1 a5 ff ff       	call   80101aa2 <iupdate>
801074d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801074d4:	83 ec 0c             	sub    $0xc,%esp
801074d7:	ff 75 f4             	pushl  -0xc(%ebp)
801074da:	e8 ad aa ff ff       	call   80101f8c <iunlockput>
801074df:	83 c4 10             	add    $0x10,%esp
  end_op();
801074e2:	e8 7c c4 ff ff       	call   80103963 <end_op>
  return -1;
801074e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074ec:	c9                   	leave  
801074ed:	c3                   	ret    

801074ee <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801074ee:	55                   	push   %ebp
801074ef:	89 e5                	mov    %esp,%ebp
801074f1:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801074f4:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801074fb:	eb 40                	jmp    8010753d <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801074fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107500:	6a 10                	push   $0x10
80107502:	50                   	push   %eax
80107503:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107506:	50                   	push   %eax
80107507:	ff 75 08             	pushl  0x8(%ebp)
8010750a:	e8 53 ad ff ff       	call   80102262 <readi>
8010750f:	83 c4 10             	add    $0x10,%esp
80107512:	83 f8 10             	cmp    $0x10,%eax
80107515:	74 0d                	je     80107524 <isdirempty+0x36>
      panic("isdirempty: readi");
80107517:	83 ec 0c             	sub    $0xc,%esp
8010751a:	68 85 a9 10 80       	push   $0x8010a985
8010751f:	e8 42 90 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80107524:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107528:	66 85 c0             	test   %ax,%ax
8010752b:	74 07                	je     80107534 <isdirempty+0x46>
      return 0;
8010752d:	b8 00 00 00 00       	mov    $0x0,%eax
80107532:	eb 1b                	jmp    8010754f <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107537:	83 c0 10             	add    $0x10,%eax
8010753a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010753d:	8b 45 08             	mov    0x8(%ebp),%eax
80107540:	8b 50 20             	mov    0x20(%eax),%edx
80107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107546:	39 c2                	cmp    %eax,%edx
80107548:	77 b3                	ja     801074fd <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010754a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010754f:	c9                   	leave  
80107550:	c3                   	ret    

80107551 <sys_unlink>:

int
sys_unlink(void)
{
80107551:	55                   	push   %ebp
80107552:	89 e5                	mov    %esp,%ebp
80107554:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80107557:	83 ec 08             	sub    $0x8,%esp
8010755a:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010755d:	50                   	push   %eax
8010755e:	6a 00                	push   $0x0
80107560:	e8 44 f9 ff ff       	call   80106ea9 <argstr>
80107565:	83 c4 10             	add    $0x10,%esp
80107568:	85 c0                	test   %eax,%eax
8010756a:	79 0a                	jns    80107576 <sys_unlink+0x25>
    return -1;
8010756c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107571:	e9 bc 01 00 00       	jmp    80107732 <sys_unlink+0x1e1>

  begin_op();
80107576:	e8 5c c3 ff ff       	call   801038d7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010757b:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010757e:	83 ec 08             	sub    $0x8,%esp
80107581:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107584:	52                   	push   %edx
80107585:	50                   	push   %eax
80107586:	e8 43 b3 ff ff       	call   801028ce <nameiparent>
8010758b:	83 c4 10             	add    $0x10,%esp
8010758e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107595:	75 0f                	jne    801075a6 <sys_unlink+0x55>
    end_op();
80107597:	e8 c7 c3 ff ff       	call   80103963 <end_op>
    return -1;
8010759c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a1:	e9 8c 01 00 00       	jmp    80107732 <sys_unlink+0x1e1>
  }

  ilock(dp);
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	ff 75 f4             	pushl  -0xc(%ebp)
801075ac:	e8 f3 a6 ff ff       	call   80101ca4 <ilock>
801075b1:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801075b4:	83 ec 08             	sub    $0x8,%esp
801075b7:	68 97 a9 10 80       	push   $0x8010a997
801075bc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801075bf:	50                   	push   %eax
801075c0:	e8 7c af ff ff       	call   80102541 <namecmp>
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	85 c0                	test   %eax,%eax
801075ca:	0f 84 4a 01 00 00    	je     8010771a <sys_unlink+0x1c9>
801075d0:	83 ec 08             	sub    $0x8,%esp
801075d3:	68 99 a9 10 80       	push   $0x8010a999
801075d8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801075db:	50                   	push   %eax
801075dc:	e8 60 af ff ff       	call   80102541 <namecmp>
801075e1:	83 c4 10             	add    $0x10,%esp
801075e4:	85 c0                	test   %eax,%eax
801075e6:	0f 84 2e 01 00 00    	je     8010771a <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801075ec:	83 ec 04             	sub    $0x4,%esp
801075ef:	8d 45 c8             	lea    -0x38(%ebp),%eax
801075f2:	50                   	push   %eax
801075f3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801075f6:	50                   	push   %eax
801075f7:	ff 75 f4             	pushl  -0xc(%ebp)
801075fa:	e8 5d af ff ff       	call   8010255c <dirlookup>
801075ff:	83 c4 10             	add    $0x10,%esp
80107602:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107609:	0f 84 0a 01 00 00    	je     80107719 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010760f:	83 ec 0c             	sub    $0xc,%esp
80107612:	ff 75 f0             	pushl  -0x10(%ebp)
80107615:	e8 8a a6 ff ff       	call   80101ca4 <ilock>
8010761a:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010761d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107620:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107624:	66 85 c0             	test   %ax,%ax
80107627:	7f 0d                	jg     80107636 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80107629:	83 ec 0c             	sub    $0xc,%esp
8010762c:	68 9c a9 10 80       	push   $0x8010a99c
80107631:	e8 30 8f ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80107636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107639:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010763d:	66 83 f8 01          	cmp    $0x1,%ax
80107641:	75 25                	jne    80107668 <sys_unlink+0x117>
80107643:	83 ec 0c             	sub    $0xc,%esp
80107646:	ff 75 f0             	pushl  -0x10(%ebp)
80107649:	e8 a0 fe ff ff       	call   801074ee <isdirempty>
8010764e:	83 c4 10             	add    $0x10,%esp
80107651:	85 c0                	test   %eax,%eax
80107653:	75 13                	jne    80107668 <sys_unlink+0x117>
    iunlockput(ip);
80107655:	83 ec 0c             	sub    $0xc,%esp
80107658:	ff 75 f0             	pushl  -0x10(%ebp)
8010765b:	e8 2c a9 ff ff       	call   80101f8c <iunlockput>
80107660:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107663:	e9 b2 00 00 00       	jmp    8010771a <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80107668:	83 ec 04             	sub    $0x4,%esp
8010766b:	6a 10                	push   $0x10
8010766d:	6a 00                	push   $0x0
8010766f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107672:	50                   	push   %eax
80107673:	e8 87 f4 ff ff       	call   80106aff <memset>
80107678:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010767b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010767e:	6a 10                	push   $0x10
80107680:	50                   	push   %eax
80107681:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107684:	50                   	push   %eax
80107685:	ff 75 f4             	pushl  -0xc(%ebp)
80107688:	e8 2c ad ff ff       	call   801023b9 <writei>
8010768d:	83 c4 10             	add    $0x10,%esp
80107690:	83 f8 10             	cmp    $0x10,%eax
80107693:	74 0d                	je     801076a2 <sys_unlink+0x151>
    panic("unlink: writei");
80107695:	83 ec 0c             	sub    $0xc,%esp
80107698:	68 ae a9 10 80       	push   $0x8010a9ae
8010769d:	e8 c4 8e ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801076a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076a5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801076a9:	66 83 f8 01          	cmp    $0x1,%ax
801076ad:	75 21                	jne    801076d0 <sys_unlink+0x17f>
    dp->nlink--;
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076b6:	83 e8 01             	sub    $0x1,%eax
801076b9:	89 c2                	mov    %eax,%edx
801076bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076be:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801076c2:	83 ec 0c             	sub    $0xc,%esp
801076c5:	ff 75 f4             	pushl  -0xc(%ebp)
801076c8:	e8 d5 a3 ff ff       	call   80101aa2 <iupdate>
801076cd:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801076d0:	83 ec 0c             	sub    $0xc,%esp
801076d3:	ff 75 f4             	pushl  -0xc(%ebp)
801076d6:	e8 b1 a8 ff ff       	call   80101f8c <iunlockput>
801076db:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801076de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076e1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076e5:	83 e8 01             	sub    $0x1,%eax
801076e8:	89 c2                	mov    %eax,%edx
801076ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ed:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801076f1:	83 ec 0c             	sub    $0xc,%esp
801076f4:	ff 75 f0             	pushl  -0x10(%ebp)
801076f7:	e8 a6 a3 ff ff       	call   80101aa2 <iupdate>
801076fc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801076ff:	83 ec 0c             	sub    $0xc,%esp
80107702:	ff 75 f0             	pushl  -0x10(%ebp)
80107705:	e8 82 a8 ff ff       	call   80101f8c <iunlockput>
8010770a:	83 c4 10             	add    $0x10,%esp

  end_op();
8010770d:	e8 51 c2 ff ff       	call   80103963 <end_op>

  return 0;
80107712:	b8 00 00 00 00       	mov    $0x0,%eax
80107717:	eb 19                	jmp    80107732 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107719:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010771a:	83 ec 0c             	sub    $0xc,%esp
8010771d:	ff 75 f4             	pushl  -0xc(%ebp)
80107720:	e8 67 a8 ff ff       	call   80101f8c <iunlockput>
80107725:	83 c4 10             	add    $0x10,%esp
  end_op();
80107728:	e8 36 c2 ff ff       	call   80103963 <end_op>
  return -1;
8010772d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107732:	c9                   	leave  
80107733:	c3                   	ret    

80107734 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	83 ec 38             	sub    $0x38,%esp
8010773a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010773d:	8b 55 10             	mov    0x10(%ebp),%edx
80107740:	8b 45 14             	mov    0x14(%ebp),%eax
80107743:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80107747:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010774b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010774f:	83 ec 08             	sub    $0x8,%esp
80107752:	8d 45 de             	lea    -0x22(%ebp),%eax
80107755:	50                   	push   %eax
80107756:	ff 75 08             	pushl  0x8(%ebp)
80107759:	e8 70 b1 ff ff       	call   801028ce <nameiparent>
8010775e:	83 c4 10             	add    $0x10,%esp
80107761:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107768:	75 0a                	jne    80107774 <create+0x40>
    return 0;
8010776a:	b8 00 00 00 00       	mov    $0x0,%eax
8010776f:	e9 90 01 00 00       	jmp    80107904 <create+0x1d0>
  ilock(dp);
80107774:	83 ec 0c             	sub    $0xc,%esp
80107777:	ff 75 f4             	pushl  -0xc(%ebp)
8010777a:	e8 25 a5 ff ff       	call   80101ca4 <ilock>
8010777f:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80107782:	83 ec 04             	sub    $0x4,%esp
80107785:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107788:	50                   	push   %eax
80107789:	8d 45 de             	lea    -0x22(%ebp),%eax
8010778c:	50                   	push   %eax
8010778d:	ff 75 f4             	pushl  -0xc(%ebp)
80107790:	e8 c7 ad ff ff       	call   8010255c <dirlookup>
80107795:	83 c4 10             	add    $0x10,%esp
80107798:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010779b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010779f:	74 50                	je     801077f1 <create+0xbd>
    iunlockput(dp);
801077a1:	83 ec 0c             	sub    $0xc,%esp
801077a4:	ff 75 f4             	pushl  -0xc(%ebp)
801077a7:	e8 e0 a7 ff ff       	call   80101f8c <iunlockput>
801077ac:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801077af:	83 ec 0c             	sub    $0xc,%esp
801077b2:	ff 75 f0             	pushl  -0x10(%ebp)
801077b5:	e8 ea a4 ff ff       	call   80101ca4 <ilock>
801077ba:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801077bd:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801077c2:	75 15                	jne    801077d9 <create+0xa5>
801077c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077c7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801077cb:	66 83 f8 02          	cmp    $0x2,%ax
801077cf:	75 08                	jne    801077d9 <create+0xa5>
      return ip;
801077d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077d4:	e9 2b 01 00 00       	jmp    80107904 <create+0x1d0>
    iunlockput(ip);
801077d9:	83 ec 0c             	sub    $0xc,%esp
801077dc:	ff 75 f0             	pushl  -0x10(%ebp)
801077df:	e8 a8 a7 ff ff       	call   80101f8c <iunlockput>
801077e4:	83 c4 10             	add    $0x10,%esp
    return 0;
801077e7:	b8 00 00 00 00       	mov    $0x0,%eax
801077ec:	e9 13 01 00 00       	jmp    80107904 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801077f1:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801077f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f8:	8b 00                	mov    (%eax),%eax
801077fa:	83 ec 08             	sub    $0x8,%esp
801077fd:	52                   	push   %edx
801077fe:	50                   	push   %eax
801077ff:	e8 ab a1 ff ff       	call   801019af <ialloc>
80107804:	83 c4 10             	add    $0x10,%esp
80107807:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010780a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010780e:	75 0d                	jne    8010781d <create+0xe9>
    panic("create: ialloc");
80107810:	83 ec 0c             	sub    $0xc,%esp
80107813:	68 bd a9 10 80       	push   $0x8010a9bd
80107818:	e8 49 8d ff ff       	call   80100566 <panic>

  ilock(ip);
8010781d:	83 ec 0c             	sub    $0xc,%esp
80107820:	ff 75 f0             	pushl  -0x10(%ebp)
80107823:	e8 7c a4 ff ff       	call   80101ca4 <ilock>
80107828:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010782b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010782e:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107832:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80107836:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107839:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010783d:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107844:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010784a:	83 ec 0c             	sub    $0xc,%esp
8010784d:	ff 75 f0             	pushl  -0x10(%ebp)
80107850:	e8 4d a2 ff ff       	call   80101aa2 <iupdate>
80107855:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107858:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010785d:	75 6a                	jne    801078c9 <create+0x195>
    dp->nlink++;  // for ".."
8010785f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107862:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107866:	83 c0 01             	add    $0x1,%eax
80107869:	89 c2                	mov    %eax,%edx
8010786b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786e:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107872:	83 ec 0c             	sub    $0xc,%esp
80107875:	ff 75 f4             	pushl  -0xc(%ebp)
80107878:	e8 25 a2 ff ff       	call   80101aa2 <iupdate>
8010787d:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107883:	8b 40 04             	mov    0x4(%eax),%eax
80107886:	83 ec 04             	sub    $0x4,%esp
80107889:	50                   	push   %eax
8010788a:	68 97 a9 10 80       	push   $0x8010a997
8010788f:	ff 75 f0             	pushl  -0x10(%ebp)
80107892:	e8 7f ad ff ff       	call   80102616 <dirlink>
80107897:	83 c4 10             	add    $0x10,%esp
8010789a:	85 c0                	test   %eax,%eax
8010789c:	78 1e                	js     801078bc <create+0x188>
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	8b 40 04             	mov    0x4(%eax),%eax
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	50                   	push   %eax
801078a8:	68 99 a9 10 80       	push   $0x8010a999
801078ad:	ff 75 f0             	pushl  -0x10(%ebp)
801078b0:	e8 61 ad ff ff       	call   80102616 <dirlink>
801078b5:	83 c4 10             	add    $0x10,%esp
801078b8:	85 c0                	test   %eax,%eax
801078ba:	79 0d                	jns    801078c9 <create+0x195>
      panic("create dots");
801078bc:	83 ec 0c             	sub    $0xc,%esp
801078bf:	68 cc a9 10 80       	push   $0x8010a9cc
801078c4:	e8 9d 8c ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801078c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078cc:	8b 40 04             	mov    0x4(%eax),%eax
801078cf:	83 ec 04             	sub    $0x4,%esp
801078d2:	50                   	push   %eax
801078d3:	8d 45 de             	lea    -0x22(%ebp),%eax
801078d6:	50                   	push   %eax
801078d7:	ff 75 f4             	pushl  -0xc(%ebp)
801078da:	e8 37 ad ff ff       	call   80102616 <dirlink>
801078df:	83 c4 10             	add    $0x10,%esp
801078e2:	85 c0                	test   %eax,%eax
801078e4:	79 0d                	jns    801078f3 <create+0x1bf>
    panic("create: dirlink");
801078e6:	83 ec 0c             	sub    $0xc,%esp
801078e9:	68 d8 a9 10 80       	push   $0x8010a9d8
801078ee:	e8 73 8c ff ff       	call   80100566 <panic>

  iunlockput(dp);
801078f3:	83 ec 0c             	sub    $0xc,%esp
801078f6:	ff 75 f4             	pushl  -0xc(%ebp)
801078f9:	e8 8e a6 ff ff       	call   80101f8c <iunlockput>
801078fe:	83 c4 10             	add    $0x10,%esp

  return ip;
80107901:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107904:	c9                   	leave  
80107905:	c3                   	ret    

80107906 <sys_open>:

int
sys_open(void)
{
80107906:	55                   	push   %ebp
80107907:	89 e5                	mov    %esp,%ebp
80107909:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010790c:	83 ec 08             	sub    $0x8,%esp
8010790f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107912:	50                   	push   %eax
80107913:	6a 00                	push   $0x0
80107915:	e8 8f f5 ff ff       	call   80106ea9 <argstr>
8010791a:	83 c4 10             	add    $0x10,%esp
8010791d:	85 c0                	test   %eax,%eax
8010791f:	78 15                	js     80107936 <sys_open+0x30>
80107921:	83 ec 08             	sub    $0x8,%esp
80107924:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107927:	50                   	push   %eax
80107928:	6a 01                	push   $0x1
8010792a:	e8 f5 f4 ff ff       	call   80106e24 <argint>
8010792f:	83 c4 10             	add    $0x10,%esp
80107932:	85 c0                	test   %eax,%eax
80107934:	79 0a                	jns    80107940 <sys_open+0x3a>
    return -1;
80107936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010793b:	e9 61 01 00 00       	jmp    80107aa1 <sys_open+0x19b>

  begin_op();
80107940:	e8 92 bf ff ff       	call   801038d7 <begin_op>

  if(omode & O_CREATE){
80107945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107948:	25 00 02 00 00       	and    $0x200,%eax
8010794d:	85 c0                	test   %eax,%eax
8010794f:	74 2a                	je     8010797b <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107951:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107954:	6a 00                	push   $0x0
80107956:	6a 00                	push   $0x0
80107958:	6a 02                	push   $0x2
8010795a:	50                   	push   %eax
8010795b:	e8 d4 fd ff ff       	call   80107734 <create>
80107960:	83 c4 10             	add    $0x10,%esp
80107963:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80107966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010796a:	75 75                	jne    801079e1 <sys_open+0xdb>
      end_op();
8010796c:	e8 f2 bf ff ff       	call   80103963 <end_op>
      return -1;
80107971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107976:	e9 26 01 00 00       	jmp    80107aa1 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010797b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010797e:	83 ec 0c             	sub    $0xc,%esp
80107981:	50                   	push   %eax
80107982:	e8 2b af ff ff       	call   801028b2 <namei>
80107987:	83 c4 10             	add    $0x10,%esp
8010798a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010798d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107991:	75 0f                	jne    801079a2 <sys_open+0x9c>
      end_op();
80107993:	e8 cb bf ff ff       	call   80103963 <end_op>
      return -1;
80107998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010799d:	e9 ff 00 00 00       	jmp    80107aa1 <sys_open+0x19b>
    }
    ilock(ip);
801079a2:	83 ec 0c             	sub    $0xc,%esp
801079a5:	ff 75 f4             	pushl  -0xc(%ebp)
801079a8:	e8 f7 a2 ff ff       	call   80101ca4 <ilock>
801079ad:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801079b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801079b7:	66 83 f8 01          	cmp    $0x1,%ax
801079bb:	75 24                	jne    801079e1 <sys_open+0xdb>
801079bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079c0:	85 c0                	test   %eax,%eax
801079c2:	74 1d                	je     801079e1 <sys_open+0xdb>
      iunlockput(ip);
801079c4:	83 ec 0c             	sub    $0xc,%esp
801079c7:	ff 75 f4             	pushl  -0xc(%ebp)
801079ca:	e8 bd a5 ff ff       	call   80101f8c <iunlockput>
801079cf:	83 c4 10             	add    $0x10,%esp
      end_op();
801079d2:	e8 8c bf ff ff       	call   80103963 <end_op>
      return -1;
801079d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079dc:	e9 c0 00 00 00       	jmp    80107aa1 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801079e1:	e8 c0 96 ff ff       	call   801010a6 <filealloc>
801079e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079ed:	74 17                	je     80107a06 <sys_open+0x100>
801079ef:	83 ec 0c             	sub    $0xc,%esp
801079f2:	ff 75 f0             	pushl  -0x10(%ebp)
801079f5:	e8 37 f7 ff ff       	call   80107131 <fdalloc>
801079fa:	83 c4 10             	add    $0x10,%esp
801079fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a04:	79 2e                	jns    80107a34 <sys_open+0x12e>
    if(f)
80107a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a0a:	74 0e                	je     80107a1a <sys_open+0x114>
      fileclose(f);
80107a0c:	83 ec 0c             	sub    $0xc,%esp
80107a0f:	ff 75 f0             	pushl  -0x10(%ebp)
80107a12:	e8 4d 97 ff ff       	call   80101164 <fileclose>
80107a17:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107a1a:	83 ec 0c             	sub    $0xc,%esp
80107a1d:	ff 75 f4             	pushl  -0xc(%ebp)
80107a20:	e8 67 a5 ff ff       	call   80101f8c <iunlockput>
80107a25:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a28:	e8 36 bf ff ff       	call   80103963 <end_op>
    return -1;
80107a2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a32:	eb 6d                	jmp    80107aa1 <sys_open+0x19b>
  }
  iunlock(ip);
80107a34:	83 ec 0c             	sub    $0xc,%esp
80107a37:	ff 75 f4             	pushl  -0xc(%ebp)
80107a3a:	e8 eb a3 ff ff       	call   80101e2a <iunlock>
80107a3f:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a42:	e8 1c bf ff ff       	call   80103963 <end_op>

  f->type = FD_INODE;
80107a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a4a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a56:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a5c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80107a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a66:	83 e0 01             	and    $0x1,%eax
80107a69:	85 c0                	test   %eax,%eax
80107a6b:	0f 94 c0             	sete   %al
80107a6e:	89 c2                	mov    %eax,%edx
80107a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a73:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a79:	83 e0 01             	and    $0x1,%eax
80107a7c:	85 c0                	test   %eax,%eax
80107a7e:	75 0a                	jne    80107a8a <sys_open+0x184>
80107a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a83:	83 e0 02             	and    $0x2,%eax
80107a86:	85 c0                	test   %eax,%eax
80107a88:	74 07                	je     80107a91 <sys_open+0x18b>
80107a8a:	b8 01 00 00 00       	mov    $0x1,%eax
80107a8f:	eb 05                	jmp    80107a96 <sys_open+0x190>
80107a91:	b8 00 00 00 00       	mov    $0x0,%eax
80107a96:	89 c2                	mov    %eax,%edx
80107a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a9b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107aa1:	c9                   	leave  
80107aa2:	c3                   	ret    

80107aa3 <sys_mkdir>:

int
sys_mkdir(void)
{
80107aa3:	55                   	push   %ebp
80107aa4:	89 e5                	mov    %esp,%ebp
80107aa6:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107aa9:	e8 29 be ff ff       	call   801038d7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107aae:	83 ec 08             	sub    $0x8,%esp
80107ab1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ab4:	50                   	push   %eax
80107ab5:	6a 00                	push   $0x0
80107ab7:	e8 ed f3 ff ff       	call   80106ea9 <argstr>
80107abc:	83 c4 10             	add    $0x10,%esp
80107abf:	85 c0                	test   %eax,%eax
80107ac1:	78 1b                	js     80107ade <sys_mkdir+0x3b>
80107ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ac6:	6a 00                	push   $0x0
80107ac8:	6a 00                	push   $0x0
80107aca:	6a 01                	push   $0x1
80107acc:	50                   	push   %eax
80107acd:	e8 62 fc ff ff       	call   80107734 <create>
80107ad2:	83 c4 10             	add    $0x10,%esp
80107ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107adc:	75 0c                	jne    80107aea <sys_mkdir+0x47>
    end_op();
80107ade:	e8 80 be ff ff       	call   80103963 <end_op>
    return -1;
80107ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ae8:	eb 18                	jmp    80107b02 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107aea:	83 ec 0c             	sub    $0xc,%esp
80107aed:	ff 75 f4             	pushl  -0xc(%ebp)
80107af0:	e8 97 a4 ff ff       	call   80101f8c <iunlockput>
80107af5:	83 c4 10             	add    $0x10,%esp
  end_op();
80107af8:	e8 66 be ff ff       	call   80103963 <end_op>
  return 0;
80107afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b02:	c9                   	leave  
80107b03:	c3                   	ret    

80107b04 <sys_mknod>:

int
sys_mknod(void)
{
80107b04:	55                   	push   %ebp
80107b05:	89 e5                	mov    %esp,%ebp
80107b07:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107b0a:	e8 c8 bd ff ff       	call   801038d7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107b0f:	83 ec 08             	sub    $0x8,%esp
80107b12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107b15:	50                   	push   %eax
80107b16:	6a 00                	push   $0x0
80107b18:	e8 8c f3 ff ff       	call   80106ea9 <argstr>
80107b1d:	83 c4 10             	add    $0x10,%esp
80107b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b27:	78 4f                	js     80107b78 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107b29:	83 ec 08             	sub    $0x8,%esp
80107b2c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107b2f:	50                   	push   %eax
80107b30:	6a 01                	push   $0x1
80107b32:	e8 ed f2 ff ff       	call   80106e24 <argint>
80107b37:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107b3a:	85 c0                	test   %eax,%eax
80107b3c:	78 3a                	js     80107b78 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107b3e:	83 ec 08             	sub    $0x8,%esp
80107b41:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107b44:	50                   	push   %eax
80107b45:	6a 02                	push   $0x2
80107b47:	e8 d8 f2 ff ff       	call   80106e24 <argint>
80107b4c:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107b4f:	85 c0                	test   %eax,%eax
80107b51:	78 25                	js     80107b78 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b56:	0f bf c8             	movswl %ax,%ecx
80107b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107b5c:	0f bf d0             	movswl %ax,%edx
80107b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107b62:	51                   	push   %ecx
80107b63:	52                   	push   %edx
80107b64:	6a 03                	push   $0x3
80107b66:	50                   	push   %eax
80107b67:	e8 c8 fb ff ff       	call   80107734 <create>
80107b6c:	83 c4 10             	add    $0x10,%esp
80107b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b76:	75 0c                	jne    80107b84 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107b78:	e8 e6 bd ff ff       	call   80103963 <end_op>
    return -1;
80107b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b82:	eb 18                	jmp    80107b9c <sys_mknod+0x98>
  }
  iunlockput(ip);
80107b84:	83 ec 0c             	sub    $0xc,%esp
80107b87:	ff 75 f0             	pushl  -0x10(%ebp)
80107b8a:	e8 fd a3 ff ff       	call   80101f8c <iunlockput>
80107b8f:	83 c4 10             	add    $0x10,%esp
  end_op();
80107b92:	e8 cc bd ff ff       	call   80103963 <end_op>
  return 0;
80107b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b9c:	c9                   	leave  
80107b9d:	c3                   	ret    

80107b9e <sys_chdir>:

int
sys_chdir(void)
{
80107b9e:	55                   	push   %ebp
80107b9f:	89 e5                	mov    %esp,%ebp
80107ba1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107ba4:	e8 2e bd ff ff       	call   801038d7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107ba9:	83 ec 08             	sub    $0x8,%esp
80107bac:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107baf:	50                   	push   %eax
80107bb0:	6a 00                	push   $0x0
80107bb2:	e8 f2 f2 ff ff       	call   80106ea9 <argstr>
80107bb7:	83 c4 10             	add    $0x10,%esp
80107bba:	85 c0                	test   %eax,%eax
80107bbc:	78 18                	js     80107bd6 <sys_chdir+0x38>
80107bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bc1:	83 ec 0c             	sub    $0xc,%esp
80107bc4:	50                   	push   %eax
80107bc5:	e8 e8 ac ff ff       	call   801028b2 <namei>
80107bca:	83 c4 10             	add    $0x10,%esp
80107bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bd4:	75 0c                	jne    80107be2 <sys_chdir+0x44>
    end_op();
80107bd6:	e8 88 bd ff ff       	call   80103963 <end_op>
    return -1;
80107bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107be0:	eb 6e                	jmp    80107c50 <sys_chdir+0xb2>
  }
  ilock(ip);
80107be2:	83 ec 0c             	sub    $0xc,%esp
80107be5:	ff 75 f4             	pushl  -0xc(%ebp)
80107be8:	e8 b7 a0 ff ff       	call   80101ca4 <ilock>
80107bed:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107bf7:	66 83 f8 01          	cmp    $0x1,%ax
80107bfb:	74 1a                	je     80107c17 <sys_chdir+0x79>
    iunlockput(ip);
80107bfd:	83 ec 0c             	sub    $0xc,%esp
80107c00:	ff 75 f4             	pushl  -0xc(%ebp)
80107c03:	e8 84 a3 ff ff       	call   80101f8c <iunlockput>
80107c08:	83 c4 10             	add    $0x10,%esp
    end_op();
80107c0b:	e8 53 bd ff ff       	call   80103963 <end_op>
    return -1;
80107c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c15:	eb 39                	jmp    80107c50 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107c17:	83 ec 0c             	sub    $0xc,%esp
80107c1a:	ff 75 f4             	pushl  -0xc(%ebp)
80107c1d:	e8 08 a2 ff ff       	call   80101e2a <iunlock>
80107c22:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107c25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c2b:	8b 40 68             	mov    0x68(%eax),%eax
80107c2e:	83 ec 0c             	sub    $0xc,%esp
80107c31:	50                   	push   %eax
80107c32:	e8 65 a2 ff ff       	call   80101e9c <iput>
80107c37:	83 c4 10             	add    $0x10,%esp
  end_op();
80107c3a:	e8 24 bd ff ff       	call   80103963 <end_op>
  proc->cwd = ip;
80107c3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c48:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c50:	c9                   	leave  
80107c51:	c3                   	ret    

80107c52 <sys_exec>:

int
sys_exec(void)
{
80107c52:	55                   	push   %ebp
80107c53:	89 e5                	mov    %esp,%ebp
80107c55:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107c5b:	83 ec 08             	sub    $0x8,%esp
80107c5e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107c61:	50                   	push   %eax
80107c62:	6a 00                	push   $0x0
80107c64:	e8 40 f2 ff ff       	call   80106ea9 <argstr>
80107c69:	83 c4 10             	add    $0x10,%esp
80107c6c:	85 c0                	test   %eax,%eax
80107c6e:	78 18                	js     80107c88 <sys_exec+0x36>
80107c70:	83 ec 08             	sub    $0x8,%esp
80107c73:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107c79:	50                   	push   %eax
80107c7a:	6a 01                	push   $0x1
80107c7c:	e8 a3 f1 ff ff       	call   80106e24 <argint>
80107c81:	83 c4 10             	add    $0x10,%esp
80107c84:	85 c0                	test   %eax,%eax
80107c86:	79 0a                	jns    80107c92 <sys_exec+0x40>
    return -1;
80107c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c8d:	e9 c6 00 00 00       	jmp    80107d58 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107c92:	83 ec 04             	sub    $0x4,%esp
80107c95:	68 80 00 00 00       	push   $0x80
80107c9a:	6a 00                	push   $0x0
80107c9c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107ca2:	50                   	push   %eax
80107ca3:	e8 57 ee ff ff       	call   80106aff <memset>
80107ca8:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb5:	83 f8 1f             	cmp    $0x1f,%eax
80107cb8:	76 0a                	jbe    80107cc4 <sys_exec+0x72>
      return -1;
80107cba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cbf:	e9 94 00 00 00       	jmp    80107d58 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc7:	c1 e0 02             	shl    $0x2,%eax
80107cca:	89 c2                	mov    %eax,%edx
80107ccc:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107cd2:	01 c2                	add    %eax,%edx
80107cd4:	83 ec 08             	sub    $0x8,%esp
80107cd7:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107cdd:	50                   	push   %eax
80107cde:	52                   	push   %edx
80107cdf:	e8 a4 f0 ff ff       	call   80106d88 <fetchint>
80107ce4:	83 c4 10             	add    $0x10,%esp
80107ce7:	85 c0                	test   %eax,%eax
80107ce9:	79 07                	jns    80107cf2 <sys_exec+0xa0>
      return -1;
80107ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cf0:	eb 66                	jmp    80107d58 <sys_exec+0x106>
    if(uarg == 0){
80107cf2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107cf8:	85 c0                	test   %eax,%eax
80107cfa:	75 27                	jne    80107d23 <sys_exec+0xd1>
      argv[i] = 0;
80107cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cff:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107d06:	00 00 00 00 
      break;
80107d0a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d0e:	83 ec 08             	sub    $0x8,%esp
80107d11:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107d17:	52                   	push   %edx
80107d18:	50                   	push   %eax
80107d19:	e8 f1 8e ff ff       	call   80100c0f <exec>
80107d1e:	83 c4 10             	add    $0x10,%esp
80107d21:	eb 35                	jmp    80107d58 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107d23:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d2c:	c1 e2 02             	shl    $0x2,%edx
80107d2f:	01 c2                	add    %eax,%edx
80107d31:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107d37:	83 ec 08             	sub    $0x8,%esp
80107d3a:	52                   	push   %edx
80107d3b:	50                   	push   %eax
80107d3c:	e8 81 f0 ff ff       	call   80106dc2 <fetchstr>
80107d41:	83 c4 10             	add    $0x10,%esp
80107d44:	85 c0                	test   %eax,%eax
80107d46:	79 07                	jns    80107d4f <sys_exec+0xfd>
      return -1;
80107d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d4d:	eb 09                	jmp    80107d58 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107d4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107d53:	e9 5a ff ff ff       	jmp    80107cb2 <sys_exec+0x60>
  return exec(path, argv);
}
80107d58:	c9                   	leave  
80107d59:	c3                   	ret    

80107d5a <sys_pipe>:

int
sys_pipe(void)
{
80107d5a:	55                   	push   %ebp
80107d5b:	89 e5                	mov    %esp,%ebp
80107d5d:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107d60:	83 ec 04             	sub    $0x4,%esp
80107d63:	6a 08                	push   $0x8
80107d65:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107d68:	50                   	push   %eax
80107d69:	6a 00                	push   $0x0
80107d6b:	e8 dc f0 ff ff       	call   80106e4c <argptr>
80107d70:	83 c4 10             	add    $0x10,%esp
80107d73:	85 c0                	test   %eax,%eax
80107d75:	79 0a                	jns    80107d81 <sys_pipe+0x27>
    return -1;
80107d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d7c:	e9 af 00 00 00       	jmp    80107e30 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107d81:	83 ec 08             	sub    $0x8,%esp
80107d84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107d87:	50                   	push   %eax
80107d88:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107d8b:	50                   	push   %eax
80107d8c:	e8 3a c6 ff ff       	call   801043cb <pipealloc>
80107d91:	83 c4 10             	add    $0x10,%esp
80107d94:	85 c0                	test   %eax,%eax
80107d96:	79 0a                	jns    80107da2 <sys_pipe+0x48>
    return -1;
80107d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d9d:	e9 8e 00 00 00       	jmp    80107e30 <sys_pipe+0xd6>
  fd0 = -1;
80107da2:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dac:	83 ec 0c             	sub    $0xc,%esp
80107daf:	50                   	push   %eax
80107db0:	e8 7c f3 ff ff       	call   80107131 <fdalloc>
80107db5:	83 c4 10             	add    $0x10,%esp
80107db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107dbf:	78 18                	js     80107dd9 <sys_pipe+0x7f>
80107dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dc4:	83 ec 0c             	sub    $0xc,%esp
80107dc7:	50                   	push   %eax
80107dc8:	e8 64 f3 ff ff       	call   80107131 <fdalloc>
80107dcd:	83 c4 10             	add    $0x10,%esp
80107dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107dd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107dd7:	79 3f                	jns    80107e18 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ddd:	78 14                	js     80107df3 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107ddf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107de8:	83 c2 08             	add    $0x8,%edx
80107deb:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107df2:	00 
    fileclose(rf);
80107df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107df6:	83 ec 0c             	sub    $0xc,%esp
80107df9:	50                   	push   %eax
80107dfa:	e8 65 93 ff ff       	call   80101164 <fileclose>
80107dff:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e05:	83 ec 0c             	sub    $0xc,%esp
80107e08:	50                   	push   %eax
80107e09:	e8 56 93 ff ff       	call   80101164 <fileclose>
80107e0e:	83 c4 10             	add    $0x10,%esp
    return -1;
80107e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e16:	eb 18                	jmp    80107e30 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e1e:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e23:	8d 50 04             	lea    0x4(%eax),%edx
80107e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e29:	89 02                	mov    %eax,(%edx)
  return 0;
80107e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e30:	c9                   	leave  
80107e31:	c3                   	ret    

80107e32 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107e32:	55                   	push   %ebp
80107e33:	89 e5                	mov    %esp,%ebp
80107e35:	83 ec 08             	sub    $0x8,%esp
80107e38:	8b 55 08             	mov    0x8(%ebp),%edx
80107e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107e42:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e46:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107e4a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e4e:	66 ef                	out    %ax,(%dx)
}
80107e50:	90                   	nop
80107e51:	c9                   	leave  
80107e52:	c3                   	ret    

80107e53 <sys_fork>:
#endif


int
sys_fork(void)
{
80107e53:	55                   	push   %ebp
80107e54:	89 e5                	mov    %esp,%ebp
80107e56:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107e59:	e8 ab ce ff ff       	call   80104d09 <fork>
}
80107e5e:	c9                   	leave  
80107e5f:	c3                   	ret    

80107e60 <sys_exit>:

int
sys_exit(void)
{
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	83 ec 08             	sub    $0x8,%esp
  exit();
80107e66:	e8 2d d1 ff ff       	call   80104f98 <exit>
  return 0;  // not reached
80107e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e70:	c9                   	leave  
80107e71:	c3                   	ret    

80107e72 <sys_wait>:

int
sys_wait(void)
{
80107e72:	55                   	push   %ebp
80107e73:	89 e5                	mov    %esp,%ebp
80107e75:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107e78:	e8 13 d3 ff ff       	call   80105190 <wait>
}
80107e7d:	c9                   	leave  
80107e7e:	c3                   	ret    

80107e7f <sys_kill>:

int
sys_kill(void)
{
80107e7f:	55                   	push   %ebp
80107e80:	89 e5                	mov    %esp,%ebp
80107e82:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107e85:	83 ec 08             	sub    $0x8,%esp
80107e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e8b:	50                   	push   %eax
80107e8c:	6a 00                	push   $0x0
80107e8e:	e8 91 ef ff ff       	call   80106e24 <argint>
80107e93:	83 c4 10             	add    $0x10,%esp
80107e96:	85 c0                	test   %eax,%eax
80107e98:	79 07                	jns    80107ea1 <sys_kill+0x22>
    return -1;
80107e9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e9f:	eb 0f                	jmp    80107eb0 <sys_kill+0x31>
  return kill(pid);
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	83 ec 0c             	sub    $0xc,%esp
80107ea7:	50                   	push   %eax
80107ea8:	e8 9d db ff ff       	call   80105a4a <kill>
80107ead:	83 c4 10             	add    $0x10,%esp
}
80107eb0:	c9                   	leave  
80107eb1:	c3                   	ret    

80107eb2 <sys_getpid>:

int
sys_getpid(void)
{
80107eb2:	55                   	push   %ebp
80107eb3:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ebb:	8b 40 10             	mov    0x10(%eax),%eax
}
80107ebe:	5d                   	pop    %ebp
80107ebf:	c3                   	ret    

80107ec0 <sys_sbrk>:

int
sys_sbrk(void)
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107ec6:	83 ec 08             	sub    $0x8,%esp
80107ec9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ecc:	50                   	push   %eax
80107ecd:	6a 00                	push   $0x0
80107ecf:	e8 50 ef ff ff       	call   80106e24 <argint>
80107ed4:	83 c4 10             	add    $0x10,%esp
80107ed7:	85 c0                	test   %eax,%eax
80107ed9:	79 07                	jns    80107ee2 <sys_sbrk+0x22>
    return -1;
80107edb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ee0:	eb 28                	jmp    80107f0a <sys_sbrk+0x4a>
  addr = proc->sz;
80107ee2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ee8:	8b 00                	mov    (%eax),%eax
80107eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ef0:	83 ec 0c             	sub    $0xc,%esp
80107ef3:	50                   	push   %eax
80107ef4:	e8 6d cd ff ff       	call   80104c66 <growproc>
80107ef9:	83 c4 10             	add    $0x10,%esp
80107efc:	85 c0                	test   %eax,%eax
80107efe:	79 07                	jns    80107f07 <sys_sbrk+0x47>
    return -1;
80107f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f05:	eb 03                	jmp    80107f0a <sys_sbrk+0x4a>
  return addr;
80107f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107f0a:	c9                   	leave  
80107f0b:	c3                   	ret    

80107f0c <sys_sleep>:

int
sys_sleep(void)
{
80107f0c:	55                   	push   %ebp
80107f0d:	89 e5                	mov    %esp,%ebp
80107f0f:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107f12:	83 ec 08             	sub    $0x8,%esp
80107f15:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f18:	50                   	push   %eax
80107f19:	6a 00                	push   $0x0
80107f1b:	e8 04 ef ff ff       	call   80106e24 <argint>
80107f20:	83 c4 10             	add    $0x10,%esp
80107f23:	85 c0                	test   %eax,%eax
80107f25:	79 07                	jns    80107f2e <sys_sleep+0x22>
    return -1;
80107f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f2c:	eb 44                	jmp    80107f72 <sys_sleep+0x66>
  ticks0 = ticks;
80107f2e:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107f36:	eb 26                	jmp    80107f5e <sys_sleep+0x52>
    if(proc->killed){
80107f38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f3e:	8b 40 24             	mov    0x24(%eax),%eax
80107f41:	85 c0                	test   %eax,%eax
80107f43:	74 07                	je     80107f4c <sys_sleep+0x40>
      return -1;
80107f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f4a:	eb 26                	jmp    80107f72 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107f4c:	83 ec 08             	sub    $0x8,%esp
80107f4f:	6a 00                	push   $0x0
80107f51:	68 20 79 11 80       	push   $0x80117920
80107f56:	e8 c8 d8 ff ff       	call   80105823 <sleep>
80107f5b:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107f5e:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f63:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f66:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f69:	39 d0                	cmp    %edx,%eax
80107f6b:	72 cb                	jb     80107f38 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f72:	c9                   	leave  
80107f73:	c3                   	ret    

80107f74 <sys_date>:

#ifdef CS333_P1
int
sys_date(void)
{
80107f74:	55                   	push   %ebp
80107f75:	89 e5                	mov    %esp,%ebp
80107f77:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80107f7a:	83 ec 04             	sub    $0x4,%esp
80107f7d:	6a 18                	push   $0x18
80107f7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f82:	50                   	push   %eax
80107f83:	6a 00                	push   $0x0
80107f85:	e8 c2 ee ff ff       	call   80106e4c <argptr>
80107f8a:	83 c4 10             	add    $0x10,%esp
80107f8d:	85 c0                	test   %eax,%eax
80107f8f:	79 07                	jns    80107f98 <sys_date+0x24>
        return -1;
80107f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f96:	eb 14                	jmp    80107fac <sys_date+0x38>
    cmostime(d);
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	83 ec 0c             	sub    $0xc,%esp
80107f9e:	50                   	push   %eax
80107f9f:	e8 ae b5 ff ff       	call   80103552 <cmostime>
80107fa4:	83 c4 10             	add    $0x10,%esp

    return 0;
80107fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fac:	c9                   	leave  
80107fad:	c3                   	ret    

80107fae <sys_getuid>:
#endif

#ifdef CS333_P2
int
sys_getuid(void)
{
80107fae:	55                   	push   %ebp
80107faf:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80107fb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fb7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107fbd:	5d                   	pop    %ebp
80107fbe:	c3                   	ret    

80107fbf <sys_getgid>:

int
sys_getgid(void)
{
80107fbf:	55                   	push   %ebp
80107fc0:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80107fc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fc8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107fce:	5d                   	pop    %ebp
80107fcf:	c3                   	ret    

80107fd0 <sys_getppid>:

int
sys_getppid(void)
{
80107fd0:	55                   	push   %ebp
80107fd1:	89 e5                	mov    %esp,%ebp
    if(proc->pid == 1)
80107fd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fd9:	8b 40 10             	mov    0x10(%eax),%eax
80107fdc:	83 f8 01             	cmp    $0x1,%eax
80107fdf:	75 07                	jne    80107fe8 <sys_getppid+0x18>
        return 1;
80107fe1:	b8 01 00 00 00       	mov    $0x1,%eax
80107fe6:	eb 0c                	jmp    80107ff4 <sys_getppid+0x24>
    return proc->parent->pid;
80107fe8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fee:	8b 40 14             	mov    0x14(%eax),%eax
80107ff1:	8b 40 10             	mov    0x10(%eax),%eax
}
80107ff4:	5d                   	pop    %ebp
80107ff5:	c3                   	ret    

80107ff6 <sys_setuid>:

int
sys_setuid(void)
{
80107ff6:	55                   	push   %ebp
80107ff7:	89 e5                	mov    %esp,%ebp
80107ff9:	83 ec 18             	sub    $0x18,%esp
    int n;

    if(argint(0, &n) < 0)
80107ffc:	83 ec 08             	sub    $0x8,%esp
80107fff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108002:	50                   	push   %eax
80108003:	6a 00                	push   $0x0
80108005:	e8 1a ee ff ff       	call   80106e24 <argint>
8010800a:	83 c4 10             	add    $0x10,%esp
8010800d:	85 c0                	test   %eax,%eax
8010800f:	79 07                	jns    80108018 <sys_setuid+0x22>
        return -1;
80108011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108016:	eb 2c                	jmp    80108044 <sys_setuid+0x4e>

    if(n > -1 && n < 32768)
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801b:	85 c0                	test   %eax,%eax
8010801d:	78 20                	js     8010803f <sys_setuid+0x49>
8010801f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108022:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80108027:	7f 16                	jg     8010803f <sys_setuid+0x49>
        proc->uid = n;
80108029:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010802f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108032:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    else
        return -1;
        
    return 0;
80108038:	b8 00 00 00 00       	mov    $0x0,%eax
8010803d:	eb 05                	jmp    80108044 <sys_setuid+0x4e>
        return -1;

    if(n > -1 && n < 32768)
        proc->uid = n;
    else
        return -1;
8010803f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        
    return 0;
}
80108044:	c9                   	leave  
80108045:	c3                   	ret    

80108046 <sys_setgid>:

int
sys_setgid(void)
{
80108046:	55                   	push   %ebp
80108047:	89 e5                	mov    %esp,%ebp
80108049:	83 ec 18             	sub    $0x18,%esp
    int n;

    if(argint(0, &n) < 0)
8010804c:	83 ec 08             	sub    $0x8,%esp
8010804f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108052:	50                   	push   %eax
80108053:	6a 00                	push   $0x0
80108055:	e8 ca ed ff ff       	call   80106e24 <argint>
8010805a:	83 c4 10             	add    $0x10,%esp
8010805d:	85 c0                	test   %eax,%eax
8010805f:	79 07                	jns    80108068 <sys_setgid+0x22>
        return -1;
80108061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108066:	eb 2c                	jmp    80108094 <sys_setgid+0x4e>
    if(n > -1 && n < 32768)        
80108068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806b:	85 c0                	test   %eax,%eax
8010806d:	78 20                	js     8010808f <sys_setgid+0x49>
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80108077:	7f 16                	jg     8010808f <sys_setgid+0x49>
        proc->gid = n;
80108079:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010807f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108082:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    else
        return -1;

    return 0;
80108088:	b8 00 00 00 00       	mov    $0x0,%eax
8010808d:	eb 05                	jmp    80108094 <sys_setgid+0x4e>
    if(argint(0, &n) < 0)
        return -1;
    if(n > -1 && n < 32768)        
        proc->gid = n;
    else
        return -1;
8010808f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

    return 0;
}
80108094:	c9                   	leave  
80108095:	c3                   	ret    

80108096 <sys_getprocs>:

int
sys_getprocs(void)
{
80108096:	55                   	push   %ebp
80108097:	89 e5                	mov    %esp,%ebp
80108099:	83 ec 18             	sub    $0x18,%esp
    struct uproc * utable;
    int n;

    if(argint(0, &n) < 0)
8010809c:	83 ec 08             	sub    $0x8,%esp
8010809f:	8d 45 f0             	lea    -0x10(%ebp),%eax
801080a2:	50                   	push   %eax
801080a3:	6a 00                	push   $0x0
801080a5:	e8 7a ed ff ff       	call   80106e24 <argint>
801080aa:	83 c4 10             	add    $0x10,%esp
801080ad:	85 c0                	test   %eax,%eax
801080af:	79 07                	jns    801080b8 <sys_getprocs+0x22>
        return -1;
801080b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080b6:	eb 3e                	jmp    801080f6 <sys_getprocs+0x60>
    if(argptr(1, (void*)&utable, sizeof(struct uproc) * n) < 0)
801080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bb:	89 c2                	mov    %eax,%edx
801080bd:	89 d0                	mov    %edx,%eax
801080bf:	01 c0                	add    %eax,%eax
801080c1:	01 d0                	add    %edx,%eax
801080c3:	c1 e0 05             	shl    $0x5,%eax
801080c6:	83 ec 04             	sub    $0x4,%esp
801080c9:	50                   	push   %eax
801080ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080cd:	50                   	push   %eax
801080ce:	6a 01                	push   $0x1
801080d0:	e8 77 ed ff ff       	call   80106e4c <argptr>
801080d5:	83 c4 10             	add    $0x10,%esp
801080d8:	85 c0                	test   %eax,%eax
801080da:	79 07                	jns    801080e3 <sys_getprocs+0x4d>
        return -1;
801080dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080e1:	eb 13                	jmp    801080f6 <sys_getprocs+0x60>

    return getprocdata(n, utable);
801080e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801080e9:	83 ec 08             	sub    $0x8,%esp
801080ec:	50                   	push   %eax
801080ed:	52                   	push   %edx
801080ee:	e8 b1 dd ff ff       	call   80105ea4 <getprocdata>
801080f3:	83 c4 10             	add    $0x10,%esp
}
801080f6:	c9                   	leave  
801080f7:	c3                   	ret    

801080f8 <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void)
{
801080f8:	55                   	push   %ebp
801080f9:	89 e5                	mov    %esp,%ebp
801080fb:	83 ec 18             	sub    $0x18,%esp
    int pid, priority;

    if(argint(0, &pid) < 0) 
801080fe:	83 ec 08             	sub    $0x8,%esp
80108101:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108104:	50                   	push   %eax
80108105:	6a 00                	push   $0x0
80108107:	e8 18 ed ff ff       	call   80106e24 <argint>
8010810c:	83 c4 10             	add    $0x10,%esp
8010810f:	85 c0                	test   %eax,%eax
80108111:	79 07                	jns    8010811a <sys_setpriority+0x22>
        return -1;
80108113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108118:	eb 55                	jmp    8010816f <sys_setpriority+0x77>
    if(argint(1, &priority) < 0)
8010811a:	83 ec 08             	sub    $0x8,%esp
8010811d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108120:	50                   	push   %eax
80108121:	6a 01                	push   $0x1
80108123:	e8 fc ec ff ff       	call   80106e24 <argint>
80108128:	83 c4 10             	add    $0x10,%esp
8010812b:	85 c0                	test   %eax,%eax
8010812d:	79 07                	jns    80108136 <sys_setpriority+0x3e>
        return -1;
8010812f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108134:	eb 39                	jmp    8010816f <sys_setpriority+0x77>

    if(priority < 0 || priority > MAX) //valid prio
80108136:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108139:	85 c0                	test   %eax,%eax
8010813b:	78 08                	js     80108145 <sys_setpriority+0x4d>
8010813d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108140:	83 f8 06             	cmp    $0x6,%eax
80108143:	7e 07                	jle    8010814c <sys_setpriority+0x54>
        return -1;
80108145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010814a:	eb 23                	jmp    8010816f <sys_setpriority+0x77>
    if(pid < 1) //valid pid
8010814c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814f:	85 c0                	test   %eax,%eax
80108151:	7f 07                	jg     8010815a <sys_setpriority+0x62>
        return -1;
80108153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108158:	eb 15                	jmp    8010816f <sys_setpriority+0x77>

    return setprocpriority(pid, priority);
8010815a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815d:	89 c2                	mov    %eax,%edx
8010815f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108162:	83 ec 08             	sub    $0x8,%esp
80108165:	52                   	push   %edx
80108166:	50                   	push   %eax
80108167:	e8 24 e5 ff ff       	call   80106690 <setprocpriority>
8010816c:	83 c4 10             	add    $0x10,%esp
}
8010816f:	c9                   	leave  
80108170:	c3                   	ret    

80108171 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80108171:	55                   	push   %ebp
80108172:	89 e5                	mov    %esp,%ebp
80108174:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80108177:	a1 20 79 11 80       	mov    0x80117920,%eax
8010817c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
8010817f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108182:	c9                   	leave  
80108183:	c3                   	ret    

80108184 <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
80108184:	55                   	push   %ebp
80108185:	89 e5                	mov    %esp,%ebp
80108187:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
8010818a:	83 ec 0c             	sub    $0xc,%esp
8010818d:	68 e8 a9 10 80       	push   $0x8010a9e8
80108192:	e8 2f 82 ff ff       	call   801003c6 <cprintf>
80108197:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
8010819a:	83 ec 08             	sub    $0x8,%esp
8010819d:	68 00 20 00 00       	push   $0x2000
801081a2:	68 04 06 00 00       	push   $0x604
801081a7:	e8 86 fc ff ff       	call   80107e32 <outw>
801081ac:	83 c4 10             	add    $0x10,%esp
  return 0;
801081af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081b4:	c9                   	leave  
801081b5:	c3                   	ret    

801081b6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801081b6:	55                   	push   %ebp
801081b7:	89 e5                	mov    %esp,%ebp
801081b9:	83 ec 08             	sub    $0x8,%esp
801081bc:	8b 55 08             	mov    0x8(%ebp),%edx
801081bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801081c2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801081c6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801081c9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801081cd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801081d1:	ee                   	out    %al,(%dx)
}
801081d2:	90                   	nop
801081d3:	c9                   	leave  
801081d4:	c3                   	ret    

801081d5 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801081d5:	55                   	push   %ebp
801081d6:	89 e5                	mov    %esp,%ebp
801081d8:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801081db:	6a 34                	push   $0x34
801081dd:	6a 43                	push   $0x43
801081df:	e8 d2 ff ff ff       	call   801081b6 <outb>
801081e4:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
801081e7:	68 a9 00 00 00       	push   $0xa9
801081ec:	6a 40                	push   $0x40
801081ee:	e8 c3 ff ff ff       	call   801081b6 <outb>
801081f3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
801081f6:	6a 04                	push   $0x4
801081f8:	6a 40                	push   $0x40
801081fa:	e8 b7 ff ff ff       	call   801081b6 <outb>
801081ff:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80108202:	83 ec 0c             	sub    $0xc,%esp
80108205:	6a 00                	push   $0x0
80108207:	e8 a9 c0 ff ff       	call   801042b5 <picenable>
8010820c:	83 c4 10             	add    $0x10,%esp
}
8010820f:	90                   	nop
80108210:	c9                   	leave  
80108211:	c3                   	ret    

80108212 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80108212:	1e                   	push   %ds
  pushl %es
80108213:	06                   	push   %es
  pushl %fs
80108214:	0f a0                	push   %fs
  pushl %gs
80108216:	0f a8                	push   %gs
  pushal
80108218:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108219:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010821d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010821f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108221:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80108225:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80108227:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108229:	54                   	push   %esp
  call trap
8010822a:	e8 ce 01 00 00       	call   801083fd <trap>
  addl $4, %esp
8010822f:	83 c4 04             	add    $0x4,%esp

80108232 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80108232:	61                   	popa   
  popl %gs
80108233:	0f a9                	pop    %gs
  popl %fs
80108235:	0f a1                	pop    %fs
  popl %es
80108237:	07                   	pop    %es
  popl %ds
80108238:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108239:	83 c4 08             	add    $0x8,%esp
  iret
8010823c:	cf                   	iret   

8010823d <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
8010823d:	55                   	push   %ebp
8010823e:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80108240:	8b 45 08             	mov    0x8(%ebp),%eax
80108243:	f0 ff 00             	lock incl (%eax)
}
80108246:	90                   	nop
80108247:	5d                   	pop    %ebp
80108248:	c3                   	ret    

80108249 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80108249:	55                   	push   %ebp
8010824a:	89 e5                	mov    %esp,%ebp
8010824c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010824f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108252:	83 e8 01             	sub    $0x1,%eax
80108255:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108259:	8b 45 08             	mov    0x8(%ebp),%eax
8010825c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108260:	8b 45 08             	mov    0x8(%ebp),%eax
80108263:	c1 e8 10             	shr    $0x10,%eax
80108266:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010826a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010826d:	0f 01 18             	lidtl  (%eax)
}
80108270:	90                   	nop
80108271:	c9                   	leave  
80108272:	c3                   	ret    

80108273 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80108273:	55                   	push   %ebp
80108274:	89 e5                	mov    %esp,%ebp
80108276:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108279:	0f 20 d0             	mov    %cr2,%eax
8010827c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010827f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108282:	c9                   	leave  
80108283:	c3                   	ret    

80108284 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80108284:	55                   	push   %ebp
80108285:	89 e5                	mov    %esp,%ebp
80108287:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
8010828a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108291:	e9 c3 00 00 00       	jmp    80108359 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80108296:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108299:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
801082a0:	89 c2                	mov    %eax,%edx
801082a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082a5:	66 89 14 c5 20 71 11 	mov    %dx,-0x7fee8ee0(,%eax,8)
801082ac:	80 
801082ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082b0:	66 c7 04 c5 22 71 11 	movw   $0x8,-0x7fee8ede(,%eax,8)
801082b7:	80 08 00 
801082ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082bd:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
801082c4:	80 
801082c5:	83 e2 e0             	and    $0xffffffe0,%edx
801082c8:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
801082cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082d2:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
801082d9:	80 
801082da:	83 e2 1f             	and    $0x1f,%edx
801082dd:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
801082e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082e7:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082ee:	80 
801082ef:	83 e2 f0             	and    $0xfffffff0,%edx
801082f2:	83 ca 0e             	or     $0xe,%edx
801082f5:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082ff:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80108306:	80 
80108307:	83 e2 ef             	and    $0xffffffef,%edx
8010830a:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80108311:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108314:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
8010831b:	80 
8010831c:	83 e2 9f             	and    $0xffffff9f,%edx
8010831f:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80108326:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108329:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80108330:	80 
80108331:	83 ca 80             	or     $0xffffff80,%edx
80108334:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
8010833b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010833e:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80108345:	c1 e8 10             	shr    $0x10,%eax
80108348:	89 c2                	mov    %eax,%edx
8010834a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010834d:	66 89 14 c5 26 71 11 	mov    %dx,-0x7fee8eda(,%eax,8)
80108354:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80108355:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108359:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80108360:	0f 8e 30 ff ff ff    	jle    80108296 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80108366:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
8010836b:	66 a3 20 73 11 80    	mov    %ax,0x80117320
80108371:	66 c7 05 22 73 11 80 	movw   $0x8,0x80117322
80108378:	08 00 
8010837a:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108381:	83 e0 e0             	and    $0xffffffe0,%eax
80108384:	a2 24 73 11 80       	mov    %al,0x80117324
80108389:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108390:	83 e0 1f             	and    $0x1f,%eax
80108393:	a2 24 73 11 80       	mov    %al,0x80117324
80108398:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
8010839f:	83 c8 0f             	or     $0xf,%eax
801083a2:	a2 25 73 11 80       	mov    %al,0x80117325
801083a7:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
801083ae:	83 e0 ef             	and    $0xffffffef,%eax
801083b1:	a2 25 73 11 80       	mov    %al,0x80117325
801083b6:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
801083bd:	83 c8 60             	or     $0x60,%eax
801083c0:	a2 25 73 11 80       	mov    %al,0x80117325
801083c5:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
801083cc:	83 c8 80             	or     $0xffffff80,%eax
801083cf:	a2 25 73 11 80       	mov    %al,0x80117325
801083d4:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
801083d9:	c1 e8 10             	shr    $0x10,%eax
801083dc:	66 a3 26 73 11 80    	mov    %ax,0x80117326
  
}
801083e2:	90                   	nop
801083e3:	c9                   	leave  
801083e4:	c3                   	ret    

801083e5 <idtinit>:

void
idtinit(void)
{
801083e5:	55                   	push   %ebp
801083e6:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801083e8:	68 00 08 00 00       	push   $0x800
801083ed:	68 20 71 11 80       	push   $0x80117120
801083f2:	e8 52 fe ff ff       	call   80108249 <lidt>
801083f7:	83 c4 08             	add    $0x8,%esp
}
801083fa:	90                   	nop
801083fb:	c9                   	leave  
801083fc:	c3                   	ret    

801083fd <trap>:

void
trap(struct trapframe *tf)
{
801083fd:	55                   	push   %ebp
801083fe:	89 e5                	mov    %esp,%ebp
80108400:	57                   	push   %edi
80108401:	56                   	push   %esi
80108402:	53                   	push   %ebx
80108403:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80108406:	8b 45 08             	mov    0x8(%ebp),%eax
80108409:	8b 40 30             	mov    0x30(%eax),%eax
8010840c:	83 f8 40             	cmp    $0x40,%eax
8010840f:	75 3e                	jne    8010844f <trap+0x52>
    if(proc->killed)
80108411:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108417:	8b 40 24             	mov    0x24(%eax),%eax
8010841a:	85 c0                	test   %eax,%eax
8010841c:	74 05                	je     80108423 <trap+0x26>
      exit();
8010841e:	e8 75 cb ff ff       	call   80104f98 <exit>
    proc->tf = tf;
80108423:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108429:	8b 55 08             	mov    0x8(%ebp),%edx
8010842c:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010842f:	e8 a6 ea ff ff       	call   80106eda <syscall>
    if(proc->killed)
80108434:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010843a:	8b 40 24             	mov    0x24(%eax),%eax
8010843d:	85 c0                	test   %eax,%eax
8010843f:	0f 84 21 02 00 00    	je     80108666 <trap+0x269>
      exit();
80108445:	e8 4e cb ff ff       	call   80104f98 <exit>
    return;
8010844a:	e9 17 02 00 00       	jmp    80108666 <trap+0x269>
  }

  switch(tf->trapno){
8010844f:	8b 45 08             	mov    0x8(%ebp),%eax
80108452:	8b 40 30             	mov    0x30(%eax),%eax
80108455:	83 e8 20             	sub    $0x20,%eax
80108458:	83 f8 1f             	cmp    $0x1f,%eax
8010845b:	0f 87 a3 00 00 00    	ja     80108504 <trap+0x107>
80108461:	8b 04 85 9c aa 10 80 	mov    -0x7fef5564(,%eax,4),%eax
80108468:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010846a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108470:	0f b6 00             	movzbl (%eax),%eax
80108473:	84 c0                	test   %al,%al
80108475:	75 20                	jne    80108497 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108477:	83 ec 0c             	sub    $0xc,%esp
8010847a:	68 20 79 11 80       	push   $0x80117920
8010847f:	e8 b9 fd ff ff       	call   8010823d <atom_inc>
80108484:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108487:	83 ec 0c             	sub    $0xc,%esp
8010848a:	68 20 79 11 80       	push   $0x80117920
8010848f:	e8 7f d5 ff ff       	call   80105a13 <wakeup>
80108494:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108497:	e8 13 af ff ff       	call   801033af <lapiceoi>
    break;
8010849c:	e9 1c 01 00 00       	jmp    801085bd <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801084a1:	e8 1c a7 ff ff       	call   80102bc2 <ideintr>
    lapiceoi();
801084a6:	e8 04 af ff ff       	call   801033af <lapiceoi>
    break;
801084ab:	e9 0d 01 00 00       	jmp    801085bd <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801084b0:	e8 fc ac ff ff       	call   801031b1 <kbdintr>
    lapiceoi();
801084b5:	e8 f5 ae ff ff       	call   801033af <lapiceoi>
    break;
801084ba:	e9 fe 00 00 00       	jmp    801085bd <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801084bf:	e8 83 03 00 00       	call   80108847 <uartintr>
    lapiceoi();
801084c4:	e8 e6 ae ff ff       	call   801033af <lapiceoi>
    break;
801084c9:	e9 ef 00 00 00       	jmp    801085bd <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801084ce:	8b 45 08             	mov    0x8(%ebp),%eax
801084d1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801084d4:	8b 45 08             	mov    0x8(%ebp),%eax
801084d7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801084db:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801084de:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084e4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801084e7:	0f b6 c0             	movzbl %al,%eax
801084ea:	51                   	push   %ecx
801084eb:	52                   	push   %edx
801084ec:	50                   	push   %eax
801084ed:	68 fc a9 10 80       	push   $0x8010a9fc
801084f2:	e8 cf 7e ff ff       	call   801003c6 <cprintf>
801084f7:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801084fa:	e8 b0 ae ff ff       	call   801033af <lapiceoi>
    break;
801084ff:	e9 b9 00 00 00       	jmp    801085bd <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80108504:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010850a:	85 c0                	test   %eax,%eax
8010850c:	74 11                	je     8010851f <trap+0x122>
8010850e:	8b 45 08             	mov    0x8(%ebp),%eax
80108511:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108515:	0f b7 c0             	movzwl %ax,%eax
80108518:	83 e0 03             	and    $0x3,%eax
8010851b:	85 c0                	test   %eax,%eax
8010851d:	75 40                	jne    8010855f <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010851f:	e8 4f fd ff ff       	call   80108273 <rcr2>
80108524:	89 c3                	mov    %eax,%ebx
80108526:	8b 45 08             	mov    0x8(%ebp),%eax
80108529:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010852c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108532:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108535:	0f b6 d0             	movzbl %al,%edx
80108538:	8b 45 08             	mov    0x8(%ebp),%eax
8010853b:	8b 40 30             	mov    0x30(%eax),%eax
8010853e:	83 ec 0c             	sub    $0xc,%esp
80108541:	53                   	push   %ebx
80108542:	51                   	push   %ecx
80108543:	52                   	push   %edx
80108544:	50                   	push   %eax
80108545:	68 20 aa 10 80       	push   $0x8010aa20
8010854a:	e8 77 7e ff ff       	call   801003c6 <cprintf>
8010854f:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80108552:	83 ec 0c             	sub    $0xc,%esp
80108555:	68 52 aa 10 80       	push   $0x8010aa52
8010855a:	e8 07 80 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010855f:	e8 0f fd ff ff       	call   80108273 <rcr2>
80108564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108567:	8b 45 08             	mov    0x8(%ebp),%eax
8010856a:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010856d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108573:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108576:	0f b6 d8             	movzbl %al,%ebx
80108579:	8b 45 08             	mov    0x8(%ebp),%eax
8010857c:	8b 48 34             	mov    0x34(%eax),%ecx
8010857f:	8b 45 08             	mov    0x8(%ebp),%eax
80108582:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108585:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010858b:	8d 78 6c             	lea    0x6c(%eax),%edi
8010858e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108594:	8b 40 10             	mov    0x10(%eax),%eax
80108597:	ff 75 e4             	pushl  -0x1c(%ebp)
8010859a:	56                   	push   %esi
8010859b:	53                   	push   %ebx
8010859c:	51                   	push   %ecx
8010859d:	52                   	push   %edx
8010859e:	57                   	push   %edi
8010859f:	50                   	push   %eax
801085a0:	68 58 aa 10 80       	push   $0x8010aa58
801085a5:	e8 1c 7e ff ff       	call   801003c6 <cprintf>
801085aa:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801085ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801085ba:	eb 01                	jmp    801085bd <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801085bc:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801085bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085c3:	85 c0                	test   %eax,%eax
801085c5:	74 24                	je     801085eb <trap+0x1ee>
801085c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085cd:	8b 40 24             	mov    0x24(%eax),%eax
801085d0:	85 c0                	test   %eax,%eax
801085d2:	74 17                	je     801085eb <trap+0x1ee>
801085d4:	8b 45 08             	mov    0x8(%ebp),%eax
801085d7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801085db:	0f b7 c0             	movzwl %ax,%eax
801085de:	83 e0 03             	and    $0x3,%eax
801085e1:	83 f8 03             	cmp    $0x3,%eax
801085e4:	75 05                	jne    801085eb <trap+0x1ee>
    exit();
801085e6:	e8 ad c9 ff ff       	call   80104f98 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801085eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085f1:	85 c0                	test   %eax,%eax
801085f3:	74 41                	je     80108636 <trap+0x239>
801085f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085fb:	8b 40 0c             	mov    0xc(%eax),%eax
801085fe:	83 f8 04             	cmp    $0x4,%eax
80108601:	75 33                	jne    80108636 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108603:	8b 45 08             	mov    0x8(%ebp),%eax
80108606:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108609:	83 f8 20             	cmp    $0x20,%eax
8010860c:	75 28                	jne    80108636 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010860e:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80108614:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80108619:	89 c8                	mov    %ecx,%eax
8010861b:	f7 e2                	mul    %edx
8010861d:	c1 ea 03             	shr    $0x3,%edx
80108620:	89 d0                	mov    %edx,%eax
80108622:	c1 e0 02             	shl    $0x2,%eax
80108625:	01 d0                	add    %edx,%eax
80108627:	01 c0                	add    %eax,%eax
80108629:	29 c1                	sub    %eax,%ecx
8010862b:	89 ca                	mov    %ecx,%edx
8010862d:	85 d2                	test   %edx,%edx
8010862f:	75 05                	jne    80108636 <trap+0x239>
    yield();
80108631:	e8 ca d0 ff ff       	call   80105700 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108636:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010863c:	85 c0                	test   %eax,%eax
8010863e:	74 27                	je     80108667 <trap+0x26a>
80108640:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108646:	8b 40 24             	mov    0x24(%eax),%eax
80108649:	85 c0                	test   %eax,%eax
8010864b:	74 1a                	je     80108667 <trap+0x26a>
8010864d:	8b 45 08             	mov    0x8(%ebp),%eax
80108650:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108654:	0f b7 c0             	movzwl %ax,%eax
80108657:	83 e0 03             	and    $0x3,%eax
8010865a:	83 f8 03             	cmp    $0x3,%eax
8010865d:	75 08                	jne    80108667 <trap+0x26a>
    exit();
8010865f:	e8 34 c9 ff ff       	call   80104f98 <exit>
80108664:	eb 01                	jmp    80108667 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80108666:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80108667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010866a:	5b                   	pop    %ebx
8010866b:	5e                   	pop    %esi
8010866c:	5f                   	pop    %edi
8010866d:	5d                   	pop    %ebp
8010866e:	c3                   	ret    

8010866f <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010866f:	55                   	push   %ebp
80108670:	89 e5                	mov    %esp,%ebp
80108672:	83 ec 14             	sub    $0x14,%esp
80108675:	8b 45 08             	mov    0x8(%ebp),%eax
80108678:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010867c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108680:	89 c2                	mov    %eax,%edx
80108682:	ec                   	in     (%dx),%al
80108683:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108686:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010868a:	c9                   	leave  
8010868b:	c3                   	ret    

8010868c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010868c:	55                   	push   %ebp
8010868d:	89 e5                	mov    %esp,%ebp
8010868f:	83 ec 08             	sub    $0x8,%esp
80108692:	8b 55 08             	mov    0x8(%ebp),%edx
80108695:	8b 45 0c             	mov    0xc(%ebp),%eax
80108698:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010869c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010869f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801086a3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801086a7:	ee                   	out    %al,(%dx)
}
801086a8:	90                   	nop
801086a9:	c9                   	leave  
801086aa:	c3                   	ret    

801086ab <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801086ab:	55                   	push   %ebp
801086ac:	89 e5                	mov    %esp,%ebp
801086ae:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801086b1:	6a 00                	push   $0x0
801086b3:	68 fa 03 00 00       	push   $0x3fa
801086b8:	e8 cf ff ff ff       	call   8010868c <outb>
801086bd:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801086c0:	68 80 00 00 00       	push   $0x80
801086c5:	68 fb 03 00 00       	push   $0x3fb
801086ca:	e8 bd ff ff ff       	call   8010868c <outb>
801086cf:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801086d2:	6a 0c                	push   $0xc
801086d4:	68 f8 03 00 00       	push   $0x3f8
801086d9:	e8 ae ff ff ff       	call   8010868c <outb>
801086de:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801086e1:	6a 00                	push   $0x0
801086e3:	68 f9 03 00 00       	push   $0x3f9
801086e8:	e8 9f ff ff ff       	call   8010868c <outb>
801086ed:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801086f0:	6a 03                	push   $0x3
801086f2:	68 fb 03 00 00       	push   $0x3fb
801086f7:	e8 90 ff ff ff       	call   8010868c <outb>
801086fc:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801086ff:	6a 00                	push   $0x0
80108701:	68 fc 03 00 00       	push   $0x3fc
80108706:	e8 81 ff ff ff       	call   8010868c <outb>
8010870b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010870e:	6a 01                	push   $0x1
80108710:	68 f9 03 00 00       	push   $0x3f9
80108715:	e8 72 ff ff ff       	call   8010868c <outb>
8010871a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010871d:	68 fd 03 00 00       	push   $0x3fd
80108722:	e8 48 ff ff ff       	call   8010866f <inb>
80108727:	83 c4 04             	add    $0x4,%esp
8010872a:	3c ff                	cmp    $0xff,%al
8010872c:	74 6e                	je     8010879c <uartinit+0xf1>
    return;
  uart = 1;
8010872e:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
80108735:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108738:	68 fa 03 00 00       	push   $0x3fa
8010873d:	e8 2d ff ff ff       	call   8010866f <inb>
80108742:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80108745:	68 f8 03 00 00       	push   $0x3f8
8010874a:	e8 20 ff ff ff       	call   8010866f <inb>
8010874f:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80108752:	83 ec 0c             	sub    $0xc,%esp
80108755:	6a 04                	push   $0x4
80108757:	e8 59 bb ff ff       	call   801042b5 <picenable>
8010875c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010875f:	83 ec 08             	sub    $0x8,%esp
80108762:	6a 00                	push   $0x0
80108764:	6a 04                	push   $0x4
80108766:	e8 f9 a6 ff ff       	call   80102e64 <ioapicenable>
8010876b:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010876e:	c7 45 f4 1c ab 10 80 	movl   $0x8010ab1c,-0xc(%ebp)
80108775:	eb 19                	jmp    80108790 <uartinit+0xe5>
    uartputc(*p);
80108777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877a:	0f b6 00             	movzbl (%eax),%eax
8010877d:	0f be c0             	movsbl %al,%eax
80108780:	83 ec 0c             	sub    $0xc,%esp
80108783:	50                   	push   %eax
80108784:	e8 16 00 00 00       	call   8010879f <uartputc>
80108789:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010878c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108793:	0f b6 00             	movzbl (%eax),%eax
80108796:	84 c0                	test   %al,%al
80108798:	75 dd                	jne    80108777 <uartinit+0xcc>
8010879a:	eb 01                	jmp    8010879d <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010879c:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010879d:	c9                   	leave  
8010879e:	c3                   	ret    

8010879f <uartputc>:

void
uartputc(int c)
{
8010879f:	55                   	push   %ebp
801087a0:	89 e5                	mov    %esp,%ebp
801087a2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801087a5:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
801087aa:	85 c0                	test   %eax,%eax
801087ac:	74 53                	je     80108801 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801087ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087b5:	eb 11                	jmp    801087c8 <uartputc+0x29>
    microdelay(10);
801087b7:	83 ec 0c             	sub    $0xc,%esp
801087ba:	6a 0a                	push   $0xa
801087bc:	e8 09 ac ff ff       	call   801033ca <microdelay>
801087c1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801087c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801087c8:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801087cc:	7f 1a                	jg     801087e8 <uartputc+0x49>
801087ce:	83 ec 0c             	sub    $0xc,%esp
801087d1:	68 fd 03 00 00       	push   $0x3fd
801087d6:	e8 94 fe ff ff       	call   8010866f <inb>
801087db:	83 c4 10             	add    $0x10,%esp
801087de:	0f b6 c0             	movzbl %al,%eax
801087e1:	83 e0 20             	and    $0x20,%eax
801087e4:	85 c0                	test   %eax,%eax
801087e6:	74 cf                	je     801087b7 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801087e8:	8b 45 08             	mov    0x8(%ebp),%eax
801087eb:	0f b6 c0             	movzbl %al,%eax
801087ee:	83 ec 08             	sub    $0x8,%esp
801087f1:	50                   	push   %eax
801087f2:	68 f8 03 00 00       	push   $0x3f8
801087f7:	e8 90 fe ff ff       	call   8010868c <outb>
801087fc:	83 c4 10             	add    $0x10,%esp
801087ff:	eb 01                	jmp    80108802 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108801:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108802:	c9                   	leave  
80108803:	c3                   	ret    

80108804 <uartgetc>:

static int
uartgetc(void)
{
80108804:	55                   	push   %ebp
80108805:	89 e5                	mov    %esp,%ebp
  if(!uart)
80108807:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
8010880c:	85 c0                	test   %eax,%eax
8010880e:	75 07                	jne    80108817 <uartgetc+0x13>
    return -1;
80108810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108815:	eb 2e                	jmp    80108845 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80108817:	68 fd 03 00 00       	push   $0x3fd
8010881c:	e8 4e fe ff ff       	call   8010866f <inb>
80108821:	83 c4 04             	add    $0x4,%esp
80108824:	0f b6 c0             	movzbl %al,%eax
80108827:	83 e0 01             	and    $0x1,%eax
8010882a:	85 c0                	test   %eax,%eax
8010882c:	75 07                	jne    80108835 <uartgetc+0x31>
    return -1;
8010882e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108833:	eb 10                	jmp    80108845 <uartgetc+0x41>
  return inb(COM1+0);
80108835:	68 f8 03 00 00       	push   $0x3f8
8010883a:	e8 30 fe ff ff       	call   8010866f <inb>
8010883f:	83 c4 04             	add    $0x4,%esp
80108842:	0f b6 c0             	movzbl %al,%eax
}
80108845:	c9                   	leave  
80108846:	c3                   	ret    

80108847 <uartintr>:

void
uartintr(void)
{
80108847:	55                   	push   %ebp
80108848:	89 e5                	mov    %esp,%ebp
8010884a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010884d:	83 ec 0c             	sub    $0xc,%esp
80108850:	68 04 88 10 80       	push   $0x80108804
80108855:	e8 9f 7f ff ff       	call   801007f9 <consoleintr>
8010885a:	83 c4 10             	add    $0x10,%esp
}
8010885d:	90                   	nop
8010885e:	c9                   	leave  
8010885f:	c3                   	ret    

80108860 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108860:	6a 00                	push   $0x0
  pushl $0
80108862:	6a 00                	push   $0x0
  jmp alltraps
80108864:	e9 a9 f9 ff ff       	jmp    80108212 <alltraps>

80108869 <vector1>:
.globl vector1
vector1:
  pushl $0
80108869:	6a 00                	push   $0x0
  pushl $1
8010886b:	6a 01                	push   $0x1
  jmp alltraps
8010886d:	e9 a0 f9 ff ff       	jmp    80108212 <alltraps>

80108872 <vector2>:
.globl vector2
vector2:
  pushl $0
80108872:	6a 00                	push   $0x0
  pushl $2
80108874:	6a 02                	push   $0x2
  jmp alltraps
80108876:	e9 97 f9 ff ff       	jmp    80108212 <alltraps>

8010887b <vector3>:
.globl vector3
vector3:
  pushl $0
8010887b:	6a 00                	push   $0x0
  pushl $3
8010887d:	6a 03                	push   $0x3
  jmp alltraps
8010887f:	e9 8e f9 ff ff       	jmp    80108212 <alltraps>

80108884 <vector4>:
.globl vector4
vector4:
  pushl $0
80108884:	6a 00                	push   $0x0
  pushl $4
80108886:	6a 04                	push   $0x4
  jmp alltraps
80108888:	e9 85 f9 ff ff       	jmp    80108212 <alltraps>

8010888d <vector5>:
.globl vector5
vector5:
  pushl $0
8010888d:	6a 00                	push   $0x0
  pushl $5
8010888f:	6a 05                	push   $0x5
  jmp alltraps
80108891:	e9 7c f9 ff ff       	jmp    80108212 <alltraps>

80108896 <vector6>:
.globl vector6
vector6:
  pushl $0
80108896:	6a 00                	push   $0x0
  pushl $6
80108898:	6a 06                	push   $0x6
  jmp alltraps
8010889a:	e9 73 f9 ff ff       	jmp    80108212 <alltraps>

8010889f <vector7>:
.globl vector7
vector7:
  pushl $0
8010889f:	6a 00                	push   $0x0
  pushl $7
801088a1:	6a 07                	push   $0x7
  jmp alltraps
801088a3:	e9 6a f9 ff ff       	jmp    80108212 <alltraps>

801088a8 <vector8>:
.globl vector8
vector8:
  pushl $8
801088a8:	6a 08                	push   $0x8
  jmp alltraps
801088aa:	e9 63 f9 ff ff       	jmp    80108212 <alltraps>

801088af <vector9>:
.globl vector9
vector9:
  pushl $0
801088af:	6a 00                	push   $0x0
  pushl $9
801088b1:	6a 09                	push   $0x9
  jmp alltraps
801088b3:	e9 5a f9 ff ff       	jmp    80108212 <alltraps>

801088b8 <vector10>:
.globl vector10
vector10:
  pushl $10
801088b8:	6a 0a                	push   $0xa
  jmp alltraps
801088ba:	e9 53 f9 ff ff       	jmp    80108212 <alltraps>

801088bf <vector11>:
.globl vector11
vector11:
  pushl $11
801088bf:	6a 0b                	push   $0xb
  jmp alltraps
801088c1:	e9 4c f9 ff ff       	jmp    80108212 <alltraps>

801088c6 <vector12>:
.globl vector12
vector12:
  pushl $12
801088c6:	6a 0c                	push   $0xc
  jmp alltraps
801088c8:	e9 45 f9 ff ff       	jmp    80108212 <alltraps>

801088cd <vector13>:
.globl vector13
vector13:
  pushl $13
801088cd:	6a 0d                	push   $0xd
  jmp alltraps
801088cf:	e9 3e f9 ff ff       	jmp    80108212 <alltraps>

801088d4 <vector14>:
.globl vector14
vector14:
  pushl $14
801088d4:	6a 0e                	push   $0xe
  jmp alltraps
801088d6:	e9 37 f9 ff ff       	jmp    80108212 <alltraps>

801088db <vector15>:
.globl vector15
vector15:
  pushl $0
801088db:	6a 00                	push   $0x0
  pushl $15
801088dd:	6a 0f                	push   $0xf
  jmp alltraps
801088df:	e9 2e f9 ff ff       	jmp    80108212 <alltraps>

801088e4 <vector16>:
.globl vector16
vector16:
  pushl $0
801088e4:	6a 00                	push   $0x0
  pushl $16
801088e6:	6a 10                	push   $0x10
  jmp alltraps
801088e8:	e9 25 f9 ff ff       	jmp    80108212 <alltraps>

801088ed <vector17>:
.globl vector17
vector17:
  pushl $17
801088ed:	6a 11                	push   $0x11
  jmp alltraps
801088ef:	e9 1e f9 ff ff       	jmp    80108212 <alltraps>

801088f4 <vector18>:
.globl vector18
vector18:
  pushl $0
801088f4:	6a 00                	push   $0x0
  pushl $18
801088f6:	6a 12                	push   $0x12
  jmp alltraps
801088f8:	e9 15 f9 ff ff       	jmp    80108212 <alltraps>

801088fd <vector19>:
.globl vector19
vector19:
  pushl $0
801088fd:	6a 00                	push   $0x0
  pushl $19
801088ff:	6a 13                	push   $0x13
  jmp alltraps
80108901:	e9 0c f9 ff ff       	jmp    80108212 <alltraps>

80108906 <vector20>:
.globl vector20
vector20:
  pushl $0
80108906:	6a 00                	push   $0x0
  pushl $20
80108908:	6a 14                	push   $0x14
  jmp alltraps
8010890a:	e9 03 f9 ff ff       	jmp    80108212 <alltraps>

8010890f <vector21>:
.globl vector21
vector21:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $21
80108911:	6a 15                	push   $0x15
  jmp alltraps
80108913:	e9 fa f8 ff ff       	jmp    80108212 <alltraps>

80108918 <vector22>:
.globl vector22
vector22:
  pushl $0
80108918:	6a 00                	push   $0x0
  pushl $22
8010891a:	6a 16                	push   $0x16
  jmp alltraps
8010891c:	e9 f1 f8 ff ff       	jmp    80108212 <alltraps>

80108921 <vector23>:
.globl vector23
vector23:
  pushl $0
80108921:	6a 00                	push   $0x0
  pushl $23
80108923:	6a 17                	push   $0x17
  jmp alltraps
80108925:	e9 e8 f8 ff ff       	jmp    80108212 <alltraps>

8010892a <vector24>:
.globl vector24
vector24:
  pushl $0
8010892a:	6a 00                	push   $0x0
  pushl $24
8010892c:	6a 18                	push   $0x18
  jmp alltraps
8010892e:	e9 df f8 ff ff       	jmp    80108212 <alltraps>

80108933 <vector25>:
.globl vector25
vector25:
  pushl $0
80108933:	6a 00                	push   $0x0
  pushl $25
80108935:	6a 19                	push   $0x19
  jmp alltraps
80108937:	e9 d6 f8 ff ff       	jmp    80108212 <alltraps>

8010893c <vector26>:
.globl vector26
vector26:
  pushl $0
8010893c:	6a 00                	push   $0x0
  pushl $26
8010893e:	6a 1a                	push   $0x1a
  jmp alltraps
80108940:	e9 cd f8 ff ff       	jmp    80108212 <alltraps>

80108945 <vector27>:
.globl vector27
vector27:
  pushl $0
80108945:	6a 00                	push   $0x0
  pushl $27
80108947:	6a 1b                	push   $0x1b
  jmp alltraps
80108949:	e9 c4 f8 ff ff       	jmp    80108212 <alltraps>

8010894e <vector28>:
.globl vector28
vector28:
  pushl $0
8010894e:	6a 00                	push   $0x0
  pushl $28
80108950:	6a 1c                	push   $0x1c
  jmp alltraps
80108952:	e9 bb f8 ff ff       	jmp    80108212 <alltraps>

80108957 <vector29>:
.globl vector29
vector29:
  pushl $0
80108957:	6a 00                	push   $0x0
  pushl $29
80108959:	6a 1d                	push   $0x1d
  jmp alltraps
8010895b:	e9 b2 f8 ff ff       	jmp    80108212 <alltraps>

80108960 <vector30>:
.globl vector30
vector30:
  pushl $0
80108960:	6a 00                	push   $0x0
  pushl $30
80108962:	6a 1e                	push   $0x1e
  jmp alltraps
80108964:	e9 a9 f8 ff ff       	jmp    80108212 <alltraps>

80108969 <vector31>:
.globl vector31
vector31:
  pushl $0
80108969:	6a 00                	push   $0x0
  pushl $31
8010896b:	6a 1f                	push   $0x1f
  jmp alltraps
8010896d:	e9 a0 f8 ff ff       	jmp    80108212 <alltraps>

80108972 <vector32>:
.globl vector32
vector32:
  pushl $0
80108972:	6a 00                	push   $0x0
  pushl $32
80108974:	6a 20                	push   $0x20
  jmp alltraps
80108976:	e9 97 f8 ff ff       	jmp    80108212 <alltraps>

8010897b <vector33>:
.globl vector33
vector33:
  pushl $0
8010897b:	6a 00                	push   $0x0
  pushl $33
8010897d:	6a 21                	push   $0x21
  jmp alltraps
8010897f:	e9 8e f8 ff ff       	jmp    80108212 <alltraps>

80108984 <vector34>:
.globl vector34
vector34:
  pushl $0
80108984:	6a 00                	push   $0x0
  pushl $34
80108986:	6a 22                	push   $0x22
  jmp alltraps
80108988:	e9 85 f8 ff ff       	jmp    80108212 <alltraps>

8010898d <vector35>:
.globl vector35
vector35:
  pushl $0
8010898d:	6a 00                	push   $0x0
  pushl $35
8010898f:	6a 23                	push   $0x23
  jmp alltraps
80108991:	e9 7c f8 ff ff       	jmp    80108212 <alltraps>

80108996 <vector36>:
.globl vector36
vector36:
  pushl $0
80108996:	6a 00                	push   $0x0
  pushl $36
80108998:	6a 24                	push   $0x24
  jmp alltraps
8010899a:	e9 73 f8 ff ff       	jmp    80108212 <alltraps>

8010899f <vector37>:
.globl vector37
vector37:
  pushl $0
8010899f:	6a 00                	push   $0x0
  pushl $37
801089a1:	6a 25                	push   $0x25
  jmp alltraps
801089a3:	e9 6a f8 ff ff       	jmp    80108212 <alltraps>

801089a8 <vector38>:
.globl vector38
vector38:
  pushl $0
801089a8:	6a 00                	push   $0x0
  pushl $38
801089aa:	6a 26                	push   $0x26
  jmp alltraps
801089ac:	e9 61 f8 ff ff       	jmp    80108212 <alltraps>

801089b1 <vector39>:
.globl vector39
vector39:
  pushl $0
801089b1:	6a 00                	push   $0x0
  pushl $39
801089b3:	6a 27                	push   $0x27
  jmp alltraps
801089b5:	e9 58 f8 ff ff       	jmp    80108212 <alltraps>

801089ba <vector40>:
.globl vector40
vector40:
  pushl $0
801089ba:	6a 00                	push   $0x0
  pushl $40
801089bc:	6a 28                	push   $0x28
  jmp alltraps
801089be:	e9 4f f8 ff ff       	jmp    80108212 <alltraps>

801089c3 <vector41>:
.globl vector41
vector41:
  pushl $0
801089c3:	6a 00                	push   $0x0
  pushl $41
801089c5:	6a 29                	push   $0x29
  jmp alltraps
801089c7:	e9 46 f8 ff ff       	jmp    80108212 <alltraps>

801089cc <vector42>:
.globl vector42
vector42:
  pushl $0
801089cc:	6a 00                	push   $0x0
  pushl $42
801089ce:	6a 2a                	push   $0x2a
  jmp alltraps
801089d0:	e9 3d f8 ff ff       	jmp    80108212 <alltraps>

801089d5 <vector43>:
.globl vector43
vector43:
  pushl $0
801089d5:	6a 00                	push   $0x0
  pushl $43
801089d7:	6a 2b                	push   $0x2b
  jmp alltraps
801089d9:	e9 34 f8 ff ff       	jmp    80108212 <alltraps>

801089de <vector44>:
.globl vector44
vector44:
  pushl $0
801089de:	6a 00                	push   $0x0
  pushl $44
801089e0:	6a 2c                	push   $0x2c
  jmp alltraps
801089e2:	e9 2b f8 ff ff       	jmp    80108212 <alltraps>

801089e7 <vector45>:
.globl vector45
vector45:
  pushl $0
801089e7:	6a 00                	push   $0x0
  pushl $45
801089e9:	6a 2d                	push   $0x2d
  jmp alltraps
801089eb:	e9 22 f8 ff ff       	jmp    80108212 <alltraps>

801089f0 <vector46>:
.globl vector46
vector46:
  pushl $0
801089f0:	6a 00                	push   $0x0
  pushl $46
801089f2:	6a 2e                	push   $0x2e
  jmp alltraps
801089f4:	e9 19 f8 ff ff       	jmp    80108212 <alltraps>

801089f9 <vector47>:
.globl vector47
vector47:
  pushl $0
801089f9:	6a 00                	push   $0x0
  pushl $47
801089fb:	6a 2f                	push   $0x2f
  jmp alltraps
801089fd:	e9 10 f8 ff ff       	jmp    80108212 <alltraps>

80108a02 <vector48>:
.globl vector48
vector48:
  pushl $0
80108a02:	6a 00                	push   $0x0
  pushl $48
80108a04:	6a 30                	push   $0x30
  jmp alltraps
80108a06:	e9 07 f8 ff ff       	jmp    80108212 <alltraps>

80108a0b <vector49>:
.globl vector49
vector49:
  pushl $0
80108a0b:	6a 00                	push   $0x0
  pushl $49
80108a0d:	6a 31                	push   $0x31
  jmp alltraps
80108a0f:	e9 fe f7 ff ff       	jmp    80108212 <alltraps>

80108a14 <vector50>:
.globl vector50
vector50:
  pushl $0
80108a14:	6a 00                	push   $0x0
  pushl $50
80108a16:	6a 32                	push   $0x32
  jmp alltraps
80108a18:	e9 f5 f7 ff ff       	jmp    80108212 <alltraps>

80108a1d <vector51>:
.globl vector51
vector51:
  pushl $0
80108a1d:	6a 00                	push   $0x0
  pushl $51
80108a1f:	6a 33                	push   $0x33
  jmp alltraps
80108a21:	e9 ec f7 ff ff       	jmp    80108212 <alltraps>

80108a26 <vector52>:
.globl vector52
vector52:
  pushl $0
80108a26:	6a 00                	push   $0x0
  pushl $52
80108a28:	6a 34                	push   $0x34
  jmp alltraps
80108a2a:	e9 e3 f7 ff ff       	jmp    80108212 <alltraps>

80108a2f <vector53>:
.globl vector53
vector53:
  pushl $0
80108a2f:	6a 00                	push   $0x0
  pushl $53
80108a31:	6a 35                	push   $0x35
  jmp alltraps
80108a33:	e9 da f7 ff ff       	jmp    80108212 <alltraps>

80108a38 <vector54>:
.globl vector54
vector54:
  pushl $0
80108a38:	6a 00                	push   $0x0
  pushl $54
80108a3a:	6a 36                	push   $0x36
  jmp alltraps
80108a3c:	e9 d1 f7 ff ff       	jmp    80108212 <alltraps>

80108a41 <vector55>:
.globl vector55
vector55:
  pushl $0
80108a41:	6a 00                	push   $0x0
  pushl $55
80108a43:	6a 37                	push   $0x37
  jmp alltraps
80108a45:	e9 c8 f7 ff ff       	jmp    80108212 <alltraps>

80108a4a <vector56>:
.globl vector56
vector56:
  pushl $0
80108a4a:	6a 00                	push   $0x0
  pushl $56
80108a4c:	6a 38                	push   $0x38
  jmp alltraps
80108a4e:	e9 bf f7 ff ff       	jmp    80108212 <alltraps>

80108a53 <vector57>:
.globl vector57
vector57:
  pushl $0
80108a53:	6a 00                	push   $0x0
  pushl $57
80108a55:	6a 39                	push   $0x39
  jmp alltraps
80108a57:	e9 b6 f7 ff ff       	jmp    80108212 <alltraps>

80108a5c <vector58>:
.globl vector58
vector58:
  pushl $0
80108a5c:	6a 00                	push   $0x0
  pushl $58
80108a5e:	6a 3a                	push   $0x3a
  jmp alltraps
80108a60:	e9 ad f7 ff ff       	jmp    80108212 <alltraps>

80108a65 <vector59>:
.globl vector59
vector59:
  pushl $0
80108a65:	6a 00                	push   $0x0
  pushl $59
80108a67:	6a 3b                	push   $0x3b
  jmp alltraps
80108a69:	e9 a4 f7 ff ff       	jmp    80108212 <alltraps>

80108a6e <vector60>:
.globl vector60
vector60:
  pushl $0
80108a6e:	6a 00                	push   $0x0
  pushl $60
80108a70:	6a 3c                	push   $0x3c
  jmp alltraps
80108a72:	e9 9b f7 ff ff       	jmp    80108212 <alltraps>

80108a77 <vector61>:
.globl vector61
vector61:
  pushl $0
80108a77:	6a 00                	push   $0x0
  pushl $61
80108a79:	6a 3d                	push   $0x3d
  jmp alltraps
80108a7b:	e9 92 f7 ff ff       	jmp    80108212 <alltraps>

80108a80 <vector62>:
.globl vector62
vector62:
  pushl $0
80108a80:	6a 00                	push   $0x0
  pushl $62
80108a82:	6a 3e                	push   $0x3e
  jmp alltraps
80108a84:	e9 89 f7 ff ff       	jmp    80108212 <alltraps>

80108a89 <vector63>:
.globl vector63
vector63:
  pushl $0
80108a89:	6a 00                	push   $0x0
  pushl $63
80108a8b:	6a 3f                	push   $0x3f
  jmp alltraps
80108a8d:	e9 80 f7 ff ff       	jmp    80108212 <alltraps>

80108a92 <vector64>:
.globl vector64
vector64:
  pushl $0
80108a92:	6a 00                	push   $0x0
  pushl $64
80108a94:	6a 40                	push   $0x40
  jmp alltraps
80108a96:	e9 77 f7 ff ff       	jmp    80108212 <alltraps>

80108a9b <vector65>:
.globl vector65
vector65:
  pushl $0
80108a9b:	6a 00                	push   $0x0
  pushl $65
80108a9d:	6a 41                	push   $0x41
  jmp alltraps
80108a9f:	e9 6e f7 ff ff       	jmp    80108212 <alltraps>

80108aa4 <vector66>:
.globl vector66
vector66:
  pushl $0
80108aa4:	6a 00                	push   $0x0
  pushl $66
80108aa6:	6a 42                	push   $0x42
  jmp alltraps
80108aa8:	e9 65 f7 ff ff       	jmp    80108212 <alltraps>

80108aad <vector67>:
.globl vector67
vector67:
  pushl $0
80108aad:	6a 00                	push   $0x0
  pushl $67
80108aaf:	6a 43                	push   $0x43
  jmp alltraps
80108ab1:	e9 5c f7 ff ff       	jmp    80108212 <alltraps>

80108ab6 <vector68>:
.globl vector68
vector68:
  pushl $0
80108ab6:	6a 00                	push   $0x0
  pushl $68
80108ab8:	6a 44                	push   $0x44
  jmp alltraps
80108aba:	e9 53 f7 ff ff       	jmp    80108212 <alltraps>

80108abf <vector69>:
.globl vector69
vector69:
  pushl $0
80108abf:	6a 00                	push   $0x0
  pushl $69
80108ac1:	6a 45                	push   $0x45
  jmp alltraps
80108ac3:	e9 4a f7 ff ff       	jmp    80108212 <alltraps>

80108ac8 <vector70>:
.globl vector70
vector70:
  pushl $0
80108ac8:	6a 00                	push   $0x0
  pushl $70
80108aca:	6a 46                	push   $0x46
  jmp alltraps
80108acc:	e9 41 f7 ff ff       	jmp    80108212 <alltraps>

80108ad1 <vector71>:
.globl vector71
vector71:
  pushl $0
80108ad1:	6a 00                	push   $0x0
  pushl $71
80108ad3:	6a 47                	push   $0x47
  jmp alltraps
80108ad5:	e9 38 f7 ff ff       	jmp    80108212 <alltraps>

80108ada <vector72>:
.globl vector72
vector72:
  pushl $0
80108ada:	6a 00                	push   $0x0
  pushl $72
80108adc:	6a 48                	push   $0x48
  jmp alltraps
80108ade:	e9 2f f7 ff ff       	jmp    80108212 <alltraps>

80108ae3 <vector73>:
.globl vector73
vector73:
  pushl $0
80108ae3:	6a 00                	push   $0x0
  pushl $73
80108ae5:	6a 49                	push   $0x49
  jmp alltraps
80108ae7:	e9 26 f7 ff ff       	jmp    80108212 <alltraps>

80108aec <vector74>:
.globl vector74
vector74:
  pushl $0
80108aec:	6a 00                	push   $0x0
  pushl $74
80108aee:	6a 4a                	push   $0x4a
  jmp alltraps
80108af0:	e9 1d f7 ff ff       	jmp    80108212 <alltraps>

80108af5 <vector75>:
.globl vector75
vector75:
  pushl $0
80108af5:	6a 00                	push   $0x0
  pushl $75
80108af7:	6a 4b                	push   $0x4b
  jmp alltraps
80108af9:	e9 14 f7 ff ff       	jmp    80108212 <alltraps>

80108afe <vector76>:
.globl vector76
vector76:
  pushl $0
80108afe:	6a 00                	push   $0x0
  pushl $76
80108b00:	6a 4c                	push   $0x4c
  jmp alltraps
80108b02:	e9 0b f7 ff ff       	jmp    80108212 <alltraps>

80108b07 <vector77>:
.globl vector77
vector77:
  pushl $0
80108b07:	6a 00                	push   $0x0
  pushl $77
80108b09:	6a 4d                	push   $0x4d
  jmp alltraps
80108b0b:	e9 02 f7 ff ff       	jmp    80108212 <alltraps>

80108b10 <vector78>:
.globl vector78
vector78:
  pushl $0
80108b10:	6a 00                	push   $0x0
  pushl $78
80108b12:	6a 4e                	push   $0x4e
  jmp alltraps
80108b14:	e9 f9 f6 ff ff       	jmp    80108212 <alltraps>

80108b19 <vector79>:
.globl vector79
vector79:
  pushl $0
80108b19:	6a 00                	push   $0x0
  pushl $79
80108b1b:	6a 4f                	push   $0x4f
  jmp alltraps
80108b1d:	e9 f0 f6 ff ff       	jmp    80108212 <alltraps>

80108b22 <vector80>:
.globl vector80
vector80:
  pushl $0
80108b22:	6a 00                	push   $0x0
  pushl $80
80108b24:	6a 50                	push   $0x50
  jmp alltraps
80108b26:	e9 e7 f6 ff ff       	jmp    80108212 <alltraps>

80108b2b <vector81>:
.globl vector81
vector81:
  pushl $0
80108b2b:	6a 00                	push   $0x0
  pushl $81
80108b2d:	6a 51                	push   $0x51
  jmp alltraps
80108b2f:	e9 de f6 ff ff       	jmp    80108212 <alltraps>

80108b34 <vector82>:
.globl vector82
vector82:
  pushl $0
80108b34:	6a 00                	push   $0x0
  pushl $82
80108b36:	6a 52                	push   $0x52
  jmp alltraps
80108b38:	e9 d5 f6 ff ff       	jmp    80108212 <alltraps>

80108b3d <vector83>:
.globl vector83
vector83:
  pushl $0
80108b3d:	6a 00                	push   $0x0
  pushl $83
80108b3f:	6a 53                	push   $0x53
  jmp alltraps
80108b41:	e9 cc f6 ff ff       	jmp    80108212 <alltraps>

80108b46 <vector84>:
.globl vector84
vector84:
  pushl $0
80108b46:	6a 00                	push   $0x0
  pushl $84
80108b48:	6a 54                	push   $0x54
  jmp alltraps
80108b4a:	e9 c3 f6 ff ff       	jmp    80108212 <alltraps>

80108b4f <vector85>:
.globl vector85
vector85:
  pushl $0
80108b4f:	6a 00                	push   $0x0
  pushl $85
80108b51:	6a 55                	push   $0x55
  jmp alltraps
80108b53:	e9 ba f6 ff ff       	jmp    80108212 <alltraps>

80108b58 <vector86>:
.globl vector86
vector86:
  pushl $0
80108b58:	6a 00                	push   $0x0
  pushl $86
80108b5a:	6a 56                	push   $0x56
  jmp alltraps
80108b5c:	e9 b1 f6 ff ff       	jmp    80108212 <alltraps>

80108b61 <vector87>:
.globl vector87
vector87:
  pushl $0
80108b61:	6a 00                	push   $0x0
  pushl $87
80108b63:	6a 57                	push   $0x57
  jmp alltraps
80108b65:	e9 a8 f6 ff ff       	jmp    80108212 <alltraps>

80108b6a <vector88>:
.globl vector88
vector88:
  pushl $0
80108b6a:	6a 00                	push   $0x0
  pushl $88
80108b6c:	6a 58                	push   $0x58
  jmp alltraps
80108b6e:	e9 9f f6 ff ff       	jmp    80108212 <alltraps>

80108b73 <vector89>:
.globl vector89
vector89:
  pushl $0
80108b73:	6a 00                	push   $0x0
  pushl $89
80108b75:	6a 59                	push   $0x59
  jmp alltraps
80108b77:	e9 96 f6 ff ff       	jmp    80108212 <alltraps>

80108b7c <vector90>:
.globl vector90
vector90:
  pushl $0
80108b7c:	6a 00                	push   $0x0
  pushl $90
80108b7e:	6a 5a                	push   $0x5a
  jmp alltraps
80108b80:	e9 8d f6 ff ff       	jmp    80108212 <alltraps>

80108b85 <vector91>:
.globl vector91
vector91:
  pushl $0
80108b85:	6a 00                	push   $0x0
  pushl $91
80108b87:	6a 5b                	push   $0x5b
  jmp alltraps
80108b89:	e9 84 f6 ff ff       	jmp    80108212 <alltraps>

80108b8e <vector92>:
.globl vector92
vector92:
  pushl $0
80108b8e:	6a 00                	push   $0x0
  pushl $92
80108b90:	6a 5c                	push   $0x5c
  jmp alltraps
80108b92:	e9 7b f6 ff ff       	jmp    80108212 <alltraps>

80108b97 <vector93>:
.globl vector93
vector93:
  pushl $0
80108b97:	6a 00                	push   $0x0
  pushl $93
80108b99:	6a 5d                	push   $0x5d
  jmp alltraps
80108b9b:	e9 72 f6 ff ff       	jmp    80108212 <alltraps>

80108ba0 <vector94>:
.globl vector94
vector94:
  pushl $0
80108ba0:	6a 00                	push   $0x0
  pushl $94
80108ba2:	6a 5e                	push   $0x5e
  jmp alltraps
80108ba4:	e9 69 f6 ff ff       	jmp    80108212 <alltraps>

80108ba9 <vector95>:
.globl vector95
vector95:
  pushl $0
80108ba9:	6a 00                	push   $0x0
  pushl $95
80108bab:	6a 5f                	push   $0x5f
  jmp alltraps
80108bad:	e9 60 f6 ff ff       	jmp    80108212 <alltraps>

80108bb2 <vector96>:
.globl vector96
vector96:
  pushl $0
80108bb2:	6a 00                	push   $0x0
  pushl $96
80108bb4:	6a 60                	push   $0x60
  jmp alltraps
80108bb6:	e9 57 f6 ff ff       	jmp    80108212 <alltraps>

80108bbb <vector97>:
.globl vector97
vector97:
  pushl $0
80108bbb:	6a 00                	push   $0x0
  pushl $97
80108bbd:	6a 61                	push   $0x61
  jmp alltraps
80108bbf:	e9 4e f6 ff ff       	jmp    80108212 <alltraps>

80108bc4 <vector98>:
.globl vector98
vector98:
  pushl $0
80108bc4:	6a 00                	push   $0x0
  pushl $98
80108bc6:	6a 62                	push   $0x62
  jmp alltraps
80108bc8:	e9 45 f6 ff ff       	jmp    80108212 <alltraps>

80108bcd <vector99>:
.globl vector99
vector99:
  pushl $0
80108bcd:	6a 00                	push   $0x0
  pushl $99
80108bcf:	6a 63                	push   $0x63
  jmp alltraps
80108bd1:	e9 3c f6 ff ff       	jmp    80108212 <alltraps>

80108bd6 <vector100>:
.globl vector100
vector100:
  pushl $0
80108bd6:	6a 00                	push   $0x0
  pushl $100
80108bd8:	6a 64                	push   $0x64
  jmp alltraps
80108bda:	e9 33 f6 ff ff       	jmp    80108212 <alltraps>

80108bdf <vector101>:
.globl vector101
vector101:
  pushl $0
80108bdf:	6a 00                	push   $0x0
  pushl $101
80108be1:	6a 65                	push   $0x65
  jmp alltraps
80108be3:	e9 2a f6 ff ff       	jmp    80108212 <alltraps>

80108be8 <vector102>:
.globl vector102
vector102:
  pushl $0
80108be8:	6a 00                	push   $0x0
  pushl $102
80108bea:	6a 66                	push   $0x66
  jmp alltraps
80108bec:	e9 21 f6 ff ff       	jmp    80108212 <alltraps>

80108bf1 <vector103>:
.globl vector103
vector103:
  pushl $0
80108bf1:	6a 00                	push   $0x0
  pushl $103
80108bf3:	6a 67                	push   $0x67
  jmp alltraps
80108bf5:	e9 18 f6 ff ff       	jmp    80108212 <alltraps>

80108bfa <vector104>:
.globl vector104
vector104:
  pushl $0
80108bfa:	6a 00                	push   $0x0
  pushl $104
80108bfc:	6a 68                	push   $0x68
  jmp alltraps
80108bfe:	e9 0f f6 ff ff       	jmp    80108212 <alltraps>

80108c03 <vector105>:
.globl vector105
vector105:
  pushl $0
80108c03:	6a 00                	push   $0x0
  pushl $105
80108c05:	6a 69                	push   $0x69
  jmp alltraps
80108c07:	e9 06 f6 ff ff       	jmp    80108212 <alltraps>

80108c0c <vector106>:
.globl vector106
vector106:
  pushl $0
80108c0c:	6a 00                	push   $0x0
  pushl $106
80108c0e:	6a 6a                	push   $0x6a
  jmp alltraps
80108c10:	e9 fd f5 ff ff       	jmp    80108212 <alltraps>

80108c15 <vector107>:
.globl vector107
vector107:
  pushl $0
80108c15:	6a 00                	push   $0x0
  pushl $107
80108c17:	6a 6b                	push   $0x6b
  jmp alltraps
80108c19:	e9 f4 f5 ff ff       	jmp    80108212 <alltraps>

80108c1e <vector108>:
.globl vector108
vector108:
  pushl $0
80108c1e:	6a 00                	push   $0x0
  pushl $108
80108c20:	6a 6c                	push   $0x6c
  jmp alltraps
80108c22:	e9 eb f5 ff ff       	jmp    80108212 <alltraps>

80108c27 <vector109>:
.globl vector109
vector109:
  pushl $0
80108c27:	6a 00                	push   $0x0
  pushl $109
80108c29:	6a 6d                	push   $0x6d
  jmp alltraps
80108c2b:	e9 e2 f5 ff ff       	jmp    80108212 <alltraps>

80108c30 <vector110>:
.globl vector110
vector110:
  pushl $0
80108c30:	6a 00                	push   $0x0
  pushl $110
80108c32:	6a 6e                	push   $0x6e
  jmp alltraps
80108c34:	e9 d9 f5 ff ff       	jmp    80108212 <alltraps>

80108c39 <vector111>:
.globl vector111
vector111:
  pushl $0
80108c39:	6a 00                	push   $0x0
  pushl $111
80108c3b:	6a 6f                	push   $0x6f
  jmp alltraps
80108c3d:	e9 d0 f5 ff ff       	jmp    80108212 <alltraps>

80108c42 <vector112>:
.globl vector112
vector112:
  pushl $0
80108c42:	6a 00                	push   $0x0
  pushl $112
80108c44:	6a 70                	push   $0x70
  jmp alltraps
80108c46:	e9 c7 f5 ff ff       	jmp    80108212 <alltraps>

80108c4b <vector113>:
.globl vector113
vector113:
  pushl $0
80108c4b:	6a 00                	push   $0x0
  pushl $113
80108c4d:	6a 71                	push   $0x71
  jmp alltraps
80108c4f:	e9 be f5 ff ff       	jmp    80108212 <alltraps>

80108c54 <vector114>:
.globl vector114
vector114:
  pushl $0
80108c54:	6a 00                	push   $0x0
  pushl $114
80108c56:	6a 72                	push   $0x72
  jmp alltraps
80108c58:	e9 b5 f5 ff ff       	jmp    80108212 <alltraps>

80108c5d <vector115>:
.globl vector115
vector115:
  pushl $0
80108c5d:	6a 00                	push   $0x0
  pushl $115
80108c5f:	6a 73                	push   $0x73
  jmp alltraps
80108c61:	e9 ac f5 ff ff       	jmp    80108212 <alltraps>

80108c66 <vector116>:
.globl vector116
vector116:
  pushl $0
80108c66:	6a 00                	push   $0x0
  pushl $116
80108c68:	6a 74                	push   $0x74
  jmp alltraps
80108c6a:	e9 a3 f5 ff ff       	jmp    80108212 <alltraps>

80108c6f <vector117>:
.globl vector117
vector117:
  pushl $0
80108c6f:	6a 00                	push   $0x0
  pushl $117
80108c71:	6a 75                	push   $0x75
  jmp alltraps
80108c73:	e9 9a f5 ff ff       	jmp    80108212 <alltraps>

80108c78 <vector118>:
.globl vector118
vector118:
  pushl $0
80108c78:	6a 00                	push   $0x0
  pushl $118
80108c7a:	6a 76                	push   $0x76
  jmp alltraps
80108c7c:	e9 91 f5 ff ff       	jmp    80108212 <alltraps>

80108c81 <vector119>:
.globl vector119
vector119:
  pushl $0
80108c81:	6a 00                	push   $0x0
  pushl $119
80108c83:	6a 77                	push   $0x77
  jmp alltraps
80108c85:	e9 88 f5 ff ff       	jmp    80108212 <alltraps>

80108c8a <vector120>:
.globl vector120
vector120:
  pushl $0
80108c8a:	6a 00                	push   $0x0
  pushl $120
80108c8c:	6a 78                	push   $0x78
  jmp alltraps
80108c8e:	e9 7f f5 ff ff       	jmp    80108212 <alltraps>

80108c93 <vector121>:
.globl vector121
vector121:
  pushl $0
80108c93:	6a 00                	push   $0x0
  pushl $121
80108c95:	6a 79                	push   $0x79
  jmp alltraps
80108c97:	e9 76 f5 ff ff       	jmp    80108212 <alltraps>

80108c9c <vector122>:
.globl vector122
vector122:
  pushl $0
80108c9c:	6a 00                	push   $0x0
  pushl $122
80108c9e:	6a 7a                	push   $0x7a
  jmp alltraps
80108ca0:	e9 6d f5 ff ff       	jmp    80108212 <alltraps>

80108ca5 <vector123>:
.globl vector123
vector123:
  pushl $0
80108ca5:	6a 00                	push   $0x0
  pushl $123
80108ca7:	6a 7b                	push   $0x7b
  jmp alltraps
80108ca9:	e9 64 f5 ff ff       	jmp    80108212 <alltraps>

80108cae <vector124>:
.globl vector124
vector124:
  pushl $0
80108cae:	6a 00                	push   $0x0
  pushl $124
80108cb0:	6a 7c                	push   $0x7c
  jmp alltraps
80108cb2:	e9 5b f5 ff ff       	jmp    80108212 <alltraps>

80108cb7 <vector125>:
.globl vector125
vector125:
  pushl $0
80108cb7:	6a 00                	push   $0x0
  pushl $125
80108cb9:	6a 7d                	push   $0x7d
  jmp alltraps
80108cbb:	e9 52 f5 ff ff       	jmp    80108212 <alltraps>

80108cc0 <vector126>:
.globl vector126
vector126:
  pushl $0
80108cc0:	6a 00                	push   $0x0
  pushl $126
80108cc2:	6a 7e                	push   $0x7e
  jmp alltraps
80108cc4:	e9 49 f5 ff ff       	jmp    80108212 <alltraps>

80108cc9 <vector127>:
.globl vector127
vector127:
  pushl $0
80108cc9:	6a 00                	push   $0x0
  pushl $127
80108ccb:	6a 7f                	push   $0x7f
  jmp alltraps
80108ccd:	e9 40 f5 ff ff       	jmp    80108212 <alltraps>

80108cd2 <vector128>:
.globl vector128
vector128:
  pushl $0
80108cd2:	6a 00                	push   $0x0
  pushl $128
80108cd4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108cd9:	e9 34 f5 ff ff       	jmp    80108212 <alltraps>

80108cde <vector129>:
.globl vector129
vector129:
  pushl $0
80108cde:	6a 00                	push   $0x0
  pushl $129
80108ce0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108ce5:	e9 28 f5 ff ff       	jmp    80108212 <alltraps>

80108cea <vector130>:
.globl vector130
vector130:
  pushl $0
80108cea:	6a 00                	push   $0x0
  pushl $130
80108cec:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108cf1:	e9 1c f5 ff ff       	jmp    80108212 <alltraps>

80108cf6 <vector131>:
.globl vector131
vector131:
  pushl $0
80108cf6:	6a 00                	push   $0x0
  pushl $131
80108cf8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108cfd:	e9 10 f5 ff ff       	jmp    80108212 <alltraps>

80108d02 <vector132>:
.globl vector132
vector132:
  pushl $0
80108d02:	6a 00                	push   $0x0
  pushl $132
80108d04:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108d09:	e9 04 f5 ff ff       	jmp    80108212 <alltraps>

80108d0e <vector133>:
.globl vector133
vector133:
  pushl $0
80108d0e:	6a 00                	push   $0x0
  pushl $133
80108d10:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108d15:	e9 f8 f4 ff ff       	jmp    80108212 <alltraps>

80108d1a <vector134>:
.globl vector134
vector134:
  pushl $0
80108d1a:	6a 00                	push   $0x0
  pushl $134
80108d1c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108d21:	e9 ec f4 ff ff       	jmp    80108212 <alltraps>

80108d26 <vector135>:
.globl vector135
vector135:
  pushl $0
80108d26:	6a 00                	push   $0x0
  pushl $135
80108d28:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108d2d:	e9 e0 f4 ff ff       	jmp    80108212 <alltraps>

80108d32 <vector136>:
.globl vector136
vector136:
  pushl $0
80108d32:	6a 00                	push   $0x0
  pushl $136
80108d34:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108d39:	e9 d4 f4 ff ff       	jmp    80108212 <alltraps>

80108d3e <vector137>:
.globl vector137
vector137:
  pushl $0
80108d3e:	6a 00                	push   $0x0
  pushl $137
80108d40:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108d45:	e9 c8 f4 ff ff       	jmp    80108212 <alltraps>

80108d4a <vector138>:
.globl vector138
vector138:
  pushl $0
80108d4a:	6a 00                	push   $0x0
  pushl $138
80108d4c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108d51:	e9 bc f4 ff ff       	jmp    80108212 <alltraps>

80108d56 <vector139>:
.globl vector139
vector139:
  pushl $0
80108d56:	6a 00                	push   $0x0
  pushl $139
80108d58:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108d5d:	e9 b0 f4 ff ff       	jmp    80108212 <alltraps>

80108d62 <vector140>:
.globl vector140
vector140:
  pushl $0
80108d62:	6a 00                	push   $0x0
  pushl $140
80108d64:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108d69:	e9 a4 f4 ff ff       	jmp    80108212 <alltraps>

80108d6e <vector141>:
.globl vector141
vector141:
  pushl $0
80108d6e:	6a 00                	push   $0x0
  pushl $141
80108d70:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108d75:	e9 98 f4 ff ff       	jmp    80108212 <alltraps>

80108d7a <vector142>:
.globl vector142
vector142:
  pushl $0
80108d7a:	6a 00                	push   $0x0
  pushl $142
80108d7c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108d81:	e9 8c f4 ff ff       	jmp    80108212 <alltraps>

80108d86 <vector143>:
.globl vector143
vector143:
  pushl $0
80108d86:	6a 00                	push   $0x0
  pushl $143
80108d88:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108d8d:	e9 80 f4 ff ff       	jmp    80108212 <alltraps>

80108d92 <vector144>:
.globl vector144
vector144:
  pushl $0
80108d92:	6a 00                	push   $0x0
  pushl $144
80108d94:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108d99:	e9 74 f4 ff ff       	jmp    80108212 <alltraps>

80108d9e <vector145>:
.globl vector145
vector145:
  pushl $0
80108d9e:	6a 00                	push   $0x0
  pushl $145
80108da0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108da5:	e9 68 f4 ff ff       	jmp    80108212 <alltraps>

80108daa <vector146>:
.globl vector146
vector146:
  pushl $0
80108daa:	6a 00                	push   $0x0
  pushl $146
80108dac:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108db1:	e9 5c f4 ff ff       	jmp    80108212 <alltraps>

80108db6 <vector147>:
.globl vector147
vector147:
  pushl $0
80108db6:	6a 00                	push   $0x0
  pushl $147
80108db8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108dbd:	e9 50 f4 ff ff       	jmp    80108212 <alltraps>

80108dc2 <vector148>:
.globl vector148
vector148:
  pushl $0
80108dc2:	6a 00                	push   $0x0
  pushl $148
80108dc4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108dc9:	e9 44 f4 ff ff       	jmp    80108212 <alltraps>

80108dce <vector149>:
.globl vector149
vector149:
  pushl $0
80108dce:	6a 00                	push   $0x0
  pushl $149
80108dd0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108dd5:	e9 38 f4 ff ff       	jmp    80108212 <alltraps>

80108dda <vector150>:
.globl vector150
vector150:
  pushl $0
80108dda:	6a 00                	push   $0x0
  pushl $150
80108ddc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108de1:	e9 2c f4 ff ff       	jmp    80108212 <alltraps>

80108de6 <vector151>:
.globl vector151
vector151:
  pushl $0
80108de6:	6a 00                	push   $0x0
  pushl $151
80108de8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108ded:	e9 20 f4 ff ff       	jmp    80108212 <alltraps>

80108df2 <vector152>:
.globl vector152
vector152:
  pushl $0
80108df2:	6a 00                	push   $0x0
  pushl $152
80108df4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108df9:	e9 14 f4 ff ff       	jmp    80108212 <alltraps>

80108dfe <vector153>:
.globl vector153
vector153:
  pushl $0
80108dfe:	6a 00                	push   $0x0
  pushl $153
80108e00:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108e05:	e9 08 f4 ff ff       	jmp    80108212 <alltraps>

80108e0a <vector154>:
.globl vector154
vector154:
  pushl $0
80108e0a:	6a 00                	push   $0x0
  pushl $154
80108e0c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108e11:	e9 fc f3 ff ff       	jmp    80108212 <alltraps>

80108e16 <vector155>:
.globl vector155
vector155:
  pushl $0
80108e16:	6a 00                	push   $0x0
  pushl $155
80108e18:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108e1d:	e9 f0 f3 ff ff       	jmp    80108212 <alltraps>

80108e22 <vector156>:
.globl vector156
vector156:
  pushl $0
80108e22:	6a 00                	push   $0x0
  pushl $156
80108e24:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108e29:	e9 e4 f3 ff ff       	jmp    80108212 <alltraps>

80108e2e <vector157>:
.globl vector157
vector157:
  pushl $0
80108e2e:	6a 00                	push   $0x0
  pushl $157
80108e30:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108e35:	e9 d8 f3 ff ff       	jmp    80108212 <alltraps>

80108e3a <vector158>:
.globl vector158
vector158:
  pushl $0
80108e3a:	6a 00                	push   $0x0
  pushl $158
80108e3c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108e41:	e9 cc f3 ff ff       	jmp    80108212 <alltraps>

80108e46 <vector159>:
.globl vector159
vector159:
  pushl $0
80108e46:	6a 00                	push   $0x0
  pushl $159
80108e48:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108e4d:	e9 c0 f3 ff ff       	jmp    80108212 <alltraps>

80108e52 <vector160>:
.globl vector160
vector160:
  pushl $0
80108e52:	6a 00                	push   $0x0
  pushl $160
80108e54:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108e59:	e9 b4 f3 ff ff       	jmp    80108212 <alltraps>

80108e5e <vector161>:
.globl vector161
vector161:
  pushl $0
80108e5e:	6a 00                	push   $0x0
  pushl $161
80108e60:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108e65:	e9 a8 f3 ff ff       	jmp    80108212 <alltraps>

80108e6a <vector162>:
.globl vector162
vector162:
  pushl $0
80108e6a:	6a 00                	push   $0x0
  pushl $162
80108e6c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108e71:	e9 9c f3 ff ff       	jmp    80108212 <alltraps>

80108e76 <vector163>:
.globl vector163
vector163:
  pushl $0
80108e76:	6a 00                	push   $0x0
  pushl $163
80108e78:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108e7d:	e9 90 f3 ff ff       	jmp    80108212 <alltraps>

80108e82 <vector164>:
.globl vector164
vector164:
  pushl $0
80108e82:	6a 00                	push   $0x0
  pushl $164
80108e84:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108e89:	e9 84 f3 ff ff       	jmp    80108212 <alltraps>

80108e8e <vector165>:
.globl vector165
vector165:
  pushl $0
80108e8e:	6a 00                	push   $0x0
  pushl $165
80108e90:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108e95:	e9 78 f3 ff ff       	jmp    80108212 <alltraps>

80108e9a <vector166>:
.globl vector166
vector166:
  pushl $0
80108e9a:	6a 00                	push   $0x0
  pushl $166
80108e9c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108ea1:	e9 6c f3 ff ff       	jmp    80108212 <alltraps>

80108ea6 <vector167>:
.globl vector167
vector167:
  pushl $0
80108ea6:	6a 00                	push   $0x0
  pushl $167
80108ea8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108ead:	e9 60 f3 ff ff       	jmp    80108212 <alltraps>

80108eb2 <vector168>:
.globl vector168
vector168:
  pushl $0
80108eb2:	6a 00                	push   $0x0
  pushl $168
80108eb4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108eb9:	e9 54 f3 ff ff       	jmp    80108212 <alltraps>

80108ebe <vector169>:
.globl vector169
vector169:
  pushl $0
80108ebe:	6a 00                	push   $0x0
  pushl $169
80108ec0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108ec5:	e9 48 f3 ff ff       	jmp    80108212 <alltraps>

80108eca <vector170>:
.globl vector170
vector170:
  pushl $0
80108eca:	6a 00                	push   $0x0
  pushl $170
80108ecc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108ed1:	e9 3c f3 ff ff       	jmp    80108212 <alltraps>

80108ed6 <vector171>:
.globl vector171
vector171:
  pushl $0
80108ed6:	6a 00                	push   $0x0
  pushl $171
80108ed8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108edd:	e9 30 f3 ff ff       	jmp    80108212 <alltraps>

80108ee2 <vector172>:
.globl vector172
vector172:
  pushl $0
80108ee2:	6a 00                	push   $0x0
  pushl $172
80108ee4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108ee9:	e9 24 f3 ff ff       	jmp    80108212 <alltraps>

80108eee <vector173>:
.globl vector173
vector173:
  pushl $0
80108eee:	6a 00                	push   $0x0
  pushl $173
80108ef0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108ef5:	e9 18 f3 ff ff       	jmp    80108212 <alltraps>

80108efa <vector174>:
.globl vector174
vector174:
  pushl $0
80108efa:	6a 00                	push   $0x0
  pushl $174
80108efc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108f01:	e9 0c f3 ff ff       	jmp    80108212 <alltraps>

80108f06 <vector175>:
.globl vector175
vector175:
  pushl $0
80108f06:	6a 00                	push   $0x0
  pushl $175
80108f08:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108f0d:	e9 00 f3 ff ff       	jmp    80108212 <alltraps>

80108f12 <vector176>:
.globl vector176
vector176:
  pushl $0
80108f12:	6a 00                	push   $0x0
  pushl $176
80108f14:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108f19:	e9 f4 f2 ff ff       	jmp    80108212 <alltraps>

80108f1e <vector177>:
.globl vector177
vector177:
  pushl $0
80108f1e:	6a 00                	push   $0x0
  pushl $177
80108f20:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108f25:	e9 e8 f2 ff ff       	jmp    80108212 <alltraps>

80108f2a <vector178>:
.globl vector178
vector178:
  pushl $0
80108f2a:	6a 00                	push   $0x0
  pushl $178
80108f2c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108f31:	e9 dc f2 ff ff       	jmp    80108212 <alltraps>

80108f36 <vector179>:
.globl vector179
vector179:
  pushl $0
80108f36:	6a 00                	push   $0x0
  pushl $179
80108f38:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108f3d:	e9 d0 f2 ff ff       	jmp    80108212 <alltraps>

80108f42 <vector180>:
.globl vector180
vector180:
  pushl $0
80108f42:	6a 00                	push   $0x0
  pushl $180
80108f44:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108f49:	e9 c4 f2 ff ff       	jmp    80108212 <alltraps>

80108f4e <vector181>:
.globl vector181
vector181:
  pushl $0
80108f4e:	6a 00                	push   $0x0
  pushl $181
80108f50:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108f55:	e9 b8 f2 ff ff       	jmp    80108212 <alltraps>

80108f5a <vector182>:
.globl vector182
vector182:
  pushl $0
80108f5a:	6a 00                	push   $0x0
  pushl $182
80108f5c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108f61:	e9 ac f2 ff ff       	jmp    80108212 <alltraps>

80108f66 <vector183>:
.globl vector183
vector183:
  pushl $0
80108f66:	6a 00                	push   $0x0
  pushl $183
80108f68:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108f6d:	e9 a0 f2 ff ff       	jmp    80108212 <alltraps>

80108f72 <vector184>:
.globl vector184
vector184:
  pushl $0
80108f72:	6a 00                	push   $0x0
  pushl $184
80108f74:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108f79:	e9 94 f2 ff ff       	jmp    80108212 <alltraps>

80108f7e <vector185>:
.globl vector185
vector185:
  pushl $0
80108f7e:	6a 00                	push   $0x0
  pushl $185
80108f80:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108f85:	e9 88 f2 ff ff       	jmp    80108212 <alltraps>

80108f8a <vector186>:
.globl vector186
vector186:
  pushl $0
80108f8a:	6a 00                	push   $0x0
  pushl $186
80108f8c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108f91:	e9 7c f2 ff ff       	jmp    80108212 <alltraps>

80108f96 <vector187>:
.globl vector187
vector187:
  pushl $0
80108f96:	6a 00                	push   $0x0
  pushl $187
80108f98:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108f9d:	e9 70 f2 ff ff       	jmp    80108212 <alltraps>

80108fa2 <vector188>:
.globl vector188
vector188:
  pushl $0
80108fa2:	6a 00                	push   $0x0
  pushl $188
80108fa4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108fa9:	e9 64 f2 ff ff       	jmp    80108212 <alltraps>

80108fae <vector189>:
.globl vector189
vector189:
  pushl $0
80108fae:	6a 00                	push   $0x0
  pushl $189
80108fb0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108fb5:	e9 58 f2 ff ff       	jmp    80108212 <alltraps>

80108fba <vector190>:
.globl vector190
vector190:
  pushl $0
80108fba:	6a 00                	push   $0x0
  pushl $190
80108fbc:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108fc1:	e9 4c f2 ff ff       	jmp    80108212 <alltraps>

80108fc6 <vector191>:
.globl vector191
vector191:
  pushl $0
80108fc6:	6a 00                	push   $0x0
  pushl $191
80108fc8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108fcd:	e9 40 f2 ff ff       	jmp    80108212 <alltraps>

80108fd2 <vector192>:
.globl vector192
vector192:
  pushl $0
80108fd2:	6a 00                	push   $0x0
  pushl $192
80108fd4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108fd9:	e9 34 f2 ff ff       	jmp    80108212 <alltraps>

80108fde <vector193>:
.globl vector193
vector193:
  pushl $0
80108fde:	6a 00                	push   $0x0
  pushl $193
80108fe0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108fe5:	e9 28 f2 ff ff       	jmp    80108212 <alltraps>

80108fea <vector194>:
.globl vector194
vector194:
  pushl $0
80108fea:	6a 00                	push   $0x0
  pushl $194
80108fec:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108ff1:	e9 1c f2 ff ff       	jmp    80108212 <alltraps>

80108ff6 <vector195>:
.globl vector195
vector195:
  pushl $0
80108ff6:	6a 00                	push   $0x0
  pushl $195
80108ff8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108ffd:	e9 10 f2 ff ff       	jmp    80108212 <alltraps>

80109002 <vector196>:
.globl vector196
vector196:
  pushl $0
80109002:	6a 00                	push   $0x0
  pushl $196
80109004:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80109009:	e9 04 f2 ff ff       	jmp    80108212 <alltraps>

8010900e <vector197>:
.globl vector197
vector197:
  pushl $0
8010900e:	6a 00                	push   $0x0
  pushl $197
80109010:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80109015:	e9 f8 f1 ff ff       	jmp    80108212 <alltraps>

8010901a <vector198>:
.globl vector198
vector198:
  pushl $0
8010901a:	6a 00                	push   $0x0
  pushl $198
8010901c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80109021:	e9 ec f1 ff ff       	jmp    80108212 <alltraps>

80109026 <vector199>:
.globl vector199
vector199:
  pushl $0
80109026:	6a 00                	push   $0x0
  pushl $199
80109028:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010902d:	e9 e0 f1 ff ff       	jmp    80108212 <alltraps>

80109032 <vector200>:
.globl vector200
vector200:
  pushl $0
80109032:	6a 00                	push   $0x0
  pushl $200
80109034:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80109039:	e9 d4 f1 ff ff       	jmp    80108212 <alltraps>

8010903e <vector201>:
.globl vector201
vector201:
  pushl $0
8010903e:	6a 00                	push   $0x0
  pushl $201
80109040:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80109045:	e9 c8 f1 ff ff       	jmp    80108212 <alltraps>

8010904a <vector202>:
.globl vector202
vector202:
  pushl $0
8010904a:	6a 00                	push   $0x0
  pushl $202
8010904c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80109051:	e9 bc f1 ff ff       	jmp    80108212 <alltraps>

80109056 <vector203>:
.globl vector203
vector203:
  pushl $0
80109056:	6a 00                	push   $0x0
  pushl $203
80109058:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010905d:	e9 b0 f1 ff ff       	jmp    80108212 <alltraps>

80109062 <vector204>:
.globl vector204
vector204:
  pushl $0
80109062:	6a 00                	push   $0x0
  pushl $204
80109064:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80109069:	e9 a4 f1 ff ff       	jmp    80108212 <alltraps>

8010906e <vector205>:
.globl vector205
vector205:
  pushl $0
8010906e:	6a 00                	push   $0x0
  pushl $205
80109070:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80109075:	e9 98 f1 ff ff       	jmp    80108212 <alltraps>

8010907a <vector206>:
.globl vector206
vector206:
  pushl $0
8010907a:	6a 00                	push   $0x0
  pushl $206
8010907c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80109081:	e9 8c f1 ff ff       	jmp    80108212 <alltraps>

80109086 <vector207>:
.globl vector207
vector207:
  pushl $0
80109086:	6a 00                	push   $0x0
  pushl $207
80109088:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010908d:	e9 80 f1 ff ff       	jmp    80108212 <alltraps>

80109092 <vector208>:
.globl vector208
vector208:
  pushl $0
80109092:	6a 00                	push   $0x0
  pushl $208
80109094:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80109099:	e9 74 f1 ff ff       	jmp    80108212 <alltraps>

8010909e <vector209>:
.globl vector209
vector209:
  pushl $0
8010909e:	6a 00                	push   $0x0
  pushl $209
801090a0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801090a5:	e9 68 f1 ff ff       	jmp    80108212 <alltraps>

801090aa <vector210>:
.globl vector210
vector210:
  pushl $0
801090aa:	6a 00                	push   $0x0
  pushl $210
801090ac:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801090b1:	e9 5c f1 ff ff       	jmp    80108212 <alltraps>

801090b6 <vector211>:
.globl vector211
vector211:
  pushl $0
801090b6:	6a 00                	push   $0x0
  pushl $211
801090b8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801090bd:	e9 50 f1 ff ff       	jmp    80108212 <alltraps>

801090c2 <vector212>:
.globl vector212
vector212:
  pushl $0
801090c2:	6a 00                	push   $0x0
  pushl $212
801090c4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801090c9:	e9 44 f1 ff ff       	jmp    80108212 <alltraps>

801090ce <vector213>:
.globl vector213
vector213:
  pushl $0
801090ce:	6a 00                	push   $0x0
  pushl $213
801090d0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801090d5:	e9 38 f1 ff ff       	jmp    80108212 <alltraps>

801090da <vector214>:
.globl vector214
vector214:
  pushl $0
801090da:	6a 00                	push   $0x0
  pushl $214
801090dc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801090e1:	e9 2c f1 ff ff       	jmp    80108212 <alltraps>

801090e6 <vector215>:
.globl vector215
vector215:
  pushl $0
801090e6:	6a 00                	push   $0x0
  pushl $215
801090e8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801090ed:	e9 20 f1 ff ff       	jmp    80108212 <alltraps>

801090f2 <vector216>:
.globl vector216
vector216:
  pushl $0
801090f2:	6a 00                	push   $0x0
  pushl $216
801090f4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801090f9:	e9 14 f1 ff ff       	jmp    80108212 <alltraps>

801090fe <vector217>:
.globl vector217
vector217:
  pushl $0
801090fe:	6a 00                	push   $0x0
  pushl $217
80109100:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80109105:	e9 08 f1 ff ff       	jmp    80108212 <alltraps>

8010910a <vector218>:
.globl vector218
vector218:
  pushl $0
8010910a:	6a 00                	push   $0x0
  pushl $218
8010910c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80109111:	e9 fc f0 ff ff       	jmp    80108212 <alltraps>

80109116 <vector219>:
.globl vector219
vector219:
  pushl $0
80109116:	6a 00                	push   $0x0
  pushl $219
80109118:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010911d:	e9 f0 f0 ff ff       	jmp    80108212 <alltraps>

80109122 <vector220>:
.globl vector220
vector220:
  pushl $0
80109122:	6a 00                	push   $0x0
  pushl $220
80109124:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80109129:	e9 e4 f0 ff ff       	jmp    80108212 <alltraps>

8010912e <vector221>:
.globl vector221
vector221:
  pushl $0
8010912e:	6a 00                	push   $0x0
  pushl $221
80109130:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80109135:	e9 d8 f0 ff ff       	jmp    80108212 <alltraps>

8010913a <vector222>:
.globl vector222
vector222:
  pushl $0
8010913a:	6a 00                	push   $0x0
  pushl $222
8010913c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80109141:	e9 cc f0 ff ff       	jmp    80108212 <alltraps>

80109146 <vector223>:
.globl vector223
vector223:
  pushl $0
80109146:	6a 00                	push   $0x0
  pushl $223
80109148:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010914d:	e9 c0 f0 ff ff       	jmp    80108212 <alltraps>

80109152 <vector224>:
.globl vector224
vector224:
  pushl $0
80109152:	6a 00                	push   $0x0
  pushl $224
80109154:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80109159:	e9 b4 f0 ff ff       	jmp    80108212 <alltraps>

8010915e <vector225>:
.globl vector225
vector225:
  pushl $0
8010915e:	6a 00                	push   $0x0
  pushl $225
80109160:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80109165:	e9 a8 f0 ff ff       	jmp    80108212 <alltraps>

8010916a <vector226>:
.globl vector226
vector226:
  pushl $0
8010916a:	6a 00                	push   $0x0
  pushl $226
8010916c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80109171:	e9 9c f0 ff ff       	jmp    80108212 <alltraps>

80109176 <vector227>:
.globl vector227
vector227:
  pushl $0
80109176:	6a 00                	push   $0x0
  pushl $227
80109178:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010917d:	e9 90 f0 ff ff       	jmp    80108212 <alltraps>

80109182 <vector228>:
.globl vector228
vector228:
  pushl $0
80109182:	6a 00                	push   $0x0
  pushl $228
80109184:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80109189:	e9 84 f0 ff ff       	jmp    80108212 <alltraps>

8010918e <vector229>:
.globl vector229
vector229:
  pushl $0
8010918e:	6a 00                	push   $0x0
  pushl $229
80109190:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80109195:	e9 78 f0 ff ff       	jmp    80108212 <alltraps>

8010919a <vector230>:
.globl vector230
vector230:
  pushl $0
8010919a:	6a 00                	push   $0x0
  pushl $230
8010919c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801091a1:	e9 6c f0 ff ff       	jmp    80108212 <alltraps>

801091a6 <vector231>:
.globl vector231
vector231:
  pushl $0
801091a6:	6a 00                	push   $0x0
  pushl $231
801091a8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801091ad:	e9 60 f0 ff ff       	jmp    80108212 <alltraps>

801091b2 <vector232>:
.globl vector232
vector232:
  pushl $0
801091b2:	6a 00                	push   $0x0
  pushl $232
801091b4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801091b9:	e9 54 f0 ff ff       	jmp    80108212 <alltraps>

801091be <vector233>:
.globl vector233
vector233:
  pushl $0
801091be:	6a 00                	push   $0x0
  pushl $233
801091c0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801091c5:	e9 48 f0 ff ff       	jmp    80108212 <alltraps>

801091ca <vector234>:
.globl vector234
vector234:
  pushl $0
801091ca:	6a 00                	push   $0x0
  pushl $234
801091cc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801091d1:	e9 3c f0 ff ff       	jmp    80108212 <alltraps>

801091d6 <vector235>:
.globl vector235
vector235:
  pushl $0
801091d6:	6a 00                	push   $0x0
  pushl $235
801091d8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801091dd:	e9 30 f0 ff ff       	jmp    80108212 <alltraps>

801091e2 <vector236>:
.globl vector236
vector236:
  pushl $0
801091e2:	6a 00                	push   $0x0
  pushl $236
801091e4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801091e9:	e9 24 f0 ff ff       	jmp    80108212 <alltraps>

801091ee <vector237>:
.globl vector237
vector237:
  pushl $0
801091ee:	6a 00                	push   $0x0
  pushl $237
801091f0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801091f5:	e9 18 f0 ff ff       	jmp    80108212 <alltraps>

801091fa <vector238>:
.globl vector238
vector238:
  pushl $0
801091fa:	6a 00                	push   $0x0
  pushl $238
801091fc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109201:	e9 0c f0 ff ff       	jmp    80108212 <alltraps>

80109206 <vector239>:
.globl vector239
vector239:
  pushl $0
80109206:	6a 00                	push   $0x0
  pushl $239
80109208:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010920d:	e9 00 f0 ff ff       	jmp    80108212 <alltraps>

80109212 <vector240>:
.globl vector240
vector240:
  pushl $0
80109212:	6a 00                	push   $0x0
  pushl $240
80109214:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109219:	e9 f4 ef ff ff       	jmp    80108212 <alltraps>

8010921e <vector241>:
.globl vector241
vector241:
  pushl $0
8010921e:	6a 00                	push   $0x0
  pushl $241
80109220:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80109225:	e9 e8 ef ff ff       	jmp    80108212 <alltraps>

8010922a <vector242>:
.globl vector242
vector242:
  pushl $0
8010922a:	6a 00                	push   $0x0
  pushl $242
8010922c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80109231:	e9 dc ef ff ff       	jmp    80108212 <alltraps>

80109236 <vector243>:
.globl vector243
vector243:
  pushl $0
80109236:	6a 00                	push   $0x0
  pushl $243
80109238:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010923d:	e9 d0 ef ff ff       	jmp    80108212 <alltraps>

80109242 <vector244>:
.globl vector244
vector244:
  pushl $0
80109242:	6a 00                	push   $0x0
  pushl $244
80109244:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80109249:	e9 c4 ef ff ff       	jmp    80108212 <alltraps>

8010924e <vector245>:
.globl vector245
vector245:
  pushl $0
8010924e:	6a 00                	push   $0x0
  pushl $245
80109250:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80109255:	e9 b8 ef ff ff       	jmp    80108212 <alltraps>

8010925a <vector246>:
.globl vector246
vector246:
  pushl $0
8010925a:	6a 00                	push   $0x0
  pushl $246
8010925c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80109261:	e9 ac ef ff ff       	jmp    80108212 <alltraps>

80109266 <vector247>:
.globl vector247
vector247:
  pushl $0
80109266:	6a 00                	push   $0x0
  pushl $247
80109268:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010926d:	e9 a0 ef ff ff       	jmp    80108212 <alltraps>

80109272 <vector248>:
.globl vector248
vector248:
  pushl $0
80109272:	6a 00                	push   $0x0
  pushl $248
80109274:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80109279:	e9 94 ef ff ff       	jmp    80108212 <alltraps>

8010927e <vector249>:
.globl vector249
vector249:
  pushl $0
8010927e:	6a 00                	push   $0x0
  pushl $249
80109280:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80109285:	e9 88 ef ff ff       	jmp    80108212 <alltraps>

8010928a <vector250>:
.globl vector250
vector250:
  pushl $0
8010928a:	6a 00                	push   $0x0
  pushl $250
8010928c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109291:	e9 7c ef ff ff       	jmp    80108212 <alltraps>

80109296 <vector251>:
.globl vector251
vector251:
  pushl $0
80109296:	6a 00                	push   $0x0
  pushl $251
80109298:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010929d:	e9 70 ef ff ff       	jmp    80108212 <alltraps>

801092a2 <vector252>:
.globl vector252
vector252:
  pushl $0
801092a2:	6a 00                	push   $0x0
  pushl $252
801092a4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801092a9:	e9 64 ef ff ff       	jmp    80108212 <alltraps>

801092ae <vector253>:
.globl vector253
vector253:
  pushl $0
801092ae:	6a 00                	push   $0x0
  pushl $253
801092b0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801092b5:	e9 58 ef ff ff       	jmp    80108212 <alltraps>

801092ba <vector254>:
.globl vector254
vector254:
  pushl $0
801092ba:	6a 00                	push   $0x0
  pushl $254
801092bc:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801092c1:	e9 4c ef ff ff       	jmp    80108212 <alltraps>

801092c6 <vector255>:
.globl vector255
vector255:
  pushl $0
801092c6:	6a 00                	push   $0x0
  pushl $255
801092c8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801092cd:	e9 40 ef ff ff       	jmp    80108212 <alltraps>

801092d2 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801092d2:	55                   	push   %ebp
801092d3:	89 e5                	mov    %esp,%ebp
801092d5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801092d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801092db:	83 e8 01             	sub    $0x1,%eax
801092de:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801092e2:	8b 45 08             	mov    0x8(%ebp),%eax
801092e5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801092e9:	8b 45 08             	mov    0x8(%ebp),%eax
801092ec:	c1 e8 10             	shr    $0x10,%eax
801092ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801092f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801092f6:	0f 01 10             	lgdtl  (%eax)
}
801092f9:	90                   	nop
801092fa:	c9                   	leave  
801092fb:	c3                   	ret    

801092fc <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801092fc:	55                   	push   %ebp
801092fd:	89 e5                	mov    %esp,%ebp
801092ff:	83 ec 04             	sub    $0x4,%esp
80109302:	8b 45 08             	mov    0x8(%ebp),%eax
80109305:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80109309:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010930d:	0f 00 d8             	ltr    %ax
}
80109310:	90                   	nop
80109311:	c9                   	leave  
80109312:	c3                   	ret    

80109313 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80109313:	55                   	push   %ebp
80109314:	89 e5                	mov    %esp,%ebp
80109316:	83 ec 04             	sub    $0x4,%esp
80109319:	8b 45 08             	mov    0x8(%ebp),%eax
8010931c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109320:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109324:	8e e8                	mov    %eax,%gs
}
80109326:	90                   	nop
80109327:	c9                   	leave  
80109328:	c3                   	ret    

80109329 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80109329:	55                   	push   %ebp
8010932a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010932c:	8b 45 08             	mov    0x8(%ebp),%eax
8010932f:	0f 22 d8             	mov    %eax,%cr3
}
80109332:	90                   	nop
80109333:	5d                   	pop    %ebp
80109334:	c3                   	ret    

80109335 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80109335:	55                   	push   %ebp
80109336:	89 e5                	mov    %esp,%ebp
80109338:	8b 45 08             	mov    0x8(%ebp),%eax
8010933b:	05 00 00 00 80       	add    $0x80000000,%eax
80109340:	5d                   	pop    %ebp
80109341:	c3                   	ret    

80109342 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80109342:	55                   	push   %ebp
80109343:	89 e5                	mov    %esp,%ebp
80109345:	8b 45 08             	mov    0x8(%ebp),%eax
80109348:	05 00 00 00 80       	add    $0x80000000,%eax
8010934d:	5d                   	pop    %ebp
8010934e:	c3                   	ret    

8010934f <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010934f:	55                   	push   %ebp
80109350:	89 e5                	mov    %esp,%ebp
80109352:	53                   	push   %ebx
80109353:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80109356:	e8 fb 9f ff ff       	call   80103356 <cpunum>
8010935b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80109361:	05 a0 43 11 80       	add    $0x801143a0,%eax
80109366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80109369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010936c:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80109372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109375:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010937b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80109382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109385:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109389:	83 e2 f0             	and    $0xfffffff0,%edx
8010938c:	83 ca 0a             	or     $0xa,%edx
8010938f:	88 50 7d             	mov    %dl,0x7d(%eax)
80109392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109395:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109399:	83 ca 10             	or     $0x10,%edx
8010939c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010939f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801093a6:	83 e2 9f             	and    $0xffffff9f,%edx
801093a9:	88 50 7d             	mov    %dl,0x7d(%eax)
801093ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093af:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801093b3:	83 ca 80             	or     $0xffffff80,%edx
801093b6:	88 50 7d             	mov    %dl,0x7d(%eax)
801093b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801093c0:	83 ca 0f             	or     $0xf,%edx
801093c3:	88 50 7e             	mov    %dl,0x7e(%eax)
801093c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801093cd:	83 e2 ef             	and    $0xffffffef,%edx
801093d0:	88 50 7e             	mov    %dl,0x7e(%eax)
801093d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801093da:	83 e2 df             	and    $0xffffffdf,%edx
801093dd:	88 50 7e             	mov    %dl,0x7e(%eax)
801093e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801093e7:	83 ca 40             	or     $0x40,%edx
801093ea:	88 50 7e             	mov    %dl,0x7e(%eax)
801093ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801093f4:	83 ca 80             	or     $0xffffff80,%edx
801093f7:	88 50 7e             	mov    %dl,0x7e(%eax)
801093fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093fd:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109404:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010940b:	ff ff 
8010940d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109410:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80109417:	00 00 
80109419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80109423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109426:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010942d:	83 e2 f0             	and    $0xfffffff0,%edx
80109430:	83 ca 02             	or     $0x2,%edx
80109433:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010943c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109443:	83 ca 10             	or     $0x10,%edx
80109446:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010944c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010944f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109456:	83 e2 9f             	and    $0xffffff9f,%edx
80109459:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010945f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109462:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109469:	83 ca 80             	or     $0xffffff80,%edx
8010946c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109472:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109475:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010947c:	83 ca 0f             	or     $0xf,%edx
8010947f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109488:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010948f:	83 e2 ef             	and    $0xffffffef,%edx
80109492:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010949b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801094a2:	83 e2 df             	and    $0xffffffdf,%edx
801094a5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801094ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ae:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801094b5:	83 ca 40             	or     $0x40,%edx
801094b8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801094be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801094c8:	83 ca 80             	or     $0xffffff80,%edx
801094cb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801094d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d4:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801094db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094de:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801094e5:	ff ff 
801094e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ea:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801094f1:	00 00 
801094f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f6:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801094fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109500:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109507:	83 e2 f0             	and    $0xfffffff0,%edx
8010950a:	83 ca 0a             	or     $0xa,%edx
8010950d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109516:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010951d:	83 ca 10             	or     $0x10,%edx
80109520:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109529:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109530:	83 ca 60             	or     $0x60,%edx
80109533:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109543:	83 ca 80             	or     $0xffffff80,%edx
80109546:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010954c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010954f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109556:	83 ca 0f             	or     $0xf,%edx
80109559:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010955f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109562:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109569:	83 e2 ef             	and    $0xffffffef,%edx
8010956c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109575:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010957c:	83 e2 df             	and    $0xffffffdf,%edx
8010957f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109588:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010958f:	83 ca 40             	or     $0x40,%edx
80109592:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010959b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801095a2:	83 ca 80             	or     $0xffffff80,%edx
801095a5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801095ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ae:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801095b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b8:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801095bf:	ff ff 
801095c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c4:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801095cb:	00 00 
801095cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d0:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801095d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095da:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801095e1:	83 e2 f0             	and    $0xfffffff0,%edx
801095e4:	83 ca 02             	or     $0x2,%edx
801095e7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801095f7:	83 ca 10             	or     $0x10,%edx
801095fa:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109603:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010960a:	83 ca 60             	or     $0x60,%edx
8010960d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109616:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010961d:	83 ca 80             	or     $0xffffff80,%edx
80109620:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109629:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109630:	83 ca 0f             	or     $0xf,%edx
80109633:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010963c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109643:	83 e2 ef             	and    $0xffffffef,%edx
80109646:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010964c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109656:	83 e2 df             	and    $0xffffffdf,%edx
80109659:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010965f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109662:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109669:	83 ca 40             	or     $0x40,%edx
8010966c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109675:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010967c:	83 ca 80             	or     $0xffffff80,%edx
8010967f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109688:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010968f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109692:	05 b4 00 00 00       	add    $0xb4,%eax
80109697:	89 c3                	mov    %eax,%ebx
80109699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010969c:	05 b4 00 00 00       	add    $0xb4,%eax
801096a1:	c1 e8 10             	shr    $0x10,%eax
801096a4:	89 c2                	mov    %eax,%edx
801096a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a9:	05 b4 00 00 00       	add    $0xb4,%eax
801096ae:	c1 e8 18             	shr    $0x18,%eax
801096b1:	89 c1                	mov    %eax,%ecx
801096b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b6:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801096bd:	00 00 
801096bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c2:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801096c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096cc:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801096d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801096dc:	83 e2 f0             	and    $0xfffffff0,%edx
801096df:	83 ca 02             	or     $0x2,%edx
801096e2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096eb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801096f2:	83 ca 10             	or     $0x10,%edx
801096f5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096fe:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109705:	83 e2 9f             	and    $0xffffff9f,%edx
80109708:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010970e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109711:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109718:	83 ca 80             	or     $0xffffff80,%edx
8010971b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109724:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010972b:	83 e2 f0             	and    $0xfffffff0,%edx
8010972e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109737:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010973e:	83 e2 ef             	and    $0xffffffef,%edx
80109741:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010974a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109751:	83 e2 df             	and    $0xffffffdf,%edx
80109754:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010975a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010975d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109764:	83 ca 40             	or     $0x40,%edx
80109767:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010976d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109770:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109777:	83 ca 80             	or     $0xffffff80,%edx
8010977a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109783:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010978c:	83 c0 70             	add    $0x70,%eax
8010978f:	83 ec 08             	sub    $0x8,%esp
80109792:	6a 38                	push   $0x38
80109794:	50                   	push   %eax
80109795:	e8 38 fb ff ff       	call   801092d2 <lgdt>
8010979a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010979d:	83 ec 0c             	sub    $0xc,%esp
801097a0:	6a 18                	push   $0x18
801097a2:	e8 6c fb ff ff       	call   80109313 <loadgs>
801097a7:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801097aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ad:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801097b3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801097ba:	00 00 00 00 
}
801097be:	90                   	nop
801097bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097c2:	c9                   	leave  
801097c3:	c3                   	ret    

801097c4 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801097c4:	55                   	push   %ebp
801097c5:	89 e5                	mov    %esp,%ebp
801097c7:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801097ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801097cd:	c1 e8 16             	shr    $0x16,%eax
801097d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801097d7:	8b 45 08             	mov    0x8(%ebp),%eax
801097da:	01 d0                	add    %edx,%eax
801097dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801097df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097e2:	8b 00                	mov    (%eax),%eax
801097e4:	83 e0 01             	and    $0x1,%eax
801097e7:	85 c0                	test   %eax,%eax
801097e9:	74 18                	je     80109803 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801097eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097ee:	8b 00                	mov    (%eax),%eax
801097f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097f5:	50                   	push   %eax
801097f6:	e8 47 fb ff ff       	call   80109342 <p2v>
801097fb:	83 c4 04             	add    $0x4,%esp
801097fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109801:	eb 48                	jmp    8010984b <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109803:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109807:	74 0e                	je     80109817 <walkpgdir+0x53>
80109809:	e8 e2 97 ff ff       	call   80102ff0 <kalloc>
8010980e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109815:	75 07                	jne    8010981e <walkpgdir+0x5a>
      return 0;
80109817:	b8 00 00 00 00       	mov    $0x0,%eax
8010981c:	eb 44                	jmp    80109862 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010981e:	83 ec 04             	sub    $0x4,%esp
80109821:	68 00 10 00 00       	push   $0x1000
80109826:	6a 00                	push   $0x0
80109828:	ff 75 f4             	pushl  -0xc(%ebp)
8010982b:	e8 cf d2 ff ff       	call   80106aff <memset>
80109830:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109833:	83 ec 0c             	sub    $0xc,%esp
80109836:	ff 75 f4             	pushl  -0xc(%ebp)
80109839:	e8 f7 fa ff ff       	call   80109335 <v2p>
8010983e:	83 c4 10             	add    $0x10,%esp
80109841:	83 c8 07             	or     $0x7,%eax
80109844:	89 c2                	mov    %eax,%edx
80109846:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109849:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010984b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010984e:	c1 e8 0c             	shr    $0xc,%eax
80109851:	25 ff 03 00 00       	and    $0x3ff,%eax
80109856:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010985d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109860:	01 d0                	add    %edx,%eax
}
80109862:	c9                   	leave  
80109863:	c3                   	ret    

80109864 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109864:	55                   	push   %ebp
80109865:	89 e5                	mov    %esp,%ebp
80109867:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010986a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010986d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109872:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109875:	8b 55 0c             	mov    0xc(%ebp),%edx
80109878:	8b 45 10             	mov    0x10(%ebp),%eax
8010987b:	01 d0                	add    %edx,%eax
8010987d:	83 e8 01             	sub    $0x1,%eax
80109880:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109885:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109888:	83 ec 04             	sub    $0x4,%esp
8010988b:	6a 01                	push   $0x1
8010988d:	ff 75 f4             	pushl  -0xc(%ebp)
80109890:	ff 75 08             	pushl  0x8(%ebp)
80109893:	e8 2c ff ff ff       	call   801097c4 <walkpgdir>
80109898:	83 c4 10             	add    $0x10,%esp
8010989b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010989e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801098a2:	75 07                	jne    801098ab <mappages+0x47>
      return -1;
801098a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801098a9:	eb 47                	jmp    801098f2 <mappages+0x8e>
    if(*pte & PTE_P)
801098ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098ae:	8b 00                	mov    (%eax),%eax
801098b0:	83 e0 01             	and    $0x1,%eax
801098b3:	85 c0                	test   %eax,%eax
801098b5:	74 0d                	je     801098c4 <mappages+0x60>
      panic("remap");
801098b7:	83 ec 0c             	sub    $0xc,%esp
801098ba:	68 24 ab 10 80       	push   $0x8010ab24
801098bf:	e8 a2 6c ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801098c4:	8b 45 18             	mov    0x18(%ebp),%eax
801098c7:	0b 45 14             	or     0x14(%ebp),%eax
801098ca:	83 c8 01             	or     $0x1,%eax
801098cd:	89 c2                	mov    %eax,%edx
801098cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098d2:	89 10                	mov    %edx,(%eax)
    if(a == last)
801098d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801098da:	74 10                	je     801098ec <mappages+0x88>
      break;
    a += PGSIZE;
801098dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801098e3:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801098ea:	eb 9c                	jmp    80109888 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801098ec:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801098ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
801098f2:	c9                   	leave  
801098f3:	c3                   	ret    

801098f4 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801098f4:	55                   	push   %ebp
801098f5:	89 e5                	mov    %esp,%ebp
801098f7:	53                   	push   %ebx
801098f8:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801098fb:	e8 f0 96 ff ff       	call   80102ff0 <kalloc>
80109900:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109907:	75 0a                	jne    80109913 <setupkvm+0x1f>
    return 0;
80109909:	b8 00 00 00 00       	mov    $0x0,%eax
8010990e:	e9 8e 00 00 00       	jmp    801099a1 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109913:	83 ec 04             	sub    $0x4,%esp
80109916:	68 00 10 00 00       	push   $0x1000
8010991b:	6a 00                	push   $0x0
8010991d:	ff 75 f0             	pushl  -0x10(%ebp)
80109920:	e8 da d1 ff ff       	call   80106aff <memset>
80109925:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109928:	83 ec 0c             	sub    $0xc,%esp
8010992b:	68 00 00 00 0e       	push   $0xe000000
80109930:	e8 0d fa ff ff       	call   80109342 <p2v>
80109935:	83 c4 10             	add    $0x10,%esp
80109938:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010993d:	76 0d                	jbe    8010994c <setupkvm+0x58>
    panic("PHYSTOP too high");
8010993f:	83 ec 0c             	sub    $0xc,%esp
80109942:	68 2a ab 10 80       	push   $0x8010ab2a
80109947:	e8 1a 6c ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010994c:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
80109953:	eb 40                	jmp    80109995 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109958:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010995b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010995e:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109961:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109964:	8b 58 08             	mov    0x8(%eax),%ebx
80109967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010996a:	8b 40 04             	mov    0x4(%eax),%eax
8010996d:	29 c3                	sub    %eax,%ebx
8010996f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109972:	8b 00                	mov    (%eax),%eax
80109974:	83 ec 0c             	sub    $0xc,%esp
80109977:	51                   	push   %ecx
80109978:	52                   	push   %edx
80109979:	53                   	push   %ebx
8010997a:	50                   	push   %eax
8010997b:	ff 75 f0             	pushl  -0x10(%ebp)
8010997e:	e8 e1 fe ff ff       	call   80109864 <mappages>
80109983:	83 c4 20             	add    $0x20,%esp
80109986:	85 c0                	test   %eax,%eax
80109988:	79 07                	jns    80109991 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010998a:	b8 00 00 00 00       	mov    $0x0,%eax
8010998f:	eb 10                	jmp    801099a1 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109991:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109995:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
8010999c:	72 b7                	jb     80109955 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010999e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801099a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801099a4:	c9                   	leave  
801099a5:	c3                   	ret    

801099a6 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801099a6:	55                   	push   %ebp
801099a7:	89 e5                	mov    %esp,%ebp
801099a9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801099ac:	e8 43 ff ff ff       	call   801098f4 <setupkvm>
801099b1:	a3 78 79 11 80       	mov    %eax,0x80117978
  switchkvm();
801099b6:	e8 03 00 00 00       	call   801099be <switchkvm>
}
801099bb:	90                   	nop
801099bc:	c9                   	leave  
801099bd:	c3                   	ret    

801099be <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801099be:	55                   	push   %ebp
801099bf:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801099c1:	a1 78 79 11 80       	mov    0x80117978,%eax
801099c6:	50                   	push   %eax
801099c7:	e8 69 f9 ff ff       	call   80109335 <v2p>
801099cc:	83 c4 04             	add    $0x4,%esp
801099cf:	50                   	push   %eax
801099d0:	e8 54 f9 ff ff       	call   80109329 <lcr3>
801099d5:	83 c4 04             	add    $0x4,%esp
}
801099d8:	90                   	nop
801099d9:	c9                   	leave  
801099da:	c3                   	ret    

801099db <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801099db:	55                   	push   %ebp
801099dc:	89 e5                	mov    %esp,%ebp
801099de:	56                   	push   %esi
801099df:	53                   	push   %ebx
  pushcli();
801099e0:	e8 14 d0 ff ff       	call   801069f9 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801099e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801099eb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801099f2:	83 c2 08             	add    $0x8,%edx
801099f5:	89 d6                	mov    %edx,%esi
801099f7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801099fe:	83 c2 08             	add    $0x8,%edx
80109a01:	c1 ea 10             	shr    $0x10,%edx
80109a04:	89 d3                	mov    %edx,%ebx
80109a06:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109a0d:	83 c2 08             	add    $0x8,%edx
80109a10:	c1 ea 18             	shr    $0x18,%edx
80109a13:	89 d1                	mov    %edx,%ecx
80109a15:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109a1c:	67 00 
80109a1e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109a25:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109a2b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a32:	83 e2 f0             	and    $0xfffffff0,%edx
80109a35:	83 ca 09             	or     $0x9,%edx
80109a38:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a3e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a45:	83 ca 10             	or     $0x10,%edx
80109a48:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a4e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a55:	83 e2 9f             	and    $0xffffff9f,%edx
80109a58:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a5e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a65:	83 ca 80             	or     $0xffffff80,%edx
80109a68:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a6e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a75:	83 e2 f0             	and    $0xfffffff0,%edx
80109a78:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a7e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a85:	83 e2 ef             	and    $0xffffffef,%edx
80109a88:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a8e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a95:	83 e2 df             	and    $0xffffffdf,%edx
80109a98:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a9e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109aa5:	83 ca 40             	or     $0x40,%edx
80109aa8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109aae:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109ab5:	83 e2 7f             	and    $0x7f,%edx
80109ab8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109abe:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109ac4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109aca:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109ad1:	83 e2 ef             	and    $0xffffffef,%edx
80109ad4:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109ada:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109ae0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109ae6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109aec:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109af3:	8b 52 08             	mov    0x8(%edx),%edx
80109af6:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109afc:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109aff:	83 ec 0c             	sub    $0xc,%esp
80109b02:	6a 30                	push   $0x30
80109b04:	e8 f3 f7 ff ff       	call   801092fc <ltr>
80109b09:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80109b0f:	8b 40 04             	mov    0x4(%eax),%eax
80109b12:	85 c0                	test   %eax,%eax
80109b14:	75 0d                	jne    80109b23 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109b16:	83 ec 0c             	sub    $0xc,%esp
80109b19:	68 3b ab 10 80       	push   $0x8010ab3b
80109b1e:	e8 43 6a ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109b23:	8b 45 08             	mov    0x8(%ebp),%eax
80109b26:	8b 40 04             	mov    0x4(%eax),%eax
80109b29:	83 ec 0c             	sub    $0xc,%esp
80109b2c:	50                   	push   %eax
80109b2d:	e8 03 f8 ff ff       	call   80109335 <v2p>
80109b32:	83 c4 10             	add    $0x10,%esp
80109b35:	83 ec 0c             	sub    $0xc,%esp
80109b38:	50                   	push   %eax
80109b39:	e8 eb f7 ff ff       	call   80109329 <lcr3>
80109b3e:	83 c4 10             	add    $0x10,%esp
  popcli();
80109b41:	e8 f8 ce ff ff       	call   80106a3e <popcli>
}
80109b46:	90                   	nop
80109b47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109b4a:	5b                   	pop    %ebx
80109b4b:	5e                   	pop    %esi
80109b4c:	5d                   	pop    %ebp
80109b4d:	c3                   	ret    

80109b4e <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109b4e:	55                   	push   %ebp
80109b4f:	89 e5                	mov    %esp,%ebp
80109b51:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109b54:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109b5b:	76 0d                	jbe    80109b6a <inituvm+0x1c>
    panic("inituvm: more than a page");
80109b5d:	83 ec 0c             	sub    $0xc,%esp
80109b60:	68 4f ab 10 80       	push   $0x8010ab4f
80109b65:	e8 fc 69 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109b6a:	e8 81 94 ff ff       	call   80102ff0 <kalloc>
80109b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109b72:	83 ec 04             	sub    $0x4,%esp
80109b75:	68 00 10 00 00       	push   $0x1000
80109b7a:	6a 00                	push   $0x0
80109b7c:	ff 75 f4             	pushl  -0xc(%ebp)
80109b7f:	e8 7b cf ff ff       	call   80106aff <memset>
80109b84:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b87:	83 ec 0c             	sub    $0xc,%esp
80109b8a:	ff 75 f4             	pushl  -0xc(%ebp)
80109b8d:	e8 a3 f7 ff ff       	call   80109335 <v2p>
80109b92:	83 c4 10             	add    $0x10,%esp
80109b95:	83 ec 0c             	sub    $0xc,%esp
80109b98:	6a 06                	push   $0x6
80109b9a:	50                   	push   %eax
80109b9b:	68 00 10 00 00       	push   $0x1000
80109ba0:	6a 00                	push   $0x0
80109ba2:	ff 75 08             	pushl  0x8(%ebp)
80109ba5:	e8 ba fc ff ff       	call   80109864 <mappages>
80109baa:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109bad:	83 ec 04             	sub    $0x4,%esp
80109bb0:	ff 75 10             	pushl  0x10(%ebp)
80109bb3:	ff 75 0c             	pushl  0xc(%ebp)
80109bb6:	ff 75 f4             	pushl  -0xc(%ebp)
80109bb9:	e8 00 d0 ff ff       	call   80106bbe <memmove>
80109bbe:	83 c4 10             	add    $0x10,%esp
}
80109bc1:	90                   	nop
80109bc2:	c9                   	leave  
80109bc3:	c3                   	ret    

80109bc4 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109bc4:	55                   	push   %ebp
80109bc5:	89 e5                	mov    %esp,%ebp
80109bc7:	53                   	push   %ebx
80109bc8:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bce:	25 ff 0f 00 00       	and    $0xfff,%eax
80109bd3:	85 c0                	test   %eax,%eax
80109bd5:	74 0d                	je     80109be4 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109bd7:	83 ec 0c             	sub    $0xc,%esp
80109bda:	68 6c ab 10 80       	push   $0x8010ab6c
80109bdf:	e8 82 69 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109beb:	e9 95 00 00 00       	jmp    80109c85 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
80109bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bf6:	01 d0                	add    %edx,%eax
80109bf8:	83 ec 04             	sub    $0x4,%esp
80109bfb:	6a 00                	push   $0x0
80109bfd:	50                   	push   %eax
80109bfe:	ff 75 08             	pushl  0x8(%ebp)
80109c01:	e8 be fb ff ff       	call   801097c4 <walkpgdir>
80109c06:	83 c4 10             	add    $0x10,%esp
80109c09:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109c0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109c10:	75 0d                	jne    80109c1f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109c12:	83 ec 0c             	sub    $0xc,%esp
80109c15:	68 8f ab 10 80       	push   $0x8010ab8f
80109c1a:	e8 47 69 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c22:	8b 00                	mov    (%eax),%eax
80109c24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109c2c:	8b 45 18             	mov    0x18(%ebp),%eax
80109c2f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109c32:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109c37:	77 0b                	ja     80109c44 <loaduvm+0x80>
      n = sz - i;
80109c39:	8b 45 18             	mov    0x18(%ebp),%eax
80109c3c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109c42:	eb 07                	jmp    80109c4b <loaduvm+0x87>
    else
      n = PGSIZE;
80109c44:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109c4b:	8b 55 14             	mov    0x14(%ebp),%edx
80109c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c51:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109c54:	83 ec 0c             	sub    $0xc,%esp
80109c57:	ff 75 e8             	pushl  -0x18(%ebp)
80109c5a:	e8 e3 f6 ff ff       	call   80109342 <p2v>
80109c5f:	83 c4 10             	add    $0x10,%esp
80109c62:	ff 75 f0             	pushl  -0x10(%ebp)
80109c65:	53                   	push   %ebx
80109c66:	50                   	push   %eax
80109c67:	ff 75 10             	pushl  0x10(%ebp)
80109c6a:	e8 f3 85 ff ff       	call   80102262 <readi>
80109c6f:	83 c4 10             	add    $0x10,%esp
80109c72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109c75:	74 07                	je     80109c7e <loaduvm+0xba>
      return -1;
80109c77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109c7c:	eb 18                	jmp    80109c96 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109c7e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c88:	3b 45 18             	cmp    0x18(%ebp),%eax
80109c8b:	0f 82 5f ff ff ff    	jb     80109bf0 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109c96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109c99:	c9                   	leave  
80109c9a:	c3                   	ret    

80109c9b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109c9b:	55                   	push   %ebp
80109c9c:	89 e5                	mov    %esp,%ebp
80109c9e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109ca1:	8b 45 10             	mov    0x10(%ebp),%eax
80109ca4:	85 c0                	test   %eax,%eax
80109ca6:	79 0a                	jns    80109cb2 <allocuvm+0x17>
    return 0;
80109ca8:	b8 00 00 00 00       	mov    $0x0,%eax
80109cad:	e9 b0 00 00 00       	jmp    80109d62 <allocuvm+0xc7>
  if(newsz < oldsz)
80109cb2:	8b 45 10             	mov    0x10(%ebp),%eax
80109cb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109cb8:	73 08                	jae    80109cc2 <allocuvm+0x27>
    return oldsz;
80109cba:	8b 45 0c             	mov    0xc(%ebp),%eax
80109cbd:	e9 a0 00 00 00       	jmp    80109d62 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80109cc5:	05 ff 0f 00 00       	add    $0xfff,%eax
80109cca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109cd2:	eb 7f                	jmp    80109d53 <allocuvm+0xb8>
    mem = kalloc();
80109cd4:	e8 17 93 ff ff       	call   80102ff0 <kalloc>
80109cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109ce0:	75 2b                	jne    80109d0d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109ce2:	83 ec 0c             	sub    $0xc,%esp
80109ce5:	68 ad ab 10 80       	push   $0x8010abad
80109cea:	e8 d7 66 ff ff       	call   801003c6 <cprintf>
80109cef:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109cf2:	83 ec 04             	sub    $0x4,%esp
80109cf5:	ff 75 0c             	pushl  0xc(%ebp)
80109cf8:	ff 75 10             	pushl  0x10(%ebp)
80109cfb:	ff 75 08             	pushl  0x8(%ebp)
80109cfe:	e8 61 00 00 00       	call   80109d64 <deallocuvm>
80109d03:	83 c4 10             	add    $0x10,%esp
      return 0;
80109d06:	b8 00 00 00 00       	mov    $0x0,%eax
80109d0b:	eb 55                	jmp    80109d62 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109d0d:	83 ec 04             	sub    $0x4,%esp
80109d10:	68 00 10 00 00       	push   $0x1000
80109d15:	6a 00                	push   $0x0
80109d17:	ff 75 f0             	pushl  -0x10(%ebp)
80109d1a:	e8 e0 cd ff ff       	call   80106aff <memset>
80109d1f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109d22:	83 ec 0c             	sub    $0xc,%esp
80109d25:	ff 75 f0             	pushl  -0x10(%ebp)
80109d28:	e8 08 f6 ff ff       	call   80109335 <v2p>
80109d2d:	83 c4 10             	add    $0x10,%esp
80109d30:	89 c2                	mov    %eax,%edx
80109d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d35:	83 ec 0c             	sub    $0xc,%esp
80109d38:	6a 06                	push   $0x6
80109d3a:	52                   	push   %edx
80109d3b:	68 00 10 00 00       	push   $0x1000
80109d40:	50                   	push   %eax
80109d41:	ff 75 08             	pushl  0x8(%ebp)
80109d44:	e8 1b fb ff ff       	call   80109864 <mappages>
80109d49:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109d4c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d56:	3b 45 10             	cmp    0x10(%ebp),%eax
80109d59:	0f 82 75 ff ff ff    	jb     80109cd4 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109d5f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109d62:	c9                   	leave  
80109d63:	c3                   	ret    

80109d64 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109d64:	55                   	push   %ebp
80109d65:	89 e5                	mov    %esp,%ebp
80109d67:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109d6a:	8b 45 10             	mov    0x10(%ebp),%eax
80109d6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109d70:	72 08                	jb     80109d7a <deallocuvm+0x16>
    return oldsz;
80109d72:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d75:	e9 a5 00 00 00       	jmp    80109e1f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109d7a:	8b 45 10             	mov    0x10(%ebp),%eax
80109d7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80109d82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109d8a:	e9 81 00 00 00       	jmp    80109e10 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d92:	83 ec 04             	sub    $0x4,%esp
80109d95:	6a 00                	push   $0x0
80109d97:	50                   	push   %eax
80109d98:	ff 75 08             	pushl  0x8(%ebp)
80109d9b:	e8 24 fa ff ff       	call   801097c4 <walkpgdir>
80109da0:	83 c4 10             	add    $0x10,%esp
80109da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109daa:	75 09                	jne    80109db5 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109dac:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109db3:	eb 54                	jmp    80109e09 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109db8:	8b 00                	mov    (%eax),%eax
80109dba:	83 e0 01             	and    $0x1,%eax
80109dbd:	85 c0                	test   %eax,%eax
80109dbf:	74 48                	je     80109e09 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dc4:	8b 00                	mov    (%eax),%eax
80109dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109dce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109dd2:	75 0d                	jne    80109de1 <deallocuvm+0x7d>
        panic("kfree");
80109dd4:	83 ec 0c             	sub    $0xc,%esp
80109dd7:	68 c5 ab 10 80       	push   $0x8010abc5
80109ddc:	e8 85 67 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109de1:	83 ec 0c             	sub    $0xc,%esp
80109de4:	ff 75 ec             	pushl  -0x14(%ebp)
80109de7:	e8 56 f5 ff ff       	call   80109342 <p2v>
80109dec:	83 c4 10             	add    $0x10,%esp
80109def:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109df2:	83 ec 0c             	sub    $0xc,%esp
80109df5:	ff 75 e8             	pushl  -0x18(%ebp)
80109df8:	e8 56 91 ff ff       	call   80102f53 <kfree>
80109dfd:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109e09:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e13:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e16:	0f 82 73 ff ff ff    	jb     80109d8f <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109e1c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109e1f:	c9                   	leave  
80109e20:	c3                   	ret    

80109e21 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109e21:	55                   	push   %ebp
80109e22:	89 e5                	mov    %esp,%ebp
80109e24:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109e2b:	75 0d                	jne    80109e3a <freevm+0x19>
    panic("freevm: no pgdir");
80109e2d:	83 ec 0c             	sub    $0xc,%esp
80109e30:	68 cb ab 10 80       	push   $0x8010abcb
80109e35:	e8 2c 67 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109e3a:	83 ec 04             	sub    $0x4,%esp
80109e3d:	6a 00                	push   $0x0
80109e3f:	68 00 00 00 80       	push   $0x80000000
80109e44:	ff 75 08             	pushl  0x8(%ebp)
80109e47:	e8 18 ff ff ff       	call   80109d64 <deallocuvm>
80109e4c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109e4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109e56:	eb 4f                	jmp    80109ea7 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109e62:	8b 45 08             	mov    0x8(%ebp),%eax
80109e65:	01 d0                	add    %edx,%eax
80109e67:	8b 00                	mov    (%eax),%eax
80109e69:	83 e0 01             	and    $0x1,%eax
80109e6c:	85 c0                	test   %eax,%eax
80109e6e:	74 33                	je     80109ea3 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80109e7d:	01 d0                	add    %edx,%eax
80109e7f:	8b 00                	mov    (%eax),%eax
80109e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e86:	83 ec 0c             	sub    $0xc,%esp
80109e89:	50                   	push   %eax
80109e8a:	e8 b3 f4 ff ff       	call   80109342 <p2v>
80109e8f:	83 c4 10             	add    $0x10,%esp
80109e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109e95:	83 ec 0c             	sub    $0xc,%esp
80109e98:	ff 75 f0             	pushl  -0x10(%ebp)
80109e9b:	e8 b3 90 ff ff       	call   80102f53 <kfree>
80109ea0:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109ea3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109ea7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109eae:	76 a8                	jbe    80109e58 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109eb0:	83 ec 0c             	sub    $0xc,%esp
80109eb3:	ff 75 08             	pushl  0x8(%ebp)
80109eb6:	e8 98 90 ff ff       	call   80102f53 <kfree>
80109ebb:	83 c4 10             	add    $0x10,%esp
}
80109ebe:	90                   	nop
80109ebf:	c9                   	leave  
80109ec0:	c3                   	ret    

80109ec1 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109ec1:	55                   	push   %ebp
80109ec2:	89 e5                	mov    %esp,%ebp
80109ec4:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109ec7:	83 ec 04             	sub    $0x4,%esp
80109eca:	6a 00                	push   $0x0
80109ecc:	ff 75 0c             	pushl  0xc(%ebp)
80109ecf:	ff 75 08             	pushl  0x8(%ebp)
80109ed2:	e8 ed f8 ff ff       	call   801097c4 <walkpgdir>
80109ed7:	83 c4 10             	add    $0x10,%esp
80109eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109ee1:	75 0d                	jne    80109ef0 <clearpteu+0x2f>
    panic("clearpteu");
80109ee3:	83 ec 0c             	sub    $0xc,%esp
80109ee6:	68 dc ab 10 80       	push   $0x8010abdc
80109eeb:	e8 76 66 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ef3:	8b 00                	mov    (%eax),%eax
80109ef5:	83 e0 fb             	and    $0xfffffffb,%eax
80109ef8:	89 c2                	mov    %eax,%edx
80109efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109efd:	89 10                	mov    %edx,(%eax)
}
80109eff:	90                   	nop
80109f00:	c9                   	leave  
80109f01:	c3                   	ret    

80109f02 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109f02:	55                   	push   %ebp
80109f03:	89 e5                	mov    %esp,%ebp
80109f05:	53                   	push   %ebx
80109f06:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109f09:	e8 e6 f9 ff ff       	call   801098f4 <setupkvm>
80109f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109f11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109f15:	75 0a                	jne    80109f21 <copyuvm+0x1f>
    return 0;
80109f17:	b8 00 00 00 00       	mov    $0x0,%eax
80109f1c:	e9 f8 00 00 00       	jmp    8010a019 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109f21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109f28:	e9 c4 00 00 00       	jmp    80109ff1 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f30:	83 ec 04             	sub    $0x4,%esp
80109f33:	6a 00                	push   $0x0
80109f35:	50                   	push   %eax
80109f36:	ff 75 08             	pushl  0x8(%ebp)
80109f39:	e8 86 f8 ff ff       	call   801097c4 <walkpgdir>
80109f3e:	83 c4 10             	add    $0x10,%esp
80109f41:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109f44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109f48:	75 0d                	jne    80109f57 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109f4a:	83 ec 0c             	sub    $0xc,%esp
80109f4d:	68 e6 ab 10 80       	push   $0x8010abe6
80109f52:	e8 0f 66 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f5a:	8b 00                	mov    (%eax),%eax
80109f5c:	83 e0 01             	and    $0x1,%eax
80109f5f:	85 c0                	test   %eax,%eax
80109f61:	75 0d                	jne    80109f70 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109f63:	83 ec 0c             	sub    $0xc,%esp
80109f66:	68 00 ac 10 80       	push   $0x8010ac00
80109f6b:	e8 f6 65 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f73:	8b 00                	mov    (%eax),%eax
80109f75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109f7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f80:	8b 00                	mov    (%eax),%eax
80109f82:	25 ff 0f 00 00       	and    $0xfff,%eax
80109f87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109f8a:	e8 61 90 ff ff       	call   80102ff0 <kalloc>
80109f8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109f92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109f96:	74 6a                	je     8010a002 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109f98:	83 ec 0c             	sub    $0xc,%esp
80109f9b:	ff 75 e8             	pushl  -0x18(%ebp)
80109f9e:	e8 9f f3 ff ff       	call   80109342 <p2v>
80109fa3:	83 c4 10             	add    $0x10,%esp
80109fa6:	83 ec 04             	sub    $0x4,%esp
80109fa9:	68 00 10 00 00       	push   $0x1000
80109fae:	50                   	push   %eax
80109faf:	ff 75 e0             	pushl  -0x20(%ebp)
80109fb2:	e8 07 cc ff ff       	call   80106bbe <memmove>
80109fb7:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109fba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109fbd:	83 ec 0c             	sub    $0xc,%esp
80109fc0:	ff 75 e0             	pushl  -0x20(%ebp)
80109fc3:	e8 6d f3 ff ff       	call   80109335 <v2p>
80109fc8:	83 c4 10             	add    $0x10,%esp
80109fcb:	89 c2                	mov    %eax,%edx
80109fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fd0:	83 ec 0c             	sub    $0xc,%esp
80109fd3:	53                   	push   %ebx
80109fd4:	52                   	push   %edx
80109fd5:	68 00 10 00 00       	push   $0x1000
80109fda:	50                   	push   %eax
80109fdb:	ff 75 f0             	pushl  -0x10(%ebp)
80109fde:	e8 81 f8 ff ff       	call   80109864 <mappages>
80109fe3:	83 c4 20             	add    $0x20,%esp
80109fe6:	85 c0                	test   %eax,%eax
80109fe8:	78 1b                	js     8010a005 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109fea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ff4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109ff7:	0f 82 30 ff ff ff    	jb     80109f2d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a000:	eb 17                	jmp    8010a019 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010a002:	90                   	nop
8010a003:	eb 01                	jmp    8010a006 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010a005:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010a006:	83 ec 0c             	sub    $0xc,%esp
8010a009:	ff 75 f0             	pushl  -0x10(%ebp)
8010a00c:	e8 10 fe ff ff       	call   80109e21 <freevm>
8010a011:	83 c4 10             	add    $0x10,%esp
  return 0;
8010a014:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010a01c:	c9                   	leave  
8010a01d:	c3                   	ret    

8010a01e <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010a01e:	55                   	push   %ebp
8010a01f:	89 e5                	mov    %esp,%ebp
8010a021:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010a024:	83 ec 04             	sub    $0x4,%esp
8010a027:	6a 00                	push   $0x0
8010a029:	ff 75 0c             	pushl  0xc(%ebp)
8010a02c:	ff 75 08             	pushl  0x8(%ebp)
8010a02f:	e8 90 f7 ff ff       	call   801097c4 <walkpgdir>
8010a034:	83 c4 10             	add    $0x10,%esp
8010a037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010a03a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a03d:	8b 00                	mov    (%eax),%eax
8010a03f:	83 e0 01             	and    $0x1,%eax
8010a042:	85 c0                	test   %eax,%eax
8010a044:	75 07                	jne    8010a04d <uva2ka+0x2f>
    return 0;
8010a046:	b8 00 00 00 00       	mov    $0x0,%eax
8010a04b:	eb 29                	jmp    8010a076 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010a04d:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a050:	8b 00                	mov    (%eax),%eax
8010a052:	83 e0 04             	and    $0x4,%eax
8010a055:	85 c0                	test   %eax,%eax
8010a057:	75 07                	jne    8010a060 <uva2ka+0x42>
    return 0;
8010a059:	b8 00 00 00 00       	mov    $0x0,%eax
8010a05e:	eb 16                	jmp    8010a076 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010a060:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a063:	8b 00                	mov    (%eax),%eax
8010a065:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a06a:	83 ec 0c             	sub    $0xc,%esp
8010a06d:	50                   	push   %eax
8010a06e:	e8 cf f2 ff ff       	call   80109342 <p2v>
8010a073:	83 c4 10             	add    $0x10,%esp
}
8010a076:	c9                   	leave  
8010a077:	c3                   	ret    

8010a078 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a078:	55                   	push   %ebp
8010a079:	89 e5                	mov    %esp,%ebp
8010a07b:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010a07e:	8b 45 10             	mov    0x10(%ebp),%eax
8010a081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a084:	eb 7f                	jmp    8010a105 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a086:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a089:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a08e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a091:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a094:	83 ec 08             	sub    $0x8,%esp
8010a097:	50                   	push   %eax
8010a098:	ff 75 08             	pushl  0x8(%ebp)
8010a09b:	e8 7e ff ff ff       	call   8010a01e <uva2ka>
8010a0a0:	83 c4 10             	add    $0x10,%esp
8010a0a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a0a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a0aa:	75 07                	jne    8010a0b3 <copyout+0x3b>
      return -1;
8010a0ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a0b1:	eb 61                	jmp    8010a114 <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a0b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0b6:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a0b9:	05 00 10 00 00       	add    $0x1000,%eax
8010a0be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a0c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0c4:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a0c7:	76 06                	jbe    8010a0cf <copyout+0x57>
      n = len;
8010a0c9:	8b 45 14             	mov    0x14(%ebp),%eax
8010a0cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a0cf:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a0d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a0d5:	89 c2                	mov    %eax,%edx
8010a0d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a0da:	01 d0                	add    %edx,%eax
8010a0dc:	83 ec 04             	sub    $0x4,%esp
8010a0df:	ff 75 f0             	pushl  -0x10(%ebp)
8010a0e2:	ff 75 f4             	pushl  -0xc(%ebp)
8010a0e5:	50                   	push   %eax
8010a0e6:	e8 d3 ca ff ff       	call   80106bbe <memmove>
8010a0eb:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a0ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0f1:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a0f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0f7:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a0fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0fd:	05 00 10 00 00       	add    $0x1000,%eax
8010a102:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a105:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a109:	0f 85 77 ff ff ff    	jne    8010a086 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a10f:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a114:	c9                   	leave  
8010a115:	c3                   	ret    
