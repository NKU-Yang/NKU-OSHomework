
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 36 2b 00 00       	call   102b5a <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 5e 14 00 00       	call   10148a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 00 33 10 00 	movl   $0x103300,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 1c 33 10 00       	push   $0x10331c
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 c9 27 00 00       	call   10281e <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 73 15 00 00       	call   1015cd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 f5 16 00 00       	call   101754 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 07 0c 00 00       	call   100c6b <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 a1 16 00 00       	call   10170a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x69>

0010006b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100071:	83 ec 04             	sub    $0x4,%esp
  100074:	6a 00                	push   $0x0
  100076:	6a 00                	push   $0x0
  100078:	6a 00                	push   $0x0
  10007a:	e8 da 0b 00 00       	call   100c59 <mon_backtrace>
  10007f:	83 c4 10             	add    $0x10,%esp
}
  100082:	90                   	nop
  100083:	c9                   	leave  
  100084:	c3                   	ret    

00100085 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	53                   	push   %ebx
  100089:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100092:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100095:	8b 45 08             	mov    0x8(%ebp),%eax
  100098:	51                   	push   %ecx
  100099:	52                   	push   %edx
  10009a:	53                   	push   %ebx
  10009b:	50                   	push   %eax
  10009c:	e8 ca ff ff ff       	call   10006b <grade_backtrace2>
  1000a1:	83 c4 10             	add    $0x10,%esp
}
  1000a4:	90                   	nop
  1000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a8:	c9                   	leave  
  1000a9:	c3                   	ret    

001000aa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b0:	83 ec 08             	sub    $0x8,%esp
  1000b3:	ff 75 10             	pushl  0x10(%ebp)
  1000b6:	ff 75 08             	pushl  0x8(%ebp)
  1000b9:	e8 c7 ff ff ff       	call   100085 <grade_backtrace1>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	c9                   	leave  
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ca:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cf:	83 ec 04             	sub    $0x4,%esp
  1000d2:	68 00 00 ff ff       	push   $0xffff0000
  1000d7:	50                   	push   %eax
  1000d8:	6a 00                	push   $0x0
  1000da:	e8 cb ff ff ff       	call   1000aa <grade_backtrace0>
  1000df:	83 c4 10             	add    $0x10,%esp
}
  1000e2:	90                   	nop
  1000e3:	c9                   	leave  
  1000e4:	c3                   	ret    

001000e5 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e5:	55                   	push   %ebp
  1000e6:	89 e5                	mov    %esp,%ebp
  1000e8:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000eb:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ee:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f1:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f4:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fb:	0f b7 c0             	movzwl %ax,%eax
  1000fe:	83 e0 03             	and    $0x3,%eax
  100101:	89 c2                	mov    %eax,%edx
  100103:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100108:	83 ec 04             	sub    $0x4,%esp
  10010b:	52                   	push   %edx
  10010c:	50                   	push   %eax
  10010d:	68 21 33 10 00       	push   $0x103321
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 2f 33 10 00       	push   $0x10332f
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 3d 33 10 00       	push   $0x10333d
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 4b 33 10 00       	push   $0x10334b
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 59 33 10 00       	push   $0x103359
  10018a:	e8 ae 00 00 00       	call   10023d <cprintf>
  10018f:	83 c4 10             	add    $0x10,%esp
    round ++;
  100192:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100197:	83 c0 01             	add    $0x1,%eax
  10019a:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019f:	90                   	nop
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001a5:	90                   	nop
  1001a6:	5d                   	pop    %ebp
  1001a7:	c3                   	ret    

001001a8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001a8:	55                   	push   %ebp
  1001a9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ab:	90                   	nop
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
  1001b1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b4:	e8 2c ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001b9:	83 ec 0c             	sub    $0xc,%esp
  1001bc:	68 68 33 10 00       	push   $0x103368
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 88 33 10 00       	push   $0x103388
  1001db:	e8 5d 00 00 00       	call   10023d <cprintf>
  1001e0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e3:	e8 c0 ff ff ff       	call   1001a8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001e8:	e8 f8 fe ff ff       	call   1000e5 <lab1_print_cur_status>
}
  1001ed:	90                   	nop
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1001f6:	83 ec 0c             	sub    $0xc,%esp
  1001f9:	ff 75 08             	pushl  0x8(%ebp)
  1001fc:	e8 ba 12 00 00       	call   1014bb <cons_putc>
  100201:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100204:	8b 45 0c             	mov    0xc(%ebp),%eax
  100207:	8b 00                	mov    (%eax),%eax
  100209:	8d 50 01             	lea    0x1(%eax),%edx
  10020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10020f:	89 10                	mov    %edx,(%eax)
}
  100211:	90                   	nop
  100212:	c9                   	leave  
  100213:	c3                   	ret    

00100214 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10021a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100221:	ff 75 0c             	pushl  0xc(%ebp)
  100224:	ff 75 08             	pushl  0x8(%ebp)
  100227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10022a:	50                   	push   %eax
  10022b:	68 f0 01 10 00       	push   $0x1001f0
  100230:	e8 5b 2c 00 00       	call   102e90 <vprintfmt>
  100235:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100238:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10023b:	c9                   	leave  
  10023c:	c3                   	ret    

0010023d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10023d:	55                   	push   %ebp
  10023e:	89 e5                	mov    %esp,%ebp
  100240:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100243:	8d 45 0c             	lea    0xc(%ebp),%eax
  100246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10024c:	83 ec 08             	sub    $0x8,%esp
  10024f:	50                   	push   %eax
  100250:	ff 75 08             	pushl  0x8(%ebp)
  100253:	e8 bc ff ff ff       	call   100214 <vcprintf>
  100258:	83 c4 10             	add    $0x10,%esp
  10025b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100261:	c9                   	leave  
  100262:	c3                   	ret    

00100263 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100263:	55                   	push   %ebp
  100264:	89 e5                	mov    %esp,%ebp
  100266:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100269:	83 ec 0c             	sub    $0xc,%esp
  10026c:	ff 75 08             	pushl  0x8(%ebp)
  10026f:	e8 47 12 00 00       	call   1014bb <cons_putc>
  100274:	83 c4 10             	add    $0x10,%esp
}
  100277:	90                   	nop
  100278:	c9                   	leave  
  100279:	c3                   	ret    

0010027a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10027a:	55                   	push   %ebp
  10027b:	89 e5                	mov    %esp,%ebp
  10027d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100280:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100287:	eb 14                	jmp    10029d <cputs+0x23>
        cputch(c, &cnt);
  100289:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10028d:	83 ec 08             	sub    $0x8,%esp
  100290:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100293:	52                   	push   %edx
  100294:	50                   	push   %eax
  100295:	e8 56 ff ff ff       	call   1001f0 <cputch>
  10029a:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  10029d:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a0:	8d 50 01             	lea    0x1(%eax),%edx
  1002a3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002a6:	0f b6 00             	movzbl (%eax),%eax
  1002a9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002ac:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b0:	75 d7                	jne    100289 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002b2:	83 ec 08             	sub    $0x8,%esp
  1002b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002b8:	50                   	push   %eax
  1002b9:	6a 0a                	push   $0xa
  1002bb:	e8 30 ff ff ff       	call   1001f0 <cputch>
  1002c0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ce:	e8 18 12 00 00       	call   1014eb <cons_getc>
  1002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002da:	74 f2                	je     1002ce <getchar+0x6>
        /* do nothing */;
    return c;
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002df:	c9                   	leave  
  1002e0:	c3                   	ret    

001002e1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e1:	55                   	push   %ebp
  1002e2:	89 e5                	mov    %esp,%ebp
  1002e4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002eb:	74 13                	je     100300 <readline+0x1f>
        cprintf("%s", prompt);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	ff 75 08             	pushl  0x8(%ebp)
  1002f3:	68 a7 33 10 00       	push   $0x1033a7
  1002f8:	e8 40 ff ff ff       	call   10023d <cprintf>
  1002fd:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100307:	e8 bc ff ff ff       	call   1002c8 <getchar>
  10030c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10030f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100313:	79 0a                	jns    10031f <readline+0x3e>
            return NULL;
  100315:	b8 00 00 00 00       	mov    $0x0,%eax
  10031a:	e9 82 00 00 00       	jmp    1003a1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10031f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100323:	7e 2b                	jle    100350 <readline+0x6f>
  100325:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10032c:	7f 22                	jg     100350 <readline+0x6f>
            cputchar(c);
  10032e:	83 ec 0c             	sub    $0xc,%esp
  100331:	ff 75 f0             	pushl  -0x10(%ebp)
  100334:	e8 2a ff ff ff       	call   100263 <cputchar>
  100339:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10033f:	8d 50 01             	lea    0x1(%eax),%edx
  100342:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100348:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10034e:	eb 4c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100350:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100354:	75 1a                	jne    100370 <readline+0x8f>
  100356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035a:	7e 14                	jle    100370 <readline+0x8f>
            cputchar(c);
  10035c:	83 ec 0c             	sub    $0xc,%esp
  10035f:	ff 75 f0             	pushl  -0x10(%ebp)
  100362:	e8 fc fe ff ff       	call   100263 <cputchar>
  100367:	83 c4 10             	add    $0x10,%esp
            i --;
  10036a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036e:	eb 2c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100370:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100374:	74 06                	je     10037c <readline+0x9b>
  100376:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10037a:	75 8b                	jne    100307 <readline+0x26>
            cputchar(c);
  10037c:	83 ec 0c             	sub    $0xc,%esp
  10037f:	ff 75 f0             	pushl  -0x10(%ebp)
  100382:	e8 dc fe ff ff       	call   100263 <cputchar>
  100387:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  100392:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100395:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  10039a:	eb 05                	jmp    1003a1 <readline+0xc0>
        c = getchar();
  10039c:	e9 66 ff ff ff       	jmp    100307 <readline+0x26>
        }
    }
}
  1003a1:	c9                   	leave  
  1003a2:	c3                   	ret    

001003a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003a9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ae:	85 c0                	test   %eax,%eax
  1003b0:	75 4a                	jne    1003fc <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003b2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003b9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003c2:	83 ec 04             	sub    $0x4,%esp
  1003c5:	ff 75 0c             	pushl  0xc(%ebp)
  1003c8:	ff 75 08             	pushl  0x8(%ebp)
  1003cb:	68 aa 33 10 00       	push   $0x1033aa
  1003d0:	e8 68 fe ff ff       	call   10023d <cprintf>
  1003d5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003db:	83 ec 08             	sub    $0x8,%esp
  1003de:	50                   	push   %eax
  1003df:	ff 75 10             	pushl  0x10(%ebp)
  1003e2:	e8 2d fe ff ff       	call   100214 <vcprintf>
  1003e7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003ea:	83 ec 0c             	sub    $0xc,%esp
  1003ed:	68 c6 33 10 00       	push   $0x1033c6
  1003f2:	e8 46 fe ff ff       	call   10023d <cprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
  1003fa:	eb 01                	jmp    1003fd <__panic+0x5a>
        goto panic_dead;
  1003fc:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  1003fd:	e8 0f 13 00 00       	call   101711 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 73 07 00 00       	call   100b7f <kmonitor>
  10040c:	83 c4 10             	add    $0x10,%esp
  10040f:	eb f1                	jmp    100402 <__panic+0x5f>

00100411 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100411:	55                   	push   %ebp
  100412:	89 e5                	mov    %esp,%ebp
  100414:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100417:	8d 45 14             	lea    0x14(%ebp),%eax
  10041a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10041d:	83 ec 04             	sub    $0x4,%esp
  100420:	ff 75 0c             	pushl  0xc(%ebp)
  100423:	ff 75 08             	pushl  0x8(%ebp)
  100426:	68 c8 33 10 00       	push   $0x1033c8
  10042b:	e8 0d fe ff ff       	call   10023d <cprintf>
  100430:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100436:	83 ec 08             	sub    $0x8,%esp
  100439:	50                   	push   %eax
  10043a:	ff 75 10             	pushl  0x10(%ebp)
  10043d:	e8 d2 fd ff ff       	call   100214 <vcprintf>
  100442:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100445:	83 ec 0c             	sub    $0xc,%esp
  100448:	68 c6 33 10 00       	push   $0x1033c6
  10044d:	e8 eb fd ff ff       	call   10023d <cprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100455:	90                   	nop
  100456:	c9                   	leave  
  100457:	c3                   	ret    

00100458 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10045b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100460:	5d                   	pop    %ebp
  100461:	c3                   	ret    

00100462 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
  100465:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046b:	8b 00                	mov    (%eax),%eax
  10046d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100470:	8b 45 10             	mov    0x10(%ebp),%eax
  100473:	8b 00                	mov    (%eax),%eax
  100475:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10047f:	e9 d2 00 00 00       	jmp    100556 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10048a:	01 d0                	add    %edx,%eax
  10048c:	89 c2                	mov    %eax,%edx
  10048e:	c1 ea 1f             	shr    $0x1f,%edx
  100491:	01 d0                	add    %edx,%eax
  100493:	d1 f8                	sar    %eax
  100495:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10049b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10049e:	eb 04                	jmp    1004a4 <stab_binsearch+0x42>
            m --;
  1004a0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004aa:	7c 1f                	jl     1004cb <stab_binsearch+0x69>
  1004ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004af:	89 d0                	mov    %edx,%eax
  1004b1:	01 c0                	add    %eax,%eax
  1004b3:	01 d0                	add    %edx,%eax
  1004b5:	c1 e0 02             	shl    $0x2,%eax
  1004b8:	89 c2                	mov    %eax,%edx
  1004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004c3:	0f b6 c0             	movzbl %al,%eax
  1004c6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004c9:	75 d5                	jne    1004a0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d1:	7d 0b                	jge    1004de <stab_binsearch+0x7c>
            l = true_m + 1;
  1004d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d6:	83 c0 01             	add    $0x1,%eax
  1004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004dc:	eb 78                	jmp    100556 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	8b 40 08             	mov    0x8(%eax),%eax
  1004fb:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004fe:	76 13                	jbe    100513 <stab_binsearch+0xb1>
            *region_left = m;
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050b:	83 c0 01             	add    $0x1,%eax
  10050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100511:	eb 43                	jmp    100556 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	39 45 18             	cmp    %eax,0x18(%ebp)
  10052c:	73 16                	jae    100544 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100531:	8d 50 ff             	lea    -0x1(%eax),%edx
  100534:	8b 45 10             	mov    0x10(%ebp),%eax
  100537:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053c:	83 e8 01             	sub    $0x1,%eax
  10053f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100542:	eb 12                	jmp    100556 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
            l = m;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100552:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100559:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10055c:	0f 8e 22 ff ff ff    	jle    100484 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100566:	75 0f                	jne    100577 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056b:	8b 00                	mov    (%eax),%eax
  10056d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100575:	eb 3f                	jmp    1005b6 <stab_binsearch+0x154>
        l = *region_right;
  100577:	8b 45 10             	mov    0x10(%ebp),%eax
  10057a:	8b 00                	mov    (%eax),%eax
  10057c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10057f:	eb 04                	jmp    100585 <stab_binsearch+0x123>
  100581:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100585:	8b 45 0c             	mov    0xc(%ebp),%eax
  100588:	8b 00                	mov    (%eax),%eax
  10058a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  10058d:	7e 1f                	jle    1005ae <stab_binsearch+0x14c>
  10058f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100592:	89 d0                	mov    %edx,%eax
  100594:	01 c0                	add    %eax,%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	c1 e0 02             	shl    $0x2,%eax
  10059b:	89 c2                	mov    %eax,%edx
  10059d:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a0:	01 d0                	add    %edx,%eax
  1005a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005a6:	0f b6 c0             	movzbl %al,%eax
  1005a9:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005ac:	75 d3                	jne    100581 <stab_binsearch+0x11f>
        *region_left = l;
  1005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b4:	89 10                	mov    %edx,(%eax)
}
  1005b6:	90                   	nop
  1005b7:	c9                   	leave  
  1005b8:	c3                   	ret    

001005b9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005b9:	55                   	push   %ebp
  1005ba:	89 e5                	mov    %esp,%ebp
  1005bc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	c7 00 e8 33 10 00    	movl   $0x1033e8,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 e8 33 10 00 	movl   $0x1033e8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ec:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005f9:	c7 45 f4 ec 3b 10 00 	movl   $0x103bec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 34 b7 10 00 	movl   $0x10b734,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec 35 b7 10 00 	movl   $0x10b735,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 e7 d7 10 00 	movl   $0x10d7e7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100618:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10061b:	76 0d                	jbe    10062a <debuginfo_eip+0x71>
  10061d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100620:	83 e8 01             	sub    $0x1,%eax
  100623:	0f b6 00             	movzbl (%eax),%eax
  100626:	84 c0                	test   %al,%al
  100628:	74 0a                	je     100634 <debuginfo_eip+0x7b>
        return -1;
  10062a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10062f:	e9 91 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10063b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100641:	29 c2                	sub    %eax,%edx
  100643:	89 d0                	mov    %edx,%eax
  100645:	c1 f8 02             	sar    $0x2,%eax
  100648:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10064e:	83 e8 01             	sub    $0x1,%eax
  100651:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100654:	ff 75 08             	pushl  0x8(%ebp)
  100657:	6a 64                	push   $0x64
  100659:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10065c:	50                   	push   %eax
  10065d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100660:	50                   	push   %eax
  100661:	ff 75 f4             	pushl  -0xc(%ebp)
  100664:	e8 f9 fd ff ff       	call   100462 <stab_binsearch>
  100669:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10066c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10066f:	85 c0                	test   %eax,%eax
  100671:	75 0a                	jne    10067d <debuginfo_eip+0xc4>
        return -1;
  100673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100678:	e9 48 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10067d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100686:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100689:	ff 75 08             	pushl  0x8(%ebp)
  10068c:	6a 24                	push   $0x24
  10068e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100691:	50                   	push   %eax
  100692:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100695:	50                   	push   %eax
  100696:	ff 75 f4             	pushl  -0xc(%ebp)
  100699:	e8 c4 fd ff ff       	call   100462 <stab_binsearch>
  10069e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a7:	39 c2                	cmp    %eax,%edx
  1006a9:	7f 7c                	jg     100727 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ae:	89 c2                	mov    %eax,%edx
  1006b0:	89 d0                	mov    %edx,%eax
  1006b2:	01 c0                	add    %eax,%eax
  1006b4:	01 d0                	add    %edx,%eax
  1006b6:	c1 e0 02             	shl    $0x2,%eax
  1006b9:	89 c2                	mov    %eax,%edx
  1006bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	8b 00                	mov    (%eax),%eax
  1006c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006c8:	29 d1                	sub    %edx,%ecx
  1006ca:	89 ca                	mov    %ecx,%edx
  1006cc:	39 d0                	cmp    %edx,%eax
  1006ce:	73 22                	jae    1006f2 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	89 d0                	mov    %edx,%eax
  1006d7:	01 c0                	add    %eax,%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	c1 e0 02             	shl    $0x2,%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	8b 10                	mov    (%eax),%edx
  1006e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006ea:	01 c2                	add    %eax,%edx
  1006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ef:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f5:	89 c2                	mov    %eax,%edx
  1006f7:	89 d0                	mov    %edx,%eax
  1006f9:	01 c0                	add    %eax,%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	c1 e0 02             	shl    $0x2,%eax
  100700:	89 c2                	mov    %eax,%edx
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	01 d0                	add    %edx,%eax
  100707:	8b 50 08             	mov    0x8(%eax),%edx
  10070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100710:	8b 45 0c             	mov    0xc(%ebp),%eax
  100713:	8b 40 10             	mov    0x10(%eax),%eax
  100716:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10071f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100722:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100725:	eb 15                	jmp    10073c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072a:	8b 55 08             	mov    0x8(%ebp),%edx
  10072d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100739:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	8b 40 08             	mov    0x8(%eax),%eax
  100742:	83 ec 08             	sub    $0x8,%esp
  100745:	6a 3a                	push   $0x3a
  100747:	50                   	push   %eax
  100748:	e8 81 22 00 00       	call   1029ce <strfind>
  10074d:	83 c4 10             	add    $0x10,%esp
  100750:	89 c2                	mov    %eax,%edx
  100752:	8b 45 0c             	mov    0xc(%ebp),%eax
  100755:	8b 40 08             	mov    0x8(%eax),%eax
  100758:	29 c2                	sub    %eax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100760:	83 ec 0c             	sub    $0xc,%esp
  100763:	ff 75 08             	pushl  0x8(%ebp)
  100766:	6a 44                	push   $0x44
  100768:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10076b:	50                   	push   %eax
  10076c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10076f:	50                   	push   %eax
  100770:	ff 75 f4             	pushl  -0xc(%ebp)
  100773:	e8 ea fc ff ff       	call   100462 <stab_binsearch>
  100778:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10077b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10077e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100781:	39 c2                	cmp    %eax,%edx
  100783:	7f 24                	jg     1007a9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100785:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	89 d0                	mov    %edx,%eax
  10078c:	01 c0                	add    %eax,%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	c1 e0 02             	shl    $0x2,%eax
  100793:	89 c2                	mov    %eax,%edx
  100795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10079e:	0f b7 d0             	movzwl %ax,%edx
  1007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007a7:	eb 13                	jmp    1007bc <debuginfo_eip+0x203>
        return -1;
  1007a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ae:	e9 12 01 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b6:	83 e8 01             	sub    $0x1,%eax
  1007b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007c2:	39 c2                	cmp    %eax,%edx
  1007c4:	7c 56                	jl     10081c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c9:	89 c2                	mov    %eax,%edx
  1007cb:	89 d0                	mov    %edx,%eax
  1007cd:	01 c0                	add    %eax,%eax
  1007cf:	01 d0                	add    %edx,%eax
  1007d1:	c1 e0 02             	shl    $0x2,%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d9:	01 d0                	add    %edx,%eax
  1007db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007df:	3c 84                	cmp    $0x84,%al
  1007e1:	74 39                	je     10081c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	89 d0                	mov    %edx,%eax
  1007ea:	01 c0                	add    %eax,%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	c1 e0 02             	shl    $0x2,%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fc:	3c 64                	cmp    $0x64,%al
  1007fe:	75 b3                	jne    1007b3 <debuginfo_eip+0x1fa>
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 40 08             	mov    0x8(%eax),%eax
  100818:	85 c0                	test   %eax,%eax
  10081a:	74 97                	je     1007b3 <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10081c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7c 46                	jl     10086c <debuginfo_eip+0x2b3>
  100826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	89 d0                	mov    %edx,%eax
  10082d:	01 c0                	add    %eax,%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	c1 e0 02             	shl    $0x2,%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	8b 00                	mov    (%eax),%eax
  10083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100843:	29 d1                	sub    %edx,%ecx
  100845:	89 ca                	mov    %ecx,%edx
  100847:	39 d0                	cmp    %edx,%eax
  100849:	73 21                	jae    10086c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 10                	mov    (%eax),%edx
  100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100865:	01 c2                	add    %eax,%edx
  100867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10086c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10086f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100872:	39 c2                	cmp    %eax,%edx
  100874:	7d 4a                	jge    1008c0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100879:	83 c0 01             	add    $0x1,%eax
  10087c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10087f:	eb 18                	jmp    100899 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100881:	8b 45 0c             	mov    0xc(%ebp),%eax
  100884:	8b 40 14             	mov    0x14(%eax),%eax
  100887:	8d 50 01             	lea    0x1(%eax),%edx
  10088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088d:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	83 c0 01             	add    $0x1,%eax
  100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10089c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10089f:	39 c2                	cmp    %eax,%edx
  1008a1:	7d 1d                	jge    1008c0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	89 d0                	mov    %edx,%eax
  1008aa:	01 c0                	add    %eax,%eax
  1008ac:	01 d0                	add    %edx,%eax
  1008ae:	c1 e0 02             	shl    $0x2,%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008bc:	3c a0                	cmp    $0xa0,%al
  1008be:	74 c1                	je     100881 <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008c5:	c9                   	leave  
  1008c6:	c3                   	ret    

