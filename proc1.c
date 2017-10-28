#
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
    while(current->next && (p->pid != current->pid)) 
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

    if(!(*sList))
        *sList = p;
    else
    {
        current = *sList;
        while(current->next)
            current = current->next;

        current->next = p;
    }
        p->next = 0;
    
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
        while(current)
        {
            if(current->parent == proc)
                return 1;
            current = current->next;
        }
    }

    return 0;
    
}
void
test(void)
{
    cprintf("TEST\n");
}
#endif





















