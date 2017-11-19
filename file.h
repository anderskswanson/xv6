struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};

#ifdef CS333_P5
union stat_mode_t {
    struct {
        uint o_x : 1;
        uint o_w : 1;
        uint o_r : 1;
        uint g_x : 1;
        uint g_w : 1;
        uint g_r : 1;
        uint u_x : 1;
        uint u_w : 1;
        uint u_r : 1;
        uint     : 22;
    } flags; 
    uint asInt;
};
#endif

// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  int flags;          // I_BUSY, I_VALID

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
#ifdef CS333_P5
  ushort uid;
  ushort gid;
  union stat_mode_t mode;
#endif
  uint size;
  uint addrs[NDIRECT+1];
};
#define I_BUSY 0x1
#define I_VALID 0x2

// table mapping major device number to
// device functions
struct devsw {
  int (*read)(struct inode*, char*, int);
  int (*write)(struct inode*, char*, int);
};

extern struct devsw devsw[];

#define CONSOLE 1

// Blank page.
