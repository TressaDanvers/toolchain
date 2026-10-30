:enc.setop
mov r8 rax
mov rax [r15+i424]
mov rdx rax
cmp r8 i1
je :enc.setop.go
add rax i1
:enc.setop.go
mov rax [r15+i416]
ret

:enc.mov
call :enc.operands2
cmp rax i0
je :enc.mov.out
mov [r15+i224] rax
mov [r15+i320] rcx
cmp rax i1
jne :enc.mov.k0
cmp rcx i1
je :enc.mov.rr
cmp rcx i2
je :enc.mov.store
jmp :enc.mov.bad
:enc.mov.k0
cmp rax i2
jne :enc.mov.bad
cmp rcx i1
je :enc.mov.load
:enc.mov.bad
call :enc.badop
:enc.mov.out
ret
:enc.mov.rr
mov [r15+i240] r8
mov [r15+i336] r9
cmp r8 r9
jne :enc.mov.size
call :enc.clear
mov [r15+i232] rax
mov rax [r15+i432]
mov [r15+i328] rax
mov rax [r15+i448]
let eax i1
mov rax [r15+i440]
mov r8 rax
let edx 0x88
call :enc.setop
call :enc.flags
call :enc.emit_rm
let eax i1
ret
:enc.mov.size
jmp :enc.size
:enc.mov.store
mov [r15+i240] r8
call :enc.clear
mov [r15+i232] rax
mov rax [r15+i432]
let edx 0x88
call :enc.setop
mov r15 rdi
add rdi i320
call :enc.mem
cmp rax i0
je :enc.mov.out
call :enc.flags
call :enc.emit_rm
let eax i1
ret
:enc.mov.load
mov [r15+i336] r8
call :enc.clear
mov [r15+i328] rax
mov rax [r15+i432]
let edx 0x8A
call :enc.setop
mov r15 rdi
add rdi i224
call :enc.mem
cmp rax i0
je :enc.mov.out
call :enc.flags
call :enc.emit_rm
let eax i1
ret

:enc.let
push r13
push r14
call :enc.operands2
cmp rax i0
je :enc.let.out
mov [r15+i224] rax
cmp rax i1
jne :enc.let.badop
mov [r15+i240] r13
mov [r15+i320] rax
cmp rax i3
jne :enc.let.badop
mov r15 rdi
add rdi i360
call :lit.resolve
cmp rax i0
je :enc.let.out
cmp r13 i1
je :enc.let.w1
cmp r13 i2
je :enc.let.w2
cmp r13 i4
je :enc.let.w4
jmp :enc.let.w8
:enc.let.badop
call :enc.badop
jmp :enc.let.out
:enc.let.w1
let edx i1
let esi i0
mov r15 rdi
add rdi i360
call :enc.fit
cmp rax i0
je :enc.let.out
let eax i64
mov [r15+i232] rdx
mov [r15+i256] rcx
call :enc.rex_b
mov [r15+i232] rax
and eax i7
add eax 0xB0
call :out.byte
mov [r15+i368] rax
let ecx i1
call :out.int
let eax i1
jmp :enc.let.out
:enc.let.w2
let edx i2
let esi i0
mov r15 rdi
add rdi i360
call :enc.fit
cmp rax i0
je :enc.let.out
let eax 0x66
call :out.byte
let r14d i2
jmp :enc.let.std
:enc.let.w4
let edx i4
let esi i0
mov r15 rdi
add rdi i360
call :enc.fit
cmp rax i0
je :enc.let.out
let r14d i4
jmp :enc.let.std
:enc.let.w8
mov [r15+i392] rax
cmp rax i1
jne :enc.let.w8.num
mov [r15+i400] rax
cmp rax i4
je :enc.let.w8.std
cmp rax i8
je :enc.let.wide
call :enc.hexsize
jmp :enc.let.out
:enc.let.w8.num
mov [r15+i368] rax
let ecx 0xFFFFFFFF
cmp rcx rax
jb :enc.let.w8.big
:enc.let.w8.std
let r14d i4
jmp :enc.let.std
:enc.let.w8.big
mov [r15+i392] rcx
cmp rcx i2
je :enc.let.w8.range
let rcx 0xFFFFFFFF80000000
cmp rax rcx
jb :enc.let.wide
let eax 0x48
mov [r15+i232] rdx
let ecx i0
call :enc.rex_b
let eax 0xC7
call :out.byte
mov [r15+i232] rax
and eax i7
add eax 0xC0
call :out.byte
mov [r15+i368] rax
let ecx i4
call :out.int
let eax i1
jmp :enc.let.out
:enc.let.w8.range
call :enc.rangeerr
jmp :enc.let.out
:enc.let.wide
let eax 0x48
mov [r15+i232] rdx
let ecx i0
call :enc.rex_b
mov [r15+i232] rax
and eax i7
add eax 0xB8
call :out.byte
mov [r15+i368] rax
let ecx i8
call :out.int
let eax i1
jmp :enc.let.out
:enc.let.std
let eax i64
mov [r15+i232] rdx
let ecx i0
call :enc.rex_b
mov [r15+i232] rax
and eax i7
add eax 0xB8
call :out.byte
mov [r15+i368] rax
mov r14 rcx
call :out.int
let eax i1
:enc.let.out
pop r14
pop r13
ret

