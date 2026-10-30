db 7F454C46 02 01 01 00 0000000000000000
db 0200 3E00 01000000 7800400000000000 4000000000000000 0000000000000000
db 00000000 4000 3800 0100 0000 0000 0000
db 01000000 07000000 0000000000000000 0000400000000000 0000400000000000
db 0010000000000000 0020000000000000 0010000000000000

:start
let r15d i1
let rax 0x1122334455667788
let rcx 0x1122334455667788
cmp rax rcx
jne :fail
mov rax rdx
cmp rdx rcx
jne :fail
let rdx 0xFFFFFFFFFFFFFFFF
let rax 0x1111111111111111
mov edx eax
let rcx 0xFFFFFFFF
cmp rax rcx
jne :fail
let rax 0x1111111111111111
let rdx 0x2222222222223333
mov dx ax
let rcx 0x1111111111113333
cmp rax rcx
jne :fail
let rax 0x1111111111111111
mov dl al
let rcx 0x1111111111111133
cmp rax rcx
jne :fail
let r8 0x0123456789ABCDEF
mov r8 r9
cmp r9 r8
jne :fail
let sil 0x5A
mov sil r10b
cmp r10b sil
jne :fail
let rax i0
let r12w 0xBEEF
mov r12w ax
let ecx 0xBEEF
cmp ax cx
jne :fail

let r15d i2
let rbx 0x401000
let rax 0x1122334455667788
mov rax [rbx]
let ecx i0
mov [rbx] rcx
cmp rcx rax
jne :fail
let ecx i0
mov [rbx] cl
cmp cl 0x88
jne :fail
let ecx i0
mov [rbx+i1] cl
cmp cl 0x77
jne :fail
let ecx i0
mov [rbx+i2] cx
cmp cx 0x5566
jne :fail
let ecx i0
mov [rbx+i4] ecx
let edx 0x11223344
cmp ecx edx
jne :fail
let ecx 0xBEEF
mov cx [rbx+i16]
let edx i0
mov [rbx+i16] dx
cmp dx 0xBEEF
jne :fail
let edx i1
mov [rbx+i18] dx
cmp dx i0
jne :fail
let ecx 0x1122337E
mov cl [rbx+i32]
let edx 0xFFFFFFFF
mov [rbx+i32] edx
cmp edx 0x7E
jne :fail
let ecx 0x99AABBCC
mov ecx [rbx+i48]
let rdx 0xFFFFFFFFFFFFFFFF
mov [rbx+i48] rdx
cmp rdx rcx
jne :fail
let r9 0x401000
let r8 0x0A0B0C0D0E0F1011
mov r8 [r9+i64]
let r10 i0
mov [r9+i64] r10
cmp r10 r8
jne :fail

let r15d i3
mov rsp r14
let rax 0x1111111111111111
let rcx 0x2222222222222222
push rax
push rcx
pop rdx
pop rsi
cmp rdx rcx
jne :fail
cmp rsi rax
jne :fail
let r8 0x0123456789ABCDEF
push r8
pop r11
cmp r11 r8
jne :fail
cmp rsp r14
jne :fail

let r15d i4
let rax i5
let rcx i7
add rax rcx
let rdx i12
cmp rax rdx
jne :fail
sub rax rcx
let rdx i5
cmp rax rdx
jne :fail
let rax 0xF0F0
let rcx 0x0FF0
and rax rcx
let rdx i240
cmp rax rdx
jne :fail
or rax rcx
cmp rax rcx
jne :fail
xor rax rcx
let rdx i0
cmp rax rdx
jne :fail
let eax 0xFFFFFFFF
let ecx i1
add eax ecx
jne :fail
let rdx i0
cmp rax rdx
jne :fail
let eax i3
let ecx i5
sub eax ecx
cmp eax 0xFFFFFFFE
jne :fail
let eax i1
let ecx i1
cmp eax ecx
jne :fail
let rax i0
let ax 0xFFFF
let cx i2
add ax cx
cmp ax i1
jne :fail
let rax i0
let al 0xFF
let cl i2
add al cl
cmp al i1
jne :fail
let eax i10
add eax i5
cmp eax i15
jne :fail
sub eax i3
cmp eax i12
jne :fail
and eax 0x0A
cmp eax i8
jne :fail
or eax i3
cmp eax i11
jne :fail
xor eax 0xFF
cmp eax i244
jne :fail
let ax 0x1000
add ax 0x0234
cmp ax 0x1234
jne :fail
let al 0x10
add al 0x20
xor al 0x3F
cmp al 0x0F
jne :fail
let r9d i100
sub r9d i1
cmp r9d i99
jne :fail
let r10b i1
add r10b i1
cmp r10b i2
jne :fail
let dil i1
or dil i4
cmp dil i5
jne :fail

