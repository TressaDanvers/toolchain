db 7F454C46 02 01 01 00 0000000000000000
db 0200 3E00 01000000 7800400000000000 4000000000000000 0000000000000000
db 00000000 4000 3800 0100 0000 0000 0000
db 01000000 07000000 0000000000000000 0000400000000000 0000400000000000
db 0020000000000000 0020000000000000 0010000000000000

:start
mov [rsp] rdi
mov rsp rsi
add rsi i8
sub rsp i2048
mov rsp rdx
call :args.parse
mov rdx r13
mov rsp r15
cmp rax i0
je :start.stdout
mov rax rdi
let esi 0x241
let edx 0x1B6
call :io.open
cmp rdx i0
je :start.opened
mov rdi rdx
let esi :s.cannotopen
jmp :err.fatal
:start.opened
mov rax r14
jmp :start.run
:start.stdout
let r14d i1
:start.run
call :emit.files
let edi i0
jmp :io.exit

:args.parse
mov rdi r13
sub r13 i1
mov rsi r14
add r14 i8
mov rdx r8
let r9d i0
let r10d i0
:args.parse.loop
cmp r13 i0
je :args.parse.done
mov [r14] r12
add r14 i8
sub r13 i1
mov r12 rdi
let esi :s.help
call :str.eq
cmp rax i1
je :args.help
mov r12 rdi
let esi :s.version
call :str.eq
cmp rax i1
je :args.version
mov r12 rdi
let esi :s.o
call :str.eq
cmp rax i1
je :args.o
mov r12 rdx
let eax i0
mov [rdx] al
cmp al 0x2D
jne :args.file
let eax i0
mov [rdx+i1] al
cmp al i0
je :args.file
let esi :s.unrecognized
jmp :err.fatal
:args.o
cmp r13 i0
jne :args.o.ok
let esi :s.missing
let edx i0
jmp :err.fatal
:args.o.ok
mov [r14] r10
add r14 i8
sub r13 i1
jmp :args.parse.loop
:args.file
cmp r9 i256
jb :args.file.add
let esi :s.many
let edx i0
jmp :err.fatal
:args.file.add
mov r12 [r8]
add r8 i8
add r9 i1
jmp :args.parse.loop
:args.parse.done
mov r10 rax
mov r9 rdx
ret
:args.help
let edi i1
let esi :s.usage
call :print
cmp rax i0
jne :write.fail
let edi i0
jmp :io.exit
:args.version
let edi i1
let esi :s.versiontext
call :print
cmp rax i0
jne :write.fail
let edi i0
jmp :io.exit

:emit.files
cmp r13 i0
jne :emit.files.next
let esi :s.stdin
mov rsi r12
let edi i0
jmp :emit.run
:emit.files.next
cmp r13 i0
je :emit.files.done
mov [r15] r12
add r15 i8
sub r13 i1
mov r12 rdi
let esi i0
let edx i0
call :io.open
cmp rdx i0
je :emit.files.opened
mov r12 rdx
let esi :s.cannotopen
jmp :err.fatal
:emit.files.opened
push rax
mov rax rdi
call :emit.run
pop rdi
call :io.close
jmp :emit.files.next
:emit.files.done
ret

:emit.run
sub rsp i65536
mov rsp rbx
mov rdi r10
let r9d i256
:emit.run.read
mov r10 rdi
mov rbx rsi
let edx i65536
let eax i0
syscall
cmp rax i0
je :emit.run.eof
let r8d i65536
cmp r8 rax
jb :read.fail
mov rax r8
mov rbx rsi
mov rbx rdi
:emit.run.conv
cmp r8 i0
je :emit.run.out
let eax i0
mov [rsi] al
add rsi i1
sub r8 i1
cmp al i32
je :emit.run.conv
cmp al i9
je :emit.run.conv
cmp al i10
je :emit.run.conv
cmp al i13
je :emit.run.conv
call :hex.digit
cmp al i255
je :emit.run.bad
cmp r9 i256
jne :emit.run.second
mov rax r9
jmp :emit.run.conv
:emit.run.second
shl r9 i4
add rax r9
mov al [rdi]
add rdi i1
let r9d i256
jmp :emit.run.conv
:emit.run.out
mov rdi rdx
sub rdx rbx
cmp rdx i0
je :emit.run.read
mov r14 rdi
mov rbx rsi
call :io.write_all
cmp rax i0
jne :write.fail
jmp :emit.run.read
:emit.run.eof
cmp r9 i256
je :emit.run.done
mov r12 rdx
let esi :s.odd
jmp :err.fatal
:emit.run.bad
mov r12 rdx
let esi :s.bad
jmp :err.fatal
:emit.run.done
add rsp i65536
ret