001008c7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008c7:	55                   	push   %ebp
  1008c8:	89 e5                	mov    %esp,%ebp
  1008ca:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008cd:	83 ec 0c             	sub    $0xc,%esp
  1008d0:	68 f2 33 10 00       	push   $0x1033f2
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 0b 34 10 00       	push   $0x10340b
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 f1 32 10 00       	push   $0x1032f1
  1008fa:	68 23 34 10 00       	push   $0x103423
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 3b 34 10 00       	push   $0x10343b
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 53 34 10 00       	push   $0x103453
  100929:	e8 0f f9 ff ff       	call   10023d <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100931:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100936:	05 ff 03 00 00       	add    $0x3ff,%eax
  10093b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100940:	29 d0                	sub    %edx,%eax
  100942:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100948:	85 c0                	test   %eax,%eax
  10094a:	0f 48 c2             	cmovs  %edx,%eax
  10094d:	c1 f8 0a             	sar    $0xa,%eax
  100950:	83 ec 08             	sub    $0x8,%esp
  100953:	50                   	push   %eax
  100954:	68 6c 34 10 00       	push   $0x10346c
  100959:	e8 df f8 ff ff       	call   10023d <cprintf>
  10095e:	83 c4 10             	add    $0x10,%esp
}
  100961:	90                   	nop
  100962:	c9                   	leave  
  100963:	c3                   	ret    

00100964 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100964:	55                   	push   %ebp
  100965:	89 e5                	mov    %esp,%ebp
  100967:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10096d:	83 ec 08             	sub    $0x8,%esp
  100970:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100973:	50                   	push   %eax
  100974:	ff 75 08             	pushl  0x8(%ebp)
  100977:	e8 3d fc ff ff       	call   1005b9 <debuginfo_eip>
  10097c:	83 c4 10             	add    $0x10,%esp
  10097f:	85 c0                	test   %eax,%eax
  100981:	74 15                	je     100998 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100983:	83 ec 08             	sub    $0x8,%esp
  100986:	ff 75 08             	pushl  0x8(%ebp)
  100989:	68 96 34 10 00       	push   $0x103496
  10098e:	e8 aa f8 ff ff       	call   10023d <cprintf>
  100993:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100996:	eb 65                	jmp    1009fd <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10099f:	eb 1c                	jmp    1009bd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	0f b6 00             	movzbl (%eax),%eax
  1009ac:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009b5:	01 ca                	add    %ecx,%edx
  1009b7:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009c3:	7c dc                	jl     1009a1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009c5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	01 d0                	add    %edx,%eax
  1009d0:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  1009d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009d9:	89 d1                	mov    %edx,%ecx
  1009db:	29 c1                	sub    %eax,%ecx
  1009dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009e3:	83 ec 0c             	sub    $0xc,%esp
  1009e6:	51                   	push   %ecx
  1009e7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ed:	51                   	push   %ecx
  1009ee:	52                   	push   %edx
  1009ef:	50                   	push   %eax
  1009f0:	68 b2 34 10 00       	push   $0x1034b2
  1009f5:	e8 43 f8 ff ff       	call   10023d <cprintf>
  1009fa:	83 c4 20             	add    $0x20,%esp
}
  1009fd:	90                   	nop
  1009fe:	c9                   	leave  
  1009ff:	c3                   	ret    

00100a00 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a06:	8b 45 04             	mov    0x4(%ebp),%eax
  100a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a0f:	c9                   	leave  
  100a10:	c3                   	ret    

00100a11 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a11:	55                   	push   %ebp
  100a12:	89 e5                	mov    %esp,%ebp
		print_debuginfo(eip - 1);
		eip = ((uint32_t *)ebp)[1];
		ebp = ((uint32_t*)ebp)[0];
	}
	*/
}
  100a14:	90                   	nop
  100a15:	5d                   	pop    %ebp
  100a16:	c3                   	ret    

00100a17 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a17:	55                   	push   %ebp
  100a18:	89 e5                	mov    %esp,%ebp
  100a1a:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a24:	eb 0c                	jmp    100a32 <parse+0x1b>
            *buf ++ = '\0';
  100a26:	8b 45 08             	mov    0x8(%ebp),%eax
  100a29:	8d 50 01             	lea    0x1(%eax),%edx
  100a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a32:	8b 45 08             	mov    0x8(%ebp),%eax
  100a35:	0f b6 00             	movzbl (%eax),%eax
  100a38:	84 c0                	test   %al,%al
  100a3a:	74 1e                	je     100a5a <parse+0x43>
  100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3f:	0f b6 00             	movzbl (%eax),%eax
  100a42:	0f be c0             	movsbl %al,%eax
  100a45:	83 ec 08             	sub    $0x8,%esp
  100a48:	50                   	push   %eax
  100a49:	68 44 35 10 00       	push   $0x103544
  100a4e:	e8 48 1f 00 00       	call   10299b <strchr>
  100a53:	83 c4 10             	add    $0x10,%esp
  100a56:	85 c0                	test   %eax,%eax
  100a58:	75 cc                	jne    100a26 <parse+0xf>
        }
        if (*buf == '\0') {
  100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5d:	0f b6 00             	movzbl (%eax),%eax
  100a60:	84 c0                	test   %al,%al
  100a62:	74 65                	je     100ac9 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a64:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a68:	75 12                	jne    100a7c <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a6a:	83 ec 08             	sub    $0x8,%esp
  100a6d:	6a 10                	push   $0x10
  100a6f:	68 49 35 10 00       	push   $0x103549
  100a74:	e8 c4 f7 ff ff       	call   10023d <cprintf>
  100a79:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7f:	8d 50 01             	lea    0x1(%eax),%edx
  100a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a8f:	01 c2                	add    %eax,%edx
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a96:	eb 04                	jmp    100a9c <parse+0x85>
            buf ++;
  100a98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	84 c0                	test   %al,%al
  100aa4:	74 8c                	je     100a32 <parse+0x1b>
  100aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa9:	0f b6 00             	movzbl (%eax),%eax
  100aac:	0f be c0             	movsbl %al,%eax
  100aaf:	83 ec 08             	sub    $0x8,%esp
  100ab2:	50                   	push   %eax
  100ab3:	68 44 35 10 00       	push   $0x103544
  100ab8:	e8 de 1e 00 00       	call   10299b <strchr>
  100abd:	83 c4 10             	add    $0x10,%esp
  100ac0:	85 c0                	test   %eax,%eax
  100ac2:	74 d4                	je     100a98 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac4:	e9 69 ff ff ff       	jmp    100a32 <parse+0x1b>
            break;
  100ac9:	90                   	nop
        }
    }
    return argc;
  100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100acd:	c9                   	leave  
  100ace:	c3                   	ret    

00100acf <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100acf:	55                   	push   %ebp
  100ad0:	89 e5                	mov    %esp,%ebp
  100ad2:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ad5:	83 ec 08             	sub    $0x8,%esp
  100ad8:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100adb:	50                   	push   %eax
  100adc:	ff 75 08             	pushl  0x8(%ebp)
  100adf:	e8 33 ff ff ff       	call   100a17 <parse>
  100ae4:	83 c4 10             	add    $0x10,%esp
  100ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100aee:	75 0a                	jne    100afa <runcmd+0x2b>
        return 0;
  100af0:	b8 00 00 00 00       	mov    $0x0,%eax
  100af5:	e9 83 00 00 00       	jmp    100b7d <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b01:	eb 59                	jmp    100b5c <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b03:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b09:	89 d0                	mov    %edx,%eax
  100b0b:	01 c0                	add    %eax,%eax
  100b0d:	01 d0                	add    %edx,%eax
  100b0f:	c1 e0 02             	shl    $0x2,%eax
  100b12:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b17:	8b 00                	mov    (%eax),%eax
  100b19:	83 ec 08             	sub    $0x8,%esp
  100b1c:	51                   	push   %ecx
  100b1d:	50                   	push   %eax
  100b1e:	e8 d8 1d 00 00       	call   1028fb <strcmp>
  100b23:	83 c4 10             	add    $0x10,%esp
  100b26:	85 c0                	test   %eax,%eax
  100b28:	75 2e                	jne    100b58 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b2d:	89 d0                	mov    %edx,%eax
  100b2f:	01 c0                	add    %eax,%eax
  100b31:	01 d0                	add    %edx,%eax
  100b33:	c1 e0 02             	shl    $0x2,%eax
  100b36:	05 08 e0 10 00       	add    $0x10e008,%eax
  100b3b:	8b 10                	mov    (%eax),%edx
  100b3d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b40:	83 c0 04             	add    $0x4,%eax
  100b43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b46:	83 e9 01             	sub    $0x1,%ecx
  100b49:	83 ec 04             	sub    $0x4,%esp
  100b4c:	ff 75 0c             	pushl  0xc(%ebp)
  100b4f:	50                   	push   %eax
  100b50:	51                   	push   %ecx
  100b51:	ff d2                	call   *%edx
  100b53:	83 c4 10             	add    $0x10,%esp
  100b56:	eb 25                	jmp    100b7d <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5f:	83 f8 02             	cmp    $0x2,%eax
  100b62:	76 9f                	jbe    100b03 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b64:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b67:	83 ec 08             	sub    $0x8,%esp
  100b6a:	50                   	push   %eax
  100b6b:	68 67 35 10 00       	push   $0x103567
  100b70:	e8 c8 f6 ff ff       	call   10023d <cprintf>
  100b75:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b7d:	c9                   	leave  
  100b7e:	c3                   	ret    

00100b7f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b7f:	55                   	push   %ebp
  100b80:	89 e5                	mov    %esp,%ebp
  100b82:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b85:	83 ec 0c             	sub    $0xc,%esp
  100b88:	68 80 35 10 00       	push   $0x103580
  100b8d:	e8 ab f6 ff ff       	call   10023d <cprintf>
  100b92:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b95:	83 ec 0c             	sub    $0xc,%esp
  100b98:	68 a8 35 10 00       	push   $0x1035a8
  100b9d:	e8 9b f6 ff ff       	call   10023d <cprintf>
  100ba2:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ba9:	74 0e                	je     100bb9 <kmonitor+0x3a>
        print_trapframe(tf);
  100bab:	83 ec 0c             	sub    $0xc,%esp
  100bae:	ff 75 08             	pushl  0x8(%ebp)
  100bb1:	e8 d7 0c 00 00       	call   10188d <print_trapframe>
  100bb6:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bb9:	83 ec 0c             	sub    $0xc,%esp
  100bbc:	68 cd 35 10 00       	push   $0x1035cd
  100bc1:	e8 1b f7 ff ff       	call   1002e1 <readline>
  100bc6:	83 c4 10             	add    $0x10,%esp
  100bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bd0:	74 e7                	je     100bb9 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bd2:	83 ec 08             	sub    $0x8,%esp
  100bd5:	ff 75 08             	pushl  0x8(%ebp)
  100bd8:	ff 75 f4             	pushl  -0xc(%ebp)
  100bdb:	e8 ef fe ff ff       	call   100acf <runcmd>
  100be0:	83 c4 10             	add    $0x10,%esp
  100be3:	85 c0                	test   %eax,%eax
  100be5:	78 02                	js     100be9 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100be7:	eb d0                	jmp    100bb9 <kmonitor+0x3a>
                break;
  100be9:	90                   	nop
            }
        }
    }
}
  100bea:	90                   	nop
  100beb:	c9                   	leave  
  100bec:	c3                   	ret    

00100bed <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100bed:	55                   	push   %ebp
  100bee:	89 e5                	mov    %esp,%ebp
  100bf0:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bfa:	eb 3c                	jmp    100c38 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bff:	89 d0                	mov    %edx,%eax
  100c01:	01 c0                	add    %eax,%eax
  100c03:	01 d0                	add    %edx,%eax
  100c05:	c1 e0 02             	shl    $0x2,%eax
  100c08:	05 04 e0 10 00       	add    $0x10e004,%eax
  100c0d:	8b 08                	mov    (%eax),%ecx
  100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c12:	89 d0                	mov    %edx,%eax
  100c14:	01 c0                	add    %eax,%eax
  100c16:	01 d0                	add    %edx,%eax
  100c18:	c1 e0 02             	shl    $0x2,%eax
  100c1b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c20:	8b 00                	mov    (%eax),%eax
  100c22:	83 ec 04             	sub    $0x4,%esp
  100c25:	51                   	push   %ecx
  100c26:	50                   	push   %eax
  100c27:	68 d1 35 10 00       	push   $0x1035d1
  100c2c:	e8 0c f6 ff ff       	call   10023d <cprintf>
  100c31:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3b:	83 f8 02             	cmp    $0x2,%eax
  100c3e:	76 bc                	jbe    100bfc <mon_help+0xf>
    }
    return 0;
  100c40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c45:	c9                   	leave  
  100c46:	c3                   	ret    

00100c47 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c47:	55                   	push   %ebp
  100c48:	89 e5                	mov    %esp,%ebp
  100c4a:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c4d:	e8 75 fc ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c57:	c9                   	leave  
  100c58:	c3                   	ret    

00100c59 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c59:	55                   	push   %ebp
  100c5a:	89 e5                	mov    %esp,%ebp
  100c5c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c5f:	e8 ad fd ff ff       	call   100a11 <print_stackframe>
    return 0;
  100c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c69:	c9                   	leave  
  100c6a:	c3                   	ret    

00100c6b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100c6b:	55                   	push   %ebp
  100c6c:	89 e5                	mov    %esp,%ebp
  100c6e:	83 ec 18             	sub    $0x18,%esp
  100c71:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100c77:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100c7b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100c7f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100c83:	ee                   	out    %al,(%dx)
  100c84:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100c8a:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100c8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100c92:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100c96:	ee                   	out    %al,(%dx)
  100c97:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100c9d:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100ca1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ca5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ca9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100caa:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100cb1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100cb4:	83 ec 0c             	sub    $0xc,%esp
  100cb7:	68 da 35 10 00       	push   $0x1035da
  100cbc:	e8 7c f5 ff ff       	call   10023d <cprintf>
  100cc1:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100cc4:	83 ec 0c             	sub    $0xc,%esp
  100cc7:	6a 00                	push   $0x0
  100cc9:	e8 d2 08 00 00       	call   1015a0 <pic_enable>
  100cce:	83 c4 10             	add    $0x10,%esp
}
  100cd1:	90                   	nop
  100cd2:	c9                   	leave  
  100cd3:	c3                   	ret    

00100cd4 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100cd4:	55                   	push   %ebp
  100cd5:	89 e5                	mov    %esp,%ebp
  100cd7:	83 ec 10             	sub    $0x10,%esp
  100cda:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ce0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ce4:	89 c2                	mov    %eax,%edx
  100ce6:	ec                   	in     (%dx),%al
  100ce7:	88 45 f1             	mov    %al,-0xf(%ebp)
  100cea:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100cf0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100cf4:	89 c2                	mov    %eax,%edx
  100cf6:	ec                   	in     (%dx),%al
  100cf7:	88 45 f5             	mov    %al,-0xb(%ebp)
  100cfa:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d00:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d04:	89 c2                	mov    %eax,%edx
  100d06:	ec                   	in     (%dx),%al
  100d07:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d0a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100d10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d14:	89 c2                	mov    %eax,%edx
  100d16:	ec                   	in     (%dx),%al
  100d17:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100d1a:	90                   	nop
  100d1b:	c9                   	leave  
  100d1c:	c3                   	ret    

00100d1d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100d1d:	55                   	push   %ebp
  100d1e:	89 e5                	mov    %esp,%ebp
  100d20:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100d23:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d2d:	0f b7 00             	movzwl (%eax),%eax
  100d30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d37:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d3f:	0f b7 00             	movzwl (%eax),%eax
  100d42:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100d46:	74 12                	je     100d5a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100d48:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100d4f:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100d56:	b4 03 
  100d58:	eb 13                	jmp    100d6d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d5d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100d61:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100d64:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100d6b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100d6d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100d74:	0f b7 c0             	movzwl %ax,%eax
  100d77:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100d7b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d7f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100d83:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100d87:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100d88:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100d8f:	83 c0 01             	add    $0x1,%eax
  100d92:	0f b7 c0             	movzwl %ax,%eax
  100d95:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d99:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100d9d:	89 c2                	mov    %eax,%edx
  100d9f:	ec                   	in     (%dx),%al
  100da0:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100da3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100da7:	0f b6 c0             	movzbl %al,%eax
  100daa:	c1 e0 08             	shl    $0x8,%eax
  100dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100db0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100db7:	0f b7 c0             	movzwl %ax,%eax
  100dba:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100dbe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dc2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dca:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100dcb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100dd2:	83 c0 01             	add    $0x1,%eax
  100dd5:	0f b7 c0             	movzwl %ax,%eax
  100dd8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ddc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100de0:	89 c2                	mov    %eax,%edx
  100de2:	ec                   	in     (%dx),%al
  100de3:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100de6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dea:	0f b6 c0             	movzbl %al,%eax
  100ded:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dfb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100e01:	90                   	nop
  100e02:	c9                   	leave  
  100e03:	c3                   	ret    

00100e04 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e04:	55                   	push   %ebp
  100e05:	89 e5                	mov    %esp,%ebp
  100e07:	83 ec 38             	sub    $0x38,%esp
  100e0a:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100e10:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e14:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100e18:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100e1c:	ee                   	out    %al,(%dx)
  100e1d:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100e23:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100e27:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100e2b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100e2f:	ee                   	out    %al,(%dx)
  100e30:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100e36:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100e3a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100e3e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100e42:	ee                   	out    %al,(%dx)
  100e43:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100e49:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100e4d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100e51:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100e55:	ee                   	out    %al,(%dx)
  100e56:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100e5c:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100e60:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100e64:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100e68:	ee                   	out    %al,(%dx)
  100e69:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100e6f:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100e73:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e77:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e7b:	ee                   	out    %al,(%dx)
  100e7c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100e82:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100e86:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e8a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e8e:	ee                   	out    %al,(%dx)
  100e8f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e95:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e99:	89 c2                	mov    %eax,%edx
  100e9b:	ec                   	in     (%dx),%al
  100e9c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e9f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ea3:	3c ff                	cmp    $0xff,%al
  100ea5:	0f 95 c0             	setne  %al
  100ea8:	0f b6 c0             	movzbl %al,%eax
  100eab:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100eb0:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eba:	89 c2                	mov    %eax,%edx
  100ebc:	ec                   	in     (%dx),%al
  100ebd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ec0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100ec6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100eca:	89 c2                	mov    %eax,%edx
  100ecc:	ec                   	in     (%dx),%al
  100ecd:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ed0:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100ed5:	85 c0                	test   %eax,%eax
  100ed7:	74 0d                	je     100ee6 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100ed9:	83 ec 0c             	sub    $0xc,%esp
  100edc:	6a 04                	push   $0x4
  100ede:	e8 bd 06 00 00       	call   1015a0 <pic_enable>
  100ee3:	83 c4 10             	add    $0x10,%esp
    }
}
  100ee6:	90                   	nop
  100ee7:	c9                   	leave  
  100ee8:	c3                   	ret    

00100ee9 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100ee9:	55                   	push   %ebp
  100eea:	89 e5                	mov    %esp,%ebp
  100eec:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ef6:	eb 09                	jmp    100f01 <lpt_putc_sub+0x18>
        delay();
  100ef8:	e8 d7 fd ff ff       	call   100cd4 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100efd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f01:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f07:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f0b:	89 c2                	mov    %eax,%edx
  100f0d:	ec                   	in     (%dx),%al
  100f0e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100f11:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100f15:	84 c0                	test   %al,%al
  100f17:	78 09                	js     100f22 <lpt_putc_sub+0x39>
  100f19:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100f20:	7e d6                	jle    100ef8 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100f22:	8b 45 08             	mov    0x8(%ebp),%eax
  100f25:	0f b6 c0             	movzbl %al,%eax
  100f28:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100f2e:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f31:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f35:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f39:	ee                   	out    %al,(%dx)
  100f3a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100f40:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100f44:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
  100f4d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100f53:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  100f57:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f5b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100f60:	90                   	nop
  100f61:	c9                   	leave  
  100f62:	c3                   	ret    

00100f63 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100f63:	55                   	push   %ebp
  100f64:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100f66:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100f6a:	74 0d                	je     100f79 <lpt_putc+0x16>
        lpt_putc_sub(c);
  100f6c:	ff 75 08             	pushl  0x8(%ebp)
  100f6f:	e8 75 ff ff ff       	call   100ee9 <lpt_putc_sub>
  100f74:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  100f77:	eb 1e                	jmp    100f97 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  100f79:	6a 08                	push   $0x8
  100f7b:	e8 69 ff ff ff       	call   100ee9 <lpt_putc_sub>
  100f80:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  100f83:	6a 20                	push   $0x20
  100f85:	e8 5f ff ff ff       	call   100ee9 <lpt_putc_sub>
  100f8a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  100f8d:	6a 08                	push   $0x8
  100f8f:	e8 55 ff ff ff       	call   100ee9 <lpt_putc_sub>
  100f94:	83 c4 04             	add    $0x4,%esp
}
  100f97:	90                   	nop
  100f98:	c9                   	leave  
  100f99:	c3                   	ret    

