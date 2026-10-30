:sym.slot
let eax i5381
:sym.slot.hash
cmp rdx i0
je :sym.slot.hashed
mov rax rcx
shl rax i5
add rax rcx
let r8d i0
mov [rsi] r8b
add rax r8
add rsi i1
sub rdx i1
jmp :sym.slot.hash
:sym.slot.hashed
add rax i1
mov rax rcx
and eax 0xFFFF
shl rax i4
mov [r15+i144] rdx
add rax rdx
:sym.slot.probe
mov [rax] rdx
cmp rdx rcx
je :sym.slot.done
cmp rdx i0
je :sym.slot.done
add rax i16
mov [r15+i144] rdx
let edi 0x100000
add rdx rdi
cmp rax rdx
jb :sym.slot.probe
mov [r15+i144] rax
jmp :sym.slot.probe
:sym.slot.done
ret

:sym.define
push rcx
call :sym.slot
pop rdx
mov [rax] rsi
cmp rsi i0
je :sym.define.new
mov [rax+i12] edi
mov [r15+i96] r8
cmp rdi r8
jne :sym.define.set
let esi :sym.s.duplicate
jmp :err.report
:sym.define.new
mov rcx [rax]
:sym.define.set
mov [rax+i8] edi
cmp rdi rdx
je :sym.define.same
let ecx i1
mov rcx [r15+i40]
:sym.define.same
mov edx [rax+i8]
mov [r15+i96] r8
mov r8d [rax+i12]
ret

:sym.lookup
call :sym.slot
mov [rax] rsi
cmp rsi i0
je :sym.lookup.none
mov [rax+i8] edx
let eax i1
ret
:sym.lookup.none
let eax i0
let edx i0
ret

:sym.s.duplicate
db "duplicate label" 00
