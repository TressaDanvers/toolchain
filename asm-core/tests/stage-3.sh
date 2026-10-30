#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

asm() { ./build/stages/asm-core-stage-3 "$@"; }
failed=0

run_test() {
  out=$(printf '%b\n' "$1" | asm) || { err check "$1: asm-core failed"; failed=1; return 0; }
  want=$(printf '%b' "$2")
  [ "$out" = "$want" ] || { err check "$1: expected '$2' got '$out'"; failed=1; }
}

run_test 'mov rax rbx' '48 89 C3'
run_test 'mov al bl' '88 C3'
run_test 'mov ax bx' '66 89 C3'
run_test 'mov r8 r9' '4D 89 C1'
run_test 'mov [rax] rbx' '48 8B 18'
run_test 'mov rbx [rax]' '48 89 18'
run_test 'mov [rsp] rax' '48 8B 04 24'
run_test 'mov [rbp] rax' '48 8B 45 00'
run_test 'mov [r13] rax' '49 8B 45 00'
run_test 'mov [r12] rax' '49 8B 04 24'
run_test 'mov [rax+i8] rcx' '48 8B 48 08'
run_test 'mov [rax+i200] rcx' '48 8B 88 C8 00 00 00'
run_test 'mov sil [rbx]' '40 88 33'
run_test 'add rax i1' '48 83 C0 01'
run_test 'add rax i200' '48 05 C8 00 00 00'
run_test 'add rbx i200' '48 81 C3 C8 00 00 00'
run_test 'add al i1' '04 01'
run_test 'add bl i1' '80 C3 01'
run_test 'add ax i1' '66 83 C0 01'
run_test 'sub rax i5' '48 83 E8 05'
run_test 'cmp rax rbx' '48 39 D8'
run_test 'xor eax eax' '31 C0'
run_test 'let eax i5' 'B8 05 00 00 00'
run_test 'let rax i5' 'B8 05 00 00 00'
run_test 'let rax 0xFFFFFFFFFFFFFFFF' '48 C7 C0 FF FF FF FF'
run_test 'let rax 0x1122334455667788' '48 B8 88 77 66 55 44 33 22 11'
run_test 'let r8d i1' '41 B8 01 00 00 00'
run_test 'let al i1' 'B0 01'
run_test 'let r8b i1' '41 B0 01'
run_test 'let sil i1' '40 B6 01'
run_test 'let ax i1' '66 B8 01 00'
run_test 'shl rax i1' '48 D1 E0'
run_test 'shl rax i3' '48 C1 E0 03'
run_test 'push rax' '50'
run_test 'push r12' '41 54'
run_test 'pop rbx' '5B'
run_test 'ret' 'C3'
run_test 'syscall' '0F 05'
run_test 'db i1 i300' '01 2C 01'
run_test 'db "ab"' '61 62'
run_test 'db AB cd' 'AB CD'
run_test 'jmp :a\n:a' 'EB 00\n'
run_test ':a\njmp :a' '\nEB FE'
run_test 'call :f\n:f' 'E8 00 00 00 00\n'

mkdir -p ./build/tests ./build/temp || err-fatal check ./build/tests ./build/temp
printf 'mov rax rbx\nret\n' > ./build/temp/stage-3-mov-ret.asm
printf 'push rax\n' > ./build/temp/stage-3-push.asm
printf 'ret\nbogus\n' > ./build/temp/stage-3-unknown-instruction.asm

asm --hex ./build/temp/stage-3-mov-ret.asm ./build/temp/stage-3-push.asm -o ./build/tests/stage-3-two-files.hex || { err check "--hex -o: asm-core failed"; failed=1; }
[ "$(cat ./build/tests/stage-3-two-files.hex)" = "$(printf '48 89 C3\nC3\n50')" ] || { err check "--hex -o: wrong output"; failed=1; }

asm ./build/temp/stage-3-mov-ret.asm -o ./build/tests/stage-3-mov-ret.bin || { err check "-o: asm-core failed"; failed=1; }
printf '\110\211\303\303' | cmp -s ./build/tests/stage-3-mov-ret.bin - || { err check "-o: wrong binary output"; failed=1; }

if asm ./build/temp/stage-3-unknown-instruction.asm > /dev/null 2>&1; then err check "error source: exit status was 0"; failed=1; fi
asm ./build/temp/stage-3-unknown-instruction.asm 2>&1 > /dev/null | grep -qF "stage-3-unknown-instruction.asm:2:" || { err check "error source: no file:line in message"; failed=1; }
if asm --bogus > /dev/null 2>&1; then err check "unknown option: exit status was 0"; failed=1; fi

[ "$failed" -eq 0 ] || err-fatal check stage 3
