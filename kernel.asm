
kernel.elf:     file format elf64-x86-64


Disassembly of section .text:

ffffffff80000000 <draw_pixel>:
	}
}

// Raw pixel drawing function
void draw_pixel(uint32_t x, uint32_t y, uint32_t color) {
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000000:	48 8b 05 e1 34 00 00 	mov    0x34e1(%rip),%rax        # ffffffff800034e8 <framebuffer_request+0x28>
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
ffffffff800000a1:	48 8b 15 40 34 00 00 	mov    0x3440(%rip),%rdx        # ffffffff800034e8 <framebuffer_request+0x28>
ffffffff800000a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800000ac:	4c 8b 02             	mov    (%rdx),%r8
				draw_pixel(cursor_x + x, cursor_y + y, color);
ffffffff800000af:	8b 15 4b 3f 00 00    	mov    0x3f4b(%rip),%edx        # ffffffff80004000 <cursor_y>
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff800000b5:	49 8b 48 18          	mov    0x18(%r8),%rcx
				draw_pixel(cursor_x + x, cursor_y + y, color);
ffffffff800000b9:	44 01 ca             	add    %r9d,%edx
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff800000bc:	48 c1 e9 02          	shr    $0x2,%rcx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff800000c0:	0f af d1             	imul   %ecx,%edx
ffffffff800000c3:	03 15 3b 3f 00 00    	add    0x3f3b(%rip),%edx        # ffffffff80004004 <cursor_x>
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
ffffffff800000e4:	48 8b 15 fd 33 00 00 	mov    0x33fd(%rip),%rdx        # ffffffff800034e8 <framebuffer_request+0x28>
	cursor_x += 8;
ffffffff800000eb:	8b 05 13 3f 00 00    	mov    0x3f13(%rip),%eax        # ffffffff80004004 <cursor_x>
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
ffffffff800000f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
	cursor_x += 8;
ffffffff800000f5:	83 c0 08             	add    $0x8,%eax
ffffffff800000f8:	89 05 06 3f 00 00    	mov    %eax,0x3f06(%rip)        # ffffffff80004004 <cursor_x>
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
ffffffff800000fe:	48 8b 12             	mov    (%rdx),%rdx
ffffffff80000101:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff80000105:	72 11                	jb     ffffffff80000118 <draw_char+0xe8>
		cursor_x = 0;
		cursor_y += 16;
ffffffff80000107:	83 05 f2 3e 00 00 10 	addl   $0x10,0x3ef2(%rip)        # ffffffff80004000 <cursor_y>
		cursor_x = 0;
ffffffff8000010e:	c7 05 ec 3e 00 00 00 	movl   $0x0,0x3eec(%rip)        # ffffffff80004004 <cursor_x>
ffffffff80000115:	00 00 00 
	}
}
ffffffff80000118:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffffffff8000011c:	c9                   	leave
ffffffff8000011d:	c3                   	ret
		cursor_y += 16;
ffffffff8000011e:	83 05 db 3e 00 00 10 	addl   $0x10,0x3edb(%rip)        # ffffffff80004000 <cursor_y>
		cursor_x = 0;
ffffffff80000125:	c7 05 d5 3e 00 00 00 	movl   $0x0,0x3ed5(%rip)        # ffffffff80004004 <cursor_x>
ffffffff8000012c:	00 00 00 
		return;
ffffffff8000012f:	c3                   	ret
		if(cursor_x >= 8) cursor_x -= 8;
ffffffff80000130:	8b 35 ce 3e 00 00    	mov    0x3ece(%rip),%esi        # ffffffff80004004 <cursor_x>
		cursor_y += 16;
ffffffff80000136:	8b 05 c4 3e 00 00    	mov    0x3ec4(%rip),%eax        # ffffffff80004000 <cursor_y>
		if(cursor_x >= 8) cursor_x -= 8;
