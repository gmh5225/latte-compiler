	.arch armv5t

	@ 全局变量
	.global	n
	.bss
	.align	2
	.type	n, %object
	.size	n, 4
n:
	.space	4
	.global	a
	.bss
	.align	2
	.type	a, %object
	.size	a, 4
a:
	.space	4
	.global	b
	.data
	.align	2
	.type	b, %object
	.size	b, 4
b:
	.word	1
	
	@ 常量
    .section .rodata
    .align 2
_str0:
    .ascii "%d"
    .align 2
_str1:
    .ascii "%d\n"
    
    .text
	.global	fib
	.type	fib, %function
fib:
	str fp, [sp, #-4]!
	mov fp, sp
	sub sp, sp, #12
	ldr r2, _bridge+4
	ldr r0, [r2]		@ r0 = a
	ldr r2, _bridge
	ldr r1, [r2]		@ r1 = b
	mov r2, r1			@ t = b
	add r1, r0, r1		@ b = a + b
	mov r0, r2			@ a = t
	ldr r2, _bridge+4
	str r0, [r2]
	ldr r2, _bridge
	str r1, [r2]
	
	add sp, fp, #0
	ldr fp, [sp], #4 	@ post-index mode, pop fp, sp = sp + 4
	bx lr
	
	.global main
main:
	push {fp, lr}
	add fp, sp, #8
	mov r2, #1			@ int i=1
	str r2, [fp, #-8]
	ldr r1,	_bridge+8	@ int n
	ldr r0, _bridge+12  @ *r0 = "%d"
	bl __isoc99_scanf(PLT)   @ scanf("%d", &n)
	ldr r1,	_bridge+8
	ldr r3, [r1]		@ r3 = n
	ldr r4, _bridge+4 	@ r4 = &a
	ldr r1, [r4]		@ r1 = a
	ldr r0, _bridge+16
	bl printf(PLT)		@ printf("%d\n", a);
	ldr r4, _bridge		@ r4 = &b
	ldr r1, [r4]		@ r1 = b
	ldr r0, _bridge+16
	bl printf(PLT)		@ printf("%d\n", b);
.L1:
	ldr r1, _bridge+8
	ldr r2, [r1]		@ r2 = n
	ldr r3, [fp, #-8]	@ r3 = i
	cmp r3, r2			@ i<n?
	blt .L2
	b .L3
.L2:
	bl fib
	ldr r4, _bridge		@ r4 = &b
	ldr r1, [r4]		@ r1 = b
	ldr r0, _bridge+16
	bl printf(PLT)		@ printf("%d\n", b);
	ldr r2, [fp, #-8]
	add r2, r2, #1		@ i = i + 1
	str r2, [fp, #-8]
	b .L1
.L3:
	mov r0, #0
	pop {fp, pc}
	
	
_bridge:
	.word b
	.word a
	.word n
	.word _str0
	.word _str1

	.section .note.GNU-stack,"",%progbits