00100f9a <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100f9a:	55                   	push   %ebp
  100f9b:	89 e5                	mov    %esp,%ebp
  100f9d:	53                   	push   %ebx
  100f9e:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  100fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  100fa4:	b0 00                	mov    $0x0,%al
  100fa6:	85 c0                	test   %eax,%eax
  100fa8:	75 07                	jne    100fb1 <cga_putc+0x17>
        c |= 0x0700;
  100faa:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  100fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb4:	0f b6 c0             	movzbl %al,%eax
  100fb7:	83 f8 0a             	cmp    $0xa,%eax
  100fba:	74 52                	je     10100e <cga_putc+0x74>
  100fbc:	83 f8 0d             	cmp    $0xd,%eax
  100fbf:	74 5d                	je     10101e <cga_putc+0x84>
  100fc1:	83 f8 08             	cmp    $0x8,%eax
  100fc4:	0f 85 8e 00 00 00    	jne    101058 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  100fca:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  100fd1:	66 85 c0             	test   %ax,%ax
  100fd4:	0f 84 a4 00 00 00    	je     10107e <cga_putc+0xe4>
            crt_pos --;
  100fda:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  100fe1:	83 e8 01             	sub    $0x1,%eax
  100fe4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100fea:	8b 45 08             	mov    0x8(%ebp),%eax
  100fed:	b0 00                	mov    $0x0,%al
  100fef:	83 c8 20             	or     $0x20,%eax
  100ff2:	89 c1                	mov    %eax,%ecx
  100ff4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  100ff9:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  101000:	0f b7 d2             	movzwl %dx,%edx
  101003:	01 d2                	add    %edx,%edx
  101005:	01 d0                	add    %edx,%eax
  101007:	89 ca                	mov    %ecx,%edx
  101009:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10100c:	eb 70                	jmp    10107e <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  10100e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101015:	83 c0 50             	add    $0x50,%eax
  101018:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10101e:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101025:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10102c:	0f b7 c1             	movzwl %cx,%eax
  10102f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101035:	c1 e8 10             	shr    $0x10,%eax
  101038:	89 c2                	mov    %eax,%edx
  10103a:	66 c1 ea 06          	shr    $0x6,%dx
  10103e:	89 d0                	mov    %edx,%eax
  101040:	c1 e0 02             	shl    $0x2,%eax
  101043:	01 d0                	add    %edx,%eax
  101045:	c1 e0 04             	shl    $0x4,%eax
  101048:	29 c1                	sub    %eax,%ecx
  10104a:	89 ca                	mov    %ecx,%edx
  10104c:	89 d8                	mov    %ebx,%eax
  10104e:	29 d0                	sub    %edx,%eax
  101050:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101056:	eb 27                	jmp    10107f <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101058:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10105e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101065:	8d 50 01             	lea    0x1(%eax),%edx
  101068:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10106f:	0f b7 c0             	movzwl %ax,%eax
  101072:	01 c0                	add    %eax,%eax
  101074:	01 c8                	add    %ecx,%eax
  101076:	8b 55 08             	mov    0x8(%ebp),%edx
  101079:	66 89 10             	mov    %dx,(%eax)
        break;
  10107c:	eb 01                	jmp    10107f <cga_putc+0xe5>
        break;
  10107e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10107f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101086:	66 3d cf 07          	cmp    $0x7cf,%ax
  10108a:	76 59                	jbe    1010e5 <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10108c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101091:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101097:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10109c:	83 ec 04             	sub    $0x4,%esp
  10109f:	68 00 0f 00 00       	push   $0xf00
  1010a4:	52                   	push   %edx
  1010a5:	50                   	push   %eax
  1010a6:	e8 ef 1a 00 00       	call   102b9a <memmove>
  1010ab:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1010ae:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1010b5:	eb 15                	jmp    1010cc <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  1010b7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1010bf:	01 d2                	add    %edx,%edx
  1010c1:	01 d0                	add    %edx,%eax
  1010c3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1010c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1010cc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1010d3:	7e e2                	jle    1010b7 <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  1010d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dc:	83 e8 50             	sub    $0x50,%eax
  1010df:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1010e5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1010ec:	0f b7 c0             	movzwl %ax,%eax
  1010ef:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1010f3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1010f7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1010fb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1010ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101100:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101107:	66 c1 e8 08          	shr    $0x8,%ax
  10110b:	0f b6 c0             	movzbl %al,%eax
  10110e:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101115:	83 c2 01             	add    $0x1,%edx
  101118:	0f b7 d2             	movzwl %dx,%edx
  10111b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10111f:	88 45 e9             	mov    %al,-0x17(%ebp)
  101122:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101126:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10112a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10112b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101132:	0f b7 c0             	movzwl %ax,%eax
  101135:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101139:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10113d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101141:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101145:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101146:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114d:	0f b6 c0             	movzbl %al,%eax
  101150:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101157:	83 c2 01             	add    $0x1,%edx
  10115a:	0f b7 d2             	movzwl %dx,%edx
  10115d:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101161:	88 45 f1             	mov    %al,-0xf(%ebp)
  101164:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101168:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10116c:	ee                   	out    %al,(%dx)
}
  10116d:	90                   	nop
  10116e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101171:	c9                   	leave  
  101172:	c3                   	ret    

00101173 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101173:	55                   	push   %ebp
  101174:	89 e5                	mov    %esp,%ebp
  101176:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101180:	eb 09                	jmp    10118b <serial_putc_sub+0x18>
        delay();
  101182:	e8 4d fb ff ff       	call   100cd4 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101187:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10118b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101191:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101195:	89 c2                	mov    %eax,%edx
  101197:	ec                   	in     (%dx),%al
  101198:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10119b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10119f:	0f b6 c0             	movzbl %al,%eax
  1011a2:	83 e0 20             	and    $0x20,%eax
  1011a5:	85 c0                	test   %eax,%eax
  1011a7:	75 09                	jne    1011b2 <serial_putc_sub+0x3f>
  1011a9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1011b0:	7e d0                	jle    101182 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b5:	0f b6 c0             	movzbl %al,%eax
  1011b8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1011be:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011c1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1011c5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1011c9:	ee                   	out    %al,(%dx)
}
  1011ca:	90                   	nop
  1011cb:	c9                   	leave  
  1011cc:	c3                   	ret    

001011cd <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1011cd:	55                   	push   %ebp
  1011ce:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1011d0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1011d4:	74 0d                	je     1011e3 <serial_putc+0x16>
        serial_putc_sub(c);
  1011d6:	ff 75 08             	pushl  0x8(%ebp)
  1011d9:	e8 95 ff ff ff       	call   101173 <serial_putc_sub>
  1011de:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1011e1:	eb 1e                	jmp    101201 <serial_putc+0x34>
        serial_putc_sub('\b');
  1011e3:	6a 08                	push   $0x8
  1011e5:	e8 89 ff ff ff       	call   101173 <serial_putc_sub>
  1011ea:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1011ed:	6a 20                	push   $0x20
  1011ef:	e8 7f ff ff ff       	call   101173 <serial_putc_sub>
  1011f4:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1011f7:	6a 08                	push   $0x8
  1011f9:	e8 75 ff ff ff       	call   101173 <serial_putc_sub>
  1011fe:	83 c4 04             	add    $0x4,%esp
}
  101201:	90                   	nop
  101202:	c9                   	leave  
  101203:	c3                   	ret    

00101204 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101204:	55                   	push   %ebp
  101205:	89 e5                	mov    %esp,%ebp
  101207:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10120a:	eb 33                	jmp    10123f <cons_intr+0x3b>
        if (c != 0) {
  10120c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101210:	74 2d                	je     10123f <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101212:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101217:	8d 50 01             	lea    0x1(%eax),%edx
  10121a:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101223:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101229:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10122e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101233:	75 0a                	jne    10123f <cons_intr+0x3b>
                cons.wpos = 0;
  101235:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10123c:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10123f:	8b 45 08             	mov    0x8(%ebp),%eax
  101242:	ff d0                	call   *%eax
  101244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101247:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10124b:	75 bf                	jne    10120c <cons_intr+0x8>
            }
        }
    }
}
  10124d:	90                   	nop
  10124e:	c9                   	leave  
  10124f:	c3                   	ret    

00101250 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101250:	55                   	push   %ebp
  101251:	89 e5                	mov    %esp,%ebp
  101253:	83 ec 10             	sub    $0x10,%esp
  101256:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10125c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101260:	89 c2                	mov    %eax,%edx
  101262:	ec                   	in     (%dx),%al
  101263:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101266:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10126a:	0f b6 c0             	movzbl %al,%eax
  10126d:	83 e0 01             	and    $0x1,%eax
  101270:	85 c0                	test   %eax,%eax
  101272:	75 07                	jne    10127b <serial_proc_data+0x2b>
        return -1;
  101274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101279:	eb 2a                	jmp    1012a5 <serial_proc_data+0x55>
  10127b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101281:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101285:	89 c2                	mov    %eax,%edx
  101287:	ec                   	in     (%dx),%al
  101288:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10128b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10128f:	0f b6 c0             	movzbl %al,%eax
  101292:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101295:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101299:	75 07                	jne    1012a2 <serial_proc_data+0x52>
        c = '\b';
  10129b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1012a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1012a5:	c9                   	leave  
  1012a6:	c3                   	ret    

001012a7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1012a7:	55                   	push   %ebp
  1012a8:	89 e5                	mov    %esp,%ebp
  1012aa:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1012ad:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1012b2:	85 c0                	test   %eax,%eax
  1012b4:	74 10                	je     1012c6 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1012b6:	83 ec 0c             	sub    $0xc,%esp
  1012b9:	68 50 12 10 00       	push   $0x101250
  1012be:	e8 41 ff ff ff       	call   101204 <cons_intr>
  1012c3:	83 c4 10             	add    $0x10,%esp
    }
}
  1012c6:	90                   	nop
  1012c7:	c9                   	leave  
  1012c8:	c3                   	ret    

001012c9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1012c9:	55                   	push   %ebp
  1012ca:	89 e5                	mov    %esp,%ebp
  1012cc:	83 ec 28             	sub    $0x28,%esp
  1012cf:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1012d9:	89 c2                	mov    %eax,%edx
  1012db:	ec                   	in     (%dx),%al
  1012dc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1012df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1012e3:	0f b6 c0             	movzbl %al,%eax
  1012e6:	83 e0 01             	and    $0x1,%eax
  1012e9:	85 c0                	test   %eax,%eax
  1012eb:	75 0a                	jne    1012f7 <kbd_proc_data+0x2e>
        return -1;
  1012ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012f2:	e9 5d 01 00 00       	jmp    101454 <kbd_proc_data+0x18b>
  1012f7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101301:	89 c2                	mov    %eax,%edx
  101303:	ec                   	in     (%dx),%al
  101304:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101307:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10130b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10130e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101312:	75 17                	jne    10132b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101314:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101319:	83 c8 40             	or     $0x40,%eax
  10131c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101321:	b8 00 00 00 00       	mov    $0x0,%eax
  101326:	e9 29 01 00 00       	jmp    101454 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10132b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10132f:	84 c0                	test   %al,%al
  101331:	79 47                	jns    10137a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101333:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101338:	83 e0 40             	and    $0x40,%eax
  10133b:	85 c0                	test   %eax,%eax
  10133d:	75 09                	jne    101348 <kbd_proc_data+0x7f>
  10133f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101343:	83 e0 7f             	and    $0x7f,%eax
  101346:	eb 04                	jmp    10134c <kbd_proc_data+0x83>
  101348:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10134c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10134f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101353:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10135a:	83 c8 40             	or     $0x40,%eax
  10135d:	0f b6 c0             	movzbl %al,%eax
  101360:	f7 d0                	not    %eax
  101362:	89 c2                	mov    %eax,%edx
  101364:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101369:	21 d0                	and    %edx,%eax
  10136b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101370:	b8 00 00 00 00       	mov    $0x0,%eax
  101375:	e9 da 00 00 00       	jmp    101454 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10137a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10137f:	83 e0 40             	and    $0x40,%eax
  101382:	85 c0                	test   %eax,%eax
  101384:	74 11                	je     101397 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101386:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10138a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10138f:	83 e0 bf             	and    $0xffffffbf,%eax
  101392:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101397:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10139b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1013a2:	0f b6 d0             	movzbl %al,%edx
  1013a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013aa:	09 d0                	or     %edx,%eax
  1013ac:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1013b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013b5:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1013bc:	0f b6 d0             	movzbl %al,%edx
  1013bf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013c4:	31 d0                	xor    %edx,%eax
  1013c6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1013cb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013d0:	83 e0 03             	and    $0x3,%eax
  1013d3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1013da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013de:	01 d0                	add    %edx,%eax
  1013e0:	0f b6 00             	movzbl (%eax),%eax
  1013e3:	0f b6 c0             	movzbl %al,%eax
  1013e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1013e9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ee:	83 e0 08             	and    $0x8,%eax
  1013f1:	85 c0                	test   %eax,%eax
  1013f3:	74 22                	je     101417 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1013f5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1013f9:	7e 0c                	jle    101407 <kbd_proc_data+0x13e>
  1013fb:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1013ff:	7f 06                	jg     101407 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101401:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101405:	eb 10                	jmp    101417 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101407:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10140b:	7e 0a                	jle    101417 <kbd_proc_data+0x14e>
  10140d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101411:	7f 04                	jg     101417 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101413:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101417:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141c:	f7 d0                	not    %eax
  10141e:	83 e0 06             	and    $0x6,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	75 2c                	jne    101451 <kbd_proc_data+0x188>
  101425:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10142c:	75 23                	jne    101451 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10142e:	83 ec 0c             	sub    $0xc,%esp
  101431:	68 f5 35 10 00       	push   $0x1035f5
  101436:	e8 02 ee ff ff       	call   10023d <cprintf>
  10143b:	83 c4 10             	add    $0x10,%esp
  10143e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101444:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101448:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10144c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101450:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101451:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101454:	c9                   	leave  
  101455:	c3                   	ret    

00101456 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101456:	55                   	push   %ebp
  101457:	89 e5                	mov    %esp,%ebp
  101459:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10145c:	83 ec 0c             	sub    $0xc,%esp
  10145f:	68 c9 12 10 00       	push   $0x1012c9
  101464:	e8 9b fd ff ff       	call   101204 <cons_intr>
  101469:	83 c4 10             	add    $0x10,%esp
}
  10146c:	90                   	nop
  10146d:	c9                   	leave  
  10146e:	c3                   	ret    

0010146f <kbd_init>:

static void
kbd_init(void) {
  10146f:	55                   	push   %ebp
  101470:	89 e5                	mov    %esp,%ebp
  101472:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101475:	e8 dc ff ff ff       	call   101456 <kbd_intr>
    pic_enable(IRQ_KBD);
  10147a:	83 ec 0c             	sub    $0xc,%esp
  10147d:	6a 01                	push   $0x1
  10147f:	e8 1c 01 00 00       	call   1015a0 <pic_enable>
  101484:	83 c4 10             	add    $0x10,%esp
}
  101487:	90                   	nop
  101488:	c9                   	leave  
  101489:	c3                   	ret    

0010148a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10148a:	55                   	push   %ebp
  10148b:	89 e5                	mov    %esp,%ebp
  10148d:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101490:	e8 88 f8 ff ff       	call   100d1d <cga_init>
    serial_init();
  101495:	e8 6a f9 ff ff       	call   100e04 <serial_init>
    kbd_init();
  10149a:	e8 d0 ff ff ff       	call   10146f <kbd_init>
    if (!serial_exists) {
  10149f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1014a4:	85 c0                	test   %eax,%eax
  1014a6:	75 10                	jne    1014b8 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1014a8:	83 ec 0c             	sub    $0xc,%esp
  1014ab:	68 01 36 10 00       	push   $0x103601
  1014b0:	e8 88 ed ff ff       	call   10023d <cprintf>
  1014b5:	83 c4 10             	add    $0x10,%esp
    }
}
  1014b8:	90                   	nop
  1014b9:	c9                   	leave  
  1014ba:	c3                   	ret    

001014bb <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1014bb:	55                   	push   %ebp
  1014bc:	89 e5                	mov    %esp,%ebp
  1014be:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1014c1:	ff 75 08             	pushl  0x8(%ebp)
  1014c4:	e8 9a fa ff ff       	call   100f63 <lpt_putc>
  1014c9:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1014cc:	83 ec 0c             	sub    $0xc,%esp
  1014cf:	ff 75 08             	pushl  0x8(%ebp)
  1014d2:	e8 c3 fa ff ff       	call   100f9a <cga_putc>
  1014d7:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1014da:	83 ec 0c             	sub    $0xc,%esp
  1014dd:	ff 75 08             	pushl  0x8(%ebp)
  1014e0:	e8 e8 fc ff ff       	call   1011cd <serial_putc>
  1014e5:	83 c4 10             	add    $0x10,%esp
}
  1014e8:	90                   	nop
  1014e9:	c9                   	leave  
  1014ea:	c3                   	ret    

001014eb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1014eb:	55                   	push   %ebp
  1014ec:	89 e5                	mov    %esp,%ebp
  1014ee:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1014f1:	e8 b1 fd ff ff       	call   1012a7 <serial_intr>
    kbd_intr();
  1014f6:	e8 5b ff ff ff       	call   101456 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1014fb:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101501:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101506:	39 c2                	cmp    %eax,%edx
  101508:	74 36                	je     101540 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10150a:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10150f:	8d 50 01             	lea    0x1(%eax),%edx
  101512:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101518:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10151f:	0f b6 c0             	movzbl %al,%eax
  101522:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101525:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10152a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10152f:	75 0a                	jne    10153b <cons_getc+0x50>
            cons.rpos = 0;
  101531:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101538:	00 00 00 
        }
        return c;
  10153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10153e:	eb 05                	jmp    101545 <cons_getc+0x5a>
    }
    return 0;
  101540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101545:	c9                   	leave  
  101546:	c3                   	ret    

00101547 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101547:	55                   	push   %ebp
  101548:	89 e5                	mov    %esp,%ebp
  10154a:	83 ec 14             	sub    $0x14,%esp
  10154d:	8b 45 08             	mov    0x8(%ebp),%eax
  101550:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101554:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101558:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10155e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101563:	85 c0                	test   %eax,%eax
  101565:	74 36                	je     10159d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101567:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10156b:	0f b6 c0             	movzbl %al,%eax
  10156e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101574:	88 45 f9             	mov    %al,-0x7(%ebp)
  101577:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10157b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10157f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101580:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101584:	66 c1 e8 08          	shr    $0x8,%ax
  101588:	0f b6 c0             	movzbl %al,%eax
  10158b:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101591:	88 45 fd             	mov    %al,-0x3(%ebp)
  101594:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101598:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10159c:	ee                   	out    %al,(%dx)
    }
}
  10159d:	90                   	nop
  10159e:	c9                   	leave  
  10159f:	c3                   	ret    

001015a0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1015a0:	55                   	push   %ebp
  1015a1:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a6:	ba 01 00 00 00       	mov    $0x1,%edx
  1015ab:	89 c1                	mov    %eax,%ecx
  1015ad:	d3 e2                	shl    %cl,%edx
  1015af:	89 d0                	mov    %edx,%eax
  1015b1:	f7 d0                	not    %eax
  1015b3:	89 c2                	mov    %eax,%edx
  1015b5:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1015bc:	21 d0                	and    %edx,%eax
  1015be:	0f b7 c0             	movzwl %ax,%eax
  1015c1:	50                   	push   %eax
  1015c2:	e8 80 ff ff ff       	call   101547 <pic_setmask>
  1015c7:	83 c4 04             	add    $0x4,%esp
}
  1015ca:	90                   	nop
  1015cb:	c9                   	leave  
  1015cc:	c3                   	ret    

001015cd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1015d3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1015da:	00 00 00 
  1015dd:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1015e3:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1015e7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1015eb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1015ef:	ee                   	out    %al,(%dx)
  1015f0:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1015f6:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1015fa:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1015fe:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101602:	ee                   	out    %al,(%dx)
  101603:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101609:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10160d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101611:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101615:	ee                   	out    %al,(%dx)
  101616:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10161c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101620:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101624:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101628:	ee                   	out    %al,(%dx)
  101629:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10162f:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101633:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101637:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10163b:	ee                   	out    %al,(%dx)
  10163c:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101642:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101646:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10164a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10164e:	ee                   	out    %al,(%dx)
  10164f:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101655:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101659:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10165d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101661:	ee                   	out    %al,(%dx)
  101662:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101668:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  10166c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101670:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
  101675:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10167b:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10167f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101683:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101687:	ee                   	out    %al,(%dx)
  101688:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10168e:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101692:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101696:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10169a:	ee                   	out    %al,(%dx)
  10169b:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1016a1:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  1016a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016ad:	ee                   	out    %al,(%dx)
  1016ae:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016b4:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  1016b8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016bc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016c0:	ee                   	out    %al,(%dx)
  1016c1:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1016c7:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1016cb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016cf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1016da:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1016de:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1016e7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ee:	66 83 f8 ff          	cmp    $0xffff,%ax
  1016f2:	74 13                	je     101707 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1016f4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016fb:	0f b7 c0             	movzwl %ax,%eax
  1016fe:	50                   	push   %eax
  1016ff:	e8 43 fe ff ff       	call   101547 <pic_setmask>
  101704:	83 c4 04             	add    $0x4,%esp
    }
}
  101707:	90                   	nop
  101708:	c9                   	leave  
  101709:	c3                   	ret    

0010170a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10170d:	fb                   	sti    
    sti();
}
  10170e:	90                   	nop
  10170f:	5d                   	pop    %ebp
  101710:	c3                   	ret    

00101711 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101711:	55                   	push   %ebp
  101712:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101714:	fa                   	cli    
    cli();
}
  101715:	90                   	nop
  101716:	5d                   	pop    %ebp
  101717:	c3                   	ret    

00101718 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101718:	55                   	push   %ebp
  101719:	89 e5                	mov    %esp,%ebp
  10171b:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10171e:	83 ec 08             	sub    $0x8,%esp
  101721:	6a 64                	push   $0x64
  101723:	68 20 36 10 00       	push   $0x103620
  101728:	e8 10 eb ff ff       	call   10023d <cprintf>
  10172d:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101730:	83 ec 0c             	sub    $0xc,%esp
  101733:	68 2a 36 10 00       	push   $0x10362a
  101738:	e8 00 eb ff ff       	call   10023d <cprintf>
  10173d:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101740:	83 ec 04             	sub    $0x4,%esp
  101743:	68 38 36 10 00       	push   $0x103638
  101748:	6a 12                	push   $0x12
  10174a:	68 4e 36 10 00       	push   $0x10364e
  10174f:	e8 4f ec ff ff       	call   1003a3 <__panic>

