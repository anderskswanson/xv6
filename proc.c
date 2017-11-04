#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif

//project 4

#ifdef CS333_P3P4
struct StateLists {
    struct proc* ready;
    struct proc* free;
    struct proc* sleep;
    struct proc* zombie;
    struct proc* running;
    struct proc* embryo;
};
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3P4
  struct StateLists pLists;
#endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
#ifdef CS333_P2
static void printproc(struct proc *p, char *);
static void tickasfloat(uint);
#endif
#ifdef CS333_P3P4 //p3 helper functions
static struct proc * removeFromStateListHead(struct proc ** sList);
static int removeFromStateList(struct proc ** sList, struct proc * p);
static void assertState(struct proc * p, enum procstate state);
static int addToStateListEnd(struct proc ** sList, struct proc * p);
static int addToStateListHead(struct proc ** sList, struct proc * p);
static void exitSearch(struct proc * sList);
static int waitSearch(struct proc * sList);
static void ctrlprint(struct proc * sList);
#endif
void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  acquire(&ptable.lock);
#ifdef CS333_P3P4
  p = removeFromStateListHead(&ptable.pLists.free);
  if(p)
  {
      assertState(p, UNUSED);
      goto found;
  }
#else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
#endif
  release(&ptable.lock);
  return 0;

found:
#ifdef CS333_P1
  p->start_ticks = ticks;
#endif
#ifdef CS333_P2  
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
#endif
  p->state = EMBRYO; 
  p->pid = nextpid++;
#ifdef CS333_P3P4
  if(addToStateListHead(&ptable.pLists.embryo, p) == 0)
      panic("Failed add embryo in allocproc");
#endif
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
#ifdef CS333_P3P4 //return to free
    acquire(&ptable.lock);
    if(removeFromStateList(&ptable.pLists.embryo, p) == 0)
        panic("Failed allocproc remove from embryo");
    assertState(p, EMBRYO);
    if(addToStateListHead(&ptable.pLists.free, p) == 0)
        panic("Failed Allocproc Add To Free");
    release(&ptable.lock);
#endif
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_P3P4
  acquire(&ptable.lock);
  ptable.pLists.free = 0;
  ptable.pLists.ready = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.embryo = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
      p->state = UNUSED;
      if(addToStateListHead(&ptable.pLists.free, p) == 0)
          panic("Failed add to free in userinit");
  }
  release(&ptable.lock);
#endif
  
  p = allocproc();  //free goes to embryo
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
#ifdef CS333_P2
  p->uid = DEF_UID;
  p->gid = DEF_GID;
#endif
#ifdef CS333_P3P4
  //embryo goes to ready
  acquire(&ptable.lock);
  if(removeFromStateList(&ptable.pLists.embryo, p) == -1)
  {
      assertState(p, EMBRYO);
      p->next = 0;
      ptable.pLists.ready = p;
  }
  else
      panic("Error Initializing Ready List");
  release(&ptable.lock);
#endif
  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int //starts as embryo here
