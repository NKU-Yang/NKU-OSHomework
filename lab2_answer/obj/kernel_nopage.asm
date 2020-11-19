
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 80 11 40 	lgdtl  0x40118018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 99 11 00       	mov    $0x119968,%edx
  100035:	b8 36 8a 11 00       	mov    $0x118a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 8a 11 00       	push   $0x118a36
  100049:	e8 46 55 00 00       	call   105594 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 7b 15 00 00       	call   1015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 40 5d 10 00 	movl   $0x105d40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 5c 5d 10 00       	push   $0x105d5c
  100068:	e8 0a 02 00 00       	call   100277 <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 8c 08 00 00       	call   100901 <print_kerninfo>

    grade_backtrace();
  100075:	e8 79 00 00 00       	call   1000f3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 36 33 00 00       	call   1033b5 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 bf 16 00 00       	call   101743 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 41 18 00 00       	call   1018ca <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 e6 0c 00 00       	call   100d74 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 ed 17 00 00       	call   101880 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100093:	e8 50 01 00 00       	call   1001e8 <lab1_switch_test>

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	83 ec 04             	sub    $0x4,%esp
  1000a3:	6a 00                	push   $0x0
  1000a5:	6a 00                	push   $0x0
  1000a7:	6a 00                	push   $0x0
  1000a9:	e8 b4 0c 00 00       	call   100d62 <mon_backtrace>
  1000ae:	83 c4 10             	add    $0x10,%esp
}
  1000b1:	90                   	nop
  1000b2:	c9                   	leave  
  1000b3:	c3                   	ret    

001000b4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000b4:	55                   	push   %ebp
  1000b5:	89 e5                	mov    %esp,%ebp
  1000b7:	53                   	push   %ebx
  1000b8:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000bb:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000be:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000c1:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c7:	51                   	push   %ecx
  1000c8:	52                   	push   %edx
  1000c9:	53                   	push   %ebx
  1000ca:	50                   	push   %eax
  1000cb:	e8 ca ff ff ff       	call   10009a <grade_backtrace2>
  1000d0:	83 c4 10             	add    $0x10,%esp
}
  1000d3:	90                   	nop
  1000d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d7:	c9                   	leave  
  1000d8:	c3                   	ret    

001000d9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d9:	55                   	push   %ebp
  1000da:	89 e5                	mov    %esp,%ebp
  1000dc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000df:	83 ec 08             	sub    $0x8,%esp
  1000e2:	ff 75 10             	pushl  0x10(%ebp)
  1000e5:	ff 75 08             	pushl  0x8(%ebp)
  1000e8:	e8 c7 ff ff ff       	call   1000b4 <grade_backtrace1>
  1000ed:	83 c4 10             	add    $0x10,%esp
}
  1000f0:	90                   	nop
  1000f1:	c9                   	leave  
  1000f2:	c3                   	ret    

001000f3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000fe:	83 ec 04             	sub    $0x4,%esp
  100101:	68 00 00 ff ff       	push   $0xffff0000
  100106:	50                   	push   %eax
  100107:	6a 00                	push   $0x0
  100109:	e8 cb ff ff ff       	call   1000d9 <grade_backtrace0>
  10010e:	83 c4 10             	add    $0x10,%esp
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100114:	55                   	push   %ebp
  100115:	89 e5                	mov    %esp,%ebp
  100117:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10011a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10011d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100120:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100123:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100126:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10012a:	0f b7 c0             	movzwl %ax,%eax
  10012d:	83 e0 03             	and    $0x3,%eax
  100130:	89 c2                	mov    %eax,%edx
  100132:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100137:	83 ec 04             	sub    $0x4,%esp
  10013a:	52                   	push   %edx
  10013b:	50                   	push   %eax
  10013c:	68 61 5d 10 00       	push   $0x105d61
  100141:	e8 31 01 00 00       	call   100277 <cprintf>
  100146:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100149:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014d:	0f b7 d0             	movzwl %ax,%edx
  100150:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100155:	83 ec 04             	sub    $0x4,%esp
  100158:	52                   	push   %edx
  100159:	50                   	push   %eax
  10015a:	68 6f 5d 10 00       	push   $0x105d6f
  10015f:	e8 13 01 00 00       	call   100277 <cprintf>
  100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100167:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10016b:	0f b7 d0             	movzwl %ax,%edx
  10016e:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100173:	83 ec 04             	sub    $0x4,%esp
  100176:	52                   	push   %edx
  100177:	50                   	push   %eax
  100178:	68 7d 5d 10 00       	push   $0x105d7d
  10017d:	e8 f5 00 00 00       	call   100277 <cprintf>
  100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100185:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100189:	0f b7 d0             	movzwl %ax,%edx
  10018c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100191:	83 ec 04             	sub    $0x4,%esp
  100194:	52                   	push   %edx
  100195:	50                   	push   %eax
  100196:	68 8b 5d 10 00       	push   $0x105d8b
  10019b:	e8 d7 00 00 00       	call   100277 <cprintf>
  1001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001a3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a7:	0f b7 d0             	movzwl %ax,%edx
  1001aa:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001af:	83 ec 04             	sub    $0x4,%esp
  1001b2:	52                   	push   %edx
  1001b3:	50                   	push   %eax
  1001b4:	68 99 5d 10 00       	push   $0x105d99
  1001b9:	e8 b9 00 00 00       	call   100277 <cprintf>
  1001be:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001c1:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001c6:	83 c0 01             	add    $0x1,%eax
  1001c9:	a3 40 8a 11 00       	mov    %eax,0x118a40
}
  1001ce:	90                   	nop
  1001cf:	c9                   	leave  
  1001d0:	c3                   	ret    

001001d1 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d1:	55                   	push   %ebp
  1001d2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d4:	83 ec 08             	sub    $0x8,%esp
  1001d7:	cd 78                	int    $0x78
  1001d9:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp"
		:
	: "i"(T_SWITCH_TOU)
		);
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001e1:	cd 79                	int    $0x79
  1001e3:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"
		:
	: "i"(T_SWITCH_TOK)
		);
}
  1001e5:	90                   	nop
  1001e6:	5d                   	pop    %ebp
  1001e7:	c3                   	ret    

001001e8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e8:	55                   	push   %ebp
  1001e9:	89 e5                	mov    %esp,%ebp
  1001eb:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001ee:	e8 21 ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001f3:	83 ec 0c             	sub    $0xc,%esp
  1001f6:	68 a8 5d 10 00       	push   $0x105da8
  1001fb:	e8 77 00 00 00       	call   100277 <cprintf>
  100200:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  100203:	e8 c9 ff ff ff       	call   1001d1 <lab1_switch_to_user>
    lab1_print_cur_status();
  100208:	e8 07 ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10020d:	83 ec 0c             	sub    $0xc,%esp
  100210:	68 c8 5d 10 00       	push   $0x105dc8
  100215:	e8 5d 00 00 00       	call   100277 <cprintf>
  10021a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10021d:	e8 bc ff ff ff       	call   1001de <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100222:	e8 ed fe ff ff       	call   100114 <lab1_print_cur_status>
}
  100227:	90                   	nop
  100228:	c9                   	leave  
  100229:	c3                   	ret    

0010022a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10022a:	55                   	push   %ebp
  10022b:	89 e5                	mov    %esp,%ebp
  10022d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100230:	83 ec 0c             	sub    $0xc,%esp
  100233:	ff 75 08             	pushl  0x8(%ebp)
  100236:	e8 c7 13 00 00       	call   101602 <cons_putc>
  10023b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10023e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100241:	8b 00                	mov    (%eax),%eax
  100243:	8d 50 01             	lea    0x1(%eax),%edx
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 10                	mov    %edx,(%eax)
}
  10024b:	90                   	nop
  10024c:	c9                   	leave  
  10024d:	c3                   	ret    

0010024e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10024e:	55                   	push   %ebp
  10024f:	89 e5                	mov    %esp,%ebp
  100251:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10025b:	ff 75 0c             	pushl  0xc(%ebp)
  10025e:	ff 75 08             	pushl  0x8(%ebp)
  100261:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100264:	50                   	push   %eax
  100265:	68 2a 02 10 00       	push   $0x10022a
  10026a:	e8 5b 56 00 00       	call   1058ca <vprintfmt>
  10026f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100272:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100275:	c9                   	leave  
  100276:	c3                   	ret    

00100277 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100277:	55                   	push   %ebp
  100278:	89 e5                	mov    %esp,%ebp
  10027a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10027d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100280:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100286:	83 ec 08             	sub    $0x8,%esp
  100289:	50                   	push   %eax
  10028a:	ff 75 08             	pushl  0x8(%ebp)
  10028d:	e8 bc ff ff ff       	call   10024e <vcprintf>
  100292:	83 c4 10             	add    $0x10,%esp
  100295:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10029b:	c9                   	leave  
  10029c:	c3                   	ret    

0010029d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10029d:	55                   	push   %ebp
  10029e:	89 e5                	mov    %esp,%ebp
  1002a0:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002a3:	83 ec 0c             	sub    $0xc,%esp
  1002a6:	ff 75 08             	pushl  0x8(%ebp)
  1002a9:	e8 54 13 00 00       	call   101602 <cons_putc>
  1002ae:	83 c4 10             	add    $0x10,%esp
}
  1002b1:	90                   	nop
  1002b2:	c9                   	leave  
  1002b3:	c3                   	ret    

001002b4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002b4:	55                   	push   %ebp
  1002b5:	89 e5                	mov    %esp,%ebp
  1002b7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002c1:	eb 14                	jmp    1002d7 <cputs+0x23>
        cputch(c, &cnt);
  1002c3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002c7:	83 ec 08             	sub    $0x8,%esp
  1002ca:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002cd:	52                   	push   %edx
  1002ce:	50                   	push   %eax
  1002cf:	e8 56 ff ff ff       	call   10022a <cputch>
  1002d4:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002da:	8d 50 01             	lea    0x1(%eax),%edx
  1002dd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002e0:	0f b6 00             	movzbl (%eax),%eax
  1002e3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002e6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ea:	75 d7                	jne    1002c3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002ec:	83 ec 08             	sub    $0x8,%esp
  1002ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002f2:	50                   	push   %eax
  1002f3:	6a 0a                	push   $0xa
  1002f5:	e8 30 ff ff ff       	call   10022a <cputch>
  1002fa:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100300:	c9                   	leave  
  100301:	c3                   	ret    

00100302 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100302:	55                   	push   %ebp
  100303:	89 e5                	mov    %esp,%ebp
  100305:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100308:	e8 3e 13 00 00       	call   10164b <cons_getc>
  10030d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100314:	74 f2                	je     100308 <getchar+0x6>
        /* do nothing */;
    return c;
  100316:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100319:	c9                   	leave  
  10031a:	c3                   	ret    

0010031b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10031b:	55                   	push   %ebp
  10031c:	89 e5                	mov    %esp,%ebp
  10031e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100325:	74 13                	je     10033a <readline+0x1f>
        cprintf("%s", prompt);
  100327:	83 ec 08             	sub    $0x8,%esp
  10032a:	ff 75 08             	pushl  0x8(%ebp)
  10032d:	68 e7 5d 10 00       	push   $0x105de7
  100332:	e8 40 ff ff ff       	call   100277 <cprintf>
  100337:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10033a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100341:	e8 bc ff ff ff       	call   100302 <getchar>
  100346:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100349:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10034d:	79 0a                	jns    100359 <readline+0x3e>
            return NULL;
  10034f:	b8 00 00 00 00       	mov    $0x0,%eax
  100354:	e9 82 00 00 00       	jmp    1003db <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100359:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10035d:	7e 2b                	jle    10038a <readline+0x6f>
  10035f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100366:	7f 22                	jg     10038a <readline+0x6f>
            cputchar(c);
  100368:	83 ec 0c             	sub    $0xc,%esp
  10036b:	ff 75 f0             	pushl  -0x10(%ebp)
  10036e:	e8 2a ff ff ff       	call   10029d <cputchar>
  100373:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100379:	8d 50 01             	lea    0x1(%eax),%edx
  10037c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10037f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100382:	88 90 60 8a 11 00    	mov    %dl,0x118a60(%eax)
  100388:	eb 4c                	jmp    1003d6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10038a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10038e:	75 1a                	jne    1003aa <readline+0x8f>
  100390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100394:	7e 14                	jle    1003aa <readline+0x8f>
            cputchar(c);
  100396:	83 ec 0c             	sub    $0xc,%esp
  100399:	ff 75 f0             	pushl  -0x10(%ebp)
  10039c:	e8 fc fe ff ff       	call   10029d <cputchar>
  1003a1:	83 c4 10             	add    $0x10,%esp
            i --;
  1003a4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003a8:	eb 2c                	jmp    1003d6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  1003aa:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003ae:	74 06                	je     1003b6 <readline+0x9b>
  1003b0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003b4:	75 8b                	jne    100341 <readline+0x26>
            cputchar(c);
  1003b6:	83 ec 0c             	sub    $0xc,%esp
  1003b9:	ff 75 f0             	pushl  -0x10(%ebp)
  1003bc:	e8 dc fe ff ff       	call   10029d <cputchar>
  1003c1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003c7:	05 60 8a 11 00       	add    $0x118a60,%eax
  1003cc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003cf:	b8 60 8a 11 00       	mov    $0x118a60,%eax
  1003d4:	eb 05                	jmp    1003db <readline+0xc0>
        c = getchar();
  1003d6:	e9 66 ff ff ff       	jmp    100341 <readline+0x26>
        }
    }
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003e3:	a1 60 8e 11 00       	mov    0x118e60,%eax
  1003e8:	85 c0                	test   %eax,%eax
  1003ea:	75 4a                	jne    100436 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003ec:	c7 05 60 8e 11 00 01 	movl   $0x1,0x118e60
  1003f3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003f6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003fc:	83 ec 04             	sub    $0x4,%esp
  1003ff:	ff 75 0c             	pushl  0xc(%ebp)
  100402:	ff 75 08             	pushl  0x8(%ebp)
  100405:	68 ea 5d 10 00       	push   $0x105dea
  10040a:	e8 68 fe ff ff       	call   100277 <cprintf>
  10040f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100415:	83 ec 08             	sub    $0x8,%esp
  100418:	50                   	push   %eax
  100419:	ff 75 10             	pushl  0x10(%ebp)
  10041c:	e8 2d fe ff ff       	call   10024e <vcprintf>
  100421:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100424:	83 ec 0c             	sub    $0xc,%esp
  100427:	68 06 5e 10 00       	push   $0x105e06
  10042c:	e8 46 fe ff ff       	call   100277 <cprintf>
  100431:	83 c4 10             	add    $0x10,%esp
  100434:	eb 01                	jmp    100437 <__panic+0x5a>
        goto panic_dead;
  100436:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  100437:	e8 4b 14 00 00       	call   101887 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10043c:	83 ec 0c             	sub    $0xc,%esp
  10043f:	6a 00                	push   $0x0
  100441:	e8 42 08 00 00       	call   100c88 <kmonitor>
  100446:	83 c4 10             	add    $0x10,%esp
  100449:	eb f1                	jmp    10043c <__panic+0x5f>

0010044b <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10044b:	55                   	push   %ebp
  10044c:	89 e5                	mov    %esp,%ebp
  10044e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100451:	8d 45 14             	lea    0x14(%ebp),%eax
  100454:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100457:	83 ec 04             	sub    $0x4,%esp
  10045a:	ff 75 0c             	pushl  0xc(%ebp)
  10045d:	ff 75 08             	pushl  0x8(%ebp)
  100460:	68 08 5e 10 00       	push   $0x105e08
  100465:	e8 0d fe ff ff       	call   100277 <cprintf>
  10046a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100470:	83 ec 08             	sub    $0x8,%esp
  100473:	50                   	push   %eax
  100474:	ff 75 10             	pushl  0x10(%ebp)
  100477:	e8 d2 fd ff ff       	call   10024e <vcprintf>
  10047c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10047f:	83 ec 0c             	sub    $0xc,%esp
  100482:	68 06 5e 10 00       	push   $0x105e06
  100487:	e8 eb fd ff ff       	call   100277 <cprintf>
  10048c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10048f:	90                   	nop
  100490:	c9                   	leave  
  100491:	c3                   	ret    

00100492 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100495:	a1 60 8e 11 00       	mov    0x118e60,%eax
}
  10049a:	5d                   	pop    %ebp
  10049b:	c3                   	ret    

0010049c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10049c:	55                   	push   %ebp
  10049d:	89 e5                	mov    %esp,%ebp
  10049f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a5:	8b 00                	mov    (%eax),%eax
  1004a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ad:	8b 00                	mov    (%eax),%eax
  1004af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004b9:	e9 d2 00 00 00       	jmp    100590 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004c4:	01 d0                	add    %edx,%eax
  1004c6:	89 c2                	mov    %eax,%edx
  1004c8:	c1 ea 1f             	shr    $0x1f,%edx
  1004cb:	01 d0                	add    %edx,%eax
  1004cd:	d1 f8                	sar    %eax
  1004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d8:	eb 04                	jmp    1004de <stab_binsearch+0x42>
            m --;
  1004da:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e4:	7c 1f                	jl     100505 <stab_binsearch+0x69>
  1004e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e9:	89 d0                	mov    %edx,%eax
  1004eb:	01 c0                	add    %eax,%eax
  1004ed:	01 d0                	add    %edx,%eax
  1004ef:	c1 e0 02             	shl    $0x2,%eax
  1004f2:	89 c2                	mov    %eax,%edx
  1004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004fd:	0f b6 c0             	movzbl %al,%eax
  100500:	39 45 14             	cmp    %eax,0x14(%ebp)
  100503:	75 d5                	jne    1004da <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100508:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050b:	7d 0b                	jge    100518 <stab_binsearch+0x7c>
            l = true_m + 1;
  10050d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100510:	83 c0 01             	add    $0x1,%eax
  100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100516:	eb 78                	jmp    100590 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100518:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10051f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100522:	89 d0                	mov    %edx,%eax
  100524:	01 c0                	add    %eax,%eax
  100526:	01 d0                	add    %edx,%eax
  100528:	c1 e0 02             	shl    $0x2,%eax
  10052b:	89 c2                	mov    %eax,%edx
  10052d:	8b 45 08             	mov    0x8(%ebp),%eax
  100530:	01 d0                	add    %edx,%eax
  100532:	8b 40 08             	mov    0x8(%eax),%eax
  100535:	39 45 18             	cmp    %eax,0x18(%ebp)
  100538:	76 13                	jbe    10054d <stab_binsearch+0xb1>
            *region_left = m;
  10053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100540:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100545:	83 c0 01             	add    $0x1,%eax
  100548:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10054b:	eb 43                	jmp    100590 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10054d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100550:	89 d0                	mov    %edx,%eax
  100552:	01 c0                	add    %eax,%eax
  100554:	01 d0                	add    %edx,%eax
  100556:	c1 e0 02             	shl    $0x2,%eax
  100559:	89 c2                	mov    %eax,%edx
  10055b:	8b 45 08             	mov    0x8(%ebp),%eax
  10055e:	01 d0                	add    %edx,%eax
  100560:	8b 40 08             	mov    0x8(%eax),%eax
  100563:	39 45 18             	cmp    %eax,0x18(%ebp)
  100566:	73 16                	jae    10057e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10056e:	8b 45 10             	mov    0x10(%ebp),%eax
  100571:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100576:	83 e8 01             	sub    $0x1,%eax
  100579:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10057c:	eb 12                	jmp    100590 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100584:	89 10                	mov    %edx,(%eax)
            l = m;
  100586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100589:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10058c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100593:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100596:	0f 8e 22 ff ff ff    	jle    1004be <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10059c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005a0:	75 0f                	jne    1005b1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a5:	8b 00                	mov    (%eax),%eax
  1005a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ad:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005af:	eb 3f                	jmp    1005f0 <stab_binsearch+0x154>
        l = *region_right;
  1005b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b4:	8b 00                	mov    (%eax),%eax
  1005b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005b9:	eb 04                	jmp    1005bf <stab_binsearch+0x123>
  1005bb:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	8b 00                	mov    (%eax),%eax
  1005c4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005c7:	7e 1f                	jle    1005e8 <stab_binsearch+0x14c>
  1005c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005cc:	89 d0                	mov    %edx,%eax
  1005ce:	01 c0                	add    %eax,%eax
  1005d0:	01 d0                	add    %edx,%eax
  1005d2:	c1 e0 02             	shl    $0x2,%eax
  1005d5:	89 c2                	mov    %eax,%edx
  1005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005da:	01 d0                	add    %edx,%eax
  1005dc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e0:	0f b6 c0             	movzbl %al,%eax
  1005e3:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005e6:	75 d3                	jne    1005bb <stab_binsearch+0x11f>
        *region_left = l;
  1005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ee:	89 10                	mov    %edx,(%eax)
}
  1005f0:	90                   	nop
  1005f1:	c9                   	leave  
  1005f2:	c3                   	ret    

001005f3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005f3:	55                   	push   %ebp
  1005f4:	89 e5                	mov    %esp,%ebp
  1005f6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 00 28 5e 10 00    	movl   $0x105e28,(%eax)
    info->eip_line = 0;
  100602:	8b 45 0c             	mov    0xc(%ebp),%eax
  100605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060f:	c7 40 08 28 5e 10 00 	movl   $0x105e28,0x8(%eax)
    info->eip_fn_namelen = 9;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100620:	8b 45 0c             	mov    0xc(%ebp),%eax
  100623:	8b 55 08             	mov    0x8(%ebp),%edx
  100626:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100629:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100633:	c7 45 f4 50 70 10 00 	movl   $0x107050,-0xc(%ebp)
    stab_end = __STAB_END__;
  10063a:	c7 45 f0 4c 25 11 00 	movl   $0x11254c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100641:	c7 45 ec 4d 25 11 00 	movl   $0x11254d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100648:	c7 45 e8 cd 50 11 00 	movl   $0x1150cd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10064f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100652:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100655:	76 0d                	jbe    100664 <debuginfo_eip+0x71>
  100657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10065a:	83 e8 01             	sub    $0x1,%eax
  10065d:	0f b6 00             	movzbl (%eax),%eax
  100660:	84 c0                	test   %al,%al
  100662:	74 0a                	je     10066e <debuginfo_eip+0x7b>
        return -1;
  100664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100669:	e9 91 02 00 00       	jmp    1008ff <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100675:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067b:	29 c2                	sub    %eax,%edx
  10067d:	89 d0                	mov    %edx,%eax
  10067f:	c1 f8 02             	sar    $0x2,%eax
  100682:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100688:	83 e8 01             	sub    $0x1,%eax
  10068b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10068e:	ff 75 08             	pushl  0x8(%ebp)
  100691:	6a 64                	push   $0x64
  100693:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100696:	50                   	push   %eax
  100697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10069a:	50                   	push   %eax
  10069b:	ff 75 f4             	pushl  -0xc(%ebp)
  10069e:	e8 f9 fd ff ff       	call   10049c <stab_binsearch>
  1006a3:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a9:	85 c0                	test   %eax,%eax
  1006ab:	75 0a                	jne    1006b7 <debuginfo_eip+0xc4>
        return -1;
  1006ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006b2:	e9 48 02 00 00       	jmp    1008ff <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006c3:	ff 75 08             	pushl  0x8(%ebp)
  1006c6:	6a 24                	push   $0x24
  1006c8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006cb:	50                   	push   %eax
  1006cc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006cf:	50                   	push   %eax
  1006d0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006d3:	e8 c4 fd ff ff       	call   10049c <stab_binsearch>
  1006d8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006e1:	39 c2                	cmp    %eax,%edx
  1006e3:	7f 7c                	jg     100761 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e8:	89 c2                	mov    %eax,%edx
  1006ea:	89 d0                	mov    %edx,%eax
  1006ec:	01 c0                	add    %eax,%eax
  1006ee:	01 d0                	add    %edx,%eax
  1006f0:	c1 e0 02             	shl    $0x2,%eax
  1006f3:	89 c2                	mov    %eax,%edx
  1006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f8:	01 d0                	add    %edx,%eax
  1006fa:	8b 00                	mov    (%eax),%eax
  1006fc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100702:	29 d1                	sub    %edx,%ecx
  100704:	89 ca                	mov    %ecx,%edx
  100706:	39 d0                	cmp    %edx,%eax
  100708:	73 22                	jae    10072c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	8b 10                	mov    (%eax),%edx
  100721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100724:	01 c2                	add    %eax,%edx
  100726:	8b 45 0c             	mov    0xc(%ebp),%eax
  100729:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10072c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072f:	89 c2                	mov    %eax,%edx
  100731:	89 d0                	mov    %edx,%eax
  100733:	01 c0                	add    %eax,%eax
  100735:	01 d0                	add    %edx,%eax
  100737:	c1 e0 02             	shl    $0x2,%eax
  10073a:	89 c2                	mov    %eax,%edx
  10073c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073f:	01 d0                	add    %edx,%eax
  100741:	8b 50 08             	mov    0x8(%eax),%edx
  100744:	8b 45 0c             	mov    0xc(%ebp),%eax
  100747:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	8b 40 10             	mov    0x10(%eax),%eax
  100750:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100756:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100759:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10075f:	eb 15                	jmp    100776 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100761:	8b 45 0c             	mov    0xc(%ebp),%eax
  100764:	8b 55 08             	mov    0x8(%ebp),%edx
  100767:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10076a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100773:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100776:	8b 45 0c             	mov    0xc(%ebp),%eax
  100779:	8b 40 08             	mov    0x8(%eax),%eax
  10077c:	83 ec 08             	sub    $0x8,%esp
  10077f:	6a 3a                	push   $0x3a
  100781:	50                   	push   %eax
  100782:	e8 81 4c 00 00       	call   105408 <strfind>
  100787:	83 c4 10             	add    $0x10,%esp
  10078a:	89 c2                	mov    %eax,%edx
  10078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078f:	8b 40 08             	mov    0x8(%eax),%eax
  100792:	29 c2                	sub    %eax,%edx
  100794:	8b 45 0c             	mov    0xc(%ebp),%eax
  100797:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10079a:	83 ec 0c             	sub    $0xc,%esp
  10079d:	ff 75 08             	pushl  0x8(%ebp)
  1007a0:	6a 44                	push   $0x44
  1007a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007a5:	50                   	push   %eax
  1007a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007a9:	50                   	push   %eax
  1007aa:	ff 75 f4             	pushl  -0xc(%ebp)
  1007ad:	e8 ea fc ff ff       	call   10049c <stab_binsearch>
  1007b2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007bb:	39 c2                	cmp    %eax,%edx
  1007bd:	7f 24                	jg     1007e3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	89 d0                	mov    %edx,%eax
  1007c6:	01 c0                	add    %eax,%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	c1 e0 02             	shl    $0x2,%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d2:	01 d0                	add    %edx,%eax
  1007d4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007d8:	0f b7 d0             	movzwl %ax,%edx
  1007db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007de:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e1:	eb 13                	jmp    1007f6 <debuginfo_eip+0x203>
        return -1;
  1007e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007e8:	e9 12 01 00 00       	jmp    1008ff <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f0:	83 e8 01             	sub    $0x1,%eax
  1007f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	7c 56                	jl     100856 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100819:	3c 84                	cmp    $0x84,%al
  10081b:	74 39                	je     100856 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	89 d0                	mov    %edx,%eax
  100824:	01 c0                	add    %eax,%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	c1 e0 02             	shl    $0x2,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100836:	3c 64                	cmp    $0x64,%al
  100838:	75 b3                	jne    1007ed <debuginfo_eip+0x1fa>
  10083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083d:	89 c2                	mov    %eax,%edx
  10083f:	89 d0                	mov    %edx,%eax
  100841:	01 c0                	add    %eax,%eax
  100843:	01 d0                	add    %edx,%eax
  100845:	c1 e0 02             	shl    $0x2,%eax
  100848:	89 c2                	mov    %eax,%edx
  10084a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10084d:	01 d0                	add    %edx,%eax
  10084f:	8b 40 08             	mov    0x8(%eax),%eax
  100852:	85 c0                	test   %eax,%eax
  100854:	74 97                	je     1007ed <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100856:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085c:	39 c2                	cmp    %eax,%edx
  10085e:	7c 46                	jl     1008a6 <debuginfo_eip+0x2b3>
  100860:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100863:	89 c2                	mov    %eax,%edx
  100865:	89 d0                	mov    %edx,%eax
  100867:	01 c0                	add    %eax,%eax
  100869:	01 d0                	add    %edx,%eax
  10086b:	c1 e0 02             	shl    $0x2,%eax
  10086e:	89 c2                	mov    %eax,%edx
  100870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100873:	01 d0                	add    %edx,%eax
  100875:	8b 00                	mov    (%eax),%eax
  100877:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10087a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10087d:	29 d1                	sub    %edx,%ecx
  10087f:	89 ca                	mov    %ecx,%edx
  100881:	39 d0                	cmp    %edx,%eax
  100883:	73 21                	jae    1008a6 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100888:	89 c2                	mov    %eax,%edx
  10088a:	89 d0                	mov    %edx,%eax
  10088c:	01 c0                	add    %eax,%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	c1 e0 02             	shl    $0x2,%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	8b 10                	mov    (%eax),%edx
  10089c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10089f:	01 c2                	add    %eax,%edx
  1008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008ac:	39 c2                	cmp    %eax,%edx
  1008ae:	7d 4a                	jge    1008fa <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008b3:	83 c0 01             	add    $0x1,%eax
  1008b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008b9:	eb 18                	jmp    1008d3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008be:	8b 40 14             	mov    0x14(%eax),%eax
  1008c1:	8d 50 01             	lea    0x1(%eax),%edx
  1008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c7:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cd:	83 c0 01             	add    $0x1,%eax
  1008d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008d9:	39 c2                	cmp    %eax,%edx
  1008db:	7d 1d                	jge    1008fa <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	89 c2                	mov    %eax,%edx
  1008e2:	89 d0                	mov    %edx,%eax
  1008e4:	01 c0                	add    %eax,%eax
  1008e6:	01 d0                	add    %edx,%eax
  1008e8:	c1 e0 02             	shl    $0x2,%eax
  1008eb:	89 c2                	mov    %eax,%edx
  1008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f0:	01 d0                	add    %edx,%eax
  1008f2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008f6:	3c a0                	cmp    $0xa0,%al
  1008f8:	74 c1                	je     1008bb <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ff:	c9                   	leave  
  100900:	c3                   	ret    

00100901 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100901:	55                   	push   %ebp
  100902:	89 e5                	mov    %esp,%ebp
  100904:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100907:	83 ec 0c             	sub    $0xc,%esp
  10090a:	68 32 5e 10 00       	push   $0x105e32
  10090f:	e8 63 f9 ff ff       	call   100277 <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 2a 00 10 00       	push   $0x10002a
  10091f:	68 4b 5e 10 00       	push   $0x105e4b
  100924:	e8 4e f9 ff ff       	call   100277 <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 2b 5d 10 00       	push   $0x105d2b
  100934:	68 63 5e 10 00       	push   $0x105e63
  100939:	e8 39 f9 ff ff       	call   100277 <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100941:	83 ec 08             	sub    $0x8,%esp
  100944:	68 36 8a 11 00       	push   $0x118a36
  100949:	68 7b 5e 10 00       	push   $0x105e7b
  10094e:	e8 24 f9 ff ff       	call   100277 <cprintf>
  100953:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100956:	83 ec 08             	sub    $0x8,%esp
  100959:	68 68 99 11 00       	push   $0x119968
  10095e:	68 93 5e 10 00       	push   $0x105e93
  100963:	e8 0f f9 ff ff       	call   100277 <cprintf>
  100968:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10096b:	b8 68 99 11 00       	mov    $0x119968,%eax
  100970:	05 ff 03 00 00       	add    $0x3ff,%eax
  100975:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10097a:	29 d0                	sub    %edx,%eax
  10097c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100982:	85 c0                	test   %eax,%eax
  100984:	0f 48 c2             	cmovs  %edx,%eax
  100987:	c1 f8 0a             	sar    $0xa,%eax
  10098a:	83 ec 08             	sub    $0x8,%esp
  10098d:	50                   	push   %eax
  10098e:	68 ac 5e 10 00       	push   $0x105eac
  100993:	e8 df f8 ff ff       	call   100277 <cprintf>
  100998:	83 c4 10             	add    $0x10,%esp
}
  10099b:	90                   	nop
  10099c:	c9                   	leave  
  10099d:	c3                   	ret    

0010099e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10099e:	55                   	push   %ebp
  10099f:	89 e5                	mov    %esp,%ebp
  1009a1:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009a7:	83 ec 08             	sub    $0x8,%esp
  1009aa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009ad:	50                   	push   %eax
  1009ae:	ff 75 08             	pushl  0x8(%ebp)
  1009b1:	e8 3d fc ff ff       	call   1005f3 <debuginfo_eip>
  1009b6:	83 c4 10             	add    $0x10,%esp
  1009b9:	85 c0                	test   %eax,%eax
  1009bb:	74 15                	je     1009d2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009bd:	83 ec 08             	sub    $0x8,%esp
  1009c0:	ff 75 08             	pushl  0x8(%ebp)
  1009c3:	68 d6 5e 10 00       	push   $0x105ed6
  1009c8:	e8 aa f8 ff ff       	call   100277 <cprintf>
  1009cd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009d0:	eb 65                	jmp    100a37 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009d9:	eb 1c                	jmp    1009f7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e1:	01 d0                	add    %edx,%eax
  1009e3:	0f b6 00             	movzbl (%eax),%eax
  1009e6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009ef:	01 ca                	add    %ecx,%edx
  1009f1:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009fd:	7c dc                	jl     1009db <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009ff:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	01 d0                	add    %edx,%eax
  100a0a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a10:	8b 55 08             	mov    0x8(%ebp),%edx
  100a13:	89 d1                	mov    %edx,%ecx
  100a15:	29 c1                	sub    %eax,%ecx
  100a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a1d:	83 ec 0c             	sub    $0xc,%esp
  100a20:	51                   	push   %ecx
  100a21:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a27:	51                   	push   %ecx
  100a28:	52                   	push   %edx
  100a29:	50                   	push   %eax
  100a2a:	68 f2 5e 10 00       	push   $0x105ef2
  100a2f:	e8 43 f8 ff ff       	call   100277 <cprintf>
  100a34:	83 c4 20             	add    $0x20,%esp
}
  100a37:	90                   	nop
  100a38:	c9                   	leave  
  100a39:	c3                   	ret    

00100a3a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a3a:	55                   	push   %ebp
  100a3b:	89 e5                	mov    %esp,%ebp
  100a3d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a40:	8b 45 04             	mov    0x4(%ebp),%eax
  100a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a49:	c9                   	leave  
  100a4a:	c3                   	ret    

00100a4b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a4b:	55                   	push   %ebp
  100a4c:	89 e5                	mov    %esp,%ebp
  100a4e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a51:	89 e8                	mov    %ebp,%eax
  100a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  100a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  100a5c:	e8 d9 ff ff ff       	call   100a3a <read_eip>
  100a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  100a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a6b:	e9 9d 00 00 00       	jmp    100b0d <print_stackframe+0xc2>
		cprintf("ebp:0x%08x eip:0x%08x", ebp, eip);
  100a70:	83 ec 04             	sub    $0x4,%esp
  100a73:	ff 75 f0             	pushl  -0x10(%ebp)
  100a76:	ff 75 f4             	pushl  -0xc(%ebp)
  100a79:	68 04 5f 10 00       	push   $0x105f04
  100a7e:	e8 f4 f7 ff ff       	call   100277 <cprintf>
  100a83:	83 c4 10             	add    $0x10,%esp
		uint32_t *arg = (uint32_t *)ebp + 2;
  100a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a89:	83 c0 08             	add    $0x8,%eax
  100a8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		cprintf(" arg:");
  100a8f:	83 ec 0c             	sub    $0xc,%esp
  100a92:	68 1a 5f 10 00       	push   $0x105f1a
  100a97:	e8 db f7 ff ff       	call   100277 <cprintf>
  100a9c:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 4; j++) {
  100a9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100aa6:	eb 26                	jmp    100ace <print_stackframe+0x83>
			cprintf("0x%08x ", arg[j]);
  100aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ab5:	01 d0                	add    %edx,%eax
  100ab7:	8b 00                	mov    (%eax),%eax
  100ab9:	83 ec 08             	sub    $0x8,%esp
  100abc:	50                   	push   %eax
  100abd:	68 20 5f 10 00       	push   $0x105f20
  100ac2:	e8 b0 f7 ff ff       	call   100277 <cprintf>
  100ac7:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 4; j++) {
  100aca:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100ace:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ad2:	7e d4                	jle    100aa8 <print_stackframe+0x5d>
		}
		cprintf("\n");
  100ad4:	83 ec 0c             	sub    $0xc,%esp
  100ad7:	68 28 5f 10 00       	push   $0x105f28
  100adc:	e8 96 f7 ff ff       	call   100277 <cprintf>
  100ae1:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(eip - 1);
  100ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae7:	83 e8 01             	sub    $0x1,%eax
  100aea:	83 ec 0c             	sub    $0xc,%esp
  100aed:	50                   	push   %eax
  100aee:	e8 ab fe ff ff       	call   10099e <print_debuginfo>
  100af3:	83 c4 10             	add    $0x10,%esp
		eip = ((uint32_t *)ebp)[1];
  100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af9:	83 c0 04             	add    $0x4,%eax
  100afc:	8b 00                	mov    (%eax),%eax
  100afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t*)ebp)[0];
  100b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b04:	8b 00                	mov    (%eax),%eax
  100b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  100b09:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b0d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b11:	7f 0a                	jg     100b1d <print_stackframe+0xd2>
  100b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b17:	0f 85 53 ff ff ff    	jne    100a70 <print_stackframe+0x25>
	}
}
  100b1d:	90                   	nop
  100b1e:	c9                   	leave  
  100b1f:	c3                   	ret    

00100b20 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b20:	55                   	push   %ebp
  100b21:	89 e5                	mov    %esp,%ebp
  100b23:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2d:	eb 0c                	jmp    100b3b <parse+0x1b>
            *buf ++ = '\0';
  100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b32:	8d 50 01             	lea    0x1(%eax),%edx
  100b35:	89 55 08             	mov    %edx,0x8(%ebp)
  100b38:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3e:	0f b6 00             	movzbl (%eax),%eax
  100b41:	84 c0                	test   %al,%al
  100b43:	74 1e                	je     100b63 <parse+0x43>
  100b45:	8b 45 08             	mov    0x8(%ebp),%eax
  100b48:	0f b6 00             	movzbl (%eax),%eax
  100b4b:	0f be c0             	movsbl %al,%eax
  100b4e:	83 ec 08             	sub    $0x8,%esp
  100b51:	50                   	push   %eax
  100b52:	68 ac 5f 10 00       	push   $0x105fac
  100b57:	e8 79 48 00 00       	call   1053d5 <strchr>
  100b5c:	83 c4 10             	add    $0x10,%esp
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 cc                	jne    100b2f <parse+0xf>
        }
        if (*buf == '\0') {
  100b63:	8b 45 08             	mov    0x8(%ebp),%eax
  100b66:	0f b6 00             	movzbl (%eax),%eax
  100b69:	84 c0                	test   %al,%al
  100b6b:	74 65                	je     100bd2 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b6d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b71:	75 12                	jne    100b85 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b73:	83 ec 08             	sub    $0x8,%esp
  100b76:	6a 10                	push   $0x10
  100b78:	68 b1 5f 10 00       	push   $0x105fb1
  100b7d:	e8 f5 f6 ff ff       	call   100277 <cprintf>
  100b82:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b88:	8d 50 01             	lea    0x1(%eax),%edx
  100b8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b98:	01 c2                	add    %eax,%edx
  100b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b9f:	eb 04                	jmp    100ba5 <parse+0x85>
            buf ++;
  100ba1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba8:	0f b6 00             	movzbl (%eax),%eax
  100bab:	84 c0                	test   %al,%al
  100bad:	74 8c                	je     100b3b <parse+0x1b>
  100baf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb2:	0f b6 00             	movzbl (%eax),%eax
  100bb5:	0f be c0             	movsbl %al,%eax
  100bb8:	83 ec 08             	sub    $0x8,%esp
  100bbb:	50                   	push   %eax
  100bbc:	68 ac 5f 10 00       	push   $0x105fac
  100bc1:	e8 0f 48 00 00       	call   1053d5 <strchr>
  100bc6:	83 c4 10             	add    $0x10,%esp
  100bc9:	85 c0                	test   %eax,%eax
  100bcb:	74 d4                	je     100ba1 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bcd:	e9 69 ff ff ff       	jmp    100b3b <parse+0x1b>
            break;
  100bd2:	90                   	nop
        }
    }
    return argc;
  100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bd6:	c9                   	leave  
  100bd7:	c3                   	ret    

00100bd8 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bd8:	55                   	push   %ebp
  100bd9:	89 e5                	mov    %esp,%ebp
  100bdb:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bde:	83 ec 08             	sub    $0x8,%esp
  100be1:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100be4:	50                   	push   %eax
  100be5:	ff 75 08             	pushl  0x8(%ebp)
  100be8:	e8 33 ff ff ff       	call   100b20 <parse>
  100bed:	83 c4 10             	add    $0x10,%esp
  100bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bf7:	75 0a                	jne    100c03 <runcmd+0x2b>
        return 0;
  100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  100bfe:	e9 83 00 00 00       	jmp    100c86 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0a:	eb 59                	jmp    100c65 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c0c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c12:	89 d0                	mov    %edx,%eax
  100c14:	01 c0                	add    %eax,%eax
  100c16:	01 d0                	add    %edx,%eax
  100c18:	c1 e0 02             	shl    $0x2,%eax
  100c1b:	05 20 80 11 00       	add    $0x118020,%eax
  100c20:	8b 00                	mov    (%eax),%eax
  100c22:	83 ec 08             	sub    $0x8,%esp
  100c25:	51                   	push   %ecx
  100c26:	50                   	push   %eax
  100c27:	e8 09 47 00 00       	call   105335 <strcmp>
  100c2c:	83 c4 10             	add    $0x10,%esp
  100c2f:	85 c0                	test   %eax,%eax
  100c31:	75 2e                	jne    100c61 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c36:	89 d0                	mov    %edx,%eax
  100c38:	01 c0                	add    %eax,%eax
  100c3a:	01 d0                	add    %edx,%eax
  100c3c:	c1 e0 02             	shl    $0x2,%eax
  100c3f:	05 28 80 11 00       	add    $0x118028,%eax
  100c44:	8b 10                	mov    (%eax),%edx
  100c46:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c49:	83 c0 04             	add    $0x4,%eax
  100c4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c4f:	83 e9 01             	sub    $0x1,%ecx
  100c52:	83 ec 04             	sub    $0x4,%esp
  100c55:	ff 75 0c             	pushl  0xc(%ebp)
  100c58:	50                   	push   %eax
  100c59:	51                   	push   %ecx
  100c5a:	ff d2                	call   *%edx
  100c5c:	83 c4 10             	add    $0x10,%esp
  100c5f:	eb 25                	jmp    100c86 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c61:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c68:	83 f8 02             	cmp    $0x2,%eax
  100c6b:	76 9f                	jbe    100c0c <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c70:	83 ec 08             	sub    $0x8,%esp
  100c73:	50                   	push   %eax
  100c74:	68 cf 5f 10 00       	push   $0x105fcf
  100c79:	e8 f9 f5 ff ff       	call   100277 <cprintf>
  100c7e:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c86:	c9                   	leave  
  100c87:	c3                   	ret    

00100c88 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c8e:	83 ec 0c             	sub    $0xc,%esp
  100c91:	68 e8 5f 10 00       	push   $0x105fe8
  100c96:	e8 dc f5 ff ff       	call   100277 <cprintf>
  100c9b:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c9e:	83 ec 0c             	sub    $0xc,%esp
  100ca1:	68 10 60 10 00       	push   $0x106010
  100ca6:	e8 cc f5 ff ff       	call   100277 <cprintf>
  100cab:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb2:	74 0e                	je     100cc2 <kmonitor+0x3a>
        print_trapframe(tf);
  100cb4:	83 ec 0c             	sub    $0xc,%esp
  100cb7:	ff 75 08             	pushl  0x8(%ebp)
  100cba:	e8 3f 0e 00 00       	call   101afe <print_trapframe>
  100cbf:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cc2:	83 ec 0c             	sub    $0xc,%esp
  100cc5:	68 35 60 10 00       	push   $0x106035
  100cca:	e8 4c f6 ff ff       	call   10031b <readline>
  100ccf:	83 c4 10             	add    $0x10,%esp
  100cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd9:	74 e7                	je     100cc2 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cdb:	83 ec 08             	sub    $0x8,%esp
  100cde:	ff 75 08             	pushl  0x8(%ebp)
  100ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  100ce4:	e8 ef fe ff ff       	call   100bd8 <runcmd>
  100ce9:	83 c4 10             	add    $0x10,%esp
  100cec:	85 c0                	test   %eax,%eax
  100cee:	78 02                	js     100cf2 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100cf0:	eb d0                	jmp    100cc2 <kmonitor+0x3a>
                break;
  100cf2:	90                   	nop
            }
        }
    }
}
  100cf3:	90                   	nop
  100cf4:	c9                   	leave  
  100cf5:	c3                   	ret    

00100cf6 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf6:	55                   	push   %ebp
  100cf7:	89 e5                	mov    %esp,%ebp
  100cf9:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d03:	eb 3c                	jmp    100d41 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d08:	89 d0                	mov    %edx,%eax
  100d0a:	01 c0                	add    %eax,%eax
  100d0c:	01 d0                	add    %edx,%eax
  100d0e:	c1 e0 02             	shl    $0x2,%eax
  100d11:	05 24 80 11 00       	add    $0x118024,%eax
  100d16:	8b 08                	mov    (%eax),%ecx
  100d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1b:	89 d0                	mov    %edx,%eax
  100d1d:	01 c0                	add    %eax,%eax
  100d1f:	01 d0                	add    %edx,%eax
  100d21:	c1 e0 02             	shl    $0x2,%eax
  100d24:	05 20 80 11 00       	add    $0x118020,%eax
  100d29:	8b 00                	mov    (%eax),%eax
  100d2b:	83 ec 04             	sub    $0x4,%esp
  100d2e:	51                   	push   %ecx
  100d2f:	50                   	push   %eax
  100d30:	68 39 60 10 00       	push   $0x106039
  100d35:	e8 3d f5 ff ff       	call   100277 <cprintf>
  100d3a:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d44:	83 f8 02             	cmp    $0x2,%eax
  100d47:	76 bc                	jbe    100d05 <mon_help+0xf>
    }
    return 0;
  100d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4e:	c9                   	leave  
  100d4f:	c3                   	ret    

00100d50 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d50:	55                   	push   %ebp
  100d51:	89 e5                	mov    %esp,%ebp
  100d53:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d56:	e8 a6 fb ff ff       	call   100901 <print_kerninfo>
    return 0;
  100d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d60:	c9                   	leave  
  100d61:	c3                   	ret    

00100d62 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d62:	55                   	push   %ebp
  100d63:	89 e5                	mov    %esp,%ebp
  100d65:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d68:	e8 de fc ff ff       	call   100a4b <print_stackframe>
    return 0;
  100d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d72:	c9                   	leave  
  100d73:	c3                   	ret    

00100d74 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d74:	55                   	push   %ebp
  100d75:	89 e5                	mov    %esp,%ebp
  100d77:	83 ec 18             	sub    $0x18,%esp
  100d7a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d80:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d8c:	ee                   	out    %al,(%dx)
  100d8d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d93:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d97:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d9b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9f:	ee                   	out    %al,(%dx)
  100da0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100da6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100daa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dae:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db3:	c7 05 4c 99 11 00 00 	movl   $0x0,0x11994c
  100dba:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dbd:	83 ec 0c             	sub    $0xc,%esp
  100dc0:	68 42 60 10 00       	push   $0x106042
  100dc5:	e8 ad f4 ff ff       	call   100277 <cprintf>
  100dca:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100dcd:	83 ec 0c             	sub    $0xc,%esp
  100dd0:	6a 00                	push   $0x0
  100dd2:	e8 3f 09 00 00       	call   101716 <pic_enable>
  100dd7:	83 c4 10             	add    $0x10,%esp
}
  100dda:	90                   	nop
  100ddb:	c9                   	leave  
  100ddc:	c3                   	ret    

00100ddd <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100ddd:	55                   	push   %ebp
  100dde:	89 e5                	mov    %esp,%ebp
  100de0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100de3:	9c                   	pushf  
  100de4:	58                   	pop    %eax
  100de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100deb:	25 00 02 00 00       	and    $0x200,%eax
  100df0:	85 c0                	test   %eax,%eax
  100df2:	74 0c                	je     100e00 <__intr_save+0x23>
        intr_disable();
  100df4:	e8 8e 0a 00 00       	call   101887 <intr_disable>
        return 1;
  100df9:	b8 01 00 00 00       	mov    $0x1,%eax
  100dfe:	eb 05                	jmp    100e05 <__intr_save+0x28>
    }
    return 0;
  100e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e05:	c9                   	leave  
  100e06:	c3                   	ret    

00100e07 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e07:	55                   	push   %ebp
  100e08:	89 e5                	mov    %esp,%ebp
  100e0a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e11:	74 05                	je     100e18 <__intr_restore+0x11>
        intr_enable();
  100e13:	e8 68 0a 00 00       	call   101880 <intr_enable>
    }
}
  100e18:	90                   	nop
  100e19:	c9                   	leave  
  100e1a:	c3                   	ret    

00100e1b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e1b:	55                   	push   %ebp
  100e1c:	89 e5                	mov    %esp,%ebp
  100e1e:	83 ec 10             	sub    $0x10,%esp
  100e21:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e27:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e2b:	89 c2                	mov    %eax,%edx
  100e2d:	ec                   	in     (%dx),%al
  100e2e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e31:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e37:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e3b:	89 c2                	mov    %eax,%edx
  100e3d:	ec                   	in     (%dx),%al
  100e3e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e51:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e57:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e61:	90                   	nop
  100e62:	c9                   	leave  
  100e63:	c3                   	ret    

00100e64 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e6a:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e74:	0f b7 00             	movzwl (%eax),%eax
  100e77:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	0f b7 00             	movzwl (%eax),%eax
  100e89:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e8d:	74 12                	je     100ea1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e8f:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e96:	66 c7 05 86 8e 11 00 	movw   $0x3b4,0x118e86
  100e9d:	b4 03 
  100e9f:	eb 13                	jmp    100eb4 <cga_init+0x50>
    } else {
        *cp = was;
  100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ea8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eab:	66 c7 05 86 8e 11 00 	movw   $0x3d4,0x118e86
  100eb2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb4:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ec2:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ec6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ece:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ecf:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100ed6:	83 c0 01             	add    $0x1,%eax
  100ed9:	0f b7 c0             	movzwl %ax,%eax
  100edc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ee4:	89 c2                	mov    %eax,%edx
  100ee6:	ec                   	in     (%dx),%al
  100ee7:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100eea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eee:	0f b6 c0             	movzbl %al,%eax
  100ef1:	c1 e0 08             	shl    $0x8,%eax
  100ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ef7:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100efe:	0f b7 c0             	movzwl %ax,%eax
  100f01:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f05:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f11:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f12:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f19:	83 c0 01             	add    $0x1,%eax
  100f1c:	0f b7 c0             	movzwl %ax,%eax
  100f1f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f23:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f27:	89 c2                	mov    %eax,%edx
  100f29:	ec                   	in     (%dx),%al
  100f2a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f2d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f31:	0f b6 c0             	movzbl %al,%eax
  100f34:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3a:	a3 80 8e 11 00       	mov    %eax,0x118e80
    crt_pos = pos;
  100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f42:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
}
  100f48:	90                   	nop
  100f49:	c9                   	leave  
  100f4a:	c3                   	ret    

00100f4b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f4b:	55                   	push   %ebp
  100f4c:	89 e5                	mov    %esp,%ebp
  100f4e:	83 ec 38             	sub    $0x38,%esp
  100f51:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f57:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f5f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f63:	ee                   	out    %al,(%dx)
  100f64:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f6a:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f6e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f72:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f76:	ee                   	out    %al,(%dx)
  100f77:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f7d:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f81:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f85:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f89:	ee                   	out    %al,(%dx)
  100f8a:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f90:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f94:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f98:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f9c:	ee                   	out    %al,(%dx)
  100f9d:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fa3:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fa7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fab:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100faf:	ee                   	out    %al,(%dx)
  100fb0:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fb6:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fba:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fbe:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fc2:	ee                   	out    %al,(%dx)
  100fc3:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc9:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fcd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fd1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fd5:	ee                   	out    %al,(%dx)
  100fd6:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fdc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fe0:	89 c2                	mov    %eax,%edx
  100fe2:	ec                   	in     (%dx),%al
  100fe3:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fe6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fea:	3c ff                	cmp    $0xff,%al
  100fec:	0f 95 c0             	setne  %al
  100fef:	0f b6 c0             	movzbl %al,%eax
  100ff2:	a3 88 8e 11 00       	mov    %eax,0x118e88
  100ff7:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ffd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101001:	89 c2                	mov    %eax,%edx
  101003:	ec                   	in     (%dx),%al
  101004:	88 45 f1             	mov    %al,-0xf(%ebp)
  101007:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10100d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101011:	89 c2                	mov    %eax,%edx
  101013:	ec                   	in     (%dx),%al
  101014:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101017:	a1 88 8e 11 00       	mov    0x118e88,%eax
  10101c:	85 c0                	test   %eax,%eax
  10101e:	74 0d                	je     10102d <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  101020:	83 ec 0c             	sub    $0xc,%esp
  101023:	6a 04                	push   $0x4
  101025:	e8 ec 06 00 00       	call   101716 <pic_enable>
  10102a:	83 c4 10             	add    $0x10,%esp
    }
}
  10102d:	90                   	nop
  10102e:	c9                   	leave  
  10102f:	c3                   	ret    

00101030 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101030:	55                   	push   %ebp
  101031:	89 e5                	mov    %esp,%ebp
  101033:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10103d:	eb 09                	jmp    101048 <lpt_putc_sub+0x18>
        delay();
  10103f:	e8 d7 fd ff ff       	call   100e1b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101044:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101048:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10104e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101052:	89 c2                	mov    %eax,%edx
  101054:	ec                   	in     (%dx),%al
  101055:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101058:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105c:	84 c0                	test   %al,%al
  10105e:	78 09                	js     101069 <lpt_putc_sub+0x39>
  101060:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101067:	7e d6                	jle    10103f <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101069:	8b 45 08             	mov    0x8(%ebp),%eax
  10106c:	0f b6 c0             	movzbl %al,%eax
  10106f:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101075:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101078:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10107c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101080:	ee                   	out    %al,(%dx)
  101081:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101087:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10108f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101093:	ee                   	out    %al,(%dx)
  101094:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10109a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10109e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010a2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010a6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a7:	90                   	nop
  1010a8:	c9                   	leave  
  1010a9:	c3                   	ret    

001010aa <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010aa:	55                   	push   %ebp
  1010ab:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1010ad:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b1:	74 0d                	je     1010c0 <lpt_putc+0x16>
        lpt_putc_sub(c);
  1010b3:	ff 75 08             	pushl  0x8(%ebp)
  1010b6:	e8 75 ff ff ff       	call   101030 <lpt_putc_sub>
  1010bb:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010be:	eb 1e                	jmp    1010de <lpt_putc+0x34>
        lpt_putc_sub('\b');
  1010c0:	6a 08                	push   $0x8
  1010c2:	e8 69 ff ff ff       	call   101030 <lpt_putc_sub>
  1010c7:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010ca:	6a 20                	push   $0x20
  1010cc:	e8 5f ff ff ff       	call   101030 <lpt_putc_sub>
  1010d1:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010d4:	6a 08                	push   $0x8
  1010d6:	e8 55 ff ff ff       	call   101030 <lpt_putc_sub>
  1010db:	83 c4 04             	add    $0x4,%esp
}
  1010de:	90                   	nop
  1010df:	c9                   	leave  
  1010e0:	c3                   	ret    

001010e1 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010e1:	55                   	push   %ebp
  1010e2:	89 e5                	mov    %esp,%ebp
  1010e4:	53                   	push   %ebx
  1010e5:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010eb:	b0 00                	mov    $0x0,%al
  1010ed:	85 c0                	test   %eax,%eax
  1010ef:	75 07                	jne    1010f8 <cga_putc+0x17>
        c |= 0x0700;
  1010f1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fb:	0f b6 c0             	movzbl %al,%eax
  1010fe:	83 f8 0a             	cmp    $0xa,%eax
  101101:	74 52                	je     101155 <cga_putc+0x74>
  101103:	83 f8 0d             	cmp    $0xd,%eax
  101106:	74 5d                	je     101165 <cga_putc+0x84>
  101108:	83 f8 08             	cmp    $0x8,%eax
  10110b:	0f 85 8e 00 00 00    	jne    10119f <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  101111:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101118:	66 85 c0             	test   %ax,%ax
  10111b:	0f 84 a4 00 00 00    	je     1011c5 <cga_putc+0xe4>
            crt_pos --;
  101121:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101128:	83 e8 01             	sub    $0x1,%eax
  10112b:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101131:	8b 45 08             	mov    0x8(%ebp),%eax
  101134:	b0 00                	mov    $0x0,%al
  101136:	83 c8 20             	or     $0x20,%eax
  101139:	89 c1                	mov    %eax,%ecx
  10113b:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101140:	0f b7 15 84 8e 11 00 	movzwl 0x118e84,%edx
  101147:	0f b7 d2             	movzwl %dx,%edx
  10114a:	01 d2                	add    %edx,%edx
  10114c:	01 d0                	add    %edx,%eax
  10114e:	89 ca                	mov    %ecx,%edx
  101150:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101153:	eb 70                	jmp    1011c5 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  101155:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10115c:	83 c0 50             	add    $0x50,%eax
  10115f:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101165:	0f b7 1d 84 8e 11 00 	movzwl 0x118e84,%ebx
  10116c:	0f b7 0d 84 8e 11 00 	movzwl 0x118e84,%ecx
  101173:	0f b7 c1             	movzwl %cx,%eax
  101176:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10117c:	c1 e8 10             	shr    $0x10,%eax
  10117f:	89 c2                	mov    %eax,%edx
  101181:	66 c1 ea 06          	shr    $0x6,%dx
  101185:	89 d0                	mov    %edx,%eax
  101187:	c1 e0 02             	shl    $0x2,%eax
  10118a:	01 d0                	add    %edx,%eax
  10118c:	c1 e0 04             	shl    $0x4,%eax
  10118f:	29 c1                	sub    %eax,%ecx
  101191:	89 ca                	mov    %ecx,%edx
  101193:	89 d8                	mov    %ebx,%eax
  101195:	29 d0                	sub    %edx,%eax
  101197:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
        break;
  10119d:	eb 27                	jmp    1011c6 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10119f:	8b 0d 80 8e 11 00    	mov    0x118e80,%ecx
  1011a5:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1011ac:	8d 50 01             	lea    0x1(%eax),%edx
  1011af:	66 89 15 84 8e 11 00 	mov    %dx,0x118e84
  1011b6:	0f b7 c0             	movzwl %ax,%eax
  1011b9:	01 c0                	add    %eax,%eax
  1011bb:	01 c8                	add    %ecx,%eax
  1011bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1011c0:	66 89 10             	mov    %dx,(%eax)
        break;
  1011c3:	eb 01                	jmp    1011c6 <cga_putc+0xe5>
        break;
  1011c5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c6:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1011cd:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d1:	76 59                	jbe    10122c <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d3:	a1 80 8e 11 00       	mov    0x118e80,%eax
  1011d8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011de:	a1 80 8e 11 00       	mov    0x118e80,%eax
  1011e3:	83 ec 04             	sub    $0x4,%esp
  1011e6:	68 00 0f 00 00       	push   $0xf00
  1011eb:	52                   	push   %edx
  1011ec:	50                   	push   %eax
  1011ed:	e8 e2 43 00 00       	call   1055d4 <memmove>
  1011f2:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011fc:	eb 15                	jmp    101213 <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  1011fe:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101206:	01 d2                	add    %edx,%edx
  101208:	01 d0                	add    %edx,%eax
  10120a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101213:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121a:	7e e2                	jle    1011fe <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  10121c:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101223:	83 e8 50             	sub    $0x50,%eax
  101226:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10122c:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  101233:	0f b7 c0             	movzwl %ax,%eax
  101236:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10123a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10123e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101242:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101246:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101247:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10124e:	66 c1 e8 08          	shr    $0x8,%ax
  101252:	0f b6 c0             	movzbl %al,%eax
  101255:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  10125c:	83 c2 01             	add    $0x1,%edx
  10125f:	0f b7 d2             	movzwl %dx,%edx
  101262:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101266:	88 45 e9             	mov    %al,-0x17(%ebp)
  101269:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10126d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101271:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101272:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  101279:	0f b7 c0             	movzwl %ax,%eax
  10127c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101280:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101284:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101288:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10128c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10128d:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  10129e:	83 c2 01             	add    $0x1,%edx
  1012a1:	0f b7 d2             	movzwl %dx,%edx
  1012a4:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012a8:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012ab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012af:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012b3:	ee                   	out    %al,(%dx)
}
  1012b4:	90                   	nop
  1012b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012b8:	c9                   	leave  
  1012b9:	c3                   	ret    

001012ba <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ba:	55                   	push   %ebp
  1012bb:	89 e5                	mov    %esp,%ebp
  1012bd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012c7:	eb 09                	jmp    1012d2 <serial_putc_sub+0x18>
        delay();
  1012c9:	e8 4d fb ff ff       	call   100e1b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012d8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012dc:	89 c2                	mov    %eax,%edx
  1012de:	ec                   	in     (%dx),%al
  1012df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012e6:	0f b6 c0             	movzbl %al,%eax
  1012e9:	83 e0 20             	and    $0x20,%eax
  1012ec:	85 c0                	test   %eax,%eax
  1012ee:	75 09                	jne    1012f9 <serial_putc_sub+0x3f>
  1012f0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012f7:	7e d0                	jle    1012c9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012fc:	0f b6 c0             	movzbl %al,%eax
  1012ff:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101305:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101308:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10130c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101310:	ee                   	out    %al,(%dx)
}
  101311:	90                   	nop
  101312:	c9                   	leave  
  101313:	c3                   	ret    

00101314 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101314:	55                   	push   %ebp
  101315:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101317:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10131b:	74 0d                	je     10132a <serial_putc+0x16>
        serial_putc_sub(c);
  10131d:	ff 75 08             	pushl  0x8(%ebp)
  101320:	e8 95 ff ff ff       	call   1012ba <serial_putc_sub>
  101325:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101328:	eb 1e                	jmp    101348 <serial_putc+0x34>
        serial_putc_sub('\b');
  10132a:	6a 08                	push   $0x8
  10132c:	e8 89 ff ff ff       	call   1012ba <serial_putc_sub>
  101331:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101334:	6a 20                	push   $0x20
  101336:	e8 7f ff ff ff       	call   1012ba <serial_putc_sub>
  10133b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10133e:	6a 08                	push   $0x8
  101340:	e8 75 ff ff ff       	call   1012ba <serial_putc_sub>
  101345:	83 c4 04             	add    $0x4,%esp
}
  101348:	90                   	nop
  101349:	c9                   	leave  
  10134a:	c3                   	ret    

0010134b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10134b:	55                   	push   %ebp
  10134c:	89 e5                	mov    %esp,%ebp
  10134e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101351:	eb 33                	jmp    101386 <cons_intr+0x3b>
        if (c != 0) {
  101353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101357:	74 2d                	je     101386 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101359:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  10135e:	8d 50 01             	lea    0x1(%eax),%edx
  101361:	89 15 a4 90 11 00    	mov    %edx,0x1190a4
  101367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10136a:	88 90 a0 8e 11 00    	mov    %dl,0x118ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101370:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  101375:	3d 00 02 00 00       	cmp    $0x200,%eax
  10137a:	75 0a                	jne    101386 <cons_intr+0x3b>
                cons.wpos = 0;
  10137c:	c7 05 a4 90 11 00 00 	movl   $0x0,0x1190a4
  101383:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101386:	8b 45 08             	mov    0x8(%ebp),%eax
  101389:	ff d0                	call   *%eax
  10138b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10138e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101392:	75 bf                	jne    101353 <cons_intr+0x8>
            }
        }
    }
}
  101394:	90                   	nop
  101395:	c9                   	leave  
  101396:	c3                   	ret    

00101397 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101397:	55                   	push   %ebp
  101398:	89 e5                	mov    %esp,%ebp
  10139a:	83 ec 10             	sub    $0x10,%esp
  10139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a7:	89 c2                	mov    %eax,%edx
  1013a9:	ec                   	in     (%dx),%al
  1013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013b1:	0f b6 c0             	movzbl %al,%eax
  1013b4:	83 e0 01             	and    $0x1,%eax
  1013b7:	85 c0                	test   %eax,%eax
  1013b9:	75 07                	jne    1013c2 <serial_proc_data+0x2b>
        return -1;
  1013bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c0:	eb 2a                	jmp    1013ec <serial_proc_data+0x55>
  1013c2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013c8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013cc:	89 c2                	mov    %eax,%edx
  1013ce:	ec                   	in     (%dx),%al
  1013cf:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013d2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013d6:	0f b6 c0             	movzbl %al,%eax
  1013d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013dc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013e0:	75 07                	jne    1013e9 <serial_proc_data+0x52>
        c = '\b';
  1013e2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013ec:	c9                   	leave  
  1013ed:	c3                   	ret    

001013ee <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ee:	55                   	push   %ebp
  1013ef:	89 e5                	mov    %esp,%ebp
  1013f1:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013f4:	a1 88 8e 11 00       	mov    0x118e88,%eax
  1013f9:	85 c0                	test   %eax,%eax
  1013fb:	74 10                	je     10140d <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013fd:	83 ec 0c             	sub    $0xc,%esp
  101400:	68 97 13 10 00       	push   $0x101397
  101405:	e8 41 ff ff ff       	call   10134b <cons_intr>
  10140a:	83 c4 10             	add    $0x10,%esp
    }
}
  10140d:	90                   	nop
  10140e:	c9                   	leave  
  10140f:	c3                   	ret    

00101410 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101410:	55                   	push   %ebp
  101411:	89 e5                	mov    %esp,%ebp
  101413:	83 ec 28             	sub    $0x28,%esp
  101416:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101420:	89 c2                	mov    %eax,%edx
  101422:	ec                   	in     (%dx),%al
  101423:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101426:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10142a:	0f b6 c0             	movzbl %al,%eax
  10142d:	83 e0 01             	and    $0x1,%eax
  101430:	85 c0                	test   %eax,%eax
  101432:	75 0a                	jne    10143e <kbd_proc_data+0x2e>
        return -1;
  101434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101439:	e9 5d 01 00 00       	jmp    10159b <kbd_proc_data+0x18b>
  10143e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101444:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101448:	89 c2                	mov    %eax,%edx
  10144a:	ec                   	in     (%dx),%al
  10144b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10144e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101452:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101455:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101459:	75 17                	jne    101472 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10145b:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101460:	83 c8 40             	or     $0x40,%eax
  101463:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  101468:	b8 00 00 00 00       	mov    $0x0,%eax
  10146d:	e9 29 01 00 00       	jmp    10159b <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101476:	84 c0                	test   %al,%al
  101478:	79 47                	jns    1014c1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10147a:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10147f:	83 e0 40             	and    $0x40,%eax
  101482:	85 c0                	test   %eax,%eax
  101484:	75 09                	jne    10148f <kbd_proc_data+0x7f>
  101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148a:	83 e0 7f             	and    $0x7f,%eax
  10148d:	eb 04                	jmp    101493 <kbd_proc_data+0x83>
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149a:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  1014a1:	83 c8 40             	or     $0x40,%eax
  1014a4:	0f b6 c0             	movzbl %al,%eax
  1014a7:	f7 d0                	not    %eax
  1014a9:	89 c2                	mov    %eax,%edx
  1014ab:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1014b0:	21 d0                	and    %edx,%eax
  1014b2:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  1014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014bc:	e9 da 00 00 00       	jmp    10159b <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1014c1:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1014c6:	83 e0 40             	and    $0x40,%eax
  1014c9:	85 c0                	test   %eax,%eax
  1014cb:	74 11                	je     1014de <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014cd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d1:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1014d6:	83 e0 bf             	and    $0xffffffbf,%eax
  1014d9:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    }

    shift |= shiftcode[data];
  1014de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e2:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  1014e9:	0f b6 d0             	movzbl %al,%edx
  1014ec:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1014f1:	09 d0                	or     %edx,%eax
  1014f3:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    shift ^= togglecode[data];
  1014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fc:	0f b6 80 60 81 11 00 	movzbl 0x118160(%eax),%eax
  101503:	0f b6 d0             	movzbl %al,%edx
  101506:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10150b:	31 d0                	xor    %edx,%eax
  10150d:	a3 a8 90 11 00       	mov    %eax,0x1190a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101512:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101517:	83 e0 03             	and    $0x3,%eax
  10151a:	8b 14 85 60 85 11 00 	mov    0x118560(,%eax,4),%edx
  101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101525:	01 d0                	add    %edx,%eax
  101527:	0f b6 00             	movzbl (%eax),%eax
  10152a:	0f b6 c0             	movzbl %al,%eax
  10152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101530:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101535:	83 e0 08             	and    $0x8,%eax
  101538:	85 c0                	test   %eax,%eax
  10153a:	74 22                	je     10155e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10153c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101540:	7e 0c                	jle    10154e <kbd_proc_data+0x13e>
  101542:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101546:	7f 06                	jg     10154e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101548:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10154c:	eb 10                	jmp    10155e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10154e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101552:	7e 0a                	jle    10155e <kbd_proc_data+0x14e>
  101554:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101558:	7f 04                	jg     10155e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10155a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10155e:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101563:	f7 d0                	not    %eax
  101565:	83 e0 06             	and    $0x6,%eax
  101568:	85 c0                	test   %eax,%eax
  10156a:	75 2c                	jne    101598 <kbd_proc_data+0x188>
  10156c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101573:	75 23                	jne    101598 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101575:	83 ec 0c             	sub    $0xc,%esp
  101578:	68 5d 60 10 00       	push   $0x10605d
  10157d:	e8 f5 ec ff ff       	call   100277 <cprintf>
  101582:	83 c4 10             	add    $0x10,%esp
  101585:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10158f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101593:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101597:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159b:	c9                   	leave  
  10159c:	c3                   	ret    

0010159d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159d:	55                   	push   %ebp
  10159e:	89 e5                	mov    %esp,%ebp
  1015a0:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1015a3:	83 ec 0c             	sub    $0xc,%esp
  1015a6:	68 10 14 10 00       	push   $0x101410
  1015ab:	e8 9b fd ff ff       	call   10134b <cons_intr>
  1015b0:	83 c4 10             	add    $0x10,%esp
}
  1015b3:	90                   	nop
  1015b4:	c9                   	leave  
  1015b5:	c3                   	ret    

001015b6 <kbd_init>:

static void
kbd_init(void) {
  1015b6:	55                   	push   %ebp
  1015b7:	89 e5                	mov    %esp,%ebp
  1015b9:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bc:	e8 dc ff ff ff       	call   10159d <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c1:	83 ec 0c             	sub    $0xc,%esp
  1015c4:	6a 01                	push   $0x1
  1015c6:	e8 4b 01 00 00       	call   101716 <pic_enable>
  1015cb:	83 c4 10             	add    $0x10,%esp
}
  1015ce:	90                   	nop
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015d7:	e8 88 f8 ff ff       	call   100e64 <cga_init>
    serial_init();
  1015dc:	e8 6a f9 ff ff       	call   100f4b <serial_init>
    kbd_init();
  1015e1:	e8 d0 ff ff ff       	call   1015b6 <kbd_init>
    if (!serial_exists) {
  1015e6:	a1 88 8e 11 00       	mov    0x118e88,%eax
  1015eb:	85 c0                	test   %eax,%eax
  1015ed:	75 10                	jne    1015ff <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015ef:	83 ec 0c             	sub    $0xc,%esp
  1015f2:	68 69 60 10 00       	push   $0x106069
  1015f7:	e8 7b ec ff ff       	call   100277 <cprintf>
  1015fc:	83 c4 10             	add    $0x10,%esp
    }
}
  1015ff:	90                   	nop
  101600:	c9                   	leave  
  101601:	c3                   	ret    

00101602 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101602:	55                   	push   %ebp
  101603:	89 e5                	mov    %esp,%ebp
  101605:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101608:	e8 d0 f7 ff ff       	call   100ddd <__intr_save>
  10160d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101610:	83 ec 0c             	sub    $0xc,%esp
  101613:	ff 75 08             	pushl  0x8(%ebp)
  101616:	e8 8f fa ff ff       	call   1010aa <lpt_putc>
  10161b:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  10161e:	83 ec 0c             	sub    $0xc,%esp
  101621:	ff 75 08             	pushl  0x8(%ebp)
  101624:	e8 b8 fa ff ff       	call   1010e1 <cga_putc>
  101629:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  10162c:	83 ec 0c             	sub    $0xc,%esp
  10162f:	ff 75 08             	pushl  0x8(%ebp)
  101632:	e8 dd fc ff ff       	call   101314 <serial_putc>
  101637:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  10163a:	83 ec 0c             	sub    $0xc,%esp
  10163d:	ff 75 f4             	pushl  -0xc(%ebp)
  101640:	e8 c2 f7 ff ff       	call   100e07 <__intr_restore>
  101645:	83 c4 10             	add    $0x10,%esp
}
  101648:	90                   	nop
  101649:	c9                   	leave  
  10164a:	c3                   	ret    

0010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164b:	55                   	push   %ebp
  10164c:	89 e5                	mov    %esp,%ebp
  10164e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101658:	e8 80 f7 ff ff       	call   100ddd <__intr_save>
  10165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101660:	e8 89 fd ff ff       	call   1013ee <serial_intr>
        kbd_intr();
  101665:	e8 33 ff ff ff       	call   10159d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10166a:	8b 15 a0 90 11 00    	mov    0x1190a0,%edx
  101670:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  101675:	39 c2                	cmp    %eax,%edx
  101677:	74 31                	je     1016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101679:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  10167e:	8d 50 01             	lea    0x1(%eax),%edx
  101681:	89 15 a0 90 11 00    	mov    %edx,0x1190a0
  101687:	0f b6 80 a0 8e 11 00 	movzbl 0x118ea0(%eax),%eax
  10168e:	0f b6 c0             	movzbl %al,%eax
  101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101694:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  101699:	3d 00 02 00 00       	cmp    $0x200,%eax
  10169e:	75 0a                	jne    1016aa <cons_getc+0x5f>
                cons.rpos = 0;
  1016a0:	c7 05 a0 90 11 00 00 	movl   $0x0,0x1190a0
  1016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016aa:	83 ec 0c             	sub    $0xc,%esp
  1016ad:	ff 75 f0             	pushl  -0x10(%ebp)
  1016b0:	e8 52 f7 ff ff       	call   100e07 <__intr_restore>
  1016b5:	83 c4 10             	add    $0x10,%esp
    return c;
  1016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016bb:	c9                   	leave  
  1016bc:	c3                   	ret    

001016bd <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016bd:	55                   	push   %ebp
  1016be:	89 e5                	mov    %esp,%ebp
  1016c0:	83 ec 14             	sub    $0x14,%esp
  1016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ce:	66 a3 70 85 11 00    	mov    %ax,0x118570
    if (did_init) {
  1016d4:	a1 ac 90 11 00       	mov    0x1190ac,%eax
  1016d9:	85 c0                	test   %eax,%eax
  1016db:	74 36                	je     101713 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e1:	0f b6 c0             	movzbl %al,%eax
  1016e4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016ea:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016fa:	66 c1 e8 08          	shr    $0x8,%ax
  1016fe:	0f b6 c0             	movzbl %al,%eax
  101701:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101707:	88 45 fd             	mov    %al,-0x3(%ebp)
  10170a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10170e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
    }
}
  101713:	90                   	nop
  101714:	c9                   	leave  
  101715:	c3                   	ret    

00101716 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101716:	55                   	push   %ebp
  101717:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101719:	8b 45 08             	mov    0x8(%ebp),%eax
  10171c:	ba 01 00 00 00       	mov    $0x1,%edx
  101721:	89 c1                	mov    %eax,%ecx
  101723:	d3 e2                	shl    %cl,%edx
  101725:	89 d0                	mov    %edx,%eax
  101727:	f7 d0                	not    %eax
  101729:	89 c2                	mov    %eax,%edx
  10172b:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  101732:	21 d0                	and    %edx,%eax
  101734:	0f b7 c0             	movzwl %ax,%eax
  101737:	50                   	push   %eax
  101738:	e8 80 ff ff ff       	call   1016bd <pic_setmask>
  10173d:	83 c4 04             	add    $0x4,%esp
}
  101740:	90                   	nop
  101741:	c9                   	leave  
  101742:	c3                   	ret    

00101743 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101743:	55                   	push   %ebp
  101744:	89 e5                	mov    %esp,%ebp
  101746:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101749:	c7 05 ac 90 11 00 01 	movl   $0x1,0x1190ac
  101750:	00 00 00 
  101753:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101759:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  10175d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101761:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101765:	ee                   	out    %al,(%dx)
  101766:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10176c:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101770:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101774:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
  101779:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10177f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101783:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101787:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10178b:	ee                   	out    %al,(%dx)
  10178c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101792:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101796:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10179a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
  10179f:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017a5:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1017a9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ad:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
  1017b2:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017b8:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017bc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017c0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
  1017c5:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017cb:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017cf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017de:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017f1:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1017f5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017f9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
  1017fe:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101804:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101808:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10180c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101810:	ee                   	out    %al,(%dx)
  101811:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101817:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10181b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10181f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
  101824:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10182a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10182e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101832:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
  101837:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10183d:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101841:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101845:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101849:	ee                   	out    %al,(%dx)
  10184a:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101850:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101854:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101858:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10185c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10185d:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  101864:	66 83 f8 ff          	cmp    $0xffff,%ax
  101868:	74 13                	je     10187d <pic_init+0x13a>
        pic_setmask(irq_mask);
  10186a:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  101871:	0f b7 c0             	movzwl %ax,%eax
  101874:	50                   	push   %eax
  101875:	e8 43 fe ff ff       	call   1016bd <pic_setmask>
  10187a:	83 c4 04             	add    $0x4,%esp
    }
}
  10187d:	90                   	nop
  10187e:	c9                   	leave  
  10187f:	c3                   	ret    

00101880 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101880:	55                   	push   %ebp
  101881:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101883:	fb                   	sti    
    sti();
}
  101884:	90                   	nop
  101885:	5d                   	pop    %ebp
  101886:	c3                   	ret    

00101887 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101887:	55                   	push   %ebp
  101888:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10188a:	fa                   	cli    
    cli();
}
  10188b:	90                   	nop
  10188c:	5d                   	pop    %ebp
  10188d:	c3                   	ret    

0010188e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10188e:	55                   	push   %ebp
  10188f:	89 e5                	mov    %esp,%ebp
  101891:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101894:	83 ec 08             	sub    $0x8,%esp
  101897:	6a 64                	push   $0x64
  101899:	68 a0 60 10 00       	push   $0x1060a0
  10189e:	e8 d4 e9 ff ff       	call   100277 <cprintf>
  1018a3:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018a6:	83 ec 0c             	sub    $0xc,%esp
  1018a9:	68 aa 60 10 00       	push   $0x1060aa
  1018ae:	e8 c4 e9 ff ff       	call   100277 <cprintf>
  1018b3:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  1018b6:	83 ec 04             	sub    $0x4,%esp
  1018b9:	68 b8 60 10 00       	push   $0x1060b8
  1018be:	6a 12                	push   $0x12
  1018c0:	68 ce 60 10 00       	push   $0x1060ce
  1018c5:	e8 13 eb ff ff       	call   1003dd <__panic>

001018ca <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018ca:	55                   	push   %ebp
  1018cb:	89 e5                	mov    %esp,%ebp
  1018cd:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t  __vectors[];
	for (int i = 0; i < 256; i++) {
  1018d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018d7:	e9 c3 00 00 00       	jmp    10199f <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);
  1018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018df:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  1018e6:	89 c2                	mov    %eax,%edx
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	66 89 14 c5 c0 90 11 	mov    %dx,0x1190c0(,%eax,8)
  1018f2:	00 
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	66 c7 04 c5 c2 90 11 	movw   $0x8,0x1190c2(,%eax,8)
  1018fd:	00 08 00 
  101900:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101903:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  10190a:	00 
  10190b:	83 e2 e0             	and    $0xffffffe0,%edx
  10190e:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  101915:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101918:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  10191f:	00 
  101920:	83 e2 1f             	and    $0x1f,%edx
  101923:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  101934:	00 
  101935:	83 e2 f0             	and    $0xfffffff0,%edx
  101938:	83 ca 0e             	or     $0xe,%edx
  10193b:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  10194c:	00 
  10194d:	83 e2 ef             	and    $0xffffffef,%edx
  101950:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  101961:	00 
  101962:	83 e2 9f             	and    $0xffffff9f,%edx
  101965:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  101976:	00 
  101977:	83 ca 80             	or     $0xffffff80,%edx
  10197a:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  10198b:	c1 e8 10             	shr    $0x10,%eax
  10198e:	89 c2                	mov    %eax,%edx
  101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101993:	66 89 14 c5 c6 90 11 	mov    %dx,0x1190c6(,%eax,8)
  10199a:	00 
	for (int i = 0; i < 256; i++) {
  10199b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10199f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019a6:	0f 8e 30 ff ff ff    	jle    1018dc <idt_init+0x12>
  1019ac:	c7 45 f8 80 85 11 00 	movl   $0x118580,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019b6:	0f 01 18             	lidtl  (%eax)
	}
	lidt(&idt_pd);

	//for challenge1
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], 3);
  1019b9:	a1 e4 87 11 00       	mov    0x1187e4,%eax
  1019be:	66 a3 88 94 11 00    	mov    %ax,0x119488
  1019c4:	66 c7 05 8a 94 11 00 	movw   $0x8,0x11948a
  1019cb:	08 00 
  1019cd:	0f b6 05 8c 94 11 00 	movzbl 0x11948c,%eax
  1019d4:	83 e0 e0             	and    $0xffffffe0,%eax
  1019d7:	a2 8c 94 11 00       	mov    %al,0x11948c
  1019dc:	0f b6 05 8c 94 11 00 	movzbl 0x11948c,%eax
  1019e3:	83 e0 1f             	and    $0x1f,%eax
  1019e6:	a2 8c 94 11 00       	mov    %al,0x11948c
  1019eb:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  1019f2:	83 c8 0f             	or     $0xf,%eax
  1019f5:	a2 8d 94 11 00       	mov    %al,0x11948d
  1019fa:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a01:	83 e0 ef             	and    $0xffffffef,%eax
  101a04:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a09:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a10:	83 c8 60             	or     $0x60,%eax
  101a13:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a18:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a1f:	83 c8 80             	or     $0xffffff80,%eax
  101a22:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a27:	a1 e4 87 11 00       	mov    0x1187e4,%eax
  101a2c:	c1 e8 10             	shr    $0x10,%eax
  101a2f:	66 a3 8e 94 11 00    	mov    %ax,0x11948e
	SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], 0);
  101a35:	a1 e0 87 11 00       	mov    0x1187e0,%eax
  101a3a:	66 a3 80 94 11 00    	mov    %ax,0x119480
  101a40:	66 c7 05 82 94 11 00 	movw   $0x8,0x119482
  101a47:	08 00 
  101a49:	0f b6 05 84 94 11 00 	movzbl 0x119484,%eax
  101a50:	83 e0 e0             	and    $0xffffffe0,%eax
  101a53:	a2 84 94 11 00       	mov    %al,0x119484
  101a58:	0f b6 05 84 94 11 00 	movzbl 0x119484,%eax
  101a5f:	83 e0 1f             	and    $0x1f,%eax
  101a62:	a2 84 94 11 00       	mov    %al,0x119484
  101a67:	0f b6 05 85 94 11 00 	movzbl 0x119485,%eax
  101a6e:	83 e0 f0             	and    $0xfffffff0,%eax
  101a71:	83 c8 0e             	or     $0xe,%eax
  101a74:	a2 85 94 11 00       	mov    %al,0x119485
  101a79:	0f b6 05 85 94 11 00 	movzbl 0x119485,%eax
  101a80:	83 e0 ef             	and    $0xffffffef,%eax
  101a83:	a2 85 94 11 00       	mov    %al,0x119485
  101a88:	0f b6 05 85 94 11 00 	movzbl 0x119485,%eax
  101a8f:	83 e0 9f             	and    $0xffffff9f,%eax
  101a92:	a2 85 94 11 00       	mov    %al,0x119485
  101a97:	0f b6 05 85 94 11 00 	movzbl 0x119485,%eax
  101a9e:	83 c8 80             	or     $0xffffff80,%eax
  101aa1:	a2 85 94 11 00       	mov    %al,0x119485
  101aa6:	a1 e0 87 11 00       	mov    0x1187e0,%eax
  101aab:	c1 e8 10             	shr    $0x10,%eax
  101aae:	66 a3 86 94 11 00    	mov    %ax,0x119486
}
  101ab4:	90                   	nop
  101ab5:	c9                   	leave  
  101ab6:	c3                   	ret    

00101ab7 <trapname>:

static const char *
trapname(int trapno) {
  101ab7:	55                   	push   %ebp
  101ab8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101aba:	8b 45 08             	mov    0x8(%ebp),%eax
  101abd:	83 f8 13             	cmp    $0x13,%eax
  101ac0:	77 0c                	ja     101ace <trapname+0x17>
        return excnames[trapno];
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	8b 04 85 20 64 10 00 	mov    0x106420(,%eax,4),%eax
  101acc:	eb 18                	jmp    101ae6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ace:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ad2:	7e 0d                	jle    101ae1 <trapname+0x2a>
  101ad4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ad8:	7f 07                	jg     101ae1 <trapname+0x2a>
        return "Hardware Interrupt";
  101ada:	b8 df 60 10 00       	mov    $0x1060df,%eax
  101adf:	eb 05                	jmp    101ae6 <trapname+0x2f>
    }
    return "(unknown trap)";
  101ae1:	b8 f2 60 10 00       	mov    $0x1060f2,%eax
}
  101ae6:	5d                   	pop    %ebp
  101ae7:	c3                   	ret    

00101ae8 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ae8:	55                   	push   %ebp
  101ae9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101aee:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af2:	66 83 f8 08          	cmp    $0x8,%ax
  101af6:	0f 94 c0             	sete   %al
  101af9:	0f b6 c0             	movzbl %al,%eax
}
  101afc:	5d                   	pop    %ebp
  101afd:	c3                   	ret    

00101afe <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101afe:	55                   	push   %ebp
  101aff:	89 e5                	mov    %esp,%ebp
  101b01:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101b04:	83 ec 08             	sub    $0x8,%esp
  101b07:	ff 75 08             	pushl  0x8(%ebp)
  101b0a:	68 33 61 10 00       	push   $0x106133
  101b0f:	e8 63 e7 ff ff       	call   100277 <cprintf>
  101b14:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101b17:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1a:	83 ec 0c             	sub    $0xc,%esp
  101b1d:	50                   	push   %eax
  101b1e:	e8 b6 01 00 00       	call   101cd9 <print_regs>
  101b23:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b26:	8b 45 08             	mov    0x8(%ebp),%eax
  101b29:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b2d:	0f b7 c0             	movzwl %ax,%eax
  101b30:	83 ec 08             	sub    $0x8,%esp
  101b33:	50                   	push   %eax
  101b34:	68 44 61 10 00       	push   $0x106144
  101b39:	e8 39 e7 ff ff       	call   100277 <cprintf>
  101b3e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b41:	8b 45 08             	mov    0x8(%ebp),%eax
  101b44:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b48:	0f b7 c0             	movzwl %ax,%eax
  101b4b:	83 ec 08             	sub    $0x8,%esp
  101b4e:	50                   	push   %eax
  101b4f:	68 57 61 10 00       	push   $0x106157
  101b54:	e8 1e e7 ff ff       	call   100277 <cprintf>
  101b59:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b63:	0f b7 c0             	movzwl %ax,%eax
  101b66:	83 ec 08             	sub    $0x8,%esp
  101b69:	50                   	push   %eax
  101b6a:	68 6a 61 10 00       	push   $0x10616a
  101b6f:	e8 03 e7 ff ff       	call   100277 <cprintf>
  101b74:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b77:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b7e:	0f b7 c0             	movzwl %ax,%eax
  101b81:	83 ec 08             	sub    $0x8,%esp
  101b84:	50                   	push   %eax
  101b85:	68 7d 61 10 00       	push   $0x10617d
  101b8a:	e8 e8 e6 ff ff       	call   100277 <cprintf>
  101b8f:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b92:	8b 45 08             	mov    0x8(%ebp),%eax
  101b95:	8b 40 30             	mov    0x30(%eax),%eax
  101b98:	83 ec 0c             	sub    $0xc,%esp
  101b9b:	50                   	push   %eax
  101b9c:	e8 16 ff ff ff       	call   101ab7 <trapname>
  101ba1:	83 c4 10             	add    $0x10,%esp
  101ba4:	89 c2                	mov    %eax,%edx
  101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba9:	8b 40 30             	mov    0x30(%eax),%eax
  101bac:	83 ec 04             	sub    $0x4,%esp
  101baf:	52                   	push   %edx
  101bb0:	50                   	push   %eax
  101bb1:	68 90 61 10 00       	push   $0x106190
  101bb6:	e8 bc e6 ff ff       	call   100277 <cprintf>
  101bbb:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	8b 40 34             	mov    0x34(%eax),%eax
  101bc4:	83 ec 08             	sub    $0x8,%esp
  101bc7:	50                   	push   %eax
  101bc8:	68 a2 61 10 00       	push   $0x1061a2
  101bcd:	e8 a5 e6 ff ff       	call   100277 <cprintf>
  101bd2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 38             	mov    0x38(%eax),%eax
  101bdb:	83 ec 08             	sub    $0x8,%esp
  101bde:	50                   	push   %eax
  101bdf:	68 b1 61 10 00       	push   $0x1061b1
  101be4:	e8 8e e6 ff ff       	call   100277 <cprintf>
  101be9:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf3:	0f b7 c0             	movzwl %ax,%eax
  101bf6:	83 ec 08             	sub    $0x8,%esp
  101bf9:	50                   	push   %eax
  101bfa:	68 c0 61 10 00       	push   $0x1061c0
  101bff:	e8 73 e6 ff ff       	call   100277 <cprintf>
  101c04:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c07:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0a:	8b 40 40             	mov    0x40(%eax),%eax
  101c0d:	83 ec 08             	sub    $0x8,%esp
  101c10:	50                   	push   %eax
  101c11:	68 d3 61 10 00       	push   $0x1061d3
  101c16:	e8 5c e6 ff ff       	call   100277 <cprintf>
  101c1b:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c2c:	eb 3f                	jmp    101c6d <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	8b 50 40             	mov    0x40(%eax),%edx
  101c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c37:	21 d0                	and    %edx,%eax
  101c39:	85 c0                	test   %eax,%eax
  101c3b:	74 29                	je     101c66 <print_trapframe+0x168>
  101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c40:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c47:	85 c0                	test   %eax,%eax
  101c49:	74 1b                	je     101c66 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4e:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c55:	83 ec 08             	sub    $0x8,%esp
  101c58:	50                   	push   %eax
  101c59:	68 e2 61 10 00       	push   $0x1061e2
  101c5e:	e8 14 e6 ff ff       	call   100277 <cprintf>
  101c63:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c6a:	d1 65 f0             	shll   -0x10(%ebp)
  101c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c70:	83 f8 17             	cmp    $0x17,%eax
  101c73:	76 b9                	jbe    101c2e <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c75:	8b 45 08             	mov    0x8(%ebp),%eax
  101c78:	8b 40 40             	mov    0x40(%eax),%eax
  101c7b:	c1 e8 0c             	shr    $0xc,%eax
  101c7e:	83 e0 03             	and    $0x3,%eax
  101c81:	83 ec 08             	sub    $0x8,%esp
  101c84:	50                   	push   %eax
  101c85:	68 e6 61 10 00       	push   $0x1061e6
  101c8a:	e8 e8 e5 ff ff       	call   100277 <cprintf>
  101c8f:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101c92:	83 ec 0c             	sub    $0xc,%esp
  101c95:	ff 75 08             	pushl  0x8(%ebp)
  101c98:	e8 4b fe ff ff       	call   101ae8 <trap_in_kernel>
  101c9d:	83 c4 10             	add    $0x10,%esp
  101ca0:	85 c0                	test   %eax,%eax
  101ca2:	75 32                	jne    101cd6 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca7:	8b 40 44             	mov    0x44(%eax),%eax
  101caa:	83 ec 08             	sub    $0x8,%esp
  101cad:	50                   	push   %eax
  101cae:	68 ef 61 10 00       	push   $0x1061ef
  101cb3:	e8 bf e5 ff ff       	call   100277 <cprintf>
  101cb8:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbe:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cc2:	0f b7 c0             	movzwl %ax,%eax
  101cc5:	83 ec 08             	sub    $0x8,%esp
  101cc8:	50                   	push   %eax
  101cc9:	68 fe 61 10 00       	push   $0x1061fe
  101cce:	e8 a4 e5 ff ff       	call   100277 <cprintf>
  101cd3:	83 c4 10             	add    $0x10,%esp
    }
}
  101cd6:	90                   	nop
  101cd7:	c9                   	leave  
  101cd8:	c3                   	ret    

00101cd9 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cd9:	55                   	push   %ebp
  101cda:	89 e5                	mov    %esp,%ebp
  101cdc:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce2:	8b 00                	mov    (%eax),%eax
  101ce4:	83 ec 08             	sub    $0x8,%esp
  101ce7:	50                   	push   %eax
  101ce8:	68 11 62 10 00       	push   $0x106211
  101ced:	e8 85 e5 ff ff       	call   100277 <cprintf>
  101cf2:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf8:	8b 40 04             	mov    0x4(%eax),%eax
  101cfb:	83 ec 08             	sub    $0x8,%esp
  101cfe:	50                   	push   %eax
  101cff:	68 20 62 10 00       	push   $0x106220
  101d04:	e8 6e e5 ff ff       	call   100277 <cprintf>
  101d09:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0f:	8b 40 08             	mov    0x8(%eax),%eax
  101d12:	83 ec 08             	sub    $0x8,%esp
  101d15:	50                   	push   %eax
  101d16:	68 2f 62 10 00       	push   $0x10622f
  101d1b:	e8 57 e5 ff ff       	call   100277 <cprintf>
  101d20:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d23:	8b 45 08             	mov    0x8(%ebp),%eax
  101d26:	8b 40 0c             	mov    0xc(%eax),%eax
  101d29:	83 ec 08             	sub    $0x8,%esp
  101d2c:	50                   	push   %eax
  101d2d:	68 3e 62 10 00       	push   $0x10623e
  101d32:	e8 40 e5 ff ff       	call   100277 <cprintf>
  101d37:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3d:	8b 40 10             	mov    0x10(%eax),%eax
  101d40:	83 ec 08             	sub    $0x8,%esp
  101d43:	50                   	push   %eax
  101d44:	68 4d 62 10 00       	push   $0x10624d
  101d49:	e8 29 e5 ff ff       	call   100277 <cprintf>
  101d4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	8b 40 14             	mov    0x14(%eax),%eax
  101d57:	83 ec 08             	sub    $0x8,%esp
  101d5a:	50                   	push   %eax
  101d5b:	68 5c 62 10 00       	push   $0x10625c
  101d60:	e8 12 e5 ff ff       	call   100277 <cprintf>
  101d65:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d68:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6b:	8b 40 18             	mov    0x18(%eax),%eax
  101d6e:	83 ec 08             	sub    $0x8,%esp
  101d71:	50                   	push   %eax
  101d72:	68 6b 62 10 00       	push   $0x10626b
  101d77:	e8 fb e4 ff ff       	call   100277 <cprintf>
  101d7c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d82:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d85:	83 ec 08             	sub    $0x8,%esp
  101d88:	50                   	push   %eax
  101d89:	68 7a 62 10 00       	push   $0x10627a
  101d8e:	e8 e4 e4 ff ff       	call   100277 <cprintf>
  101d93:	83 c4 10             	add    $0x10,%esp
}
  101d96:	90                   	nop
  101d97:	c9                   	leave  
  101d98:	c3                   	ret    

00101d99 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d99:	55                   	push   %ebp
  101d9a:	89 e5                	mov    %esp,%ebp
  101d9c:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101da2:	8b 40 30             	mov    0x30(%eax),%eax
  101da5:	83 f8 2f             	cmp    $0x2f,%eax
  101da8:	77 21                	ja     101dcb <trap_dispatch+0x32>
  101daa:	83 f8 2e             	cmp    $0x2e,%eax
  101dad:	0f 83 5c 02 00 00    	jae    10200f <trap_dispatch+0x276>
  101db3:	83 f8 21             	cmp    $0x21,%eax
  101db6:	0f 84 87 00 00 00    	je     101e43 <trap_dispatch+0xaa>
  101dbc:	83 f8 24             	cmp    $0x24,%eax
  101dbf:	74 5b                	je     101e1c <trap_dispatch+0x83>
  101dc1:	83 f8 20             	cmp    $0x20,%eax
  101dc4:	74 1c                	je     101de2 <trap_dispatch+0x49>
  101dc6:	e9 0e 02 00 00       	jmp    101fd9 <trap_dispatch+0x240>
  101dcb:	83 f8 78             	cmp    $0x78,%eax
  101dce:	0f 84 5e 01 00 00    	je     101f32 <trap_dispatch+0x199>
  101dd4:	83 f8 79             	cmp    $0x79,%eax
  101dd7:	0f 84 aa 01 00 00    	je     101f87 <trap_dispatch+0x1ee>
  101ddd:	e9 f7 01 00 00       	jmp    101fd9 <trap_dispatch+0x240>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks += 1;
  101de2:	a1 4c 99 11 00       	mov    0x11994c,%eax
  101de7:	83 c0 01             	add    $0x1,%eax
  101dea:	a3 4c 99 11 00       	mov    %eax,0x11994c
		if (ticks%TICK_NUM == 0) {
  101def:	8b 0d 4c 99 11 00    	mov    0x11994c,%ecx
  101df5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101dfa:	89 c8                	mov    %ecx,%eax
  101dfc:	f7 e2                	mul    %edx
  101dfe:	89 d0                	mov    %edx,%eax
  101e00:	c1 e8 05             	shr    $0x5,%eax
  101e03:	6b c0 64             	imul   $0x64,%eax,%eax
  101e06:	29 c1                	sub    %eax,%ecx
  101e08:	89 c8                	mov    %ecx,%eax
  101e0a:	85 c0                	test   %eax,%eax
  101e0c:	0f 85 00 02 00 00    	jne    102012 <trap_dispatch+0x279>
			print_ticks();
  101e12:	e8 77 fa ff ff       	call   10188e <print_ticks>
		}
		break;
  101e17:	e9 f6 01 00 00       	jmp    102012 <trap_dispatch+0x279>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e1c:	e8 2a f8 ff ff       	call   10164b <cons_getc>
  101e21:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e24:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e28:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e2c:	83 ec 04             	sub    $0x4,%esp
  101e2f:	52                   	push   %edx
  101e30:	50                   	push   %eax
  101e31:	68 89 62 10 00       	push   $0x106289
  101e36:	e8 3c e4 ff ff       	call   100277 <cprintf>
  101e3b:	83 c4 10             	add    $0x10,%esp
        break;
  101e3e:	e9 d9 01 00 00       	jmp    10201c <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_KBD:
		c = cons_getc();
  101e43:	e8 03 f8 ff ff       	call   10164b <cons_getc>
  101e48:	88 45 f7             	mov    %al,-0x9(%ebp)

		cprintf("kbd [%03d] %c\n", c, c);
  101e4b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e4f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e53:	83 ec 04             	sub    $0x4,%esp
  101e56:	52                   	push   %edx
  101e57:	50                   	push   %eax
  101e58:	68 9b 62 10 00       	push   $0x10629b
  101e5d:	e8 15 e4 ff ff       	call   100277 <cprintf>
  101e62:	83 c4 10             	add    $0x10,%esp
		if (c == '0') {
  101e65:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101e69:	75 5a                	jne    101ec5 <trap_dispatch+0x12c>
			if (tf->tf_cs != (uint16_t)KERNEL_CS) {
  101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e72:	66 83 f8 08          	cmp    $0x8,%ax
  101e76:	74 4d                	je     101ec5 <trap_dispatch+0x12c>
				tf->tf_cs = (uint16_t)KERNEL_CS;
  101e78:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)KERNEL_DS;
  101e81:	8b 45 08             	mov    0x8(%ebp),%eax
  101e84:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8d:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e98:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags &= ~FL_IOPL_MASK;
  101ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea9:	8b 40 40             	mov    0x40(%eax),%eax
  101eac:	80 e4 cf             	and    $0xcf,%ah
  101eaf:	89 c2                	mov    %eax,%edx
  101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb4:	89 50 40             	mov    %edx,0x40(%eax)
				print_trapframe(tf);
  101eb7:	83 ec 0c             	sub    $0xc,%esp
  101eba:	ff 75 08             	pushl  0x8(%ebp)
  101ebd:	e8 3c fc ff ff       	call   101afe <print_trapframe>
  101ec2:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (c == '3') {
  101ec5:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101ec9:	0f 85 46 01 00 00    	jne    102015 <trap_dispatch+0x27c>
			if (tf->tf_cs != (uint16_t)USER_CS) {
  101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed6:	66 83 f8 1b          	cmp    $0x1b,%ax
  101eda:	0f 84 35 01 00 00    	je     102015 <trap_dispatch+0x27c>
				tf->tf_cs = (uint16_t)USER_CS;
  101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee3:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)USER_DS;
  101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eec:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef5:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f00:	8b 45 08             	mov    0x8(%ebp),%eax
  101f03:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f07:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
  101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f11:	8b 40 40             	mov    0x40(%eax),%eax
  101f14:	80 cc 30             	or     $0x30,%ah
  101f17:	89 c2                	mov    %eax,%edx
  101f19:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1c:	89 50 40             	mov    %edx,0x40(%eax)
				print_trapframe(tf);
  101f1f:	83 ec 0c             	sub    $0xc,%esp
  101f22:	ff 75 08             	pushl  0x8(%ebp)
  101f25:	e8 d4 fb ff ff       	call   101afe <print_trapframe>
  101f2a:	83 c4 10             	add    $0x10,%esp
			}
		}
		break;
  101f2d:	e9 e3 00 00 00       	jmp    102015 <trap_dispatch+0x27c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
		if (tf->tf_cs != (uint16_t)USER_CS) {
  101f32:	8b 45 08             	mov    0x8(%ebp),%eax
  101f35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f39:	66 83 f8 1b          	cmp    $0x1b,%ax
  101f3d:	0f 84 d5 00 00 00    	je     102018 <trap_dispatch+0x27f>
			tf->tf_cs = (uint16_t)USER_CS;
  101f43:	8b 45 08             	mov    0x8(%ebp),%eax
  101f46:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)USER_DS;
  101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4f:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f63:	8b 45 08             	mov    0x8(%ebp),%eax
  101f66:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;  //3000
  101f71:	8b 45 08             	mov    0x8(%ebp),%eax
  101f74:	8b 40 40             	mov    0x40(%eax),%eax
  101f77:	80 cc 30             	or     $0x30,%ah
  101f7a:	89 c2                	mov    %eax,%edx
  101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7f:	89 50 40             	mov    %edx,0x40(%eax)

		}
		break;
  101f82:	e9 91 00 00 00       	jmp    102018 <trap_dispatch+0x27f>
    case T_SWITCH_TOK:
		if (tf->tf_cs != (uint16_t)KERNEL_CS) {
  101f87:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f8e:	66 83 f8 08          	cmp    $0x8,%ax
  101f92:	0f 84 83 00 00 00    	je     10201b <trap_dispatch+0x282>
			tf->tf_cs = (uint16_t)KERNEL_CS;
  101f98:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ds = tf->tf_es = tf->tf_ss = (uint16_t)KERNEL_DS;
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101faa:	8b 45 08             	mov    0x8(%ebp),%eax
  101fad:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb4:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbb:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
  101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc9:	8b 40 40             	mov    0x40(%eax),%eax
  101fcc:	80 e4 cf             	and    $0xcf,%ah
  101fcf:	89 c2                	mov    %eax,%edx
  101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd4:	89 50 40             	mov    %edx,0x40(%eax)
		}
		break;
  101fd7:	eb 42                	jmp    10201b <trap_dispatch+0x282>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fdc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe0:	0f b7 c0             	movzwl %ax,%eax
  101fe3:	83 e0 03             	and    $0x3,%eax
  101fe6:	85 c0                	test   %eax,%eax
  101fe8:	75 32                	jne    10201c <trap_dispatch+0x283>
            print_trapframe(tf);
  101fea:	83 ec 0c             	sub    $0xc,%esp
  101fed:	ff 75 08             	pushl  0x8(%ebp)
  101ff0:	e8 09 fb ff ff       	call   101afe <print_trapframe>
  101ff5:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ff8:	83 ec 04             	sub    $0x4,%esp
  101ffb:	68 aa 62 10 00       	push   $0x1062aa
  102000:	68 d5 00 00 00       	push   $0xd5
  102005:	68 ce 60 10 00       	push   $0x1060ce
  10200a:	e8 ce e3 ff ff       	call   1003dd <__panic>
        break;
  10200f:	90                   	nop
  102010:	eb 0a                	jmp    10201c <trap_dispatch+0x283>
		break;
  102012:	90                   	nop
  102013:	eb 07                	jmp    10201c <trap_dispatch+0x283>
		break;
  102015:	90                   	nop
  102016:	eb 04                	jmp    10201c <trap_dispatch+0x283>
		break;
  102018:	90                   	nop
  102019:	eb 01                	jmp    10201c <trap_dispatch+0x283>
		break;
  10201b:	90                   	nop
        }
    }
}
  10201c:	90                   	nop
  10201d:	c9                   	leave  
  10201e:	c3                   	ret    

0010201f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10201f:	55                   	push   %ebp
  102020:	89 e5                	mov    %esp,%ebp
  102022:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102025:	83 ec 0c             	sub    $0xc,%esp
  102028:	ff 75 08             	pushl  0x8(%ebp)
  10202b:	e8 69 fd ff ff       	call   101d99 <trap_dispatch>
  102030:	83 c4 10             	add    $0x10,%esp
}
  102033:	90                   	nop
  102034:	c9                   	leave  
  102035:	c3                   	ret    

00102036 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $0
  102038:	6a 00                	push   $0x0
  jmp __alltraps
  10203a:	e9 67 0a 00 00       	jmp    102aa6 <__alltraps>

0010203f <vector1>:
.globl vector1
vector1:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $1
  102041:	6a 01                	push   $0x1
  jmp __alltraps
  102043:	e9 5e 0a 00 00       	jmp    102aa6 <__alltraps>

00102048 <vector2>:
.globl vector2
vector2:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $2
  10204a:	6a 02                	push   $0x2
  jmp __alltraps
  10204c:	e9 55 0a 00 00       	jmp    102aa6 <__alltraps>

00102051 <vector3>:
.globl vector3
vector3:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $3
  102053:	6a 03                	push   $0x3
  jmp __alltraps
  102055:	e9 4c 0a 00 00       	jmp    102aa6 <__alltraps>

0010205a <vector4>:
.globl vector4
vector4:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $4
  10205c:	6a 04                	push   $0x4
  jmp __alltraps
  10205e:	e9 43 0a 00 00       	jmp    102aa6 <__alltraps>

00102063 <vector5>:
.globl vector5
vector5:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $5
  102065:	6a 05                	push   $0x5
  jmp __alltraps
  102067:	e9 3a 0a 00 00       	jmp    102aa6 <__alltraps>

0010206c <vector6>:
.globl vector6
vector6:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $6
  10206e:	6a 06                	push   $0x6
  jmp __alltraps
  102070:	e9 31 0a 00 00       	jmp    102aa6 <__alltraps>

00102075 <vector7>:
.globl vector7
vector7:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $7
  102077:	6a 07                	push   $0x7
  jmp __alltraps
  102079:	e9 28 0a 00 00       	jmp    102aa6 <__alltraps>

0010207e <vector8>:
.globl vector8
vector8:
  pushl $8
  10207e:	6a 08                	push   $0x8
  jmp __alltraps
  102080:	e9 21 0a 00 00       	jmp    102aa6 <__alltraps>

00102085 <vector9>:
.globl vector9
vector9:
  pushl $9
  102085:	6a 09                	push   $0x9
  jmp __alltraps
  102087:	e9 1a 0a 00 00       	jmp    102aa6 <__alltraps>

0010208c <vector10>:
.globl vector10
vector10:
  pushl $10
  10208c:	6a 0a                	push   $0xa
  jmp __alltraps
  10208e:	e9 13 0a 00 00       	jmp    102aa6 <__alltraps>

00102093 <vector11>:
.globl vector11
vector11:
  pushl $11
  102093:	6a 0b                	push   $0xb
  jmp __alltraps
  102095:	e9 0c 0a 00 00       	jmp    102aa6 <__alltraps>

0010209a <vector12>:
.globl vector12
vector12:
  pushl $12
  10209a:	6a 0c                	push   $0xc
  jmp __alltraps
  10209c:	e9 05 0a 00 00       	jmp    102aa6 <__alltraps>

001020a1 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020a1:	6a 0d                	push   $0xd
  jmp __alltraps
  1020a3:	e9 fe 09 00 00       	jmp    102aa6 <__alltraps>

001020a8 <vector14>:
.globl vector14
vector14:
  pushl $14
  1020a8:	6a 0e                	push   $0xe
  jmp __alltraps
  1020aa:	e9 f7 09 00 00       	jmp    102aa6 <__alltraps>

001020af <vector15>:
.globl vector15
vector15:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $15
  1020b1:	6a 0f                	push   $0xf
  jmp __alltraps
  1020b3:	e9 ee 09 00 00       	jmp    102aa6 <__alltraps>

001020b8 <vector16>:
.globl vector16
vector16:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $16
  1020ba:	6a 10                	push   $0x10
  jmp __alltraps
  1020bc:	e9 e5 09 00 00       	jmp    102aa6 <__alltraps>

001020c1 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020c1:	6a 11                	push   $0x11
  jmp __alltraps
  1020c3:	e9 de 09 00 00       	jmp    102aa6 <__alltraps>

001020c8 <vector18>:
.globl vector18
vector18:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $18
  1020ca:	6a 12                	push   $0x12
  jmp __alltraps
  1020cc:	e9 d5 09 00 00       	jmp    102aa6 <__alltraps>

001020d1 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $19
  1020d3:	6a 13                	push   $0x13
  jmp __alltraps
  1020d5:	e9 cc 09 00 00       	jmp    102aa6 <__alltraps>

001020da <vector20>:
.globl vector20
vector20:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $20
  1020dc:	6a 14                	push   $0x14
  jmp __alltraps
  1020de:	e9 c3 09 00 00       	jmp    102aa6 <__alltraps>

001020e3 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $21
  1020e5:	6a 15                	push   $0x15
  jmp __alltraps
  1020e7:	e9 ba 09 00 00       	jmp    102aa6 <__alltraps>

001020ec <vector22>:
.globl vector22
vector22:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $22
  1020ee:	6a 16                	push   $0x16
  jmp __alltraps
  1020f0:	e9 b1 09 00 00       	jmp    102aa6 <__alltraps>

001020f5 <vector23>:
.globl vector23
vector23:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $23
  1020f7:	6a 17                	push   $0x17
  jmp __alltraps
  1020f9:	e9 a8 09 00 00       	jmp    102aa6 <__alltraps>

001020fe <vector24>:
.globl vector24
vector24:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $24
  102100:	6a 18                	push   $0x18
  jmp __alltraps
  102102:	e9 9f 09 00 00       	jmp    102aa6 <__alltraps>

00102107 <vector25>:
.globl vector25
vector25:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $25
  102109:	6a 19                	push   $0x19
  jmp __alltraps
  10210b:	e9 96 09 00 00       	jmp    102aa6 <__alltraps>

00102110 <vector26>:
.globl vector26
vector26:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $26
  102112:	6a 1a                	push   $0x1a
  jmp __alltraps
  102114:	e9 8d 09 00 00       	jmp    102aa6 <__alltraps>

00102119 <vector27>:
.globl vector27
vector27:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $27
  10211b:	6a 1b                	push   $0x1b
  jmp __alltraps
  10211d:	e9 84 09 00 00       	jmp    102aa6 <__alltraps>

00102122 <vector28>:
.globl vector28
vector28:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $28
  102124:	6a 1c                	push   $0x1c
  jmp __alltraps
  102126:	e9 7b 09 00 00       	jmp    102aa6 <__alltraps>

0010212b <vector29>:
.globl vector29
vector29:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $29
  10212d:	6a 1d                	push   $0x1d
  jmp __alltraps
  10212f:	e9 72 09 00 00       	jmp    102aa6 <__alltraps>

00102134 <vector30>:
.globl vector30
vector30:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $30
  102136:	6a 1e                	push   $0x1e
  jmp __alltraps
  102138:	e9 69 09 00 00       	jmp    102aa6 <__alltraps>

0010213d <vector31>:
.globl vector31
vector31:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $31
  10213f:	6a 1f                	push   $0x1f
  jmp __alltraps
  102141:	e9 60 09 00 00       	jmp    102aa6 <__alltraps>

00102146 <vector32>:
.globl vector32
vector32:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $32
  102148:	6a 20                	push   $0x20
  jmp __alltraps
  10214a:	e9 57 09 00 00       	jmp    102aa6 <__alltraps>

0010214f <vector33>:
.globl vector33
vector33:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $33
  102151:	6a 21                	push   $0x21
  jmp __alltraps
  102153:	e9 4e 09 00 00       	jmp    102aa6 <__alltraps>

00102158 <vector34>:
.globl vector34
vector34:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $34
  10215a:	6a 22                	push   $0x22
  jmp __alltraps
  10215c:	e9 45 09 00 00       	jmp    102aa6 <__alltraps>

00102161 <vector35>:
.globl vector35
vector35:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $35
  102163:	6a 23                	push   $0x23
  jmp __alltraps
  102165:	e9 3c 09 00 00       	jmp    102aa6 <__alltraps>

0010216a <vector36>:
.globl vector36
vector36:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $36
  10216c:	6a 24                	push   $0x24
  jmp __alltraps
  10216e:	e9 33 09 00 00       	jmp    102aa6 <__alltraps>

00102173 <vector37>:
.globl vector37
vector37:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $37
  102175:	6a 25                	push   $0x25
  jmp __alltraps
  102177:	e9 2a 09 00 00       	jmp    102aa6 <__alltraps>

0010217c <vector38>:
.globl vector38
vector38:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $38
  10217e:	6a 26                	push   $0x26
  jmp __alltraps
  102180:	e9 21 09 00 00       	jmp    102aa6 <__alltraps>

00102185 <vector39>:
.globl vector39
vector39:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $39
  102187:	6a 27                	push   $0x27
  jmp __alltraps
  102189:	e9 18 09 00 00       	jmp    102aa6 <__alltraps>

0010218e <vector40>:
.globl vector40
vector40:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $40
  102190:	6a 28                	push   $0x28
  jmp __alltraps
  102192:	e9 0f 09 00 00       	jmp    102aa6 <__alltraps>

00102197 <vector41>:
.globl vector41
vector41:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $41
  102199:	6a 29                	push   $0x29
  jmp __alltraps
  10219b:	e9 06 09 00 00       	jmp    102aa6 <__alltraps>

001021a0 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $42
  1021a2:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021a4:	e9 fd 08 00 00       	jmp    102aa6 <__alltraps>

001021a9 <vector43>:
.globl vector43
vector43:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $43
  1021ab:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021ad:	e9 f4 08 00 00       	jmp    102aa6 <__alltraps>

001021b2 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $44
  1021b4:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021b6:	e9 eb 08 00 00       	jmp    102aa6 <__alltraps>

001021bb <vector45>:
.globl vector45
vector45:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $45
  1021bd:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021bf:	e9 e2 08 00 00       	jmp    102aa6 <__alltraps>

001021c4 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $46
  1021c6:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021c8:	e9 d9 08 00 00       	jmp    102aa6 <__alltraps>

001021cd <vector47>:
.globl vector47
vector47:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $47
  1021cf:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021d1:	e9 d0 08 00 00       	jmp    102aa6 <__alltraps>

001021d6 <vector48>:
.globl vector48
vector48:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $48
  1021d8:	6a 30                	push   $0x30
  jmp __alltraps
  1021da:	e9 c7 08 00 00       	jmp    102aa6 <__alltraps>

001021df <vector49>:
.globl vector49
vector49:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $49
  1021e1:	6a 31                	push   $0x31
  jmp __alltraps
  1021e3:	e9 be 08 00 00       	jmp    102aa6 <__alltraps>

001021e8 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $50
  1021ea:	6a 32                	push   $0x32
  jmp __alltraps
  1021ec:	e9 b5 08 00 00       	jmp    102aa6 <__alltraps>

001021f1 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $51
  1021f3:	6a 33                	push   $0x33
  jmp __alltraps
  1021f5:	e9 ac 08 00 00       	jmp    102aa6 <__alltraps>

001021fa <vector52>:
.globl vector52
vector52:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $52
  1021fc:	6a 34                	push   $0x34
  jmp __alltraps
  1021fe:	e9 a3 08 00 00       	jmp    102aa6 <__alltraps>

00102203 <vector53>:
.globl vector53
vector53:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $53
  102205:	6a 35                	push   $0x35
  jmp __alltraps
  102207:	e9 9a 08 00 00       	jmp    102aa6 <__alltraps>

0010220c <vector54>:
.globl vector54
vector54:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $54
  10220e:	6a 36                	push   $0x36
  jmp __alltraps
  102210:	e9 91 08 00 00       	jmp    102aa6 <__alltraps>

00102215 <vector55>:
.globl vector55
vector55:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $55
  102217:	6a 37                	push   $0x37
  jmp __alltraps
  102219:	e9 88 08 00 00       	jmp    102aa6 <__alltraps>

0010221e <vector56>:
.globl vector56
vector56:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $56
  102220:	6a 38                	push   $0x38
  jmp __alltraps
  102222:	e9 7f 08 00 00       	jmp    102aa6 <__alltraps>

00102227 <vector57>:
.globl vector57
vector57:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $57
  102229:	6a 39                	push   $0x39
  jmp __alltraps
  10222b:	e9 76 08 00 00       	jmp    102aa6 <__alltraps>

00102230 <vector58>:
.globl vector58
vector58:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $58
  102232:	6a 3a                	push   $0x3a
  jmp __alltraps
  102234:	e9 6d 08 00 00       	jmp    102aa6 <__alltraps>

00102239 <vector59>:
.globl vector59
vector59:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $59
  10223b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10223d:	e9 64 08 00 00       	jmp    102aa6 <__alltraps>

00102242 <vector60>:
.globl vector60
vector60:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $60
  102244:	6a 3c                	push   $0x3c
  jmp __alltraps
  102246:	e9 5b 08 00 00       	jmp    102aa6 <__alltraps>

0010224b <vector61>:
.globl vector61
vector61:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $61
  10224d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10224f:	e9 52 08 00 00       	jmp    102aa6 <__alltraps>

00102254 <vector62>:
.globl vector62
vector62:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $62
  102256:	6a 3e                	push   $0x3e
  jmp __alltraps
  102258:	e9 49 08 00 00       	jmp    102aa6 <__alltraps>

0010225d <vector63>:
.globl vector63
vector63:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $63
  10225f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102261:	e9 40 08 00 00       	jmp    102aa6 <__alltraps>

00102266 <vector64>:
.globl vector64
vector64:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $64
  102268:	6a 40                	push   $0x40
  jmp __alltraps
  10226a:	e9 37 08 00 00       	jmp    102aa6 <__alltraps>

0010226f <vector65>:
.globl vector65
vector65:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $65
  102271:	6a 41                	push   $0x41
  jmp __alltraps
  102273:	e9 2e 08 00 00       	jmp    102aa6 <__alltraps>

00102278 <vector66>:
.globl vector66
vector66:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $66
  10227a:	6a 42                	push   $0x42
  jmp __alltraps
  10227c:	e9 25 08 00 00       	jmp    102aa6 <__alltraps>

00102281 <vector67>:
.globl vector67
vector67:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $67
  102283:	6a 43                	push   $0x43
  jmp __alltraps
  102285:	e9 1c 08 00 00       	jmp    102aa6 <__alltraps>

0010228a <vector68>:
.globl vector68
vector68:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $68
  10228c:	6a 44                	push   $0x44
  jmp __alltraps
  10228e:	e9 13 08 00 00       	jmp    102aa6 <__alltraps>

00102293 <vector69>:
.globl vector69
vector69:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $69
  102295:	6a 45                	push   $0x45
  jmp __alltraps
  102297:	e9 0a 08 00 00       	jmp    102aa6 <__alltraps>

0010229c <vector70>:
.globl vector70
vector70:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $70
  10229e:	6a 46                	push   $0x46
  jmp __alltraps
  1022a0:	e9 01 08 00 00       	jmp    102aa6 <__alltraps>

001022a5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $71
  1022a7:	6a 47                	push   $0x47
  jmp __alltraps
  1022a9:	e9 f8 07 00 00       	jmp    102aa6 <__alltraps>

001022ae <vector72>:
.globl vector72
vector72:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $72
  1022b0:	6a 48                	push   $0x48
  jmp __alltraps
  1022b2:	e9 ef 07 00 00       	jmp    102aa6 <__alltraps>

001022b7 <vector73>:
.globl vector73
vector73:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $73
  1022b9:	6a 49                	push   $0x49
  jmp __alltraps
  1022bb:	e9 e6 07 00 00       	jmp    102aa6 <__alltraps>

001022c0 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $74
  1022c2:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022c4:	e9 dd 07 00 00       	jmp    102aa6 <__alltraps>

001022c9 <vector75>:
.globl vector75
vector75:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $75
  1022cb:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022cd:	e9 d4 07 00 00       	jmp    102aa6 <__alltraps>

001022d2 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $76
  1022d4:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022d6:	e9 cb 07 00 00       	jmp    102aa6 <__alltraps>

001022db <vector77>:
.globl vector77
vector77:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $77
  1022dd:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022df:	e9 c2 07 00 00       	jmp    102aa6 <__alltraps>

001022e4 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $78
  1022e6:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022e8:	e9 b9 07 00 00       	jmp    102aa6 <__alltraps>

001022ed <vector79>:
.globl vector79
vector79:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $79
  1022ef:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022f1:	e9 b0 07 00 00       	jmp    102aa6 <__alltraps>

001022f6 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $80
  1022f8:	6a 50                	push   $0x50
  jmp __alltraps
  1022fa:	e9 a7 07 00 00       	jmp    102aa6 <__alltraps>

001022ff <vector81>:
.globl vector81
vector81:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $81
  102301:	6a 51                	push   $0x51
  jmp __alltraps
  102303:	e9 9e 07 00 00       	jmp    102aa6 <__alltraps>

00102308 <vector82>:
.globl vector82
vector82:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $82
  10230a:	6a 52                	push   $0x52
  jmp __alltraps
  10230c:	e9 95 07 00 00       	jmp    102aa6 <__alltraps>

00102311 <vector83>:
.globl vector83
vector83:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $83
  102313:	6a 53                	push   $0x53
  jmp __alltraps
  102315:	e9 8c 07 00 00       	jmp    102aa6 <__alltraps>

0010231a <vector84>:
.globl vector84
vector84:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $84
  10231c:	6a 54                	push   $0x54
  jmp __alltraps
  10231e:	e9 83 07 00 00       	jmp    102aa6 <__alltraps>

00102323 <vector85>:
.globl vector85
vector85:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $85
  102325:	6a 55                	push   $0x55
  jmp __alltraps
  102327:	e9 7a 07 00 00       	jmp    102aa6 <__alltraps>

0010232c <vector86>:
.globl vector86
vector86:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $86
  10232e:	6a 56                	push   $0x56
  jmp __alltraps
  102330:	e9 71 07 00 00       	jmp    102aa6 <__alltraps>

00102335 <vector87>:
.globl vector87
vector87:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $87
  102337:	6a 57                	push   $0x57
  jmp __alltraps
  102339:	e9 68 07 00 00       	jmp    102aa6 <__alltraps>

0010233e <vector88>:
.globl vector88
vector88:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $88
  102340:	6a 58                	push   $0x58
  jmp __alltraps
  102342:	e9 5f 07 00 00       	jmp    102aa6 <__alltraps>

00102347 <vector89>:
.globl vector89
vector89:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $89
  102349:	6a 59                	push   $0x59
  jmp __alltraps
  10234b:	e9 56 07 00 00       	jmp    102aa6 <__alltraps>

00102350 <vector90>:
.globl vector90
vector90:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $90
  102352:	6a 5a                	push   $0x5a
  jmp __alltraps
  102354:	e9 4d 07 00 00       	jmp    102aa6 <__alltraps>

00102359 <vector91>:
.globl vector91
vector91:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $91
  10235b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10235d:	e9 44 07 00 00       	jmp    102aa6 <__alltraps>

00102362 <vector92>:
.globl vector92
vector92:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $92
  102364:	6a 5c                	push   $0x5c
  jmp __alltraps
  102366:	e9 3b 07 00 00       	jmp    102aa6 <__alltraps>

0010236b <vector93>:
.globl vector93
vector93:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $93
  10236d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10236f:	e9 32 07 00 00       	jmp    102aa6 <__alltraps>

00102374 <vector94>:
.globl vector94
vector94:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $94
  102376:	6a 5e                	push   $0x5e
  jmp __alltraps
  102378:	e9 29 07 00 00       	jmp    102aa6 <__alltraps>

0010237d <vector95>:
.globl vector95
vector95:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $95
  10237f:	6a 5f                	push   $0x5f
  jmp __alltraps
  102381:	e9 20 07 00 00       	jmp    102aa6 <__alltraps>

00102386 <vector96>:
.globl vector96
vector96:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $96
  102388:	6a 60                	push   $0x60
  jmp __alltraps
  10238a:	e9 17 07 00 00       	jmp    102aa6 <__alltraps>

0010238f <vector97>:
.globl vector97
vector97:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $97
  102391:	6a 61                	push   $0x61
  jmp __alltraps
  102393:	e9 0e 07 00 00       	jmp    102aa6 <__alltraps>

00102398 <vector98>:
.globl vector98
vector98:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $98
  10239a:	6a 62                	push   $0x62
  jmp __alltraps
  10239c:	e9 05 07 00 00       	jmp    102aa6 <__alltraps>

001023a1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $99
  1023a3:	6a 63                	push   $0x63
  jmp __alltraps
  1023a5:	e9 fc 06 00 00       	jmp    102aa6 <__alltraps>

001023aa <vector100>:
.globl vector100
vector100:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $100
  1023ac:	6a 64                	push   $0x64
  jmp __alltraps
  1023ae:	e9 f3 06 00 00       	jmp    102aa6 <__alltraps>

001023b3 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $101
  1023b5:	6a 65                	push   $0x65
  jmp __alltraps
  1023b7:	e9 ea 06 00 00       	jmp    102aa6 <__alltraps>

001023bc <vector102>:
.globl vector102
vector102:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $102
  1023be:	6a 66                	push   $0x66
  jmp __alltraps
  1023c0:	e9 e1 06 00 00       	jmp    102aa6 <__alltraps>

001023c5 <vector103>:
.globl vector103
vector103:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $103
  1023c7:	6a 67                	push   $0x67
  jmp __alltraps
  1023c9:	e9 d8 06 00 00       	jmp    102aa6 <__alltraps>

001023ce <vector104>:
.globl vector104
vector104:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $104
  1023d0:	6a 68                	push   $0x68
  jmp __alltraps
  1023d2:	e9 cf 06 00 00       	jmp    102aa6 <__alltraps>

001023d7 <vector105>:
.globl vector105
vector105:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $105
  1023d9:	6a 69                	push   $0x69
  jmp __alltraps
  1023db:	e9 c6 06 00 00       	jmp    102aa6 <__alltraps>

001023e0 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $106
  1023e2:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023e4:	e9 bd 06 00 00       	jmp    102aa6 <__alltraps>

001023e9 <vector107>:
.globl vector107
vector107:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $107
  1023eb:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023ed:	e9 b4 06 00 00       	jmp    102aa6 <__alltraps>

001023f2 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $108
  1023f4:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023f6:	e9 ab 06 00 00       	jmp    102aa6 <__alltraps>

001023fb <vector109>:
.globl vector109
vector109:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $109
  1023fd:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023ff:	e9 a2 06 00 00       	jmp    102aa6 <__alltraps>

00102404 <vector110>:
.globl vector110
vector110:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $110
  102406:	6a 6e                	push   $0x6e
  jmp __alltraps
  102408:	e9 99 06 00 00       	jmp    102aa6 <__alltraps>

0010240d <vector111>:
.globl vector111
vector111:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $111
  10240f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102411:	e9 90 06 00 00       	jmp    102aa6 <__alltraps>

00102416 <vector112>:
.globl vector112
vector112:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $112
  102418:	6a 70                	push   $0x70
  jmp __alltraps
  10241a:	e9 87 06 00 00       	jmp    102aa6 <__alltraps>

0010241f <vector113>:
.globl vector113
vector113:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $113
  102421:	6a 71                	push   $0x71
  jmp __alltraps
  102423:	e9 7e 06 00 00       	jmp    102aa6 <__alltraps>

00102428 <vector114>:
.globl vector114
vector114:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $114
  10242a:	6a 72                	push   $0x72
  jmp __alltraps
  10242c:	e9 75 06 00 00       	jmp    102aa6 <__alltraps>

00102431 <vector115>:
.globl vector115
vector115:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $115
  102433:	6a 73                	push   $0x73
  jmp __alltraps
  102435:	e9 6c 06 00 00       	jmp    102aa6 <__alltraps>

0010243a <vector116>:
.globl vector116
vector116:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $116
  10243c:	6a 74                	push   $0x74
  jmp __alltraps
  10243e:	e9 63 06 00 00       	jmp    102aa6 <__alltraps>

00102443 <vector117>:
.globl vector117
vector117:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $117
  102445:	6a 75                	push   $0x75
  jmp __alltraps
  102447:	e9 5a 06 00 00       	jmp    102aa6 <__alltraps>

0010244c <vector118>:
.globl vector118
vector118:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $118
  10244e:	6a 76                	push   $0x76
  jmp __alltraps
  102450:	e9 51 06 00 00       	jmp    102aa6 <__alltraps>

00102455 <vector119>:
.globl vector119
vector119:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $119
  102457:	6a 77                	push   $0x77
  jmp __alltraps
  102459:	e9 48 06 00 00       	jmp    102aa6 <__alltraps>

0010245e <vector120>:
.globl vector120
vector120:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $120
  102460:	6a 78                	push   $0x78
  jmp __alltraps
  102462:	e9 3f 06 00 00       	jmp    102aa6 <__alltraps>

00102467 <vector121>:
.globl vector121
vector121:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $121
  102469:	6a 79                	push   $0x79
  jmp __alltraps
  10246b:	e9 36 06 00 00       	jmp    102aa6 <__alltraps>

00102470 <vector122>:
.globl vector122
vector122:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $122
  102472:	6a 7a                	push   $0x7a
  jmp __alltraps
  102474:	e9 2d 06 00 00       	jmp    102aa6 <__alltraps>

00102479 <vector123>:
.globl vector123
vector123:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $123
  10247b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10247d:	e9 24 06 00 00       	jmp    102aa6 <__alltraps>

00102482 <vector124>:
.globl vector124
vector124:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $124
  102484:	6a 7c                	push   $0x7c
  jmp __alltraps
  102486:	e9 1b 06 00 00       	jmp    102aa6 <__alltraps>

0010248b <vector125>:
.globl vector125
vector125:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $125
  10248d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10248f:	e9 12 06 00 00       	jmp    102aa6 <__alltraps>

00102494 <vector126>:
.globl vector126
vector126:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $126
  102496:	6a 7e                	push   $0x7e
  jmp __alltraps
  102498:	e9 09 06 00 00       	jmp    102aa6 <__alltraps>

0010249d <vector127>:
.globl vector127
vector127:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $127
  10249f:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024a1:	e9 00 06 00 00       	jmp    102aa6 <__alltraps>

001024a6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $128
  1024a8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024ad:	e9 f4 05 00 00       	jmp    102aa6 <__alltraps>

001024b2 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $129
  1024b4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024b9:	e9 e8 05 00 00       	jmp    102aa6 <__alltraps>

001024be <vector130>:
.globl vector130
vector130:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $130
  1024c0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024c5:	e9 dc 05 00 00       	jmp    102aa6 <__alltraps>

001024ca <vector131>:
.globl vector131
vector131:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $131
  1024cc:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024d1:	e9 d0 05 00 00       	jmp    102aa6 <__alltraps>

001024d6 <vector132>:
.globl vector132
vector132:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $132
  1024d8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024dd:	e9 c4 05 00 00       	jmp    102aa6 <__alltraps>

001024e2 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $133
  1024e4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024e9:	e9 b8 05 00 00       	jmp    102aa6 <__alltraps>

001024ee <vector134>:
.globl vector134
vector134:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $134
  1024f0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024f5:	e9 ac 05 00 00       	jmp    102aa6 <__alltraps>

001024fa <vector135>:
.globl vector135
vector135:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $135
  1024fc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102501:	e9 a0 05 00 00       	jmp    102aa6 <__alltraps>

00102506 <vector136>:
.globl vector136
vector136:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $136
  102508:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10250d:	e9 94 05 00 00       	jmp    102aa6 <__alltraps>

00102512 <vector137>:
.globl vector137
vector137:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $137
  102514:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102519:	e9 88 05 00 00       	jmp    102aa6 <__alltraps>

0010251e <vector138>:
.globl vector138
vector138:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $138
  102520:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102525:	e9 7c 05 00 00       	jmp    102aa6 <__alltraps>

0010252a <vector139>:
.globl vector139
vector139:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $139
  10252c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102531:	e9 70 05 00 00       	jmp    102aa6 <__alltraps>

00102536 <vector140>:
.globl vector140
vector140:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $140
  102538:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10253d:	e9 64 05 00 00       	jmp    102aa6 <__alltraps>

00102542 <vector141>:
.globl vector141
vector141:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $141
  102544:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102549:	e9 58 05 00 00       	jmp    102aa6 <__alltraps>

0010254e <vector142>:
.globl vector142
vector142:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $142
  102550:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102555:	e9 4c 05 00 00       	jmp    102aa6 <__alltraps>

0010255a <vector143>:
.globl vector143
vector143:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $143
  10255c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102561:	e9 40 05 00 00       	jmp    102aa6 <__alltraps>

00102566 <vector144>:
.globl vector144
vector144:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $144
  102568:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10256d:	e9 34 05 00 00       	jmp    102aa6 <__alltraps>

00102572 <vector145>:
.globl vector145
vector145:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $145
  102574:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102579:	e9 28 05 00 00       	jmp    102aa6 <__alltraps>

0010257e <vector146>:
.globl vector146
vector146:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $146
  102580:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102585:	e9 1c 05 00 00       	jmp    102aa6 <__alltraps>

0010258a <vector147>:
.globl vector147
vector147:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $147
  10258c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102591:	e9 10 05 00 00       	jmp    102aa6 <__alltraps>

00102596 <vector148>:
.globl vector148
vector148:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $148
  102598:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10259d:	e9 04 05 00 00       	jmp    102aa6 <__alltraps>

001025a2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $149
  1025a4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025a9:	e9 f8 04 00 00       	jmp    102aa6 <__alltraps>

001025ae <vector150>:
.globl vector150
vector150:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $150
  1025b0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025b5:	e9 ec 04 00 00       	jmp    102aa6 <__alltraps>

001025ba <vector151>:
.globl vector151
vector151:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $151
  1025bc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025c1:	e9 e0 04 00 00       	jmp    102aa6 <__alltraps>

001025c6 <vector152>:
.globl vector152
vector152:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $152
  1025c8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025cd:	e9 d4 04 00 00       	jmp    102aa6 <__alltraps>

001025d2 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $153
  1025d4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025d9:	e9 c8 04 00 00       	jmp    102aa6 <__alltraps>

001025de <vector154>:
.globl vector154
vector154:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $154
  1025e0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025e5:	e9 bc 04 00 00       	jmp    102aa6 <__alltraps>

001025ea <vector155>:
.globl vector155
vector155:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $155
  1025ec:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025f1:	e9 b0 04 00 00       	jmp    102aa6 <__alltraps>

001025f6 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $156
  1025f8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025fd:	e9 a4 04 00 00       	jmp    102aa6 <__alltraps>

00102602 <vector157>:
.globl vector157
vector157:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $157
  102604:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102609:	e9 98 04 00 00       	jmp    102aa6 <__alltraps>

0010260e <vector158>:
.globl vector158
vector158:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $158
  102610:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102615:	e9 8c 04 00 00       	jmp    102aa6 <__alltraps>

0010261a <vector159>:
.globl vector159
vector159:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $159
  10261c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102621:	e9 80 04 00 00       	jmp    102aa6 <__alltraps>

00102626 <vector160>:
.globl vector160
vector160:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $160
  102628:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10262d:	e9 74 04 00 00       	jmp    102aa6 <__alltraps>

00102632 <vector161>:
.globl vector161
vector161:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $161
  102634:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102639:	e9 68 04 00 00       	jmp    102aa6 <__alltraps>

0010263e <vector162>:
.globl vector162
vector162:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $162
  102640:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102645:	e9 5c 04 00 00       	jmp    102aa6 <__alltraps>

0010264a <vector163>:
.globl vector163
vector163:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $163
  10264c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102651:	e9 50 04 00 00       	jmp    102aa6 <__alltraps>

00102656 <vector164>:
.globl vector164
vector164:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $164
  102658:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10265d:	e9 44 04 00 00       	jmp    102aa6 <__alltraps>

00102662 <vector165>:
.globl vector165
vector165:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $165
  102664:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102669:	e9 38 04 00 00       	jmp    102aa6 <__alltraps>

0010266e <vector166>:
.globl vector166
vector166:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $166
  102670:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102675:	e9 2c 04 00 00       	jmp    102aa6 <__alltraps>

0010267a <vector167>:
.globl vector167
vector167:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $167
  10267c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102681:	e9 20 04 00 00       	jmp    102aa6 <__alltraps>

00102686 <vector168>:
.globl vector168
vector168:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $168
  102688:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10268d:	e9 14 04 00 00       	jmp    102aa6 <__alltraps>

00102692 <vector169>:
.globl vector169
vector169:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $169
  102694:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102699:	e9 08 04 00 00       	jmp    102aa6 <__alltraps>

0010269e <vector170>:
.globl vector170
vector170:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $170
  1026a0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026a5:	e9 fc 03 00 00       	jmp    102aa6 <__alltraps>

001026aa <vector171>:
.globl vector171
vector171:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $171
  1026ac:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026b1:	e9 f0 03 00 00       	jmp    102aa6 <__alltraps>

001026b6 <vector172>:
.globl vector172
vector172:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $172
  1026b8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026bd:	e9 e4 03 00 00       	jmp    102aa6 <__alltraps>

001026c2 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $173
  1026c4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026c9:	e9 d8 03 00 00       	jmp    102aa6 <__alltraps>

001026ce <vector174>:
.globl vector174
vector174:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $174
  1026d0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026d5:	e9 cc 03 00 00       	jmp    102aa6 <__alltraps>

001026da <vector175>:
.globl vector175
vector175:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $175
  1026dc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026e1:	e9 c0 03 00 00       	jmp    102aa6 <__alltraps>

001026e6 <vector176>:
.globl vector176
vector176:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $176
  1026e8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026ed:	e9 b4 03 00 00       	jmp    102aa6 <__alltraps>

001026f2 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $177
  1026f4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026f9:	e9 a8 03 00 00       	jmp    102aa6 <__alltraps>

001026fe <vector178>:
.globl vector178
vector178:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $178
  102700:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102705:	e9 9c 03 00 00       	jmp    102aa6 <__alltraps>

0010270a <vector179>:
.globl vector179
vector179:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $179
  10270c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102711:	e9 90 03 00 00       	jmp    102aa6 <__alltraps>

00102716 <vector180>:
.globl vector180
vector180:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $180
  102718:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10271d:	e9 84 03 00 00       	jmp    102aa6 <__alltraps>

00102722 <vector181>:
.globl vector181
vector181:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $181
  102724:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102729:	e9 78 03 00 00       	jmp    102aa6 <__alltraps>

0010272e <vector182>:
.globl vector182
vector182:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $182
  102730:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102735:	e9 6c 03 00 00       	jmp    102aa6 <__alltraps>

0010273a <vector183>:
.globl vector183
vector183:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $183
  10273c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102741:	e9 60 03 00 00       	jmp    102aa6 <__alltraps>

00102746 <vector184>:
.globl vector184
vector184:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $184
  102748:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10274d:	e9 54 03 00 00       	jmp    102aa6 <__alltraps>

00102752 <vector185>:
.globl vector185
vector185:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $185
  102754:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102759:	e9 48 03 00 00       	jmp    102aa6 <__alltraps>

0010275e <vector186>:
.globl vector186
vector186:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $186
  102760:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102765:	e9 3c 03 00 00       	jmp    102aa6 <__alltraps>

0010276a <vector187>:
.globl vector187
vector187:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $187
  10276c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102771:	e9 30 03 00 00       	jmp    102aa6 <__alltraps>

00102776 <vector188>:
.globl vector188
vector188:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $188
  102778:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10277d:	e9 24 03 00 00       	jmp    102aa6 <__alltraps>

00102782 <vector189>:
.globl vector189
vector189:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $189
  102784:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102789:	e9 18 03 00 00       	jmp    102aa6 <__alltraps>

0010278e <vector190>:
.globl vector190
vector190:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $190
  102790:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102795:	e9 0c 03 00 00       	jmp    102aa6 <__alltraps>

0010279a <vector191>:
.globl vector191
vector191:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $191
  10279c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027a1:	e9 00 03 00 00       	jmp    102aa6 <__alltraps>

001027a6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $192
  1027a8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027ad:	e9 f4 02 00 00       	jmp    102aa6 <__alltraps>

001027b2 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $193
  1027b4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027b9:	e9 e8 02 00 00       	jmp    102aa6 <__alltraps>

001027be <vector194>:
.globl vector194
vector194:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $194
  1027c0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027c5:	e9 dc 02 00 00       	jmp    102aa6 <__alltraps>

001027ca <vector195>:
.globl vector195
vector195:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $195
  1027cc:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027d1:	e9 d0 02 00 00       	jmp    102aa6 <__alltraps>

001027d6 <vector196>:
.globl vector196
vector196:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $196
  1027d8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027dd:	e9 c4 02 00 00       	jmp    102aa6 <__alltraps>

001027e2 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $197
  1027e4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027e9:	e9 b8 02 00 00       	jmp    102aa6 <__alltraps>

001027ee <vector198>:
.globl vector198
vector198:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $198
  1027f0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027f5:	e9 ac 02 00 00       	jmp    102aa6 <__alltraps>

001027fa <vector199>:
.globl vector199
vector199:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $199
  1027fc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102801:	e9 a0 02 00 00       	jmp    102aa6 <__alltraps>

00102806 <vector200>:
.globl vector200
vector200:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $200
  102808:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10280d:	e9 94 02 00 00       	jmp    102aa6 <__alltraps>

00102812 <vector201>:
.globl vector201
vector201:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $201
  102814:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102819:	e9 88 02 00 00       	jmp    102aa6 <__alltraps>

0010281e <vector202>:
.globl vector202
vector202:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $202
  102820:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102825:	e9 7c 02 00 00       	jmp    102aa6 <__alltraps>

0010282a <vector203>:
.globl vector203
vector203:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $203
  10282c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102831:	e9 70 02 00 00       	jmp    102aa6 <__alltraps>

00102836 <vector204>:
.globl vector204
vector204:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $204
  102838:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10283d:	e9 64 02 00 00       	jmp    102aa6 <__alltraps>

00102842 <vector205>:
.globl vector205
vector205:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $205
  102844:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102849:	e9 58 02 00 00       	jmp    102aa6 <__alltraps>

0010284e <vector206>:
.globl vector206
vector206:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $206
  102850:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102855:	e9 4c 02 00 00       	jmp    102aa6 <__alltraps>

0010285a <vector207>:
.globl vector207
vector207:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $207
  10285c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102861:	e9 40 02 00 00       	jmp    102aa6 <__alltraps>

00102866 <vector208>:
.globl vector208
vector208:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $208
  102868:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10286d:	e9 34 02 00 00       	jmp    102aa6 <__alltraps>

00102872 <vector209>:
.globl vector209
vector209:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $209
  102874:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102879:	e9 28 02 00 00       	jmp    102aa6 <__alltraps>

0010287e <vector210>:
.globl vector210
vector210:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $210
  102880:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102885:	e9 1c 02 00 00       	jmp    102aa6 <__alltraps>

0010288a <vector211>:
.globl vector211
vector211:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $211
  10288c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102891:	e9 10 02 00 00       	jmp    102aa6 <__alltraps>

00102896 <vector212>:
.globl vector212
vector212:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $212
  102898:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10289d:	e9 04 02 00 00       	jmp    102aa6 <__alltraps>

001028a2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $213
  1028a4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028a9:	e9 f8 01 00 00       	jmp    102aa6 <__alltraps>

001028ae <vector214>:
.globl vector214
vector214:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $214
  1028b0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028b5:	e9 ec 01 00 00       	jmp    102aa6 <__alltraps>

001028ba <vector215>:
.globl vector215
vector215:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $215
  1028bc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028c1:	e9 e0 01 00 00       	jmp    102aa6 <__alltraps>

001028c6 <vector216>:
.globl vector216
vector216:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $216
  1028c8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028cd:	e9 d4 01 00 00       	jmp    102aa6 <__alltraps>

001028d2 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $217
  1028d4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028d9:	e9 c8 01 00 00       	jmp    102aa6 <__alltraps>

001028de <vector218>:
.globl vector218
vector218:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $218
  1028e0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028e5:	e9 bc 01 00 00       	jmp    102aa6 <__alltraps>

001028ea <vector219>:
.globl vector219
vector219:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $219
  1028ec:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028f1:	e9 b0 01 00 00       	jmp    102aa6 <__alltraps>

001028f6 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $220
  1028f8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028fd:	e9 a4 01 00 00       	jmp    102aa6 <__alltraps>

00102902 <vector221>:
.globl vector221
vector221:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $221
  102904:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102909:	e9 98 01 00 00       	jmp    102aa6 <__alltraps>

0010290e <vector222>:
.globl vector222
vector222:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $222
  102910:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102915:	e9 8c 01 00 00       	jmp    102aa6 <__alltraps>

0010291a <vector223>:
.globl vector223
vector223:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $223
  10291c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102921:	e9 80 01 00 00       	jmp    102aa6 <__alltraps>

00102926 <vector224>:
.globl vector224
vector224:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $224
  102928:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10292d:	e9 74 01 00 00       	jmp    102aa6 <__alltraps>

00102932 <vector225>:
.globl vector225
vector225:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $225
  102934:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102939:	e9 68 01 00 00       	jmp    102aa6 <__alltraps>

0010293e <vector226>:
.globl vector226
vector226:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $226
  102940:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102945:	e9 5c 01 00 00       	jmp    102aa6 <__alltraps>

0010294a <vector227>:
.globl vector227
vector227:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $227
  10294c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102951:	e9 50 01 00 00       	jmp    102aa6 <__alltraps>

00102956 <vector228>:
.globl vector228
vector228:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $228
  102958:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10295d:	e9 44 01 00 00       	jmp    102aa6 <__alltraps>

00102962 <vector229>:
.globl vector229
vector229:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $229
  102964:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102969:	e9 38 01 00 00       	jmp    102aa6 <__alltraps>

0010296e <vector230>:
.globl vector230
vector230:
  pushl $0
  10296e:	6a 00                	push   $0x0
  pushl $230
  102970:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102975:	e9 2c 01 00 00       	jmp    102aa6 <__alltraps>

0010297a <vector231>:
.globl vector231
vector231:
  pushl $0
  10297a:	6a 00                	push   $0x0
  pushl $231
  10297c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102981:	e9 20 01 00 00       	jmp    102aa6 <__alltraps>

00102986 <vector232>:
.globl vector232
vector232:
  pushl $0
  102986:	6a 00                	push   $0x0
  pushl $232
  102988:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10298d:	e9 14 01 00 00       	jmp    102aa6 <__alltraps>

00102992 <vector233>:
.globl vector233
vector233:
  pushl $0
  102992:	6a 00                	push   $0x0
  pushl $233
  102994:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102999:	e9 08 01 00 00       	jmp    102aa6 <__alltraps>

0010299e <vector234>:
.globl vector234
vector234:
  pushl $0
  10299e:	6a 00                	push   $0x0
  pushl $234
  1029a0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029a5:	e9 fc 00 00 00       	jmp    102aa6 <__alltraps>

001029aa <vector235>:
.globl vector235
vector235:
  pushl $0
  1029aa:	6a 00                	push   $0x0
  pushl $235
  1029ac:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029b1:	e9 f0 00 00 00       	jmp    102aa6 <__alltraps>

001029b6 <vector236>:
.globl vector236
vector236:
  pushl $0
  1029b6:	6a 00                	push   $0x0
  pushl $236
  1029b8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029bd:	e9 e4 00 00 00       	jmp    102aa6 <__alltraps>

001029c2 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029c2:	6a 00                	push   $0x0
  pushl $237
  1029c4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029c9:	e9 d8 00 00 00       	jmp    102aa6 <__alltraps>

001029ce <vector238>:
.globl vector238
vector238:
  pushl $0
  1029ce:	6a 00                	push   $0x0
  pushl $238
  1029d0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029d5:	e9 cc 00 00 00       	jmp    102aa6 <__alltraps>

001029da <vector239>:
.globl vector239
vector239:
  pushl $0
  1029da:	6a 00                	push   $0x0
  pushl $239
  1029dc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029e1:	e9 c0 00 00 00       	jmp    102aa6 <__alltraps>

001029e6 <vector240>:
.globl vector240
vector240:
  pushl $0
  1029e6:	6a 00                	push   $0x0
  pushl $240
  1029e8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029ed:	e9 b4 00 00 00       	jmp    102aa6 <__alltraps>

001029f2 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029f2:	6a 00                	push   $0x0
  pushl $241
  1029f4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029f9:	e9 a8 00 00 00       	jmp    102aa6 <__alltraps>

001029fe <vector242>:
.globl vector242
vector242:
  pushl $0
  1029fe:	6a 00                	push   $0x0
  pushl $242
  102a00:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a05:	e9 9c 00 00 00       	jmp    102aa6 <__alltraps>

00102a0a <vector243>:
.globl vector243
vector243:
  pushl $0
  102a0a:	6a 00                	push   $0x0
  pushl $243
  102a0c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a11:	e9 90 00 00 00       	jmp    102aa6 <__alltraps>

00102a16 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a16:	6a 00                	push   $0x0
  pushl $244
  102a18:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a1d:	e9 84 00 00 00       	jmp    102aa6 <__alltraps>

00102a22 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a22:	6a 00                	push   $0x0
  pushl $245
  102a24:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a29:	e9 78 00 00 00       	jmp    102aa6 <__alltraps>

00102a2e <vector246>:
.globl vector246
vector246:
  pushl $0
  102a2e:	6a 00                	push   $0x0
  pushl $246
  102a30:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a35:	e9 6c 00 00 00       	jmp    102aa6 <__alltraps>

00102a3a <vector247>:
.globl vector247
vector247:
  pushl $0
  102a3a:	6a 00                	push   $0x0
  pushl $247
  102a3c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a41:	e9 60 00 00 00       	jmp    102aa6 <__alltraps>

00102a46 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a46:	6a 00                	push   $0x0
  pushl $248
  102a48:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a4d:	e9 54 00 00 00       	jmp    102aa6 <__alltraps>

00102a52 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a52:	6a 00                	push   $0x0
  pushl $249
  102a54:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a59:	e9 48 00 00 00       	jmp    102aa6 <__alltraps>

00102a5e <vector250>:
.globl vector250
vector250:
  pushl $0
  102a5e:	6a 00                	push   $0x0
  pushl $250
  102a60:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a65:	e9 3c 00 00 00       	jmp    102aa6 <__alltraps>

00102a6a <vector251>:
.globl vector251
vector251:
  pushl $0
  102a6a:	6a 00                	push   $0x0
  pushl $251
  102a6c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a71:	e9 30 00 00 00       	jmp    102aa6 <__alltraps>

00102a76 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a76:	6a 00                	push   $0x0
  pushl $252
  102a78:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a7d:	e9 24 00 00 00       	jmp    102aa6 <__alltraps>

00102a82 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a82:	6a 00                	push   $0x0
  pushl $253
  102a84:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a89:	e9 18 00 00 00       	jmp    102aa6 <__alltraps>

00102a8e <vector254>:
.globl vector254
vector254:
  pushl $0
  102a8e:	6a 00                	push   $0x0
  pushl $254
  102a90:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a95:	e9 0c 00 00 00       	jmp    102aa6 <__alltraps>

00102a9a <vector255>:
.globl vector255
vector255:
  pushl $0
  102a9a:	6a 00                	push   $0x0
  pushl $255
  102a9c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102aa1:	e9 00 00 00 00       	jmp    102aa6 <__alltraps>

00102aa6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102aa6:	1e                   	push   %ds
    pushl %es
  102aa7:	06                   	push   %es
    pushl %fs
  102aa8:	0f a0                	push   %fs
    pushl %gs
  102aaa:	0f a8                	push   %gs
    pushal
  102aac:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102aad:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102ab2:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102ab4:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102ab6:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102ab7:	e8 63 f5 ff ff       	call   10201f <trap>

    # pop the pushed stack pointer
    popl %esp
  102abc:	5c                   	pop    %esp

00102abd <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102abd:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102abe:	0f a9                	pop    %gs
    popl %fs
  102ac0:	0f a1                	pop    %fs
    popl %es
  102ac2:	07                   	pop    %es
    popl %ds
  102ac3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ac4:	83 c4 08             	add    $0x8,%esp
    iret
  102ac7:	cf                   	iret   

00102ac8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102ac8:	55                   	push   %ebp
  102ac9:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102acb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ace:	8b 15 58 99 11 00    	mov    0x119958,%edx
  102ad4:	29 d0                	sub    %edx,%eax
  102ad6:	c1 f8 02             	sar    $0x2,%eax
  102ad9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102adf:	5d                   	pop    %ebp
  102ae0:	c3                   	ret    

00102ae1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102ae1:	55                   	push   %ebp
  102ae2:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  102ae4:	ff 75 08             	pushl  0x8(%ebp)
  102ae7:	e8 dc ff ff ff       	call   102ac8 <page2ppn>
  102aec:	83 c4 04             	add    $0x4,%esp
  102aef:	c1 e0 0c             	shl    $0xc,%eax
}
  102af2:	c9                   	leave  
  102af3:	c3                   	ret    

00102af4 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102af4:	55                   	push   %ebp
  102af5:	89 e5                	mov    %esp,%ebp
  102af7:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  102afd:	c1 e8 0c             	shr    $0xc,%eax
  102b00:	89 c2                	mov    %eax,%edx
  102b02:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  102b07:	39 c2                	cmp    %eax,%edx
  102b09:	72 14                	jb     102b1f <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  102b0b:	83 ec 04             	sub    $0x4,%esp
  102b0e:	68 70 64 10 00       	push   $0x106470
  102b13:	6a 5a                	push   $0x5a
  102b15:	68 8f 64 10 00       	push   $0x10648f
  102b1a:	e8 be d8 ff ff       	call   1003dd <__panic>
    }
    return &pages[PPN(pa)];
  102b1f:	8b 0d 58 99 11 00    	mov    0x119958,%ecx
  102b25:	8b 45 08             	mov    0x8(%ebp),%eax
  102b28:	c1 e8 0c             	shr    $0xc,%eax
  102b2b:	89 c2                	mov    %eax,%edx
  102b2d:	89 d0                	mov    %edx,%eax
  102b2f:	c1 e0 02             	shl    $0x2,%eax
  102b32:	01 d0                	add    %edx,%eax
  102b34:	c1 e0 02             	shl    $0x2,%eax
  102b37:	01 c8                	add    %ecx,%eax
}
  102b39:	c9                   	leave  
  102b3a:	c3                   	ret    

00102b3b <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102b3b:	55                   	push   %ebp
  102b3c:	89 e5                	mov    %esp,%ebp
  102b3e:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  102b41:	ff 75 08             	pushl  0x8(%ebp)
  102b44:	e8 98 ff ff ff       	call   102ae1 <page2pa>
  102b49:	83 c4 04             	add    $0x4,%esp
  102b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b52:	c1 e8 0c             	shr    $0xc,%eax
  102b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b58:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  102b5d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102b60:	72 14                	jb     102b76 <page2kva+0x3b>
  102b62:	ff 75 f4             	pushl  -0xc(%ebp)
  102b65:	68 a0 64 10 00       	push   $0x1064a0
  102b6a:	6a 61                	push   $0x61
  102b6c:	68 8f 64 10 00       	push   $0x10648f
  102b71:	e8 67 d8 ff ff       	call   1003dd <__panic>
  102b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b79:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102b7e:	c9                   	leave  
  102b7f:	c3                   	ret    

00102b80 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102b80:	55                   	push   %ebp
  102b81:	89 e5                	mov    %esp,%ebp
  102b83:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102b86:	8b 45 08             	mov    0x8(%ebp),%eax
  102b89:	83 e0 01             	and    $0x1,%eax
  102b8c:	85 c0                	test   %eax,%eax
  102b8e:	75 14                	jne    102ba4 <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102b90:	83 ec 04             	sub    $0x4,%esp
  102b93:	68 c4 64 10 00       	push   $0x1064c4
  102b98:	6a 6c                	push   $0x6c
  102b9a:	68 8f 64 10 00       	push   $0x10648f
  102b9f:	e8 39 d8 ff ff       	call   1003dd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102bac:	83 ec 0c             	sub    $0xc,%esp
  102baf:	50                   	push   %eax
  102bb0:	e8 3f ff ff ff       	call   102af4 <pa2page>
  102bb5:	83 c4 10             	add    $0x10,%esp
}
  102bb8:	c9                   	leave  
  102bb9:	c3                   	ret    

00102bba <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102bba:	55                   	push   %ebp
  102bbb:	89 e5                	mov    %esp,%ebp
  102bbd:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102bc8:	83 ec 0c             	sub    $0xc,%esp
  102bcb:	50                   	push   %eax
  102bcc:	e8 23 ff ff ff       	call   102af4 <pa2page>
  102bd1:	83 c4 10             	add    $0x10,%esp
}
  102bd4:	c9                   	leave  
  102bd5:	c3                   	ret    

00102bd6 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102bd6:	55                   	push   %ebp
  102bd7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdc:	8b 00                	mov    (%eax),%eax
}
  102bde:	5d                   	pop    %ebp
  102bdf:	c3                   	ret    

00102be0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102be0:	55                   	push   %ebp
  102be1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102be3:	8b 45 08             	mov    0x8(%ebp),%eax
  102be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102be9:	89 10                	mov    %edx,(%eax)
}
  102beb:	90                   	nop
  102bec:	5d                   	pop    %ebp
  102bed:	c3                   	ret    

00102bee <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102bee:	55                   	push   %ebp
  102bef:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf4:	8b 00                	mov    (%eax),%eax
  102bf6:	8d 50 01             	lea    0x1(%eax),%edx
  102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfc:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	8b 00                	mov    (%eax),%eax
}
  102c03:	5d                   	pop    %ebp
  102c04:	c3                   	ret    

00102c05 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102c05:	55                   	push   %ebp
  102c06:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102c08:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0b:	8b 00                	mov    (%eax),%eax
  102c0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c10:	8b 45 08             	mov    0x8(%ebp),%eax
  102c13:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102c15:	8b 45 08             	mov    0x8(%ebp),%eax
  102c18:	8b 00                	mov    (%eax),%eax
}
  102c1a:	5d                   	pop    %ebp
  102c1b:	c3                   	ret    

00102c1c <__intr_save>:
__intr_save(void) {
  102c1c:	55                   	push   %ebp
  102c1d:	89 e5                	mov    %esp,%ebp
  102c1f:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102c22:	9c                   	pushf  
  102c23:	58                   	pop    %eax
  102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102c2a:	25 00 02 00 00       	and    $0x200,%eax
  102c2f:	85 c0                	test   %eax,%eax
  102c31:	74 0c                	je     102c3f <__intr_save+0x23>
        intr_disable();
  102c33:	e8 4f ec ff ff       	call   101887 <intr_disable>
        return 1;
  102c38:	b8 01 00 00 00       	mov    $0x1,%eax
  102c3d:	eb 05                	jmp    102c44 <__intr_save+0x28>
    return 0;
  102c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c44:	c9                   	leave  
  102c45:	c3                   	ret    

00102c46 <__intr_restore>:
__intr_restore(bool flag) {
  102c46:	55                   	push   %ebp
  102c47:	89 e5                	mov    %esp,%ebp
  102c49:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102c50:	74 05                	je     102c57 <__intr_restore+0x11>
        intr_enable();
  102c52:	e8 29 ec ff ff       	call   101880 <intr_enable>
}
  102c57:	90                   	nop
  102c58:	c9                   	leave  
  102c59:	c3                   	ret    

00102c5a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102c5a:	55                   	push   %ebp
  102c5b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c60:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102c63:	b8 23 00 00 00       	mov    $0x23,%eax
  102c68:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102c6a:	b8 23 00 00 00       	mov    $0x23,%eax
  102c6f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102c71:	b8 10 00 00 00       	mov    $0x10,%eax
  102c76:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c78:	b8 10 00 00 00       	mov    $0x10,%eax
  102c7d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c7f:	b8 10 00 00 00       	mov    $0x10,%eax
  102c84:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102c86:	ea 8d 2c 10 00 08 00 	ljmp   $0x8,$0x102c8d
}
  102c8d:	90                   	nop
  102c8e:	5d                   	pop    %ebp
  102c8f:	c3                   	ret    

00102c90 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102c90:	55                   	push   %ebp
  102c91:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102c93:	8b 45 08             	mov    0x8(%ebp),%eax
  102c96:	a3 e4 98 11 00       	mov    %eax,0x1198e4
}
  102c9b:	90                   	nop
  102c9c:	5d                   	pop    %ebp
  102c9d:	c3                   	ret    

00102c9e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102c9e:	55                   	push   %ebp
  102c9f:	89 e5                	mov    %esp,%ebp
  102ca1:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102ca4:	b8 00 80 11 00       	mov    $0x118000,%eax
  102ca9:	50                   	push   %eax
  102caa:	e8 e1 ff ff ff       	call   102c90 <load_esp0>
  102caf:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102cb2:	66 c7 05 e8 98 11 00 	movw   $0x10,0x1198e8
  102cb9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102cbb:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  102cc2:	68 00 
  102cc4:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  102cc9:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  102ccf:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  102cd4:	c1 e8 10             	shr    $0x10,%eax
  102cd7:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  102cdc:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102ce3:	83 e0 f0             	and    $0xfffffff0,%eax
  102ce6:	83 c8 09             	or     $0x9,%eax
  102ce9:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102cee:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102cf5:	83 e0 ef             	and    $0xffffffef,%eax
  102cf8:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102cfd:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102d04:	83 e0 9f             	and    $0xffffff9f,%eax
  102d07:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102d0c:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  102d13:	83 c8 80             	or     $0xffffff80,%eax
  102d16:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  102d1b:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102d22:	83 e0 f0             	and    $0xfffffff0,%eax
  102d25:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102d2a:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102d31:	83 e0 ef             	and    $0xffffffef,%eax
  102d34:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102d39:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102d40:	83 e0 df             	and    $0xffffffdf,%eax
  102d43:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102d48:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102d4f:	83 c8 40             	or     $0x40,%eax
  102d52:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102d57:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  102d5e:	83 e0 7f             	and    $0x7f,%eax
  102d61:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  102d66:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  102d6b:	c1 e8 18             	shr    $0x18,%eax
  102d6e:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102d73:	68 30 8a 11 00       	push   $0x118a30
  102d78:	e8 dd fe ff ff       	call   102c5a <lgdt>
  102d7d:	83 c4 04             	add    $0x4,%esp
  102d80:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102d86:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102d8a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102d8d:	90                   	nop
  102d8e:	c9                   	leave  
  102d8f:	c3                   	ret    

00102d90 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102d90:	55                   	push   %ebp
  102d91:	89 e5                	mov    %esp,%ebp
  102d93:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102d96:	c7 05 50 99 11 00 38 	movl   $0x106e38,0x119950
  102d9d:	6e 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102da0:	a1 50 99 11 00       	mov    0x119950,%eax
  102da5:	8b 00                	mov    (%eax),%eax
  102da7:	83 ec 08             	sub    $0x8,%esp
  102daa:	50                   	push   %eax
  102dab:	68 f0 64 10 00       	push   $0x1064f0
  102db0:	e8 c2 d4 ff ff       	call   100277 <cprintf>
  102db5:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102db8:	a1 50 99 11 00       	mov    0x119950,%eax
  102dbd:	8b 40 04             	mov    0x4(%eax),%eax
  102dc0:	ff d0                	call   *%eax
}
  102dc2:	90                   	nop
  102dc3:	c9                   	leave  
  102dc4:	c3                   	ret    

00102dc5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102dc5:	55                   	push   %ebp
  102dc6:	89 e5                	mov    %esp,%ebp
  102dc8:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102dcb:	a1 50 99 11 00       	mov    0x119950,%eax
  102dd0:	8b 40 08             	mov    0x8(%eax),%eax
  102dd3:	83 ec 08             	sub    $0x8,%esp
  102dd6:	ff 75 0c             	pushl  0xc(%ebp)
  102dd9:	ff 75 08             	pushl  0x8(%ebp)
  102ddc:	ff d0                	call   *%eax
  102dde:	83 c4 10             	add    $0x10,%esp
}
  102de1:	90                   	nop
  102de2:	c9                   	leave  
  102de3:	c3                   	ret    

00102de4 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102de4:	55                   	push   %ebp
  102de5:	89 e5                	mov    %esp,%ebp
  102de7:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102dea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102df1:	e8 26 fe ff ff       	call   102c1c <__intr_save>
  102df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102df9:	a1 50 99 11 00       	mov    0x119950,%eax
  102dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  102e01:	83 ec 0c             	sub    $0xc,%esp
  102e04:	ff 75 08             	pushl  0x8(%ebp)
  102e07:	ff d0                	call   *%eax
  102e09:	83 c4 10             	add    $0x10,%esp
  102e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102e0f:	83 ec 0c             	sub    $0xc,%esp
  102e12:	ff 75 f0             	pushl  -0x10(%ebp)
  102e15:	e8 2c fe ff ff       	call   102c46 <__intr_restore>
  102e1a:	83 c4 10             	add    $0x10,%esp
    return page;
  102e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e20:	c9                   	leave  
  102e21:	c3                   	ret    

00102e22 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102e22:	55                   	push   %ebp
  102e23:	89 e5                	mov    %esp,%ebp
  102e25:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102e28:	e8 ef fd ff ff       	call   102c1c <__intr_save>
  102e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102e30:	a1 50 99 11 00       	mov    0x119950,%eax
  102e35:	8b 40 10             	mov    0x10(%eax),%eax
  102e38:	83 ec 08             	sub    $0x8,%esp
  102e3b:	ff 75 0c             	pushl  0xc(%ebp)
  102e3e:	ff 75 08             	pushl  0x8(%ebp)
  102e41:	ff d0                	call   *%eax
  102e43:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102e46:	83 ec 0c             	sub    $0xc,%esp
  102e49:	ff 75 f4             	pushl  -0xc(%ebp)
  102e4c:	e8 f5 fd ff ff       	call   102c46 <__intr_restore>
  102e51:	83 c4 10             	add    $0x10,%esp
}
  102e54:	90                   	nop
  102e55:	c9                   	leave  
  102e56:	c3                   	ret    

00102e57 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102e57:	55                   	push   %ebp
  102e58:	89 e5                	mov    %esp,%ebp
  102e5a:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102e5d:	e8 ba fd ff ff       	call   102c1c <__intr_save>
  102e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102e65:	a1 50 99 11 00       	mov    0x119950,%eax
  102e6a:	8b 40 14             	mov    0x14(%eax),%eax
  102e6d:	ff d0                	call   *%eax
  102e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102e72:	83 ec 0c             	sub    $0xc,%esp
  102e75:	ff 75 f4             	pushl  -0xc(%ebp)
  102e78:	e8 c9 fd ff ff       	call   102c46 <__intr_restore>
  102e7d:	83 c4 10             	add    $0x10,%esp
    return ret;
  102e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102e83:	c9                   	leave  
  102e84:	c3                   	ret    

00102e85 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102e85:	55                   	push   %ebp
  102e86:	89 e5                	mov    %esp,%ebp
  102e88:	57                   	push   %edi
  102e89:	56                   	push   %esi
  102e8a:	53                   	push   %ebx
  102e8b:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102e8e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102e95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102e9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102ea3:	83 ec 0c             	sub    $0xc,%esp
  102ea6:	68 07 65 10 00       	push   $0x106507
  102eab:	e8 c7 d3 ff ff       	call   100277 <cprintf>
  102eb0:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102eb3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102eba:	e9 fc 00 00 00       	jmp    102fbb <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102ebf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ec5:	89 d0                	mov    %edx,%eax
  102ec7:	c1 e0 02             	shl    $0x2,%eax
  102eca:	01 d0                	add    %edx,%eax
  102ecc:	c1 e0 02             	shl    $0x2,%eax
  102ecf:	01 c8                	add    %ecx,%eax
  102ed1:	8b 50 08             	mov    0x8(%eax),%edx
  102ed4:	8b 40 04             	mov    0x4(%eax),%eax
  102ed7:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102eda:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102edd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ee0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ee3:	89 d0                	mov    %edx,%eax
  102ee5:	c1 e0 02             	shl    $0x2,%eax
  102ee8:	01 d0                	add    %edx,%eax
  102eea:	c1 e0 02             	shl    $0x2,%eax
  102eed:	01 c8                	add    %ecx,%eax
  102eef:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ef2:	8b 58 10             	mov    0x10(%eax),%ebx
  102ef5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ef8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102efb:	01 c8                	add    %ecx,%eax
  102efd:	11 da                	adc    %ebx,%edx
  102eff:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f02:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102f05:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f0b:	89 d0                	mov    %edx,%eax
  102f0d:	c1 e0 02             	shl    $0x2,%eax
  102f10:	01 d0                	add    %edx,%eax
  102f12:	c1 e0 02             	shl    $0x2,%eax
  102f15:	01 c8                	add    %ecx,%eax
  102f17:	83 c0 14             	add    $0x14,%eax
  102f1a:	8b 00                	mov    (%eax),%eax
  102f1c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102f1f:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f22:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102f25:	83 c0 ff             	add    $0xffffffff,%eax
  102f28:	83 d2 ff             	adc    $0xffffffff,%edx
  102f2b:	89 c1                	mov    %eax,%ecx
  102f2d:	89 d3                	mov    %edx,%ebx
  102f2f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102f32:	89 55 80             	mov    %edx,-0x80(%ebp)
  102f35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f38:	89 d0                	mov    %edx,%eax
  102f3a:	c1 e0 02             	shl    $0x2,%eax
  102f3d:	01 d0                	add    %edx,%eax
  102f3f:	c1 e0 02             	shl    $0x2,%eax
  102f42:	03 45 80             	add    -0x80(%ebp),%eax
  102f45:	8b 50 10             	mov    0x10(%eax),%edx
  102f48:	8b 40 0c             	mov    0xc(%eax),%eax
  102f4b:	ff 75 84             	pushl  -0x7c(%ebp)
  102f4e:	53                   	push   %ebx
  102f4f:	51                   	push   %ecx
  102f50:	ff 75 a4             	pushl  -0x5c(%ebp)
  102f53:	ff 75 a0             	pushl  -0x60(%ebp)
  102f56:	52                   	push   %edx
  102f57:	50                   	push   %eax
  102f58:	68 14 65 10 00       	push   $0x106514
  102f5d:	e8 15 d3 ff ff       	call   100277 <cprintf>
  102f62:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102f65:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f6b:	89 d0                	mov    %edx,%eax
  102f6d:	c1 e0 02             	shl    $0x2,%eax
  102f70:	01 d0                	add    %edx,%eax
  102f72:	c1 e0 02             	shl    $0x2,%eax
  102f75:	01 c8                	add    %ecx,%eax
  102f77:	83 c0 14             	add    $0x14,%eax
  102f7a:	8b 00                	mov    (%eax),%eax
  102f7c:	83 f8 01             	cmp    $0x1,%eax
  102f7f:	75 36                	jne    102fb7 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f87:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102f8a:	77 2b                	ja     102fb7 <page_init+0x132>
  102f8c:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102f8f:	72 05                	jb     102f96 <page_init+0x111>
  102f91:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102f94:	73 21                	jae    102fb7 <page_init+0x132>
  102f96:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102f9a:	77 1b                	ja     102fb7 <page_init+0x132>
  102f9c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102fa0:	72 09                	jb     102fab <page_init+0x126>
  102fa2:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  102fa9:	77 0c                	ja     102fb7 <page_init+0x132>
                maxpa = end;
  102fab:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fae:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102fb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102fb7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102fbb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fbe:	8b 00                	mov    (%eax),%eax
  102fc0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fc3:	0f 8c f6 fe ff ff    	jl     102ebf <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102fc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102fcd:	72 1d                	jb     102fec <page_init+0x167>
  102fcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102fd3:	77 09                	ja     102fde <page_init+0x159>
  102fd5:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102fdc:	76 0e                	jbe    102fec <page_init+0x167>
        maxpa = KMEMSIZE;
  102fde:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ff2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ff6:	c1 ea 0c             	shr    $0xc,%edx
  102ff9:	89 c1                	mov    %eax,%ecx
  102ffb:	89 d3                	mov    %edx,%ebx
  102ffd:	89 c8                	mov    %ecx,%eax
  102fff:	a3 c0 98 11 00       	mov    %eax,0x1198c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103004:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  10300b:	b8 68 99 11 00       	mov    $0x119968,%eax
  103010:	8d 50 ff             	lea    -0x1(%eax),%edx
  103013:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103016:	01 d0                	add    %edx,%eax
  103018:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10301b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10301e:	ba 00 00 00 00       	mov    $0x0,%edx
  103023:	f7 75 c0             	divl   -0x40(%ebp)
  103026:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103029:	29 d0                	sub    %edx,%eax
  10302b:	a3 58 99 11 00       	mov    %eax,0x119958

    for (i = 0; i < npage; i ++) {
  103030:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103037:	eb 2f                	jmp    103068 <page_init+0x1e3>
        SetPageReserved(pages + i);
  103039:	8b 0d 58 99 11 00    	mov    0x119958,%ecx
  10303f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103042:	89 d0                	mov    %edx,%eax
  103044:	c1 e0 02             	shl    $0x2,%eax
  103047:	01 d0                	add    %edx,%eax
  103049:	c1 e0 02             	shl    $0x2,%eax
  10304c:	01 c8                	add    %ecx,%eax
  10304e:	83 c0 04             	add    $0x4,%eax
  103051:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103058:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10305b:	8b 45 90             	mov    -0x70(%ebp),%eax
  10305e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103061:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  103064:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103068:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10306b:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103070:	39 c2                	cmp    %eax,%edx
  103072:	72 c5                	jb     103039 <page_init+0x1b4>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103074:	8b 15 c0 98 11 00    	mov    0x1198c0,%edx
  10307a:	89 d0                	mov    %edx,%eax
  10307c:	c1 e0 02             	shl    $0x2,%eax
  10307f:	01 d0                	add    %edx,%eax
  103081:	c1 e0 02             	shl    $0x2,%eax
  103084:	89 c2                	mov    %eax,%edx
  103086:	a1 58 99 11 00       	mov    0x119958,%eax
  10308b:	01 d0                	add    %edx,%eax
  10308d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103090:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103097:	77 17                	ja     1030b0 <page_init+0x22b>
  103099:	ff 75 b8             	pushl  -0x48(%ebp)
  10309c:	68 44 65 10 00       	push   $0x106544
  1030a1:	68 db 00 00 00       	push   $0xdb
  1030a6:	68 68 65 10 00       	push   $0x106568
  1030ab:	e8 2d d3 ff ff       	call   1003dd <__panic>
  1030b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1030b3:	05 00 00 00 40       	add    $0x40000000,%eax
  1030b8:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1030bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030c2:	e9 71 01 00 00       	jmp    103238 <page_init+0x3b3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1030c7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030cd:	89 d0                	mov    %edx,%eax
  1030cf:	c1 e0 02             	shl    $0x2,%eax
  1030d2:	01 d0                	add    %edx,%eax
  1030d4:	c1 e0 02             	shl    $0x2,%eax
  1030d7:	01 c8                	add    %ecx,%eax
  1030d9:	8b 50 08             	mov    0x8(%eax),%edx
  1030dc:	8b 40 04             	mov    0x4(%eax),%eax
  1030df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030e5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030eb:	89 d0                	mov    %edx,%eax
  1030ed:	c1 e0 02             	shl    $0x2,%eax
  1030f0:	01 d0                	add    %edx,%eax
  1030f2:	c1 e0 02             	shl    $0x2,%eax
  1030f5:	01 c8                	add    %ecx,%eax
  1030f7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1030fa:	8b 58 10             	mov    0x10(%eax),%ebx
  1030fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103100:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103103:	01 c8                	add    %ecx,%eax
  103105:	11 da                	adc    %ebx,%edx
  103107:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10310a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10310d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103110:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103113:	89 d0                	mov    %edx,%eax
  103115:	c1 e0 02             	shl    $0x2,%eax
  103118:	01 d0                	add    %edx,%eax
  10311a:	c1 e0 02             	shl    $0x2,%eax
  10311d:	01 c8                	add    %ecx,%eax
  10311f:	83 c0 14             	add    $0x14,%eax
  103122:	8b 00                	mov    (%eax),%eax
  103124:	83 f8 01             	cmp    $0x1,%eax
  103127:	0f 85 07 01 00 00    	jne    103234 <page_init+0x3af>
            if (begin < freemem) {
  10312d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103130:	ba 00 00 00 00       	mov    $0x0,%edx
  103135:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103138:	77 17                	ja     103151 <page_init+0x2cc>
  10313a:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10313d:	72 05                	jb     103144 <page_init+0x2bf>
  10313f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103142:	73 0d                	jae    103151 <page_init+0x2cc>
                begin = freemem;
  103144:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103147:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10314a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103151:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103155:	72 1d                	jb     103174 <page_init+0x2ef>
  103157:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10315b:	77 09                	ja     103166 <page_init+0x2e1>
  10315d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103164:	76 0e                	jbe    103174 <page_init+0x2ef>
                end = KMEMSIZE;
  103166:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10316d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103174:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103177:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10317a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10317d:	0f 87 b1 00 00 00    	ja     103234 <page_init+0x3af>
  103183:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103186:	72 09                	jb     103191 <page_init+0x30c>
  103188:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10318b:	0f 83 a3 00 00 00    	jae    103234 <page_init+0x3af>
                begin = ROUNDUP(begin, PGSIZE);
  103191:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103198:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10319b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10319e:	01 d0                	add    %edx,%eax
  1031a0:	83 e8 01             	sub    $0x1,%eax
  1031a3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1031a6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1031a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1031ae:	f7 75 b0             	divl   -0x50(%ebp)
  1031b1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1031b4:	29 d0                	sub    %edx,%eax
  1031b6:	ba 00 00 00 00       	mov    $0x0,%edx
  1031bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1031c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031c4:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1031c7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1031ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1031cf:	89 c3                	mov    %eax,%ebx
  1031d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1031d7:	89 de                	mov    %ebx,%esi
  1031d9:	89 d0                	mov    %edx,%eax
  1031db:	83 e0 00             	and    $0x0,%eax
  1031de:	89 c7                	mov    %eax,%edi
  1031e0:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1031e3:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1031e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031ec:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1031ef:	77 43                	ja     103234 <page_init+0x3af>
  1031f1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1031f4:	72 05                	jb     1031fb <page_init+0x376>
  1031f6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1031f9:	73 39                	jae    103234 <page_init+0x3af>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1031fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103201:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103204:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103207:	89 c1                	mov    %eax,%ecx
  103209:	89 d3                	mov    %edx,%ebx
  10320b:	89 c8                	mov    %ecx,%eax
  10320d:	89 da                	mov    %ebx,%edx
  10320f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103213:	c1 ea 0c             	shr    $0xc,%edx
  103216:	89 c3                	mov    %eax,%ebx
  103218:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10321b:	83 ec 0c             	sub    $0xc,%esp
  10321e:	50                   	push   %eax
  10321f:	e8 d0 f8 ff ff       	call   102af4 <pa2page>
  103224:	83 c4 10             	add    $0x10,%esp
  103227:	83 ec 08             	sub    $0x8,%esp
  10322a:	53                   	push   %ebx
  10322b:	50                   	push   %eax
  10322c:	e8 94 fb ff ff       	call   102dc5 <init_memmap>
  103231:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
  103234:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103238:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10323b:	8b 00                	mov    (%eax),%eax
  10323d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103240:	0f 8c 81 fe ff ff    	jl     1030c7 <page_init+0x242>
                }
            }
        }
    }
}
  103246:	90                   	nop
  103247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10324a:	5b                   	pop    %ebx
  10324b:	5e                   	pop    %esi
  10324c:	5f                   	pop    %edi
  10324d:	5d                   	pop    %ebp
  10324e:	c3                   	ret    

0010324f <enable_paging>:

static void
enable_paging(void) {
  10324f:	55                   	push   %ebp
  103250:	89 e5                	mov    %esp,%ebp
  103252:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103255:	a1 54 99 11 00       	mov    0x119954,%eax
  10325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103260:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103263:	0f 20 c0             	mov    %cr0,%eax
  103266:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103269:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10326c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10326f:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103276:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  10327a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10327d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103280:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103283:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103286:	90                   	nop
  103287:	c9                   	leave  
  103288:	c3                   	ret    

00103289 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103289:	55                   	push   %ebp
  10328a:	89 e5                	mov    %esp,%ebp
  10328c:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10328f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103292:	33 45 14             	xor    0x14(%ebp),%eax
  103295:	25 ff 0f 00 00       	and    $0xfff,%eax
  10329a:	85 c0                	test   %eax,%eax
  10329c:	74 19                	je     1032b7 <boot_map_segment+0x2e>
  10329e:	68 76 65 10 00       	push   $0x106576
  1032a3:	68 8d 65 10 00       	push   $0x10658d
  1032a8:	68 04 01 00 00       	push   $0x104
  1032ad:	68 68 65 10 00       	push   $0x106568
  1032b2:	e8 26 d1 ff ff       	call   1003dd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1032b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1032be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c1:	25 ff 0f 00 00       	and    $0xfff,%eax
  1032c6:	89 c2                	mov    %eax,%edx
  1032c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1032cb:	01 c2                	add    %eax,%edx
  1032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d0:	01 d0                	add    %edx,%eax
  1032d2:	83 e8 01             	sub    $0x1,%eax
  1032d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032db:	ba 00 00 00 00       	mov    $0x0,%edx
  1032e0:	f7 75 f0             	divl   -0x10(%ebp)
  1032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032e6:	29 d0                	sub    %edx,%eax
  1032e8:	c1 e8 0c             	shr    $0xc,%eax
  1032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1032ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1032fc:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1032ff:	8b 45 14             	mov    0x14(%ebp),%eax
  103302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103308:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10330d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103310:	eb 57                	jmp    103369 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103312:	83 ec 04             	sub    $0x4,%esp
  103315:	6a 01                	push   $0x1
  103317:	ff 75 0c             	pushl  0xc(%ebp)
  10331a:	ff 75 08             	pushl  0x8(%ebp)
  10331d:	e8 98 01 00 00       	call   1034ba <get_pte>
  103322:	83 c4 10             	add    $0x10,%esp
  103325:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103328:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10332c:	75 19                	jne    103347 <boot_map_segment+0xbe>
  10332e:	68 a2 65 10 00       	push   $0x1065a2
  103333:	68 8d 65 10 00       	push   $0x10658d
  103338:	68 0a 01 00 00       	push   $0x10a
  10333d:	68 68 65 10 00       	push   $0x106568
  103342:	e8 96 d0 ff ff       	call   1003dd <__panic>
        *ptep = pa | PTE_P | perm;
  103347:	8b 45 14             	mov    0x14(%ebp),%eax
  10334a:	0b 45 18             	or     0x18(%ebp),%eax
  10334d:	83 c8 01             	or     $0x1,%eax
  103350:	89 c2                	mov    %eax,%edx
  103352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103355:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103357:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10335b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103362:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10336d:	75 a3                	jne    103312 <boot_map_segment+0x89>
    }
}
  10336f:	90                   	nop
  103370:	c9                   	leave  
  103371:	c3                   	ret    

00103372 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103372:	55                   	push   %ebp
  103373:	89 e5                	mov    %esp,%ebp
  103375:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  103378:	83 ec 0c             	sub    $0xc,%esp
  10337b:	6a 01                	push   $0x1
  10337d:	e8 62 fa ff ff       	call   102de4 <alloc_pages>
  103382:	83 c4 10             	add    $0x10,%esp
  103385:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10338c:	75 17                	jne    1033a5 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10338e:	83 ec 04             	sub    $0x4,%esp
  103391:	68 af 65 10 00       	push   $0x1065af
  103396:	68 16 01 00 00       	push   $0x116
  10339b:	68 68 65 10 00       	push   $0x106568
  1033a0:	e8 38 d0 ff ff       	call   1003dd <__panic>
    }
    return page2kva(p);
  1033a5:	83 ec 0c             	sub    $0xc,%esp
  1033a8:	ff 75 f4             	pushl  -0xc(%ebp)
  1033ab:	e8 8b f7 ff ff       	call   102b3b <page2kva>
  1033b0:	83 c4 10             	add    $0x10,%esp
}
  1033b3:	c9                   	leave  
  1033b4:	c3                   	ret    

001033b5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1033b5:	55                   	push   %ebp
  1033b6:	89 e5                	mov    %esp,%ebp
  1033b8:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1033bb:	e8 d0 f9 ff ff       	call   102d90 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1033c0:	e8 c0 fa ff ff       	call   102e85 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1033c5:	e8 72 04 00 00       	call   10383c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1033ca:	e8 a3 ff ff ff       	call   103372 <boot_alloc_page>
  1033cf:	a3 c4 98 11 00       	mov    %eax,0x1198c4
    memset(boot_pgdir, 0, PGSIZE);
  1033d4:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1033d9:	83 ec 04             	sub    $0x4,%esp
  1033dc:	68 00 10 00 00       	push   $0x1000
  1033e1:	6a 00                	push   $0x0
  1033e3:	50                   	push   %eax
  1033e4:	e8 ab 21 00 00       	call   105594 <memset>
  1033e9:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1033ec:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1033f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033f4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1033fb:	77 17                	ja     103414 <pmm_init+0x5f>
  1033fd:	ff 75 f4             	pushl  -0xc(%ebp)
  103400:	68 44 65 10 00       	push   $0x106544
  103405:	68 30 01 00 00       	push   $0x130
  10340a:	68 68 65 10 00       	push   $0x106568
  10340f:	e8 c9 cf ff ff       	call   1003dd <__panic>
  103414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103417:	05 00 00 00 40       	add    $0x40000000,%eax
  10341c:	a3 54 99 11 00       	mov    %eax,0x119954

    check_pgdir();
  103421:	e8 39 04 00 00       	call   10385f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103426:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10342b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103435:	77 17                	ja     10344e <pmm_init+0x99>
  103437:	ff 75 f0             	pushl  -0x10(%ebp)
  10343a:	68 44 65 10 00       	push   $0x106544
  10343f:	68 38 01 00 00       	push   $0x138
  103444:	68 68 65 10 00       	push   $0x106568
  103449:	e8 8f cf ff ff       	call   1003dd <__panic>
  10344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103451:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103457:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10345c:	05 ac 0f 00 00       	add    $0xfac,%eax
  103461:	83 ca 03             	or     $0x3,%edx
  103464:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103466:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10346b:	83 ec 0c             	sub    $0xc,%esp
  10346e:	6a 02                	push   $0x2
  103470:	6a 00                	push   $0x0
  103472:	68 00 00 00 38       	push   $0x38000000
  103477:	68 00 00 00 c0       	push   $0xc0000000
  10347c:	50                   	push   %eax
  10347d:	e8 07 fe ff ff       	call   103289 <boot_map_segment>
  103482:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103485:	8b 15 c4 98 11 00    	mov    0x1198c4,%edx
  10348b:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103490:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103496:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103498:	e8 b2 fd ff ff       	call   10324f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10349d:	e8 fc f7 ff ff       	call   102c9e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1034a2:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1034a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1034ad:	e8 13 09 00 00       	call   103dc5 <check_boot_pgdir>

    print_pgdir();
  1034b2:	e8 09 0d 00 00       	call   1041c0 <print_pgdir>

}
  1034b7:	90                   	nop
  1034b8:	c9                   	leave  
  1034b9:	c3                   	ret    

001034ba <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1034ba:	55                   	push   %ebp
  1034bb:	89 e5                	mov    %esp,%ebp
  1034bd:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la); // 获取到页目录表中给定线性地址对应到的页目录项
  1034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c3:	c1 e8 16             	shr    $0x16,%eax
  1034c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d0:	01 d0                	add    %edx,%eax
  1034d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
pte_t *ptep = ((pte_t *) (KADDR(*pdep & ~0XFFF)) + PTX(la)); // 从找到的页目录项中查询到线性地址对应到的页表中的页表项，即页表基址加上线性地址的中的offset（第12...21位，从0开始）
  1034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d8:	8b 00                	mov    (%eax),%eax
  1034da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e5:	c1 e8 0c             	shr    $0xc,%eax
  1034e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034eb:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1034f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1034f3:	72 17                	jb     10350c <get_pte+0x52>
  1034f5:	ff 75 f0             	pushl  -0x10(%ebp)
  1034f8:	68 a0 64 10 00       	push   $0x1064a0
  1034fd:	68 80 01 00 00       	push   $0x180
  103502:	68 68 65 10 00       	push   $0x106568
  103507:	e8 d1 ce ff ff       	call   1003dd <__panic>
  10350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10350f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103514:	89 c2                	mov    %eax,%edx
  103516:	8b 45 0c             	mov    0xc(%ebp),%eax
  103519:	c1 e8 0c             	shr    $0xc,%eax
  10351c:	25 ff 03 00 00       	and    $0x3ff,%eax
  103521:	c1 e0 02             	shl    $0x2,%eax
  103524:	01 d0                	add    %edx,%eax
  103526:	89 45 e8             	mov    %eax,-0x18(%ebp)
if (*pdep & PTE_P) 
  103529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10352c:	8b 00                	mov    (%eax),%eax
  10352e:	83 e0 01             	and    $0x1,%eax
  103531:	85 c0                	test   %eax,%eax
  103533:	74 08                	je     10353d <get_pte+0x83>
return ptep; // 检查查找到的页目录项是否存在，如果存在直接放回找到的页表项即可
  103535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103538:	e9 00 01 00 00       	jmp    10363d <get_pte+0x183>
if (!create) 
  10353d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103541:	75 0a                	jne    10354d <get_pte+0x93>
return NULL; // 如果该页目录项是不存在的，并且参数要求不创建新的页表，则直接返回
  103543:	b8 00 00 00 00       	mov    $0x0,%eax
  103548:	e9 f0 00 00 00       	jmp    10363d <get_pte+0x183>
struct Page* pt = alloc_page(); // 如果需要按需创建新的页表，则请求一个物理页来存储新创建的页表
  10354d:	83 ec 0c             	sub    $0xc,%esp
  103550:	6a 01                	push   $0x1
  103552:	e8 8d f8 ff ff       	call   102de4 <alloc_pages>
  103557:	83 c4 10             	add    $0x10,%esp
  10355a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
if (pt == NULL) 
  10355d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103561:	75 0a                	jne    10356d <get_pte+0xb3>
return NULL; // 如果物理空间不足，直接返回
  103563:	b8 00 00 00 00       	mov    $0x0,%eax
  103568:	e9 d0 00 00 00       	jmp    10363d <get_pte+0x183>

set_page_ref(pt, 1); // 更新该物理页的引用计数
  10356d:	83 ec 08             	sub    $0x8,%esp
  103570:	6a 01                	push   $0x1
  103572:	ff 75 e4             	pushl  -0x1c(%ebp)
  103575:	e8 66 f6 ff ff       	call   102be0 <set_page_ref>
  10357a:	83 c4 10             	add    $0x10,%esp

uintptr_t pa=page2pa(pt); //得到该页物理地址
  10357d:	83 ec 0c             	sub    $0xc,%esp
  103580:	ff 75 e4             	pushl  -0x1c(%ebp)
  103583:	e8 59 f5 ff ff       	call   102ae1 <page2pa>
  103588:	83 c4 10             	add    $0x10,%esp
  10358b:	89 45 e0             	mov    %eax,-0x20(%ebp)

memset(KADDR(pa),0,PGSIZE);//物理地址转虚拟地址，并初始化
  10358e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103591:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103594:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103597:	c1 e8 0c             	shr    $0xc,%eax
  10359a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10359d:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1035a2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1035a5:	72 17                	jb     1035be <get_pte+0x104>
  1035a7:	ff 75 dc             	pushl  -0x24(%ebp)
  1035aa:	68 a0 64 10 00       	push   $0x1064a0
  1035af:	68 8d 01 00 00       	push   $0x18d
  1035b4:	68 68 65 10 00       	push   $0x106568
  1035b9:	e8 1f ce ff ff       	call   1003dd <__panic>
  1035be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1035c1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1035c6:	83 ec 04             	sub    $0x4,%esp
  1035c9:	68 00 10 00 00       	push   $0x1000
  1035ce:	6a 00                	push   $0x0
  1035d0:	50                   	push   %eax
  1035d1:	e8 be 1f 00 00       	call   105594 <memset>
  1035d6:	83 c4 10             	add    $0x10,%esp

*pdep = pa| PTE_U | PTE_W | PTE_P; // 对原先的页目录项进行设置，包括设置其对应的页表的物理地址，以及包括存在位在内的标志位
  1035d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035dc:	83 c8 07             	or     $0x7,%eax
  1035df:	89 c2                	mov    %eax,%edx
  1035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e4:	89 10                	mov    %edx,(%eax)
ptep=((pte_t*)KADDR(PDE_ADDR(*pdep)))+PTX(la);
  1035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e9:	8b 00                	mov    (%eax),%eax
  1035eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1035f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035f6:	c1 e8 0c             	shr    $0xc,%eax
  1035f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1035fc:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103601:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103604:	72 17                	jb     10361d <get_pte+0x163>
  103606:	ff 75 d4             	pushl  -0x2c(%ebp)
  103609:	68 a0 64 10 00       	push   $0x1064a0
  10360e:	68 90 01 00 00       	push   $0x190
  103613:	68 68 65 10 00       	push   $0x106568
  103618:	e8 c0 cd ff ff       	call   1003dd <__panic>
  10361d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103620:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103625:	89 c2                	mov    %eax,%edx
  103627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10362a:	c1 e8 0c             	shr    $0xc,%eax
  10362d:	25 ff 03 00 00       	and    $0x3ff,%eax
  103632:	c1 e0 02             	shl    $0x2,%eax
  103635:	01 d0                	add    %edx,%eax
  103637:	89 45 e8             	mov    %eax,-0x18(%ebp)
return ptep ; // 返回线性地址对应的页目录项
  10363a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  10363d:	c9                   	leave  
  10363e:	c3                   	ret    

0010363f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10363f:	55                   	push   %ebp
  103640:	89 e5                	mov    %esp,%ebp
  103642:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103645:	83 ec 04             	sub    $0x4,%esp
  103648:	6a 00                	push   $0x0
  10364a:	ff 75 0c             	pushl  0xc(%ebp)
  10364d:	ff 75 08             	pushl  0x8(%ebp)
  103650:	e8 65 fe ff ff       	call   1034ba <get_pte>
  103655:	83 c4 10             	add    $0x10,%esp
  103658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10365b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10365f:	74 08                	je     103669 <get_page+0x2a>
        *ptep_store = ptep;
  103661:	8b 45 10             	mov    0x10(%ebp),%eax
  103664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103667:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10366d:	74 1f                	je     10368e <get_page+0x4f>
  10366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103672:	8b 00                	mov    (%eax),%eax
  103674:	83 e0 01             	and    $0x1,%eax
  103677:	85 c0                	test   %eax,%eax
  103679:	74 13                	je     10368e <get_page+0x4f>
        return pte2page(*ptep);
  10367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10367e:	8b 00                	mov    (%eax),%eax
  103680:	83 ec 0c             	sub    $0xc,%esp
  103683:	50                   	push   %eax
  103684:	e8 f7 f4 ff ff       	call   102b80 <pte2page>
  103689:	83 c4 10             	add    $0x10,%esp
  10368c:	eb 05                	jmp    103693 <get_page+0x54>
    }
    return NULL;
  10368e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103693:	c9                   	leave  
  103694:	c3                   	ret    

00103695 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103695:	55                   	push   %ebp
  103696:	89 e5                	mov    %esp,%ebp
  103698:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  10369b:	8b 45 10             	mov    0x10(%ebp),%eax
  10369e:	8b 00                	mov    (%eax),%eax
  1036a0:	83 e0 01             	and    $0x1,%eax
  1036a3:	85 c0                	test   %eax,%eax
  1036a5:	74 50                	je     1036f7 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
  1036a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1036aa:	8b 00                	mov    (%eax),%eax
  1036ac:	83 ec 0c             	sub    $0xc,%esp
  1036af:	50                   	push   %eax
  1036b0:	e8 cb f4 ff ff       	call   102b80 <pte2page>
  1036b5:	83 c4 10             	add    $0x10,%esp
  1036b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  1036bb:	83 ec 0c             	sub    $0xc,%esp
  1036be:	ff 75 f4             	pushl  -0xc(%ebp)
  1036c1:	e8 3f f5 ff ff       	call   102c05 <page_ref_dec>
  1036c6:	83 c4 10             	add    $0x10,%esp
  1036c9:	85 c0                	test   %eax,%eax
  1036cb:	75 10                	jne    1036dd <page_remove_pte+0x48>
            free_page(page);
  1036cd:	83 ec 08             	sub    $0x8,%esp
  1036d0:	6a 01                	push   $0x1
  1036d2:	ff 75 f4             	pushl  -0xc(%ebp)
  1036d5:	e8 48 f7 ff ff       	call   102e22 <free_pages>
  1036da:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
  1036dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1036e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  1036e6:	83 ec 08             	sub    $0x8,%esp
  1036e9:	ff 75 0c             	pushl  0xc(%ebp)
  1036ec:	ff 75 08             	pushl  0x8(%ebp)
  1036ef:	e8 f8 00 00 00       	call   1037ec <tlb_invalidate>
  1036f4:	83 c4 10             	add    $0x10,%esp
    }
}
  1036f7:	90                   	nop
  1036f8:	c9                   	leave  
  1036f9:	c3                   	ret    

001036fa <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1036fa:	55                   	push   %ebp
  1036fb:	89 e5                	mov    %esp,%ebp
  1036fd:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103700:	83 ec 04             	sub    $0x4,%esp
  103703:	6a 00                	push   $0x0
  103705:	ff 75 0c             	pushl  0xc(%ebp)
  103708:	ff 75 08             	pushl  0x8(%ebp)
  10370b:	e8 aa fd ff ff       	call   1034ba <get_pte>
  103710:	83 c4 10             	add    $0x10,%esp
  103713:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103716:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10371a:	74 14                	je     103730 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  10371c:	83 ec 04             	sub    $0x4,%esp
  10371f:	ff 75 f4             	pushl  -0xc(%ebp)
  103722:	ff 75 0c             	pushl  0xc(%ebp)
  103725:	ff 75 08             	pushl  0x8(%ebp)
  103728:	e8 68 ff ff ff       	call   103695 <page_remove_pte>
  10372d:	83 c4 10             	add    $0x10,%esp
    }
}
  103730:	90                   	nop
  103731:	c9                   	leave  
  103732:	c3                   	ret    

00103733 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103733:	55                   	push   %ebp
  103734:	89 e5                	mov    %esp,%ebp
  103736:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103739:	83 ec 04             	sub    $0x4,%esp
  10373c:	6a 01                	push   $0x1
  10373e:	ff 75 10             	pushl  0x10(%ebp)
  103741:	ff 75 08             	pushl  0x8(%ebp)
  103744:	e8 71 fd ff ff       	call   1034ba <get_pte>
  103749:	83 c4 10             	add    $0x10,%esp
  10374c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103753:	75 0a                	jne    10375f <page_insert+0x2c>
        return -E_NO_MEM;
  103755:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10375a:	e9 8b 00 00 00       	jmp    1037ea <page_insert+0xb7>
    }
    page_ref_inc(page);
  10375f:	83 ec 0c             	sub    $0xc,%esp
  103762:	ff 75 0c             	pushl  0xc(%ebp)
  103765:	e8 84 f4 ff ff       	call   102bee <page_ref_inc>
  10376a:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  10376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103770:	8b 00                	mov    (%eax),%eax
  103772:	83 e0 01             	and    $0x1,%eax
  103775:	85 c0                	test   %eax,%eax
  103777:	74 40                	je     1037b9 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10377c:	8b 00                	mov    (%eax),%eax
  10377e:	83 ec 0c             	sub    $0xc,%esp
  103781:	50                   	push   %eax
  103782:	e8 f9 f3 ff ff       	call   102b80 <pte2page>
  103787:	83 c4 10             	add    $0x10,%esp
  10378a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103790:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103793:	75 10                	jne    1037a5 <page_insert+0x72>
            page_ref_dec(page);
  103795:	83 ec 0c             	sub    $0xc,%esp
  103798:	ff 75 0c             	pushl  0xc(%ebp)
  10379b:	e8 65 f4 ff ff       	call   102c05 <page_ref_dec>
  1037a0:	83 c4 10             	add    $0x10,%esp
  1037a3:	eb 14                	jmp    1037b9 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1037a5:	83 ec 04             	sub    $0x4,%esp
  1037a8:	ff 75 f4             	pushl  -0xc(%ebp)
  1037ab:	ff 75 10             	pushl  0x10(%ebp)
  1037ae:	ff 75 08             	pushl  0x8(%ebp)
  1037b1:	e8 df fe ff ff       	call   103695 <page_remove_pte>
  1037b6:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1037b9:	83 ec 0c             	sub    $0xc,%esp
  1037bc:	ff 75 0c             	pushl  0xc(%ebp)
  1037bf:	e8 1d f3 ff ff       	call   102ae1 <page2pa>
  1037c4:	83 c4 10             	add    $0x10,%esp
  1037c7:	0b 45 14             	or     0x14(%ebp),%eax
  1037ca:	83 c8 01             	or     $0x1,%eax
  1037cd:	89 c2                	mov    %eax,%edx
  1037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1037d4:	83 ec 08             	sub    $0x8,%esp
  1037d7:	ff 75 10             	pushl  0x10(%ebp)
  1037da:	ff 75 08             	pushl  0x8(%ebp)
  1037dd:	e8 0a 00 00 00       	call   1037ec <tlb_invalidate>
  1037e2:	83 c4 10             	add    $0x10,%esp
    return 0;
  1037e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1037ea:	c9                   	leave  
  1037eb:	c3                   	ret    

001037ec <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1037ec:	55                   	push   %ebp
  1037ed:	89 e5                	mov    %esp,%ebp
  1037ef:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1037f2:	0f 20 d8             	mov    %cr3,%eax
  1037f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1037f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1037fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103801:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103808:	77 17                	ja     103821 <tlb_invalidate+0x35>
  10380a:	ff 75 f4             	pushl  -0xc(%ebp)
  10380d:	68 44 65 10 00       	push   $0x106544
  103812:	68 f3 01 00 00       	push   $0x1f3
  103817:	68 68 65 10 00       	push   $0x106568
  10381c:	e8 bc cb ff ff       	call   1003dd <__panic>
  103821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103824:	05 00 00 00 40       	add    $0x40000000,%eax
  103829:	39 d0                	cmp    %edx,%eax
  10382b:	75 0c                	jne    103839 <tlb_invalidate+0x4d>
        invlpg((void *)la);
  10382d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103830:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103836:	0f 01 38             	invlpg (%eax)
    }
}
  103839:	90                   	nop
  10383a:	c9                   	leave  
  10383b:	c3                   	ret    

0010383c <check_alloc_page>:

static void
check_alloc_page(void) {
  10383c:	55                   	push   %ebp
  10383d:	89 e5                	mov    %esp,%ebp
  10383f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  103842:	a1 50 99 11 00       	mov    0x119950,%eax
  103847:	8b 40 18             	mov    0x18(%eax),%eax
  10384a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10384c:	83 ec 0c             	sub    $0xc,%esp
  10384f:	68 c8 65 10 00       	push   $0x1065c8
  103854:	e8 1e ca ff ff       	call   100277 <cprintf>
  103859:	83 c4 10             	add    $0x10,%esp
}
  10385c:	90                   	nop
  10385d:	c9                   	leave  
  10385e:	c3                   	ret    

0010385f <check_pgdir>:

static void
check_pgdir(void) {
  10385f:	55                   	push   %ebp
  103860:	89 e5                	mov    %esp,%ebp
  103862:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103865:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  10386a:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10386f:	76 19                	jbe    10388a <check_pgdir+0x2b>
  103871:	68 e7 65 10 00       	push   $0x1065e7
  103876:	68 8d 65 10 00       	push   $0x10658d
  10387b:	68 00 02 00 00       	push   $0x200
  103880:	68 68 65 10 00       	push   $0x106568
  103885:	e8 53 cb ff ff       	call   1003dd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10388a:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10388f:	85 c0                	test   %eax,%eax
  103891:	74 0e                	je     1038a1 <check_pgdir+0x42>
  103893:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103898:	25 ff 0f 00 00       	and    $0xfff,%eax
  10389d:	85 c0                	test   %eax,%eax
  10389f:	74 19                	je     1038ba <check_pgdir+0x5b>
  1038a1:	68 04 66 10 00       	push   $0x106604
  1038a6:	68 8d 65 10 00       	push   $0x10658d
  1038ab:	68 01 02 00 00       	push   $0x201
  1038b0:	68 68 65 10 00       	push   $0x106568
  1038b5:	e8 23 cb ff ff       	call   1003dd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1038ba:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1038bf:	83 ec 04             	sub    $0x4,%esp
  1038c2:	6a 00                	push   $0x0
  1038c4:	6a 00                	push   $0x0
  1038c6:	50                   	push   %eax
  1038c7:	e8 73 fd ff ff       	call   10363f <get_page>
  1038cc:	83 c4 10             	add    $0x10,%esp
  1038cf:	85 c0                	test   %eax,%eax
  1038d1:	74 19                	je     1038ec <check_pgdir+0x8d>
  1038d3:	68 3c 66 10 00       	push   $0x10663c
  1038d8:	68 8d 65 10 00       	push   $0x10658d
  1038dd:	68 02 02 00 00       	push   $0x202
  1038e2:	68 68 65 10 00       	push   $0x106568
  1038e7:	e8 f1 ca ff ff       	call   1003dd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1038ec:	83 ec 0c             	sub    $0xc,%esp
  1038ef:	6a 01                	push   $0x1
  1038f1:	e8 ee f4 ff ff       	call   102de4 <alloc_pages>
  1038f6:	83 c4 10             	add    $0x10,%esp
  1038f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1038fc:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103901:	6a 00                	push   $0x0
  103903:	6a 00                	push   $0x0
  103905:	ff 75 f4             	pushl  -0xc(%ebp)
  103908:	50                   	push   %eax
  103909:	e8 25 fe ff ff       	call   103733 <page_insert>
  10390e:	83 c4 10             	add    $0x10,%esp
  103911:	85 c0                	test   %eax,%eax
  103913:	74 19                	je     10392e <check_pgdir+0xcf>
  103915:	68 64 66 10 00       	push   $0x106664
  10391a:	68 8d 65 10 00       	push   $0x10658d
  10391f:	68 06 02 00 00       	push   $0x206
  103924:	68 68 65 10 00       	push   $0x106568
  103929:	e8 af ca ff ff       	call   1003dd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10392e:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103933:	83 ec 04             	sub    $0x4,%esp
  103936:	6a 00                	push   $0x0
  103938:	6a 00                	push   $0x0
  10393a:	50                   	push   %eax
  10393b:	e8 7a fb ff ff       	call   1034ba <get_pte>
  103940:	83 c4 10             	add    $0x10,%esp
  103943:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103946:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10394a:	75 19                	jne    103965 <check_pgdir+0x106>
  10394c:	68 90 66 10 00       	push   $0x106690
  103951:	68 8d 65 10 00       	push   $0x10658d
  103956:	68 09 02 00 00       	push   $0x209
  10395b:	68 68 65 10 00       	push   $0x106568
  103960:	e8 78 ca ff ff       	call   1003dd <__panic>
    assert(pte2page(*ptep) == p1);
  103965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103968:	8b 00                	mov    (%eax),%eax
  10396a:	83 ec 0c             	sub    $0xc,%esp
  10396d:	50                   	push   %eax
  10396e:	e8 0d f2 ff ff       	call   102b80 <pte2page>
  103973:	83 c4 10             	add    $0x10,%esp
  103976:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103979:	74 19                	je     103994 <check_pgdir+0x135>
  10397b:	68 bd 66 10 00       	push   $0x1066bd
  103980:	68 8d 65 10 00       	push   $0x10658d
  103985:	68 0a 02 00 00       	push   $0x20a
  10398a:	68 68 65 10 00       	push   $0x106568
  10398f:	e8 49 ca ff ff       	call   1003dd <__panic>
    assert(page_ref(p1) == 1);
  103994:	83 ec 0c             	sub    $0xc,%esp
  103997:	ff 75 f4             	pushl  -0xc(%ebp)
  10399a:	e8 37 f2 ff ff       	call   102bd6 <page_ref>
  10399f:	83 c4 10             	add    $0x10,%esp
  1039a2:	83 f8 01             	cmp    $0x1,%eax
  1039a5:	74 19                	je     1039c0 <check_pgdir+0x161>
  1039a7:	68 d3 66 10 00       	push   $0x1066d3
  1039ac:	68 8d 65 10 00       	push   $0x10658d
  1039b1:	68 0b 02 00 00       	push   $0x20b
  1039b6:	68 68 65 10 00       	push   $0x106568
  1039bb:	e8 1d ca ff ff       	call   1003dd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1039c0:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1039c5:	8b 00                	mov    (%eax),%eax
  1039c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039d2:	c1 e8 0c             	shr    $0xc,%eax
  1039d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039d8:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1039dd:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039e0:	72 17                	jb     1039f9 <check_pgdir+0x19a>
  1039e2:	ff 75 ec             	pushl  -0x14(%ebp)
  1039e5:	68 a0 64 10 00       	push   $0x1064a0
  1039ea:	68 0d 02 00 00       	push   $0x20d
  1039ef:	68 68 65 10 00       	push   $0x106568
  1039f4:	e8 e4 c9 ff ff       	call   1003dd <__panic>
  1039f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039fc:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103a01:	83 c0 04             	add    $0x4,%eax
  103a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103a07:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103a0c:	83 ec 04             	sub    $0x4,%esp
  103a0f:	6a 00                	push   $0x0
  103a11:	68 00 10 00 00       	push   $0x1000
  103a16:	50                   	push   %eax
  103a17:	e8 9e fa ff ff       	call   1034ba <get_pte>
  103a1c:	83 c4 10             	add    $0x10,%esp
  103a1f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a22:	74 19                	je     103a3d <check_pgdir+0x1de>
  103a24:	68 e8 66 10 00       	push   $0x1066e8
  103a29:	68 8d 65 10 00       	push   $0x10658d
  103a2e:	68 0e 02 00 00       	push   $0x20e
  103a33:	68 68 65 10 00       	push   $0x106568
  103a38:	e8 a0 c9 ff ff       	call   1003dd <__panic>

    p2 = alloc_page();
  103a3d:	83 ec 0c             	sub    $0xc,%esp
  103a40:	6a 01                	push   $0x1
  103a42:	e8 9d f3 ff ff       	call   102de4 <alloc_pages>
  103a47:	83 c4 10             	add    $0x10,%esp
  103a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103a4d:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103a52:	6a 06                	push   $0x6
  103a54:	68 00 10 00 00       	push   $0x1000
  103a59:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a5c:	50                   	push   %eax
  103a5d:	e8 d1 fc ff ff       	call   103733 <page_insert>
  103a62:	83 c4 10             	add    $0x10,%esp
  103a65:	85 c0                	test   %eax,%eax
  103a67:	74 19                	je     103a82 <check_pgdir+0x223>
  103a69:	68 10 67 10 00       	push   $0x106710
  103a6e:	68 8d 65 10 00       	push   $0x10658d
  103a73:	68 11 02 00 00       	push   $0x211
  103a78:	68 68 65 10 00       	push   $0x106568
  103a7d:	e8 5b c9 ff ff       	call   1003dd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a82:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103a87:	83 ec 04             	sub    $0x4,%esp
  103a8a:	6a 00                	push   $0x0
  103a8c:	68 00 10 00 00       	push   $0x1000
  103a91:	50                   	push   %eax
  103a92:	e8 23 fa ff ff       	call   1034ba <get_pte>
  103a97:	83 c4 10             	add    $0x10,%esp
  103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aa1:	75 19                	jne    103abc <check_pgdir+0x25d>
  103aa3:	68 48 67 10 00       	push   $0x106748
  103aa8:	68 8d 65 10 00       	push   $0x10658d
  103aad:	68 12 02 00 00       	push   $0x212
  103ab2:	68 68 65 10 00       	push   $0x106568
  103ab7:	e8 21 c9 ff ff       	call   1003dd <__panic>
    assert(*ptep & PTE_U);
  103abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103abf:	8b 00                	mov    (%eax),%eax
  103ac1:	83 e0 04             	and    $0x4,%eax
  103ac4:	85 c0                	test   %eax,%eax
  103ac6:	75 19                	jne    103ae1 <check_pgdir+0x282>
  103ac8:	68 78 67 10 00       	push   $0x106778
  103acd:	68 8d 65 10 00       	push   $0x10658d
  103ad2:	68 13 02 00 00       	push   $0x213
  103ad7:	68 68 65 10 00       	push   $0x106568
  103adc:	e8 fc c8 ff ff       	call   1003dd <__panic>
    assert(*ptep & PTE_W);
  103ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ae4:	8b 00                	mov    (%eax),%eax
  103ae6:	83 e0 02             	and    $0x2,%eax
  103ae9:	85 c0                	test   %eax,%eax
  103aeb:	75 19                	jne    103b06 <check_pgdir+0x2a7>
  103aed:	68 86 67 10 00       	push   $0x106786
  103af2:	68 8d 65 10 00       	push   $0x10658d
  103af7:	68 14 02 00 00       	push   $0x214
  103afc:	68 68 65 10 00       	push   $0x106568
  103b01:	e8 d7 c8 ff ff       	call   1003dd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103b06:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103b0b:	8b 00                	mov    (%eax),%eax
  103b0d:	83 e0 04             	and    $0x4,%eax
  103b10:	85 c0                	test   %eax,%eax
  103b12:	75 19                	jne    103b2d <check_pgdir+0x2ce>
  103b14:	68 94 67 10 00       	push   $0x106794
  103b19:	68 8d 65 10 00       	push   $0x10658d
  103b1e:	68 15 02 00 00       	push   $0x215
  103b23:	68 68 65 10 00       	push   $0x106568
  103b28:	e8 b0 c8 ff ff       	call   1003dd <__panic>
    assert(page_ref(p2) == 1);
  103b2d:	83 ec 0c             	sub    $0xc,%esp
  103b30:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b33:	e8 9e f0 ff ff       	call   102bd6 <page_ref>
  103b38:	83 c4 10             	add    $0x10,%esp
  103b3b:	83 f8 01             	cmp    $0x1,%eax
  103b3e:	74 19                	je     103b59 <check_pgdir+0x2fa>
  103b40:	68 aa 67 10 00       	push   $0x1067aa
  103b45:	68 8d 65 10 00       	push   $0x10658d
  103b4a:	68 16 02 00 00       	push   $0x216
  103b4f:	68 68 65 10 00       	push   $0x106568
  103b54:	e8 84 c8 ff ff       	call   1003dd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b59:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103b5e:	6a 00                	push   $0x0
  103b60:	68 00 10 00 00       	push   $0x1000
  103b65:	ff 75 f4             	pushl  -0xc(%ebp)
  103b68:	50                   	push   %eax
  103b69:	e8 c5 fb ff ff       	call   103733 <page_insert>
  103b6e:	83 c4 10             	add    $0x10,%esp
  103b71:	85 c0                	test   %eax,%eax
  103b73:	74 19                	je     103b8e <check_pgdir+0x32f>
  103b75:	68 bc 67 10 00       	push   $0x1067bc
  103b7a:	68 8d 65 10 00       	push   $0x10658d
  103b7f:	68 18 02 00 00       	push   $0x218
  103b84:	68 68 65 10 00       	push   $0x106568
  103b89:	e8 4f c8 ff ff       	call   1003dd <__panic>
    assert(page_ref(p1) == 2);
  103b8e:	83 ec 0c             	sub    $0xc,%esp
  103b91:	ff 75 f4             	pushl  -0xc(%ebp)
  103b94:	e8 3d f0 ff ff       	call   102bd6 <page_ref>
  103b99:	83 c4 10             	add    $0x10,%esp
  103b9c:	83 f8 02             	cmp    $0x2,%eax
  103b9f:	74 19                	je     103bba <check_pgdir+0x35b>
  103ba1:	68 e8 67 10 00       	push   $0x1067e8
  103ba6:	68 8d 65 10 00       	push   $0x10658d
  103bab:	68 19 02 00 00       	push   $0x219
  103bb0:	68 68 65 10 00       	push   $0x106568
  103bb5:	e8 23 c8 ff ff       	call   1003dd <__panic>
    assert(page_ref(p2) == 0);
  103bba:	83 ec 0c             	sub    $0xc,%esp
  103bbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  103bc0:	e8 11 f0 ff ff       	call   102bd6 <page_ref>
  103bc5:	83 c4 10             	add    $0x10,%esp
  103bc8:	85 c0                	test   %eax,%eax
  103bca:	74 19                	je     103be5 <check_pgdir+0x386>
  103bcc:	68 fa 67 10 00       	push   $0x1067fa
  103bd1:	68 8d 65 10 00       	push   $0x10658d
  103bd6:	68 1a 02 00 00       	push   $0x21a
  103bdb:	68 68 65 10 00       	push   $0x106568
  103be0:	e8 f8 c7 ff ff       	call   1003dd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103be5:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103bea:	83 ec 04             	sub    $0x4,%esp
  103bed:	6a 00                	push   $0x0
  103bef:	68 00 10 00 00       	push   $0x1000
  103bf4:	50                   	push   %eax
  103bf5:	e8 c0 f8 ff ff       	call   1034ba <get_pte>
  103bfa:	83 c4 10             	add    $0x10,%esp
  103bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c04:	75 19                	jne    103c1f <check_pgdir+0x3c0>
  103c06:	68 48 67 10 00       	push   $0x106748
  103c0b:	68 8d 65 10 00       	push   $0x10658d
  103c10:	68 1b 02 00 00       	push   $0x21b
  103c15:	68 68 65 10 00       	push   $0x106568
  103c1a:	e8 be c7 ff ff       	call   1003dd <__panic>
    assert(pte2page(*ptep) == p1);
  103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c22:	8b 00                	mov    (%eax),%eax
  103c24:	83 ec 0c             	sub    $0xc,%esp
  103c27:	50                   	push   %eax
  103c28:	e8 53 ef ff ff       	call   102b80 <pte2page>
  103c2d:	83 c4 10             	add    $0x10,%esp
  103c30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c33:	74 19                	je     103c4e <check_pgdir+0x3ef>
  103c35:	68 bd 66 10 00       	push   $0x1066bd
  103c3a:	68 8d 65 10 00       	push   $0x10658d
  103c3f:	68 1c 02 00 00       	push   $0x21c
  103c44:	68 68 65 10 00       	push   $0x106568
  103c49:	e8 8f c7 ff ff       	call   1003dd <__panic>
    assert((*ptep & PTE_U) == 0);
  103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c51:	8b 00                	mov    (%eax),%eax
  103c53:	83 e0 04             	and    $0x4,%eax
  103c56:	85 c0                	test   %eax,%eax
  103c58:	74 19                	je     103c73 <check_pgdir+0x414>
  103c5a:	68 0c 68 10 00       	push   $0x10680c
  103c5f:	68 8d 65 10 00       	push   $0x10658d
  103c64:	68 1d 02 00 00       	push   $0x21d
  103c69:	68 68 65 10 00       	push   $0x106568
  103c6e:	e8 6a c7 ff ff       	call   1003dd <__panic>

    page_remove(boot_pgdir, 0x0);
  103c73:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103c78:	83 ec 08             	sub    $0x8,%esp
  103c7b:	6a 00                	push   $0x0
  103c7d:	50                   	push   %eax
  103c7e:	e8 77 fa ff ff       	call   1036fa <page_remove>
  103c83:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103c86:	83 ec 0c             	sub    $0xc,%esp
  103c89:	ff 75 f4             	pushl  -0xc(%ebp)
  103c8c:	e8 45 ef ff ff       	call   102bd6 <page_ref>
  103c91:	83 c4 10             	add    $0x10,%esp
  103c94:	83 f8 01             	cmp    $0x1,%eax
  103c97:	74 19                	je     103cb2 <check_pgdir+0x453>
  103c99:	68 d3 66 10 00       	push   $0x1066d3
  103c9e:	68 8d 65 10 00       	push   $0x10658d
  103ca3:	68 20 02 00 00       	push   $0x220
  103ca8:	68 68 65 10 00       	push   $0x106568
  103cad:	e8 2b c7 ff ff       	call   1003dd <__panic>
    assert(page_ref(p2) == 0);
  103cb2:	83 ec 0c             	sub    $0xc,%esp
  103cb5:	ff 75 e4             	pushl  -0x1c(%ebp)
  103cb8:	e8 19 ef ff ff       	call   102bd6 <page_ref>
  103cbd:	83 c4 10             	add    $0x10,%esp
  103cc0:	85 c0                	test   %eax,%eax
  103cc2:	74 19                	je     103cdd <check_pgdir+0x47e>
  103cc4:	68 fa 67 10 00       	push   $0x1067fa
  103cc9:	68 8d 65 10 00       	push   $0x10658d
  103cce:	68 21 02 00 00       	push   $0x221
  103cd3:	68 68 65 10 00       	push   $0x106568
  103cd8:	e8 00 c7 ff ff       	call   1003dd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103cdd:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103ce2:	83 ec 08             	sub    $0x8,%esp
  103ce5:	68 00 10 00 00       	push   $0x1000
  103cea:	50                   	push   %eax
  103ceb:	e8 0a fa ff ff       	call   1036fa <page_remove>
  103cf0:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103cf3:	83 ec 0c             	sub    $0xc,%esp
  103cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  103cf9:	e8 d8 ee ff ff       	call   102bd6 <page_ref>
  103cfe:	83 c4 10             	add    $0x10,%esp
  103d01:	85 c0                	test   %eax,%eax
  103d03:	74 19                	je     103d1e <check_pgdir+0x4bf>
  103d05:	68 21 68 10 00       	push   $0x106821
  103d0a:	68 8d 65 10 00       	push   $0x10658d
  103d0f:	68 24 02 00 00       	push   $0x224
  103d14:	68 68 65 10 00       	push   $0x106568
  103d19:	e8 bf c6 ff ff       	call   1003dd <__panic>
    assert(page_ref(p2) == 0);
  103d1e:	83 ec 0c             	sub    $0xc,%esp
  103d21:	ff 75 e4             	pushl  -0x1c(%ebp)
  103d24:	e8 ad ee ff ff       	call   102bd6 <page_ref>
  103d29:	83 c4 10             	add    $0x10,%esp
  103d2c:	85 c0                	test   %eax,%eax
  103d2e:	74 19                	je     103d49 <check_pgdir+0x4ea>
  103d30:	68 fa 67 10 00       	push   $0x1067fa
  103d35:	68 8d 65 10 00       	push   $0x10658d
  103d3a:	68 25 02 00 00       	push   $0x225
  103d3f:	68 68 65 10 00       	push   $0x106568
  103d44:	e8 94 c6 ff ff       	call   1003dd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103d49:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103d4e:	8b 00                	mov    (%eax),%eax
  103d50:	83 ec 0c             	sub    $0xc,%esp
  103d53:	50                   	push   %eax
  103d54:	e8 61 ee ff ff       	call   102bba <pde2page>
  103d59:	83 c4 10             	add    $0x10,%esp
  103d5c:	83 ec 0c             	sub    $0xc,%esp
  103d5f:	50                   	push   %eax
  103d60:	e8 71 ee ff ff       	call   102bd6 <page_ref>
  103d65:	83 c4 10             	add    $0x10,%esp
  103d68:	83 f8 01             	cmp    $0x1,%eax
  103d6b:	74 19                	je     103d86 <check_pgdir+0x527>
  103d6d:	68 34 68 10 00       	push   $0x106834
  103d72:	68 8d 65 10 00       	push   $0x10658d
  103d77:	68 27 02 00 00       	push   $0x227
  103d7c:	68 68 65 10 00       	push   $0x106568
  103d81:	e8 57 c6 ff ff       	call   1003dd <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d86:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103d8b:	8b 00                	mov    (%eax),%eax
  103d8d:	83 ec 0c             	sub    $0xc,%esp
  103d90:	50                   	push   %eax
  103d91:	e8 24 ee ff ff       	call   102bba <pde2page>
  103d96:	83 c4 10             	add    $0x10,%esp
  103d99:	83 ec 08             	sub    $0x8,%esp
  103d9c:	6a 01                	push   $0x1
  103d9e:	50                   	push   %eax
  103d9f:	e8 7e f0 ff ff       	call   102e22 <free_pages>
  103da4:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103da7:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103db2:	83 ec 0c             	sub    $0xc,%esp
  103db5:	68 5b 68 10 00       	push   $0x10685b
  103dba:	e8 b8 c4 ff ff       	call   100277 <cprintf>
  103dbf:	83 c4 10             	add    $0x10,%esp
}
  103dc2:	90                   	nop
  103dc3:	c9                   	leave  
  103dc4:	c3                   	ret    

00103dc5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103dc5:	55                   	push   %ebp
  103dc6:	89 e5                	mov    %esp,%ebp
  103dc8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103dcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103dd2:	e9 a3 00 00 00       	jmp    103e7a <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103de0:	c1 e8 0c             	shr    $0xc,%eax
  103de3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103de6:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103deb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103dee:	72 17                	jb     103e07 <check_boot_pgdir+0x42>
  103df0:	ff 75 e4             	pushl  -0x1c(%ebp)
  103df3:	68 a0 64 10 00       	push   $0x1064a0
  103df8:	68 33 02 00 00       	push   $0x233
  103dfd:	68 68 65 10 00       	push   $0x106568
  103e02:	e8 d6 c5 ff ff       	call   1003dd <__panic>
  103e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e0a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e0f:	89 c2                	mov    %eax,%edx
  103e11:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103e16:	83 ec 04             	sub    $0x4,%esp
  103e19:	6a 00                	push   $0x0
  103e1b:	52                   	push   %edx
  103e1c:	50                   	push   %eax
  103e1d:	e8 98 f6 ff ff       	call   1034ba <get_pte>
  103e22:	83 c4 10             	add    $0x10,%esp
  103e25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103e28:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103e2c:	75 19                	jne    103e47 <check_boot_pgdir+0x82>
  103e2e:	68 78 68 10 00       	push   $0x106878
  103e33:	68 8d 65 10 00       	push   $0x10658d
  103e38:	68 33 02 00 00       	push   $0x233
  103e3d:	68 68 65 10 00       	push   $0x106568
  103e42:	e8 96 c5 ff ff       	call   1003dd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103e47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e4a:	8b 00                	mov    (%eax),%eax
  103e4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e51:	89 c2                	mov    %eax,%edx
  103e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e56:	39 c2                	cmp    %eax,%edx
  103e58:	74 19                	je     103e73 <check_boot_pgdir+0xae>
  103e5a:	68 b5 68 10 00       	push   $0x1068b5
  103e5f:	68 8d 65 10 00       	push   $0x10658d
  103e64:	68 34 02 00 00       	push   $0x234
  103e69:	68 68 65 10 00       	push   $0x106568
  103e6e:	e8 6a c5 ff ff       	call   1003dd <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103e73:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e7d:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103e82:	39 c2                	cmp    %eax,%edx
  103e84:	0f 82 4d ff ff ff    	jb     103dd7 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103e8a:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103e8f:	05 ac 0f 00 00       	add    $0xfac,%eax
  103e94:	8b 00                	mov    (%eax),%eax
  103e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e9b:	89 c2                	mov    %eax,%edx
  103e9d:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ea5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103eac:	77 17                	ja     103ec5 <check_boot_pgdir+0x100>
  103eae:	ff 75 f0             	pushl  -0x10(%ebp)
  103eb1:	68 44 65 10 00       	push   $0x106544
  103eb6:	68 37 02 00 00       	push   $0x237
  103ebb:	68 68 65 10 00       	push   $0x106568
  103ec0:	e8 18 c5 ff ff       	call   1003dd <__panic>
  103ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ec8:	05 00 00 00 40       	add    $0x40000000,%eax
  103ecd:	39 d0                	cmp    %edx,%eax
  103ecf:	74 19                	je     103eea <check_boot_pgdir+0x125>
  103ed1:	68 cc 68 10 00       	push   $0x1068cc
  103ed6:	68 8d 65 10 00       	push   $0x10658d
  103edb:	68 37 02 00 00       	push   $0x237
  103ee0:	68 68 65 10 00       	push   $0x106568
  103ee5:	e8 f3 c4 ff ff       	call   1003dd <__panic>

    assert(boot_pgdir[0] == 0);
  103eea:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103eef:	8b 00                	mov    (%eax),%eax
  103ef1:	85 c0                	test   %eax,%eax
  103ef3:	74 19                	je     103f0e <check_boot_pgdir+0x149>
  103ef5:	68 00 69 10 00       	push   $0x106900
  103efa:	68 8d 65 10 00       	push   $0x10658d
  103eff:	68 39 02 00 00       	push   $0x239
  103f04:	68 68 65 10 00       	push   $0x106568
  103f09:	e8 cf c4 ff ff       	call   1003dd <__panic>

    struct Page *p;
    p = alloc_page();
  103f0e:	83 ec 0c             	sub    $0xc,%esp
  103f11:	6a 01                	push   $0x1
  103f13:	e8 cc ee ff ff       	call   102de4 <alloc_pages>
  103f18:	83 c4 10             	add    $0x10,%esp
  103f1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103f1e:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103f23:	6a 02                	push   $0x2
  103f25:	68 00 01 00 00       	push   $0x100
  103f2a:	ff 75 ec             	pushl  -0x14(%ebp)
  103f2d:	50                   	push   %eax
  103f2e:	e8 00 f8 ff ff       	call   103733 <page_insert>
  103f33:	83 c4 10             	add    $0x10,%esp
  103f36:	85 c0                	test   %eax,%eax
  103f38:	74 19                	je     103f53 <check_boot_pgdir+0x18e>
  103f3a:	68 14 69 10 00       	push   $0x106914
  103f3f:	68 8d 65 10 00       	push   $0x10658d
  103f44:	68 3d 02 00 00       	push   $0x23d
  103f49:	68 68 65 10 00       	push   $0x106568
  103f4e:	e8 8a c4 ff ff       	call   1003dd <__panic>
    assert(page_ref(p) == 1);
  103f53:	83 ec 0c             	sub    $0xc,%esp
  103f56:	ff 75 ec             	pushl  -0x14(%ebp)
  103f59:	e8 78 ec ff ff       	call   102bd6 <page_ref>
  103f5e:	83 c4 10             	add    $0x10,%esp
  103f61:	83 f8 01             	cmp    $0x1,%eax
  103f64:	74 19                	je     103f7f <check_boot_pgdir+0x1ba>
  103f66:	68 42 69 10 00       	push   $0x106942
  103f6b:	68 8d 65 10 00       	push   $0x10658d
  103f70:	68 3e 02 00 00       	push   $0x23e
  103f75:	68 68 65 10 00       	push   $0x106568
  103f7a:	e8 5e c4 ff ff       	call   1003dd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103f7f:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  103f84:	6a 02                	push   $0x2
  103f86:	68 00 11 00 00       	push   $0x1100
  103f8b:	ff 75 ec             	pushl  -0x14(%ebp)
  103f8e:	50                   	push   %eax
  103f8f:	e8 9f f7 ff ff       	call   103733 <page_insert>
  103f94:	83 c4 10             	add    $0x10,%esp
  103f97:	85 c0                	test   %eax,%eax
  103f99:	74 19                	je     103fb4 <check_boot_pgdir+0x1ef>
  103f9b:	68 54 69 10 00       	push   $0x106954
  103fa0:	68 8d 65 10 00       	push   $0x10658d
  103fa5:	68 3f 02 00 00       	push   $0x23f
  103faa:	68 68 65 10 00       	push   $0x106568
  103faf:	e8 29 c4 ff ff       	call   1003dd <__panic>
    assert(page_ref(p) == 2);
  103fb4:	83 ec 0c             	sub    $0xc,%esp
  103fb7:	ff 75 ec             	pushl  -0x14(%ebp)
  103fba:	e8 17 ec ff ff       	call   102bd6 <page_ref>
  103fbf:	83 c4 10             	add    $0x10,%esp
  103fc2:	83 f8 02             	cmp    $0x2,%eax
  103fc5:	74 19                	je     103fe0 <check_boot_pgdir+0x21b>
  103fc7:	68 8b 69 10 00       	push   $0x10698b
  103fcc:	68 8d 65 10 00       	push   $0x10658d
  103fd1:	68 40 02 00 00       	push   $0x240
  103fd6:	68 68 65 10 00       	push   $0x106568
  103fdb:	e8 fd c3 ff ff       	call   1003dd <__panic>

    const char *str = "ucore: Hello world!!";
  103fe0:	c7 45 e8 9c 69 10 00 	movl   $0x10699c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103fe7:	83 ec 08             	sub    $0x8,%esp
  103fea:	ff 75 e8             	pushl  -0x18(%ebp)
  103fed:	68 00 01 00 00       	push   $0x100
  103ff2:	e8 c4 12 00 00       	call   1052bb <strcpy>
  103ff7:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103ffa:	83 ec 08             	sub    $0x8,%esp
  103ffd:	68 00 11 00 00       	push   $0x1100
  104002:	68 00 01 00 00       	push   $0x100
  104007:	e8 29 13 00 00       	call   105335 <strcmp>
  10400c:	83 c4 10             	add    $0x10,%esp
  10400f:	85 c0                	test   %eax,%eax
  104011:	74 19                	je     10402c <check_boot_pgdir+0x267>
  104013:	68 b4 69 10 00       	push   $0x1069b4
  104018:	68 8d 65 10 00       	push   $0x10658d
  10401d:	68 44 02 00 00       	push   $0x244
  104022:	68 68 65 10 00       	push   $0x106568
  104027:	e8 b1 c3 ff ff       	call   1003dd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10402c:	83 ec 0c             	sub    $0xc,%esp
  10402f:	ff 75 ec             	pushl  -0x14(%ebp)
  104032:	e8 04 eb ff ff       	call   102b3b <page2kva>
  104037:	83 c4 10             	add    $0x10,%esp
  10403a:	05 00 01 00 00       	add    $0x100,%eax
  10403f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104042:	83 ec 0c             	sub    $0xc,%esp
  104045:	68 00 01 00 00       	push   $0x100
  10404a:	e8 14 12 00 00       	call   105263 <strlen>
  10404f:	83 c4 10             	add    $0x10,%esp
  104052:	85 c0                	test   %eax,%eax
  104054:	74 19                	je     10406f <check_boot_pgdir+0x2aa>
  104056:	68 ec 69 10 00       	push   $0x1069ec
  10405b:	68 8d 65 10 00       	push   $0x10658d
  104060:	68 47 02 00 00       	push   $0x247
  104065:	68 68 65 10 00       	push   $0x106568
  10406a:	e8 6e c3 ff ff       	call   1003dd <__panic>

    free_page(p);
  10406f:	83 ec 08             	sub    $0x8,%esp
  104072:	6a 01                	push   $0x1
  104074:	ff 75 ec             	pushl  -0x14(%ebp)
  104077:	e8 a6 ed ff ff       	call   102e22 <free_pages>
  10407c:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  10407f:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104084:	8b 00                	mov    (%eax),%eax
  104086:	83 ec 0c             	sub    $0xc,%esp
  104089:	50                   	push   %eax
  10408a:	e8 2b eb ff ff       	call   102bba <pde2page>
  10408f:	83 c4 10             	add    $0x10,%esp
  104092:	83 ec 08             	sub    $0x8,%esp
  104095:	6a 01                	push   $0x1
  104097:	50                   	push   %eax
  104098:	e8 85 ed ff ff       	call   102e22 <free_pages>
  10409d:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  1040a0:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1040a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1040ab:	83 ec 0c             	sub    $0xc,%esp
  1040ae:	68 10 6a 10 00       	push   $0x106a10
  1040b3:	e8 bf c1 ff ff       	call   100277 <cprintf>
  1040b8:	83 c4 10             	add    $0x10,%esp
}
  1040bb:	90                   	nop
  1040bc:	c9                   	leave  
  1040bd:	c3                   	ret    

001040be <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1040be:	55                   	push   %ebp
  1040bf:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1040c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1040c4:	83 e0 04             	and    $0x4,%eax
  1040c7:	85 c0                	test   %eax,%eax
  1040c9:	74 07                	je     1040d2 <perm2str+0x14>
  1040cb:	b8 75 00 00 00       	mov    $0x75,%eax
  1040d0:	eb 05                	jmp    1040d7 <perm2str+0x19>
  1040d2:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1040d7:	a2 48 99 11 00       	mov    %al,0x119948
    str[1] = 'r';
  1040dc:	c6 05 49 99 11 00 72 	movb   $0x72,0x119949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1040e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1040e6:	83 e0 02             	and    $0x2,%eax
  1040e9:	85 c0                	test   %eax,%eax
  1040eb:	74 07                	je     1040f4 <perm2str+0x36>
  1040ed:	b8 77 00 00 00       	mov    $0x77,%eax
  1040f2:	eb 05                	jmp    1040f9 <perm2str+0x3b>
  1040f4:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1040f9:	a2 4a 99 11 00       	mov    %al,0x11994a
    str[3] = '\0';
  1040fe:	c6 05 4b 99 11 00 00 	movb   $0x0,0x11994b
    return str;
  104105:	b8 48 99 11 00       	mov    $0x119948,%eax
}
  10410a:	5d                   	pop    %ebp
  10410b:	c3                   	ret    

0010410c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10410c:	55                   	push   %ebp
  10410d:	89 e5                	mov    %esp,%ebp
  10410f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104112:	8b 45 10             	mov    0x10(%ebp),%eax
  104115:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104118:	72 0e                	jb     104128 <get_pgtable_items+0x1c>
        return 0;
  10411a:	b8 00 00 00 00       	mov    $0x0,%eax
  10411f:	e9 9a 00 00 00       	jmp    1041be <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104124:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104128:	8b 45 10             	mov    0x10(%ebp),%eax
  10412b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10412e:	73 18                	jae    104148 <get_pgtable_items+0x3c>
  104130:	8b 45 10             	mov    0x10(%ebp),%eax
  104133:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10413a:	8b 45 14             	mov    0x14(%ebp),%eax
  10413d:	01 d0                	add    %edx,%eax
  10413f:	8b 00                	mov    (%eax),%eax
  104141:	83 e0 01             	and    $0x1,%eax
  104144:	85 c0                	test   %eax,%eax
  104146:	74 dc                	je     104124 <get_pgtable_items+0x18>
    }
    if (start < right) {
  104148:	8b 45 10             	mov    0x10(%ebp),%eax
  10414b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10414e:	73 69                	jae    1041b9 <get_pgtable_items+0xad>
        if (left_store != NULL) {
  104150:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104154:	74 08                	je     10415e <get_pgtable_items+0x52>
            *left_store = start;
  104156:	8b 45 18             	mov    0x18(%ebp),%eax
  104159:	8b 55 10             	mov    0x10(%ebp),%edx
  10415c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10415e:	8b 45 10             	mov    0x10(%ebp),%eax
  104161:	8d 50 01             	lea    0x1(%eax),%edx
  104164:	89 55 10             	mov    %edx,0x10(%ebp)
  104167:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10416e:	8b 45 14             	mov    0x14(%ebp),%eax
  104171:	01 d0                	add    %edx,%eax
  104173:	8b 00                	mov    (%eax),%eax
  104175:	83 e0 07             	and    $0x7,%eax
  104178:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10417b:	eb 04                	jmp    104181 <get_pgtable_items+0x75>
            start ++;
  10417d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104181:	8b 45 10             	mov    0x10(%ebp),%eax
  104184:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104187:	73 1d                	jae    1041a6 <get_pgtable_items+0x9a>
  104189:	8b 45 10             	mov    0x10(%ebp),%eax
  10418c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104193:	8b 45 14             	mov    0x14(%ebp),%eax
  104196:	01 d0                	add    %edx,%eax
  104198:	8b 00                	mov    (%eax),%eax
  10419a:	83 e0 07             	and    $0x7,%eax
  10419d:	89 c2                	mov    %eax,%edx
  10419f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041a2:	39 c2                	cmp    %eax,%edx
  1041a4:	74 d7                	je     10417d <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
  1041a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1041aa:	74 08                	je     1041b4 <get_pgtable_items+0xa8>
            *right_store = start;
  1041ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1041af:	8b 55 10             	mov    0x10(%ebp),%edx
  1041b2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1041b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b7:	eb 05                	jmp    1041be <get_pgtable_items+0xb2>
    }
    return 0;
  1041b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1041be:	c9                   	leave  
  1041bf:	c3                   	ret    

001041c0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1041c0:	55                   	push   %ebp
  1041c1:	89 e5                	mov    %esp,%ebp
  1041c3:	57                   	push   %edi
  1041c4:	56                   	push   %esi
  1041c5:	53                   	push   %ebx
  1041c6:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1041c9:	83 ec 0c             	sub    $0xc,%esp
  1041cc:	68 30 6a 10 00       	push   $0x106a30
  1041d1:	e8 a1 c0 ff ff       	call   100277 <cprintf>
  1041d6:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  1041d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1041e0:	e9 e5 00 00 00       	jmp    1042ca <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1041e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041e8:	83 ec 0c             	sub    $0xc,%esp
  1041eb:	50                   	push   %eax
  1041ec:	e8 cd fe ff ff       	call   1040be <perm2str>
  1041f1:	83 c4 10             	add    $0x10,%esp
  1041f4:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1041f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041fc:	29 c2                	sub    %eax,%edx
  1041fe:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104200:	c1 e0 16             	shl    $0x16,%eax
  104203:	89 c3                	mov    %eax,%ebx
  104205:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104208:	c1 e0 16             	shl    $0x16,%eax
  10420b:	89 c1                	mov    %eax,%ecx
  10420d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104210:	c1 e0 16             	shl    $0x16,%eax
  104213:	89 c2                	mov    %eax,%edx
  104215:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10421b:	29 c6                	sub    %eax,%esi
  10421d:	89 f0                	mov    %esi,%eax
  10421f:	83 ec 08             	sub    $0x8,%esp
  104222:	57                   	push   %edi
  104223:	53                   	push   %ebx
  104224:	51                   	push   %ecx
  104225:	52                   	push   %edx
  104226:	50                   	push   %eax
  104227:	68 61 6a 10 00       	push   $0x106a61
  10422c:	e8 46 c0 ff ff       	call   100277 <cprintf>
  104231:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
  104234:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104237:	c1 e0 0a             	shl    $0xa,%eax
  10423a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10423d:	eb 4f                	jmp    10428e <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10423f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104242:	83 ec 0c             	sub    $0xc,%esp
  104245:	50                   	push   %eax
  104246:	e8 73 fe ff ff       	call   1040be <perm2str>
  10424b:	83 c4 10             	add    $0x10,%esp
  10424e:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104250:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104253:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104256:	29 c2                	sub    %eax,%edx
  104258:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10425a:	c1 e0 0c             	shl    $0xc,%eax
  10425d:	89 c3                	mov    %eax,%ebx
  10425f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104262:	c1 e0 0c             	shl    $0xc,%eax
  104265:	89 c1                	mov    %eax,%ecx
  104267:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10426a:	c1 e0 0c             	shl    $0xc,%eax
  10426d:	89 c2                	mov    %eax,%edx
  10426f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  104272:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104275:	29 c6                	sub    %eax,%esi
  104277:	89 f0                	mov    %esi,%eax
  104279:	83 ec 08             	sub    $0x8,%esp
  10427c:	57                   	push   %edi
  10427d:	53                   	push   %ebx
  10427e:	51                   	push   %ecx
  10427f:	52                   	push   %edx
  104280:	50                   	push   %eax
  104281:	68 80 6a 10 00       	push   $0x106a80
  104286:	e8 ec bf ff ff       	call   100277 <cprintf>
  10428b:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10428e:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104293:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104296:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104299:	89 d3                	mov    %edx,%ebx
  10429b:	c1 e3 0a             	shl    $0xa,%ebx
  10429e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042a1:	89 d1                	mov    %edx,%ecx
  1042a3:	c1 e1 0a             	shl    $0xa,%ecx
  1042a6:	83 ec 08             	sub    $0x8,%esp
  1042a9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1042ac:	52                   	push   %edx
  1042ad:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1042b0:	52                   	push   %edx
  1042b1:	56                   	push   %esi
  1042b2:	50                   	push   %eax
  1042b3:	53                   	push   %ebx
  1042b4:	51                   	push   %ecx
  1042b5:	e8 52 fe ff ff       	call   10410c <get_pgtable_items>
  1042ba:	83 c4 20             	add    $0x20,%esp
  1042bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1042c4:	0f 85 75 ff ff ff    	jne    10423f <print_pgdir+0x7f>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042ca:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1042cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042d2:	83 ec 08             	sub    $0x8,%esp
  1042d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1042d8:	52                   	push   %edx
  1042d9:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1042dc:	52                   	push   %edx
  1042dd:	51                   	push   %ecx
  1042de:	50                   	push   %eax
  1042df:	68 00 04 00 00       	push   $0x400
  1042e4:	6a 00                	push   $0x0
  1042e6:	e8 21 fe ff ff       	call   10410c <get_pgtable_items>
  1042eb:	83 c4 20             	add    $0x20,%esp
  1042ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1042f5:	0f 85 ea fe ff ff    	jne    1041e5 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1042fb:	83 ec 0c             	sub    $0xc,%esp
  1042fe:	68 a4 6a 10 00       	push   $0x106aa4
  104303:	e8 6f bf ff ff       	call   100277 <cprintf>
  104308:	83 c4 10             	add    $0x10,%esp
}
  10430b:	90                   	nop
  10430c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10430f:	5b                   	pop    %ebx
  104310:	5e                   	pop    %esi
  104311:	5f                   	pop    %edi
  104312:	5d                   	pop    %ebp
  104313:	c3                   	ret    

00104314 <page2ppn>:
page2ppn(struct Page *page) {
  104314:	55                   	push   %ebp
  104315:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104317:	8b 45 08             	mov    0x8(%ebp),%eax
  10431a:	8b 15 58 99 11 00    	mov    0x119958,%edx
  104320:	29 d0                	sub    %edx,%eax
  104322:	c1 f8 02             	sar    $0x2,%eax
  104325:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10432b:	5d                   	pop    %ebp
  10432c:	c3                   	ret    

0010432d <page2pa>:
page2pa(struct Page *page) {
  10432d:	55                   	push   %ebp
  10432e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  104330:	ff 75 08             	pushl  0x8(%ebp)
  104333:	e8 dc ff ff ff       	call   104314 <page2ppn>
  104338:	83 c4 04             	add    $0x4,%esp
  10433b:	c1 e0 0c             	shl    $0xc,%eax
}
  10433e:	c9                   	leave  
  10433f:	c3                   	ret    

00104340 <page_ref>:
page_ref(struct Page *page) {
  104340:	55                   	push   %ebp
  104341:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104343:	8b 45 08             	mov    0x8(%ebp),%eax
  104346:	8b 00                	mov    (%eax),%eax
}
  104348:	5d                   	pop    %ebp
  104349:	c3                   	ret    

0010434a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10434a:	55                   	push   %ebp
  10434b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10434d:	8b 45 08             	mov    0x8(%ebp),%eax
  104350:	8b 55 0c             	mov    0xc(%ebp),%edx
  104353:	89 10                	mov    %edx,(%eax)
}
  104355:	90                   	nop
  104356:	5d                   	pop    %ebp
  104357:	c3                   	ret    

00104358 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104358:	55                   	push   %ebp
  104359:	89 e5                	mov    %esp,%ebp
  10435b:	83 ec 10             	sub    $0x10,%esp
  10435e:	c7 45 fc 5c 99 11 00 	movl   $0x11995c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104368:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10436b:	89 50 04             	mov    %edx,0x4(%eax)
  10436e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104371:	8b 50 04             	mov    0x4(%eax),%edx
  104374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104377:	89 10                	mov    %edx,(%eax)
	list_init(&free_list);
	nr_free = 0;
  104379:	c7 05 64 99 11 00 00 	movl   $0x0,0x119964
  104380:	00 00 00 
}
  104383:	90                   	nop
  104384:	c9                   	leave  
  104385:	c3                   	ret    

00104386 <default_init_memmap>:


//��Ϊdefault_pmm_manager�ĳ�Ա��������page_init���memmap���ÿ��map
static void
default_init_memmap(struct Page *base, size_t n) {
  104386:	55                   	push   %ebp
  104387:	89 e5                	mov    %esp,%ebp
  104389:	83 ec 38             	sub    $0x38,%esp
	assert(n > 0);
  10438c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104390:	75 16                	jne    1043a8 <default_init_memmap+0x22>
  104392:	68 d8 6a 10 00       	push   $0x106ad8
  104397:	68 de 6a 10 00       	push   $0x106ade
  10439c:	6a 4a                	push   $0x4a
  10439e:	68 f3 6a 10 00       	push   $0x106af3
  1043a3:	e8 35 c0 ff ff       	call   1003dd <__panic>
	struct Page *p = base;
  1043a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1043ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++) {
  1043ae:	e9 cb 00 00 00       	jmp    10447e <default_init_memmap+0xf8>
		assert(PageReserved(p));
  1043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043b6:	83 c0 04             	add    $0x4,%eax
  1043b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1043c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1043c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1043c9:	0f a3 10             	bt     %edx,(%eax)
  1043cc:	19 c0                	sbb    %eax,%eax
  1043ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1043d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1043d5:	0f 95 c0             	setne  %al
  1043d8:	0f b6 c0             	movzbl %al,%eax
  1043db:	85 c0                	test   %eax,%eax
  1043dd:	75 16                	jne    1043f5 <default_init_memmap+0x6f>
  1043df:	68 09 6b 10 00       	push   $0x106b09
  1043e4:	68 de 6a 10 00       	push   $0x106ade
  1043e9:	6a 4d                	push   $0x4d
  1043eb:	68 f3 6a 10 00       	push   $0x106af3
  1043f0:	e8 e8 bf ff ff       	call   1003dd <__panic>
		p->flags = 0;
  1043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
  1043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104402:	83 c0 04             	add    $0x4,%eax
  104405:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10440c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10440f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104412:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104415:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
  104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10441b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
  104422:	83 ec 08             	sub    $0x8,%esp
  104425:	6a 00                	push   $0x0
  104427:	ff 75 f4             	pushl  -0xc(%ebp)
  10442a:	e8 1b ff ff ff       	call   10434a <set_page_ref>
  10442f:	83 c4 10             	add    $0x10,%esp
		list_add_before(&free_list, &(p->page_link));
  104432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104435:	83 c0 0c             	add    $0xc,%eax
  104438:	c7 45 e4 5c 99 11 00 	movl   $0x11995c,-0x1c(%ebp)
  10443f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104445:	8b 00                	mov    (%eax),%eax
  104447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10444a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10444d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104453:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104456:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104459:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10445c:	89 10                	mov    %edx,(%eax)
  10445e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104461:	8b 10                	mov    (%eax),%edx
  104463:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104466:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10446c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10446f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104472:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104475:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104478:	89 10                	mov    %edx,(%eax)
	for (; p != base + n; p++) {
  10447a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10447e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104481:	89 d0                	mov    %edx,%eax
  104483:	c1 e0 02             	shl    $0x2,%eax
  104486:	01 d0                	add    %edx,%eax
  104488:	c1 e0 02             	shl    $0x2,%eax
  10448b:	89 c2                	mov    %eax,%edx
  10448d:	8b 45 08             	mov    0x8(%ebp),%eax
  104490:	01 d0                	add    %edx,%eax
  104492:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104495:	0f 85 18 ff ff ff    	jne    1043b3 <default_init_memmap+0x2d>
	}
	nr_free += n;
  10449b:	8b 15 64 99 11 00    	mov    0x119964,%edx
  1044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044a4:	01 d0                	add    %edx,%eax
  1044a6:	a3 64 99 11 00       	mov    %eax,0x119964
	base->property = n;
  1044ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044b1:	89 50 08             	mov    %edx,0x8(%eax)
}
  1044b4:	90                   	nop
  1044b5:	c9                   	leave  
  1044b6:	c3                   	ret    

001044b7 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1044b7:	55                   	push   %ebp
  1044b8:	89 e5                	mov    %esp,%ebp
  1044ba:	83 ec 58             	sub    $0x58,%esp
	//�߽�����
	assert(n > 0);
  1044bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1044c1:	75 16                	jne    1044d9 <default_alloc_pages+0x22>
  1044c3:	68 d8 6a 10 00       	push   $0x106ad8
  1044c8:	68 de 6a 10 00       	push   $0x106ade
  1044cd:	6a 5b                	push   $0x5b
  1044cf:	68 f3 6a 10 00       	push   $0x106af3
  1044d4:	e8 04 bf ff ff       	call   1003dd <__panic>
	//�����ܹ�����
	if (n > nr_free) {
  1044d9:	a1 64 99 11 00       	mov    0x119964,%eax
  1044de:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044e1:	76 0a                	jbe    1044ed <default_alloc_pages+0x36>
		return NULL;
  1044e3:	b8 00 00 00 00       	mov    $0x0,%eax
  1044e8:	e9 46 01 00 00       	jmp    104633 <default_alloc_pages+0x17c>
  1044ed:	c7 45 dc 5c 99 11 00 	movl   $0x11995c,-0x24(%ebp)
    return listelm->next;
  1044f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044f7:	8b 40 04             	mov    0x4(%eax),%eax
	}
	//���ܹ�
	list_entry_t *le = list_next(&free_list);
  1044fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
  1044fd:	e9 1f 01 00 00       	jmp    104621 <default_alloc_pages+0x16a>
		//ͨ��le����������Ѱ��һ����Ϊ�������п���ʼҳ������ҳ�����ڵ���n
		//����property�ķ�ʽ��Ҫ����offset
		struct Page *p = le2page(le, page_link);
  104502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104505:	83 e8 0c             	sub    $0xc,%eax
  104508:	89 45 e8             	mov    %eax,-0x18(%ebp)

		//�ҵ��㹻����
		if (p->property >= n) {
  10450b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10450e:	8b 40 08             	mov    0x8(%eax),%eax
  104511:	39 45 08             	cmp    %eax,0x8(%ebp)
  104514:	0f 87 f8 00 00 00    	ja     104612 <default_alloc_pages+0x15b>
			//��Ҫ����ģ��˴�>=n�����ܻ���ʣ���ҳ�����Ȱ�n������״̬��ժ����ʣ�µı�����������
			int iter = 0;
  10451a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			list_entry_t * cur_le = le;
  104521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104524:	89 45 ec             	mov    %eax,-0x14(%ebp)
			list_entry_t * next_le;
			while (iter < n) {
  104527:	eb 7c                	jmp    1045a5 <default_alloc_pages+0xee>
				struct Page * cur_p = le2page(cur_le, page_link);
  104529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10452c:	83 e8 0c             	sub    $0xc,%eax
  10452f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104535:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10453b:	8b 40 04             	mov    0x4(%eax),%eax
				next_le = list_next(cur_le);
  10453e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				SetPageReserved(cur_p);
  104541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104544:	83 c0 04             	add    $0x4,%eax
  104547:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  10454e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104551:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104554:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104557:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(cur_p);
  10455a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10455d:	83 c0 04             	add    $0x4,%eax
  104560:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104567:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10456a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10456d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104570:	0f b3 10             	btr    %edx,(%eax)
  104573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104576:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_del(listelm->prev, listelm->next);
  104579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10457c:	8b 40 04             	mov    0x4(%eax),%eax
  10457f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104582:	8b 12                	mov    (%edx),%edx
  104584:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104587:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10458a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10458d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104590:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104593:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104599:	89 10                	mov    %edx,(%eax)
				list_del(cur_le);
				cur_le = next_le;
  10459b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10459e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				iter++;
  1045a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			while (iter < n) {
  1045a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a8:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045ab:	0f 87 78 ff ff ff    	ja     104529 <default_alloc_pages+0x72>
			}
			//��ʱn�����Ѿ��������
			//���>n����ôcur_le������������ͷ
			if (p->property > n) {
  1045b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045b4:	8b 40 08             	mov    0x8(%eax),%eax
  1045b7:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045ba:	73 12                	jae    1045ce <default_alloc_pages+0x117>
				(le2page(cur_le, page_link))->property = p->property - n;
  1045bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045bf:	8b 40 08             	mov    0x8(%eax),%eax
  1045c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1045c5:	83 ea 0c             	sub    $0xc,%edx
  1045c8:	2b 45 08             	sub    0x8(%ebp),%eax
  1045cb:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
  1045ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045d1:	83 c0 04             	add    $0x4,%eax
  1045d4:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  1045db:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1045de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1045e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1045e4:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
  1045e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045ea:	83 c0 04             	add    $0x4,%eax
  1045ed:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  1045f4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1045f7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1045fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1045fd:	0f ab 10             	bts    %edx,(%eax)
			nr_free -= n;
  104600:	a1 64 99 11 00       	mov    0x119964,%eax
  104605:	2b 45 08             	sub    0x8(%ebp),%eax
  104608:	a3 64 99 11 00       	mov    %eax,0x119964
			return p;
  10460d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104610:	eb 21                	jmp    104633 <default_alloc_pages+0x17c>
  104612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104615:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return listelm->next;
  104618:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10461b:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  10461e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
  104621:	81 7d f4 5c 99 11 00 	cmpl   $0x11995c,-0xc(%ebp)
  104628:	0f 85 d4 fe ff ff    	jne    104502 <default_alloc_pages+0x4b>
	}
	return NULL;
  10462e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104633:	c9                   	leave  
  104634:	c3                   	ret    

00104635 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104635:	55                   	push   %ebp
  104636:	89 e5                	mov    %esp,%ebp
  104638:	83 ec 68             	sub    $0x68,%esp
assert(n > 0);
  10463b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10463f:	75 19                	jne    10465a <default_free_pages+0x25>
  104641:	68 d8 6a 10 00       	push   $0x106ad8
  104646:	68 de 6a 10 00       	push   $0x106ade
  10464b:	68 87 00 00 00       	push   $0x87
  104650:	68 f3 6a 10 00       	push   $0x106af3
  104655:	e8 83 bd ff ff       	call   1003dd <__panic>
	assert(PageReserved(base));
  10465a:	8b 45 08             	mov    0x8(%ebp),%eax
  10465d:	83 c0 04             	add    $0x4,%eax
  104660:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104667:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10466a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10466d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104670:	0f a3 10             	bt     %edx,(%eax)
  104673:	19 c0                	sbb    %eax,%eax
  104675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  104678:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  10467c:	0f 95 c0             	setne  %al
  10467f:	0f b6 c0             	movzbl %al,%eax
  104682:	85 c0                	test   %eax,%eax
  104684:	75 19                	jne    10469f <default_free_pages+0x6a>
  104686:	68 19 6b 10 00       	push   $0x106b19
  10468b:	68 de 6a 10 00       	push   $0x106ade
  104690:	68 88 00 00 00       	push   $0x88
  104695:	68 f3 6a 10 00       	push   $0x106af3
  10469a:	e8 3e bd ff ff       	call   1003dd <__panic>
	list_entry_t *le = &free_list;
  10469f:	c7 45 f4 5c 99 11 00 	movl   $0x11995c,-0xc(%ebp)
  1046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1046ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046af:	8b 40 04             	mov    0x4(%eax),%eax
	struct Page* p;
	list_entry_t* insert_position;

	le = list_next(le);
  1046b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
  1046b5:	eb 20                	jmp    1046d7 <default_free_pages+0xa2>
	    p = le2page(le, page_link);
  1046b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ba:	83 e8 0c             	sub    $0xc,%eax
  1046bd:	89 45 f0             	mov    %eax,-0x10(%ebp)

		if (p > base) {
  1046c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  1046c6:	77 1a                	ja     1046e2 <default_free_pages+0xad>
  1046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1046ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1046d1:	8b 40 04             	mov    0x4(%eax),%eax
			break;
		}
		le = list_next(le);
  1046d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (le != &free_list) {
  1046d7:	81 7d f4 5c 99 11 00 	cmpl   $0x11995c,-0xc(%ebp)
  1046de:	75 d7                	jne    1046b7 <default_free_pages+0x82>
  1046e0:	eb 01                	jmp    1046e3 <default_free_pages+0xae>
			break;
  1046e2:	90                   	nop
	}
	insert_position = le;
  1046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (unsigned int iter = 0; iter < n; iter++) {
  1046e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1046f0:	eb 62                	jmp    104754 <default_free_pages+0x11f>
		struct Page* cur_p = base + iter;
  1046f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1046f5:	89 d0                	mov    %edx,%eax
  1046f7:	c1 e0 02             	shl    $0x2,%eax
  1046fa:	01 d0                	add    %edx,%eax
  1046fc:	c1 e0 02             	shl    $0x2,%eax
  1046ff:	89 c2                	mov    %eax,%edx
  104701:	8b 45 08             	mov    0x8(%ebp),%eax
  104704:	01 d0                	add    %edx,%eax
  104706:	89 45 e0             	mov    %eax,-0x20(%ebp)
		list_add_before(insert_position, &(cur_p->page_link));
  104709:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10470c:	8d 50 0c             	lea    0xc(%eax),%edx
  10470f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104712:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104715:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104718:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10471b:	8b 00                	mov    (%eax),%eax
  10471d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104720:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104723:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104726:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104729:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next->prev = elm;
  10472c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10472f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104732:	89 10                	mov    %edx,(%eax)
  104734:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104737:	8b 10                	mov    (%eax),%edx
  104739:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10473c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10473f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104742:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104745:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104748:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10474b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10474e:	89 10                	mov    %edx,(%eax)
	for (unsigned int iter = 0; iter < n; iter++) {
  104750:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  104754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104757:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10475a:	72 96                	jb     1046f2 <default_free_pages+0xbd>
	}
    	base->flags = 0;
  10475c:	8b 45 08             	mov    0x8(%ebp),%eax
  10475f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	set_page_ref(base, 0);
  104766:	83 ec 08             	sub    $0x8,%esp
  104769:	6a 00                	push   $0x0
  10476b:	ff 75 08             	pushl  0x8(%ebp)
  10476e:	e8 d7 fb ff ff       	call   10434a <set_page_ref>
  104773:	83 c4 10             	add    $0x10,%esp
    	ClearPageProperty(base);
  104776:	8b 45 08             	mov    0x8(%ebp),%eax
  104779:	83 c0 04             	add    $0x4,%eax
  10477c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104783:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104786:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104789:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10478c:	0f b3 10             	btr    %edx,(%eax)
    	SetPageProperty(base);
  10478f:	8b 45 08             	mov    0x8(%ebp),%eax
  104792:	83 c0 04             	add    $0x4,%eax
  104795:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  10479c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10479f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1047a2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1047a5:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;
  1047a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047ae:	89 50 08             	mov    %edx,0x8(%eax)

	struct Page* insert_p = le2page(insert_position, page_link);
  1047b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047b4:	83 e8 0c             	sub    $0xc,%eax
  1047b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	//back connected
	if (base + n == insert_p) {
  1047ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047bd:	89 d0                	mov    %edx,%eax
  1047bf:	c1 e0 02             	shl    $0x2,%eax
  1047c2:	01 d0                	add    %edx,%eax
  1047c4:	c1 e0 02             	shl    $0x2,%eax
  1047c7:	89 c2                	mov    %eax,%edx
  1047c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1047cc:	01 d0                	add    %edx,%eax
  1047ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1047d1:	75 1b                	jne    1047ee <default_free_pages+0x1b9>
		base->property = n + insert_p->property;
  1047d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047d6:	8b 50 08             	mov    0x8(%eax),%edx
  1047d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047dc:	01 c2                	add    %eax,%edx
  1047de:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e1:	89 50 08             	mov    %edx,0x8(%eax)
		insert_p->property = 0;
  1047e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}


	//prev connected
	le = list_prev(&(base->page_link));
  1047ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f1:	83 c0 0c             	add    $0xc,%eax
  1047f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return listelm->prev;
  1047f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1047fa:	8b 00                	mov    (%eax),%eax
  1047fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
  1047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104802:	83 e8 0c             	sub    $0xc,%eax
  104805:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(le!=&free_list && p==base-1){
  104808:	81 7d f4 5c 99 11 00 	cmpl   $0x11995c,-0xc(%ebp)
  10480f:	74 57                	je     104868 <default_free_pages+0x233>
  104811:	8b 45 08             	mov    0x8(%ebp),%eax
  104814:	83 e8 14             	sub    $0x14,%eax
  104817:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10481a:	75 4c                	jne    104868 <default_free_pages+0x233>
	      while(le!=&free_list){
  10481c:	eb 41                	jmp    10485f <default_free_pages+0x22a>
		if(p->property){
  10481e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104821:	8b 40 08             	mov    0x8(%eax),%eax
  104824:	85 c0                	test   %eax,%eax
  104826:	74 20                	je     104848 <default_free_pages+0x213>
		  p->property += base->property;
  104828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10482b:	8b 50 08             	mov    0x8(%eax),%edx
  10482e:	8b 45 08             	mov    0x8(%ebp),%eax
  104831:	8b 40 08             	mov    0x8(%eax),%eax
  104834:	01 c2                	add    %eax,%edx
  104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104839:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
  10483c:	8b 45 08             	mov    0x8(%ebp),%eax
  10483f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
  104846:	eb 20                	jmp    104868 <default_free_pages+0x233>
  104848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10484b:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10484e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104851:	8b 00                	mov    (%eax),%eax
		}
		le = list_prev(le);
  104853:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
  104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104859:	83 e8 0c             	sub    $0xc,%eax
  10485c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	      while(le!=&free_list){
  10485f:	81 7d f4 5c 99 11 00 	cmpl   $0x11995c,-0xc(%ebp)
  104866:	75 b6                	jne    10481e <default_free_pages+0x1e9>
	      }
	}
	nr_free += n;
  104868:	8b 15 64 99 11 00    	mov    0x119964,%edx
  10486e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104871:	01 d0                	add    %edx,%eax
  104873:	a3 64 99 11 00       	mov    %eax,0x119964
	return;
  104878:	90                   	nop
}
  104879:	c9                   	leave  
  10487a:	c3                   	ret    

0010487b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10487b:	55                   	push   %ebp
  10487c:	89 e5                	mov    %esp,%ebp
	return nr_free;
  10487e:	a1 64 99 11 00       	mov    0x119964,%eax
}
  104883:	5d                   	pop    %ebp
  104884:	c3                   	ret    

00104885 <basic_check>:

static void
basic_check(void) {
  104885:	55                   	push   %ebp
  104886:	89 e5                	mov    %esp,%ebp
  104888:	83 ec 38             	sub    $0x38,%esp
	struct Page *p0, *p1, *p2;
	p0 = p1 = p2 = NULL;
  10488b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10489b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	assert((p0 = alloc_page()) != NULL);
  10489e:	83 ec 0c             	sub    $0xc,%esp
  1048a1:	6a 01                	push   $0x1
  1048a3:	e8 3c e5 ff ff       	call   102de4 <alloc_pages>
  1048a8:	83 c4 10             	add    $0x10,%esp
  1048ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1048ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1048b2:	75 19                	jne    1048cd <basic_check+0x48>
  1048b4:	68 2c 6b 10 00       	push   $0x106b2c
  1048b9:	68 de 6a 10 00       	push   $0x106ade
  1048be:	68 c4 00 00 00       	push   $0xc4
  1048c3:	68 f3 6a 10 00       	push   $0x106af3
  1048c8:	e8 10 bb ff ff       	call   1003dd <__panic>
	assert((p1 = alloc_page()) != NULL);
  1048cd:	83 ec 0c             	sub    $0xc,%esp
  1048d0:	6a 01                	push   $0x1
  1048d2:	e8 0d e5 ff ff       	call   102de4 <alloc_pages>
  1048d7:	83 c4 10             	add    $0x10,%esp
  1048da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048e1:	75 19                	jne    1048fc <basic_check+0x77>
  1048e3:	68 48 6b 10 00       	push   $0x106b48
  1048e8:	68 de 6a 10 00       	push   $0x106ade
  1048ed:	68 c5 00 00 00       	push   $0xc5
  1048f2:	68 f3 6a 10 00       	push   $0x106af3
  1048f7:	e8 e1 ba ff ff       	call   1003dd <__panic>
	assert((p2 = alloc_page()) != NULL);
  1048fc:	83 ec 0c             	sub    $0xc,%esp
  1048ff:	6a 01                	push   $0x1
  104901:	e8 de e4 ff ff       	call   102de4 <alloc_pages>
  104906:	83 c4 10             	add    $0x10,%esp
  104909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10490c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104910:	75 19                	jne    10492b <basic_check+0xa6>
  104912:	68 64 6b 10 00       	push   $0x106b64
  104917:	68 de 6a 10 00       	push   $0x106ade
  10491c:	68 c6 00 00 00       	push   $0xc6
  104921:	68 f3 6a 10 00       	push   $0x106af3
  104926:	e8 b2 ba ff ff       	call   1003dd <__panic>

	assert(p0 != p1 && p0 != p2 && p1 != p2);
  10492b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10492e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104931:	74 10                	je     104943 <basic_check+0xbe>
  104933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104936:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104939:	74 08                	je     104943 <basic_check+0xbe>
  10493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10493e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104941:	75 19                	jne    10495c <basic_check+0xd7>
  104943:	68 80 6b 10 00       	push   $0x106b80
  104948:	68 de 6a 10 00       	push   $0x106ade
  10494d:	68 c8 00 00 00       	push   $0xc8
  104952:	68 f3 6a 10 00       	push   $0x106af3
  104957:	e8 81 ba ff ff       	call   1003dd <__panic>
	assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10495c:	83 ec 0c             	sub    $0xc,%esp
  10495f:	ff 75 ec             	pushl  -0x14(%ebp)
  104962:	e8 d9 f9 ff ff       	call   104340 <page_ref>
  104967:	83 c4 10             	add    $0x10,%esp
  10496a:	85 c0                	test   %eax,%eax
  10496c:	75 24                	jne    104992 <basic_check+0x10d>
  10496e:	83 ec 0c             	sub    $0xc,%esp
  104971:	ff 75 f0             	pushl  -0x10(%ebp)
  104974:	e8 c7 f9 ff ff       	call   104340 <page_ref>
  104979:	83 c4 10             	add    $0x10,%esp
  10497c:	85 c0                	test   %eax,%eax
  10497e:	75 12                	jne    104992 <basic_check+0x10d>
  104980:	83 ec 0c             	sub    $0xc,%esp
  104983:	ff 75 f4             	pushl  -0xc(%ebp)
  104986:	e8 b5 f9 ff ff       	call   104340 <page_ref>
  10498b:	83 c4 10             	add    $0x10,%esp
  10498e:	85 c0                	test   %eax,%eax
  104990:	74 19                	je     1049ab <basic_check+0x126>
  104992:	68 a4 6b 10 00       	push   $0x106ba4
  104997:	68 de 6a 10 00       	push   $0x106ade
  10499c:	68 c9 00 00 00       	push   $0xc9
  1049a1:	68 f3 6a 10 00       	push   $0x106af3
  1049a6:	e8 32 ba ff ff       	call   1003dd <__panic>

	assert(page2pa(p0) < npage * PGSIZE);
  1049ab:	83 ec 0c             	sub    $0xc,%esp
  1049ae:	ff 75 ec             	pushl  -0x14(%ebp)
  1049b1:	e8 77 f9 ff ff       	call   10432d <page2pa>
  1049b6:	83 c4 10             	add    $0x10,%esp
  1049b9:	89 c2                	mov    %eax,%edx
  1049bb:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1049c0:	c1 e0 0c             	shl    $0xc,%eax
  1049c3:	39 c2                	cmp    %eax,%edx
  1049c5:	72 19                	jb     1049e0 <basic_check+0x15b>
  1049c7:	68 e0 6b 10 00       	push   $0x106be0
  1049cc:	68 de 6a 10 00       	push   $0x106ade
  1049d1:	68 cb 00 00 00       	push   $0xcb
  1049d6:	68 f3 6a 10 00       	push   $0x106af3
  1049db:	e8 fd b9 ff ff       	call   1003dd <__panic>
	assert(page2pa(p1) < npage * PGSIZE);
  1049e0:	83 ec 0c             	sub    $0xc,%esp
  1049e3:	ff 75 f0             	pushl  -0x10(%ebp)
  1049e6:	e8 42 f9 ff ff       	call   10432d <page2pa>
  1049eb:	83 c4 10             	add    $0x10,%esp
  1049ee:	89 c2                	mov    %eax,%edx
  1049f0:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1049f5:	c1 e0 0c             	shl    $0xc,%eax
  1049f8:	39 c2                	cmp    %eax,%edx
  1049fa:	72 19                	jb     104a15 <basic_check+0x190>
  1049fc:	68 fd 6b 10 00       	push   $0x106bfd
  104a01:	68 de 6a 10 00       	push   $0x106ade
  104a06:	68 cc 00 00 00       	push   $0xcc
  104a0b:	68 f3 6a 10 00       	push   $0x106af3
  104a10:	e8 c8 b9 ff ff       	call   1003dd <__panic>
	assert(page2pa(p2) < npage * PGSIZE);
  104a15:	83 ec 0c             	sub    $0xc,%esp
  104a18:	ff 75 f4             	pushl  -0xc(%ebp)
  104a1b:	e8 0d f9 ff ff       	call   10432d <page2pa>
  104a20:	83 c4 10             	add    $0x10,%esp
  104a23:	89 c2                	mov    %eax,%edx
  104a25:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  104a2a:	c1 e0 0c             	shl    $0xc,%eax
  104a2d:	39 c2                	cmp    %eax,%edx
  104a2f:	72 19                	jb     104a4a <basic_check+0x1c5>
  104a31:	68 1a 6c 10 00       	push   $0x106c1a
  104a36:	68 de 6a 10 00       	push   $0x106ade
  104a3b:	68 cd 00 00 00       	push   $0xcd
  104a40:	68 f3 6a 10 00       	push   $0x106af3
  104a45:	e8 93 b9 ff ff       	call   1003dd <__panic>

	list_entry_t free_list_store = free_list;
  104a4a:	a1 5c 99 11 00       	mov    0x11995c,%eax
  104a4f:	8b 15 60 99 11 00    	mov    0x119960,%edx
  104a55:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104a58:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a5b:	c7 45 dc 5c 99 11 00 	movl   $0x11995c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104a68:	89 50 04             	mov    %edx,0x4(%eax)
  104a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a6e:	8b 50 04             	mov    0x4(%eax),%edx
  104a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a74:	89 10                	mov    %edx,(%eax)
  104a76:	c7 45 e0 5c 99 11 00 	movl   $0x11995c,-0x20(%ebp)
    return list->next == list;
  104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a80:	8b 40 04             	mov    0x4(%eax),%eax
  104a83:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104a86:	0f 94 c0             	sete   %al
  104a89:	0f b6 c0             	movzbl %al,%eax
	list_init(&free_list);
	assert(list_empty(&free_list));
  104a8c:	85 c0                	test   %eax,%eax
  104a8e:	75 19                	jne    104aa9 <basic_check+0x224>
  104a90:	68 37 6c 10 00       	push   $0x106c37
  104a95:	68 de 6a 10 00       	push   $0x106ade
  104a9a:	68 d1 00 00 00       	push   $0xd1
  104a9f:	68 f3 6a 10 00       	push   $0x106af3
  104aa4:	e8 34 b9 ff ff       	call   1003dd <__panic>

	unsigned int nr_free_store = nr_free;
  104aa9:	a1 64 99 11 00       	mov    0x119964,%eax
  104aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nr_free = 0;
  104ab1:	c7 05 64 99 11 00 00 	movl   $0x0,0x119964
  104ab8:	00 00 00 

	assert(alloc_page() == NULL);
  104abb:	83 ec 0c             	sub    $0xc,%esp
  104abe:	6a 01                	push   $0x1
  104ac0:	e8 1f e3 ff ff       	call   102de4 <alloc_pages>
  104ac5:	83 c4 10             	add    $0x10,%esp
  104ac8:	85 c0                	test   %eax,%eax
  104aca:	74 19                	je     104ae5 <basic_check+0x260>
  104acc:	68 4e 6c 10 00       	push   $0x106c4e
  104ad1:	68 de 6a 10 00       	push   $0x106ade
  104ad6:	68 d6 00 00 00       	push   $0xd6
  104adb:	68 f3 6a 10 00       	push   $0x106af3
  104ae0:	e8 f8 b8 ff ff       	call   1003dd <__panic>

	free_page(p0);
  104ae5:	83 ec 08             	sub    $0x8,%esp
  104ae8:	6a 01                	push   $0x1
  104aea:	ff 75 ec             	pushl  -0x14(%ebp)
  104aed:	e8 30 e3 ff ff       	call   102e22 <free_pages>
  104af2:	83 c4 10             	add    $0x10,%esp
	free_page(p1);
  104af5:	83 ec 08             	sub    $0x8,%esp
  104af8:	6a 01                	push   $0x1
  104afa:	ff 75 f0             	pushl  -0x10(%ebp)
  104afd:	e8 20 e3 ff ff       	call   102e22 <free_pages>
  104b02:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
  104b05:	83 ec 08             	sub    $0x8,%esp
  104b08:	6a 01                	push   $0x1
  104b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  104b0d:	e8 10 e3 ff ff       	call   102e22 <free_pages>
  104b12:	83 c4 10             	add    $0x10,%esp
	assert(nr_free == 3);
  104b15:	a1 64 99 11 00       	mov    0x119964,%eax
  104b1a:	83 f8 03             	cmp    $0x3,%eax
  104b1d:	74 19                	je     104b38 <basic_check+0x2b3>
  104b1f:	68 63 6c 10 00       	push   $0x106c63
  104b24:	68 de 6a 10 00       	push   $0x106ade
  104b29:	68 db 00 00 00       	push   $0xdb
  104b2e:	68 f3 6a 10 00       	push   $0x106af3
  104b33:	e8 a5 b8 ff ff       	call   1003dd <__panic>

	assert((p0 = alloc_page()) != NULL);
  104b38:	83 ec 0c             	sub    $0xc,%esp
  104b3b:	6a 01                	push   $0x1
  104b3d:	e8 a2 e2 ff ff       	call   102de4 <alloc_pages>
  104b42:	83 c4 10             	add    $0x10,%esp
  104b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b4c:	75 19                	jne    104b67 <basic_check+0x2e2>
  104b4e:	68 2c 6b 10 00       	push   $0x106b2c
  104b53:	68 de 6a 10 00       	push   $0x106ade
  104b58:	68 dd 00 00 00       	push   $0xdd
  104b5d:	68 f3 6a 10 00       	push   $0x106af3
  104b62:	e8 76 b8 ff ff       	call   1003dd <__panic>
	assert((p1 = alloc_page()) != NULL);
  104b67:	83 ec 0c             	sub    $0xc,%esp
  104b6a:	6a 01                	push   $0x1
  104b6c:	e8 73 e2 ff ff       	call   102de4 <alloc_pages>
  104b71:	83 c4 10             	add    $0x10,%esp
  104b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b7b:	75 19                	jne    104b96 <basic_check+0x311>
  104b7d:	68 48 6b 10 00       	push   $0x106b48
  104b82:	68 de 6a 10 00       	push   $0x106ade
  104b87:	68 de 00 00 00       	push   $0xde
  104b8c:	68 f3 6a 10 00       	push   $0x106af3
  104b91:	e8 47 b8 ff ff       	call   1003dd <__panic>
	assert((p2 = alloc_page()) != NULL);
  104b96:	83 ec 0c             	sub    $0xc,%esp
  104b99:	6a 01                	push   $0x1
  104b9b:	e8 44 e2 ff ff       	call   102de4 <alloc_pages>
  104ba0:	83 c4 10             	add    $0x10,%esp
  104ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104baa:	75 19                	jne    104bc5 <basic_check+0x340>
  104bac:	68 64 6b 10 00       	push   $0x106b64
  104bb1:	68 de 6a 10 00       	push   $0x106ade
  104bb6:	68 df 00 00 00       	push   $0xdf
  104bbb:	68 f3 6a 10 00       	push   $0x106af3
  104bc0:	e8 18 b8 ff ff       	call   1003dd <__panic>

	assert(alloc_page() == NULL);
  104bc5:	83 ec 0c             	sub    $0xc,%esp
  104bc8:	6a 01                	push   $0x1
  104bca:	e8 15 e2 ff ff       	call   102de4 <alloc_pages>
  104bcf:	83 c4 10             	add    $0x10,%esp
  104bd2:	85 c0                	test   %eax,%eax
  104bd4:	74 19                	je     104bef <basic_check+0x36a>
  104bd6:	68 4e 6c 10 00       	push   $0x106c4e
  104bdb:	68 de 6a 10 00       	push   $0x106ade
  104be0:	68 e1 00 00 00       	push   $0xe1
  104be5:	68 f3 6a 10 00       	push   $0x106af3
  104bea:	e8 ee b7 ff ff       	call   1003dd <__panic>

	free_page(p0);
  104bef:	83 ec 08             	sub    $0x8,%esp
  104bf2:	6a 01                	push   $0x1
  104bf4:	ff 75 ec             	pushl  -0x14(%ebp)
  104bf7:	e8 26 e2 ff ff       	call   102e22 <free_pages>
  104bfc:	83 c4 10             	add    $0x10,%esp
  104bff:	c7 45 d8 5c 99 11 00 	movl   $0x11995c,-0x28(%ebp)
  104c06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c09:	8b 40 04             	mov    0x4(%eax),%eax
  104c0c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104c0f:	0f 94 c0             	sete   %al
  104c12:	0f b6 c0             	movzbl %al,%eax
	assert(!list_empty(&free_list));
  104c15:	85 c0                	test   %eax,%eax
  104c17:	74 19                	je     104c32 <basic_check+0x3ad>
  104c19:	68 70 6c 10 00       	push   $0x106c70
  104c1e:	68 de 6a 10 00       	push   $0x106ade
  104c23:	68 e4 00 00 00       	push   $0xe4
  104c28:	68 f3 6a 10 00       	push   $0x106af3
  104c2d:	e8 ab b7 ff ff       	call   1003dd <__panic>

	struct Page *p;
	assert((p = alloc_page()) == p0);
  104c32:	83 ec 0c             	sub    $0xc,%esp
  104c35:	6a 01                	push   $0x1
  104c37:	e8 a8 e1 ff ff       	call   102de4 <alloc_pages>
  104c3c:	83 c4 10             	add    $0x10,%esp
  104c3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104c48:	74 19                	je     104c63 <basic_check+0x3de>
  104c4a:	68 88 6c 10 00       	push   $0x106c88
  104c4f:	68 de 6a 10 00       	push   $0x106ade
  104c54:	68 e7 00 00 00       	push   $0xe7
  104c59:	68 f3 6a 10 00       	push   $0x106af3
  104c5e:	e8 7a b7 ff ff       	call   1003dd <__panic>
	assert(alloc_page() == NULL);
  104c63:	83 ec 0c             	sub    $0xc,%esp
  104c66:	6a 01                	push   $0x1
  104c68:	e8 77 e1 ff ff       	call   102de4 <alloc_pages>
  104c6d:	83 c4 10             	add    $0x10,%esp
  104c70:	85 c0                	test   %eax,%eax
  104c72:	74 19                	je     104c8d <basic_check+0x408>
  104c74:	68 4e 6c 10 00       	push   $0x106c4e
  104c79:	68 de 6a 10 00       	push   $0x106ade
  104c7e:	68 e8 00 00 00       	push   $0xe8
  104c83:	68 f3 6a 10 00       	push   $0x106af3
  104c88:	e8 50 b7 ff ff       	call   1003dd <__panic>

	assert(nr_free == 0);
  104c8d:	a1 64 99 11 00       	mov    0x119964,%eax
  104c92:	85 c0                	test   %eax,%eax
  104c94:	74 19                	je     104caf <basic_check+0x42a>
  104c96:	68 a1 6c 10 00       	push   $0x106ca1
  104c9b:	68 de 6a 10 00       	push   $0x106ade
  104ca0:	68 ea 00 00 00       	push   $0xea
  104ca5:	68 f3 6a 10 00       	push   $0x106af3
  104caa:	e8 2e b7 ff ff       	call   1003dd <__panic>
	free_list = free_list_store;
  104caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104cb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104cb5:	a3 5c 99 11 00       	mov    %eax,0x11995c
  104cba:	89 15 60 99 11 00    	mov    %edx,0x119960
	nr_free = nr_free_store;
  104cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104cc3:	a3 64 99 11 00       	mov    %eax,0x119964

	free_page(p);
  104cc8:	83 ec 08             	sub    $0x8,%esp
  104ccb:	6a 01                	push   $0x1
  104ccd:	ff 75 e4             	pushl  -0x1c(%ebp)
  104cd0:	e8 4d e1 ff ff       	call   102e22 <free_pages>
  104cd5:	83 c4 10             	add    $0x10,%esp
	free_page(p1);
  104cd8:	83 ec 08             	sub    $0x8,%esp
  104cdb:	6a 01                	push   $0x1
  104cdd:	ff 75 f0             	pushl  -0x10(%ebp)
  104ce0:	e8 3d e1 ff ff       	call   102e22 <free_pages>
  104ce5:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
  104ce8:	83 ec 08             	sub    $0x8,%esp
  104ceb:	6a 01                	push   $0x1
  104ced:	ff 75 f4             	pushl  -0xc(%ebp)
  104cf0:	e8 2d e1 ff ff       	call   102e22 <free_pages>
  104cf5:	83 c4 10             	add    $0x10,%esp
}
  104cf8:	90                   	nop
  104cf9:	c9                   	leave  
  104cfa:	c3                   	ret    

00104cfb <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104cfb:	55                   	push   %ebp
  104cfc:	89 e5                	mov    %esp,%ebp
  104cfe:	81 ec 88 00 00 00    	sub    $0x88,%esp
	int count = 0, total = 0;
  104d04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	list_entry_t *le = &free_list;
  104d12:	c7 45 ec 5c 99 11 00 	movl   $0x11995c,-0x14(%ebp)
	//����������������Ƿ�ÿ��page��propertyλ����1��ʾ����
	while ((le = list_next(le)) != &free_list) {
  104d19:	eb 60                	jmp    104d7b <default_check+0x80>
		struct Page *p = le2page(le, page_link);
  104d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d1e:	83 e8 0c             	sub    $0xc,%eax
  104d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(PageProperty(p));
  104d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d27:	83 c0 04             	add    $0x4,%eax
  104d2a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104d31:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104d37:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104d3a:	0f a3 10             	bt     %edx,(%eax)
  104d3d:	19 c0                	sbb    %eax,%eax
  104d3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104d42:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104d46:	0f 95 c0             	setne  %al
  104d49:	0f b6 c0             	movzbl %al,%eax
  104d4c:	85 c0                	test   %eax,%eax
  104d4e:	75 19                	jne    104d69 <default_check+0x6e>
  104d50:	68 ae 6c 10 00       	push   $0x106cae
  104d55:	68 de 6a 10 00       	push   $0x106ade
  104d5a:	68 fc 00 00 00       	push   $0xfc
  104d5f:	68 f3 6a 10 00       	push   $0x106af3
  104d64:	e8 74 b6 ff ff       	call   1003dd <__panic>
		count++, total += p->property;
  104d69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d70:	8b 50 08             	mov    0x8(%eax),%edx
  104d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d76:	01 d0                	add    %edx,%eax
  104d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104d81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d84:	8b 40 04             	mov    0x4(%eax),%eax
	while ((le = list_next(le)) != &free_list) {
  104d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d8a:	81 7d ec 5c 99 11 00 	cmpl   $0x11995c,-0x14(%ebp)
  104d91:	75 88                	jne    104d1b <default_check+0x20>
	}
	assert(total == nr_free_pages());
  104d93:	e8 bf e0 ff ff       	call   102e57 <nr_free_pages>
  104d98:	89 c2                	mov    %eax,%edx
  104d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d9d:	39 c2                	cmp    %eax,%edx
  104d9f:	74 19                	je     104dba <default_check+0xbf>
  104da1:	68 be 6c 10 00       	push   $0x106cbe
  104da6:	68 de 6a 10 00       	push   $0x106ade
  104dab:	68 ff 00 00 00       	push   $0xff
  104db0:	68 f3 6a 10 00       	push   $0x106af3
  104db5:	e8 23 b6 ff ff       	call   1003dd <__panic>

	basic_check();
  104dba:	e8 c6 fa ff ff       	call   104885 <basic_check>

	struct Page *p0 = alloc_pages(5), *p1, *p2;
  104dbf:	83 ec 0c             	sub    $0xc,%esp
  104dc2:	6a 05                	push   $0x5
  104dc4:	e8 1b e0 ff ff       	call   102de4 <alloc_pages>
  104dc9:	83 c4 10             	add    $0x10,%esp
  104dcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	assert(p0 != NULL);
  104dcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104dd3:	75 19                	jne    104dee <default_check+0xf3>
  104dd5:	68 d7 6c 10 00       	push   $0x106cd7
  104dda:	68 de 6a 10 00       	push   $0x106ade
  104ddf:	68 04 01 00 00       	push   $0x104
  104de4:	68 f3 6a 10 00       	push   $0x106af3
  104de9:	e8 ef b5 ff ff       	call   1003dd <__panic>
	assert(!PageProperty(p0));
  104dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104df1:	83 c0 04             	add    $0x4,%eax
  104df4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104dfb:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104dfe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104e01:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104e04:	0f a3 10             	bt     %edx,(%eax)
  104e07:	19 c0                	sbb    %eax,%eax
  104e09:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104e0c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104e10:	0f 95 c0             	setne  %al
  104e13:	0f b6 c0             	movzbl %al,%eax
  104e16:	85 c0                	test   %eax,%eax
  104e18:	74 19                	je     104e33 <default_check+0x138>
  104e1a:	68 e2 6c 10 00       	push   $0x106ce2
  104e1f:	68 de 6a 10 00       	push   $0x106ade
  104e24:	68 05 01 00 00       	push   $0x105
  104e29:	68 f3 6a 10 00       	push   $0x106af3
  104e2e:	e8 aa b5 ff ff       	call   1003dd <__panic>

	list_entry_t free_list_store = free_list;
  104e33:	a1 5c 99 11 00       	mov    0x11995c,%eax
  104e38:	8b 15 60 99 11 00    	mov    0x119960,%edx
  104e3e:	89 45 80             	mov    %eax,-0x80(%ebp)
  104e41:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104e44:	c7 45 b0 5c 99 11 00 	movl   $0x11995c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104e4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104e4e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104e51:	89 50 04             	mov    %edx,0x4(%eax)
  104e54:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104e57:	8b 50 04             	mov    0x4(%eax),%edx
  104e5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104e5d:	89 10                	mov    %edx,(%eax)
  104e5f:	c7 45 b4 5c 99 11 00 	movl   $0x11995c,-0x4c(%ebp)
    return list->next == list;
  104e66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104e69:	8b 40 04             	mov    0x4(%eax),%eax
  104e6c:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104e6f:	0f 94 c0             	sete   %al
  104e72:	0f b6 c0             	movzbl %al,%eax
	list_init(&free_list);
	assert(list_empty(&free_list));
  104e75:	85 c0                	test   %eax,%eax
  104e77:	75 19                	jne    104e92 <default_check+0x197>
  104e79:	68 37 6c 10 00       	push   $0x106c37
  104e7e:	68 de 6a 10 00       	push   $0x106ade
  104e83:	68 09 01 00 00       	push   $0x109
  104e88:	68 f3 6a 10 00       	push   $0x106af3
  104e8d:	e8 4b b5 ff ff       	call   1003dd <__panic>
	assert(alloc_page() == NULL);
  104e92:	83 ec 0c             	sub    $0xc,%esp
  104e95:	6a 01                	push   $0x1
  104e97:	e8 48 df ff ff       	call   102de4 <alloc_pages>
  104e9c:	83 c4 10             	add    $0x10,%esp
  104e9f:	85 c0                	test   %eax,%eax
  104ea1:	74 19                	je     104ebc <default_check+0x1c1>
  104ea3:	68 4e 6c 10 00       	push   $0x106c4e
  104ea8:	68 de 6a 10 00       	push   $0x106ade
  104ead:	68 0a 01 00 00       	push   $0x10a
  104eb2:	68 f3 6a 10 00       	push   $0x106af3
  104eb7:	e8 21 b5 ff ff       	call   1003dd <__panic>

	unsigned int nr_free_store = nr_free;
  104ebc:	a1 64 99 11 00       	mov    0x119964,%eax
  104ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	nr_free = 0;
  104ec4:	c7 05 64 99 11 00 00 	movl   $0x0,0x119964
  104ecb:	00 00 00 

	free_pages(p0 + 2, 3);
  104ece:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ed1:	83 c0 28             	add    $0x28,%eax
  104ed4:	83 ec 08             	sub    $0x8,%esp
  104ed7:	6a 03                	push   $0x3
  104ed9:	50                   	push   %eax
  104eda:	e8 43 df ff ff       	call   102e22 <free_pages>
  104edf:	83 c4 10             	add    $0x10,%esp
	assert(alloc_pages(4) == NULL);
  104ee2:	83 ec 0c             	sub    $0xc,%esp
  104ee5:	6a 04                	push   $0x4
  104ee7:	e8 f8 de ff ff       	call   102de4 <alloc_pages>
  104eec:	83 c4 10             	add    $0x10,%esp
  104eef:	85 c0                	test   %eax,%eax
  104ef1:	74 19                	je     104f0c <default_check+0x211>
  104ef3:	68 f4 6c 10 00       	push   $0x106cf4
  104ef8:	68 de 6a 10 00       	push   $0x106ade
  104efd:	68 10 01 00 00       	push   $0x110
  104f02:	68 f3 6a 10 00       	push   $0x106af3
  104f07:	e8 d1 b4 ff ff       	call   1003dd <__panic>
	assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f0f:	83 c0 28             	add    $0x28,%eax
  104f12:	83 c0 04             	add    $0x4,%eax
  104f15:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104f1c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f1f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104f22:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104f25:	0f a3 10             	bt     %edx,(%eax)
  104f28:	19 c0                	sbb    %eax,%eax
  104f2a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104f2d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104f31:	0f 95 c0             	setne  %al
  104f34:	0f b6 c0             	movzbl %al,%eax
  104f37:	85 c0                	test   %eax,%eax
  104f39:	74 0e                	je     104f49 <default_check+0x24e>
  104f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f3e:	83 c0 28             	add    $0x28,%eax
  104f41:	8b 40 08             	mov    0x8(%eax),%eax
  104f44:	83 f8 03             	cmp    $0x3,%eax
  104f47:	74 19                	je     104f62 <default_check+0x267>
  104f49:	68 0c 6d 10 00       	push   $0x106d0c
  104f4e:	68 de 6a 10 00       	push   $0x106ade
  104f53:	68 11 01 00 00       	push   $0x111
  104f58:	68 f3 6a 10 00       	push   $0x106af3
  104f5d:	e8 7b b4 ff ff       	call   1003dd <__panic>
	assert((p1 = alloc_pages(3)) != NULL);
  104f62:	83 ec 0c             	sub    $0xc,%esp
  104f65:	6a 03                	push   $0x3
  104f67:	e8 78 de ff ff       	call   102de4 <alloc_pages>
  104f6c:	83 c4 10             	add    $0x10,%esp
  104f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104f72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104f76:	75 19                	jne    104f91 <default_check+0x296>
  104f78:	68 38 6d 10 00       	push   $0x106d38
  104f7d:	68 de 6a 10 00       	push   $0x106ade
  104f82:	68 12 01 00 00       	push   $0x112
  104f87:	68 f3 6a 10 00       	push   $0x106af3
  104f8c:	e8 4c b4 ff ff       	call   1003dd <__panic>
	assert(alloc_page() == NULL);
  104f91:	83 ec 0c             	sub    $0xc,%esp
  104f94:	6a 01                	push   $0x1
  104f96:	e8 49 de ff ff       	call   102de4 <alloc_pages>
  104f9b:	83 c4 10             	add    $0x10,%esp
  104f9e:	85 c0                	test   %eax,%eax
  104fa0:	74 19                	je     104fbb <default_check+0x2c0>
  104fa2:	68 4e 6c 10 00       	push   $0x106c4e
  104fa7:	68 de 6a 10 00       	push   $0x106ade
  104fac:	68 13 01 00 00       	push   $0x113
  104fb1:	68 f3 6a 10 00       	push   $0x106af3
  104fb6:	e8 22 b4 ff ff       	call   1003dd <__panic>
	assert(p0 + 2 == p1);
  104fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fbe:	83 c0 28             	add    $0x28,%eax
  104fc1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104fc4:	74 19                	je     104fdf <default_check+0x2e4>
  104fc6:	68 56 6d 10 00       	push   $0x106d56
  104fcb:	68 de 6a 10 00       	push   $0x106ade
  104fd0:	68 14 01 00 00       	push   $0x114
  104fd5:	68 f3 6a 10 00       	push   $0x106af3
  104fda:	e8 fe b3 ff ff       	call   1003dd <__panic>

	p2 = p0 + 1;
  104fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fe2:	83 c0 14             	add    $0x14,%eax
  104fe5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	free_page(p0);
  104fe8:	83 ec 08             	sub    $0x8,%esp
  104feb:	6a 01                	push   $0x1
  104fed:	ff 75 e8             	pushl  -0x18(%ebp)
  104ff0:	e8 2d de ff ff       	call   102e22 <free_pages>
  104ff5:	83 c4 10             	add    $0x10,%esp
	free_pages(p1, 3);
  104ff8:	83 ec 08             	sub    $0x8,%esp
  104ffb:	6a 03                	push   $0x3
  104ffd:	ff 75 e0             	pushl  -0x20(%ebp)
  105000:	e8 1d de ff ff       	call   102e22 <free_pages>
  105005:	83 c4 10             	add    $0x10,%esp
	assert(PageProperty(p0) && p0->property == 1);
  105008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10500b:	83 c0 04             	add    $0x4,%eax
  10500e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105015:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105018:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10501b:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10501e:	0f a3 10             	bt     %edx,(%eax)
  105021:	19 c0                	sbb    %eax,%eax
  105023:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105026:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10502a:	0f 95 c0             	setne  %al
  10502d:	0f b6 c0             	movzbl %al,%eax
  105030:	85 c0                	test   %eax,%eax
  105032:	74 0b                	je     10503f <default_check+0x344>
  105034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105037:	8b 40 08             	mov    0x8(%eax),%eax
  10503a:	83 f8 01             	cmp    $0x1,%eax
  10503d:	74 19                	je     105058 <default_check+0x35d>
  10503f:	68 64 6d 10 00       	push   $0x106d64
  105044:	68 de 6a 10 00       	push   $0x106ade
  105049:	68 19 01 00 00       	push   $0x119
  10504e:	68 f3 6a 10 00       	push   $0x106af3
  105053:	e8 85 b3 ff ff       	call   1003dd <__panic>
	assert(PageProperty(p1) && p1->property == 3);
  105058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10505b:	83 c0 04             	add    $0x4,%eax
  10505e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105065:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105068:	8b 45 90             	mov    -0x70(%ebp),%eax
  10506b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10506e:	0f a3 10             	bt     %edx,(%eax)
  105071:	19 c0                	sbb    %eax,%eax
  105073:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105076:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10507a:	0f 95 c0             	setne  %al
  10507d:	0f b6 c0             	movzbl %al,%eax
  105080:	85 c0                	test   %eax,%eax
  105082:	74 0b                	je     10508f <default_check+0x394>
  105084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105087:	8b 40 08             	mov    0x8(%eax),%eax
  10508a:	83 f8 03             	cmp    $0x3,%eax
  10508d:	74 19                	je     1050a8 <default_check+0x3ad>
  10508f:	68 8c 6d 10 00       	push   $0x106d8c
  105094:	68 de 6a 10 00       	push   $0x106ade
  105099:	68 1a 01 00 00       	push   $0x11a
  10509e:	68 f3 6a 10 00       	push   $0x106af3
  1050a3:	e8 35 b3 ff ff       	call   1003dd <__panic>

	assert((p0 = alloc_page()) == p2 - 1);
  1050a8:	83 ec 0c             	sub    $0xc,%esp
  1050ab:	6a 01                	push   $0x1
  1050ad:	e8 32 dd ff ff       	call   102de4 <alloc_pages>
  1050b2:	83 c4 10             	add    $0x10,%esp
  1050b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050bb:	83 e8 14             	sub    $0x14,%eax
  1050be:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1050c1:	74 19                	je     1050dc <default_check+0x3e1>
  1050c3:	68 b2 6d 10 00       	push   $0x106db2
  1050c8:	68 de 6a 10 00       	push   $0x106ade
  1050cd:	68 1c 01 00 00       	push   $0x11c
  1050d2:	68 f3 6a 10 00       	push   $0x106af3
  1050d7:	e8 01 b3 ff ff       	call   1003dd <__panic>
	free_page(p0);
  1050dc:	83 ec 08             	sub    $0x8,%esp
  1050df:	6a 01                	push   $0x1
  1050e1:	ff 75 e8             	pushl  -0x18(%ebp)
  1050e4:	e8 39 dd ff ff       	call   102e22 <free_pages>
  1050e9:	83 c4 10             	add    $0x10,%esp
	assert((p0 = alloc_pages(2)) == p2 + 1);
  1050ec:	83 ec 0c             	sub    $0xc,%esp
  1050ef:	6a 02                	push   $0x2
  1050f1:	e8 ee dc ff ff       	call   102de4 <alloc_pages>
  1050f6:	83 c4 10             	add    $0x10,%esp
  1050f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050ff:	83 c0 14             	add    $0x14,%eax
  105102:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105105:	74 19                	je     105120 <default_check+0x425>
  105107:	68 d0 6d 10 00       	push   $0x106dd0
  10510c:	68 de 6a 10 00       	push   $0x106ade
  105111:	68 1e 01 00 00       	push   $0x11e
  105116:	68 f3 6a 10 00       	push   $0x106af3
  10511b:	e8 bd b2 ff ff       	call   1003dd <__panic>

	free_pages(p0, 2);
  105120:	83 ec 08             	sub    $0x8,%esp
  105123:	6a 02                	push   $0x2
  105125:	ff 75 e8             	pushl  -0x18(%ebp)
  105128:	e8 f5 dc ff ff       	call   102e22 <free_pages>
  10512d:	83 c4 10             	add    $0x10,%esp
	free_page(p2);
  105130:	83 ec 08             	sub    $0x8,%esp
  105133:	6a 01                	push   $0x1
  105135:	ff 75 dc             	pushl  -0x24(%ebp)
  105138:	e8 e5 dc ff ff       	call   102e22 <free_pages>
  10513d:	83 c4 10             	add    $0x10,%esp

	assert((p0 = alloc_pages(5)) != NULL);
  105140:	83 ec 0c             	sub    $0xc,%esp
  105143:	6a 05                	push   $0x5
  105145:	e8 9a dc ff ff       	call   102de4 <alloc_pages>
  10514a:	83 c4 10             	add    $0x10,%esp
  10514d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105150:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105154:	75 19                	jne    10516f <default_check+0x474>
  105156:	68 f0 6d 10 00       	push   $0x106df0
  10515b:	68 de 6a 10 00       	push   $0x106ade
  105160:	68 23 01 00 00       	push   $0x123
  105165:	68 f3 6a 10 00       	push   $0x106af3
  10516a:	e8 6e b2 ff ff       	call   1003dd <__panic>
	assert(alloc_page() == NULL);
  10516f:	83 ec 0c             	sub    $0xc,%esp
  105172:	6a 01                	push   $0x1
  105174:	e8 6b dc ff ff       	call   102de4 <alloc_pages>
  105179:	83 c4 10             	add    $0x10,%esp
  10517c:	85 c0                	test   %eax,%eax
  10517e:	74 19                	je     105199 <default_check+0x49e>
  105180:	68 4e 6c 10 00       	push   $0x106c4e
  105185:	68 de 6a 10 00       	push   $0x106ade
  10518a:	68 24 01 00 00       	push   $0x124
  10518f:	68 f3 6a 10 00       	push   $0x106af3
  105194:	e8 44 b2 ff ff       	call   1003dd <__panic>

	assert(nr_free == 0);
  105199:	a1 64 99 11 00       	mov    0x119964,%eax
  10519e:	85 c0                	test   %eax,%eax
  1051a0:	74 19                	je     1051bb <default_check+0x4c0>
  1051a2:	68 a1 6c 10 00       	push   $0x106ca1
  1051a7:	68 de 6a 10 00       	push   $0x106ade
  1051ac:	68 26 01 00 00       	push   $0x126
  1051b1:	68 f3 6a 10 00       	push   $0x106af3
  1051b6:	e8 22 b2 ff ff       	call   1003dd <__panic>
	nr_free = nr_free_store;
  1051bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051be:	a3 64 99 11 00       	mov    %eax,0x119964

	free_list = free_list_store;
  1051c3:	8b 45 80             	mov    -0x80(%ebp),%eax
  1051c6:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1051c9:	a3 5c 99 11 00       	mov    %eax,0x11995c
  1051ce:	89 15 60 99 11 00    	mov    %edx,0x119960
	free_pages(p0, 5);
  1051d4:	83 ec 08             	sub    $0x8,%esp
  1051d7:	6a 05                	push   $0x5
  1051d9:	ff 75 e8             	pushl  -0x18(%ebp)
  1051dc:	e8 41 dc ff ff       	call   102e22 <free_pages>
  1051e1:	83 c4 10             	add    $0x10,%esp

	le = &free_list;
  1051e4:	c7 45 ec 5c 99 11 00 	movl   $0x11995c,-0x14(%ebp)
	while ((le = list_next(le)) != &free_list) {
  1051eb:	eb 1d                	jmp    10520a <default_check+0x50f>
		struct Page *p = le2page(le, page_link);
  1051ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051f0:	83 e8 0c             	sub    $0xc,%eax
  1051f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		count--, total -= p->property;
  1051f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1051fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1051fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105200:	8b 40 08             	mov    0x8(%eax),%eax
  105203:	29 c2                	sub    %eax,%edx
  105205:	89 d0                	mov    %edx,%eax
  105207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10520a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10520d:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105210:	8b 45 88             	mov    -0x78(%ebp),%eax
  105213:	8b 40 04             	mov    0x4(%eax),%eax
	while ((le = list_next(le)) != &free_list) {
  105216:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105219:	81 7d ec 5c 99 11 00 	cmpl   $0x11995c,-0x14(%ebp)
  105220:	75 cb                	jne    1051ed <default_check+0x4f2>
	}
	assert(count == 0);
  105222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105226:	74 19                	je     105241 <default_check+0x546>
  105228:	68 0e 6e 10 00       	push   $0x106e0e
  10522d:	68 de 6a 10 00       	push   $0x106ade
  105232:	68 31 01 00 00       	push   $0x131
  105237:	68 f3 6a 10 00       	push   $0x106af3
  10523c:	e8 9c b1 ff ff       	call   1003dd <__panic>
	assert(total == 0);
  105241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105245:	74 19                	je     105260 <default_check+0x565>
  105247:	68 19 6e 10 00       	push   $0x106e19
  10524c:	68 de 6a 10 00       	push   $0x106ade
  105251:	68 32 01 00 00       	push   $0x132
  105256:	68 f3 6a 10 00       	push   $0x106af3
  10525b:	e8 7d b1 ff ff       	call   1003dd <__panic>
}
  105260:	90                   	nop
  105261:	c9                   	leave  
  105262:	c3                   	ret    

00105263 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105263:	55                   	push   %ebp
  105264:	89 e5                	mov    %esp,%ebp
  105266:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105270:	eb 04                	jmp    105276 <strlen+0x13>
        cnt ++;
  105272:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  105276:	8b 45 08             	mov    0x8(%ebp),%eax
  105279:	8d 50 01             	lea    0x1(%eax),%edx
  10527c:	89 55 08             	mov    %edx,0x8(%ebp)
  10527f:	0f b6 00             	movzbl (%eax),%eax
  105282:	84 c0                	test   %al,%al
  105284:	75 ec                	jne    105272 <strlen+0xf>
    }
    return cnt;
  105286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105289:	c9                   	leave  
  10528a:	c3                   	ret    

0010528b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10528b:	55                   	push   %ebp
  10528c:	89 e5                	mov    %esp,%ebp
  10528e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105298:	eb 04                	jmp    10529e <strnlen+0x13>
        cnt ++;
  10529a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10529e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052a4:	73 10                	jae    1052b6 <strnlen+0x2b>
  1052a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a9:	8d 50 01             	lea    0x1(%eax),%edx
  1052ac:	89 55 08             	mov    %edx,0x8(%ebp)
  1052af:	0f b6 00             	movzbl (%eax),%eax
  1052b2:	84 c0                	test   %al,%al
  1052b4:	75 e4                	jne    10529a <strnlen+0xf>
    }
    return cnt;
  1052b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1052b9:	c9                   	leave  
  1052ba:	c3                   	ret    

001052bb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1052bb:	55                   	push   %ebp
  1052bc:	89 e5                	mov    %esp,%ebp
  1052be:	57                   	push   %edi
  1052bf:	56                   	push   %esi
  1052c0:	83 ec 20             	sub    $0x20,%esp
  1052c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1052cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1052d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052d5:	89 d1                	mov    %edx,%ecx
  1052d7:	89 c2                	mov    %eax,%edx
  1052d9:	89 ce                	mov    %ecx,%esi
  1052db:	89 d7                	mov    %edx,%edi
  1052dd:	ac                   	lods   %ds:(%esi),%al
  1052de:	aa                   	stos   %al,%es:(%edi)
  1052df:	84 c0                	test   %al,%al
  1052e1:	75 fa                	jne    1052dd <strcpy+0x22>
  1052e3:	89 fa                	mov    %edi,%edx
  1052e5:	89 f1                	mov    %esi,%ecx
  1052e7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1052ea:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1052ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1052f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1052f3:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1052f4:	83 c4 20             	add    $0x20,%esp
  1052f7:	5e                   	pop    %esi
  1052f8:	5f                   	pop    %edi
  1052f9:	5d                   	pop    %ebp
  1052fa:	c3                   	ret    

001052fb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1052fb:	55                   	push   %ebp
  1052fc:	89 e5                	mov    %esp,%ebp
  1052fe:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105301:	8b 45 08             	mov    0x8(%ebp),%eax
  105304:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105307:	eb 21                	jmp    10532a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105309:	8b 45 0c             	mov    0xc(%ebp),%eax
  10530c:	0f b6 10             	movzbl (%eax),%edx
  10530f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105312:	88 10                	mov    %dl,(%eax)
  105314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105317:	0f b6 00             	movzbl (%eax),%eax
  10531a:	84 c0                	test   %al,%al
  10531c:	74 04                	je     105322 <strncpy+0x27>
            src ++;
  10531e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105322:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105326:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  10532a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10532e:	75 d9                	jne    105309 <strncpy+0xe>
    }
    return dst;
  105330:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105333:	c9                   	leave  
  105334:	c3                   	ret    

00105335 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105335:	55                   	push   %ebp
  105336:	89 e5                	mov    %esp,%ebp
  105338:	57                   	push   %edi
  105339:	56                   	push   %esi
  10533a:	83 ec 20             	sub    $0x20,%esp
  10533d:	8b 45 08             	mov    0x8(%ebp),%eax
  105340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105343:	8b 45 0c             	mov    0xc(%ebp),%eax
  105346:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10534c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10534f:	89 d1                	mov    %edx,%ecx
  105351:	89 c2                	mov    %eax,%edx
  105353:	89 ce                	mov    %ecx,%esi
  105355:	89 d7                	mov    %edx,%edi
  105357:	ac                   	lods   %ds:(%esi),%al
  105358:	ae                   	scas   %es:(%edi),%al
  105359:	75 08                	jne    105363 <strcmp+0x2e>
  10535b:	84 c0                	test   %al,%al
  10535d:	75 f8                	jne    105357 <strcmp+0x22>
  10535f:	31 c0                	xor    %eax,%eax
  105361:	eb 04                	jmp    105367 <strcmp+0x32>
  105363:	19 c0                	sbb    %eax,%eax
  105365:	0c 01                	or     $0x1,%al
  105367:	89 fa                	mov    %edi,%edx
  105369:	89 f1                	mov    %esi,%ecx
  10536b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10536e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105371:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105374:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105377:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105378:	83 c4 20             	add    $0x20,%esp
  10537b:	5e                   	pop    %esi
  10537c:	5f                   	pop    %edi
  10537d:	5d                   	pop    %ebp
  10537e:	c3                   	ret    

0010537f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10537f:	55                   	push   %ebp
  105380:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105382:	eb 0c                	jmp    105390 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105384:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105388:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10538c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105394:	74 1a                	je     1053b0 <strncmp+0x31>
  105396:	8b 45 08             	mov    0x8(%ebp),%eax
  105399:	0f b6 00             	movzbl (%eax),%eax
  10539c:	84 c0                	test   %al,%al
  10539e:	74 10                	je     1053b0 <strncmp+0x31>
  1053a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a3:	0f b6 10             	movzbl (%eax),%edx
  1053a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053a9:	0f b6 00             	movzbl (%eax),%eax
  1053ac:	38 c2                	cmp    %al,%dl
  1053ae:	74 d4                	je     105384 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1053b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053b4:	74 18                	je     1053ce <strncmp+0x4f>
  1053b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b9:	0f b6 00             	movzbl (%eax),%eax
  1053bc:	0f b6 d0             	movzbl %al,%edx
  1053bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053c2:	0f b6 00             	movzbl (%eax),%eax
  1053c5:	0f b6 c0             	movzbl %al,%eax
  1053c8:	29 c2                	sub    %eax,%edx
  1053ca:	89 d0                	mov    %edx,%eax
  1053cc:	eb 05                	jmp    1053d3 <strncmp+0x54>
  1053ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1053d3:	5d                   	pop    %ebp
  1053d4:	c3                   	ret    

001053d5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1053d5:	55                   	push   %ebp
  1053d6:	89 e5                	mov    %esp,%ebp
  1053d8:	83 ec 04             	sub    $0x4,%esp
  1053db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053de:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1053e1:	eb 14                	jmp    1053f7 <strchr+0x22>
        if (*s == c) {
  1053e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e6:	0f b6 00             	movzbl (%eax),%eax
  1053e9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1053ec:	75 05                	jne    1053f3 <strchr+0x1e>
            return (char *)s;
  1053ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f1:	eb 13                	jmp    105406 <strchr+0x31>
        }
        s ++;
  1053f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1053f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1053fa:	0f b6 00             	movzbl (%eax),%eax
  1053fd:	84 c0                	test   %al,%al
  1053ff:	75 e2                	jne    1053e3 <strchr+0xe>
    }
    return NULL;
  105401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105406:	c9                   	leave  
  105407:	c3                   	ret    

00105408 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105408:	55                   	push   %ebp
  105409:	89 e5                	mov    %esp,%ebp
  10540b:	83 ec 04             	sub    $0x4,%esp
  10540e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105411:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105414:	eb 0f                	jmp    105425 <strfind+0x1d>
        if (*s == c) {
  105416:	8b 45 08             	mov    0x8(%ebp),%eax
  105419:	0f b6 00             	movzbl (%eax),%eax
  10541c:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10541f:	74 10                	je     105431 <strfind+0x29>
            break;
        }
        s ++;
  105421:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105425:	8b 45 08             	mov    0x8(%ebp),%eax
  105428:	0f b6 00             	movzbl (%eax),%eax
  10542b:	84 c0                	test   %al,%al
  10542d:	75 e7                	jne    105416 <strfind+0xe>
  10542f:	eb 01                	jmp    105432 <strfind+0x2a>
            break;
  105431:	90                   	nop
    }
    return (char *)s;
  105432:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105435:	c9                   	leave  
  105436:	c3                   	ret    

00105437 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105437:	55                   	push   %ebp
  105438:	89 e5                	mov    %esp,%ebp
  10543a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10543d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105444:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10544b:	eb 04                	jmp    105451 <strtol+0x1a>
        s ++;
  10544d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105451:	8b 45 08             	mov    0x8(%ebp),%eax
  105454:	0f b6 00             	movzbl (%eax),%eax
  105457:	3c 20                	cmp    $0x20,%al
  105459:	74 f2                	je     10544d <strtol+0x16>
  10545b:	8b 45 08             	mov    0x8(%ebp),%eax
  10545e:	0f b6 00             	movzbl (%eax),%eax
  105461:	3c 09                	cmp    $0x9,%al
  105463:	74 e8                	je     10544d <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105465:	8b 45 08             	mov    0x8(%ebp),%eax
  105468:	0f b6 00             	movzbl (%eax),%eax
  10546b:	3c 2b                	cmp    $0x2b,%al
  10546d:	75 06                	jne    105475 <strtol+0x3e>
        s ++;
  10546f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105473:	eb 15                	jmp    10548a <strtol+0x53>
    }
    else if (*s == '-') {
  105475:	8b 45 08             	mov    0x8(%ebp),%eax
  105478:	0f b6 00             	movzbl (%eax),%eax
  10547b:	3c 2d                	cmp    $0x2d,%al
  10547d:	75 0b                	jne    10548a <strtol+0x53>
        s ++, neg = 1;
  10547f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10548a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10548e:	74 06                	je     105496 <strtol+0x5f>
  105490:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105494:	75 24                	jne    1054ba <strtol+0x83>
  105496:	8b 45 08             	mov    0x8(%ebp),%eax
  105499:	0f b6 00             	movzbl (%eax),%eax
  10549c:	3c 30                	cmp    $0x30,%al
  10549e:	75 1a                	jne    1054ba <strtol+0x83>
  1054a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a3:	83 c0 01             	add    $0x1,%eax
  1054a6:	0f b6 00             	movzbl (%eax),%eax
  1054a9:	3c 78                	cmp    $0x78,%al
  1054ab:	75 0d                	jne    1054ba <strtol+0x83>
        s += 2, base = 16;
  1054ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1054b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1054b8:	eb 2a                	jmp    1054e4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1054ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054be:	75 17                	jne    1054d7 <strtol+0xa0>
  1054c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c3:	0f b6 00             	movzbl (%eax),%eax
  1054c6:	3c 30                	cmp    $0x30,%al
  1054c8:	75 0d                	jne    1054d7 <strtol+0xa0>
        s ++, base = 8;
  1054ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1054ce:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1054d5:	eb 0d                	jmp    1054e4 <strtol+0xad>
    }
    else if (base == 0) {
  1054d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054db:	75 07                	jne    1054e4 <strtol+0xad>
        base = 10;
  1054dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1054e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e7:	0f b6 00             	movzbl (%eax),%eax
  1054ea:	3c 2f                	cmp    $0x2f,%al
  1054ec:	7e 1b                	jle    105509 <strtol+0xd2>
  1054ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f1:	0f b6 00             	movzbl (%eax),%eax
  1054f4:	3c 39                	cmp    $0x39,%al
  1054f6:	7f 11                	jg     105509 <strtol+0xd2>
            dig = *s - '0';
  1054f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1054fb:	0f b6 00             	movzbl (%eax),%eax
  1054fe:	0f be c0             	movsbl %al,%eax
  105501:	83 e8 30             	sub    $0x30,%eax
  105504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105507:	eb 48                	jmp    105551 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105509:	8b 45 08             	mov    0x8(%ebp),%eax
  10550c:	0f b6 00             	movzbl (%eax),%eax
  10550f:	3c 60                	cmp    $0x60,%al
  105511:	7e 1b                	jle    10552e <strtol+0xf7>
  105513:	8b 45 08             	mov    0x8(%ebp),%eax
  105516:	0f b6 00             	movzbl (%eax),%eax
  105519:	3c 7a                	cmp    $0x7a,%al
  10551b:	7f 11                	jg     10552e <strtol+0xf7>
            dig = *s - 'a' + 10;
  10551d:	8b 45 08             	mov    0x8(%ebp),%eax
  105520:	0f b6 00             	movzbl (%eax),%eax
  105523:	0f be c0             	movsbl %al,%eax
  105526:	83 e8 57             	sub    $0x57,%eax
  105529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10552c:	eb 23                	jmp    105551 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10552e:	8b 45 08             	mov    0x8(%ebp),%eax
  105531:	0f b6 00             	movzbl (%eax),%eax
  105534:	3c 40                	cmp    $0x40,%al
  105536:	7e 3c                	jle    105574 <strtol+0x13d>
  105538:	8b 45 08             	mov    0x8(%ebp),%eax
  10553b:	0f b6 00             	movzbl (%eax),%eax
  10553e:	3c 5a                	cmp    $0x5a,%al
  105540:	7f 32                	jg     105574 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105542:	8b 45 08             	mov    0x8(%ebp),%eax
  105545:	0f b6 00             	movzbl (%eax),%eax
  105548:	0f be c0             	movsbl %al,%eax
  10554b:	83 e8 37             	sub    $0x37,%eax
  10554e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105554:	3b 45 10             	cmp    0x10(%ebp),%eax
  105557:	7d 1a                	jge    105573 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  105559:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10555d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105560:	0f af 45 10          	imul   0x10(%ebp),%eax
  105564:	89 c2                	mov    %eax,%edx
  105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105569:	01 d0                	add    %edx,%eax
  10556b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  10556e:	e9 71 ff ff ff       	jmp    1054e4 <strtol+0xad>
            break;
  105573:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105578:	74 08                	je     105582 <strtol+0x14b>
        *endptr = (char *) s;
  10557a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10557d:	8b 55 08             	mov    0x8(%ebp),%edx
  105580:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105582:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105586:	74 07                	je     10558f <strtol+0x158>
  105588:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10558b:	f7 d8                	neg    %eax
  10558d:	eb 03                	jmp    105592 <strtol+0x15b>
  10558f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105592:	c9                   	leave  
  105593:	c3                   	ret    

00105594 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105594:	55                   	push   %ebp
  105595:	89 e5                	mov    %esp,%ebp
  105597:	57                   	push   %edi
  105598:	83 ec 24             	sub    $0x24,%esp
  10559b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10559e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1055a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1055a5:	8b 55 08             	mov    0x8(%ebp),%edx
  1055a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1055ab:	88 45 f7             	mov    %al,-0x9(%ebp)
  1055ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1055b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1055b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1055b7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1055bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1055be:	89 d7                	mov    %edx,%edi
  1055c0:	f3 aa                	rep stos %al,%es:(%edi)
  1055c2:	89 fa                	mov    %edi,%edx
  1055c4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1055c7:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1055ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055cd:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1055ce:	83 c4 24             	add    $0x24,%esp
  1055d1:	5f                   	pop    %edi
  1055d2:	5d                   	pop    %ebp
  1055d3:	c3                   	ret    

001055d4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1055d4:	55                   	push   %ebp
  1055d5:	89 e5                	mov    %esp,%ebp
  1055d7:	57                   	push   %edi
  1055d8:	56                   	push   %esi
  1055d9:	53                   	push   %ebx
  1055da:	83 ec 30             	sub    $0x30,%esp
  1055dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1055e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1055e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1055ec:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1055ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1055f5:	73 42                	jae    105639 <memmove+0x65>
  1055f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105600:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105606:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105609:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10560c:	c1 e8 02             	shr    $0x2,%eax
  10560f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105611:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105617:	89 d7                	mov    %edx,%edi
  105619:	89 c6                	mov    %eax,%esi
  10561b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10561d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105620:	83 e1 03             	and    $0x3,%ecx
  105623:	74 02                	je     105627 <memmove+0x53>
  105625:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105627:	89 f0                	mov    %esi,%eax
  105629:	89 fa                	mov    %edi,%edx
  10562b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10562e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105631:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105637:	eb 36                	jmp    10566f <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10563c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10563f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105642:	01 c2                	add    %eax,%edx
  105644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105647:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10564a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10564d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105653:	89 c1                	mov    %eax,%ecx
  105655:	89 d8                	mov    %ebx,%eax
  105657:	89 d6                	mov    %edx,%esi
  105659:	89 c7                	mov    %eax,%edi
  10565b:	fd                   	std    
  10565c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10565e:	fc                   	cld    
  10565f:	89 f8                	mov    %edi,%eax
  105661:	89 f2                	mov    %esi,%edx
  105663:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105666:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105669:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10566c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10566f:	83 c4 30             	add    $0x30,%esp
  105672:	5b                   	pop    %ebx
  105673:	5e                   	pop    %esi
  105674:	5f                   	pop    %edi
  105675:	5d                   	pop    %ebp
  105676:	c3                   	ret    

00105677 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105677:	55                   	push   %ebp
  105678:	89 e5                	mov    %esp,%ebp
  10567a:	57                   	push   %edi
  10567b:	56                   	push   %esi
  10567c:	83 ec 20             	sub    $0x20,%esp
  10567f:	8b 45 08             	mov    0x8(%ebp),%eax
  105682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105685:	8b 45 0c             	mov    0xc(%ebp),%eax
  105688:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10568b:	8b 45 10             	mov    0x10(%ebp),%eax
  10568e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105694:	c1 e8 02             	shr    $0x2,%eax
  105697:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105699:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10569c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10569f:	89 d7                	mov    %edx,%edi
  1056a1:	89 c6                	mov    %eax,%esi
  1056a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1056a5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1056a8:	83 e1 03             	and    $0x3,%ecx
  1056ab:	74 02                	je     1056af <memcpy+0x38>
  1056ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1056af:	89 f0                	mov    %esi,%eax
  1056b1:	89 fa                	mov    %edi,%edx
  1056b3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1056b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1056b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1056bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1056bf:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1056c0:	83 c4 20             	add    $0x20,%esp
  1056c3:	5e                   	pop    %esi
  1056c4:	5f                   	pop    %edi
  1056c5:	5d                   	pop    %ebp
  1056c6:	c3                   	ret    

001056c7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1056c7:	55                   	push   %ebp
  1056c8:	89 e5                	mov    %esp,%ebp
  1056ca:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1056cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1056d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1056d9:	eb 30                	jmp    10570b <memcmp+0x44>
        if (*s1 != *s2) {
  1056db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056de:	0f b6 10             	movzbl (%eax),%edx
  1056e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056e4:	0f b6 00             	movzbl (%eax),%eax
  1056e7:	38 c2                	cmp    %al,%dl
  1056e9:	74 18                	je     105703 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1056eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056ee:	0f b6 00             	movzbl (%eax),%eax
  1056f1:	0f b6 d0             	movzbl %al,%edx
  1056f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056f7:	0f b6 00             	movzbl (%eax),%eax
  1056fa:	0f b6 c0             	movzbl %al,%eax
  1056fd:	29 c2                	sub    %eax,%edx
  1056ff:	89 d0                	mov    %edx,%eax
  105701:	eb 1a                	jmp    10571d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105703:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105707:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  10570b:	8b 45 10             	mov    0x10(%ebp),%eax
  10570e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105711:	89 55 10             	mov    %edx,0x10(%ebp)
  105714:	85 c0                	test   %eax,%eax
  105716:	75 c3                	jne    1056db <memcmp+0x14>
    }
    return 0;
  105718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10571d:	c9                   	leave  
  10571e:	c3                   	ret    

0010571f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10571f:	55                   	push   %ebp
  105720:	89 e5                	mov    %esp,%ebp
  105722:	83 ec 38             	sub    $0x38,%esp
  105725:	8b 45 10             	mov    0x10(%ebp),%eax
  105728:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10572b:	8b 45 14             	mov    0x14(%ebp),%eax
  10572e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105731:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105737:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10573a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10573d:	8b 45 18             	mov    0x18(%ebp),%eax
  105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105746:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105749:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10574c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10574f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105752:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105759:	74 1c                	je     105777 <printnum+0x58>
  10575b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10575e:	ba 00 00 00 00       	mov    $0x0,%edx
  105763:	f7 75 e4             	divl   -0x1c(%ebp)
  105766:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10576c:	ba 00 00 00 00       	mov    $0x0,%edx
  105771:	f7 75 e4             	divl   -0x1c(%ebp)
  105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10577a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10577d:	f7 75 e4             	divl   -0x1c(%ebp)
  105780:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105783:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105789:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10578c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10578f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105795:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105798:	8b 45 18             	mov    0x18(%ebp),%eax
  10579b:	ba 00 00 00 00       	mov    $0x0,%edx
  1057a0:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1057a3:	72 41                	jb     1057e6 <printnum+0xc7>
  1057a5:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1057a8:	77 05                	ja     1057af <printnum+0x90>
  1057aa:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1057ad:	72 37                	jb     1057e6 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1057af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1057b2:	83 e8 01             	sub    $0x1,%eax
  1057b5:	83 ec 04             	sub    $0x4,%esp
  1057b8:	ff 75 20             	pushl  0x20(%ebp)
  1057bb:	50                   	push   %eax
  1057bc:	ff 75 18             	pushl  0x18(%ebp)
  1057bf:	ff 75 ec             	pushl  -0x14(%ebp)
  1057c2:	ff 75 e8             	pushl  -0x18(%ebp)
  1057c5:	ff 75 0c             	pushl  0xc(%ebp)
  1057c8:	ff 75 08             	pushl  0x8(%ebp)
  1057cb:	e8 4f ff ff ff       	call   10571f <printnum>
  1057d0:	83 c4 20             	add    $0x20,%esp
  1057d3:	eb 1b                	jmp    1057f0 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1057d5:	83 ec 08             	sub    $0x8,%esp
  1057d8:	ff 75 0c             	pushl  0xc(%ebp)
  1057db:	ff 75 20             	pushl  0x20(%ebp)
  1057de:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e1:	ff d0                	call   *%eax
  1057e3:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  1057e6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1057ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1057ee:	7f e5                	jg     1057d5 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1057f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1057f3:	05 d4 6e 10 00       	add    $0x106ed4,%eax
  1057f8:	0f b6 00             	movzbl (%eax),%eax
  1057fb:	0f be c0             	movsbl %al,%eax
  1057fe:	83 ec 08             	sub    $0x8,%esp
  105801:	ff 75 0c             	pushl  0xc(%ebp)
  105804:	50                   	push   %eax
  105805:	8b 45 08             	mov    0x8(%ebp),%eax
  105808:	ff d0                	call   *%eax
  10580a:	83 c4 10             	add    $0x10,%esp
}
  10580d:	90                   	nop
  10580e:	c9                   	leave  
  10580f:	c3                   	ret    

00105810 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105810:	55                   	push   %ebp
  105811:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105813:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105817:	7e 14                	jle    10582d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105819:	8b 45 08             	mov    0x8(%ebp),%eax
  10581c:	8b 00                	mov    (%eax),%eax
  10581e:	8d 48 08             	lea    0x8(%eax),%ecx
  105821:	8b 55 08             	mov    0x8(%ebp),%edx
  105824:	89 0a                	mov    %ecx,(%edx)
  105826:	8b 50 04             	mov    0x4(%eax),%edx
  105829:	8b 00                	mov    (%eax),%eax
  10582b:	eb 30                	jmp    10585d <getuint+0x4d>
    }
    else if (lflag) {
  10582d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105831:	74 16                	je     105849 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105833:	8b 45 08             	mov    0x8(%ebp),%eax
  105836:	8b 00                	mov    (%eax),%eax
  105838:	8d 48 04             	lea    0x4(%eax),%ecx
  10583b:	8b 55 08             	mov    0x8(%ebp),%edx
  10583e:	89 0a                	mov    %ecx,(%edx)
  105840:	8b 00                	mov    (%eax),%eax
  105842:	ba 00 00 00 00       	mov    $0x0,%edx
  105847:	eb 14                	jmp    10585d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105849:	8b 45 08             	mov    0x8(%ebp),%eax
  10584c:	8b 00                	mov    (%eax),%eax
  10584e:	8d 48 04             	lea    0x4(%eax),%ecx
  105851:	8b 55 08             	mov    0x8(%ebp),%edx
  105854:	89 0a                	mov    %ecx,(%edx)
  105856:	8b 00                	mov    (%eax),%eax
  105858:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10585d:	5d                   	pop    %ebp
  10585e:	c3                   	ret    

0010585f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10585f:	55                   	push   %ebp
  105860:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105862:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105866:	7e 14                	jle    10587c <getint+0x1d>
        return va_arg(*ap, long long);
  105868:	8b 45 08             	mov    0x8(%ebp),%eax
  10586b:	8b 00                	mov    (%eax),%eax
  10586d:	8d 48 08             	lea    0x8(%eax),%ecx
  105870:	8b 55 08             	mov    0x8(%ebp),%edx
  105873:	89 0a                	mov    %ecx,(%edx)
  105875:	8b 50 04             	mov    0x4(%eax),%edx
  105878:	8b 00                	mov    (%eax),%eax
  10587a:	eb 28                	jmp    1058a4 <getint+0x45>
    }
    else if (lflag) {
  10587c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105880:	74 12                	je     105894 <getint+0x35>
        return va_arg(*ap, long);
  105882:	8b 45 08             	mov    0x8(%ebp),%eax
  105885:	8b 00                	mov    (%eax),%eax
  105887:	8d 48 04             	lea    0x4(%eax),%ecx
  10588a:	8b 55 08             	mov    0x8(%ebp),%edx
  10588d:	89 0a                	mov    %ecx,(%edx)
  10588f:	8b 00                	mov    (%eax),%eax
  105891:	99                   	cltd   
  105892:	eb 10                	jmp    1058a4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105894:	8b 45 08             	mov    0x8(%ebp),%eax
  105897:	8b 00                	mov    (%eax),%eax
  105899:	8d 48 04             	lea    0x4(%eax),%ecx
  10589c:	8b 55 08             	mov    0x8(%ebp),%edx
  10589f:	89 0a                	mov    %ecx,(%edx)
  1058a1:	8b 00                	mov    (%eax),%eax
  1058a3:	99                   	cltd   
    }
}
  1058a4:	5d                   	pop    %ebp
  1058a5:	c3                   	ret    

001058a6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1058a6:	55                   	push   %ebp
  1058a7:	89 e5                	mov    %esp,%ebp
  1058a9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1058ac:	8d 45 14             	lea    0x14(%ebp),%eax
  1058af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1058b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058b5:	50                   	push   %eax
  1058b6:	ff 75 10             	pushl  0x10(%ebp)
  1058b9:	ff 75 0c             	pushl  0xc(%ebp)
  1058bc:	ff 75 08             	pushl  0x8(%ebp)
  1058bf:	e8 06 00 00 00       	call   1058ca <vprintfmt>
  1058c4:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1058c7:	90                   	nop
  1058c8:	c9                   	leave  
  1058c9:	c3                   	ret    

001058ca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1058ca:	55                   	push   %ebp
  1058cb:	89 e5                	mov    %esp,%ebp
  1058cd:	56                   	push   %esi
  1058ce:	53                   	push   %ebx
  1058cf:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058d2:	eb 17                	jmp    1058eb <vprintfmt+0x21>
            if (ch == '\0') {
  1058d4:	85 db                	test   %ebx,%ebx
  1058d6:	0f 84 8e 03 00 00    	je     105c6a <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1058dc:	83 ec 08             	sub    $0x8,%esp
  1058df:	ff 75 0c             	pushl  0xc(%ebp)
  1058e2:	53                   	push   %ebx
  1058e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e6:	ff d0                	call   *%eax
  1058e8:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1058ee:	8d 50 01             	lea    0x1(%eax),%edx
  1058f1:	89 55 10             	mov    %edx,0x10(%ebp)
  1058f4:	0f b6 00             	movzbl (%eax),%eax
  1058f7:	0f b6 d8             	movzbl %al,%ebx
  1058fa:	83 fb 25             	cmp    $0x25,%ebx
  1058fd:	75 d5                	jne    1058d4 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1058ff:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105903:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10590a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10590d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105910:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105917:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10591a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10591d:	8b 45 10             	mov    0x10(%ebp),%eax
  105920:	8d 50 01             	lea    0x1(%eax),%edx
  105923:	89 55 10             	mov    %edx,0x10(%ebp)
  105926:	0f b6 00             	movzbl (%eax),%eax
  105929:	0f b6 d8             	movzbl %al,%ebx
  10592c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10592f:	83 f8 55             	cmp    $0x55,%eax
  105932:	0f 87 05 03 00 00    	ja     105c3d <vprintfmt+0x373>
  105938:	8b 04 85 f8 6e 10 00 	mov    0x106ef8(,%eax,4),%eax
  10593f:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105941:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105945:	eb d6                	jmp    10591d <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105947:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10594b:	eb d0                	jmp    10591d <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10594d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105957:	89 d0                	mov    %edx,%eax
  105959:	c1 e0 02             	shl    $0x2,%eax
  10595c:	01 d0                	add    %edx,%eax
  10595e:	01 c0                	add    %eax,%eax
  105960:	01 d8                	add    %ebx,%eax
  105962:	83 e8 30             	sub    $0x30,%eax
  105965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105968:	8b 45 10             	mov    0x10(%ebp),%eax
  10596b:	0f b6 00             	movzbl (%eax),%eax
  10596e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105971:	83 fb 2f             	cmp    $0x2f,%ebx
  105974:	7e 39                	jle    1059af <vprintfmt+0xe5>
  105976:	83 fb 39             	cmp    $0x39,%ebx
  105979:	7f 34                	jg     1059af <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  10597b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10597f:	eb d3                	jmp    105954 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105981:	8b 45 14             	mov    0x14(%ebp),%eax
  105984:	8d 50 04             	lea    0x4(%eax),%edx
  105987:	89 55 14             	mov    %edx,0x14(%ebp)
  10598a:	8b 00                	mov    (%eax),%eax
  10598c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10598f:	eb 1f                	jmp    1059b0 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105991:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105995:	79 86                	jns    10591d <vprintfmt+0x53>
                width = 0;
  105997:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10599e:	e9 7a ff ff ff       	jmp    10591d <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1059a3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1059aa:	e9 6e ff ff ff       	jmp    10591d <vprintfmt+0x53>
            goto process_precision;
  1059af:	90                   	nop

        process_precision:
            if (width < 0)
  1059b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059b4:	0f 89 63 ff ff ff    	jns    10591d <vprintfmt+0x53>
                width = precision, precision = -1;
  1059ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1059c7:	e9 51 ff ff ff       	jmp    10591d <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1059cc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1059d0:	e9 48 ff ff ff       	jmp    10591d <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1059d5:	8b 45 14             	mov    0x14(%ebp),%eax
  1059d8:	8d 50 04             	lea    0x4(%eax),%edx
  1059db:	89 55 14             	mov    %edx,0x14(%ebp)
  1059de:	8b 00                	mov    (%eax),%eax
  1059e0:	83 ec 08             	sub    $0x8,%esp
  1059e3:	ff 75 0c             	pushl  0xc(%ebp)
  1059e6:	50                   	push   %eax
  1059e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ea:	ff d0                	call   *%eax
  1059ec:	83 c4 10             	add    $0x10,%esp
            break;
  1059ef:	e9 71 02 00 00       	jmp    105c65 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1059f4:	8b 45 14             	mov    0x14(%ebp),%eax
  1059f7:	8d 50 04             	lea    0x4(%eax),%edx
  1059fa:	89 55 14             	mov    %edx,0x14(%ebp)
  1059fd:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1059ff:	85 db                	test   %ebx,%ebx
  105a01:	79 02                	jns    105a05 <vprintfmt+0x13b>
                err = -err;
  105a03:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105a05:	83 fb 06             	cmp    $0x6,%ebx
  105a08:	7f 0b                	jg     105a15 <vprintfmt+0x14b>
  105a0a:	8b 34 9d b8 6e 10 00 	mov    0x106eb8(,%ebx,4),%esi
  105a11:	85 f6                	test   %esi,%esi
  105a13:	75 19                	jne    105a2e <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  105a15:	53                   	push   %ebx
  105a16:	68 e5 6e 10 00       	push   $0x106ee5
  105a1b:	ff 75 0c             	pushl  0xc(%ebp)
  105a1e:	ff 75 08             	pushl  0x8(%ebp)
  105a21:	e8 80 fe ff ff       	call   1058a6 <printfmt>
  105a26:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105a29:	e9 37 02 00 00       	jmp    105c65 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  105a2e:	56                   	push   %esi
  105a2f:	68 ee 6e 10 00       	push   $0x106eee
  105a34:	ff 75 0c             	pushl  0xc(%ebp)
  105a37:	ff 75 08             	pushl  0x8(%ebp)
  105a3a:	e8 67 fe ff ff       	call   1058a6 <printfmt>
  105a3f:	83 c4 10             	add    $0x10,%esp
            break;
  105a42:	e9 1e 02 00 00       	jmp    105c65 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105a47:	8b 45 14             	mov    0x14(%ebp),%eax
  105a4a:	8d 50 04             	lea    0x4(%eax),%edx
  105a4d:	89 55 14             	mov    %edx,0x14(%ebp)
  105a50:	8b 30                	mov    (%eax),%esi
  105a52:	85 f6                	test   %esi,%esi
  105a54:	75 05                	jne    105a5b <vprintfmt+0x191>
                p = "(null)";
  105a56:	be f1 6e 10 00       	mov    $0x106ef1,%esi
            }
            if (width > 0 && padc != '-') {
  105a5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a5f:	7e 76                	jle    105ad7 <vprintfmt+0x20d>
  105a61:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105a65:	74 70                	je     105ad7 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a6a:	83 ec 08             	sub    $0x8,%esp
  105a6d:	50                   	push   %eax
  105a6e:	56                   	push   %esi
  105a6f:	e8 17 f8 ff ff       	call   10528b <strnlen>
  105a74:	83 c4 10             	add    $0x10,%esp
  105a77:	89 c2                	mov    %eax,%edx
  105a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a7c:	29 d0                	sub    %edx,%eax
  105a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a81:	eb 17                	jmp    105a9a <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105a83:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105a87:	83 ec 08             	sub    $0x8,%esp
  105a8a:	ff 75 0c             	pushl  0xc(%ebp)
  105a8d:	50                   	push   %eax
  105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a91:	ff d0                	call   *%eax
  105a93:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a96:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a9e:	7f e3                	jg     105a83 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105aa0:	eb 35                	jmp    105ad7 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  105aa2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105aa6:	74 1c                	je     105ac4 <vprintfmt+0x1fa>
  105aa8:	83 fb 1f             	cmp    $0x1f,%ebx
  105aab:	7e 05                	jle    105ab2 <vprintfmt+0x1e8>
  105aad:	83 fb 7e             	cmp    $0x7e,%ebx
  105ab0:	7e 12                	jle    105ac4 <vprintfmt+0x1fa>
                    putch('?', putdat);
  105ab2:	83 ec 08             	sub    $0x8,%esp
  105ab5:	ff 75 0c             	pushl  0xc(%ebp)
  105ab8:	6a 3f                	push   $0x3f
  105aba:	8b 45 08             	mov    0x8(%ebp),%eax
  105abd:	ff d0                	call   *%eax
  105abf:	83 c4 10             	add    $0x10,%esp
  105ac2:	eb 0f                	jmp    105ad3 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  105ac4:	83 ec 08             	sub    $0x8,%esp
  105ac7:	ff 75 0c             	pushl  0xc(%ebp)
  105aca:	53                   	push   %ebx
  105acb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ace:	ff d0                	call   *%eax
  105ad0:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ad3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ad7:	89 f0                	mov    %esi,%eax
  105ad9:	8d 70 01             	lea    0x1(%eax),%esi
  105adc:	0f b6 00             	movzbl (%eax),%eax
  105adf:	0f be d8             	movsbl %al,%ebx
  105ae2:	85 db                	test   %ebx,%ebx
  105ae4:	74 26                	je     105b0c <vprintfmt+0x242>
  105ae6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105aea:	78 b6                	js     105aa2 <vprintfmt+0x1d8>
  105aec:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105af0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105af4:	79 ac                	jns    105aa2 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  105af6:	eb 14                	jmp    105b0c <vprintfmt+0x242>
                putch(' ', putdat);
  105af8:	83 ec 08             	sub    $0x8,%esp
  105afb:	ff 75 0c             	pushl  0xc(%ebp)
  105afe:	6a 20                	push   $0x20
  105b00:	8b 45 08             	mov    0x8(%ebp),%eax
  105b03:	ff d0                	call   *%eax
  105b05:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  105b08:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b10:	7f e6                	jg     105af8 <vprintfmt+0x22e>
            }
            break;
  105b12:	e9 4e 01 00 00       	jmp    105c65 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105b17:	83 ec 08             	sub    $0x8,%esp
  105b1a:	ff 75 e0             	pushl  -0x20(%ebp)
  105b1d:	8d 45 14             	lea    0x14(%ebp),%eax
  105b20:	50                   	push   %eax
  105b21:	e8 39 fd ff ff       	call   10585f <getint>
  105b26:	83 c4 10             	add    $0x10,%esp
  105b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b35:	85 d2                	test   %edx,%edx
  105b37:	79 23                	jns    105b5c <vprintfmt+0x292>
                putch('-', putdat);
  105b39:	83 ec 08             	sub    $0x8,%esp
  105b3c:	ff 75 0c             	pushl  0xc(%ebp)
  105b3f:	6a 2d                	push   $0x2d
  105b41:	8b 45 08             	mov    0x8(%ebp),%eax
  105b44:	ff d0                	call   *%eax
  105b46:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b4f:	f7 d8                	neg    %eax
  105b51:	83 d2 00             	adc    $0x0,%edx
  105b54:	f7 da                	neg    %edx
  105b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b59:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105b5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b63:	e9 9f 00 00 00       	jmp    105c07 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105b68:	83 ec 08             	sub    $0x8,%esp
  105b6b:	ff 75 e0             	pushl  -0x20(%ebp)
  105b6e:	8d 45 14             	lea    0x14(%ebp),%eax
  105b71:	50                   	push   %eax
  105b72:	e8 99 fc ff ff       	call   105810 <getuint>
  105b77:	83 c4 10             	add    $0x10,%esp
  105b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105b80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b87:	eb 7e                	jmp    105c07 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105b89:	83 ec 08             	sub    $0x8,%esp
  105b8c:	ff 75 e0             	pushl  -0x20(%ebp)
  105b8f:	8d 45 14             	lea    0x14(%ebp),%eax
  105b92:	50                   	push   %eax
  105b93:	e8 78 fc ff ff       	call   105810 <getuint>
  105b98:	83 c4 10             	add    $0x10,%esp
  105b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105ba1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105ba8:	eb 5d                	jmp    105c07 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  105baa:	83 ec 08             	sub    $0x8,%esp
  105bad:	ff 75 0c             	pushl  0xc(%ebp)
  105bb0:	6a 30                	push   $0x30
  105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb5:	ff d0                	call   *%eax
  105bb7:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  105bba:	83 ec 08             	sub    $0x8,%esp
  105bbd:	ff 75 0c             	pushl  0xc(%ebp)
  105bc0:	6a 78                	push   $0x78
  105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc5:	ff d0                	call   *%eax
  105bc7:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105bca:	8b 45 14             	mov    0x14(%ebp),%eax
  105bcd:	8d 50 04             	lea    0x4(%eax),%edx
  105bd0:	89 55 14             	mov    %edx,0x14(%ebp)
  105bd3:	8b 00                	mov    (%eax),%eax
  105bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105bdf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105be6:	eb 1f                	jmp    105c07 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105be8:	83 ec 08             	sub    $0x8,%esp
  105beb:	ff 75 e0             	pushl  -0x20(%ebp)
  105bee:	8d 45 14             	lea    0x14(%ebp),%eax
  105bf1:	50                   	push   %eax
  105bf2:	e8 19 fc ff ff       	call   105810 <getuint>
  105bf7:	83 c4 10             	add    $0x10,%esp
  105bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105c00:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105c07:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c0e:	83 ec 04             	sub    $0x4,%esp
  105c11:	52                   	push   %edx
  105c12:	ff 75 e8             	pushl  -0x18(%ebp)
  105c15:	50                   	push   %eax
  105c16:	ff 75 f4             	pushl  -0xc(%ebp)
  105c19:	ff 75 f0             	pushl  -0x10(%ebp)
  105c1c:	ff 75 0c             	pushl  0xc(%ebp)
  105c1f:	ff 75 08             	pushl  0x8(%ebp)
  105c22:	e8 f8 fa ff ff       	call   10571f <printnum>
  105c27:	83 c4 20             	add    $0x20,%esp
            break;
  105c2a:	eb 39                	jmp    105c65 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105c2c:	83 ec 08             	sub    $0x8,%esp
  105c2f:	ff 75 0c             	pushl  0xc(%ebp)
  105c32:	53                   	push   %ebx
  105c33:	8b 45 08             	mov    0x8(%ebp),%eax
  105c36:	ff d0                	call   *%eax
  105c38:	83 c4 10             	add    $0x10,%esp
            break;
  105c3b:	eb 28                	jmp    105c65 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105c3d:	83 ec 08             	sub    $0x8,%esp
  105c40:	ff 75 0c             	pushl  0xc(%ebp)
  105c43:	6a 25                	push   $0x25
  105c45:	8b 45 08             	mov    0x8(%ebp),%eax
  105c48:	ff d0                	call   *%eax
  105c4a:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  105c4d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c51:	eb 04                	jmp    105c57 <vprintfmt+0x38d>
  105c53:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c57:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5a:	83 e8 01             	sub    $0x1,%eax
  105c5d:	0f b6 00             	movzbl (%eax),%eax
  105c60:	3c 25                	cmp    $0x25,%al
  105c62:	75 ef                	jne    105c53 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105c64:	90                   	nop
    while (1) {
  105c65:	e9 68 fc ff ff       	jmp    1058d2 <vprintfmt+0x8>
                return;
  105c6a:	90                   	nop
        }
    }
}
  105c6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  105c6e:	5b                   	pop    %ebx
  105c6f:	5e                   	pop    %esi
  105c70:	5d                   	pop    %ebp
  105c71:	c3                   	ret    

00105c72 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105c72:	55                   	push   %ebp
  105c73:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c78:	8b 40 08             	mov    0x8(%eax),%eax
  105c7b:	8d 50 01             	lea    0x1(%eax),%edx
  105c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c81:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c87:	8b 10                	mov    (%eax),%edx
  105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c8c:	8b 40 04             	mov    0x4(%eax),%eax
  105c8f:	39 c2                	cmp    %eax,%edx
  105c91:	73 12                	jae    105ca5 <sprintputch+0x33>
        *b->buf ++ = ch;
  105c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c96:	8b 00                	mov    (%eax),%eax
  105c98:	8d 48 01             	lea    0x1(%eax),%ecx
  105c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c9e:	89 0a                	mov    %ecx,(%edx)
  105ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  105ca3:	88 10                	mov    %dl,(%eax)
    }
}
  105ca5:	90                   	nop
  105ca6:	5d                   	pop    %ebp
  105ca7:	c3                   	ret    

00105ca8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105ca8:	55                   	push   %ebp
  105ca9:	89 e5                	mov    %esp,%ebp
  105cab:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105cae:	8d 45 14             	lea    0x14(%ebp),%eax
  105cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cb7:	50                   	push   %eax
  105cb8:	ff 75 10             	pushl  0x10(%ebp)
  105cbb:	ff 75 0c             	pushl  0xc(%ebp)
  105cbe:	ff 75 08             	pushl  0x8(%ebp)
  105cc1:	e8 0b 00 00 00       	call   105cd1 <vsnprintf>
  105cc6:	83 c4 10             	add    $0x10,%esp
  105cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ccf:	c9                   	leave  
  105cd0:	c3                   	ret    

00105cd1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105cd1:	55                   	push   %ebp
  105cd2:	89 e5                	mov    %esp,%ebp
  105cd4:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ce0:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce6:	01 d0                	add    %edx,%eax
  105ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105cf6:	74 0a                	je     105d02 <vsnprintf+0x31>
  105cf8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cfe:	39 c2                	cmp    %eax,%edx
  105d00:	76 07                	jbe    105d09 <vsnprintf+0x38>
        return -E_INVAL;
  105d02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105d07:	eb 20                	jmp    105d29 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105d09:	ff 75 14             	pushl  0x14(%ebp)
  105d0c:	ff 75 10             	pushl  0x10(%ebp)
  105d0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105d12:	50                   	push   %eax
  105d13:	68 72 5c 10 00       	push   $0x105c72
  105d18:	e8 ad fb ff ff       	call   1058ca <vprintfmt>
  105d1d:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d23:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d29:	c9                   	leave  
  105d2a:	c3                   	ret    
