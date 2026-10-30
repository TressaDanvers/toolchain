:lex.token
mov [r15+i184] rax
cmp rax i0
je :lex.token.go
let eax i0
ret
:lex.token.go
mov [r15+i0] rsi
mov [r15+i8] rdi
:lex.token.blank
cmp rsi rdi
jb :lex.token.more
jmp :lex.token.eof
:lex.token.more
let eax i0
mov [rsi] al
cmp al i32
je :lex.token.skip
cmp al i9
je :lex.token.skip
cmp al i13
je :lex.token.skip
jmp :lex.token.start
:lex.token.skip
add rsi i1
jmp :lex.token.blank
:lex.token.eof
mov rsi [r15+i0]
let eax i1
mov rax [r15+i184]
ret
:lex.token.start
cmp al i10
je :lex.token.eol
mov rsi rdx
cmp al 0x22
je :lex.token.quote
cmp al 0x5B
je :lex.token.bracket
:lex.token.plain
add rsi i1
cmp rsi rdi
jb :lex.token.plainchk
jmp :lex.token.end
:lex.token.plainchk
let eax i0
mov [rsi] al
cmp al i33
jb :lex.token.end
jmp :lex.token.plain
:lex.token.quote
add rsi i1
cmp rsi rdi
jb :lex.token.quotechk
jmp :lex.token.bad
:lex.token.quotechk
let eax i0
mov [rsi] al
cmp al i10
je :lex.token.bad
cmp al 0x22
jne :lex.token.quote
add rsi i1
jmp :lex.token.end
:lex.token.bracket
add rsi i1
cmp rsi rdi
jb :lex.token.bracketchk
jmp :lex.token.bad
:lex.token.bracketchk
let eax i0
mov [rsi] al
cmp al i10
je :lex.token.bad
cmp al 0x5D
jne :lex.token.bracket
add rsi i1
jmp :lex.token.end
:lex.token.end
mov rsi [r15+i0]
mov rsi rcx
sub rcx rdx
let eax i2
ret
:lex.token.bad
mov rsi [r15+i0]
mov rsi rcx
sub rcx rdx
let eax i3
ret
:lex.token.eol
add rsi i1
mov rsi [r15+i0]
let eax i1
mov rax [r15+i184]
let eax i0
ret

:lex.skip_line
mov [r15+i184] rax
cmp rax i0
jne :lex.skip_line.done
mov [r15+i0] rsi
mov [r15+i8] rdi
:lex.skip_line.loop
cmp rsi rdi
jb :lex.skip_line.chk
jmp :lex.skip_line.fin
:lex.skip_line.chk
let eax i0
mov [rsi] al
add rsi i1
cmp al i10
jne :lex.skip_line.loop
:lex.skip_line.fin
mov rsi [r15+i0]
let eax i1
mov rax [r15+i184]
:lex.skip_line.done
ret

:lex.expect_end
mov [r15+i184] rax
cmp rax i0
jne :lex.expect_end.ok
call :lex.token
cmp rax i2
jb :lex.expect_end.ok
let esi :lex.s.extra
call :err.report
call :lex.skip_line
let eax i0
ret
:lex.expect_end.ok
let eax i1
ret

:lex.s.extra
db "unexpected operand" 00
:lex.s.unterminated
db "unterminated literal" 00
