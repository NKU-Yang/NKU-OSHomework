
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 80 11 00 	lgdtl  0x118018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 99 11 c0       	mov    $0xc0119968,%edx
c0100035:	b8 36 8a 11 c0       	mov    $0xc0118a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 8a 11 c0       	push   $0xc0118a36
c0100049:	e8 46 55 00 00       	call   c0105594 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 7b 15 00 00       	call   c01015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 40 5d 10 c0 	movl   $0xc0105d40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 5c 5d 10 c0       	push   $0xc0105d5c
c0100068:	e8 0a 02 00 00       	call   c0100277 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 8c 08 00 00       	call   c0100901 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 79 00 00 00       	call   c01000f3 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 36 33 00 00       	call   c01033b5 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 bf 16 00 00       	call   c0101743 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 41 18 00 00       	call   c01018ca <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 e6 0c 00 00       	call   c0100d74 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 ed 17 00 00       	call   c0101880 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c0100093:	e8 50 01 00 00       	call   c01001e8 <lab1_switch_test>

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	83 ec 04             	sub    $0x4,%esp
c01000a3:	6a 00                	push   $0x0
c01000a5:	6a 00                	push   $0x0
c01000a7:	6a 00                	push   $0x0
c01000a9:	e8 b4 0c 00 00       	call   c0100d62 <mon_backtrace>
c01000ae:	83 c4 10             	add    $0x10,%esp
}
c01000b1:	90                   	nop
c01000b2:	c9                   	leave  
c01000b3:	c3                   	ret    

c01000b4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000b4:	55                   	push   %ebp
c01000b5:	89 e5                	mov    %esp,%ebp
c01000b7:	53                   	push   %ebx
c01000b8:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000bb:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c1:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c7:	51                   	push   %ecx
c01000c8:	52                   	push   %edx
c01000c9:	53                   	push   %ebx
c01000ca:	50                   	push   %eax
c01000cb:	e8 ca ff ff ff       	call   c010009a <grade_backtrace2>
c01000d0:	83 c4 10             	add    $0x10,%esp
}
c01000d3:	90                   	nop
c01000d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000df:	83 ec 08             	sub    $0x8,%esp
c01000e2:	ff 75 10             	pushl  0x10(%ebp)
c01000e5:	ff 75 08             	pushl  0x8(%ebp)
c01000e8:	e8 c7 ff ff ff       	call   c01000b4 <grade_backtrace1>
c01000ed:	83 c4 10             	add    $0x10,%esp
}
c01000f0:	90                   	nop
c01000f1:	c9                   	leave  
c01000f2:	c3                   	ret    

c01000f3 <grade_backtrace>:

void
grade_backtrace(void) {
c01000f3:	55                   	push   %ebp
c01000f4:	89 e5                	mov    %esp,%ebp
c01000f6:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f9:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000fe:	83 ec 04             	sub    $0x4,%esp
c0100101:	68 00 00 ff ff       	push   $0xffff0000
c0100106:	50                   	push   %eax
c0100107:	6a 00                	push   $0x0
c0100109:	e8 cb ff ff ff       	call   c01000d9 <grade_backtrace0>
c010010e:	83 c4 10             	add    $0x10,%esp
}
c0100111:	90                   	nop
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010011a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010011d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100120:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100123:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100126:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010012a:	0f b7 c0             	movzwl %ax,%eax
c010012d:	83 e0 03             	and    $0x3,%eax
c0100130:	89 c2                	mov    %eax,%edx
c0100132:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100137:	83 ec 04             	sub    $0x4,%esp
c010013a:	52                   	push   %edx
c010013b:	50                   	push   %eax
c010013c:	68 61 5d 10 c0       	push   $0xc0105d61
c0100141:	e8 31 01 00 00       	call   c0100277 <cprintf>
c0100146:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100149:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014d:	0f b7 d0             	movzwl %ax,%edx
c0100150:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100155:	83 ec 04             	sub    $0x4,%esp
c0100158:	52                   	push   %edx
c0100159:	50                   	push   %eax
c010015a:	68 6f 5d 10 c0       	push   $0xc0105d6f
c010015f:	e8 13 01 00 00       	call   c0100277 <cprintf>
c0100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100167:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010016b:	0f b7 d0             	movzwl %ax,%edx
c010016e:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100173:	83 ec 04             	sub    $0x4,%esp
c0100176:	52                   	push   %edx
c0100177:	50                   	push   %eax
c0100178:	68 7d 5d 10 c0       	push   $0xc0105d7d
c010017d:	e8 f5 00 00 00       	call   c0100277 <cprintf>
c0100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100185:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100191:	83 ec 04             	sub    $0x4,%esp
c0100194:	52                   	push   %edx
c0100195:	50                   	push   %eax
c0100196:	68 8b 5d 10 c0       	push   $0xc0105d8b
c010019b:	e8 d7 00 00 00       	call   c0100277 <cprintf>
c01001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a7:	0f b7 d0             	movzwl %ax,%edx
c01001aa:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001af:	83 ec 04             	sub    $0x4,%esp
c01001b2:	52                   	push   %edx
c01001b3:	50                   	push   %eax
c01001b4:	68 99 5d 10 c0       	push   $0xc0105d99
c01001b9:	e8 b9 00 00 00       	call   c0100277 <cprintf>
c01001be:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c1:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001c6:	83 c0 01             	add    $0x1,%eax
c01001c9:	a3 40 8a 11 c0       	mov    %eax,0xc0118a40
}
c01001ce:	90                   	nop
c01001cf:	c9                   	leave  
c01001d0:	c3                   	ret    

c01001d1 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d1:	55                   	push   %ebp
c01001d2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
c01001d4:	83 ec 08             	sub    $0x8,%esp
c01001d7:	cd 78                	int    $0x78
c01001d9:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp"
		:
	: "i"(T_SWITCH_TOU)
		);
}
c01001db:	90                   	nop
c01001dc:	5d                   	pop    %ebp
c01001dd:	c3                   	ret    

c01001de <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001de:	55                   	push   %ebp
c01001df:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
c01001e1:	cd 79                	int    $0x79
c01001e3:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"
		:
	: "i"(T_SWITCH_TOK)
		);
}
c01001e5:	90                   	nop
c01001e6:	5d                   	pop    %ebp
c01001e7:	c3                   	ret    

c01001e8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e8:	55                   	push   %ebp
c01001e9:	89 e5                	mov    %esp,%ebp
c01001eb:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001ee:	e8 21 ff ff ff       	call   c0100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001f3:	83 ec 0c             	sub    $0xc,%esp
c01001f6:	68 a8 5d 10 c0       	push   $0xc0105da8
c01001fb:	e8 77 00 00 00       	call   c0100277 <cprintf>
c0100200:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100203:	e8 c9 ff ff ff       	call   c01001d1 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100208:	e8 07 ff ff ff       	call   c0100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010020d:	83 ec 0c             	sub    $0xc,%esp
c0100210:	68 c8 5d 10 c0       	push   $0xc0105dc8
c0100215:	e8 5d 00 00 00       	call   c0100277 <cprintf>
c010021a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010021d:	e8 bc ff ff ff       	call   c01001de <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100222:	e8 ed fe ff ff       	call   c0100114 <lab1_print_cur_status>
}
c0100227:	90                   	nop
c0100228:	c9                   	leave  
c0100229:	c3                   	ret    

c010022a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010022a:	55                   	push   %ebp
c010022b:	89 e5                	mov    %esp,%ebp
c010022d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100230:	83 ec 0c             	sub    $0xc,%esp
c0100233:	ff 75 08             	pushl  0x8(%ebp)
c0100236:	e8 c7 13 00 00       	call   c0101602 <cons_putc>
c010023b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010023e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100241:	8b 00                	mov    (%eax),%eax
c0100243:	8d 50 01             	lea    0x1(%eax),%edx
c0100246:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100249:	89 10                	mov    %edx,(%eax)
}
c010024b:	90                   	nop
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010025b:	ff 75 0c             	pushl  0xc(%ebp)
c010025e:	ff 75 08             	pushl  0x8(%ebp)
c0100261:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100264:	50                   	push   %eax
c0100265:	68 2a 02 10 c0       	push   $0xc010022a
c010026a:	e8 5b 56 00 00       	call   c01058ca <vprintfmt>
c010026f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100272:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100275:	c9                   	leave  
c0100276:	c3                   	ret    

c0100277 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100277:	55                   	push   %ebp
c0100278:	89 e5                	mov    %esp,%ebp
c010027a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010027d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100280:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100283:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100286:	83 ec 08             	sub    $0x8,%esp
c0100289:	50                   	push   %eax
c010028a:	ff 75 08             	pushl  0x8(%ebp)
c010028d:	e8 bc ff ff ff       	call   c010024e <vcprintf>
c0100292:	83 c4 10             	add    $0x10,%esp
c0100295:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010029b:	c9                   	leave  
c010029c:	c3                   	ret    

c010029d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010029d:	55                   	push   %ebp
c010029e:	89 e5                	mov    %esp,%ebp
c01002a0:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002a3:	83 ec 0c             	sub    $0xc,%esp
c01002a6:	ff 75 08             	pushl  0x8(%ebp)
c01002a9:	e8 54 13 00 00       	call   c0101602 <cons_putc>
c01002ae:	83 c4 10             	add    $0x10,%esp
}
c01002b1:	90                   	nop
c01002b2:	c9                   	leave  
c01002b3:	c3                   	ret    

c01002b4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002b4:	55                   	push   %ebp
c01002b5:	89 e5                	mov    %esp,%ebp
c01002b7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002c1:	eb 14                	jmp    c01002d7 <cputs+0x23>
        cputch(c, &cnt);
c01002c3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002c7:	83 ec 08             	sub    $0x8,%esp
c01002ca:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002cd:	52                   	push   %edx
c01002ce:	50                   	push   %eax
c01002cf:	e8 56 ff ff ff       	call   c010022a <cputch>
c01002d4:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c01002d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002da:	8d 50 01             	lea    0x1(%eax),%edx
c01002dd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002e0:	0f b6 00             	movzbl (%eax),%eax
c01002e3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002e6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002ea:	75 d7                	jne    c01002c3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01002ec:	83 ec 08             	sub    $0x8,%esp
c01002ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002f2:	50                   	push   %eax
c01002f3:	6a 0a                	push   $0xa
c01002f5:	e8 30 ff ff ff       	call   c010022a <cputch>
c01002fa:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100300:	c9                   	leave  
c0100301:	c3                   	ret    

c0100302 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100302:	55                   	push   %ebp
c0100303:	89 e5                	mov    %esp,%ebp
c0100305:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100308:	e8 3e 13 00 00       	call   c010164b <cons_getc>
c010030d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100314:	74 f2                	je     c0100308 <getchar+0x6>
        /* do nothing */;
    return c;
c0100316:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100319:	c9                   	leave  
c010031a:	c3                   	ret    

c010031b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010031b:	55                   	push   %ebp
c010031c:	89 e5                	mov    %esp,%ebp
c010031e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100325:	74 13                	je     c010033a <readline+0x1f>
        cprintf("%s", prompt);
c0100327:	83 ec 08             	sub    $0x8,%esp
c010032a:	ff 75 08             	pushl  0x8(%ebp)
c010032d:	68 e7 5d 10 c0       	push   $0xc0105de7
c0100332:	e8 40 ff ff ff       	call   c0100277 <cprintf>
c0100337:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010033a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100341:	e8 bc ff ff ff       	call   c0100302 <getchar>
c0100346:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100349:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010034d:	79 0a                	jns    c0100359 <readline+0x3e>
            return NULL;
c010034f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100354:	e9 82 00 00 00       	jmp    c01003db <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100359:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010035d:	7e 2b                	jle    c010038a <readline+0x6f>
c010035f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100366:	7f 22                	jg     c010038a <readline+0x6f>
            cputchar(c);
c0100368:	83 ec 0c             	sub    $0xc,%esp
c010036b:	ff 75 f0             	pushl  -0x10(%ebp)
c010036e:	e8 2a ff ff ff       	call   c010029d <cputchar>
c0100373:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100376:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100379:	8d 50 01             	lea    0x1(%eax),%edx
c010037c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010037f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100382:	88 90 60 8a 11 c0    	mov    %dl,-0x3fee75a0(%eax)
c0100388:	eb 4c                	jmp    c01003d6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010038a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010038e:	75 1a                	jne    c01003aa <readline+0x8f>
c0100390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100394:	7e 14                	jle    c01003aa <readline+0x8f>
            cputchar(c);
c0100396:	83 ec 0c             	sub    $0xc,%esp
c0100399:	ff 75 f0             	pushl  -0x10(%ebp)
c010039c:	e8 fc fe ff ff       	call   c010029d <cputchar>
c01003a1:	83 c4 10             	add    $0x10,%esp
            i --;
c01003a4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003a8:	eb 2c                	jmp    c01003d6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003aa:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003ae:	74 06                	je     c01003b6 <readline+0x9b>
c01003b0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003b4:	75 8b                	jne    c0100341 <readline+0x26>
            cputchar(c);
c01003b6:	83 ec 0c             	sub    $0xc,%esp
c01003b9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003bc:	e8 dc fe ff ff       	call   c010029d <cputchar>
c01003c1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c7:	05 60 8a 11 c0       	add    $0xc0118a60,%eax
c01003cc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003cf:	b8 60 8a 11 c0       	mov    $0xc0118a60,%eax
c01003d4:	eb 05                	jmp    c01003db <readline+0xc0>
        c = getchar();
c01003d6:	e9 66 ff ff ff       	jmp    c0100341 <readline+0x26>
        }
    }
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003e3:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
c01003e8:	85 c0                	test   %eax,%eax
c01003ea:	75 4a                	jne    c0100436 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003ec:	c7 05 60 8e 11 c0 01 	movl   $0x1,0xc0118e60
c01003f3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003f6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003fc:	83 ec 04             	sub    $0x4,%esp
c01003ff:	ff 75 0c             	pushl  0xc(%ebp)
c0100402:	ff 75 08             	pushl  0x8(%ebp)
c0100405:	68 ea 5d 10 c0       	push   $0xc0105dea
c010040a:	e8 68 fe ff ff       	call   c0100277 <cprintf>
c010040f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100412:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100415:	83 ec 08             	sub    $0x8,%esp
c0100418:	50                   	push   %eax
c0100419:	ff 75 10             	pushl  0x10(%ebp)
c010041c:	e8 2d fe ff ff       	call   c010024e <vcprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100424:	83 ec 0c             	sub    $0xc,%esp
c0100427:	68 06 5e 10 c0       	push   $0xc0105e06
c010042c:	e8 46 fe ff ff       	call   c0100277 <cprintf>
c0100431:	83 c4 10             	add    $0x10,%esp
c0100434:	eb 01                	jmp    c0100437 <__panic+0x5a>
        goto panic_dead;
c0100436:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
c0100437:	e8 4b 14 00 00       	call   c0101887 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010043c:	83 ec 0c             	sub    $0xc,%esp
c010043f:	6a 00                	push   $0x0
c0100441:	e8 42 08 00 00       	call   c0100c88 <kmonitor>
c0100446:	83 c4 10             	add    $0x10,%esp
c0100449:	eb f1                	jmp    c010043c <__panic+0x5f>

c010044b <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010044b:	55                   	push   %ebp
c010044c:	89 e5                	mov    %esp,%ebp
c010044e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100451:	8d 45 14             	lea    0x14(%ebp),%eax
c0100454:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100457:	83 ec 04             	sub    $0x4,%esp
c010045a:	ff 75 0c             	pushl  0xc(%ebp)
c010045d:	ff 75 08             	pushl  0x8(%ebp)
c0100460:	68 08 5e 10 c0       	push   $0xc0105e08
c0100465:	e8 0d fe ff ff       	call   c0100277 <cprintf>
c010046a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100470:	83 ec 08             	sub    $0x8,%esp
c0100473:	50                   	push   %eax
c0100474:	ff 75 10             	pushl  0x10(%ebp)
c0100477:	e8 d2 fd ff ff       	call   c010024e <vcprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010047f:	83 ec 0c             	sub    $0xc,%esp
c0100482:	68 06 5e 10 c0       	push   $0xc0105e06
c0100487:	e8 eb fd ff ff       	call   c0100277 <cprintf>
c010048c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010048f:	90                   	nop
c0100490:	c9                   	leave  
c0100491:	c3                   	ret    

c0100492 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100492:	55                   	push   %ebp
c0100493:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100495:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
}
c010049a:	5d                   	pop    %ebp
c010049b:	c3                   	ret    

c010049c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010049c:	55                   	push   %ebp
c010049d:	89 e5                	mov    %esp,%ebp
c010049f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004a5:	8b 00                	mov    (%eax),%eax
c01004a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ad:	8b 00                	mov    (%eax),%eax
c01004af:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004b9:	e9 d2 00 00 00       	jmp    c0100590 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004c4:	01 d0                	add    %edx,%eax
c01004c6:	89 c2                	mov    %eax,%edx
c01004c8:	c1 ea 1f             	shr    $0x1f,%edx
c01004cb:	01 d0                	add    %edx,%eax
c01004cd:	d1 f8                	sar    %eax
c01004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004d8:	eb 04                	jmp    c01004de <stab_binsearch+0x42>
            m --;
c01004da:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004e4:	7c 1f                	jl     c0100505 <stab_binsearch+0x69>
c01004e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e9:	89 d0                	mov    %edx,%eax
c01004eb:	01 c0                	add    %eax,%eax
c01004ed:	01 d0                	add    %edx,%eax
c01004ef:	c1 e0 02             	shl    $0x2,%eax
c01004f2:	89 c2                	mov    %eax,%edx
c01004f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004f7:	01 d0                	add    %edx,%eax
c01004f9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004fd:	0f b6 c0             	movzbl %al,%eax
c0100500:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100503:	75 d5                	jne    c01004da <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100505:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100508:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050b:	7d 0b                	jge    c0100518 <stab_binsearch+0x7c>
            l = true_m + 1;
c010050d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100510:	83 c0 01             	add    $0x1,%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100516:	eb 78                	jmp    c0100590 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100518:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010051f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100522:	89 d0                	mov    %edx,%eax
c0100524:	01 c0                	add    %eax,%eax
c0100526:	01 d0                	add    %edx,%eax
c0100528:	c1 e0 02             	shl    $0x2,%eax
c010052b:	89 c2                	mov    %eax,%edx
c010052d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100530:	01 d0                	add    %edx,%eax
c0100532:	8b 40 08             	mov    0x8(%eax),%eax
c0100535:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100538:	76 13                	jbe    c010054d <stab_binsearch+0xb1>
            *region_left = m;
c010053a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100542:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100545:	83 c0 01             	add    $0x1,%eax
c0100548:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010054b:	eb 43                	jmp    c0100590 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010054d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100550:	89 d0                	mov    %edx,%eax
c0100552:	01 c0                	add    %eax,%eax
c0100554:	01 d0                	add    %edx,%eax
c0100556:	c1 e0 02             	shl    $0x2,%eax
c0100559:	89 c2                	mov    %eax,%edx
c010055b:	8b 45 08             	mov    0x8(%ebp),%eax
c010055e:	01 d0                	add    %edx,%eax
c0100560:	8b 40 08             	mov    0x8(%eax),%eax
c0100563:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100566:	73 16                	jae    c010057e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100568:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010056b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010056e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100571:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100573:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100576:	83 e8 01             	sub    $0x1,%eax
c0100579:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010057c:	eb 12                	jmp    c0100590 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010057e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100581:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100584:	89 10                	mov    %edx,(%eax)
            l = m;
c0100586:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100589:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010058c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c0100590:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100593:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100596:	0f 8e 22 ff ff ff    	jle    c01004be <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c010059c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005a0:	75 0f                	jne    c01005b1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a5:	8b 00                	mov    (%eax),%eax
c01005a7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01005ad:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005af:	eb 3f                	jmp    c01005f0 <stab_binsearch+0x154>
        l = *region_right;
c01005b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b4:	8b 00                	mov    (%eax),%eax
c01005b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005b9:	eb 04                	jmp    c01005bf <stab_binsearch+0x123>
c01005bb:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c2:	8b 00                	mov    (%eax),%eax
c01005c4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005c7:	7e 1f                	jle    c01005e8 <stab_binsearch+0x14c>
c01005c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	01 c0                	add    %eax,%eax
c01005d0:	01 d0                	add    %edx,%eax
c01005d2:	c1 e0 02             	shl    $0x2,%eax
c01005d5:	89 c2                	mov    %eax,%edx
c01005d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005da:	01 d0                	add    %edx,%eax
c01005dc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005e0:	0f b6 c0             	movzbl %al,%eax
c01005e3:	39 45 14             	cmp    %eax,0x14(%ebp)
c01005e6:	75 d3                	jne    c01005bb <stab_binsearch+0x11f>
        *region_left = l;
c01005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ee:	89 10                	mov    %edx,(%eax)
}
c01005f0:	90                   	nop
c01005f1:	c9                   	leave  
c01005f2:	c3                   	ret    

c01005f3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005f3:	55                   	push   %ebp
c01005f4:	89 e5                	mov    %esp,%ebp
c01005f6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fc:	c7 00 28 5e 10 c0    	movl   $0xc0105e28,(%eax)
    info->eip_line = 0;
c0100602:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010060c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060f:	c7 40 08 28 5e 10 c0 	movl   $0xc0105e28,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100616:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100619:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100623:	8b 55 08             	mov    0x8(%ebp),%edx
c0100626:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100633:	c7 45 f4 50 70 10 c0 	movl   $0xc0107050,-0xc(%ebp)
    stab_end = __STAB_END__;
c010063a:	c7 45 f0 4c 25 11 c0 	movl   $0xc011254c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100641:	c7 45 ec 4d 25 11 c0 	movl   $0xc011254d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100648:	c7 45 e8 cd 50 11 c0 	movl   $0xc01150cd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010064f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100652:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100655:	76 0d                	jbe    c0100664 <debuginfo_eip+0x71>
c0100657:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010065a:	83 e8 01             	sub    $0x1,%eax
c010065d:	0f b6 00             	movzbl (%eax),%eax
c0100660:	84 c0                	test   %al,%al
c0100662:	74 0a                	je     c010066e <debuginfo_eip+0x7b>
        return -1;
c0100664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100669:	e9 91 02 00 00       	jmp    c01008ff <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100675:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067b:	29 c2                	sub    %eax,%edx
c010067d:	89 d0                	mov    %edx,%eax
c010067f:	c1 f8 02             	sar    $0x2,%eax
c0100682:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100688:	83 e8 01             	sub    $0x1,%eax
c010068b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010068e:	ff 75 08             	pushl  0x8(%ebp)
c0100691:	6a 64                	push   $0x64
c0100693:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100696:	50                   	push   %eax
c0100697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010069a:	50                   	push   %eax
c010069b:	ff 75 f4             	pushl  -0xc(%ebp)
c010069e:	e8 f9 fd ff ff       	call   c010049c <stab_binsearch>
c01006a3:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006a9:	85 c0                	test   %eax,%eax
c01006ab:	75 0a                	jne    c01006b7 <debuginfo_eip+0xc4>
        return -1;
c01006ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b2:	e9 48 02 00 00       	jmp    c01008ff <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006c3:	ff 75 08             	pushl  0x8(%ebp)
c01006c6:	6a 24                	push   $0x24
c01006c8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006cb:	50                   	push   %eax
c01006cc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006cf:	50                   	push   %eax
c01006d0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006d3:	e8 c4 fd ff ff       	call   c010049c <stab_binsearch>
c01006d8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006db:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006e1:	39 c2                	cmp    %eax,%edx
c01006e3:	7f 7c                	jg     c0100761 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006e8:	89 c2                	mov    %eax,%edx
c01006ea:	89 d0                	mov    %edx,%eax
c01006ec:	01 c0                	add    %eax,%eax
c01006ee:	01 d0                	add    %edx,%eax
c01006f0:	c1 e0 02             	shl    $0x2,%eax
c01006f3:	89 c2                	mov    %eax,%edx
c01006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006f8:	01 d0                	add    %edx,%eax
c01006fa:	8b 00                	mov    (%eax),%eax
c01006fc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100702:	29 d1                	sub    %edx,%ecx
c0100704:	89 ca                	mov    %ecx,%edx
c0100706:	39 d0                	cmp    %edx,%eax
c0100708:	73 22                	jae    c010072c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010070d:	89 c2                	mov    %eax,%edx
c010070f:	89 d0                	mov    %edx,%eax
c0100711:	01 c0                	add    %eax,%eax
c0100713:	01 d0                	add    %edx,%eax
c0100715:	c1 e0 02             	shl    $0x2,%eax
c0100718:	89 c2                	mov    %eax,%edx
c010071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071d:	01 d0                	add    %edx,%eax
c010071f:	8b 10                	mov    (%eax),%edx
c0100721:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100724:	01 c2                	add    %eax,%edx
c0100726:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100729:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010072c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010072f:	89 c2                	mov    %eax,%edx
c0100731:	89 d0                	mov    %edx,%eax
c0100733:	01 c0                	add    %eax,%eax
c0100735:	01 d0                	add    %edx,%eax
c0100737:	c1 e0 02             	shl    $0x2,%eax
c010073a:	89 c2                	mov    %eax,%edx
c010073c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073f:	01 d0                	add    %edx,%eax
c0100741:	8b 50 08             	mov    0x8(%eax),%edx
c0100744:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100747:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	8b 40 10             	mov    0x10(%eax),%eax
c0100750:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100756:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100759:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010075c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010075f:	eb 15                	jmp    c0100776 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	8b 55 08             	mov    0x8(%ebp),%edx
c0100767:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010076a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100770:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100773:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100776:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100779:	8b 40 08             	mov    0x8(%eax),%eax
c010077c:	83 ec 08             	sub    $0x8,%esp
c010077f:	6a 3a                	push   $0x3a
c0100781:	50                   	push   %eax
c0100782:	e8 81 4c 00 00       	call   c0105408 <strfind>
c0100787:	83 c4 10             	add    $0x10,%esp
c010078a:	89 c2                	mov    %eax,%edx
c010078c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078f:	8b 40 08             	mov    0x8(%eax),%eax
c0100792:	29 c2                	sub    %eax,%edx
c0100794:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100797:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010079a:	83 ec 0c             	sub    $0xc,%esp
c010079d:	ff 75 08             	pushl  0x8(%ebp)
c01007a0:	6a 44                	push   $0x44
c01007a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007a5:	50                   	push   %eax
c01007a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007a9:	50                   	push   %eax
c01007aa:	ff 75 f4             	pushl  -0xc(%ebp)
c01007ad:	e8 ea fc ff ff       	call   c010049c <stab_binsearch>
c01007b2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007bb:	39 c2                	cmp    %eax,%edx
c01007bd:	7f 24                	jg     c01007e3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007c2:	89 c2                	mov    %eax,%edx
c01007c4:	89 d0                	mov    %edx,%eax
c01007c6:	01 c0                	add    %eax,%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	c1 e0 02             	shl    $0x2,%eax
c01007cd:	89 c2                	mov    %eax,%edx
c01007cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d2:	01 d0                	add    %edx,%eax
c01007d4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007d8:	0f b7 d0             	movzwl %ax,%edx
c01007db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007de:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e1:	eb 13                	jmp    c01007f6 <debuginfo_eip+0x203>
        return -1;
c01007e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007e8:	e9 12 01 00 00       	jmp    c01008ff <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f0:	83 e8 01             	sub    $0x1,%eax
c01007f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c01007f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	7c 56                	jl     c0100856 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100819:	3c 84                	cmp    $0x84,%al
c010081b:	74 39                	je     c0100856 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100820:	89 c2                	mov    %eax,%edx
c0100822:	89 d0                	mov    %edx,%eax
c0100824:	01 c0                	add    %eax,%eax
c0100826:	01 d0                	add    %edx,%eax
c0100828:	c1 e0 02             	shl    $0x2,%eax
c010082b:	89 c2                	mov    %eax,%edx
c010082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100830:	01 d0                	add    %edx,%eax
c0100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100836:	3c 64                	cmp    $0x64,%al
c0100838:	75 b3                	jne    c01007ed <debuginfo_eip+0x1fa>
c010083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083d:	89 c2                	mov    %eax,%edx
c010083f:	89 d0                	mov    %edx,%eax
c0100841:	01 c0                	add    %eax,%eax
c0100843:	01 d0                	add    %edx,%eax
c0100845:	c1 e0 02             	shl    $0x2,%eax
c0100848:	89 c2                	mov    %eax,%edx
c010084a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010084d:	01 d0                	add    %edx,%eax
c010084f:	8b 40 08             	mov    0x8(%eax),%eax
c0100852:	85 c0                	test   %eax,%eax
c0100854:	74 97                	je     c01007ed <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100856:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010085c:	39 c2                	cmp    %eax,%edx
c010085e:	7c 46                	jl     c01008a6 <debuginfo_eip+0x2b3>
c0100860:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100863:	89 c2                	mov    %eax,%edx
c0100865:	89 d0                	mov    %edx,%eax
c0100867:	01 c0                	add    %eax,%eax
c0100869:	01 d0                	add    %edx,%eax
c010086b:	c1 e0 02             	shl    $0x2,%eax
c010086e:	89 c2                	mov    %eax,%edx
c0100870:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100873:	01 d0                	add    %edx,%eax
c0100875:	8b 00                	mov    (%eax),%eax
c0100877:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010087a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010087d:	29 d1                	sub    %edx,%ecx
c010087f:	89 ca                	mov    %ecx,%edx
c0100881:	39 d0                	cmp    %edx,%eax
c0100883:	73 21                	jae    c01008a6 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100888:	89 c2                	mov    %eax,%edx
c010088a:	89 d0                	mov    %edx,%eax
c010088c:	01 c0                	add    %eax,%eax
c010088e:	01 d0                	add    %edx,%eax
c0100890:	c1 e0 02             	shl    $0x2,%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	8b 10                	mov    (%eax),%edx
c010089c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010089f:	01 c2                	add    %eax,%edx
c01008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008a4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008ac:	39 c2                	cmp    %eax,%edx
c01008ae:	7d 4a                	jge    c01008fa <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008b3:	83 c0 01             	add    $0x1,%eax
c01008b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008b9:	eb 18                	jmp    c01008d3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008be:	8b 40 14             	mov    0x14(%eax),%eax
c01008c1:	8d 50 01             	lea    0x1(%eax),%edx
c01008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008c7:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01008ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008cd:	83 c0 01             	add    $0x1,%eax
c01008d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c01008d9:	39 c2                	cmp    %eax,%edx
c01008db:	7d 1d                	jge    c01008fa <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e0:	89 c2                	mov    %eax,%edx
c01008e2:	89 d0                	mov    %edx,%eax
c01008e4:	01 c0                	add    %eax,%eax
c01008e6:	01 d0                	add    %edx,%eax
c01008e8:	c1 e0 02             	shl    $0x2,%eax
c01008eb:	89 c2                	mov    %eax,%edx
c01008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f0:	01 d0                	add    %edx,%eax
c01008f2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008f6:	3c a0                	cmp    $0xa0,%al
c01008f8:	74 c1                	je     c01008bb <debuginfo_eip+0x2c8>
        }
    }
    return 0;
c01008fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ff:	c9                   	leave  
c0100900:	c3                   	ret    

c0100901 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100901:	55                   	push   %ebp
c0100902:	89 e5                	mov    %esp,%ebp
c0100904:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100907:	83 ec 0c             	sub    $0xc,%esp
c010090a:	68 32 5e 10 c0       	push   $0xc0105e32
c010090f:	e8 63 f9 ff ff       	call   c0100277 <cprintf>
c0100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100917:	83 ec 08             	sub    $0x8,%esp
c010091a:	68 2a 00 10 c0       	push   $0xc010002a
c010091f:	68 4b 5e 10 c0       	push   $0xc0105e4b
c0100924:	e8 4e f9 ff ff       	call   c0100277 <cprintf>
c0100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010092c:	83 ec 08             	sub    $0x8,%esp
c010092f:	68 2b 5d 10 c0       	push   $0xc0105d2b
c0100934:	68 63 5e 10 c0       	push   $0xc0105e63
c0100939:	e8 39 f9 ff ff       	call   c0100277 <cprintf>
c010093e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100941:	83 ec 08             	sub    $0x8,%esp
c0100944:	68 36 8a 11 c0       	push   $0xc0118a36
c0100949:	68 7b 5e 10 c0       	push   $0xc0105e7b
c010094e:	e8 24 f9 ff ff       	call   c0100277 <cprintf>
c0100953:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100956:	83 ec 08             	sub    $0x8,%esp
c0100959:	68 68 99 11 c0       	push   $0xc0119968
c010095e:	68 93 5e 10 c0       	push   $0xc0105e93
c0100963:	e8 0f f9 ff ff       	call   c0100277 <cprintf>
c0100968:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010096b:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
c0100970:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100975:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010097a:	29 d0                	sub    %edx,%eax
c010097c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100982:	85 c0                	test   %eax,%eax
c0100984:	0f 48 c2             	cmovs  %edx,%eax
c0100987:	c1 f8 0a             	sar    $0xa,%eax
c010098a:	83 ec 08             	sub    $0x8,%esp
c010098d:	50                   	push   %eax
c010098e:	68 ac 5e 10 c0       	push   $0xc0105eac
c0100993:	e8 df f8 ff ff       	call   c0100277 <cprintf>
c0100998:	83 c4 10             	add    $0x10,%esp
}
c010099b:	90                   	nop
c010099c:	c9                   	leave  
c010099d:	c3                   	ret    

c010099e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010099e:	55                   	push   %ebp
c010099f:	89 e5                	mov    %esp,%ebp
c01009a1:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009a7:	83 ec 08             	sub    $0x8,%esp
c01009aa:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009ad:	50                   	push   %eax
c01009ae:	ff 75 08             	pushl  0x8(%ebp)
c01009b1:	e8 3d fc ff ff       	call   c01005f3 <debuginfo_eip>
c01009b6:	83 c4 10             	add    $0x10,%esp
c01009b9:	85 c0                	test   %eax,%eax
c01009bb:	74 15                	je     c01009d2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009bd:	83 ec 08             	sub    $0x8,%esp
c01009c0:	ff 75 08             	pushl  0x8(%ebp)
c01009c3:	68 d6 5e 10 c0       	push   $0xc0105ed6
c01009c8:	e8 aa f8 ff ff       	call   c0100277 <cprintf>
c01009cd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009d0:	eb 65                	jmp    c0100a37 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009d9:	eb 1c                	jmp    c01009f7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e1:	01 d0                	add    %edx,%eax
c01009e3:	0f b6 00             	movzbl (%eax),%eax
c01009e6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009ef:	01 ca                	add    %ecx,%edx
c01009f1:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01009fd:	7c dc                	jl     c01009db <print_debuginfo+0x3d>
        fnname[j] = '\0';
c01009ff:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a08:	01 d0                	add    %edx,%eax
c0100a0a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a10:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a13:	89 d1                	mov    %edx,%ecx
c0100a15:	29 c1                	sub    %eax,%ecx
c0100a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a1d:	83 ec 0c             	sub    $0xc,%esp
c0100a20:	51                   	push   %ecx
c0100a21:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a27:	51                   	push   %ecx
c0100a28:	52                   	push   %edx
c0100a29:	50                   	push   %eax
c0100a2a:	68 f2 5e 10 c0       	push   $0xc0105ef2
c0100a2f:	e8 43 f8 ff ff       	call   c0100277 <cprintf>
c0100a34:	83 c4 20             	add    $0x20,%esp
}
c0100a37:	90                   	nop
c0100a38:	c9                   	leave  
c0100a39:	c3                   	ret    

c0100a3a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a3a:	55                   	push   %ebp
c0100a3b:	89 e5                	mov    %esp,%ebp
c0100a3d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a40:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a49:	c9                   	leave  
c0100a4a:	c3                   	ret    

c0100a4b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a4b:	55                   	push   %ebp
c0100a4c:	89 e5                	mov    %esp,%ebp
c0100a4e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a51:	89 e8                	mov    %ebp,%eax
c0100a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c0100a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c0100a5c:	e8 d9 ff ff ff       	call   c0100a3a <read_eip>
c0100a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a6b:	e9 9d 00 00 00       	jmp    c0100b0d <print_stackframe+0xc2>
		cprintf("ebp:0x%08x eip:0x%08x", ebp, eip);
c0100a70:	83 ec 04             	sub    $0x4,%esp
c0100a73:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a76:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a79:	68 04 5f 10 c0       	push   $0xc0105f04
c0100a7e:	e8 f4 f7 ff ff       	call   c0100277 <cprintf>
c0100a83:	83 c4 10             	add    $0x10,%esp
		uint32_t *arg = (uint32_t *)ebp + 2;
c0100a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a89:	83 c0 08             	add    $0x8,%eax
c0100a8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		cprintf(" arg:");
c0100a8f:	83 ec 0c             	sub    $0xc,%esp
c0100a92:	68 1a 5f 10 c0       	push   $0xc0105f1a
c0100a97:	e8 db f7 ff ff       	call   c0100277 <cprintf>
c0100a9c:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 4; j++) {
c0100a9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100aa6:	eb 26                	jmp    c0100ace <print_stackframe+0x83>
			cprintf("0x%08x ", arg[j]);
c0100aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ab5:	01 d0                	add    %edx,%eax
c0100ab7:	8b 00                	mov    (%eax),%eax
c0100ab9:	83 ec 08             	sub    $0x8,%esp
c0100abc:	50                   	push   %eax
c0100abd:	68 20 5f 10 c0       	push   $0xc0105f20
c0100ac2:	e8 b0 f7 ff ff       	call   c0100277 <cprintf>
c0100ac7:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 4; j++) {
c0100aca:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100ace:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ad2:	7e d4                	jle    c0100aa8 <print_stackframe+0x5d>
		}
		cprintf("\n");
c0100ad4:	83 ec 0c             	sub    $0xc,%esp
c0100ad7:	68 28 5f 10 c0       	push   $0xc0105f28
c0100adc:	e8 96 f7 ff ff       	call   c0100277 <cprintf>
c0100ae1:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(eip - 1);
c0100ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ae7:	83 e8 01             	sub    $0x1,%eax
c0100aea:	83 ec 0c             	sub    $0xc,%esp
c0100aed:	50                   	push   %eax
c0100aee:	e8 ab fe ff ff       	call   c010099e <print_debuginfo>
c0100af3:	83 c4 10             	add    $0x10,%esp
		eip = ((uint32_t *)ebp)[1];
c0100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af9:	83 c0 04             	add    $0x4,%eax
c0100afc:	8b 00                	mov    (%eax),%eax
c0100afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t*)ebp)[0];
c0100b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b04:	8b 00                	mov    (%eax),%eax
c0100b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100b09:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b0d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b11:	7f 0a                	jg     c0100b1d <print_stackframe+0xd2>
c0100b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b17:	0f 85 53 ff ff ff    	jne    c0100a70 <print_stackframe+0x25>
	}
}
c0100b1d:	90                   	nop
c0100b1e:	c9                   	leave  
c0100b1f:	c3                   	ret    

c0100b20 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b20:	55                   	push   %ebp
c0100b21:	89 e5                	mov    %esp,%ebp
c0100b23:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2d:	eb 0c                	jmp    c0100b3b <parse+0x1b>
            *buf ++ = '\0';
c0100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b32:	8d 50 01             	lea    0x1(%eax),%edx
c0100b35:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b38:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3e:	0f b6 00             	movzbl (%eax),%eax
c0100b41:	84 c0                	test   %al,%al
c0100b43:	74 1e                	je     c0100b63 <parse+0x43>
c0100b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b48:	0f b6 00             	movzbl (%eax),%eax
c0100b4b:	0f be c0             	movsbl %al,%eax
c0100b4e:	83 ec 08             	sub    $0x8,%esp
c0100b51:	50                   	push   %eax
c0100b52:	68 ac 5f 10 c0       	push   $0xc0105fac
c0100b57:	e8 79 48 00 00       	call   c01053d5 <strchr>
c0100b5c:	83 c4 10             	add    $0x10,%esp
c0100b5f:	85 c0                	test   %eax,%eax
c0100b61:	75 cc                	jne    c0100b2f <parse+0xf>
        }
        if (*buf == '\0') {
c0100b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b66:	0f b6 00             	movzbl (%eax),%eax
c0100b69:	84 c0                	test   %al,%al
c0100b6b:	74 65                	je     c0100bd2 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b6d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b71:	75 12                	jne    c0100b85 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b73:	83 ec 08             	sub    $0x8,%esp
c0100b76:	6a 10                	push   $0x10
c0100b78:	68 b1 5f 10 c0       	push   $0xc0105fb1
c0100b7d:	e8 f5 f6 ff ff       	call   c0100277 <cprintf>
c0100b82:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b88:	8d 50 01             	lea    0x1(%eax),%edx
c0100b8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b98:	01 c2                	add    %eax,%edx
c0100b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b9f:	eb 04                	jmp    c0100ba5 <parse+0x85>
            buf ++;
c0100ba1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba8:	0f b6 00             	movzbl (%eax),%eax
c0100bab:	84 c0                	test   %al,%al
c0100bad:	74 8c                	je     c0100b3b <parse+0x1b>
c0100baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb2:	0f b6 00             	movzbl (%eax),%eax
c0100bb5:	0f be c0             	movsbl %al,%eax
c0100bb8:	83 ec 08             	sub    $0x8,%esp
c0100bbb:	50                   	push   %eax
c0100bbc:	68 ac 5f 10 c0       	push   $0xc0105fac
c0100bc1:	e8 0f 48 00 00       	call   c01053d5 <strchr>
c0100bc6:	83 c4 10             	add    $0x10,%esp
c0100bc9:	85 c0                	test   %eax,%eax
c0100bcb:	74 d4                	je     c0100ba1 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bcd:	e9 69 ff ff ff       	jmp    c0100b3b <parse+0x1b>
            break;
c0100bd2:	90                   	nop
        }
    }
    return argc;
c0100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bd6:	c9                   	leave  
c0100bd7:	c3                   	ret    

c0100bd8 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bd8:	55                   	push   %ebp
c0100bd9:	89 e5                	mov    %esp,%ebp
c0100bdb:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bde:	83 ec 08             	sub    $0x8,%esp
c0100be1:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100be4:	50                   	push   %eax
c0100be5:	ff 75 08             	pushl  0x8(%ebp)
c0100be8:	e8 33 ff ff ff       	call   c0100b20 <parse>
c0100bed:	83 c4 10             	add    $0x10,%esp
c0100bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bf7:	75 0a                	jne    c0100c03 <runcmd+0x2b>
        return 0;
c0100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bfe:	e9 83 00 00 00       	jmp    c0100c86 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c0a:	eb 59                	jmp    c0100c65 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c0c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c12:	89 d0                	mov    %edx,%eax
c0100c14:	01 c0                	add    %eax,%eax
c0100c16:	01 d0                	add    %edx,%eax
c0100c18:	c1 e0 02             	shl    $0x2,%eax
c0100c1b:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100c20:	8b 00                	mov    (%eax),%eax
c0100c22:	83 ec 08             	sub    $0x8,%esp
c0100c25:	51                   	push   %ecx
c0100c26:	50                   	push   %eax
c0100c27:	e8 09 47 00 00       	call   c0105335 <strcmp>
c0100c2c:	83 c4 10             	add    $0x10,%esp
c0100c2f:	85 c0                	test   %eax,%eax
c0100c31:	75 2e                	jne    c0100c61 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c36:	89 d0                	mov    %edx,%eax
c0100c38:	01 c0                	add    %eax,%eax
c0100c3a:	01 d0                	add    %edx,%eax
c0100c3c:	c1 e0 02             	shl    $0x2,%eax
c0100c3f:	05 28 80 11 c0       	add    $0xc0118028,%eax
c0100c44:	8b 10                	mov    (%eax),%edx
c0100c46:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c49:	83 c0 04             	add    $0x4,%eax
c0100c4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c4f:	83 e9 01             	sub    $0x1,%ecx
c0100c52:	83 ec 04             	sub    $0x4,%esp
c0100c55:	ff 75 0c             	pushl  0xc(%ebp)
c0100c58:	50                   	push   %eax
c0100c59:	51                   	push   %ecx
c0100c5a:	ff d2                	call   *%edx
c0100c5c:	83 c4 10             	add    $0x10,%esp
c0100c5f:	eb 25                	jmp    c0100c86 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c61:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c68:	83 f8 02             	cmp    $0x2,%eax
c0100c6b:	76 9f                	jbe    c0100c0c <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c70:	83 ec 08             	sub    $0x8,%esp
c0100c73:	50                   	push   %eax
c0100c74:	68 cf 5f 10 c0       	push   $0xc0105fcf
c0100c79:	e8 f9 f5 ff ff       	call   c0100277 <cprintf>
c0100c7e:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c86:	c9                   	leave  
c0100c87:	c3                   	ret    

c0100c88 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c88:	55                   	push   %ebp
c0100c89:	89 e5                	mov    %esp,%ebp
c0100c8b:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c8e:	83 ec 0c             	sub    $0xc,%esp
c0100c91:	68 e8 5f 10 c0       	push   $0xc0105fe8
c0100c96:	e8 dc f5 ff ff       	call   c0100277 <cprintf>
c0100c9b:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c9e:	83 ec 0c             	sub    $0xc,%esp
c0100ca1:	68 10 60 10 c0       	push   $0xc0106010
c0100ca6:	e8 cc f5 ff ff       	call   c0100277 <cprintf>
c0100cab:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cb2:	74 0e                	je     c0100cc2 <kmonitor+0x3a>
        print_trapframe(tf);
c0100cb4:	83 ec 0c             	sub    $0xc,%esp
c0100cb7:	ff 75 08             	pushl  0x8(%ebp)
c0100cba:	e8 3f 0e 00 00       	call   c0101afe <print_trapframe>
c0100cbf:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cc2:	83 ec 0c             	sub    $0xc,%esp
c0100cc5:	68 35 60 10 c0       	push   $0xc0106035
c0100cca:	e8 4c f6 ff ff       	call   c010031b <readline>
c0100ccf:	83 c4 10             	add    $0x10,%esp
c0100cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cd9:	74 e7                	je     c0100cc2 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cdb:	83 ec 08             	sub    $0x8,%esp
c0100cde:	ff 75 08             	pushl  0x8(%ebp)
c0100ce1:	ff 75 f4             	pushl  -0xc(%ebp)
c0100ce4:	e8 ef fe ff ff       	call   c0100bd8 <runcmd>
c0100ce9:	83 c4 10             	add    $0x10,%esp
c0100cec:	85 c0                	test   %eax,%eax
c0100cee:	78 02                	js     c0100cf2 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100cf0:	eb d0                	jmp    c0100cc2 <kmonitor+0x3a>
                break;
c0100cf2:	90                   	nop
            }
        }
    }
}
c0100cf3:	90                   	nop
c0100cf4:	c9                   	leave  
c0100cf5:	c3                   	ret    

c0100cf6 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cf6:	55                   	push   %ebp
c0100cf7:	89 e5                	mov    %esp,%ebp
c0100cf9:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d03:	eb 3c                	jmp    c0100d41 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d08:	89 d0                	mov    %edx,%eax
c0100d0a:	01 c0                	add    %eax,%eax
c0100d0c:	01 d0                	add    %edx,%eax
c0100d0e:	c1 e0 02             	shl    $0x2,%eax
c0100d11:	05 24 80 11 c0       	add    $0xc0118024,%eax
c0100d16:	8b 08                	mov    (%eax),%ecx
c0100d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d1b:	89 d0                	mov    %edx,%eax
c0100d1d:	01 c0                	add    %eax,%eax
c0100d1f:	01 d0                	add    %edx,%eax
c0100d21:	c1 e0 02             	shl    $0x2,%eax
c0100d24:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100d29:	8b 00                	mov    (%eax),%eax
c0100d2b:	83 ec 04             	sub    $0x4,%esp
c0100d2e:	51                   	push   %ecx
c0100d2f:	50                   	push   %eax
c0100d30:	68 39 60 10 c0       	push   $0xc0106039
c0100d35:	e8 3d f5 ff ff       	call   c0100277 <cprintf>
c0100d3a:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d44:	83 f8 02             	cmp    $0x2,%eax
c0100d47:	76 bc                	jbe    c0100d05 <mon_help+0xf>
    }
    return 0;
c0100d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d4e:	c9                   	leave  
c0100d4f:	c3                   	ret    

c0100d50 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d50:	55                   	push   %ebp
c0100d51:	89 e5                	mov    %esp,%ebp
c0100d53:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d56:	e8 a6 fb ff ff       	call   c0100901 <print_kerninfo>
    return 0;
c0100d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d60:	c9                   	leave  
c0100d61:	c3                   	ret    

c0100d62 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d62:	55                   	push   %ebp
c0100d63:	89 e5                	mov    %esp,%ebp
c0100d65:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d68:	e8 de fc ff ff       	call   c0100a4b <print_stackframe>
    return 0;
c0100d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d72:	c9                   	leave  
c0100d73:	c3                   	ret    

c0100d74 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d74:	55                   	push   %ebp
c0100d75:	89 e5                	mov    %esp,%ebp
c0100d77:	83 ec 18             	sub    $0x18,%esp
c0100d7a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d80:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d8c:	ee                   	out    %al,(%dx)
c0100d8d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d93:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d97:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d9b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d9f:	ee                   	out    %al,(%dx)
c0100da0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100da6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100daa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dae:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100db3:	c7 05 4c 99 11 c0 00 	movl   $0x0,0xc011994c
c0100dba:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dbd:	83 ec 0c             	sub    $0xc,%esp
c0100dc0:	68 42 60 10 c0       	push   $0xc0106042
c0100dc5:	e8 ad f4 ff ff       	call   c0100277 <cprintf>
c0100dca:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dcd:	83 ec 0c             	sub    $0xc,%esp
c0100dd0:	6a 00                	push   $0x0
c0100dd2:	e8 3f 09 00 00       	call   c0101716 <pic_enable>
c0100dd7:	83 c4 10             	add    $0x10,%esp
}
c0100dda:	90                   	nop
c0100ddb:	c9                   	leave  
c0100ddc:	c3                   	ret    

c0100ddd <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100ddd:	55                   	push   %ebp
c0100dde:	89 e5                	mov    %esp,%ebp
c0100de0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de3:	9c                   	pushf  
c0100de4:	58                   	pop    %eax
c0100de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100deb:	25 00 02 00 00       	and    $0x200,%eax
c0100df0:	85 c0                	test   %eax,%eax
c0100df2:	74 0c                	je     c0100e00 <__intr_save+0x23>
        intr_disable();
c0100df4:	e8 8e 0a 00 00       	call   c0101887 <intr_disable>
        return 1;
c0100df9:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dfe:	eb 05                	jmp    c0100e05 <__intr_save+0x28>
    }
    return 0;
c0100e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e05:	c9                   	leave  
c0100e06:	c3                   	ret    

c0100e07 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e07:	55                   	push   %ebp
c0100e08:	89 e5                	mov    %esp,%ebp
c0100e0a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e11:	74 05                	je     c0100e18 <__intr_restore+0x11>
        intr_enable();
c0100e13:	e8 68 0a 00 00       	call   c0101880 <intr_enable>
    }
}
c0100e18:	90                   	nop
c0100e19:	c9                   	leave  
c0100e1a:	c3                   	ret    

c0100e1b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e1b:	55                   	push   %ebp
c0100e1c:	89 e5                	mov    %esp,%ebp
c0100e1e:	83 ec 10             	sub    $0x10,%esp
c0100e21:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e27:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e2b:	89 c2                	mov    %eax,%edx
c0100e2d:	ec                   	in     (%dx),%al
c0100e2e:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e31:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e37:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3b:	89 c2                	mov    %eax,%edx
c0100e3d:	ec                   	in     (%dx),%al
c0100e3e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4b:	89 c2                	mov    %eax,%edx
c0100e4d:	ec                   	in     (%dx),%al
c0100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e51:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e57:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5b:	89 c2                	mov    %eax,%edx
c0100e5d:	ec                   	in     (%dx),%al
c0100e5e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e61:	90                   	nop
c0100e62:	c9                   	leave  
c0100e63:	c3                   	ret    

c0100e64 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6a:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e74:	0f b7 00             	movzwl (%eax),%eax
c0100e77:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e86:	0f b7 00             	movzwl (%eax),%eax
c0100e89:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e8d:	74 12                	je     c0100ea1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e8f:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e96:	66 c7 05 86 8e 11 c0 	movw   $0x3b4,0xc0118e86
c0100e9d:	b4 03 
c0100e9f:	eb 13                	jmp    c0100eb4 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eab:	66 c7 05 86 8e 11 c0 	movw   $0x3d4,0xc0118e86
c0100eb2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb4:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100ebb:	0f b7 c0             	movzwl %ax,%eax
c0100ebe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ec2:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100eca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ece:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ecf:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100ed6:	83 c0 01             	add    $0x1,%eax
c0100ed9:	0f b7 c0             	movzwl %ax,%eax
c0100edc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ee4:	89 c2                	mov    %eax,%edx
c0100ee6:	ec                   	in     (%dx),%al
c0100ee7:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100eea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100eee:	0f b6 c0             	movzbl %al,%eax
c0100ef1:	c1 e0 08             	shl    $0x8,%eax
c0100ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ef7:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100efe:	0f b7 c0             	movzwl %ax,%eax
c0100f01:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f05:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f11:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f12:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f19:	83 c0 01             	add    $0x1,%eax
c0100f1c:	0f b7 c0             	movzwl %ax,%eax
c0100f1f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f23:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f27:	89 c2                	mov    %eax,%edx
c0100f29:	ec                   	in     (%dx),%al
c0100f2a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f2d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f31:	0f b6 c0             	movzbl %al,%eax
c0100f34:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3a:	a3 80 8e 11 c0       	mov    %eax,0xc0118e80
    crt_pos = pos;
c0100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f42:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
}
c0100f48:	90                   	nop
c0100f49:	c9                   	leave  
c0100f4a:	c3                   	ret    

c0100f4b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4b:	55                   	push   %ebp
c0100f4c:	89 e5                	mov    %esp,%ebp
c0100f4e:	83 ec 38             	sub    $0x38,%esp
c0100f51:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f57:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f5f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f63:	ee                   	out    %al,(%dx)
c0100f64:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f6a:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f6e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f72:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f76:	ee                   	out    %al,(%dx)
c0100f77:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f7d:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f81:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f85:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f89:	ee                   	out    %al,(%dx)
c0100f8a:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f90:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f94:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f98:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f9c:	ee                   	out    %al,(%dx)
c0100f9d:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fa3:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fa7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fab:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100faf:	ee                   	out    %al,(%dx)
c0100fb0:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fb6:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fba:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbe:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc2:	ee                   	out    %al,(%dx)
c0100fc3:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc9:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fcd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fd1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fd5:	ee                   	out    %al,(%dx)
c0100fd6:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fdc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fe0:	89 c2                	mov    %eax,%edx
c0100fe2:	ec                   	in     (%dx),%al
c0100fe3:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fe6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fea:	3c ff                	cmp    $0xff,%al
c0100fec:	0f 95 c0             	setne  %al
c0100fef:	0f b6 c0             	movzbl %al,%eax
c0100ff2:	a3 88 8e 11 c0       	mov    %eax,0xc0118e88
c0100ff7:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101001:	89 c2                	mov    %eax,%edx
c0101003:	ec                   	in     (%dx),%al
c0101004:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101007:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010100d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101011:	89 c2                	mov    %eax,%edx
c0101013:	ec                   	in     (%dx),%al
c0101014:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101017:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c010101c:	85 c0                	test   %eax,%eax
c010101e:	74 0d                	je     c010102d <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101020:	83 ec 0c             	sub    $0xc,%esp
c0101023:	6a 04                	push   $0x4
c0101025:	e8 ec 06 00 00       	call   c0101716 <pic_enable>
c010102a:	83 c4 10             	add    $0x10,%esp
    }
}
c010102d:	90                   	nop
c010102e:	c9                   	leave  
c010102f:	c3                   	ret    

c0101030 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101030:	55                   	push   %ebp
c0101031:	89 e5                	mov    %esp,%ebp
c0101033:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010103d:	eb 09                	jmp    c0101048 <lpt_putc_sub+0x18>
        delay();
c010103f:	e8 d7 fd ff ff       	call   c0100e1b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101044:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101048:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101052:	89 c2                	mov    %eax,%edx
c0101054:	ec                   	in     (%dx),%al
c0101055:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101058:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105c:	84 c0                	test   %al,%al
c010105e:	78 09                	js     c0101069 <lpt_putc_sub+0x39>
c0101060:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101067:	7e d6                	jle    c010103f <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101069:	8b 45 08             	mov    0x8(%ebp),%eax
c010106c:	0f b6 c0             	movzbl %al,%eax
c010106f:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101075:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101078:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010107c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101080:	ee                   	out    %al,(%dx)
c0101081:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101087:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010108f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101093:	ee                   	out    %al,(%dx)
c0101094:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010109a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c010109e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a7:	90                   	nop
c01010a8:	c9                   	leave  
c01010a9:	c3                   	ret    

c01010aa <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010aa:	55                   	push   %ebp
c01010ab:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010ad:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b1:	74 0d                	je     c01010c0 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010b3:	ff 75 08             	pushl  0x8(%ebp)
c01010b6:	e8 75 ff ff ff       	call   c0101030 <lpt_putc_sub>
c01010bb:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010be:	eb 1e                	jmp    c01010de <lpt_putc+0x34>
        lpt_putc_sub('\b');
c01010c0:	6a 08                	push   $0x8
c01010c2:	e8 69 ff ff ff       	call   c0101030 <lpt_putc_sub>
c01010c7:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010ca:	6a 20                	push   $0x20
c01010cc:	e8 5f ff ff ff       	call   c0101030 <lpt_putc_sub>
c01010d1:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010d4:	6a 08                	push   $0x8
c01010d6:	e8 55 ff ff ff       	call   c0101030 <lpt_putc_sub>
c01010db:	83 c4 04             	add    $0x4,%esp
}
c01010de:	90                   	nop
c01010df:	c9                   	leave  
c01010e0:	c3                   	ret    

c01010e1 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e1:	55                   	push   %ebp
c01010e2:	89 e5                	mov    %esp,%ebp
c01010e4:	53                   	push   %ebx
c01010e5:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010eb:	b0 00                	mov    $0x0,%al
c01010ed:	85 c0                	test   %eax,%eax
c01010ef:	75 07                	jne    c01010f8 <cga_putc+0x17>
        c |= 0x0700;
c01010f1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fb:	0f b6 c0             	movzbl %al,%eax
c01010fe:	83 f8 0a             	cmp    $0xa,%eax
c0101101:	74 52                	je     c0101155 <cga_putc+0x74>
c0101103:	83 f8 0d             	cmp    $0xd,%eax
c0101106:	74 5d                	je     c0101165 <cga_putc+0x84>
c0101108:	83 f8 08             	cmp    $0x8,%eax
c010110b:	0f 85 8e 00 00 00    	jne    c010119f <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101111:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101118:	66 85 c0             	test   %ax,%ax
c010111b:	0f 84 a4 00 00 00    	je     c01011c5 <cga_putc+0xe4>
            crt_pos --;
c0101121:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101128:	83 e8 01             	sub    $0x1,%eax
c010112b:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101131:	8b 45 08             	mov    0x8(%ebp),%eax
c0101134:	b0 00                	mov    $0x0,%al
c0101136:	83 c8 20             	or     $0x20,%eax
c0101139:	89 c1                	mov    %eax,%ecx
c010113b:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101140:	0f b7 15 84 8e 11 c0 	movzwl 0xc0118e84,%edx
c0101147:	0f b7 d2             	movzwl %dx,%edx
c010114a:	01 d2                	add    %edx,%edx
c010114c:	01 d0                	add    %edx,%eax
c010114e:	89 ca                	mov    %ecx,%edx
c0101150:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101153:	eb 70                	jmp    c01011c5 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
c0101155:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010115c:	83 c0 50             	add    $0x50,%eax
c010115f:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101165:	0f b7 1d 84 8e 11 c0 	movzwl 0xc0118e84,%ebx
c010116c:	0f b7 0d 84 8e 11 c0 	movzwl 0xc0118e84,%ecx
c0101173:	0f b7 c1             	movzwl %cx,%eax
c0101176:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010117c:	c1 e8 10             	shr    $0x10,%eax
c010117f:	89 c2                	mov    %eax,%edx
c0101181:	66 c1 ea 06          	shr    $0x6,%dx
c0101185:	89 d0                	mov    %edx,%eax
c0101187:	c1 e0 02             	shl    $0x2,%eax
c010118a:	01 d0                	add    %edx,%eax
c010118c:	c1 e0 04             	shl    $0x4,%eax
c010118f:	29 c1                	sub    %eax,%ecx
c0101191:	89 ca                	mov    %ecx,%edx
c0101193:	89 d8                	mov    %ebx,%eax
c0101195:	29 d0                	sub    %edx,%eax
c0101197:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
        break;
c010119d:	eb 27                	jmp    c01011c6 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010119f:	8b 0d 80 8e 11 c0    	mov    0xc0118e80,%ecx
c01011a5:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01011ac:	8d 50 01             	lea    0x1(%eax),%edx
c01011af:	66 89 15 84 8e 11 c0 	mov    %dx,0xc0118e84
c01011b6:	0f b7 c0             	movzwl %ax,%eax
c01011b9:	01 c0                	add    %eax,%eax
c01011bb:	01 c8                	add    %ecx,%eax
c01011bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01011c0:	66 89 10             	mov    %dx,(%eax)
        break;
c01011c3:	eb 01                	jmp    c01011c6 <cga_putc+0xe5>
        break;
c01011c5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c6:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01011cd:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d1:	76 59                	jbe    c010122c <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d3:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c01011d8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011de:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c01011e3:	83 ec 04             	sub    $0x4,%esp
c01011e6:	68 00 0f 00 00       	push   $0xf00
c01011eb:	52                   	push   %edx
c01011ec:	50                   	push   %eax
c01011ed:	e8 e2 43 00 00       	call   c01055d4 <memmove>
c01011f2:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011fc:	eb 15                	jmp    c0101213 <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
c01011fe:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101203:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101206:	01 d2                	add    %edx,%edx
c0101208:	01 d0                	add    %edx,%eax
c010120a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101213:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121a:	7e e2                	jle    c01011fe <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
c010121c:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101223:	83 e8 50             	sub    $0x50,%eax
c0101226:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010122c:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0101233:	0f b7 c0             	movzwl %ax,%eax
c0101236:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010123a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010123e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101242:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101246:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101247:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010124e:	66 c1 e8 08          	shr    $0x8,%ax
c0101252:	0f b6 c0             	movzbl %al,%eax
c0101255:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c010125c:	83 c2 01             	add    $0x1,%edx
c010125f:	0f b7 d2             	movzwl %dx,%edx
c0101262:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101266:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101269:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010126d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101271:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101272:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0101279:	0f b7 c0             	movzwl %ax,%eax
c010127c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101280:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101284:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101288:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010128d:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101294:	0f b6 c0             	movzbl %al,%eax
c0101297:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c010129e:	83 c2 01             	add    $0x1,%edx
c01012a1:	0f b7 d2             	movzwl %dx,%edx
c01012a4:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012a8:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012ab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012af:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b3:	ee                   	out    %al,(%dx)
}
c01012b4:	90                   	nop
c01012b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012b8:	c9                   	leave  
c01012b9:	c3                   	ret    

c01012ba <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ba:	55                   	push   %ebp
c01012bb:	89 e5                	mov    %esp,%ebp
c01012bd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012c7:	eb 09                	jmp    c01012d2 <serial_putc_sub+0x18>
        delay();
c01012c9:	e8 4d fb ff ff       	call   c0100e1b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012d8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012dc:	89 c2                	mov    %eax,%edx
c01012de:	ec                   	in     (%dx),%al
c01012df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012e6:	0f b6 c0             	movzbl %al,%eax
c01012e9:	83 e0 20             	and    $0x20,%eax
c01012ec:	85 c0                	test   %eax,%eax
c01012ee:	75 09                	jne    c01012f9 <serial_putc_sub+0x3f>
c01012f0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012f7:	7e d0                	jle    c01012c9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c01012f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01012fc:	0f b6 c0             	movzbl %al,%eax
c01012ff:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101305:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101308:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010130c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101310:	ee                   	out    %al,(%dx)
}
c0101311:	90                   	nop
c0101312:	c9                   	leave  
c0101313:	c3                   	ret    

c0101314 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101314:	55                   	push   %ebp
c0101315:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101317:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010131b:	74 0d                	je     c010132a <serial_putc+0x16>
        serial_putc_sub(c);
c010131d:	ff 75 08             	pushl  0x8(%ebp)
c0101320:	e8 95 ff ff ff       	call   c01012ba <serial_putc_sub>
c0101325:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101328:	eb 1e                	jmp    c0101348 <serial_putc+0x34>
        serial_putc_sub('\b');
c010132a:	6a 08                	push   $0x8
c010132c:	e8 89 ff ff ff       	call   c01012ba <serial_putc_sub>
c0101331:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101334:	6a 20                	push   $0x20
c0101336:	e8 7f ff ff ff       	call   c01012ba <serial_putc_sub>
c010133b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010133e:	6a 08                	push   $0x8
c0101340:	e8 75 ff ff ff       	call   c01012ba <serial_putc_sub>
c0101345:	83 c4 04             	add    $0x4,%esp
}
c0101348:	90                   	nop
c0101349:	c9                   	leave  
c010134a:	c3                   	ret    

c010134b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010134b:	55                   	push   %ebp
c010134c:	89 e5                	mov    %esp,%ebp
c010134e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101351:	eb 33                	jmp    c0101386 <cons_intr+0x3b>
        if (c != 0) {
c0101353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101357:	74 2d                	je     c0101386 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101359:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c010135e:	8d 50 01             	lea    0x1(%eax),%edx
c0101361:	89 15 a4 90 11 c0    	mov    %edx,0xc01190a4
c0101367:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010136a:	88 90 a0 8e 11 c0    	mov    %dl,-0x3fee7160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101370:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c0101375:	3d 00 02 00 00       	cmp    $0x200,%eax
c010137a:	75 0a                	jne    c0101386 <cons_intr+0x3b>
                cons.wpos = 0;
c010137c:	c7 05 a4 90 11 c0 00 	movl   $0x0,0xc01190a4
c0101383:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101386:	8b 45 08             	mov    0x8(%ebp),%eax
c0101389:	ff d0                	call   *%eax
c010138b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010138e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101392:	75 bf                	jne    c0101353 <cons_intr+0x8>
            }
        }
    }
}
c0101394:	90                   	nop
c0101395:	c9                   	leave  
c0101396:	c3                   	ret    

c0101397 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101397:	55                   	push   %ebp
c0101398:	89 e5                	mov    %esp,%ebp
c010139a:	83 ec 10             	sub    $0x10,%esp
c010139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a7:	89 c2                	mov    %eax,%edx
c01013a9:	ec                   	in     (%dx),%al
c01013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013b1:	0f b6 c0             	movzbl %al,%eax
c01013b4:	83 e0 01             	and    $0x1,%eax
c01013b7:	85 c0                	test   %eax,%eax
c01013b9:	75 07                	jne    c01013c2 <serial_proc_data+0x2b>
        return -1;
c01013bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013c0:	eb 2a                	jmp    c01013ec <serial_proc_data+0x55>
c01013c2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013cc:	89 c2                	mov    %eax,%edx
c01013ce:	ec                   	in     (%dx),%al
c01013cf:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013d2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013d6:	0f b6 c0             	movzbl %al,%eax
c01013d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013dc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013e0:	75 07                	jne    c01013e9 <serial_proc_data+0x52>
        c = '\b';
c01013e2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013ec:	c9                   	leave  
c01013ed:	c3                   	ret    

c01013ee <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013ee:	55                   	push   %ebp
c01013ef:	89 e5                	mov    %esp,%ebp
c01013f1:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013f4:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c01013f9:	85 c0                	test   %eax,%eax
c01013fb:	74 10                	je     c010140d <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013fd:	83 ec 0c             	sub    $0xc,%esp
c0101400:	68 97 13 10 c0       	push   $0xc0101397
c0101405:	e8 41 ff ff ff       	call   c010134b <cons_intr>
c010140a:	83 c4 10             	add    $0x10,%esp
    }
}
c010140d:	90                   	nop
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 28             	sub    $0x28,%esp
c0101416:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101420:	89 c2                	mov    %eax,%edx
c0101422:	ec                   	in     (%dx),%al
c0101423:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101426:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010142a:	0f b6 c0             	movzbl %al,%eax
c010142d:	83 e0 01             	and    $0x1,%eax
c0101430:	85 c0                	test   %eax,%eax
c0101432:	75 0a                	jne    c010143e <kbd_proc_data+0x2e>
        return -1;
c0101434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101439:	e9 5d 01 00 00       	jmp    c010159b <kbd_proc_data+0x18b>
c010143e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101444:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101448:	89 c2                	mov    %eax,%edx
c010144a:	ec                   	in     (%dx),%al
c010144b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010144e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101452:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101455:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101459:	75 17                	jne    c0101472 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010145b:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101460:	83 c8 40             	or     $0x40,%eax
c0101463:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c0101468:	b8 00 00 00 00       	mov    $0x0,%eax
c010146d:	e9 29 01 00 00       	jmp    c010159b <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101476:	84 c0                	test   %al,%al
c0101478:	79 47                	jns    c01014c1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010147a:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010147f:	83 e0 40             	and    $0x40,%eax
c0101482:	85 c0                	test   %eax,%eax
c0101484:	75 09                	jne    c010148f <kbd_proc_data+0x7f>
c0101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148a:	83 e0 7f             	and    $0x7f,%eax
c010148d:	eb 04                	jmp    c0101493 <kbd_proc_data+0x83>
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149a:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c01014a1:	83 c8 40             	or     $0x40,%eax
c01014a4:	0f b6 c0             	movzbl %al,%eax
c01014a7:	f7 d0                	not    %eax
c01014a9:	89 c2                	mov    %eax,%edx
c01014ab:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01014b0:	21 d0                	and    %edx,%eax
c01014b2:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c01014b7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014bc:	e9 da 00 00 00       	jmp    c010159b <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014c1:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01014c6:	83 e0 40             	and    $0x40,%eax
c01014c9:	85 c0                	test   %eax,%eax
c01014cb:	74 11                	je     c01014de <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014cd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d1:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01014d6:	83 e0 bf             	and    $0xffffffbf,%eax
c01014d9:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    }

    shift |= shiftcode[data];
c01014de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e2:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c01014e9:	0f b6 d0             	movzbl %al,%edx
c01014ec:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01014f1:	09 d0                	or     %edx,%eax
c01014f3:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    shift ^= togglecode[data];
c01014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fc:	0f b6 80 60 81 11 c0 	movzbl -0x3fee7ea0(%eax),%eax
c0101503:	0f b6 d0             	movzbl %al,%edx
c0101506:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010150b:	31 d0                	xor    %edx,%eax
c010150d:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101512:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101517:	83 e0 03             	and    $0x3,%eax
c010151a:	8b 14 85 60 85 11 c0 	mov    -0x3fee7aa0(,%eax,4),%edx
c0101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101525:	01 d0                	add    %edx,%eax
c0101527:	0f b6 00             	movzbl (%eax),%eax
c010152a:	0f b6 c0             	movzbl %al,%eax
c010152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101530:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101535:	83 e0 08             	and    $0x8,%eax
c0101538:	85 c0                	test   %eax,%eax
c010153a:	74 22                	je     c010155e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010153c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101540:	7e 0c                	jle    c010154e <kbd_proc_data+0x13e>
c0101542:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101546:	7f 06                	jg     c010154e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101548:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010154c:	eb 10                	jmp    c010155e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010154e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101552:	7e 0a                	jle    c010155e <kbd_proc_data+0x14e>
c0101554:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101558:	7f 04                	jg     c010155e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010155a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010155e:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101563:	f7 d0                	not    %eax
c0101565:	83 e0 06             	and    $0x6,%eax
c0101568:	85 c0                	test   %eax,%eax
c010156a:	75 2c                	jne    c0101598 <kbd_proc_data+0x188>
c010156c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101573:	75 23                	jne    c0101598 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101575:	83 ec 0c             	sub    $0xc,%esp
c0101578:	68 5d 60 10 c0       	push   $0xc010605d
c010157d:	e8 f5 ec ff ff       	call   c0100277 <cprintf>
c0101582:	83 c4 10             	add    $0x10,%esp
c0101585:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010158f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101593:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101597:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159b:	c9                   	leave  
c010159c:	c3                   	ret    

c010159d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159d:	55                   	push   %ebp
c010159e:	89 e5                	mov    %esp,%ebp
c01015a0:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c01015a3:	83 ec 0c             	sub    $0xc,%esp
c01015a6:	68 10 14 10 c0       	push   $0xc0101410
c01015ab:	e8 9b fd ff ff       	call   c010134b <cons_intr>
c01015b0:	83 c4 10             	add    $0x10,%esp
}
c01015b3:	90                   	nop
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_init>:

static void
kbd_init(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015bc:	e8 dc ff ff ff       	call   c010159d <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c1:	83 ec 0c             	sub    $0xc,%esp
c01015c4:	6a 01                	push   $0x1
c01015c6:	e8 4b 01 00 00       	call   c0101716 <pic_enable>
c01015cb:	83 c4 10             	add    $0x10,%esp
}
c01015ce:	90                   	nop
c01015cf:	c9                   	leave  
c01015d0:	c3                   	ret    

c01015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015d7:	e8 88 f8 ff ff       	call   c0100e64 <cga_init>
    serial_init();
c01015dc:	e8 6a f9 ff ff       	call   c0100f4b <serial_init>
    kbd_init();
c01015e1:	e8 d0 ff ff ff       	call   c01015b6 <kbd_init>
    if (!serial_exists) {
c01015e6:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c01015eb:	85 c0                	test   %eax,%eax
c01015ed:	75 10                	jne    c01015ff <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015ef:	83 ec 0c             	sub    $0xc,%esp
c01015f2:	68 69 60 10 c0       	push   $0xc0106069
c01015f7:	e8 7b ec ff ff       	call   c0100277 <cprintf>
c01015fc:	83 c4 10             	add    $0x10,%esp
    }
}
c01015ff:	90                   	nop
c0101600:	c9                   	leave  
c0101601:	c3                   	ret    

c0101602 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101602:	55                   	push   %ebp
c0101603:	89 e5                	mov    %esp,%ebp
c0101605:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101608:	e8 d0 f7 ff ff       	call   c0100ddd <__intr_save>
c010160d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101610:	83 ec 0c             	sub    $0xc,%esp
c0101613:	ff 75 08             	pushl  0x8(%ebp)
c0101616:	e8 8f fa ff ff       	call   c01010aa <lpt_putc>
c010161b:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010161e:	83 ec 0c             	sub    $0xc,%esp
c0101621:	ff 75 08             	pushl  0x8(%ebp)
c0101624:	e8 b8 fa ff ff       	call   c01010e1 <cga_putc>
c0101629:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010162c:	83 ec 0c             	sub    $0xc,%esp
c010162f:	ff 75 08             	pushl  0x8(%ebp)
c0101632:	e8 dd fc ff ff       	call   c0101314 <serial_putc>
c0101637:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010163a:	83 ec 0c             	sub    $0xc,%esp
c010163d:	ff 75 f4             	pushl  -0xc(%ebp)
c0101640:	e8 c2 f7 ff ff       	call   c0100e07 <__intr_restore>
c0101645:	83 c4 10             	add    $0x10,%esp
}
c0101648:	90                   	nop
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 80 f7 ff ff       	call   c0100ddd <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 89 fd ff ff       	call   c01013ee <serial_intr>
        kbd_intr();
c0101665:	e8 33 ff ff ff       	call   c010159d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 a0 90 11 c0    	mov    0xc01190a0,%edx
c0101670:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 a0 90 11 c0    	mov    %edx,0xc01190a0
c0101687:	0f b6 80 a0 8e 11 c0 	movzbl -0x3fee7160(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 a0 90 11 c0 00 	movl   $0x0,0xc01190a0
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	83 ec 0c             	sub    $0xc,%esp
c01016ad:	ff 75 f0             	pushl  -0x10(%ebp)
c01016b0:	e8 52 f7 ff ff       	call   c0100e07 <__intr_restore>
c01016b5:	83 c4 10             	add    $0x10,%esp
    return c;
c01016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016bb:	c9                   	leave  
c01016bc:	c3                   	ret    

c01016bd <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016bd:	55                   	push   %ebp
c01016be:	89 e5                	mov    %esp,%ebp
c01016c0:	83 ec 14             	sub    $0x14,%esp
c01016c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ce:	66 a3 70 85 11 c0    	mov    %ax,0xc0118570
    if (did_init) {
c01016d4:	a1 ac 90 11 c0       	mov    0xc01190ac,%eax
c01016d9:	85 c0                	test   %eax,%eax
c01016db:	74 36                	je     c0101713 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e1:	0f b6 c0             	movzbl %al,%eax
c01016e4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016ea:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016f5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fa:	66 c1 e8 08          	shr    $0x8,%ax
c01016fe:	0f b6 c0             	movzbl %al,%eax
c0101701:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101707:	88 45 fd             	mov    %al,-0x3(%ebp)
c010170a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010170e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101712:	ee                   	out    %al,(%dx)
    }
}
c0101713:	90                   	nop
c0101714:	c9                   	leave  
c0101715:	c3                   	ret    

c0101716 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101716:	55                   	push   %ebp
c0101717:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101719:	8b 45 08             	mov    0x8(%ebp),%eax
c010171c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101721:	89 c1                	mov    %eax,%ecx
c0101723:	d3 e2                	shl    %cl,%edx
c0101725:	89 d0                	mov    %edx,%eax
c0101727:	f7 d0                	not    %eax
c0101729:	89 c2                	mov    %eax,%edx
c010172b:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c0101732:	21 d0                	and    %edx,%eax
c0101734:	0f b7 c0             	movzwl %ax,%eax
c0101737:	50                   	push   %eax
c0101738:	e8 80 ff ff ff       	call   c01016bd <pic_setmask>
c010173d:	83 c4 04             	add    $0x4,%esp
}
c0101740:	90                   	nop
c0101741:	c9                   	leave  
c0101742:	c3                   	ret    

c0101743 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
c0101746:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c0101749:	c7 05 ac 90 11 c0 01 	movl   $0x1,0xc01190ac
c0101750:	00 00 00 
c0101753:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101759:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c010175d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101761:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101765:	ee                   	out    %al,(%dx)
c0101766:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010176c:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101770:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101774:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
c0101779:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010177f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101783:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101787:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178b:	ee                   	out    %al,(%dx)
c010178c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101792:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101796:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010179a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010179e:	ee                   	out    %al,(%dx)
c010179f:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017a5:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017a9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017ad:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017b1:	ee                   	out    %al,(%dx)
c01017b2:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017b8:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017bc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017c0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
c01017c5:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017cb:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017cf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
c01017d8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017de:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017ea:	ee                   	out    %al,(%dx)
c01017eb:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017f1:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01017f5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017f9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
c01017fe:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101804:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101808:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010180c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101810:	ee                   	out    %al,(%dx)
c0101811:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101817:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c010181b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010181f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101823:	ee                   	out    %al,(%dx)
c0101824:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010182a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c010182e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101832:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101836:	ee                   	out    %al,(%dx)
c0101837:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010183d:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101841:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101845:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101849:	ee                   	out    %al,(%dx)
c010184a:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101850:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101854:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101858:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010185c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010185d:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c0101864:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101868:	74 13                	je     c010187d <pic_init+0x13a>
        pic_setmask(irq_mask);
c010186a:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c0101871:	0f b7 c0             	movzwl %ax,%eax
c0101874:	50                   	push   %eax
c0101875:	e8 43 fe ff ff       	call   c01016bd <pic_setmask>
c010187a:	83 c4 04             	add    $0x4,%esp
    }
}
c010187d:	90                   	nop
c010187e:	c9                   	leave  
c010187f:	c3                   	ret    

c0101880 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101880:	55                   	push   %ebp
c0101881:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101883:	fb                   	sti    
    sti();
}
c0101884:	90                   	nop
c0101885:	5d                   	pop    %ebp
c0101886:	c3                   	ret    

c0101887 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101887:	55                   	push   %ebp
c0101888:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010188a:	fa                   	cli    
    cli();
}
c010188b:	90                   	nop
c010188c:	5d                   	pop    %ebp
c010188d:	c3                   	ret    

c010188e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010188e:	55                   	push   %ebp
c010188f:	89 e5                	mov    %esp,%ebp
c0101891:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101894:	83 ec 08             	sub    $0x8,%esp
c0101897:	6a 64                	push   $0x64
c0101899:	68 a0 60 10 c0       	push   $0xc01060a0
c010189e:	e8 d4 e9 ff ff       	call   c0100277 <cprintf>
c01018a3:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018a6:	83 ec 0c             	sub    $0xc,%esp
c01018a9:	68 aa 60 10 c0       	push   $0xc01060aa
c01018ae:	e8 c4 e9 ff ff       	call   c0100277 <cprintf>
c01018b3:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01018b6:	83 ec 04             	sub    $0x4,%esp
c01018b9:	68 b8 60 10 c0       	push   $0xc01060b8
c01018be:	6a 12                	push   $0x12
c01018c0:	68 ce 60 10 c0       	push   $0xc01060ce
c01018c5:	e8 13 eb ff ff       	call   c01003dd <__panic>

c01018ca <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018ca:	55                   	push   %ebp
c01018cb:	89 e5                	mov    %esp,%ebp
c01018cd:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t  __vectors[];
	for (int i = 0; i < 256; i++) {
c01018d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018d7:	e9 c3 00 00 00       	jmp    c010199f <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);
c01018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018df:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c01018e6:	89 c2                	mov    %eax,%edx
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	66 89 14 c5 c0 90 11 	mov    %dx,-0x3fee6f40(,%eax,8)
c01018f2:	c0 
c01018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f6:	66 c7 04 c5 c2 90 11 	movw   $0x8,-0x3fee6f3e(,%eax,8)
c01018fd:	c0 08 00 
c0101900:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101903:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c010190a:	c0 
c010190b:	83 e2 e0             	and    $0xffffffe0,%edx
c010190e:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c0101915:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101918:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c010191f:	c0 
c0101920:	83 e2 1f             	and    $0x1f,%edx
c0101923:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c010192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192d:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c0101934:	c0 
c0101935:	83 e2 f0             	and    $0xfffffff0,%edx
c0101938:	83 ca 0e             	or     $0xe,%edx
c010193b:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c0101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101945:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c010194c:	c0 
c010194d:	83 e2 ef             	and    $0xffffffef,%edx
c0101950:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c0101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195a:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c0101961:	c0 
c0101962:	83 e2 9f             	and    $0xffffff9f,%edx
c0101965:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c010196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196f:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c0101976:	c0 
c0101977:	83 ca 80             	or     $0xffffff80,%edx
c010197a:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c0101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101984:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c010198b:	c1 e8 10             	shr    $0x10,%eax
c010198e:	89 c2                	mov    %eax,%edx
c0101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101993:	66 89 14 c5 c6 90 11 	mov    %dx,-0x3fee6f3a(,%eax,8)
c010199a:	c0 
	for (int i = 0; i < 256; i++) {
c010199b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010199f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019a6:	0f 8e 30 ff ff ff    	jle    c01018dc <idt_init+0x12>
c01019ac:	c7 45 f8 80 85 11 c0 	movl   $0xc0118580,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019b6:	0f 01 18             	lidtl  (%eax)
	}
	lidt(&idt_pd);

	//for challenge1
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], 3);
c01019b9:	a1 e4 87 11 c0       	mov    0xc01187e4,%eax
c01019be:	66 a3 88 94 11 c0    	mov    %ax,0xc0119488
c01019c4:	66 c7 05 8a 94 11 c0 	movw   $0x8,0xc011948a
c01019cb:	08 00 
c01019cd:	0f b6 05 8c 94 11 c0 	movzbl 0xc011948c,%eax
c01019d4:	83 e0 e0             	and    $0xffffffe0,%eax
c01019d7:	a2 8c 94 11 c0       	mov    %al,0xc011948c
c01019dc:	0f b6 05 8c 94 11 c0 	movzbl 0xc011948c,%eax
c01019e3:	83 e0 1f             	and    $0x1f,%eax
c01019e6:	a2 8c 94 11 c0       	mov    %al,0xc011948c
c01019eb:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c01019f2:	83 c8 0f             	or     $0xf,%eax
c01019f5:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c01019fa:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a01:	83 e0 ef             	and    $0xffffffef,%eax
c0101a04:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a09:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a10:	83 c8 60             	or     $0x60,%eax
c0101a13:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a18:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a1f:	83 c8 80             	or     $0xffffff80,%eax
c0101a22:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a27:	a1 e4 87 11 c0       	mov    0xc01187e4,%eax
c0101a2c:	c1 e8 10             	shr    $0x10,%eax
c0101a2f:	66 a3 8e 94 11 c0    	mov    %ax,0xc011948e
	SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], 0);
c0101a35:	a1 e0 87 11 c0       	mov    0xc01187e0,%eax
c0101a3a:	66 a3 80 94 11 c0    	mov    %ax,0xc0119480
c0101a40:	66 c7 05 82 94 11 c0 	movw   $0x8,0xc0119482
c0101a47:	08 00 
c0101a49:	0f b6 05 84 94 11 c0 	movzbl 0xc0119484,%eax
c0101a50:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a53:	a2 84 94 11 c0       	mov    %al,0xc0119484
c0101a58:	0f b6 05 84 94 11 c0 	movzbl 0xc0119484,%eax
c0101a5f:	83 e0 1f             	and    $0x1f,%eax
c0101a62:	a2 84 94 11 c0       	mov    %al,0xc0119484
c0101a67:	0f b6 05 85 94 11 c0 	movzbl 0xc0119485,%eax
c0101a6e:	83 e0 f0             	and    $0xfffffff0,%eax
c0101a71:	83 c8 0e             	or     $0xe,%eax
c0101a74:	a2 85 94 11 c0       	mov    %al,0xc0119485
c0101a79:	0f b6 05 85 94 11 c0 	movzbl 0xc0119485,%eax
c0101a80:	83 e0 ef             	and    $0xffffffef,%eax
c0101a83:	a2 85 94 11 c0       	mov    %al,0xc0119485
c0101a88:	0f b6 05 85 94 11 c0 	movzbl 0xc0119485,%eax
c0101a8f:	83 e0 9f             	and    $0xffffff9f,%eax
c0101a92:	a2 85 94 11 c0       	mov    %al,0xc0119485
c0101a97:	0f b6 05 85 94 11 c0 	movzbl 0xc0119485,%eax
c0101a9e:	83 c8 80             	or     $0xffffff80,%eax
c0101aa1:	a2 85 94 11 c0       	mov    %al,0xc0119485
c0101aa6:	a1 e0 87 11 c0       	mov    0xc01187e0,%eax
c0101aab:	c1 e8 10             	shr    $0x10,%eax
c0101aae:	66 a3 86 94 11 c0    	mov    %ax,0xc0119486
}
c0101ab4:	90                   	nop
c0101ab5:	c9                   	leave  
c0101ab6:	c3                   	ret    

c0101ab7 <trapname>:

static const char *
trapname(int trapno) {
c0101ab7:	55                   	push   %ebp
c0101ab8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abd:	83 f8 13             	cmp    $0x13,%eax
c0101ac0:	77 0c                	ja     c0101ace <trapname+0x17>
        return excnames[trapno];
c0101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac5:	8b 04 85 20 64 10 c0 	mov    -0x3fef9be0(,%eax,4),%eax
c0101acc:	eb 18                	jmp    c0101ae6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ace:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ad2:	7e 0d                	jle    c0101ae1 <trapname+0x2a>
c0101ad4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ad8:	7f 07                	jg     c0101ae1 <trapname+0x2a>
        return "Hardware Interrupt";
c0101ada:	b8 df 60 10 c0       	mov    $0xc01060df,%eax
c0101adf:	eb 05                	jmp    c0101ae6 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101ae1:	b8 f2 60 10 c0       	mov    $0xc01060f2,%eax
}
c0101ae6:	5d                   	pop    %ebp
c0101ae7:	c3                   	ret    

c0101ae8 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ae8:	55                   	push   %ebp
c0101ae9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aee:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101af2:	66 83 f8 08          	cmp    $0x8,%ax
c0101af6:	0f 94 c0             	sete   %al
c0101af9:	0f b6 c0             	movzbl %al,%eax
}
c0101afc:	5d                   	pop    %ebp
c0101afd:	c3                   	ret    

c0101afe <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101afe:	55                   	push   %ebp
c0101aff:	89 e5                	mov    %esp,%ebp
c0101b01:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101b04:	83 ec 08             	sub    $0x8,%esp
c0101b07:	ff 75 08             	pushl  0x8(%ebp)
c0101b0a:	68 33 61 10 c0       	push   $0xc0106133
c0101b0f:	e8 63 e7 ff ff       	call   c0100277 <cprintf>
c0101b14:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1a:	83 ec 0c             	sub    $0xc,%esp
c0101b1d:	50                   	push   %eax
c0101b1e:	e8 b6 01 00 00       	call   c0101cd9 <print_regs>
c0101b23:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b29:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b2d:	0f b7 c0             	movzwl %ax,%eax
c0101b30:	83 ec 08             	sub    $0x8,%esp
c0101b33:	50                   	push   %eax
c0101b34:	68 44 61 10 c0       	push   $0xc0106144
c0101b39:	e8 39 e7 ff ff       	call   c0100277 <cprintf>
c0101b3e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b44:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b48:	0f b7 c0             	movzwl %ax,%eax
c0101b4b:	83 ec 08             	sub    $0x8,%esp
c0101b4e:	50                   	push   %eax
c0101b4f:	68 57 61 10 c0       	push   $0xc0106157
c0101b54:	e8 1e e7 ff ff       	call   c0100277 <cprintf>
c0101b59:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	83 ec 08             	sub    $0x8,%esp
c0101b69:	50                   	push   %eax
c0101b6a:	68 6a 61 10 c0       	push   $0xc010616a
c0101b6f:	e8 03 e7 ff ff       	call   c0100277 <cprintf>
c0101b74:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b7e:	0f b7 c0             	movzwl %ax,%eax
c0101b81:	83 ec 08             	sub    $0x8,%esp
c0101b84:	50                   	push   %eax
c0101b85:	68 7d 61 10 c0       	push   $0xc010617d
c0101b8a:	e8 e8 e6 ff ff       	call   c0100277 <cprintf>
c0101b8f:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b95:	8b 40 30             	mov    0x30(%eax),%eax
c0101b98:	83 ec 0c             	sub    $0xc,%esp
c0101b9b:	50                   	push   %eax
c0101b9c:	e8 16 ff ff ff       	call   c0101ab7 <trapname>
c0101ba1:	83 c4 10             	add    $0x10,%esp
c0101ba4:	89 c2                	mov    %eax,%edx
c0101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba9:	8b 40 30             	mov    0x30(%eax),%eax
c0101bac:	83 ec 04             	sub    $0x4,%esp
c0101baf:	52                   	push   %edx
c0101bb0:	50                   	push   %eax
c0101bb1:	68 90 61 10 c0       	push   $0xc0106190
c0101bb6:	e8 bc e6 ff ff       	call   c0100277 <cprintf>
c0101bbb:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc1:	8b 40 34             	mov    0x34(%eax),%eax
c0101bc4:	83 ec 08             	sub    $0x8,%esp
c0101bc7:	50                   	push   %eax
c0101bc8:	68 a2 61 10 c0       	push   $0xc01061a2
c0101bcd:	e8 a5 e6 ff ff       	call   c0100277 <cprintf>
c0101bd2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd8:	8b 40 38             	mov    0x38(%eax),%eax
c0101bdb:	83 ec 08             	sub    $0x8,%esp
c0101bde:	50                   	push   %eax
c0101bdf:	68 b1 61 10 c0       	push   $0xc01061b1
c0101be4:	e8 8e e6 ff ff       	call   c0100277 <cprintf>
c0101be9:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bf3:	0f b7 c0             	movzwl %ax,%eax
c0101bf6:	83 ec 08             	sub    $0x8,%esp
c0101bf9:	50                   	push   %eax
c0101bfa:	68 c0 61 10 c0       	push   $0xc01061c0
c0101bff:	e8 73 e6 ff ff       	call   c0100277 <cprintf>
c0101c04:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0a:	8b 40 40             	mov    0x40(%eax),%eax
c0101c0d:	83 ec 08             	sub    $0x8,%esp
c0101c10:	50                   	push   %eax
c0101c11:	68 d3 61 10 c0       	push   $0xc01061d3
c0101c16:	e8 5c e6 ff ff       	call   c0100277 <cprintf>
c0101c1b:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c2c:	eb 3f                	jmp    c0101c6d <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c31:	8b 50 40             	mov    0x40(%eax),%edx
c0101c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c37:	21 d0                	and    %edx,%eax
c0101c39:	85 c0                	test   %eax,%eax
c0101c3b:	74 29                	je     c0101c66 <print_trapframe+0x168>
c0101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c40:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c47:	85 c0                	test   %eax,%eax
c0101c49:	74 1b                	je     c0101c66 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c4e:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c55:	83 ec 08             	sub    $0x8,%esp
c0101c58:	50                   	push   %eax
c0101c59:	68 e2 61 10 c0       	push   $0xc01061e2
c0101c5e:	e8 14 e6 ff ff       	call   c0100277 <cprintf>
c0101c63:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c6a:	d1 65 f0             	shll   -0x10(%ebp)
c0101c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c70:	83 f8 17             	cmp    $0x17,%eax
c0101c73:	76 b9                	jbe    c0101c2e <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c78:	8b 40 40             	mov    0x40(%eax),%eax
c0101c7b:	c1 e8 0c             	shr    $0xc,%eax
c0101c7e:	83 e0 03             	and    $0x3,%eax
c0101c81:	83 ec 08             	sub    $0x8,%esp
c0101c84:	50                   	push   %eax
c0101c85:	68 e6 61 10 c0       	push   $0xc01061e6
c0101c8a:	e8 e8 e5 ff ff       	call   c0100277 <cprintf>
c0101c8f:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101c92:	83 ec 0c             	sub    $0xc,%esp
c0101c95:	ff 75 08             	pushl  0x8(%ebp)
c0101c98:	e8 4b fe ff ff       	call   c0101ae8 <trap_in_kernel>
c0101c9d:	83 c4 10             	add    $0x10,%esp
c0101ca0:	85 c0                	test   %eax,%eax
c0101ca2:	75 32                	jne    c0101cd6 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 44             	mov    0x44(%eax),%eax
c0101caa:	83 ec 08             	sub    $0x8,%esp
c0101cad:	50                   	push   %eax
c0101cae:	68 ef 61 10 c0       	push   $0xc01061ef
c0101cb3:	e8 bf e5 ff ff       	call   c0100277 <cprintf>
c0101cb8:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbe:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cc2:	0f b7 c0             	movzwl %ax,%eax
c0101cc5:	83 ec 08             	sub    $0x8,%esp
c0101cc8:	50                   	push   %eax
c0101cc9:	68 fe 61 10 c0       	push   $0xc01061fe
c0101cce:	e8 a4 e5 ff ff       	call   c0100277 <cprintf>
c0101cd3:	83 c4 10             	add    $0x10,%esp
    }
}
c0101cd6:	90                   	nop
c0101cd7:	c9                   	leave  
c0101cd8:	c3                   	ret    

c0101cd9 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cd9:	55                   	push   %ebp
c0101cda:	89 e5                	mov    %esp,%ebp
c0101cdc:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce2:	8b 00                	mov    (%eax),%eax
c0101ce4:	83 ec 08             	sub    $0x8,%esp
c0101ce7:	50                   	push   %eax
c0101ce8:	68 11 62 10 c0       	push   $0xc0106211
c0101ced:	e8 85 e5 ff ff       	call   c0100277 <cprintf>
c0101cf2:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	8b 40 04             	mov    0x4(%eax),%eax
c0101cfb:	83 ec 08             	sub    $0x8,%esp
c0101cfe:	50                   	push   %eax
c0101cff:	68 20 62 10 c0       	push   $0xc0106220
c0101d04:	e8 6e e5 ff ff       	call   c0100277 <cprintf>
c0101d09:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0f:	8b 40 08             	mov    0x8(%eax),%eax
c0101d12:	83 ec 08             	sub    $0x8,%esp
c0101d15:	50                   	push   %eax
c0101d16:	68 2f 62 10 c0       	push   $0xc010622f
c0101d1b:	e8 57 e5 ff ff       	call   c0100277 <cprintf>
c0101d20:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d26:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d29:	83 ec 08             	sub    $0x8,%esp
c0101d2c:	50                   	push   %eax
c0101d2d:	68 3e 62 10 c0       	push   $0xc010623e
c0101d32:	e8 40 e5 ff ff       	call   c0100277 <cprintf>
c0101d37:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3d:	8b 40 10             	mov    0x10(%eax),%eax
c0101d40:	83 ec 08             	sub    $0x8,%esp
c0101d43:	50                   	push   %eax
c0101d44:	68 4d 62 10 c0       	push   $0xc010624d
c0101d49:	e8 29 e5 ff ff       	call   c0100277 <cprintf>
c0101d4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d54:	8b 40 14             	mov    0x14(%eax),%eax
c0101d57:	83 ec 08             	sub    $0x8,%esp
c0101d5a:	50                   	push   %eax
c0101d5b:	68 5c 62 10 c0       	push   $0xc010625c
c0101d60:	e8 12 e5 ff ff       	call   c0100277 <cprintf>
c0101d65:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6b:	8b 40 18             	mov    0x18(%eax),%eax
c0101d6e:	83 ec 08             	sub    $0x8,%esp
c0101d71:	50                   	push   %eax
c0101d72:	68 6b 62 10 c0       	push   $0xc010626b
c0101d77:	e8 fb e4 ff ff       	call   c0100277 <cprintf>
c0101d7c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d82:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d85:	83 ec 08             	sub    $0x8,%esp
c0101d88:	50                   	push   %eax
c0101d89:	68 7a 62 10 c0       	push   $0xc010627a
c0101d8e:	e8 e4 e4 ff ff       	call   c0100277 <cprintf>
c0101d93:	83 c4 10             	add    $0x10,%esp
}
c0101d96:	90                   	nop
c0101d97:	c9                   	leave  
c0101d98:	c3                   	ret    

c0101d99 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d99:	55                   	push   %ebp
c0101d9a:	89 e5                	mov    %esp,%ebp
c0101d9c:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da2:	8b 40 30             	mov    0x30(%eax),%eax
c0101da5:	83 f8 2f             	cmp    $0x2f,%eax
c0101da8:	77 21                	ja     c0101dcb <trap_dispatch+0x32>
c0101daa:	83 f8 2e             	cmp    $0x2e,%eax
c0101dad:	0f 83 5c 02 00 00    	jae    c010200f <trap_dispatch+0x276>
c0101db3:	83 f8 21             	cmp    $0x21,%eax
c0101db6:	0f 84 87 00 00 00    	je     c0101e43 <trap_dispatch+0xaa>
c0101dbc:	83 f8 24             	cmp    $0x24,%eax
c0101dbf:	74 5b                	je     c0101e1c <trap_dispatch+0x83>
c0101dc1:	83 f8 20             	cmp    $0x20,%eax
c0101dc4:	74 1c                	je     c0101de2 <trap_dispatch+0x49>
c0101dc6:	e9 0e 02 00 00       	jmp    c0101fd9 <trap_dispatch+0x240>
c0101dcb:	83 f8 78             	cmp    $0x78,%eax
c0101dce:	0f 84 5e 01 00 00    	je     c0101f32 <trap_dispatch+0x199>
c0101dd4:	83 f8 79             	cmp    $0x79,%eax
c0101dd7:	0f 84 aa 01 00 00    	je     c0101f87 <trap_dispatch+0x1ee>
c0101ddd:	e9 f7 01 00 00       	jmp    c0101fd9 <trap_dispatch+0x240>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks += 1;
c0101de2:	a1 4c 99 11 c0       	mov    0xc011994c,%eax
c0101de7:	83 c0 01             	add    $0x1,%eax
c0101dea:	a3 4c 99 11 c0       	mov    %eax,0xc011994c
		if (ticks%TICK_NUM == 0) {
c0101def:	8b 0d 4c 99 11 c0    	mov    0xc011994c,%ecx
c0101df5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101dfa:	89 c8                	mov    %ecx,%eax
c0101dfc:	f7 e2                	mul    %edx
c0101dfe:	89 d0                	mov    %edx,%eax
c0101e00:	c1 e8 05             	shr    $0x5,%eax
c0101e03:	6b c0 64             	imul   $0x64,%eax,%eax
c0101e06:	29 c1                	sub    %eax,%ecx
c0101e08:	89 c8                	mov    %ecx,%eax
c0101e0a:	85 c0                	test   %eax,%eax
c0101e0c:	0f 85 00 02 00 00    	jne    c0102012 <trap_dispatch+0x279>
			print_ticks();
c0101e12:	e8 77 fa ff ff       	call   c010188e <print_ticks>
		}
		break;
c0101e17:	e9 f6 01 00 00       	jmp    c0102012 <trap_dispatch+0x279>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e1c:	e8 2a f8 ff ff       	call   c010164b <cons_getc>
c0101e21:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e24:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e28:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e2c:	83 ec 04             	sub    $0x4,%esp
c0101e2f:	52                   	push   %edx
c0101e30:	50                   	push   %eax
c0101e31:	68 89 62 10 c0       	push   $0xc0106289
c0101e36:	e8 3c e4 ff ff       	call   c0100277 <cprintf>
c0101e3b:	83 c4 10             	add    $0x10,%esp
        break;
c0101e3e:	e9 d9 01 00 00       	jmp    c010201c <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_KBD:
		c = cons_getc();
c0101e43:	e8 03 f8 ff ff       	call   c010164b <cons_getc>
c0101e48:	88 45 f7             	mov    %al,-0x9(%ebp)

		cprintf("kbd [%03d] %c\n", c, c);
c0101e4b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e4f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e53:	83 ec 04             	sub    $0x4,%esp
c0101e56:	52                   	push   %edx
c0101e57:	50                   	push   %eax
c0101e58:	68 9b 62 10 c0       	push   $0xc010629b
c0101e5d:	e8 15 e4 ff ff       	call   c0100277 <cprintf>
c0101e62:	83 c4 10             	add    $0x10,%esp
		if (c == '0') {
c0101e65:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
c0101e69:	75 5a                	jne    c0101ec5 <trap_dispatch+0x12c>
			if (tf->tf_cs != (uint16_t)KERNEL_CS) {
c0101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e72:	66 83 f8 08          	cmp    $0x8,%ax
c0101e76:	74 4d                	je     c0101ec5 <trap_dispatch+0x12c>
				tf->tf_cs = (uint16_t)KERNEL_CS;
c0101e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)KERNEL_DS;
c0101e81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e84:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8d:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e94:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags &= ~FL_IOPL_MASK;
c0101ea6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea9:	8b 40 40             	mov    0x40(%eax),%eax
c0101eac:	80 e4 cf             	and    $0xcf,%ah
c0101eaf:	89 c2                	mov    %eax,%edx
c0101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb4:	89 50 40             	mov    %edx,0x40(%eax)
				print_trapframe(tf);
c0101eb7:	83 ec 0c             	sub    $0xc,%esp
c0101eba:	ff 75 08             	pushl  0x8(%ebp)
c0101ebd:	e8 3c fc ff ff       	call   c0101afe <print_trapframe>
c0101ec2:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (c == '3') {
c0101ec5:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
c0101ec9:	0f 85 46 01 00 00    	jne    c0102015 <trap_dispatch+0x27c>
			if (tf->tf_cs != (uint16_t)USER_CS) {
c0101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ed6:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101eda:	0f 84 35 01 00 00    	je     c0102015 <trap_dispatch+0x27c>
				tf->tf_cs = (uint16_t)USER_CS;
c0101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee3:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)USER_DS;
c0101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eec:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef5:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efc:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f03:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
c0101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f11:	8b 40 40             	mov    0x40(%eax),%eax
c0101f14:	80 cc 30             	or     $0x30,%ah
c0101f17:	89 c2                	mov    %eax,%edx
c0101f19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1c:	89 50 40             	mov    %edx,0x40(%eax)
				print_trapframe(tf);
c0101f1f:	83 ec 0c             	sub    $0xc,%esp
c0101f22:	ff 75 08             	pushl  0x8(%ebp)
c0101f25:	e8 d4 fb ff ff       	call   c0101afe <print_trapframe>
c0101f2a:	83 c4 10             	add    $0x10,%esp
			}
		}
		break;
c0101f2d:	e9 e3 00 00 00       	jmp    c0102015 <trap_dispatch+0x27c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
		if (tf->tf_cs != (uint16_t)USER_CS) {
c0101f32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f39:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101f3d:	0f 84 d5 00 00 00    	je     c0102018 <trap_dispatch+0x27f>
			tf->tf_cs = (uint16_t)USER_CS;
c0101f43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f46:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)USER_DS;
c0101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4f:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f58:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5f:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f66:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f6d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;  //3000
c0101f71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f74:	8b 40 40             	mov    0x40(%eax),%eax
c0101f77:	80 cc 30             	or     $0x30,%ah
c0101f7a:	89 c2                	mov    %eax,%edx
c0101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7f:	89 50 40             	mov    %edx,0x40(%eax)

		}
		break;
c0101f82:	e9 91 00 00 00       	jmp    c0102018 <trap_dispatch+0x27f>
    case T_SWITCH_TOK:
		if (tf->tf_cs != (uint16_t)KERNEL_CS) {
c0101f87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f8e:	66 83 f8 08          	cmp    $0x8,%ax
c0101f92:	0f 84 83 00 00 00    	je     c010201b <trap_dispatch+0x282>
			tf->tf_cs = (uint16_t)KERNEL_CS;
c0101f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)KERNEL_DS;
c0101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa4:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101faa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fad:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb4:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbb:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
c0101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc9:	8b 40 40             	mov    0x40(%eax),%eax
c0101fcc:	80 e4 cf             	and    $0xcf,%ah
c0101fcf:	89 c2                	mov    %eax,%edx
c0101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd4:	89 50 40             	mov    %edx,0x40(%eax)
		}
		break;
c0101fd7:	eb 42                	jmp    c010201b <trap_dispatch+0x282>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101fd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fdc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fe0:	0f b7 c0             	movzwl %ax,%eax
c0101fe3:	83 e0 03             	and    $0x3,%eax
c0101fe6:	85 c0                	test   %eax,%eax
c0101fe8:	75 32                	jne    c010201c <trap_dispatch+0x283>
            print_trapframe(tf);
c0101fea:	83 ec 0c             	sub    $0xc,%esp
c0101fed:	ff 75 08             	pushl  0x8(%ebp)
c0101ff0:	e8 09 fb ff ff       	call   c0101afe <print_trapframe>
c0101ff5:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101ff8:	83 ec 04             	sub    $0x4,%esp
c0101ffb:	68 aa 62 10 c0       	push   $0xc01062aa
c0102000:	68 d5 00 00 00       	push   $0xd5
c0102005:	68 ce 60 10 c0       	push   $0xc01060ce
c010200a:	e8 ce e3 ff ff       	call   c01003dd <__panic>
        break;
c010200f:	90                   	nop
c0102010:	eb 0a                	jmp    c010201c <trap_dispatch+0x283>
		break;
c0102012:	90                   	nop
c0102013:	eb 07                	jmp    c010201c <trap_dispatch+0x283>
		break;
c0102015:	90                   	nop
c0102016:	eb 04                	jmp    c010201c <trap_dispatch+0x283>
		break;
c0102018:	90                   	nop
c0102019:	eb 01                	jmp    c010201c <trap_dispatch+0x283>
		break;
c010201b:	90                   	nop
        }
    }
}
c010201c:	90                   	nop
c010201d:	c9                   	leave  
c010201e:	c3                   	ret    

c010201f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010201f:	55                   	push   %ebp
c0102020:	89 e5                	mov    %esp,%ebp
c0102022:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102025:	83 ec 0c             	sub    $0xc,%esp
c0102028:	ff 75 08             	pushl  0x8(%ebp)
c010202b:	e8 69 fd ff ff       	call   c0101d99 <trap_dispatch>
c0102030:	83 c4 10             	add    $0x10,%esp
}
c0102033:	90                   	nop
c0102034:	c9                   	leave  
c0102035:	c3                   	ret    

c0102036 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $0
c0102038:	6a 00                	push   $0x0
  jmp __alltraps
c010203a:	e9 67 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010203f <vector1>:
.globl vector1
vector1:
  pushl $0
c010203f:	6a 00                	push   $0x0
  pushl $1
c0102041:	6a 01                	push   $0x1
  jmp __alltraps
c0102043:	e9 5e 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102048 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102048:	6a 00                	push   $0x0
  pushl $2
c010204a:	6a 02                	push   $0x2
  jmp __alltraps
c010204c:	e9 55 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102051 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102051:	6a 00                	push   $0x0
  pushl $3
c0102053:	6a 03                	push   $0x3
  jmp __alltraps
c0102055:	e9 4c 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010205a <vector4>:
.globl vector4
vector4:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $4
c010205c:	6a 04                	push   $0x4
  jmp __alltraps
c010205e:	e9 43 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102063 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102063:	6a 00                	push   $0x0
  pushl $5
c0102065:	6a 05                	push   $0x5
  jmp __alltraps
c0102067:	e9 3a 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010206c <vector6>:
.globl vector6
vector6:
  pushl $0
c010206c:	6a 00                	push   $0x0
  pushl $6
c010206e:	6a 06                	push   $0x6
  jmp __alltraps
c0102070:	e9 31 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102075 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102075:	6a 00                	push   $0x0
  pushl $7
c0102077:	6a 07                	push   $0x7
  jmp __alltraps
c0102079:	e9 28 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010207e <vector8>:
.globl vector8
vector8:
  pushl $8
c010207e:	6a 08                	push   $0x8
  jmp __alltraps
c0102080:	e9 21 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102085 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102085:	6a 09                	push   $0x9
  jmp __alltraps
c0102087:	e9 1a 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010208c <vector10>:
.globl vector10
vector10:
  pushl $10
c010208c:	6a 0a                	push   $0xa
  jmp __alltraps
c010208e:	e9 13 0a 00 00       	jmp    c0102aa6 <__alltraps>

c0102093 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102093:	6a 0b                	push   $0xb
  jmp __alltraps
c0102095:	e9 0c 0a 00 00       	jmp    c0102aa6 <__alltraps>

c010209a <vector12>:
.globl vector12
vector12:
  pushl $12
c010209a:	6a 0c                	push   $0xc
  jmp __alltraps
c010209c:	e9 05 0a 00 00       	jmp    c0102aa6 <__alltraps>

c01020a1 <vector13>:
.globl vector13
vector13:
  pushl $13
c01020a1:	6a 0d                	push   $0xd
  jmp __alltraps
c01020a3:	e9 fe 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020a8 <vector14>:
.globl vector14
vector14:
  pushl $14
c01020a8:	6a 0e                	push   $0xe
  jmp __alltraps
c01020aa:	e9 f7 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020af <vector15>:
.globl vector15
vector15:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $15
c01020b1:	6a 0f                	push   $0xf
  jmp __alltraps
c01020b3:	e9 ee 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020b8 <vector16>:
.globl vector16
vector16:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $16
c01020ba:	6a 10                	push   $0x10
  jmp __alltraps
c01020bc:	e9 e5 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020c1 <vector17>:
.globl vector17
vector17:
  pushl $17
c01020c1:	6a 11                	push   $0x11
  jmp __alltraps
c01020c3:	e9 de 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020c8 <vector18>:
.globl vector18
vector18:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $18
c01020ca:	6a 12                	push   $0x12
  jmp __alltraps
c01020cc:	e9 d5 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020d1 <vector19>:
.globl vector19
vector19:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $19
c01020d3:	6a 13                	push   $0x13
  jmp __alltraps
c01020d5:	e9 cc 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020da <vector20>:
.globl vector20
vector20:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $20
c01020dc:	6a 14                	push   $0x14
  jmp __alltraps
c01020de:	e9 c3 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020e3 <vector21>:
.globl vector21
vector21:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $21
c01020e5:	6a 15                	push   $0x15
  jmp __alltraps
c01020e7:	e9 ba 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020ec <vector22>:
.globl vector22
vector22:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $22
c01020ee:	6a 16                	push   $0x16
  jmp __alltraps
c01020f0:	e9 b1 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020f5 <vector23>:
.globl vector23
vector23:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $23
c01020f7:	6a 17                	push   $0x17
  jmp __alltraps
c01020f9:	e9 a8 09 00 00       	jmp    c0102aa6 <__alltraps>

c01020fe <vector24>:
.globl vector24
vector24:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $24
c0102100:	6a 18                	push   $0x18
  jmp __alltraps
c0102102:	e9 9f 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102107 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $25
c0102109:	6a 19                	push   $0x19
  jmp __alltraps
c010210b:	e9 96 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102110 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $26
c0102112:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102114:	e9 8d 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102119 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $27
c010211b:	6a 1b                	push   $0x1b
  jmp __alltraps
c010211d:	e9 84 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102122 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $28
c0102124:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102126:	e9 7b 09 00 00       	jmp    c0102aa6 <__alltraps>

c010212b <vector29>:
.globl vector29
vector29:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $29
c010212d:	6a 1d                	push   $0x1d
  jmp __alltraps
c010212f:	e9 72 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102134 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $30
c0102136:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102138:	e9 69 09 00 00       	jmp    c0102aa6 <__alltraps>

c010213d <vector31>:
.globl vector31
vector31:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $31
c010213f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102141:	e9 60 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102146 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $32
c0102148:	6a 20                	push   $0x20
  jmp __alltraps
c010214a:	e9 57 09 00 00       	jmp    c0102aa6 <__alltraps>

c010214f <vector33>:
.globl vector33
vector33:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $33
c0102151:	6a 21                	push   $0x21
  jmp __alltraps
c0102153:	e9 4e 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102158 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $34
c010215a:	6a 22                	push   $0x22
  jmp __alltraps
c010215c:	e9 45 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102161 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $35
c0102163:	6a 23                	push   $0x23
  jmp __alltraps
c0102165:	e9 3c 09 00 00       	jmp    c0102aa6 <__alltraps>

c010216a <vector36>:
.globl vector36
vector36:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $36
c010216c:	6a 24                	push   $0x24
  jmp __alltraps
c010216e:	e9 33 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102173 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $37
c0102175:	6a 25                	push   $0x25
  jmp __alltraps
c0102177:	e9 2a 09 00 00       	jmp    c0102aa6 <__alltraps>

c010217c <vector38>:
.globl vector38
vector38:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $38
c010217e:	6a 26                	push   $0x26
  jmp __alltraps
c0102180:	e9 21 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102185 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $39
c0102187:	6a 27                	push   $0x27
  jmp __alltraps
c0102189:	e9 18 09 00 00       	jmp    c0102aa6 <__alltraps>

c010218e <vector40>:
.globl vector40
vector40:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $40
c0102190:	6a 28                	push   $0x28
  jmp __alltraps
c0102192:	e9 0f 09 00 00       	jmp    c0102aa6 <__alltraps>

c0102197 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $41
c0102199:	6a 29                	push   $0x29
  jmp __alltraps
c010219b:	e9 06 09 00 00       	jmp    c0102aa6 <__alltraps>

c01021a0 <vector42>:
.globl vector42
vector42:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $42
c01021a2:	6a 2a                	push   $0x2a
  jmp __alltraps
c01021a4:	e9 fd 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021a9 <vector43>:
.globl vector43
vector43:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $43
c01021ab:	6a 2b                	push   $0x2b
  jmp __alltraps
c01021ad:	e9 f4 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021b2 <vector44>:
.globl vector44
vector44:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $44
c01021b4:	6a 2c                	push   $0x2c
  jmp __alltraps
c01021b6:	e9 eb 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021bb <vector45>:
.globl vector45
vector45:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $45
c01021bd:	6a 2d                	push   $0x2d
  jmp __alltraps
c01021bf:	e9 e2 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021c4 <vector46>:
.globl vector46
vector46:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $46
c01021c6:	6a 2e                	push   $0x2e
  jmp __alltraps
c01021c8:	e9 d9 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021cd <vector47>:
.globl vector47
vector47:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $47
c01021cf:	6a 2f                	push   $0x2f
  jmp __alltraps
c01021d1:	e9 d0 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021d6 <vector48>:
.globl vector48
vector48:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $48
c01021d8:	6a 30                	push   $0x30
  jmp __alltraps
c01021da:	e9 c7 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021df <vector49>:
.globl vector49
vector49:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $49
c01021e1:	6a 31                	push   $0x31
  jmp __alltraps
c01021e3:	e9 be 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021e8 <vector50>:
.globl vector50
vector50:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $50
c01021ea:	6a 32                	push   $0x32
  jmp __alltraps
c01021ec:	e9 b5 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021f1 <vector51>:
.globl vector51
vector51:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $51
c01021f3:	6a 33                	push   $0x33
  jmp __alltraps
c01021f5:	e9 ac 08 00 00       	jmp    c0102aa6 <__alltraps>

c01021fa <vector52>:
.globl vector52
vector52:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $52
c01021fc:	6a 34                	push   $0x34
  jmp __alltraps
c01021fe:	e9 a3 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102203 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102203:	6a 00                	push   $0x0
  pushl $53
c0102205:	6a 35                	push   $0x35
  jmp __alltraps
c0102207:	e9 9a 08 00 00       	jmp    c0102aa6 <__alltraps>

c010220c <vector54>:
.globl vector54
vector54:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $54
c010220e:	6a 36                	push   $0x36
  jmp __alltraps
c0102210:	e9 91 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102215 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102215:	6a 00                	push   $0x0
  pushl $55
c0102217:	6a 37                	push   $0x37
  jmp __alltraps
c0102219:	e9 88 08 00 00       	jmp    c0102aa6 <__alltraps>

c010221e <vector56>:
.globl vector56
vector56:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $56
c0102220:	6a 38                	push   $0x38
  jmp __alltraps
c0102222:	e9 7f 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102227 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102227:	6a 00                	push   $0x0
  pushl $57
c0102229:	6a 39                	push   $0x39
  jmp __alltraps
c010222b:	e9 76 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102230 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $58
c0102232:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102234:	e9 6d 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102239 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $59
c010223b:	6a 3b                	push   $0x3b
  jmp __alltraps
c010223d:	e9 64 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102242 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $60
c0102244:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102246:	e9 5b 08 00 00       	jmp    c0102aa6 <__alltraps>

c010224b <vector61>:
.globl vector61
vector61:
  pushl $0
c010224b:	6a 00                	push   $0x0
  pushl $61
c010224d:	6a 3d                	push   $0x3d
  jmp __alltraps
c010224f:	e9 52 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102254 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $62
c0102256:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102258:	e9 49 08 00 00       	jmp    c0102aa6 <__alltraps>

c010225d <vector63>:
.globl vector63
vector63:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $63
c010225f:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102261:	e9 40 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102266 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $64
c0102268:	6a 40                	push   $0x40
  jmp __alltraps
c010226a:	e9 37 08 00 00       	jmp    c0102aa6 <__alltraps>

c010226f <vector65>:
.globl vector65
vector65:
  pushl $0
c010226f:	6a 00                	push   $0x0
  pushl $65
c0102271:	6a 41                	push   $0x41
  jmp __alltraps
c0102273:	e9 2e 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102278 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $66
c010227a:	6a 42                	push   $0x42
  jmp __alltraps
c010227c:	e9 25 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102281 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $67
c0102283:	6a 43                	push   $0x43
  jmp __alltraps
c0102285:	e9 1c 08 00 00       	jmp    c0102aa6 <__alltraps>

c010228a <vector68>:
.globl vector68
vector68:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $68
c010228c:	6a 44                	push   $0x44
  jmp __alltraps
c010228e:	e9 13 08 00 00       	jmp    c0102aa6 <__alltraps>

c0102293 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $69
c0102295:	6a 45                	push   $0x45
  jmp __alltraps
c0102297:	e9 0a 08 00 00       	jmp    c0102aa6 <__alltraps>

c010229c <vector70>:
.globl vector70
vector70:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $70
c010229e:	6a 46                	push   $0x46
  jmp __alltraps
c01022a0:	e9 01 08 00 00       	jmp    c0102aa6 <__alltraps>

c01022a5 <vector71>:
.globl vector71
vector71:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $71
c01022a7:	6a 47                	push   $0x47
  jmp __alltraps
c01022a9:	e9 f8 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022ae <vector72>:
.globl vector72
vector72:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $72
c01022b0:	6a 48                	push   $0x48
  jmp __alltraps
c01022b2:	e9 ef 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022b7 <vector73>:
.globl vector73
vector73:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $73
c01022b9:	6a 49                	push   $0x49
  jmp __alltraps
c01022bb:	e9 e6 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022c0 <vector74>:
.globl vector74
vector74:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $74
c01022c2:	6a 4a                	push   $0x4a
  jmp __alltraps
c01022c4:	e9 dd 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022c9 <vector75>:
.globl vector75
vector75:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $75
c01022cb:	6a 4b                	push   $0x4b
  jmp __alltraps
c01022cd:	e9 d4 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022d2 <vector76>:
.globl vector76
vector76:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $76
c01022d4:	6a 4c                	push   $0x4c
  jmp __alltraps
c01022d6:	e9 cb 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022db <vector77>:
.globl vector77
vector77:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $77
c01022dd:	6a 4d                	push   $0x4d
  jmp __alltraps
c01022df:	e9 c2 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022e4 <vector78>:
.globl vector78
vector78:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $78
c01022e6:	6a 4e                	push   $0x4e
  jmp __alltraps
c01022e8:	e9 b9 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022ed <vector79>:
.globl vector79
vector79:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $79
c01022ef:	6a 4f                	push   $0x4f
  jmp __alltraps
c01022f1:	e9 b0 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022f6 <vector80>:
.globl vector80
vector80:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $80
c01022f8:	6a 50                	push   $0x50
  jmp __alltraps
c01022fa:	e9 a7 07 00 00       	jmp    c0102aa6 <__alltraps>

c01022ff <vector81>:
.globl vector81
vector81:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $81
c0102301:	6a 51                	push   $0x51
  jmp __alltraps
c0102303:	e9 9e 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102308 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $82
c010230a:	6a 52                	push   $0x52
  jmp __alltraps
c010230c:	e9 95 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102311 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $83
c0102313:	6a 53                	push   $0x53
  jmp __alltraps
c0102315:	e9 8c 07 00 00       	jmp    c0102aa6 <__alltraps>

c010231a <vector84>:
.globl vector84
vector84:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $84
c010231c:	6a 54                	push   $0x54
  jmp __alltraps
c010231e:	e9 83 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102323 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $85
c0102325:	6a 55                	push   $0x55
  jmp __alltraps
c0102327:	e9 7a 07 00 00       	jmp    c0102aa6 <__alltraps>

c010232c <vector86>:
.globl vector86
vector86:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $86
c010232e:	6a 56                	push   $0x56
  jmp __alltraps
c0102330:	e9 71 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102335 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $87
c0102337:	6a 57                	push   $0x57
  jmp __alltraps
c0102339:	e9 68 07 00 00       	jmp    c0102aa6 <__alltraps>

c010233e <vector88>:
.globl vector88
vector88:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $88
c0102340:	6a 58                	push   $0x58
  jmp __alltraps
c0102342:	e9 5f 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102347 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $89
c0102349:	6a 59                	push   $0x59
  jmp __alltraps
c010234b:	e9 56 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102350 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $90
c0102352:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102354:	e9 4d 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102359 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $91
c010235b:	6a 5b                	push   $0x5b
  jmp __alltraps
c010235d:	e9 44 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102362 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $92
c0102364:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102366:	e9 3b 07 00 00       	jmp    c0102aa6 <__alltraps>

c010236b <vector93>:
.globl vector93
vector93:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $93
c010236d:	6a 5d                	push   $0x5d
  jmp __alltraps
c010236f:	e9 32 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102374 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $94
c0102376:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102378:	e9 29 07 00 00       	jmp    c0102aa6 <__alltraps>

c010237d <vector95>:
.globl vector95
vector95:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $95
c010237f:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102381:	e9 20 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102386 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $96
c0102388:	6a 60                	push   $0x60
  jmp __alltraps
c010238a:	e9 17 07 00 00       	jmp    c0102aa6 <__alltraps>

c010238f <vector97>:
.globl vector97
vector97:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $97
c0102391:	6a 61                	push   $0x61
  jmp __alltraps
c0102393:	e9 0e 07 00 00       	jmp    c0102aa6 <__alltraps>

c0102398 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $98
c010239a:	6a 62                	push   $0x62
  jmp __alltraps
c010239c:	e9 05 07 00 00       	jmp    c0102aa6 <__alltraps>

c01023a1 <vector99>:
.globl vector99
vector99:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $99
c01023a3:	6a 63                	push   $0x63
  jmp __alltraps
c01023a5:	e9 fc 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023aa <vector100>:
.globl vector100
vector100:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $100
c01023ac:	6a 64                	push   $0x64
  jmp __alltraps
c01023ae:	e9 f3 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023b3 <vector101>:
.globl vector101
vector101:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $101
c01023b5:	6a 65                	push   $0x65
  jmp __alltraps
c01023b7:	e9 ea 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023bc <vector102>:
.globl vector102
vector102:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $102
c01023be:	6a 66                	push   $0x66
  jmp __alltraps
c01023c0:	e9 e1 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023c5 <vector103>:
.globl vector103
vector103:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $103
c01023c7:	6a 67                	push   $0x67
  jmp __alltraps
c01023c9:	e9 d8 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023ce <vector104>:
.globl vector104
vector104:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $104
c01023d0:	6a 68                	push   $0x68
  jmp __alltraps
c01023d2:	e9 cf 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023d7 <vector105>:
.globl vector105
vector105:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $105
c01023d9:	6a 69                	push   $0x69
  jmp __alltraps
c01023db:	e9 c6 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023e0 <vector106>:
.globl vector106
vector106:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $106
c01023e2:	6a 6a                	push   $0x6a
  jmp __alltraps
c01023e4:	e9 bd 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023e9 <vector107>:
.globl vector107
vector107:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $107
c01023eb:	6a 6b                	push   $0x6b
  jmp __alltraps
c01023ed:	e9 b4 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023f2 <vector108>:
.globl vector108
vector108:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $108
c01023f4:	6a 6c                	push   $0x6c
  jmp __alltraps
c01023f6:	e9 ab 06 00 00       	jmp    c0102aa6 <__alltraps>

c01023fb <vector109>:
.globl vector109
vector109:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $109
c01023fd:	6a 6d                	push   $0x6d
  jmp __alltraps
c01023ff:	e9 a2 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102404 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $110
c0102406:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102408:	e9 99 06 00 00       	jmp    c0102aa6 <__alltraps>

c010240d <vector111>:
.globl vector111
vector111:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $111
c010240f:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102411:	e9 90 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102416 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $112
c0102418:	6a 70                	push   $0x70
  jmp __alltraps
c010241a:	e9 87 06 00 00       	jmp    c0102aa6 <__alltraps>

c010241f <vector113>:
.globl vector113
vector113:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $113
c0102421:	6a 71                	push   $0x71
  jmp __alltraps
c0102423:	e9 7e 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102428 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $114
c010242a:	6a 72                	push   $0x72
  jmp __alltraps
c010242c:	e9 75 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102431 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $115
c0102433:	6a 73                	push   $0x73
  jmp __alltraps
c0102435:	e9 6c 06 00 00       	jmp    c0102aa6 <__alltraps>

c010243a <vector116>:
.globl vector116
vector116:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $116
c010243c:	6a 74                	push   $0x74
  jmp __alltraps
c010243e:	e9 63 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102443 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $117
c0102445:	6a 75                	push   $0x75
  jmp __alltraps
c0102447:	e9 5a 06 00 00       	jmp    c0102aa6 <__alltraps>

c010244c <vector118>:
.globl vector118
vector118:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $118
c010244e:	6a 76                	push   $0x76
  jmp __alltraps
c0102450:	e9 51 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102455 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $119
c0102457:	6a 77                	push   $0x77
  jmp __alltraps
c0102459:	e9 48 06 00 00       	jmp    c0102aa6 <__alltraps>

c010245e <vector120>:
.globl vector120
vector120:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $120
c0102460:	6a 78                	push   $0x78
  jmp __alltraps
c0102462:	e9 3f 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102467 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $121
c0102469:	6a 79                	push   $0x79
  jmp __alltraps
c010246b:	e9 36 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102470 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $122
c0102472:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102474:	e9 2d 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102479 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $123
c010247b:	6a 7b                	push   $0x7b
  jmp __alltraps
c010247d:	e9 24 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102482 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $124
c0102484:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102486:	e9 1b 06 00 00       	jmp    c0102aa6 <__alltraps>

c010248b <vector125>:
.globl vector125
vector125:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $125
c010248d:	6a 7d                	push   $0x7d
  jmp __alltraps
c010248f:	e9 12 06 00 00       	jmp    c0102aa6 <__alltraps>

c0102494 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $126
c0102496:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102498:	e9 09 06 00 00       	jmp    c0102aa6 <__alltraps>

c010249d <vector127>:
.globl vector127
vector127:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $127
c010249f:	6a 7f                	push   $0x7f
  jmp __alltraps
c01024a1:	e9 00 06 00 00       	jmp    c0102aa6 <__alltraps>

c01024a6 <vector128>:
.globl vector128
vector128:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $128
c01024a8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01024ad:	e9 f4 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024b2 <vector129>:
.globl vector129
vector129:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $129
c01024b4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01024b9:	e9 e8 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024be <vector130>:
.globl vector130
vector130:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $130
c01024c0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01024c5:	e9 dc 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024ca <vector131>:
.globl vector131
vector131:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $131
c01024cc:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01024d1:	e9 d0 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024d6 <vector132>:
.globl vector132
vector132:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $132
c01024d8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01024dd:	e9 c4 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024e2 <vector133>:
.globl vector133
vector133:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $133
c01024e4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01024e9:	e9 b8 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024ee <vector134>:
.globl vector134
vector134:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $134
c01024f0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01024f5:	e9 ac 05 00 00       	jmp    c0102aa6 <__alltraps>

c01024fa <vector135>:
.globl vector135
vector135:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $135
c01024fc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102501:	e9 a0 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102506 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $136
c0102508:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010250d:	e9 94 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102512 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $137
c0102514:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102519:	e9 88 05 00 00       	jmp    c0102aa6 <__alltraps>

c010251e <vector138>:
.globl vector138
vector138:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $138
c0102520:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102525:	e9 7c 05 00 00       	jmp    c0102aa6 <__alltraps>

c010252a <vector139>:
.globl vector139
vector139:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $139
c010252c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102531:	e9 70 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102536 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $140
c0102538:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010253d:	e9 64 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102542 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $141
c0102544:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102549:	e9 58 05 00 00       	jmp    c0102aa6 <__alltraps>

c010254e <vector142>:
.globl vector142
vector142:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $142
c0102550:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102555:	e9 4c 05 00 00       	jmp    c0102aa6 <__alltraps>

c010255a <vector143>:
.globl vector143
vector143:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $143
c010255c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102561:	e9 40 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102566 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $144
c0102568:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010256d:	e9 34 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102572 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $145
c0102574:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102579:	e9 28 05 00 00       	jmp    c0102aa6 <__alltraps>

c010257e <vector146>:
.globl vector146
vector146:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $146
c0102580:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102585:	e9 1c 05 00 00       	jmp    c0102aa6 <__alltraps>

c010258a <vector147>:
.globl vector147
vector147:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $147
c010258c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102591:	e9 10 05 00 00       	jmp    c0102aa6 <__alltraps>

c0102596 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $148
c0102598:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010259d:	e9 04 05 00 00       	jmp    c0102aa6 <__alltraps>

c01025a2 <vector149>:
.globl vector149
vector149:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $149
c01025a4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01025a9:	e9 f8 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025ae <vector150>:
.globl vector150
vector150:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $150
c01025b0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01025b5:	e9 ec 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025ba <vector151>:
.globl vector151
vector151:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $151
c01025bc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01025c1:	e9 e0 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025c6 <vector152>:
.globl vector152
vector152:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $152
c01025c8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01025cd:	e9 d4 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025d2 <vector153>:
.globl vector153
vector153:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $153
c01025d4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01025d9:	e9 c8 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025de <vector154>:
.globl vector154
vector154:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $154
c01025e0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01025e5:	e9 bc 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025ea <vector155>:
.globl vector155
vector155:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $155
c01025ec:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01025f1:	e9 b0 04 00 00       	jmp    c0102aa6 <__alltraps>

c01025f6 <vector156>:
.globl vector156
vector156:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $156
c01025f8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01025fd:	e9 a4 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102602 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $157
c0102604:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102609:	e9 98 04 00 00       	jmp    c0102aa6 <__alltraps>

c010260e <vector158>:
.globl vector158
vector158:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $158
c0102610:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102615:	e9 8c 04 00 00       	jmp    c0102aa6 <__alltraps>

c010261a <vector159>:
.globl vector159
vector159:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $159
c010261c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102621:	e9 80 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102626 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $160
c0102628:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010262d:	e9 74 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102632 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $161
c0102634:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102639:	e9 68 04 00 00       	jmp    c0102aa6 <__alltraps>

c010263e <vector162>:
.globl vector162
vector162:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $162
c0102640:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102645:	e9 5c 04 00 00       	jmp    c0102aa6 <__alltraps>

c010264a <vector163>:
.globl vector163
vector163:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $163
c010264c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102651:	e9 50 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102656 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $164
c0102658:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010265d:	e9 44 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102662 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $165
c0102664:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102669:	e9 38 04 00 00       	jmp    c0102aa6 <__alltraps>

c010266e <vector166>:
.globl vector166
vector166:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $166
c0102670:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102675:	e9 2c 04 00 00       	jmp    c0102aa6 <__alltraps>

c010267a <vector167>:
.globl vector167
vector167:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $167
c010267c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102681:	e9 20 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102686 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $168
c0102688:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010268d:	e9 14 04 00 00       	jmp    c0102aa6 <__alltraps>

c0102692 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $169
c0102694:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102699:	e9 08 04 00 00       	jmp    c0102aa6 <__alltraps>

c010269e <vector170>:
.globl vector170
vector170:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $170
c01026a0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01026a5:	e9 fc 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026aa <vector171>:
.globl vector171
vector171:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $171
c01026ac:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01026b1:	e9 f0 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026b6 <vector172>:
.globl vector172
vector172:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $172
c01026b8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01026bd:	e9 e4 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026c2 <vector173>:
.globl vector173
vector173:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $173
c01026c4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01026c9:	e9 d8 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026ce <vector174>:
.globl vector174
vector174:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $174
c01026d0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01026d5:	e9 cc 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026da <vector175>:
.globl vector175
vector175:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $175
c01026dc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01026e1:	e9 c0 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026e6 <vector176>:
.globl vector176
vector176:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $176
c01026e8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01026ed:	e9 b4 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026f2 <vector177>:
.globl vector177
vector177:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $177
c01026f4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01026f9:	e9 a8 03 00 00       	jmp    c0102aa6 <__alltraps>

c01026fe <vector178>:
.globl vector178
vector178:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $178
c0102700:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102705:	e9 9c 03 00 00       	jmp    c0102aa6 <__alltraps>

c010270a <vector179>:
.globl vector179
vector179:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $179
c010270c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102711:	e9 90 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102716 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $180
c0102718:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010271d:	e9 84 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102722 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $181
c0102724:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102729:	e9 78 03 00 00       	jmp    c0102aa6 <__alltraps>

c010272e <vector182>:
.globl vector182
vector182:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $182
c0102730:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102735:	e9 6c 03 00 00       	jmp    c0102aa6 <__alltraps>

c010273a <vector183>:
.globl vector183
vector183:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $183
c010273c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102741:	e9 60 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102746 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $184
c0102748:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010274d:	e9 54 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102752 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $185
c0102754:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102759:	e9 48 03 00 00       	jmp    c0102aa6 <__alltraps>

c010275e <vector186>:
.globl vector186
vector186:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $186
c0102760:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102765:	e9 3c 03 00 00       	jmp    c0102aa6 <__alltraps>

c010276a <vector187>:
.globl vector187
vector187:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $187
c010276c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102771:	e9 30 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102776 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $188
c0102778:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010277d:	e9 24 03 00 00       	jmp    c0102aa6 <__alltraps>

c0102782 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $189
c0102784:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102789:	e9 18 03 00 00       	jmp    c0102aa6 <__alltraps>

c010278e <vector190>:
.globl vector190
vector190:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $190
c0102790:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102795:	e9 0c 03 00 00       	jmp    c0102aa6 <__alltraps>

c010279a <vector191>:
.globl vector191
vector191:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $191
c010279c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01027a1:	e9 00 03 00 00       	jmp    c0102aa6 <__alltraps>

c01027a6 <vector192>:
.globl vector192
vector192:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $192
c01027a8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01027ad:	e9 f4 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027b2 <vector193>:
.globl vector193
vector193:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $193
c01027b4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01027b9:	e9 e8 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027be <vector194>:
.globl vector194
vector194:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $194
c01027c0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01027c5:	e9 dc 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027ca <vector195>:
.globl vector195
vector195:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $195
c01027cc:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01027d1:	e9 d0 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027d6 <vector196>:
.globl vector196
vector196:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $196
c01027d8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01027dd:	e9 c4 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027e2 <vector197>:
.globl vector197
vector197:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $197
c01027e4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01027e9:	e9 b8 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027ee <vector198>:
.globl vector198
vector198:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $198
c01027f0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01027f5:	e9 ac 02 00 00       	jmp    c0102aa6 <__alltraps>

c01027fa <vector199>:
.globl vector199
vector199:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $199
c01027fc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102801:	e9 a0 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102806 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $200
c0102808:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010280d:	e9 94 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102812 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102812:	6a 00                	push   $0x0
  pushl $201
c0102814:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102819:	e9 88 02 00 00       	jmp    c0102aa6 <__alltraps>

c010281e <vector202>:
.globl vector202
vector202:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $202
c0102820:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102825:	e9 7c 02 00 00       	jmp    c0102aa6 <__alltraps>

c010282a <vector203>:
.globl vector203
vector203:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $203
c010282c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102831:	e9 70 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102836 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102836:	6a 00                	push   $0x0
  pushl $204
c0102838:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010283d:	e9 64 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102842 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $205
c0102844:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102849:	e9 58 02 00 00       	jmp    c0102aa6 <__alltraps>

c010284e <vector206>:
.globl vector206
vector206:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $206
c0102850:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102855:	e9 4c 02 00 00       	jmp    c0102aa6 <__alltraps>

c010285a <vector207>:
.globl vector207
vector207:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $207
c010285c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102861:	e9 40 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102866 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $208
c0102868:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010286d:	e9 34 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102872 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $209
c0102874:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102879:	e9 28 02 00 00       	jmp    c0102aa6 <__alltraps>

c010287e <vector210>:
.globl vector210
vector210:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $210
c0102880:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102885:	e9 1c 02 00 00       	jmp    c0102aa6 <__alltraps>

c010288a <vector211>:
.globl vector211
vector211:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $211
c010288c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102891:	e9 10 02 00 00       	jmp    c0102aa6 <__alltraps>

c0102896 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $212
c0102898:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010289d:	e9 04 02 00 00       	jmp    c0102aa6 <__alltraps>

c01028a2 <vector213>:
.globl vector213
vector213:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $213
c01028a4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01028a9:	e9 f8 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028ae <vector214>:
.globl vector214
vector214:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $214
c01028b0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01028b5:	e9 ec 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028ba <vector215>:
.globl vector215
vector215:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $215
c01028bc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01028c1:	e9 e0 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028c6 <vector216>:
.globl vector216
vector216:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $216
c01028c8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01028cd:	e9 d4 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028d2 <vector217>:
.globl vector217
vector217:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $217
c01028d4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01028d9:	e9 c8 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028de <vector218>:
.globl vector218
vector218:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $218
c01028e0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01028e5:	e9 bc 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028ea <vector219>:
.globl vector219
vector219:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $219
c01028ec:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01028f1:	e9 b0 01 00 00       	jmp    c0102aa6 <__alltraps>

c01028f6 <vector220>:
.globl vector220
vector220:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $220
c01028f8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01028fd:	e9 a4 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102902 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $221
c0102904:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102909:	e9 98 01 00 00       	jmp    c0102aa6 <__alltraps>

c010290e <vector222>:
.globl vector222
vector222:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $222
c0102910:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102915:	e9 8c 01 00 00       	jmp    c0102aa6 <__alltraps>

c010291a <vector223>:
.globl vector223
vector223:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $223
c010291c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102921:	e9 80 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102926 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $224
c0102928:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010292d:	e9 74 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102932 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $225
c0102934:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102939:	e9 68 01 00 00       	jmp    c0102aa6 <__alltraps>

c010293e <vector226>:
.globl vector226
vector226:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $226
c0102940:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102945:	e9 5c 01 00 00       	jmp    c0102aa6 <__alltraps>

c010294a <vector227>:
.globl vector227
vector227:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $227
c010294c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102951:	e9 50 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102956 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $228
c0102958:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010295d:	e9 44 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102962 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $229
c0102964:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102969:	e9 38 01 00 00       	jmp    c0102aa6 <__alltraps>

c010296e <vector230>:
.globl vector230
vector230:
  pushl $0
c010296e:	6a 00                	push   $0x0
  pushl $230
c0102970:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102975:	e9 2c 01 00 00       	jmp    c0102aa6 <__alltraps>

c010297a <vector231>:
.globl vector231
vector231:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $231
c010297c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102981:	e9 20 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102986 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $232
c0102988:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010298d:	e9 14 01 00 00       	jmp    c0102aa6 <__alltraps>

c0102992 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $233
c0102994:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102999:	e9 08 01 00 00       	jmp    c0102aa6 <__alltraps>

c010299e <vector234>:
.globl vector234
vector234:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $234
c01029a0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01029a5:	e9 fc 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029aa <vector235>:
.globl vector235
vector235:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $235
c01029ac:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01029b1:	e9 f0 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029b6 <vector236>:
.globl vector236
vector236:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $236
c01029b8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01029bd:	e9 e4 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029c2 <vector237>:
.globl vector237
vector237:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $237
c01029c4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01029c9:	e9 d8 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029ce <vector238>:
.globl vector238
vector238:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $238
c01029d0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01029d5:	e9 cc 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029da <vector239>:
.globl vector239
vector239:
  pushl $0
c01029da:	6a 00                	push   $0x0
  pushl $239
c01029dc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01029e1:	e9 c0 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029e6 <vector240>:
.globl vector240
vector240:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $240
c01029e8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01029ed:	e9 b4 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029f2 <vector241>:
.globl vector241
vector241:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $241
c01029f4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01029f9:	e9 a8 00 00 00       	jmp    c0102aa6 <__alltraps>

c01029fe <vector242>:
.globl vector242
vector242:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $242
c0102a00:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102a05:	e9 9c 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a0a <vector243>:
.globl vector243
vector243:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $243
c0102a0c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102a11:	e9 90 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a16 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $244
c0102a18:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102a1d:	e9 84 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a22 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $245
c0102a24:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102a29:	e9 78 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a2e <vector246>:
.globl vector246
vector246:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $246
c0102a30:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102a35:	e9 6c 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a3a <vector247>:
.globl vector247
vector247:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $247
c0102a3c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102a41:	e9 60 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a46 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $248
c0102a48:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102a4d:	e9 54 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a52 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $249
c0102a54:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102a59:	e9 48 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a5e <vector250>:
.globl vector250
vector250:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $250
c0102a60:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102a65:	e9 3c 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a6a <vector251>:
.globl vector251
vector251:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $251
c0102a6c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102a71:	e9 30 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a76 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $252
c0102a78:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102a7d:	e9 24 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a82 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $253
c0102a84:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102a89:	e9 18 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a8e <vector254>:
.globl vector254
vector254:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $254
c0102a90:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a95:	e9 0c 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102a9a <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $255
c0102a9c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102aa1:	e9 00 00 00 00       	jmp    c0102aa6 <__alltraps>

c0102aa6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102aa6:	1e                   	push   %ds
    pushl %es
c0102aa7:	06                   	push   %es
    pushl %fs
c0102aa8:	0f a0                	push   %fs
    pushl %gs
c0102aaa:	0f a8                	push   %gs
    pushal
c0102aac:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102aad:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102ab2:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102ab4:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102ab6:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102ab7:	e8 63 f5 ff ff       	call   c010201f <trap>

    # pop the pushed stack pointer
    popl %esp
c0102abc:	5c                   	pop    %esp

c0102abd <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102abd:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102abe:	0f a9                	pop    %gs
    popl %fs
c0102ac0:	0f a1                	pop    %fs
    popl %es
c0102ac2:	07                   	pop    %es
    popl %ds
c0102ac3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102ac4:	83 c4 08             	add    $0x8,%esp
    iret
c0102ac7:	cf                   	iret   

c0102ac8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102ac8:	55                   	push   %ebp
c0102ac9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ace:	8b 15 58 99 11 c0    	mov    0xc0119958,%edx
c0102ad4:	29 d0                	sub    %edx,%eax
c0102ad6:	c1 f8 02             	sar    $0x2,%eax
c0102ad9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102adf:	5d                   	pop    %ebp
c0102ae0:	c3                   	ret    

c0102ae1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102ae1:	55                   	push   %ebp
c0102ae2:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102ae4:	ff 75 08             	pushl  0x8(%ebp)
c0102ae7:	e8 dc ff ff ff       	call   c0102ac8 <page2ppn>
c0102aec:	83 c4 04             	add    $0x4,%esp
c0102aef:	c1 e0 0c             	shl    $0xc,%eax
}
c0102af2:	c9                   	leave  
c0102af3:	c3                   	ret    

c0102af4 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102af4:	55                   	push   %ebp
c0102af5:	89 e5                	mov    %esp,%ebp
c0102af7:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afd:	c1 e8 0c             	shr    $0xc,%eax
c0102b00:	89 c2                	mov    %eax,%edx
c0102b02:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0102b07:	39 c2                	cmp    %eax,%edx
c0102b09:	72 14                	jb     c0102b1f <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102b0b:	83 ec 04             	sub    $0x4,%esp
c0102b0e:	68 70 64 10 c0       	push   $0xc0106470
c0102b13:	6a 5a                	push   $0x5a
c0102b15:	68 8f 64 10 c0       	push   $0xc010648f
c0102b1a:	e8 be d8 ff ff       	call   c01003dd <__panic>
    }
    return &pages[PPN(pa)];
c0102b1f:	8b 0d 58 99 11 c0    	mov    0xc0119958,%ecx
c0102b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b28:	c1 e8 0c             	shr    $0xc,%eax
c0102b2b:	89 c2                	mov    %eax,%edx
c0102b2d:	89 d0                	mov    %edx,%eax
c0102b2f:	c1 e0 02             	shl    $0x2,%eax
c0102b32:	01 d0                	add    %edx,%eax
c0102b34:	c1 e0 02             	shl    $0x2,%eax
c0102b37:	01 c8                	add    %ecx,%eax
}
c0102b39:	c9                   	leave  
c0102b3a:	c3                   	ret    

c0102b3b <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102b3b:	55                   	push   %ebp
c0102b3c:	89 e5                	mov    %esp,%ebp
c0102b3e:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0102b41:	ff 75 08             	pushl  0x8(%ebp)
c0102b44:	e8 98 ff ff ff       	call   c0102ae1 <page2pa>
c0102b49:	83 c4 04             	add    $0x4,%esp
c0102b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b52:	c1 e8 0c             	shr    $0xc,%eax
c0102b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b58:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0102b5d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102b60:	72 14                	jb     c0102b76 <page2kva+0x3b>
c0102b62:	ff 75 f4             	pushl  -0xc(%ebp)
c0102b65:	68 a0 64 10 c0       	push   $0xc01064a0
c0102b6a:	6a 61                	push   $0x61
c0102b6c:	68 8f 64 10 c0       	push   $0xc010648f
c0102b71:	e8 67 d8 ff ff       	call   c01003dd <__panic>
c0102b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b79:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102b7e:	c9                   	leave  
c0102b7f:	c3                   	ret    

c0102b80 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102b80:	55                   	push   %ebp
c0102b81:	89 e5                	mov    %esp,%ebp
c0102b83:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b89:	83 e0 01             	and    $0x1,%eax
c0102b8c:	85 c0                	test   %eax,%eax
c0102b8e:	75 14                	jne    c0102ba4 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102b90:	83 ec 04             	sub    $0x4,%esp
c0102b93:	68 c4 64 10 c0       	push   $0xc01064c4
c0102b98:	6a 6c                	push   $0x6c
c0102b9a:	68 8f 64 10 c0       	push   $0xc010648f
c0102b9f:	e8 39 d8 ff ff       	call   c01003dd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102bac:	83 ec 0c             	sub    $0xc,%esp
c0102baf:	50                   	push   %eax
c0102bb0:	e8 3f ff ff ff       	call   c0102af4 <pa2page>
c0102bb5:	83 c4 10             	add    $0x10,%esp
}
c0102bb8:	c9                   	leave  
c0102bb9:	c3                   	ret    

c0102bba <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102bba:	55                   	push   %ebp
c0102bbb:	89 e5                	mov    %esp,%ebp
c0102bbd:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102bc8:	83 ec 0c             	sub    $0xc,%esp
c0102bcb:	50                   	push   %eax
c0102bcc:	e8 23 ff ff ff       	call   c0102af4 <pa2page>
c0102bd1:	83 c4 10             	add    $0x10,%esp
}
c0102bd4:	c9                   	leave  
c0102bd5:	c3                   	ret    

c0102bd6 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102bd6:	55                   	push   %ebp
c0102bd7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdc:	8b 00                	mov    (%eax),%eax
}
c0102bde:	5d                   	pop    %ebp
c0102bdf:	c3                   	ret    

c0102be0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102be0:	55                   	push   %ebp
c0102be1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102be9:	89 10                	mov    %edx,(%eax)
}
c0102beb:	90                   	nop
c0102bec:	5d                   	pop    %ebp
c0102bed:	c3                   	ret    

c0102bee <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102bee:	55                   	push   %ebp
c0102bef:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf4:	8b 00                	mov    (%eax),%eax
c0102bf6:	8d 50 01             	lea    0x1(%eax),%edx
c0102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bfc:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c01:	8b 00                	mov    (%eax),%eax
}
c0102c03:	5d                   	pop    %ebp
c0102c04:	c3                   	ret    

c0102c05 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102c05:	55                   	push   %ebp
c0102c06:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c0b:	8b 00                	mov    (%eax),%eax
c0102c0d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c13:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c18:	8b 00                	mov    (%eax),%eax
}
c0102c1a:	5d                   	pop    %ebp
c0102c1b:	c3                   	ret    

c0102c1c <__intr_save>:
__intr_save(void) {
c0102c1c:	55                   	push   %ebp
c0102c1d:	89 e5                	mov    %esp,%ebp
c0102c1f:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102c22:	9c                   	pushf  
c0102c23:	58                   	pop    %eax
c0102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102c2a:	25 00 02 00 00       	and    $0x200,%eax
c0102c2f:	85 c0                	test   %eax,%eax
c0102c31:	74 0c                	je     c0102c3f <__intr_save+0x23>
        intr_disable();
c0102c33:	e8 4f ec ff ff       	call   c0101887 <intr_disable>
        return 1;
c0102c38:	b8 01 00 00 00       	mov    $0x1,%eax
c0102c3d:	eb 05                	jmp    c0102c44 <__intr_save+0x28>
    return 0;
c0102c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102c44:	c9                   	leave  
c0102c45:	c3                   	ret    

c0102c46 <__intr_restore>:
__intr_restore(bool flag) {
c0102c46:	55                   	push   %ebp
c0102c47:	89 e5                	mov    %esp,%ebp
c0102c49:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c50:	74 05                	je     c0102c57 <__intr_restore+0x11>
        intr_enable();
c0102c52:	e8 29 ec ff ff       	call   c0101880 <intr_enable>
}
c0102c57:	90                   	nop
c0102c58:	c9                   	leave  
c0102c59:	c3                   	ret    

c0102c5a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102c5a:	55                   	push   %ebp
c0102c5b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c60:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102c63:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c68:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102c6a:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c6f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102c71:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c76:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102c78:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c7d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102c7f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c84:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102c86:	ea 8d 2c 10 c0 08 00 	ljmp   $0x8,$0xc0102c8d
}
c0102c8d:	90                   	nop
c0102c8e:	5d                   	pop    %ebp
c0102c8f:	c3                   	ret    

c0102c90 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102c90:	55                   	push   %ebp
c0102c91:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c96:	a3 e4 98 11 c0       	mov    %eax,0xc01198e4
}
c0102c9b:	90                   	nop
c0102c9c:	5d                   	pop    %ebp
c0102c9d:	c3                   	ret    

c0102c9e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102c9e:	55                   	push   %ebp
c0102c9f:	89 e5                	mov    %esp,%ebp
c0102ca1:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102ca4:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0102ca9:	50                   	push   %eax
c0102caa:	e8 e1 ff ff ff       	call   c0102c90 <load_esp0>
c0102caf:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102cb2:	66 c7 05 e8 98 11 c0 	movw   $0x10,0xc01198e8
c0102cb9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102cbb:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0102cc2:	68 00 
c0102cc4:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0102cc9:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0102ccf:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0102cd4:	c1 e8 10             	shr    $0x10,%eax
c0102cd7:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0102cdc:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102ce3:	83 e0 f0             	and    $0xfffffff0,%eax
c0102ce6:	83 c8 09             	or     $0x9,%eax
c0102ce9:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102cee:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102cf5:	83 e0 ef             	and    $0xffffffef,%eax
c0102cf8:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102cfd:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102d04:	83 e0 9f             	and    $0xffffff9f,%eax
c0102d07:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102d0c:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0102d13:	83 c8 80             	or     $0xffffff80,%eax
c0102d16:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0102d1b:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102d22:	83 e0 f0             	and    $0xfffffff0,%eax
c0102d25:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102d2a:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102d31:	83 e0 ef             	and    $0xffffffef,%eax
c0102d34:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102d39:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102d40:	83 e0 df             	and    $0xffffffdf,%eax
c0102d43:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102d48:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102d4f:	83 c8 40             	or     $0x40,%eax
c0102d52:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102d57:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0102d5e:	83 e0 7f             	and    $0x7f,%eax
c0102d61:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0102d66:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0102d6b:	c1 e8 18             	shr    $0x18,%eax
c0102d6e:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102d73:	68 30 8a 11 c0       	push   $0xc0118a30
c0102d78:	e8 dd fe ff ff       	call   c0102c5a <lgdt>
c0102d7d:	83 c4 04             	add    $0x4,%esp
c0102d80:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102d86:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102d8a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102d8d:	90                   	nop
c0102d8e:	c9                   	leave  
c0102d8f:	c3                   	ret    

c0102d90 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102d90:	55                   	push   %ebp
c0102d91:	89 e5                	mov    %esp,%ebp
c0102d93:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102d96:	c7 05 50 99 11 c0 38 	movl   $0xc0106e38,0xc0119950
c0102d9d:	6e 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102da0:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102da5:	8b 00                	mov    (%eax),%eax
c0102da7:	83 ec 08             	sub    $0x8,%esp
c0102daa:	50                   	push   %eax
c0102dab:	68 f0 64 10 c0       	push   $0xc01064f0
c0102db0:	e8 c2 d4 ff ff       	call   c0100277 <cprintf>
c0102db5:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102db8:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102dbd:	8b 40 04             	mov    0x4(%eax),%eax
c0102dc0:	ff d0                	call   *%eax
}
c0102dc2:	90                   	nop
c0102dc3:	c9                   	leave  
c0102dc4:	c3                   	ret    

c0102dc5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102dc5:	55                   	push   %ebp
c0102dc6:	89 e5                	mov    %esp,%ebp
c0102dc8:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102dcb:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102dd0:	8b 40 08             	mov    0x8(%eax),%eax
c0102dd3:	83 ec 08             	sub    $0x8,%esp
c0102dd6:	ff 75 0c             	pushl  0xc(%ebp)
c0102dd9:	ff 75 08             	pushl  0x8(%ebp)
c0102ddc:	ff d0                	call   *%eax
c0102dde:	83 c4 10             	add    $0x10,%esp
}
c0102de1:	90                   	nop
c0102de2:	c9                   	leave  
c0102de3:	c3                   	ret    

c0102de4 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102de4:	55                   	push   %ebp
c0102de5:	89 e5                	mov    %esp,%ebp
c0102de7:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102dea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102df1:	e8 26 fe ff ff       	call   c0102c1c <__intr_save>
c0102df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102df9:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102dfe:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e01:	83 ec 0c             	sub    $0xc,%esp
c0102e04:	ff 75 08             	pushl  0x8(%ebp)
c0102e07:	ff d0                	call   *%eax
c0102e09:	83 c4 10             	add    $0x10,%esp
c0102e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102e0f:	83 ec 0c             	sub    $0xc,%esp
c0102e12:	ff 75 f0             	pushl  -0x10(%ebp)
c0102e15:	e8 2c fe ff ff       	call   c0102c46 <__intr_restore>
c0102e1a:	83 c4 10             	add    $0x10,%esp
    return page;
c0102e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102e20:	c9                   	leave  
c0102e21:	c3                   	ret    

c0102e22 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102e22:	55                   	push   %ebp
c0102e23:	89 e5                	mov    %esp,%ebp
c0102e25:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102e28:	e8 ef fd ff ff       	call   c0102c1c <__intr_save>
c0102e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102e30:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102e35:	8b 40 10             	mov    0x10(%eax),%eax
c0102e38:	83 ec 08             	sub    $0x8,%esp
c0102e3b:	ff 75 0c             	pushl  0xc(%ebp)
c0102e3e:	ff 75 08             	pushl  0x8(%ebp)
c0102e41:	ff d0                	call   *%eax
c0102e43:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102e46:	83 ec 0c             	sub    $0xc,%esp
c0102e49:	ff 75 f4             	pushl  -0xc(%ebp)
c0102e4c:	e8 f5 fd ff ff       	call   c0102c46 <__intr_restore>
c0102e51:	83 c4 10             	add    $0x10,%esp
}
c0102e54:	90                   	nop
c0102e55:	c9                   	leave  
c0102e56:	c3                   	ret    

c0102e57 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102e57:	55                   	push   %ebp
c0102e58:	89 e5                	mov    %esp,%ebp
c0102e5a:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102e5d:	e8 ba fd ff ff       	call   c0102c1c <__intr_save>
c0102e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102e65:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0102e6a:	8b 40 14             	mov    0x14(%eax),%eax
c0102e6d:	ff d0                	call   *%eax
c0102e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102e72:	83 ec 0c             	sub    $0xc,%esp
c0102e75:	ff 75 f4             	pushl  -0xc(%ebp)
c0102e78:	e8 c9 fd ff ff       	call   c0102c46 <__intr_restore>
c0102e7d:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102e83:	c9                   	leave  
c0102e84:	c3                   	ret    

c0102e85 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102e85:	55                   	push   %ebp
c0102e86:	89 e5                	mov    %esp,%ebp
c0102e88:	57                   	push   %edi
c0102e89:	56                   	push   %esi
c0102e8a:	53                   	push   %ebx
c0102e8b:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102e8e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102e95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102e9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102ea3:	83 ec 0c             	sub    $0xc,%esp
c0102ea6:	68 07 65 10 c0       	push   $0xc0106507
c0102eab:	e8 c7 d3 ff ff       	call   c0100277 <cprintf>
c0102eb0:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102eb3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102eba:	e9 fc 00 00 00       	jmp    c0102fbb <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102ebf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ec5:	89 d0                	mov    %edx,%eax
c0102ec7:	c1 e0 02             	shl    $0x2,%eax
c0102eca:	01 d0                	add    %edx,%eax
c0102ecc:	c1 e0 02             	shl    $0x2,%eax
c0102ecf:	01 c8                	add    %ecx,%eax
c0102ed1:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed4:	8b 40 04             	mov    0x4(%eax),%eax
c0102ed7:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102eda:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102edd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ee0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee3:	89 d0                	mov    %edx,%eax
c0102ee5:	c1 e0 02             	shl    $0x2,%eax
c0102ee8:	01 d0                	add    %edx,%eax
c0102eea:	c1 e0 02             	shl    $0x2,%eax
c0102eed:	01 c8                	add    %ecx,%eax
c0102eef:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ef2:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ef5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ef8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102efb:	01 c8                	add    %ecx,%eax
c0102efd:	11 da                	adc    %ebx,%edx
c0102eff:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f02:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102f05:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f0b:	89 d0                	mov    %edx,%eax
c0102f0d:	c1 e0 02             	shl    $0x2,%eax
c0102f10:	01 d0                	add    %edx,%eax
c0102f12:	c1 e0 02             	shl    $0x2,%eax
c0102f15:	01 c8                	add    %ecx,%eax
c0102f17:	83 c0 14             	add    $0x14,%eax
c0102f1a:	8b 00                	mov    (%eax),%eax
c0102f1c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102f1f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f22:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102f25:	83 c0 ff             	add    $0xffffffff,%eax
c0102f28:	83 d2 ff             	adc    $0xffffffff,%edx
c0102f2b:	89 c1                	mov    %eax,%ecx
c0102f2d:	89 d3                	mov    %edx,%ebx
c0102f2f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102f32:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102f35:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f38:	89 d0                	mov    %edx,%eax
c0102f3a:	c1 e0 02             	shl    $0x2,%eax
c0102f3d:	01 d0                	add    %edx,%eax
c0102f3f:	c1 e0 02             	shl    $0x2,%eax
c0102f42:	03 45 80             	add    -0x80(%ebp),%eax
c0102f45:	8b 50 10             	mov    0x10(%eax),%edx
c0102f48:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f4b:	ff 75 84             	pushl  -0x7c(%ebp)
c0102f4e:	53                   	push   %ebx
c0102f4f:	51                   	push   %ecx
c0102f50:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102f53:	ff 75 a0             	pushl  -0x60(%ebp)
c0102f56:	52                   	push   %edx
c0102f57:	50                   	push   %eax
c0102f58:	68 14 65 10 c0       	push   $0xc0106514
c0102f5d:	e8 15 d3 ff ff       	call   c0100277 <cprintf>
c0102f62:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102f65:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f68:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f6b:	89 d0                	mov    %edx,%eax
c0102f6d:	c1 e0 02             	shl    $0x2,%eax
c0102f70:	01 d0                	add    %edx,%eax
c0102f72:	c1 e0 02             	shl    $0x2,%eax
c0102f75:	01 c8                	add    %ecx,%eax
c0102f77:	83 c0 14             	add    $0x14,%eax
c0102f7a:	8b 00                	mov    (%eax),%eax
c0102f7c:	83 f8 01             	cmp    $0x1,%eax
c0102f7f:	75 36                	jne    c0102fb7 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f87:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102f8a:	77 2b                	ja     c0102fb7 <page_init+0x132>
c0102f8c:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102f8f:	72 05                	jb     c0102f96 <page_init+0x111>
c0102f91:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102f94:	73 21                	jae    c0102fb7 <page_init+0x132>
c0102f96:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102f9a:	77 1b                	ja     c0102fb7 <page_init+0x132>
c0102f9c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102fa0:	72 09                	jb     c0102fab <page_init+0x126>
c0102fa2:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102fa9:	77 0c                	ja     c0102fb7 <page_init+0x132>
                maxpa = end;
c0102fab:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fae:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102fb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102fb4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fb7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fbb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fbe:	8b 00                	mov    (%eax),%eax
c0102fc0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fc3:	0f 8c f6 fe ff ff    	jl     c0102ebf <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102fc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102fcd:	72 1d                	jb     c0102fec <page_init+0x167>
c0102fcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102fd3:	77 09                	ja     c0102fde <page_init+0x159>
c0102fd5:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102fdc:	76 0e                	jbe    c0102fec <page_init+0x167>
        maxpa = KMEMSIZE;
c0102fde:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ff2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ff6:	c1 ea 0c             	shr    $0xc,%edx
c0102ff9:	89 c1                	mov    %eax,%ecx
c0102ffb:	89 d3                	mov    %edx,%ebx
c0102ffd:	89 c8                	mov    %ecx,%eax
c0102fff:	a3 c0 98 11 c0       	mov    %eax,0xc01198c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103004:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c010300b:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
c0103010:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103013:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103016:	01 d0                	add    %edx,%eax
c0103018:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010301b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010301e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103023:	f7 75 c0             	divl   -0x40(%ebp)
c0103026:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103029:	29 d0                	sub    %edx,%eax
c010302b:	a3 58 99 11 c0       	mov    %eax,0xc0119958

    for (i = 0; i < npage; i ++) {
c0103030:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103037:	eb 2f                	jmp    c0103068 <page_init+0x1e3>
        SetPageReserved(pages + i);
c0103039:	8b 0d 58 99 11 c0    	mov    0xc0119958,%ecx
c010303f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103042:	89 d0                	mov    %edx,%eax
c0103044:	c1 e0 02             	shl    $0x2,%eax
c0103047:	01 d0                	add    %edx,%eax
c0103049:	c1 e0 02             	shl    $0x2,%eax
c010304c:	01 c8                	add    %ecx,%eax
c010304e:	83 c0 04             	add    $0x4,%eax
c0103051:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103058:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010305b:	8b 45 90             	mov    -0x70(%ebp),%eax
c010305e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103061:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103064:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103068:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010306b:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103070:	39 c2                	cmp    %eax,%edx
c0103072:	72 c5                	jb     c0103039 <page_init+0x1b4>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103074:	8b 15 c0 98 11 c0    	mov    0xc01198c0,%edx
c010307a:	89 d0                	mov    %edx,%eax
c010307c:	c1 e0 02             	shl    $0x2,%eax
c010307f:	01 d0                	add    %edx,%eax
c0103081:	c1 e0 02             	shl    $0x2,%eax
c0103084:	89 c2                	mov    %eax,%edx
c0103086:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c010308b:	01 d0                	add    %edx,%eax
c010308d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103090:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103097:	77 17                	ja     c01030b0 <page_init+0x22b>
c0103099:	ff 75 b8             	pushl  -0x48(%ebp)
c010309c:	68 44 65 10 c0       	push   $0xc0106544
c01030a1:	68 db 00 00 00       	push   $0xdb
c01030a6:	68 68 65 10 c0       	push   $0xc0106568
c01030ab:	e8 2d d3 ff ff       	call   c01003dd <__panic>
c01030b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01030b3:	05 00 00 00 40       	add    $0x40000000,%eax
c01030b8:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01030bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01030c2:	e9 71 01 00 00       	jmp    c0103238 <page_init+0x3b3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01030c7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030cd:	89 d0                	mov    %edx,%eax
c01030cf:	c1 e0 02             	shl    $0x2,%eax
c01030d2:	01 d0                	add    %edx,%eax
c01030d4:	c1 e0 02             	shl    $0x2,%eax
c01030d7:	01 c8                	add    %ecx,%eax
c01030d9:	8b 50 08             	mov    0x8(%eax),%edx
c01030dc:	8b 40 04             	mov    0x4(%eax),%eax
c01030df:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030e5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030eb:	89 d0                	mov    %edx,%eax
c01030ed:	c1 e0 02             	shl    $0x2,%eax
c01030f0:	01 d0                	add    %edx,%eax
c01030f2:	c1 e0 02             	shl    $0x2,%eax
c01030f5:	01 c8                	add    %ecx,%eax
c01030f7:	8b 48 0c             	mov    0xc(%eax),%ecx
c01030fa:	8b 58 10             	mov    0x10(%eax),%ebx
c01030fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103100:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103103:	01 c8                	add    %ecx,%eax
c0103105:	11 da                	adc    %ebx,%edx
c0103107:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010310a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010310d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103110:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103113:	89 d0                	mov    %edx,%eax
c0103115:	c1 e0 02             	shl    $0x2,%eax
c0103118:	01 d0                	add    %edx,%eax
c010311a:	c1 e0 02             	shl    $0x2,%eax
c010311d:	01 c8                	add    %ecx,%eax
c010311f:	83 c0 14             	add    $0x14,%eax
c0103122:	8b 00                	mov    (%eax),%eax
c0103124:	83 f8 01             	cmp    $0x1,%eax
c0103127:	0f 85 07 01 00 00    	jne    c0103234 <page_init+0x3af>
            if (begin < freemem) {
c010312d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103130:	ba 00 00 00 00       	mov    $0x0,%edx
c0103135:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103138:	77 17                	ja     c0103151 <page_init+0x2cc>
c010313a:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010313d:	72 05                	jb     c0103144 <page_init+0x2bf>
c010313f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103142:	73 0d                	jae    c0103151 <page_init+0x2cc>
                begin = freemem;
c0103144:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103147:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010314a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103151:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103155:	72 1d                	jb     c0103174 <page_init+0x2ef>
c0103157:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010315b:	77 09                	ja     c0103166 <page_init+0x2e1>
c010315d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103164:	76 0e                	jbe    c0103174 <page_init+0x2ef>
                end = KMEMSIZE;
c0103166:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010316d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103174:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103177:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010317a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010317d:	0f 87 b1 00 00 00    	ja     c0103234 <page_init+0x3af>
c0103183:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103186:	72 09                	jb     c0103191 <page_init+0x30c>
c0103188:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010318b:	0f 83 a3 00 00 00    	jae    c0103234 <page_init+0x3af>
                begin = ROUNDUP(begin, PGSIZE);
c0103191:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103198:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010319b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010319e:	01 d0                	add    %edx,%eax
c01031a0:	83 e8 01             	sub    $0x1,%eax
c01031a3:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01031a6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01031a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01031ae:	f7 75 b0             	divl   -0x50(%ebp)
c01031b1:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01031b4:	29 d0                	sub    %edx,%eax
c01031b6:	ba 00 00 00 00       	mov    $0x0,%edx
c01031bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01031be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01031c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031c4:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01031c7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01031ca:	ba 00 00 00 00       	mov    $0x0,%edx
c01031cf:	89 c3                	mov    %eax,%ebx
c01031d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01031d7:	89 de                	mov    %ebx,%esi
c01031d9:	89 d0                	mov    %edx,%eax
c01031db:	83 e0 00             	and    $0x0,%eax
c01031de:	89 c7                	mov    %eax,%edi
c01031e0:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01031e3:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01031e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031ec:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01031ef:	77 43                	ja     c0103234 <page_init+0x3af>
c01031f1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01031f4:	72 05                	jb     c01031fb <page_init+0x376>
c01031f6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01031f9:	73 39                	jae    c0103234 <page_init+0x3af>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01031fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103201:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103204:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103207:	89 c1                	mov    %eax,%ecx
c0103209:	89 d3                	mov    %edx,%ebx
c010320b:	89 c8                	mov    %ecx,%eax
c010320d:	89 da                	mov    %ebx,%edx
c010320f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103213:	c1 ea 0c             	shr    $0xc,%edx
c0103216:	89 c3                	mov    %eax,%ebx
c0103218:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010321b:	83 ec 0c             	sub    $0xc,%esp
c010321e:	50                   	push   %eax
c010321f:	e8 d0 f8 ff ff       	call   c0102af4 <pa2page>
c0103224:	83 c4 10             	add    $0x10,%esp
c0103227:	83 ec 08             	sub    $0x8,%esp
c010322a:	53                   	push   %ebx
c010322b:	50                   	push   %eax
c010322c:	e8 94 fb ff ff       	call   c0102dc5 <init_memmap>
c0103231:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103234:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103238:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010323b:	8b 00                	mov    (%eax),%eax
c010323d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103240:	0f 8c 81 fe ff ff    	jl     c01030c7 <page_init+0x242>
                }
            }
        }
    }
}
c0103246:	90                   	nop
c0103247:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010324a:	5b                   	pop    %ebx
c010324b:	5e                   	pop    %esi
c010324c:	5f                   	pop    %edi
c010324d:	5d                   	pop    %ebp
c010324e:	c3                   	ret    

c010324f <enable_paging>:

static void
enable_paging(void) {
c010324f:	55                   	push   %ebp
c0103250:	89 e5                	mov    %esp,%ebp
c0103252:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103255:	a1 54 99 11 c0       	mov    0xc0119954,%eax
c010325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103260:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103263:	0f 20 c0             	mov    %cr0,%eax
c0103266:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103269:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c010326c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010326f:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103276:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010327a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010327d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103280:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103283:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103286:	90                   	nop
c0103287:	c9                   	leave  
c0103288:	c3                   	ret    

c0103289 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103289:	55                   	push   %ebp
c010328a:	89 e5                	mov    %esp,%ebp
c010328c:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010328f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103292:	33 45 14             	xor    0x14(%ebp),%eax
c0103295:	25 ff 0f 00 00       	and    $0xfff,%eax
c010329a:	85 c0                	test   %eax,%eax
c010329c:	74 19                	je     c01032b7 <boot_map_segment+0x2e>
c010329e:	68 76 65 10 c0       	push   $0xc0106576
c01032a3:	68 8d 65 10 c0       	push   $0xc010658d
c01032a8:	68 04 01 00 00       	push   $0x104
c01032ad:	68 68 65 10 c0       	push   $0xc0106568
c01032b2:	e8 26 d1 ff ff       	call   c01003dd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01032b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01032be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032c1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01032c6:	89 c2                	mov    %eax,%edx
c01032c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01032cb:	01 c2                	add    %eax,%edx
c01032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d0:	01 d0                	add    %edx,%eax
c01032d2:	83 e8 01             	sub    $0x1,%eax
c01032d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032db:	ba 00 00 00 00       	mov    $0x0,%edx
c01032e0:	f7 75 f0             	divl   -0x10(%ebp)
c01032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032e6:	29 d0                	sub    %edx,%eax
c01032e8:	c1 e8 0c             	shr    $0xc,%eax
c01032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01032ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032fc:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01032ff:	8b 45 14             	mov    0x14(%ebp),%eax
c0103302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103308:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010330d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103310:	eb 57                	jmp    c0103369 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103312:	83 ec 04             	sub    $0x4,%esp
c0103315:	6a 01                	push   $0x1
c0103317:	ff 75 0c             	pushl  0xc(%ebp)
c010331a:	ff 75 08             	pushl  0x8(%ebp)
c010331d:	e8 98 01 00 00       	call   c01034ba <get_pte>
c0103322:	83 c4 10             	add    $0x10,%esp
c0103325:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103328:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010332c:	75 19                	jne    c0103347 <boot_map_segment+0xbe>
c010332e:	68 a2 65 10 c0       	push   $0xc01065a2
c0103333:	68 8d 65 10 c0       	push   $0xc010658d
c0103338:	68 0a 01 00 00       	push   $0x10a
c010333d:	68 68 65 10 c0       	push   $0xc0106568
c0103342:	e8 96 d0 ff ff       	call   c01003dd <__panic>
        *ptep = pa | PTE_P | perm;
c0103347:	8b 45 14             	mov    0x14(%ebp),%eax
c010334a:	0b 45 18             	or     0x18(%ebp),%eax
c010334d:	83 c8 01             	or     $0x1,%eax
c0103350:	89 c2                	mov    %eax,%edx
c0103352:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103355:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103357:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010335b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103362:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010336d:	75 a3                	jne    c0103312 <boot_map_segment+0x89>
    }
}
c010336f:	90                   	nop
c0103370:	c9                   	leave  
c0103371:	c3                   	ret    

c0103372 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103372:	55                   	push   %ebp
c0103373:	89 e5                	mov    %esp,%ebp
c0103375:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103378:	83 ec 0c             	sub    $0xc,%esp
c010337b:	6a 01                	push   $0x1
c010337d:	e8 62 fa ff ff       	call   c0102de4 <alloc_pages>
c0103382:	83 c4 10             	add    $0x10,%esp
c0103385:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010338c:	75 17                	jne    c01033a5 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010338e:	83 ec 04             	sub    $0x4,%esp
c0103391:	68 af 65 10 c0       	push   $0xc01065af
c0103396:	68 16 01 00 00       	push   $0x116
c010339b:	68 68 65 10 c0       	push   $0xc0106568
c01033a0:	e8 38 d0 ff ff       	call   c01003dd <__panic>
    }
    return page2kva(p);
c01033a5:	83 ec 0c             	sub    $0xc,%esp
c01033a8:	ff 75 f4             	pushl  -0xc(%ebp)
c01033ab:	e8 8b f7 ff ff       	call   c0102b3b <page2kva>
c01033b0:	83 c4 10             	add    $0x10,%esp
}
c01033b3:	c9                   	leave  
c01033b4:	c3                   	ret    

c01033b5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01033b5:	55                   	push   %ebp
c01033b6:	89 e5                	mov    %esp,%ebp
c01033b8:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01033bb:	e8 d0 f9 ff ff       	call   c0102d90 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01033c0:	e8 c0 fa ff ff       	call   c0102e85 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01033c5:	e8 72 04 00 00       	call   c010383c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01033ca:	e8 a3 ff ff ff       	call   c0103372 <boot_alloc_page>
c01033cf:	a3 c4 98 11 c0       	mov    %eax,0xc01198c4
    memset(boot_pgdir, 0, PGSIZE);
c01033d4:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01033d9:	83 ec 04             	sub    $0x4,%esp
c01033dc:	68 00 10 00 00       	push   $0x1000
c01033e1:	6a 00                	push   $0x0
c01033e3:	50                   	push   %eax
c01033e4:	e8 ab 21 00 00       	call   c0105594 <memset>
c01033e9:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01033ec:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01033f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033f4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01033fb:	77 17                	ja     c0103414 <pmm_init+0x5f>
c01033fd:	ff 75 f4             	pushl  -0xc(%ebp)
c0103400:	68 44 65 10 c0       	push   $0xc0106544
c0103405:	68 30 01 00 00       	push   $0x130
c010340a:	68 68 65 10 c0       	push   $0xc0106568
c010340f:	e8 c9 cf ff ff       	call   c01003dd <__panic>
c0103414:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103417:	05 00 00 00 40       	add    $0x40000000,%eax
c010341c:	a3 54 99 11 c0       	mov    %eax,0xc0119954

    check_pgdir();
c0103421:	e8 39 04 00 00       	call   c010385f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103426:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010342b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010342e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103435:	77 17                	ja     c010344e <pmm_init+0x99>
c0103437:	ff 75 f0             	pushl  -0x10(%ebp)
c010343a:	68 44 65 10 c0       	push   $0xc0106544
c010343f:	68 38 01 00 00       	push   $0x138
c0103444:	68 68 65 10 c0       	push   $0xc0106568
c0103449:	e8 8f cf ff ff       	call   c01003dd <__panic>
c010344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103451:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103457:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010345c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103461:	83 ca 03             	or     $0x3,%edx
c0103464:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103466:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010346b:	83 ec 0c             	sub    $0xc,%esp
c010346e:	6a 02                	push   $0x2
c0103470:	6a 00                	push   $0x0
c0103472:	68 00 00 00 38       	push   $0x38000000
c0103477:	68 00 00 00 c0       	push   $0xc0000000
c010347c:	50                   	push   %eax
c010347d:	e8 07 fe ff ff       	call   c0103289 <boot_map_segment>
c0103482:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103485:	8b 15 c4 98 11 c0    	mov    0xc01198c4,%edx
c010348b:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103490:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103496:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103498:	e8 b2 fd ff ff       	call   c010324f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010349d:	e8 fc f7 ff ff       	call   c0102c9e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01034a2:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01034a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01034ad:	e8 13 09 00 00       	call   c0103dc5 <check_boot_pgdir>

    print_pgdir();
c01034b2:	e8 09 0d 00 00       	call   c01041c0 <print_pgdir>

}
c01034b7:	90                   	nop
c01034b8:	c9                   	leave  
c01034b9:	c3                   	ret    

c01034ba <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01034ba:	55                   	push   %ebp
c01034bb:	89 e5                	mov    %esp,%ebp
c01034bd:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la); // 获取到页目录表中给定线性地址对应到的页目录项
c01034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034c3:	c1 e8 16             	shr    $0x16,%eax
c01034c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01034cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01034d0:	01 d0                	add    %edx,%eax
c01034d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
pte_t *ptep = ((pte_t *) (KADDR(*pdep & ~0XFFF)) + PTX(la)); // 从找到的页目录项中查询到线性地址对应到的页表中的页表项，即页表基址加上线性地址的中的offset（第12...21位，从0开始）
c01034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d8:	8b 00                	mov    (%eax),%eax
c01034da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e5:	c1 e8 0c             	shr    $0xc,%eax
c01034e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034eb:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01034f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01034f3:	72 17                	jb     c010350c <get_pte+0x52>
c01034f5:	ff 75 f0             	pushl  -0x10(%ebp)
c01034f8:	68 a0 64 10 c0       	push   $0xc01064a0
c01034fd:	68 80 01 00 00       	push   $0x180
c0103502:	68 68 65 10 c0       	push   $0xc0106568
c0103507:	e8 d1 ce ff ff       	call   c01003dd <__panic>
c010350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010350f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103514:	89 c2                	mov    %eax,%edx
c0103516:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103519:	c1 e8 0c             	shr    $0xc,%eax
c010351c:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103521:	c1 e0 02             	shl    $0x2,%eax
c0103524:	01 d0                	add    %edx,%eax
c0103526:	89 45 e8             	mov    %eax,-0x18(%ebp)
if (*pdep & PTE_P) 
c0103529:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352c:	8b 00                	mov    (%eax),%eax
c010352e:	83 e0 01             	and    $0x1,%eax
c0103531:	85 c0                	test   %eax,%eax
c0103533:	74 08                	je     c010353d <get_pte+0x83>
return ptep; // 检查查找到的页目录项是否存在，如果存在直接放回找到的页表项即可
c0103535:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103538:	e9 00 01 00 00       	jmp    c010363d <get_pte+0x183>
if (!create) 
c010353d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103541:	75 0a                	jne    c010354d <get_pte+0x93>
return NULL; // 如果该页目录项是不存在的，并且参数要求不创建新的页表，则直接返回
c0103543:	b8 00 00 00 00       	mov    $0x0,%eax
c0103548:	e9 f0 00 00 00       	jmp    c010363d <get_pte+0x183>
struct Page* pt = alloc_page(); // 如果需要按需创建新的页表，则请求一个物理页来存储新创建的页表
c010354d:	83 ec 0c             	sub    $0xc,%esp
c0103550:	6a 01                	push   $0x1
c0103552:	e8 8d f8 ff ff       	call   c0102de4 <alloc_pages>
c0103557:	83 c4 10             	add    $0x10,%esp
c010355a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
if (pt == NULL) 
c010355d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103561:	75 0a                	jne    c010356d <get_pte+0xb3>
return NULL; // 如果物理空间不足，直接返回
c0103563:	b8 00 00 00 00       	mov    $0x0,%eax
c0103568:	e9 d0 00 00 00       	jmp    c010363d <get_pte+0x183>

set_page_ref(pt, 1); // 更新该物理页的引用计数
c010356d:	83 ec 08             	sub    $0x8,%esp
c0103570:	6a 01                	push   $0x1
c0103572:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103575:	e8 66 f6 ff ff       	call   c0102be0 <set_page_ref>
c010357a:	83 c4 10             	add    $0x10,%esp

uintptr_t pa=page2pa(pt); //得到该页物理地址
c010357d:	83 ec 0c             	sub    $0xc,%esp
c0103580:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103583:	e8 59 f5 ff ff       	call   c0102ae1 <page2pa>
c0103588:	83 c4 10             	add    $0x10,%esp
c010358b:	89 45 e0             	mov    %eax,-0x20(%ebp)

memset(KADDR(pa),0,PGSIZE);//物理地址转虚拟地址，并初始化
c010358e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103591:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103594:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103597:	c1 e8 0c             	shr    $0xc,%eax
c010359a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010359d:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01035a2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01035a5:	72 17                	jb     c01035be <get_pte+0x104>
c01035a7:	ff 75 dc             	pushl  -0x24(%ebp)
c01035aa:	68 a0 64 10 c0       	push   $0xc01064a0
c01035af:	68 8d 01 00 00       	push   $0x18d
c01035b4:	68 68 65 10 c0       	push   $0xc0106568
c01035b9:	e8 1f ce ff ff       	call   c01003dd <__panic>
c01035be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035c1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01035c6:	83 ec 04             	sub    $0x4,%esp
c01035c9:	68 00 10 00 00       	push   $0x1000
c01035ce:	6a 00                	push   $0x0
c01035d0:	50                   	push   %eax
c01035d1:	e8 be 1f 00 00       	call   c0105594 <memset>
c01035d6:	83 c4 10             	add    $0x10,%esp

*pdep = pa| PTE_U | PTE_W | PTE_P; // 对原先的页目录项进行设置，包括设置其对应的页表的物理地址，以及包括存在位在内的标志位
c01035d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035dc:	83 c8 07             	or     $0x7,%eax
c01035df:	89 c2                	mov    %eax,%edx
c01035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e4:	89 10                	mov    %edx,(%eax)
ptep=((pte_t*)KADDR(PDE_ADDR(*pdep)))+PTX(la);
c01035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e9:	8b 00                	mov    (%eax),%eax
c01035eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01035f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035f6:	c1 e8 0c             	shr    $0xc,%eax
c01035f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01035fc:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103601:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103604:	72 17                	jb     c010361d <get_pte+0x163>
c0103606:	ff 75 d4             	pushl  -0x2c(%ebp)
c0103609:	68 a0 64 10 c0       	push   $0xc01064a0
c010360e:	68 90 01 00 00       	push   $0x190
c0103613:	68 68 65 10 c0       	push   $0xc0106568
c0103618:	e8 c0 cd ff ff       	call   c01003dd <__panic>
c010361d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103620:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103625:	89 c2                	mov    %eax,%edx
c0103627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010362a:	c1 e8 0c             	shr    $0xc,%eax
c010362d:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103632:	c1 e0 02             	shl    $0x2,%eax
c0103635:	01 d0                	add    %edx,%eax
c0103637:	89 45 e8             	mov    %eax,-0x18(%ebp)
return ptep ; // 返回线性地址对应的页目录项
c010363a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c010363d:	c9                   	leave  
c010363e:	c3                   	ret    

c010363f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010363f:	55                   	push   %ebp
c0103640:	89 e5                	mov    %esp,%ebp
c0103642:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103645:	83 ec 04             	sub    $0x4,%esp
c0103648:	6a 00                	push   $0x0
c010364a:	ff 75 0c             	pushl  0xc(%ebp)
c010364d:	ff 75 08             	pushl  0x8(%ebp)
c0103650:	e8 65 fe ff ff       	call   c01034ba <get_pte>
c0103655:	83 c4 10             	add    $0x10,%esp
c0103658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010365b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010365f:	74 08                	je     c0103669 <get_page+0x2a>
        *ptep_store = ptep;
c0103661:	8b 45 10             	mov    0x10(%ebp),%eax
c0103664:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103667:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010366d:	74 1f                	je     c010368e <get_page+0x4f>
c010366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103672:	8b 00                	mov    (%eax),%eax
c0103674:	83 e0 01             	and    $0x1,%eax
c0103677:	85 c0                	test   %eax,%eax
c0103679:	74 13                	je     c010368e <get_page+0x4f>
        return pte2page(*ptep);
c010367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367e:	8b 00                	mov    (%eax),%eax
c0103680:	83 ec 0c             	sub    $0xc,%esp
c0103683:	50                   	push   %eax
c0103684:	e8 f7 f4 ff ff       	call   c0102b80 <pte2page>
c0103689:	83 c4 10             	add    $0x10,%esp
c010368c:	eb 05                	jmp    c0103693 <get_page+0x54>
    }
    return NULL;
c010368e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103693:	c9                   	leave  
c0103694:	c3                   	ret    

c0103695 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103695:	55                   	push   %ebp
c0103696:	89 e5                	mov    %esp,%ebp
c0103698:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010369b:	8b 45 10             	mov    0x10(%ebp),%eax
c010369e:	8b 00                	mov    (%eax),%eax
c01036a0:	83 e0 01             	and    $0x1,%eax
c01036a3:	85 c0                	test   %eax,%eax
c01036a5:	74 50                	je     c01036f7 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c01036a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01036aa:	8b 00                	mov    (%eax),%eax
c01036ac:	83 ec 0c             	sub    $0xc,%esp
c01036af:	50                   	push   %eax
c01036b0:	e8 cb f4 ff ff       	call   c0102b80 <pte2page>
c01036b5:	83 c4 10             	add    $0x10,%esp
c01036b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01036bb:	83 ec 0c             	sub    $0xc,%esp
c01036be:	ff 75 f4             	pushl  -0xc(%ebp)
c01036c1:	e8 3f f5 ff ff       	call   c0102c05 <page_ref_dec>
c01036c6:	83 c4 10             	add    $0x10,%esp
c01036c9:	85 c0                	test   %eax,%eax
c01036cb:	75 10                	jne    c01036dd <page_remove_pte+0x48>
            free_page(page);
c01036cd:	83 ec 08             	sub    $0x8,%esp
c01036d0:	6a 01                	push   $0x1
c01036d2:	ff 75 f4             	pushl  -0xc(%ebp)
c01036d5:	e8 48 f7 ff ff       	call   c0102e22 <free_pages>
c01036da:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c01036dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01036e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01036e6:	83 ec 08             	sub    $0x8,%esp
c01036e9:	ff 75 0c             	pushl  0xc(%ebp)
c01036ec:	ff 75 08             	pushl  0x8(%ebp)
c01036ef:	e8 f8 00 00 00       	call   c01037ec <tlb_invalidate>
c01036f4:	83 c4 10             	add    $0x10,%esp
    }
}
c01036f7:	90                   	nop
c01036f8:	c9                   	leave  
c01036f9:	c3                   	ret    

c01036fa <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01036fa:	55                   	push   %ebp
c01036fb:	89 e5                	mov    %esp,%ebp
c01036fd:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103700:	83 ec 04             	sub    $0x4,%esp
c0103703:	6a 00                	push   $0x0
c0103705:	ff 75 0c             	pushl  0xc(%ebp)
c0103708:	ff 75 08             	pushl  0x8(%ebp)
c010370b:	e8 aa fd ff ff       	call   c01034ba <get_pte>
c0103710:	83 c4 10             	add    $0x10,%esp
c0103713:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103716:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010371a:	74 14                	je     c0103730 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010371c:	83 ec 04             	sub    $0x4,%esp
c010371f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103722:	ff 75 0c             	pushl  0xc(%ebp)
c0103725:	ff 75 08             	pushl  0x8(%ebp)
c0103728:	e8 68 ff ff ff       	call   c0103695 <page_remove_pte>
c010372d:	83 c4 10             	add    $0x10,%esp
    }
}
c0103730:	90                   	nop
c0103731:	c9                   	leave  
c0103732:	c3                   	ret    

c0103733 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103733:	55                   	push   %ebp
c0103734:	89 e5                	mov    %esp,%ebp
c0103736:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103739:	83 ec 04             	sub    $0x4,%esp
c010373c:	6a 01                	push   $0x1
c010373e:	ff 75 10             	pushl  0x10(%ebp)
c0103741:	ff 75 08             	pushl  0x8(%ebp)
c0103744:	e8 71 fd ff ff       	call   c01034ba <get_pte>
c0103749:	83 c4 10             	add    $0x10,%esp
c010374c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103753:	75 0a                	jne    c010375f <page_insert+0x2c>
        return -E_NO_MEM;
c0103755:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010375a:	e9 8b 00 00 00       	jmp    c01037ea <page_insert+0xb7>
    }
    page_ref_inc(page);
c010375f:	83 ec 0c             	sub    $0xc,%esp
c0103762:	ff 75 0c             	pushl  0xc(%ebp)
c0103765:	e8 84 f4 ff ff       	call   c0102bee <page_ref_inc>
c010376a:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c010376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103770:	8b 00                	mov    (%eax),%eax
c0103772:	83 e0 01             	and    $0x1,%eax
c0103775:	85 c0                	test   %eax,%eax
c0103777:	74 40                	je     c01037b9 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377c:	8b 00                	mov    (%eax),%eax
c010377e:	83 ec 0c             	sub    $0xc,%esp
c0103781:	50                   	push   %eax
c0103782:	e8 f9 f3 ff ff       	call   c0102b80 <pte2page>
c0103787:	83 c4 10             	add    $0x10,%esp
c010378a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103790:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103793:	75 10                	jne    c01037a5 <page_insert+0x72>
            page_ref_dec(page);
c0103795:	83 ec 0c             	sub    $0xc,%esp
c0103798:	ff 75 0c             	pushl  0xc(%ebp)
c010379b:	e8 65 f4 ff ff       	call   c0102c05 <page_ref_dec>
c01037a0:	83 c4 10             	add    $0x10,%esp
c01037a3:	eb 14                	jmp    c01037b9 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01037a5:	83 ec 04             	sub    $0x4,%esp
c01037a8:	ff 75 f4             	pushl  -0xc(%ebp)
c01037ab:	ff 75 10             	pushl  0x10(%ebp)
c01037ae:	ff 75 08             	pushl  0x8(%ebp)
c01037b1:	e8 df fe ff ff       	call   c0103695 <page_remove_pte>
c01037b6:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01037b9:	83 ec 0c             	sub    $0xc,%esp
c01037bc:	ff 75 0c             	pushl  0xc(%ebp)
c01037bf:	e8 1d f3 ff ff       	call   c0102ae1 <page2pa>
c01037c4:	83 c4 10             	add    $0x10,%esp
c01037c7:	0b 45 14             	or     0x14(%ebp),%eax
c01037ca:	83 c8 01             	or     $0x1,%eax
c01037cd:	89 c2                	mov    %eax,%edx
c01037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01037d4:	83 ec 08             	sub    $0x8,%esp
c01037d7:	ff 75 10             	pushl  0x10(%ebp)
c01037da:	ff 75 08             	pushl  0x8(%ebp)
c01037dd:	e8 0a 00 00 00       	call   c01037ec <tlb_invalidate>
c01037e2:	83 c4 10             	add    $0x10,%esp
    return 0;
c01037e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01037ea:	c9                   	leave  
c01037eb:	c3                   	ret    

c01037ec <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01037ec:	55                   	push   %ebp
c01037ed:	89 e5                	mov    %esp,%ebp
c01037ef:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01037f2:	0f 20 d8             	mov    %cr3,%eax
c01037f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01037f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01037fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01037fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103801:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103808:	77 17                	ja     c0103821 <tlb_invalidate+0x35>
c010380a:	ff 75 f4             	pushl  -0xc(%ebp)
c010380d:	68 44 65 10 c0       	push   $0xc0106544
c0103812:	68 f3 01 00 00       	push   $0x1f3
c0103817:	68 68 65 10 c0       	push   $0xc0106568
c010381c:	e8 bc cb ff ff       	call   c01003dd <__panic>
c0103821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103824:	05 00 00 00 40       	add    $0x40000000,%eax
c0103829:	39 d0                	cmp    %edx,%eax
c010382b:	75 0c                	jne    c0103839 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010382d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103830:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103833:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103836:	0f 01 38             	invlpg (%eax)
    }
}
c0103839:	90                   	nop
c010383a:	c9                   	leave  
c010383b:	c3                   	ret    

c010383c <check_alloc_page>:

static void
check_alloc_page(void) {
c010383c:	55                   	push   %ebp
c010383d:	89 e5                	mov    %esp,%ebp
c010383f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103842:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0103847:	8b 40 18             	mov    0x18(%eax),%eax
c010384a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010384c:	83 ec 0c             	sub    $0xc,%esp
c010384f:	68 c8 65 10 c0       	push   $0xc01065c8
c0103854:	e8 1e ca ff ff       	call   c0100277 <cprintf>
c0103859:	83 c4 10             	add    $0x10,%esp
}
c010385c:	90                   	nop
c010385d:	c9                   	leave  
c010385e:	c3                   	ret    

c010385f <check_pgdir>:

static void
check_pgdir(void) {
c010385f:	55                   	push   %ebp
c0103860:	89 e5                	mov    %esp,%ebp
c0103862:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103865:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c010386a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010386f:	76 19                	jbe    c010388a <check_pgdir+0x2b>
c0103871:	68 e7 65 10 c0       	push   $0xc01065e7
c0103876:	68 8d 65 10 c0       	push   $0xc010658d
c010387b:	68 00 02 00 00       	push   $0x200
c0103880:	68 68 65 10 c0       	push   $0xc0106568
c0103885:	e8 53 cb ff ff       	call   c01003dd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010388a:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010388f:	85 c0                	test   %eax,%eax
c0103891:	74 0e                	je     c01038a1 <check_pgdir+0x42>
c0103893:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103898:	25 ff 0f 00 00       	and    $0xfff,%eax
c010389d:	85 c0                	test   %eax,%eax
c010389f:	74 19                	je     c01038ba <check_pgdir+0x5b>
c01038a1:	68 04 66 10 c0       	push   $0xc0106604
c01038a6:	68 8d 65 10 c0       	push   $0xc010658d
c01038ab:	68 01 02 00 00       	push   $0x201
c01038b0:	68 68 65 10 c0       	push   $0xc0106568
c01038b5:	e8 23 cb ff ff       	call   c01003dd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01038ba:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01038bf:	83 ec 04             	sub    $0x4,%esp
c01038c2:	6a 00                	push   $0x0
c01038c4:	6a 00                	push   $0x0
c01038c6:	50                   	push   %eax
c01038c7:	e8 73 fd ff ff       	call   c010363f <get_page>
c01038cc:	83 c4 10             	add    $0x10,%esp
c01038cf:	85 c0                	test   %eax,%eax
c01038d1:	74 19                	je     c01038ec <check_pgdir+0x8d>
c01038d3:	68 3c 66 10 c0       	push   $0xc010663c
c01038d8:	68 8d 65 10 c0       	push   $0xc010658d
c01038dd:	68 02 02 00 00       	push   $0x202
c01038e2:	68 68 65 10 c0       	push   $0xc0106568
c01038e7:	e8 f1 ca ff ff       	call   c01003dd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01038ec:	83 ec 0c             	sub    $0xc,%esp
c01038ef:	6a 01                	push   $0x1
c01038f1:	e8 ee f4 ff ff       	call   c0102de4 <alloc_pages>
c01038f6:	83 c4 10             	add    $0x10,%esp
c01038f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01038fc:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103901:	6a 00                	push   $0x0
c0103903:	6a 00                	push   $0x0
c0103905:	ff 75 f4             	pushl  -0xc(%ebp)
c0103908:	50                   	push   %eax
c0103909:	e8 25 fe ff ff       	call   c0103733 <page_insert>
c010390e:	83 c4 10             	add    $0x10,%esp
c0103911:	85 c0                	test   %eax,%eax
c0103913:	74 19                	je     c010392e <check_pgdir+0xcf>
c0103915:	68 64 66 10 c0       	push   $0xc0106664
c010391a:	68 8d 65 10 c0       	push   $0xc010658d
c010391f:	68 06 02 00 00       	push   $0x206
c0103924:	68 68 65 10 c0       	push   $0xc0106568
c0103929:	e8 af ca ff ff       	call   c01003dd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010392e:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103933:	83 ec 04             	sub    $0x4,%esp
c0103936:	6a 00                	push   $0x0
c0103938:	6a 00                	push   $0x0
c010393a:	50                   	push   %eax
c010393b:	e8 7a fb ff ff       	call   c01034ba <get_pte>
c0103940:	83 c4 10             	add    $0x10,%esp
c0103943:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103946:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010394a:	75 19                	jne    c0103965 <check_pgdir+0x106>
c010394c:	68 90 66 10 c0       	push   $0xc0106690
c0103951:	68 8d 65 10 c0       	push   $0xc010658d
c0103956:	68 09 02 00 00       	push   $0x209
c010395b:	68 68 65 10 c0       	push   $0xc0106568
c0103960:	e8 78 ca ff ff       	call   c01003dd <__panic>
    assert(pte2page(*ptep) == p1);
c0103965:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103968:	8b 00                	mov    (%eax),%eax
c010396a:	83 ec 0c             	sub    $0xc,%esp
c010396d:	50                   	push   %eax
c010396e:	e8 0d f2 ff ff       	call   c0102b80 <pte2page>
c0103973:	83 c4 10             	add    $0x10,%esp
c0103976:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103979:	74 19                	je     c0103994 <check_pgdir+0x135>
c010397b:	68 bd 66 10 c0       	push   $0xc01066bd
c0103980:	68 8d 65 10 c0       	push   $0xc010658d
c0103985:	68 0a 02 00 00       	push   $0x20a
c010398a:	68 68 65 10 c0       	push   $0xc0106568
c010398f:	e8 49 ca ff ff       	call   c01003dd <__panic>
    assert(page_ref(p1) == 1);
c0103994:	83 ec 0c             	sub    $0xc,%esp
c0103997:	ff 75 f4             	pushl  -0xc(%ebp)
c010399a:	e8 37 f2 ff ff       	call   c0102bd6 <page_ref>
c010399f:	83 c4 10             	add    $0x10,%esp
c01039a2:	83 f8 01             	cmp    $0x1,%eax
c01039a5:	74 19                	je     c01039c0 <check_pgdir+0x161>
c01039a7:	68 d3 66 10 c0       	push   $0xc01066d3
c01039ac:	68 8d 65 10 c0       	push   $0xc010658d
c01039b1:	68 0b 02 00 00       	push   $0x20b
c01039b6:	68 68 65 10 c0       	push   $0xc0106568
c01039bb:	e8 1d ca ff ff       	call   c01003dd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01039c0:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01039c5:	8b 00                	mov    (%eax),%eax
c01039c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d2:	c1 e8 0c             	shr    $0xc,%eax
c01039d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039d8:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01039dd:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039e0:	72 17                	jb     c01039f9 <check_pgdir+0x19a>
c01039e2:	ff 75 ec             	pushl  -0x14(%ebp)
c01039e5:	68 a0 64 10 c0       	push   $0xc01064a0
c01039ea:	68 0d 02 00 00       	push   $0x20d
c01039ef:	68 68 65 10 c0       	push   $0xc0106568
c01039f4:	e8 e4 c9 ff ff       	call   c01003dd <__panic>
c01039f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039fc:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103a01:	83 c0 04             	add    $0x4,%eax
c0103a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103a07:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103a0c:	83 ec 04             	sub    $0x4,%esp
c0103a0f:	6a 00                	push   $0x0
c0103a11:	68 00 10 00 00       	push   $0x1000
c0103a16:	50                   	push   %eax
c0103a17:	e8 9e fa ff ff       	call   c01034ba <get_pte>
c0103a1c:	83 c4 10             	add    $0x10,%esp
c0103a1f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a22:	74 19                	je     c0103a3d <check_pgdir+0x1de>
c0103a24:	68 e8 66 10 c0       	push   $0xc01066e8
c0103a29:	68 8d 65 10 c0       	push   $0xc010658d
c0103a2e:	68 0e 02 00 00       	push   $0x20e
c0103a33:	68 68 65 10 c0       	push   $0xc0106568
c0103a38:	e8 a0 c9 ff ff       	call   c01003dd <__panic>

    p2 = alloc_page();
c0103a3d:	83 ec 0c             	sub    $0xc,%esp
c0103a40:	6a 01                	push   $0x1
c0103a42:	e8 9d f3 ff ff       	call   c0102de4 <alloc_pages>
c0103a47:	83 c4 10             	add    $0x10,%esp
c0103a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103a4d:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103a52:	6a 06                	push   $0x6
c0103a54:	68 00 10 00 00       	push   $0x1000
c0103a59:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a5c:	50                   	push   %eax
c0103a5d:	e8 d1 fc ff ff       	call   c0103733 <page_insert>
c0103a62:	83 c4 10             	add    $0x10,%esp
c0103a65:	85 c0                	test   %eax,%eax
c0103a67:	74 19                	je     c0103a82 <check_pgdir+0x223>
c0103a69:	68 10 67 10 c0       	push   $0xc0106710
c0103a6e:	68 8d 65 10 c0       	push   $0xc010658d
c0103a73:	68 11 02 00 00       	push   $0x211
c0103a78:	68 68 65 10 c0       	push   $0xc0106568
c0103a7d:	e8 5b c9 ff ff       	call   c01003dd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a82:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103a87:	83 ec 04             	sub    $0x4,%esp
c0103a8a:	6a 00                	push   $0x0
c0103a8c:	68 00 10 00 00       	push   $0x1000
c0103a91:	50                   	push   %eax
c0103a92:	e8 23 fa ff ff       	call   c01034ba <get_pte>
c0103a97:	83 c4 10             	add    $0x10,%esp
c0103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aa1:	75 19                	jne    c0103abc <check_pgdir+0x25d>
c0103aa3:	68 48 67 10 c0       	push   $0xc0106748
c0103aa8:	68 8d 65 10 c0       	push   $0xc010658d
c0103aad:	68 12 02 00 00       	push   $0x212
c0103ab2:	68 68 65 10 c0       	push   $0xc0106568
c0103ab7:	e8 21 c9 ff ff       	call   c01003dd <__panic>
    assert(*ptep & PTE_U);
c0103abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103abf:	8b 00                	mov    (%eax),%eax
c0103ac1:	83 e0 04             	and    $0x4,%eax
c0103ac4:	85 c0                	test   %eax,%eax
c0103ac6:	75 19                	jne    c0103ae1 <check_pgdir+0x282>
c0103ac8:	68 78 67 10 c0       	push   $0xc0106778
c0103acd:	68 8d 65 10 c0       	push   $0xc010658d
c0103ad2:	68 13 02 00 00       	push   $0x213
c0103ad7:	68 68 65 10 c0       	push   $0xc0106568
c0103adc:	e8 fc c8 ff ff       	call   c01003dd <__panic>
    assert(*ptep & PTE_W);
c0103ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ae4:	8b 00                	mov    (%eax),%eax
c0103ae6:	83 e0 02             	and    $0x2,%eax
c0103ae9:	85 c0                	test   %eax,%eax
c0103aeb:	75 19                	jne    c0103b06 <check_pgdir+0x2a7>
c0103aed:	68 86 67 10 c0       	push   $0xc0106786
c0103af2:	68 8d 65 10 c0       	push   $0xc010658d
c0103af7:	68 14 02 00 00       	push   $0x214
c0103afc:	68 68 65 10 c0       	push   $0xc0106568
c0103b01:	e8 d7 c8 ff ff       	call   c01003dd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103b06:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103b0b:	8b 00                	mov    (%eax),%eax
c0103b0d:	83 e0 04             	and    $0x4,%eax
c0103b10:	85 c0                	test   %eax,%eax
c0103b12:	75 19                	jne    c0103b2d <check_pgdir+0x2ce>
c0103b14:	68 94 67 10 c0       	push   $0xc0106794
c0103b19:	68 8d 65 10 c0       	push   $0xc010658d
c0103b1e:	68 15 02 00 00       	push   $0x215
c0103b23:	68 68 65 10 c0       	push   $0xc0106568
c0103b28:	e8 b0 c8 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p2) == 1);
c0103b2d:	83 ec 0c             	sub    $0xc,%esp
c0103b30:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b33:	e8 9e f0 ff ff       	call   c0102bd6 <page_ref>
c0103b38:	83 c4 10             	add    $0x10,%esp
c0103b3b:	83 f8 01             	cmp    $0x1,%eax
c0103b3e:	74 19                	je     c0103b59 <check_pgdir+0x2fa>
c0103b40:	68 aa 67 10 c0       	push   $0xc01067aa
c0103b45:	68 8d 65 10 c0       	push   $0xc010658d
c0103b4a:	68 16 02 00 00       	push   $0x216
c0103b4f:	68 68 65 10 c0       	push   $0xc0106568
c0103b54:	e8 84 c8 ff ff       	call   c01003dd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b59:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103b5e:	6a 00                	push   $0x0
c0103b60:	68 00 10 00 00       	push   $0x1000
c0103b65:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b68:	50                   	push   %eax
c0103b69:	e8 c5 fb ff ff       	call   c0103733 <page_insert>
c0103b6e:	83 c4 10             	add    $0x10,%esp
c0103b71:	85 c0                	test   %eax,%eax
c0103b73:	74 19                	je     c0103b8e <check_pgdir+0x32f>
c0103b75:	68 bc 67 10 c0       	push   $0xc01067bc
c0103b7a:	68 8d 65 10 c0       	push   $0xc010658d
c0103b7f:	68 18 02 00 00       	push   $0x218
c0103b84:	68 68 65 10 c0       	push   $0xc0106568
c0103b89:	e8 4f c8 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p1) == 2);
c0103b8e:	83 ec 0c             	sub    $0xc,%esp
c0103b91:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b94:	e8 3d f0 ff ff       	call   c0102bd6 <page_ref>
c0103b99:	83 c4 10             	add    $0x10,%esp
c0103b9c:	83 f8 02             	cmp    $0x2,%eax
c0103b9f:	74 19                	je     c0103bba <check_pgdir+0x35b>
c0103ba1:	68 e8 67 10 c0       	push   $0xc01067e8
c0103ba6:	68 8d 65 10 c0       	push   $0xc010658d
c0103bab:	68 19 02 00 00       	push   $0x219
c0103bb0:	68 68 65 10 c0       	push   $0xc0106568
c0103bb5:	e8 23 c8 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p2) == 0);
c0103bba:	83 ec 0c             	sub    $0xc,%esp
c0103bbd:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103bc0:	e8 11 f0 ff ff       	call   c0102bd6 <page_ref>
c0103bc5:	83 c4 10             	add    $0x10,%esp
c0103bc8:	85 c0                	test   %eax,%eax
c0103bca:	74 19                	je     c0103be5 <check_pgdir+0x386>
c0103bcc:	68 fa 67 10 c0       	push   $0xc01067fa
c0103bd1:	68 8d 65 10 c0       	push   $0xc010658d
c0103bd6:	68 1a 02 00 00       	push   $0x21a
c0103bdb:	68 68 65 10 c0       	push   $0xc0106568
c0103be0:	e8 f8 c7 ff ff       	call   c01003dd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103be5:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103bea:	83 ec 04             	sub    $0x4,%esp
c0103bed:	6a 00                	push   $0x0
c0103bef:	68 00 10 00 00       	push   $0x1000
c0103bf4:	50                   	push   %eax
c0103bf5:	e8 c0 f8 ff ff       	call   c01034ba <get_pte>
c0103bfa:	83 c4 10             	add    $0x10,%esp
c0103bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c04:	75 19                	jne    c0103c1f <check_pgdir+0x3c0>
c0103c06:	68 48 67 10 c0       	push   $0xc0106748
c0103c0b:	68 8d 65 10 c0       	push   $0xc010658d
c0103c10:	68 1b 02 00 00       	push   $0x21b
c0103c15:	68 68 65 10 c0       	push   $0xc0106568
c0103c1a:	e8 be c7 ff ff       	call   c01003dd <__panic>
    assert(pte2page(*ptep) == p1);
c0103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c22:	8b 00                	mov    (%eax),%eax
c0103c24:	83 ec 0c             	sub    $0xc,%esp
c0103c27:	50                   	push   %eax
c0103c28:	e8 53 ef ff ff       	call   c0102b80 <pte2page>
c0103c2d:	83 c4 10             	add    $0x10,%esp
c0103c30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103c33:	74 19                	je     c0103c4e <check_pgdir+0x3ef>
c0103c35:	68 bd 66 10 c0       	push   $0xc01066bd
c0103c3a:	68 8d 65 10 c0       	push   $0xc010658d
c0103c3f:	68 1c 02 00 00       	push   $0x21c
c0103c44:	68 68 65 10 c0       	push   $0xc0106568
c0103c49:	e8 8f c7 ff ff       	call   c01003dd <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c51:	8b 00                	mov    (%eax),%eax
c0103c53:	83 e0 04             	and    $0x4,%eax
c0103c56:	85 c0                	test   %eax,%eax
c0103c58:	74 19                	je     c0103c73 <check_pgdir+0x414>
c0103c5a:	68 0c 68 10 c0       	push   $0xc010680c
c0103c5f:	68 8d 65 10 c0       	push   $0xc010658d
c0103c64:	68 1d 02 00 00       	push   $0x21d
c0103c69:	68 68 65 10 c0       	push   $0xc0106568
c0103c6e:	e8 6a c7 ff ff       	call   c01003dd <__panic>

    page_remove(boot_pgdir, 0x0);
c0103c73:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103c78:	83 ec 08             	sub    $0x8,%esp
c0103c7b:	6a 00                	push   $0x0
c0103c7d:	50                   	push   %eax
c0103c7e:	e8 77 fa ff ff       	call   c01036fa <page_remove>
c0103c83:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103c86:	83 ec 0c             	sub    $0xc,%esp
c0103c89:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c8c:	e8 45 ef ff ff       	call   c0102bd6 <page_ref>
c0103c91:	83 c4 10             	add    $0x10,%esp
c0103c94:	83 f8 01             	cmp    $0x1,%eax
c0103c97:	74 19                	je     c0103cb2 <check_pgdir+0x453>
c0103c99:	68 d3 66 10 c0       	push   $0xc01066d3
c0103c9e:	68 8d 65 10 c0       	push   $0xc010658d
c0103ca3:	68 20 02 00 00       	push   $0x220
c0103ca8:	68 68 65 10 c0       	push   $0xc0106568
c0103cad:	e8 2b c7 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p2) == 0);
c0103cb2:	83 ec 0c             	sub    $0xc,%esp
c0103cb5:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103cb8:	e8 19 ef ff ff       	call   c0102bd6 <page_ref>
c0103cbd:	83 c4 10             	add    $0x10,%esp
c0103cc0:	85 c0                	test   %eax,%eax
c0103cc2:	74 19                	je     c0103cdd <check_pgdir+0x47e>
c0103cc4:	68 fa 67 10 c0       	push   $0xc01067fa
c0103cc9:	68 8d 65 10 c0       	push   $0xc010658d
c0103cce:	68 21 02 00 00       	push   $0x221
c0103cd3:	68 68 65 10 c0       	push   $0xc0106568
c0103cd8:	e8 00 c7 ff ff       	call   c01003dd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103cdd:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103ce2:	83 ec 08             	sub    $0x8,%esp
c0103ce5:	68 00 10 00 00       	push   $0x1000
c0103cea:	50                   	push   %eax
c0103ceb:	e8 0a fa ff ff       	call   c01036fa <page_remove>
c0103cf0:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103cf3:	83 ec 0c             	sub    $0xc,%esp
c0103cf6:	ff 75 f4             	pushl  -0xc(%ebp)
c0103cf9:	e8 d8 ee ff ff       	call   c0102bd6 <page_ref>
c0103cfe:	83 c4 10             	add    $0x10,%esp
c0103d01:	85 c0                	test   %eax,%eax
c0103d03:	74 19                	je     c0103d1e <check_pgdir+0x4bf>
c0103d05:	68 21 68 10 c0       	push   $0xc0106821
c0103d0a:	68 8d 65 10 c0       	push   $0xc010658d
c0103d0f:	68 24 02 00 00       	push   $0x224
c0103d14:	68 68 65 10 c0       	push   $0xc0106568
c0103d19:	e8 bf c6 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p2) == 0);
c0103d1e:	83 ec 0c             	sub    $0xc,%esp
c0103d21:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103d24:	e8 ad ee ff ff       	call   c0102bd6 <page_ref>
c0103d29:	83 c4 10             	add    $0x10,%esp
c0103d2c:	85 c0                	test   %eax,%eax
c0103d2e:	74 19                	je     c0103d49 <check_pgdir+0x4ea>
c0103d30:	68 fa 67 10 c0       	push   $0xc01067fa
c0103d35:	68 8d 65 10 c0       	push   $0xc010658d
c0103d3a:	68 25 02 00 00       	push   $0x225
c0103d3f:	68 68 65 10 c0       	push   $0xc0106568
c0103d44:	e8 94 c6 ff ff       	call   c01003dd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103d49:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103d4e:	8b 00                	mov    (%eax),%eax
c0103d50:	83 ec 0c             	sub    $0xc,%esp
c0103d53:	50                   	push   %eax
c0103d54:	e8 61 ee ff ff       	call   c0102bba <pde2page>
c0103d59:	83 c4 10             	add    $0x10,%esp
c0103d5c:	83 ec 0c             	sub    $0xc,%esp
c0103d5f:	50                   	push   %eax
c0103d60:	e8 71 ee ff ff       	call   c0102bd6 <page_ref>
c0103d65:	83 c4 10             	add    $0x10,%esp
c0103d68:	83 f8 01             	cmp    $0x1,%eax
c0103d6b:	74 19                	je     c0103d86 <check_pgdir+0x527>
c0103d6d:	68 34 68 10 c0       	push   $0xc0106834
c0103d72:	68 8d 65 10 c0       	push   $0xc010658d
c0103d77:	68 27 02 00 00       	push   $0x227
c0103d7c:	68 68 65 10 c0       	push   $0xc0106568
c0103d81:	e8 57 c6 ff ff       	call   c01003dd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103d86:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103d8b:	8b 00                	mov    (%eax),%eax
c0103d8d:	83 ec 0c             	sub    $0xc,%esp
c0103d90:	50                   	push   %eax
c0103d91:	e8 24 ee ff ff       	call   c0102bba <pde2page>
c0103d96:	83 c4 10             	add    $0x10,%esp
c0103d99:	83 ec 08             	sub    $0x8,%esp
c0103d9c:	6a 01                	push   $0x1
c0103d9e:	50                   	push   %eax
c0103d9f:	e8 7e f0 ff ff       	call   c0102e22 <free_pages>
c0103da4:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103da7:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103db2:	83 ec 0c             	sub    $0xc,%esp
c0103db5:	68 5b 68 10 c0       	push   $0xc010685b
c0103dba:	e8 b8 c4 ff ff       	call   c0100277 <cprintf>
c0103dbf:	83 c4 10             	add    $0x10,%esp
}
c0103dc2:	90                   	nop
c0103dc3:	c9                   	leave  
c0103dc4:	c3                   	ret    

c0103dc5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103dc5:	55                   	push   %ebp
c0103dc6:	89 e5                	mov    %esp,%ebp
c0103dc8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103dcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dd2:	e9 a3 00 00 00       	jmp    c0103e7a <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103de0:	c1 e8 0c             	shr    $0xc,%eax
c0103de3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103de6:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103deb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103dee:	72 17                	jb     c0103e07 <check_boot_pgdir+0x42>
c0103df0:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103df3:	68 a0 64 10 c0       	push   $0xc01064a0
c0103df8:	68 33 02 00 00       	push   $0x233
c0103dfd:	68 68 65 10 c0       	push   $0xc0106568
c0103e02:	e8 d6 c5 ff ff       	call   c01003dd <__panic>
c0103e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e0a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e0f:	89 c2                	mov    %eax,%edx
c0103e11:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103e16:	83 ec 04             	sub    $0x4,%esp
c0103e19:	6a 00                	push   $0x0
c0103e1b:	52                   	push   %edx
c0103e1c:	50                   	push   %eax
c0103e1d:	e8 98 f6 ff ff       	call   c01034ba <get_pte>
c0103e22:	83 c4 10             	add    $0x10,%esp
c0103e25:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103e28:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103e2c:	75 19                	jne    c0103e47 <check_boot_pgdir+0x82>
c0103e2e:	68 78 68 10 c0       	push   $0xc0106878
c0103e33:	68 8d 65 10 c0       	push   $0xc010658d
c0103e38:	68 33 02 00 00       	push   $0x233
c0103e3d:	68 68 65 10 c0       	push   $0xc0106568
c0103e42:	e8 96 c5 ff ff       	call   c01003dd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103e47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e4a:	8b 00                	mov    (%eax),%eax
c0103e4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e51:	89 c2                	mov    %eax,%edx
c0103e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e56:	39 c2                	cmp    %eax,%edx
c0103e58:	74 19                	je     c0103e73 <check_boot_pgdir+0xae>
c0103e5a:	68 b5 68 10 c0       	push   $0xc01068b5
c0103e5f:	68 8d 65 10 c0       	push   $0xc010658d
c0103e64:	68 34 02 00 00       	push   $0x234
c0103e69:	68 68 65 10 c0       	push   $0xc0106568
c0103e6e:	e8 6a c5 ff ff       	call   c01003dd <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103e73:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e7d:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103e82:	39 c2                	cmp    %eax,%edx
c0103e84:	0f 82 4d ff ff ff    	jb     c0103dd7 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103e8a:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103e8f:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103e94:	8b 00                	mov    (%eax),%eax
c0103e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e9b:	89 c2                	mov    %eax,%edx
c0103e9d:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ea5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103eac:	77 17                	ja     c0103ec5 <check_boot_pgdir+0x100>
c0103eae:	ff 75 f0             	pushl  -0x10(%ebp)
c0103eb1:	68 44 65 10 c0       	push   $0xc0106544
c0103eb6:	68 37 02 00 00       	push   $0x237
c0103ebb:	68 68 65 10 c0       	push   $0xc0106568
c0103ec0:	e8 18 c5 ff ff       	call   c01003dd <__panic>
c0103ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ec8:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ecd:	39 d0                	cmp    %edx,%eax
c0103ecf:	74 19                	je     c0103eea <check_boot_pgdir+0x125>
c0103ed1:	68 cc 68 10 c0       	push   $0xc01068cc
c0103ed6:	68 8d 65 10 c0       	push   $0xc010658d
c0103edb:	68 37 02 00 00       	push   $0x237
c0103ee0:	68 68 65 10 c0       	push   $0xc0106568
c0103ee5:	e8 f3 c4 ff ff       	call   c01003dd <__panic>

    assert(boot_pgdir[0] == 0);
c0103eea:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103eef:	8b 00                	mov    (%eax),%eax
c0103ef1:	85 c0                	test   %eax,%eax
c0103ef3:	74 19                	je     c0103f0e <check_boot_pgdir+0x149>
c0103ef5:	68 00 69 10 c0       	push   $0xc0106900
c0103efa:	68 8d 65 10 c0       	push   $0xc010658d
c0103eff:	68 39 02 00 00       	push   $0x239
c0103f04:	68 68 65 10 c0       	push   $0xc0106568
c0103f09:	e8 cf c4 ff ff       	call   c01003dd <__panic>

    struct Page *p;
    p = alloc_page();
c0103f0e:	83 ec 0c             	sub    $0xc,%esp
c0103f11:	6a 01                	push   $0x1
c0103f13:	e8 cc ee ff ff       	call   c0102de4 <alloc_pages>
c0103f18:	83 c4 10             	add    $0x10,%esp
c0103f1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103f1e:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103f23:	6a 02                	push   $0x2
c0103f25:	68 00 01 00 00       	push   $0x100
c0103f2a:	ff 75 ec             	pushl  -0x14(%ebp)
c0103f2d:	50                   	push   %eax
c0103f2e:	e8 00 f8 ff ff       	call   c0103733 <page_insert>
c0103f33:	83 c4 10             	add    $0x10,%esp
c0103f36:	85 c0                	test   %eax,%eax
c0103f38:	74 19                	je     c0103f53 <check_boot_pgdir+0x18e>
c0103f3a:	68 14 69 10 c0       	push   $0xc0106914
c0103f3f:	68 8d 65 10 c0       	push   $0xc010658d
c0103f44:	68 3d 02 00 00       	push   $0x23d
c0103f49:	68 68 65 10 c0       	push   $0xc0106568
c0103f4e:	e8 8a c4 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p) == 1);
c0103f53:	83 ec 0c             	sub    $0xc,%esp
c0103f56:	ff 75 ec             	pushl  -0x14(%ebp)
c0103f59:	e8 78 ec ff ff       	call   c0102bd6 <page_ref>
c0103f5e:	83 c4 10             	add    $0x10,%esp
c0103f61:	83 f8 01             	cmp    $0x1,%eax
c0103f64:	74 19                	je     c0103f7f <check_boot_pgdir+0x1ba>
c0103f66:	68 42 69 10 c0       	push   $0xc0106942
c0103f6b:	68 8d 65 10 c0       	push   $0xc010658d
c0103f70:	68 3e 02 00 00       	push   $0x23e
c0103f75:	68 68 65 10 c0       	push   $0xc0106568
c0103f7a:	e8 5e c4 ff ff       	call   c01003dd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103f7f:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0103f84:	6a 02                	push   $0x2
c0103f86:	68 00 11 00 00       	push   $0x1100
c0103f8b:	ff 75 ec             	pushl  -0x14(%ebp)
c0103f8e:	50                   	push   %eax
c0103f8f:	e8 9f f7 ff ff       	call   c0103733 <page_insert>
c0103f94:	83 c4 10             	add    $0x10,%esp
c0103f97:	85 c0                	test   %eax,%eax
c0103f99:	74 19                	je     c0103fb4 <check_boot_pgdir+0x1ef>
c0103f9b:	68 54 69 10 c0       	push   $0xc0106954
c0103fa0:	68 8d 65 10 c0       	push   $0xc010658d
c0103fa5:	68 3f 02 00 00       	push   $0x23f
c0103faa:	68 68 65 10 c0       	push   $0xc0106568
c0103faf:	e8 29 c4 ff ff       	call   c01003dd <__panic>
    assert(page_ref(p) == 2);
c0103fb4:	83 ec 0c             	sub    $0xc,%esp
c0103fb7:	ff 75 ec             	pushl  -0x14(%ebp)
c0103fba:	e8 17 ec ff ff       	call   c0102bd6 <page_ref>
c0103fbf:	83 c4 10             	add    $0x10,%esp
c0103fc2:	83 f8 02             	cmp    $0x2,%eax
c0103fc5:	74 19                	je     c0103fe0 <check_boot_pgdir+0x21b>
c0103fc7:	68 8b 69 10 c0       	push   $0xc010698b
c0103fcc:	68 8d 65 10 c0       	push   $0xc010658d
c0103fd1:	68 40 02 00 00       	push   $0x240
c0103fd6:	68 68 65 10 c0       	push   $0xc0106568
c0103fdb:	e8 fd c3 ff ff       	call   c01003dd <__panic>

    const char *str = "ucore: Hello world!!";
c0103fe0:	c7 45 e8 9c 69 10 c0 	movl   $0xc010699c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103fe7:	83 ec 08             	sub    $0x8,%esp
c0103fea:	ff 75 e8             	pushl  -0x18(%ebp)
c0103fed:	68 00 01 00 00       	push   $0x100
c0103ff2:	e8 c4 12 00 00       	call   c01052bb <strcpy>
c0103ff7:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103ffa:	83 ec 08             	sub    $0x8,%esp
c0103ffd:	68 00 11 00 00       	push   $0x1100
c0104002:	68 00 01 00 00       	push   $0x100
c0104007:	e8 29 13 00 00       	call   c0105335 <strcmp>
c010400c:	83 c4 10             	add    $0x10,%esp
c010400f:	85 c0                	test   %eax,%eax
c0104011:	74 19                	je     c010402c <check_boot_pgdir+0x267>
c0104013:	68 b4 69 10 c0       	push   $0xc01069b4
c0104018:	68 8d 65 10 c0       	push   $0xc010658d
c010401d:	68 44 02 00 00       	push   $0x244
c0104022:	68 68 65 10 c0       	push   $0xc0106568
c0104027:	e8 b1 c3 ff ff       	call   c01003dd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010402c:	83 ec 0c             	sub    $0xc,%esp
c010402f:	ff 75 ec             	pushl  -0x14(%ebp)
c0104032:	e8 04 eb ff ff       	call   c0102b3b <page2kva>
c0104037:	83 c4 10             	add    $0x10,%esp
c010403a:	05 00 01 00 00       	add    $0x100,%eax
c010403f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104042:	83 ec 0c             	sub    $0xc,%esp
c0104045:	68 00 01 00 00       	push   $0x100
c010404a:	e8 14 12 00 00       	call   c0105263 <strlen>
c010404f:	83 c4 10             	add    $0x10,%esp
c0104052:	85 c0                	test   %eax,%eax
c0104054:	74 19                	je     c010406f <check_boot_pgdir+0x2aa>
c0104056:	68 ec 69 10 c0       	push   $0xc01069ec
c010405b:	68 8d 65 10 c0       	push   $0xc010658d
c0104060:	68 47 02 00 00       	push   $0x247
c0104065:	68 68 65 10 c0       	push   $0xc0106568
c010406a:	e8 6e c3 ff ff       	call   c01003dd <__panic>

    free_page(p);
c010406f:	83 ec 08             	sub    $0x8,%esp
c0104072:	6a 01                	push   $0x1
c0104074:	ff 75 ec             	pushl  -0x14(%ebp)
c0104077:	e8 a6 ed ff ff       	call   c0102e22 <free_pages>
c010407c:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c010407f:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104084:	8b 00                	mov    (%eax),%eax
c0104086:	83 ec 0c             	sub    $0xc,%esp
c0104089:	50                   	push   %eax
c010408a:	e8 2b eb ff ff       	call   c0102bba <pde2page>
c010408f:	83 c4 10             	add    $0x10,%esp
c0104092:	83 ec 08             	sub    $0x8,%esp
c0104095:	6a 01                	push   $0x1
c0104097:	50                   	push   %eax
c0104098:	e8 85 ed ff ff       	call   c0102e22 <free_pages>
c010409d:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01040a0:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01040a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01040ab:	83 ec 0c             	sub    $0xc,%esp
c01040ae:	68 10 6a 10 c0       	push   $0xc0106a10
c01040b3:	e8 bf c1 ff ff       	call   c0100277 <cprintf>
c01040b8:	83 c4 10             	add    $0x10,%esp
}
c01040bb:	90                   	nop
c01040bc:	c9                   	leave  
c01040bd:	c3                   	ret    

c01040be <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01040be:	55                   	push   %ebp
c01040bf:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01040c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01040c4:	83 e0 04             	and    $0x4,%eax
c01040c7:	85 c0                	test   %eax,%eax
c01040c9:	74 07                	je     c01040d2 <perm2str+0x14>
c01040cb:	b8 75 00 00 00       	mov    $0x75,%eax
c01040d0:	eb 05                	jmp    c01040d7 <perm2str+0x19>
c01040d2:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01040d7:	a2 48 99 11 c0       	mov    %al,0xc0119948
    str[1] = 'r';
c01040dc:	c6 05 49 99 11 c0 72 	movb   $0x72,0xc0119949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01040e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01040e6:	83 e0 02             	and    $0x2,%eax
c01040e9:	85 c0                	test   %eax,%eax
c01040eb:	74 07                	je     c01040f4 <perm2str+0x36>
c01040ed:	b8 77 00 00 00       	mov    $0x77,%eax
c01040f2:	eb 05                	jmp    c01040f9 <perm2str+0x3b>
c01040f4:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01040f9:	a2 4a 99 11 c0       	mov    %al,0xc011994a
    str[3] = '\0';
c01040fe:	c6 05 4b 99 11 c0 00 	movb   $0x0,0xc011994b
    return str;
c0104105:	b8 48 99 11 c0       	mov    $0xc0119948,%eax
}
c010410a:	5d                   	pop    %ebp
c010410b:	c3                   	ret    

c010410c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010410c:	55                   	push   %ebp
c010410d:	89 e5                	mov    %esp,%ebp
c010410f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104112:	8b 45 10             	mov    0x10(%ebp),%eax
c0104115:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104118:	72 0e                	jb     c0104128 <get_pgtable_items+0x1c>
        return 0;
c010411a:	b8 00 00 00 00       	mov    $0x0,%eax
c010411f:	e9 9a 00 00 00       	jmp    c01041be <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104124:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104128:	8b 45 10             	mov    0x10(%ebp),%eax
c010412b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010412e:	73 18                	jae    c0104148 <get_pgtable_items+0x3c>
c0104130:	8b 45 10             	mov    0x10(%ebp),%eax
c0104133:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010413a:	8b 45 14             	mov    0x14(%ebp),%eax
c010413d:	01 d0                	add    %edx,%eax
c010413f:	8b 00                	mov    (%eax),%eax
c0104141:	83 e0 01             	and    $0x1,%eax
c0104144:	85 c0                	test   %eax,%eax
c0104146:	74 dc                	je     c0104124 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104148:	8b 45 10             	mov    0x10(%ebp),%eax
c010414b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010414e:	73 69                	jae    c01041b9 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0104150:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104154:	74 08                	je     c010415e <get_pgtable_items+0x52>
            *left_store = start;
c0104156:	8b 45 18             	mov    0x18(%ebp),%eax
c0104159:	8b 55 10             	mov    0x10(%ebp),%edx
c010415c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010415e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104161:	8d 50 01             	lea    0x1(%eax),%edx
c0104164:	89 55 10             	mov    %edx,0x10(%ebp)
c0104167:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010416e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104171:	01 d0                	add    %edx,%eax
c0104173:	8b 00                	mov    (%eax),%eax
c0104175:	83 e0 07             	and    $0x7,%eax
c0104178:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010417b:	eb 04                	jmp    c0104181 <get_pgtable_items+0x75>
            start ++;
c010417d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104181:	8b 45 10             	mov    0x10(%ebp),%eax
c0104184:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104187:	73 1d                	jae    c01041a6 <get_pgtable_items+0x9a>
c0104189:	8b 45 10             	mov    0x10(%ebp),%eax
c010418c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104193:	8b 45 14             	mov    0x14(%ebp),%eax
c0104196:	01 d0                	add    %edx,%eax
c0104198:	8b 00                	mov    (%eax),%eax
c010419a:	83 e0 07             	and    $0x7,%eax
c010419d:	89 c2                	mov    %eax,%edx
c010419f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041a2:	39 c2                	cmp    %eax,%edx
c01041a4:	74 d7                	je     c010417d <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
c01041a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01041aa:	74 08                	je     c01041b4 <get_pgtable_items+0xa8>
            *right_store = start;
c01041ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01041af:	8b 55 10             	mov    0x10(%ebp),%edx
c01041b2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01041b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b7:	eb 05                	jmp    c01041be <get_pgtable_items+0xb2>
    }
    return 0;
c01041b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01041be:	c9                   	leave  
c01041bf:	c3                   	ret    

c01041c0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01041c0:	55                   	push   %ebp
c01041c1:	89 e5                	mov    %esp,%ebp
c01041c3:	57                   	push   %edi
c01041c4:	56                   	push   %esi
c01041c5:	53                   	push   %ebx
c01041c6:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01041c9:	83 ec 0c             	sub    $0xc,%esp
c01041cc:	68 30 6a 10 c0       	push   $0xc0106a30
c01041d1:	e8 a1 c0 ff ff       	call   c0100277 <cprintf>
c01041d6:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01041d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01041e0:	e9 e5 00 00 00       	jmp    c01042ca <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01041e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041e8:	83 ec 0c             	sub    $0xc,%esp
c01041eb:	50                   	push   %eax
c01041ec:	e8 cd fe ff ff       	call   c01040be <perm2str>
c01041f1:	83 c4 10             	add    $0x10,%esp
c01041f4:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01041f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041fc:	29 c2                	sub    %eax,%edx
c01041fe:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104200:	c1 e0 16             	shl    $0x16,%eax
c0104203:	89 c3                	mov    %eax,%ebx
c0104205:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104208:	c1 e0 16             	shl    $0x16,%eax
c010420b:	89 c1                	mov    %eax,%ecx
c010420d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104210:	c1 e0 16             	shl    $0x16,%eax
c0104213:	89 c2                	mov    %eax,%edx
c0104215:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0104218:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010421b:	29 c6                	sub    %eax,%esi
c010421d:	89 f0                	mov    %esi,%eax
c010421f:	83 ec 08             	sub    $0x8,%esp
c0104222:	57                   	push   %edi
c0104223:	53                   	push   %ebx
c0104224:	51                   	push   %ecx
c0104225:	52                   	push   %edx
c0104226:	50                   	push   %eax
c0104227:	68 61 6a 10 c0       	push   $0xc0106a61
c010422c:	e8 46 c0 ff ff       	call   c0100277 <cprintf>
c0104231:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104234:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104237:	c1 e0 0a             	shl    $0xa,%eax
c010423a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010423d:	eb 4f                	jmp    c010428e <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010423f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104242:	83 ec 0c             	sub    $0xc,%esp
c0104245:	50                   	push   %eax
c0104246:	e8 73 fe ff ff       	call   c01040be <perm2str>
c010424b:	83 c4 10             	add    $0x10,%esp
c010424e:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104250:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104253:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104256:	29 c2                	sub    %eax,%edx
c0104258:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010425a:	c1 e0 0c             	shl    $0xc,%eax
c010425d:	89 c3                	mov    %eax,%ebx
c010425f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104262:	c1 e0 0c             	shl    $0xc,%eax
c0104265:	89 c1                	mov    %eax,%ecx
c0104267:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010426a:	c1 e0 0c             	shl    $0xc,%eax
c010426d:	89 c2                	mov    %eax,%edx
c010426f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0104272:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104275:	29 c6                	sub    %eax,%esi
c0104277:	89 f0                	mov    %esi,%eax
c0104279:	83 ec 08             	sub    $0x8,%esp
c010427c:	57                   	push   %edi
c010427d:	53                   	push   %ebx
c010427e:	51                   	push   %ecx
c010427f:	52                   	push   %edx
c0104280:	50                   	push   %eax
c0104281:	68 80 6a 10 c0       	push   $0xc0106a80
c0104286:	e8 ec bf ff ff       	call   c0100277 <cprintf>
c010428b:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010428e:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104293:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104296:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104299:	89 d3                	mov    %edx,%ebx
c010429b:	c1 e3 0a             	shl    $0xa,%ebx
c010429e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042a1:	89 d1                	mov    %edx,%ecx
c01042a3:	c1 e1 0a             	shl    $0xa,%ecx
c01042a6:	83 ec 08             	sub    $0x8,%esp
c01042a9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01042ac:	52                   	push   %edx
c01042ad:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01042b0:	52                   	push   %edx
c01042b1:	56                   	push   %esi
c01042b2:	50                   	push   %eax
c01042b3:	53                   	push   %ebx
c01042b4:	51                   	push   %ecx
c01042b5:	e8 52 fe ff ff       	call   c010410c <get_pgtable_items>
c01042ba:	83 c4 20             	add    $0x20,%esp
c01042bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042c4:	0f 85 75 ff ff ff    	jne    c010423f <print_pgdir+0x7f>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01042ca:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01042cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042d2:	83 ec 08             	sub    $0x8,%esp
c01042d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01042d8:	52                   	push   %edx
c01042d9:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01042dc:	52                   	push   %edx
c01042dd:	51                   	push   %ecx
c01042de:	50                   	push   %eax
c01042df:	68 00 04 00 00       	push   $0x400
c01042e4:	6a 00                	push   $0x0
c01042e6:	e8 21 fe ff ff       	call   c010410c <get_pgtable_items>
c01042eb:	83 c4 20             	add    $0x20,%esp
c01042ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042f5:	0f 85 ea fe ff ff    	jne    c01041e5 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01042fb:	83 ec 0c             	sub    $0xc,%esp
c01042fe:	68 a4 6a 10 c0       	push   $0xc0106aa4
c0104303:	e8 6f bf ff ff       	call   c0100277 <cprintf>
c0104308:	83 c4 10             	add    $0x10,%esp
}
c010430b:	90                   	nop
c010430c:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010430f:	5b                   	pop    %ebx
c0104310:	5e                   	pop    %esi
c0104311:	5f                   	pop    %edi
c0104312:	5d                   	pop    %ebp
c0104313:	c3                   	ret    

c0104314 <page2ppn>:
page2ppn(struct Page *page) {
c0104314:	55                   	push   %ebp
c0104315:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104317:	8b 45 08             	mov    0x8(%ebp),%eax
c010431a:	8b 15 58 99 11 c0    	mov    0xc0119958,%edx
c0104320:	29 d0                	sub    %edx,%eax
c0104322:	c1 f8 02             	sar    $0x2,%eax
c0104325:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010432b:	5d                   	pop    %ebp
c010432c:	c3                   	ret    

c010432d <page2pa>:
page2pa(struct Page *page) {
c010432d:	55                   	push   %ebp
c010432e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104330:	ff 75 08             	pushl  0x8(%ebp)
c0104333:	e8 dc ff ff ff       	call   c0104314 <page2ppn>
c0104338:	83 c4 04             	add    $0x4,%esp
c010433b:	c1 e0 0c             	shl    $0xc,%eax
}
c010433e:	c9                   	leave  
c010433f:	c3                   	ret    

c0104340 <page_ref>:
page_ref(struct Page *page) {
c0104340:	55                   	push   %ebp
c0104341:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104343:	8b 45 08             	mov    0x8(%ebp),%eax
c0104346:	8b 00                	mov    (%eax),%eax
}
c0104348:	5d                   	pop    %ebp
c0104349:	c3                   	ret    

c010434a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010434a:	55                   	push   %ebp
c010434b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010434d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104350:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104353:	89 10                	mov    %edx,(%eax)
}
c0104355:	90                   	nop
c0104356:	5d                   	pop    %ebp
c0104357:	c3                   	ret    

c0104358 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104358:	55                   	push   %ebp
c0104359:	89 e5                	mov    %esp,%ebp
c010435b:	83 ec 10             	sub    $0x10,%esp
c010435e:	c7 45 fc 5c 99 11 c0 	movl   $0xc011995c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104365:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104368:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010436b:	89 50 04             	mov    %edx,0x4(%eax)
c010436e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104371:	8b 50 04             	mov    0x4(%eax),%edx
c0104374:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104377:	89 10                	mov    %edx,(%eax)
	list_init(&free_list);
	nr_free = 0;
c0104379:	c7 05 64 99 11 c0 00 	movl   $0x0,0xc0119964
c0104380:	00 00 00 
}
c0104383:	90                   	nop
c0104384:	c9                   	leave  
c0104385:	c3                   	ret    

c0104386 <default_init_memmap>:


//��Ϊdefault_pmm_manager�ĳ�Ա��������page_init���memmap���ÿ��map
static void
default_init_memmap(struct Page *base, size_t n) {
c0104386:	55                   	push   %ebp
c0104387:	89 e5                	mov    %esp,%ebp
c0104389:	83 ec 38             	sub    $0x38,%esp
	assert(n > 0);
c010438c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104390:	75 16                	jne    c01043a8 <default_init_memmap+0x22>
c0104392:	68 d8 6a 10 c0       	push   $0xc0106ad8
c0104397:	68 de 6a 10 c0       	push   $0xc0106ade
c010439c:	6a 4a                	push   $0x4a
c010439e:	68 f3 6a 10 c0       	push   $0xc0106af3
c01043a3:	e8 35 c0 ff ff       	call   c01003dd <__panic>
	struct Page *p = base;
c01043a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++) {
c01043ae:	e9 cb 00 00 00       	jmp    c010447e <default_init_memmap+0xf8>
		assert(PageReserved(p));
c01043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b6:	83 c0 04             	add    $0x4,%eax
c01043b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01043c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01043c9:	0f a3 10             	bt     %edx,(%eax)
c01043cc:	19 c0                	sbb    %eax,%eax
c01043ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01043d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01043d5:	0f 95 c0             	setne  %al
c01043d8:	0f b6 c0             	movzbl %al,%eax
c01043db:	85 c0                	test   %eax,%eax
c01043dd:	75 16                	jne    c01043f5 <default_init_memmap+0x6f>
c01043df:	68 09 6b 10 c0       	push   $0xc0106b09
c01043e4:	68 de 6a 10 c0       	push   $0xc0106ade
c01043e9:	6a 4d                	push   $0x4d
c01043eb:	68 f3 6a 10 c0       	push   $0xc0106af3
c01043f0:	e8 e8 bf ff ff       	call   c01003dd <__panic>
		p->flags = 0;
c01043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c01043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104402:	83 c0 04             	add    $0x4,%eax
c0104405:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010440c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010440f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104412:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104415:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
c0104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010441b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
c0104422:	83 ec 08             	sub    $0x8,%esp
c0104425:	6a 00                	push   $0x0
c0104427:	ff 75 f4             	pushl  -0xc(%ebp)
c010442a:	e8 1b ff ff ff       	call   c010434a <set_page_ref>
c010442f:	83 c4 10             	add    $0x10,%esp
		list_add_before(&free_list, &(p->page_link));
c0104432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104435:	83 c0 0c             	add    $0xc,%eax
c0104438:	c7 45 e4 5c 99 11 c0 	movl   $0xc011995c,-0x1c(%ebp)
c010443f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104445:	8b 00                	mov    (%eax),%eax
c0104447:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010444a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010444d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104453:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104456:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104459:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010445c:	89 10                	mov    %edx,(%eax)
c010445e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104461:	8b 10                	mov    (%eax),%edx
c0104463:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104466:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104469:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010446c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010446f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104472:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104475:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104478:	89 10                	mov    %edx,(%eax)
	for (; p != base + n; p++) {
c010447a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010447e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104481:	89 d0                	mov    %edx,%eax
c0104483:	c1 e0 02             	shl    $0x2,%eax
c0104486:	01 d0                	add    %edx,%eax
c0104488:	c1 e0 02             	shl    $0x2,%eax
c010448b:	89 c2                	mov    %eax,%edx
c010448d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104490:	01 d0                	add    %edx,%eax
c0104492:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104495:	0f 85 18 ff ff ff    	jne    c01043b3 <default_init_memmap+0x2d>
	}
	nr_free += n;
c010449b:	8b 15 64 99 11 c0    	mov    0xc0119964,%edx
c01044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a4:	01 d0                	add    %edx,%eax
c01044a6:	a3 64 99 11 c0       	mov    %eax,0xc0119964
	base->property = n;
c01044ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ae:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044b1:	89 50 08             	mov    %edx,0x8(%eax)
}
c01044b4:	90                   	nop
c01044b5:	c9                   	leave  
c01044b6:	c3                   	ret    

c01044b7 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01044b7:	55                   	push   %ebp
c01044b8:	89 e5                	mov    %esp,%ebp
c01044ba:	83 ec 58             	sub    $0x58,%esp
	//�߽�����
	assert(n > 0);
c01044bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01044c1:	75 16                	jne    c01044d9 <default_alloc_pages+0x22>
c01044c3:	68 d8 6a 10 c0       	push   $0xc0106ad8
c01044c8:	68 de 6a 10 c0       	push   $0xc0106ade
c01044cd:	6a 5b                	push   $0x5b
c01044cf:	68 f3 6a 10 c0       	push   $0xc0106af3
c01044d4:	e8 04 bf ff ff       	call   c01003dd <__panic>
	//�����ܹ�����
	if (n > nr_free) {
c01044d9:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c01044de:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044e1:	76 0a                	jbe    c01044ed <default_alloc_pages+0x36>
		return NULL;
c01044e3:	b8 00 00 00 00       	mov    $0x0,%eax
c01044e8:	e9 46 01 00 00       	jmp    c0104633 <default_alloc_pages+0x17c>
c01044ed:	c7 45 dc 5c 99 11 c0 	movl   $0xc011995c,-0x24(%ebp)
    return listelm->next;
c01044f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044f7:	8b 40 04             	mov    0x4(%eax),%eax
	}
	//���ܹ�
	list_entry_t *le = list_next(&free_list);
c01044fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
c01044fd:	e9 1f 01 00 00       	jmp    c0104621 <default_alloc_pages+0x16a>
		//ͨ��le����������Ѱ��һ����Ϊ�������п���ʼҳ������ҳ�����ڵ���n
		//����property�ķ�ʽ��Ҫ����offset
		struct Page *p = le2page(le, page_link);
c0104502:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104505:	83 e8 0c             	sub    $0xc,%eax
c0104508:	89 45 e8             	mov    %eax,-0x18(%ebp)

		//�ҵ��㹻����
		if (p->property >= n) {
c010450b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010450e:	8b 40 08             	mov    0x8(%eax),%eax
c0104511:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104514:	0f 87 f8 00 00 00    	ja     c0104612 <default_alloc_pages+0x15b>
			//��Ҫ����ģ��˴�>=n�����ܻ���ʣ���ҳ�����Ȱ�n������״̬��ժ����ʣ�µı�����������
			int iter = 0;
c010451a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			list_entry_t * cur_le = le;
c0104521:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104524:	89 45 ec             	mov    %eax,-0x14(%ebp)
			list_entry_t * next_le;
			while (iter < n) {
c0104527:	eb 7c                	jmp    c01045a5 <default_alloc_pages+0xee>
				struct Page * cur_p = le2page(cur_le, page_link);
c0104529:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010452c:	83 e8 0c             	sub    $0xc,%eax
c010452f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104535:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104538:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010453b:	8b 40 04             	mov    0x4(%eax),%eax
				next_le = list_next(cur_le);
c010453e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				SetPageReserved(cur_p);
c0104541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104544:	83 c0 04             	add    $0x4,%eax
c0104547:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
c010454e:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104551:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104554:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104557:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(cur_p);
c010455a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010455d:	83 c0 04             	add    $0x4,%eax
c0104560:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104567:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010456a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010456d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104570:	0f b3 10             	btr    %edx,(%eax)
c0104573:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104576:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104579:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010457c:	8b 40 04             	mov    0x4(%eax),%eax
c010457f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104582:	8b 12                	mov    (%edx),%edx
c0104584:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104587:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010458a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010458d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104590:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104593:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104599:	89 10                	mov    %edx,(%eax)
				list_del(cur_le);
				cur_le = next_le;
c010459b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010459e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				iter++;
c01045a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			while (iter < n) {
c01045a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a8:	39 45 08             	cmp    %eax,0x8(%ebp)
c01045ab:	0f 87 78 ff ff ff    	ja     c0104529 <default_alloc_pages+0x72>
			}
			//��ʱn�����Ѿ��������
			//���>n����ôcur_le������������ͷ
			if (p->property > n) {
c01045b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045b4:	8b 40 08             	mov    0x8(%eax),%eax
c01045b7:	39 45 08             	cmp    %eax,0x8(%ebp)
c01045ba:	73 12                	jae    c01045ce <default_alloc_pages+0x117>
				(le2page(cur_le, page_link))->property = p->property - n;
c01045bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045bf:	8b 40 08             	mov    0x8(%eax),%eax
c01045c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045c5:	83 ea 0c             	sub    $0xc,%edx
c01045c8:	2b 45 08             	sub    0x8(%ebp),%eax
c01045cb:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
c01045ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045d1:	83 c0 04             	add    $0x4,%eax
c01045d4:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01045db:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01045de:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01045e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01045e4:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
c01045e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045ea:	83 c0 04             	add    $0x4,%eax
c01045ed:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01045f4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045f7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01045fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01045fd:	0f ab 10             	bts    %edx,(%eax)
			nr_free -= n;
c0104600:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104605:	2b 45 08             	sub    0x8(%ebp),%eax
c0104608:	a3 64 99 11 c0       	mov    %eax,0xc0119964
			return p;
c010460d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104610:	eb 21                	jmp    c0104633 <default_alloc_pages+0x17c>
c0104612:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104615:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return listelm->next;
c0104618:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010461b:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c010461e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
c0104621:	81 7d f4 5c 99 11 c0 	cmpl   $0xc011995c,-0xc(%ebp)
c0104628:	0f 85 d4 fe ff ff    	jne    c0104502 <default_alloc_pages+0x4b>
	}
	return NULL;
c010462e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104633:	c9                   	leave  
c0104634:	c3                   	ret    

c0104635 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104635:	55                   	push   %ebp
c0104636:	89 e5                	mov    %esp,%ebp
c0104638:	83 ec 68             	sub    $0x68,%esp
assert(n > 0);
c010463b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010463f:	75 19                	jne    c010465a <default_free_pages+0x25>
c0104641:	68 d8 6a 10 c0       	push   $0xc0106ad8
c0104646:	68 de 6a 10 c0       	push   $0xc0106ade
c010464b:	68 87 00 00 00       	push   $0x87
c0104650:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104655:	e8 83 bd ff ff       	call   c01003dd <__panic>
	assert(PageReserved(base));
c010465a:	8b 45 08             	mov    0x8(%ebp),%eax
c010465d:	83 c0 04             	add    $0x4,%eax
c0104660:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104667:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010466a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010466d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104670:	0f a3 10             	bt     %edx,(%eax)
c0104673:	19 c0                	sbb    %eax,%eax
c0104675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0104678:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010467c:	0f 95 c0             	setne  %al
c010467f:	0f b6 c0             	movzbl %al,%eax
c0104682:	85 c0                	test   %eax,%eax
c0104684:	75 19                	jne    c010469f <default_free_pages+0x6a>
c0104686:	68 19 6b 10 c0       	push   $0xc0106b19
c010468b:	68 de 6a 10 c0       	push   $0xc0106ade
c0104690:	68 88 00 00 00       	push   $0x88
c0104695:	68 f3 6a 10 c0       	push   $0xc0106af3
c010469a:	e8 3e bd ff ff       	call   c01003dd <__panic>
	list_entry_t *le = &free_list;
c010469f:	c7 45 f4 5c 99 11 c0 	movl   $0xc011995c,-0xc(%ebp)
c01046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01046ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046af:	8b 40 04             	mov    0x4(%eax),%eax
	struct Page* p;
	list_entry_t* insert_position;

	le = list_next(le);
c01046b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
c01046b5:	eb 20                	jmp    c01046d7 <default_free_pages+0xa2>
	    p = le2page(le, page_link);
c01046b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ba:	83 e8 0c             	sub    $0xc,%eax
c01046bd:	89 45 f0             	mov    %eax,-0x10(%ebp)

		if (p > base) {
c01046c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01046c6:	77 1a                	ja     c01046e2 <default_free_pages+0xad>
c01046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01046ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01046d1:	8b 40 04             	mov    0x4(%eax),%eax
			break;
		}
		le = list_next(le);
c01046d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
c01046d7:	81 7d f4 5c 99 11 c0 	cmpl   $0xc011995c,-0xc(%ebp)
c01046de:	75 d7                	jne    c01046b7 <default_free_pages+0x82>
c01046e0:	eb 01                	jmp    c01046e3 <default_free_pages+0xae>
			break;
c01046e2:	90                   	nop
	}
	insert_position = le;
c01046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (unsigned int iter = 0; iter < n; iter++) {
c01046e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01046f0:	eb 62                	jmp    c0104754 <default_free_pages+0x11f>
		struct Page* cur_p = base + iter;
c01046f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01046f5:	89 d0                	mov    %edx,%eax
c01046f7:	c1 e0 02             	shl    $0x2,%eax
c01046fa:	01 d0                	add    %edx,%eax
c01046fc:	c1 e0 02             	shl    $0x2,%eax
c01046ff:	89 c2                	mov    %eax,%edx
c0104701:	8b 45 08             	mov    0x8(%ebp),%eax
c0104704:	01 d0                	add    %edx,%eax
c0104706:	89 45 e0             	mov    %eax,-0x20(%ebp)
		list_add_before(insert_position, &(cur_p->page_link));
c0104709:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010470c:	8d 50 0c             	lea    0xc(%eax),%edx
c010470f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104712:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104715:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104718:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010471b:	8b 00                	mov    (%eax),%eax
c010471d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104720:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104723:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104726:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104729:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next->prev = elm;
c010472c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010472f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104732:	89 10                	mov    %edx,(%eax)
c0104734:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104737:	8b 10                	mov    (%eax),%edx
c0104739:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010473c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010473f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104742:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104745:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104748:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010474b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010474e:	89 10                	mov    %edx,(%eax)
	for (unsigned int iter = 0; iter < n; iter++) {
c0104750:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104754:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104757:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010475a:	72 96                	jb     c01046f2 <default_free_pages+0xbd>
	}
    	base->flags = 0;
c010475c:	8b 45 08             	mov    0x8(%ebp),%eax
c010475f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	set_page_ref(base, 0);
c0104766:	83 ec 08             	sub    $0x8,%esp
c0104769:	6a 00                	push   $0x0
c010476b:	ff 75 08             	pushl  0x8(%ebp)
c010476e:	e8 d7 fb ff ff       	call   c010434a <set_page_ref>
c0104773:	83 c4 10             	add    $0x10,%esp
    	ClearPageProperty(base);
c0104776:	8b 45 08             	mov    0x8(%ebp),%eax
c0104779:	83 c0 04             	add    $0x4,%eax
c010477c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104783:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104786:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104789:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010478c:	0f b3 10             	btr    %edx,(%eax)
    	SetPageProperty(base);
c010478f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104792:	83 c0 04             	add    $0x4,%eax
c0104795:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010479c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010479f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047a2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01047a5:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;
c01047a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ab:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047ae:	89 50 08             	mov    %edx,0x8(%eax)

	struct Page* insert_p = le2page(insert_position, page_link);
c01047b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047b4:	83 e8 0c             	sub    $0xc,%eax
c01047b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	//back connected
	if (base + n == insert_p) {
c01047ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047bd:	89 d0                	mov    %edx,%eax
c01047bf:	c1 e0 02             	shl    $0x2,%eax
c01047c2:	01 d0                	add    %edx,%eax
c01047c4:	c1 e0 02             	shl    $0x2,%eax
c01047c7:	89 c2                	mov    %eax,%edx
c01047c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047cc:	01 d0                	add    %edx,%eax
c01047ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01047d1:	75 1b                	jne    c01047ee <default_free_pages+0x1b9>
		base->property = n + insert_p->property;
c01047d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047d6:	8b 50 08             	mov    0x8(%eax),%edx
c01047d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047dc:	01 c2                	add    %eax,%edx
c01047de:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e1:	89 50 08             	mov    %edx,0x8(%eax)
		insert_p->property = 0;
c01047e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}


	//prev connected
	le = list_prev(&(base->page_link));
c01047ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f1:	83 c0 0c             	add    $0xc,%eax
c01047f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return listelm->prev;
c01047f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01047fa:	8b 00                	mov    (%eax),%eax
c01047fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
c01047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104802:	83 e8 0c             	sub    $0xc,%eax
c0104805:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(le!=&free_list && p==base-1){
c0104808:	81 7d f4 5c 99 11 c0 	cmpl   $0xc011995c,-0xc(%ebp)
c010480f:	74 57                	je     c0104868 <default_free_pages+0x233>
c0104811:	8b 45 08             	mov    0x8(%ebp),%eax
c0104814:	83 e8 14             	sub    $0x14,%eax
c0104817:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010481a:	75 4c                	jne    c0104868 <default_free_pages+0x233>
	      while(le!=&free_list){
c010481c:	eb 41                	jmp    c010485f <default_free_pages+0x22a>
		if(p->property){
c010481e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104821:	8b 40 08             	mov    0x8(%eax),%eax
c0104824:	85 c0                	test   %eax,%eax
c0104826:	74 20                	je     c0104848 <default_free_pages+0x213>
		  p->property += base->property;
c0104828:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010482b:	8b 50 08             	mov    0x8(%eax),%edx
c010482e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104831:	8b 40 08             	mov    0x8(%eax),%eax
c0104834:	01 c2                	add    %eax,%edx
c0104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104839:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
c010483c:	8b 45 08             	mov    0x8(%ebp),%eax
c010483f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
c0104846:	eb 20                	jmp    c0104868 <default_free_pages+0x233>
c0104848:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010484b:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010484e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104851:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
c0104853:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
c0104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104859:	83 e8 0c             	sub    $0xc,%eax
c010485c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	      while(le!=&free_list){
c010485f:	81 7d f4 5c 99 11 c0 	cmpl   $0xc011995c,-0xc(%ebp)
c0104866:	75 b6                	jne    c010481e <default_free_pages+0x1e9>
	      }
	}
	nr_free += n;
c0104868:	8b 15 64 99 11 c0    	mov    0xc0119964,%edx
c010486e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104871:	01 d0                	add    %edx,%eax
c0104873:	a3 64 99 11 c0       	mov    %eax,0xc0119964
	return;
c0104878:	90                   	nop
}
c0104879:	c9                   	leave  
c010487a:	c3                   	ret    

c010487b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010487b:	55                   	push   %ebp
c010487c:	89 e5                	mov    %esp,%ebp
	return nr_free;
c010487e:	a1 64 99 11 c0       	mov    0xc0119964,%eax
}
c0104883:	5d                   	pop    %ebp
c0104884:	c3                   	ret    

c0104885 <basic_check>:

static void
basic_check(void) {
c0104885:	55                   	push   %ebp
c0104886:	89 e5                	mov    %esp,%ebp
c0104888:	83 ec 38             	sub    $0x38,%esp
	struct Page *p0, *p1, *p2;
	p0 = p1 = p2 = NULL;
c010488b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104895:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104898:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010489b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	assert((p0 = alloc_page()) != NULL);
c010489e:	83 ec 0c             	sub    $0xc,%esp
c01048a1:	6a 01                	push   $0x1
c01048a3:	e8 3c e5 ff ff       	call   c0102de4 <alloc_pages>
c01048a8:	83 c4 10             	add    $0x10,%esp
c01048ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01048b2:	75 19                	jne    c01048cd <basic_check+0x48>
c01048b4:	68 2c 6b 10 c0       	push   $0xc0106b2c
c01048b9:	68 de 6a 10 c0       	push   $0xc0106ade
c01048be:	68 c4 00 00 00       	push   $0xc4
c01048c3:	68 f3 6a 10 c0       	push   $0xc0106af3
c01048c8:	e8 10 bb ff ff       	call   c01003dd <__panic>
	assert((p1 = alloc_page()) != NULL);
c01048cd:	83 ec 0c             	sub    $0xc,%esp
c01048d0:	6a 01                	push   $0x1
c01048d2:	e8 0d e5 ff ff       	call   c0102de4 <alloc_pages>
c01048d7:	83 c4 10             	add    $0x10,%esp
c01048da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048e1:	75 19                	jne    c01048fc <basic_check+0x77>
c01048e3:	68 48 6b 10 c0       	push   $0xc0106b48
c01048e8:	68 de 6a 10 c0       	push   $0xc0106ade
c01048ed:	68 c5 00 00 00       	push   $0xc5
c01048f2:	68 f3 6a 10 c0       	push   $0xc0106af3
c01048f7:	e8 e1 ba ff ff       	call   c01003dd <__panic>
	assert((p2 = alloc_page()) != NULL);
c01048fc:	83 ec 0c             	sub    $0xc,%esp
c01048ff:	6a 01                	push   $0x1
c0104901:	e8 de e4 ff ff       	call   c0102de4 <alloc_pages>
c0104906:	83 c4 10             	add    $0x10,%esp
c0104909:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010490c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104910:	75 19                	jne    c010492b <basic_check+0xa6>
c0104912:	68 64 6b 10 c0       	push   $0xc0106b64
c0104917:	68 de 6a 10 c0       	push   $0xc0106ade
c010491c:	68 c6 00 00 00       	push   $0xc6
c0104921:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104926:	e8 b2 ba ff ff       	call   c01003dd <__panic>

	assert(p0 != p1 && p0 != p2 && p1 != p2);
c010492b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010492e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104931:	74 10                	je     c0104943 <basic_check+0xbe>
c0104933:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104936:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104939:	74 08                	je     c0104943 <basic_check+0xbe>
c010493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010493e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104941:	75 19                	jne    c010495c <basic_check+0xd7>
c0104943:	68 80 6b 10 c0       	push   $0xc0106b80
c0104948:	68 de 6a 10 c0       	push   $0xc0106ade
c010494d:	68 c8 00 00 00       	push   $0xc8
c0104952:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104957:	e8 81 ba ff ff       	call   c01003dd <__panic>
	assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010495c:	83 ec 0c             	sub    $0xc,%esp
c010495f:	ff 75 ec             	pushl  -0x14(%ebp)
c0104962:	e8 d9 f9 ff ff       	call   c0104340 <page_ref>
c0104967:	83 c4 10             	add    $0x10,%esp
c010496a:	85 c0                	test   %eax,%eax
c010496c:	75 24                	jne    c0104992 <basic_check+0x10d>
c010496e:	83 ec 0c             	sub    $0xc,%esp
c0104971:	ff 75 f0             	pushl  -0x10(%ebp)
c0104974:	e8 c7 f9 ff ff       	call   c0104340 <page_ref>
c0104979:	83 c4 10             	add    $0x10,%esp
c010497c:	85 c0                	test   %eax,%eax
c010497e:	75 12                	jne    c0104992 <basic_check+0x10d>
c0104980:	83 ec 0c             	sub    $0xc,%esp
c0104983:	ff 75 f4             	pushl  -0xc(%ebp)
c0104986:	e8 b5 f9 ff ff       	call   c0104340 <page_ref>
c010498b:	83 c4 10             	add    $0x10,%esp
c010498e:	85 c0                	test   %eax,%eax
c0104990:	74 19                	je     c01049ab <basic_check+0x126>
c0104992:	68 a4 6b 10 c0       	push   $0xc0106ba4
c0104997:	68 de 6a 10 c0       	push   $0xc0106ade
c010499c:	68 c9 00 00 00       	push   $0xc9
c01049a1:	68 f3 6a 10 c0       	push   $0xc0106af3
c01049a6:	e8 32 ba ff ff       	call   c01003dd <__panic>

	assert(page2pa(p0) < npage * PGSIZE);
c01049ab:	83 ec 0c             	sub    $0xc,%esp
c01049ae:	ff 75 ec             	pushl  -0x14(%ebp)
c01049b1:	e8 77 f9 ff ff       	call   c010432d <page2pa>
c01049b6:	83 c4 10             	add    $0x10,%esp
c01049b9:	89 c2                	mov    %eax,%edx
c01049bb:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01049c0:	c1 e0 0c             	shl    $0xc,%eax
c01049c3:	39 c2                	cmp    %eax,%edx
c01049c5:	72 19                	jb     c01049e0 <basic_check+0x15b>
c01049c7:	68 e0 6b 10 c0       	push   $0xc0106be0
c01049cc:	68 de 6a 10 c0       	push   $0xc0106ade
c01049d1:	68 cb 00 00 00       	push   $0xcb
c01049d6:	68 f3 6a 10 c0       	push   $0xc0106af3
c01049db:	e8 fd b9 ff ff       	call   c01003dd <__panic>
	assert(page2pa(p1) < npage * PGSIZE);
c01049e0:	83 ec 0c             	sub    $0xc,%esp
c01049e3:	ff 75 f0             	pushl  -0x10(%ebp)
c01049e6:	e8 42 f9 ff ff       	call   c010432d <page2pa>
c01049eb:	83 c4 10             	add    $0x10,%esp
c01049ee:	89 c2                	mov    %eax,%edx
c01049f0:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01049f5:	c1 e0 0c             	shl    $0xc,%eax
c01049f8:	39 c2                	cmp    %eax,%edx
c01049fa:	72 19                	jb     c0104a15 <basic_check+0x190>
c01049fc:	68 fd 6b 10 c0       	push   $0xc0106bfd
c0104a01:	68 de 6a 10 c0       	push   $0xc0106ade
c0104a06:	68 cc 00 00 00       	push   $0xcc
c0104a0b:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104a10:	e8 c8 b9 ff ff       	call   c01003dd <__panic>
	assert(page2pa(p2) < npage * PGSIZE);
c0104a15:	83 ec 0c             	sub    $0xc,%esp
c0104a18:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a1b:	e8 0d f9 ff ff       	call   c010432d <page2pa>
c0104a20:	83 c4 10             	add    $0x10,%esp
c0104a23:	89 c2                	mov    %eax,%edx
c0104a25:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0104a2a:	c1 e0 0c             	shl    $0xc,%eax
c0104a2d:	39 c2                	cmp    %eax,%edx
c0104a2f:	72 19                	jb     c0104a4a <basic_check+0x1c5>
c0104a31:	68 1a 6c 10 c0       	push   $0xc0106c1a
c0104a36:	68 de 6a 10 c0       	push   $0xc0106ade
c0104a3b:	68 cd 00 00 00       	push   $0xcd
c0104a40:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104a45:	e8 93 b9 ff ff       	call   c01003dd <__panic>

	list_entry_t free_list_store = free_list;
c0104a4a:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0104a4f:	8b 15 60 99 11 c0    	mov    0xc0119960,%edx
c0104a55:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a58:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a5b:	c7 45 dc 5c 99 11 c0 	movl   $0xc011995c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a68:	89 50 04             	mov    %edx,0x4(%eax)
c0104a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a6e:	8b 50 04             	mov    0x4(%eax),%edx
c0104a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a74:	89 10                	mov    %edx,(%eax)
c0104a76:	c7 45 e0 5c 99 11 c0 	movl   $0xc011995c,-0x20(%ebp)
    return list->next == list;
c0104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a80:	8b 40 04             	mov    0x4(%eax),%eax
c0104a83:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104a86:	0f 94 c0             	sete   %al
c0104a89:	0f b6 c0             	movzbl %al,%eax
	list_init(&free_list);
	assert(list_empty(&free_list));
c0104a8c:	85 c0                	test   %eax,%eax
c0104a8e:	75 19                	jne    c0104aa9 <basic_check+0x224>
c0104a90:	68 37 6c 10 c0       	push   $0xc0106c37
c0104a95:	68 de 6a 10 c0       	push   $0xc0106ade
c0104a9a:	68 d1 00 00 00       	push   $0xd1
c0104a9f:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104aa4:	e8 34 b9 ff ff       	call   c01003dd <__panic>

	unsigned int nr_free_store = nr_free;
c0104aa9:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nr_free = 0;
c0104ab1:	c7 05 64 99 11 c0 00 	movl   $0x0,0xc0119964
c0104ab8:	00 00 00 

	assert(alloc_page() == NULL);
c0104abb:	83 ec 0c             	sub    $0xc,%esp
c0104abe:	6a 01                	push   $0x1
c0104ac0:	e8 1f e3 ff ff       	call   c0102de4 <alloc_pages>
c0104ac5:	83 c4 10             	add    $0x10,%esp
c0104ac8:	85 c0                	test   %eax,%eax
c0104aca:	74 19                	je     c0104ae5 <basic_check+0x260>
c0104acc:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0104ad1:	68 de 6a 10 c0       	push   $0xc0106ade
c0104ad6:	68 d6 00 00 00       	push   $0xd6
c0104adb:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104ae0:	e8 f8 b8 ff ff       	call   c01003dd <__panic>

	free_page(p0);
c0104ae5:	83 ec 08             	sub    $0x8,%esp
c0104ae8:	6a 01                	push   $0x1
c0104aea:	ff 75 ec             	pushl  -0x14(%ebp)
c0104aed:	e8 30 e3 ff ff       	call   c0102e22 <free_pages>
c0104af2:	83 c4 10             	add    $0x10,%esp
	free_page(p1);
c0104af5:	83 ec 08             	sub    $0x8,%esp
c0104af8:	6a 01                	push   $0x1
c0104afa:	ff 75 f0             	pushl  -0x10(%ebp)
c0104afd:	e8 20 e3 ff ff       	call   c0102e22 <free_pages>
c0104b02:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
c0104b05:	83 ec 08             	sub    $0x8,%esp
c0104b08:	6a 01                	push   $0x1
c0104b0a:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b0d:	e8 10 e3 ff ff       	call   c0102e22 <free_pages>
c0104b12:	83 c4 10             	add    $0x10,%esp
	assert(nr_free == 3);
c0104b15:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104b1a:	83 f8 03             	cmp    $0x3,%eax
c0104b1d:	74 19                	je     c0104b38 <basic_check+0x2b3>
c0104b1f:	68 63 6c 10 c0       	push   $0xc0106c63
c0104b24:	68 de 6a 10 c0       	push   $0xc0106ade
c0104b29:	68 db 00 00 00       	push   $0xdb
c0104b2e:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104b33:	e8 a5 b8 ff ff       	call   c01003dd <__panic>

	assert((p0 = alloc_page()) != NULL);
c0104b38:	83 ec 0c             	sub    $0xc,%esp
c0104b3b:	6a 01                	push   $0x1
c0104b3d:	e8 a2 e2 ff ff       	call   c0102de4 <alloc_pages>
c0104b42:	83 c4 10             	add    $0x10,%esp
c0104b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b4c:	75 19                	jne    c0104b67 <basic_check+0x2e2>
c0104b4e:	68 2c 6b 10 c0       	push   $0xc0106b2c
c0104b53:	68 de 6a 10 c0       	push   $0xc0106ade
c0104b58:	68 dd 00 00 00       	push   $0xdd
c0104b5d:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104b62:	e8 76 b8 ff ff       	call   c01003dd <__panic>
	assert((p1 = alloc_page()) != NULL);
c0104b67:	83 ec 0c             	sub    $0xc,%esp
c0104b6a:	6a 01                	push   $0x1
c0104b6c:	e8 73 e2 ff ff       	call   c0102de4 <alloc_pages>
c0104b71:	83 c4 10             	add    $0x10,%esp
c0104b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b7b:	75 19                	jne    c0104b96 <basic_check+0x311>
c0104b7d:	68 48 6b 10 c0       	push   $0xc0106b48
c0104b82:	68 de 6a 10 c0       	push   $0xc0106ade
c0104b87:	68 de 00 00 00       	push   $0xde
c0104b8c:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104b91:	e8 47 b8 ff ff       	call   c01003dd <__panic>
	assert((p2 = alloc_page()) != NULL);
c0104b96:	83 ec 0c             	sub    $0xc,%esp
c0104b99:	6a 01                	push   $0x1
c0104b9b:	e8 44 e2 ff ff       	call   c0102de4 <alloc_pages>
c0104ba0:	83 c4 10             	add    $0x10,%esp
c0104ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104baa:	75 19                	jne    c0104bc5 <basic_check+0x340>
c0104bac:	68 64 6b 10 c0       	push   $0xc0106b64
c0104bb1:	68 de 6a 10 c0       	push   $0xc0106ade
c0104bb6:	68 df 00 00 00       	push   $0xdf
c0104bbb:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104bc0:	e8 18 b8 ff ff       	call   c01003dd <__panic>

	assert(alloc_page() == NULL);
c0104bc5:	83 ec 0c             	sub    $0xc,%esp
c0104bc8:	6a 01                	push   $0x1
c0104bca:	e8 15 e2 ff ff       	call   c0102de4 <alloc_pages>
c0104bcf:	83 c4 10             	add    $0x10,%esp
c0104bd2:	85 c0                	test   %eax,%eax
c0104bd4:	74 19                	je     c0104bef <basic_check+0x36a>
c0104bd6:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0104bdb:	68 de 6a 10 c0       	push   $0xc0106ade
c0104be0:	68 e1 00 00 00       	push   $0xe1
c0104be5:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104bea:	e8 ee b7 ff ff       	call   c01003dd <__panic>

	free_page(p0);
c0104bef:	83 ec 08             	sub    $0x8,%esp
c0104bf2:	6a 01                	push   $0x1
c0104bf4:	ff 75 ec             	pushl  -0x14(%ebp)
c0104bf7:	e8 26 e2 ff ff       	call   c0102e22 <free_pages>
c0104bfc:	83 c4 10             	add    $0x10,%esp
c0104bff:	c7 45 d8 5c 99 11 c0 	movl   $0xc011995c,-0x28(%ebp)
c0104c06:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c09:	8b 40 04             	mov    0x4(%eax),%eax
c0104c0c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104c0f:	0f 94 c0             	sete   %al
c0104c12:	0f b6 c0             	movzbl %al,%eax
	assert(!list_empty(&free_list));
c0104c15:	85 c0                	test   %eax,%eax
c0104c17:	74 19                	je     c0104c32 <basic_check+0x3ad>
c0104c19:	68 70 6c 10 c0       	push   $0xc0106c70
c0104c1e:	68 de 6a 10 c0       	push   $0xc0106ade
c0104c23:	68 e4 00 00 00       	push   $0xe4
c0104c28:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104c2d:	e8 ab b7 ff ff       	call   c01003dd <__panic>

	struct Page *p;
	assert((p = alloc_page()) == p0);
c0104c32:	83 ec 0c             	sub    $0xc,%esp
c0104c35:	6a 01                	push   $0x1
c0104c37:	e8 a8 e1 ff ff       	call   c0102de4 <alloc_pages>
c0104c3c:	83 c4 10             	add    $0x10,%esp
c0104c3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104c48:	74 19                	je     c0104c63 <basic_check+0x3de>
c0104c4a:	68 88 6c 10 c0       	push   $0xc0106c88
c0104c4f:	68 de 6a 10 c0       	push   $0xc0106ade
c0104c54:	68 e7 00 00 00       	push   $0xe7
c0104c59:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104c5e:	e8 7a b7 ff ff       	call   c01003dd <__panic>
	assert(alloc_page() == NULL);
c0104c63:	83 ec 0c             	sub    $0xc,%esp
c0104c66:	6a 01                	push   $0x1
c0104c68:	e8 77 e1 ff ff       	call   c0102de4 <alloc_pages>
c0104c6d:	83 c4 10             	add    $0x10,%esp
c0104c70:	85 c0                	test   %eax,%eax
c0104c72:	74 19                	je     c0104c8d <basic_check+0x408>
c0104c74:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0104c79:	68 de 6a 10 c0       	push   $0xc0106ade
c0104c7e:	68 e8 00 00 00       	push   $0xe8
c0104c83:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104c88:	e8 50 b7 ff ff       	call   c01003dd <__panic>

	assert(nr_free == 0);
c0104c8d:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104c92:	85 c0                	test   %eax,%eax
c0104c94:	74 19                	je     c0104caf <basic_check+0x42a>
c0104c96:	68 a1 6c 10 c0       	push   $0xc0106ca1
c0104c9b:	68 de 6a 10 c0       	push   $0xc0106ade
c0104ca0:	68 ea 00 00 00       	push   $0xea
c0104ca5:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104caa:	e8 2e b7 ff ff       	call   c01003dd <__panic>
	free_list = free_list_store;
c0104caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104cb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104cb5:	a3 5c 99 11 c0       	mov    %eax,0xc011995c
c0104cba:	89 15 60 99 11 c0    	mov    %edx,0xc0119960
	nr_free = nr_free_store;
c0104cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cc3:	a3 64 99 11 c0       	mov    %eax,0xc0119964

	free_page(p);
c0104cc8:	83 ec 08             	sub    $0x8,%esp
c0104ccb:	6a 01                	push   $0x1
c0104ccd:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104cd0:	e8 4d e1 ff ff       	call   c0102e22 <free_pages>
c0104cd5:	83 c4 10             	add    $0x10,%esp
	free_page(p1);
c0104cd8:	83 ec 08             	sub    $0x8,%esp
c0104cdb:	6a 01                	push   $0x1
c0104cdd:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ce0:	e8 3d e1 ff ff       	call   c0102e22 <free_pages>
c0104ce5:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
c0104ce8:	83 ec 08             	sub    $0x8,%esp
c0104ceb:	6a 01                	push   $0x1
c0104ced:	ff 75 f4             	pushl  -0xc(%ebp)
c0104cf0:	e8 2d e1 ff ff       	call   c0102e22 <free_pages>
c0104cf5:	83 c4 10             	add    $0x10,%esp
}
c0104cf8:	90                   	nop
c0104cf9:	c9                   	leave  
c0104cfa:	c3                   	ret    

c0104cfb <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104cfb:	55                   	push   %ebp
c0104cfc:	89 e5                	mov    %esp,%ebp
c0104cfe:	81 ec 88 00 00 00    	sub    $0x88,%esp
	int count = 0, total = 0;
c0104d04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	list_entry_t *le = &free_list;
c0104d12:	c7 45 ec 5c 99 11 c0 	movl   $0xc011995c,-0x14(%ebp)
	//����������������Ƿ�ÿ��page��propertyλ����1��ʾ����
	while ((le = list_next(le)) != &free_list) {
c0104d19:	eb 60                	jmp    c0104d7b <default_check+0x80>
		struct Page *p = le2page(le, page_link);
c0104d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d1e:	83 e8 0c             	sub    $0xc,%eax
c0104d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(PageProperty(p));
c0104d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d27:	83 c0 04             	add    $0x4,%eax
c0104d2a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104d31:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104d37:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104d3a:	0f a3 10             	bt     %edx,(%eax)
c0104d3d:	19 c0                	sbb    %eax,%eax
c0104d3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104d42:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104d46:	0f 95 c0             	setne  %al
c0104d49:	0f b6 c0             	movzbl %al,%eax
c0104d4c:	85 c0                	test   %eax,%eax
c0104d4e:	75 19                	jne    c0104d69 <default_check+0x6e>
c0104d50:	68 ae 6c 10 c0       	push   $0xc0106cae
c0104d55:	68 de 6a 10 c0       	push   $0xc0106ade
c0104d5a:	68 fc 00 00 00       	push   $0xfc
c0104d5f:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104d64:	e8 74 b6 ff ff       	call   c01003dd <__panic>
		count++, total += p->property;
c0104d69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d70:	8b 50 08             	mov    0x8(%eax),%edx
c0104d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d76:	01 d0                	add    %edx,%eax
c0104d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104d81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d84:	8b 40 04             	mov    0x4(%eax),%eax
	while ((le = list_next(le)) != &free_list) {
c0104d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d8a:	81 7d ec 5c 99 11 c0 	cmpl   $0xc011995c,-0x14(%ebp)
c0104d91:	75 88                	jne    c0104d1b <default_check+0x20>
	}
	assert(total == nr_free_pages());
c0104d93:	e8 bf e0 ff ff       	call   c0102e57 <nr_free_pages>
c0104d98:	89 c2                	mov    %eax,%edx
c0104d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d9d:	39 c2                	cmp    %eax,%edx
c0104d9f:	74 19                	je     c0104dba <default_check+0xbf>
c0104da1:	68 be 6c 10 c0       	push   $0xc0106cbe
c0104da6:	68 de 6a 10 c0       	push   $0xc0106ade
c0104dab:	68 ff 00 00 00       	push   $0xff
c0104db0:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104db5:	e8 23 b6 ff ff       	call   c01003dd <__panic>

	basic_check();
c0104dba:	e8 c6 fa ff ff       	call   c0104885 <basic_check>

	struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104dbf:	83 ec 0c             	sub    $0xc,%esp
c0104dc2:	6a 05                	push   $0x5
c0104dc4:	e8 1b e0 ff ff       	call   c0102de4 <alloc_pages>
c0104dc9:	83 c4 10             	add    $0x10,%esp
c0104dcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	assert(p0 != NULL);
c0104dcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104dd3:	75 19                	jne    c0104dee <default_check+0xf3>
c0104dd5:	68 d7 6c 10 c0       	push   $0xc0106cd7
c0104dda:	68 de 6a 10 c0       	push   $0xc0106ade
c0104ddf:	68 04 01 00 00       	push   $0x104
c0104de4:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104de9:	e8 ef b5 ff ff       	call   c01003dd <__panic>
	assert(!PageProperty(p0));
c0104dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104df1:	83 c0 04             	add    $0x4,%eax
c0104df4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104dfb:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dfe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104e01:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104e04:	0f a3 10             	bt     %edx,(%eax)
c0104e07:	19 c0                	sbb    %eax,%eax
c0104e09:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104e0c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104e10:	0f 95 c0             	setne  %al
c0104e13:	0f b6 c0             	movzbl %al,%eax
c0104e16:	85 c0                	test   %eax,%eax
c0104e18:	74 19                	je     c0104e33 <default_check+0x138>
c0104e1a:	68 e2 6c 10 c0       	push   $0xc0106ce2
c0104e1f:	68 de 6a 10 c0       	push   $0xc0106ade
c0104e24:	68 05 01 00 00       	push   $0x105
c0104e29:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104e2e:	e8 aa b5 ff ff       	call   c01003dd <__panic>

	list_entry_t free_list_store = free_list;
c0104e33:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0104e38:	8b 15 60 99 11 c0    	mov    0xc0119960,%edx
c0104e3e:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104e41:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104e44:	c7 45 b0 5c 99 11 c0 	movl   $0xc011995c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104e4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e4e:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104e51:	89 50 04             	mov    %edx,0x4(%eax)
c0104e54:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e57:	8b 50 04             	mov    0x4(%eax),%edx
c0104e5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e5d:	89 10                	mov    %edx,(%eax)
c0104e5f:	c7 45 b4 5c 99 11 c0 	movl   $0xc011995c,-0x4c(%ebp)
    return list->next == list;
c0104e66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104e69:	8b 40 04             	mov    0x4(%eax),%eax
c0104e6c:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104e6f:	0f 94 c0             	sete   %al
c0104e72:	0f b6 c0             	movzbl %al,%eax
	list_init(&free_list);
	assert(list_empty(&free_list));
c0104e75:	85 c0                	test   %eax,%eax
c0104e77:	75 19                	jne    c0104e92 <default_check+0x197>
c0104e79:	68 37 6c 10 c0       	push   $0xc0106c37
c0104e7e:	68 de 6a 10 c0       	push   $0xc0106ade
c0104e83:	68 09 01 00 00       	push   $0x109
c0104e88:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104e8d:	e8 4b b5 ff ff       	call   c01003dd <__panic>
	assert(alloc_page() == NULL);
c0104e92:	83 ec 0c             	sub    $0xc,%esp
c0104e95:	6a 01                	push   $0x1
c0104e97:	e8 48 df ff ff       	call   c0102de4 <alloc_pages>
c0104e9c:	83 c4 10             	add    $0x10,%esp
c0104e9f:	85 c0                	test   %eax,%eax
c0104ea1:	74 19                	je     c0104ebc <default_check+0x1c1>
c0104ea3:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0104ea8:	68 de 6a 10 c0       	push   $0xc0106ade
c0104ead:	68 0a 01 00 00       	push   $0x10a
c0104eb2:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104eb7:	e8 21 b5 ff ff       	call   c01003dd <__panic>

	unsigned int nr_free_store = nr_free;
c0104ebc:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	nr_free = 0;
c0104ec4:	c7 05 64 99 11 c0 00 	movl   $0x0,0xc0119964
c0104ecb:	00 00 00 

	free_pages(p0 + 2, 3);
c0104ece:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ed1:	83 c0 28             	add    $0x28,%eax
c0104ed4:	83 ec 08             	sub    $0x8,%esp
c0104ed7:	6a 03                	push   $0x3
c0104ed9:	50                   	push   %eax
c0104eda:	e8 43 df ff ff       	call   c0102e22 <free_pages>
c0104edf:	83 c4 10             	add    $0x10,%esp
	assert(alloc_pages(4) == NULL);
c0104ee2:	83 ec 0c             	sub    $0xc,%esp
c0104ee5:	6a 04                	push   $0x4
c0104ee7:	e8 f8 de ff ff       	call   c0102de4 <alloc_pages>
c0104eec:	83 c4 10             	add    $0x10,%esp
c0104eef:	85 c0                	test   %eax,%eax
c0104ef1:	74 19                	je     c0104f0c <default_check+0x211>
c0104ef3:	68 f4 6c 10 c0       	push   $0xc0106cf4
c0104ef8:	68 de 6a 10 c0       	push   $0xc0106ade
c0104efd:	68 10 01 00 00       	push   $0x110
c0104f02:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104f07:	e8 d1 b4 ff ff       	call   c01003dd <__panic>
	assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f0f:	83 c0 28             	add    $0x28,%eax
c0104f12:	83 c0 04             	add    $0x4,%eax
c0104f15:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104f1c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f1f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f22:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104f25:	0f a3 10             	bt     %edx,(%eax)
c0104f28:	19 c0                	sbb    %eax,%eax
c0104f2a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104f2d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104f31:	0f 95 c0             	setne  %al
c0104f34:	0f b6 c0             	movzbl %al,%eax
c0104f37:	85 c0                	test   %eax,%eax
c0104f39:	74 0e                	je     c0104f49 <default_check+0x24e>
c0104f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f3e:	83 c0 28             	add    $0x28,%eax
c0104f41:	8b 40 08             	mov    0x8(%eax),%eax
c0104f44:	83 f8 03             	cmp    $0x3,%eax
c0104f47:	74 19                	je     c0104f62 <default_check+0x267>
c0104f49:	68 0c 6d 10 c0       	push   $0xc0106d0c
c0104f4e:	68 de 6a 10 c0       	push   $0xc0106ade
c0104f53:	68 11 01 00 00       	push   $0x111
c0104f58:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104f5d:	e8 7b b4 ff ff       	call   c01003dd <__panic>
	assert((p1 = alloc_pages(3)) != NULL);
c0104f62:	83 ec 0c             	sub    $0xc,%esp
c0104f65:	6a 03                	push   $0x3
c0104f67:	e8 78 de ff ff       	call   c0102de4 <alloc_pages>
c0104f6c:	83 c4 10             	add    $0x10,%esp
c0104f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104f76:	75 19                	jne    c0104f91 <default_check+0x296>
c0104f78:	68 38 6d 10 c0       	push   $0xc0106d38
c0104f7d:	68 de 6a 10 c0       	push   $0xc0106ade
c0104f82:	68 12 01 00 00       	push   $0x112
c0104f87:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104f8c:	e8 4c b4 ff ff       	call   c01003dd <__panic>
	assert(alloc_page() == NULL);
c0104f91:	83 ec 0c             	sub    $0xc,%esp
c0104f94:	6a 01                	push   $0x1
c0104f96:	e8 49 de ff ff       	call   c0102de4 <alloc_pages>
c0104f9b:	83 c4 10             	add    $0x10,%esp
c0104f9e:	85 c0                	test   %eax,%eax
c0104fa0:	74 19                	je     c0104fbb <default_check+0x2c0>
c0104fa2:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0104fa7:	68 de 6a 10 c0       	push   $0xc0106ade
c0104fac:	68 13 01 00 00       	push   $0x113
c0104fb1:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104fb6:	e8 22 b4 ff ff       	call   c01003dd <__panic>
	assert(p0 + 2 == p1);
c0104fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fbe:	83 c0 28             	add    $0x28,%eax
c0104fc1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104fc4:	74 19                	je     c0104fdf <default_check+0x2e4>
c0104fc6:	68 56 6d 10 c0       	push   $0xc0106d56
c0104fcb:	68 de 6a 10 c0       	push   $0xc0106ade
c0104fd0:	68 14 01 00 00       	push   $0x114
c0104fd5:	68 f3 6a 10 c0       	push   $0xc0106af3
c0104fda:	e8 fe b3 ff ff       	call   c01003dd <__panic>

	p2 = p0 + 1;
c0104fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fe2:	83 c0 14             	add    $0x14,%eax
c0104fe5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	free_page(p0);
c0104fe8:	83 ec 08             	sub    $0x8,%esp
c0104feb:	6a 01                	push   $0x1
c0104fed:	ff 75 e8             	pushl  -0x18(%ebp)
c0104ff0:	e8 2d de ff ff       	call   c0102e22 <free_pages>
c0104ff5:	83 c4 10             	add    $0x10,%esp
	free_pages(p1, 3);
c0104ff8:	83 ec 08             	sub    $0x8,%esp
c0104ffb:	6a 03                	push   $0x3
c0104ffd:	ff 75 e0             	pushl  -0x20(%ebp)
c0105000:	e8 1d de ff ff       	call   c0102e22 <free_pages>
c0105005:	83 c4 10             	add    $0x10,%esp
	assert(PageProperty(p0) && p0->property == 1);
c0105008:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010500b:	83 c0 04             	add    $0x4,%eax
c010500e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105015:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105018:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010501b:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010501e:	0f a3 10             	bt     %edx,(%eax)
c0105021:	19 c0                	sbb    %eax,%eax
c0105023:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105026:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010502a:	0f 95 c0             	setne  %al
c010502d:	0f b6 c0             	movzbl %al,%eax
c0105030:	85 c0                	test   %eax,%eax
c0105032:	74 0b                	je     c010503f <default_check+0x344>
c0105034:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105037:	8b 40 08             	mov    0x8(%eax),%eax
c010503a:	83 f8 01             	cmp    $0x1,%eax
c010503d:	74 19                	je     c0105058 <default_check+0x35d>
c010503f:	68 64 6d 10 c0       	push   $0xc0106d64
c0105044:	68 de 6a 10 c0       	push   $0xc0106ade
c0105049:	68 19 01 00 00       	push   $0x119
c010504e:	68 f3 6a 10 c0       	push   $0xc0106af3
c0105053:	e8 85 b3 ff ff       	call   c01003dd <__panic>
	assert(PageProperty(p1) && p1->property == 3);
c0105058:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010505b:	83 c0 04             	add    $0x4,%eax
c010505e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105065:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105068:	8b 45 90             	mov    -0x70(%ebp),%eax
c010506b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010506e:	0f a3 10             	bt     %edx,(%eax)
c0105071:	19 c0                	sbb    %eax,%eax
c0105073:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105076:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010507a:	0f 95 c0             	setne  %al
c010507d:	0f b6 c0             	movzbl %al,%eax
c0105080:	85 c0                	test   %eax,%eax
c0105082:	74 0b                	je     c010508f <default_check+0x394>
c0105084:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105087:	8b 40 08             	mov    0x8(%eax),%eax
c010508a:	83 f8 03             	cmp    $0x3,%eax
c010508d:	74 19                	je     c01050a8 <default_check+0x3ad>
c010508f:	68 8c 6d 10 c0       	push   $0xc0106d8c
c0105094:	68 de 6a 10 c0       	push   $0xc0106ade
c0105099:	68 1a 01 00 00       	push   $0x11a
c010509e:	68 f3 6a 10 c0       	push   $0xc0106af3
c01050a3:	e8 35 b3 ff ff       	call   c01003dd <__panic>

	assert((p0 = alloc_page()) == p2 - 1);
c01050a8:	83 ec 0c             	sub    $0xc,%esp
c01050ab:	6a 01                	push   $0x1
c01050ad:	e8 32 dd ff ff       	call   c0102de4 <alloc_pages>
c01050b2:	83 c4 10             	add    $0x10,%esp
c01050b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050bb:	83 e8 14             	sub    $0x14,%eax
c01050be:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01050c1:	74 19                	je     c01050dc <default_check+0x3e1>
c01050c3:	68 b2 6d 10 c0       	push   $0xc0106db2
c01050c8:	68 de 6a 10 c0       	push   $0xc0106ade
c01050cd:	68 1c 01 00 00       	push   $0x11c
c01050d2:	68 f3 6a 10 c0       	push   $0xc0106af3
c01050d7:	e8 01 b3 ff ff       	call   c01003dd <__panic>
	free_page(p0);
c01050dc:	83 ec 08             	sub    $0x8,%esp
c01050df:	6a 01                	push   $0x1
c01050e1:	ff 75 e8             	pushl  -0x18(%ebp)
c01050e4:	e8 39 dd ff ff       	call   c0102e22 <free_pages>
c01050e9:	83 c4 10             	add    $0x10,%esp
	assert((p0 = alloc_pages(2)) == p2 + 1);
c01050ec:	83 ec 0c             	sub    $0xc,%esp
c01050ef:	6a 02                	push   $0x2
c01050f1:	e8 ee dc ff ff       	call   c0102de4 <alloc_pages>
c01050f6:	83 c4 10             	add    $0x10,%esp
c01050f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050ff:	83 c0 14             	add    $0x14,%eax
c0105102:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105105:	74 19                	je     c0105120 <default_check+0x425>
c0105107:	68 d0 6d 10 c0       	push   $0xc0106dd0
c010510c:	68 de 6a 10 c0       	push   $0xc0106ade
c0105111:	68 1e 01 00 00       	push   $0x11e
c0105116:	68 f3 6a 10 c0       	push   $0xc0106af3
c010511b:	e8 bd b2 ff ff       	call   c01003dd <__panic>

	free_pages(p0, 2);
c0105120:	83 ec 08             	sub    $0x8,%esp
c0105123:	6a 02                	push   $0x2
c0105125:	ff 75 e8             	pushl  -0x18(%ebp)
c0105128:	e8 f5 dc ff ff       	call   c0102e22 <free_pages>
c010512d:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
c0105130:	83 ec 08             	sub    $0x8,%esp
c0105133:	6a 01                	push   $0x1
c0105135:	ff 75 dc             	pushl  -0x24(%ebp)
c0105138:	e8 e5 dc ff ff       	call   c0102e22 <free_pages>
c010513d:	83 c4 10             	add    $0x10,%esp

	assert((p0 = alloc_pages(5)) != NULL);
c0105140:	83 ec 0c             	sub    $0xc,%esp
c0105143:	6a 05                	push   $0x5
c0105145:	e8 9a dc ff ff       	call   c0102de4 <alloc_pages>
c010514a:	83 c4 10             	add    $0x10,%esp
c010514d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105150:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105154:	75 19                	jne    c010516f <default_check+0x474>
c0105156:	68 f0 6d 10 c0       	push   $0xc0106df0
c010515b:	68 de 6a 10 c0       	push   $0xc0106ade
c0105160:	68 23 01 00 00       	push   $0x123
c0105165:	68 f3 6a 10 c0       	push   $0xc0106af3
c010516a:	e8 6e b2 ff ff       	call   c01003dd <__panic>
	assert(alloc_page() == NULL);
c010516f:	83 ec 0c             	sub    $0xc,%esp
c0105172:	6a 01                	push   $0x1
c0105174:	e8 6b dc ff ff       	call   c0102de4 <alloc_pages>
c0105179:	83 c4 10             	add    $0x10,%esp
c010517c:	85 c0                	test   %eax,%eax
c010517e:	74 19                	je     c0105199 <default_check+0x49e>
c0105180:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0105185:	68 de 6a 10 c0       	push   $0xc0106ade
c010518a:	68 24 01 00 00       	push   $0x124
c010518f:	68 f3 6a 10 c0       	push   $0xc0106af3
c0105194:	e8 44 b2 ff ff       	call   c01003dd <__panic>

	assert(nr_free == 0);
c0105199:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c010519e:	85 c0                	test   %eax,%eax
c01051a0:	74 19                	je     c01051bb <default_check+0x4c0>
c01051a2:	68 a1 6c 10 c0       	push   $0xc0106ca1
c01051a7:	68 de 6a 10 c0       	push   $0xc0106ade
c01051ac:	68 26 01 00 00       	push   $0x126
c01051b1:	68 f3 6a 10 c0       	push   $0xc0106af3
c01051b6:	e8 22 b2 ff ff       	call   c01003dd <__panic>
	nr_free = nr_free_store;
c01051bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051be:	a3 64 99 11 c0       	mov    %eax,0xc0119964

	free_list = free_list_store;
c01051c3:	8b 45 80             	mov    -0x80(%ebp),%eax
c01051c6:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01051c9:	a3 5c 99 11 c0       	mov    %eax,0xc011995c
c01051ce:	89 15 60 99 11 c0    	mov    %edx,0xc0119960
	free_pages(p0, 5);
c01051d4:	83 ec 08             	sub    $0x8,%esp
c01051d7:	6a 05                	push   $0x5
c01051d9:	ff 75 e8             	pushl  -0x18(%ebp)
c01051dc:	e8 41 dc ff ff       	call   c0102e22 <free_pages>
c01051e1:	83 c4 10             	add    $0x10,%esp

	le = &free_list;
c01051e4:	c7 45 ec 5c 99 11 c0 	movl   $0xc011995c,-0x14(%ebp)
	while ((le = list_next(le)) != &free_list) {
c01051eb:	eb 1d                	jmp    c010520a <default_check+0x50f>
		struct Page *p = le2page(le, page_link);
c01051ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051f0:	83 e8 0c             	sub    $0xc,%eax
c01051f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		count--, total -= p->property;
c01051f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01051fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105200:	8b 40 08             	mov    0x8(%eax),%eax
c0105203:	29 c2                	sub    %eax,%edx
c0105205:	89 d0                	mov    %edx,%eax
c0105207:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010520a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010520d:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105210:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105213:	8b 40 04             	mov    0x4(%eax),%eax
	while ((le = list_next(le)) != &free_list) {
c0105216:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105219:	81 7d ec 5c 99 11 c0 	cmpl   $0xc011995c,-0x14(%ebp)
c0105220:	75 cb                	jne    c01051ed <default_check+0x4f2>
	}
	assert(count == 0);
c0105222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105226:	74 19                	je     c0105241 <default_check+0x546>
c0105228:	68 0e 6e 10 c0       	push   $0xc0106e0e
c010522d:	68 de 6a 10 c0       	push   $0xc0106ade
c0105232:	68 31 01 00 00       	push   $0x131
c0105237:	68 f3 6a 10 c0       	push   $0xc0106af3
c010523c:	e8 9c b1 ff ff       	call   c01003dd <__panic>
	assert(total == 0);
c0105241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105245:	74 19                	je     c0105260 <default_check+0x565>
c0105247:	68 19 6e 10 c0       	push   $0xc0106e19
c010524c:	68 de 6a 10 c0       	push   $0xc0106ade
c0105251:	68 32 01 00 00       	push   $0x132
c0105256:	68 f3 6a 10 c0       	push   $0xc0106af3
c010525b:	e8 7d b1 ff ff       	call   c01003dd <__panic>
}
c0105260:	90                   	nop
c0105261:	c9                   	leave  
c0105262:	c3                   	ret    

c0105263 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105263:	55                   	push   %ebp
c0105264:	89 e5                	mov    %esp,%ebp
c0105266:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105270:	eb 04                	jmp    c0105276 <strlen+0x13>
        cnt ++;
c0105272:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105276:	8b 45 08             	mov    0x8(%ebp),%eax
c0105279:	8d 50 01             	lea    0x1(%eax),%edx
c010527c:	89 55 08             	mov    %edx,0x8(%ebp)
c010527f:	0f b6 00             	movzbl (%eax),%eax
c0105282:	84 c0                	test   %al,%al
c0105284:	75 ec                	jne    c0105272 <strlen+0xf>
    }
    return cnt;
c0105286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105289:	c9                   	leave  
c010528a:	c3                   	ret    

c010528b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010528b:	55                   	push   %ebp
c010528c:	89 e5                	mov    %esp,%ebp
c010528e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105298:	eb 04                	jmp    c010529e <strnlen+0x13>
        cnt ++;
c010529a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010529e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052a4:	73 10                	jae    c01052b6 <strnlen+0x2b>
c01052a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a9:	8d 50 01             	lea    0x1(%eax),%edx
c01052ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01052af:	0f b6 00             	movzbl (%eax),%eax
c01052b2:	84 c0                	test   %al,%al
c01052b4:	75 e4                	jne    c010529a <strnlen+0xf>
    }
    return cnt;
c01052b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01052b9:	c9                   	leave  
c01052ba:	c3                   	ret    

c01052bb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01052bb:	55                   	push   %ebp
c01052bc:	89 e5                	mov    %esp,%ebp
c01052be:	57                   	push   %edi
c01052bf:	56                   	push   %esi
c01052c0:	83 ec 20             	sub    $0x20,%esp
c01052c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01052cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052d5:	89 d1                	mov    %edx,%ecx
c01052d7:	89 c2                	mov    %eax,%edx
c01052d9:	89 ce                	mov    %ecx,%esi
c01052db:	89 d7                	mov    %edx,%edi
c01052dd:	ac                   	lods   %ds:(%esi),%al
c01052de:	aa                   	stos   %al,%es:(%edi)
c01052df:	84 c0                	test   %al,%al
c01052e1:	75 fa                	jne    c01052dd <strcpy+0x22>
c01052e3:	89 fa                	mov    %edi,%edx
c01052e5:	89 f1                	mov    %esi,%ecx
c01052e7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01052ea:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01052ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01052f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01052f3:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01052f4:	83 c4 20             	add    $0x20,%esp
c01052f7:	5e                   	pop    %esi
c01052f8:	5f                   	pop    %edi
c01052f9:	5d                   	pop    %ebp
c01052fa:	c3                   	ret    

c01052fb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01052fb:	55                   	push   %ebp
c01052fc:	89 e5                	mov    %esp,%ebp
c01052fe:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105301:	8b 45 08             	mov    0x8(%ebp),%eax
c0105304:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105307:	eb 21                	jmp    c010532a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010530c:	0f b6 10             	movzbl (%eax),%edx
c010530f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105312:	88 10                	mov    %dl,(%eax)
c0105314:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105317:	0f b6 00             	movzbl (%eax),%eax
c010531a:	84 c0                	test   %al,%al
c010531c:	74 04                	je     c0105322 <strncpy+0x27>
            src ++;
c010531e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105322:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105326:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c010532a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010532e:	75 d9                	jne    c0105309 <strncpy+0xe>
    }
    return dst;
c0105330:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105333:	c9                   	leave  
c0105334:	c3                   	ret    

c0105335 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105335:	55                   	push   %ebp
c0105336:	89 e5                	mov    %esp,%ebp
c0105338:	57                   	push   %edi
c0105339:	56                   	push   %esi
c010533a:	83 ec 20             	sub    $0x20,%esp
c010533d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105340:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105343:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105346:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105349:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010534c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010534f:	89 d1                	mov    %edx,%ecx
c0105351:	89 c2                	mov    %eax,%edx
c0105353:	89 ce                	mov    %ecx,%esi
c0105355:	89 d7                	mov    %edx,%edi
c0105357:	ac                   	lods   %ds:(%esi),%al
c0105358:	ae                   	scas   %es:(%edi),%al
c0105359:	75 08                	jne    c0105363 <strcmp+0x2e>
c010535b:	84 c0                	test   %al,%al
c010535d:	75 f8                	jne    c0105357 <strcmp+0x22>
c010535f:	31 c0                	xor    %eax,%eax
c0105361:	eb 04                	jmp    c0105367 <strcmp+0x32>
c0105363:	19 c0                	sbb    %eax,%eax
c0105365:	0c 01                	or     $0x1,%al
c0105367:	89 fa                	mov    %edi,%edx
c0105369:	89 f1                	mov    %esi,%ecx
c010536b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010536e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105371:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105374:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105377:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105378:	83 c4 20             	add    $0x20,%esp
c010537b:	5e                   	pop    %esi
c010537c:	5f                   	pop    %edi
c010537d:	5d                   	pop    %ebp
c010537e:	c3                   	ret    

c010537f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010537f:	55                   	push   %ebp
c0105380:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105382:	eb 0c                	jmp    c0105390 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105384:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105388:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010538c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105394:	74 1a                	je     c01053b0 <strncmp+0x31>
c0105396:	8b 45 08             	mov    0x8(%ebp),%eax
c0105399:	0f b6 00             	movzbl (%eax),%eax
c010539c:	84 c0                	test   %al,%al
c010539e:	74 10                	je     c01053b0 <strncmp+0x31>
c01053a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a3:	0f b6 10             	movzbl (%eax),%edx
c01053a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053a9:	0f b6 00             	movzbl (%eax),%eax
c01053ac:	38 c2                	cmp    %al,%dl
c01053ae:	74 d4                	je     c0105384 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01053b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053b4:	74 18                	je     c01053ce <strncmp+0x4f>
c01053b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b9:	0f b6 00             	movzbl (%eax),%eax
c01053bc:	0f b6 d0             	movzbl %al,%edx
c01053bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053c2:	0f b6 00             	movzbl (%eax),%eax
c01053c5:	0f b6 c0             	movzbl %al,%eax
c01053c8:	29 c2                	sub    %eax,%edx
c01053ca:	89 d0                	mov    %edx,%eax
c01053cc:	eb 05                	jmp    c01053d3 <strncmp+0x54>
c01053ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053d3:	5d                   	pop    %ebp
c01053d4:	c3                   	ret    

c01053d5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01053d5:	55                   	push   %ebp
c01053d6:	89 e5                	mov    %esp,%ebp
c01053d8:	83 ec 04             	sub    $0x4,%esp
c01053db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053de:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01053e1:	eb 14                	jmp    c01053f7 <strchr+0x22>
        if (*s == c) {
c01053e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e6:	0f b6 00             	movzbl (%eax),%eax
c01053e9:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01053ec:	75 05                	jne    c01053f3 <strchr+0x1e>
            return (char *)s;
c01053ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f1:	eb 13                	jmp    c0105406 <strchr+0x31>
        }
        s ++;
c01053f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01053f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fa:	0f b6 00             	movzbl (%eax),%eax
c01053fd:	84 c0                	test   %al,%al
c01053ff:	75 e2                	jne    c01053e3 <strchr+0xe>
    }
    return NULL;
c0105401:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105406:	c9                   	leave  
c0105407:	c3                   	ret    

c0105408 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105408:	55                   	push   %ebp
c0105409:	89 e5                	mov    %esp,%ebp
c010540b:	83 ec 04             	sub    $0x4,%esp
c010540e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105411:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105414:	eb 0f                	jmp    c0105425 <strfind+0x1d>
        if (*s == c) {
c0105416:	8b 45 08             	mov    0x8(%ebp),%eax
c0105419:	0f b6 00             	movzbl (%eax),%eax
c010541c:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010541f:	74 10                	je     c0105431 <strfind+0x29>
            break;
        }
        s ++;
c0105421:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105425:	8b 45 08             	mov    0x8(%ebp),%eax
c0105428:	0f b6 00             	movzbl (%eax),%eax
c010542b:	84 c0                	test   %al,%al
c010542d:	75 e7                	jne    c0105416 <strfind+0xe>
c010542f:	eb 01                	jmp    c0105432 <strfind+0x2a>
            break;
c0105431:	90                   	nop
    }
    return (char *)s;
c0105432:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105435:	c9                   	leave  
c0105436:	c3                   	ret    

c0105437 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105437:	55                   	push   %ebp
c0105438:	89 e5                	mov    %esp,%ebp
c010543a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010543d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105444:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010544b:	eb 04                	jmp    c0105451 <strtol+0x1a>
        s ++;
c010544d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105451:	8b 45 08             	mov    0x8(%ebp),%eax
c0105454:	0f b6 00             	movzbl (%eax),%eax
c0105457:	3c 20                	cmp    $0x20,%al
c0105459:	74 f2                	je     c010544d <strtol+0x16>
c010545b:	8b 45 08             	mov    0x8(%ebp),%eax
c010545e:	0f b6 00             	movzbl (%eax),%eax
c0105461:	3c 09                	cmp    $0x9,%al
c0105463:	74 e8                	je     c010544d <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105465:	8b 45 08             	mov    0x8(%ebp),%eax
c0105468:	0f b6 00             	movzbl (%eax),%eax
c010546b:	3c 2b                	cmp    $0x2b,%al
c010546d:	75 06                	jne    c0105475 <strtol+0x3e>
        s ++;
c010546f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105473:	eb 15                	jmp    c010548a <strtol+0x53>
    }
    else if (*s == '-') {
c0105475:	8b 45 08             	mov    0x8(%ebp),%eax
c0105478:	0f b6 00             	movzbl (%eax),%eax
c010547b:	3c 2d                	cmp    $0x2d,%al
c010547d:	75 0b                	jne    c010548a <strtol+0x53>
        s ++, neg = 1;
c010547f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010548a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010548e:	74 06                	je     c0105496 <strtol+0x5f>
c0105490:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105494:	75 24                	jne    c01054ba <strtol+0x83>
c0105496:	8b 45 08             	mov    0x8(%ebp),%eax
c0105499:	0f b6 00             	movzbl (%eax),%eax
c010549c:	3c 30                	cmp    $0x30,%al
c010549e:	75 1a                	jne    c01054ba <strtol+0x83>
c01054a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a3:	83 c0 01             	add    $0x1,%eax
c01054a6:	0f b6 00             	movzbl (%eax),%eax
c01054a9:	3c 78                	cmp    $0x78,%al
c01054ab:	75 0d                	jne    c01054ba <strtol+0x83>
        s += 2, base = 16;
c01054ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01054b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01054b8:	eb 2a                	jmp    c01054e4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01054ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054be:	75 17                	jne    c01054d7 <strtol+0xa0>
c01054c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c3:	0f b6 00             	movzbl (%eax),%eax
c01054c6:	3c 30                	cmp    $0x30,%al
c01054c8:	75 0d                	jne    c01054d7 <strtol+0xa0>
        s ++, base = 8;
c01054ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01054ce:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01054d5:	eb 0d                	jmp    c01054e4 <strtol+0xad>
    }
    else if (base == 0) {
c01054d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054db:	75 07                	jne    c01054e4 <strtol+0xad>
        base = 10;
c01054dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01054e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e7:	0f b6 00             	movzbl (%eax),%eax
c01054ea:	3c 2f                	cmp    $0x2f,%al
c01054ec:	7e 1b                	jle    c0105509 <strtol+0xd2>
c01054ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f1:	0f b6 00             	movzbl (%eax),%eax
c01054f4:	3c 39                	cmp    $0x39,%al
c01054f6:	7f 11                	jg     c0105509 <strtol+0xd2>
            dig = *s - '0';
c01054f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fb:	0f b6 00             	movzbl (%eax),%eax
c01054fe:	0f be c0             	movsbl %al,%eax
c0105501:	83 e8 30             	sub    $0x30,%eax
c0105504:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105507:	eb 48                	jmp    c0105551 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105509:	8b 45 08             	mov    0x8(%ebp),%eax
c010550c:	0f b6 00             	movzbl (%eax),%eax
c010550f:	3c 60                	cmp    $0x60,%al
c0105511:	7e 1b                	jle    c010552e <strtol+0xf7>
c0105513:	8b 45 08             	mov    0x8(%ebp),%eax
c0105516:	0f b6 00             	movzbl (%eax),%eax
c0105519:	3c 7a                	cmp    $0x7a,%al
c010551b:	7f 11                	jg     c010552e <strtol+0xf7>
            dig = *s - 'a' + 10;
c010551d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105520:	0f b6 00             	movzbl (%eax),%eax
c0105523:	0f be c0             	movsbl %al,%eax
c0105526:	83 e8 57             	sub    $0x57,%eax
c0105529:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010552c:	eb 23                	jmp    c0105551 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010552e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105531:	0f b6 00             	movzbl (%eax),%eax
c0105534:	3c 40                	cmp    $0x40,%al
c0105536:	7e 3c                	jle    c0105574 <strtol+0x13d>
c0105538:	8b 45 08             	mov    0x8(%ebp),%eax
c010553b:	0f b6 00             	movzbl (%eax),%eax
c010553e:	3c 5a                	cmp    $0x5a,%al
c0105540:	7f 32                	jg     c0105574 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105542:	8b 45 08             	mov    0x8(%ebp),%eax
c0105545:	0f b6 00             	movzbl (%eax),%eax
c0105548:	0f be c0             	movsbl %al,%eax
c010554b:	83 e8 37             	sub    $0x37,%eax
c010554e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105551:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105554:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105557:	7d 1a                	jge    c0105573 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c0105559:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010555d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105560:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105564:	89 c2                	mov    %eax,%edx
c0105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105569:	01 d0                	add    %edx,%eax
c010556b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c010556e:	e9 71 ff ff ff       	jmp    c01054e4 <strtol+0xad>
            break;
c0105573:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105578:	74 08                	je     c0105582 <strtol+0x14b>
        *endptr = (char *) s;
c010557a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010557d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105580:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105582:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105586:	74 07                	je     c010558f <strtol+0x158>
c0105588:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010558b:	f7 d8                	neg    %eax
c010558d:	eb 03                	jmp    c0105592 <strtol+0x15b>
c010558f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105592:	c9                   	leave  
c0105593:	c3                   	ret    

c0105594 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105594:	55                   	push   %ebp
c0105595:	89 e5                	mov    %esp,%ebp
c0105597:	57                   	push   %edi
c0105598:	83 ec 24             	sub    $0x24,%esp
c010559b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010559e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01055a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01055a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01055ab:	88 45 f7             	mov    %al,-0x9(%ebp)
c01055ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01055b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01055b7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01055bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01055be:	89 d7                	mov    %edx,%edi
c01055c0:	f3 aa                	rep stos %al,%es:(%edi)
c01055c2:	89 fa                	mov    %edi,%edx
c01055c4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01055c7:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01055ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055cd:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01055ce:	83 c4 24             	add    $0x24,%esp
c01055d1:	5f                   	pop    %edi
c01055d2:	5d                   	pop    %ebp
c01055d3:	c3                   	ret    

c01055d4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01055d4:	55                   	push   %ebp
c01055d5:	89 e5                	mov    %esp,%ebp
c01055d7:	57                   	push   %edi
c01055d8:	56                   	push   %esi
c01055d9:	53                   	push   %ebx
c01055da:	83 ec 30             	sub    $0x30,%esp
c01055dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ec:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01055ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01055f5:	73 42                	jae    c0105639 <memmove+0x65>
c01055f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105600:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105603:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105606:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105609:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010560c:	c1 e8 02             	shr    $0x2,%eax
c010560f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105611:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105614:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105617:	89 d7                	mov    %edx,%edi
c0105619:	89 c6                	mov    %eax,%esi
c010561b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010561d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105620:	83 e1 03             	and    $0x3,%ecx
c0105623:	74 02                	je     c0105627 <memmove+0x53>
c0105625:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105627:	89 f0                	mov    %esi,%eax
c0105629:	89 fa                	mov    %edi,%edx
c010562b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010562e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105631:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105637:	eb 36                	jmp    c010566f <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105639:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010563c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010563f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105642:	01 c2                	add    %eax,%edx
c0105644:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105647:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010564a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010564d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105650:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105653:	89 c1                	mov    %eax,%ecx
c0105655:	89 d8                	mov    %ebx,%eax
c0105657:	89 d6                	mov    %edx,%esi
c0105659:	89 c7                	mov    %eax,%edi
c010565b:	fd                   	std    
c010565c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010565e:	fc                   	cld    
c010565f:	89 f8                	mov    %edi,%eax
c0105661:	89 f2                	mov    %esi,%edx
c0105663:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105666:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105669:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010566c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010566f:	83 c4 30             	add    $0x30,%esp
c0105672:	5b                   	pop    %ebx
c0105673:	5e                   	pop    %esi
c0105674:	5f                   	pop    %edi
c0105675:	5d                   	pop    %ebp
c0105676:	c3                   	ret    

c0105677 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105677:	55                   	push   %ebp
c0105678:	89 e5                	mov    %esp,%ebp
c010567a:	57                   	push   %edi
c010567b:	56                   	push   %esi
c010567c:	83 ec 20             	sub    $0x20,%esp
c010567f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105682:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105688:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010568b:	8b 45 10             	mov    0x10(%ebp),%eax
c010568e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105694:	c1 e8 02             	shr    $0x2,%eax
c0105697:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105699:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010569c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010569f:	89 d7                	mov    %edx,%edi
c01056a1:	89 c6                	mov    %eax,%esi
c01056a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01056a5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01056a8:	83 e1 03             	and    $0x3,%ecx
c01056ab:	74 02                	je     c01056af <memcpy+0x38>
c01056ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01056af:	89 f0                	mov    %esi,%eax
c01056b1:	89 fa                	mov    %edi,%edx
c01056b3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01056b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01056b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01056bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01056bf:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01056c0:	83 c4 20             	add    $0x20,%esp
c01056c3:	5e                   	pop    %esi
c01056c4:	5f                   	pop    %edi
c01056c5:	5d                   	pop    %ebp
c01056c6:	c3                   	ret    

c01056c7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01056c7:	55                   	push   %ebp
c01056c8:	89 e5                	mov    %esp,%ebp
c01056ca:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01056cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01056d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01056d9:	eb 30                	jmp    c010570b <memcmp+0x44>
        if (*s1 != *s2) {
c01056db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056de:	0f b6 10             	movzbl (%eax),%edx
c01056e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056e4:	0f b6 00             	movzbl (%eax),%eax
c01056e7:	38 c2                	cmp    %al,%dl
c01056e9:	74 18                	je     c0105703 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01056eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056ee:	0f b6 00             	movzbl (%eax),%eax
c01056f1:	0f b6 d0             	movzbl %al,%edx
c01056f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056f7:	0f b6 00             	movzbl (%eax),%eax
c01056fa:	0f b6 c0             	movzbl %al,%eax
c01056fd:	29 c2                	sub    %eax,%edx
c01056ff:	89 d0                	mov    %edx,%eax
c0105701:	eb 1a                	jmp    c010571d <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105703:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105707:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c010570b:	8b 45 10             	mov    0x10(%ebp),%eax
c010570e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105711:	89 55 10             	mov    %edx,0x10(%ebp)
c0105714:	85 c0                	test   %eax,%eax
c0105716:	75 c3                	jne    c01056db <memcmp+0x14>
    }
    return 0;
c0105718:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010571d:	c9                   	leave  
c010571e:	c3                   	ret    

c010571f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010571f:	55                   	push   %ebp
c0105720:	89 e5                	mov    %esp,%ebp
c0105722:	83 ec 38             	sub    $0x38,%esp
c0105725:	8b 45 10             	mov    0x10(%ebp),%eax
c0105728:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010572b:	8b 45 14             	mov    0x14(%ebp),%eax
c010572e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105731:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105737:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010573a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010573d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105743:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105746:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105749:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010574c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010574f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105752:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105759:	74 1c                	je     c0105777 <printnum+0x58>
c010575b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010575e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105763:	f7 75 e4             	divl   -0x1c(%ebp)
c0105766:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105769:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010576c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105771:	f7 75 e4             	divl   -0x1c(%ebp)
c0105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105777:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010577a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010577d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105780:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105783:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105786:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105789:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010578c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010578f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105792:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105795:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105798:	8b 45 18             	mov    0x18(%ebp),%eax
c010579b:	ba 00 00 00 00       	mov    $0x0,%edx
c01057a0:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01057a3:	72 41                	jb     c01057e6 <printnum+0xc7>
c01057a5:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01057a8:	77 05                	ja     c01057af <printnum+0x90>
c01057aa:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01057ad:	72 37                	jb     c01057e6 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01057af:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01057b2:	83 e8 01             	sub    $0x1,%eax
c01057b5:	83 ec 04             	sub    $0x4,%esp
c01057b8:	ff 75 20             	pushl  0x20(%ebp)
c01057bb:	50                   	push   %eax
c01057bc:	ff 75 18             	pushl  0x18(%ebp)
c01057bf:	ff 75 ec             	pushl  -0x14(%ebp)
c01057c2:	ff 75 e8             	pushl  -0x18(%ebp)
c01057c5:	ff 75 0c             	pushl  0xc(%ebp)
c01057c8:	ff 75 08             	pushl  0x8(%ebp)
c01057cb:	e8 4f ff ff ff       	call   c010571f <printnum>
c01057d0:	83 c4 20             	add    $0x20,%esp
c01057d3:	eb 1b                	jmp    c01057f0 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01057d5:	83 ec 08             	sub    $0x8,%esp
c01057d8:	ff 75 0c             	pushl  0xc(%ebp)
c01057db:	ff 75 20             	pushl  0x20(%ebp)
c01057de:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e1:	ff d0                	call   *%eax
c01057e3:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c01057e6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01057ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01057ee:	7f e5                	jg     c01057d5 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01057f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01057f3:	05 d4 6e 10 c0       	add    $0xc0106ed4,%eax
c01057f8:	0f b6 00             	movzbl (%eax),%eax
c01057fb:	0f be c0             	movsbl %al,%eax
c01057fe:	83 ec 08             	sub    $0x8,%esp
c0105801:	ff 75 0c             	pushl  0xc(%ebp)
c0105804:	50                   	push   %eax
c0105805:	8b 45 08             	mov    0x8(%ebp),%eax
c0105808:	ff d0                	call   *%eax
c010580a:	83 c4 10             	add    $0x10,%esp
}
c010580d:	90                   	nop
c010580e:	c9                   	leave  
c010580f:	c3                   	ret    

c0105810 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105810:	55                   	push   %ebp
c0105811:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105813:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105817:	7e 14                	jle    c010582d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105819:	8b 45 08             	mov    0x8(%ebp),%eax
c010581c:	8b 00                	mov    (%eax),%eax
c010581e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105821:	8b 55 08             	mov    0x8(%ebp),%edx
c0105824:	89 0a                	mov    %ecx,(%edx)
c0105826:	8b 50 04             	mov    0x4(%eax),%edx
c0105829:	8b 00                	mov    (%eax),%eax
c010582b:	eb 30                	jmp    c010585d <getuint+0x4d>
    }
    else if (lflag) {
c010582d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105831:	74 16                	je     c0105849 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105833:	8b 45 08             	mov    0x8(%ebp),%eax
c0105836:	8b 00                	mov    (%eax),%eax
c0105838:	8d 48 04             	lea    0x4(%eax),%ecx
c010583b:	8b 55 08             	mov    0x8(%ebp),%edx
c010583e:	89 0a                	mov    %ecx,(%edx)
c0105840:	8b 00                	mov    (%eax),%eax
c0105842:	ba 00 00 00 00       	mov    $0x0,%edx
c0105847:	eb 14                	jmp    c010585d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105849:	8b 45 08             	mov    0x8(%ebp),%eax
c010584c:	8b 00                	mov    (%eax),%eax
c010584e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105851:	8b 55 08             	mov    0x8(%ebp),%edx
c0105854:	89 0a                	mov    %ecx,(%edx)
c0105856:	8b 00                	mov    (%eax),%eax
c0105858:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010585d:	5d                   	pop    %ebp
c010585e:	c3                   	ret    

c010585f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010585f:	55                   	push   %ebp
c0105860:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105862:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105866:	7e 14                	jle    c010587c <getint+0x1d>
        return va_arg(*ap, long long);
c0105868:	8b 45 08             	mov    0x8(%ebp),%eax
c010586b:	8b 00                	mov    (%eax),%eax
c010586d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105870:	8b 55 08             	mov    0x8(%ebp),%edx
c0105873:	89 0a                	mov    %ecx,(%edx)
c0105875:	8b 50 04             	mov    0x4(%eax),%edx
c0105878:	8b 00                	mov    (%eax),%eax
c010587a:	eb 28                	jmp    c01058a4 <getint+0x45>
    }
    else if (lflag) {
c010587c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105880:	74 12                	je     c0105894 <getint+0x35>
        return va_arg(*ap, long);
c0105882:	8b 45 08             	mov    0x8(%ebp),%eax
c0105885:	8b 00                	mov    (%eax),%eax
c0105887:	8d 48 04             	lea    0x4(%eax),%ecx
c010588a:	8b 55 08             	mov    0x8(%ebp),%edx
c010588d:	89 0a                	mov    %ecx,(%edx)
c010588f:	8b 00                	mov    (%eax),%eax
c0105891:	99                   	cltd   
c0105892:	eb 10                	jmp    c01058a4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105894:	8b 45 08             	mov    0x8(%ebp),%eax
c0105897:	8b 00                	mov    (%eax),%eax
c0105899:	8d 48 04             	lea    0x4(%eax),%ecx
c010589c:	8b 55 08             	mov    0x8(%ebp),%edx
c010589f:	89 0a                	mov    %ecx,(%edx)
c01058a1:	8b 00                	mov    (%eax),%eax
c01058a3:	99                   	cltd   
    }
}
c01058a4:	5d                   	pop    %ebp
c01058a5:	c3                   	ret    

c01058a6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01058a6:	55                   	push   %ebp
c01058a7:	89 e5                	mov    %esp,%ebp
c01058a9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01058ac:	8d 45 14             	lea    0x14(%ebp),%eax
c01058af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01058b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b5:	50                   	push   %eax
c01058b6:	ff 75 10             	pushl  0x10(%ebp)
c01058b9:	ff 75 0c             	pushl  0xc(%ebp)
c01058bc:	ff 75 08             	pushl  0x8(%ebp)
c01058bf:	e8 06 00 00 00       	call   c01058ca <vprintfmt>
c01058c4:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01058c7:	90                   	nop
c01058c8:	c9                   	leave  
c01058c9:	c3                   	ret    

c01058ca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01058ca:	55                   	push   %ebp
c01058cb:	89 e5                	mov    %esp,%ebp
c01058cd:	56                   	push   %esi
c01058ce:	53                   	push   %ebx
c01058cf:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058d2:	eb 17                	jmp    c01058eb <vprintfmt+0x21>
            if (ch == '\0') {
c01058d4:	85 db                	test   %ebx,%ebx
c01058d6:	0f 84 8e 03 00 00    	je     c0105c6a <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01058dc:	83 ec 08             	sub    $0x8,%esp
c01058df:	ff 75 0c             	pushl  0xc(%ebp)
c01058e2:	53                   	push   %ebx
c01058e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e6:	ff d0                	call   *%eax
c01058e8:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01058ee:	8d 50 01             	lea    0x1(%eax),%edx
c01058f1:	89 55 10             	mov    %edx,0x10(%ebp)
c01058f4:	0f b6 00             	movzbl (%eax),%eax
c01058f7:	0f b6 d8             	movzbl %al,%ebx
c01058fa:	83 fb 25             	cmp    $0x25,%ebx
c01058fd:	75 d5                	jne    c01058d4 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01058ff:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105903:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010590a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010590d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105910:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105917:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010591a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010591d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105920:	8d 50 01             	lea    0x1(%eax),%edx
c0105923:	89 55 10             	mov    %edx,0x10(%ebp)
c0105926:	0f b6 00             	movzbl (%eax),%eax
c0105929:	0f b6 d8             	movzbl %al,%ebx
c010592c:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010592f:	83 f8 55             	cmp    $0x55,%eax
c0105932:	0f 87 05 03 00 00    	ja     c0105c3d <vprintfmt+0x373>
c0105938:	8b 04 85 f8 6e 10 c0 	mov    -0x3fef9108(,%eax,4),%eax
c010593f:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105941:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105945:	eb d6                	jmp    c010591d <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105947:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010594b:	eb d0                	jmp    c010591d <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010594d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105957:	89 d0                	mov    %edx,%eax
c0105959:	c1 e0 02             	shl    $0x2,%eax
c010595c:	01 d0                	add    %edx,%eax
c010595e:	01 c0                	add    %eax,%eax
c0105960:	01 d8                	add    %ebx,%eax
c0105962:	83 e8 30             	sub    $0x30,%eax
c0105965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105968:	8b 45 10             	mov    0x10(%ebp),%eax
c010596b:	0f b6 00             	movzbl (%eax),%eax
c010596e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105971:	83 fb 2f             	cmp    $0x2f,%ebx
c0105974:	7e 39                	jle    c01059af <vprintfmt+0xe5>
c0105976:	83 fb 39             	cmp    $0x39,%ebx
c0105979:	7f 34                	jg     c01059af <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
c010597b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010597f:	eb d3                	jmp    c0105954 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105981:	8b 45 14             	mov    0x14(%ebp),%eax
c0105984:	8d 50 04             	lea    0x4(%eax),%edx
c0105987:	89 55 14             	mov    %edx,0x14(%ebp)
c010598a:	8b 00                	mov    (%eax),%eax
c010598c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010598f:	eb 1f                	jmp    c01059b0 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105991:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105995:	79 86                	jns    c010591d <vprintfmt+0x53>
                width = 0;
c0105997:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010599e:	e9 7a ff ff ff       	jmp    c010591d <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01059a3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01059aa:	e9 6e ff ff ff       	jmp    c010591d <vprintfmt+0x53>
            goto process_precision;
c01059af:	90                   	nop

        process_precision:
            if (width < 0)
c01059b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059b4:	0f 89 63 ff ff ff    	jns    c010591d <vprintfmt+0x53>
                width = precision, precision = -1;
c01059ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01059c7:	e9 51 ff ff ff       	jmp    c010591d <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01059cc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01059d0:	e9 48 ff ff ff       	jmp    c010591d <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01059d5:	8b 45 14             	mov    0x14(%ebp),%eax
c01059d8:	8d 50 04             	lea    0x4(%eax),%edx
c01059db:	89 55 14             	mov    %edx,0x14(%ebp)
c01059de:	8b 00                	mov    (%eax),%eax
c01059e0:	83 ec 08             	sub    $0x8,%esp
c01059e3:	ff 75 0c             	pushl  0xc(%ebp)
c01059e6:	50                   	push   %eax
c01059e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ea:	ff d0                	call   *%eax
c01059ec:	83 c4 10             	add    $0x10,%esp
            break;
c01059ef:	e9 71 02 00 00       	jmp    c0105c65 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01059f4:	8b 45 14             	mov    0x14(%ebp),%eax
c01059f7:	8d 50 04             	lea    0x4(%eax),%edx
c01059fa:	89 55 14             	mov    %edx,0x14(%ebp)
c01059fd:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01059ff:	85 db                	test   %ebx,%ebx
c0105a01:	79 02                	jns    c0105a05 <vprintfmt+0x13b>
                err = -err;
c0105a03:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105a05:	83 fb 06             	cmp    $0x6,%ebx
c0105a08:	7f 0b                	jg     c0105a15 <vprintfmt+0x14b>
c0105a0a:	8b 34 9d b8 6e 10 c0 	mov    -0x3fef9148(,%ebx,4),%esi
c0105a11:	85 f6                	test   %esi,%esi
c0105a13:	75 19                	jne    c0105a2e <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105a15:	53                   	push   %ebx
c0105a16:	68 e5 6e 10 c0       	push   $0xc0106ee5
c0105a1b:	ff 75 0c             	pushl  0xc(%ebp)
c0105a1e:	ff 75 08             	pushl  0x8(%ebp)
c0105a21:	e8 80 fe ff ff       	call   c01058a6 <printfmt>
c0105a26:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105a29:	e9 37 02 00 00       	jmp    c0105c65 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
c0105a2e:	56                   	push   %esi
c0105a2f:	68 ee 6e 10 c0       	push   $0xc0106eee
c0105a34:	ff 75 0c             	pushl  0xc(%ebp)
c0105a37:	ff 75 08             	pushl  0x8(%ebp)
c0105a3a:	e8 67 fe ff ff       	call   c01058a6 <printfmt>
c0105a3f:	83 c4 10             	add    $0x10,%esp
            break;
c0105a42:	e9 1e 02 00 00       	jmp    c0105c65 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105a47:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a4a:	8d 50 04             	lea    0x4(%eax),%edx
c0105a4d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a50:	8b 30                	mov    (%eax),%esi
c0105a52:	85 f6                	test   %esi,%esi
c0105a54:	75 05                	jne    c0105a5b <vprintfmt+0x191>
                p = "(null)";
c0105a56:	be f1 6e 10 c0       	mov    $0xc0106ef1,%esi
            }
            if (width > 0 && padc != '-') {
c0105a5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a5f:	7e 76                	jle    c0105ad7 <vprintfmt+0x20d>
c0105a61:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105a65:	74 70                	je     c0105ad7 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a6a:	83 ec 08             	sub    $0x8,%esp
c0105a6d:	50                   	push   %eax
c0105a6e:	56                   	push   %esi
c0105a6f:	e8 17 f8 ff ff       	call   c010528b <strnlen>
c0105a74:	83 c4 10             	add    $0x10,%esp
c0105a77:	89 c2                	mov    %eax,%edx
c0105a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a7c:	29 d0                	sub    %edx,%eax
c0105a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a81:	eb 17                	jmp    c0105a9a <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105a83:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105a87:	83 ec 08             	sub    $0x8,%esp
c0105a8a:	ff 75 0c             	pushl  0xc(%ebp)
c0105a8d:	50                   	push   %eax
c0105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a91:	ff d0                	call   *%eax
c0105a93:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a96:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a9e:	7f e3                	jg     c0105a83 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105aa0:	eb 35                	jmp    c0105ad7 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105aa2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105aa6:	74 1c                	je     c0105ac4 <vprintfmt+0x1fa>
c0105aa8:	83 fb 1f             	cmp    $0x1f,%ebx
c0105aab:	7e 05                	jle    c0105ab2 <vprintfmt+0x1e8>
c0105aad:	83 fb 7e             	cmp    $0x7e,%ebx
c0105ab0:	7e 12                	jle    c0105ac4 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105ab2:	83 ec 08             	sub    $0x8,%esp
c0105ab5:	ff 75 0c             	pushl  0xc(%ebp)
c0105ab8:	6a 3f                	push   $0x3f
c0105aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abd:	ff d0                	call   *%eax
c0105abf:	83 c4 10             	add    $0x10,%esp
c0105ac2:	eb 0f                	jmp    c0105ad3 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105ac4:	83 ec 08             	sub    $0x8,%esp
c0105ac7:	ff 75 0c             	pushl  0xc(%ebp)
c0105aca:	53                   	push   %ebx
c0105acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ace:	ff d0                	call   *%eax
c0105ad0:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ad3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ad7:	89 f0                	mov    %esi,%eax
c0105ad9:	8d 70 01             	lea    0x1(%eax),%esi
c0105adc:	0f b6 00             	movzbl (%eax),%eax
c0105adf:	0f be d8             	movsbl %al,%ebx
c0105ae2:	85 db                	test   %ebx,%ebx
c0105ae4:	74 26                	je     c0105b0c <vprintfmt+0x242>
c0105ae6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105aea:	78 b6                	js     c0105aa2 <vprintfmt+0x1d8>
c0105aec:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105af0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105af4:	79 ac                	jns    c0105aa2 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
c0105af6:	eb 14                	jmp    c0105b0c <vprintfmt+0x242>
                putch(' ', putdat);
c0105af8:	83 ec 08             	sub    $0x8,%esp
c0105afb:	ff 75 0c             	pushl  0xc(%ebp)
c0105afe:	6a 20                	push   $0x20
c0105b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b03:	ff d0                	call   *%eax
c0105b05:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105b08:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b10:	7f e6                	jg     c0105af8 <vprintfmt+0x22e>
            }
            break;
c0105b12:	e9 4e 01 00 00       	jmp    c0105c65 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105b17:	83 ec 08             	sub    $0x8,%esp
c0105b1a:	ff 75 e0             	pushl  -0x20(%ebp)
c0105b1d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b20:	50                   	push   %eax
c0105b21:	e8 39 fd ff ff       	call   c010585f <getint>
c0105b26:	83 c4 10             	add    $0x10,%esp
c0105b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b35:	85 d2                	test   %edx,%edx
c0105b37:	79 23                	jns    c0105b5c <vprintfmt+0x292>
                putch('-', putdat);
c0105b39:	83 ec 08             	sub    $0x8,%esp
c0105b3c:	ff 75 0c             	pushl  0xc(%ebp)
c0105b3f:	6a 2d                	push   $0x2d
c0105b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b44:	ff d0                	call   *%eax
c0105b46:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b4f:	f7 d8                	neg    %eax
c0105b51:	83 d2 00             	adc    $0x0,%edx
c0105b54:	f7 da                	neg    %edx
c0105b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b59:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105b5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b63:	e9 9f 00 00 00       	jmp    c0105c07 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105b68:	83 ec 08             	sub    $0x8,%esp
c0105b6b:	ff 75 e0             	pushl  -0x20(%ebp)
c0105b6e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b71:	50                   	push   %eax
c0105b72:	e8 99 fc ff ff       	call   c0105810 <getuint>
c0105b77:	83 c4 10             	add    $0x10,%esp
c0105b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105b80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b87:	eb 7e                	jmp    c0105c07 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105b89:	83 ec 08             	sub    $0x8,%esp
c0105b8c:	ff 75 e0             	pushl  -0x20(%ebp)
c0105b8f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b92:	50                   	push   %eax
c0105b93:	e8 78 fc ff ff       	call   c0105810 <getuint>
c0105b98:	83 c4 10             	add    $0x10,%esp
c0105b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105ba1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105ba8:	eb 5d                	jmp    c0105c07 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105baa:	83 ec 08             	sub    $0x8,%esp
c0105bad:	ff 75 0c             	pushl  0xc(%ebp)
c0105bb0:	6a 30                	push   $0x30
c0105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb5:	ff d0                	call   *%eax
c0105bb7:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105bba:	83 ec 08             	sub    $0x8,%esp
c0105bbd:	ff 75 0c             	pushl  0xc(%ebp)
c0105bc0:	6a 78                	push   $0x78
c0105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc5:	ff d0                	call   *%eax
c0105bc7:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105bca:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bcd:	8d 50 04             	lea    0x4(%eax),%edx
c0105bd0:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bd3:	8b 00                	mov    (%eax),%eax
c0105bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105bdf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105be6:	eb 1f                	jmp    c0105c07 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105be8:	83 ec 08             	sub    $0x8,%esp
c0105beb:	ff 75 e0             	pushl  -0x20(%ebp)
c0105bee:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bf1:	50                   	push   %eax
c0105bf2:	e8 19 fc ff ff       	call   c0105810 <getuint>
c0105bf7:	83 c4 10             	add    $0x10,%esp
c0105bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105c00:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105c07:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c0e:	83 ec 04             	sub    $0x4,%esp
c0105c11:	52                   	push   %edx
c0105c12:	ff 75 e8             	pushl  -0x18(%ebp)
c0105c15:	50                   	push   %eax
c0105c16:	ff 75 f4             	pushl  -0xc(%ebp)
c0105c19:	ff 75 f0             	pushl  -0x10(%ebp)
c0105c1c:	ff 75 0c             	pushl  0xc(%ebp)
c0105c1f:	ff 75 08             	pushl  0x8(%ebp)
c0105c22:	e8 f8 fa ff ff       	call   c010571f <printnum>
c0105c27:	83 c4 20             	add    $0x20,%esp
            break;
c0105c2a:	eb 39                	jmp    c0105c65 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105c2c:	83 ec 08             	sub    $0x8,%esp
c0105c2f:	ff 75 0c             	pushl  0xc(%ebp)
c0105c32:	53                   	push   %ebx
c0105c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c36:	ff d0                	call   *%eax
c0105c38:	83 c4 10             	add    $0x10,%esp
            break;
c0105c3b:	eb 28                	jmp    c0105c65 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105c3d:	83 ec 08             	sub    $0x8,%esp
c0105c40:	ff 75 0c             	pushl  0xc(%ebp)
c0105c43:	6a 25                	push   $0x25
c0105c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c48:	ff d0                	call   *%eax
c0105c4a:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105c4d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c51:	eb 04                	jmp    c0105c57 <vprintfmt+0x38d>
c0105c53:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5a:	83 e8 01             	sub    $0x1,%eax
c0105c5d:	0f b6 00             	movzbl (%eax),%eax
c0105c60:	3c 25                	cmp    $0x25,%al
c0105c62:	75 ef                	jne    c0105c53 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105c64:	90                   	nop
    while (1) {
c0105c65:	e9 68 fc ff ff       	jmp    c01058d2 <vprintfmt+0x8>
                return;
c0105c6a:	90                   	nop
        }
    }
}
c0105c6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105c6e:	5b                   	pop    %ebx
c0105c6f:	5e                   	pop    %esi
c0105c70:	5d                   	pop    %ebp
c0105c71:	c3                   	ret    

c0105c72 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105c72:	55                   	push   %ebp
c0105c73:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105c75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c78:	8b 40 08             	mov    0x8(%eax),%eax
c0105c7b:	8d 50 01             	lea    0x1(%eax),%edx
c0105c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c81:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105c84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c87:	8b 10                	mov    (%eax),%edx
c0105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8c:	8b 40 04             	mov    0x4(%eax),%eax
c0105c8f:	39 c2                	cmp    %eax,%edx
c0105c91:	73 12                	jae    c0105ca5 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105c93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c96:	8b 00                	mov    (%eax),%eax
c0105c98:	8d 48 01             	lea    0x1(%eax),%ecx
c0105c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c9e:	89 0a                	mov    %ecx,(%edx)
c0105ca0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ca3:	88 10                	mov    %dl,(%eax)
    }
}
c0105ca5:	90                   	nop
c0105ca6:	5d                   	pop    %ebp
c0105ca7:	c3                   	ret    

c0105ca8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105ca8:	55                   	push   %ebp
c0105ca9:	89 e5                	mov    %esp,%ebp
c0105cab:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105cae:	8d 45 14             	lea    0x14(%ebp),%eax
c0105cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cb7:	50                   	push   %eax
c0105cb8:	ff 75 10             	pushl  0x10(%ebp)
c0105cbb:	ff 75 0c             	pushl  0xc(%ebp)
c0105cbe:	ff 75 08             	pushl  0x8(%ebp)
c0105cc1:	e8 0b 00 00 00       	call   c0105cd1 <vsnprintf>
c0105cc6:	83 c4 10             	add    $0x10,%esp
c0105cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ccf:	c9                   	leave  
c0105cd0:	c3                   	ret    

c0105cd1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105cd1:	55                   	push   %ebp
c0105cd2:	89 e5                	mov    %esp,%ebp
c0105cd4:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ce0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce6:	01 d0                	add    %edx,%eax
c0105ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105cf6:	74 0a                	je     c0105d02 <vsnprintf+0x31>
c0105cf8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cfe:	39 c2                	cmp    %eax,%edx
c0105d00:	76 07                	jbe    c0105d09 <vsnprintf+0x38>
        return -E_INVAL;
c0105d02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105d07:	eb 20                	jmp    c0105d29 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105d09:	ff 75 14             	pushl  0x14(%ebp)
c0105d0c:	ff 75 10             	pushl  0x10(%ebp)
c0105d0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105d12:	50                   	push   %eax
c0105d13:	68 72 5c 10 c0       	push   $0xc0105c72
c0105d18:	e8 ad fb ff ff       	call   c01058ca <vprintfmt>
c0105d1d:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d23:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d29:	c9                   	leave  
c0105d2a:	c3                   	ret    
