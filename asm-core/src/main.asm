db 7F454C46 02 01 01 00 0000000000000000
db 0200 3E00 01000000 7800400000000000 4000000000000000 0000000000000000
db 00000000 4000 3800 0100 0000 0000 0000
db 01000000 07000000 0000000000000000 0000400000000000 0000400000000000
db 0000010000000000 0000500100000000 0010000000000000

:start
sub rsp i512
mov rsp r15
call :ctx.zero
mov [r15+i512] rdi
mov rdi [r15+i208]
mov r15 rsi
add rsi i520
mov rsi [r15+i216]
call :ctx.regions
call :args.parse
call :src.load
call :asm.run
call :out.finish
let edi i0
jmp :io.exit

:ctx.zero
mov r15 rdi
let ecx i64
let eax i0
:ctx.zero.loop
mov rax [rdi]
add rdi i8
sub rcx i1
jne :ctx.zero.loop
ret

:ctx.regions
let eax 0x1400000
mov rax [r15+i120]
let eax 0x800000
mov rax [r15+i128]
mov rax [r15+i16]
let eax 0x900000
mov rax [r15+i176]
mov rax [r15+i136]
mov rax [r15+i64]
let eax 0xD00000
mov rax [r15+i192]
mov rax [r15+i168]
let eax 0x1200000
mov rax [r15+i144]
let eax 0x1300000
mov rax [r15+i152]
let eax 0x1500000
mov rax [r15+i160]
let eax 0x1900000
mov rax [r15+i200]
ret