:enc.shl
push r13
call :enc.operands2
cmp rax i0
je :enc.shl.out
mov [r15+i224] rax
cmp rax i1
jne :enc.shl.bad
mov [r15+i240] r13
mov [r15+i320] rax
cmp rax i3
jne :enc.shl.bad
mov r15 rdi
add rdi i360
call :lit.resolve
cmp rax i0
je :enc.shl.out
let edx i1
let esi i0
mov r15 rdi
add rdi i360
call :enc.fit
cmp rax i0
je :enc.shl.out
call :enc.clear
mov [r15+i240] rax
mov rax [r15+i424]
mov [r15+i232] rax
mov rax [r15+i448]
let eax i1
mov rax [r15+i440]
let eax i4
mov rax [r15+i432]
mov [r15+i248] rax
mov rax [r15+i456]
mov [r15+i256] rax
mov rax [r15+i464]
mov [r15+i392] rax
cmp rax i0
jne :enc.shl.imm
mov [r15+i368] rax
cmp rax i1
jne :enc.shl.imm
let eax 0xD1
cmp r13 i1
jne :enc.shl.one
let eax 0xD0
:enc.shl.one
mov rax [r15+i416]
call :enc.emit_rm
let eax i1
jmp :enc.shl.out
:enc.shl.imm
let eax 0xC1
cmp r13 i1
jne :enc.shl.imm.go
let eax 0xC0
:enc.shl.imm.go
mov rax [r15+i416]
call :enc.emit_rm
mov [r15+i368] rax
let ecx i1
call :out.int
let eax i1
jmp :enc.shl.out
:enc.shl.bad
call :enc.badop
:enc.shl.out
pop r13
ret

:enc.stack
push r13
call :enc.operand1
cmp rax i0
je :enc.stack.out
mov [r15+i224] rax
cmp rax i1
jne :enc.stack.bad
mov [r15+i240] rax
cmp rax i8
jne :enc.stack.size
let eax i64
mov [r15+i232] rdx
let ecx i0
call :enc.rex_b
mov [r15+i232] rax
and eax i7
add rax r12
call :out.byte
let eax i1
jmp :enc.stack.out
:enc.stack.size
call :enc.size
jmp :enc.stack.out
:enc.stack.bad
call :enc.badop
:enc.stack.out
pop r13
ret

:enc.jump
push rbx
push r13
push r14
call :enc.operand1
cmp rax i0
je :enc.jump.out
mov [r15+i224] rax
cmp rax i3
jne :enc.jump.bad
mov [r15+i264] rax
cmp rax i3
jne :enc.jump.bad
mov r15 rdi
add rdi i264
call :lit.resolve
cmp rax i0
je :enc.jump.out
mov [r15+i272] r13
call :asm.addr
mov rax r14
mov [r15+i304] r8
mov [r15+i48] rax
mov [r15+i152] rbx
add rbx rax
add rax i1
mov rax [r15+i48]
cmp rax 0x100000
jb :enc.jump.idx
let esi :enc.s.jumps
let edx i0
jmp :err.fatal
:enc.jump.idx
let ecx i0
mov [rbx] cl
cmp rcx i0
jne :enc.jump.long
cmp r8 i0
je :enc.jump.short
mov r13 rax
sub rax r14
sub rax i2
add rax i128
cmp rax i256
jb :enc.jump.short
let ecx i1
mov cl [rbx]
mov rcx [r15+i40]
jmp :enc.jump.long
:enc.jump.short
cmp r12 i16
jne :enc.jump.short.cc
let eax 0xEB
jmp :enc.jump.short.op
:enc.jump.short.cc
mov r12 rax
add rax i112
:enc.jump.short.op
call :out.byte
mov r13 rax
sub rax r14
sub rax i2
call :out.byte
let eax i1
jmp :enc.jump.out
:enc.jump.long
cmp r12 i16
jne :enc.jump.long.cc
let eax 0xE9
call :out.byte
mov r13 rax
sub rax r14
sub rax i5
jmp :enc.jump.long.imm
:enc.jump.long.cc
let eax 0x0F
call :out.byte
mov r12 rax
add rax i128
call :out.byte
mov r13 rax
sub rax r14
sub rax i6
:enc.jump.long.imm
let ecx i4
call :out.int
let eax i1
jmp :enc.jump.out
:enc.jump.bad
call :enc.badop
:enc.jump.out
pop r14
pop r13
pop rbx
ret

