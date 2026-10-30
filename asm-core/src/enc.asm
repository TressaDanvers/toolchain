:enc.clear
let eax i0
mov rax [r15+i416]
mov rax [r15+i424]
mov rax [r15+i432]
mov rax [r15+i440]
mov rax [r15+i448]
mov rax [r15+i456]
mov rax [r15+i464]
mov rax [r15+i472]
mov rax [r15+i480]
ret

:enc.flags
mov [r15+i248] rax
mov [r15+i344] rcx
or rax rcx
mov rax [r15+i456]
mov [r15+i256] rax
mov [r15+i352] rcx
or rax rcx
mov rax [r15+i464]
ret

:enc.operands2
mov r15 rdi
add rdi i224
call :operand.parse
cmp rax i1
jne :enc.operands2.bad
mov r15 rdi
add rdi i320
call :operand.parse
cmp rax i1
jne :enc.operands2.bad
let eax i1
ret
:enc.operands2.bad
cmp rax i0
jne :enc.operands2.fail
let esi :enc.s.few
call :err.report
:enc.operands2.fail
let eax i0
ret

:enc.operand1
mov r15 rdi
add rdi i224
call :operand.parse
cmp rax i1
jne :enc.operand1.bad
ret
:enc.operand1.bad
cmp rax i0
jne :enc.operand1.fail
let esi :enc.s.few
call :err.report
:enc.operand1.fail
let eax i0
ret

:enc.badop
let esi :enc.s.badop
call :err.report
let eax i0
ret

:enc.size
let esi :enc.s.size
call :err.report
let eax i0
ret

:enc.fit
mov [rdi+i32] rax
cmp rax i1
jne :enc.fit.value
mov [rdi+i40] rax
cmp rax rdx
je :enc.fit.ok
let esi :enc.s.hexsize
call :err.report
let eax i0
ret
:enc.fit.value
mov [rdi+i8] rax
let ecx 0xFF
cmp rdx i1
je :enc.fit.cmp
let ecx 0xFFFF
cmp rdx i2
je :enc.fit.cmp
let ecx 0xFFFFFFFF
cmp rsi i0
je :enc.fit.cmp
let ecx 0x7FFFFFFF
:enc.fit.cmp
cmp rcx rax
jb :enc.fit.range
:enc.fit.ok
let eax i1
ret
:enc.fit.range
let esi :enc.s.range
call :err.report
let eax i0
ret

:enc.disp
mov [rdi+i40] rax
cmp rax i0
jne :enc.disp.lit
let eax i0
mov rax [r15+i472]
mov rax [r15+i480]
let eax i1
ret
:enc.disp.lit
add rdi i40
call :lit.resolve
cmp rax i0
je :enc.disp.ret
mov [rdi+i32] rax
mov [rdi+i8] rcx
cmp rax i1
je :enc.disp.exact
cmp rax i2
je :enc.disp.d32
cmp rcx i0
je :enc.disp.none
cmp rcx i128
jb :enc.disp.d8
let eax 0x7FFFFFFF
cmp rax rcx
jb :enc.disp.range
:enc.disp.d32
let eax i4
jmp :enc.disp.set
:enc.disp.d8
let eax i1
jmp :enc.disp.set
:enc.disp.none
let eax i0
:enc.disp.set
mov rax [r15+i472]
mov rcx [r15+i480]
let eax i1
ret
:enc.disp.exact
mov [rdi+i40] rax
cmp rax i1
je :enc.disp.set
cmp rax i4
je :enc.disp.set
let esi :enc.s.dispsize
call :err.report
let eax i0
ret
:enc.disp.range
let esi :enc.s.range
call :err.report
let eax i0
:enc.disp.ret
ret

:enc.mem
push rdi
call :enc.disp
pop rdi
cmp rax i0
je :enc.mem.out
mov [rdi+i8] rcx
mov rcx [r15+i448]
let ecx i2
mov rcx [r15+i440]
let eax i1
:enc.mem.out
ret

:enc.rex_b
cmp rdx i8
jb :enc.rex_b.low
add rax i1
:enc.rex_b.low
cmp rax i64
jne :enc.rex_b.emit
cmp rcx i0
je :enc.rex_b.none
:enc.rex_b.emit
jmp :out.byte
:enc.rex_b.none
ret

