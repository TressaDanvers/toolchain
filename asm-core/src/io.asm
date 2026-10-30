:io.exit
let eax i60
syscall

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

:io.read_all
mov rsi r10
mov rdx r8
let r9d i0
:io.read_all.loop
mov r8 rdx
sub rdx r9
cmp rdx i0
je :io.read_all.full
mov r10 rsi
add rsi r9
let eax i0
syscall
cmp rdx rax
jb :io.read_all.fail
cmp rax i0
je :io.read_all.eof
add r9 rax
jmp :io.read_all.loop
:io.read_all.eof
mov r9 rax
let edx i0
ret
:io.read_all.full
mov r9 rax
let edx i2
ret
:io.read_all.fail
mov r9 rax
let edx i1
ret