let r15d i5
let rax i1
let rcx i2
cmp rax rcx
je :fail
jne :t5a
jmp :fail
:t5a
jb :t5b
jmp :fail
:t5b
cmp rcx rax
jb :fail
cmp rax rax
je :t5c
jmp :fail
:t5c
jne :fail
let rdx 0xFFFFFFFFFFFFFFFF
cmp rax rdx
jb :t5d
jmp :fail
:t5d

let r15d i6
let eax i0
call :incr
call :incr
call :incr
cmp eax i3
jne :fail
let eax i0
call :incr2
cmp eax i2
jne :fail
cmp rsp r14
jne :fail

let r15d i7
let rax i1
shl rax i4
let rcx i16
cmp rax rcx
jne :fail
let rax i1
shl rax i32
let rcx 0x100000000
cmp rax rcx
jne :fail
let eax 0x80000000
shl eax i1
jne :fail
let rcx i0
cmp rax rcx
jne :fail
let eax i1
shl ax i4
cmp ax i16
jne :fail
let eax i129
shl al i1
cmp al i2
jne :fail
let r9 i3
shl r9 i2
let r10 i12
cmp r9 r10
jne :fail

let r15d i8
let eax i39
syscall
cmp eax i0
je :fail

let r15d i9
let ebx :data
let ecx i0
mov [rbx] cl
cmp cl "A"
jne :fail
let ecx i0
mov [rbx+i1] cl
cmp cl "B"
jne :fail
let ecx i0
mov [rbx+i2] cx
cmp cx 0x4344
jne :fail
let ecx i0
mov [rbx+i4] cl
cmp cl i69
jne :fail
let ecx i0
mov [rbx+i5] cx
cmp cx 4647
jne :fail
let ecx i0
mov [rbx+i7] cx
cmp cx i258
jne :fail
let ecx i0
mov [rbx+i9] ecx
cmp ecx 0x01020304
jne :fail
let ecx i0
mov [rbx+i13] cx
cmp cx A1B2
jne :fail
let eax :lb
let ecx :la
sub eax ecx
cmp eax i5
jne :fail

let r15d i11
let rbx 0x401000
let rax 0x1122334455667788
let rdx 0x99AABBCCDDEEFF00
push rax
push rdx
let rcx i0
mov [rsp+i8] rcx
cmp rcx rax
jne :fail
mov [rsp] rcx
cmp rcx rdx
jne :fail
let rcx 0xDEADBEEF
mov rcx [rsp+i8]
mov [rsp+i8] rsi
cmp rsi rcx
jne :fail
pop rcx
pop rcx
cmp rsp r14
jne :fail
let r12 0x401000
let rax 0x0102030405060708
mov rax [r12+i96]
let rcx i0
mov [r12+i96] rcx
cmp rcx rax
jne :fail
let ecx 0x5C
mov cl [r12+i120]
let edx i0
mov [r12+i120] dl
cmp dl 0x5C
jne :fail
let eax 0x11223344
let ebx i0
mov ah bl
cmp bl 0x33
jne :fail
let ecx i0
let ch 0x7E
cmp ecx 0x7E00
jne :fail
let edx i0
let dh i5
let bl i3
add dh bl
cmp edx 0x0800
jne :fail
let eax 0x1100
shl ah i4
cmp eax 0x1000
jne :fail
let edx 0x0100
cmp dh i1
jne :fail
let ecx 0x7E00
let ebx i0
mov ch bh
cmp ebx 0x7E00
jne :fail
let rsi 0x401000
let eax 0x5A00
mov ah [rsi+i200]
let edx i0
mov [rsi+i200] dh
cmp edx 0x5A00
jne :fail

let r15d i10
let rax i1
let rcx i2
let rdx i4
let rbx i8
let rbp i16
let rsi i32
let rdi i64
let r8 i128
let r9 i256
let r10 i512
let r11 i1024
let r12 i2048
let r13 i4096
add rax rcx
add rax rdx
add rax rbx
add rax rbp
add rax rsi
add rax rdi
add rax r8
add rax r9
add rax r10
add rax r11
add rax r12
add rax r13
let rcx i8191
cmp rax rcx
jne :fail
cmp rsp r14
jne :fail
jmp :pass

:pass
let edi i0
let eax i60
syscall

:fail
mov r15 rdi
let eax i60
syscall

:incr
add eax i1
ret

:incr2
call :incr
call :incr
ret

:data
db "AB" 0x4344 i69 4647 i258 0x01020304 A1B2
:la
db 0102030405
:lb