00101754 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101754:	55                   	push   %ebp
  101755:	89 e5                	mov    %esp,%ebp
  101757:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t  __vectors[];
	for (int i = 0; i < 256; i++) {
  10175a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101761:	e9 c3 00 00 00       	jmp    101829 <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);
  101766:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101769:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101770:	89 c2                	mov    %eax,%edx
  101772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101775:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10177c:	00 
  10177d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101780:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101787:	00 08 00 
  10178a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10178d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101794:	00 
  101795:	83 e2 e0             	and    $0xffffffe0,%edx
  101798:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017a2:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1017a9:	00 
  1017aa:	83 e2 1f             	and    $0x1f,%edx
  1017ad:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1017b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017b7:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1017be:	00 
  1017bf:	83 e2 f0             	and    $0xfffffff0,%edx
  1017c2:	83 ca 0e             	or     $0xe,%edx
  1017c5:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1017cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017cf:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1017d6:	00 
  1017d7:	83 e2 ef             	and    $0xffffffef,%edx
  1017da:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1017e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017e4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1017eb:	00 
  1017ec:	83 e2 9f             	and    $0xffffff9f,%edx
  1017ef:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1017f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101800:	00 
  101801:	83 ca 80             	or     $0xffffff80,%edx
  101804:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180e:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101815:	c1 e8 10             	shr    $0x10,%eax
  101818:	89 c2                	mov    %eax,%edx
  10181a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181d:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101824:	00 
	for (int i = 0; i < 256; i++) {
  101825:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101829:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101830:	0f 8e 30 ff ff ff    	jle    101766 <idt_init+0x12>
  101836:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  10183d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101840:	0f 01 18             	lidtl  (%eax)
	}
	lidt(&idt_pd);
}
  101843:	90                   	nop
  101844:	c9                   	leave  
  101845:	c3                   	ret    

00101846 <trapname>:

static const char *
trapname(int trapno) {
  101846:	55                   	push   %ebp
  101847:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101849:	8b 45 08             	mov    0x8(%ebp),%eax
  10184c:	83 f8 13             	cmp    $0x13,%eax
  10184f:	77 0c                	ja     10185d <trapname+0x17>
        return excnames[trapno];
  101851:	8b 45 08             	mov    0x8(%ebp),%eax
  101854:	8b 04 85 a0 39 10 00 	mov    0x1039a0(,%eax,4),%eax
  10185b:	eb 18                	jmp    101875 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10185d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101861:	7e 0d                	jle    101870 <trapname+0x2a>
  101863:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101867:	7f 07                	jg     101870 <trapname+0x2a>
        return "Hardware Interrupt";
  101869:	b8 5f 36 10 00       	mov    $0x10365f,%eax
  10186e:	eb 05                	jmp    101875 <trapname+0x2f>
    }
    return "(unknown trap)";
  101870:	b8 72 36 10 00       	mov    $0x103672,%eax
}
  101875:	5d                   	pop    %ebp
  101876:	c3                   	ret    

00101877 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101877:	55                   	push   %ebp
  101878:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10187a:	8b 45 08             	mov    0x8(%ebp),%eax
  10187d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101881:	66 83 f8 08          	cmp    $0x8,%ax
  101885:	0f 94 c0             	sete   %al
  101888:	0f b6 c0             	movzbl %al,%eax
}
  10188b:	5d                   	pop    %ebp
  10188c:	c3                   	ret    

0010188d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10188d:	55                   	push   %ebp
  10188e:	89 e5                	mov    %esp,%ebp
  101890:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101893:	83 ec 08             	sub    $0x8,%esp
  101896:	ff 75 08             	pushl  0x8(%ebp)
  101899:	68 b3 36 10 00       	push   $0x1036b3
  10189e:	e8 9a e9 ff ff       	call   10023d <cprintf>
  1018a3:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1018a9:	83 ec 0c             	sub    $0xc,%esp
  1018ac:	50                   	push   %eax
  1018ad:	e8 b6 01 00 00       	call   101a68 <print_regs>
  1018b2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1018bc:	0f b7 c0             	movzwl %ax,%eax
  1018bf:	83 ec 08             	sub    $0x8,%esp
  1018c2:	50                   	push   %eax
  1018c3:	68 c4 36 10 00       	push   $0x1036c4
  1018c8:	e8 70 e9 ff ff       	call   10023d <cprintf>
  1018cd:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018d7:	0f b7 c0             	movzwl %ax,%eax
  1018da:	83 ec 08             	sub    $0x8,%esp
  1018dd:	50                   	push   %eax
  1018de:	68 d7 36 10 00       	push   $0x1036d7
  1018e3:	e8 55 e9 ff ff       	call   10023d <cprintf>
  1018e8:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ee:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018f2:	0f b7 c0             	movzwl %ax,%eax
  1018f5:	83 ec 08             	sub    $0x8,%esp
  1018f8:	50                   	push   %eax
  1018f9:	68 ea 36 10 00       	push   $0x1036ea
  1018fe:	e8 3a e9 ff ff       	call   10023d <cprintf>
  101903:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101906:	8b 45 08             	mov    0x8(%ebp),%eax
  101909:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10190d:	0f b7 c0             	movzwl %ax,%eax
  101910:	83 ec 08             	sub    $0x8,%esp
  101913:	50                   	push   %eax
  101914:	68 fd 36 10 00       	push   $0x1036fd
  101919:	e8 1f e9 ff ff       	call   10023d <cprintf>
  10191e:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101921:	8b 45 08             	mov    0x8(%ebp),%eax
  101924:	8b 40 30             	mov    0x30(%eax),%eax
  101927:	83 ec 0c             	sub    $0xc,%esp
  10192a:	50                   	push   %eax
  10192b:	e8 16 ff ff ff       	call   101846 <trapname>
  101930:	83 c4 10             	add    $0x10,%esp
  101933:	89 c2                	mov    %eax,%edx
  101935:	8b 45 08             	mov    0x8(%ebp),%eax
  101938:	8b 40 30             	mov    0x30(%eax),%eax
  10193b:	83 ec 04             	sub    $0x4,%esp
  10193e:	52                   	push   %edx
  10193f:	50                   	push   %eax
  101940:	68 10 37 10 00       	push   $0x103710
  101945:	e8 f3 e8 ff ff       	call   10023d <cprintf>
  10194a:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  10194d:	8b 45 08             	mov    0x8(%ebp),%eax
  101950:	8b 40 34             	mov    0x34(%eax),%eax
  101953:	83 ec 08             	sub    $0x8,%esp
  101956:	50                   	push   %eax
  101957:	68 22 37 10 00       	push   $0x103722
  10195c:	e8 dc e8 ff ff       	call   10023d <cprintf>
  101961:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101964:	8b 45 08             	mov    0x8(%ebp),%eax
  101967:	8b 40 38             	mov    0x38(%eax),%eax
  10196a:	83 ec 08             	sub    $0x8,%esp
  10196d:	50                   	push   %eax
  10196e:	68 31 37 10 00       	push   $0x103731
  101973:	e8 c5 e8 ff ff       	call   10023d <cprintf>
  101978:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10197b:	8b 45 08             	mov    0x8(%ebp),%eax
  10197e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101982:	0f b7 c0             	movzwl %ax,%eax
  101985:	83 ec 08             	sub    $0x8,%esp
  101988:	50                   	push   %eax
  101989:	68 40 37 10 00       	push   $0x103740
  10198e:	e8 aa e8 ff ff       	call   10023d <cprintf>
  101993:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101996:	8b 45 08             	mov    0x8(%ebp),%eax
  101999:	8b 40 40             	mov    0x40(%eax),%eax
  10199c:	83 ec 08             	sub    $0x8,%esp
  10199f:	50                   	push   %eax
  1019a0:	68 53 37 10 00       	push   $0x103753
  1019a5:	e8 93 e8 ff ff       	call   10023d <cprintf>
  1019aa:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1019b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  1019bb:	eb 3f                	jmp    1019fc <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  1019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c0:	8b 50 40             	mov    0x40(%eax),%edx
  1019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019c6:	21 d0                	and    %edx,%eax
  1019c8:	85 c0                	test   %eax,%eax
  1019ca:	74 29                	je     1019f5 <print_trapframe+0x168>
  1019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019cf:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019d6:	85 c0                	test   %eax,%eax
  1019d8:	74 1b                	je     1019f5 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  1019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019dd:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019e4:	83 ec 08             	sub    $0x8,%esp
  1019e7:	50                   	push   %eax
  1019e8:	68 62 37 10 00       	push   $0x103762
  1019ed:	e8 4b e8 ff ff       	call   10023d <cprintf>
  1019f2:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1019f9:	d1 65 f0             	shll   -0x10(%ebp)
  1019fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019ff:	83 f8 17             	cmp    $0x17,%eax
  101a02:	76 b9                	jbe    1019bd <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a04:	8b 45 08             	mov    0x8(%ebp),%eax
  101a07:	8b 40 40             	mov    0x40(%eax),%eax
  101a0a:	c1 e8 0c             	shr    $0xc,%eax
  101a0d:	83 e0 03             	and    $0x3,%eax
  101a10:	83 ec 08             	sub    $0x8,%esp
  101a13:	50                   	push   %eax
  101a14:	68 66 37 10 00       	push   $0x103766
  101a19:	e8 1f e8 ff ff       	call   10023d <cprintf>
  101a1e:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101a21:	83 ec 0c             	sub    $0xc,%esp
  101a24:	ff 75 08             	pushl  0x8(%ebp)
  101a27:	e8 4b fe ff ff       	call   101877 <trap_in_kernel>
  101a2c:	83 c4 10             	add    $0x10,%esp
  101a2f:	85 c0                	test   %eax,%eax
  101a31:	75 32                	jne    101a65 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101a33:	8b 45 08             	mov    0x8(%ebp),%eax
  101a36:	8b 40 44             	mov    0x44(%eax),%eax
  101a39:	83 ec 08             	sub    $0x8,%esp
  101a3c:	50                   	push   %eax
  101a3d:	68 6f 37 10 00       	push   $0x10376f
  101a42:	e8 f6 e7 ff ff       	call   10023d <cprintf>
  101a47:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a51:	0f b7 c0             	movzwl %ax,%eax
  101a54:	83 ec 08             	sub    $0x8,%esp
  101a57:	50                   	push   %eax
  101a58:	68 7e 37 10 00       	push   $0x10377e
  101a5d:	e8 db e7 ff ff       	call   10023d <cprintf>
  101a62:	83 c4 10             	add    $0x10,%esp
    }
}
  101a65:	90                   	nop
  101a66:	c9                   	leave  
  101a67:	c3                   	ret    

00101a68 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a68:	55                   	push   %ebp
  101a69:	89 e5                	mov    %esp,%ebp
  101a6b:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a71:	8b 00                	mov    (%eax),%eax
  101a73:	83 ec 08             	sub    $0x8,%esp
  101a76:	50                   	push   %eax
  101a77:	68 91 37 10 00       	push   $0x103791
  101a7c:	e8 bc e7 ff ff       	call   10023d <cprintf>
  101a81:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a84:	8b 45 08             	mov    0x8(%ebp),%eax
  101a87:	8b 40 04             	mov    0x4(%eax),%eax
  101a8a:	83 ec 08             	sub    $0x8,%esp
  101a8d:	50                   	push   %eax
  101a8e:	68 a0 37 10 00       	push   $0x1037a0
  101a93:	e8 a5 e7 ff ff       	call   10023d <cprintf>
  101a98:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9e:	8b 40 08             	mov    0x8(%eax),%eax
  101aa1:	83 ec 08             	sub    $0x8,%esp
  101aa4:	50                   	push   %eax
  101aa5:	68 af 37 10 00       	push   $0x1037af
  101aaa:	e8 8e e7 ff ff       	call   10023d <cprintf>
  101aaf:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  101ab8:	83 ec 08             	sub    $0x8,%esp
  101abb:	50                   	push   %eax
  101abc:	68 be 37 10 00       	push   $0x1037be
  101ac1:	e8 77 e7 ff ff       	call   10023d <cprintf>
  101ac6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  101acc:	8b 40 10             	mov    0x10(%eax),%eax
  101acf:	83 ec 08             	sub    $0x8,%esp
  101ad2:	50                   	push   %eax
  101ad3:	68 cd 37 10 00       	push   $0x1037cd
  101ad8:	e8 60 e7 ff ff       	call   10023d <cprintf>
  101add:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae3:	8b 40 14             	mov    0x14(%eax),%eax
  101ae6:	83 ec 08             	sub    $0x8,%esp
  101ae9:	50                   	push   %eax
  101aea:	68 dc 37 10 00       	push   $0x1037dc
  101aef:	e8 49 e7 ff ff       	call   10023d <cprintf>
  101af4:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 18             	mov    0x18(%eax),%eax
  101afd:	83 ec 08             	sub    $0x8,%esp
  101b00:	50                   	push   %eax
  101b01:	68 eb 37 10 00       	push   $0x1037eb
  101b06:	e8 32 e7 ff ff       	call   10023d <cprintf>
  101b0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b14:	83 ec 08             	sub    $0x8,%esp
  101b17:	50                   	push   %eax
  101b18:	68 fa 37 10 00       	push   $0x1037fa
  101b1d:	e8 1b e7 ff ff       	call   10023d <cprintf>
  101b22:	83 c4 10             	add    $0x10,%esp
}
  101b25:	90                   	nop
  101b26:	c9                   	leave  
  101b27:	c3                   	ret    

00101b28 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101b28:	55                   	push   %ebp
  101b29:	89 e5                	mov    %esp,%ebp
  101b2b:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	8b 40 30             	mov    0x30(%eax),%eax
  101b34:	83 f8 2f             	cmp    $0x2f,%eax
  101b37:	77 1d                	ja     101b56 <trap_dispatch+0x2e>
  101b39:	83 f8 2e             	cmp    $0x2e,%eax
  101b3c:	0f 83 f4 00 00 00    	jae    101c36 <trap_dispatch+0x10e>
  101b42:	83 f8 21             	cmp    $0x21,%eax
  101b45:	74 7e                	je     101bc5 <trap_dispatch+0x9d>
  101b47:	83 f8 24             	cmp    $0x24,%eax
  101b4a:	74 55                	je     101ba1 <trap_dispatch+0x79>
  101b4c:	83 f8 20             	cmp    $0x20,%eax
  101b4f:	74 16                	je     101b67 <trap_dispatch+0x3f>
  101b51:	e9 aa 00 00 00       	jmp    101c00 <trap_dispatch+0xd8>
  101b56:	83 e8 78             	sub    $0x78,%eax
  101b59:	83 f8 01             	cmp    $0x1,%eax
  101b5c:	0f 87 9e 00 00 00    	ja     101c00 <trap_dispatch+0xd8>
  101b62:	e9 82 00 00 00       	jmp    101be9 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks += 1;
  101b67:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101b6c:	83 c0 01             	add    $0x1,%eax
  101b6f:	a3 08 f9 10 00       	mov    %eax,0x10f908
		if (ticks%TICK_NUM == 0) {
  101b74:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101b7a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101b7f:	89 c8                	mov    %ecx,%eax
  101b81:	f7 e2                	mul    %edx
  101b83:	89 d0                	mov    %edx,%eax
  101b85:	c1 e8 05             	shr    $0x5,%eax
  101b88:	6b c0 64             	imul   $0x64,%eax,%eax
  101b8b:	29 c1                	sub    %eax,%ecx
  101b8d:	89 c8                	mov    %ecx,%eax
  101b8f:	85 c0                	test   %eax,%eax
  101b91:	0f 85 a2 00 00 00    	jne    101c39 <trap_dispatch+0x111>
			print_ticks();
  101b97:	e8 7c fb ff ff       	call   101718 <print_ticks>
		}
        break;
  101b9c:	e9 98 00 00 00       	jmp    101c39 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ba1:	e8 45 f9 ff ff       	call   1014eb <cons_getc>
  101ba6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ba9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101bad:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101bb1:	83 ec 04             	sub    $0x4,%esp
  101bb4:	52                   	push   %edx
  101bb5:	50                   	push   %eax
  101bb6:	68 09 38 10 00       	push   $0x103809
  101bbb:	e8 7d e6 ff ff       	call   10023d <cprintf>
  101bc0:	83 c4 10             	add    $0x10,%esp
        break;
  101bc3:	eb 75                	jmp    101c3a <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101bc5:	e8 21 f9 ff ff       	call   1014eb <cons_getc>
  101bca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101bcd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101bd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101bd5:	83 ec 04             	sub    $0x4,%esp
  101bd8:	52                   	push   %edx
  101bd9:	50                   	push   %eax
  101bda:	68 1b 38 10 00       	push   $0x10381b
  101bdf:	e8 59 e6 ff ff       	call   10023d <cprintf>
  101be4:	83 c4 10             	add    $0x10,%esp
        break;
  101be7:	eb 51                	jmp    101c3a <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101be9:	83 ec 04             	sub    $0x4,%esp
  101bec:	68 2a 38 10 00       	push   $0x10382a
  101bf1:	68 ab 00 00 00       	push   $0xab
  101bf6:	68 4e 36 10 00       	push   $0x10364e
  101bfb:	e8 a3 e7 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c07:	0f b7 c0             	movzwl %ax,%eax
  101c0a:	83 e0 03             	and    $0x3,%eax
  101c0d:	85 c0                	test   %eax,%eax
  101c0f:	75 29                	jne    101c3a <trap_dispatch+0x112>
            print_trapframe(tf);
  101c11:	83 ec 0c             	sub    $0xc,%esp
  101c14:	ff 75 08             	pushl  0x8(%ebp)
  101c17:	e8 71 fc ff ff       	call   10188d <print_trapframe>
  101c1c:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101c1f:	83 ec 04             	sub    $0x4,%esp
  101c22:	68 3a 38 10 00       	push   $0x10383a
  101c27:	68 b5 00 00 00       	push   $0xb5
  101c2c:	68 4e 36 10 00       	push   $0x10364e
  101c31:	e8 6d e7 ff ff       	call   1003a3 <__panic>
        break;
  101c36:	90                   	nop
  101c37:	eb 01                	jmp    101c3a <trap_dispatch+0x112>
        break;
  101c39:	90                   	nop
        }
    }
}
  101c3a:	90                   	nop
  101c3b:	c9                   	leave  
  101c3c:	c3                   	ret    

00101c3d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101c3d:	55                   	push   %ebp
  101c3e:	89 e5                	mov    %esp,%ebp
  101c40:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101c43:	83 ec 0c             	sub    $0xc,%esp
  101c46:	ff 75 08             	pushl  0x8(%ebp)
  101c49:	e8 da fe ff ff       	call   101b28 <trap_dispatch>
  101c4e:	83 c4 10             	add    $0x10,%esp
}
  101c51:	90                   	nop
  101c52:	c9                   	leave  
  101c53:	c3                   	ret    

00101c54 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101c54:	6a 00                	push   $0x0
  pushl $0
  101c56:	6a 00                	push   $0x0
  jmp __alltraps
  101c58:	e9 67 0a 00 00       	jmp    1026c4 <__alltraps>

00101c5d <vector1>:
.globl vector1
vector1:
  pushl $0
  101c5d:	6a 00                	push   $0x0
  pushl $1
  101c5f:	6a 01                	push   $0x1
  jmp __alltraps
  101c61:	e9 5e 0a 00 00       	jmp    1026c4 <__alltraps>

00101c66 <vector2>:
.globl vector2
vector2:
  pushl $0
  101c66:	6a 00                	push   $0x0
  pushl $2
  101c68:	6a 02                	push   $0x2
  jmp __alltraps
  101c6a:	e9 55 0a 00 00       	jmp    1026c4 <__alltraps>

00101c6f <vector3>:
.globl vector3
vector3:
  pushl $0
  101c6f:	6a 00                	push   $0x0
  pushl $3
  101c71:	6a 03                	push   $0x3
  jmp __alltraps
  101c73:	e9 4c 0a 00 00       	jmp    1026c4 <__alltraps>

00101c78 <vector4>:
.globl vector4
vector4:
  pushl $0
  101c78:	6a 00                	push   $0x0
  pushl $4
  101c7a:	6a 04                	push   $0x4
  jmp __alltraps
  101c7c:	e9 43 0a 00 00       	jmp    1026c4 <__alltraps>

00101c81 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c81:	6a 00                	push   $0x0
  pushl $5
  101c83:	6a 05                	push   $0x5
  jmp __alltraps
  101c85:	e9 3a 0a 00 00       	jmp    1026c4 <__alltraps>

00101c8a <vector6>:
.globl vector6
vector6:
  pushl $0
  101c8a:	6a 00                	push   $0x0
  pushl $6
  101c8c:	6a 06                	push   $0x6
  jmp __alltraps
  101c8e:	e9 31 0a 00 00       	jmp    1026c4 <__alltraps>

00101c93 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c93:	6a 00                	push   $0x0
  pushl $7
  101c95:	6a 07                	push   $0x7
  jmp __alltraps
  101c97:	e9 28 0a 00 00       	jmp    1026c4 <__alltraps>

00101c9c <vector8>:
.globl vector8
vector8:
  pushl $8
  101c9c:	6a 08                	push   $0x8
  jmp __alltraps
  101c9e:	e9 21 0a 00 00       	jmp    1026c4 <__alltraps>

00101ca3 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ca3:	6a 09                	push   $0x9
  jmp __alltraps
  101ca5:	e9 1a 0a 00 00       	jmp    1026c4 <__alltraps>

00101caa <vector10>:
.globl vector10
vector10:
  pushl $10
  101caa:	6a 0a                	push   $0xa
  jmp __alltraps
  101cac:	e9 13 0a 00 00       	jmp    1026c4 <__alltraps>

00101cb1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101cb1:	6a 0b                	push   $0xb
  jmp __alltraps
  101cb3:	e9 0c 0a 00 00       	jmp    1026c4 <__alltraps>

00101cb8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101cb8:	6a 0c                	push   $0xc
  jmp __alltraps
  101cba:	e9 05 0a 00 00       	jmp    1026c4 <__alltraps>

00101cbf <vector13>:
.globl vector13
vector13:
  pushl $13
  101cbf:	6a 0d                	push   $0xd
  jmp __alltraps
  101cc1:	e9 fe 09 00 00       	jmp    1026c4 <__alltraps>

00101cc6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101cc6:	6a 0e                	push   $0xe
  jmp __alltraps
  101cc8:	e9 f7 09 00 00       	jmp    1026c4 <__alltraps>

00101ccd <vector15>:
.globl vector15
vector15:
  pushl $0
  101ccd:	6a 00                	push   $0x0
  pushl $15
  101ccf:	6a 0f                	push   $0xf
  jmp __alltraps
  101cd1:	e9 ee 09 00 00       	jmp    1026c4 <__alltraps>

00101cd6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101cd6:	6a 00                	push   $0x0
  pushl $16
  101cd8:	6a 10                	push   $0x10
  jmp __alltraps
  101cda:	e9 e5 09 00 00       	jmp    1026c4 <__alltraps>

00101cdf <vector17>:
.globl vector17
vector17:
  pushl $17
  101cdf:	6a 11                	push   $0x11
  jmp __alltraps
  101ce1:	e9 de 09 00 00       	jmp    1026c4 <__alltraps>

00101ce6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ce6:	6a 00                	push   $0x0
  pushl $18
  101ce8:	6a 12                	push   $0x12
  jmp __alltraps
  101cea:	e9 d5 09 00 00       	jmp    1026c4 <__alltraps>

00101cef <vector19>:
.globl vector19
vector19:
  pushl $0
  101cef:	6a 00                	push   $0x0
  pushl $19
  101cf1:	6a 13                	push   $0x13
  jmp __alltraps
  101cf3:	e9 cc 09 00 00       	jmp    1026c4 <__alltraps>

