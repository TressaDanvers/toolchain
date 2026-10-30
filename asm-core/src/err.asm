:err.report
mov [r15+i104] rax
cmp rax i0
jne :err.report.on
ret
:err.report.on
mov [r15+i56] rax
add rax i1
mov rax [r15+i56]
push rbx
mov rsi rbx
sub rsp i512
mov rsp rdi
let esi :err.s.bold
call :fmt.str
mov [r15+i32] rsi
call :fmt.str
let eax 0x3A
call :fmt.chr
mov [r15+i24] rax
call :fmt.dec
let eax 0x3A
call :fmt.chr
let esi :err.s.error
call :fmt.str
mov rbx rsi
call :fmt.str
let eax i10
call :fmt.chr
mov rsp rsi
mov rdi rdx
sub rdx rsi
let edi i2
call :io.write_all
add rsp i512
pop rbx
ret

:err.fatal
mov rsi rbx
mov rdx r12
sub rsp i512
mov rsp rdi
let esi :err.s.fatal
call :fmt.str
mov rbx rsi
call :fmt.str
cmp r12 i0
je :err.fatal.end
let eax 0x20
call :fmt.chr
let eax 0x27
call :fmt.chr
mov r12 rsi
call :fmt.str
let eax 0x27
call :fmt.chr
:err.fatal.end
let eax i10
call :fmt.chr
mov rsp rsi
mov rdi rdx
sub rdx rsi
let edi i2
call :io.write_all
let edi i1
jmp :io.exit

:err.s.bold
db 1B "[1m" 00
:err.s.error
db 1B "[22m " 1B "[1;31merror:" 1B "[39m" 1B "[22m " 00
:err.s.fatal
db 1B "[1masm-core:" 1B "[22m " 1B "[1;31mfatal error:" 1B "[39m" 1B "[22m " 00
