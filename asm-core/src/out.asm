:out.byte
mov [r15+i16] rdx
mov [r15+i176] rcx
cmp rdx rcx
jb :out.byte.room
let esi :out.s.full
let edx i0
jmp :err.fatal
:out.byte.room
mov al [rdx]
add rdx i1
mov rdx [r15+i16]
ret

:out.bytes
mov rdx r8
:out.bytes.loop
cmp r8 i0
je :out.bytes.done
let eax i0
mov [rsi] al
call :out.byte
add rsi i1
sub r8 i1
jmp :out.bytes.loop
:out.bytes.done
ret

:out.int
push rax
mov rsp rsi
mov rcx rdx
call :out.bytes
pop rax
ret

:out.line_end
mov [r15+i16] rax
mov [r15+i112] rcx
sub rax rcx
mov [r15+i64] rdx
mov [r15+i192] rcx
cmp rdx rcx
jb :out.line_end.room
let esi :out.s.lines
let edx i0
jmp :err.fatal
:out.line_end.room
mov eax [rdx]
add rdx i4
mov rdx [r15+i64]
ret

:out.format_hex
push rbx
push r12
mov [r15+i128] rsi
mov [r15+i136] rbx
mov [r15+i64] r12
mov [r15+i168] rdi
mov rdi r10
:out.format_hex.line
cmp rbx r12
je :out.format_hex.done
mov [rbx] r9d
add rbx i4
let r11d i0
:out.format_hex.byte
cmp r9d i0
je :out.format_hex.eol
cmp r11d i0
je :out.format_hex.nospace
let eax 0x20
call :fmt.chr
:out.format_hex.nospace
let r11d i1
let eax i0
mov [rsi] al
call :hex.pair
add rsi i1
sub r9d i1
jmp :out.format_hex.byte
:out.format_hex.eol
let eax i10
call :fmt.chr
jmp :out.format_hex.line
:out.format_hex.done
mov r10 rsi
mov rdi rdx
sub rdx rsi
pop r12
pop rbx
ret

:out.finish
push r12
push r13
mov [r15+i72] rax
cmp rax i0
je :out.finish.hex
mov [r15+i128] r12
mov [r15+i16] r13
sub r13 r12
jmp :out.finish.sink
:out.finish.hex
call :out.format_hex
mov rsi r12
mov rdx r13
:out.finish.sink
mov [r15+i80] rdi
cmp rdi i0
je :out.finish.stdout
mov [r15+i72] rax
let edx 0x1B6
cmp rax i0
je :out.finish.open
let edx 0x1FF
:out.finish.open
let esi 0x241
call :io.open
cmp rdx i0
je :out.finish.opened
mov [r15+i80] rdx
let esi :out.s.open
jmp :err.fatal
:out.finish.opened
mov rax rdi
jmp :out.finish.go
:out.finish.stdout
let edi i1
:out.finish.go
mov r12 rsi
mov r13 rdx
call :io.write_all
cmp rax i0
je :out.finish.done
let esi :out.s.write
let edx i0
jmp :err.fatal
:out.finish.done
pop r13
pop r12
ret

:out.s.full
db "output is too large" 00
:out.s.lines
db "too many lines" 00
:out.s.open
db "cannot open" 00
:out.s.write
db "cannot write output" 00