ffffffff8000013c:	83 fe 07             	cmp    $0x7,%esi
ffffffff8000013f:	0f 86 94 00 00 00    	jbe    ffffffff800001d9 <draw_char+0x1a9>
ffffffff80000145:	83 ee 08             	sub    $0x8,%esi
ffffffff80000148:	89 35 b6 3e 00 00    	mov    %esi,0x3eb6(%rip)        # ffffffff80004004 <cursor_x>
			for (int x=0; x<8; x++) {
ffffffff8000014e:	31 ff                	xor    %edi,%edi
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
ffffffff80000150:	48 8b 15 91 33 00 00 	mov    0x3391(%rip),%rdx        # ffffffff800034e8 <framebuffer_request+0x28>
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
ffffffff80000180:	48 8b 05 61 33 00 00 	mov    0x3361(%rip),%rax        # ffffffff800034e8 <framebuffer_request+0x28>
ffffffff80000187:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000018b:	48 8b 30             	mov    (%rax),%rsi
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff8000018e:	8b 05 6c 3e 00 00    	mov    0x3e6c(%rip),%eax        # ffffffff80004000 <cursor_y>
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff80000194:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
ffffffff80000198:	01 f8                	add    %edi,%eax
	uint32_t pixels_per_row = fb->pitch / 4;
ffffffff8000019a:	48 c1 e9 02          	shr    $0x2,%rcx
	pixels[(y*pixels_per_row) + x] = color;
ffffffff8000019e:	0f af c1             	imul   %ecx,%eax
ffffffff800001a1:	03 05 5d 3e 00 00    	add    0x3e5d(%rip),%eax        # ffffffff80004004 <cursor_x>
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
ffffffff800001c8:	8b 05 32 3e 00 00    	mov    0x3e32(%rip),%eax        # ffffffff80004000 <cursor_y>
ffffffff800001ce:	8b 35 30 3e 00 00    	mov    0x3e30(%rip),%esi        # ffffffff80004004 <cursor_x>
ffffffff800001d4:	e9 77 ff ff ff       	jmp    ffffffff80000150 <draw_char+0x120>
		else if (cursor_y >= 16) {	// wrap backward to the end of the previous line
ffffffff800001d9:	83 f8 0f             	cmp    $0xf,%eax
ffffffff800001dc:	0f 86 6c ff ff ff    	jbe    ffffffff8000014e <draw_char+0x11e>
			uint32_t screen_width = framebuffer_request.response->framebuffers[0]->width;
ffffffff800001e2:	48 8b 15 ff 32 00 00 	mov    0x32ff(%rip),%rdx        # ffffffff800034e8 <framebuffer_request+0x28>
			cursor_y -= 16;
ffffffff800001e9:	83 e8 10             	sub    $0x10,%eax
ffffffff800001ec:	89 05 0e 3e 00 00    	mov    %eax,0x3e0e(%rip)        # ffffffff80004000 <cursor_y>
			uint32_t screen_width = framebuffer_request.response->framebuffers[0]->width;
ffffffff800001f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800001f6:	48 8b 12             	mov    (%rdx),%rdx
ffffffff800001f9:	48 8b 72 08          	mov    0x8(%rdx),%rsi
			cursor_x = screen_width -8;
ffffffff800001fd:	83 ee 08             	sub    $0x8,%esi
ffffffff80000200:	89 35 fe 3d 00 00    	mov    %esi,0x3dfe(%rip)        # ffffffff80004004 <cursor_x>
		for (int y=0; y < 16; y++) {
ffffffff80000206:	e9 43 ff ff ff       	jmp    ffffffff8000014e <draw_char+0x11e>
ffffffff8000020b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000210 <kernel_main>:

// The Main Kernel Entry Point
void kernel_main(void){
	if(LIMINE_BASE_REVISION_SUPPORTED(base_revision) == false){
ffffffff80000210:	48 8b 05 e9 32 00 00 	mov    0x32e9(%rip),%rax        # ffffffff80003500 <base_revision+0x10>
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

	idt_init();
ffffffff80000227:	e8 a4 01 00 00       	call   ffffffff800003d0 <idt_init>

	print_str("Hello from the 64-bit Higher Half!\n");
ffffffff8000022c:	48 c7 c7 00 10 00 80 	mov    $0xffffffff80001000,%rdi
ffffffff80000233:	e8 28 0a 00 00       	call   ffffffff80000c60 <print_str>

	pic_remap(32,40);
ffffffff80000238:	be 28 00 00 00       	mov    $0x28,%esi
ffffffff8000023d:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff80000242:	e8 69 02 00 00       	call   ffffffff800004b0 <pic_remap>
	
	pmm_init();	
ffffffff80000247:	e8 34 09 00 00       	call   ffffffff80000b80 <pmm_init>
ffffffff8000024c:	0f 1f 40 00          	nopl   0x0(%rax)
	

	// __asm__ __volatile__ ("int $0");
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
ffffffff80000290:	80 3d 89 4d 00 00 00 	cmpb   $0x0,0x4d89(%rip)        # ffffffff80005020 <shift_pressed>
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
ffffffff800002b8:	e8 a3 09 00 00       	call   ffffffff80000c60 <print_str>
			}

			draw_char(ascii, 0x00FF00);
ffffffff800002bd:	0f be fb             	movsbl %bl,%edi
ffffffff800002c0:	be 00 ff 00 00       	mov    $0xff00,%esi
ffffffff800002c5:	e8 66 fd ff ff       	call   ffffffff80000030 <draw_char>
ffffffff800002ca:	eb 0c                	jmp    ffffffff800002d8 <keyboard_handler+0x78>
ffffffff800002cc:	0f 1f 40 00          	nopl   0x0(%rax)
	if(scancode == 0x2A || scancode == 0x36) shift_pressed = true;
ffffffff800002d0:	c6 05 49 4d 00 00 01 	movb   $0x1,0x4d49(%rip)        # ffffffff80005020 <shift_pressed>
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
ffffffff80000300:	c6 05 19 4d 00 00 00 	movb   $0x0,0x4d19(%rip)        # ffffffff80005020 <shift_pressed>
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
ffffffff80000330:	e8 2b 09 00 00       	call   ffffffff80000c60 <print_str>
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
ffffffff8000035d:	e8 fe 08 00 00       	call   ffffffff80000c60 <print_str>
	print_str(" RIP (Instruction) ");
ffffffff80000362:	48 c7 c7 44 10 00 80 	mov    $0xffffffff80001044,%rdi
ffffffff80000369:	e8 f2 08 00 00       	call   ffffffff80000c60 <print_str>
	print_hex(frame->rip);
ffffffff8000036e:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
ffffffff80000372:	e8 09 09 00 00       	call   ffffffff80000c80 <print_hex>
	print_str("\n");
ffffffff80000377:	48 c7 c7 6d 10 00 80 	mov    $0xffffffff8000106d,%rdi
ffffffff8000037e:	e8 dd 08 00 00       	call   ffffffff80000c60 <print_str>
	print_str(" RSP (Stack) ");
ffffffff80000383:	48 c7 c7 58 10 00 80 	mov    $0xffffffff80001058,%rdi
ffffffff8000038a:	e8 d1 08 00 00       	call   ffffffff80000c60 <print_str>
	print_hex(frame->rsp);
ffffffff8000038f:	48 8b 7d 20          	mov    0x20(%rbp),%rdi
ffffffff80000393:	e8 e8 08 00 00       	call   ffffffff80000c80 <print_hex>
	print_str("\n");
ffffffff80000398:	48 c7 c7 6d 10 00 80 	mov    $0xffffffff8000106d,%rdi
ffffffff8000039f:	e8 bc 08 00 00       	call   ffffffff80000c60 <print_str>
	print_str(" HALTED\n");
ffffffff800003a4:	48 c7 c7 66 10 00 80 	mov    $0xffffffff80001066,%rdi
ffffffff800003ab:	e8 b0 08 00 00       	call   ffffffff80000c60 <print_str>
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
ffffffff800003dd:	48 c7 05 2a 3c 00 00 	movq   $0xffffffff80004020,0x3c2a(%rip)        # ffffffff80004012 <idtr+0x2>
ffffffff800003e4:	20 40 00 80 
	idtr.limit = (uint16_t)sizeof(idt) - 1;
ffffffff800003e8:	0f b7 35 d1 0d 00 00 	movzwl 0xdd1(%rip),%esi        # ffffffff800011c0 <kbd_US+0x80>
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff800003ef:	48 89 d0             	mov    %rdx,%rax
	idtr.limit = (uint16_t)sizeof(idt) - 1;
ffffffff800003f2:	66 44 89 15 16 3c 00 	mov    %r10w,0x3c16(%rip)        # ffffffff80004010 <idtr>
ffffffff800003f9:	00 
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff800003fa:	48 89 d1             	mov    %rdx,%rcx
ffffffff800003fd:	48 c7 c7 20 42 00 80 	mov    $0xffffffff80004220,%rdi
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff80000404:	48 c1 e8 20          	shr    $0x20,%rax
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000408:	48 c1 e9 10          	shr    $0x10,%rcx
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff8000040c:	41 89 c0             	mov    %eax,%r8d
ffffffff8000040f:	48 c7 c0 20 40 00 80 	mov    $0xffffffff80004020,%rax
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
ffffffff80000451:	c7 05 d7 3d 00 00 28 	movl   $0x8e000028,0x3dd7(%rip)        # ffffffff80004232 <idt+0x212>
ffffffff80000458:	00 00 8e 
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff8000045b:	48 89 c2             	mov    %rax,%rdx
	idt_entry->isr_low = isr_addr & 0xFFFF;
ffffffff8000045e:	66 89 05 cb 3d 00 00 	mov    %ax,0x3dcb(%rip)        # ffffffff80004230 <idt+0x210>
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff80000465:	48 c1 e8 20          	shr    $0x20,%rax
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000469:	48 c1 ea 10          	shr    $0x10,%rdx
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
ffffffff8000046d:	89 05 c5 3d 00 00    	mov    %eax,0x3dc5(%rip)        # ffffffff80004238 <idt+0x218>
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
ffffffff80000473:	66 89 15 bc 3d 00 00 	mov    %dx,0x3dbc(%rip)        # ffffffff80004236 <idt+0x216>
	idt_entry->zero = 0;
ffffffff8000047a:	c7 05 b8 3d 00 00 00 	movl   $0x0,0x3db8(%rip)        # ffffffff8000423c <idt+0x21c>
ffffffff80000481:	00 00 00 
		idt_set_entry(idx, generic_exception_handler, 0x8E);
	}

	idt_set_entry(33, keyboard_handler, 0x8E);

	__asm__ __volatile__ ("lidt %0" : : "m"(idtr));
ffffffff80000484:	0f 01 1d 85 3b 00 00 	lidt   0x3b85(%rip)        # ffffffff80004010 <idtr>
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

ffffffff80000520 <vmm_map_page>:
};

uint64_t hhdm_offset;


void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags){
ffffffff80000520:	55                   	push   %rbp
	// PML4
	uint64_t entry = pml4[GET_PML4_INDEX(virtual_addr)];
ffffffff80000521:	48 89 f0             	mov    %rsi,%rax
ffffffff80000524:	48 c1 e8 24          	shr    $0x24,%rax
ffffffff80000528:	25 f8 0f 00 00       	and    $0xff8,%eax
void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags){
ffffffff8000052d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000530:	41 57                	push   %r15
ffffffff80000532:	49 89 cf             	mov    %rcx,%r15
ffffffff80000535:	41 56                	push   %r14
		entry = (PDPT_paddr  & PTE_PADDR) | PTE_PRESENT;
	}
	pml4[GET_PML4_INDEX(virtual_addr)] = entry | flags;

	// PDPT
	uint64_t* pdpt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff80000537:	49 be 00 f0 ff ff ff 	movabs $0xffffffffff000,%r14
ffffffff8000053e:	ff 0f 00 
void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags){
ffffffff80000541:	41 55                	push   %r13
	uint64_t entry = pml4[GET_PML4_INDEX(virtual_addr)];
ffffffff80000543:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags){
ffffffff80000547:	41 54                	push   %r12
ffffffff80000549:	49 89 d4             	mov    %rdx,%r12
ffffffff8000054c:	53                   	push   %rbx
ffffffff8000054d:	48 89 f3             	mov    %rsi,%rbx
ffffffff80000550:	48 83 ec 08          	sub    $0x8,%rsp
	uint64_t entry = pml4[GET_PML4_INDEX(virtual_addr)];
ffffffff80000554:	49 8b 45 00          	mov    0x0(%r13),%rax
	uint64_t* pdpt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff80000558:	49 21 c6             	and    %rax,%r14
	if (!(entry & PTE_PRESENT)) {
ffffffff8000055b:	a8 01                	test   $0x1,%al
ffffffff8000055d:	0f 84 ad 00 00 00    	je     ffffffff80000610 <vmm_map_page+0xf0>
	pml4[GET_PML4_INDEX(virtual_addr)] = entry | flags;
ffffffff80000563:	4c 09 f8             	or     %r15,%rax
ffffffff80000566:	49 89 45 00          	mov    %rax,0x0(%r13)
	entry = pdpt[GET_PDPT_INDEX(virtual_addr)];
ffffffff8000056a:	48 89 d8             	mov    %rbx,%rax
	uint64_t* pdpt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff8000056d:	4c 03 35 b4 4a 00 00 	add    0x4ab4(%rip),%r14        # ffffffff80005028 <hhdm_offset>
		entry = (PD_paddr  & PTE_PADDR) | PTE_PRESENT;
	}
	pdpt[GET_PDPT_INDEX(virtual_addr)] = entry | flags;

	// PD
	uint64_t* pd = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff80000574:	49 bd 00 f0 ff ff ff 	movabs $0xffffffffff000,%r13
ffffffff8000057b:	ff 0f 00 
	entry = pdpt[GET_PDPT_INDEX(virtual_addr)];
ffffffff8000057e:	48 c1 e8 1b          	shr    $0x1b,%rax
ffffffff80000582:	25 f8 0f 00 00       	and    $0xff8,%eax
ffffffff80000587:	49 01 c6             	add    %rax,%r14
ffffffff8000058a:	49 8b 06             	mov    (%r14),%rax
	uint64_t* pd = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff8000058d:	49 21 c5             	and    %rax,%r13
	if (!(entry & PTE_PRESENT)) {
ffffffff80000590:	a8 01                	test   $0x1,%al
ffffffff80000592:	0f 84 f8 00 00 00    	je     ffffffff80000690 <vmm_map_page+0x170>
	pdpt[GET_PDPT_INDEX(virtual_addr)] = entry | flags;
ffffffff80000598:	4c 09 f8             	or     %r15,%rax
ffffffff8000059b:	49 89 06             	mov    %rax,(%r14)
	entry = pd[GET_PD_INDEX(virtual_addr)];
ffffffff8000059e:	48 89 d8             	mov    %rbx,%rax
	uint64_t* pd = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff800005a1:	4c 03 2d 80 4a 00 00 	add    0x4a80(%rip),%r13        # ffffffff80005028 <hhdm_offset>
	entry = pd[GET_PD_INDEX(virtual_addr)];
ffffffff800005a8:	48 c1 e8 12          	shr    $0x12,%rax
ffffffff800005ac:	25 f8 0f 00 00       	and    $0xff8,%eax
ffffffff800005b1:	49 01 c5             	add    %rax,%r13
		entry = (PT_paddr & PTE_PADDR) | PTE_PRESENT;
	}
	pd[GET_PD_INDEX(virtual_addr)] = entry | flags;
	
	// PT
	uint64_t* pt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff800005b4:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
ffffffff800005bb:	ff 0f 00 
	entry = pd[GET_PD_INDEX(virtual_addr)];
ffffffff800005be:	49 8b 55 00          	mov    0x0(%r13),%rdx
	uint64_t* pt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
ffffffff800005c2:	48 21 d0             	and    %rdx,%rax
	if (!(entry & PTE_PRESENT)) {
ffffffff800005c5:	f6 c2 01             	test   $0x1,%dl
ffffffff800005c8:	0f 84 82 00 00 00    	je     ffffffff80000650 <vmm_map_page+0x130>
	pt[GET_PT_INDEX(virtual_addr)] = (physical_addr & PTE_PADDR) | PTE_PRESENT | flags;
ffffffff800005ce:	48 c1 eb 09          	shr    $0x9,%rbx
	pd[GET_PD_INDEX(virtual_addr)] = entry | flags;
ffffffff800005d2:	4c 09 fa             	or     %r15,%rdx
	pt[GET_PT_INDEX(virtual_addr)] = (physical_addr & PTE_PADDR) | PTE_PRESENT | flags;
ffffffff800005d5:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
	pd[GET_PD_INDEX(virtual_addr)] = entry | flags;
ffffffff800005db:	49 89 55 00          	mov    %rdx,0x0(%r13)
	pt[GET_PT_INDEX(virtual_addr)] = (physical_addr & PTE_PADDR) | PTE_PRESENT | flags;
ffffffff800005df:	48 01 c3             	add    %rax,%rbx
ffffffff800005e2:	48 03 1d 3f 4a 00 00 	add    0x4a3f(%rip),%rbx        # ffffffff80005028 <hhdm_offset>
ffffffff800005e9:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
ffffffff800005f0:	ff 0f 00 
ffffffff800005f3:	49 21 c4             	and    %rax,%r12
ffffffff800005f6:	4d 09 fc             	or     %r15,%r12
ffffffff800005f9:	49 83 cc 01          	or     $0x1,%r12
ffffffff800005fd:	4c 89 23             	mov    %r12,(%rbx)
}
ffffffff80000600:	48 83 c4 08          	add    $0x8,%rsp
ffffffff80000604:	5b                   	pop    %rbx
ffffffff80000605:	41 5c                	pop    %r12
ffffffff80000607:	41 5d                	pop    %r13
ffffffff80000609:	41 5e                	pop    %r14
ffffffff8000060b:	41 5f                	pop    %r15
ffffffff8000060d:	5d                   	pop    %rbp
ffffffff8000060e:	c3                   	ret
ffffffff8000060f:	90                   	nop
		uint64_t PDPT_paddr = pmm_alloc_page();
ffffffff80000610:	e8 2b 04 00 00       	call   ffffffff80000a40 <pmm_alloc_page>
		memset((void*)(PDPT_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff80000615:	48 8b 3d 0c 4a 00 00 	mov    0x4a0c(%rip),%rdi        # ffffffff80005028 <hhdm_offset>
ffffffff8000061c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80000621:	31 f6                	xor    %esi,%esi
		uint64_t PDPT_paddr = pmm_alloc_page();
ffffffff80000623:	49 89 c6             	mov    %rax,%r14
		memset((void*)(PDPT_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff80000626:	48 01 c7             	add    %rax,%rdi
ffffffff80000629:	e8 b2 06 00 00       	call   ffffffff80000ce0 <memset>
		entry = (PDPT_paddr  & PTE_PADDR) | PTE_PRESENT;
ffffffff8000062e:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
ffffffff80000635:	ff 0f 00 
ffffffff80000638:	49 21 c6             	and    %rax,%r14
ffffffff8000063b:	4c 89 f0             	mov    %r14,%rax
ffffffff8000063e:	48 83 c8 01          	or     $0x1,%rax
ffffffff80000642:	e9 1c ff ff ff       	jmp    ffffffff80000563 <vmm_map_page+0x43>
ffffffff80000647:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff8000064e:	00 00 
		uint64_t PT_paddr = pmm_alloc_page();
ffffffff80000650:	e8 eb 03 00 00       	call   ffffffff80000a40 <pmm_alloc_page>
		memset((void*)(PT_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff80000655:	48 8b 3d cc 49 00 00 	mov    0x49cc(%rip),%rdi        # ffffffff80005028 <hhdm_offset>
ffffffff8000065c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80000661:	31 f6                	xor    %esi,%esi
		uint64_t PT_paddr = pmm_alloc_page();
ffffffff80000663:	49 89 c6             	mov    %rax,%r14
		memset((void*)(PT_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff80000666:	48 01 c7             	add    %rax,%rdi
ffffffff80000669:	e8 72 06 00 00       	call   ffffffff80000ce0 <memset>
		entry = (PT_paddr & PTE_PADDR) | PTE_PRESENT;
ffffffff8000066e:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
ffffffff80000675:	ff 0f 00 
ffffffff80000678:	4c 21 f0             	and    %r14,%rax
ffffffff8000067b:	48 89 c2             	mov    %rax,%rdx
ffffffff8000067e:	48 83 ca 01          	or     $0x1,%rdx
ffffffff80000682:	e9 47 ff ff ff       	jmp    ffffffff800005ce <vmm_map_page+0xae>
ffffffff80000687:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff8000068e:	00 00 
		uint64_t PD_paddr = pmm_alloc_page();
ffffffff80000690:	e8 ab 03 00 00       	call   ffffffff80000a40 <pmm_alloc_page>
		memset((void*)(PD_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff80000695:	48 8b 3d 8c 49 00 00 	mov    0x498c(%rip),%rdi        # ffffffff80005028 <hhdm_offset>
ffffffff8000069c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff800006a1:	31 f6                	xor    %esi,%esi
		uint64_t PD_paddr = pmm_alloc_page();
ffffffff800006a3:	49 89 c5             	mov    %rax,%r13
		memset((void*)(PD_paddr + hhdm_offset), 0, PAGE_SIZE);
ffffffff800006a6:	48 01 c7             	add    %rax,%rdi
ffffffff800006a9:	e8 32 06 00 00       	call   ffffffff80000ce0 <memset>
		entry = (PD_paddr  & PTE_PADDR) | PTE_PRESENT;
ffffffff800006ae:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
ffffffff800006b5:	ff 0f 00 
ffffffff800006b8:	49 21 c5             	and    %rax,%r13
ffffffff800006bb:	4c 89 e8             	mov    %r13,%rax
ffffffff800006be:	48 83 c8 01          	or     $0x1,%rax
ffffffff800006c2:	e9 d1 fe ff ff       	jmp    ffffffff80000598 <vmm_map_page+0x78>
ffffffff800006c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff800006ce:	00 00 

ffffffff800006d0 <vmm_init>:

void vmm_init(void) {
	hhdm_offset = hhdm_request.response->offset;
ffffffff800006d0:	48 8b 05 71 2e 00 00 	mov    0x2e71(%rip),%rax        # ffffffff80003548 <hhdm_request+0x28>
ffffffff800006d7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff800006db:	48 89 05 46 49 00 00 	mov    %rax,0x4946(%rip)        # ffffffff80005028 <hhdm_offset>
}
ffffffff800006e2:	c3                   	ret
ffffffff800006e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff800006ea:	00 00 00 
ffffffff800006ed:	0f 1f 00             	nopl   (%rax)

ffffffff800006f0 <pmm_dump_usable_memmap.part.0>:
        bitmap[byte_idx] &= ~(1 << bit_idx);
}

void pmm_dump_usable_memmap(void) {
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800006f0:	48 8b 05 d1 2e 00 00 	mov    0x2ed1(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800006f7:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
ffffffff800006fc:	0f 84 7e 00 00 00    	je     ffffffff80000780 <pmm_dump_usable_memmap.part.0+0x90>
void pmm_dump_usable_memmap(void) {
ffffffff80000702:	55                   	push   %rbp
ffffffff80000703:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000706:	41 54                	push   %r12
ffffffff80000708:	53                   	push   %rbx
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000709:	31 db                	xor    %ebx,%ebx
ffffffff8000070b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff80000710:	48 8b 05 b1 2e 00 00 	mov    0x2eb1(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000717:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000071b:	4c 8b 24 d8          	mov    (%rax,%rbx,8),%r12
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff8000071f:	49 83 7c 24 10 00    	cmpq   $0x0,0x10(%r12)
ffffffff80000725:	75 41                	jne    ffffffff80000768 <pmm_dump_usable_memmap.part.0+0x78>
                        print_str("\n\nbase: ");
ffffffff80000727:	48 c7 c7 6f 10 00 80 	mov    $0xffffffff8000106f,%rdi
ffffffff8000072e:	e8 2d 05 00 00       	call   ffffffff80000c60 <print_str>
                        print_hex(mm->base);
ffffffff80000733:	49 8b 3c 24          	mov    (%r12),%rdi
ffffffff80000737:	e8 44 05 00 00       	call   ffffffff80000c80 <print_hex>
                        print_str("\nlength: ");
ffffffff8000073c:	48 c7 c7 78 10 00 80 	mov    $0xffffffff80001078,%rdi
ffffffff80000743:	e8 18 05 00 00       	call   ffffffff80000c60 <print_str>
                        print_hex(mm->length);
ffffffff80000748:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
ffffffff8000074d:	e8 2e 05 00 00       	call   ffffffff80000c80 <print_hex>
                        print_str("\ntype: ");
ffffffff80000752:	48 c7 c7 82 10 00 80 	mov    $0xffffffff80001082,%rdi
ffffffff80000759:	e8 02 05 00 00       	call   ffffffff80000c60 <print_str>
                        print_hex(mm->type);
ffffffff8000075e:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
ffffffff80000763:	e8 18 05 00 00       	call   ffffffff80000c80 <print_hex>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000768:	48 8b 05 59 2e 00 00 	mov    0x2e59(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff8000076f:	48 83 c3 01          	add    $0x1,%rbx
ffffffff80000773:	48 3b 58 08          	cmp    0x8(%rax),%rbx
ffffffff80000777:	72 97                	jb     ffffffff80000710 <pmm_dump_usable_memmap.part.0+0x20>
                }
        }
}
ffffffff80000779:	5b                   	pop    %rbx
ffffffff8000077a:	41 5c                	pop    %r12
ffffffff8000077c:	5d                   	pop    %rbp
ffffffff8000077d:	c3                   	ret
ffffffff8000077e:	66 90                	xchg   %ax,%ax
ffffffff80000780:	c3                   	ret
ffffffff80000781:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff80000788:	00 00 00 00 
ffffffff8000078c:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff80000790 <pmm_max_usable_addr.part.0>:

uint64_t pmm_max_usable_addr(void) {
	uint64_t max = 0;
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000790:	48 8b 05 31 2e 00 00 	mov    0x2e31(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000797:	48 8b 70 08          	mov    0x8(%rax),%rsi
ffffffff8000079b:	48 85 f6             	test   %rsi,%rsi
ffffffff8000079e:	74 3d                	je     ffffffff800007dd <pmm_max_usable_addr.part.0+0x4d>
	uint64_t max = 0;
ffffffff800007a0:	31 f6                	xor    %esi,%esi
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800007a2:	31 c0                	xor    %eax,%eax
ffffffff800007a4:	0f 1f 40 00          	nopl   0x0(%rax)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff800007a8:	48 8b 15 19 2e 00 00 	mov    0x2e19(%rip),%rdx        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800007af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff800007b3:	48 8b 0c c2          	mov    (%rdx,%rax,8),%rcx
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff800007b7:	48 83 79 10 00       	cmpq   $0x0,0x10(%rcx)
ffffffff800007bc:	75 0e                	jne    ffffffff800007cc <pmm_max_usable_addr.part.0+0x3c>
                        if(max<mm->base+mm->length) max=mm->base+mm->length;
ffffffff800007be:	48 8b 51 08          	mov    0x8(%rcx),%rdx
ffffffff800007c2:	48 03 11             	add    (%rcx),%rdx
ffffffff800007c5:	48 39 d6             	cmp    %rdx,%rsi
ffffffff800007c8:	48 0f 42 f2          	cmovb  %rdx,%rsi
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800007cc:	48 8b 15 f5 2d 00 00 	mov    0x2df5(%rip),%rdx        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800007d3:	48 83 c0 01          	add    $0x1,%rax
ffffffff800007d7:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff800007db:	72 cb                	jb     ffffffff800007a8 <pmm_max_usable_addr.part.0+0x18>
                }
        }
	return max;
}
ffffffff800007dd:	48 89 f0             	mov    %rsi,%rax
ffffffff800007e0:	c3                   	ret
ffffffff800007e1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff800007e8:	00 00 00 00 
ffffffff800007ec:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff800007f0 <pmm_get_bitmap_pbase.part.0>:
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
}

uint64_t pmm_get_bitmap_pbase(void){
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff800007f0:	48 8b 05 d1 2d 00 00 	mov    0x2dd1(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800007f7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff800007fb:	48 85 c0             	test   %rax,%rax
ffffffff800007fe:	74 3f                	je     ffffffff8000083f <pmm_get_bitmap_pbase.part.0+0x4f>
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
                        if (mm->type != LIMINE_MEMMAP_USABLE) continue;
			if ((uint64_t)bitmap_size < mm->length) {
ffffffff80000800:	48 8b 0d 31 48 00 00 	mov    0x4831(%rip),%rcx        # ffffffff80005038 <bitmap_size>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000807:	31 c0                	xor    %eax,%eax
ffffffff80000809:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff80000810:	48 8b 15 b1 2d 00 00 	mov    0x2db1(%rip),%rdx        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000817:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff8000081b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
                        if (mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff8000081f:	48 83 7a 10 00       	cmpq   $0x0,0x10(%rdx)
ffffffff80000824:	75 06                	jne    ffffffff8000082c <pmm_get_bitmap_pbase.part.0+0x3c>
			if ((uint64_t)bitmap_size < mm->length) {
ffffffff80000826:	48 3b 4a 08          	cmp    0x8(%rdx),%rcx
ffffffff8000082a:	72 14                	jb     ffffffff80000840 <pmm_get_bitmap_pbase.part.0+0x50>
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff8000082c:	48 8b 15 95 2d 00 00 	mov    0x2d95(%rip),%rdx        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000833:	48 83 c0 01          	add    $0x1,%rax
ffffffff80000837:	48 3b 42 08          	cmp    0x8(%rdx),%rax
ffffffff8000083b:	72 d3                	jb     ffffffff80000810 <pmm_get_bitmap_pbase.part.0+0x20>
				return mm->base;
			}
                }
        }
	return 0;
ffffffff8000083d:	31 c0                	xor    %eax,%eax
}
ffffffff8000083f:	c3                   	ret
				return mm->base;
ffffffff80000840:	48 8b 02             	mov    (%rdx),%rax
ffffffff80000843:	c3                   	ret
ffffffff80000844:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff8000084b:	00 00 00 00 
ffffffff8000084f:	90                   	nop

ffffffff80000850 <pmm_zero_usable_pages.part.0>:

void pmm_zero_usable_pages(void) {
	if(memmap_request.response != NULL) {
		for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000850:	48 8b 05 71 2d 00 00 	mov    0x2d71(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000857:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
ffffffff8000085c:	0f 84 8e 00 00 00    	je     ffffffff800008f0 <pmm_zero_usable_pages.part.0+0xa0>
ffffffff80000862:	31 ff                	xor    %edi,%edi
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000864:	41 b8 01 00 00 00    	mov    $0x1,%r8d
ffffffff8000086a:	eb 15                	jmp    ffffffff80000881 <pmm_zero_usable_pages.part.0+0x31>
ffffffff8000086c:	0f 1f 40 00          	nopl   0x0(%rax)
		for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
ffffffff80000870:	48 8b 05 51 2d 00 00 	mov    0x2d51(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000877:	48 83 c7 01          	add    $0x1,%rdi
ffffffff8000087b:	48 3b 78 08          	cmp    0x8(%rax),%rdi
ffffffff8000087f:	73 6f                	jae    ffffffff800008f0 <pmm_zero_usable_pages.part.0+0xa0>
			struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
ffffffff80000881:	48 8b 05 40 2d 00 00 	mov    0x2d40(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000888:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8000088c:	48 8b 34 f8          	mov    (%rax,%rdi,8),%rsi
			if (mm->type != LIMINE_MEMMAP_USABLE) continue;
ffffffff80000890:	48 83 7e 10 00       	cmpq   $0x0,0x10(%rsi)
ffffffff80000895:	75 d9                	jne    ffffffff80000870 <pmm_zero_usable_pages.part.0+0x20>
			
			// Setting all usable memory to 0
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff80000897:	48 8b 06             	mov    (%rsi),%rax
ffffffff8000089a:	48 8b 56 08          	mov    0x8(%rsi),%rdx
ffffffff8000089e:	48 01 c2             	add    %rax,%rdx
ffffffff800008a1:	48 39 d0             	cmp    %rdx,%rax
ffffffff800008a4:	73 ca                	jae    ffffffff80000870 <pmm_zero_usable_pages.part.0+0x20>
ffffffff800008a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
ffffffff800008ad:	00 00 00 
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800008b0:	48 89 c1             	mov    %rax,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800008b3:	45 89 c1             	mov    %r8d,%r9d
        uint64_t byte_idx = frame_idx / 8;
ffffffff800008b6:	48 89 c2             	mov    %rax,%rdx
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff800008b9:	48 05 00 10 00 00    	add    $0x1000,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff800008bf:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff800008c3:	48 c1 ea 0f          	shr    $0xf,%rdx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800008c7:	48 03 15 7a 47 00 00 	add    0x477a(%rip),%rdx        # ffffffff80005048 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff800008ce:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff800008d1:	41 d3 e1             	shl    %cl,%r9d
ffffffff800008d4:	44 89 c9             	mov    %r9d,%ecx
ffffffff800008d7:	f7 d1                	not    %ecx
ffffffff800008d9:	20 0a                	and    %cl,(%rdx)
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
ffffffff800008db:	48 8b 56 08          	mov    0x8(%rsi),%rdx
ffffffff800008df:	48 03 16             	add    (%rsi),%rdx
ffffffff800008e2:	48 39 d0             	cmp    %rdx,%rax
ffffffff800008e5:	72 c9                	jb     ffffffff800008b0 <pmm_zero_usable_pages.part.0+0x60>
ffffffff800008e7:	eb 87                	jmp    ffffffff80000870 <pmm_zero_usable_pages.part.0+0x20>
ffffffff800008e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
				pmm_mark_free(p);
			}
		}
		// Setting back bitmap memory to 1
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff800008f0:	48 8b 05 49 47 00 00 	mov    0x4749(%rip),%rax        # ffffffff80005040 <bitmap_pbase>
ffffffff800008f7:	48 8b 15 3a 47 00 00 	mov    0x473a(%rip),%rdx        # ffffffff80005038 <bitmap_size>
ffffffff800008fe:	48 01 c2             	add    %rax,%rdx
ffffffff80000901:	48 39 d0             	cmp    %rdx,%rax
ffffffff80000904:	73 42                	jae    ffffffff80000948 <pmm_zero_usable_pages.part.0+0xf8>
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000906:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff8000090b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000910:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000913:	48 89 c2             	mov    %rax,%rdx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000916:	89 f7                	mov    %esi,%edi
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff80000918:	48 05 00 10 00 00    	add    $0x1000,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff8000091e:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000922:	48 c1 ea 0f          	shr    $0xf,%rdx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000926:	48 03 15 1b 47 00 00 	add    0x471b(%rip),%rdx        # ffffffff80005048 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff8000092d:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000930:	d3 e7                	shl    %cl,%edi
ffffffff80000932:	40 08 3a             	or     %dil,(%rdx)
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
ffffffff80000935:	48 8b 15 fc 46 00 00 	mov    0x46fc(%rip),%rdx        # ffffffff80005038 <bitmap_size>
ffffffff8000093c:	48 03 15 fd 46 00 00 	add    0x46fd(%rip),%rdx        # ffffffff80005040 <bitmap_pbase>
ffffffff80000943:	48 39 d0             	cmp    %rdx,%rax
ffffffff80000946:	72 c8                	jb     ffffffff80000910 <pmm_zero_usable_pages.part.0+0xc0>
			pmm_mark_used(p);
		}
	}
}
ffffffff80000948:	c3                   	ret
ffffffff80000949:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000950 <pmm_mark_used>:
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000950:	48 89 f8             	mov    %rdi,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000953:	48 c1 ef 0c          	shr    $0xc,%rdi
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000957:	ba 01 00 00 00       	mov    $0x1,%edx
        uint8_t bit_idx = frame_idx % 8;
ffffffff8000095c:	89 f9                	mov    %edi,%ecx
        uint64_t byte_idx = frame_idx / 8;
ffffffff8000095e:	48 c1 e8 0f          	shr    $0xf,%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000962:	48 03 05 df 46 00 00 	add    0x46df(%rip),%rax        # ffffffff80005048 <bitmap>
        uint8_t bit_idx = frame_idx % 8;
ffffffff80000969:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff8000096c:	d3 e2                	shl    %cl,%edx
ffffffff8000096e:	08 10                	or     %dl,(%rax)
}
ffffffff80000970:	c3                   	ret
ffffffff80000971:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff80000978:	00 00 00 00 
ffffffff8000097c:	0f 1f 40 00          	nopl   0x0(%rax)

ffffffff80000980 <pmm_mark_free>:
void pmm_mark_free(uint64_t physical_addr) {
ffffffff80000980:	48 89 f9             	mov    %rdi,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000983:	48 89 f8             	mov    %rdi,%rax
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000986:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
        uint64_t byte_idx = frame_idx / 8;
ffffffff8000098b:	48 c1 e8 0f          	shr    $0xf,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff8000098f:	48 c1 e9 0c          	shr    $0xc,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000993:	48 03 05 ae 46 00 00 	add    0x46ae(%rip),%rax        # ffffffff80005048 <bitmap>
ffffffff8000099a:	d2 c2                	rol    %cl,%dl
ffffffff8000099c:	20 10                	and    %dl,(%rax)
}
ffffffff8000099e:	c3                   	ret
ffffffff8000099f:	90                   	nop

ffffffff800009a0 <pmm_dump_usable_memmap>:
	if(memmap_request.response != NULL) {
ffffffff800009a0:	48 8b 05 21 2c 00 00 	mov    0x2c21(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800009a7:	48 85 c0             	test   %rax,%rax
ffffffff800009aa:	74 0c                	je     ffffffff800009b8 <pmm_dump_usable_memmap+0x18>
ffffffff800009ac:	e9 3f fd ff ff       	jmp    ffffffff800006f0 <pmm_dump_usable_memmap.part.0>
ffffffff800009b1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff800009b8:	c3                   	ret
ffffffff800009b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff800009c0 <pmm_max_usable_addr>:
	if(memmap_request.response != NULL) {
ffffffff800009c0:	48 8b 05 01 2c 00 00 	mov    0x2c01(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff800009c7:	48 85 c0             	test   %rax,%rax
ffffffff800009ca:	74 0c                	je     ffffffff800009d8 <pmm_max_usable_addr+0x18>
ffffffff800009cc:	e9 bf fd ff ff       	jmp    ffffffff80000790 <pmm_max_usable_addr.part.0>
ffffffff800009d1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff800009d8:	31 c0                	xor    %eax,%eax
ffffffff800009da:	c3                   	ret
ffffffff800009db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff800009e0 <pmm_get_bitmap_size>:
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
ffffffff800009e0:	48 8b 05 49 46 00 00 	mov    0x4649(%rip),%rax        # ffffffff80005030 <highest_usable_addr>
ffffffff800009e7:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff800009ed:	48 c1 e8 0c          	shr    $0xc,%rax
ffffffff800009f1:	48 83 c0 07          	add    $0x7,%rax
ffffffff800009f5:	48 c1 e8 03          	shr    $0x3,%rax
}
ffffffff800009f9:	c3                   	ret
ffffffff800009fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

ffffffff80000a00 <pmm_get_bitmap_pbase>:
	if(memmap_request.response != NULL) {
ffffffff80000a00:	48 8b 05 c1 2b 00 00 	mov    0x2bc1(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000a07:	48 85 c0             	test   %rax,%rax
ffffffff80000a0a:	74 0c                	je     ffffffff80000a18 <pmm_get_bitmap_pbase+0x18>
ffffffff80000a0c:	e9 df fd ff ff       	jmp    ffffffff800007f0 <pmm_get_bitmap_pbase.part.0>
ffffffff80000a11:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff80000a18:	31 c0                	xor    %eax,%eax
ffffffff80000a1a:	c3                   	ret
ffffffff80000a1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff80000a20 <pmm_zero_usable_pages>:
	if(memmap_request.response != NULL) {
ffffffff80000a20:	48 8b 05 a1 2b 00 00 	mov    0x2ba1(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000a27:	48 85 c0             	test   %rax,%rax
ffffffff80000a2a:	74 0c                	je     ffffffff80000a38 <pmm_zero_usable_pages+0x18>
ffffffff80000a2c:	e9 1f fe ff ff       	jmp    ffffffff80000850 <pmm_zero_usable_pages.part.0>
ffffffff80000a31:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
}
ffffffff80000a38:	c3                   	ret
ffffffff80000a39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000a40 <pmm_alloc_page>:

uint64_t pmm_alloc_page(void) {
	uint64_t* bitmap_64 = (uint64_t*)bitmap;
	size_t bitmap64_size = bitmap_size / 8;
ffffffff80000a40:	4c 8b 05 f1 45 00 00 	mov    0x45f1(%rip),%r8        # ffffffff80005038 <bitmap_size>
	
	// Start scanning from where we last found a free page
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff80000a47:	48 8b 15 02 46 00 00 	mov    0x4602(%rip),%rdx        # ffffffff80005050 <last_scanned_i>
	uint64_t* bitmap_64 = (uint64_t*)bitmap;
ffffffff80000a4e:	48 8b 3d f3 45 00 00 	mov    0x45f3(%rip),%rdi        # ffffffff80005048 <bitmap>
	size_t bitmap64_size = bitmap_size / 8;
ffffffff80000a55:	4c 89 c1             	mov    %r8,%rcx
ffffffff80000a58:	48 c1 e9 03          	shr    $0x3,%rcx
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff80000a5c:	48 39 ca             	cmp    %rcx,%rdx
ffffffff80000a5f:	73 58                	jae    ffffffff80000ab9 <pmm_alloc_page+0x79>
ffffffff80000a61:	48 89 d6             	mov    %rdx,%rsi
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff80000a64:	48 8b 04 f7          	mov    (%rdi,%rsi,8),%rax
ffffffff80000a68:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff80000a6c:	74 42                	je     ffffffff80000ab0 <pmm_alloc_page+0x70>

		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff80000a6e:	48 f7 d0             	not    %rax

		size_t page_idx = i * 64 + index;
ffffffff80000a71:	48 89 f2             	mov    %rsi,%rdx
		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff80000a74:	f3 48 0f bc c0       	tzcnt  %rax,%rax
		size_t page_idx = i * 64 + index;
ffffffff80000a79:	48 c1 e2 06          	shl    $0x6,%rdx
		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff80000a7d:	48 98                	cltq
	for (size_t i = 0; i < last_scanned_i; i++) {
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;

                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;

                size_t page_idx = i * 64 + index;
ffffffff80000a7f:	48 01 d0             	add    %rdx,%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000a82:	ba 01 00 00 00       	mov    $0x1,%edx
                uint64_t paddr = page_idx * PAGE_SIZE;
ffffffff80000a87:	48 c1 e0 0c          	shl    $0xc,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000a8b:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000a8e:	49 89 c0             	mov    %rax,%r8
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000a91:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000a95:	49 c1 e8 0f          	shr    $0xf,%r8
        uint8_t bit_idx = frame_idx % 8;
ffffffff80000a99:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000a9c:	d3 e2                	shl    %cl,%edx
ffffffff80000a9e:	42 08 14 07          	or     %dl,(%rdi,%r8,1)
        
                pmm_mark_used(paddr);
		last_scanned_i = i;
ffffffff80000aa2:	48 89 35 a7 45 00 00 	mov    %rsi,0x45a7(%rip)        # ffffffff80005050 <last_scanned_i>
                return paddr;
ffffffff80000aa9:	c3                   	ret
ffffffff80000aaa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
ffffffff80000ab0:	48 83 c6 01          	add    $0x1,%rsi
ffffffff80000ab4:	48 39 f1             	cmp    %rsi,%rcx
ffffffff80000ab7:	75 ab                	jne    ffffffff80000a64 <pmm_alloc_page+0x24>
	for (size_t i = 0; i < last_scanned_i; i++) {
ffffffff80000ab9:	31 f6                	xor    %esi,%esi
ffffffff80000abb:	48 85 d2             	test   %rdx,%rdx
ffffffff80000abe:	74 29                	je     ffffffff80000ae9 <pmm_alloc_page+0xa9>
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff80000ac0:	48 8b 04 f7          	mov    (%rdi,%rsi,8),%rax
ffffffff80000ac4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff80000ac8:	74 16                	je     ffffffff80000ae0 <pmm_alloc_page+0xa0>
                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff80000aca:	48 f7 d0             	not    %rax
ffffffff80000acd:	31 d2                	xor    %edx,%edx
ffffffff80000acf:	f3 48 0f bc d0       	tzcnt  %rax,%rdx
                size_t page_idx = i * 64 + index;
ffffffff80000ad4:	48 89 f0             	mov    %rsi,%rax
ffffffff80000ad7:	48 c1 e0 06          	shl    $0x6,%rax
                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;
ffffffff80000adb:	48 63 d2             	movslq %edx,%rdx
ffffffff80000ade:	eb 9f                	jmp    ffffffff80000a7f <pmm_alloc_page+0x3f>
	for (size_t i = 0; i < last_scanned_i; i++) {
ffffffff80000ae0:	48 83 c6 01          	add    $0x1,%rsi
ffffffff80000ae4:	48 39 f2             	cmp    %rsi,%rdx
ffffffff80000ae7:	75 d7                	jne    ffffffff80000ac0 <pmm_alloc_page+0x80>
	}

	// We only check the remainder bytes if the main RAM is completely full
	for (size_t i = bitmap_size & ~0x7ULL; i < bitmap_size; i++) {
ffffffff80000ae9:	4c 89 c2             	mov    %r8,%rdx
ffffffff80000aec:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
ffffffff80000af0:	4c 39 c2             	cmp    %r8,%rdx
ffffffff80000af3:	73 47                	jae    ffffffff80000b3c <pmm_alloc_page+0xfc>
		uint64_t byte = (uint64_t)bitmap[i] | ~((1ULL << 8) - 1ULL);
ffffffff80000af5:	0f b6 04 17          	movzbl (%rdi,%rdx,1),%eax
ffffffff80000af9:	48 0d 00 ff ff ff    	or     $0xffffffffffffff00,%rax

		if(byte == 0xFFFFFFFFFFFFFFFF) continue;
ffffffff80000aff:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
ffffffff80000b03:	74 2e                	je     ffffffff80000b33 <pmm_alloc_page+0xf3>
		size_t index = __builtin_ffsll(~(byte)) - 1;
ffffffff80000b05:	48 f7 d0             	not    %rax
ffffffff80000b08:	f3 48 0f bc c0       	tzcnt  %rax,%rax
ffffffff80000b0d:	48 98                	cltq

		size_t page_idx = i * 8 + index;
ffffffff80000b0f:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000b13:	ba 01 00 00 00       	mov    $0x1,%edx
		uint64_t paddr = page_idx * PAGE_SIZE;
ffffffff80000b18:	48 c1 e0 0c          	shl    $0xc,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000b1c:	48 89 c1             	mov    %rax,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000b1f:	48 89 c6             	mov    %rax,%rsi
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000b22:	48 c1 e9 0c          	shr    $0xc,%rcx
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000b26:	48 c1 ee 0f          	shr    $0xf,%rsi
        uint8_t bit_idx = frame_idx % 8;
ffffffff80000b2a:	83 e1 07             	and    $0x7,%ecx
        bitmap[byte_idx] |= (1 << bit_idx);
ffffffff80000b2d:	d3 e2                	shl    %cl,%edx
ffffffff80000b2f:	08 14 37             	or     %dl,(%rdi,%rsi,1)
}
ffffffff80000b32:	c3                   	ret
	for (size_t i = bitmap_size & ~0x7ULL; i < bitmap_size; i++) {
ffffffff80000b33:	48 83 c2 01          	add    $0x1,%rdx
ffffffff80000b37:	49 39 d0             	cmp    %rdx,%r8
ffffffff80000b3a:	75 b9                	jne    ffffffff80000af5 <pmm_alloc_page+0xb5>
		pmm_mark_used(paddr);
		return paddr;
	}
	
	// Run out of memory
	return 0;
ffffffff80000b3c:	31 c0                	xor    %eax,%eax
}
ffffffff80000b3e:	c3                   	ret
ffffffff80000b3f:	90                   	nop

ffffffff80000b40 <pmm_free_page>:
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000b40:	48 89 f8             	mov    %rdi,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000b43:	48 89 f9             	mov    %rdi,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000b46:	ba fe ff ff ff       	mov    $0xfffffffe,%edx

void pmm_free_page(uint64_t paddr) {
	pmm_mark_free(paddr);
	size_t freed_chunk_idx = (paddr / PAGE_SIZE) / 64;
ffffffff80000b4b:	48 c1 ef 12          	shr    $0x12,%rdi
        uint64_t byte_idx = frame_idx / 8;
ffffffff80000b4f:	48 c1 e8 0f          	shr    $0xf,%rax
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
ffffffff80000b53:	48 c1 e9 0c          	shr    $0xc,%rcx
        bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffff80000b57:	48 03 05 ea 44 00 00 	add    0x44ea(%rip),%rax        # ffffffff80005048 <bitmap>
ffffffff80000b5e:	d2 c2                	rol    %cl,%dl
ffffffff80000b60:	20 10                	and    %dl,(%rax)
	
	if (freed_chunk_idx < last_scanned_i) {
ffffffff80000b62:	48 3b 3d e7 44 00 00 	cmp    0x44e7(%rip),%rdi        # ffffffff80005050 <last_scanned_i>
ffffffff80000b69:	73 07                	jae    ffffffff80000b72 <pmm_free_page+0x32>
		last_scanned_i = freed_chunk_idx;
ffffffff80000b6b:	48 89 3d de 44 00 00 	mov    %rdi,0x44de(%rip)        # ffffffff80005050 <last_scanned_i>
	}
}
ffffffff80000b72:	c3                   	ret
ffffffff80000b73:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
ffffffff80000b7a:	00 00 00 00 
ffffffff80000b7e:	66 90                	xchg   %ax,%ax

ffffffff80000b80 <pmm_init>:

void pmm_init(void){
ffffffff80000b80:	55                   	push   %rbp
	if(memmap_request.response != NULL) {
ffffffff80000b81:	48 8b 05 40 2a 00 00 	mov    0x2a40(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
void pmm_init(void){
ffffffff80000b88:	48 89 e5             	mov    %rsp,%rbp
	if(memmap_request.response != NULL) {
ffffffff80000b8b:	48 85 c0             	test   %rax,%rax
ffffffff80000b8e:	0f 84 bc 00 00 00    	je     ffffffff80000c50 <pmm_init+0xd0>
ffffffff80000b94:	e8 f7 fb ff ff       	call   ffffffff80000790 <pmm_max_usable_addr.part.0>
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
ffffffff80000b99:	48 8d b0 ff 0f 00 00 	lea    0xfff(%rax),%rsi
ffffffff80000ba0:	48 c1 ee 0c          	shr    $0xc,%rsi
ffffffff80000ba4:	48 83 c6 07          	add    $0x7,%rsi
ffffffff80000ba8:	48 c1 ee 03          	shr    $0x3,%rsi
	//Initiallize global variables
	highest_usable_addr = pmm_max_usable_addr();
ffffffff80000bac:	48 89 05 7d 44 00 00 	mov    %rax,0x447d(%rip)        # ffffffff80005030 <highest_usable_addr>
	if(memmap_request.response != NULL) {
ffffffff80000bb3:	48 8b 05 0e 2a 00 00 	mov    0x2a0e(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
	return 0;
ffffffff80000bba:	31 ff                	xor    %edi,%edi
	bitmap_size = pmm_get_bitmap_size();
ffffffff80000bbc:	48 89 35 75 44 00 00 	mov    %rsi,0x4475(%rip)        # ffffffff80005038 <bitmap_size>
	if(memmap_request.response != NULL) {
ffffffff80000bc3:	48 85 c0             	test   %rax,%rax
ffffffff80000bc6:	74 08                	je     ffffffff80000bd0 <pmm_init+0x50>
ffffffff80000bc8:	e8 23 fc ff ff       	call   ffffffff800007f0 <pmm_get_bitmap_pbase.part.0>
ffffffff80000bcd:	48 89 c7             	mov    %rax,%rdi
	bitmap_pbase = pmm_get_bitmap_pbase();
	bitmap = (uint8_t*)(bitmap_pbase + hhdm_request.response->offset);	// Offset to virtual base
ffffffff80000bd0:	48 8b 05 b1 29 00 00 	mov    0x29b1(%rip),%rax        # ffffffff80003588 <hhdm_request+0x28>
	bitmap_pbase = pmm_get_bitmap_pbase();
ffffffff80000bd7:	48 89 3d 62 44 00 00 	mov    %rdi,0x4462(%rip)        # ffffffff80005040 <bitmap_pbase>
	
	// Setting all pages in bitmap to be used (for now)
	memset(bitmap, 0xFF, bitmap_size);
ffffffff80000bde:	48 89 f2             	mov    %rsi,%rdx
ffffffff80000be1:	be ff 00 00 00       	mov    $0xff,%esi
	bitmap = (uint8_t*)(bitmap_pbase + hhdm_request.response->offset);	// Offset to virtual base
ffffffff80000be6:	48 03 78 08          	add    0x8(%rax),%rdi
ffffffff80000bea:	48 89 3d 57 44 00 00 	mov    %rdi,0x4457(%rip)        # ffffffff80005048 <bitmap>
	memset(bitmap, 0xFF, bitmap_size);
ffffffff80000bf1:	e8 ea 00 00 00       	call   ffffffff80000ce0 <memset>
	if(memmap_request.response != NULL) {
ffffffff80000bf6:	48 8b 05 cb 29 00 00 	mov    0x29cb(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000bfd:	48 85 c0             	test   %rax,%rax
ffffffff80000c00:	74 05                	je     ffffffff80000c07 <pmm_init+0x87>
ffffffff80000c02:	e8 49 fc ff ff       	call   ffffffff80000850 <pmm_zero_usable_pages.part.0>
	if(memmap_request.response != NULL) {
ffffffff80000c07:	48 8b 05 ba 29 00 00 	mov    0x29ba(%rip),%rax        # ffffffff800035c8 <memmap_request+0x28>
ffffffff80000c0e:	48 85 c0             	test   %rax,%rax
ffffffff80000c11:	74 05                	je     ffffffff80000c18 <pmm_init+0x98>
ffffffff80000c13:	e8 d8 fa ff ff       	call   ffffffff800006f0 <pmm_dump_usable_memmap.part.0>
	// Zero all usable pages (bitmap memory address will be 1 (used))
	pmm_zero_usable_pages();

	
	pmm_dump_usable_memmap();
        print_str("\n\nMax Usable Addr: ");
ffffffff80000c18:	48 c7 c7 8a 10 00 80 	mov    $0xffffffff8000108a,%rdi
ffffffff80000c1f:	e8 3c 00 00 00       	call   ffffffff80000c60 <print_str>
        print_hex(highest_usable_addr);
ffffffff80000c24:	48 8b 3d 05 44 00 00 	mov    0x4405(%rip),%rdi        # ffffffff80005030 <highest_usable_addr>
ffffffff80000c2b:	e8 50 00 00 00       	call   ffffffff80000c80 <print_hex>
        print_str("\n\nbitmap_vbase: ");
ffffffff80000c30:	48 c7 c7 9e 10 00 80 	mov    $0xffffffff8000109e,%rdi
ffffffff80000c37:	e8 24 00 00 00       	call   ffffffff80000c60 <print_str>
        print_hex((uint64_t)bitmap);
ffffffff80000c3c:	48 8b 3d 05 44 00 00 	mov    0x4405(%rip),%rdi        # ffffffff80005048 <bitmap>

}
ffffffff80000c43:	5d                   	pop    %rbp
        print_hex((uint64_t)bitmap);
ffffffff80000c44:	e9 37 00 00 00       	jmp    ffffffff80000c80 <print_hex>
ffffffff80000c49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
ffffffff80000c50:	31 f6                	xor    %esi,%esi
	uint64_t max = 0;
ffffffff80000c52:	31 c0                	xor    %eax,%eax
ffffffff80000c54:	e9 53 ff ff ff       	jmp    ffffffff80000bac <pmm_init+0x2c>
ffffffff80000c59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffffffff80000c60 <print_str>:
#include "kprint.h"
#include "io.h"

// Sending a str to an I/O port
void print_str(const char *str){
        for(int i=0; str[i] != '\0'; i++){
ffffffff80000c60:	0f b6 07             	movzbl (%rdi),%eax
ffffffff80000c63:	84 c0                	test   %al,%al
ffffffff80000c65:	74 15                	je     ffffffff80000c7c <print_str+0x1c>
ffffffff80000c67:	48 83 c7 01          	add    $0x1,%rdi
ffffffff80000c6b:	ba f8 03 00 00       	mov    $0x3f8,%edx
ffffffff80000c70:	ee                   	out    %al,(%dx)
ffffffff80000c71:	0f b6 07             	movzbl (%rdi),%eax
ffffffff80000c74:	48 83 c7 01          	add    $0x1,%rdi
ffffffff80000c78:	84 c0                	test   %al,%al
ffffffff80000c7a:	75 f4                	jne    ffffffff80000c70 <print_str+0x10>
                outb(0x3F8, str[i]);
        }
}
ffffffff80000c7c:	c3                   	ret
ffffffff80000c7d:	0f 1f 00             	nopl   (%rax)

ffffffff80000c80 <print_hex>:

// Convert 64 bit number to hex string and prints it
void print_hex(uint64_t value){
ffffffff80000c80:	55                   	push   %rbp
        const char *hex_chars = "0123456789abcdef";
        char buffer[19];

        buffer[0]='0';
ffffffff80000c81:	b8 30 78 00 00       	mov    $0x7830,%eax
void print_hex(uint64_t value){
ffffffff80000c86:	48 89 e5             	mov    %rsp,%rbp
ffffffff80000c89:	48 83 ec 20          	sub    $0x20,%rsp
        buffer[1]='x';
        buffer[18]='\0';
ffffffff80000c8d:	c6 45 fe 00          	movb   $0x0,-0x2(%rbp)
ffffffff80000c91:	48 8d 4d ed          	lea    -0x13(%rbp),%rcx
        buffer[0]='0';
ffffffff80000c95:	66 89 45 ec          	mov    %ax,-0x14(%rbp)

        for (int i=17;i>=2;i--){
ffffffff80000c99:	48 8d 45 fd          	lea    -0x3(%rbp),%rax
ffffffff80000c9d:	0f 1f 00             	nopl   (%rax)
                buffer[i] = hex_chars[value & 0xF];
ffffffff80000ca0:	48 89 fa             	mov    %rdi,%rdx
        for (int i=17;i>=2;i--){
ffffffff80000ca3:	48 83 e8 01          	sub    $0x1,%rax
                value >>= 4;
ffffffff80000ca7:	48 c1 ef 04          	shr    $0x4,%rdi
                buffer[i] = hex_chars[value & 0xF];
ffffffff80000cab:	83 e2 0f             	and    $0xf,%edx
ffffffff80000cae:	0f b6 92 af 10 00 80 	movzbl -0x7fffef51(%rdx),%edx
ffffffff80000cb5:	88 50 01             	mov    %dl,0x1(%rax)
        for (int i=17;i>=2;i--){
ffffffff80000cb8:	48 39 c1             	cmp    %rax,%rcx
ffffffff80000cbb:	75 e3                	jne    ffffffff80000ca0 <print_hex+0x20>
        for(int i=0; str[i] != '\0'; i++){
ffffffff80000cbd:	b8 30 00 00 00       	mov    $0x30,%eax
ffffffff80000cc2:	ba f8 03 00 00       	mov    $0x3f8,%edx
ffffffff80000cc7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff80000cce:	00 00 
ffffffff80000cd0:	ee                   	out    %al,(%dx)
ffffffff80000cd1:	0f b6 01             	movzbl (%rcx),%eax
ffffffff80000cd4:	48 83 c1 01          	add    $0x1,%rcx
ffffffff80000cd8:	84 c0                	test   %al,%al
ffffffff80000cda:	75 f4                	jne    ffffffff80000cd0 <print_hex+0x50>
        }

        print_str(buffer);
}
ffffffff80000cdc:	c9                   	leave
ffffffff80000cdd:	c3                   	ret
ffffffff80000cde:	66 90                	xchg   %ax,%ax

ffffffff80000ce0 <memset>:
#include "string.h"

void* memset(void* dst, int value, size_t num) {
ffffffff80000ce0:	48 89 f8             	mov    %rdi,%rax
ffffffff80000ce3:	48 89 f9             	mov    %rdi,%rcx
ffffffff80000ce6:	48 8d 3c 3a          	lea    (%rdx,%rdi,1),%rdi
	volatile uint8_t* ptr = (uint8_t*)dst;
        for (size_t i = 0; i < num; i++) ptr[i] = (uint8_t)value;
ffffffff80000cea:	41 89 f0             	mov    %esi,%r8d
ffffffff80000ced:	48 85 d2             	test   %rdx,%rdx
ffffffff80000cf0:	74 2e                	je     ffffffff80000d20 <memset+0x40>
ffffffff80000cf2:	48 89 fa             	mov    %rdi,%rdx
ffffffff80000cf5:	48 29 c2             	sub    %rax,%rdx
ffffffff80000cf8:	83 e2 01             	and    $0x1,%edx
ffffffff80000cfb:	74 13                	je     ffffffff80000d10 <memset+0x30>
ffffffff80000cfd:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffffffff80000d01:	40 88 30             	mov    %sil,(%rax)
ffffffff80000d04:	48 39 f9             	cmp    %rdi,%rcx
ffffffff80000d07:	74 18                	je     ffffffff80000d21 <memset+0x41>
ffffffff80000d09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
ffffffff80000d10:	44 88 01             	mov    %r8b,(%rcx)
ffffffff80000d13:	48 83 c1 02          	add    $0x2,%rcx
ffffffff80000d17:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
ffffffff80000d1b:	48 39 f9             	cmp    %rdi,%rcx
ffffffff80000d1e:	75 f0                	jne    ffffffff80000d10 <memset+0x30>
        return dst;
}
ffffffff80000d20:	c3                   	ret
ffffffff80000d21:	c3                   	ret
