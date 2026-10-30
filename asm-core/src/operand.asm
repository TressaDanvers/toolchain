:operand.parse
push rbx
mov rdi rbx
let eax i0
mov rax [rbx]
mov rax [rbx+i8]
mov rax [rbx+i16]
mov rax [rbx+i24]
mov rax [rbx+i32]
mov rax [rbx+i40]
call :lex.token
cmp rax i2
jb :operand.parse.none
je :operand.parse.token
let esi :lex.s.unterminated
call :err.report
let eax i2
pop rbx
ret
:operand.parse.none
let eax i0
pop rbx
ret
:operand.parse.token
mov rdx r8
mov rcx r9
let eax i0
mov [r8] al
cmp al 0x5B
je :operand.parse.mem
mov r8 rsi
mov r9 rdx
call :tok.pack
let edi :reg.table
call :tab.find
cmp rax i0
je :operand.parse.lit
let ecx i0
mov [rax+i8] cl
mov rcx [rbx+i8]
let ecx i0
mov [rax+i9] cl
mov rcx [rbx+i16]
let ecx i0
mov [rax+i10] cl
mov rcx [rbx+i24]
let ecx i0
mov [rax+i11] cl
mov rcx [rbx+i32]
let ecx i1
mov rcx [rbx]
let eax i1
pop rbx
ret
:operand.parse.lit
mov rbx rdi
add rdi i40
call :lit.parse
cmp rax i1
jne :operand.parse.litfail
let eax i3
mov rax [rbx]
let eax i1
pop rbx
ret
:operand.parse.litfail
cmp rax i0
jne :operand.parse.ret
let esi :operand.s.bad
call :err.report
let eax i2
:operand.parse.ret
pop rbx
ret

:operand.parse.mem
add r8 i1
sub r9 i2
push r12
push r13
mov r8 r12
mov r9 r13
mov r12 rsi
let edx i0
:operand.parse.mem.scan
cmp rdx r13
je :operand.parse.mem.name
let eax i0
mov [rsi] al
cmp al 0x2B
je :operand.parse.mem.name
add rsi i1
add rdx i1
jmp :operand.parse.mem.scan
:operand.parse.mem.name
push rdx
mov r12 rsi
call :tok.pack
let edi :reg.table
call :tab.find
pop rdx
cmp rax i0
je :operand.parse.mem.badbase
let ecx i0
mov [rax+i9] cl
cmp cl i8
jne :operand.parse.mem.badbase
let ecx i0
mov [rax+i8] cl
mov rcx [rbx+i8]
let ecx i8
mov rcx [rbx+i16]
let ecx i2
mov rcx [rbx]
cmp rdx r13
je :operand.parse.mem.ok
mov r13 r9
sub r9 rdx
sub r9 i1
cmp r9 i0
je :operand.parse.mem.baddisp
mov r12 r8
add r8 rdx
add r8 i1
mov rbx rdi
add rdi i40
call :lit.parse
cmp rax i1
je :operand.parse.mem.ok
cmp rax i0
jne :operand.parse.mem.out
:operand.parse.mem.baddisp
let esi :operand.s.disp
call :err.report
let eax i2
jmp :operand.parse.mem.out
:operand.parse.mem.ok
let eax i1
:operand.parse.mem.out
pop r13
pop r12
pop rbx
ret
:operand.parse.mem.badbase
let esi :operand.s.base
call :err.report
let eax i2
jmp :operand.parse.mem.out

:operand.s.bad
db "invalid operand" 00
:operand.s.base
db "memory base must be a 64-bit register" 00
:operand.s.disp
db "invalid displacement" 00
