:asm.addr
mov [r15+i112] rax
mov [r15+i128] r9
sub rax r9
add rax 0x400000
ret

:asm.line
push rbx
push r12
mov [r15+i16] rax
mov rax [r15+i112]
let eax i0
mov rax [r15+i184]
call :lex.token
cmp rax i2
jb :asm.line.end
je :asm.line.token
let esi :lex.s.unterminated
call :err.report
call :lex.skip_line
jmp :asm.line.end
:asm.line.token
let eax i0
mov [rdx] al
cmp al 0x3A
je :asm.line.label
mov rdx rsi
mov rcx rdx
call :tok.pack
let edi :mn.table
call :tab.find
cmp rax i0
jne :asm.line.known
let esi :asm.s.unknown
call :err.report
call :lex.skip_line
jmp :asm.line.end
:asm.line.known
let ecx i0
mov [rax+i9] cl
mov rcx r12
let ecx i0
mov [rax+i8] cl
cmp rcx i0
jne :asm.line.d1
call :enc.alu
jmp :asm.line.done
:asm.line.d1
cmp rcx i1
jne :asm.line.d2
call :enc.mov
jmp :asm.line.done
:asm.line.d2
cmp rcx i2
jne :asm.line.d3
call :enc.let
jmp :asm.line.done
:asm.line.d3
cmp rcx i3
jne :asm.line.d4
call :enc.shl
jmp :asm.line.done
:asm.line.d4
cmp rcx i4
jne :asm.line.d5
call :enc.stack
jmp :asm.line.done
:asm.line.d5
cmp rcx i5
jne :asm.line.d6
call :enc.jump
jmp :asm.line.done
:asm.line.d6
cmp rcx i6
jne :asm.line.d7
call :enc.call
jmp :asm.line.done
:asm.line.d7
cmp rcx i7
jne :asm.line.d8
call :enc.ret
jmp :asm.line.done
:asm.line.d8
cmp rcx i8
jne :asm.line.d9
call :enc.db
jmp :asm.line.done
:asm.line.d9
call :enc.syscall
:asm.line.done
cmp rax i0
je :asm.line.skip
call :lex.expect_end
jmp :asm.line.end
:asm.line.skip
call :lex.skip_line
jmp :asm.line.end
:asm.line.label
cmp rcx i2
jb :asm.line.nolabel
mov rdx rsi
mov rcx rdx
add rsi i1
sub rdx i1
call :asm.addr
mov rax rcx
call :sym.define
call :lex.expect_end
jmp :asm.line.end
:asm.line.nolabel
let esi :asm.s.nolabel
call :err.report
call :lex.skip_line
:asm.line.end
call :out.line_end
pop r12
pop rbx
ret

:asm.pass
push rbx
push r12
mov [r15+i128] rax
mov rax [r15+i16]
mov rax [r15+i112]
mov [r15+i136] rax
mov rax [r15+i64]
let eax i0
mov rax [r15+i48]
mov [r15+i120] rbx
let r12d i0
:asm.pass.file
mov [r15+i88] rax
cmp r12 rax
je :asm.pass.done
mov [rbx] rax
mov rax [r15+i32]
mov [rbx+i8] rax
mov rax [r15+i0]
mov [rbx+i16] rax
mov rax [r15+i8]
let eax i0
mov rax [r15+i24]
:asm.pass.line
mov [r15+i0] rax
mov [r15+i8] rcx
cmp rax rcx
jb :asm.pass.go
add r12 i1
add rbx i32
jmp :asm.pass.file
:asm.pass.go
mov [r15+i24] rax
add rax i1
mov rax [r15+i24]
call :asm.line
jmp :asm.pass.line
:asm.pass.done
mov [r15+i56] rax
pop r12
pop rbx
ret

:asm.run
push rbx
let ebx i1
:asm.run.loop
let eax i0
mov rax [r15+i40]
mov rax [r15+i104]
mov rbx rax
mov rax [r15+i96]
call :asm.pass
mov [r15+i40] rax
cmp rax i0
je :asm.run.final
add rbx i1
cmp rbx i1000
jb :asm.run.loop
let esi :asm.s.converge
let edx i0
jmp :err.fatal
:asm.run.final
add rbx i1
mov rbx rax
mov rax [r15+i96]
let eax i1
mov rax [r15+i104]
let eax i0
mov rax [r15+i40]
call :asm.pass
mov [r15+i56] rax
cmp rax i0
je :asm.run.ok
let edi i1
jmp :io.exit
:asm.run.ok
pop rbx
ret

:asm.s.unknown
db "unknown instruction" 00
:asm.s.nolabel
db "empty label name" 00
:asm.s.converge
db "assembly did not converge" 00