00101cf8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101cf8:	6a 00                	push   $0x0
  pushl $20
  101cfa:	6a 14                	push   $0x14
  jmp __alltraps
  101cfc:	e9 c3 09 00 00       	jmp    1026c4 <__alltraps>

00101d01 <vector21>:
.globl vector21
vector21:
  pushl $0
  101d01:	6a 00                	push   $0x0
  pushl $21
  101d03:	6a 15                	push   $0x15
  jmp __alltraps
  101d05:	e9 ba 09 00 00       	jmp    1026c4 <__alltraps>

00101d0a <vector22>:
.globl vector22
vector22:
  pushl $0
  101d0a:	6a 00                	push   $0x0
  pushl $22
  101d0c:	6a 16                	push   $0x16
  jmp __alltraps
  101d0e:	e9 b1 09 00 00       	jmp    1026c4 <__alltraps>

00101d13 <vector23>:
.globl vector23
vector23:
  pushl $0
  101d13:	6a 00                	push   $0x0
  pushl $23
  101d15:	6a 17                	push   $0x17
  jmp __alltraps
  101d17:	e9 a8 09 00 00       	jmp    1026c4 <__alltraps>

00101d1c <vector24>:
.globl vector24
vector24:
  pushl $0
  101d1c:	6a 00                	push   $0x0
  pushl $24
  101d1e:	6a 18                	push   $0x18
  jmp __alltraps
  101d20:	e9 9f 09 00 00       	jmp    1026c4 <__alltraps>

00101d25 <vector25>:
.globl vector25
vector25:
  pushl $0
  101d25:	6a 00                	push   $0x0
  pushl $25
  101d27:	6a 19                	push   $0x19
  jmp __alltraps
  101d29:	e9 96 09 00 00       	jmp    1026c4 <__alltraps>

00101d2e <vector26>:
.globl vector26
vector26:
  pushl $0
  101d2e:	6a 00                	push   $0x0
  pushl $26
  101d30:	6a 1a                	push   $0x1a
  jmp __alltraps
  101d32:	e9 8d 09 00 00       	jmp    1026c4 <__alltraps>

00101d37 <vector27>:
.globl vector27
vector27:
  pushl $0
  101d37:	6a 00                	push   $0x0
  pushl $27
  101d39:	6a 1b                	push   $0x1b
  jmp __alltraps
  101d3b:	e9 84 09 00 00       	jmp    1026c4 <__alltraps>

00101d40 <vector28>:
.globl vector28
vector28:
  pushl $0
  101d40:	6a 00                	push   $0x0
  pushl $28
  101d42:	6a 1c                	push   $0x1c
  jmp __alltraps
  101d44:	e9 7b 09 00 00       	jmp    1026c4 <__alltraps>

00101d49 <vector29>:
.globl vector29
vector29:
  pushl $0
  101d49:	6a 00                	push   $0x0
  pushl $29
  101d4b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101d4d:	e9 72 09 00 00       	jmp    1026c4 <__alltraps>

00101d52 <vector30>:
.globl vector30
vector30:
  pushl $0
  101d52:	6a 00                	push   $0x0
  pushl $30
  101d54:	6a 1e                	push   $0x1e
  jmp __alltraps
  101d56:	e9 69 09 00 00       	jmp    1026c4 <__alltraps>

00101d5b <vector31>:
.globl vector31
vector31:
  pushl $0
  101d5b:	6a 00                	push   $0x0
  pushl $31
  101d5d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101d5f:	e9 60 09 00 00       	jmp    1026c4 <__alltraps>

00101d64 <vector32>:
.globl vector32
vector32:
  pushl $0
  101d64:	6a 00                	push   $0x0
  pushl $32
  101d66:	6a 20                	push   $0x20
  jmp __alltraps
  101d68:	e9 57 09 00 00       	jmp    1026c4 <__alltraps>

00101d6d <vector33>:
.globl vector33
vector33:
  pushl $0
  101d6d:	6a 00                	push   $0x0
  pushl $33
  101d6f:	6a 21                	push   $0x21
  jmp __alltraps
  101d71:	e9 4e 09 00 00       	jmp    1026c4 <__alltraps>

00101d76 <vector34>:
.globl vector34
vector34:
  pushl $0
  101d76:	6a 00                	push   $0x0
  pushl $34
  101d78:	6a 22                	push   $0x22
  jmp __alltraps
  101d7a:	e9 45 09 00 00       	jmp    1026c4 <__alltraps>

00101d7f <vector35>:
.globl vector35
vector35:
  pushl $0
  101d7f:	6a 00                	push   $0x0
  pushl $35
  101d81:	6a 23                	push   $0x23
  jmp __alltraps
  101d83:	e9 3c 09 00 00       	jmp    1026c4 <__alltraps>

00101d88 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d88:	6a 00                	push   $0x0
  pushl $36
  101d8a:	6a 24                	push   $0x24
  jmp __alltraps
  101d8c:	e9 33 09 00 00       	jmp    1026c4 <__alltraps>

00101d91 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d91:	6a 00                	push   $0x0
  pushl $37
  101d93:	6a 25                	push   $0x25
  jmp __alltraps
  101d95:	e9 2a 09 00 00       	jmp    1026c4 <__alltraps>

00101d9a <vector38>:
.globl vector38
vector38:
  pushl $0
  101d9a:	6a 00                	push   $0x0
  pushl $38
  101d9c:	6a 26                	push   $0x26
  jmp __alltraps
  101d9e:	e9 21 09 00 00       	jmp    1026c4 <__alltraps>

00101da3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101da3:	6a 00                	push   $0x0
  pushl $39
  101da5:	6a 27                	push   $0x27
  jmp __alltraps
  101da7:	e9 18 09 00 00       	jmp    1026c4 <__alltraps>

00101dac <vector40>:
.globl vector40
vector40:
  pushl $0
  101dac:	6a 00                	push   $0x0
  pushl $40
  101dae:	6a 28                	push   $0x28
  jmp __alltraps
  101db0:	e9 0f 09 00 00       	jmp    1026c4 <__alltraps>

00101db5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101db5:	6a 00                	push   $0x0
  pushl $41
  101db7:	6a 29                	push   $0x29
  jmp __alltraps
  101db9:	e9 06 09 00 00       	jmp    1026c4 <__alltraps>

00101dbe <vector42>:
.globl vector42
vector42:
  pushl $0
  101dbe:	6a 00                	push   $0x0
  pushl $42
  101dc0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101dc2:	e9 fd 08 00 00       	jmp    1026c4 <__alltraps>

00101dc7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101dc7:	6a 00                	push   $0x0
  pushl $43
  101dc9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101dcb:	e9 f4 08 00 00       	jmp    1026c4 <__alltraps>

00101dd0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101dd0:	6a 00                	push   $0x0
  pushl $44
  101dd2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101dd4:	e9 eb 08 00 00       	jmp    1026c4 <__alltraps>

00101dd9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101dd9:	6a 00                	push   $0x0
  pushl $45
  101ddb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ddd:	e9 e2 08 00 00       	jmp    1026c4 <__alltraps>

00101de2 <vector46>:
.globl vector46
vector46:
  pushl $0
  101de2:	6a 00                	push   $0x0
  pushl $46
  101de4:	6a 2e                	push   $0x2e
  jmp __alltraps
  101de6:	e9 d9 08 00 00       	jmp    1026c4 <__alltraps>

00101deb <vector47>:
.globl vector47
vector47:
  pushl $0
  101deb:	6a 00                	push   $0x0
  pushl $47
  101ded:	6a 2f                	push   $0x2f
  jmp __alltraps
  101def:	e9 d0 08 00 00       	jmp    1026c4 <__alltraps>

00101df4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $48
  101df6:	6a 30                	push   $0x30
  jmp __alltraps
  101df8:	e9 c7 08 00 00       	jmp    1026c4 <__alltraps>

00101dfd <vector49>:
.globl vector49
vector49:
  pushl $0
  101dfd:	6a 00                	push   $0x0
  pushl $49
  101dff:	6a 31                	push   $0x31
  jmp __alltraps
  101e01:	e9 be 08 00 00       	jmp    1026c4 <__alltraps>

00101e06 <vector50>:
.globl vector50
vector50:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $50
  101e08:	6a 32                	push   $0x32
  jmp __alltraps
  101e0a:	e9 b5 08 00 00       	jmp    1026c4 <__alltraps>

00101e0f <vector51>:
.globl vector51
vector51:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $51
  101e11:	6a 33                	push   $0x33
  jmp __alltraps
  101e13:	e9 ac 08 00 00       	jmp    1026c4 <__alltraps>

00101e18 <vector52>:
.globl vector52
vector52:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $52
  101e1a:	6a 34                	push   $0x34
  jmp __alltraps
  101e1c:	e9 a3 08 00 00       	jmp    1026c4 <__alltraps>

00101e21 <vector53>:
.globl vector53
vector53:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $53
  101e23:	6a 35                	push   $0x35
  jmp __alltraps
  101e25:	e9 9a 08 00 00       	jmp    1026c4 <__alltraps>

00101e2a <vector54>:
.globl vector54
vector54:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $54
  101e2c:	6a 36                	push   $0x36
  jmp __alltraps
  101e2e:	e9 91 08 00 00       	jmp    1026c4 <__alltraps>

00101e33 <vector55>:
.globl vector55
vector55:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $55
  101e35:	6a 37                	push   $0x37
  jmp __alltraps
  101e37:	e9 88 08 00 00       	jmp    1026c4 <__alltraps>

00101e3c <vector56>:
.globl vector56
vector56:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $56
  101e3e:	6a 38                	push   $0x38
  jmp __alltraps
  101e40:	e9 7f 08 00 00       	jmp    1026c4 <__alltraps>

00101e45 <vector57>:
.globl vector57
vector57:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $57
  101e47:	6a 39                	push   $0x39
  jmp __alltraps
  101e49:	e9 76 08 00 00       	jmp    1026c4 <__alltraps>

00101e4e <vector58>:
.globl vector58
vector58:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $58
  101e50:	6a 3a                	push   $0x3a
  jmp __alltraps
  101e52:	e9 6d 08 00 00       	jmp    1026c4 <__alltraps>

00101e57 <vector59>:
.globl vector59
vector59:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $59
  101e59:	6a 3b                	push   $0x3b
  jmp __alltraps
  101e5b:	e9 64 08 00 00       	jmp    1026c4 <__alltraps>

00101e60 <vector60>:
.globl vector60
vector60:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $60
  101e62:	6a 3c                	push   $0x3c
  jmp __alltraps
  101e64:	e9 5b 08 00 00       	jmp    1026c4 <__alltraps>

00101e69 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $61
  101e6b:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e6d:	e9 52 08 00 00       	jmp    1026c4 <__alltraps>

00101e72 <vector62>:
.globl vector62
vector62:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $62
  101e74:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e76:	e9 49 08 00 00       	jmp    1026c4 <__alltraps>

00101e7b <vector63>:
.globl vector63
vector63:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $63
  101e7d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e7f:	e9 40 08 00 00       	jmp    1026c4 <__alltraps>

00101e84 <vector64>:
.globl vector64
vector64:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $64
  101e86:	6a 40                	push   $0x40
  jmp __alltraps
  101e88:	e9 37 08 00 00       	jmp    1026c4 <__alltraps>

00101e8d <vector65>:
.globl vector65
vector65:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $65
  101e8f:	6a 41                	push   $0x41
  jmp __alltraps
  101e91:	e9 2e 08 00 00       	jmp    1026c4 <__alltraps>

00101e96 <vector66>:
.globl vector66
vector66:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $66
  101e98:	6a 42                	push   $0x42
  jmp __alltraps
  101e9a:	e9 25 08 00 00       	jmp    1026c4 <__alltraps>

00101e9f <vector67>:
.globl vector67
vector67:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $67
  101ea1:	6a 43                	push   $0x43
  jmp __alltraps
  101ea3:	e9 1c 08 00 00       	jmp    1026c4 <__alltraps>

00101ea8 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $68
  101eaa:	6a 44                	push   $0x44
  jmp __alltraps
  101eac:	e9 13 08 00 00       	jmp    1026c4 <__alltraps>

00101eb1 <vector69>:
.globl vector69
vector69:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $69
  101eb3:	6a 45                	push   $0x45
  jmp __alltraps
  101eb5:	e9 0a 08 00 00       	jmp    1026c4 <__alltraps>

00101eba <vector70>:
.globl vector70
vector70:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $70
  101ebc:	6a 46                	push   $0x46
  jmp __alltraps
  101ebe:	e9 01 08 00 00       	jmp    1026c4 <__alltraps>

00101ec3 <vector71>:
.globl vector71
vector71:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $71
  101ec5:	6a 47                	push   $0x47
  jmp __alltraps
  101ec7:	e9 f8 07 00 00       	jmp    1026c4 <__alltraps>

00101ecc <vector72>:
.globl vector72
vector72:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $72
  101ece:	6a 48                	push   $0x48
  jmp __alltraps
  101ed0:	e9 ef 07 00 00       	jmp    1026c4 <__alltraps>

00101ed5 <vector73>:
.globl vector73
vector73:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $73
  101ed7:	6a 49                	push   $0x49
  jmp __alltraps
  101ed9:	e9 e6 07 00 00       	jmp    1026c4 <__alltraps>

00101ede <vector74>:
.globl vector74
vector74:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $74
  101ee0:	6a 4a                	push   $0x4a
  jmp __alltraps
  101ee2:	e9 dd 07 00 00       	jmp    1026c4 <__alltraps>

00101ee7 <vector75>:
.globl vector75
vector75:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $75
  101ee9:	6a 4b                	push   $0x4b
  jmp __alltraps
  101eeb:	e9 d4 07 00 00       	jmp    1026c4 <__alltraps>

00101ef0 <vector76>:
.globl vector76
vector76:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $76
  101ef2:	6a 4c                	push   $0x4c
  jmp __alltraps
  101ef4:	e9 cb 07 00 00       	jmp    1026c4 <__alltraps>

00101ef9 <vector77>:
.globl vector77
vector77:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $77
  101efb:	6a 4d                	push   $0x4d
  jmp __alltraps
  101efd:	e9 c2 07 00 00       	jmp    1026c4 <__alltraps>

00101f02 <vector78>:
.globl vector78
vector78:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $78
  101f04:	6a 4e                	push   $0x4e
  jmp __alltraps
  101f06:	e9 b9 07 00 00       	jmp    1026c4 <__alltraps>

00101f0b <vector79>:
.globl vector79
vector79:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $79
  101f0d:	6a 4f                	push   $0x4f
  jmp __alltraps
  101f0f:	e9 b0 07 00 00       	jmp    1026c4 <__alltraps>

00101f14 <vector80>:
.globl vector80
vector80:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $80
  101f16:	6a 50                	push   $0x50
  jmp __alltraps
  101f18:	e9 a7 07 00 00       	jmp    1026c4 <__alltraps>

00101f1d <vector81>:
.globl vector81
vector81:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $81
  101f1f:	6a 51                	push   $0x51
  jmp __alltraps
  101f21:	e9 9e 07 00 00       	jmp    1026c4 <__alltraps>

00101f26 <vector82>:
.globl vector82
vector82:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $82
  101f28:	6a 52                	push   $0x52
  jmp __alltraps
  101f2a:	e9 95 07 00 00       	jmp    1026c4 <__alltraps>

00101f2f <vector83>:
.globl vector83
vector83:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $83
  101f31:	6a 53                	push   $0x53
  jmp __alltraps
  101f33:	e9 8c 07 00 00       	jmp    1026c4 <__alltraps>

00101f38 <vector84>:
.globl vector84
vector84:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $84
  101f3a:	6a 54                	push   $0x54
  jmp __alltraps
  101f3c:	e9 83 07 00 00       	jmp    1026c4 <__alltraps>

00101f41 <vector85>:
.globl vector85
vector85:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $85
  101f43:	6a 55                	push   $0x55
  jmp __alltraps
  101f45:	e9 7a 07 00 00       	jmp    1026c4 <__alltraps>

00101f4a <vector86>:
.globl vector86
vector86:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $86
  101f4c:	6a 56                	push   $0x56
  jmp __alltraps
  101f4e:	e9 71 07 00 00       	jmp    1026c4 <__alltraps>

00101f53 <vector87>:
.globl vector87
vector87:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $87
  101f55:	6a 57                	push   $0x57
  jmp __alltraps
  101f57:	e9 68 07 00 00       	jmp    1026c4 <__alltraps>

00101f5c <vector88>:
.globl vector88
vector88:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $88
  101f5e:	6a 58                	push   $0x58
  jmp __alltraps
  101f60:	e9 5f 07 00 00       	jmp    1026c4 <__alltraps>

00101f65 <vector89>:
.globl vector89
vector89:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $89
  101f67:	6a 59                	push   $0x59
  jmp __alltraps
  101f69:	e9 56 07 00 00       	jmp    1026c4 <__alltraps>

00101f6e <vector90>:
.globl vector90
vector90:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $90
  101f70:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f72:	e9 4d 07 00 00       	jmp    1026c4 <__alltraps>

00101f77 <vector91>:
.globl vector91
vector91:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $91
  101f79:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f7b:	e9 44 07 00 00       	jmp    1026c4 <__alltraps>

00101f80 <vector92>:
.globl vector92
vector92:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $92
  101f82:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f84:	e9 3b 07 00 00       	jmp    1026c4 <__alltraps>

00101f89 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $93
  101f8b:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f8d:	e9 32 07 00 00       	jmp    1026c4 <__alltraps>

00101f92 <vector94>:
.globl vector94
vector94:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $94
  101f94:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f96:	e9 29 07 00 00       	jmp    1026c4 <__alltraps>

00101f9b <vector95>:
.globl vector95
vector95:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $95
  101f9d:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f9f:	e9 20 07 00 00       	jmp    1026c4 <__alltraps>

00101fa4 <vector96>:
.globl vector96
vector96:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $96
  101fa6:	6a 60                	push   $0x60
  jmp __alltraps
  101fa8:	e9 17 07 00 00       	jmp    1026c4 <__alltraps>

00101fad <vector97>:
.globl vector97
vector97:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $97
  101faf:	6a 61                	push   $0x61
  jmp __alltraps
  101fb1:	e9 0e 07 00 00       	jmp    1026c4 <__alltraps>

00101fb6 <vector98>:
.globl vector98
vector98:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $98
  101fb8:	6a 62                	push   $0x62
  jmp __alltraps
  101fba:	e9 05 07 00 00       	jmp    1026c4 <__alltraps>

00101fbf <vector99>:
.globl vector99
vector99:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $99
  101fc1:	6a 63                	push   $0x63
  jmp __alltraps
  101fc3:	e9 fc 06 00 00       	jmp    1026c4 <__alltraps>

00101fc8 <vector100>:
.globl vector100
vector100:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $100
  101fca:	6a 64                	push   $0x64
  jmp __alltraps
  101fcc:	e9 f3 06 00 00       	jmp    1026c4 <__alltraps>

00101fd1 <vector101>:
.globl vector101
vector101:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $101
  101fd3:	6a 65                	push   $0x65
  jmp __alltraps
  101fd5:	e9 ea 06 00 00       	jmp    1026c4 <__alltraps>

00101fda <vector102>:
.globl vector102
vector102:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $102
  101fdc:	6a 66                	push   $0x66
  jmp __alltraps
  101fde:	e9 e1 06 00 00       	jmp    1026c4 <__alltraps>

00101fe3 <vector103>:
.globl vector103
vector103:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $103
  101fe5:	6a 67                	push   $0x67
  jmp __alltraps
  101fe7:	e9 d8 06 00 00       	jmp    1026c4 <__alltraps>

00101fec <vector104>:
.globl vector104
vector104:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $104
  101fee:	6a 68                	push   $0x68
  jmp __alltraps
  101ff0:	e9 cf 06 00 00       	jmp    1026c4 <__alltraps>

00101ff5 <vector105>:
.globl vector105
vector105:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $105
  101ff7:	6a 69                	push   $0x69
  jmp __alltraps
  101ff9:	e9 c6 06 00 00       	jmp    1026c4 <__alltraps>

00101ffe <vector106>:
.globl vector106
vector106:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $106
  102000:	6a 6a                	push   $0x6a
  jmp __alltraps
  102002:	e9 bd 06 00 00       	jmp    1026c4 <__alltraps>

00102007 <vector107>:
.globl vector107
vector107:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $107
  102009:	6a 6b                	push   $0x6b
  jmp __alltraps
  10200b:	e9 b4 06 00 00       	jmp    1026c4 <__alltraps>

00102010 <vector108>:
.globl vector108
vector108:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $108
  102012:	6a 6c                	push   $0x6c
  jmp __alltraps
  102014:	e9 ab 06 00 00       	jmp    1026c4 <__alltraps>

00102019 <vector109>:
.globl vector109
vector109:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $109
  10201b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10201d:	e9 a2 06 00 00       	jmp    1026c4 <__alltraps>

00102022 <vector110>:
.globl vector110
vector110:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $110
  102024:	6a 6e                	push   $0x6e
  jmp __alltraps
  102026:	e9 99 06 00 00       	jmp    1026c4 <__alltraps>

0010202b <vector111>:
.globl vector111
vector111:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $111
  10202d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10202f:	e9 90 06 00 00       	jmp    1026c4 <__alltraps>

00102034 <vector112>:
.globl vector112
vector112:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $112
  102036:	6a 70                	push   $0x70
  jmp __alltraps
  102038:	e9 87 06 00 00       	jmp    1026c4 <__alltraps>

0010203d <vector113>:
.globl vector113
vector113:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $113
  10203f:	6a 71                	push   $0x71
  jmp __alltraps
  102041:	e9 7e 06 00 00       	jmp    1026c4 <__alltraps>

00102046 <vector114>:
.globl vector114
vector114:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $114
  102048:	6a 72                	push   $0x72
  jmp __alltraps
  10204a:	e9 75 06 00 00       	jmp    1026c4 <__alltraps>

0010204f <vector115>:
.globl vector115
vector115:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $115
  102051:	6a 73                	push   $0x73
  jmp __alltraps
  102053:	e9 6c 06 00 00       	jmp    1026c4 <__alltraps>

00102058 <vector116>:
.globl vector116
vector116:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $116
  10205a:	6a 74                	push   $0x74
  jmp __alltraps
  10205c:	e9 63 06 00 00       	jmp    1026c4 <__alltraps>

00102061 <vector117>:
.globl vector117
vector117:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $117
  102063:	6a 75                	push   $0x75
  jmp __alltraps
  102065:	e9 5a 06 00 00       	jmp    1026c4 <__alltraps>

0010206a <vector118>:
.globl vector118
vector118:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $118
  10206c:	6a 76                	push   $0x76
  jmp __alltraps
  10206e:	e9 51 06 00 00       	jmp    1026c4 <__alltraps>

