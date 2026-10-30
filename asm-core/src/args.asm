:args.print
mov rdi rsi
call :str.len
mov rax rdx
let edi i1
call :io.write_all
let edi i0
jmp :io.exit

:args.arg
mov [r15+i216] rdx
mov rbx rax
shl rax i3
add rax rdx
mov [rax] rdi
ret

:args.is
mov r14 rdi
call :str.eq
ret

:args.parse
push rbx
push r12
push r13
push r14
let ebx i1
let r12d i0
let r13d i0
:args.parse.loop
mov [r15+i208] rax
cmp rbx rax
je :args.parse.done
call :args.arg
add rbx i1
mov rdi r14
let esi :args.s.help
call :args.is
cmp rax i1
jne :args.parse.not_help
let edi :args.s.helptext
jmp :args.print
:args.parse.not_help
let esi :args.s.version
call :args.is
cmp rax i1
jne :args.parse.not_version
let edi :args.s.versiontext
jmp :args.print
:args.parse.not_version
let esi :args.s.hex
call :args.is
cmp rax i1
jne :args.parse.not_hex
let r12d i1
jmp :args.parse.loop
:args.parse.not_hex
let esi :args.s.o
call :args.is
cmp rax i1
jne :args.parse.not_o
mov [r15+i208] rax
cmp rbx rax
jne :args.parse.o_ok
let esi :args.s.missing
let edx i0
jmp :err.fatal
:args.parse.o_ok
call :args.arg
add rbx i1
mov rdi r14
mov r14 r13
jmp :args.parse.loop
:args.parse.not_o
let eax i0
mov [r14] al
cmp al 0x2D
jne :args.parse.file
let eax i0
mov [r14+i1] al
cmp al i0
je :args.parse.file
let esi :args.s.unknown
mov r14 rdx
jmp :err.fatal
:args.parse.file
mov [r15+i88] rax
cmp rax i4096
jb :args.parse.add
let esi :args.s.many
let edx i0
jmp :err.fatal
:args.parse.add
mov rax rcx
shl rcx i5
mov [r15+i120] rdx
add rdx rcx
mov r14 rcx
mov rcx [rdx]
add rax i1
mov rax [r15+i88]
jmp :args.parse.loop
:args.parse.done
mov r13 rax
mov rax [r15+i80]
let eax i0
cmp r13 i0
je :args.parse.mode
cmp r12 i0
jne :args.parse.mode
let eax i1
:args.parse.mode
mov rax [r15+i72]
pop r14
pop r13
pop r12
pop rbx
ret

:args.s.help
db "--help" 00
:args.s.version
db "--version" 00
:args.s.hex
db "--hex" 00
:args.s.o
db "-o" 00
:args.s.missing
db "missing filename after '-o'" 00
:args.s.unknown
db "unrecognized command-line option" 00
:args.s.many
db "too many input files" 00
:args.s.versiontext
db "asm-core v0.1.1" 0A 00
:args.s.helptext
db "Usage: asm-core [options] [file...]" 0A
db "Assemble RISC source into amd64 machine code." 0A
db 0A
db "Options:" 0A
db "  --help       Display this information." 0A
db "  --version    Display version information." 0A
db "  --hex        Write the output as hexadecimal text." 0A
db "  -o <file>    Place the output into <file>." 0A
db 0A
db "Without -o, the output goes to standard output as hexadecimal text." 0A
db "With -o and without --hex, the output is binary." 0A
db "Without input files, asm-core reads standard input." 0A
db 00