:enc.emit_rm
mov [r15+i424] rax
cmp rax i2
jne :enc.emit_rm.rex
let eax 0x66
call :out.byte
:enc.emit_rm.rex
let r8d i0
mov [r15+i424] rax
cmp rax i8
jne :enc.emit_rm.r
or r8d i8
:enc.emit_rm.r
mov [r15+i432] rax
cmp rax i8
jb :enc.emit_rm.b
or r8d i4
:enc.emit_rm.b
mov [r15+i448] rax
cmp rax i8
jb :enc.emit_rm.rexdone
or r8d i1
:enc.emit_rm.rexdone
cmp r8d i0
jne :enc.emit_rm.needrex
mov [r15+i464] rax
cmp rax i0
je :enc.emit_rm.norex
:enc.emit_rm.needrex
mov [r15+i456] rax
cmp rax i0
je :enc.emit_rm.userex
let esi :enc.s.high
call :err.report
:enc.emit_rm.userex
or r8d i64
mov r8 rax
call :out.byte
:enc.emit_rm.norex
mov [r15+i416] rax
call :out.byte
mov [r15+i432] rax
and eax i7
shl eax i3
mov rax r8
mov [r15+i448] rax
and eax i7
mov rax r9
mov [r15+i440] rax
cmp rax i2
je :enc.emit_rm.mem
let eax 0xC0
add eax r8d
add eax r9d
jmp :out.byte
:enc.emit_rm.mem
mov [r15+i472] rax
cmp rax i0
jne :enc.emit_rm.mod
cmp r9d i5
jne :enc.emit_rm.mod
let eax i1
mov rax [r15+i472]
let eax i0
mov rax [r15+i480]
:enc.emit_rm.mod
mov [r15+i472] rax
let edx i0
cmp rax i0
je :enc.emit_rm.modgo
let edx 0x40
cmp rax i1
je :enc.emit_rm.modgo
let edx 0x80
:enc.emit_rm.modgo
let eax i0
add eax edx
add eax r8d
add eax r9d
call :out.byte
cmp r9d i4
jne :enc.emit_rm.disp
let eax 0x24
call :out.byte
:enc.emit_rm.disp
mov [r15+i472] rcx
mov [r15+i480] rax
jmp :out.int

:enc.alu
push r13
push r14
push rbx
call :enc.operands2
cmp rax i0
je :enc.alu.out
mov [r15+i224] rax
cmp rax i1
jne :enc.alu.badop
mov [r15+i240] r13
mov [r15+i320] rax
cmp rax i1
je :enc.alu.regreg
cmp rax i3
je :enc.alu.imm
:enc.alu.badop
call :enc.badop
jmp :enc.alu.out
:enc.alu.regreg
mov [r15+i336] rax
cmp rax r13
jne :enc.alu.size
call :enc.clear
mov r12 rax
shl rax i3
cmp r13 i1
je :enc.alu.rr.op
add rax i1
:enc.alu.rr.op
mov rax [r15+i416]
mov [r15+i328] rax
mov rax [r15+i432]
mov [r15+i232] rax
mov rax [r15+i448]
let eax i1
mov rax [r15+i440]
mov r13 rax
mov rax [r15+i424]
call :enc.flags
call :enc.emit_rm
let eax i1
jmp :enc.alu.out
:enc.alu.size
call :enc.size
jmp :enc.alu.out
:enc.alu.imm
mov r15 rdi
add rdi i360
call :lit.resolve
cmp rax i0
je :enc.alu.out
mov [r15+i392] rax
cmp rax i0
jne :enc.alu.full
cmp r13 i1
je :enc.alu.full
mov [r15+i368] rax
cmp rax i128
jb :enc.alu.short
:enc.alu.full
mov r13 r14
cmp r14 i8
jne :enc.alu.fit
let r14d i4
:enc.alu.fit
mov r14 rdx
let esi i0
cmp r13 i8
jne :enc.alu.fit2
let esi i1
:enc.alu.fit2
mov r15 rdi
add rdi i360
call :enc.fit
cmp rax i0
je :enc.alu.out
mov [r15+i232] rax
cmp rax i0
jne :enc.alu.modrm
mov [r15+i248] rax
cmp rax i0
jne :enc.alu.modrm
cmp r13 i2
jne :enc.alu.acc.rex
let eax 0x66
call :out.byte
:enc.alu.acc.rex
cmp r13 i8
jne :enc.alu.acc.op
let eax 0x48
call :out.byte
:enc.alu.acc.op
mov r12 rax
shl eax i3
add eax i5
cmp r13 i1
jne :enc.alu.acc.emit
sub eax i1
:enc.alu.acc.emit
call :out.byte
jmp :enc.alu.imm.emit
:enc.alu.short
let r14d i1
let ebx 0x83
jmp :enc.alu.modrm.go
:enc.alu.modrm
let ebx 0x81
cmp r13 i1
jne :enc.alu.modrm.go
let ebx 0x80
:enc.alu.modrm.go
call :enc.clear
mov rbx rax
mov rax [r15+i416]
mov r12 rax
mov rax [r15+i432]
mov [r15+i232] rax
mov rax [r15+i448]
let eax i1
mov rax [r15+i440]
mov r13 rax
mov rax [r15+i424]
call :enc.flags
call :enc.emit_rm
:enc.alu.imm.emit
mov [r15+i368] rax
mov r14 rcx
call :out.int
let eax i1
:enc.alu.out
pop rbx
pop r14
pop r13
ret