00102073 <vector119>:
.globl vector119
vector119:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $119
  102075:	6a 77                	push   $0x77
  jmp __alltraps
  102077:	e9 48 06 00 00       	jmp    1026c4 <__alltraps>

0010207c <vector120>:
.globl vector120
vector120:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $120
  10207e:	6a 78                	push   $0x78
  jmp __alltraps
  102080:	e9 3f 06 00 00       	jmp    1026c4 <__alltraps>

00102085 <vector121>:
.globl vector121
vector121:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $121
  102087:	6a 79                	push   $0x79
  jmp __alltraps
  102089:	e9 36 06 00 00       	jmp    1026c4 <__alltraps>

0010208e <vector122>:
.globl vector122
vector122:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $122
  102090:	6a 7a                	push   $0x7a
  jmp __alltraps
  102092:	e9 2d 06 00 00       	jmp    1026c4 <__alltraps>

00102097 <vector123>:
.globl vector123
vector123:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $123
  102099:	6a 7b                	push   $0x7b
  jmp __alltraps
  10209b:	e9 24 06 00 00       	jmp    1026c4 <__alltraps>

001020a0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $124
  1020a2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1020a4:	e9 1b 06 00 00       	jmp    1026c4 <__alltraps>

001020a9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $125
  1020ab:	6a 7d                	push   $0x7d
  jmp __alltraps
  1020ad:	e9 12 06 00 00       	jmp    1026c4 <__alltraps>

001020b2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $126
  1020b4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1020b6:	e9 09 06 00 00       	jmp    1026c4 <__alltraps>

001020bb <vector127>:
.globl vector127
vector127:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $127
  1020bd:	6a 7f                	push   $0x7f
  jmp __alltraps
  1020bf:	e9 00 06 00 00       	jmp    1026c4 <__alltraps>

001020c4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $128
  1020c6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1020cb:	e9 f4 05 00 00       	jmp    1026c4 <__alltraps>

001020d0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $129
  1020d2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1020d7:	e9 e8 05 00 00       	jmp    1026c4 <__alltraps>

001020dc <vector130>:
.globl vector130
vector130:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $130
  1020de:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1020e3:	e9 dc 05 00 00       	jmp    1026c4 <__alltraps>

001020e8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $131
  1020ea:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1020ef:	e9 d0 05 00 00       	jmp    1026c4 <__alltraps>

001020f4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $132
  1020f6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1020fb:	e9 c4 05 00 00       	jmp    1026c4 <__alltraps>

00102100 <vector133>:
.globl vector133
vector133:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $133
  102102:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102107:	e9 b8 05 00 00       	jmp    1026c4 <__alltraps>

0010210c <vector134>:
.globl vector134
vector134:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $134
  10210e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102113:	e9 ac 05 00 00       	jmp    1026c4 <__alltraps>

00102118 <vector135>:
.globl vector135
vector135:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $135
  10211a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10211f:	e9 a0 05 00 00       	jmp    1026c4 <__alltraps>

00102124 <vector136>:
.globl vector136
vector136:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $136
  102126:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10212b:	e9 94 05 00 00       	jmp    1026c4 <__alltraps>

00102130 <vector137>:
.globl vector137
vector137:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $137
  102132:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102137:	e9 88 05 00 00       	jmp    1026c4 <__alltraps>

0010213c <vector138>:
.globl vector138
vector138:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $138
  10213e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102143:	e9 7c 05 00 00       	jmp    1026c4 <__alltraps>

00102148 <vector139>:
.globl vector139
vector139:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $139
  10214a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10214f:	e9 70 05 00 00       	jmp    1026c4 <__alltraps>

00102154 <vector140>:
.globl vector140
vector140:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $140
  102156:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10215b:	e9 64 05 00 00       	jmp    1026c4 <__alltraps>

00102160 <vector141>:
.globl vector141
vector141:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $141
  102162:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102167:	e9 58 05 00 00       	jmp    1026c4 <__alltraps>

0010216c <vector142>:
.globl vector142
vector142:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $142
  10216e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102173:	e9 4c 05 00 00       	jmp    1026c4 <__alltraps>

00102178 <vector143>:
.globl vector143
vector143:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $143
  10217a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10217f:	e9 40 05 00 00       	jmp    1026c4 <__alltraps>

00102184 <vector144>:
.globl vector144
vector144:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $144
  102186:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10218b:	e9 34 05 00 00       	jmp    1026c4 <__alltraps>

00102190 <vector145>:
.globl vector145
vector145:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $145
  102192:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102197:	e9 28 05 00 00       	jmp    1026c4 <__alltraps>

0010219c <vector146>:
.globl vector146
vector146:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $146
  10219e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1021a3:	e9 1c 05 00 00       	jmp    1026c4 <__alltraps>

001021a8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $147
  1021aa:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1021af:	e9 10 05 00 00       	jmp    1026c4 <__alltraps>

001021b4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $148
  1021b6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1021bb:	e9 04 05 00 00       	jmp    1026c4 <__alltraps>

001021c0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $149
  1021c2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1021c7:	e9 f8 04 00 00       	jmp    1026c4 <__alltraps>

001021cc <vector150>:
.globl vector150
vector150:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $150
  1021ce:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1021d3:	e9 ec 04 00 00       	jmp    1026c4 <__alltraps>

001021d8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $151
  1021da:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1021df:	e9 e0 04 00 00       	jmp    1026c4 <__alltraps>

001021e4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $152
  1021e6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1021eb:	e9 d4 04 00 00       	jmp    1026c4 <__alltraps>

001021f0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $153
  1021f2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1021f7:	e9 c8 04 00 00       	jmp    1026c4 <__alltraps>

001021fc <vector154>:
.globl vector154
vector154:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $154
  1021fe:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102203:	e9 bc 04 00 00       	jmp    1026c4 <__alltraps>

00102208 <vector155>:
.globl vector155
vector155:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $155
  10220a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10220f:	e9 b0 04 00 00       	jmp    1026c4 <__alltraps>

00102214 <vector156>:
.globl vector156
vector156:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $156
  102216:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10221b:	e9 a4 04 00 00       	jmp    1026c4 <__alltraps>

00102220 <vector157>:
.globl vector157
vector157:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $157
  102222:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102227:	e9 98 04 00 00       	jmp    1026c4 <__alltraps>

0010222c <vector158>:
.globl vector158
vector158:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $158
  10222e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102233:	e9 8c 04 00 00       	jmp    1026c4 <__alltraps>

00102238 <vector159>:
.globl vector159
vector159:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $159
  10223a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10223f:	e9 80 04 00 00       	jmp    1026c4 <__alltraps>

00102244 <vector160>:
.globl vector160
vector160:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $160
  102246:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10224b:	e9 74 04 00 00       	jmp    1026c4 <__alltraps>

00102250 <vector161>:
.globl vector161
vector161:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $161
  102252:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102257:	e9 68 04 00 00       	jmp    1026c4 <__alltraps>

0010225c <vector162>:
.globl vector162
vector162:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $162
  10225e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102263:	e9 5c 04 00 00       	jmp    1026c4 <__alltraps>

00102268 <vector163>:
.globl vector163
vector163:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $163
  10226a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10226f:	e9 50 04 00 00       	jmp    1026c4 <__alltraps>

00102274 <vector164>:
.globl vector164
vector164:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $164
  102276:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10227b:	e9 44 04 00 00       	jmp    1026c4 <__alltraps>

00102280 <vector165>:
.globl vector165
vector165:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $165
  102282:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102287:	e9 38 04 00 00       	jmp    1026c4 <__alltraps>

0010228c <vector166>:
.globl vector166
vector166:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $166
  10228e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102293:	e9 2c 04 00 00       	jmp    1026c4 <__alltraps>

00102298 <vector167>:
.globl vector167
vector167:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $167
  10229a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10229f:	e9 20 04 00 00       	jmp    1026c4 <__alltraps>

001022a4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $168
  1022a6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1022ab:	e9 14 04 00 00       	jmp    1026c4 <__alltraps>

001022b0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $169
  1022b2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1022b7:	e9 08 04 00 00       	jmp    1026c4 <__alltraps>

001022bc <vector170>:
.globl vector170
vector170:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $170
  1022be:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1022c3:	e9 fc 03 00 00       	jmp    1026c4 <__alltraps>

001022c8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $171
  1022ca:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1022cf:	e9 f0 03 00 00       	jmp    1026c4 <__alltraps>

001022d4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $172
  1022d6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1022db:	e9 e4 03 00 00       	jmp    1026c4 <__alltraps>

001022e0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $173
  1022e2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1022e7:	e9 d8 03 00 00       	jmp    1026c4 <__alltraps>

001022ec <vector174>:
.globl vector174
vector174:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $174
  1022ee:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1022f3:	e9 cc 03 00 00       	jmp    1026c4 <__alltraps>

001022f8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $175
  1022fa:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1022ff:	e9 c0 03 00 00       	jmp    1026c4 <__alltraps>

00102304 <vector176>:
.globl vector176
vector176:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $176
  102306:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10230b:	e9 b4 03 00 00       	jmp    1026c4 <__alltraps>

00102310 <vector177>:
.globl vector177
vector177:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $177
  102312:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102317:	e9 a8 03 00 00       	jmp    1026c4 <__alltraps>

0010231c <vector178>:
.globl vector178
vector178:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $178
  10231e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102323:	e9 9c 03 00 00       	jmp    1026c4 <__alltraps>

00102328 <vector179>:
.globl vector179
vector179:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $179
  10232a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10232f:	e9 90 03 00 00       	jmp    1026c4 <__alltraps>

00102334 <vector180>:
.globl vector180
vector180:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $180
  102336:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10233b:	e9 84 03 00 00       	jmp    1026c4 <__alltraps>

00102340 <vector181>:
.globl vector181
vector181:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $181
  102342:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102347:	e9 78 03 00 00       	jmp    1026c4 <__alltraps>

0010234c <vector182>:
.globl vector182
vector182:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $182
  10234e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102353:	e9 6c 03 00 00       	jmp    1026c4 <__alltraps>

00102358 <vector183>:
.globl vector183
vector183:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $183
  10235a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10235f:	e9 60 03 00 00       	jmp    1026c4 <__alltraps>

00102364 <vector184>:
.globl vector184
vector184:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $184
  102366:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10236b:	e9 54 03 00 00       	jmp    1026c4 <__alltraps>

00102370 <vector185>:
.globl vector185
vector185:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $185
  102372:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102377:	e9 48 03 00 00       	jmp    1026c4 <__alltraps>

0010237c <vector186>:
.globl vector186
vector186:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $186
  10237e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102383:	e9 3c 03 00 00       	jmp    1026c4 <__alltraps>

00102388 <vector187>:
.globl vector187
vector187:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $187
  10238a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10238f:	e9 30 03 00 00       	jmp    1026c4 <__alltraps>

00102394 <vector188>:
.globl vector188
vector188:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $188
  102396:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10239b:	e9 24 03 00 00       	jmp    1026c4 <__alltraps>

001023a0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $189
  1023a2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1023a7:	e9 18 03 00 00       	jmp    1026c4 <__alltraps>

001023ac <vector190>:
.globl vector190
vector190:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $190
  1023ae:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1023b3:	e9 0c 03 00 00       	jmp    1026c4 <__alltraps>

001023b8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $191
  1023ba:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1023bf:	e9 00 03 00 00       	jmp    1026c4 <__alltraps>

001023c4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $192
  1023c6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1023cb:	e9 f4 02 00 00       	jmp    1026c4 <__alltraps>

001023d0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $193
  1023d2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1023d7:	e9 e8 02 00 00       	jmp    1026c4 <__alltraps>

001023dc <vector194>:
.globl vector194
vector194:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $194
  1023de:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1023e3:	e9 dc 02 00 00       	jmp    1026c4 <__alltraps>

001023e8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $195
  1023ea:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1023ef:	e9 d0 02 00 00       	jmp    1026c4 <__alltraps>

001023f4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $196
  1023f6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1023fb:	e9 c4 02 00 00       	jmp    1026c4 <__alltraps>

00102400 <vector197>:
.globl vector197
vector197:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $197
  102402:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102407:	e9 b8 02 00 00       	jmp    1026c4 <__alltraps>

0010240c <vector198>:
.globl vector198
vector198:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $198
  10240e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102413:	e9 ac 02 00 00       	jmp    1026c4 <__alltraps>

00102418 <vector199>:
.globl vector199
vector199:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $199
  10241a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10241f:	e9 a0 02 00 00       	jmp    1026c4 <__alltraps>

00102424 <vector200>:
.globl vector200
vector200:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $200
  102426:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10242b:	e9 94 02 00 00       	jmp    1026c4 <__alltraps>

00102430 <vector201>:
.globl vector201
vector201:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $201
  102432:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102437:	e9 88 02 00 00       	jmp    1026c4 <__alltraps>

0010243c <vector202>:
.globl vector202
vector202:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $202
  10243e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102443:	e9 7c 02 00 00       	jmp    1026c4 <__alltraps>

00102448 <vector203>:
.globl vector203
vector203:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $203
  10244a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10244f:	e9 70 02 00 00       	jmp    1026c4 <__alltraps>

00102454 <vector204>:
.globl vector204
vector204:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $204
  102456:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10245b:	e9 64 02 00 00       	jmp    1026c4 <__alltraps>

00102460 <vector205>:
.globl vector205
vector205:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $205
  102462:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102467:	e9 58 02 00 00       	jmp    1026c4 <__alltraps>

0010246c <vector206>:
.globl vector206
vector206:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $206
  10246e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102473:	e9 4c 02 00 00       	jmp    1026c4 <__alltraps>

00102478 <vector207>:
.globl vector207
vector207:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $207
  10247a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10247f:	e9 40 02 00 00       	jmp    1026c4 <__alltraps>

00102484 <vector208>:
.globl vector208
vector208:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $208
  102486:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10248b:	e9 34 02 00 00       	jmp    1026c4 <__alltraps>

00102490 <vector209>:
.globl vector209
vector209:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $209
  102492:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102497:	e9 28 02 00 00       	jmp    1026c4 <__alltraps>

0010249c <vector210>:
.globl vector210
vector210:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $210
  10249e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1024a3:	e9 1c 02 00 00       	jmp    1026c4 <__alltraps>

001024a8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $211
  1024aa:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1024af:	e9 10 02 00 00       	jmp    1026c4 <__alltraps>

001024b4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $212
  1024b6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1024bb:	e9 04 02 00 00       	jmp    1026c4 <__alltraps>

001024c0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $213
  1024c2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1024c7:	e9 f8 01 00 00       	jmp    1026c4 <__alltraps>

001024cc <vector214>:
.globl vector214
vector214:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $214
  1024ce:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1024d3:	e9 ec 01 00 00       	jmp    1026c4 <__alltraps>

001024d8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $215
  1024da:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1024df:	e9 e0 01 00 00       	jmp    1026c4 <__alltraps>

001024e4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $216
  1024e6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1024eb:	e9 d4 01 00 00       	jmp    1026c4 <__alltraps>

001024f0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $217
  1024f2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1024f7:	e9 c8 01 00 00       	jmp    1026c4 <__alltraps>

001024fc <vector218>:
.globl vector218
vector218:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $218
  1024fe:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102503:	e9 bc 01 00 00       	jmp    1026c4 <__alltraps>

00102508 <vector219>:
.globl vector219
vector219:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $219
  10250a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10250f:	e9 b0 01 00 00       	jmp    1026c4 <__alltraps>

00102514 <vector220>:
.globl vector220
vector220:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $220
  102516:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10251b:	e9 a4 01 00 00       	jmp    1026c4 <__alltraps>

00102520 <vector221>:
.globl vector221
vector221:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $221
  102522:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102527:	e9 98 01 00 00       	jmp    1026c4 <__alltraps>

0010252c <vector222>:
.globl vector222
vector222:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $222
  10252e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102533:	e9 8c 01 00 00       	jmp    1026c4 <__alltraps>

00102538 <vector223>:
.globl vector223
vector223:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $223
  10253a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10253f:	e9 80 01 00 00       	jmp    1026c4 <__alltraps>

00102544 <vector224>:
.globl vector224
vector224:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $224
  102546:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10254b:	e9 74 01 00 00       	jmp    1026c4 <__alltraps>

00102550 <vector225>:
.globl vector225
vector225:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $225
  102552:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102557:	e9 68 01 00 00       	jmp    1026c4 <__alltraps>

0010255c <vector226>:
.globl vector226
vector226:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $226
  10255e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102563:	e9 5c 01 00 00       	jmp    1026c4 <__alltraps>

00102568 <vector227>:
.globl vector227
vector227:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $227
  10256a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10256f:	e9 50 01 00 00       	jmp    1026c4 <__alltraps>

00102574 <vector228>:
.globl vector228
vector228:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $228
  102576:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10257b:	e9 44 01 00 00       	jmp    1026c4 <__alltraps>

00102580 <vector229>:
.globl vector229
vector229:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $229
  102582:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102587:	e9 38 01 00 00       	jmp    1026c4 <__alltraps>

0010258c <vector230>:
.globl vector230
vector230:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $230
  10258e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102593:	e9 2c 01 00 00       	jmp    1026c4 <__alltraps>

00102598 <vector231>:
.globl vector231
vector231:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $231
  10259a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10259f:	e9 20 01 00 00       	jmp    1026c4 <__alltraps>

001025a4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $232
  1025a6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1025ab:	e9 14 01 00 00       	jmp    1026c4 <__alltraps>

001025b0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $233
  1025b2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1025b7:	e9 08 01 00 00       	jmp    1026c4 <__alltraps>

001025bc <vector234>:
.globl vector234
vector234:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $234
  1025be:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1025c3:	e9 fc 00 00 00       	jmp    1026c4 <__alltraps>

001025c8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $235
  1025ca:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1025cf:	e9 f0 00 00 00       	jmp    1026c4 <__alltraps>

001025d4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $236
  1025d6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1025db:	e9 e4 00 00 00       	jmp    1026c4 <__alltraps>

001025e0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $237
  1025e2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1025e7:	e9 d8 00 00 00       	jmp    1026c4 <__alltraps>

001025ec <vector238>:
.globl vector238
vector238:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $238
  1025ee:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1025f3:	e9 cc 00 00 00       	jmp    1026c4 <__alltraps>

001025f8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $239
  1025fa:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1025ff:	e9 c0 00 00 00       	jmp    1026c4 <__alltraps>

00102604 <vector240>:
.globl vector240
vector240:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $240
  102606:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10260b:	e9 b4 00 00 00       	jmp    1026c4 <__alltraps>

00102610 <vector241>:
.globl vector241
vector241:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $241
  102612:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102617:	e9 a8 00 00 00       	jmp    1026c4 <__alltraps>

0010261c <vector242>:
.globl vector242
vector242:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $242
  10261e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102623:	e9 9c 00 00 00       	jmp    1026c4 <__alltraps>

00102628 <vector243>:
.globl vector243
vector243:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $243
  10262a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10262f:	e9 90 00 00 00       	jmp    1026c4 <__alltraps>

00102634 <vector244>:
.globl vector244
vector244:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $244
  102636:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10263b:	e9 84 00 00 00       	jmp    1026c4 <__alltraps>

00102640 <vector245>:
.globl vector245
vector245:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $245
  102642:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102647:	e9 78 00 00 00       	jmp    1026c4 <__alltraps>

0010264c <vector246>:
.globl vector246
vector246:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $246
  10264e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102653:	e9 6c 00 00 00       	jmp    1026c4 <__alltraps>

00102658 <vector247>:
.globl vector247
vector247:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $247
  10265a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10265f:	e9 60 00 00 00       	jmp    1026c4 <__alltraps>

00102664 <vector248>:
.globl vector248
vector248:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $248
  102666:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10266b:	e9 54 00 00 00       	jmp    1026c4 <__alltraps>

00102670 <vector249>:
.globl vector249
vector249:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $249
  102672:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102677:	e9 48 00 00 00       	jmp    1026c4 <__alltraps>

0010267c <vector250>:
.globl vector250
vector250:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $250
  10267e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102683:	e9 3c 00 00 00       	jmp    1026c4 <__alltraps>

00102688 <vector251>:
.globl vector251
vector251:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $251
  10268a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10268f:	e9 30 00 00 00       	jmp    1026c4 <__alltraps>

00102694 <vector252>:
.globl vector252
vector252:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $252
  102696:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10269b:	e9 24 00 00 00       	jmp    1026c4 <__alltraps>

001026a0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $253
  1026a2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1026a7:	e9 18 00 00 00       	jmp    1026c4 <__alltraps>

001026ac <vector254>:
.globl vector254
vector254:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $254
  1026ae:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1026b3:	e9 0c 00 00 00       	jmp    1026c4 <__alltraps>

001026b8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $255
  1026ba:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1026bf:	e9 00 00 00 00       	jmp    1026c4 <__alltraps>

001026c4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1026c4:	1e                   	push   %ds
    pushl %es
  1026c5:	06                   	push   %es
    pushl %fs
  1026c6:	0f a0                	push   %fs
    pushl %gs
  1026c8:	0f a8                	push   %gs
    pushal
  1026ca:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1026cb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1026d0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1026d2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1026d4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1026d5:	e8 63 f5 ff ff       	call   101c3d <trap>

    # pop the pushed stack pointer
    popl %esp
  1026da:	5c                   	pop    %esp

001026db <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1026db:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1026dc:	0f a9                	pop    %gs
    popl %fs
  1026de:	0f a1                	pop    %fs
    popl %es
  1026e0:	07                   	pop    %es
    popl %ds
  1026e1:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1026e2:	83 c4 08             	add    $0x8,%esp
    iret
  1026e5:	cf                   	iret   

001026e6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1026e6:	55                   	push   %ebp
  1026e7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1026ec:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1026ef:	b8 23 00 00 00       	mov    $0x23,%eax
  1026f4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1026f6:	b8 23 00 00 00       	mov    $0x23,%eax
  1026fb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1026fd:	b8 10 00 00 00       	mov    $0x10,%eax
  102702:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102704:	b8 10 00 00 00       	mov    $0x10,%eax
  102709:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10270b:	b8 10 00 00 00       	mov    $0x10,%eax
  102710:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102712:	ea 19 27 10 00 08 00 	ljmp   $0x8,$0x102719
}
  102719:	90                   	nop
  10271a:	5d                   	pop    %ebp
  10271b:	c3                   	ret    