fork(void)
{
  int i, pid;
  struct proc *np;
  
  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;


  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
#ifdef CS333_P3P4
    acquire(&ptable.lock); 
    //give to free : handle return value?
    if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
        panic("Failed remove from Embryo in fork");
    assertState(np, EMBRYO);    
    if(addToStateListHead(&ptable.pLists.free, np) == 0)
        panic("Failed add to free in fork");
    release(&ptable.lock);
#endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

#ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
#endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.embryo, np) == 0)
      panic("fork fail");
  assertState(np, EMBRYO);
  if(addToStateListEnd(&ptable.pLists.ready, np) == 0)
      panic("Fork fail 2");
#endif
  np->state = RUNNABLE;
  release(&ptable.lock);
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *p;
  //struct proc *current;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  

  // Pass abandoned children to init.

  exitSearch(ptable.pLists.ready);
  exitSearch(ptable.pLists.running);
  exitSearch(ptable.pLists.sleep);
  exitSearch(ptable.pLists.embryo);

  p = ptable.pLists.zombie;
  while(p)
  {
      if(p->parent == proc)
      {
          p->parent = initproc;
          wakeup1(initproc);
      }
      p = p->next;
  }

  // Jump into the scheduler, never to return.

  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
      panic("exit failed running");
  assertState(proc, RUNNING);
  if(addToStateListHead(&ptable.pLists.zombie, proc) == 0)
      panic("exit failed zombie");
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;
    while(p)
    {                   
      if(p->parent == proc){
        havekids = 1;
        // Found one.
        if(removeFromStateList(&ptable.pLists.zombie, p) == 0)
            panic("wait zombie");
        assertState(p, ZOMBIE);
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        if(addToStateListHead(&ptable.pLists.free, p) == 0)
            panic("wait free");        
        release(&ptable.lock);
        return pid;
      }
      p = p->next;
    }

    if(havekids == 0)
        havekids = waitSearch(ptable.pLists.ready);
    if(havekids == 0)
        havekids = waitSearch(ptable.pLists.sleep);
    if(havekids == 0)
        havekids = waitSearch(ptable.pLists.running);
    if(havekids == 0)
        havekids = waitSearch(ptable.pLists.embryo);

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    p = removeFromStateListHead(&ptable.pLists.ready);
    if(p)
    {
      assertState(p, RUNNABLE);

//      cprintf("Process entering CPU: %d\n", p->pid);
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);

      p->state = RUNNING;
#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif
      if(addToStateListHead(&ptable.pLists.running, p) == 0)
          panic("failed sched add to running");
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;

    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
#ifdef CS333_P2
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
#endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
#ifdef CS333_P2
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
#endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
#ifdef CS333_P3P4 //from running to ready
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
      panic("Failed Yield Remove From Running");
  assertState(proc, RUNNING);
  if(addToStateListEnd(&ptable.pLists.ready, proc) == 0)
      panic("Failed Yield Add To Ready");
#endif
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

#ifdef CS333_P3P4
  if(removeFromStateList(&ptable.pLists.running, proc) == 0)
      panic("Failed In Sleep To Remove From Running");
  assertState(proc, RUNNING);
  if(addToStateListHead(&ptable.pLists.sleep, proc) == 0)
      panic("Failed In Sleep To Add To Sleep");
#endif
  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc * current;
  struct proc * found;

  current = ptable.pLists.sleep;
  while(current)
  {
      if(current->chan == chan)
      {
          found = current;
          current = current->next;
          if(removeFromStateList(&ptable.pLists.sleep, found) == 0)
              panic("Failed Wakeup Remove From Sleep");
          assertState(found, SLEEPING);
          found->state = RUNNABLE;
          if(addToStateListEnd(&ptable.pLists.ready, found) == 0)
              panic("Failed Wakupe Add To Ready");
      }
      else
          current = current->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p;
  acquire(&ptable.lock);

  //check ready
  p = ptable.pLists.ready;
  while(p)
  {
      if(p->pid == pid)
      {          
          p->killed = 1;
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }

  p = ptable.pLists.running;
  while(p)
  {
      if(p->pid == pid)
      {          
          p->killed = 1;
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }
  
  p = ptable.pLists.embryo;
  while(p)
  {
      if(p->pid == pid)
      {          
          p->killed = 1;
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }

  //check sleep
  p = ptable.pLists.sleep;
  while(p)
  {
      if(p->pid == pid)
      {
          p->killed = 1;
          if(removeFromStateList(&ptable.pLists.sleep, p) == 0)
              panic("kill sleep");
          assertState(p, SLEEPING);
          p->state = RUNNABLE;
          if(addToStateListEnd(&ptable.pLists.ready, p) == 0)
              panic("kill ready");
          release(&ptable.lock);
          return 0;
      }
      p = p->next;
  }
  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
 
#ifdef CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");   
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
#ifdef CS333_P2
    printproc(p, state);
#else
    cprintf("%d %s %s", p->pid, state, p->name);
#endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


#ifdef CS333_P2
static void
printproc(struct proc *p, char * state)
{
    uint ppid;
    if(p->pid == 1)
        ppid = 1;
    else
        ppid = p->parent->pid;
    cprintf("%d\t%s\t%d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid);
    tickasfloat(ticks - p->start_ticks);
    tickasfloat(p->cpu_ticks_total);
    cprintf("%s\t%d\t", state, p->sz);
}

static void 
tickasfloat(uint tickcount)
{
    uint ticksl = tickcount / 1000;
    uint ticksr = tickcount % 1000;
    cprintf("%d.", ticksl);
    if(ticksr < 10) //pad zeroes
       cprintf("%d%d%d\t", 0, 0, ticksr);
    else if(ticksr < 100)
        cprintf("%d%d\t", 0, ticksr);
    else
        cprintf("%d\t", ticksr);

}
#endif

#ifdef CS333_P2

int getprocdata(uint max, struct uproc *utable)
{
    int i = 0;
    struct proc * p;
    
    acquire(&ptable.lock);
    for(p = ptable.proc; i < max && p < &ptable.proc[NPROC]; p++)
    {
        if(p->state != UNUSED && p->state != EMBRYO)
        {
            utable[i].pid             = p->pid;
            utable[i].uid             = p->uid;
            utable[i].gid             = p->gid;
            if(p->pid == 1)
                utable[i].ppid        = 1;
            else
                utable[i].ppid        = p->parent->pid;
            utable[i].elapsed_ticks   = ticks - p->start_ticks;
            utable[i].CPU_total_ticks = p->cpu_ticks_total;
            utable[i].size            = p->sz;
            if(strncpy(utable[i].state, states[p->state], sizeof(states[p->state])+1) == 0)
                return -1;
            if(strncpy(utable[i].name, p->name, sizeof(p->name)+1) == 0)
                return -1;
            ++i;
        }
    }
    
    release(&ptable.lock);    

    return i;
}
#endif

#ifdef CS333_P3P4
static struct proc *
removeFromStateListHead(struct proc ** sList)
{
    struct proc * p;
    if(!(*sList))
        return 0;

    p = *sList;
    *sList = (*sList)->next;
    p->next = 0;

    return p;
}

static int 
removeFromStateList(struct proc ** sList, struct proc * p)
{
    struct proc * current;
    struct proc * prev = 0;
    if(!(*sList))
        return 0;

    current = *sList;
    //search list for p
    while(current->next && (p != current)) 
    {
        prev = current;
        current = current->next;
    }

    if(p->pid == current->pid)
    {
        if(prev) //middle of list
            prev->next = current->next;
        else //head of list
            *sList = current->next;
        p->next = 0;
        return -1;
    }

    //p not in list
    return 0;
}

static void 
assertState(struct proc * p, enum procstate state)
{
    if(p->state != state)
        panic("Process has invalid state for transition!");
}

static int 
addToStateListEnd(struct proc ** sList, struct proc * p)
{
    struct proc * current;

    if(!p)
        return 0;

    p->next = 0;
    if(!(*sList))
        *sList = p;
    else
    {
        current = *sList;
        while(current->next)
            current = current->next;

        current->next = p;
    }
    
    return -1;
}

static int 
addToStateListHead(struct proc ** sList, struct proc * p)
{
    if(p)
    {
        p->next = *sList;
        *sList = p;
        return -1;
    }
    else
        return 0;
}

static void
exitSearch(struct proc * sList)
{
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
        {
            if(current->parent == proc)
                current->parent = initproc;
            current = current->next;
        }
    }
}

static int 
waitSearch(struct proc * sList)
{
    struct proc * current;

    if(sList)
    {
        current = sList;
        while(current)
        {
            if(current->parent == proc)
                return 1;
            current = current->next;
        }
    }

    return 0;
    
}

static void 
ctrlprint(struct proc * sList)
{
    struct proc * current;
    if(sList)
    {
        current = sList;
        while(current)
        {
            if(current->next)
                cprintf("%d -> ", current->pid);
            else
                cprintf("%d\n", current->pid);
            current = current->next;
        }

        return;

    }

    cprintf("Empty List\n");
}

void
printsleep(void)
{
    cprintf("Sleep List Processes:\n");
    ctrlprint(ptable.pLists.sleep);
}

void
printfree(void)
{
    int count = 0;
    struct proc * current = ptable.pLists.free;
    cprintf("Free List Size: ");

    while(current)
    {
        ++count;
        current = current->next;
    }

    cprintf("%d processes\n", count);
}

void
printzombie(void)
{
    struct proc * current = ptable.pLists.zombie;
    uint ppid;

    cprintf("Zombie List:\n");
    if(!current)
        cprintf("Empty List\n");

    while(current)
    {
        if(current->pid == 1)
            ppid = 1;
        else if(current->parent)
            ppid = current->parent->pid;
        else
            ppid = 0;

        cprintf("(%d, %d)", current->pid, ppid);

        if(current->next)
            cprintf(" -> ");
        else
            cprintf("\n");

        current = current->next;
    }
}

void
printready(void)
{
    cprintf("Ready List Processes:\n");
    ctrlprint(ptable.pLists.ready);
}
#endif




















