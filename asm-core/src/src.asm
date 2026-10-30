:src.load
push rbx
push r12
push r13
mov [r15+i160] rbx
mov [r15+i120] r12
mov [r15+i88] r13
cmp r13 i0
jne :src.load.next
let edx :src.s.stdin
mov rdx [r12]
let r13d i1
mov r13 rax
mov rax [r15+i88]
:src.load.next
cmp r13 i0
je :src.load.done
mov [r12] rdi
mov rbx [r12+i8]
cmp rdi :src.s.stdin
je :src.load.stdin
let esi i0
let edx i0
call :io.open
cmp rdx i0
je :src.load.opened
mov [r12] rdx
let esi :src.s.open
jmp :err.fatal
:src.load.opened
mov rax rdi
jmp :src.load.read
:src.load.stdin
let edi i0
:src.load.read
mov rbx rsi
mov [r15+i200] rdx
sub rdx rsi
call :io.read_all
cmp rdx i0
je :src.load.got
cmp rdx i1
let esi :src.s.read
je :src.load.fail
let esi :src.s.large
:src.load.fail
mov [r12] rdx
jmp :err.fatal
:src.load.got
mov rbx rsi
add rsi rax
cmp rax i0
je :src.load.set
mov rsi rcx
sub rcx i1
let eax i0
mov [rcx] al
cmp al i10
je :src.load.set
mov [r15+i200] rax
cmp rsi rax
jb :src.load.nl
mov [r12] rdx
let esi :src.s.large
jmp :err.fatal
:src.load.nl
let eax i10
mov al [rsi]
add rsi i1
:src.load.set
mov rsi [r12+i16]
mov rsi rbx
add r12 i32
sub r13 i1
jmp :src.load.next
:src.load.done
pop r13
pop r12
pop rbx
ret

:src.s.stdin
db "<stdin>" 00
:src.s.open
db "cannot open" 00
:src.s.read
db "cannot read" 00
:src.s.large
db "input is too large" 00