0010271c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10271c:	55                   	push   %ebp
  10271d:	89 e5                	mov    %esp,%ebp
  10271f:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102722:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102727:	05 00 04 00 00       	add    $0x400,%eax
  10272c:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102731:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102738:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10273a:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102741:	68 00 
  102743:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102748:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10274e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102753:	c1 e8 10             	shr    $0x10,%eax
  102756:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10275b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102762:	83 e0 f0             	and    $0xfffffff0,%eax
  102765:	83 c8 09             	or     $0x9,%eax
  102768:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10276d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102774:	83 c8 10             	or     $0x10,%eax
  102777:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10277c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102783:	83 e0 9f             	and    $0xffffff9f,%eax
  102786:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10278b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102792:	83 c8 80             	or     $0xffffff80,%eax
  102795:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10279a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1027a1:	83 e0 f0             	and    $0xfffffff0,%eax
  1027a4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1027a9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1027b0:	83 e0 ef             	and    $0xffffffef,%eax
  1027b3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1027b8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1027bf:	83 e0 df             	and    $0xffffffdf,%eax
  1027c2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1027c7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1027ce:	83 c8 40             	or     $0x40,%eax
  1027d1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1027d6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1027dd:	83 e0 7f             	and    $0x7f,%eax
  1027e0:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1027e5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1027ea:	c1 e8 18             	shr    $0x18,%eax
  1027ed:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1027f2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1027f9:	83 e0 ef             	and    $0xffffffef,%eax
  1027fc:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102801:	68 10 ea 10 00       	push   $0x10ea10
  102806:	e8 db fe ff ff       	call   1026e6 <lgdt>
  10280b:	83 c4 04             	add    $0x4,%esp
  10280e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102814:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102818:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10281b:	90                   	nop
  10281c:	c9                   	leave  
  10281d:	c3                   	ret    

0010281e <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10281e:	55                   	push   %ebp
  10281f:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102821:	e8 f6 fe ff ff       	call   10271c <gdt_init>
}
  102826:	90                   	nop
  102827:	5d                   	pop    %ebp
  102828:	c3                   	ret    

00102829 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102829:	55                   	push   %ebp
  10282a:	89 e5                	mov    %esp,%ebp
  10282c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10282f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102836:	eb 04                	jmp    10283c <strlen+0x13>
        cnt ++;
  102838:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  10283c:	8b 45 08             	mov    0x8(%ebp),%eax
  10283f:	8d 50 01             	lea    0x1(%eax),%edx
  102842:	89 55 08             	mov    %edx,0x8(%ebp)
  102845:	0f b6 00             	movzbl (%eax),%eax
  102848:	84 c0                	test   %al,%al
  10284a:	75 ec                	jne    102838 <strlen+0xf>
    }
    return cnt;
  10284c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10284f:	c9                   	leave  
  102850:	c3                   	ret    

00102851 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102851:	55                   	push   %ebp
  102852:	89 e5                	mov    %esp,%ebp
  102854:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102857:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10285e:	eb 04                	jmp    102864 <strnlen+0x13>
        cnt ++;
  102860:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102867:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10286a:	73 10                	jae    10287c <strnlen+0x2b>
  10286c:	8b 45 08             	mov    0x8(%ebp),%eax
  10286f:	8d 50 01             	lea    0x1(%eax),%edx
  102872:	89 55 08             	mov    %edx,0x8(%ebp)
  102875:	0f b6 00             	movzbl (%eax),%eax
  102878:	84 c0                	test   %al,%al
  10287a:	75 e4                	jne    102860 <strnlen+0xf>
    }
    return cnt;
  10287c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10287f:	c9                   	leave  
  102880:	c3                   	ret    

00102881 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102881:	55                   	push   %ebp
  102882:	89 e5                	mov    %esp,%ebp
  102884:	57                   	push   %edi
  102885:	56                   	push   %esi
  102886:	83 ec 20             	sub    $0x20,%esp
  102889:	8b 45 08             	mov    0x8(%ebp),%eax
  10288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10288f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102892:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102895:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10289b:	89 d1                	mov    %edx,%ecx
  10289d:	89 c2                	mov    %eax,%edx
  10289f:	89 ce                	mov    %ecx,%esi
  1028a1:	89 d7                	mov    %edx,%edi
  1028a3:	ac                   	lods   %ds:(%esi),%al
  1028a4:	aa                   	stos   %al,%es:(%edi)
  1028a5:	84 c0                	test   %al,%al
  1028a7:	75 fa                	jne    1028a3 <strcpy+0x22>
  1028a9:	89 fa                	mov    %edi,%edx
  1028ab:	89 f1                	mov    %esi,%ecx
  1028ad:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1028b0:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1028b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1028b9:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1028ba:	83 c4 20             	add    $0x20,%esp
  1028bd:	5e                   	pop    %esi
  1028be:	5f                   	pop    %edi
  1028bf:	5d                   	pop    %ebp
  1028c0:	c3                   	ret    

001028c1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1028c1:	55                   	push   %ebp
  1028c2:	89 e5                	mov    %esp,%ebp
  1028c4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1028cd:	eb 21                	jmp    1028f0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1028cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028d2:	0f b6 10             	movzbl (%eax),%edx
  1028d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028d8:	88 10                	mov    %dl,(%eax)
  1028da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028dd:	0f b6 00             	movzbl (%eax),%eax
  1028e0:	84 c0                	test   %al,%al
  1028e2:	74 04                	je     1028e8 <strncpy+0x27>
            src ++;
  1028e4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1028e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1028ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  1028f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028f4:	75 d9                	jne    1028cf <strncpy+0xe>
    }
    return dst;
  1028f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1028f9:	c9                   	leave  
  1028fa:	c3                   	ret    

001028fb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1028fb:	55                   	push   %ebp
  1028fc:	89 e5                	mov    %esp,%ebp
  1028fe:	57                   	push   %edi
  1028ff:	56                   	push   %esi
  102900:	83 ec 20             	sub    $0x20,%esp
  102903:	8b 45 08             	mov    0x8(%ebp),%eax
  102906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10290c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102915:	89 d1                	mov    %edx,%ecx
  102917:	89 c2                	mov    %eax,%edx
  102919:	89 ce                	mov    %ecx,%esi
  10291b:	89 d7                	mov    %edx,%edi
  10291d:	ac                   	lods   %ds:(%esi),%al
  10291e:	ae                   	scas   %es:(%edi),%al
  10291f:	75 08                	jne    102929 <strcmp+0x2e>
  102921:	84 c0                	test   %al,%al
  102923:	75 f8                	jne    10291d <strcmp+0x22>
  102925:	31 c0                	xor    %eax,%eax
  102927:	eb 04                	jmp    10292d <strcmp+0x32>
  102929:	19 c0                	sbb    %eax,%eax
  10292b:	0c 01                	or     $0x1,%al
  10292d:	89 fa                	mov    %edi,%edx
  10292f:	89 f1                	mov    %esi,%ecx
  102931:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102934:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102937:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  10293a:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10293d:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10293e:	83 c4 20             	add    $0x20,%esp
  102941:	5e                   	pop    %esi
  102942:	5f                   	pop    %edi
  102943:	5d                   	pop    %ebp
  102944:	c3                   	ret    

00102945 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102945:	55                   	push   %ebp
  102946:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102948:	eb 0c                	jmp    102956 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  10294a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10294e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102952:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102956:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10295a:	74 1a                	je     102976 <strncmp+0x31>
  10295c:	8b 45 08             	mov    0x8(%ebp),%eax
  10295f:	0f b6 00             	movzbl (%eax),%eax
  102962:	84 c0                	test   %al,%al
  102964:	74 10                	je     102976 <strncmp+0x31>
  102966:	8b 45 08             	mov    0x8(%ebp),%eax
  102969:	0f b6 10             	movzbl (%eax),%edx
  10296c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296f:	0f b6 00             	movzbl (%eax),%eax
  102972:	38 c2                	cmp    %al,%dl
  102974:	74 d4                	je     10294a <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102976:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10297a:	74 18                	je     102994 <strncmp+0x4f>
  10297c:	8b 45 08             	mov    0x8(%ebp),%eax
  10297f:	0f b6 00             	movzbl (%eax),%eax
  102982:	0f b6 d0             	movzbl %al,%edx
  102985:	8b 45 0c             	mov    0xc(%ebp),%eax
  102988:	0f b6 00             	movzbl (%eax),%eax
  10298b:	0f b6 c0             	movzbl %al,%eax
  10298e:	29 c2                	sub    %eax,%edx
  102990:	89 d0                	mov    %edx,%eax
  102992:	eb 05                	jmp    102999 <strncmp+0x54>
  102994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102999:	5d                   	pop    %ebp
  10299a:	c3                   	ret    

0010299b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10299b:	55                   	push   %ebp
  10299c:	89 e5                	mov    %esp,%ebp
  10299e:	83 ec 04             	sub    $0x4,%esp
  1029a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029a4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1029a7:	eb 14                	jmp    1029bd <strchr+0x22>
        if (*s == c) {
  1029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ac:	0f b6 00             	movzbl (%eax),%eax
  1029af:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1029b2:	75 05                	jne    1029b9 <strchr+0x1e>
            return (char *)s;
  1029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b7:	eb 13                	jmp    1029cc <strchr+0x31>
        }
        s ++;
  1029b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c0:	0f b6 00             	movzbl (%eax),%eax
  1029c3:	84 c0                	test   %al,%al
  1029c5:	75 e2                	jne    1029a9 <strchr+0xe>
    }
    return NULL;
  1029c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1029cc:	c9                   	leave  
  1029cd:	c3                   	ret    

001029ce <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1029ce:	55                   	push   %ebp
  1029cf:	89 e5                	mov    %esp,%ebp
  1029d1:	83 ec 04             	sub    $0x4,%esp
  1029d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029d7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1029da:	eb 0f                	jmp    1029eb <strfind+0x1d>
        if (*s == c) {
  1029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1029df:	0f b6 00             	movzbl (%eax),%eax
  1029e2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1029e5:	74 10                	je     1029f7 <strfind+0x29>
            break;
        }
        s ++;
  1029e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ee:	0f b6 00             	movzbl (%eax),%eax
  1029f1:	84 c0                	test   %al,%al
  1029f3:	75 e7                	jne    1029dc <strfind+0xe>
  1029f5:	eb 01                	jmp    1029f8 <strfind+0x2a>
            break;
  1029f7:	90                   	nop
    }
    return (char *)s;
  1029f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1029fb:	c9                   	leave  
  1029fc:	c3                   	ret    

001029fd <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1029fd:	55                   	push   %ebp
  1029fe:	89 e5                	mov    %esp,%ebp
  102a00:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102a0a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102a11:	eb 04                	jmp    102a17 <strtol+0x1a>
        s ++;
  102a13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102a17:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1a:	0f b6 00             	movzbl (%eax),%eax
  102a1d:	3c 20                	cmp    $0x20,%al
  102a1f:	74 f2                	je     102a13 <strtol+0x16>
  102a21:	8b 45 08             	mov    0x8(%ebp),%eax
  102a24:	0f b6 00             	movzbl (%eax),%eax
  102a27:	3c 09                	cmp    $0x9,%al
  102a29:	74 e8                	je     102a13 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2e:	0f b6 00             	movzbl (%eax),%eax
  102a31:	3c 2b                	cmp    $0x2b,%al
  102a33:	75 06                	jne    102a3b <strtol+0x3e>
        s ++;
  102a35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a39:	eb 15                	jmp    102a50 <strtol+0x53>
    }
    else if (*s == '-') {
  102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3e:	0f b6 00             	movzbl (%eax),%eax
  102a41:	3c 2d                	cmp    $0x2d,%al
  102a43:	75 0b                	jne    102a50 <strtol+0x53>
        s ++, neg = 1;
  102a45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a49:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a54:	74 06                	je     102a5c <strtol+0x5f>
  102a56:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102a5a:	75 24                	jne    102a80 <strtol+0x83>
  102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5f:	0f b6 00             	movzbl (%eax),%eax
  102a62:	3c 30                	cmp    $0x30,%al
  102a64:	75 1a                	jne    102a80 <strtol+0x83>
  102a66:	8b 45 08             	mov    0x8(%ebp),%eax
  102a69:	83 c0 01             	add    $0x1,%eax
  102a6c:	0f b6 00             	movzbl (%eax),%eax
  102a6f:	3c 78                	cmp    $0x78,%al
  102a71:	75 0d                	jne    102a80 <strtol+0x83>
        s += 2, base = 16;
  102a73:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102a77:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102a7e:	eb 2a                	jmp    102aaa <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102a80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a84:	75 17                	jne    102a9d <strtol+0xa0>
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	0f b6 00             	movzbl (%eax),%eax
  102a8c:	3c 30                	cmp    $0x30,%al
  102a8e:	75 0d                	jne    102a9d <strtol+0xa0>
        s ++, base = 8;
  102a90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a94:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102a9b:	eb 0d                	jmp    102aaa <strtol+0xad>
    }
    else if (base == 0) {
  102a9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102aa1:	75 07                	jne    102aaa <strtol+0xad>
        base = 10;
  102aa3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  102aad:	0f b6 00             	movzbl (%eax),%eax
  102ab0:	3c 2f                	cmp    $0x2f,%al
  102ab2:	7e 1b                	jle    102acf <strtol+0xd2>
  102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab7:	0f b6 00             	movzbl (%eax),%eax
  102aba:	3c 39                	cmp    $0x39,%al
  102abc:	7f 11                	jg     102acf <strtol+0xd2>
            dig = *s - '0';
  102abe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac1:	0f b6 00             	movzbl (%eax),%eax
  102ac4:	0f be c0             	movsbl %al,%eax
  102ac7:	83 e8 30             	sub    $0x30,%eax
  102aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102acd:	eb 48                	jmp    102b17 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102acf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad2:	0f b6 00             	movzbl (%eax),%eax
  102ad5:	3c 60                	cmp    $0x60,%al
  102ad7:	7e 1b                	jle    102af4 <strtol+0xf7>
  102ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  102adc:	0f b6 00             	movzbl (%eax),%eax
  102adf:	3c 7a                	cmp    $0x7a,%al
  102ae1:	7f 11                	jg     102af4 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae6:	0f b6 00             	movzbl (%eax),%eax
  102ae9:	0f be c0             	movsbl %al,%eax
  102aec:	83 e8 57             	sub    $0x57,%eax
  102aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102af2:	eb 23                	jmp    102b17 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102af4:	8b 45 08             	mov    0x8(%ebp),%eax
  102af7:	0f b6 00             	movzbl (%eax),%eax
  102afa:	3c 40                	cmp    $0x40,%al
  102afc:	7e 3c                	jle    102b3a <strtol+0x13d>
  102afe:	8b 45 08             	mov    0x8(%ebp),%eax
  102b01:	0f b6 00             	movzbl (%eax),%eax
  102b04:	3c 5a                	cmp    $0x5a,%al
  102b06:	7f 32                	jg     102b3a <strtol+0x13d>
            dig = *s - 'A' + 10;
  102b08:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0b:	0f b6 00             	movzbl (%eax),%eax
  102b0e:	0f be c0             	movsbl %al,%eax
  102b11:	83 e8 37             	sub    $0x37,%eax
  102b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1a:	3b 45 10             	cmp    0x10(%ebp),%eax
  102b1d:	7d 1a                	jge    102b39 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102b1f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b26:	0f af 45 10          	imul   0x10(%ebp),%eax
  102b2a:	89 c2                	mov    %eax,%edx
  102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2f:	01 d0                	add    %edx,%eax
  102b31:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102b34:	e9 71 ff ff ff       	jmp    102aaa <strtol+0xad>
            break;
  102b39:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b3e:	74 08                	je     102b48 <strtol+0x14b>
        *endptr = (char *) s;
  102b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b43:	8b 55 08             	mov    0x8(%ebp),%edx
  102b46:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102b4c:	74 07                	je     102b55 <strtol+0x158>
  102b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b51:	f7 d8                	neg    %eax
  102b53:	eb 03                	jmp    102b58 <strtol+0x15b>
  102b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102b58:	c9                   	leave  
  102b59:	c3                   	ret    

00102b5a <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102b5a:	55                   	push   %ebp
  102b5b:	89 e5                	mov    %esp,%ebp
  102b5d:	57                   	push   %edi
  102b5e:	83 ec 24             	sub    $0x24,%esp
  102b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b64:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102b67:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  102b6e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102b71:	88 45 f7             	mov    %al,-0x9(%ebp)
  102b74:	8b 45 10             	mov    0x10(%ebp),%eax
  102b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102b7a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b7d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102b81:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b84:	89 d7                	mov    %edx,%edi
  102b86:	f3 aa                	rep stos %al,%es:(%edi)
  102b88:	89 fa                	mov    %edi,%edx
  102b8a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b8d:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102b90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b93:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102b94:	83 c4 24             	add    $0x24,%esp
  102b97:	5f                   	pop    %edi
  102b98:	5d                   	pop    %ebp
  102b99:	c3                   	ret    

00102b9a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102b9a:	55                   	push   %ebp
  102b9b:	89 e5                	mov    %esp,%ebp
  102b9d:	57                   	push   %edi
  102b9e:	56                   	push   %esi
  102b9f:	53                   	push   %ebx
  102ba0:	83 ec 30             	sub    $0x30,%esp
  102ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102baf:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102bbb:	73 42                	jae    102bff <memmove+0x65>
  102bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bd2:	c1 e8 02             	shr    $0x2,%eax
  102bd5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102bd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bdd:	89 d7                	mov    %edx,%edi
  102bdf:	89 c6                	mov    %eax,%esi
  102be1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102be3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102be6:	83 e1 03             	and    $0x3,%ecx
  102be9:	74 02                	je     102bed <memmove+0x53>
  102beb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102bed:	89 f0                	mov    %esi,%eax
  102bef:	89 fa                	mov    %edi,%edx
  102bf1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102bf4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102bf7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102bfd:	eb 36                	jmp    102c35 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c02:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c08:	01 c2                	add    %eax,%edx
  102c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c0d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c13:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c19:	89 c1                	mov    %eax,%ecx
  102c1b:	89 d8                	mov    %ebx,%eax
  102c1d:	89 d6                	mov    %edx,%esi
  102c1f:	89 c7                	mov    %eax,%edi
  102c21:	fd                   	std    
  102c22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c24:	fc                   	cld    
  102c25:	89 f8                	mov    %edi,%eax
  102c27:	89 f2                	mov    %esi,%edx
  102c29:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102c2c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102c2f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102c35:	83 c4 30             	add    $0x30,%esp
  102c38:	5b                   	pop    %ebx
  102c39:	5e                   	pop    %esi
  102c3a:	5f                   	pop    %edi
  102c3b:	5d                   	pop    %ebp
  102c3c:	c3                   	ret    

00102c3d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102c3d:	55                   	push   %ebp
  102c3e:	89 e5                	mov    %esp,%ebp
  102c40:	57                   	push   %edi
  102c41:	56                   	push   %esi
  102c42:	83 ec 20             	sub    $0x20,%esp
  102c45:	8b 45 08             	mov    0x8(%ebp),%eax
  102c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c51:	8b 45 10             	mov    0x10(%ebp),%eax
  102c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c5a:	c1 e8 02             	shr    $0x2,%eax
  102c5d:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c65:	89 d7                	mov    %edx,%edi
  102c67:	89 c6                	mov    %eax,%esi
  102c69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102c6b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102c6e:	83 e1 03             	and    $0x3,%ecx
  102c71:	74 02                	je     102c75 <memcpy+0x38>
  102c73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c75:	89 f0                	mov    %esi,%eax
  102c77:	89 fa                	mov    %edi,%edx
  102c79:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102c7c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102c85:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102c86:	83 c4 20             	add    $0x20,%esp
  102c89:	5e                   	pop    %esi
  102c8a:	5f                   	pop    %edi
  102c8b:	5d                   	pop    %ebp
  102c8c:	c3                   	ret    

00102c8d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102c8d:	55                   	push   %ebp
  102c8e:	89 e5                	mov    %esp,%ebp
  102c90:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102c93:	8b 45 08             	mov    0x8(%ebp),%eax
  102c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102c9f:	eb 30                	jmp    102cd1 <memcmp+0x44>
        if (*s1 != *s2) {
  102ca1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ca4:	0f b6 10             	movzbl (%eax),%edx
  102ca7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102caa:	0f b6 00             	movzbl (%eax),%eax
  102cad:	38 c2                	cmp    %al,%dl
  102caf:	74 18                	je     102cc9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cb4:	0f b6 00             	movzbl (%eax),%eax
  102cb7:	0f b6 d0             	movzbl %al,%edx
  102cba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cbd:	0f b6 00             	movzbl (%eax),%eax
  102cc0:	0f b6 c0             	movzbl %al,%eax
  102cc3:	29 c2                	sub    %eax,%edx
  102cc5:	89 d0                	mov    %edx,%eax
  102cc7:	eb 1a                	jmp    102ce3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102cc9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ccd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  102cd7:	89 55 10             	mov    %edx,0x10(%ebp)
  102cda:	85 c0                	test   %eax,%eax
  102cdc:	75 c3                	jne    102ca1 <memcmp+0x14>
    }
    return 0;
  102cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ce3:	c9                   	leave  
  102ce4:	c3                   	ret    

00102ce5 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102ce5:	55                   	push   %ebp
  102ce6:	89 e5                	mov    %esp,%ebp
  102ce8:	83 ec 38             	sub    $0x38,%esp
  102ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  102cee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102cf1:	8b 45 14             	mov    0x14(%ebp),%eax
  102cf4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cfa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d00:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102d03:	8b 45 18             	mov    0x18(%ebp),%eax
  102d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d12:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102d1f:	74 1c                	je     102d3d <printnum+0x58>
  102d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d24:	ba 00 00 00 00       	mov    $0x0,%edx
  102d29:	f7 75 e4             	divl   -0x1c(%ebp)
  102d2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d32:	ba 00 00 00 00       	mov    $0x0,%edx
  102d37:	f7 75 e4             	divl   -0x1c(%ebp)
  102d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d43:	f7 75 e4             	divl   -0x1c(%ebp)
  102d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102d52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d55:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102d58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d5b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102d5e:	8b 45 18             	mov    0x18(%ebp),%eax
  102d61:	ba 00 00 00 00       	mov    $0x0,%edx
  102d66:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102d69:	72 41                	jb     102dac <printnum+0xc7>
  102d6b:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102d6e:	77 05                	ja     102d75 <printnum+0x90>
  102d70:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102d73:	72 37                	jb     102dac <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102d75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102d78:	83 e8 01             	sub    $0x1,%eax
  102d7b:	83 ec 04             	sub    $0x4,%esp
  102d7e:	ff 75 20             	pushl  0x20(%ebp)
  102d81:	50                   	push   %eax
  102d82:	ff 75 18             	pushl  0x18(%ebp)
  102d85:	ff 75 ec             	pushl  -0x14(%ebp)
  102d88:	ff 75 e8             	pushl  -0x18(%ebp)
  102d8b:	ff 75 0c             	pushl  0xc(%ebp)
  102d8e:	ff 75 08             	pushl  0x8(%ebp)
  102d91:	e8 4f ff ff ff       	call   102ce5 <printnum>
  102d96:	83 c4 20             	add    $0x20,%esp
  102d99:	eb 1b                	jmp    102db6 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d9b:	83 ec 08             	sub    $0x8,%esp
  102d9e:	ff 75 0c             	pushl  0xc(%ebp)
  102da1:	ff 75 20             	pushl  0x20(%ebp)
  102da4:	8b 45 08             	mov    0x8(%ebp),%eax
  102da7:	ff d0                	call   *%eax
  102da9:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102dac:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102db4:	7f e5                	jg     102d9b <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102db6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102db9:	05 70 3a 10 00       	add    $0x103a70,%eax
  102dbe:	0f b6 00             	movzbl (%eax),%eax
  102dc1:	0f be c0             	movsbl %al,%eax
  102dc4:	83 ec 08             	sub    $0x8,%esp
  102dc7:	ff 75 0c             	pushl  0xc(%ebp)
  102dca:	50                   	push   %eax
  102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dce:	ff d0                	call   *%eax
  102dd0:	83 c4 10             	add    $0x10,%esp
}
  102dd3:	90                   	nop
  102dd4:	c9                   	leave  
  102dd5:	c3                   	ret    