:read.fail
mov r12 rdx
let esi :s.read
jmp :err.fatal
:write.fail
let esi :s.write
let edx i0
jmp :err.fatal

:hex.digit
cmp al 0x30
jb :hex.digit.bad
cmp al 0x3A
jb :hex.digit.decimal
cmp al 0x41
jb :hex.digit.bad
cmp al 0x47
jb :hex.digit.capital
cmp al 0x61
jb :hex.digit.bad
cmp al 0x67
jb :hex.digit.lower
:hex.digit.bad
let al 0xFF
ret
:hex.digit.decimal
sub al 0x30
ret
:hex.digit.capital
sub al 0x37
ret
:hex.digit.lower
sub al 0x57
ret

:str.eq
let eax i0
mov [rdi] al
let ecx i0
mov [rsi] cl
cmp al cl
jne :str.eq.no
cmp al i0
je :str.eq.yes
add rdi i1
add rsi i1
jmp :str.eq
:str.eq.yes
let eax i1
ret
:str.eq.no
let eax i0
ret

:io.exit
let eax i60
syscall

:io.open
let eax i2
syscall
let edx i0
let rcx 0x1000000
cmp rax rcx
jb :io.open.ok
let edx i1
:io.open.ok
ret

:io.close
let eax i3
syscall
ret

:io.write_all
cmp rdx i0
je :io.write_all.ok
let eax i1
syscall
cmp rax i0
je :io.write_all.fail
cmp rdx rax
jb :io.write_all.fail
sub rdx rax
add rsi rax
jmp :io.write_all
:io.write_all.ok
let eax i0
ret
:io.write_all.fail
let eax i1
ret

:print
mov rsi r8
let edx i0
:print.len
let eax i0
mov [r8] al
cmp al i0
je :print.go
add r8 i1
add rdx i1
jmp :print.len
:print.go
jmp :io.write_all

:err.fatal
mov rsi r12
mov rdx r13
let edi i2
let esi :s.fatal
call :print
mov r12 rsi
let edi i2
call :print
cmp r13 i0
je :err.fatal.end
let esi :s.quote
let edi i2
call :print
mov r13 rsi
let edi i2
call :print
let esi :s.endquote
let edi i2
call :print
:err.fatal.end
let esi :s.newline
let edi i2
call :print
let edi i1
jmp :io.exit

:s.fatal
db 1B "[1memit:" 1B "[22m " 1B "[1;31mfatal error:" 1B "[39m" 1B "[22m " 00
:s.quote
db " '" 00
:s.endquote
db "'" 00
:s.newline
db 0A 00
:s.help
db "--help" 00
:s.version
db "--version" 00
:s.o
db "-o" 00
:s.stdin
db "<stdin>" 00
:s.versiontext
db "emit v0.1.0" 0A 00
:s.usage
db "Usage: emit [options] [file...]" 0A
db "Convert hexadecimal text to binary." 0A
db 0A
db "Options:" 0A
db "  --help       Display this information." 0A
db "  --version    Display version information." 0A
db "  -o <file>    Place the output into <file>." 0A
db 0A
db "Hex digits can be upper case or lower case. White space is ignored." 0A
db "Each file must have an even number of hex digits." 0A
db "Without input files, emit reads standard input." 0A
db "Without -o, emit writes to standard output." 0A
db 00
:s.unrecognized
db "unrecognized command-line option" 00
:s.missing
db "missing file name after '-o'" 00
:s.many
db "too many input files" 00
:s.cannotopen
db "cannot open" 00
:s.odd
db "odd number of hex digits in" 00
:s.bad
db "character that is not a hex digit in" 00
:s.read
db "cannot read" 00
:s.write
db "cannot write output" 00
