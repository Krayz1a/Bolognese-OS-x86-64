
kernel.elf:     file format elf64-x86-64


Disassembly of section .text:

ffffffff80000000 <draw_pixel>:
	}
}

// Raw pixel drawing function
void draw_pixel(uint32_t x, uint32_t y, uint32_t color) {
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000000:	48 8b 05 e1 40 00 00 	mov    0x40e1(%rip),%rax        # ffffffff800040e8 <framebuffer_request+0x28>
void draw_pixel(uint32_t x, uint32_t y, uint32_t color) {
ffffffff80000007:	89 f9                	mov    %edi,%ecx
ffffffff80000009:	89 d7                	mov    %edx,%edi
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff8000000b:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000000f:	48 8b 10             	mov    (%rax),%rdx
	uint32_t *pixels = fb->address;

	// Pitch is in bytes. Since our pixels are 32-bit (4 bytes), we divide pitch by 4
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff80000012:	48 8b 42 18          	mov    0x18(%rdx),%rax
ffffffff80000016:	48 c1 e8 02          	shr    $0x2,%rax
	pixels[(y*pixels_per_row) + x] = color;
ffffffff8000001a:	0f af f0             	imul   %eax,%esi
ffffffff8000001d:	48 8b 02             	mov    (%rdx),%rax
ffffffff80000020:	01 f1                	add    %esi,%ecx
ffffffff80000022:	89 c9                	mov    %ecx,%ecx
ffffffff80000024:	89 3c 88             	mov    %edi,(%rax,%rcx,4)
}
ffffffff80000027:	c3                   	ret
ffffffff80000028:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
ffffffff8000002f:	00 

ffffffff80000030 <draw_char>:

// Color rendering function
void draw_char(char c, uint32_t color) {
	if (c == '\n') {
ffffffff80000030:	40 80 ff 0a          	cmp    $0xa,%dil
ffffffff80000034:	0f 84 e4 00 00 00    	je     ffffffff8000011e <draw_char+0xee>
		cursor_x = 0;
		cursor_y += 16;
		return;
	} else if (c == '\b') {
ffffffff8000003a:	40 80 ff 08          	cmp    $0x8,%dil
ffffffff8000003e:	0f 84 ec 00 00 00    	je     ffffffff80000130 <draw_char+0x100>
	}


	PSF1_HEADER *font_header = (PSF1_HEADER*)_binary_src_font_psf_start;

	if (font_header->magic[0]!=PSF1_MAGIC0 || font_header->magic[1]!=PSF1_MAGIC1) return;
ffffffff80000044:	80 3d b5 1f 00 00 36 	cmpb   $0x36,0x1fb5(%rip)        # ffffffff80002000 <_binary_src_font_psf_start>
ffffffff8000004b:	74 03                	je     ffffffff80000050 <draw_char+0x20>
ffffffff8000004d:	c3                   	ret
ffffffff8000004e:	66 90                	xchg   %ax,%ax
ffffffff80000050:	80 3d aa 1f 00 00 04 	cmpb   $0x4,0x1faa(%rip)        # ffffffff80002001 <_binary_src_font_psf_start+0x1>
ffffffff80000057:	75 f4                	jne    ffffffff8000004d <draw_char+0x1d>
void draw_char(char c, uint32_t color) {
ffffffff80000059:	55                   	push   %rbp

	uint8_t *glyph_data = (uint8_t*)(_binary_src_font_psf_start + sizeof(PSF1_HEADER));

	int font_idx = (unsigned char)c;
ffffffff8000005a:	40 0f b6 ff          	movzbl %dil,%edi
ffffffff8000005e:	41 89 f3             	mov    %esi,%r11d
	uint8_t *glyph = glyph_data + (font_idx * font_header->chars_size);

	for (int y=0; y < font_header->chars_size; y++) {
ffffffff80000061:	45 31 c9             	xor    %r9d,%r9d
void draw_char(char c, uint32_t color) {
ffffffff80000064:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000067:	53                   	push   %rbx
	uint8_t *glyph = glyph_data + (font_idx * font_header->chars_size);
ffffffff80000068:	0f b6 1d 94 1f 00 00 	movzbl 0x1f94(%rip),%ebx        # ffffffff80002003 <_binary_src_font_psf_start+0x3>
ffffffff8000006f:	0f af fb             	imul   %ebx,%edi
ffffffff80000072:	4c 63 d7             	movslq %edi,%r10
		uint8_t row_data = glyph[y];
		for (int x=0; x < 8; x++) {
			if ((row_data >> (7-x)) & 1) {
ffffffff80000075:	bf 07 00 00 00       	mov    $0x7,%edi
	for (int y=0; y < font_header->chars_size; y++) {
ffffffff8000007a:	85 db                	test   %ebx,%ebx
ffffffff8000007c:	74 66                	je     ffffffff800000e4 <draw_char+0xb4>
ffffffff8000007e:	66 90                	xchg   %ax,%ax
			if ((row_data >> (7-x)) & 1) {
ffffffff80000080:	43 0f b6 b4 0a 04 20 	movzbl -0x7fffdffc(%r10,%r9,1),%esi
ffffffff80000087:	00 80 
		for (int x=0; x < 8; x++) {
ffffffff80000089:	31 c0                	xor    %eax,%eax
ffffffff8000008b:	eb 0b                	jmp    ffffffff80000098 <draw_char+0x68>
ffffffff8000008d:	0f 1f 00             	nopl   (%rax)
ffffffff80000090:	83 c0 01             	add    $0x1,%eax
ffffffff80000093:	83 f8 08             	cmp    $0x8,%eax
ffffffff80000096:	74 43                	je     ffffffff800000db <draw_char+0xab>
			if ((row_data >> (7-x)) & 1) {
ffffffff80000098:	89 fa                	mov    %edi,%edx
ffffffff8000009a:	29 c2                	sub    %eax,%edx
ffffffff8000009c:	0f a3 d6             	bt     %edx,%esi
ffffffff8000009f:	73 ef                	jae    ffffffff80000090 <draw_char+0x60>
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff800000a1:	48 8b 15 40 40 00 00 	mov    0x4040(%rip),%rdx        # ffffffff800040e8 <framebuffer_request+0x28>
ffffffff800000a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800000ac:	4c 8b 02             	mov    (%rdx),%r8
				draw_pixel(cursor_x + x, cursor_y + y, color);
ffffffff800000af:	8b 15 4b 4f 00 00    	mov    0x4f4b(%rip),%edx        # ffffffff80005000 <cursor_y>
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff800000b5:	49 8b 48 18          	mov    0x18(%r8),%rcx
				draw_pixel(cursor_x + x, cursor_y + y, color);
ffffffff800000b9:	44 01 ca             	add    %r9d,%edx
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff800000bc:	48 c1 e9 02          	shr    $0x2,%rcx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff800000c0:	0f af d1             	imul   %ecx,%edx
ffffffff800000c3:	03 15 3b 4f 00 00    	add    0x4f3b(%rip),%edx        # ffffffff80005004 <cursor_x>
ffffffff800000c9:	8d 0c 02             	lea    (%rdx,%rax,1),%ecx
ffffffff800000cc:	49 8b 10             	mov    (%r8),%rdx
		for (int x=0; x < 8; x++) {
ffffffff800000cf:	83 c0 01             	add    $0x1,%eax
	pixels[(y*pixels_per_row) + x] = color;
ffffffff800000d2:	44 89 1c 8a          	mov    %r11d,(%rdx,%rcx,4)
		for (int x=0; x < 8; x++) {
ffffffff800000d6:	83 f8 08             	cmp    $0x8,%eax
ffffffff800000d9:	75 bd                	jne    ffffffff80000098 <draw_char+0x68>
	for (int y=0; y < font_header->chars_size; y++) {
ffffffff800000db:	49 83 c1 01          	add    $0x1,%r9
ffffffff800000df:	44 39 cb             	cmp    %r9d,%ebx
ffffffff800000e2:	7f 9c                	jg     ffffffff80000080 <draw_char+0x50>
			}
		}
	}

	cursor_x += 8;
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
ffffffff800000e4:	48 8b 15 fd 3f 00 00 	mov    0x3ffd(%rip),%rdx        # ffffffff800040e8 <framebuffer_request+0x28>
	cursor_x += 8;
ffffffff800000eb:	8b 05 13 4f 00 00    	mov    0x4f13(%rip),%eax        # ffffffff80005004 <cursor_x>
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
ffffffff800000f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
	cursor_x += 8;
ffffffff800000f5:	83 c0 08             	add    $0x8,%eax
ffffffff800000f8:	89 05 06 4f 00 00    	mov    %eax,0x4f06(%rip)        # ffffffff80005004 <cursor_x>
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
ffffffff800000fe:	48 8b 12             	mov    (%rdx),%rdx
ffffffff80000101:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff80000105:	72 11                	jb     ffffffff80000118 <draw_char+0xe8>
		cursor_x = 0;
		cursor_y += 16;
ffffffff80000107:	83 05 f2 4e 00 00 10 	addl   $0x10,0x4ef2(%rip)        # ffffffff80005000 <cursor_y>
		cursor_x = 0;
ffffffff8000010e:	c7 05 ec 4e 00 00 00 	movl   $0x0,0x4eec(%rip)        # ffffffff80005004 <cursor_x>
ffffffff80000115:	00 00 00 
	}
}
ffffffff80000118:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffffffff8000011c:	c9                   	leave
ffffffff8000011d:	c3                   	ret
		cursor_y += 16;
ffffffff8000011e:	83 05 db 4e 00 00 10 	addl   $0x10,0x4edb(%rip)        # ffffffff80005000 <cursor_y>
		cursor_x = 0;
ffffffff80000125:	c7 05 d5 4e 00 00 00 	movl   $0x0,0x4ed5(%rip)        # ffffffff80005004 <cursor_x>
ffffffff8000012c:	00 00 00 
		return;
ffffffff8000012f:	c3                   	ret
		if(cursor_x >= 8) cursor_x -= 8;
ffffffff80000130:	8b 35 ce 4e 00 00    	mov    0x4ece(%rip),%esi        # ffffffff80005004 <cursor_x>
		cursor_y += 16;
ffffffff80000136:	8b 05 c4 4e 00 00    	mov    0x4ec4(%rip),%eax        # ffffffff80005000 <cursor_y>
		if(cursor_x >= 8) cursor_x -= 8;
ffffffff8000013c:	83 fe 07             	cmp    $0x7,%esi
ffffffff8000013f:	0f 86 94 00 00 00    	jbe    ffffffff800001d9 <draw_char+0x1a9>
ffffffff80000145:	83 ee 08             	sub    $0x8,%esi
ffffffff80000148:	89 35 b6 4e 00 00    	mov    %esi,0x4eb6(%rip)        # ffffffff80005004 <cursor_x>
			for (int x=0; x<8; x++) {
ffffffff8000014e:	31 ff                	xor    %edi,%edi
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000150:	48 8b 15 91 3f 00 00 	mov    0x3f91(%rip),%rdx        # ffffffff800040e8 <framebuffer_request+0x28>
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff80000157:	01 f8                	add    %edi,%eax
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000159:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff8000015d:	48 8b 0a             	mov    (%rdx),%rcx
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff80000160:	48 8b 51 18          	mov    0x18(%rcx),%rdx
ffffffff80000164:	48 c1 ea 02          	shr    $0x2,%rdx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff80000168:	0f af c2             	imul   %edx,%eax
ffffffff8000016b:	8d 14 30             	lea    (%rax,%rsi,1),%edx
ffffffff8000016e:	48 8b 01             	mov    (%rcx),%rax
ffffffff80000171:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
			for (int x=0; x<8; x++) {
ffffffff80000178:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff8000017d:	0f 1f 00             	nopl   (%rax)
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000180:	48 8b 05 61 3f 00 00 	mov    0x3f61(%rip),%rax        # ffffffff800040e8 <framebuffer_request+0x28>
ffffffff80000187:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000018b:	48 8b 30             	mov    (%rax),%rsi
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff8000018e:	8b 05 6c 4e 00 00    	mov    0x4e6c(%rip),%eax        # ffffffff80005000 <cursor_y>
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff80000194:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff80000198:	01 f8                	add    %edi,%eax
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff8000019a:	48 c1 e9 02          	shr    $0x2,%rcx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff8000019e:	0f af c1             	imul   %ecx,%eax
ffffffff800001a1:	03 05 5d 4e 00 00    	add    0x4e5d(%rip),%eax        # ffffffff80005004 <cursor_x>
ffffffff800001a7:	8d 0c 10             	lea    (%rax,%rdx,1),%ecx
ffffffff800001aa:	48 8b 06             	mov    (%rsi),%rax
			for (int x=0; x<8; x++) {
ffffffff800001ad:	83 c2 01             	add    $0x1,%edx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff800001b0:	c7 04 88 00 00 00 00 	movl   $0x0,(%rax,%rcx,4)
			for (int x=0; x<8; x++) {
ffffffff800001b7:	83 fa 08             	cmp    $0x8,%edx
ffffffff800001ba:	75 c4                	jne    ffffffff80000180 <draw_char+0x150>
		for (int y=0; y < 16; y++) {
ffffffff800001bc:	83 c7 01             	add    $0x1,%edi
ffffffff800001bf:	83 ff 10             	cmp    $0x10,%edi
ffffffff800001c2:	0f 84 85 fe ff ff    	je     ffffffff8000004d <draw_char+0x1d>
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff800001c8:	8b 05 32 4e 00 00    	mov    0x4e32(%rip),%eax        # ffffffff80005000 <cursor_y>
ffffffff800001ce:	8b 35 30 4e 00 00    	mov    0x4e30(%rip),%esi        # ffffffff80005004 <cursor_x>
ffffffff800001d4:	e9 77 ff ff ff       	jmp    ffffffff80000150 <draw_char+0x120>
		else if (cursor_y >= 16) {	// wrap backward to the end of the previous line
ffffffff800001d9:	83 f8 0f             	cmp    $0xf,%eax
ffffffff800001dc:	0f 86 6c ff ff ff    	jbe    ffffffff8000014e <draw_char+0x11e>
			uint32_t screen_width = framebuffer_request.response->framebuffers[0]->width;
ffffffff800001e2:	48 8b 15 ff 3e 00 00 	mov    0x3eff(%rip),%rdx        # ffffffff800040e8 <framebuffer_request+0x28>
			cursor_y -= 16;
ffffffff800001e9:	83 e8 10             	sub    $0x10,%eax
ffffffff800001ec:	89 05 0e 4e 00 00    	mov    %eax,0x4e0e(%rip)        # ffffffff80005000 <cursor_y>
			uint32_t screen_width = framebuffer_request.response->framebuffers[0]->width;
ffffffff800001f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800001f6:	48 8b 12             	mov    (%rdx),%rdx
ffffffff800001f9:	48 8b 72 08          	mov    0x8(%rdx),%rsi
			cursor_x = screen_width -8;
ffffffff800001fd:	83 ee 08             	sub    $0x8,%esi
ffffffff80000200:	89 35 fe 4d 00 00    	mov    %esi,0x4dfe(%rip)        # ffffffff80005004 <cursor_x>
		for (int y=0; y < 16; y++) {
ffffffff80000206:	e9 43 ff ff ff       	jmp    ffffffff8000014e <draw_char+0x11e>
ffffffff8000020b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000210 <kernel_main>:

// The Main Kernel Entry Point
void kernel_main(void){
	if(LIMINE_BASE_REVISION_SUPPORTED(base_revision) == false){
ffffffff80000210:	48 8b 05 e9 3e 00 00 	mov    0x3ee9(%rip),%rax        # ffffffff80004100 <base_revision+0x10>
ffffffff80000217:	48 85 c0             	test   %rax,%rax
ffffffff8000021a:	74 07                	je     ffffffff80000223 <kernel_main+0x13>
	__asm__ __volatile__ ("cli");
ffffffff8000021c:	fa                   	cli
ffffffff8000021d:	0f 1f 00             	nopl   (%rax)
		__asm__ __volatile__ ("hlt");
ffffffff80000220:	f4                   	hlt
	for (;;){
ffffffff80000221:	eb fd                	jmp    ffffffff80000220 <kernel_main+0x10>
void kernel_main(void){
ffffffff80000223:	55                   	push   %rbp
ffffffff80000224:	48 89 e5             	mov    %rsp,%rbp
		hcf();
	}

	// Sets up the Interrupt Descriptor Table (IDT) so the CPU knows how to handle exceptions and hardware interrupts
	idt_init();
ffffffff80000227:	e8 a4 01 00 00       	call   ffffffff800003d0 <idt_init>

	print_str("Hello from the 64-bit Higher Half!\n");
ffffffff8000022c:	48 c7 c7 00 10 00 80 	mov    $0xffffffff80001000,%rdi
ffffffff80000233:	e8 58 08 00 00       	call   ffffffff80000a90 <print_str>

	// Reconfigures the  Programmable Interrupt Controller (PIC) so hardware interrupts don't conflict with CPU exceptions
	pic_remap(32,40);	
ffffffff80000238:	be 28 00 00 00       	mov    $0x28,%esi
ffffffff8000023d:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff80000242:	e8 69 02 00 00       	call   ffffffff800004b0 <pic_remap>

	// Initializes the Physical Memory Manager (PMM) to keep track of free and used RAM frames
	pmm_init();	
ffffffff80000247:	e8 64 07 00 00       	call   ffffffff800009b0 <pmm_init>
	

	__asm__ __volatile__ ("int $0");
ffffffff8000024c:	cd 00                	int    $0x0
ffffffff8000024e:	66 90                	xchg   %ax,%ax
	for (;;) {
		__asm__ __volatile__ ("hlt");
ffffffff80000250:	f4                   	hlt
	for (;;) {
ffffffff80000251:	eb fd                	jmp    ffffffff80000250 <kernel_main+0x40>
ffffffff80000253:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff8000025a:	00 00 00 
ffffffff8000025d:	0f 1f 00             	nopl   (%rax)

ffffffff80000260 <keyboard_handler>:

	__asm__ __volatile__ ("cli; hlt");
}

__attribute__((interrupt))
static void keyboard_handler(struct interrupt_frame *frame) {
ffffffff80000260:	55                   	push   %rbp
ffffffff80000261:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000264:	41 53                	push   %r11
ffffffff80000266:	41 52                	push   %r10
ffffffff80000268:	41 51                	push   %r9
ffffffff8000026a:	41 50                	push   %r8
ffffffff8000026c:	57                   	push   %rdi
ffffffff8000026d:	56                   	push   %rsi
ffffffff8000026e:	53                   	push   %rbx
ffffffff8000026f:	51                   	push   %rcx
ffffffff80000270:	52                   	push   %rdx
ffffffff80000271:	50                   	push   %rax
ffffffff80000272:	48 83 ec 10          	sub    $0x10,%rsp
	__asm__ __volatile__ ( "outb %0, %1" : : "a"(val), "Nd"(port) : "memory");
}

static inline uint8_t inb(uint16_t port) {
	uint8_t ret;
	__asm__ __volatile__ ( "inb %1, %0" : "=a"(ret) : "Nd"(port) : "memory");
ffffffff80000276:	e4 60                	in     $0x60,%al
	(void)frame;
	uint8_t scancode = inb(0x60);	// 0x60 is the Keyboard controller data register
	
	if(scancode == 0x2A || scancode == 0x36) shift_pressed = true;
ffffffff80000278:	3c 2a                	cmp    $0x2a,%al
ffffffff8000027a:	74 54                	je     ffffffff800002d0 <keyboard_handler+0x70>
ffffffff8000027c:	3c 36                	cmp    $0x36,%al
ffffffff8000027e:	74 50                	je     ffffffff800002d0 <keyboard_handler+0x70>

	else if(scancode == 0xAA || scancode == 0xB6) shift_pressed = false;
ffffffff80000280:	3c aa                	cmp    $0xaa,%al
ffffffff80000282:	74 7c                	je     ffffffff80000300 <keyboard_handler+0xa0>
ffffffff80000284:	3c b6                	cmp    $0xb6,%al
ffffffff80000286:	74 78                	je     ffffffff80000300 <keyboard_handler+0xa0>

	else if(!(scancode & 0x80)){		// check if MSB is set, if not then its press (else release)
ffffffff80000288:	84 c0                	test   %al,%al
ffffffff8000028a:	0f 88 80 00 00 00    	js     ffffffff80000310 <keyboard_handler+0xb0>
		char ascii = shift_pressed ? kbd_US_shifted[scancode] : kbd_US[scancode];
ffffffff80000290:	80 3d 89 5d 00 00 00 	cmpb   $0x0,0x5d89(%rip)        # ffffffff80006020 <shift_pressed>
ffffffff80000297:	0f b6 c0             	movzbl %al,%eax
ffffffff8000029a:	74 7c                	je     ffffffff80000318 <keyboard_handler+0xb8>
ffffffff8000029c:	0f b6 98 c0 10 00 80 	movzbl -0x7fffef40(%rax),%ebx
		if(ascii != 0){
ffffffff800002a3:	84 db                	test   %bl,%bl
ffffffff800002a5:	74 69                	je     ffffffff80000310 <keyboard_handler+0xb0>
			if(ascii == '\b') {
ffffffff800002a7:	80 fb 08             	cmp    $0x8,%bl
ffffffff800002aa:	74 7c                	je     ffffffff80000328 <keyboard_handler+0xc8>
				print_str("\b \b");
			} else { 
				char str[2] = {ascii, '\0'};
				print_str(str);
ffffffff800002ac:	48 8d 7d ae          	lea    -0x52(%rbp),%rdi
				char str[2] = {ascii, '\0'};
ffffffff800002b0:	88 5d ae             	mov    %bl,-0x52(%rbp)
ffffffff800002b3:	c6 45 af 00          	movb   $0x0,-0x51(%rbp)
				print_str(str);
ffffffff800002b7:	fc                   	cld
ffffffff800002b8:	e8 d3 07 00 00       	call   ffffffff80000a90 <print_str>
			}

			draw_char(ascii, 0x00FF00);
ffffffff800002bd:	0f be fb             	movsbl %bl,%edi
ffffffff800002c0:	be 00 ff 00 00       	mov    $0xff00,%esi
ffffffff800002c5:	e8 66 fd ff ff       	call   ffffffff80000030 <draw_char>
ffffffff800002ca:	eb 0c                	jmp    ffffffff800002d8 <keyboard_handler+0x78>
ffffffff800002cc:	0f 1f 40 00          	nopl   0x0(%rax)
	if(scancode == 0x2A || scancode == 0x36) shift_pressed = true;
ffffffff800002d0:	c6 05 49 5d 00 00 01 	movb   $0x1,0x5d49(%rip)        # ffffffff80006020 <shift_pressed>
ffffffff800002d7:	fc                   	cld
		}
	}
	pic_send_eoi(1);	// keyboard wired to IRQ 1 of the Master PIC
ffffffff800002d8:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff800002dd:	e8 ae 01 00 00       	call   ffffffff80000490 <pic_send_eoi>
}
ffffffff800002e2:	48 83 c4 10          	add    $0x10,%rsp
ffffffff800002e6:	58                   	pop    %rax
ffffffff800002e7:	5a                   	pop    %rdx
ffffffff800002e8:	59                   	pop    %rcx
ffffffff800002e9:	5b                   	pop    %rbx
ffffffff800002ea:	5e                   	pop    %rsi
ffffffff800002eb:	5f                   	pop    %rdi
ffffffff800002ec:	41 58                	pop    %r8
ffffffff800002ee:	41 59                	pop    %r9
ffffffff800002f0:	41 5a                	pop    %r10
ffffffff800002f2:	41 5b                	pop    %r11
ffffffff800002f4:	5d                   	pop    %rbp
ffffffff800002f5:	48 cf                	iretq
ffffffff800002f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff800002fe:	00 00 
	else if(scancode == 0xAA || scancode == 0xB6) shift_pressed = false;
ffffffff80000300:	c6 05 19 5d 00 00 00 	movb   $0x0,0x5d19(%rip)        # ffffffff80006020 <shift_pressed>
ffffffff80000307:	fc                   	cld
ffffffff80000308:	eb ce                	jmp    ffffffff800002d8 <keyboard_handler+0x78>
ffffffff8000030a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
ffffffff80000310:	fc                   	cld
ffffffff80000311:	eb c5                	jmp    ffffffff800002d8 <keyboard_handler+0x78>
ffffffff80000313:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
		char ascii = shift_pressed ? kbd_US_shifted[scancode] : kbd_US[scancode];
ffffffff80000318:	0f b6 98 40 11 00 80 	movzbl -0x7fffeec0(%rax),%ebx
ffffffff8000031f:	eb 82                	jmp    ffffffff800002a3 <keyboard_handler+0x43>
ffffffff80000321:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
				print_str("\b \b");
ffffffff80000328:	48 c7 c7 24 10 00 80 	mov    $0xffffffff80001024,%rdi
ffffffff8000032f:	fc                   	cld
ffffffff80000330:	e8 5b 07 00 00       	call   ffffffff80000a90 <print_str>
ffffffff80000335:	eb 86                	jmp    ffffffff800002bd <keyboard_handler+0x5d>
ffffffff80000337:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff8000033e:	00 00 

ffffffff80000340 <generic_exception_handler>:
static void generic_exception_handler(struct interrupt_frame* frame) {
ffffffff80000340:	55                   	push   %rbp
ffffffff80000341:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000344:	41 53                	push   %r11
ffffffff80000346:	41 52                	push   %r10
ffffffff80000348:	41 51                	push   %r9
ffffffff8000034a:	41 50                	push   %r8
ffffffff8000034c:	57                   	push   %rdi
	print_str("\nnig nig nig nig nign igni\n");
ffffffff8000034d:	48 c7 c7 28 10 00 80 	mov    $0xffffffff80001028,%rdi
static void generic_exception_handler(struct interrupt_frame* frame) {
ffffffff80000354:	56                   	push   %rsi
ffffffff80000355:	51                   	push   %rcx
ffffffff80000356:	52                   	push   %rdx
ffffffff80000357:	50                   	push   %rax
ffffffff80000358:	48 83 ec 08          	sub    $0x8,%rsp
	print_str("\nnig nig nig nig nign igni\n");
ffffffff8000035c:	fc                   	cld
ffffffff8000035d:	e8 2e 07 00 00       	call   ffffffff80000a90 <print_str>
	print_str(" RIP (Instruction) ");
ffffffff80000362:	48 c7 c7 44 10 00 80 	mov    $0xffffffff80001044,%rdi
ffffffff80000369:	e8 22 07 00 00       	call   ffffffff80000a90 <print_str>
	print_hex(frame->rip);
ffffffff8000036e:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
ffffffff80000372:	e8 39 07 00 00       	call   ffffffff80000ab0 <print_hex>
	print_str("\n");
ffffffff80000377:	48 c7 c7 6d 10 00 80 	mov    $0xffffffff8000106d,%rdi
ffffffff8000037e:	e8 0d 07 00 00       	call   ffffffff80000a90 <print_str>
	print_str(" RSP (Stack) ");
ffffffff80000383:	48 c7 c7 58 10 00 80 	mov    $0xffffffff80001058,%rdi
ffffffff8000038a:	e8 01 07 00 00       	call   ffffffff80000a90 <print_str>
	print_hex(frame->rsp);
ffffffff8000038f:	48 8b 7d 20          	mov    0x20(%rbp),%rdi
ffffffff80000393:	e8 18 07 00 00       	call   ffffffff80000ab0 <print_hex>
	print_str("\n");
ffffffff80000398:	48 c7 c7 6d 10 00 80 	mov    $0xffffffff8000106d,%rdi
ffffffff8000039f:	e8 ec 06 00 00       	call   ffffffff80000a90 <print_str>
	print_str(" HALTED\n");
ffffffff800003a4:	48 c7 c7 66 10 00 80 	mov    $0xffffffff80001066,%rdi
ffffffff800003ab:	e8 e0 06 00 00       	call   ffffffff80000a90 <print_str>
	__asm__ __volatile__ ("cli; hlt");
ffffffff800003b0:	fa                   	cli
ffffffff800003b1:	f4                   	hlt
}
ffffffff800003b2:	48 83 c4 08          	add    $0x8,%rsp
ffffffff800003b6:	58                   	pop    %rax
ffffffff800003b7:	5a                   	pop    %rdx
ffffffff800003b8:	59                   	pop    %rcx
ffffffff800003b9:	5e                   	pop    %rsi
ffffffff800003ba:	5f                   	pop    %rdi
ffffffff800003bb:	41 58                	pop    %r8
ffffffff800003bd:	41 59                	pop    %r9
ffffffff800003bf:	41 5a                	pop    %r10
ffffffff800003c1:	41 5b                	pop    %r11
ffffffff800003c3:	5d                   	pop    %rbp
ffffffff800003c4:	48 cf                	iretq
ffffffff800003c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff800003cd:	00 00 00 

ffffffff800003d0 <idt_init>:
	uint64_t isr_addr = (uint64_t)isr;
ffffffff800003d0:	48 c7 c2 40 03 00 80 	mov    $0xffffffff80000340,%rdx

void idt_init(void) {
	idtr.base = (uint64_t)&idt[0];
	idtr.limit = (uint16_t)sizeof(idt) - 1;
ffffffff800003d7:	41 ba ff 0f 00 00    	mov    $0xfff,%r10d
	idtr.base = (uint64_t)&idt[0];
ffffffff800003dd:	48 c7 05 2a 4c 00 00 	movq   $0xffffffff80005020,0x4c2a(%rip)        # ffffffff80005012 <idtr+0x2>
ffffffff800003e4:	20 50 00 80 
	idtr.limit = (uint16_t)sizeof(idt) - 1;
ffffffff800003e8:	0f b7 35 d1 0d 00 00 	movzwl 0xdd1(%rip),%esi        # ffffffff800011c0 <kbd_US+0x80>
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff800003ef:	48 89 d0             	mov    %rdx,%rax
	idtr.limit = (uint16_t)sizeof(idt) - 1;
ffffffff800003f2:	66 44 89 15 16 4c 00 	mov    %r10w,0x4c16(%rip)        # ffffffff80005010 <idtr>
ffffffff800003f9:	00 
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff800003fa:	48 89 d1             	mov    %rdx,%rcx
ffffffff800003fd:	48 c7 c7 20 52 00 80 	mov    $0xffffffff80005220,%rdi
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff80000404:	48 c1 e8 20          	shr    $0x20,%rax
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000408:	48 c1 e9 10          	shr    $0x10,%rcx
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff8000040c:	41 89 c0             	mov    %eax,%r8d
ffffffff8000040f:	48 c7 c0 20 50 00 80 	mov    $0xffffffff80005020,%rax
ffffffff80000416:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff8000041d:	00 00 00 
	idt_entry->kernel_cs = 0x28;
ffffffff80000420:	41 b9 28 00 00 00    	mov    $0x28,%r9d
	idt_entry->isr_low = isr_addr & 0xFFFF;
ffffffff80000426:	66 89 10             	mov    %dx,(%rax)

	for (int idx=0; idx < 32; idx++){
ffffffff80000429:	48 83 c0 10          	add    $0x10,%rax
	idt_entry->kernel_cs = 0x28;
ffffffff8000042d:	66 44 89 48 f2       	mov    %r9w,-0xe(%rax)
	idt_entry->ist = 0;
ffffffff80000432:	66 89 70 f4          	mov    %si,-0xc(%rax)
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000436:	66 89 48 f6          	mov    %cx,-0xa(%rax)
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff8000043a:	44 89 40 f8          	mov    %r8d,-0x8(%rax)
	idt_entry->zero = 0;
ffffffff8000043e:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%rax)
	for (int idx=0; idx < 32; idx++){
ffffffff80000445:	48 39 c7             	cmp    %rax,%rdi
ffffffff80000448:	75 d6                	jne    ffffffff80000420 <idt_init+0x50>
	uint64_t isr_addr = (uint64_t)isr;
ffffffff8000044a:	48 c7 c0 60 02 00 80 	mov    $0xffffffff80000260,%rax
	idt_entry->kernel_cs = 0x28;
ffffffff80000451:	c7 05 d7 4d 00 00 28 	movl   $0x8e000028,0x4dd7(%rip)        # ffffffff80005232 <idt+0x212>
ffffffff80000458:	00 00 8e 
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff8000045b:	48 89 c2             	mov    %rax,%rdx
	idt_entry->isr_low = isr_addr & 0xFFFF;
ffffffff8000045e:	66 89 05 cb 4d 00 00 	mov    %ax,0x4dcb(%rip)        # ffffffff80005230 <idt+0x210>
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff80000465:	48 c1 e8 20          	shr    $0x20,%rax
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000469:	48 c1 ea 10          	shr    $0x10,%rdx
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff8000046d:	89 05 c5 4d 00 00    	mov    %eax,0x4dc5(%rip)        # ffffffff80005238 <idt+0x218>
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000473:	66 89 15 bc 4d 00 00 	mov    %dx,0x4dbc(%rip)        # ffffffff80005236 <idt+0x216>
	idt_entry->zero = 0;
ffffffff8000047a:	c7 05 b8 4d 00 00 00 	movl   $0x0,0x4db8(%rip)        # ffffffff8000523c <idt+0x21c>
ffffffff80000481:	00 00 00 
		idt_set_entry(idx, generic_exception_handler, 0x8E);
	}

	idt_set_entry(33, keyboard_handler, 0x8E);

	__asm__ __volatile__ ("lidt %0" : : "m"(idtr));
ffffffff80000484:	0f 01 1d 85 4b 00 00 	lidt   0x4b85(%rip)        # ffffffff80005010 <idtr>
	__asm__ __volatile__ ("sti");
ffffffff8000048b:	fb                   	sti
}
ffffffff8000048c:	c3                   	ret
ffffffff8000048d:	0f 1f 00             	nopl   (%rax)

ffffffff80000490 <pic_send_eoi>:
#define ICW1_INIT 0x11
#define ICW4_8086 0x01

// Send EOI
void pic_send_eoi(unsigned char irq) {
	if(irq >= 8) {
ffffffff80000490:	40 80 ff 07          	cmp    $0x7,%dil
ffffffff80000494:	76 07                	jbe    ffffffff8000049d <pic_send_eoi+0xd>
	__asm__ __volatile__ ( "outb %0, %1" : : "a"(val), "Nd"(port) : "memory");
ffffffff80000496:	b8 20 00 00 00       	mov    $0x20,%eax
ffffffff8000049b:	e6 a0                	out    %al,$0xa0
ffffffff8000049d:	b8 20 00 00 00       	mov    $0x20,%eax
ffffffff800004a2:	e6 20                	out    %al,$0x20
		outb(PIC2_COMMAND, 0x20);
	}
	outb(PIC1_COMMAND, 0x20);
}
ffffffff800004a4:	c3                   	ret
ffffffff800004a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff800004ac:	00 00 00 00 

ffffffff800004b0 <pic_remap>:
ffffffff800004b0:	b9 11 00 00 00       	mov    $0x11,%ecx
ffffffff800004b5:	89 c8                	mov    %ecx,%eax
ffffffff800004b7:	e6 20                	out    %al,$0x20
ffffffff800004b9:	31 d2                	xor    %edx,%edx
ffffffff800004bb:	89 d0                	mov    %edx,%eax
ffffffff800004bd:	e6 80                	out    %al,$0x80
ffffffff800004bf:	89 c8                	mov    %ecx,%eax
ffffffff800004c1:	e6 a0                	out    %al,$0xa0
ffffffff800004c3:	89 d0                	mov    %edx,%eax
ffffffff800004c5:	e6 80                	out    %al,$0x80
ffffffff800004c7:	89 f8                	mov    %edi,%eax
ffffffff800004c9:	e6 21                	out    %al,$0x21
ffffffff800004cb:	89 d0                	mov    %edx,%eax
ffffffff800004cd:	e6 80                	out    %al,$0x80
ffffffff800004cf:	89 f0                	mov    %esi,%eax
ffffffff800004d1:	e6 a1                	out    %al,$0xa1
ffffffff800004d3:	89 d0                	mov    %edx,%eax
ffffffff800004d5:	e6 80                	out    %al,$0x80
ffffffff800004d7:	b8 04 00 00 00       	mov    $0x4,%eax
ffffffff800004dc:	e6 21                	out    %al,$0x21
ffffffff800004de:	89 d0                	mov    %edx,%eax
ffffffff800004e0:	e6 80                	out    %al,$0x80
ffffffff800004e2:	b8 02 00 00 00       	mov    $0x2,%eax
ffffffff800004e7:	e6 a1                	out    %al,$0xa1
ffffffff800004e9:	89 d0                	mov    %edx,%eax
ffffffff800004eb:	e6 80                	out    %al,$0x80
ffffffff800004ed:	b9 01 00 00 00       	mov    $0x1,%ecx
ffffffff800004f2:	89 c8                	mov    %ecx,%eax
ffffffff800004f4:	e6 21                	out    %al,$0x21
ffffffff800004f6:	89 d0                	mov    %edx,%eax
ffffffff800004f8:	e6 80                	out    %al,$0x80
ffffffff800004fa:	89 c8                	mov    %ecx,%eax
ffffffff800004fc:	e6 a1                	out    %al,$0xa1
ffffffff800004fe:	89 d0                	mov    %edx,%eax
ffffffff80000500:	e6 80                	out    %al,$0x80
ffffffff80000502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
ffffffff80000507:	e6 21                	out    %al,$0x21
ffffffff80000509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8000050e:	e6 a1                	out    %al,$0xa1
	io_wait();

	// restoring interrrupt masks
	outb(PIC1_DATA, 0xFD);
	outb(PIC2_DATA, 0xFF);
}
ffffffff80000510:	c3                   	ret
ffffffff80000511:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff80000518:	00 00 00 
ffffffff8000051b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000520 <pmm_dump_usable_memmap.part.0>:
        bitmap[byte_idx] &= ~(1 << bit_idx);
}

void pmm_dump_usable_memmap(void) {
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000520:	48 8b 05 81 3b 00 00 	mov    0x3b81(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000527:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
ffffffff8000052c:	0f 84 7e 00 00 00    	je     ffffffff800005b0 <pmm_dump_usable_memmap.part.0+0x90>
void pmm_dump_usable_memmap(void) {
ffffffff80000532:	55                   	push   %rbp
ffffffff80000533:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000536:	41 54                	push   %r12
ffffffff80000538:	53                   	push   %rbx
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000539:	31 db                	xor    %ebx,%ebx
ffffffff8000053b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff80000540:	48 8b 05 61 3b 00 00 	mov    0x3b61(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000547:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000054b:	4c 8b 24 d8          	mov    (%rax,%rbx,8),%r12
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff8000054f:	49 83 7c 24 10 00    	cmpq   $0x0,0x10(%r12)
ffffffff80000555:	75 41                	jne    ffffffff80000598 <pmm_dump_usable_memmap.part.0+0x78>
                        print_str("\n\nbase: ");
ffffffff80000557:	48 c7 c7 6f 10 00 80 	mov    $0xffffffff8000106f,%rdi
ffffffff8000055e:	e8 2d 05 00 00       	call   ffffffff80000a90 <print_str>
                        print_hex(mm->base);
ffffffff80000563:	49 8b 3c 24          	mov    (%r12),%rdi
ffffffff80000567:	e8 44 05 00 00       	call   ffffffff80000ab0 <print_hex>
                        print_str("\nlength: ");
ffffffff8000056c:	48 c7 c7 78 10 00 80 	mov    $0xffffffff80001078,%rdi
ffffffff80000573:	e8 18 05 00 00       	call   ffffffff80000a90 <print_str>
                        print_hex(mm->length);
ffffffff80000578:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
ffffffff8000057d:	e8 2e 05 00 00       	call   ffffffff80000ab0 <print_hex>
                        print_str("\ntype: ");
ffffffff80000582:	48 c7 c7 82 10 00 80 	mov    $0xffffffff80001082,%rdi
ffffffff80000589:	e8 02 05 00 00       	call   ffffffff80000a90 <print_str>
                        print_hex(mm->type);
ffffffff8000058e:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
ffffffff80000593:	e8 18 05 00 00       	call   ffffffff80000ab0 <print_hex>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000598:	48 8b 05 09 3b 00 00 	mov    0x3b09(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff8000059f:	48 83 c3 01          	add    $0x1,%rbx
ffffffff800005a3:	48 3b 58 08          	cmp    0x8(%rax),%rbx
ffffffff800005a7:	72 97                	jb     ffffffff80000540 <pmm_dump_usable_memmap.part.0+0x20>
                }
        }
}
ffffffff800005a9:	5b                   	pop    %rbx
ffffffff800005aa:	41 5c                	pop    %r12
ffffffff800005ac:	5d                   	pop    %rbp
ffffffff800005ad:	c3                   	ret
ffffffff800005ae:	66 90                	xchg   %ax,%ax
ffffffff800005b0:	c3                   	ret
ffffffff800005b1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff800005b8:	00 00 00 00 
ffffffff800005bc:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff800005c0 <pmm_max_usable_addr.part.0>:

uint64_t pmm_max_usable_addr(void) {
	uint64_t max = 0;
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800005c0:	48 8b 05 e1 3a 00 00 	mov    0x3ae1(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800005c7:	48 8b 70 08          	mov    0x8(%rax),%rsi
ffffffff800005cb:	48 85 f6             	test   %rsi,%rsi
ffffffff800005ce:	74 3d                	je     ffffffff8000060d <pmm_max_usable_addr.part.0+0x4d>
	uint64_t max = 0;
ffffffff800005d0:	31 f6                	xor    %esi,%esi
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800005d2:	31 c0                	xor    %eax,%eax
ffffffff800005d4:	0f 1f 40 00          	nopl   0x0(%rax)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff800005d8:	48 8b 15 c9 3a 00 00 	mov    0x3ac9(%rip),%rdx        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800005df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800005e3:	48 8b 0c c2          	mov    (%rdx,%rax,8),%rcx
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff800005e7:	48 83 79 10 00       	cmpq   $0x0,0x10(%rcx)
ffffffff800005ec:	75 0e                	jne    ffffffff800005fc <pmm_max_usable_addr.part.0+0x3c>
                        if(max<mm->base+mm->length) max=mm->base+mm->length;
ffffffff800005ee:	48 8b 51 08          	mov    0x8(%rcx),%rdx
ffffffff800005f2:	48 03 11             	add    (%rcx),%rdx
ffffffff800005f5:	48 39 d6             	cmp    %rdx,%rsi
ffffffff800005f8:	48 0f 42 f2          	cmovb  %rdx,%rsi
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800005fc:	48 8b 15 a5 3a 00 00 	mov    0x3aa5(%rip),%rdx        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000603:	48 83 c0 01          	add    $0x1,%rax
ffffffff80000607:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff8000060b:	72 cb                	jb     ffffffff800005d8 <pmm_max_usable_addr.part.0+0x18>
                }
        }
	return max;
}
ffffffff8000060d:	48 89 f0             	mov    %rsi,%rax
ffffffff80000610:	c3                   	ret
ffffffff80000611:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff80000618:	00 00 00 00 
ffffffff8000061c:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff80000620 <pmm_get_bitmap_pbase.part.0>:
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
}

uint64_t pmm_get_bitmap_pbase(void){
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000620:	48 8b 05 81 3a 00 00 	mov    0x3a81(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000627:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff8000062b:	48 85 c0             	test   %rax,%rax
ffffffff8000062e:	74 3f                	je     ffffffff8000066f <pmm_get_bitmap_pbase.part.0+0x4f>
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
                        if (mm->type != LIMINE_MEMMAP_USABLE) continue;
			if ((uint64_t)bitmap_size < mm->length) {
ffffffff80000630:	48 8b 0d f9 59 00 00 	mov    0x59f9(%rip),%rcx        # ffffffff80006030 <bitmap_size>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000637:	31 c0                	xor    %eax,%eax
ffffffff80000639:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff80000640:	48 8b 15 61 3a 00 00 	mov    0x3a61(%rip),%rdx        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000647:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff8000064b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
                        if (mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff8000064f:	48 83 7a 10 00       	cmpq   $0x0,0x10(%rdx)
ffffffff80000654:	75 06                	jne    ffffffff8000065c <pmm_get_bitmap_pbase.part.0+0x3c>
			if ((uint64_t)bitmap_size < mm->length) {
ffffffff80000656:	48 3b 4a 08          	cmp    0x8(%rdx),%rcx
ffffffff8000065a:	72 14                	jb     ffffffff80000670 <pmm_get_bitmap_pbase.part.0+0x50>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff8000065c:	48 8b 15 45 3a 00 00 	mov    0x3a45(%rip),%rdx        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000663:	48 83 c0 01          	add    $0x1,%rax
ffffffff80000667:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff8000066b:	72 d3                	jb     ffffffff80000640 <pmm_get_bitmap_pbase.part.0+0x20>
				return mm->base;
			}
                }
        }
	return 0;
ffffffff8000066d:	31 c0                	xor    %eax,%eax
}
ffffffff8000066f:	c3                   	ret
				return mm->base;
ffffffff80000670:	48 8b 02             	mov    (%rdx),%rax
ffffffff80000673:	c3                   	ret
ffffffff80000674:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff8000067b:	00 00 00 00 
ffffffff8000067f:	90                   	nop

ffffffff80000680 <pmm_zero_usable_pages.part.0>:

void pmm_zero_usable_pages(void) {
	if(memmap_request.response != NULL) {
		for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000680:	48 8b 05 21 3a 00 00 	mov    0x3a21(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000687:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
ffffffff8000068c:	0f 84 8e 00 00 00    	je     ffffffff80000720 <pmm_zero_usable_pages.part.0+0xa0>
ffffffff80000692:	31 ff                	xor    %edi,%edi
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000694:	41 b8 01 00 00 00    	mov    $0x1,%r8d
ffffffff8000069a:	eb 15                	jmp    ffffffff800006b1 <pmm_zero_usable_pages.part.0+0x31>
ffffffff8000069c:	0f 1f 40 00          	nopl   0x0(%rax)
		for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800006a0:	48 8b 05 01 3a 00 00 	mov    0x3a01(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800006a7:	48 83 c7 01          	add    $0x1,%rdi
ffffffff800006ab:	48 3b 78 08          	cmp    0x8(%rax),%rdi
ffffffff800006af:	73 6f                	jae    ffffffff80000720 <pmm_zero_usable_pages.part.0+0xa0>
			struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff800006b1:	48 8b 05 f0 39 00 00 	mov    0x39f0(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800006b8:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff800006bc:	48 8b 34 f8          	mov    (%rax,%rdi,8),%rsi
			if (mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff800006c0:	48 83 7e 10 00       	cmpq   $0x0,0x10(%rsi)
ffffffff800006c5:	75 d9                	jne    ffffffff800006a0 <pmm_zero_usable_pages.part.0+0x20>
			
			// Setting all usable memory to 0
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff800006c7:	48 8b 06             	mov    (%rsi),%rax
ffffffff800006ca:	48 8b 56 08          	mov    0x8(%rsi),%rdx
ffffffff800006ce:	48 01 c2             	add    %rax,%rdx
ffffffff800006d1:	48 39 d0             	cmp    %rdx,%rax
ffffffff800006d4:	73 ca                	jae    ffffffff800006a0 <pmm_zero_usable_pages.part.0+0x20>
ffffffff800006d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff800006dd:	00 00 00 
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800006e0:	48 89 c1             	mov    %rax,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800006e3:	45 89 c1             	mov    %r8d,%r9d
        uint64_t byte_idx = frame_idx / 8;
ffffffff800006e6:	48 89 c2             	mov    %rax,%rdx
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff800006e9:	48 05 00 10 00 00    	add    $0x1000,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800006ef:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800006f3:	48 c1 ea 0f          	shr    $0xf,%rdx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800006f7:	48 03 15 42 59 00 00 	add    0x5942(%rip),%rdx        # ffffffff80006040 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff800006fe:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000701:	41 d3 e1             	shl    %cl,%r9d
ffffffff80000704:	44 89 c9             	mov    %r9d,%ecx
ffffffff80000707:	f7 d1                	not    %ecx
ffffffff80000709:	20 0a                	and    %cl,(%rdx)
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff8000070b:	48 8b 56 08          	mov    0x8(%rsi),%rdx
ffffffff8000070f:	48 03 16             	add    (%rsi),%rdx
ffffffff80000712:	48 39 d0             	cmp    %rdx,%rax
ffffffff80000715:	72 c9                	jb     ffffffff800006e0 <pmm_zero_usable_pages.part.0+0x60>
ffffffff80000717:	eb 87                	jmp    ffffffff800006a0 <pmm_zero_usable_pages.part.0+0x20>
ffffffff80000719:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
				pmm_mark_free(p);
			}
		}
		// Setting back bitmap memory to 1
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff80000720:	48 8b 05 11 59 00 00 	mov    0x5911(%rip),%rax        # ffffffff80006038 <bitmap_pbase>
ffffffff80000727:	48 8b 15 02 59 00 00 	mov    0x5902(%rip),%rdx        # ffffffff80006030 <bitmap_size>
ffffffff8000072e:	48 01 c2             	add    %rax,%rdx
ffffffff80000731:	48 39 d0             	cmp    %rdx,%rax
ffffffff80000734:	73 42                	jae    ffffffff80000778 <pmm_zero_usable_pages.part.0+0xf8>
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000736:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff8000073b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000740:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000743:	48 89 c2             	mov    %rax,%rdx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000746:	89 f7                	mov    %esi,%edi
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff80000748:	48 05 00 10 00 00    	add    $0x1000,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff8000074e:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000752:	48 c1 ea 0f          	shr    $0xf,%rdx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000756:	48 03 15 e3 58 00 00 	add    0x58e3(%rip),%rdx        # ffffffff80006040 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff8000075d:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000760:	d3 e7                	shl    %cl,%edi
ffffffff80000762:	40 08 3a             	or     %dil,(%rdx)
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff80000765:	48 8b 15 c4 58 00 00 	mov    0x58c4(%rip),%rdx        # ffffffff80006030 <bitmap_size>
ffffffff8000076c:	48 03 15 c5 58 00 00 	add    0x58c5(%rip),%rdx        # ffffffff80006038 <bitmap_pbase>
ffffffff80000773:	48 39 d0             	cmp    %rdx,%rax
ffffffff80000776:	72 c8                	jb     ffffffff80000740 <pmm_zero_usable_pages.part.0+0xc0>
			pmm_mark_used(p);
		}
	}
}
ffffffff80000778:	c3                   	ret
ffffffff80000779:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000780 <pmm_mark_used>:
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000780:	48 89 f8             	mov    %rdi,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000783:	48 c1 ef 0c          	shr    $0xc,%rdi
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000787:	ba 01 00 00 00       	mov    $0x1,%edx
        uint8_t bit_idx = frame_idx % 8;
ffffffff8000078c:	89 f9                	mov    %edi,%ecx
        uint64_t byte_idx = frame_idx / 8;
ffffffff8000078e:	48 c1 e8 0f          	shr    $0xf,%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000792:	48 03 05 a7 58 00 00 	add    0x58a7(%rip),%rax        # ffffffff80006040 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff80000799:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff8000079c:	d3 e2                	shl    %cl,%edx
ffffffff8000079e:	08 10                	or     %dl,(%rax)
}
ffffffff800007a0:	c3                   	ret
ffffffff800007a1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff800007a8:	00 00 00 00 
ffffffff800007ac:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff800007b0 <pmm_mark_free>:
void pmm_mark_free(uint64_t physical_addr) {
ffffffff800007b0:	48 89 f9             	mov    %rdi,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800007b3:	48 89 f8             	mov    %rdi,%rax
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800007b6:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800007bb:	48 c1 e8 0f          	shr    $0xf,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800007bf:	48 c1 e9 0c          	shr    $0xc,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800007c3:	48 03 05 76 58 00 00 	add    0x5876(%rip),%rax        # ffffffff80006040 <bitmap>
ffffffff800007ca:	d2 c2                	rol    %cl,%dl
ffffffff800007cc:	20 10                	and    %dl,(%rax)
}
ffffffff800007ce:	c3                   	ret
ffffffff800007cf:	90                   	nop

ffffffff800007d0 <pmm_dump_usable_memmap>:
	if(memmap_request.response != NULL) {
ffffffff800007d0:	48 8b 05 d1 38 00 00 	mov    0x38d1(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800007d7:	48 85 c0             	test   %rax,%rax
ffffffff800007da:	74 0c                	je     ffffffff800007e8 <pmm_dump_usable_memmap+0x18>
ffffffff800007dc:	e9 3f fd ff ff       	jmp    ffffffff80000520 <pmm_dump_usable_memmap.part.0>
ffffffff800007e1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff800007e8:	c3                   	ret
ffffffff800007e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff800007f0 <pmm_max_usable_addr>:
	if(memmap_request.response != NULL) {
ffffffff800007f0:	48 8b 05 b1 38 00 00 	mov    0x38b1(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff800007f7:	48 85 c0             	test   %rax,%rax
ffffffff800007fa:	74 0c                	je     ffffffff80000808 <pmm_max_usable_addr+0x18>
ffffffff800007fc:	e9 bf fd ff ff       	jmp    ffffffff800005c0 <pmm_max_usable_addr.part.0>
ffffffff80000801:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff80000808:	31 c0                	xor    %eax,%eax
ffffffff8000080a:	c3                   	ret
ffffffff8000080b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000810 <pmm_get_bitmap_size>:
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
ffffffff80000810:	48 8b 05 11 58 00 00 	mov    0x5811(%rip),%rax        # ffffffff80006028 <highest_usable_addr>
ffffffff80000817:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff8000081d:	48 c1 e8 0c          	shr    $0xc,%rax
ffffffff80000821:	48 83 c0 07          	add    $0x7,%rax
ffffffff80000825:	48 c1 e8 03          	shr    $0x3,%rax
}
ffffffff80000829:	c3                   	ret
ffffffff8000082a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

ffffffff80000830 <pmm_get_bitmap_pbase>:
	if(memmap_request.response != NULL) {
ffffffff80000830:	48 8b 05 71 38 00 00 	mov    0x3871(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000837:	48 85 c0             	test   %rax,%rax
ffffffff8000083a:	74 0c                	je     ffffffff80000848 <pmm_get_bitmap_pbase+0x18>
ffffffff8000083c:	e9 df fd ff ff       	jmp    ffffffff80000620 <pmm_get_bitmap_pbase.part.0>
ffffffff80000841:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff80000848:	31 c0                	xor    %eax,%eax
ffffffff8000084a:	c3                   	ret
ffffffff8000084b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000850 <pmm_zero_usable_pages>:
	if(memmap_request.response != NULL) {
ffffffff80000850:	48 8b 05 51 38 00 00 	mov    0x3851(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000857:	48 85 c0             	test   %rax,%rax
ffffffff8000085a:	74 0c                	je     ffffffff80000868 <pmm_zero_usable_pages+0x18>
ffffffff8000085c:	e9 1f fe ff ff       	jmp    ffffffff80000680 <pmm_zero_usable_pages.part.0>
ffffffff80000861:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff80000868:	c3                   	ret
ffffffff80000869:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000870 <pmm_alloc_page>:

uint64_t pmm_alloc_page(void) {
	uint64_t* bitmap_64 = (uint64_t*)bitmap;
	size_t bitmap64_size = bitmap_size / 8;
ffffffff80000870:	4c 8b 05 b9 57 00 00 	mov    0x57b9(%rip),%r8        # ffffffff80006030 <bitmap_size>
	
	// Start scanning from where we last found a free page
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff80000877:	48 8b 15 ca 57 00 00 	mov    0x57ca(%rip),%rdx        # ffffffff80006048 <last_scanned_i>
	uint64_t* bitmap_64 = (uint64_t*)bitmap;
ffffffff8000087e:	48 8b 3d bb 57 00 00 	mov    0x57bb(%rip),%rdi        # ffffffff80006040 <bitmap>
	size_t bitmap64_size = bitmap_size / 8;
ffffffff80000885:	4c 89 c1             	mov    %r8,%rcx
ffffffff80000888:	48 c1 e9 03          	shr    $0x3,%rcx
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff8000088c:	48 39 ca             	cmp    %rcx,%rdx
ffffffff8000088f:	73 58                	jae    ffffffff800008e9 <pmm_alloc_page+0x79>
ffffffff80000891:	48 89 d6             	mov    %rdx,%rsi
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff80000894:	48 8b 04 f7          	mov    (%rdi,%rsi,8),%rax
ffffffff80000898:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff8000089c:	74 42                	je     ffffffff800008e0 <pmm_alloc_page+0x70>

		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff8000089e:	48 f7 d0             	not    %rax

		size_t page_idx = i * 64 + index;
ffffffff800008a1:	48 89 f2             	mov    %rsi,%rdx
		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff800008a4:	f3 48 0f bc c0       	tzcnt  %rax,%rax
		size_t page_idx = i * 64 + index;
ffffffff800008a9:	48 c1 e2 06          	shl    $0x6,%rdx
		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff800008ad:	48 98                	cltq
	for (size_t i = 0; i < last_scanned_i; i++) {
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;

                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;

                size_t page_idx = i * 64 + index;
ffffffff800008af:	48 01 d0             	add    %rdx,%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff800008b2:	ba 01 00 00 00       	mov    $0x1,%edx
                uint64_t paddr = page_idx * PAGE_SIZE;
ffffffff800008b7:	48 c1 e0 0c          	shl    $0xc,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800008bb:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800008be:	49 89 c0             	mov    %rax,%r8
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800008c1:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800008c5:	49 c1 e8 0f          	shr    $0xf,%r8
        uint8_t bit_idx = frame_idx % 8;
ffffffff800008c9:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff800008cc:	d3 e2                	shl    %cl,%edx
ffffffff800008ce:	42 08 14 07          	or     %dl,(%rdi,%r8,1)
        
                pmm_mark_used(paddr);
		last_scanned_i = i;
ffffffff800008d2:	48 89 35 6f 57 00 00 	mov    %rsi,0x576f(%rip)        # ffffffff80006048 <last_scanned_i>
                return paddr;
ffffffff800008d9:	c3                   	ret
ffffffff800008da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff800008e0:	48 83 c6 01          	add    $0x1,%rsi
ffffffff800008e4:	48 39 f1             	cmp    %rsi,%rcx
ffffffff800008e7:	75 ab                	jne    ffffffff80000894 <pmm_alloc_page+0x24>
	for (size_t i = 0; i < last_scanned_i; i++) {
ffffffff800008e9:	31 f6                	xor    %esi,%esi
ffffffff800008eb:	48 85 d2             	test   %rdx,%rdx
ffffffff800008ee:	74 29                	je     ffffffff80000919 <pmm_alloc_page+0xa9>
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff800008f0:	48 8b 04 f7          	mov    (%rdi,%rsi,8),%rax
ffffffff800008f4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff800008f8:	74 16                	je     ffffffff80000910 <pmm_alloc_page+0xa0>
                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff800008fa:	48 f7 d0             	not    %rax
ffffffff800008fd:	31 d2                	xor    %edx,%edx
ffffffff800008ff:	f3 48 0f bc d0       	tzcnt  %rax,%rdx
                size_t page_idx = i * 64 + index;
ffffffff80000904:	48 89 f0             	mov    %rsi,%rax
ffffffff80000907:	48 c1 e0 06          	shl    $0x6,%rax
                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff8000090b:	48 63 d2             	movslq %edx,%rdx
ffffffff8000090e:	eb 9f                	jmp    ffffffff800008af <pmm_alloc_page+0x3f>
	for (size_t i = 0; i < last_scanned_i; i++) {
ffffffff80000910:	48 83 c6 01          	add    $0x1,%rsi
ffffffff80000914:	48 39 f2             	cmp    %rsi,%rdx
ffffffff80000917:	75 d7                	jne    ffffffff800008f0 <pmm_alloc_page+0x80>
	}

	// We only check the remainder bytes if the main RAM is completely full
	for (size_t i = bitmap_size & ~0x7ULL; i < bitmap_size; i++) {
ffffffff80000919:	4c 89 c2             	mov    %r8,%rdx
ffffffff8000091c:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
ffffffff80000920:	4c 39 c2             	cmp    %r8,%rdx
ffffffff80000923:	73 47                	jae    ffffffff8000096c <pmm_alloc_page+0xfc>
		uint64_t byte = (uint64_t)bitmap[i] | ~((1ULL << 8) - 1ULL);
ffffffff80000925:	0f b6 04 17          	movzbl (%rdi,%rdx,1),%eax
ffffffff80000929:	48 0d 00 ff ff ff    	or     $0xffffffffffffff00,%rax

		if(byte == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff8000092f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff80000933:	74 2e                	je     ffffffff80000963 <pmm_alloc_page+0xf3>
		size_t index = __builtin_ffsll(~(byte)) - 1;
ffffffff80000935:	48 f7 d0             	not    %rax
ffffffff80000938:	f3 48 0f bc c0       	tzcnt  %rax,%rax
ffffffff8000093d:	48 98                	cltq

		size_t page_idx = i * 8 + index;
ffffffff8000093f:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000943:	ba 01 00 00 00       	mov    $0x1,%edx
		uint64_t paddr = page_idx * PAGE_SIZE;
ffffffff80000948:	48 c1 e0 0c          	shl    $0xc,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff8000094c:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff8000094f:	48 89 c6             	mov    %rax,%rsi
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000952:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000956:	48 c1 ee 0f          	shr    $0xf,%rsi
        uint8_t bit_idx = frame_idx % 8;
ffffffff8000095a:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff8000095d:	d3 e2                	shl    %cl,%edx
ffffffff8000095f:	08 14 37             	or     %dl,(%rdi,%rsi,1)
}
ffffffff80000962:	c3                   	ret
	for (size_t i = bitmap_size & ~0x7ULL; i < bitmap_size; i++) {
ffffffff80000963:	48 83 c2 01          	add    $0x1,%rdx
ffffffff80000967:	49 39 d0             	cmp    %rdx,%r8
ffffffff8000096a:	75 b9                	jne    ffffffff80000925 <pmm_alloc_page+0xb5>
		pmm_mark_used(paddr);
		return paddr;
	}
	
	// Run out of memory
	return 0;
ffffffff8000096c:	31 c0                	xor    %eax,%eax
}
ffffffff8000096e:	c3                   	ret
ffffffff8000096f:	90                   	nop

ffffffff80000970 <pmm_free_page>:
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000970:	48 89 f8             	mov    %rdi,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000973:	48 89 f9             	mov    %rdi,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000976:	ba fe ff ff ff       	mov    $0xfffffffe,%edx

void pmm_free_page(uint64_t paddr) {
	pmm_mark_free(paddr);
	size_t freed_chunk_idx = (paddr / PAGE_SIZE) / 64;
ffffffff8000097b:	48 c1 ef 12          	shr    $0x12,%rdi
        uint64_t byte_idx = frame_idx / 8;
ffffffff8000097f:	48 c1 e8 0f          	shr    $0xf,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000983:	48 c1 e9 0c          	shr    $0xc,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000987:	48 03 05 b2 56 00 00 	add    0x56b2(%rip),%rax        # ffffffff80006040 <bitmap>
ffffffff8000098e:	d2 c2                	rol    %cl,%dl
ffffffff80000990:	20 10                	and    %dl,(%rax)
	
	if (freed_chunk_idx < last_scanned_i) {
ffffffff80000992:	48 3b 3d af 56 00 00 	cmp    0x56af(%rip),%rdi        # ffffffff80006048 <last_scanned_i>
ffffffff80000999:	73 07                	jae    ffffffff800009a2 <pmm_free_page+0x32>
		last_scanned_i = freed_chunk_idx;
ffffffff8000099b:	48 89 3d a6 56 00 00 	mov    %rdi,0x56a6(%rip)        # ffffffff80006048 <last_scanned_i>
	}
}
ffffffff800009a2:	c3                   	ret
ffffffff800009a3:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff800009aa:	00 00 00 00 
ffffffff800009ae:	66 90                	xchg   %ax,%ax

ffffffff800009b0 <pmm_init>:

void pmm_init(void){
ffffffff800009b0:	55                   	push   %rbp
	if(memmap_request.response != NULL) {
ffffffff800009b1:	48 8b 05 f0 36 00 00 	mov    0x36f0(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
void pmm_init(void){
ffffffff800009b8:	48 89 e5             	mov    %rsp,%rbp
	if(memmap_request.response != NULL) {
ffffffff800009bb:	48 85 c0             	test   %rax,%rax
ffffffff800009be:	0f 84 bc 00 00 00    	je     ffffffff80000a80 <pmm_init+0xd0>
ffffffff800009c4:	e8 f7 fb ff ff       	call   ffffffff800005c0 <pmm_max_usable_addr.part.0>
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
ffffffff800009c9:	48 8d b0 ff 0f 00 00 	lea    0xfff(%rax),%rsi
ffffffff800009d0:	48 c1 ee 0c          	shr    $0xc,%rsi
ffffffff800009d4:	48 83 c6 07          	add    $0x7,%rsi
ffffffff800009d8:	48 c1 ee 03          	shr    $0x3,%rsi
	//Initiallize global variables
	highest_usable_addr = pmm_max_usable_addr();
ffffffff800009dc:	48 89 05 45 56 00 00 	mov    %rax,0x5645(%rip)        # ffffffff80006028 <highest_usable_addr>
	if(memmap_request.response != NULL) {
ffffffff800009e3:	48 8b 05 be 36 00 00 	mov    0x36be(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
	return 0;
ffffffff800009ea:	31 ff                	xor    %edi,%edi
	bitmap_size = pmm_get_bitmap_size();
ffffffff800009ec:	48 89 35 3d 56 00 00 	mov    %rsi,0x563d(%rip)        # ffffffff80006030 <bitmap_size>
	if(memmap_request.response != NULL) {
ffffffff800009f3:	48 85 c0             	test   %rax,%rax
ffffffff800009f6:	74 08                	je     ffffffff80000a00 <pmm_init+0x50>
ffffffff800009f8:	e8 23 fc ff ff       	call   ffffffff80000620 <pmm_get_bitmap_pbase.part.0>
ffffffff800009fd:	48 89 c7             	mov    %rax,%rdi
	bitmap_pbase = pmm_get_bitmap_pbase();
	bitmap = (uint8_t*)(bitmap_pbase + hhdm_request.response->offset);	// Offset to virtual base
ffffffff80000a00:	48 8b 05 61 36 00 00 	mov    0x3661(%rip),%rax        # ffffffff80004068 <hhdm_request+0x28>
	bitmap_pbase = pmm_get_bitmap_pbase();
ffffffff80000a07:	48 89 3d 2a 56 00 00 	mov    %rdi,0x562a(%rip)        # ffffffff80006038 <bitmap_pbase>
	
	// Setting all pages in bitmap to be used (for now)
	memset(bitmap, 0xFF, bitmap_size);
ffffffff80000a0e:	48 89 f2             	mov    %rsi,%rdx
ffffffff80000a11:	be ff 00 00 00       	mov    $0xff,%esi
	bitmap = (uint8_t*)(bitmap_pbase + hhdm_request.response->offset);	// Offset to virtual base
ffffffff80000a16:	48 03 78 08          	add    0x8(%rax),%rdi
ffffffff80000a1a:	48 89 3d 1f 56 00 00 	mov    %rdi,0x561f(%rip)        # ffffffff80006040 <bitmap>
	memset(bitmap, 0xFF, bitmap_size);
ffffffff80000a21:	e8 ea 00 00 00       	call   ffffffff80000b10 <memset>
	if(memmap_request.response != NULL) {
ffffffff80000a26:	48 8b 05 7b 36 00 00 	mov    0x367b(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000a2d:	48 85 c0             	test   %rax,%rax
ffffffff80000a30:	74 05                	je     ffffffff80000a37 <pmm_init+0x87>
ffffffff80000a32:	e8 49 fc ff ff       	call   ffffffff80000680 <pmm_zero_usable_pages.part.0>
	if(memmap_request.response != NULL) {
ffffffff80000a37:	48 8b 05 6a 36 00 00 	mov    0x366a(%rip),%rax        # ffffffff800040a8 <memmap_request+0x28>
ffffffff80000a3e:	48 85 c0             	test   %rax,%rax
ffffffff80000a41:	74 05                	je     ffffffff80000a48 <pmm_init+0x98>
ffffffff80000a43:	e8 d8 fa ff ff       	call   ffffffff80000520 <pmm_dump_usable_memmap.part.0>
	// Zero all usable pages (bitmap memory address will be 1 (used))
	pmm_zero_usable_pages();

	
	pmm_dump_usable_memmap();
        print_str("\n\nMax Usable Addr: ");
ffffffff80000a48:	48 c7 c7 8a 10 00 80 	mov    $0xffffffff8000108a,%rdi
ffffffff80000a4f:	e8 3c 00 00 00       	call   ffffffff80000a90 <print_str>
        print_hex(highest_usable_addr);
ffffffff80000a54:	48 8b 3d cd 55 00 00 	mov    0x55cd(%rip),%rdi        # ffffffff80006028 <highest_usable_addr>
ffffffff80000a5b:	e8 50 00 00 00       	call   ffffffff80000ab0 <print_hex>
        print_str("\n\nbitmap_vbase: ");
ffffffff80000a60:	48 c7 c7 9e 10 00 80 	mov    $0xffffffff8000109e,%rdi
ffffffff80000a67:	e8 24 00 00 00       	call   ffffffff80000a90 <print_str>
        print_hex((uint64_t)bitmap);
ffffffff80000a6c:	48 8b 3d cd 55 00 00 	mov    0x55cd(%rip),%rdi        # ffffffff80006040 <bitmap>

}
ffffffff80000a73:	5d                   	pop    %rbp
        print_hex((uint64_t)bitmap);
ffffffff80000a74:	e9 37 00 00 00       	jmp    ffffffff80000ab0 <print_hex>
ffffffff80000a79:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
ffffffff80000a80:	31 f6                	xor    %esi,%esi
	uint64_t max = 0;
ffffffff80000a82:	31 c0                	xor    %eax,%eax
ffffffff80000a84:	e9 53 ff ff ff       	jmp    ffffffff800009dc <pmm_init+0x2c>
ffffffff80000a89:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000a90 <print_str>:
#include "kprint.h"
#include "io.h"

// Sending a str to an I/O port
void print_str(const char *str){
        for(int i=0; str[i] != '\0'; i++){
ffffffff80000a90:	0f b6 07             	movzbl (%rdi),%eax
ffffffff80000a93:	84 c0                	test   %al,%al
ffffffff80000a95:	74 15                	je     ffffffff80000aac <print_str+0x1c>
ffffffff80000a97:	48 83 c7 01          	add    $0x1,%rdi
ffffffff80000a9b:	ba f8 03 00 00       	mov    $0x3f8,%edx
ffffffff80000aa0:	ee                   	out    %al,(%dx)
ffffffff80000aa1:	0f b6 07             	movzbl (%rdi),%eax
ffffffff80000aa4:	48 83 c7 01          	add    $0x1,%rdi
ffffffff80000aa8:	84 c0                	test   %al,%al
ffffffff80000aaa:	75 f4                	jne    ffffffff80000aa0 <print_str+0x10>
                outb(0x3F8, str[i]);
        }
}
ffffffff80000aac:	c3                   	ret
ffffffff80000aad:	0f 1f 00             	nopl   (%rax)

ffffffff80000ab0 <print_hex>:

// Convert 64 bit number to hex string and prints it
void print_hex(uint64_t value){
ffffffff80000ab0:	55                   	push   %rbp
        const char *hex_chars = "0123456789abcdef";
        char buffer[19];

        buffer[0]='0';
ffffffff80000ab1:	b8 30 78 00 00       	mov    $0x7830,%eax
void print_hex(uint64_t value){
ffffffff80000ab6:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000ab9:	48 83 ec 20          	sub    $0x20,%rsp
        buffer[1]='x';
        buffer[18]='\0';
ffffffff80000abd:	c6 45 fe 00          	movb   $0x0,-0x2(%rbp)
ffffffff80000ac1:	48 8d 4d ed          	lea    -0x13(%rbp),%rcx
        buffer[0]='0';
ffffffff80000ac5:	66 89 45 ec          	mov    %ax,-0x14(%rbp)

        for (int i=17;i>=2;i--){
ffffffff80000ac9:	48 8d 45 fd          	lea    -0x3(%rbp),%rax
ffffffff80000acd:	0f 1f 00             	nopl   (%rax)
                buffer[i] = hex_chars[value & 0xF];
ffffffff80000ad0:	48 89 fa             	mov    %rdi,%rdx
        for (int i=17;i>=2;i--){
ffffffff80000ad3:	48 83 e8 01          	sub    $0x1,%rax
                value >>= 4;
ffffffff80000ad7:	48 c1 ef 04          	shr    $0x4,%rdi
                buffer[i] = hex_chars[value & 0xF];
ffffffff80000adb:	83 e2 0f             	and    $0xf,%edx
ffffffff80000ade:	0f b6 92 af 10 00 80 	movzbl -0x7fffef51(%rdx),%edx
ffffffff80000ae5:	88 50 01             	mov    %dl,0x1(%rax)
        for (int i=17;i>=2;i--){
ffffffff80000ae8:	48 39 c1             	cmp    %rax,%rcx
ffffffff80000aeb:	75 e3                	jne    ffffffff80000ad0 <print_hex+0x20>
        for(int i=0; str[i] != '\0'; i++){
ffffffff80000aed:	b8 30 00 00 00       	mov    $0x30,%eax
ffffffff80000af2:	ba f8 03 00 00       	mov    $0x3f8,%edx
ffffffff80000af7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff80000afe:	00 00 
ffffffff80000b00:	ee                   	out    %al,(%dx)
ffffffff80000b01:	0f b6 01             	movzbl (%rcx),%eax
ffffffff80000b04:	48 83 c1 01          	add    $0x1,%rcx
ffffffff80000b08:	84 c0                	test   %al,%al
ffffffff80000b0a:	75 f4                	jne    ffffffff80000b00 <print_hex+0x50>
        }

        print_str(buffer);
}
ffffffff80000b0c:	c9                   	leave
ffffffff80000b0d:	c3                   	ret
ffffffff80000b0e:	66 90                	xchg   %ax,%ax

ffffffff80000b10 <memset>:
#include "string.h"

void* memset(void* dst, int value, size_t num) {
ffffffff80000b10:	48 89 f8             	mov    %rdi,%rax
ffffffff80000b13:	48 89 f9             	mov    %rdi,%rcx
ffffffff80000b16:	48 8d 3c 3a          	lea    (%rdx,%rdi,1),%rdi
	volatile uint8_t* ptr = (uint8_t*)dst;
        for (size_t i = 0; i < num; i++) ptr[i] = (uint8_t)value;
ffffffff80000b1a:	41 89 f0             	mov    %esi,%r8d
ffffffff80000b1d:	48 85 d2             	test   %rdx,%rdx
ffffffff80000b20:	74 2e                	je     ffffffff80000b50 <memset+0x40>
ffffffff80000b22:	48 89 fa             	mov    %rdi,%rdx
ffffffff80000b25:	48 29 c2             	sub    %rax,%rdx
ffffffff80000b28:	83 e2 01             	and    $0x1,%edx
ffffffff80000b2b:	74 13                	je     ffffffff80000b40 <memset+0x30>
ffffffff80000b2d:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffffffff80000b31:	40 88 30             	mov    %sil,(%rax)
ffffffff80000b34:	48 39 f9             	cmp    %rdi,%rcx
ffffffff80000b37:	74 18                	je     ffffffff80000b51 <memset+0x41>
ffffffff80000b39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
ffffffff80000b40:	44 88 01             	mov    %r8b,(%rcx)
ffffffff80000b43:	48 83 c1 02          	add    $0x2,%rcx
ffffffff80000b47:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
ffffffff80000b4b:	48 39 f9             	cmp    %rdi,%rcx
ffffffff80000b4e:	75 f0                	jne    ffffffff80000b40 <memset+0x30>
        return dst;
}
ffffffff80000b50:	c3                   	ret
ffffffff80000b51:	c3                   	ret