00102dd6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102dd6:	55                   	push   %ebp
  102dd7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102dd9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ddd:	7e 14                	jle    102df3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  102de2:	8b 00                	mov    (%eax),%eax
  102de4:	8d 48 08             	lea    0x8(%eax),%ecx
  102de7:	8b 55 08             	mov    0x8(%ebp),%edx
  102dea:	89 0a                	mov    %ecx,(%edx)
  102dec:	8b 50 04             	mov    0x4(%eax),%edx
  102def:	8b 00                	mov    (%eax),%eax
  102df1:	eb 30                	jmp    102e23 <getuint+0x4d>
    }
    else if (lflag) {
  102df3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102df7:	74 16                	je     102e0f <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102df9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfc:	8b 00                	mov    (%eax),%eax
  102dfe:	8d 48 04             	lea    0x4(%eax),%ecx
  102e01:	8b 55 08             	mov    0x8(%ebp),%edx
  102e04:	89 0a                	mov    %ecx,(%edx)
  102e06:	8b 00                	mov    (%eax),%eax
  102e08:	ba 00 00 00 00       	mov    $0x0,%edx
  102e0d:	eb 14                	jmp    102e23 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	8b 00                	mov    (%eax),%eax
  102e14:	8d 48 04             	lea    0x4(%eax),%ecx
  102e17:	8b 55 08             	mov    0x8(%ebp),%edx
  102e1a:	89 0a                	mov    %ecx,(%edx)
  102e1c:	8b 00                	mov    (%eax),%eax
  102e1e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102e23:	5d                   	pop    %ebp
  102e24:	c3                   	ret    

00102e25 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102e25:	55                   	push   %ebp
  102e26:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102e28:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102e2c:	7e 14                	jle    102e42 <getint+0x1d>
        return va_arg(*ap, long long);
  102e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e31:	8b 00                	mov    (%eax),%eax
  102e33:	8d 48 08             	lea    0x8(%eax),%ecx
  102e36:	8b 55 08             	mov    0x8(%ebp),%edx
  102e39:	89 0a                	mov    %ecx,(%edx)
  102e3b:	8b 50 04             	mov    0x4(%eax),%edx
  102e3e:	8b 00                	mov    (%eax),%eax
  102e40:	eb 28                	jmp    102e6a <getint+0x45>
    }
    else if (lflag) {
  102e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e46:	74 12                	je     102e5a <getint+0x35>
        return va_arg(*ap, long);
  102e48:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4b:	8b 00                	mov    (%eax),%eax
  102e4d:	8d 48 04             	lea    0x4(%eax),%ecx
  102e50:	8b 55 08             	mov    0x8(%ebp),%edx
  102e53:	89 0a                	mov    %ecx,(%edx)
  102e55:	8b 00                	mov    (%eax),%eax
  102e57:	99                   	cltd   
  102e58:	eb 10                	jmp    102e6a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5d:	8b 00                	mov    (%eax),%eax
  102e5f:	8d 48 04             	lea    0x4(%eax),%ecx
  102e62:	8b 55 08             	mov    0x8(%ebp),%edx
  102e65:	89 0a                	mov    %ecx,(%edx)
  102e67:	8b 00                	mov    (%eax),%eax
  102e69:	99                   	cltd   
    }
}
  102e6a:	5d                   	pop    %ebp
  102e6b:	c3                   	ret    

00102e6c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102e6c:	55                   	push   %ebp
  102e6d:	89 e5                	mov    %esp,%ebp
  102e6f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102e72:	8d 45 14             	lea    0x14(%ebp),%eax
  102e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e7b:	50                   	push   %eax
  102e7c:	ff 75 10             	pushl  0x10(%ebp)
  102e7f:	ff 75 0c             	pushl  0xc(%ebp)
  102e82:	ff 75 08             	pushl  0x8(%ebp)
  102e85:	e8 06 00 00 00       	call   102e90 <vprintfmt>
  102e8a:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102e8d:	90                   	nop
  102e8e:	c9                   	leave  
  102e8f:	c3                   	ret    

00102e90 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e90:	55                   	push   %ebp
  102e91:	89 e5                	mov    %esp,%ebp
  102e93:	56                   	push   %esi
  102e94:	53                   	push   %ebx
  102e95:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e98:	eb 17                	jmp    102eb1 <vprintfmt+0x21>
            if (ch == '\0') {
  102e9a:	85 db                	test   %ebx,%ebx
  102e9c:	0f 84 8e 03 00 00    	je     103230 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102ea2:	83 ec 08             	sub    $0x8,%esp
  102ea5:	ff 75 0c             	pushl  0xc(%ebp)
  102ea8:	53                   	push   %ebx
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	ff d0                	call   *%eax
  102eae:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb4:	8d 50 01             	lea    0x1(%eax),%edx
  102eb7:	89 55 10             	mov    %edx,0x10(%ebp)
  102eba:	0f b6 00             	movzbl (%eax),%eax
  102ebd:	0f b6 d8             	movzbl %al,%ebx
  102ec0:	83 fb 25             	cmp    $0x25,%ebx
  102ec3:	75 d5                	jne    102e9a <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102ec5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102ec9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ed3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ed6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ee0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ee6:	8d 50 01             	lea    0x1(%eax),%edx
  102ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  102eec:	0f b6 00             	movzbl (%eax),%eax
  102eef:	0f b6 d8             	movzbl %al,%ebx
  102ef2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ef5:	83 f8 55             	cmp    $0x55,%eax
  102ef8:	0f 87 05 03 00 00    	ja     103203 <vprintfmt+0x373>
  102efe:	8b 04 85 94 3a 10 00 	mov    0x103a94(,%eax,4),%eax
  102f05:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102f07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102f0b:	eb d6                	jmp    102ee3 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102f0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102f11:	eb d0                	jmp    102ee3 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102f13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f1d:	89 d0                	mov    %edx,%eax
  102f1f:	c1 e0 02             	shl    $0x2,%eax
  102f22:	01 d0                	add    %edx,%eax
  102f24:	01 c0                	add    %eax,%eax
  102f26:	01 d8                	add    %ebx,%eax
  102f28:	83 e8 30             	sub    $0x30,%eax
  102f2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f31:	0f b6 00             	movzbl (%eax),%eax
  102f34:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102f37:	83 fb 2f             	cmp    $0x2f,%ebx
  102f3a:	7e 39                	jle    102f75 <vprintfmt+0xe5>
  102f3c:	83 fb 39             	cmp    $0x39,%ebx
  102f3f:	7f 34                	jg     102f75 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  102f41:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102f45:	eb d3                	jmp    102f1a <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102f47:	8b 45 14             	mov    0x14(%ebp),%eax
  102f4a:	8d 50 04             	lea    0x4(%eax),%edx
  102f4d:	89 55 14             	mov    %edx,0x14(%ebp)
  102f50:	8b 00                	mov    (%eax),%eax
  102f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102f55:	eb 1f                	jmp    102f76 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102f57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f5b:	79 86                	jns    102ee3 <vprintfmt+0x53>
                width = 0;
  102f5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102f64:	e9 7a ff ff ff       	jmp    102ee3 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102f69:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102f70:	e9 6e ff ff ff       	jmp    102ee3 <vprintfmt+0x53>
            goto process_precision;
  102f75:	90                   	nop

        process_precision:
            if (width < 0)
  102f76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f7a:	0f 89 63 ff ff ff    	jns    102ee3 <vprintfmt+0x53>
                width = precision, precision = -1;
  102f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f83:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f86:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102f8d:	e9 51 ff ff ff       	jmp    102ee3 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f92:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102f96:	e9 48 ff ff ff       	jmp    102ee3 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f9e:	8d 50 04             	lea    0x4(%eax),%edx
  102fa1:	89 55 14             	mov    %edx,0x14(%ebp)
  102fa4:	8b 00                	mov    (%eax),%eax
  102fa6:	83 ec 08             	sub    $0x8,%esp
  102fa9:	ff 75 0c             	pushl  0xc(%ebp)
  102fac:	50                   	push   %eax
  102fad:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb0:	ff d0                	call   *%eax
  102fb2:	83 c4 10             	add    $0x10,%esp
            break;
  102fb5:	e9 71 02 00 00       	jmp    10322b <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102fba:	8b 45 14             	mov    0x14(%ebp),%eax
  102fbd:	8d 50 04             	lea    0x4(%eax),%edx
  102fc0:	89 55 14             	mov    %edx,0x14(%ebp)
  102fc3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102fc5:	85 db                	test   %ebx,%ebx
  102fc7:	79 02                	jns    102fcb <vprintfmt+0x13b>
                err = -err;
  102fc9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102fcb:	83 fb 06             	cmp    $0x6,%ebx
  102fce:	7f 0b                	jg     102fdb <vprintfmt+0x14b>
  102fd0:	8b 34 9d 54 3a 10 00 	mov    0x103a54(,%ebx,4),%esi
  102fd7:	85 f6                	test   %esi,%esi
  102fd9:	75 19                	jne    102ff4 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  102fdb:	53                   	push   %ebx
  102fdc:	68 81 3a 10 00       	push   $0x103a81
  102fe1:	ff 75 0c             	pushl  0xc(%ebp)
  102fe4:	ff 75 08             	pushl  0x8(%ebp)
  102fe7:	e8 80 fe ff ff       	call   102e6c <printfmt>
  102fec:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102fef:	e9 37 02 00 00       	jmp    10322b <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  102ff4:	56                   	push   %esi
  102ff5:	68 8a 3a 10 00       	push   $0x103a8a
  102ffa:	ff 75 0c             	pushl  0xc(%ebp)
  102ffd:	ff 75 08             	pushl  0x8(%ebp)
  103000:	e8 67 fe ff ff       	call   102e6c <printfmt>
  103005:	83 c4 10             	add    $0x10,%esp
            break;
  103008:	e9 1e 02 00 00       	jmp    10322b <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10300d:	8b 45 14             	mov    0x14(%ebp),%eax
  103010:	8d 50 04             	lea    0x4(%eax),%edx
  103013:	89 55 14             	mov    %edx,0x14(%ebp)
  103016:	8b 30                	mov    (%eax),%esi
  103018:	85 f6                	test   %esi,%esi
  10301a:	75 05                	jne    103021 <vprintfmt+0x191>
                p = "(null)";
  10301c:	be 8d 3a 10 00       	mov    $0x103a8d,%esi
            }
            if (width > 0 && padc != '-') {
  103021:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103025:	7e 76                	jle    10309d <vprintfmt+0x20d>
  103027:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10302b:	74 70                	je     10309d <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10302d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103030:	83 ec 08             	sub    $0x8,%esp
  103033:	50                   	push   %eax
  103034:	56                   	push   %esi
  103035:	e8 17 f8 ff ff       	call   102851 <strnlen>
  10303a:	83 c4 10             	add    $0x10,%esp
  10303d:	89 c2                	mov    %eax,%edx
  10303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103042:	29 d0                	sub    %edx,%eax
  103044:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103047:	eb 17                	jmp    103060 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  103049:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10304d:	83 ec 08             	sub    $0x8,%esp
  103050:	ff 75 0c             	pushl  0xc(%ebp)
  103053:	50                   	push   %eax
  103054:	8b 45 08             	mov    0x8(%ebp),%eax
  103057:	ff d0                	call   *%eax
  103059:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  10305c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103060:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103064:	7f e3                	jg     103049 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103066:	eb 35                	jmp    10309d <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10306c:	74 1c                	je     10308a <vprintfmt+0x1fa>
  10306e:	83 fb 1f             	cmp    $0x1f,%ebx
  103071:	7e 05                	jle    103078 <vprintfmt+0x1e8>
  103073:	83 fb 7e             	cmp    $0x7e,%ebx
  103076:	7e 12                	jle    10308a <vprintfmt+0x1fa>
                    putch('?', putdat);
  103078:	83 ec 08             	sub    $0x8,%esp
  10307b:	ff 75 0c             	pushl  0xc(%ebp)
  10307e:	6a 3f                	push   $0x3f
  103080:	8b 45 08             	mov    0x8(%ebp),%eax
  103083:	ff d0                	call   *%eax
  103085:	83 c4 10             	add    $0x10,%esp
  103088:	eb 0f                	jmp    103099 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  10308a:	83 ec 08             	sub    $0x8,%esp
  10308d:	ff 75 0c             	pushl  0xc(%ebp)
  103090:	53                   	push   %ebx
  103091:	8b 45 08             	mov    0x8(%ebp),%eax
  103094:	ff d0                	call   *%eax
  103096:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103099:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10309d:	89 f0                	mov    %esi,%eax
  10309f:	8d 70 01             	lea    0x1(%eax),%esi
  1030a2:	0f b6 00             	movzbl (%eax),%eax
  1030a5:	0f be d8             	movsbl %al,%ebx
  1030a8:	85 db                	test   %ebx,%ebx
  1030aa:	74 26                	je     1030d2 <vprintfmt+0x242>
  1030ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030b0:	78 b6                	js     103068 <vprintfmt+0x1d8>
  1030b2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1030b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030ba:	79 ac                	jns    103068 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  1030bc:	eb 14                	jmp    1030d2 <vprintfmt+0x242>
                putch(' ', putdat);
  1030be:	83 ec 08             	sub    $0x8,%esp
  1030c1:	ff 75 0c             	pushl  0xc(%ebp)
  1030c4:	6a 20                	push   $0x20
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	ff d0                	call   *%eax
  1030cb:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  1030ce:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1030d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030d6:	7f e6                	jg     1030be <vprintfmt+0x22e>
            }
            break;
  1030d8:	e9 4e 01 00 00       	jmp    10322b <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1030dd:	83 ec 08             	sub    $0x8,%esp
  1030e0:	ff 75 e0             	pushl  -0x20(%ebp)
  1030e3:	8d 45 14             	lea    0x14(%ebp),%eax
  1030e6:	50                   	push   %eax
  1030e7:	e8 39 fd ff ff       	call   102e25 <getint>
  1030ec:	83 c4 10             	add    $0x10,%esp
  1030ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030fb:	85 d2                	test   %edx,%edx
  1030fd:	79 23                	jns    103122 <vprintfmt+0x292>
                putch('-', putdat);
  1030ff:	83 ec 08             	sub    $0x8,%esp
  103102:	ff 75 0c             	pushl  0xc(%ebp)
  103105:	6a 2d                	push   $0x2d
  103107:	8b 45 08             	mov    0x8(%ebp),%eax
  10310a:	ff d0                	call   *%eax
  10310c:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103115:	f7 d8                	neg    %eax
  103117:	83 d2 00             	adc    $0x0,%edx
  10311a:	f7 da                	neg    %edx
  10311c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10311f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103122:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103129:	e9 9f 00 00 00       	jmp    1031cd <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10312e:	83 ec 08             	sub    $0x8,%esp
  103131:	ff 75 e0             	pushl  -0x20(%ebp)
  103134:	8d 45 14             	lea    0x14(%ebp),%eax
  103137:	50                   	push   %eax
  103138:	e8 99 fc ff ff       	call   102dd6 <getuint>
  10313d:	83 c4 10             	add    $0x10,%esp
  103140:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103143:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103146:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10314d:	eb 7e                	jmp    1031cd <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10314f:	83 ec 08             	sub    $0x8,%esp
  103152:	ff 75 e0             	pushl  -0x20(%ebp)
  103155:	8d 45 14             	lea    0x14(%ebp),%eax
  103158:	50                   	push   %eax
  103159:	e8 78 fc ff ff       	call   102dd6 <getuint>
  10315e:	83 c4 10             	add    $0x10,%esp
  103161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103164:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103167:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10316e:	eb 5d                	jmp    1031cd <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  103170:	83 ec 08             	sub    $0x8,%esp
  103173:	ff 75 0c             	pushl  0xc(%ebp)
  103176:	6a 30                	push   $0x30
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
  10317b:	ff d0                	call   *%eax
  10317d:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103180:	83 ec 08             	sub    $0x8,%esp
  103183:	ff 75 0c             	pushl  0xc(%ebp)
  103186:	6a 78                	push   $0x78
  103188:	8b 45 08             	mov    0x8(%ebp),%eax
  10318b:	ff d0                	call   *%eax
  10318d:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103190:	8b 45 14             	mov    0x14(%ebp),%eax
  103193:	8d 50 04             	lea    0x4(%eax),%edx
  103196:	89 55 14             	mov    %edx,0x14(%ebp)
  103199:	8b 00                	mov    (%eax),%eax
  10319b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10319e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1031a5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1031ac:	eb 1f                	jmp    1031cd <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1031ae:	83 ec 08             	sub    $0x8,%esp
  1031b1:	ff 75 e0             	pushl  -0x20(%ebp)
  1031b4:	8d 45 14             	lea    0x14(%ebp),%eax
  1031b7:	50                   	push   %eax
  1031b8:	e8 19 fc ff ff       	call   102dd6 <getuint>
  1031bd:	83 c4 10             	add    $0x10,%esp
  1031c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1031c6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1031cd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031d4:	83 ec 04             	sub    $0x4,%esp
  1031d7:	52                   	push   %edx
  1031d8:	ff 75 e8             	pushl  -0x18(%ebp)
  1031db:	50                   	push   %eax
  1031dc:	ff 75 f4             	pushl  -0xc(%ebp)
  1031df:	ff 75 f0             	pushl  -0x10(%ebp)
  1031e2:	ff 75 0c             	pushl  0xc(%ebp)
  1031e5:	ff 75 08             	pushl  0x8(%ebp)
  1031e8:	e8 f8 fa ff ff       	call   102ce5 <printnum>
  1031ed:	83 c4 20             	add    $0x20,%esp
            break;
  1031f0:	eb 39                	jmp    10322b <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1031f2:	83 ec 08             	sub    $0x8,%esp
  1031f5:	ff 75 0c             	pushl  0xc(%ebp)
  1031f8:	53                   	push   %ebx
  1031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fc:	ff d0                	call   *%eax
  1031fe:	83 c4 10             	add    $0x10,%esp
            break;
  103201:	eb 28                	jmp    10322b <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103203:	83 ec 08             	sub    $0x8,%esp
  103206:	ff 75 0c             	pushl  0xc(%ebp)
  103209:	6a 25                	push   $0x25
  10320b:	8b 45 08             	mov    0x8(%ebp),%eax
  10320e:	ff d0                	call   *%eax
  103210:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103213:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103217:	eb 04                	jmp    10321d <vprintfmt+0x38d>
  103219:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10321d:	8b 45 10             	mov    0x10(%ebp),%eax
  103220:	83 e8 01             	sub    $0x1,%eax
  103223:	0f b6 00             	movzbl (%eax),%eax
  103226:	3c 25                	cmp    $0x25,%al
  103228:	75 ef                	jne    103219 <vprintfmt+0x389>
                /* do nothing */;
            break;
  10322a:	90                   	nop
    while (1) {
  10322b:	e9 68 fc ff ff       	jmp    102e98 <vprintfmt+0x8>
                return;
  103230:	90                   	nop
        }
    }
}
  103231:	8d 65 f8             	lea    -0x8(%ebp),%esp
  103234:	5b                   	pop    %ebx
  103235:	5e                   	pop    %esi
  103236:	5d                   	pop    %ebp
  103237:	c3                   	ret    

00103238 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103238:	55                   	push   %ebp
  103239:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10323b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10323e:	8b 40 08             	mov    0x8(%eax),%eax
  103241:	8d 50 01             	lea    0x1(%eax),%edx
  103244:	8b 45 0c             	mov    0xc(%ebp),%eax
  103247:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10324a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324d:	8b 10                	mov    (%eax),%edx
  10324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103252:	8b 40 04             	mov    0x4(%eax),%eax
  103255:	39 c2                	cmp    %eax,%edx
  103257:	73 12                	jae    10326b <sprintputch+0x33>
        *b->buf ++ = ch;
  103259:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325c:	8b 00                	mov    (%eax),%eax
  10325e:	8d 48 01             	lea    0x1(%eax),%ecx
  103261:	8b 55 0c             	mov    0xc(%ebp),%edx
  103264:	89 0a                	mov    %ecx,(%edx)
  103266:	8b 55 08             	mov    0x8(%ebp),%edx
  103269:	88 10                	mov    %dl,(%eax)
    }
}
  10326b:	90                   	nop
  10326c:	5d                   	pop    %ebp
  10326d:	c3                   	ret    

0010326e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10326e:	55                   	push   %ebp
  10326f:	89 e5                	mov    %esp,%ebp
  103271:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103274:	8d 45 14             	lea    0x14(%ebp),%eax
  103277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10327d:	50                   	push   %eax
  10327e:	ff 75 10             	pushl  0x10(%ebp)
  103281:	ff 75 0c             	pushl  0xc(%ebp)
  103284:	ff 75 08             	pushl  0x8(%ebp)
  103287:	e8 0b 00 00 00       	call   103297 <vsnprintf>
  10328c:	83 c4 10             	add    $0x10,%esp
  10328f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103292:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103295:	c9                   	leave  
  103296:	c3                   	ret    

00103297 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103297:	55                   	push   %ebp
  103298:	89 e5                	mov    %esp,%ebp
  10329a:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10329d:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ac:	01 d0                	add    %edx,%eax
  1032ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1032b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1032bc:	74 0a                	je     1032c8 <vsnprintf+0x31>
  1032be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c4:	39 c2                	cmp    %eax,%edx
  1032c6:	76 07                	jbe    1032cf <vsnprintf+0x38>
        return -E_INVAL;
  1032c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1032cd:	eb 20                	jmp    1032ef <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1032cf:	ff 75 14             	pushl  0x14(%ebp)
  1032d2:	ff 75 10             	pushl  0x10(%ebp)
  1032d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1032d8:	50                   	push   %eax
  1032d9:	68 38 32 10 00       	push   $0x103238
  1032de:	e8 ad fb ff ff       	call   102e90 <vprintfmt>
  1032e3:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1032e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032e9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032ef:	c9                   	leave  
  1032f0:	c3                   	ret    
