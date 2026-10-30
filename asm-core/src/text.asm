:str.len
mov rdi rcx
:str.len.loop
let eax i0
mov [rcx] al
cmp al i0
je :str.len.done
add rcx i1
jmp :str.len.loop
:str.len.done
sub rcx rdi
mov rcx rax
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

:tok.pack
let eax i0
cmp rdx i9
jb :tok.pack.ok
ret
:tok.pack.ok
push rax
mov rsp rdi
:tok.pack.copy
cmp rdx i0
je :tok.pack.done
let ecx i0
mov [rsi] cl
mov cl [rdi]
add rsi i1
add rdi i1
sub rdx i1
jmp :tok.pack.copy
:tok.pack.done
pop rax
ret

:tab.find
cmp rax i0
je :tab.find.none
:tab.find.loop
mov [rdi] rcx
cmp rcx i0
je :tab.find.none
cmp rcx rax
je :tab.find.yes
add rdi i16
jmp :tab.find.loop
:tab.find.yes
mov rdi rax
ret
:tab.find.none
let eax i0
ret

:hex.digit
cmp al 0x61
jb :hex.digit.upper
cmp al 0x67
jb :hex.digit.lower
jmp :hex.digit.bad
:hex.digit.lower
sub al 0x57
ret
:hex.digit.upper
cmp al 0x41
jb :hex.digit.number
cmp al 0x47
jb :hex.digit.capital
jmp :hex.digit.bad
:hex.digit.capital
sub al 0x37
ret
:hex.digit.number
cmp al 0x30
jb :hex.digit.bad
cmp al 0x3A
jb :hex.digit.decimal
:hex.digit.bad
let al 0xFF
ret
:hex.digit.decimal
sub al 0x30
ret

:hex.char
cmp al i10
jb :hex.char.digit
add al 0x37
ret
:hex.char.digit
add al 0x30
ret

:hex.pair
mov al cl
let edx i0
cmp cl 0x80
jb :hex.pair.1
sub cl 0x80
add dl i8
:hex.pair.1
cmp cl 0x40
jb :hex.pair.2
sub cl 0x40
add dl i4
:hex.pair.2
cmp cl 0x20
jb :hex.pair.3
sub cl 0x20
add dl i2
:hex.pair.3
cmp cl 0x10
jb :hex.pair.4
sub cl 0x10
add dl i1
:hex.pair.4
mov dl al
call :hex.char
call :fmt.chr
mov cl al
call :hex.char
jmp :fmt.chr

:fmt.chr
mov al [rdi]
add rdi i1
ret

:fmt.str
let eax i0
mov [rsi] al
cmp al i0
je :fmt.str.done
mov al [rdi]
add rsi i1
add rdi i1
jmp :fmt.str
:fmt.str.done
ret

:fmt.dec
let esi :fmt.dec.powers
let r8d i0
:fmt.dec.next
mov [rsi] ecx
let edx i0
:fmt.dec.sub
cmp eax ecx
jb :fmt.dec.digit
sub eax ecx
add edx i1
jmp :fmt.dec.sub
:fmt.dec.digit
cmp edx i0
jne :fmt.dec.emit
cmp r8d i0
jne :fmt.dec.emit
cmp ecx i1
jne :fmt.dec.advance
:fmt.dec.emit
let r8d i1
add dl 0x30
mov dl [rdi]
add rdi i1
:fmt.dec.advance
cmp ecx i1
je :fmt.dec.done
add rsi i4
jmp :fmt.dec.next
:fmt.dec.done
ret

:fmt.dec.powers
db 00CA9A3B 00E1F505 80969800 40420F00 A0860100 10270000 E8030000 64000000 0A000000 01000000
