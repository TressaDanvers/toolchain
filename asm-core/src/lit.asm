:lit.parse
mov r8 rsi
mov r9 rdx
let eax i0
mov [rsi] al
cmp al 0x22
je :lit.parse.string
cmp al 0x3A
je :lit.parse.label
cmp al 0x69
je :lit.parse.int
cmp al 0x30
jne :lit.parse.hex
cmp rdx i3
jb :lit.parse.hex
let ecx i0
mov [rsi+i1] cl
cmp cl 0x78
je :lit.parse.xint
jmp :lit.parse.hex

:lit.parse.string
let eax i4
mov rax [rdi]
add rsi i1
mov rsi [rdi+i16]
sub rdx i2
mov rdx [rdi+i24]
let eax i1
ret

:lit.parse.label
cmp rdx i2
jb :lit.parse.none
let eax i3
mov rax [rdi]
add rsi i1
mov rsi [rdi+i16]
sub rdx i1
mov rdx [rdi+i24]
let eax i1
ret

:lit.parse.int
cmp rdx i2
jb :lit.parse.none
add rsi i1
sub rdx i1
let eax i0
let r8 0x2000000000000000
:lit.parse.int.loop
let ecx i0
mov [rsi] cl
sub cl 0x30
cmp cl i10
jb :lit.parse.int.digit
jmp :lit.parse.none
:lit.parse.int.digit
cmp rax r8
jb :lit.parse.int.fits
jmp :lit.parse.range
:lit.parse.int.fits
mov rax r9
shl rax i1
shl r9 i3
add rax r9
jb :lit.parse.range
add rax rcx
jb :lit.parse.range
add rsi i1
sub rdx i1
jne :lit.parse.int.loop
jmp :lit.parse.number

:lit.parse.xint
add rsi i2
sub rdx i2
cmp rdx i17
jb :lit.parse.xint.go
jmp :lit.parse.range
:lit.parse.xint.go
let r9d i0
:lit.parse.xint.loop
let eax i0
mov [rsi] al
call :hex.digit
cmp al 0xFF
je :lit.parse.none
shl r9 i4
add r9 rax
add rsi i1
sub rdx i1
jne :lit.parse.xint.loop
mov r9 rax
:lit.parse.number
mov rax [rdi+i8]
let eax i1
mov rax [rdi]
ret

:lit.parse.hex
mov r9 rcx
and ecx i1
cmp ecx i0
jne :lit.parse.none
cmp r9 i0
je :lit.parse.none
mov r8 rsi
mov r9 rdx
:lit.parse.hex.loop
let eax i0
mov [rsi] al
call :hex.digit
cmp al 0xFF
je :lit.parse.none
add rsi i1
sub rdx i1
jne :lit.parse.hex.loop
let eax i2
mov rax [rdi]
mov r8 [rdi+i16]
mov r9 [rdi+i24]
let eax i1
ret

:lit.parse.none
let eax i0
ret

:lit.parse.range
let esi :lit.s.range
call :err.report
let eax i2
ret

:lit.bytes_value
let eax i0
add rsi rdx
:lit.bytes_value.loop
cmp rdx i0
je :lit.bytes_value.done
sub rsi i1
shl rax i8
let ecx i0
mov [rsi] cl
add rax rcx
sub rdx i1
jmp :lit.bytes_value.loop
:lit.bytes_value.done
ret

:lit.hex_value
let r8d i0
let r9d i0
add rsi rdx
:lit.hex_value.loop
cmp rdx i0
je :lit.hex_value.done
sub rsi i2
sub rdx i2
shl r8 i8
let ecx i0
let eax i0
mov [rsi] al
call :hex.digit
shl al i4
mov al cl
let eax i0
mov [rsi+i1] al
call :hex.digit
add cl al
or r8 rcx
add r9 i1
jmp :lit.hex_value.loop
:lit.hex_value.done
mov r8 rax
ret

:lit.resolve
mov [rdi] rax
cmp rax i1
je :lit.resolve.number
cmp rax i2
je :lit.resolve.hex
cmp rax i3
je :lit.resolve.label
mov [rdi+i16] rsi
mov [rdi+i24] rdx
cmp rdx i9
jb :lit.resolve.string
let esi :lit.s.strlong
call :err.report
let eax i0
ret
:lit.resolve.string
call :lit.bytes_value
mov rax [rdi+i8]
let eax i1
mov rax [rdi]
:lit.resolve.number
let eax i0
mov rax [rdi+i32]
let eax i1
ret
:lit.resolve.hex
mov [rdi+i16] rsi
mov [rdi+i24] rdx
cmp rdx i17
jb :lit.resolve.hexok
let esi :lit.s.hexlong
call :err.report
let eax i0
ret
:lit.resolve.hexok
call :lit.hex_value
mov rax [rdi+i8]
mov r9 [rdi+i40]
let eax i1
mov rax [rdi+i32]
let eax i1
ret
:lit.resolve.label
push rdi
mov [rdi+i16] rsi
mov [rdi+i24] rdx
call :sym.lookup
pop rdi
mov rax [rdi+i40]
let ecx i2
mov rcx [rdi+i32]
cmp rax i0
jne :lit.resolve.found
mov [r15+i104] rax
cmp rax i0
je :lit.resolve.unknown
let esi :lit.s.undefined
call :err.report
let eax i0
ret
:lit.resolve.unknown
let edx i0
:lit.resolve.found
mov rdx [rdi+i8]
let eax i1
ret

:lit.s.range
db "number out of range" 00
:lit.s.strlong
db "string literal is longer than 8 bytes" 00
:lit.s.hexlong
db "hex literal is longer than 8 bytes" 00
:lit.s.undefined
db "undefined label" 00
