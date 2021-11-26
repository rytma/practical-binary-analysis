	.file	"multiple_functions.c"
	.intel_syntax noprefix
	.text
	.globl	square
	.type	square, @function
square:
.LFB2:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	movsd	QWORD PTR [rbp-8], xmm0
	movsd	xmm0, QWORD PTR [rbp-8]
	mulsd	xmm0, QWORD PTR [rbp-8]
	movsd	QWORD PTR [rbp-16], xmm0
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rbp-16], rax
	movsd	xmm0, QWORD PTR [rbp-16]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	square, .-square
	.globl	distance
	.type	distance, @function
distance:
.LFB3:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	movsd	QWORD PTR [rbp-40], xmm0
	mov	rcx, QWORD PTR [rbp-40]
	movsd	QWORD PTR [rbp-40], xmm1
	mov	rsi, QWORD PTR [rbp-40]
	mov	eax, 0
	mov	edx, 0
	mov	rax, rcx
	mov	rdx, rsi
	mov	QWORD PTR [rbp-16], rax
	mov	QWORD PTR [rbp-8], rdx
	movsd	QWORD PTR [rbp-40], xmm2
	mov	rsi, QWORD PTR [rbp-40]
	movsd	QWORD PTR [rbp-40], xmm3
	mov	rcx, QWORD PTR [rbp-40]
	mov	eax, 0
	mov	edx, 0
	mov	rax, rsi
	mov	rdx, rcx
	mov	QWORD PTR [rbp-32], rax
	mov	QWORD PTR [rbp-24], rdx
	movsd	xmm0, QWORD PTR [rbp-16]
	movsd	xmm1, QWORD PTR [rbp-32]
	subsd	xmm0, xmm1
	call	square
	movsd	QWORD PTR [rbp-40], xmm0
	movsd	xmm0, QWORD PTR [rbp-8]
	movsd	xmm1, QWORD PTR [rbp-24]
	subsd	xmm0, xmm1
	call	square
	addsd	xmm0, QWORD PTR [rbp-40]
	call	sqrt
	movsd	QWORD PTR [rbp-40], xmm0
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rbp-40], rax
	movsd	xmm0, QWORD PTR [rbp-40]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	distance, .-distance
	.globl	fib
	.type	fib, @function
fib:
.LFB4:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 24
	.cfi_offset 3, -24
	mov	DWORD PTR [rbp-20], edi
	cmp	DWORD PTR [rbp-20], 1
	jg	.L6
	mov	eax, 1
	jmp	.L7
.L6:
	mov	eax, DWORD PTR [rbp-20]
	sub	eax, 1
	mov	edi, eax
	call	fib
	mov	ebx, eax
	mov	eax, DWORD PTR [rbp-20]
	sub	eax, 2
	mov	edi, eax
	call	fib
	add	eax, ebx
.L7:
	add	rsp, 24
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	fib, .-fib
	.section	.rodata
.LC4:
	.string	"distance: %2.f\n"
.LC5:
	.string	"fib(5): %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 104
	.cfi_offset 3, -24
	mov	DWORD PTR [rbp-84], edi
	mov	QWORD PTR [rbp-96], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR [rbp-24], rax
	xor	eax, eax
	movabs	rax, 4621819117588971520
	mov	QWORD PTR [rbp-80], rax
	movabs	rax, 4624633867356078080
	mov	QWORD PTR [rbp-72], rax
	movabs	rax, 4629137466983448576
	mov	QWORD PTR [rbp-64], rax
	movabs	rax, 4631530004285489152
	mov	QWORD PTR [rbp-56], rax
	mov	rsi, QWORD PTR [rbp-64]
	mov	rcx, QWORD PTR [rbp-56]
	mov	rax, QWORD PTR [rbp-80]
	mov	rdx, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-104], rsi
	movsd	xmm2, QWORD PTR [rbp-104]
	mov	QWORD PTR [rbp-104], rcx
	movsd	xmm3, QWORD PTR [rbp-104]
	mov	QWORD PTR [rbp-104], rax
	movsd	xmm0, QWORD PTR [rbp-104]
	mov	QWORD PTR [rbp-104], rdx
	movsd	xmm1, QWORD PTR [rbp-104]
	call	distance
	movsd	QWORD PTR [rbp-104], xmm0
	mov	rax, QWORD PTR [rbp-104]
	mov	QWORD PTR [rbp-104], rax
	movsd	xmm0, QWORD PTR [rbp-104]
	mov	edi, OFFSET FLAT:.LC4
	mov	eax, 1
	call	printf
	mov	edi, 5
	call	fib
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC5
	mov	eax, 0
	call	printf
	movabs	rax, 4050765991979987505
	mov	QWORD PTR [rbp-48], rax
	mov	WORD PTR [rbp-40], 57
	lea	rax, [rbp-48]
	mov	esi, 9
	mov	rdi, rax
	call	splitprint
	mov	rbx, QWORD PTR [rbp-24]
	xor	rbx, QWORD PTR fs:40
	je	.L9
	call	__stack_chk_fail
.L9:
	add	rsp, 104
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.section	.rodata
.LC6:
	.string	"%c "
	.text
	.globl	splitprint
	.type	splitprint, @function
splitprint:
.LFB6:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-24], rdi
	mov	DWORD PTR [rbp-28], esi
	mov	DWORD PTR [rbp-4], 0
	jmp	.L11
.L12:
	mov	eax, DWORD PTR [rbp-4]
	movsx	rdx, eax
	mov	rax, QWORD PTR [rbp-24]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC6
	mov	eax, 0
	call	printf
	add	DWORD PTR [rbp-4], 1
.L11:
	mov	eax, DWORD PTR [rbp-4]
	cmp	eax, DWORD PTR [rbp-28]
	jl	.L12
	mov	edi, 10
	call	putchar
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	splitprint, .-splitprint
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.4) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
