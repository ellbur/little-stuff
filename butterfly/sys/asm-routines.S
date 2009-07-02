
.file "asm-routines.S"

__SREG__     = 0x3f
__SP_H__     = 0x3e
__SP_L__     = 0x3d
__CCP__      = 0x34
__tmp_reg__  = 0
__zero_reg__ = 1

; ------------------------------------------
; Variables

.section .bss

; ------------------------------------------
; Code

.section .text

.global context_switch
	.type context_switch, @function

context_switch:
	
	cli
	
	; Return address is currently on the stack.
	;
	; Now we push registers onto the stack
	
	push r31
	push r30
	push r29
	push r28
	push r27
	push r26
	push r25
	push r24
	push r23
	push r22
	push r21
	push r20
	push r19
	push r18
	push r17
	push r16
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push r7
	push r6
	push r5
	push r4
	push r3
	push r2
	push r1
	push r0
	
	in r0, __SREG__
	push r0
	
	; Read current stack pointer into argument list
	in r24, __SP_L__
	in r25, __SP_H__
	
	call change_task_data
	
	; Read off return value into stack pointer
	out __SP_L__, r24
	out __SP_H__, r25
	
	; Pop registers
	pop r0
	out __SREG__, r0
	
	pop r0
	pop r1
	pop r2
	pop r3
	pop r4
	pop r5
	pop r6
	pop r7
	pop r8
	pop r9
	pop r10
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15
	pop r16
	pop r17
	pop r18
	pop r19
	pop r20
	pop r21
	pop r22
	pop r23
	pop r24
	pop r25
	pop r26
	pop r27
	pop r28
	pop r29
	pop r30
	pop r31
	
	sei
	ret
	
.size context_switch, .-context_switch

.global start_tasks
	.type start_tasks, @function
start_tasks:

	call first_task_data
	
	; Read off return value into SP
	out __SP_L__, r24
	out __SP_H__, r25
	
	; Pop registers
	pop r0
	out __SREG__, r0
	
	pop r0
	pop r1
	pop r2
	pop r3
	pop r4
	pop r5
	pop r6
	pop r7
	pop r8
	pop r9
	pop r10
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15
	pop r16
	pop r17
	pop r18
	pop r19
	pop r20
	pop r21
	pop r22
	pop r23
	pop r24
	pop r25
	pop r26
	pop r27
	pop r28
	pop r29
	pop r30
	pop r31
	
	sei
	ret
	
.size start_tasks, .-start_tasks

.global __vector_7
	.type __vector_7, @function
__vector_7:
	
	call context_switch
	reti

.size __vector_7, .-__vector_7