:enc.call
push r13
push r14
call :enc.operand1
cmp rax i0
je :enc.call.out
mov [r15+i224] rax
cmp rax i3
jne :enc.call.bad
mov [r15+i264] rax
cmp rax i3
jne :enc.call.bad
mov r15 rdi
add rdi i264
call :lit.resolve
cmp rax i0
je :enc.call.out
mov [r15+i272] r13
call :asm.addr
mov rax r14
let eax 0xE8
call :out.byte
mov r13 rax
sub rax r14
sub rax i5
let ecx i4
call :out.int
let eax i1
jmp :enc.call.out
:enc.call.bad
call :enc.badop
:enc.call.out
pop r14
pop r13
ret

:enc.ret
let eax 0xC3
call :out.byte
let eax i1
ret

:enc.syscall
let eax 0x0F
call :out.byte
let eax i5
call :out.byte
let eax i1
ret

:enc.db
push rbx
push r13
:enc.db.next
call :lex.token
cmp rax i2
jb :enc.db.done
je :enc.db.token
let esi :lex.s.unterminated
call :err.report
jmp :enc.db.fail
:enc.db.token
mov rdx r8
mov rcx r9
mov r15 rdi
add rdi i264
call :lit.parse
cmp rax i1
je :enc.db.kind
cmp rax i0
jne :enc.db.fail
let esi :operand.s.bad
call :err.report
jmp :enc.db.fail
:enc.db.kind
mov [r15+i264] rax
cmp rax i1
je :enc.db.number
cmp rax i2
je :enc.db.hex
cmp rax i3
je :enc.db.label
mov [r15+i280] rsi
mov [r15+i288] rdx
call :out.bytes
jmp :enc.db.next
:enc.db.number
mov [r15+i272] rdx
let ecx i1
let esi 0x100
:enc.db.number.size
cmp rdx rsi
jb :enc.db.number.emit
add ecx i1
shl rsi i8
cmp ecx i8
jne :enc.db.number.size
:enc.db.number.emit
mov rdx rax
call :out.int
jmp :enc.db.next
:enc.db.hex
mov [r15+i280] rsi
mov [r15+i288] r8
:enc.db.hex.loop
cmp r8 i0
je :enc.db.next
let eax i0
mov [rsi] al
call :hex.digit
shl al i4
mov al cl
let eax i0
mov [rsi+i1] al
call :hex.digit
add al cl
call :out.byte
add rsi i2
sub r8 i2
jmp :enc.db.hex.loop
:enc.db.label
mov r15 rdi
add rdi i264
call :lit.resolve
cmp rax i0
je :enc.db.fail
mov [r15+i272] rax
let ecx i4
call :out.int
jmp :enc.db.next
:enc.db.done
let eax i1
jmp :enc.db.out
:enc.db.fail
let eax i0
:enc.db.out
pop r13
pop rbx
ret

:enc.hexsize
let esi :enc.s.hexsize
call :err.report
let eax i0
ret

:enc.rangeerr
let esi :enc.s.range
call :err.report
let eax i0
ret

:enc.s.jumps
db "too many jump instructions" 00
:enc.s.few
db "too few operands" 00
:enc.s.badop
db "invalid operands for this instruction" 00
:enc.s.size
db "operand sizes do not match" 00
:enc.s.hexsize
db "hex literal size does not match the operand" 00
:enc.s.range
db "immediate out of range" 00
:enc.s.dispsize
db "hex displacement must be 1 or 4 bytes" 00
:enc.s.high
db "high byte register cannot be used with a REX prefix" 00
